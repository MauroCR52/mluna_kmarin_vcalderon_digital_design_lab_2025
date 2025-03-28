`timescale 1ns/1ps

module ALU_tb;

    parameter WIDTH = 4;
    logic [WIDTH-1:0] A, B;
    logic [3:0] opcode;
    logic [WIDTH-1:0] result;
    logic N, Z, C, V;

    // Instancia de la ALU
    ALU #(WIDTH) dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );

    // Procedimiento inicial para ejecutar casos de prueba
    initial begin
        $display("Test de ALU - Auto-chequeo");

        // --- Suma ---
        A = 4'b0011; B = 4'b0001; opcode = 4'b0000; #10;
        $display("SUMA: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        A = 4'b1111; B = 4'b0001; opcode = 4'b0000; #10;
        $display("SUMA: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        // --- Resta ---
        A = 4'b1001; B = 4'b0010; opcode = 4'b0001; #10;
        $display("RESTA: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        A = 4'b0010; B = 4'b0010; opcode = 4'b0001; #10;
        $display("RESTA: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        // --- Multiplicación ---
        A = 4'b0010; B = 4'b0011; opcode = 4'b0010; #10;
        $display("MULTIPLICACION: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        A = 4'b0011; B = 4'b0011; opcode = 4'b0010; #10;
        $display("MULTIPLICACION: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        // --- División ---
        A = 4'b1000; B = 4'b0010; opcode = 4'b0011; #10;
        $display("DIVISION: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        A = 4'b1100; B = 4'b0011; opcode = 4'b0011; #10;
        $display("DIVISION: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        // --- Módulo ---
        A = 4'b1001; B = 4'b0010; opcode = 4'b0100; #10;
        $display("MODULO: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        A = 4'b1100; B = 4'b0011; opcode = 4'b0100; #10;
        $display("MODULO: A = %b, B = %b, Resultado = %b, C = %b, Z = %b, N = %b, V = %b", A, B, result, C, Z, N, V);

        // --- AND ---
        A = 4'b1100; B = 4'b1010; opcode = 4'b0101; #10;
        $display("AND: A = %b, B = %b, Resultado = %b", A, B, result);

        A = 4'b0110; B = 4'b0011; opcode = 4'b0101; #10;
        $display("AND: A = %b, B = %b, Resultado = %b", A, B, result);

        // --- OR ---
        A = 4'b1100; B = 4'b1010; opcode = 4'b0110; #10;
        $display("OR: A = %b, B = %b, Resultado = %b", A, B, result);

        A = 4'b0110; B = 4'b0011; opcode = 4'b0110; #10;
        $display("OR: A = %b, B = %b, Resultado = %b", A, B, result);

        // --- XOR ---
        A = 4'b1100; B = 4'b1010; opcode = 4'b0111; #10;
        $display("XOR: A = %b, B = %b, Resultado = %b", A, B, result);

        A = 4'b0110; B = 4'b0011; opcode = 4'b0111; #10;
        $display("XOR: A = %b, B = %b, Resultado = %b", A, B, result);

        // --- Shift Left ---
        A = 4'b0011; B = 4'b0001; opcode = 4'b1000; #10;
        $display("SHIFT LEFT: A = %b, B = %b, Resultado = %b, C = %b", A, B, result, C);

        A = 4'b1001; B = 4'b0001; opcode = 4'b1000; #10;
        $display("SHIFT LEFT: A = %b, B = %b, Resultado = %b, C = %b", A, B, result, C);

        // --- Shift Right ---
        A = 4'b1000; B = 4'b0001; opcode = 4'b1001; #10;
        $display("SHIFT RIGHT: A = %b, B = %b, Resultado = %b, C = %b", A, B, result, C);

        A = 4'b1001; B = 4'b0001; opcode = 4'b1001; #10;
        $display("SHIFT RIGHT: A = %b, B = %b, Resultado = %b, C = %b", A, B, result, C);

        $display("Test completado.");
        $finish;
    end
endmodule
