module count_leading #(
    parameter N = 24,                  // Input width (e.g., 26-bit)
    parameter WIDTH = $clog2(N)       // Output width (log2(N) + 1)
)(
    input  [N-1:0] in,                // Input signal
    output [WIDTH-1:0] shift_count     // 1-based index of first '1' from MSB
);

// Chain of assignments to prioritize MSB-to-LSB
wire [WIDTH-1:0] shift_chain [N:0];   // Chain of shift values
        
assign shift_chain[N-1] =in[N-1]; //MSB SHIFTvalue
genvar i;
generate
  for (i = N-2; i >= 0; i = i-1) begin : gen_priority
    // Check if current bit is the first '1' (MSB priority)
    assign shift_chain[i] = (in[i] && !(|in[N-1:i+1])) ? 
                            (N - i) :       // 1-based shift count
                            shift_chain[i+1];           // Propagate lower priority
  end
endgenerate

assign shift_count = shift_chain[0]; // Final output

endmodule
