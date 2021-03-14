`include "Headers/Lengths.v"

module MStage (
    input clk,
    input reset,
    
    input forward_wb_m,
    
    input mem_read,
    input mem_write,
    
    input [`LEN_REG_FILE_ADDR - 1: 0] write_reg,
    
    input [`LEN_WORD - 1: 0] alu_out,
    input [`LEN_WORD - 1: 0] write_data_mem,
    input [`LEN_WORD - 1: 0] write_data_reg_wb_m,

    output [`LEN_WORD - 1: 0] read_data_mem
);
    
    wire [`LEN_WORD - 1: 0] write_data;
    
    Mux2To1 #(
        .LEN(`LEN_WORD)
    
    ) MuxWriteData (

        .sel(forward_wb_m),
        .in_0(write_data_mem),
        .in_1(write_data_reg_wb_m),
        // OUTPUTS
        .out(write_data)
    );

    DataMem #(
        .LEN_WORD(`LEN_WORD),
        .SIZE_MEM_CELL(`SIZE_MEM_CELL),
        .SIZE_MEM(`SIZE_MEM)

    ) DataMem (
    
        .clk(clk),
        .reset(reset),
        .read_en(mem_read),
        .write_en(mem_write),
        .address(alu_out),
        .in(write_data),
        // OUTPUTS
        .out(read_data_mem)
    );

endmodule // MStage
