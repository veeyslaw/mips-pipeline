// ROM

module InstrMem
#(
    parameter integer LEN_WORD = 32,
    parameter integer SIZE_MEM_CELL = 32,
    parameter integer SIZE_MEM = 256
)
// signals
(
    input reset,
    
    input [LEN_WORD - 1: 0] address,
    
    output [LEN_WORD - 1: 0] out
);

    integer i;
    
    reg [SIZE_MEM_CELL - 1: 0] instr_mem [0: SIZE_MEM - 1];
    
    assign out = instr_mem[address >> 2];

// EDIT BEYOND THIS POINT AT THE RISK OF BREAKING PROGRAM LOADING //
    
    always @(posedge reset) begin
        instr_mem[0] <= 'b00100000000010000000000000000110;
        instr_mem[1] <= 'b00000001000000001000000000100000;
        instr_mem[2] <= 'b00000000000000000100100000100000;
        instr_mem[3] <= 'b00010001001100000000000000000110;
        instr_mem[4] <= 'b00000001000010010101000000100000;
        instr_mem[5] <= 'b00000000000010010101100000100000;
        instr_mem[6] <= 'b10001101010011000000000000000000;
        instr_mem[7] <= 'b10100101011011000000000000000000;
        instr_mem[8] <= 'b00100001001010010000000000000001;
        instr_mem[9] <= 'b00001011111111111111111111111001;
        instr_mem[10] <= 'b10001100000100010000000000000000;
        instr_mem[11] <= 'b00000000000100011001000000100010;
        instr_mem[12] <= 'b10001100000100110000000000000000;
        instr_mem[13] <= 'b00010010011010000000000000000001;
        instr_mem[14] <= 'b00000001000010101010000000100100;
        instr_mem[15] <= 'b00000001000010111010100000100100;
        instr_mem[16] <= 'b00000001000010011011000000100111;
        instr_mem[17] <= 'b00000001011010101011100000100101;
        instr_mem[18] <= 'b00010010110010000000000000000001;
        instr_mem[19] <= 'b00110101000110000000000000001000;
        instr_mem[20] <= 'b00110001000111110000000000000110;
        for (i = 21; i < SIZE_MEM; i = i + 1)
            instr_mem[i] <= 0;
    end

endmodule // InstrMem