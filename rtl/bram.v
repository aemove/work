module bram #(
    // parameters
) (
    input            clk,
    input  [5:0]     addr_in,           
    input  [5:0]     addr_out,
    input            wr_en,
    input            rd_en,
    input  [7:0]     data_in,           
    output [7:0]     data_out,           
);
reg [7:0]ram[0:2][0:2];
assign addrx_in  = addr_in[5:3];
assign addry_in  = addr_in[2:0];
assign addrx_out = addr_out[5:3];
assign addry_out = addr_out[2:0];

always @(posedge clk) begin
    if (wr_en==1) begin
        ram[addrx_in][addry_in] <= data_in;
    end
end

always @(posedge clk) begin
    if (rd_en==1) begin
        data_out <= ram[addrx_out][addry_out];
    end
end
    
endmodule