`timescale 1ns/1ps

module hub_tb;

    reg clk;
    reg reset;

    // Port 1 Signals
    reg [7:0] port1_rx_data;
    reg port1_rx_valid;
    wire [7:0] port1_tx_data;
    wire port1_tx_valid;

    // Port 2 Signals
    reg [7:0] port2_rx_data;
    reg port2_rx_valid;
    wire [7:0] port2_tx_data;
    wire port2_tx_valid;

    // Port 3 Signals
    reg [7:0] port3_rx_data;
    reg port3_rx_valid;
    wire [7:0] port3_tx_data;
    wire port3_tx_valid;

    // Instantiate the Ethernet hub module
    hub uut (
        .clk(clk),
        .reset(reset),
        // Port 1 Interface
        .port1_rx_data(port1_rx_data),
        .port1_rx_valid(port1_rx_valid),
        .port1_tx_data(port1_tx_data),
        .port1_tx_valid(port1_tx_valid),
        // Port 2 Interface
        .port2_rx_data(port2_rx_data),
        .port2_rx_valid(port2_rx_valid),
        .port2_tx_data(port2_tx_data),
        .port2_tx_valid(port2_tx_valid),
        // Port 3 Interface
        .port3_rx_data(port3_rx_data),
        .port3_rx_valid(port3_rx_valid),
        .port3_tx_data(port3_tx_data),
        .port3_tx_valid(port3_tx_valid)
    );

    // Clock Generation
    always #5 clk = ~clk; // 10ns clock period (100 MHz)

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        port1_rx_data = 8'b0;
        port1_rx_valid = 0;
        port2_rx_data = 8'b0;
        port2_rx_valid = 0;
        port3_rx_data = 8'b0;
        port3_rx_valid = 0;

        // Apply reset
        #10 reset = 0;

        // Simulate sending a frame from Port 1 with a broadcast destination MAC
        send_frame(1, 48'hFFFFFFFFFFFF, 48'h001122334455, 8'hAA);

        // Simulate sending a frame from Port 2 with destination MAC of Port 1
        send_frame(2, 48'h001122334455, 48'hAABBCCDDEEFF, 8'hBB);

        // Simulate sending a frame from Port 3 with a broadcast destination MAC
        send_frame(3, 48'hFFFFFFFFFFFF, 48'h123456789ABC, 8'hCC);

        #2000; // Wait for simulation to complete

        $finish;
    end

    // Task to send an Ethernet frame
    task send_frame(input integer port, input [47:0] dest_mac, input [47:0] src_mac, input [7:0] payload);
        integer i;
        begin
            case (port)
                1: begin
                    // Send destination MAC
                    for (i = 47; i >= 0; i = i - 8) begin
                        @(posedge clk);
                        port1_rx_data = dest_mac[i +: 8];
                        port1_rx_valid = 1;
                    end
                    // Send source MAC
                    for (i = 47; i >= 0; i = i - 8) begin
                        @(posedge clk);
                        port1_rx_data = src_mac[i +: 8];
                        port1_rx_valid = 1;
                    end
                    // Send payload
                    @(posedge clk);
                    port1_rx_data = payload;
                    port1_rx_valid = 1;
                    @(posedge clk);
                    port1_rx_valid = 0;
                end
                2: begin
                    // Send destination MAC
                    for (i = 47; i >= 0; i = i - 8) begin
                        @(posedge clk);
                        port2_rx_data = dest_mac[i +: 8];
                        port2_rx_valid = 1;
                    end
                    // Send source MAC
                    for (i = 47; i >= 0; i = i - 8) begin
                        @(posedge clk);
                        port2_rx_data = src_mac[i +: 8];
                        port2_rx_valid = 1;
                    end
                    // Send payload
                    @(posedge clk);
                    port2_rx_data = payload;
                    port2_rx_valid = 1;
                    @(posedge clk);
                    port2_rx_valid = 0;
                end
                3: begin
                    // Send destination MAC
                    for (i = 47; i >= 0; i = i - 8) begin
                        @(posedge clk);
                        port3_rx_data = dest_mac[i +: 8];
                        port3_rx_valid = 1;
                    end
                    // Send source MAC
                    for (i = 47; i >= 0; i = i - 8) begin
                        @(posedge clk);
                        port3_rx_data = src_mac[i +: 8];
                        port3_rx_valid = 1;
                    end
                    // Send payload
                    @(posedge clk);
                    port3_rx_data = payload;
                    port3_rx_valid = 1;
                    @(posedge clk);
                    port3_rx_valid = 0;
                end
            endcase
        end
    endtask

endmodule
