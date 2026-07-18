`timescale 1ns/1ps 

module tb_ring_counter;

reg clk, rst;
wire [3:0] count;

ring_counter uut(
    .clk(clk),
    .rst(rst),
    .count(count)
);

initial begin 
clk = 0;
forever #5 clk = ~clk;
end

initial begin 
$dumpfile("ring_counter.vcd");
$dumpvars(0, tb_ring_counter);

rst = 1; #10;
rst = 0; #40;

$finish;
end

endmodule