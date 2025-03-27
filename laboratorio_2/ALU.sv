module ALU #(parameter WIDTH = 4) (
    input logic [WIDTH - 1:0] A, B,
    input logic [3:0] opcode,
    output logic [WIDTH-1:0] result,  
    output logic N, Z, C, V
);


logic [WIDTH:0] addResult, subResult;  
logic [WIDTH*2-1:0] mulResult;
logic [WIDTH-1:0] andResult, orResult, xorResult, shlResult, shrResult, divResult, modResult;

Adder #(WIDTH) adder(
    .num1(A), 
    .num2(B), 	
    .sum(addResult[WIDTH-1:0]), 
    .cout(addResult[WIDTH])   
);

Subtractor #(WIDTH) subtractor(
    .minuendo(A), 
    .sustraendo(B), 
    .diferencia(subResult[WIDTH-1:0]),
    .cout(subResult[WIDTH])  
);

Multiplier #(WIDTH) multiplier(
    .A(A),
    .B(B),
    .result(mulResult)
);

assign andResult = A & B;
assign orResult  = A | B;
assign xorResult = A ^ B;
assign shlResult = A << B;  
assign shrResult = A >> B;  
assign divResult = (B != 0) ? A / B : 0;
assign modResult = (B != 0) ? A % B : 0;

always_comb begin
    case (opcode)
        4'b0000: result = addResult[WIDTH-1:0];  // Suma
        4'b0001: result = subResult[WIDTH-1:0];  // Resta
        4'b0010: result = mulResult[WIDTH-1:0];  // Multiplicación
        4'b0011: result = divResult;             // División
        4'b0100: result = modResult;             // Módulo
        4'b0101: result = andResult;             // AND
        4'b0110: result = orResult;              // OR
        4'b0111: result = xorResult;             // XOR
        4'b1000: result = shlResult;             // Shift Left
        4'b1001: result = shrResult;             // Shift Right
        default: result = 0;
    endcase
end


// Flags
assign N = result[WIDTH-1];                // Bit más significativo para negativo
assign Z = (result == 0);                   // Resultado igual a 0
assign C = (opcode == 4'b0000) ? addResult[WIDTH] :   // Carry para suma
           (opcode == 4'b0001) ? subResult[WIDTH] :   // Carry para resta
           (opcode == 4'b1000) ? A[WIDTH-1] :         // Carry para shift left
           (opcode == 4'b1001) ? A[0] : 0;            // Carry para shift right

assign V = ((opcode == 4'b0000) && (A[WIDTH-1] == B[WIDTH-1]) && (result[WIDTH-1] != A[WIDTH-1])) || 
           ((opcode == 4'b0001) && (A[WIDTH-1] != B[WIDTH-1]) && (result[WIDTH-1] != A[WIDTH-1])) ||
           ((opcode == 4'b0010) && (mulResult[2*WIDTH-1:WIDTH] != 0)) || 
           ((opcode == 4'b0011) && (B == 0));  // División por cero
			  
			  
endmodule

