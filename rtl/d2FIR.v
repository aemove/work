module  gaussian_filter_3x3(
	 	clk, //pixel clk
	  	rst_n,
	 
	 	data_in, //8 bit 灰度 pixel 
	  	data_in_en,
	 
		data_out,
	 	data_out_en
);

parameter DATA_WIDTH = 8;
     input 							clk; //pixel clk
	 input 							rst_n;
	 
	 input 		[DATA_WIDTH-1:0]	data_in; //8 bit 灰度 pixel 
	 input 							data_in_en;
	 
	 output 	[DATA_WIDTH-1:0] 	data_out;
	 output  						data_out_en;
//------------------------------------
// 三行像素缓存
//----------------------------------- 
wire [DATA_WIDTH-1:0] line0;
wire [DATA_WIDTH-1:0] line1;
wire [DATA_WIDTH-1:0] line2;
//-----------------------------------------
// 3x3 像素矩阵中的像素
//-----------------------------------------
reg [DATA_WIDTH-1:0] line0_data0;
reg [DATA_WIDTH-1:0] line0_data1;
reg [DATA_WIDTH-1:0] line0_data2;
reg [DATA_WIDTH-1:0] line1_data0;
reg [DATA_WIDTH-1:0] line1_data1;
reg [DATA_WIDTH-1:0] line1_data2;
reg [DATA_WIDTH-1:0] line2_data0;
reg [DATA_WIDTH-1:0] line2_data1;
reg [DATA_WIDTH-1:0] line2_data2;

wire	out_en;
wire	lastin_flag;
wire    [3:0]            corner_type;

//---------------------------------------------
// 获取3*3的图像矩�??
//---------------------------------------------
matrix_3x3 matrix_3x3_inst(
    .clk (clk),
    .rst_n(rst_n),
    .din (data_in),
    .valid_in(data_in_en),
    .dout_r0(line0),
    .dout_r1(line1),
    .dout_r2(line2),
    .corner_type(corner_type),
	.lastin_flag(lastin_flag),
	.out_en(out_en)
);
//--------------------------------------------------
// Form an image matrix of three multiplied by three
//--------------------------------------------------
always @(posedge clk or negedge rst_n) begin
 if(!rst_n) begin
	 line0_data1 <= 8'b0;
	 line0_data2 <= 8'b0;
	 
	 line1_data1 <= 8'b0;
	 line1_data2 <= 8'b0;
	 
	 line2_data1 <= 8'b0;
	 line2_data2 <= 8'b0;
 end
 else if(data_in_en | data_out_en) begin 
	 
	 line0_data1 <= line0_data0;
	 line0_data2 <= line0_data1;
	 
	 
	 line1_data1 <= line1_data0;
	 line1_data2 <= line1_data1;
	 
	 
	 line2_data1 <= line2_data0;
	 line2_data2 <= line2_data1; 
 end
end

always@(*) begin
	if(!rst_n) begin
	line0_data0 <= 8'b0;
	line1_data0 <= 8'b0;
	line2_data0 <= 8'b0;
	end
	else begin
line0_data0 <= line0;
line1_data0 <= line1;
line2_data0 <= line2;
	end
end
//--------------------------------------------------------------------------
// 计算�??终结�??
//--------------------------------------------------------------------------


computing_block u_compute(
.line0_data0	(line0_data0),
.line0_data1	(line0_data1),
.line0_data2	(line0_data2),
.line1_data0	(line1_data0),
.line1_data1	(line1_data1),
.line1_data2	(line1_data2),
.line2_data0	(line2_data0),
.line2_data1	(line2_data1),
.line2_data2	(line2_data2),
.corner_type    (corner_type),
.data_out   	(data_out)
);

reg en_flag;  	//起始点到终点的输出使�?//
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        en_flag  <= 1'b0;
	else if (corner_type == 4'd1)	// start//
		en_flag  <= 1'b1;
	else if (corner_type == 4'd6)  	// end //
		en_flag  <= 1'b0;
end

wire total_flag;
assign total_flag	=	(corner_type == 4'd1) | en_flag;
assign data_out_en	=	(corner_type == 4'd6)? 1'b1 : (total_flag & out_en);

endmodule

