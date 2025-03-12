module Lab1TallerDD(input logic bit1, bit2, bit3, bit4,
	output reg[4:0] BCD, 
	output reg [3:0] numero,
	output wire [6:0] display1, 
   output wire [6:0] display2);
	
	
	assign numero = {bit1, bit2, bit3, bit4};
	
	
	binaryBCDdecoder resultado(
        .binary_input(numero),
        .BCD_output(BCD)
    );
	
	// Lógica para convertir el sensor binario en segmentos 7-segmento
	seg7_decoder seg7d_binary(.BCD_input(BCD), .display1(display1), .display2(display2));


endmodule 