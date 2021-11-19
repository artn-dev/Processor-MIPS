module Processador(
        input wire clk, rst
);

//****************************************************************************//
//                            Declarações de Fios                           //
//****************************************************************************//

// PC (Contador de Programa)
wire pc_load;
wire [31:0] pc_in;
wire [31:0] pc_out;

// Memória
wire mem_write;
wire [31:0] mem_addr;
wire [31:0] mem_in;
wire [31:0] mem_out;

// Registro de Instruções
wire [31:0] ins_in;
wire [5:0]  ins_opcode;
wire [4:0]  ins_rs;
wire [4:0]  ins_rt;
wire [15:0] ins_imm;

// Banco de Registros
wire reg_write;
wire [4:0]  reg_rreg1;
wire [4:0]  reg_rreg2;
wire [4:0]  reg_wreg;
wire [31:0] reg_wdata;
wire [31:0] reg_rdata1;
wire [31:0] reg_rdata2;

// Registro A
wire regA_load;
wire [31:0] regA_in;
wire [31:0] regA_out;

// Registro B
wire regB_load;
wire [31:0] regB_in;
wire [31:0] regB_out;

// ULA
wire [31:0] alu_srcA;
wire [31:0] alu_srcB;
wire [2:0]  alu_op;
wire alu_overflow;
wire alu_neg;
wire alu_zero;
wire alu_eq;
wire alu_gt;
wire alu_lt;

// Registro ALUOut
wire aluout_load;
wire [31:0] aluout_in;
wire [31:0] aluout_out;


//****************************************************************************//
//                                 Componentes                                //
//****************************************************************************//

Registrador PC(
  clk,
  rst,
  pc_load,
  pc_in,
  pc_out
);

MUX4x1 mux0(
);

MUX2x1 mux1(
);

Memoria MEM(
  mem_addr,
  clk,
  mem_write,
  mem_in,
  mem_out
);

Instr_Reg IR(
  clk,
  rst,
  ins_in,
  ins_opcode,
  inst_rs,
  inst_rt,
  inst_imm
);

MUX4x1_5b mux2(
);

MUX7x1 mux3(
);

Banco_reg REG(
  clk,
  rst,
  reg_write,
  reg_rreg1,
  reg_rreg2,
  reg_wreg,
  reg_wdata,
  reg_rdata1,
  reg_rdata2
);

Registrador A(
  clk,
  rst,
  regA_load,
  regA_in,
  regA_out
);

Registrador B(
  clk,
  rst,
  regB_load,
  regB_in,
  regB_out
);

MUX2x1 mux4(
);

MUX4x1 mux5(
);

Ula32 ALU(
  alu_srcA,
  alu_srcB,
  alu_op,
  alu_overflow,
  alu_neg,
  alu_zero,
  alu_eq,
  alu_gt,
  alu_lt
);

Registrador ALUout(
  clk,
  rst,
  aluout_load,
  aluout_in,
  aluout_out
);

MUX4x1 mux6(
);

endmodule
