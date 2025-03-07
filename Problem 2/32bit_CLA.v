module CLA_32bit (
    input [31:0] A, B,
    input Cin,
    output [31:0] S,
    output Cout
);
    wire [7:0] C, G, P;

    // P & G logic for each block
    assign G[0] = (A[3:0] & B[3:0]) != 0; 
    assign P[0] = (A[3:0] | B[3:0]) != 0;

    assign G[1] = (A[7:4] & B[7:4]) != 0;
    assign P[1] = (A[7:4] | B[7:4]) != 0;

    assign G[2] = (A[11:8] & B[11:8]) != 0;
    assign P[2] = (A[11:8] | B[11:8]) != 0;

    assign G[3] = (A[15:12] & B[15:12]) != 0;
    assign P[3] = (A[15:12] | B[15:12]) != 0;

    assign G[4] = (A[19:16] & B[19:16]) != 0;
    assign P[4] = (A[19:16] | B[19:16]) != 0;

    assign G[5] = (A[23:20] & B[23:20]) != 0;
    assign P[5] = (A[23:20] | B[23:20]) != 0;

    assign G[6] = (A[27:24] & B[27:24]) != 0;
    assign P[6] = (A[27:24] | B[27:24]) != 0;

    assign G[7] = (A[31:28] & B[31:28]) != 0;
    assign P[7] = (A[31:28] | B[31:28]) != 0;

    // Carry calculation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign Cout = G[7] | (P[7] & C[7]);

    //RCA block instantiation
    ripple_carry_adder_4bit RCA0 (A[3:0], B[3:0], C[0], S[3:0], G[0]);
    ripple_carry_adder_4bit RCA1 (A[7:4], B[7:4], C[1], S[7:4], G[1]);
    ripple_carry_adder_4bit RCA2 (A[11:8], B[11:8], C[2], S[11:8], G[2]);
    ripple_carry_adder_4bit RCA3 (A[15:12], B[15:12], C[3], S[15:12], G[3]);
    ripple_carry_adder_4bit RCA4 (A[19:16], B[19:16], C[4], S[19:16], G[4]);
    ripple_carry_adder_4bit RCA5 (A[23:20], B[23:20], C[5], S[23:20], G[5]);
    ripple_carry_adder_4bit RCA6 (A[27:24], B[27:24], C[6], S[27:24], G[6]);
    ripple_carry_adder_4bit RCA7 (A[31:28], B[31:28], C[7], S[31:28], G[7]);

endmodule

module ripple_carry_adder_4bit(
    input [3:0] A, B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire C1, C2, C3;

    full_adder FA0 (A[0], B[0], Cin,  Sum[0], C1);
    full_adder FA1 (A[1], B[1], C1,   Sum[1], C2);
    full_adder FA2 (A[2], B[2], C2,   Sum[2], C3);
    full_adder FA3 (A[3], B[3], C3,   Sum[3], Cout);
endmodule

module full_adder(input A, B, Cin, output Sum, Cout);
    wire w1, w2, w3;
    
    xor(w1, A, B);
    xor(Sum, w1, Cin);
    and(w2, A, B);
    and(w3, w1, Cin);
    or(Cout, w2, w3);
endmodule