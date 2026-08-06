`timescale 1ns/1ps

module tb_apb;

parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
parameter NUM_REG = 4;

reg PCLK;
reg PRESETn;
reg PSEL;
reg PENABLE;
reg PWRITE;
reg [3:0] PSTRB;
reg [ADDR_WIDTH-1:0] PADDR;
reg [DATA_WIDTH-1:0] PWDATA;

wire PSLVERR;
wire PREADY;
wire [DATA_WIDTH-1:0] PRDATA;

apb #(
.ADDR_WIDTH(ADDR_WIDTH),
.DATA_WIDTH(DATA_WIDTH),
.NUM_REG(NUM_REG),
.WAIT_CYCLES(3)
) dut (
.PCLK(PCLK),
.PRESETn(PRESETn),
.PSEL(PSEL),
.PENABLE(PENABLE),
.PWRITE(PWRITE),
.PADDR(PADDR),
.PWDATA(PWDATA),
.PSLVERR(PSLVERR),
.PREADY(PREADY),
.PSTRB(PSTRB),
.PRDATA(PRDATA)
);

initial begin
PCLK = 0;
forever #5 PCLK = ~PCLK;
end

initial begin

$dumpfile("apb.vcd");
$dumpvars(0, tb_apb);

// Initialize signals
PSTRB = 4'b0000;
PRESETn  = 0;
PSEL     = 0;
PENABLE  = 0;
PWRITE   = 0;
PADDR    = 0;
PWDATA   = 0;

// Apply Reset
#20;
PRESETn = 1;


end

task apb_write;
input [ADDR_WIDTH-1:0] addr;
input [DATA_WIDTH-1:0] data;
input [3:0] strobe;
begin
// Setup
@(posedge PCLK);
PSEL = 1;
PENABLE = 0;
PWRITE = 1;
PADDR = addr;
PWDATA = data;
PSTRB = strobe;

// Access
@(posedge PCLK);
PENABLE = 1;

// Hold ACCESS for one full clock
while (!PREADY)
    @(posedge PCLK);

#1;
// End transaction
PSTRB = 4'b0000;
PSEL    = 0;
PENABLE = 0;
PWRITE  = 0;
PADDR   = 0;
PWDATA  = 0;


end
endtask

task apb_read;
input [ADDR_WIDTH-1:0] addr;
output [DATA_WIDTH-1:0] data;

begin

PSTRB = 4'b1111;
// SETUP
@(posedge PCLK);
PSEL    = 1;
PENABLE = 0;
PWRITE  = 0;
PADDR   = addr;

// ACCESS
@(posedge PCLK);
PENABLE = 1;

// Hold ACCESS for one full clock
while (!PREADY)
    @(posedge PCLK);

@(negedge PCLK);
data = PRDATA;

// End transaction
PSTRB = 4'b0000;
PSEL    = 0;
PENABLE = 0;
PADDR   = 0;


end
endtask

reg [31:0] read_data;

initial begin
wait(PRESETn);

// Read before clearing
apb_read(32'h00000008, read_data);
$display("Before W1C REG2 = %h", read_data);

if (read_data == 32'h0000000F)
    $display("PASS: W1C initial value correct");
else
    $display("FAIL: W1C initial value incorrect");

// Clear all 4 bits
apb_write(32'h00000008, 32'h0000000F, 4'b1111);

// Read after clearing
apb_read(32'h00000008, read_data);
$display("After W1C REG2 = %h", read_data);

// Try writing to RO register
apb_write(32'h00000004, 32'h12345678, 4'b1111);

// Read back
apb_read(32'h00000004, read_data);
$display("REG1 = %h", read_data);

if (read_data == 32'hDEADBEEF)
    $display("PASS: RO register protected");
else
    $display("FAIL: RO register modified");

apb_read(32'h00000002, read_data);

if (PSLVERR)
    $display("PASS: Misaligned address detected");
else
    $display("FAIL: Misaligned address not detected");

apb_read(32'h00000020, read_data);
if (PSLVERR)
    $display("PASS: PSLVERR asserted for invalid address");
else
    $display("FAIL: PSLVERR not asserted");

#20;
$finish;


end
endmodule