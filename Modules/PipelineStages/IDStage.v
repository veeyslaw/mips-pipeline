`include "Headers/Lengths.v"
`include "Headers/Opcodes.v"

module IDStage(
    input neg_clk,
    input reset,
    
    input reg_write_apply,
    
    input forward_1_id,
    input forward_2_id,
    input [`LEN_WORD - 1: 0] alu_out_m_id,

    input [`LEN_WORD - 1: 0] inced_pc,
    input [`LEN_WORD - 1: 0] instruction,
    
    input reg_write_wb,
    input [`LEN_REG_FILE_ADDR - 1: 0] write_reg_wb,
    input [`LEN_WORD - 1: 0] write_data_reg,

    output [`LEN_WORD - 1: 0] read_data_1,
    output [`LEN_WORD - 1: 0] read_data_2,

    output [`LEN_WORD - 1: 0] extended_imm,
    output [`LEN_WORD - 1: 0] jump_pc,

    output branch,
    output pc_src,

    output [2: 0] alu_op,
    output reg_dst,
    output alu_src,
    output mem_read,
    output mem_write,
    output reg_write,
    output mem_to_reg
);

    wire [`LEN_WORD - 1: 0] branch_data_1;
    wire [`LEN_WORD - 1: 0] branch_data_2;
    wire equal;
    
    wire [`LEN_WORD - 1: 0] j_type_extended_imm;
    wire [`LEN_WORD - 1: 0] offset;
    wire [`LEN_WORD - 1: 0] shifted_offset;
    
    wire is_j_type;
    
    assign is_j_type = instruction[31: 26] == `OP_J;

    assign pc_src = branch & equal | is_j_type;
    
    EqualityChecker #(
        .LEN(`LEN_WORD)
    
    ) EqualityChecker (
    
        .num_1(branch_data_1),
        .num_2(branch_data_2),
        // OUTPUTS
        .result(equal)
    );
    
    Mux2To1 #(
        .LEN(`LEN_WORD)
    
    ) MuxBranchData1 (
        
        .sel(forward_1_id),
        .in_0(read_data_1),
        .in_1(alu_out_m_id),
        // OUTPUTS
        .out(branch_data_1)
    );
    
    Mux2To1 #(
        .LEN(`LEN_WORD)
    
    ) MuxBranchData2 (
    
        .sel(forward_2_id),
        .in_0(read_data_2),
        .in_1(alu_out_m_id),
        // OUTPUTS
        .out(branch_data_2)
    );
    
    ControlUnit #(
        .LEN_OP_CODE(`LEN_OP_CODE)
    
    ) ControlUnit (

        .reset(reset),
        .opcode(instruction[31: 26]),
        // OUTPUTS
        .branch(branch),
        .alu_op(alu_op),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .mem_to_reg(mem_to_reg)
    );

    RegFile #(
        .LEN_REG_FILE_ADDR(`LEN_REG_FILE_ADDR),
        .SIZE_REG_FILE(`SIZE_REG_FILE),
        .LEN_WORD(`LEN_WORD)

    ) RegFile (
        
        .clk(neg_clk),
        .reset(reset),
        .write_en(reg_write_wb),
        .src_1(instruction[25: 21]),
        .src_2(instruction[20: 16]),
        .dst(write_reg_wb),
        .write_data(write_data_reg),
        // OUTPUTS
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    SignExtend #(
        .EXTEND_FROM(`EXTEND_FROM),
        .EXTEND_TO(`EXTEND_TO)

    ) ImmSignExtend (

        .in(instruction[15: 0]),
        // OUTPUTS
        .out(extended_imm)
    );
    
    ShiftLeft #(
        .LEN(`LEN_WORD),
        .SH_AMT(2)
    
    ) OffsetShiftLeft (

        .in(offset),
        // OUTPUTS
        .out(shifted_offset)
    );


    Adder #(
        .LEN(`LEN_WORD)

    ) OffsetAdder (
    
        .num_1(inced_pc),
        .num_2(shifted_offset),
        // OUTPUTS
        .result(jump_pc)
    );
    
    SignExtend #(
        .EXTEND_FROM(`J_EXTEND_FROM),
        .EXTEND_TO(`EXTEND_TO)

    ) JTypeImmSignExtend (

        .in(instruction[25: 0]),
        // OUTPUTS
        .out(j_type_extended_imm)
    );
    
    Mux2To1 #(
        .LEN(`LEN_WORD)
    
    ) MuxImmType (

        .sel(is_j_type),
        .in_0(extended_imm),
        .in_1(j_type_extended_imm),
        // OUTPUTS
        .out(offset)
    );

endmodule // IDStage
