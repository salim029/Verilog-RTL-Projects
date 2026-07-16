module siso_register(
    input din, clk,
    output reg q0, q1, q2, q3
);

always @(posedge clk) begin 
    q0 <= din;
    q1 <= q0;
    q2 <= q1;
    q3 <= q2;
end 

endmodule