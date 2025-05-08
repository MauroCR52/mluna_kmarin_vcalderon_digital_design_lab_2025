module flanco_subida (
    input  logic clk,
    input  logic reset,
    input  logic sw_in,
    output logic pulse
);
    logic btn_sync_0, btn_sync_1;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync_0 <= 0;
            btn_sync_1 <= 0;
        end else begin
            btn_sync_0 <= sw_in;
            btn_sync_1 <= btn_sync_0;
        end
    end

    assign pulse = btn_sync_0 & ~btn_sync_1;
endmodule