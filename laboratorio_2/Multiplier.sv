module Multiplier #(parameter N = 4)(
    input logic [N-1:0] A, B,
    output logic [2*N-1:0] result
);

always_comb begin
    result = 0;
    for (int i = 0; i < N; i++) begin
        if (B[i])
            result = result + (A << i);
    end
end

endmodule
