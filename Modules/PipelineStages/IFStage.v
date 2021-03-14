`include "Headers/Lengths.v"

module IFStage (
    input clk,
    input reset,
    
    input stall,
    
    input pc_src,
    input [`LEN_WORD - 1: 0] jump_pc,
    
    output [`LEN_WORD - 1: 0] inced_pc,
    output [`LEN_WORD - 1: 0] instruction
);
    
    wire [`LEN_WORD - 1: 0] pc;
    wire [`LEN_WORD - 1: 0] selected_pc;

    Mux2To1 #(.LEN(`LEN_WORD)) PCSelector (
        .sel(pc_src),
        .in_0(inced_pc),
        .in_1(jump_pc),
        // OUTPUTS
        .out(selected_pc)
    );

    Incer #(.LEN(`LEN_WORD)) PCInc4 (
        .num(pc),
        // OUTPUTS
        .result(inced_pc)
    );

    Register #(.LEN(`LEN_WORD)) PCReg (
        .clk(clk),
        .reset(reset),
        .write_en(~stall),
        .in(selected_pc),
        // OUTPUTS
        .out(pc)
    );

    InstrMem #(
        .LEN_WORD(`LEN_WORD),
        .SIZE_MEM_CELL(`SIZE_MEM_CELL),
        .SIZE_MEM(`SIZE_MEM)

    ) InstrMem (

        .reset(reset) ,
        .address(pc),
        // OUTPUTS
        .out(instruction)
    );

endmodule // IFStage
