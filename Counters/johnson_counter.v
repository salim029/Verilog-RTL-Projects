module johnson_counter#(
    parameter N = 4
)
(
    input clk, rst,
    output reg [N-1:0] count 
);

always @(posedge clk or posedge rst) begin

if (rst)
  count <= 0;
else 
count <= {~count[0], count[N-1:1]};
end

endmodule
