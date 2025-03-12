module testbench;
    reg [31:0] A, B;
    reg Cin;
    wire [31:0] S;
    wire Cout;

    PREFIXADDER_32bit out (A, B, Cin, S, Cout);

    initial begin
      $monitor("A=%h B=%h Cin=%b | S=%h Cout=%b", A, B, Cin, S, Cout);

        A = 32'h00000001; B = 32'h00000001; Cin = 0; #00;
        A = 32'hFFFFFFFF; B = 32'h00000001; Cin = 0; #10;
        A = 32'h12345678; B = 32'h87654321; Cin = 0; #10;//output should be 0x99999999 Cout=0
        A = 32'h77101100; B = 32'h00CB9981; Cin = 0; #10;//output should be 0x77DBAA81 Cout=0
        A = 32'h8A881210; B = 32'h1BB49110; Cin = 0; #10;//output should be 0xA63CA320 Cout=0
        A = 32'hE871761B; B = 32'hCA18879A; Cin = 0; #10;//output should be 0xB289FDB5 Cout=1
        A = 32'hABCDEF01; B = 32'h12345678; Cin = 1; #10;//output should be 0xBE02457A Cout=0
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; Cin = 1; #10;//output should be 0xFFFFFFFF Cout=1

        $finish;
    end
endmodule