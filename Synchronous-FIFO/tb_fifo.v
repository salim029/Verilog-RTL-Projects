`timescale 1ns/1ps

module tb_fifo;

parameter WIDTH = 8;
parameter DEPTH = 8;
parameter ADD_WIDTH = 3;

reg clk, rst, wr_en, rd_en;
reg [WIDTH-1:0] in;
wire full, empty;
wire [WIDTH-1:0] out;

fifo#(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .ADD_WIDTH(ADD_WIDTH)
) 
uut(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .in(in),
    .full(full),
    .empty(empty),
    .out(out)
);

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin

$dumpfile ("fifo.vcd");
$dumpvars (0, tb_fifo);

rst = 1; wr_en = 0; rd_en = 0; in = 8'b0;
#10; rst = 0;

repeat(8)
begin
    @(posedge clk);
    wr_en = 1;
    in = in + 8'd10;
end

@(posedge clk);
wr_en = 0;

// Read first 4 values
repeat(4) begin
    @(posedge clk);
    rd_en = 1;
end

// Simultaneous Read & Write
@(posedge clk);
wr_en = 1;
rd_en = 1;
in = 8'hAA;

// Stop write, continue reading
@(posedge clk);
wr_en = 0;

// Read remaining data
repeat(5) begin
    @(posedge clk);
    rd_en = 1;
end

@(posedge clk);
rd_en = 0;


#20;
$finish;
end

endmodule