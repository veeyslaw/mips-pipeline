module IF2ID
#(
    parameter integer LEN = 1
)
// signals
(
    input clk,
    input reset,
    
    input flush,
    input stall,
    
    input [LEN - 1: 0] next_inced_pc,
    input [LEN - 1: 0] next_instruction,
    
    output reg [LEN - 1: 0] inced_pc,
    output reg [LEN - 1: 0] instruction
);

    always @(posedge clk) begin
        if (reset || flush) begin
            inced_pc <= 0;
            instruction <= 0;
            
        end
        else if (~stall) begin
            inced_pc <= next_inced_pc;
            instruction <= next_instruction;
            
        end
    end

endmodule // IF2ID
