module preblock(
  input A, B,
  output P, G
);
  assign P = A | B;
  assign G = A & B;
  
endmodule


//Note: P2 is k-1:j and P1 is i:k 
//Note G2 is k-1:j and G2 is i:k
module inter(
  input P1, P2, G1, G2,
  output P, G
);
  wire X;
  assign P = P1 & P2;
  assign X = P1 & G2;
  assign G = G1 | X;
  
  
endmodule
  

module postblock(
  input A,B,G,
  output S
);
  wire X;
  assign X = A ^ B;
  assign S = G ^ X;
  
endmodule


module PREFIXADDER_32bit(
  input [31:0] A, B,
  input Cin,
  output [31:0] S,
  output Cout
);
  wire[31:0] P0;//Level 0 (topmost) of intermediate block
  wire[31:0] G0;//Level 0 (topmost) of intermediate block
  
  //NOTICE! Only some elements of this array are used
  //many are unused. This approach simplifies the verilog code
  //e.g. G0 only exists for 0, 2, 4, 6, 8, 10, 12... 30
  
  wire[31:0] P1;//Level 1 of intermediate block
  wire[31:0] G1;//Level 1 of intermediate block

  //NOTICE! Only some elements of this array are used
  //many are unused. This approach simplifies the verilog code
  //e.g. G1 only exists for 1, 2,  5, 6,  9, 10...
  
  wire[31:0] P2;//Level 2 of intermediate block
  wire[31:0] G2;//Level 2 of intermediate block
  
  wire[31:0] P3;//Level 3 of intermediate block
  wire[31:0] G3;//Level 3 of intermediate block
  
  wire[31:0] P4;//Level 4 of intermediate block
  wire[31:0] G4;//Level 4 of intermediate block
  
  
  wire [31:0] P;
  wire [31:0] G;
  
  
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : preblock
      preblock pb (
        .A(A[i]),
        .B(B[i]),
        .P(P[i]),
        .G(G[i])
      );
    end
  endgenerate
  
  wire CinP =0;
  
  inter l0i0 (P[0],CinP,G[0],Cin,P0[0],G0[0]);
  
  //level 0 (topmost) intermediate blocks
  
  generate
    for (i = 2; i < 32; i = i + 2) begin : level0
      inter l0ix (
        .P1(P[i]),
        .P2(P[i-1]),
        .G1(G[i]),
        .G2(G[i-1]),
        .P(P0[i]),
        .G(G0[i])
      );
    end
  endgenerate
  
  
  //level 1
  
  
  generate
    
    for (i = 1; i+1 < 32; i = i + 4) begin : l1_starting_positions
      
      
      inter l1ix0 (
        .P1(P[i]),
        .P2(P0[i-1]),
        .G1(G[i]),
        .G2(G0[i-1]),
        .P(P1[i]),
        .G(G1[i])
      );

      
      inter l1ix1 (
        .P1(P0[i+1]),
        .P2(P0[i-1]),
        .G1(G0[i+1]),
        .G2(G0[i-1]),
        .P(P1[i+1]),
        .G(G1[i+1])
      );
         
       
    end
  endgenerate
  
  
  
  //level 2
  
  

  generate
    for (i = 3; i+3 < 32; i = i + 8) begin : l2_starting_positions
      
         inter l2ix0 (
			.P1(P[i]),
			.P2(P1[i-1]),
			.G1(G[i]),
			.G2(G1[i-1]),
			.P(P2[i]),
			.G(G2[i])
         );
        inter l2ix1 (
			.P1(P0[i+1]),
			.P2(P1[i-1]),
			.G1(G0[i+1]),
			.G2(G1[i-1]),
			.P(P2[i+1]),
			.G(G2[i+1])
         );
        inter l2ix2 (
			.P1(P1[i+2]),
			.P2(P1[i-1]),
			.G1(G1[i+2]),
			.G2(G1[i-1]),
			.P(P2[i+2]),
			.G(G2[i+2])
        );
		inter l2ix3 (
			.P1(P1[i+3]),
			.P2(P1[i-1]),
			.G1(G1[i+3]),
			.G2(G1[i-1]),
			.P(P2[i+3]),
			.G(G2[i+3])
        );
      
         
    end
  endgenerate
  
  //level 3
  generate
    for (i = 7; i+7 < 32; i = i + 8) begin : l3_starting_positions
      
        inter l3ix0 (
			.P1(P[i]),
			.P2(P2[i-1]),
			.G1(G[i]),
			.G2(G2[i-1]),
			.P(P3[i]),
			.G(G3[i])
        );
		inter l3ix1 (
			.P1(P0[i+1]),
			.P2(P2[i-1]),
			.G1(G0[i+1]),
			.G2(G2[i-1]),
			.P(P3[i+1]),
			.G(G3[i+1])
		);
		inter l3ix2 (
			.P1(P1[i+2]),
			.P2(P2[i-1]),
			.G1(G1[i+2]),
			.G2(G2[i-1]),
			.P(P3[i+2]),
			.G(G3[i+2])
		);
		inter l3ix3 (
          .P1(P1[i+3]),
			.P2(P2[i-1]),
          .G1(G1[i+3]),
			.G2(G2[i-1]),
			.P(P3[i+3]),
			.G(G3[i+3])
		);
		inter l3ix4 (
			.P1(P2[i+4]),
			.P2(P2[i-1]),
			.G1(G2[i+4]),
			.G2(G2[i-1]),
			.P(P3[i+4]),
			.G(G3[i+4])
		);
		inter l3ix5 (
			.P1(P2[i+5]),
			.P2(P2[i-1]),
			.G1(G2[i+5]),
			.G2(G2[i-1]),
			.P(P3[i+5]),
			.G(G3[i+5])
		);
		inter l3ix6 (
			.P1(P2[i+6]),
			.P2(P2[i-1]),
			.G1(G2[i+6]),
			.G2(G2[i-1]),
			.P(P3[i+6]),
			.G(G3[i+6])
		);
		inter l3ix7 (
			.P1(P2[i+7]),
			.P2(P2[i-1]),
			.G1(G2[i+7]),
			.G2(G2[i-1]),
			.P(P3[i+7]),
			.G(G3[i+7])
		);
		   
    end
  endgenerate
  
  //level 4 (bottom-most intermediate block level)
  
		localparam int j=15;
  
		inter l4jx0 (
			.P1(P[j]),
			.P2(P3[j-1]),
			.G1(G[j]),
			.G2(G3[j-1]),
			.P(P4[j]),
			.G(G4[j])
        );
		inter l4jx1 (
			.P1(P0[j+1]),
			.P2(P3[j-1]),
			.G1(G0[j+1]),
			.G2(G3[j-1]),
			.P(P4[j+1]),
			.G(G4[j+1])
        );
		inter l4jx2 (
			.P1(P1[j+2]),
			.P2(P3[j-1]),
			.G1(G1[j+2]),
			.G2(G3[j-1]),
			.P(P4[j+2]),
			.G(G4[j+2])
        );
		inter l4jx3 (
			.P1(P1[j+3]),
			.P2(P3[j-1]),
			.G1(G1[j+3]),
			.G2(G3[j-1]),
			.P(P4[j+3]),
			.G(G4[j+3])
        );
		inter l4jx4 (
			.P1(P2[j+4]),
			.P2(P3[j-1]),
			.G1(G2[j+4]),
			.G2(G3[j-1]),
			.P(P4[j+4]),
			.G(G4[j+4])
        );
		inter l4jx5 (
			.P1(P2[j+5]),
			.P2(P3[j-1]),
			.G1(G2[j+5]),
			.G2(G3[j-1]),
			.P(P4[j+5]),
			.G(G4[j+5])
        );
		inter l4jx6 (
			.P1(P2[j+6]),
			.P2(P3[j-1]),
			.G1(G2[j+6]),
			.G2(G3[j-1]),
			.P(P4[j+6]),
			.G(G4[j+6])
        );
		inter l4jx7 (
			.P1(P2[j+7]),
			.P2(P3[j-1]),
			.G1(G2[j+7]),
			.G2(G3[j-1]),
			.P(P4[j+7]),
			.G(G4[j+7])
        );
		////////
		////////
		inter l4jx8 (
			.P1(P3[j+8]),
			.P2(P3[j-1]),
			.G1(G3[j+8]),
			.G2(G3[j-1]),
			.P(P4[j+8]),
			.G(G4[j+8])
        );
		inter l4jx9 (
			.P1(P3[j+9]),
			.P2(P3[j-1]),
			.G1(G3[j+9]),
			.G2(G3[j-1]),
			.P(P4[j+9]),
			.G(G4[j+9])
        );
		inter l4jx10 (
			.P1(P3[j+10]),
			.P2(P3[j-1]),
			.G1(G3[j+10]),
			.G2(G3[j-1]),
			.P(P4[j+10]),
			.G(G4[j+10])
        );
		inter l4jx11 (
			.P1(P3[j+11]),
			.P2(P3[j-1]),
			.G1(G3[j+11]),
			.G2(G3[j-1]),
			.P(P4[j+11]),
			.G(G4[j+11])
        );
		inter l4jx12 (
			.P1(P3[j+12]),
			.P2(P3[j-1]),
			.G1(G3[j+12]),
			.G2(G3[j-1]),
			.P(P4[j+12]),
			.G(G4[j+12])
        );
		inter l4jx13 (
			.P1(P3[j+13]),
			.P2(P3[j-1]),
			.G1(G3[j+13]),
			.G2(G3[j-1]),
			.P(P4[j+13]),
			.G(G4[j+13])
        );
		inter l4jx14 (
			.P1(P3[j+14]),
			.P2(P3[j-1]),
			.G1(G3[j+14]),
			.G2(G3[j-1]),
			.P(P4[j+14]),
			.G(G4[j+14])
        );
		inter l4jx15 (
			.P1(P3[j+15]),
			.P2(P3[j-1]),
			.G1(G3[j+15]),
			.G2(G3[j-1]),
			.P(P4[j+15]),
			.G(G4[j+15])
        );
  localparam int k=31;
  wire Pout;
  		inter l5COUT (
          .P1(P[k]),
          .P2(P4[k-1]),
          .G1(G[k]),
          .G2(G4[k-1]),
          .P(Pout),
          .G(Cout)
        	);
  
  
  postblock p0(A[0],B[0],Cin,S[0]);
  postblock p1(A[1],B[1],G0[0],S[1]);
  postblock p2(A[2],B[2],G1[1],S[2]);
  postblock p3(A[3],B[3],G1[2],S[3]);
  postblock p4(A[4],B[4],G2[3],S[4]);
  postblock p5(A[5],B[5],G2[4],S[5]);
  postblock p6(A[6],B[6],G2[5],S[6]);
  postblock p7(A[7],B[7],G2[6],S[7]);
  postblock p8(A[8],B[8],G3[7],S[8]);
  postblock p9(A[9],B[9],G3[8],S[9]);
  postblock p10(A[10],B[10],G3[9],S[10]);
  postblock p11(A[11],B[11],G3[10],S[11]);
  postblock p12(A[12],B[12],G3[11],S[12]);
  postblock p13(A[13],B[13],G3[12],S[13]);
  postblock p14(A[14],B[14],G3[13],S[14]);
  postblock p15(A[15],B[15],G3[14],S[15]);
  postblock p16(A[16],B[16],G4[15],S[16]);
  postblock p17(A[17],B[17],G4[16],S[17]);
  postblock p18(A[18],B[18],G4[17],S[18]);
  postblock p19(A[19],B[19],G4[18],S[19]);
  postblock p20(A[20],B[20],G4[19],S[20]);
  postblock p21(A[21],B[21],G4[20],S[21]);
  postblock p22(A[22],B[22],G4[21],S[22]);
  postblock p23(A[23],B[23],G4[22],S[23]);
  postblock p24(A[24],B[24],G4[23],S[24]);
  postblock p25(A[25],B[25],G4[24],S[25]);
  postblock p26(A[26],B[26],G4[25],S[26]);
  postblock p27(A[27],B[27],G4[26],S[27]);
  postblock p28(A[28],B[28],G4[27],S[28]);
  postblock p29(A[29],B[29],G4[28],S[29]);
  postblock p30(A[30],B[30],G4[29],S[30]);
  postblock p31(A[31],B[31],G4[30],S[31]);  

  
endmodule