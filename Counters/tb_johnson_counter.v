`timescale 1ns/1ps

module tb_johnson_counter;

reg clk, rst;
parameter N = 4;
wire [N-1:0]count;

johnson_counter#(
    .N(N)
)
uut(
    .clk(clk),
    .rst(rst),
    .count(count)
);

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin 

$dumpfile("johnson_counter.vcd");
$dumpvars(0, tb_johnson_counter);

rst = 1; #10;
rst = 0; #80;

$finish;
end

endmodule