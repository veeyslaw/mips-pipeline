// {reg_dst, alu_src, branch, mem_read, mem_write, reg_write, mem_to_reg}

`define CTRL_SIG_NOP		7'b0_0_0_0_0_0_0
`define CTRL_SIG_R_TYPE		7'b1_0_0_0_0_1_0
`define CTRL_SIG_ADDI		7'b0_1_0_0_0_1_0
`define CTRL_SIG_ORI		7'b0_1_0_0_0_1_0
`define CTRL_SIG_ANDI		7'b0_1_0_0_0_1_0
`define CTRL_SIG_BEQ		7'bx_0_1_0_0_0_x
`define CTRL_SIG_LW			7'b0_1_0_1_0_1_1
`define CTRL_SIG_SW			7'bx_1_0_0_1_0_x
`define CTRL_SIG_J			7'bx_x_1_0_0_0_x
