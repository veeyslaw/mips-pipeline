`timescale 1ps/1ps

// clock period = 200ps
// => clock speed = 5 GHz
// => Intel i9 9900k one core on max turbo speed - wow

module TestBench ();
    reg clk;
    reg reset;
    
    MIPS_top MIPS_top(
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk <= 0;
        forever #100 clk = ~clk;
    end

    initial begin
        reset <= 1;
        
        #150
        reset <= 0;
    end

    initial begin
        $dumpfile("TestBench.vcd");
        $dumpvars(0, TestBench);
        
        #1000000
        $finish;
    end
endmodule // TestBench
