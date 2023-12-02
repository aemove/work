module bram 
(
    input                           clk,
    input  [7:0]                    addr_in,           
    input  [7:0]                    addr_out,
    input                           wr_en,
    input                           rd_en,
    input  [7:0]                    data_in,           
    output reg[7:0]                 data_out           
);
reg[7:0]    ram[7:0][7:0];
assign      addrx_in  = addr_in[7:4];
assign      addry_in  = addr_in[3:0];
assign      addrx_out = addr_out[7:4];
assign      addry_out = addr_out[3:0];

always @(posedge clk) begin
    if (wr_en==1) begin
        ram[addrx_in][addry_in] <= data_in;
    end
end

always @(posedge clk) begin
    if (rd_en==1) 
        data_out <= ram[addrx_out][addry_out];
    else 
        data_out <= data_out;
end
    
endmodule