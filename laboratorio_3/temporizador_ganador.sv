module temporizador_ganador #(
    parameter MAX_CYCLES = 50_350_000 // 2 seg a 25.175 MHz
)(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    output logic done
);
    logic [$clog2(MAX_CYCLES)-1:0] contador = 0;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            contador <= 0;
            done <= 0;
        end else if (enable) begin
            if (contador >= MAX_CYCLES) begin
                done <= 1;
            end else begin
                contador <= contador + 1;
                done <= 0;
            end
        end else begin
            contador <= 0;
            done <= 0;
        end
    end
endmodule
