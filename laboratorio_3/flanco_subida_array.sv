module flanco_subida_array #(
    parameter N = 7  // Cantidad de switches
)(
    input  logic clk,
    input  logic reset,
    input  logic [N-1:0] sw_in,    // Entradas de switches
    output logic [N-1:0] pulse     // Pulsos de flanco de subida por switch
);

    logic [N-1:0] sync0, sync1;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            sync0 <= {N{1'b0}};
            sync1 <= {N{1'b0}};
        end else begin
            sync0 <= sw_in;
            sync1 <= sync0;
        end
    end

    assign pulse = sync0 & ~sync1;  // Flanco de subida: 0 → 1

endmodule
