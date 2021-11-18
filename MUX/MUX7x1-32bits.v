module MUX4x1 (
    input  wire [31:0] a, b, c, d, e, f ,g,
    input  wire [1:0] sel,
    output wire [31:0] out
);

assign out = sel == 0 ? a :
             sel == 1 ? b :
             sel == 2 ? c :
             sel == 3 ? d :
             sel == 4 ? e :
             sel == 5 ? f :
             sel == 6 ? g :
             0;
    
endmodule
