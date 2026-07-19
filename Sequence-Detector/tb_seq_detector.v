`timescale 1ns/1ps

module tb_seq_detector;

reg in, clk, rst;
wire out;

seq_detector uut(
    .in(in),
    .clk(clk),
    .rst(rst),
    .out(out)

);

initial begin 
clk = 0;
forever #5 clk = ~clk;
end

initial begin 

$dumpfile("seq_detector.vcd");
$dumpvars(0, tb_seq_detector);

rst = 1; in = 0; #10;
rst = 0; in = 1; #10;
in = 0; #10;
in = 1; #10;
in = 1; #10;
in = 0; #10;
in = 1; #10;
in = 0; #10;

$finish;
end

endmodule