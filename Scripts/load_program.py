opcode = {
    "add": "000000",
    "sub": "000000",
    "nor": "000000",
    "and": "000000",
    "or": "000000",
    "nop": "000000",
    "addi": "001000",
    "ori": "001101",
    "andi": "001100",
    "beq": "000100",
    "lw": "100011",
    "sw": "101001",
    "j": "000010"
}

funct = {
    "other": "000000",
    "add": "100000",
    "sub": "100010",
    "nor": "100111",
    "and": "100100",
    "or": "100101"
}

reg = {
    "$zero": "00000",
    "$at": "00001",
    "$v0": "00010",
    "$v1": "00011",
    "$a0": "00100",
    "$a1": "00101",
    "$a2": "00110",
    "$a3": "00111",
    "$t0": "01000",
    "$t1": "01001",
    "$t2": "01010",
    "$t3": "01011",
    "$t4": "01100",
    "$t5": "01101",
    "$t6": "01110",
    "$t7": "01111",
    "$s0": "10000",
    "$s1": "10001",
    "$s2": "10010",
    "$s3": "10011",
    "$s4": "10100",
    "$s5": "10101",
    "$s6": "10110",
    "$s7": "10111",
    "$t8": "11000",
    "$t9": "11001",
    "$k0": "11010",
    "$k1": "11011",
    "$gp": "11100",
    "$sp": "11101",
    "$fp": "11110",
    "$ra": "11111"
}

labels = {}


def clean_noise(line):
    line = line.strip()
    line = line.replace("\t", "")
    [func, c, args] = line.partition(" ")
    args = args.replace(" ", "")
    line = "".join([func, c, args])
    return line


def register_labels(lines):
    for index, line in enumerate(lines):
        if ":" in line:
            labels[line[0: -1]] = index


def replace_i_type_labels(lines):
    for index, line in enumerate(lines):
        components = line.split(",")
        if components[-1] in labels:
            components[-1] = str(labels[components[-1]] - index - 1)
            lines[index] = ",".join(components)
    return lines


def replace_j_type_labels(lines):
    for index, line in enumerate(lines):
        components = line.split(" ")
        if components[-1] in labels:
            components[-1] = str(labels[components[-1]] - index)
            lines[index] = " ".join(components)
    return lines


def remove_labels(lines):
    lines = replace_i_type_labels(lines)
    lines = replace_j_type_labels(lines)
    lines = [line for line in lines if ":" not in line]
    return lines


def r_type_translation(func, args):
    return opcode[func] + reg[args[1]] + reg[args[2]] + reg[args[0]] + funct[func].rjust(11, "0")


def j_type_translation(func, args):
    const = int(args[0])
    extend = "0"
    if const < 0:
        extend = "1"
        const = -(const + 1)
        const = bin(const)[2:].replace("1", "2").replace("0", "1").replace("2", "0").rjust(26, extend)
    else:
        const = bin(const)[2:].rjust(16, extend)
    return opcode[func] + const

def sw_lw_translation(func, args):
    args[1] = args[1].replace(")", "")
    args[1: 2] = args[1].split("(")
    const = int(args[1])
    extend = "0"
    if const < 0:
        extend = "1"
        const = -(const + 1)
        const = bin(const)[2:].replace("1", "2").replace("0", "1").replace("2", "0").rjust(16, extend)
    else:
        const = bin(const)[2:].rjust(16, extend)
    return opcode[func] + reg[args[2]] + reg[args[0]] + const


def beq_type_translation(func, args):
    const = int(args[2])
    extend = "0"
    if const < 0:
        extend = "1"
        const = -(const + 1)
        const = bin(const)[2:].replace("1", "2").replace("0", "1").replace("2", "0").rjust(16, extend)
    else:
        const = bin(const)[2:].rjust(16, extend)
    return opcode[func] + reg[args[0]] + reg[args[1]] + const


def other_i_type_translation(func, args):
    const = int(args[2])
    extend = "0"
    if const < 0:
        extend = "1"
        const = -(const + 1)
        const = bin(const)[2:].replace("1", "2").replace("0", "1").replace("2", "0").rjust(16, extend)
    else:
        const = bin(const)[2:].rjust(16, extend)
    return opcode[func] + reg[args[1]] + reg[args[0]] + const


with open("program_to_load.txt") as file:
    program = file.readlines()

clean_lines = [clean_noise(line) for line in program]
uncommented_lines = [line for line in clean_lines if line is not None and not line == "" and not line.startswith("//")]
register_labels(uncommented_lines)
unlabeled_lines = remove_labels(uncommented_lines)

translation = []

for line in unlabeled_lines:
    (func, c, arg_list) = line.partition(" ")
    args = arg_list.split(",")

    if func in funct:  # r-type
        trans = r_type_translation(func, args)
    elif func == "j":
        trans = j_type_translation(func, args)
    elif func == "nop":
        trans = "".center(32, "0")
    elif func == "sw" or func == "lw":
        trans = sw_lw_translation(func, args)
    elif func == "beq":
    	trans = beq_type_translation(func, args)
    else:  # i-type
        trans = other_i_type_translation(func, args)

    translation.append(trans)

instr_mem_location = "../Modules/MemReg/InstrMem.v"

with open(instr_mem_location) as file:
    old_code = file.readlines()

always_line = -1
for index, line in enumerate(old_code):
    if line.strip() == "always @(posedge reset) begin":
        always_line = index

if always_line == -1:
    print("script failed")
    exit()

new_code = old_code[0: always_line + 1]

for index, byte in enumerate(translation):
    new_code += f"        instr_mem[{index}] <= 'b{byte};\n"

new_code += [f"        for (i = {len(translation)}; i < SIZE_MEM; i = i + 1)\n",
             "            instr_mem[i] <= 0;\n"]
new_code += ["    end\n", "\n", "endmodule // InstrMem"]

with open(instr_mem_location, 'w') as file:
    file.write("".join(new_code))
