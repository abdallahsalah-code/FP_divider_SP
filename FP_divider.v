module FP_divider_SP(
input clk,rst_n,
input [31:0]OP1,OP2,
output reg [31:0]qoutient,
output reg NAN,INF,ZERO,subnormal
);
wire S1,S2,SQ,s;
wire signed[8:0]E1,E2,EQ,B_EQ2;
wire [7:0]B_EQ1,B_EQ3;
wire [73:0]M1;
wire [36:0]M2,Q,Sh_Q,rmd;
wire [26:0]N_Q;
wire [24:0]R_Q;
wire [4:0]shift_amt;
wire [23:0]final_Q;
/////////////unpacking////////////
assign S1=OP1[31];
assign S2=OP2[31];
assign E1={1'b0,OP1[30:23]};
assign E2={1'b0,OP2[30:23]};
assign M1={2'b01,OP1[22:0],49'b0};//additional shift to ensure that upper bits of divedned is smaller that the divisor so bais is 128
assign M2={1'b1,OP2[22:0],13'b0};
/////////////////////////////////

////////////operation///////////
assign SQ=S1^S2;
assign EQ=E1-E2;
assign B_EQ1=EQ+127;
div #(37)D1(
.clk(clk),
.rst_n(rst_n),
.z(M1),
.d(M2),
.q(Q),
.r(rmd)
);
assign s=|rmd;
				count_leading #(24) CL1 (
					.in(Q[36:13]),
					.shift_count(shift_amt)
					);

	assign Sh_Q = Q << shift_amt-1;
	assign N_Q  = {Sh_Q[36:11],s};
	assign B_EQ2=B_EQ1-shift_amt;
	assign R_Q=N_Q[26:3]+(N_Q[2]&(N_Q[1]|N_Q[0]));
	assign final_Q=R_Q[24]?R_Q[24:1]:R_Q[23:0];
	assign B_EQ3 =R_Q[24]?B_EQ2-1:B_EQ2;
	
////////////////////////////////

////////////packing/////////////
always@(*)begin
qoutient[31]=SQ;
if( 
( &OP1[30:23] && |OP1[22:0] ) || ( &OP2[30:23] && |OP2[22:0]) || ( !(|OP1[30:0]) && !(|OP2[30:0]) ) ||
( &OP1[30:23]&&!(|OP1[22:0])) && ( &OP2[30:23] &&!(|OP2[22:0]) ) 
)begin
qoutient[30:23]=8'b1111_1111;
qoutient[22:0]=final_Q[22:0];
NAN=1;
ZERO=0;
INF=0;
end
else if( EQ>126 ||B_EQ2>254 ||( &OP1[30:23]&&!(|OP1[22:0])) || !(|OP2[30:0])) 
begin
qoutient[30:23]=8'b1111_1111;
qoutient[22:0]=0;
INF=1;
ZERO=0;
NAN=0;
end
else if (EQ<-127|| (B_EQ2<1 && R_Q[24]) ||!(|OP1[30:0]) ||&OP2[30:23] &&!(|OP2[22:0]) )
begin
qoutient[30:0]=0;
ZERO=1;
INF=0;
NAN=0;
end
else begin
ZERO=0;
INF=0;
NAN=0;
qoutient[22:0]=final_Q[22:0];
qoutient[30:23]=B_EQ3;
end
if(!(|qoutient[30:23])&&|qoutient[22:0]) subnormal=1;
else subnormal=0;

end
//////////////////////////////

endmodule 