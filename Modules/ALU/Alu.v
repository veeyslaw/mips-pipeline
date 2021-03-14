`include "Headers/ALUControls.v"

module Alu
#(
    parameter integer LEN = 1
)
// signals
(
    input [LEN - 1: 0] num_1,
    input [LEN - 1: 0] num_2,
    input [2: 0] alu_ctrl,

    output reg [LEN - 1: 0] alu_out,
    output alu_zero
);

    assign alu_zero = alu_out ? 0 : 1;

    always @*
        case (alu_ctrl)
        
            `ALU_CTRL_NOP: alu_out <= 0;
            `ALU_CTRL_ADD: alu_out <= num_1 + num_2;
            `ALU_CTRL_SUB: alu_out <= num_1 - num_2;
            `ALU_CTRL_OR: alu_out <= num_1 | num_2;
            `ALU_CTRL_AND: alu_out <= num_1 & num_2;
            `ALU_CTRL_NOR: alu_out <= ~(num_1 | num_2);

            default: alu_out <= 0;
            
        endcase

endmodule // Alu
