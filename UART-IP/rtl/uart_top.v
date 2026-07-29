module uart_top(
    input clk, rst, 

    input tx_start,
    input [7:0] tx_data,

    input  serial_in,
    input [31:0] baud_div,

    input rd_en,

    output serial_out,
    output [7:0] rx_data,
    output data_valid
);

wire tick;
wire tx_busy;

reg [3:0] tx_tick_cnt;
reg tx_bit_tick;

wire [7:0] rx_parallel_out;
wire rx_data_valid;

wire [7:0] fifo_data_out;
wire fifo_full;
wire fifo_empty;

baud_gen baud_inst(
    .clk(clk),
    .rst(rst),
    .baud_div(baud_div),
    .tick(tick)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx_tick_cnt <= 4'd0;
        tx_bit_tick <= 1'b0;
    end
    else begin
        tx_bit_tick <= 1'b0;
        if (tx_start) 
            begin
                tx_tick_cnt <= 4'd0;   
            end
        else if (tick) 
            begin
                if (tx_tick_cnt == 4'd15) 
                    begin
                        tx_tick_cnt <= 4'd0;
                        tx_bit_tick <= 1'b1;
                    end
                else
                    tx_tick_cnt <= tx_tick_cnt + 1;
            end
    end
end

uartTx tx_inst(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tick(tx_bit_tick),
    .parallel_in(tx_data),
    .serial_out(serial_out),
    .busy(tx_busy)
);

uartRx rx_inst(
    .clk(clk),
    .rst(rst),
    .tick(tick),
    .serial_in(serial_in),
    .parallel_out(rx_parallel_out),
    .data_valid(rx_data_valid)
);

fifo fifo_inst(
    .clk(clk),
    .rst(rst),
    .wr_en(rx_data_valid),
    .rd_en(rd_en),
    .data_in(rx_parallel_out),
    .data_out(fifo_data_out),
    .full(fifo_full),
    .empty(fifo_empty)
);

reg data_valid_r;
always @(posedge clk or posedge rst) 
begin
    if (rst)
        data_valid_r <= 1'b0;
    else
        data_valid_r <= rd_en && !fifo_empty;
end

assign rx_data = fifo_data_out;
assign data_valid = data_valid_r;

endmodule