`timescale 1ns/1ps

module tb_modn_counter;

reg clk, rst;
parameter N = 10;
parameter WIDTH = 4;
wire [WIDTH-1:0] count;

modn_counter
#(
    .N(N),
    .WIDTH(WIDTH)
)
 uut(
    .clk(clk),
    .count(count),
    .rst(rst)
);

initial begin 
clk = 0;
forever #5 clk = ~clk;
end

initial begin 

$dumpfile("modn_counter.vcd");
$dumpvars(0, tb_modn_counter);

rst = 1; #10;
rst = 0; #((N+2)*10);

$finish;
end

endmodule