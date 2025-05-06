module display_7seg_doble(
    input  logic [7:0] contador,     // de 0 a 99
    output logic [6:0] display1,     // decenas
    output logic [6:0] display0      // unidades
);

    function automatic [6:0] dec_to_7seg(input [3:0] val);
        case (val)
            4'd0: dec_to_7seg = 7'b1000000;
            4'd1: dec_to_7seg = 7'b1111001;
            4'd2: dec_to_7seg = 7'b0100100;
            4'd3: dec_to_7seg = 7'b0110000;
            4'd4: dec_to_7seg = 7'b0011001;
            4'd5: dec_to_7seg = 7'b0010010;
            4'd6: dec_to_7seg = 7'b0000010;
            4'd7: dec_to_7seg = 7'b1111000;
            4'd8: dec_to_7seg = 7'b0000000;
            4'd9: dec_to_7seg = 7'b0010000;
            default: dec_to_7seg = 7'b1111111; // Apagado
        endcase
    endfunction

    always_comb begin
        display1 = dec_to_7seg(contador / 10); // decenas
        display0 = dec_to_7seg(contador % 10); // unidades
    end

endmodule
