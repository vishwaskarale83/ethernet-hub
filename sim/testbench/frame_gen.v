module frame_gen(
    input wire clk,
    input wire rst,
    input wire enable,
    output reg [7:0] frame_data,
    output reg frame_valid
);

    // Ethernet frame fields
    reg [47:0] dst_mac;
    reg [47:0] src_mac;
    reg [15:0] eth_type;
    reg [31:0] crc;
    reg [7:0] payload_data[0:1499]; // Ethernet payload (max 1500 bytes)

    integer i;
    reg [11:0] frame_size;
    reg [11:0] byte_count;

    typedef enum {IDLE, GEN_HEADER, GEN_PAYLOAD, GEN_CRC, DONE} state_type;
    state_type state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            frame_valid <= 0;
            byte_count <= 0;
            frame_data <= 8'h00;
        end else begin
            case (state)
                IDLE: begin
                    if (enable) begin
                        state <= GEN_HEADER;
                        frame_valid <= 1;
                        byte_count <= 0;
                        dst_mac <= 48'hFF_FF_FF_FF_FF_FF;  // Broadcast MAC for testing
                        src_mac <= 48'hAA_BB_CC_DD_EE_FF;  // Sample source MAC
                        eth_type <= 16'h0800;              // IPv4 EtherType
                        frame_size <= 64 + 100;            // Ethernet frame size: header + payload + CRC
                    end
                end

                GEN_HEADER: begin
                    case (byte_count)
                        0: frame_data <= dst_mac[47:40];
                        1: frame_data <= dst_mac[39:32];
                        2: frame_data <= dst_mac[31:24];
                        3: frame_data <= dst_mac[23:16];
                        4: frame_data <= dst_mac[15:8];
                        5: frame_data <= dst_mac[7:0];
                        6: frame_data <= src_mac[47:40];
                        7: frame_data <= src_mac[39:32];
                        8: frame_data <= src_mac[31:24];
                        9: frame_data <= src_mac[23:16];
                        10: frame_data <= src_mac[15:8];
                        11: frame_data <= src_mac[7:0];
                        12: frame_data <= eth_type[15:8];
                        13: frame_data <= eth_type[7:0];
                        default: state <= GEN_PAYLOAD;
                    endcase
                    byte_count <= byte_count + 1;
                end

                GEN_PAYLOAD: begin
                    if (byte_count < frame_size - 4) begin
                        frame_data <= payload_data[byte_count - 14];
                        byte_count <= byte_count + 1;
                    end else begin
                        state <= GEN_CRC;
                    end
                end

                GEN_CRC: begin
                    // Generate sample CRC (for simplicity, not accurate)
                    case (byte_count - frame_size + 4)
                        0: frame_data <= crc[31:24];
                        1: frame_data <= crc[23:16];
                        2: frame_data <= crc[15:8];
                        3: frame_data <= crc[7:0];
                    endcase
                    byte_count <= byte_count + 1;
                    if (byte_count == frame_size) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    frame_valid <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

    initial begin
        // Initialize CRC and payload for simplicity
        crc = 32'hDEADBEEF;
        for (i = 0; i < 1500; i = i + 1) begin
            payload_data[i] = i[7:0];
        end
    end

endmodule
