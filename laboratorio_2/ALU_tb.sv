`timescale 1ns/1ps

module ALU_tb;

    parameter WIDTH = 4;
    logic [WIDTH-1:0] A, B;
    logic [3:0] opcode;
    logic [WIDTH*2-1:0] result;
    logic N, Z, C, V;

    // DUT
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

    // Task para comparar resultados
    task automatic check(
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        input [3:0] opc,
        input [WIDTH*2-1:0] expected,
        input string op_name
    );
        begin
            A = a;
            B = b;
            opcode = opc;
            #10; // esperar propagación
            $display("[%s] A=%0d, B=%0d => result=%0d (esperado=%0d) | N=%0b Z=%0b C=%0b V=%0b",
                      op_name, A, B, result, expected, N, Z, C, V);
            if (result !== expected)
                $display("  ❌ ERROR en %s\n", op_name);
            else
                $display("  ✅ OK en %s\n", op_name);
        end
    endtask

    initial begin
        $display("\n--- Iniciando pruebas de ALU 4-bit ---\n");

        // SUMA
        check(4'd3, 4'd2, 4'b0000, 4'd5, "Suma");
        check(4'd7, 4'd8, 4'b0000, 4'd15, "Suma");

        // RESTA
        check(4'd6, 4'd2, 4'b0001, 4'd4, "Resta");
        check(4'd2, 4'd5, 4'b0001, 4'd13, "Resta (negativa en complemento)");

        // MULTIPLICACIÓN
        check(4'd3, 4'd2, 4'b0010, 4'd6, "Multiplicación");
        check(4'd4, 4'd4, 4'b0010, 4'd16, "Multiplicación");

        // DIVISIÓN
        check(4'd8, 4'd2, 4'b0011, 4'd4, "División");
        check(4'd7, 4'd3, 4'b0011, 4'd2, "División");

        // MÓDULO
        check(4'd8, 4'd3, 4'b0100, 4'd2, "Módulo");
        check(4'd5, 4'd5, 4'b0100, 4'd0, "Módulo");

        // AND
        check(4'b1100, 4'b1010, 4'b0101, 4'b1000, "AND");
        check(4'b1111, 4'b0000, 4'b0101, 4'b0000, "AND");

        // OR
        check(4'b1100, 4'b1010, 4'b0110, 4'b1110, "OR");
        check(4'b0101, 4'b0011, 4'b0110, 4'b0111, "OR");

        // XOR
        check(4'b1100, 4'b1010, 4'b0111, 4'b0110, "XOR");
        check(4'b1111, 4'b1111, 4'b0111, 4'b0000, "XOR");

        // SHIFT LEFT
        check(4'b0011, 4'd1, 4'b1000, 4'b0110, "Shift Left");
        check(4'b0001, 4'd3, 4'b1000, 4'b1000, "Shift Left");

        // SHIFT RIGHT
        check(4'b1000, 4'd1, 4'b1001, 4'b0100, "Shift Right");
        check(4'b1000, 4'd3, 4'b1001, 4'b0001, "Shift Right");

        $display("--- Pruebas finalizadas ---");
        $stop;
    end

endmodule
