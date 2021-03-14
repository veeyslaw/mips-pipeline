module EqualityChecker
#(
    parameter integer LEN = 1 // should be set to LEN_WORD
)
// signals
(
    input [LEN - 1: 0] num_1,
    input [LEN - 1: 0] num_2,
    
    output result
);
    
    assign result = ~ ( | (num_1 ^ num_2));
    
endmodule // EqualityChecker
