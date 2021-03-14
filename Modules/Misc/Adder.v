module Adder
#(
    parameter integer LEN = 1 // should be set to LEN_WORD
)
// signals
(
    input [LEN - 1: 0] num_1,
    input [LEN - 1: 0] num_2,
    
    output [LEN - 1: 0] result
);
    
    assign result = num_1 + num_2;
    
endmodule // Adder



module Incer
#(
    parameter integer LEN = 1 // should be set to LEN_WORD
)
// signals
(
    input [LEN - 1: 0] num,
    
    output [LEN - 1: 0] result
);

    assign result = num + 4;

endmodule // Incer
