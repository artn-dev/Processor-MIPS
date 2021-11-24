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
	output wire mux_memdata,
	output wire mux_alusrcA,
	output wire [1:0] mux_pcin,
	output wire [1:0] mux_IorD,
	output wire [1:0] mux_regdst,
	output wire [1:0] mux_alusrcB,
	output wire [1:0] adjsz_ctrl,
	output wire [2:0] mux_mem2reg,
	output wire [2:0] alu_op
);

parameter RESET     = 4'b0000;
parameter START     = 4'b0001;
parameter READ_MEM1 = 4'b0010;
parameter READ_MEM2 = 4'b0011;
parameter READ_MEM3 = 4'b0100;
parameter DECODE    = 4'b0101;
parameter CALC_PC1  = 4'b0110;
parameter CALC_PC2  = 4'b0111;
parameter CALC_PC3  = 4'b1000;
parameter SAVE_MEM1 = 4'b1001;
parameter SAVE_MEM2 = 4'b1010;

parameter ADDI      = 4'b1011;
parameter ALU_INST  = 4'b1100;
parameter LUI       = 4'b1001;


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
reg [1:0] radjsz_ctrl;
reg [2:0] rmux_mem2reg;
reg [2:0] ralu_op;

reg [3:0] state;


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
assign adjsz_ctrl  = radjsz_ctrl;


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
    radjsz_ctrl  <= 0;
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
        radjsz_ctrl  <= 0;
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
        radjsz_ctrl  <= 0;
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
        radjsz_ctrl  <= 0;
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
        radjsz_ctrl  <= 0;
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
        radjsz_ctrl  <= 0;
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
        rmux_alusrcB <= 1;
        rmux_mem2reg <= 0;
        ralu_op      <= 1;
        radjsz_ctrl  <= 0;
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
        radjsz_ctrl  <= 0;
        state        <= CALC_PC2;
      end

      CALC_PC2: begin
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
        radjsz_ctrl  <= 0;
        state        <= CALC_PC3;
      end

      CALC_PC3: begin
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
        rmux_alusrcB <= 3;
        rmux_mem2reg <= 0;
        ralu_op      <= 1;
        radjsz_ctrl  <= 0;
        state        <= (opcode == 6'h0) ? ALU_INST :
                        (opcode == 6'h8) ? ADDI :
                        (opcode == 6'hf) ? LUI :
                        0;
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
        rmux_regdst  <= (opcode == 0) ? 1 : 0;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= (opcode == 6'hf) ? 2 : 1;
        ralu_op      <= 0;
        radjsz_ctrl  <= 0;
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
        rmux_regdst  <= (opcode == 0) ? 1 : 0;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= (opcode == 6'hf) ? 2 : 1;
        ralu_op      <= 0;
        radjsz_ctrl  <= 0;
        state        <= READ_MEM1;
      end

      ADDI: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 0;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 1;
        rmux_memdata <= 0;
        rmux_alusrcA <= 1;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 2;
        rmux_mem2reg <= 0;
        ralu_op      <= 1;
        radjsz_ctrl  <= 0;
        state        <= SAVE_MEM1;
      end

      ALU_INST: begin
        rpc_load     <= 0;
        rmem_write   <= 0;
        rins_load    <= 0;
        rreg_write   <= 0;
        rregA_load   <= 0;
        rregB_load   <= 0;
        raluout_load <= 1;
        rmux_memdata <= 0;
        rmux_alusrcA <= 1;
        rmux_pcin    <= 0;
        rmux_IorD    <= 0;
        rmux_regdst  <= 0;
        rmux_alusrcB <= 0;
        rmux_mem2reg <= 0;
        ralu_op      <= (funct == 6'h20) ? 1 :
                        (funct == 6'h22) ? 2 :
                        (funct == 6'h24) ? 3 :
                        0;
        radjsz_ctrl  <= 0;
        state        <= SAVE_MEM1;
      end

    endcase
  end
end


endmodule
