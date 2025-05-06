module color_toggle (
    input  logic clk,
    input  logic reset,
    output logic tick
);
    parameter MAX_COUNT = 25_000_000;  // Aproximadamente 1 segundo a 25.175 MHz
    logic [25:0] counter;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            tick <= 0;
        end else begin
            if (counter >= MAX_COUNT) begin
                counter <= 0;
                tick <= 1;
            end else begin
                counter <= counter + 1;
                tick <= 0;
            end
        end
    end
endmodule
