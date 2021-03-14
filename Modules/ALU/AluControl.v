`include "Headers/Functs.v"
`include "Headers/ALUControls.v"
`include "Headers/ALUOps.v"

module AluControl (
    input [2: 0] alu_op,
    input [5: 0] funct,

    output reg [2: 0] alu_ctrl
);

    always @(alu_op or funct)
        case (alu_op)
        
            `ALU_OP_ADD: alu_ctrl <= `ALU_CTRL_ADD;
            `ALU_OP_OR: alu_ctrl <= `ALU_CTRL_OR;
            `ALU_OP_AND: alu_ctrl <= `ALU_CTRL_AND;
            `ALU_OP_SUB: alu_ctrl <= `ALU_CTRL_SUB;
            `ALU_OP_NOP: alu_ctrl <= `ALU_CTRL_NOP;

            `ALU_OP_R_TYPE: case (funct)
            
                `FUNCT_ADD: alu_ctrl <= `ALU_CTRL_ADD;
                `FUNCT_SUB: alu_ctrl <= `ALU_CTRL_SUB;
                `FUNCT_NOR: alu_ctrl <= `ALU_CTRL_NOR;
                `FUNCT_AND: alu_ctrl <= `ALU_CTRL_AND;
                `FUNCT_OR: alu_ctrl <= `ALU_CTRL_OR;

                default: alu_ctrl <= 3'bx;
                
            endcase

            default: alu_ctrl <= 3'bx;
            
        endcase

endmodule // AluControl
