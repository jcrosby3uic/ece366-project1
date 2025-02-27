module ripple_carry_subtractor_4bit(
    input [3:0] A, B,
  output [3:0] Dif,
    output Cout
);
  wire C1, C2, C3;
  wire Cin = 1;
  wire [3:0] Binv;
  
  inverter i1 (B[0], Binv[0]);
  inverter i2 (B[1], Binv[1]);
  inverter i3 (B[2], Binv[2]);
  inverter i4 (B[3], Binv[3]);
	
  full_adder FA0 (A[0], Binv[0], Cin,  Dif[0], C1);
  full_adder FA1 (A[1], Binv[1], C1,   Dif[1], C2);
  full_adder FA2 (A[2], Binv[2], C2,   Dif[2], C3);
  full_adder FA3 (A[3], Binv[3], C3,   Dif[3], Cout);
endmodule
