module ethernet_hub_logic (
    input wire clk,
    input wire reset,
    
    // Port 1
    input wire [47:0] port1_dest_mac,
    input wire [7:0] port1_payload,
    input wire port1_tx_valid,
    output reg [7:0] port1_tx_data,
    output reg port1_tx_ready,

    // Port 2
    input wire [47:0] port2_dest_mac,
    input wire [7:0] port2_payload,
    input wire port2_tx_valid,
    output reg [7:0] port2_tx_data,
    output reg port2_tx_ready,

    // Port 3
    input wire [47:0] port3_dest_mac,
    input wire [7:0] port3_payload,
    input wire port3_tx_valid,
    output reg [7:0] port3_tx_data,
    output reg port3_tx_ready
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs
            port1_tx_ready <= 0;
            port2_tx_ready <= 0;
            port3_tx_ready <= 0;
        end else begin
            // Forward frames based on MAC addresses
            if (port1_tx_valid) begin
                port2_tx_data <= port1_payload;
                port3_tx_data <= port1_payload;
                port2_tx_ready <= 1;
                port3_tx_ready <= 1;
            end

            if (port2_tx_valid) begin
                port1_tx_data <= port2_payload;
                port3_tx_data <= port2_payload;
                port1_tx_ready <= 1;
                port3_tx_ready <= 1;
            end

            if (port3_tx_valid) begin
                port1_tx_data <= port3_payload;
                port2_tx_data <= port3_payload;
                port1_tx_ready <= 1;
                port2_tx_ready <= 1;
            end
        end
    end

endmodule
