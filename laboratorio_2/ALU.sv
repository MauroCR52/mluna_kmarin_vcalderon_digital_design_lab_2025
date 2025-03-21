module ALU #(parameter WIDTH = 4) (
    input logic [WIDTH - 1:0] A, B,
    input logic [3:0] opcode,
    output logic [WIDTH*2 - 1:0] result,
    output logic N, Z, C, V
);

logic [WIDTH*2-1:0] addResult, subResult, mulResult;
logic [WIDTH*2-1:0] andResult, orResult, xorResult, shlResult, shrResult;
logic [WIDTH*2-1:0] divResult, modResult;
logic cout_add;

Adder #(WIDTH) adder(
    .num1(A), 
    .num2(B), 	
    .sum(addResult), 
    .cout(cout_add)
);

Subtractor #(WIDTH) subtractor(
    .minuendo(A), 
    .sustraendo(B), 
    .diferencia(subResult)
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
        4'b0000: result = addResult;
        4'b0001: result = subResult;
        4'b0010: result = mulResult;
        4'b0011: result = divResult;
        4'b0100: result = modResult;
        4'b0101: result = andResult;
        4'b0110: result = orResult;
        4'b0111: result = xorResult;
        4'b1000: result = shlResult;
        4'b1001: result = shrResult;
        default: result = 0;
    endcase
end

assign N = result[WIDTH*2 - 1];
assign Z = (result == 0);
assign C = (opcode == 4'b0000) ? cout_add : 0;
assign V = (opcode == 4'b0000) && ((A[WIDTH-1] == B[WIDTH-1]) && (result[WIDTH-1] != A[WIDTH-1]));

endmodule
