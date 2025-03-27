module top (
    input logic [9:0] SW,       // SW0 - SW9
    input logic [3:0] KEY,      // KEY0 - KEY3
    output logic [3:0] LEDR,    // LEDR0 - LEDR3 para flags C, Z, N, V
    output logic [6:0] HEX0,    // HEX0 - HEX3 para mostrar resultado
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3
);

    logic [3:0] A, B;         // Operandos
    logic [3:0] opcode;       // Código de operación
    logic [3:0] result;       // Resultado de la ALU
    logic C, Z, N, V;         // Flags

    // Asignar switches a A y B
    assign A = SW[3:0];       // SW0 - SW3 → A
    assign B = SW[7:4];       // SW4 - SW7 → B

    // Lógica para definir opcode según SW8 y SW9
    always_comb begin
        if (SW[9] == 0 && SW[8] == 0) begin
            // Operaciones aritméticas: Suma, Resta, Multiplicación, División
            case (~KEY)                   // Invertir KEY para activo bajo
                4'b0001: opcode = 4'b0000; // KEY0: Suma
                4'b0010: opcode = 4'b0001; // KEY1: Resta
                4'b0100: opcode = 4'b0010; // KEY2: Multiplicación
                4'b1000: opcode = 4'b0011; // KEY3: División
                default: opcode = 4'b0000;
            endcase
        end
        else if (SW[9] == 1 && SW[8] == 0) begin
            // Operaciones lógicas: Mod, AND, OR, XOR
            case (~KEY)
                4'b0001: opcode = 4'b0100; // KEY0: Modulo
                4'b0010: opcode = 4'b0101; // KEY1: AND
                4'b0100: opcode = 4'b0110; // KEY2: OR
                4'b1000: opcode = 4'b0111; // KEY3: XOR
                default: opcode = 4'b0100;
            endcase
        end
        else if (SW[9] == 1 && SW[8] == 1) begin
            // Operaciones de Shift: Shift Left, Shift Right
            case (~KEY)
                4'b0001: opcode = 4'b1000; // KEY0: Shift Left
                4'b0010: opcode = 4'b1001; // KEY1: Shift Right
                default: opcode = 4'b1000;
            endcase
        end
        else begin
            opcode = 4'b0000;
        end
    end

    // Instancia de la ALU
    ALU #(4) alu_inst (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );

    // Mapear flags a los LEDR
    assign LEDR[0] = C;
    assign LEDR[1] = Z;
    assign LEDR[2] = N;
    assign LEDR[3] = V;

    // Mostrar resultado en HEX0-HEX3
    bin_to_7seg b0 (.bin(result[0]), .seg(HEX0));
    bin_to_7seg b1 (.bin(result[1]), .seg(HEX1));
    bin_to_7seg b2 (.bin(result[2]), .seg(HEX2));
    bin_to_7seg b3 (.bin(result[3]), .seg(HEX3));

endmodule

// Conversión de binario a display de 7 segmentos
module bin_to_7seg(
    input logic bin,
    output logic [6:0] seg
);

    always_comb begin
        case (bin)
            4'b0000: seg = 7'b1000000;  // 0
            4'b0001: seg = 7'b1111001;  // 1
            default: seg = 7'b1111111;  // Apagado si es inválido
        endcase
    end
endmodule
