module Processador(
        input wire clk, rst
);

//****************************************************************************//
//                                 Parâmetros                                //
//****************************************************************************//

parameter RESET     = 4'b0000;
parameter START     = 4'b0001;
parameter READ_MEM1 = 4'b0010;
parameter READ_MEM2 = 4'b0011;
parameter READ_MEM3 = 4'b0100;
parameter DECODE    = 4'b0101;
parameter CALC_PC1  = 4'b0110;
parameter CALC_PC2  = 4'b0111;
parameter SAVE_MEM1 = 4'b1000;
parameter SAVE_MEM2 = 4'b1001;
parameter ADD       = 4'b1010;


//****************************************************************************//
//                         Declarações de Registros                         //
//****************************************************************************//

reg rpc_load;
reg rmem_write;
reg rins_load;
reg rreg_write;
reg rregA_load;
reg rregB_load;
reg raluout_load;
reg rmux_memdata;
reg rmux_alusrcA;
reg [1:0] rmux_pcin;
reg [1:0] rmux_IorD;
reg [1:0] rmux_regdst;
reg [1:0] rmux_alusrcB;
reg [2:0] rmux_mem2reg;
reg [2:0] ralu_op;

reg [3:0] state;


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
  alu_out,
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
  pc_out,
  regA_out,
  mux_alusrcA,
  alu_srcA
);

MUX4x1 mux5(
  regB_out,
  4,
  0,                    // TODO ler imediatos
  0,                    // TODO ler offsets
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


assign pc_load     = rpc_load;
assign mem_write   = rmem_write;
assign ins_load    = rins_load;
assign reg_write   = rreg_write;
assign regA_load   = rregA_load;
assign regB_load   = rregB_load;
assign aluout_load = raluout_load;
assign mux_memdata = rmux_memdata;
assign mux_alusrcA = rmux_alusrcA;
assign mux_pcin    = rmux_pcin;
assign mux_IorD    = rmux_IorD;
assign mux_regdst  = rmux_regdst;
assign mux_alusrcB = rmux_alusrcB;
assign mux_mem2reg = rmux_mem2reg;
assign alu_op      = ralu_op;



always @(posedge clk, posedge rst) begin
  if (rst) begin
    rpc_load     <= 0;
    rmem_write   <= 0;
    rins_load    <= 0;
    rreg_write   <= 0;
    rregA_load   <= 0;
    rregB_load   <= 0;
    raluout_load <= 0;
    rmux_memdata <= 0;
    rmux_alusrcA <= 0;
    rmux_pcin    <= 0;
    rmux_IorD    <= 0;
    rmux_regdst  <= 0;
    rmux_alusrcB <= 0;
    rmux_mem2reg <= 0;
    ralu_op      <= 0;
    state        <= START;

  end else begin
    case (state)

      START: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 1;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 2;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= 6;
        ralu_op      <= 0;
        state        <= RESET;
      end

      RESET: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 0;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= 0;
        ralu_op      <= 0;
        state        <= READ_MEM1;
      end

      READ_MEM1: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 0;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 1;
        rmux_mem2reg <= 0;
        ralu_op      <= 1;
        state        <= READ_MEM2;
      end

      READ_MEM2: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 0;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 1;
        rmux_mem2reg <= 0;
        ralu_op      <= 1;
        state        <= READ_MEM3;
      end

      READ_MEM3: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 0;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 1;
        rmux_mem2reg <= 0;
        ralu_op      <= 1;
        state        <= DECODE;
      end

      DECODE: begin
        rpc_load     <= 1;
        rmem_write   <= 0;
        rins_load    <= 1;
        rreg_write   <= 0;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= 0;
        ralu_op      <= 0;
        state        <= CALC_PC1;
      end

      CALC_PC1: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 0;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 3;
        rmux_mem2reg <= 0;
        ralu_op      <= 1;
        state        <= CALC_PC2;
      end

      CALC_PC2: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 0;
        rregA_load   <= 1;
        rregB_load   <= 1;
        raluout_load <= 1;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= 0;
        ralu_op      <= 0;
        state        <= ADD;
      end

      ADD: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 0;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 1;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= 0;
        ralu_op      <= 1;
        state        <= SAVE_MEM1;
      end

      SAVE_MEM1: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 1;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= 1;
        ralu_op      <= 0;
        state        <= SAVE_MEM2;
      end

      SAVE_MEM2: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 1;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 0;
        rmux_memdata <= 0;
        rmux_alusrcA <= 0;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= 1;
        ralu_op      <= 0;
        state        <= READ_MEM1;
      end

    endcase
  end
end

endmodule
