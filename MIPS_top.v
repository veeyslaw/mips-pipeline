`include "Headers/Lengths.v"
`include "Headers/Opcodes.v"

module MIPS_top(
    input clk,
    input reset
);
    ///////// negated clock for reg file write sync
    wire neg_clk;
    
    ///////// IF Stage
    wire pc_src;
    wire [`LEN_WORD - 1: 0] inced_pc_if;
    wire [`LEN_WORD - 1: 0] instruction_if;

    ///////// ID Stage
    wire [`LEN_WORD - 1: 0] inced_pc_id;
    wire [`LEN_WORD - 1: 0] instruction_id;
    
    wire branch;
    
    wire [`LEN_WORD - 1: 0] read_data_1_id;
    wire [`LEN_WORD - 1: 0] read_data_2_id;

    wire [`LEN_WORD - 1: 0] extended_imm_id;

    // ex
    wire [2: 0] alu_op_id;
    wire reg_dst_id;
    wire alu_src_id;

    // m
    wire mem_read_id;
    wire mem_write_id;
    
    // wb
    wire reg_write_id;
    wire mem_to_reg_id;
    wire [`LEN_WORD - 1: 0] jump_pc;

    ///////// EX Stage
    wire [`LEN_WORD - 1: 0] read_data_1_ex;
    wire [`LEN_WORD - 1: 0] read_data_2_ex;

    wire [`LEN_WORD - 1: 0] extended_imm_ex;
    
    wire [`LEN_REG_FILE_ADDR - 1: 0] reg_1_ex;
    wire [`LEN_REG_FILE_ADDR - 1: 0] reg_2_ex;
    wire [`LEN_REG_FILE_ADDR - 1: 0] reg_3_ex;
    
    wire [`LEN_WORD - 1: 0] alu_out_ex;
    wire alu_zero_ex;

    wire [`LEN_REG_FILE_ADDR - 1: 0] write_reg_ex;
    wire [`LEN_WORD - 1: 0] write_data_mem_ex;

    // ex
    wire [2: 0] alu_op_ex;
    wire reg_dst_ex;
    wire alu_src_ex;

    // m
    wire mem_read_ex;
    wire mem_write_ex;
    
    // wb
    wire reg_write_ex;
    wire mem_to_reg_ex;

    ///////// M Stage
    wire [`LEN_WORD - 1: 0] alu_out_m;
    wire alu_zero_m;
    
    wire [`LEN_REG_FILE_ADDR - 1: 0] reg_2_m;
    wire [`LEN_REG_FILE_ADDR - 1: 0] write_reg_m;

    wire [`LEN_WORD - 1: 0] read_data_mem_m;
    
    wire [`LEN_WORD - 1: 0] write_data_mem_m;
    
    // m
    wire mem_read_m;
    wire mem_write_m;

    // wb
    wire reg_write_m;
    wire mem_to_reg_m;

    ///////// WB Stage
    wire [`LEN_WORD - 1: 0] read_data_mem_wb;
    wire [`LEN_WORD - 1: 0] alu_out_wb;
    
    wire [`LEN_REG_FILE_ADDR - 1: 0] write_reg_wb;
    wire [`LEN_WORD - 1: 0] write_data_reg;

    // m
    wire mem_read_wb;
    
    // wb
    wire mem_to_reg_wb;
    wire reg_write_wb;

    
    ///////// FORWARDING Unit
    wire [1: 0] forward_1_ex;
    wire [1: 0] forward_2_ex;
    
    wire forward_1_id;
    wire forward_2_id;
    
    wire forward_wb_m;
    
    ///////// HAZARD Detection
    wire stall;
    wire id2ex_flush;
    
    ///////////////////////////////////////////
    //            CODE ZONE                  //
    ///////////////////////////////////////////
    
    assign id2ex_flush = stall | pc_src;
    
    assign neg_clk = ~clk;

    // HAZARD AND FORWARDING
    
    ForwardingUnit #(
        .LEN_REG_FILE_ADDR(`LEN_REG_FILE_ADDR)
        
    ) ForwardingUnit (
        
        .reset(reset),
        .reg_1_id(instruction_id[25: 21]),
        .reg_2_id(instruction_id[20: 16]),
        .reg_1_ex(reg_1_ex),
        .reg_2_ex(reg_2_ex),
        .reg_2_m(reg_2_m),
        .reg_3_m(write_reg_m),
        .reg_3_wb(write_reg_wb),
        .branch(branch),
        .mem_write_m(mem_write_m),
        .reg_write_m(reg_write_m),
        .mem_read_wb(mem_read_wb),
        .reg_write_wb(reg_write_wb),
        // OUTPUTS
        .forward_1_id(forward_1_id),
        .forward_2_id(forward_2_id),
        .forward_1_ex(forward_1_ex),
        .forward_2_ex(forward_2_ex),
        .forward_wb_m(forward_wb_m)
    );
    
    HazardDetectionUnit #(
        .LEN_REG_FILE_ADDR(`LEN_REG_FILE_ADDR),
        .LEN_OP_CODE(`LEN_OP_CODE),
        .OP_J(`OP_J)
    
    ) HazardDetectionUnit (
        
        .reset(reset),
        .opcode(instruction_id[26: 21]),
        .branch(branch),
        .mem_write_id(mem_write_id),
        .mem_read_ex(mem_read_ex),
        .reg_write_ex(reg_write_ex),
        .mem_read_m(mem_read_m),
        .reg_1_id(instruction_id[25: 21]),
        .reg_2_id(instruction_id[20: 16]),
        .reg_2_ex(reg_2_ex),
        .write_reg_ex(write_reg_ex),
        .write_reg_m(write_reg_m),
        // OUTPUTS
        .stall(stall)
    );

    // PIPELINE STAGES

    IFStage IFStage (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .pc_src(pc_src),
        .jump_pc(jump_pc),
        // OUTPUTS
        .inced_pc(inced_pc_if),
        .instruction(instruction_if)
    );

    IDStage IDStage (
        .neg_clk(neg_clk),
        .reset(reset),
        .forward_1_id(forward_1_id),
        .forward_2_id(forward_2_id),
        .alu_out_m_id(alu_out_m),
        .inced_pc(inced_pc_id),
        .instruction(instruction_id),
        .reg_write_wb(reg_write_wb),
        .write_reg_wb(write_reg_wb),
        .write_data_reg(write_data_reg),
        // OUTPUTS
        .read_data_1(read_data_1_id),
        .read_data_2(read_data_2_id),
        .extended_imm(extended_imm_id),
        .jump_pc(jump_pc),
        .branch(branch),
        .pc_src(pc_src),
        .alu_op(alu_op_id),
        .reg_dst(reg_dst_id),
        .alu_src(alu_src_id),
        .mem_read(mem_read_id),
        .mem_write(mem_write_id),
        .reg_write(reg_write_id),
        .mem_to_reg(mem_to_reg_id)
    );

    EXStage EXStage (
        .clk(clk),
        .reset(reset),
        .forward_1_ex(forward_1_ex),
        .forward_2_ex(forward_2_ex),
        .alu_out_m_ex(alu_out_m),
        .write_data_reg_wb_ex(write_data_reg),
        .read_data_1(read_data_1_ex),
        .read_data_2(read_data_2_ex),
        .extended_imm(extended_imm_ex),
        .reg_2(reg_2_ex),
        .reg_3(reg_3_ex),
        .alu_op(alu_op_ex),
        .reg_dst(reg_dst_ex),
        .alu_src(alu_src_ex),
        // OUTPUTS
        .alu_out(alu_out_ex),
        .alu_zero(alu_zero_ex),
        .write_reg(write_reg_ex),
        .write_data_mem(write_data_mem_ex)
    );

    MStage MStage (
    
        .clk(clk),
        .reset(reset),
        .forward_wb_m(forward_wb_m),
        .mem_read(mem_read_m),
        .mem_write(mem_write_m),
        .write_reg(write_reg_m),
        .alu_out(alu_out_m),
        .write_data_mem(write_data_mem_m),
        .write_data_reg_wb_m(write_data_reg),
        // OUTPUTS
        .read_data_mem(read_data_mem_m)
    );

    WBStage WBStage (
        .read_data_mem(read_data_mem_wb),
        .alu_out(alu_out_wb),
        .write_data_reg(write_data_reg),
        // OUTPUTS
        .mem_to_reg(mem_to_reg_wb)
    );

    // PIPELINE REGISTERS

    IF2ID #(
        .LEN(`LEN_WORD)
    
    ) IF2ID (

        .clk(clk),
        .reset(reset),
        .flush(pc_src),
        .stall(stall),
        .next_inced_pc(inced_pc_if),
        .next_instruction(instruction_if),
        // OUTPUTS
        .inced_pc(inced_pc_id),
        .instruction(instruction_id)
    );

    ID2EX #(
        .LEN_WORD(`LEN_WORD),
        .LEN_REG_FILE_ADDR(`LEN_REG_FILE_ADDR)

    ) ID2EX (

        .clk(clk),
        .reset(reset),
        .flush(id2ex_flush),
        .next_read_data_1(read_data_1_id),
        .next_read_data_2(read_data_2_id),
        .next_extended_imm(extended_imm_id),
        .next_reg_1(instruction_id[25: 21]),
        .next_reg_2(instruction_id[20: 16]),
        .next_reg_3(instruction_id[15: 11]),
        .next_alu_op(alu_op_id),
        .next_reg_dst(reg_dst_id),
        .next_alu_src(alu_src_id),
        .next_mem_read(mem_read_id),
        .next_mem_write(mem_write_id),
        .next_reg_write(reg_write_id),
        .next_mem_to_reg(mem_to_reg_id),
        // OUTPUTS
        .read_data_1(read_data_1_ex),
        .read_data_2(read_data_2_ex),
        .extended_imm(extended_imm_ex),
        .reg_1(reg_1_ex),
        .reg_2(reg_2_ex),
        .reg_3(reg_3_ex),
        .alu_op(alu_op_ex),
        .reg_dst(reg_dst_ex),
        .alu_src(alu_src_ex),
        .mem_read(mem_read_ex),
        .mem_write(mem_write_ex),
        .reg_write(reg_write_ex),
        .mem_to_reg(mem_to_reg_ex)
    );

    EX2M #(
        .LEN_WORD(`LEN_WORD),
        .LEN_REG_FILE_ADDR(`LEN_REG_FILE_ADDR)

    ) EX2M (
        .clk(clk),
        .reset(reset),
        .next_alu_out(alu_out_ex),
        .next_alu_zero(alu_zero_ex),
        .next_write_reg(write_reg_ex),
        .next_write_data_mem(write_data_mem_ex),
        .next_reg_2(reg_2_ex),
        .next_mem_read(mem_read_ex),
        .next_mem_write(mem_write_ex),
        .next_reg_write(reg_write_ex),
        .next_mem_to_reg(mem_to_reg_ex),
        // OUTPUTS
        .alu_out(alu_out_m),
        .alu_zero(alu_zero_m),
        .write_reg(write_reg_m),
        .write_data_mem(write_data_mem_m),
        .reg_2(reg_2_m),
        .mem_read(mem_read_m),
        .mem_write(mem_write_m),
        .reg_write(reg_write_m),
        .mem_to_reg(mem_to_reg_m)
    );

    M2WB #(
        .LEN_WORD(`LEN_WORD),
        .LEN_REG_FILE_ADDR(`LEN_REG_FILE_ADDR)

    ) M2WB (

        .clk(clk),
        .reset(reset),
        .next_read_data_mem(read_data_mem_m),
        .next_alu_out(alu_out_m),
        .next_write_reg(write_reg_m),
        .next_mem_read(mem_read_m),
        .next_reg_write(reg_write_m),
        .next_mem_to_reg(mem_to_reg_m),
        // OUTPUTS
        .read_data_mem(read_data_mem_wb),
        .alu_out(alu_out_wb),
        .write_reg(write_reg_wb),
        .mem_read(mem_read_wb),
        .reg_write(reg_write_wb),
        .mem_to_reg(mem_to_reg_wb)
    );

endmodule // MIPS_top
