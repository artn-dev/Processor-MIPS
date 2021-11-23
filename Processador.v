module Processador(
        input wire clk, rst
);

// PC (Contador de Programa)
wire pc_load;
wire [31:0] pc_in;
wire [31:0] pc_out;

// Memória
wire mem_write;
wire [31:0] mem_addr;
wire [31:0] mem_in;
wire [31:0] mem_out;

// MDR
wire mdr_load;
wire [31:0] mdr_in;
wire [31:0] mdr_out;

// Registro de Instruções
wire ins_load;
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
wire [31:0] alu_imm;
wire [31:0] alu_offset;
wire [2:0]  alu_op;
wire [31:0] alu_out;
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

// Concatenador
wire [25:0] concat_insaddr;
wire [27:0] concat_in;
wire [31:0] concat_out;

// MUX
wire mux_memdata;
wire mux_alusrcA;
wire [1:0] mux_pcin;
wire [1:0] mux_IorD;
wire [1:0] mux_regdst;
wire [1:0] mux_alusrcB;
wire [2:0] mux_mem2reg;


//****************************************************************************//
//                                 Componentes                                //
//****************************************************************************//

Control CTRL(
  clk,
  rst,
  ins_opcode,
  ins_imm[5:0],
  pc_load,
  mem_write,
  ins_load,
  reg_write,
  regA_load,
  regB_load,
  aluout_load,
  mux_memdata,
  mux_alusrcA,
  mux_pcin,
  mux_IorD,
  mux_regdst,
  mux_alusrcB,
  mux_mem2reg,
  alu_op
);

Registrador PC(
  clk,
  rst,
  pc_load,
  pc_in,
  pc_out
);

MUX4x1 mux0(
  pc_out,
  alu_out,
  regA_out,
  regB_out,
  mux_IorD,
  mem_addr
);

MUX2x1 mux1(
  regB_out,
  0,            // TODO salvar meia-palavra/byte
  mux_memdata,
  mem_in
);

Memoria MEM(
  mem_addr,
  clk,
  mem_write,
  mem_in,
  mem_out
);

assign ins_in = mem_out;
assign mdr_in = mem_out;

Registrador MDR(
  clk,
  rst,
  mdr_load,
  mdr_in,
  mdr_out
);

Instr_Reg IR(
  clk,
  rst,
  ins_load,
  ins_in,
  ins_opcode,
  ins_rs,
  ins_rt,
  ins_imm
);

assign concat_insaddr = { ins_rs, ins_rt, ins_imm };
assign concat_in  = concat_insaddr << 2;
assign concat_out = { pc_out[31:28], concat_in };

MUX4x1_5b mux2(
  ins_rt,
  ins_imm[15:11],
  5'd29,
  5'd31,
  mux_regdst,
  reg_wreg
);

MUX7x1 mux3(
  0,                    // TODO ler memória
  aluout_out,
  0,                    // TODO ler imediato
  0,                    // TODO implementar multiplicação/divisão
  0,                    // TODO ler flags da ULA
  0,                    // TODO implementar shift
  227,
  mux_mem2reg,
  reg_wdata
);

assign reg_rreg1 = ins_rs;
assign reg_rreg2 = ins_rt;

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

assign regA_in = reg_rdata1;

Registrador A(
  clk,
  rst,
  regA_load,
  regA_in,
  regA_out
);

assign regB_in = reg_rdata2;

Registrador B(
  clk,
  rst,
  regB_load,
  regB_in,
  regB_out
);

MUX2x1 mux4(
  regA_out,
  pc_out,
  mux_alusrcA,
  alu_srcA
);

assign alu_imm = { 16'd0, ins_imm };
assign alu_offset = alu_imm << 2;

MUX4x1 mux5(
  regB_out,
  4,
  alu_imm,
  alu_offset,
  mux_alusrcB,
  alu_srcB
);

Ula32 ALU(
  alu_srcA,
  alu_srcB,
  alu_op,
  alu_out,
  alu_overflow,
  alu_neg,
  alu_zero,
  alu_eq,
  alu_gt,
  alu_lt
);

assign aluout_in = alu_out;

Registrador ALUout(
  clk,
  rst,
  aluout_load,
  aluout_in,
  aluout_out
);

MUX4x1 mux6(
  alu_out,
  aluout_out,
  concat_out,
  0,                    // TODO implementar EPC
  mux_pcin,
  pc_in
);

endmodule
