module down_counter(
    input clk, rst,
    output reg [3:0] count
);

always @(posedge clk or posedge rst) begin 

    if(rst)
      count <= 4'b1111;
    else
      count <= count - 1'b1;
end

endmodule