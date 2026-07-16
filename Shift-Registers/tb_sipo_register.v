`timescale 1ns/1ps

module tb_sipo_register;

reg din, clk;
wire q0, q1, q2, q3;

sipo_register uut(
    .din(din),
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

$dumpfile("sipo_register.vcd");
$dumpvars(0, tb_sipo_register);

din = 1; #10;
din = 1; #10;
din = 0; #10;
din = 1; #10;
$finish;

end


endmodule