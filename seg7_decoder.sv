module seg7_decoder(input [4:0] BCD_input, output [6:0] display1, output [6:0] display2);

assign A = BCD_input[3];
assign B = BCD_input[2];
assign C = BCD_input[1];
assign D = BCD_input[0];
assign E = BCD_input[4];


assign display1[0] = ~((~B&~D)|(B&C)|(A&~D)|(~A&C)|(A&~B&~C)|(~A&B&D));	//a
assign display1[1] = ~((~B&~D)|(~B&~C)|(~A&C&D)|(A&~C&D)|(~A&~C&~D)); //b
assign display1[2] = ~((A&~B)|(~C&D)|(~A&B)|(~A&D)|(~B&~C)); //c
assign display1[3] = ~((A&B&~D)|(~B&~C&~D)|(B&~C&D)|(~A&C&~D)|(A&~B&D)|(~A&~B&C)); //d
assign display1[4] = ~((~B&~D)|(C&~D)|(A&B)|(A&C)); //e
assign display1[5] = ~((A&~B)|(B&~D)|(A&C)|(~C&~D)|(~A&B&~C)); //f
assign display1[6] = ~((C&~D)|(A&~B)|(~B&C)|(A&D)|(~A&B&~C)); //g

assign display2[0] = E;	//a
assign display2[1] = 0; //b
assign display2[2] = 0; //c
assign display2[3] = E; //d
assign display2[4] = E; //e
assign display2[5] = E; //f
assign display2[6] = 1; //g

endmodule