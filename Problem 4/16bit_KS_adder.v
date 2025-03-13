module KS_Adder_16bit (
    input [15:0] A, B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [15:0] G, P;
    wire [15:0] C;

    // Step 1: Compute Generate (G) and Propagate (P)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : GP_GEN
            assign G[i] = A[i] & B[i];  // Generate
            assign P[i] = A[i] | B[i];  // Propagate
        end
    endgenerate

    // Step 2: Compute Carry using Prefix Tree (AND & OR Gates Only)
    assign C[0] = Cin;
    generate
        for (i = 1; i < 16; i = i + 1) begin : CARRY_COMPUTE
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate

    // Step 3: Compute Sum
    generate
        for (i = 0; i < 16; i = i + 1) begin : SUM_COMPUTE
            assign S[i] = P[i] ^ C[i];
        end
    endgenerate

    assign Cout = G[15] | (P[15] & C[15]);

endmodule