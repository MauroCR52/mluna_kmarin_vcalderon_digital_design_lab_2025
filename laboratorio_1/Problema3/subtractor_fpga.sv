module subtractor_fpga (
    input logic clk,  
    input logic [3:0] key, 
    input logic [8:0] sw, 
    output logic [6:0] hex0, hex1, hex2 
);

    logic [5:0] count; // 6 bits
    logic [5:0] init_value; 

    // logica para evitar debounce en el boton de restar
    logic dec_pressed, dec_last;
    always_ff @(posedge clk) begin
        dec_last <= key[0]; 
        dec_pressed <= !key[0] & dec_last; 
    end

    // se asigna valores definidos a diferentes switches
    always_comb begin
        if (sw[1]) init_value = 6'd6;  
        else if (sw[2]) init_value = 6'd12;  
        else if (sw[3]) init_value = 6'd25; 
        else if (sw[4]) init_value = 6'd35; 
        else if (sw[5]) init_value = 6'd57; 
        else if (sw[6]) init_value = 6'd134; 
        else init_value = 6'd0; 
    end

    /
    subtractor #(6) restador (
        .clk(clk),
        .reset(sw[0]),
        .dec(dec_pressed),
        .init_value(init_value),
        .count(count)
    );
   
    logic [3:0] dig0, dig1; /
    always_ff @(posedge clk) begin
        dig0 <= count % 10;   
        dig1 <= (count / 10) % 10; 
    end

    seven_segment_display disp0 (.num(dig0), .segments(hex0)); 
    seven_segment_display disp1 (.num(dig1), .segments(hex1)); 
    assign hex2 = 7'b1111111; 
endmodule
