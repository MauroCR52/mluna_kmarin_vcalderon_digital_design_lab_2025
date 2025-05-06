module flanco_bajada_array #(
    parameter N = 7
)(
    input  logic clk,
    input  logic reset,
    input  logic [N-1:0] botones,     // botones activos en bajo
    output logic [N-1:0] pulses        // un pulso por switch activado
);
    logic [N-1:0] sync0, sync1;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            sync0 <= {N{1'b1}};
            sync1 <= {N{1'b1}};
        end else begin
            sync0 <= botones;
            sync1 <= sync0;
        end
    end

    assign pulses = sync1 & ~sync0;  // Flanco de bajada
endmodule
