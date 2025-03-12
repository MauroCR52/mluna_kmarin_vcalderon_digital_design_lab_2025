module tb_subtractor;
    logic clk, reset, dec;
    logic [5:0] init_value;
    logic [5:0] count;

    subtractor #(6) uut (
        .clk(clk), .reset(reset), .dec(dec), .init_value(init_value), .count(count)
    );

    always #5 clk = ~clk;  // Genera un clock cada 5 unidades de tiempo .

    initial begin
        
        $monitor("Time: %0t | count: %b | dec: %b | reset: %b", $time, count, dec, reset);

        
        clk = 0; reset = 1; dec = 0; init_value = 6'b111100;
        #10 reset = 0; // se apaga el reset al 10 unidades de tiempo

        
        if (count !== init_value) begin
            $error("Error: El valor inicial no se cargó");
            error_count++;
        end

        // Decrementamos varias veces, alternando 1 y 0
        repeat (10) begin
            #5 dec = 1;
            #10 dec = 0;
        end

        // Probamos que el restador no reste si ya el contador es 0
        repeat (55) begin
            #5 dec = 1;
            #10 dec = 0;
        end

        if (count !== 0) begin // Esperamos que se mantenga en 0
            $error("Error: Se intenta pasar de 0");
            error_count++;
        end

        // Reset
        reset = 1; #10 reset = 0;
        if (count !== init_value) begin
            $error("Error: Reset falló.");
            error_count++;
        end
        $stop;
    end
endmodule
