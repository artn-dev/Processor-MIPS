module AdjSize(
        input  wire [31:0] in,
	input  wire [1:0]  ctrl,
        output wire [31:0] out
);

assign out = (ctrl == 2) ? { 16'd0, in[15:0] } :
	     (ctrl == 1) ? { 24'd0, in[7:0] }  :
	     in;

endmodule
