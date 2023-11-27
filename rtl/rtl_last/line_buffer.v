`timescale 1ns/1ps

module line_buffer (
        rst_n,
        clk,
        din,
        dout,
        valid_in,
        valid_out,
        lastout,
        out_en
    );

parameter WIDTH = 8;//数据位宽
parameter IMG_WIDTH = 4;//图像宽度

input  rst_n;
input  clk;
input  [WIDTH-1:0] din;
output [WIDTH-1:0] dout;
input  valid_in;//输入数据有效，写使能
output valid_out;//输出给下�??级的valid_in，也即上�??级开始读的同时下�??级就可以�??始写�??
input  lastout;
output out_en;

wire   rd_en;//读使�??
reg    [8:0] cnt;//这里的宽度注意要根据IMG_WIDTH的�?�来设置，需要满足cnt的范围≥图像宽度


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt <= {9{1'b0}};
    else if(valid_in)
        if(cnt == IMG_WIDTH)
            cnt <= IMG_WIDTH;
        else
            cnt <= cnt +1'b1;
    else
        cnt <= cnt;
end
//�??行数据写完之后，该级fifo就可以开始读出，下一级也可以�??始写入了
assign rd_en = ((cnt == IMG_WIDTH) && (valid_in)) ? 1'b1 : (lastout)? 1'b1 : 1'b0;
assign valid_out = (lastout)? 1'b0 : rd_en;
// �?要解决dout 跟下一级的 valid_in =valid_out 的时钟同�? 
wire     [WIDTH-1:0]    dout_r;
assign dout     = rd_en? dout_r : 0;
assign out_en   = rd_en;
// 没给读就dout = 0�?

fifo_generator_0 u_line_fifo(
    .clk (clk),
    .srst (!rst_n),
    .din (din),
    .wr_en (valid_in),
    .rd_en (rd_en),
    .dout(dout_r),

    .empty(),
    .full()
);

/*
  .clk(clk),                  // input wire clk
  .rst(rst),                  // input wire rst
  .din(din),                  // input wire [9 : 0] din
  .wr_en(wr_en),              // input wire wr_en
  .rd_en(rd_en),              // input wire rd_en
  .dout(dout),                // output wire [9 : 0] dout
  .full(full),                // output wire full
  .empty(empty),              // output wire empty
  .data_count(data_count),    // output wire [8 : 0] data_count
  .wr_rst_busy(wr_rst_busy),  // output wire wr_rst_busy
  .rd_rst_busy(rd_rst_busy)  // output wire rd_rst_busy
*/
endmodule

