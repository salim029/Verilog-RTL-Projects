module pipo_register(
    input d0, d1, d2, d3, clk,
    output reg q0, q1, q2, q3
);

always @(posedge clk) begin

q0 <= d0;
   q1 <= d1;
   q2 <= d2;
   q3 <= d3;
end

endmodule