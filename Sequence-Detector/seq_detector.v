module seq_detector(
    input in, clk, rst,
    output reg out
);

parameter s0 = 3'b000;
parameter s1 = 3'b001;
parameter s2 = 3'b010;
parameter s3 = 3'b100;
parameter s4 = 3'b011;
reg [2:0] state, next_state;

always @(posedge clk or posedge rst) begin
    if(rst)
        state <= s0;
    else 
        state <= next_state;
end

always @(*) begin

    case(state)
    s0: if(in)
            next_state = s1;
        else 
            next_state = s0;
    
    s1: if(in)
            next_state = s1;
        else 
            next_state = s2;

    s2: if(in)
            next_state = s3;
        else 
            next_state = s0;

    s3: if(in)
            next_state = s4;
        else 
            next_state = s2;

    s4: if(in)
            next_state = s1;
        else 
            next_state = s2;

    default: next_state = s0;
    endcase
end

always @(*)
begin
case(state)
        s4: out = 1;
        default: out = 0;
    endcase
end

endmodule

        


