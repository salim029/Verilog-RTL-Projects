`timescale 1ns/1ps 

module tb_pipo_register;
reg d0, d1, d2, d3, clk;
wire q0, q1, q2, q3;

pipo_register uut(
    .d0(d0),
    .d1(d1),
    .d2(d2),
    .d3(d3),
    .clk(clk),
    .q0(q0),
    .q1(q1),
    .q2(q2),
    .q3(q3)
);

initial begin 
clk = 0;
forever #5 clk = ~clk;
end

initial begin

$dumpfile("pipo_register.vcd");
$dumpvars(0, tb_pipo_register);

d0 = 1; d1 = 0; d2 = 0; d3 = 1; #10;

$finish;
end

endmodule