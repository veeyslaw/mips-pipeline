module Mux2To1
#(
    parameter integer LEN = 1 // should be set to LEN_WORD
)
// signals
(
    input sel,
    
    input [LEN - 1: 0] in_0,
    input [LEN - 1: 0] in_1,
    
    output [LEN - 1: 0] out
);

    assign out = (sel) ? in_1 : in_0;

endmodule // Mux2To1



module Mux3To1
#(
    parameter integer LEN = 1 // should be set to LEN_WORD
)
// signals
(
    input [1:0] sel,
    
    input [LEN - 1: 0] in_0,
    input [LEN - 1: 0] in_1,
    input [LEN - 1: 0] in_2,
    output [LEN - 1: 0] out
);

    assign out = (sel[1]) ? in_2 :
                 (sel[0]) ? in_1 : in_0;

endmodule // Mux3To1

