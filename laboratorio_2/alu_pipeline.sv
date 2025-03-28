module alu_pipeline #(parameter WIDTH = 8)(
    input logic clk, reset,        
    input logic [3:0] opcode,      
    input logic [WIDTH-1:0] A, B,  
    output logic [WIDTH-1:0] result_out,  
    output logic N, Z, C, V        
);

    logic [WIDTH-1:0] A_reg, B_reg;        // Registros de entrada
    logic [WIDTH-1:0] result_comb;         // Resultado
    logic [WIDTH-1:0] result_reg;          // Registro de salida 
    logic N_comb, Z_comb, C_comb, V_comb;  // Flags 

	//registro de entrada
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            A_reg <= 0;
            B_reg <= 0;
        end
        else begin
            A_reg <= A;
            B_reg <= B;
        end
    end


		ALU #(WIDTH) alu_inst (
			 .A(A_reg),
			 .B(B_reg),
			 .opcode(4'b0000),  // Solo suma
			 .result(result_comb),
			 .N(N_comb),
			 .Z(Z_comb),
			 .C(C_comb),
			 .V(V_comb)
		);

	//Registro de salida
    always_ff @(negedge clk or posedge reset) begin
        if (reset) begin
            result_reg <= 0;
        end
        else begin
            result_reg <= result_comb;
        end
    end

    // Salidas
    assign result_out = result_reg;
    assign N = N_comb;
    assign Z = Z_comb;
    assign C = C_comb;
    assign V = V_comb;

endmodule
