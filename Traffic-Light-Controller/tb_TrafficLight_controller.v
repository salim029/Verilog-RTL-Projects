`timescale 1ns/1ps

module tb_TrafficLight_controller;

reg clk, rst;
wire [2:0] out;

TrafficLight_controller uut(
    .clk(clk),
    .rst(rst),
    .out(out)
);

initial 
begin 
clk = 0;
forever #5 clk = ~clk;
end

initial begin 

$dumpfile("TrafficLight_controller.vcd");
$dumpvars(0, tb_TrafficLight_controller);

rst = 1; #10;
rst = 0; #50;

$finish;
end

endmodule