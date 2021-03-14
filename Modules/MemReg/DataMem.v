// RAM

module DataMem
#(
    parameter integer LEN_WORD = 1,
    parameter integer SIZE_MEM_CELL = 1,
    parameter integer SIZE_MEM = 1
)
// signals
(
    input clk,
    input reset,
    
    input read_en,
    input write_en,
    
    input [LEN_WORD - 1: 0] address,
    input [LEN_WORD - 1: 0] in,
    output [LEN_WORD - 1: 0] out
);

    integer i;
    
    reg [SIZE_MEM_CELL - 1: 0] data_mem [0: SIZE_MEM - 1];
    
    assign out = read_en ? data_mem[address] : 0;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 30; i = i + 1)
                data_mem[i] <= i;
                
            for (i = 30; i < SIZE_MEM; i = i + 1)
                data_mem[i] <= 0;
                
        end
        else if (write_en)
            data_mem[address] <= in;
            
    end
    
    initial begin
        #1000000
            $writememh("dump_data_mem.txt", data_mem);
    end

endmodule // DataMem
