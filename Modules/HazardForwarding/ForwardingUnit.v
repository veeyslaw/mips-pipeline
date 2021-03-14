module ForwardingUnit
#(
    parameter integer LEN_REG_FILE_ADDR = 1
)
// signal
(
    input reset,
    
    input [LEN_REG_FILE_ADDR - 1: 0] reg_1_id,
    input [LEN_REG_FILE_ADDR - 1: 0] reg_2_id,

    input [LEN_REG_FILE_ADDR - 1: 0] reg_1_ex,
    input [LEN_REG_FILE_ADDR - 1: 0] reg_2_ex,
    
    input [LEN_REG_FILE_ADDR - 1: 0] reg_2_m,
    input [LEN_REG_FILE_ADDR - 1: 0] reg_3_m,
    
    input [LEN_REG_FILE_ADDR - 1: 0] reg_3_wb,

    input branch,

    input mem_write_m,
    input reg_write_m,
    
    input mem_read_wb,
    input reg_write_wb,
    
    output reg forward_1_id,
    output reg forward_2_id,

    output reg [1: 0] forward_1_ex,
    output reg [1: 0] forward_2_ex,
    
    output reg forward_wb_m
);

    always @* begin
        if (reset) begin
            forward_1_ex <= 0;
            forward_2_ex <= 0;
            
        end
        else begin
            forward_1_ex <= 0;
            forward_2_ex <= 0;
    
            if (reg_write_m
                && (reg_3_m != 0)
                && (reg_3_m == reg_1_ex))
                
                forward_1_ex <= 'b10;
    
            if (reg_write_m
                && (reg_3_m != 0)
                && (reg_3_m == reg_2_ex))
                
                forward_2_ex <= 'b10;
    
            if (reg_write_wb
                && (reg_3_wb != 0)
                && !(reg_write_m
                        && (reg_3_m != 0)
                        && (reg_3_m == reg_1_ex))
                && (reg_3_wb == reg_1_ex))
                
                forward_1_ex <= 'b01;
    
            if (reg_write_wb
                && (reg_3_wb != 0)
                && !(reg_write_m
                        && (reg_3_m != 0)
                        && (reg_3_m == reg_2_ex))
                & (reg_3_wb == reg_2_ex))
                
                forward_2_ex <= 'b01;
        end
    end
    
    always @* begin
        if (reset) begin
            forward_1_id <= 0;
            forward_2_id <= 0;
            
        end
        else begin
            if (branch 
                && reg_write_m
                && (reg_3_m != 0)
                && (reg_3_m == reg_1_id))
                
                forward_1_id <= 1;
            else
                forward_1_id <= 0;
            
            if (branch
                && reg_write_m
                && (reg_3_m != 0)
                && (reg_3_m == reg_2_id))
                
                forward_2_id <= 1;
            else
                forward_2_id <= 0;
        end
    end
    
    always @* begin
        if (reset)
            forward_wb_m <= 0;
            
        else begin
            if (mem_read_wb
                && mem_write_m
                && (reg_3_wb != 0)
                && (reg_3_wb == reg_2_m))
                
                forward_wb_m <= 1;
                
            else
                forward_wb_m <= 0;
                
        end
    end

endmodule // ForwardingUnit
