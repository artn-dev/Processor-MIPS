module MUX4x1 (
    input  wire [4:0] a, b, c, d,
    input  wire [1:0] sel,
    output wire [4:0] out
);

assign out = sel == 0 ? a :
             sel == 1 ? b :
             sel == 2 ? c :
             sel == 3 ? d :
             0;
    
endmodule
