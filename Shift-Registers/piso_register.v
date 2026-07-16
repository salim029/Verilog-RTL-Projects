module piso_register(
    input d0,d1,d2,d3,load,clk,
    output reg q0, q1, q2, q3
);

always @(posedge clk) begin
 if(load) begin
   q0 <= d0;
   q1 <= d1;
   q2 <= d2;
   q3 <= d3;
  end

 else begin
 q3 <= q2;
 q2 <= q1;
 q1 <= q0;
 q0 <= 1'b0;
 end

end


endmodule
