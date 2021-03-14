module SignExtend
#(
    parameter integer EXTEND_FROM = 1,
    parameter integer EXTEND_TO = 2
)
// signals
(
    input [EXTEND_FROM - 1: 0] in,
    
    output [EXTEND_TO - 1: 0] out
);

    assign out = { { 16{ in[15] } }, in[15: 0]};

endmodule // SignExtend
