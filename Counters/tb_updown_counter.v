`timescale 1ns/1ps 

module tb_updown_counter;

reg in, clk, rst;
wire [3:0] count;

updown_counter uut(
    .clk(clk),
    .in(in),
    .rst(rst),
    .count(count)
);

initial begin 
clk = 0;
forever #5 clk = ~clk;
end

initial begin 

$dumpfile("updown_counter.vcd");
$dumpvars(0, tb_updown_counter);

rst = 1; in = 1; #10;
rst = 0; in = 1; #160;
in = 0; #160;
$finish;
end

endmodule

