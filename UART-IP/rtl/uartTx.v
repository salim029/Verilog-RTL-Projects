module uartTx(
    input clk, rst, tx_start, tick,
    input [7:0] parallel_in,
    output reg serial_out, busy
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [3:0] bit_count;
reg [7:0] shift_reg;

always @(posedge clk) begin
    if (rst) begin
        state      <= IDLE;
        serial_out <= 1'b1;
        busy       <= 1'b0;
        bit_count  <= 4'd0;
        shift_reg  <= 8'd0;
    end
    else begin
        case (state)
            IDLE: begin
                serial_out <= 1'b1;
                busy       <= 1'b0;
                bit_count  <= 4'd0;
                if (tx_start) begin
                    shift_reg <= parallel_in;
                    busy      <= 1'b1;
                    state     <= START;
                end
            end

            START: begin
                    serial_out <= 1'b0;

                    if (tick) begin
                        serial_out <= shift_reg[0];
                        shift_reg  <= {1'b0, shift_reg[7:1]};
                        bit_count  <= 4'd1;
                        state      <= DATA;
                    end
                end

            DATA: begin
                    if (tick) begin
                        if (bit_count == 8) begin
                            bit_count <= 4'd0;
                            state     <= STOP;
                        end
                        else begin
                            serial_out <= shift_reg[0];
                            shift_reg  <= {1'b0, shift_reg[7:1]};
                            bit_count  <= bit_count + 1;
                        end
                    end
                end

            STOP: begin
                serial_out <= 1'b1;
                if (tick) begin
                    busy  <= 1'b0;
                    state <= IDLE;
                end
            end

            default: begin
                state      <= IDLE;
                serial_out <= 1'b1;
                busy       <= 1'b0;
            end
        endcase
    end
end

endmodule