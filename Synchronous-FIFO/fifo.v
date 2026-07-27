module fifo#(
    parameter WIDTH = 8,
    parameter DEPTH = 8,
    parameter ADD_WIDTH = 3
)
(
    input clk, rst,
    input [WIDTH-1:0] in,
    input wr_en,
    input rd_en,
    output reg [WIDTH-1:0] out,
    output  full, empty
);
reg [WIDTH-1:0] mem[0:DEPTH-1];
reg [ADD_WIDTH-1:0] wr_ptr;
reg [ADD_WIDTH-1:0] rd_ptr;
reg [ADD_WIDTH:0] count;

assign full = (count == DEPTH);
assign empty = (count == 0);

always @(posedge clk or posedge rst)
begin
if(rst)
begin
    count <= 0;
    wr_ptr <= 0;
    rd_ptr <= 0;
    out <= 0;
end
else 
begin

    // Simultaneous Read & Write
    if(wr_en && rd_en && !full && !empty)
    begin
        mem[wr_ptr] <= in;
        wr_ptr <= wr_ptr + 1;

        out <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;

        count <= count;
    end

    // Write Only
    else if(wr_en && !full)
    begin
        mem[wr_ptr] <= in;
        wr_ptr <= wr_ptr + 1;
        count <= count + 1;
    end

    // Read Only
    else if(rd_en && !empty)
    begin 
        out <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
    end
end
end

endmodule