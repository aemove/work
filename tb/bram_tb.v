`timescale  1ns / 1ps

module tb_bram;

// bram Parameters
parameter PERIOD  = 20;


// bram Inputs
reg   clk                                  = 0 ;
reg   [7:0]  addr_in                       = 0 ;
reg   [7:0]  addr_out                      = 0 ;
reg   wr_en                                = 0 ;
reg   rd_en                                = 0 ;
reg   [7:0]  data_in                       = 0 ;

// bram Outputs
 reg[7:0]         data_out  ;    


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


bram  u_bram0 (
    .clk                                ( clk            ),
    .addr_in                            ( addr_in  [7:0] ),
    .addr_out                           ( addr_out [7:0] ),
    .wr_en                              ( wr_en          ),
    .rd_en                              ( rd_en          ),
    .data_in                            ( data_in  [7:0] ),
    .data_out                           ( data_out [7:0] )
);

initial
begin
    #10
    data_in = 8'd1;
    addr_in = 8'd1;
    wr_en   = 1'b1;
    #20
    data_in = 8'd2;
    addr_in = 8'd2;
    wr_en   = 1'b1;
    // data_in = 8'd2;
    addr_out = 8'd1;
    rd_en   = 1'b1;
    #20    
    data_in = 8'd3;
    addr_in = 8'd3;
    wr_en   = 1'b1;
    addr_out = 8'd2;
    rd_en   = 1'b1;
    #20
    wr_en   = 0;
    addr_out = 8'd3;
    rd_en   = 1'b1;
    #20

    rd_en   = 1'b0;
    #20
    #20
    $finish;
end

endmodule