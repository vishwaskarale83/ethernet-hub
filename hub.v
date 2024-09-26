module ethernet_hub (
    input wire clk,            // System clock
    input wire reset,          // Reset signal
    
    // Port 1 Interface
    input wire [7:0] port1_rx_data,  // Data received from Port 1
    input wire port1_rx_valid,       // Valid data indicator for Port 1 receive
    output wire [7:0] port1_tx_data, // Data to transmit on Port 1
    output wire port1_tx_valid,      // Valid data indicator for Port 1 transmit

    // Port 2 Interface
    input wire [7:0] port2_rx_data,  // Data received from Port 2
    input wire port2_rx_valid,       // Valid data indicator for Port 2 receive
    output wire [7:0] port2_tx_data, // Data to transmit on Port 2
    output wire port2_tx_valid,      // Valid data indicator for Port 2 transmit

    // Port 3 Interface
    input wire [7:0] port3_rx_data,  // Data received from Port 3
    input wire port3_rx_valid,       // Valid data indicator for Port 3 receive
    output wire [7:0] port3_tx_data, // Data to transmit on Port 3
    output wire port3_tx_valid       // Valid data indicator for Port 3 transmit
);

    // Internal signals for parsed frame data
    wire [47:0] dest_mac_port1, dest_mac_port2, dest_mac_port3;
    wire [47:0] src_mac_port1, src_mac_port2, src_mac_port3;
    wire [7:0] payload_port1, payload_port2, payload_port3;
    wire crc_valid_port1, crc_valid_port2, crc_valid_port3;

    // FIFO buffers for each port
    wire [7:0] fifo1_tx_data, fifo2_tx_data, fifo3_tx_data;
    wire fifo1_tx_valid, fifo2_tx_valid, fifo3_tx_valid;

    // Frame Parsers for each port
    ethernet_frame_parser frame_parser_port1 (
        .clk(clk),
        .reset(reset),
        .rx_data(port1_rx_data),
        .rx_valid(port1_rx_valid),
        .dest_mac(dest_mac_port1),
        .src_mac(src_mac_port1),
        .payload(payload_port1),
        .crc_valid(crc_valid_port1)
    );

    ethernet_frame_parser frame_parser_port2 (
        .clk(clk),
        .reset(reset),
        .rx_data(port2_rx_data),
        .rx_valid(port2_rx_valid),
        .dest_mac(dest_mac_port2),
        .src_mac(src_mac_port2),
        .payload(payload_port2),
        .crc_valid(crc_valid_port2)
    );

    ethernet_frame_parser frame_parser_port3 (
        .clk(clk),
        .reset(reset),
        .rx_data(port3_rx_data),
        .rx_valid(port3_rx_valid),
        .dest_mac(dest_mac_port3),
        .src_mac(src_mac_port3),
        .payload(payload_port3),
        .crc_valid(crc_valid_port3)
    );

    // FIFO Buffers for each port to handle speed mismatches
    fifo_buffer fifo1 (
        .clk(clk),
        .reset(reset),
        .tx_data(fifo1_tx_data),
        .tx_valid(fifo1_tx_valid),
        .rx_data(payload_port1),
        .rx_valid(crc_valid_port1)
    );

    fifo_buffer fifo2 (
        .clk(clk),
        .reset(reset),
        .tx_data(fifo2_tx_data),
        .tx_valid(fifo2_tx_valid),
        .rx_data(payload_port2),
        .rx_valid(crc_valid_port2)
    );

    fifo_buffer fifo3 (
        .clk(clk),
        .reset(reset),
        .tx_data(fifo3_tx_data),
        .tx_valid(fifo3_tx_valid),
        .rx_data(payload_port3),
        .rx_valid(crc_valid_port3)
    );

    // Hub Logic - MAC address filtering and frame forwarding
    ethernet_hub_logic hub_logic (
        .clk(clk),
        .reset(reset),

        // Port 1 interface
        .port1_dest_mac(dest_mac_port1),
        .port1_payload(fifo1_tx_data),
        .port1_tx_valid(fifo1_tx_valid),
        .port1_tx_data(port1_tx_data),
        .port1_tx_ready(port1_tx_valid),

        // Port 2 interface
        .port2_dest_mac(dest_mac_port2),
        .port2_payload(fifo2_tx_data),
        .port2_tx_valid(fifo2_tx_valid),
        .port2_tx_data(port2_tx_data),
        .port2_tx_ready(port2_tx_valid),

        // Port 3 interface
        .port3_dest_mac(dest_mac_port3),
        .port3_payload(fifo3_tx_data),
        .port3_tx_valid(fifo3_tx_valid),
        .port3_tx_data(port3_tx_data),
        .port3_tx_ready(port3_tx_valid)
    );

endmodule
