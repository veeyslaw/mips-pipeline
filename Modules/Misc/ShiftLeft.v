module ShiftLeft
#(
    parameter integer LEN = 1,
    parameter integer SH_AMT = 1
)
// signals
(
    input [LEN - 1: 0] in,
    
    output [LEN - 1: 0] out
);

    assign out = in << SH_AMT;

endmodule // ShiftLeft
