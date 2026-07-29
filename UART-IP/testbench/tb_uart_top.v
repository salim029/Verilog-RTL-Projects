`timescale 1ns/1ps

module tb_uart_top;

reg clk, rst, tx_start;
reg [7:0] tx_data;
reg rd_en;
reg [31:0] baud_div;
wire serial_out, data_valid;
wire [7:0] rx_data;

wire serial_in;
assign serial_in = serial_out;

uart_top uut(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .serial_in(serial_in),
    .rd_en(rd_en),
    .baud_div(baud_div),
    .serial_out(serial_out),
    .data_valid(data_valid),
    .rx_data(rx_data)
);

initial 
begin
clk = 0;
forever #5 clk = ~clk;
end


initial 
begin

$dumpfile("uart_top.vcd");
$dumpvars(0, tb_uart_top);

rst = 1; 
tx_start = 0;
tx_data = 8'h00;
baud_div = 32'd64;
rd_en = 0;
#20;

rst = 0;

tx_data = 8'hA5;
tx_start = 1;
#10;
tx_start = 0;

// one full UART frame = 10 bits * 16 ticks/bit * sample_div clk cycles/tick
// sample_div = baud_div>>4 = 4, so 1 tick = 4 clk = 40ns
// 1 bit = 16 ticks = 640ns, 10 bits ≈ 6400ns. Add margin.
#8000;

rd_en = 1;
#10;
rd_en = 0;

#100;

$finish;
end

endmodule