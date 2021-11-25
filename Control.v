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
	output wire [1:0] mux_pcin,
	output wire [1:0] mux_IorD,
	output wire [1:0] mux_regdst,
	output wire [1:0] mux_alusrcB,
	output wire [1:0] adjsz_ctrl,
	output wire [1:0] memow_ctrl,
	output wire [2:0] mux_mem2reg,
	output wire [2:0] alu_op
);

parameter RESET     = 5'b00000;
parameter START     = 5'b00001;
parameter FETCH1    = 5'b00010;
parameter FETCH2    = 5'b00011;
parameter DECODE    = 5'b00100;
parameter SAVE_REG1 = 5'b00101;
parameter SAVE_REG2 = 5'b00110;
parameter ADDI      = 5'b00111;
parameter ALU_INST  = 5'b01000;
parameter LOAD1     = 5'b01001;
parameter LOAD2     = 5'b01010;
parameter LOAD3     = 5'b01011;
parameter LUI       = 5'b01100;
parameter LW        = 5'b01101;
parameter LH        = 5'b01110;
parameter LB        = 5'b01111;
parameter SW        = 5'b10000;
parameter SH        = 5'b10001;
parameter SB        = 5'b10010;
parameter SAVE_MEM1 = 5'b10011;
parameter SAVE_MEM2 = 5'b10100;
parameter SAVE_MEM3 = 5'b10101;
parameter SAVE_MEM4 = 5'b10110;
parameter SAVE_MEM5 = 5'b10111;
parameter JUMP_J1   = 5'b11000;
parameter JUMP_J2   = 5'b11001;
parameter JUMP_JAL1 = 5'b11010;
parameter JUMP_JAL2 = 5'b11011;
parameter JUMP_JAL3 = 5'b11100;
parameter JUMP_JAL4 = 5'b11101;


reg rpc_load;
reg rmem_write;
reg rins_load;
reg rreg_write;
reg rregA_load;
reg rregB_load;
reg raluout_load;
reg rmdr_load;
reg rmux_alusrcA;
reg [1:0] rmux_pcin;
reg [1:0] rmux_IorD;
reg [1:0] rmux_regdst;
reg [1:0] rmux_alusrcB;
reg [1:0] radjsz_ctrl;
reg [1:0] rmemow_ctrl;
reg [2:0] rmux_mem2reg;
reg [2:0] ralu_op;

reg [4:0] state;


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
	state          <= (opcode == 6'hf)  ? LUI       :
			  (opcode == 6'h8)  ? ADDI      :
			  (opcode == 6'h0)  ? ALU_INST  :
			  (opcode == 6'h23) ? LW        :
			  (opcode == 6'h21) ? LH        :
			  (opcode == 6'h20) ? LB        :
                          (opcode == 6'h2b) ? SW        :
                          (opcode == 6'h29) ? SH        :
                          (opcode == 6'h28) ? SB        :
                          (opcode == 6'h2)  ? JUMP_J1   :
                          (opcode == 6'h3)  ? JUMP_JAL1 :
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
        state          <= SAVE_REG1;
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

      JUMP_J1: begin
        rmux_pcin      <= 2;
        rpc_load       <= 1;
        state          <= JUMP_J2;
      end
      JUMP_J2: begin
        rmux_pcin      <= 0;
        rpc_load       <= 0;
        state          <= FETCH1;
      end

      JUMP_JAL1: begin
        rmux_alusrcA   <= 0;
        ralu_op        <= 0;
        state          <= JUMP_JAL2;
      end
      JUMP_JAL2: begin
        rreg_write     <= 1;
        rmux_mem2reg   <= 1;
        rmux_regdst    <= 3;
        state          <= JUMP_JAL3;
      end
      JUMP_JAL3: begin
        rmux_pcin      <= 2;
        rpc_load       <= 1;
        rreg_write     <= 0;
        state          <= JUMP_JAL4;
      end
      JUMP_JAL4: begin
        rmux_pcin      <= 0;
        rpc_load       <= 0;
        state          <= FETCH1;
      end

    endcase
  end
end


endmodule
