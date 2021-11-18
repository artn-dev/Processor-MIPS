module MUX3x1 (
    // Inputs
    input  wire [31:0] a, b, c
    input  wire [1:0] sel,

    // Output
    output wire [31:0] out
);

assign out = sel == 0 ? a :
             sel == 1 ? b :
             sel == 2 ? c :
             0;
    
endmodule
