module Adder #(parameter N = 4)(
    input logic [N-1:0] num1,
    input logic [N-1:0] num2,
    output logic [N-1:0] sum,
    output logic cout
);

logic tempCarry;
logic cin = 1'b0;

always_comb begin
    tempCarry = cin;
    for (int i = 0; i < N; i++) begin
        sum[i] = num1[i] ^ num2[i] ^ tempCarry;
        tempCarry = (num1[i] & num2[i]) | (num1[i] & tempCarry) | (num2[i] & tempCarry);
    end
    cout = tempCarry;   // Carry-out
end

endmodule
