module computing_block
#(parameter DATA_WIDTH = 8)
(
input [DATA_WIDTH-1:0] line0_data0,
input [DATA_WIDTH-1:0] line0_data1,
input [DATA_WIDTH-1:0] line0_data2,
input [DATA_WIDTH-1:0] line1_data0,
input [DATA_WIDTH-1:0] line1_data1,
input [DATA_WIDTH-1:0] line1_data2,
input [DATA_WIDTH-1:0] line2_data0,
input [DATA_WIDTH-1:0] line2_data1,
input [DATA_WIDTH-1:0] line2_data2,
input  [3:0]           corner_type,
output [DATA_WIDTH-1:0] data_out
);

//    parameter         corner_flag_start     = 1;
//    parameter         corner_right_start    = 2;
//    parameter         corner_flag_leftline  = 3;
//    parameter         corner_flag_rigntline = 4;
//    parameter         corner_flag_leftend   = 5;
//    parameter         corner_flag_rigntend  = 6;
//    parameter         corner_flag_lastline  = 7;
//    parameter         total_cross           = 8;

reg [3:0]   coff_0  [2:0];
reg [3:0]   coff_1  [2:0];
reg [3:0]   coff_2  [2:0];

always@(*) begin
case (corner_type)
4'd0 :  begin           // initial//
        coff_0[0] <= 0;
        coff_0[1] <= 0;
        coff_0[2] <= 0;
        coff_1[0] <= 0;
        coff_1[1] <= 0;
        coff_1[2] <= 0;
        coff_2[0] <= 0;
        coff_2[1] <= 0;
        coff_2[2] <= 0;
        end
4'd1 :  begin           // start//
        coff_0[0] <= 1;
        coff_0[1] <= 2;
        coff_0[2] <= 0;
        coff_1[0] <= 2;
        coff_1[1] <= 4;
        coff_1[2] <= 0;
        coff_2[0] <= 0;
        coff_2[1] <= 0;
        coff_2[2] <= 0;
        end
4'd2 :  begin           // right start//
        coff_0[0] <= 0;
        coff_0[1] <= 2;
        coff_0[2] <= 1;
        coff_1[0] <= 0;
        coff_1[1] <= 4;
        coff_1[2] <= 2;
        coff_2[0] <= 0;
        coff_2[1] <= 0;
        coff_2[2] <= 0;
        end
4'd3 :  begin           // the left beginning//
        coff_0[0] <= 1;
        coff_0[1] <= 2;
        coff_0[2] <= 0;
        coff_1[0] <= 2;
        coff_1[1] <= 4;
        coff_1[2] <= 0;
        coff_2[0] <= 1;
        coff_2[1] <= 2;
        coff_2[2] <= 0;
        end
4'd4 :  begin           // the right boarder//
        coff_0[0] <= 0;
        coff_0[1] <= 2;
        coff_0[2] <= 1;
        coff_1[0] <= 0;
        coff_1[1] <= 4;
        coff_1[2] <= 2;
        coff_2[0] <= 0;
        coff_2[1] <= 2;
        coff_2[2] <= 1;
        end
4'd5 :  begin           // the leftend//
        coff_0[0] <= 0;
        coff_0[1] <= 0;
        coff_0[2] <= 0;
        coff_1[0] <= 2;
        coff_1[1] <= 4;
        coff_1[2] <= 0;
        coff_2[0] <= 1;
        coff_2[1] <= 2;
        coff_2[2] <= 0;
        end
4'd6 :  begin           // the rigntend//
        coff_0[0] <= 0;
        coff_0[1] <= 0;
        coff_0[2] <= 0;
        coff_1[0] <= 0;
        coff_1[1] <= 4;
        coff_1[2] <= 2;
        coff_2[0] <= 0;
        coff_2[1] <= 2;
        coff_2[2] <= 1;
        end
default: begin           // the total 3*3//
        coff_0[0] <= 1;
        coff_0[1] <= 2;
        coff_0[2] <= 1;
        coff_1[0] <= 2;
        coff_1[1] <= 4;
        coff_1[2] <= 2;
        coff_2[0] <= 1;
        coff_2[1] <= 2;
        coff_2[2] <= 1;
        end
endcase
end 

wire   [11:0] data_out_r;
assign data_out_r  =     (line0_data0*coff_0[0] + line0_data1*coff_0[1] + line0_data2*coff_0[2] 
                        + line1_data0*coff_1[0] + line1_data1*coff_1[1] + line1_data2*coff_1[2]
                        + line2_data0*coff_2[0] + line2_data1*coff_2[1] + line2_data2*coff_2[2])>>4;
assign data_out    =    data_out_r[DATA_WIDTH-1:0];
endmodule