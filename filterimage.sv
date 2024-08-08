module image_processor (
    input logic clk,          // Clock signal
    input logic reset,        // Reset signal
    input logic [9:0] x,      // X coordinate for VGA
    input logic [9:0] y,      // Y coordinate for VGA
    output logic [7:0] vga_data // VGA pixel data
);
    // Define memory for storing image data (adjust size as needed)
    logic [7:0] image_mem [0:63999]; // Example for a 640x480 image

    // Define the size of the filter window
    localparam WINDOW_SIZE = 3;
    localparam NUM_PIXELS = WINDOW_SIZE * WINDOW_SIZE;

    // Define a window for the median filter
    logic[7:0] window [0:NUM_PIXELS-1];

    // Median filter parameters
    logic [7:0] median_value;

    // Initialize memory with image data from file
	          wire [7:0] sorted_window [0:NUM_PIXELS-1];	
        // Copy window data for sorting
    initial begin
        $readmemh("D:/New folder (2)/CAPSTONE2/median.hex", image_mem);
    end
    // Collect window pixels and apply median filter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            vga_data <= 8'h00; // Set default value on reset
        end 
		  else begin
            // Collect window pixels
            integer i, j;
            integer index;
            integer offset_x, offset_y;
				 reg [9:0] window_x, window_y;
            
            // Initialize window
            index = 0;
            for (offset_y = -1; offset_y <= 1; offset_y = offset_y + 1) begin
                for (offset_x = -1; offset_x <= 1; offset_x = offset_x + 1) begin
                    // Calculate window pixel position with boundary checks
                     window_x = x + offset_x;
                     window_y = y + offset_y;
                    
                    if (window_x >= 0 && window_x < 640 && window_y >= 0 && window_y < 480) begin
                        // Read pixel from image memory
                        window[index] = image_mem[window_y * 640 + window_x];
								end
                    else begin
                        // Handle out-of-bounds (use border value or default)
                        window[index] = 8'h00; // Default value for out-of-bounds
                    end
                    index = index + 1;
                end
            // Sorting logic - bubble sort for simplicity
			end
            for (i = 0; i < NUM_PIXELS; i = i + 1) begin
                sorted_window[i] = window[i];
            end
            // Bubble sort
            for (i = 0; i < NUM_PIXELS-1; i = i + 1) begin
                for (j = 0; j < NUM_PIXELS-i-1; j = j + 1) begin
                    if (sorted_window[j] > sorted_window[j+1]) begin
                        // Swap
                        reg [7:0] temp;
                        temp = sorted_window[j];
                        sorted_window[j] = sorted_window[j+1];
                        sorted_window[j+1] = temp;
                    end
                end
            end
            // The median is the middle element in the sorted array
            median_value = sorted_window[NUM_PIXELS/2];
            vga_data <= median_value; // Set the output data
		end   
	end 
endmodule
