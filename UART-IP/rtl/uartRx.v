module uartRx(
    input clk, rst, tick, serial_in,
    output reg data_valid,
    output reg [7:0] parallel_out 
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [7:0] shift_reg;
reg [3:0] bit_count;
reg [1:0] state;
reg [3:0] sample_count;
reg serial_in_d;

always @(posedge clk)
begin 
if(rst)
    begin
        state        <= IDLE;
        bit_count    <= 4'd0;
        shift_reg    <= 8'd0;
        data_valid   <= 1'b0;
        parallel_out <= 8'b0;
        sample_count <= 4'd0;
        serial_in_d <= 1'b1;
    end
else
    begin
        serial_in_d <= serial_in;

        case(state)

            IDLE:
                begin
                    data_valid   <= 1'b0;
                    bit_count    <= 4'd0;
                    sample_count <= 4'd0;
                    shift_reg <= 8'd0;

                    if(serial_in_d && !serial_in)
                        state <= START;
                end

            START:
                begin
                    if(tick)   
                    begin
                        if(sample_count == 7)
                        begin
                            sample_count <= 4'd0;

                            if(serial_in == 1'b0)
                                state <= DATA;
                            else
                                state <= IDLE;
                        end
                        else
                            sample_count <= sample_count + 1;
                    end
                end

            DATA:
                begin
                    if(tick)   
                    begin
                        if(sample_count == 15)
                        begin
                            sample_count <= 4'd0;
                            shift_reg    <= {serial_in, shift_reg[7:1]};

                            if(bit_count == 7)
                            begin
                                bit_count <= 4'd0;
                                state     <= STOP;
                            end
                            else
                                bit_count <= bit_count + 1;
                        end
                        else
                            sample_count <= sample_count + 1;
                    end
                end

            STOP:
                begin
                    if(tick)   
                    begin
                        if(sample_count == 15)
                        begin
                            sample_count <= 4'd0;

                            if(serial_in)
                            begin
                                parallel_out <= shift_reg;
                                data_valid   <= 1'b1;
                            end

                            state <= IDLE;
                        end
                        else
                            sample_count <= sample_count + 1;
                    end
                end
            
            default:
                state <= IDLE;

        endcase
    end
end        

endmodule    