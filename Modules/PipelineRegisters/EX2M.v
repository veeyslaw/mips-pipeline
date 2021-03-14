module EX2M
#(
    parameter integer LEN_WORD = 1,
    parameter integer LEN_REG_FILE_ADDR = 1
)
// signals
(
    input clk,
    input reset,
    
    input [LEN_WORD - 1: 0] next_alu_out,
    input next_alu_zero,
    
    input [LEN_REG_FILE_ADDR - 1: 0] next_write_reg,
    input [LEN_WORD - 1: 0] next_write_data_mem,
    input [LEN_REG_FILE_ADDR - 1: 0] next_reg_2,
    
    // M
    input next_mem_read,
    input next_mem_write,
    
    // WB
    input next_reg_write,
    input next_mem_to_reg,
    
    output reg [LEN_WORD - 1: 0] alu_out,
    output reg alu_zero,
    
    output reg [LEN_REG_FILE_ADDR - 1: 0] write_reg,
    output reg [LEN_WORD - 1: 0] write_data_mem,
    output reg [LEN_REG_FILE_ADDR - 1: 0] reg_2,
    
    // M
    output reg mem_read,
    output reg mem_write,

    // WB
    output reg reg_write,
    output reg mem_to_reg
);

    always @(posedge clk)
        if (reset)
            {alu_out, alu_zero, write_reg, write_data_mem, reg_2,
        mem_read, mem_write, reg_write, mem_to_reg} <= 0;
        
        else begin
            alu_out <= next_alu_out;
            alu_zero <= next_alu_zero;
            write_reg <= next_write_reg;
            write_data_mem <= next_write_data_mem;
            reg_2 <= next_reg_2;
            mem_read <= next_mem_read;
            mem_write <= next_mem_write;
            reg_write <= next_reg_write;
            mem_to_reg <= next_mem_to_reg;
            
        end

endmodule // EX2M
