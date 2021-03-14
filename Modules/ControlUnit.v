`include "Headers/Opcodes.v"
`include "Headers/ALUOps.v"

module ControlUnit
#(
    parameter integer LEN_OP_CODE = 1
)
// signals
(
    input reset,
    
    input [LEN_OP_CODE - 1: 0] opcode,

    // EX
    output reg branch,
    output reg [2: 0] alu_op,
    output reg reg_dst,
    output reg alu_src,

    // M
    output reg mem_read,
    output reg mem_write,

    // WB
    output reg reg_write,
    output reg mem_to_reg
);
    
    always @*
        if (reset)
            {alu_op, reg_dst, alu_src, branch, 
        mem_read, mem_write, reg_write, mem_to_reg} =
                {`ALU_OP_NOP, `CTRL_SIG_NOP};
        else 
            case (opcode)
            
                `OP_R_TYPE: {alu_op, reg_dst, alu_src, branch, 
            mem_read, mem_write, reg_write, mem_to_reg} =
                    {`ALU_OP_R_TYPE, `CTRL_SIG_R_TYPE};
            
                `OP_ADDI: {alu_op, reg_dst, alu_src, branch, mem_read, 
            mem_write, reg_write, mem_to_reg} =
                    {`ALU_OP_ADD, `CTRL_SIG_ADDI};
            
                `OP_ORI: {alu_op, reg_dst, alu_src, branch, mem_read, 
            mem_write, reg_write, mem_to_reg} =
                    {`ALU_OP_OR, `CTRL_SIG_ORI};
            
                `OP_ANDI: {alu_op, reg_dst, alu_src, branch, mem_read, 
            mem_write, reg_write, mem_to_reg} =
                    {`ALU_OP_AND, `CTRL_SIG_ANDI};
            
                `OP_BEQ: {alu_op, reg_dst, alu_src, branch, mem_read, 
            mem_write, reg_write, mem_to_reg} =
                    {`ALU_OP_SUB, `CTRL_SIG_BEQ};
            
                `OP_LW: {alu_op, reg_dst, alu_src, branch, mem_read, 
            mem_write, reg_write, mem_to_reg} =
                    {`ALU_OP_ADD, `CTRL_SIG_LW};
            
                `OP_SW: {alu_op, reg_dst, alu_src, branch, mem_read, 
            mem_write, reg_write, mem_to_reg} =
                    {`ALU_OP_ADD, `CTRL_SIG_SW};
            
                `OP_J: {alu_op, reg_dst, alu_src, branch, mem_read, 
            mem_write, reg_write, mem_to_reg} =
                    {`ALU_OP_NOP, `CTRL_SIG_J};
            
                default: {alu_op, reg_dst, alu_src, branch, mem_read, 
            mem_write, reg_write, mem_to_reg} = 10'bx;
        
        endcase

endmodule // ControlUnit
