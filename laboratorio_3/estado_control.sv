module estado_control (
    input  logic clk,
    input  logic reset,
    input  logic pulse,           // desde flanco_subida
    output logic [3:0] state_out  // para video_gen
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state_out <= 4'd0;
        else if (pulse)
            state_out <= (state_out == 4'd3) ? 4'd0 : state_out + 1;
    end
endmodule