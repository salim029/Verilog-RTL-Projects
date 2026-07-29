module baud_gen(
    input clk, rst, 
    input [31:0] baud_div,
    output reg tick
);

reg [31:0] count;

wire [31:0] sample_div;

assign sample_div = baud_div >> 4;

always @(posedge clk or posedge rst)
begin
if(rst)
    begin
        count <= 32'd0;
        tick <= 1'b0;
    end
else
    begin
        if (sample_div == 0) 
            begin
                count <= 0;
                tick  <= 0;
            end
        else if(count == sample_div - 1)
            begin 
                tick <= 1'b1;
                count <= 32'd0;
            end
        else
            begin
                count <= count + 1;
                tick <= 1'b0;
            end
    end
end

endmodule