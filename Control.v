module Control(
	input  wire clk, rst,
        input  wire [5:0] opcode,
        input  wire [5:0] funct,
	output wire pc_load,
	output wire mem_write,
	output wire ins_load,
	output wire reg_write,
	output wire regA_load,
	output wire regB_load,
	output wire aluout_load,
	output wire mdr_load,
	output wire mux_alusrcA,
        output wire mux_desin,
	output wire [1:0] mux_pcin,
	output wire [1:0] mux_IorD,
	output wire [1:0] mux_regdst,
	output wire [1:0] mux_alusrcB,
	output wire [1:0] adjsz_ctrl,
	output wire [1:0] memow_ctrl,
        output wire [1:0] mux_desn,
	output wire [2:0] mux_mem2reg,
	output wire [2:0] alu_op,
        output wire [2:0] des_op
);

parameter RESET      = 5'd0;
parameter START      = 5'd1;
parameter FETCH1     = 5'd2;
parameter FETCH2     = 5'd3;
parameter DECODE     = 5'd4;
parameter SAVE_REG1  = 5'd5;
parameter SAVE_REG2  = 5'd6;
parameter ADDI       = 5'd7;
parameter ALU_INST   = 5'd8;
parameter LOAD1      = 5'd9;
parameter LOAD2      = 5'd10;
parameter LOAD3      = 5'd11;
parameter LUI        = 5'd12;
parameter LW         = 5'd13;
parameter LH         = 5'd14;
parameter LB         = 5'd15;
parameter SW         = 5'd16;
parameter SH         = 5'd17;
parameter SB         = 5'd18;
parameter SAVE_MEM1  = 5'd19;
parameter SAVE_MEM2  = 5'd20;
parameter SAVE_MEM3  = 5'd21;
parameter SAVE_MEM4  = 5'd22;
parameter SAVE_MEM5  = 5'd23;
parameter JUMP1      = 5'd24;
parameter JUMP2      = 5'd25;
parameter SAVE_INST1 = 5'd26;
parameter SAVE_INST2 = 5'd27;
parameter JR         = 5'd28;
parameter SHIFT1     = 5'd29;
parameter SHIFT2     = 5'd30;


reg rpc_load;
reg rmem_write;
reg rins_load;
reg rreg_write;
reg rregA_load;
reg rregB_load;
reg raluout_load;
reg rmdr_load;
reg rmux_alusrcA;
reg rmux_desin;
reg [1:0] rmux_pcin;
reg [1:0] rmux_IorD;
reg [1:0] rmux_regdst;
reg [1:0] rmux_alusrcB;
reg [1:0] radjsz_ctrl;
reg [1:0] rmemow_ctrl;
reg [1:0] rmux_desn;
reg [2:0] rmux_mem2reg;
reg [2:0] ralu_op;
reg [2:0] rdes_op;

reg [5:0] state;


assign pc_load     = rpc_load;
assign mem_write   = rmem_write;
assign ins_load    = rins_load;
assign reg_write   = rreg_write;
assign regA_load   = rregA_load;
assign regB_load   = rregB_load;
assign aluout_load = raluout_load;
assign mux_alusrcA = rmux_alusrcA;
assign mux_pcin    = rmux_pcin;
assign mux_IorD    = rmux_IorD;
assign mux_regdst  = rmux_regdst;
assign mux_alusrcB = rmux_alusrcB;
assign mux_mem2reg = rmux_mem2reg;
assign alu_op      = ralu_op;
assign adjsz_ctrl  = radjsz_ctrl;
assign memow_ctrl  = rmemow_ctrl;
assign mdr_load    = rmdr_load;
assign des_op      = rdes_op;
assign mux_desin   = rmux_desin;
assign mux_desn    = rmux_desn;


always @(posedge clk, posedge rst) begin
  if (rst) begin
    rpc_load     <= 0;
    rmem_write   <= 0;
    rins_load    <= 0;
    rreg_write   <= 0;
    rregA_load   <= 0;
    rregB_load   <= 0;
    raluout_load <= 0;
    rmdr_load    <= 0;
    rmux_alusrcA <= 0;
    rmux_pcin    <= 0;
    rmux_IorD    <= 0;
    rmux_regdst  <= 0;
    rmux_alusrcB <= 0;
    rmux_mem2reg <= 0;
    ralu_op      <= 0;
    radjsz_ctrl  <= 0;
    rmemow_ctrl  <= 0;
    rdes_op      <= 0;
    rmux_desn    <= 0;
    rmux_desin   <= 0;
    state        <= START;

  end else begin
    case (state)

      START: begin
        rpc_load       <= 0;
        rmem_write     <= 0;
        rins_load      <= 0;
        rreg_write     <= 1;
        rregA_load     <= 0;
        rregB_load     <= 0;
        raluout_load   <= 0;
        rmdr_load      <= 0;
        rmux_alusrcA   <= 0;
        rmux_pcin      <= 0;
        rmux_IorD      <= 0;
        rmux_regdst    <= 2;
        rmux_alusrcB   <= 0;
        rmux_mem2reg   <= 6;
        ralu_op        <= 0;
        radjsz_ctrl    <= 0;
        rmemow_ctrl    <= 0;
        rdes_op        <= 0;
        rmux_desn      <= 0;
        rmux_desin     <= 0;
        state          <= RESET;
      end

      RESET: begin
        rpc_load       <= 0;
        rmem_write     <= 0;
        rins_load      <= 0;
        rreg_write     <= 0;
        rregA_load     <= 0;
        rregB_load     <= 0;
        raluout_load   <= 0;
        rmdr_load      <= 0;
        rmux_alusrcA   <= 0;
        rmux_pcin      <= 0;
        rmux_IorD      <= 0;
        rmux_regdst    <= 0;
        rmux_alusrcB   <= 0;
        rmux_mem2reg   <= 0;
        ralu_op        <= 0;
        radjsz_ctrl    <= 0;
        rmemow_ctrl    <= 0;
        rdes_op        <= 0;
        rmux_desn      <= 0;
        rmux_desin     <= 0;
        state          <= FETCH1;
      end

      FETCH1: begin
        rmem_write     <= 0;
	rmux_IorD      <= 0;
	rins_load      <= 1;
	rmux_alusrcA   <= 0;
	rmux_alusrcB   <= 1;
	rmux_pcin      <= 0;
	ralu_op        <= 1;
	rpc_load       <= 1;
	rmdr_load      <= 1;
        state          <= FETCH2;
      end

      FETCH2: begin
	rpc_load       <= 0;
	rregA_load     <= 1;
	rregB_load     <= 1;
	rins_load      <= 0;
	state          <= DECODE;
      end

      DECODE: begin
	rregA_load     <= 0;
	rregB_load     <= 0;
	state          <= (opcode == 6'hf)  ? LUI        :
			  (opcode == 6'h8)  ? ADDI       :
			  (opcode == 6'h0)  ? ALU_INST   :
			  (opcode == 6'h23) ? LW         :
			  (opcode == 6'h21) ? LH         :
			  (opcode == 6'h20) ? LB         :
                          (opcode == 6'h2b) ? SW         :
                          (opcode == 6'h29) ? SH         :
                          (opcode == 6'h28) ? SB         :
                          (opcode == 6'h2)  ? JUMP1      :
                          (opcode == 6'h3)  ? SAVE_INST1 :
		          FETCH1;
      end

      ADDI: begin
	rmux_alusrcA   <= 1;
	rmux_alusrcB   <= 2;
	ralu_op        <= 1;
	raluout_load   <= 1;
	rmux_regdst    <= 0;
	rmux_mem2reg   <= 1;
        state          <= SAVE_REG1;
      end

      LUI: begin
	rmux_regdst    <= 0;
	rmux_mem2reg   <= 2;
        state          <= SAVE_REG1;
      end

      ALU_INST: begin
	rmux_alusrcA   <= 1;
	rmux_alusrcB   <= 0;
	ralu_op        <= (funct == 6'h20) ? 1 :
			  (funct == 6'h22) ? 2 :
			  (funct == 6'h24) ? 3 :
			  0;
	raluout_load   <= 1;
	rmux_regdst    <= 1;
	rmux_mem2reg   <= 1;
        state          <= (funct == 6'h0 ||
                           funct == 6'h2 ||
                           funct == 6'h3 ||
                           funct == 6'h4 ||
                           funct == 6'h7) ? SHIFT1 :
                          (funct == 6'h8) ? JR     :
                          SAVE_REG1;
      end

      LW: begin
	radjsz_ctrl    <= 0;
        state          <= LOAD1;
      end
      LH: begin
	radjsz_ctrl    <= 2;
        state          <= LOAD1;
      end
      LB: begin
	radjsz_ctrl    <= 1;
        state          <= LOAD1;
      end

      LOAD1: begin
	rmux_alusrcA   <= 1;
	rmux_alusrcB   <= 2;
	ralu_op        <= 1;
	raluout_load   <= 1;
	rmux_IorD      <= 1;
	rmdr_load      <= 1;
        state          <= LOAD2;
      end
      LOAD2: state     <= LOAD3;
      LOAD3: begin
	rmux_regdst    <= 0;
	rmux_mem2reg   <= 0;
        state          <= SAVE_REG1;
      end

      SAVE_REG1: begin
	rreg_write     <= 1;
        rmem_write     <= 0;
	rmux_IorD      <= 0;
	rdes_op        <= 0;
        state          <= SAVE_REG2;
      end
      SAVE_REG2: begin
	rreg_write     <= 0;
        state          <= FETCH1;
      end

      SW: begin
	rmux_alusrcA   <= 1;
	rmux_alusrcB   <= 2;
	ralu_op        <= 1;
	raluout_load   <= 1;
	rmux_IorD      <= 1;
	rmemow_ctrl    <= 0;
	state          <= SAVE_MEM1;
      end
      SH: begin
	rmux_alusrcA   <= 1;
	rmux_alusrcB   <= 2;
	ralu_op        <= 1;
	raluout_load   <= 1;
	rmux_IorD      <= 1;
	rmemow_ctrl    <= 2;
	state          <= SAVE_MEM1;
      end
      SB: begin
	rmux_alusrcA   <= 1;
	rmux_alusrcB   <= 2;
	ralu_op        <= 1;
	raluout_load   <= 1;
	rmux_IorD      <= 1;
	rmemow_ctrl    <= 1;
	state          <= SAVE_MEM1;
      end

      SAVE_MEM1: begin
	rmem_write     <= 1;
	state          <= SAVE_MEM2;
      end
      SAVE_MEM2: state <= SAVE_MEM3;
      SAVE_MEM3: state <= SAVE_MEM4;
      SAVE_MEM4: begin
        rmem_write     <= 0;
	rmux_IorD      <= 0;
	state          <= SAVE_MEM5;
      end
      SAVE_MEM5: state <= FETCH1;

      JUMP1: begin
        rmux_pcin      <= 2;
        rpc_load       <= 1;
        rreg_write     <= 0;
        state          <= JUMP2;
      end
      JUMP2: begin
        rmux_pcin      <= 0;
        rpc_load       <= 0;
        state          <= FETCH1;
      end

      SAVE_INST1: begin
        rmux_alusrcA   <= 0;
        ralu_op        <= 0;
        state          <= SAVE_INST2;
      end
      SAVE_INST2: begin
        rreg_write     <= 1;
        rmux_mem2reg   <= 1;
        rmux_regdst    <= 3;
        state          <= JUMP1;
      end

      JR: begin
        rmux_pcin      <= 1;
        rpc_load       <= 1;
        state          <= JUMP2;
      end

      SHIFT1: begin
	rmux_desn      <= (funct == 6'h4 || funct == 6'h7) ? 1 : 0;
	rmux_desin     <= (funct == 6'h4 || funct == 6'h7) ? 0 : 1;
        rdes_op        <= 1;
        state          <= SHIFT2;
      end
      SHIFT2: begin
        rdes_op        <= (funct == 6'h0 || funct == 6'h4) ? 2 :
			  (funct == 6'h3 || funct == 6'h7) ? 4 :
			  (funct == 6'h2) ? 3                  :
		          0;
        rmux_regdst    <= 1;
        rmux_mem2reg   <= 5;
        state          <= SAVE_REG1;
      end

    endcase
  end
end

endmodule
