`include "Headers/Lengths.v"

module EXStage (
    input clk,
    input reset,
    
    input [1: 0] forward_1_ex,
    input [1: 0] forward_2_ex,
    
    input [`LEN_WORD - 1: 0] alu_out_m_ex,
    input [`LEN_WORD - 1: 0] write_data_reg_wb_ex,
    
    input [`LEN_WORD - 1: 0] read_data_1,
    input [`LEN_WORD - 1: 0] read_data_2,
    input [`LEN_WORD - 1: 0] extended_imm,
    
    input [`LEN_REG_FILE_ADDR - 1: 0] reg_2,
    input [`LEN_REG_FILE_ADDR - 1: 0] reg_3,
    
    input [2: 0] alu_op,
    input reg_dst,
    input alu_src,
    
    output [`LEN_WORD - 1: 0] alu_out,
    output alu_zero,
    
    output [`LEN_REG_FILE_ADDR - 1: 0] write_reg,
    output [`LEN_WORD - 1: 0] write_data_mem
);

    wire [`LEN_WORD - 1: 0] num_1;
    wire [`LEN_WORD - 1: 0] num_2;
    wire [2: 0] alu_ctrl;

    Mux3To1 #(
        .LEN(`LEN_WORD)

    ) MUXAluOp1 (

        .sel(forward_1_ex),
        .in_0(read_data_1),
        .in_1(write_data_reg_wb_ex),
        .in_2(alu_out_m_ex),
        // OUTPUTS
        .out(num_1)
    );

    Mux3To1 #(
        .LEN(`LEN_WORD)

    ) MUXWriteDataMem (

        .sel(forward_2_ex),
        .in_0(read_data_2),
        .in_1(write_data_reg_wb_ex),
        .in_2(alu_out_m_ex),
        // OUTPUTS
        .out(write_data_mem)
    );

    Mux2To1 #(
        .LEN(`LEN_WORD)
    
    ) MuxAluOp2 (

        .sel(alu_src),
        .in_0(write_data_mem),
        .in_1(extended_imm),
        // OUTPUTS
        .out(num_2)
    );

    Mux2To1 #(
        .LEN(`LEN_REG_FILE_ADDR)

    ) MuxDstReg (

        .sel(reg_dst),
        .in_0(reg_2),
        .in_1(reg_3),
        // OUTPUTS
        .out(write_reg)
    );

    AluControl AluControl (
        .alu_op(alu_op),
        .funct(extended_imm[5: 0]),
        // OUTPUTS
        .alu_ctrl(alu_ctrl)
    );

    Alu #(
        .LEN(`LEN_WORD)

    ) Alu (

        .num_1(num_1),
        .num_2(num_2),
        .alu_ctrl(alu_ctrl),
        // OUTPUTS
        .alu_out(alu_out),
        .alu_zero(alu_zero)
    );

endmodule // EXStage
