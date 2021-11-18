module MUX2x1(
    // Inputs
    input  wire [31:0] a, b,
    input  wire [1:0] sel,

    // Output
    output wire [31:0] out
);

assign out = sel ? a : b;

endmodule
