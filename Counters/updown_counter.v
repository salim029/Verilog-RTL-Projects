module updown_counter(
    input clk, rst, in,
    output reg [3:0] count

);

always @(posedge clk or posedge rst) begin
if(rst)
    count <= 0;
else if(in)
    count <= count + 1;
else
    count <= count - 1;
end

endmodule