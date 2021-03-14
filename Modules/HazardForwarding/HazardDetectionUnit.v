`include "Headers/Opcodes.v"
`include "Headers/Lengths.v"

module HazardDetectionUnit
#(
    parameter integer LEN_REG_FILE_ADDR = 1,
    parameter integer LEN_OP_CODE = 1,
    parameter integer OP_J = 1
)
// signals
(
    input reset,
    
    input [LEN_OP_CODE - 1: 0] opcode,

    input branch,
    
    input mem_write_id,
    
    input mem_read_ex,
    input reg_write_ex,
    
    input mem_read_m,
    
    input [LEN_REG_FILE_ADDR - 1: 0] reg_1_id,
    input [LEN_REG_FILE_ADDR - 1: 0] reg_2_id,
    
    input [LEN_REG_FILE_ADDR - 1: 0] reg_2_ex,
    input [LEN_REG_FILE_ADDR - 1: 0] write_reg_ex,
    
    input [LEN_REG_FILE_ADDR - 1: 0] write_reg_m,

    output reg stall
);

    // mai multe paranteze pentru a fi sigur ca nu e aici problema
    always @* begin
        if (reset | opcode == OP_J)
            stall <= 0;
        else begin
            stall <= 0;
            
            if (mem_read_ex
                && ! mem_write_id
                && (reg_2_ex != 0)
                    && ((reg_2_ex == reg_1_id)
                        || (reg_2_ex == reg_2_id)))
            
                stall <= 1;
            
            if (branch
                && mem_read_m
                && (write_reg_m != 0)
                && ((write_reg_m == reg_1_id)
                    || (write_reg_m == reg_2_id)))
                
                stall <= 1;
            
            if (branch
                && reg_write_ex
                && (write_reg_ex != 0)
                && ((write_reg_ex == reg_1_id)
                    || (write_reg_ex == reg_2_id)))
                
                stall <= 1;
        end
    end

endmodule // HazardDetectionUnit
