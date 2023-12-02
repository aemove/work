`timescale 1ns/1ps

module matrix_3x3 (
    clk,
    rst_n,
    valid_in,
    din,
    dout_r0,
    dout_r1,
    dout_r2,
    corner_type,
    lastin_flag,
    out_en
);
parameter           WIDTH = 8;
parameter           COL_NUM     =   8    ;
parameter           ROW_NUM     =   5    ;
parameter           LINE_NUM = 3;

input               clk;
input               rst_n;
input               valid_in;
input [WIDTH-1:0]   din;

output[WIDTH-1:0]   dout_r0;
output[WIDTH-1:0]   dout_r1;
output[WIDTH-1:0]   dout_r2;
output[3:0]         corner_type; 
output reg          lastin_flag; // for the last input 0000000 of line0//
output              out_en; //dout enable//

reg   [WIDTH-1:0] line[2:0];//line_buffer
reg   valid_in_r  [2:0];
wire  [WIDTH-1:0] din_r; // 
wire  valid_out_r [2:0];
wire  [WIDTH-1:0] dout_r[2:0];
reg   corner_flag_lastline; // the last line for output//
wire  out_en_r [2:0];

assign dout_r0 = dout_r[0];
assign dout_r1 = dout_r[1];
assign dout_r2 = dout_r[2];
assign din_r   = (lastin_flag)?  0: din;
assign out_en  = out_en_r[1]; //control the real data_out//

genvar i;
generate
    begin:HDL1
    
    for (i = 0;i < LINE_NUM;i = i +1)
        begin : buffer_inst
            // line 0
            if(i == 0) begin: MAPO
                always @(*)begin
                    line[i]         <=  din_r;
                    if (lastin_flag)
                    valid_in_r[i]   <=  1'b1 ;
                    else
                    valid_in_r[i]   <=  valid_in ;
                end
            end
            // line 1 2 ...
        
            else  begin: MAP1
                always @(*) begin

                    line[i] <= dout_r[i-1];

                    valid_in_r[i] <= valid_out_r[i-1];
                end
            end
        line_buffer #(WIDTH,COL_NUM)
            line_buffer_inst(
                .rst_n (rst_n),
                .clk (clk),
                .din (line[i]),
                .dout (dout_r[i]),
                .valid_in(valid_in_r[i]),
                .valid_out (valid_out_r[i]),
                .lastout (corner_flag_lastline),
                .out_en (out_en_r[i])
                );
        end
    end
endgenerate
reg                 [10:0]  col_cnt         ;
reg                 [10:0]  row_cnt         ;


always @(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
        col_cnt             <=          11'd0;
    else if(row_cnt == ROW_NUM-1 && col_cnt == COL_NUM-1 )
        col_cnt             <=          11'd0;    
    else if(col_cnt == COL_NUM && valid_in == 1'b1)
        col_cnt             <=          11'd1;
    else if(valid_in == 1'b1)
        col_cnt             <=          col_cnt + 1'b1;
    else
        col_cnt             <=          col_cnt;


always @(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
        row_cnt             <=          11'd0;
    else if(row_cnt == ROW_NUM-1 && col_cnt == COL_NUM-1) //&& valid_in_r[0] == 1'b1 && lastin_flag)
        row_cnt             <=          11'd0;
    else if(col_cnt == COL_NUM && valid_in == 1'b1) 
        row_cnt             <=          row_cnt + 1'b1;


reg [3:0]   corner_type;
reg [10:0]  lastcnt_in;
reg [10:0]  lastcnt_out;
reg [10:0]  lastcnt_r;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        lastin_flag <= 1'b0;
    else if((lastcnt_in == COL_NUM-1) & lastin_flag)
            lastin_flag <= 1'b0;
    else if(row_cnt == ROW_NUM-1 && col_cnt == COL_NUM-1)
            lastin_flag <= 1'b1;
    else
        lastin_flag <= lastin_flag;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        corner_flag_lastline <= 1'b0;
    else if(corner_flag_lastline == 1'b1 && (lastcnt_out == COL_NUM-1))
            corner_flag_lastline <= 1'b0;
    else if((lastcnt_in == COL_NUM-1) & lastin_flag)
            corner_flag_lastline <= 1'b1;
    else
        corner_flag_lastline <= corner_flag_lastline;
end

// counter for the last line & the last 00000 input//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        lastcnt_in             <=          11'd0;
    else if((lastcnt_in == COL_NUM-1) & lastin_flag)
        lastcnt_in             <=          11'd0;
    else if(lastin_flag)
        lastcnt_in             <=          lastcnt_in + 1'b1;    
    else
        lastcnt_in             <=          lastcnt_in;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        lastcnt_out             <=          11'd0;
    else if((lastcnt_out == COL_NUM-1) & corner_flag_lastline)
        lastcnt_out             <=          11'd0;
    else if(corner_flag_lastline)
        lastcnt_out             <=          lastcnt_out + 1'b1;    
    else
        lastcnt_out             <=          lastcnt_out;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        lastcnt_r             <=          11'd0;
    else
        lastcnt_r             <=          lastcnt_out;
end 

reg    last_true; 
always @(posedge clk or negedge rst_n) begin
     if(!rst_n)
     last_true               <= 1'b0;
else begin
     last_true  <=  corner_flag_lastline;
end
end


always@(*)begin
    if(rst_n == 1'b0) begin 
        //initial//
        corner_type <= 0;
    end

    // start//
    else if((row_cnt == 11'd2)&(col_cnt == 11'd1)) begin
        corner_type <= 1;
    end

    // right start//
    else if((row_cnt == 11'd2)&(col_cnt == COL_NUM)) begin
        corner_type <= 2;
    end

    // the left beginning//
    else if(((!corner_flag_lastline)&(col_cnt == 11'd1))    | (   (lastin_flag)&(lastcnt_in == 11'd1) ) )begin
        corner_type <= 3;
    end

    // the right boarder//
    else if(((!corner_flag_lastline)&(col_cnt == COL_NUM))  | (   (lastin_flag)&(lastcnt_in == 11'd0) ) |(   (corner_flag_lastline)&(lastcnt_out == 11'd0) ))begin
        corner_type <= 4;
    end

    // the leftend//
    else if((lastcnt_r == 11'd0) & last_true) begin
        corner_type <= 5;
    end

    // the rigntend//
    else if((lastcnt_r == COL_NUM-1) & last_true ) begin
        corner_type <= 6;
    end

    // the lastline//
    else if(last_true) begin
        corner_type <= 7;
    end

    //total 3*3//
    else
    corner_type <= 8;
end


endmodule






