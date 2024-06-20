module vga_sync (
    input wire clk,
    output wire hsync,
    output wire vsync,
    output wire [9:0] h_count,
    output wire [9:0] v_count
);
    // VGA 640x480 @ 60Hz Timing Parameters
    localparam H_SYNC_CYC = 96;       // Horizontal sync pulse width
    localparam H_BACK_PORCH = 48;     // Horizontal back porch
    localparam H_ACTIVE_TIME = 640;   // Horizontal active video time
    localparam H_FRONT_PORCH = 16;    // Horizontal front porch
    localparam H_LINE = H_SYNC_CYC + H_BACK_PORCH + H_ACTIVE_TIME + H_FRONT_PORCH;

    localparam V_SYNC_CYC = 2;        // Vertical sync pulse width
    localparam V_BACK_PORCH = 33;     // Vertical back porch
    localparam V_ACTIVE_TIME = 480;   // Vertical active video time
    localparam V_FRONT_PORCH = 10;    // Vertical front porch
    localparam V_FRAME = V_SYNC_CYC + V_BACK_PORCH + V_ACTIVE_TIME + V_FRONT_PORCH;

    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;

    // Horizontal and vertical counters
    always @(posedge clk) begin
        if (h_counter < H_LINE - 1)
            h_counter <= h_counter + 1;
        else begin
            h_counter <= 0;
            if (v_counter < V_FRAME - 1)
                v_counter <= v_counter + 1;
            else
                v_counter <= 0;
        end
    end

    // Horizontal sync generation
    assign hsync = (h_counter < H_SYNC_CYC) ? 0 : 1;

    // Vertical sync generation
    assign vsync = (v_counter < V_SYNC_CYC) ? 0 : 1;

    // Output the current counters
    assign h_count = h_counter;
    assign v_count = v_counter;
endmodule
