module apb#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter NUM_REG = 4,
    parameter WAIT_CYCLES = 0
)(
    input  PCLK, PRESETn, PSEL, PENABLE, PWRITE,
    input [ADDR_WIDTH-1:0] PADDR, 
    input [DATA_WIDTH-1:0] PWDATA,
    input [3:0] PSTRB,
    output PREADY,
    output reg PSLVERR,
    output reg [DATA_WIDTH-1:0] PRDATA 
);

localparam RW  = 2'b00;
localparam RO  = 2'b01;
localparam W1C = 2'b10;

localparam REG0_TYPE = RW;
localparam REG1_TYPE = RO;
localparam REG2_TYPE = W1C;
localparam REG3_TYPE = RW;

reg [31:0] wait_count;
reg [DATA_WIDTH-1:0] registers [0:NUM_REG-1];

reg hw_event;

reg[$clog2(NUM_REG)-1:0] reg_index;
reg [1:0] reg_type;

localparam IDLE = 2'b00;
localparam SETUP = 2'b01;
localparam ACCESS = 2'b10;

reg [1:0] state, next_state;

always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        registers[0] <= REG0_RESET;
        registers[1] <= REG1_RESET;
        registers[2] <= REG2_RESET;
        registers[3] <= REG3_RESET;

        state <= IDLE;
        wait_count <= 0;
        hw_event <= 1'b0;
    end
    else
    begin 
        state <= next_state;
                if(state == IDLE)
                    hw_event <= 1'b1;
                else
                    hw_event <= 1'b0;
            if(state == ACCESS)
                begin
                    if(wait_count < WAIT_CYCLES)
                        wait_count <= wait_count + 1;
                    else
                        wait_count <= 0;
                end
                else
                begin
                    wait_count <= 0;
                end
            if(hw_event)
            begin
                registers[2] <= registers[2] | 32'h0000000F;  
                registers[1] <= 32'hDEADBEEF;
            end
    end
end

always @(*)
begin
    next_state = state;

    case(state)

        IDLE:
            begin
                if(PSEL)
                    next_state = SETUP;
            end

        SETUP:
            begin
                next_state = ACCESS;
            end
        
        ACCESS:
        begin
            if(!PREADY)
                next_state = ACCESS;

            else if(PSEL && !PENABLE)
                next_state = SETUP;

            else if(!PSEL)
                next_state = IDLE;

            else
                next_state = ACCESS;
        end
        
        default: 
            begin
                next_state = IDLE;
            end
    endcase
end    

localparam REG0_RESET = 32'h00000000;
localparam REG1_RESET = 32'hDEADBEEF;
localparam REG2_RESET = 32'h0000000F;
localparam REG3_RESET = 32'hFFFFFFFF;

always @(*)
begin

    reg_index = 0;
    reg_type  = RW;
    PSLVERR = 1'b0;
    
    reg_index = PADDR[ADDR_WIDTH-1:2];

    case(reg_index)
        0: reg_type = REG0_TYPE;
        1: reg_type = REG1_TYPE;
        2: reg_type = REG2_TYPE;
        3: reg_type = REG3_TYPE;

        default:
            PSLVERR = 1'b1;
    endcase

    if(PADDR >= (NUM_REG * 4))
        PSLVERR = 1'b1;

    if(PADDR[1:0] != 2'b00)
        PSLVERR = 1'b1;

end

always @(posedge PCLK)
begin
    if(write_en)
    begin
        case(reg_type)

            RW:
            begin
                if(PSTRB[0])
                    registers[reg_index][7:0]   <= PWDATA[7:0];

                if(PSTRB[1])
                    registers[reg_index][15:8]  <= PWDATA[15:8];

                if(PSTRB[2])
                    registers[reg_index][23:16] <= PWDATA[23:16];

                if(PSTRB[3])
                    registers[reg_index][31:24] <= PWDATA[31:24];

                $display("WRITE: PSTRB=%b DATA=%h",
                        PSTRB, PWDATA);
            end

            RO:
            begin
                // Ignore write
            end

            W1C:
            begin
                if(PSTRB[0])
                    registers[reg_index][7:0] <= registers[reg_index][7:0] & ~PWDATA[7:0];

                if(PSTRB[1])
                    registers[reg_index][15:8] <= registers[reg_index][15:8] & ~PWDATA[15:8];

                if(PSTRB[2])
                    registers[reg_index][23:16] <= registers[reg_index][23:16] & ~PWDATA[23:16];

                if(PSTRB[3])
                    registers[reg_index][31:24] <= registers[reg_index][31:24] & ~PWDATA[31:24];

                $display("W1C WRITE: PSTRB=%b DATA=%h", PSTRB, PWDATA);
            end
        endcase
                    
    end
end

wire write_en;
wire read_en;

assign write_en = PSEL && PENABLE && PWRITE && PREADY && !PSLVERR;

assign read_en = PSEL && PENABLE && !PWRITE && PREADY && !PSLVERR;

always @(posedge PCLK)
begin
    if(read_en)
        PRDATA <= registers[reg_index];
end

assign PREADY = (WAIT_CYCLES == 0) ? 1'b1 : (wait_count == WAIT_CYCLES);

endmodule