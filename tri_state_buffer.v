module tri_buf (
    input [15:0] a,
    input enable,
    output [15:0] b
);
    assign b = enable ? a : 16'bz;
endmodule
