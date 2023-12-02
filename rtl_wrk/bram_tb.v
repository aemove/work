// `timescale  1ns / 1ps

module tb_bram;

// bram Parameters
parameter PERIOD  = 20;


// bram Inputs
reg   clk                                  = 0 ;
reg   [2:0]  addrx_out                     = 0 ;
reg   [2:0]  addry_out                     = 0 ;
reg   wr_en                                = 0 ;
reg   rd_en                                = 0 ;
reg   [7:0]  data_in                       = 0 ;

// bram Outputs
wire  [71:0]  data_out                     ;     
wire  [5:0]   addr_out                     ; 
assign addr_out = {addrx_out,addry_out};

initial begin
    $vcdpluson;
    $vcdplusmemon;
    $vcdplusdeltacycleon;
end

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end



bram  u_bram (
    .clk                     ( clk               ),
    .addr_out                ( addr_out  [5:0]  ),
    .wr_en                   ( wr_en             ),
    .rd_en                   ( rd_en             ),
    .data_in                 ( data_in    [7:0]  ),

    .data_out                ( data_out   [71:0] )
);

integer i,j;
initial
begin
    #10
    //图片ram赋初值
    for (i=0; i < 64; i=i+1) begin
        #PERIOD
        data_in = i;
        wr_en   = 1;
    end
    #PERIOD
    for (i=0; i < 6; i=i+1) begin
        for (j=0; j < 6; j=j+1) begin
        #PERIOD
            rd_en     = 1;
            addrx_out = i;
            addry_out = j;
        end
    end
    #20
    $finish;
end

endmodule