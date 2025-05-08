module timer_3s(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    output logic timeout
);
    localparam COUNT_MAX = 75_000_000; // 3s a 25MHz

    logic [26:0] counter;

    always_ff @(posedge clk or posedge reset) begin
        if (reset || !enable) begin
            counter <= 0;
            timeout <= 0;
        end else if (counter >= COUNT_MAX) begin
            timeout <= 1;
        end else begin
            counter <= counter + 1;
            timeout <= 0;
        end
    end
endmodule
