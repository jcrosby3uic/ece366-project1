module testbench;
    reg [31:0] A, B;
    reg Cin;
    wire [31:0] S;
    wire Cout;

    CLA_32bit out (A, B, Cin, S, Cout);

    initial begin
        $monitor("A=%h B=%h Cin=%b | S=%h Cout=%b", A, B, Cin, S, Cout);

        A = 32'h00000001; B = 32'h00000001; Cin = 0; #10;
        A = 32'hFFFFFFFF; B = 32'h00000001; Cin = 0; #10;
        A = 32'h12345678; B = 32'h87654321; Cin = 0; #10;
        A = 32'hABCDEF01; B = 32'h12345678; Cin = 1; #10;
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; Cin = 1; #10;

        $finish;
    end
endmodule