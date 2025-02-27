module testbench;
    reg [3:0] A, B;
  wire [3:0] Dif;
    wire Cout;
    
  ripple_carry_subtractor_4bit uut (A, B, Dif, Cout);

    initial begin
      $monitor("A=%b B=%b | Dif=%b Cout=%b", A, B, Dif, Cout);
        
        A = 4'b0000; B = 4'b0000; #10;//0 - 0 = 0000
        A = 4'b0001; B = 4'b0001; #10;//1 - 1 = 0000
        A = 4'b0111; B = 4'b0011; #10;//7 - 3 = 0100
	
        A = 4'b0110; B = 4'b0001; #10;//6 - 1 = 0101
        A = 4'b0110; B = 4'b0010; #10;//6 - 2 = 0100

		A = 4'b1100; B = 4'b0001; #10;//-4 - 1 = 1011
      	
        
        $finish;
    end
endmodule
