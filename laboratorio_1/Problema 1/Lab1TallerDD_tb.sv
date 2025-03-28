module Lab1TallerDD_tb;

    // Señales de prueba
    logic bit1, bit2, bit3, bit4;
    wire [4:0] BCD;
    wire [3:0] numero;
    wire [6:0] display1, display2;

    // Instanciar el DUT (Device Under Test)
    Lab1TallerDD uut (
        .bit1(bit1),
        .bit2(bit2),
        .bit3(bit3),
        .bit4(bit4),
        .BCD(BCD),
        .numero(numero),
        .display1(display1),
        .display2(display2)
    );

    // Generar estímulos
    initial begin
        $display("Tiempo | bit1 bit2 bit3 bit4 | BCD | Display1 | Display2");
        $monitor("%t | %b %b %b %b | %b | %b | %b", $time, bit1, bit2, bit3, bit4, BCD, display1, display2);

        // Pruebas de entrada binaria
        bit1 = 0; bit2 = 0; bit3 = 0; bit4 = 0; #10;
        bit1 = 0; bit2 = 0; bit3 = 0; bit4 = 1; #10;
        bit1 = 0; bit2 = 0; bit3 = 1; bit4 = 0; #10;
        bit1 = 0; bit2 = 0; bit3 = 1; bit4 = 1; #10;
        bit1 = 0; bit2 = 1; bit3 = 0; bit4 = 0; #10;
        bit1 = 0; bit2 = 1; bit3 = 0; bit4 = 1; #10;
        bit1 = 0; bit2 = 1; bit3 = 1; bit4 = 0; #10;
        bit1 = 0; bit2 = 1; bit3 = 1; bit4 = 1; #10;
        bit1 = 1; bit2 = 0; bit3 = 0; bit4 = 0; #10;
        bit1 = 1; bit2 = 0; bit3 = 0; bit4 = 1; #10;
        
        // Terminar simulación
        $finish;
    end

endmodule