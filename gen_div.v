module div #(parameter n = 37)(
input clk,rst_n,
input [2*n-1:0]z,[n-1:0]d,
output [n-1:0]q,r
);
wire [n-1:0]diff;
wire [n-1:0]trial_diff; 
wire SQ;
reg [2*n-1:0]part;
reg [n-1:0]div;

assign diff=part[2*n-2:n-1]+(~div)+1'b1; //find differnce
assign SQ=(div<=part[2*n-1:n-1]);       //check if upper dividend higher than divisor included MSB
assign trial_diff=SQ? diff:part[2*n-2:n-1]; //load if Cout=1 or MSB is 1
assign {r,q}=part; //wire out the output
always @(posedge clk or negedge rst_n) 
    begin
	if(!rst_n)
	begin
	part <= z;
	div <= d;
	
	
	end

	else
	begin
		

		part <= {trial_diff,part[n-2:0],SQ}; //shift and load the partial trail reminder and the Q bit

	end
    end 
endmodule
/*
`timescale 1ns/1ps
module div_TB();
parameter width=26;
parameter delay=10*width;
wire  [width-1:0]qoutient,reminder;
reg clk,reset;
reg [2*width-1:0]dividend;
reg [width-1:0] divisor;
div #(width) uut1(clk,reset,dividend,divisor,qoutient,reminder);

initial
begin
clk=0;
#10
repeat(3000)#5 clk=~clk;
end

initial
begin
dividend=74'b10100000000000000000000000000000000000000000000000000000000000000000000000;
divisor=37'b1010000000000000000000000000000000000; 
reset=0;
#10 reset=1;
#(delay)
$display("A=%d B=%d resultA*B=%d,remind=%b,%d,%d",dividend,divisor,qoutient,reminder,(dividend/divisor),(dividend%divisor));
dividend=500100;
divisor=1000;
reset=0;
#10 reset=1;
#(delay)
$display("A=%d B=%d resultA*B=%d,remind=%d,%d,%d",dividend,divisor,qoutient,reminder,(dividend/divisor),(dividend%divisor));
dividend=11;
divisor=3;
reset=0;
#10 reset=1;
#(delay)
$display("A=%d B=%d resultA*B=%d,remind=%d,%d,%d",dividend,divisor,qoutient,reminder,(dividend/divisor),(dividend%divisor));
/*repeat(50)begin
dividend=$random;
divisor=$random;
reset=0;
#10 reset=1;
#(delay)
$display("A=%d B=%d resultA*B=%d,remind=%d,%d,%d",dividend,divisor,qoutient,reminder,(dividend/divisor),(dividend%divisor));
end

dividend=10501;
divisor=450;
reset=0;
#10 reset=1;
#(delay)
$display("A=%d B=%d resultA*B=%d,remind=%d,%d,%d",dividend,divisor,qoutient,reminder,(dividend/divisor),(dividend%divisor));
dividend=2147648;
divisor=2080;
reset=0;
#10 reset=1;
#(delay)
$display("A=%d B=%d resultA*B=%d,remind=%d,%d,%d",dividend,divisor,qoutient,reminder,(dividend/divisor),(dividend%divisor));
dividend=15000;
divisor=254;
reset=0;
#10 reset=1;
#(delay)
$display("A=%d B=%d resultA*B=%d,remind=%d,%d,%d",dividend,divisor,qoutient,reminder,(dividend/divisor),(dividend%divisor));
dividend=3;
divisor=3;
reset=0;
#10 reset=1;
#(delay)
$display("A=%d B=%d resultA*B=%d,remind=%d,%d,%d",dividend,divisor,qoutient,reminder,(dividend/divisor),(dividend%divisor));
dividend=153241;
divisor=2000;
reset=0;
#10 reset=1;
#(delay)
$display("A=%d B=%d resultA*B=%d,remind=%d,%d,%d",dividend,divisor,qoutient,reminder,(dividend/divisor),(dividend%divisor));

end
endmodule
*/