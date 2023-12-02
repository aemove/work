module bram 
(
    input                           clk,
    // input  [5:0]                    addr_in,           
    input  [5:0]                    addr_out,// first matrix address ,just need the top-left address
    // input  [5:0]                    addr_out2,// second matrix
    // input  [5:0]                    addr_out3,// third matrix
    input                           wr_en,
    input                           rd_en,
    input  [7:0]                    data_in,
    output [71:0]                   data_out            
         
);
reg[7:0]    ram[7:0][7:0];
reg[2:0]    addrx_in = 0;
reg[2:0]    addry_in = 0;
wire [2:0] addrx_out1,addry_out1;
assign      addrx_out1 = addr_out[5:3];
assign      addry_out1 = addr_out[2:0];
reg[23:0]                 data_out1;           
reg[23:0]                 data_out2;          
reg[23:0]                 data_out3;           


// input
always @(posedge clk) begin
    if (wr_en==1) begin
        ram[addrx_in][addry_in] <= data_in;
        addrx_in                <= addrx_in +1;
        if (addrx_in == 3'b111) begin
            addry_in <= addry_in + 1;
        end
    end
end

// output
always @(posedge clk) begin
    if (rd_en==1) begin
        data_out1 <= {ram[addrx_out1][addry_out1],  ram[addrx_out1+1][addry_out1],  ram[addrx_out1+2][addry_out1]};
        data_out2 <= {ram[addrx_out1][addry_out1+1],ram[addrx_out1+1][addry_out1+1],ram[addrx_out1+2][addry_out1+1]};
        data_out3 <= {ram[addrx_out1][addry_out1+2],ram[addrx_out1+1][addry_out1+2],ram[addrx_out1+2][addry_out1+2]};
    end else begin
        data_out1 <= data_out1; data_out2 <= data_out2; data_out3 <= data_out3;
    end
end
assign data_out = {data_out1,data_out2,data_out3};
endmodule