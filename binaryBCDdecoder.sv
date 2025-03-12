module binaryBCDdecoder(input [3:0] binary_input, output [4:0] BCD_output);

assign A = binary_input[0];
assign B = binary_input[1];
assign C = binary_input[2];
assign D = binary_input[3];

assign BCD_output[0] = (D);	//a
assign BCD_output[1] = ((~A&C)|(A&B&~C));
assign BCD_output[2] = ((~A&B)|(B&C));
assign BCD_output[3] = (A&~B&~C);
assign BCD_output[4] = ((A&C)|(A&B));

endmodule