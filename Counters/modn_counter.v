module modn_counter
#(
    parameter N = 10,
    parameter WIDTH = 4
)
(
    input clk, rst,
    output reg [WIDTH-1:0] count 
);

always @(posedge clk or posedge rst) begin
    if(rst)
        count <= 0;
    else if(count == N-1)
        count <= 0;
    else 
        count <= count + 1'b1;
end

endmodule
