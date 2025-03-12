module subtractor #(parameter N = 6) (
    input logic clk,
    input logic reset,
    input logic dec,
    input logic [N-1:0] init_value,
    output logic [N-1:0] count
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            count <= init_value; 
        else if (dec && count > 0)
            count <= count - 1;
    end
endmodule