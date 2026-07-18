`timescale 1ns/1ps 

module tb_down_counter;

reg clk, rst;
wire [3:0] count;

down_counter uut(
    .clk(clk),
    .rst(rst),
    .count(count)
);

initial begin 
clk = 0;
forever #5 clk = ~clk;
end

initial begin 

$dumpfile("down_counter.vcd");
$dumpvars(0, tb_down_counter);

rst = 1; #10;
rst = 0; #10;
#180;
$finish;
end 

endmodule
