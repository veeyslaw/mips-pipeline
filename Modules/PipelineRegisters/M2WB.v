module M2WB
#(
    parameter integer LEN_WORD = 1,
    parameter integer LEN_REG_FILE_ADDR = 1
)
// stages
(
    input clk,
    input reset,
    
    input [LEN_WORD - 1: 0] next_read_data_mem,
    input [LEN_WORD - 1: 0] next_alu_out,
    
    input [LEN_REG_FILE_ADDR - 1: 0] next_write_reg,
    
    input next_mem_read,
    input next_reg_write,
    input next_mem_to_reg,
    
    output reg [LEN_WORD - 1: 0] read_data_mem,
    output reg [LEN_WORD - 1: 0] alu_out,

    output reg [LEN_REG_FILE_ADDR - 1: 0] write_reg,

    output reg mem_read,
    output reg reg_write,
    output reg mem_to_reg
);

    always @(posedge clk)
        if (reset)
            {read_data_mem, alu_out, write_reg,
                mem_read, reg_write, mem_to_reg} <= 0;
                
        else begin
            read_data_mem <= next_read_data_mem;
            alu_out <= next_alu_out;
            write_reg <= next_write_reg;
            mem_read <= next_mem_read;
            reg_write <= next_reg_write;
            mem_to_reg <= next_mem_to_reg;
            
        end

endmodule // M2WB
