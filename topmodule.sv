module topmodule(
    input logic clk,
    input logic reset,
    output logic hsync,
    output logic vsync,
    output logic [7:0] rgb1
);

    logic [7:0] vga_data;

    // Instantiate image processor
    image_processor img_proc (
        .clk(clk),
        .reset(reset),
        .x(x), // Provide VGA coordinates
        .y(y),
        .vga_data(vga_data)
    );

    // Instantiate VGA controller
    vga_controller vga_ctrl (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb1)
		  
    );

    // Combine or mux signals as necessary
    assign rgb = vga_data; // Example: directly use vga_data as rgb output
endmodule
