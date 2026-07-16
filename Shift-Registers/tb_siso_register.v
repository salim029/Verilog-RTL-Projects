`timescale 1ns/1ps

module tb_siso_register;
 reg din, clk;
 wire q0, q1, q2 ,q3;

siso_register uut(
    .din(din),
    .clk(clk),
    .q0(q0),
    .q1(q1),
    .q2(q2),
    .q3(q3)
);

initial begin
clk = 1;
forever #5 clk = ~clk;
end

initial begin

$dumpfile("siso_register.vcd");
$dumpvars(0, tb_siso_register);

din = 1; #10;
din = 1; #10;
din = 0; #10;
din = 1; #10;

$finish;
end

endmodule
