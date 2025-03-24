module Subtractor #(parameter N = 4)(
    input logic [N-1:0] minuendo,
    input logic [N-1:0] sustraendo,
    output logic [N-1:0] diferencia,
    output logic cout   
);

    // Se transforma el sustraendo a un número negativo 
    logic [N:0] complemento_dos; 
    logic [N:0] temp_sum;
    logic cout_internal;
    
    // Complemento a dos: invertir los bits y sumar 1
    assign complemento_dos = ~sustraendo + 1;

    // Suma el minuendo con el complemento del sustraendo
    Adder #(N) restAdder (
        .num1(minuendo),
        .num2(complemento_dos),
        .sum(temp_sum),
        .cout(cout_internal)
    );
    

    assign diferencia = temp_sum[N-1:0]; // No necesitamos el ~temp_sum, ya que la suma es directa.

    
    assign cout = cout_internal;


    assign overflow = (minuendo[N-1] == sustraendo[N-1]) && (diferencia[N-1] != minuendo[N-1]);

endmodule
