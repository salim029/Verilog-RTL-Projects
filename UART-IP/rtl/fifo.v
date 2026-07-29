module fifo(
    input clk, rst, wr_en, rd_en, 
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full, empty
);

reg [7:0] mem [0:15];
reg [4:0] count;

reg [3:0] wr_ptr;
reg [3:0] rd_ptr;

assign full = (count == 16);
assign empty = (count == 0);

integer i;

always @(posedge clk)
begin
if(rst)
    begin

        for(i = 0; i < 16; i= i + 1)
        mem[i] <= 8'd0;
        
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            data_out <= 0;
    end
else
    begin 
        
        if (wr_en && !rd_en && !full) 
        begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
        end

        else if (rd_en && !wr_en && !empty) 
        begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end

// Read & Write Together
    else if (wr_en && rd_en) 
    begin

        if (empty) 
            begin
                // Write only
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end

        else if (full) 
        begin
            // Read only
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end

        else 
        begin
            // Read + Write
            mem[wr_ptr] <= data_in;
            data_out <= mem[rd_ptr];

            wr_ptr <= wr_ptr + 1;
            rd_ptr <= rd_ptr + 1;

            // count unchanged
        end
    end
    end
end

endmodule                