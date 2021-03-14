module Register
#(
    parameter integer LEN = 1 // should be set to LEN_WORD
)
// signals
(
   input clk,
   input reset,
   
   input write_en,
   
   input [LEN - 1: 0] in,
   
   output reg [LEN - 1: 0] out
);

    always @(posedge clk) begin
        if (reset)
            out <= 0;
            
        else if (write_en)
            out <= in;
            
    end

endmodule // Register
