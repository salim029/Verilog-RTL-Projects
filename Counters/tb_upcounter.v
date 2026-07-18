`timescale 1ns/1ps

module tb_upcounter;
reg clk, rst;
wire [3:0] count;
parameter N = 4;
up_counter#(
    .N(N)
) uut(
    .clk(clk),
    .rst(rst),
    .count(count)
);

initial begin 
clk = 0;
forever #5 clk = ~clk;
end

initial begin 

$dumpfile("up_counter.vcd");
$dumpvars(0, tb_upcounter);

rst = 1; #10;
rst = 0; #((1<<N)*10);
$finish;
end

endmodule