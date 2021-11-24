module MemOverwrite(
	input  wire [31:0] in, mem,
	input  wire [1:0]  ctrl,
	output wire [31:0] out
);

assign out = (ctrl == 2) ? { mem[31:16], in[15:0] } :
	     (ctrl == 1) ? { mem[31:8],  in[7:0]  } :
	     in;

endmodule
