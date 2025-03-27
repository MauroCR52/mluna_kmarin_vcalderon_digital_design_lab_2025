module Subtractor #(parameter N = 4)(
    input logic [N-1:0] minuendo,
    input logic [N-1:0] sustraendo,
    output logic [N-1:0] diferencia,
    output logic cout   
);

logic [N:0] complemento_dos; 
logic [N:0] temp_sum;
logic cout_internal;

// Complemento a dos: invertir bits y sumar 1
assign complemento_dos = {1'b0, ~sustraendo} + 1'b1;

// Suma del minuendo + complemento a dos
Adder #(N) restAdder (
    .num1(minuendo),
    .num2(complemento_dos[N-1:0]),  
    .sum(diferencia),
    .cout(cout_internal)
);

assign cout = cout_internal;  // Acarreo de resta

endmodule
