module ring_counter(
    input clk, rst,
    output reg [3:0] count
);

always @(posedge clk or posedge rst) begin
    if(rst)
     count <= 1;
    else
     count <= {count[2:0],count[3]};
end

endmodule