/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_VKL (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    wire [7:0] priority_out;
    tt_um_priority_encoder encoder (
        .input_signal({ui_in, uio_in}), // Combining 8-bit ui_in and 8-bit uio_in to form 16-bit input
        .encoded_output(priority_out)
    );

    assign uo_out = priority_out; // Drive output with encoder output
    assign uio_out = 0;
    assign uio_oe  = 0;

    wire _unused = &{ena, clk, rst_n, 1'b0}; // Avoid unused signal warnings

endmodule

module tt_um_priority_encoder (
    input  wire [15:0] In,
    output reg  [7:0] C
);

    always @(*) 
    begin
        // Priority Checking from In[15] to In[0]
        if (In[15] == 1)       C = 8'b0000_1111; // 15 in binary
        else if (In[14] == 1)  C = 8'b0000_1110; // 14 in binary
        else if (In[13] == 1)  C = 8'b0000_1101; // 13 in binary
        else if (In[12] == 1)  C = 8'b0000_1100; // 12 in binary
        else if (In[11] == 1)  C = 8'b0000_1011; // 11 in binary
        else if (In[10] == 1)  C = 8'b0000_1010; // 10 in binary
        else if (In[9] == 1)   C = 8'b0000_1001; // 9 in binary
        else if (In[8] == 1)   C = 8'b0000_1000; // 8 in binary
        else if (In[7] == 1)   C = 8'b0000_0111; // 7 in binary
        else if (In[6] == 1)   C = 8'b0000_0110; // 6 in binary
        else if (In[5] == 1)   C = 8'b0000_0101; // 5 in binary
        else if (In[4] == 1)   C = 8'b0000_0100; // 4 in binary
        else if (In[3] == 1)   C = 8'b0000_0011; // 3 in binary
        else if (In[2] == 1)   C = 8'b0000_0010; // 2 in binary
        else if (In[1] == 1)   C = 8'b0000_0001; // 1 in binary
        else if (In[0] == 1)   C = 8'b0000_0000; // 0 in binary
        else                   C = 8'b1111_0000; // Special case: All zeros
    end

endmodule
