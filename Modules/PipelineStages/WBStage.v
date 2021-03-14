`include "Headers/Lengths.v"

module WBStage (
    input [`LEN_WORD - 1: 0] read_data_mem,
    input [`LEN_WORD - 1: 0] alu_out,
    
    input mem_to_reg,

    output [`LEN_WORD - 1: 0] write_data_reg
);

    Mux2To1 #(
        .LEN(`LEN_WORD)

    ) WriteBackMux (
        
        .sel(mem_to_reg),
        .in_0(alu_out),
        .in_1(read_data_mem),
        // OUTPUTS
        .out(write_data_reg)
    );

endmodule // WBStage
