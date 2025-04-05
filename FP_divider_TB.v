`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 10:55:49 PM
// Design Name: 
// Module Name: FP_divider_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module FP_divider_TB();

parameter delay=380;

wire NAN,INF,ZERO,subnormal;
wire [31:0]qoutient;
reg clk,reset;
reg [31:0]OP1,OP2;
FP_divider_SP DUT(
clk,reset,
OP1,OP2,
qoutient,
NAN,INF,ZERO,subnormal
);
initial
begin
clk=0;
#10
repeat(3000)#5 clk=~clk;
end

initial
begin
OP1=32'h40c00000;
OP2=32'h00000000;
reset=0;
#10 reset=1;
#(delay)
$display("%0t A=%h B=%h resultA*B=%h,zero=%d,INF=%d,NAN=%d",$time,OP1,OP2,qoutient,ZERO,INF,NAN);
OP1=32'h7f200000;
OP2=32'h3e200000;
reset=0;
#10 reset=1;
#(delay)
$display("%0t A=%h B=%h resultA*B=%h,zero=%d,INF=%d,NAN=%d,subnormal=%d",$time,OP1,OP2,qoutient,ZERO,INF,NAN,subnormal);

    // Special Case 1: Positive Zero Divided by Positive Number
    OP1 = 32'h00000000;  // +0.0
    OP2 = 32'h40400000;  // 3.0
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);

    // Special Case 2: Negative Zero Divided by Positive Number
    OP1 = 32'h80000000;  // -0.0
    OP2 = 32'h40400000;  // 3.0
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);

    // Special Case 3: Positive Number Divided by Infinity
    OP1 = 32'h40400000;  // 3.0
    OP2 = 32'h7F800000;  // +Infinity
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);

    // Special Case 4: Negative Number Divided by Infinity
    OP1 = 32'hC0400000;  // -3.0
    OP2 = 32'h7F800000;  // +Infinity
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);

    // Special Case 5: Infinity Divided by Infinity
    OP1 = 32'h7F800000;  // +Infinity
    OP2 = 32'hFF800000;  // -Infinity
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);

    // Special Case 6: Subnormal Number Divided by Subnormal Number
    OP1 = 32'h00000001;  // Smallest subnormal number
    OP2 = 32'h00000002;  // Another small subnormal number
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);

    // Common Case 3: Division Resulting in Exact Fraction
    OP1 = 32'h40800000;  // 4.0
    OP2 = 32'h40400000;  // 3.0
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);

    // Common Case 4: Negative Result Division
    OP1 = 32'hC0400000;  // -3.0
    OP2 = 32'h40400000;  // 3.0
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);

    // Common Case 5: Large Number Divided by Small Number
    OP1 = 32'h40e00000;  // Largest finite number
    OP2 = 32'h41300000;  // Smallest subnormal number
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);

    // Common Case 6: Division by Negative Subnormal Number
    OP1 = 32'h40400000;  // 3.0
    OP2 = 32'h80000001;  // Negative smallest subnormal
    reset = 0;
    #10 reset = 1;
    #(delay);
    $display("%0t A=%h B=%h resultA/B=%h, zero=%d, INF=%d, NAN=%d, subnormal=%d", 
             $time, OP1, OP2, qoutient, ZERO, INF, NAN, subnormal);
end

endmodule