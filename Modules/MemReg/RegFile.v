module RegFile
#(
    parameter integer LEN_REG_FILE_ADDR = 1,
    parameter integer SIZE_REG_FILE = 1,
    parameter integer LEN_WORD = 1
)
// signals
(
    input clk,
    input reset,
    
    input write_en,
    
    input [LEN_REG_FILE_ADDR - 1: 0] src_1,
    input [LEN_REG_FILE_ADDR - 1: 0] src_2,
    input [LEN_REG_FILE_ADDR - 1: 0] dst,
    
    input [LEN_WORD - 1: 0] write_data,
    
    output [LEN_WORD - 1: 0] read_data_1,
    output [LEN_WORD - 1: 0] read_data_2
);

    integer i;
    
    reg [LEN_WORD - 1: 0] reg_file [0: SIZE_REG_FILE - 1];

    assign read_data_1 = reg_file[src_1];
    assign read_data_2 = reg_file[src_2];

    always @(posedge clk) begin
        if (reset)
            for (i = 0; i < LEN_WORD; i = i + 1)
                reg_file[i] <= 0;
                
        else if (write_en)
            reg_file[dst] <= write_data;

        reg_file[0] <= 0;
        
    end
    
    initial begin
        #1000000
            $writememh("dump_reg_file.txt", reg_file);
    end

endmodule // RegFile
