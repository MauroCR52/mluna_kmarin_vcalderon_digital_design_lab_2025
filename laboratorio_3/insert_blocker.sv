module insert_blocker #(
    parameter WAIT_CYCLES = 12_500_000  // 0.5 segundos a 25 MHz
)(
    input  logic clk,
    input  logic reset,
    input  logic trigger,     // Activa el bloqueo (pulso al insertar)
    output logic enabled      // Solo se puede insertar cuando esto es 1
);

    logic [23:0] counter = 0;
    logic blocking = 0;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            blocking <= 0;
        end else begin
            if (trigger && !blocking) begin
                blocking <= 1;
                counter <= 0;
            end else if (blocking) begin
                if (counter >= WAIT_CYCLES) begin
                    blocking <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end

    assign enabled = ~blocking;

endmodule
