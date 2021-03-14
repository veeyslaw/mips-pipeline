module ID2EX
#(
    parameter integer LEN_WORD = 1,
    parameter integer LEN_REG_FILE_ADDR = 1
)
// signals
(
    input clk,
    input reset,
    
    input flush,
    
    input [LEN_WORD - 1: 0] next_read_data_1,
    input [LEN_WORD - 1: 0] next_read_data_2,
    
    input [LEN_WORD - 1: 0] next_extended_imm,
    
    input [LEN_REG_FILE_ADDR - 1: 0] next_reg_1,
    input [LEN_REG_FILE_ADDR - 1: 0] next_reg_2,
    input [LEN_REG_FILE_ADDR - 1: 0] next_reg_3,
    
    // EX
    input [2: 0] next_alu_op,
    input next_reg_dst,
    input next_alu_src,
    
    // M
    input next_mem_read,
    input next_mem_write,
    
    // WB
    input next_reg_write,
    input next_mem_to_reg,
    
    
    output reg [LEN_WORD - 1: 0] read_data_1,
    output reg [LEN_WORD - 1: 0] read_data_2,
    
    output reg [LEN_WORD - 1: 0] extended_imm,
    
    output reg [LEN_REG_FILE_ADDR - 1: 0] reg_1,
    output reg [LEN_REG_FILE_ADDR - 1: 0] reg_2,
    output reg [LEN_REG_FILE_ADDR - 1: 0] reg_3,

    // EX
    output reg [2: 0] alu_op,
    output reg reg_dst,
    output reg alu_src,
    
    //M
    output reg mem_read,
    output reg mem_write,

    // WB
    output reg reg_write,
    output reg mem_to_reg
);

    always @(posedge clk)
        if (reset || flush) begin
            {read_data_1, read_data_2, extended_imm, reg_1, reg_2, reg_3 ,alu_op, reg_dst, alu_src, mem_read, mem_write, reg_write, mem_to_reg} <= 0;
            
        end
        else begin
            read_data_1 <= next_read_data_1;
            read_data_2 <= next_read_data_2;
            extended_imm <= next_extended_imm;
            reg_1 <= next_reg_1;
            reg_2 <= next_reg_2;
            reg_3 <= next_reg_3;
            alu_op <= next_alu_op;
            reg_dst <= next_reg_dst;
            alu_src <= next_alu_src;
            mem_read <= next_mem_read;
            mem_write <= next_mem_write;
            reg_write <= next_reg_write;
            mem_to_reg <= next_mem_to_reg;
            
        end

endmodule // ID2EX
