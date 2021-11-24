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

parameter RESET     = 5'b00000;
parameter START     = 5'b00001;
parameter READ_MEM1 = 5'b00010;
parameter READ_MEM2 = 5'b00011;
parameter READ_MEM3 = 5'b00100;
parameter DECODE    = 5'b00101;
parameter CALC_PC1  = 5'b00110;
parameter CALC_PC2  = 5'b00111;
parameter CALC_PC3  = 5'b01000;
parameter SAVE_MEM1 = 5'b01001;
parameter SAVE_MEM2 = 5'b01010;

parameter ADDI      = 5'b01011;
parameter ALU_INST  = 5'b01100;
parameter LOAD1     = 5'b01101;
parameter LOAD2     = 5'b01110;
parameter LOAD3     = 5'b01111;
parameter LOAD4     = 5'b10000;
parameter LOAD5     = 5'b10001;
parameter LUI       = 5'b10010;


reg rpc_load;
reg rmem_write;
reg rins_load;
reg rreg_write;
reg rregA_load;
reg rregB_load;
reg raluout_load;
reg rmdr_load;
reg rmux_memdata;
reg rmux_alusrcA;
reg [1:0] rmux_pcin;
reg [1:0] rmux_IorD;
reg [1:0] rmux_regdst;
reg [1:0] rmux_alusrcB;
reg [1:0] radjsz_ctrl;
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
assign mux_memdata = rmux_memdata;
assign mux_alusrcA = rmux_alusrcA;
assign mux_pcin    = rmux_pcin;
assign mux_IorD    = rmux_IorD;
assign mux_regdst  = rmux_regdst;
assign mux_alusrcB = rmux_alusrcB;
assign mux_mem2reg = rmux_mem2reg;
assign alu_op      = ralu_op;
assign adjsz_ctrl  = radjsz_ctrl;
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
        rmdr_load    <= 0;
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
        rmdr_load    <= 0;
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
        rmem_write   <= 0;
	rmux_IorD    <= 0;
	rins_load    <= 1;
	rmux_alusrcA <= 0;
	rmux_alusrcB <= 1;
	rmux_pcin    <= 0;
	ralu_op      <= 1;
	rpc_load     <= 1;
        state        <= READ_MEM2;
      end

      READ_MEM2: begin
	rpc_load     <= 0;
	rregA_load   <= 1;
	rregB_load   <= 1;
        state        <= READ_MEM3;
      end

      READ_MEM3: begin
	rins_load    <= 0;
	rregA_load   <= 0;
	rregB_load   <= 0;
	state        <= (opcode == 6'hf) ? LUI      :
			(opcode == 6'h8) ? ADDI     :
			(opcode == 6'h0) ? ALU_INST :
		        DECODE;
      end

      ADDI: begin
	rmux_alusrcA <= 1;
	rmux_alusrcB <= 2;
	ralu_op      <= 1;
	raluout_load <= 1;
	rmux_regdst  <= 0;
	rmux_mem2reg <= 1;
        state        <= SAVE_MEM1;
      end

      LUI: begin
	rmux_regdst  <= 0;
	rmux_mem2reg <= 2;
        state        <= SAVE_MEM1;
      end

      ALU_INST: begin
	rmux_alusrcA <= 1;
	rmux_alusrcB <= 0;
	ralu_op      <= (funct == 6'h20) ? 1 :
			(funct == 6'h22) ? 2 :
			(funct == 6'h24) ? 3 :
			0;
	raluout_load <= 1;
	rmux_regdst  <= 1;
	rmux_mem2reg <= 1;
        state        <= SAVE_MEM1;
      end

      SAVE_MEM1: begin
	rreg_write <= 1;
        state        <= SAVE_MEM2;
      end

      SAVE_MEM2: begin
	rreg_write   <= 0;
        state        <= READ_MEM1;
      end


      DECODE: begin
        state        <= CALC_PC1;
      end

      CALC_PC1: begin
        state        <= CALC_PC2;
      end

      CALC_PC2: begin
        state        <= CALC_PC3;
      end

      CALC_PC3: begin
        state        <= (opcode == 6'h0)  ? ALU_INST :
                        (opcode == 6'h8)  ? ADDI     :
                        (opcode == 6'hf)  ? LUI      :
			(opcode == 6'h23) ? LOAD1     :
                        0;
      end

      LOAD1: begin
        state        <= LOAD2;
      end

      LOAD2: begin
        state        <= LOAD3;
      end

      LOAD3: begin
        state        <= LOAD4;
      end

      LOAD4: begin
        state        <= LOAD5;
      end

      LOAD5: begin
        state        <= SAVE_MEM1;
      end

    endcase
  end
end


endmodule
