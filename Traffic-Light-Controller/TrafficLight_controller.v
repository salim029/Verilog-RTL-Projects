module TrafficLight_controller(
    input clk, rst,
    output reg [2:0] out
);
parameter RED = 2'b10;
parameter GREEN = 2'b01;
parameter YELLOW = 2'b11;
reg [1:0] state, next_state;

always @(posedge clk or posedge rst) begin
if(rst)
    state <= RED;
else 
    state <= next_state;
end

always @(*) 
begin
    next_state = state;
    case(state)
        RED: next_state = GREEN;
        GREEN: next_state = YELLOW;
        YELLOW: next_state = RED;
    endcase
end

always @(*)
begin
    case(state)
        RED: out = 3'b100;
        GREEN: out = 3'b010;
        YELLOW: out = 3'b001;
    endcase
end


endmodule



