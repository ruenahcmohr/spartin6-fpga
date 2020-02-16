

module seg7Decoder( d, q);
  input  wire     [3:0] d;
  output wire     [6:0] q;
                             
  assign q =        // GFEDCBA
    ( d == 4'h0) ? ~7'b1000000 : //'0'
    ( d == 4'h1) ? ~7'b1111001 : //'1'
    ( d == 4'h2) ? ~7'b0100100 : //'2'
    ( d == 4'h3) ? ~7'b0110000 : //'3'
    ( d == 4'h4) ? ~7'b0011001 : //'4'
    ( d == 4'h5) ? ~7'b0010010 : //'5'
    ( d == 4'h6) ? ~7'b0000010 : //'6'
    ( d == 4'h7) ? ~7'b1111000 : //'7'
    ( d == 4'h8) ? ~7'b0000000 : //'8'
    ( d == 4'h9) ? ~7'b0010000 : //'9'
    ( d == 4'hA) ? ~7'b0001000 : //'A'
    ( d == 4'hB) ? ~7'b0000011 : //'b'
    ( d == 4'hC) ? ~7'b0100111 : //'C'
    ( d == 4'hD) ? ~7'b0100001 : //'d'
    ( d == 4'hE) ? ~7'b0000110 : //'E'
    ( d == 4'hF) ? ~7'b0001110 : ~7'b0;  //'F'  the last value is a vogon, mind it to your own apperal.       
endmodule


module norRS(input r, input s, output q, output qn ) ;   // working!
  nor G1 (q, r, qn);
  nor G2 (qn,s, q);
endmodule

module TTL279(input rn, input sn, output q, output qn ) ;  // working!
  nand G1 (q, sn, qn);
  nand G2 (qn,rn, q);
endmodule

module TTL74(input set, input rst, input clk, input d, output q, output qn); // works  
  nand G1 ( q,   set, g4o, qn );
  nand G2 ( qn,  rst, g5o, q  );
  nand G3 ( g3o, set, g6o, g4o);
  nand G4 ( g4o, rst, clk, g3o);
  nand G5 ( g5o, g4o, clk, g6o);
  nand G6 ( g6o, rst, d,   g5o);
endmodule

module TTL72(input set, input clr, input clk, input j, input k, output q, output qn);
  nand G1 ( q,   qn, g4o, set ); 
  nand G2 ( qn,  q,  g3o, clr );
  nand G3 ( g3o, g6o, g7o );
  nand G4 ( g4o, g5o, g8o );
  nand G5 ( g5o, g6o, set, g8o );
  nand G6 ( g6o, g5o, clr, g7o );
  nand G7 ( g7o, set, q,  k, clk);
  nand G8 ( g8o, clr, qn, j, clk);  
endmodule

module CMOS17(input clk, input rst, output wire [9:0] q, output cout);
  reg [3:0] c;
  always @ (posedge clk or posedge rst) 
    begin
	   if (rst) c = 0;
		else 
		  if (c > 8) c = 0;
		  else c = c + 1;		  
	 end	
	 
	 assign {q, cout} =        
    ( c == 4'h0) ? {10'b0000000001,1'b1} : //'0'
    ( c == 4'h1) ? {10'b0000000010,1'b1} : //'1'
    ( c == 4'h2) ? {10'b0000000100,1'b1} : //'2'
    ( c == 4'h3) ? {10'b0000001000,1'b1} : //'3'
    ( c == 4'h4) ? {10'b0000010000,1'b1} : //'4'
    ( c == 4'h5) ? {10'b0000100000,1'b0} : //'5'
    ( c == 4'h6) ? {10'b0001000000,1'b0} : //'6'
    ( c == 4'h7) ? {10'b0010000000,1'b0} : //'7'
    ( c == 4'h8) ? {10'b0100000000,1'b0} : //'8'
                   {10'b1000000000,1'b0} ; //'9'
    
	 
endmodule


/*
module Synch2bit( input clr, input clk, output [1:0] q);
  TTL72 U1 (1, clr, clk, 1,    1,    q[0], u1qn);
  TTL72 U2 (1, clr, clk, q[0], q[0], q[1], u2qn);  
endmodule
*/

/*
module synch4bitBin(input clr, input clk, output [3:0] q);
//TTL72    (input set, input clr, input clk, input j, input k, output q, output qn);
  TTL72 U1 ( 1'b1, clr, clk ,1'b1, 1'b1, u1q, u1qn);
  TTL72 U2 ( 1'b1, clr, clk ,u1q,  u1q,  u2q, u2qn); 
  TTL72 U3 ( 1'b1, clr, clk ,og1,  og1,  u3q, u3qn);
  TTL72 U4 ( 1'b1, clr, clk ,og2,  og2,  u4q, u4qn); 
  
  and G1 ( og1, u1q,  u2q );
  and G2 ( og2, og1,  u3q );
  
  assign q = {u4q, u3q, u2q, u1q};
endmodule
*/

module tff (   input clk, input rstn,  output reg q, output qn); 

  assign qn = ~q;
  
  always @ (posedge clk or negedge rstn) begin
    if (!rstn) 
      q <= 0;
    else
      q <= ~q;   
  end
endmodule

module Synch4bitDecadeUD (input clr, input clkup, input clkdown, output [3:0] q, output CU, output CD);
  //tff (   input clk, input rstn,  output reg q, qn);
  tff U1 ( og5,  clr, u1q, u1qn);
  tff U2 ( og11, clr, u2q, u2qn);
  tff U3 ( og17, clr, u3q, u3qn);
  tff U4 ( og24, clr, u4q, u4qn);
  
  nor  G5 (og5, ~clkup, ~clkdown);

  and  G9 (og9, ~clkup, u4qn, u1q ); 
  and  G10(og10, u1qn, ~clkdown, og18 );
  nor  G11(og11, og9, og10);
  
  and  G15(og15, ~clkup, u1q, u2q );
  and  G16(og16, u2qn, u1qn, ~clkdown, og18);
  nor  G17(og17, og15, og16 );
  
  nand G18(og18, u2qn, u3qn, u4qn );
  
  and  G21(og21, ~clkup, u1q, u2q, u3q);
  and  G22(og22, ~clkup, u1q, u4q );
  and  G23(og23, u3qn, u2qn, u1qn, ~clkdown);
  nor  G24(og24, og21, og22, og23);
  
  nand G28(CU, ~clkup, u1q, u4q);
  nand G29(CD, ~clkdown, u1qn, u2qn, u3qn, u4qn);
  
  assign q = {u4q, u3q, u2q, u1q};
  
endmodule
 
  
  
module main( input clk, input bluebtn, input redbtn, output led1, output led3,
  output U8_41, output U8_43, output U8_45, output U8_47, output U8_49, 
  output U8_51, output U8_53, output U8_55,output U8_57, output U8_59);
   
   reg[27:0] clkdown;    
   
   always @ (posedge clk) begin
     clkdown <= clkdown + 1'b1;	  
   end
		
 // assign led1 = clkdown[24];               // test 1, which is led1
 // assign led1 = 1;                         // test 2, is 1 on or off (its off)
 // assign led1 = bluebtn;                   // test 3, is normal button 1 or 0? (its 1)
 
 	not(led1, D1); // this will fix up the led polarity, use ~ to correct buttons if req'd
	not(led3, D3);
	
 // norRS  U1 (~bluebtn, ~redbtn, D1, D3 );  // test 4, nor RS latch
 // TTL297 U1 (bluebtn, redbtn, D1, D3 );    // test 5, nand RS latch
 //  TTL74 U1 (redbtn, bluebtn, 1, 1, D1, D3);   // test 6, RS with 74v74
 //  TTL74 U1 (1, 1, redbtn, ~bluebtn, D1, D3);  // test 7, D  with 74v74
	
	/*
	// test 8 ripple counter with clear;
   TTL74 U1 (1, bluebtn, clkdown[24], U1qn, U1q, U1qn); 
   TTL74 U2 (1, bluebtn, U1qn,        U2qn, U2q, U2qn);
	assign D1 = U1q;
	assign D3 = U2q;
	*/
	
 //  TTL72 U1 (redbtn, bluebtn, 1, 1, 1, D1, D3); // test 9 JK set/reset
 //  TTL72 U1 (1, 1, clkdown[24], 1, 1, D1, D3); // test 10, clocked JK operation - toggle test
 //  TTL72 U1 (1, 1, clkdown[24], ~redbtn, ~bluebtn, D1, D3); // test 11, clocked JK operation - button test
  
  	/*
	// test 12 ripple counter with clear;
   TTL72 U1 (1, bluebtn, clkdown[24], 1, 1, U1q, U1qn); 
   TTL72 U2 (1, bluebtn, U1q,         1, 1, U2q, U2qn);
	assign D1 = U1q;
	assign D3 = U2q;
	*/
	
	// test 13, 2 bit synchronous counter.
   // Synch2bit U1 ( bluebtn, clkdown[24], {D3, D1});
 
   // test 14, 4 bit synchronous with async reset 
   // synch4bitBin(bluebtn, clkdown[24], { U8_49 , U8_57 , U8_51 ,U8_55}); 
	
	// test 15, 4 bit up/down sync with async reset
   //Synch4bitDecadeUD U1 (bluebtn, clkdown[24] , 1'b1  , { U8_49 , U8_57 , U8_51 ,U8_55} , D3 , D1 );   
 
   /*
   // test 16, test 15 to a 7 segemnt
	wire [3:0] d;
	Synch4bitDecadeUD U1 (bluebtn,  1'b1, clkdown[24] , d , D3 , D1 );
   seg7Decoder U2 ( d, { U8_47,U8_49,U8_51, U8_53, U8_55 , U8_57 ,U8_59 });
   */
	
	/*
	// test 17 updown at same time, good luck with that switch bounce!
   wire [3:0] d;
	Synch4bitDecadeUD U1 (1'b1,  bluebtn|clkdown[24], (~bluebtn)|clkdown[24] , d , D3 , D1 );
   seg7Decoder U2 ( d, { U8_47, U8_49, U8_51, U8_53, U8_55 , U8_57 ,U8_59 });
	*/
	
	// test 18, johnston counter
//	CMOS17 U1 (clkdown[24], ~bluebtn, {u1o9,u1o8,u1o7,u1o6,U8_49, U8_51, U8_53, U8_55 , U8_57 ,U8_59 }, D1);
   
   // test 20, johnston counter		
	// CMOS17 U1 (clkdown[24], u1o6, {u1o9,u1o8,u1o7,u1o6,U8_49,U8_51, U8_53, U8_55 , U8_57 ,U8_59 }, D1);
	
  // test 19, cycling counter
  // CMOS17 U1 (clkdown[24], u1o3, {u1o9,u1o8,u1o7,u1o6,u1o5,u1o4,u1o3, U8_41 ,U8_43 ,U8_45 }, D1);
			
	
	// test    3 digit updown counter
	wire [3:0] d0, d1, d2;
	Synch4bitDecadeUD U1 (bluebtn,  clkdown[23], 1'b1 , d0 , u1cu , u1cd );
	Synch4bitDecadeUD U2 (bluebtn,  u1cu, u1cd , d1 , u2cu , u2cd );
	Synch4bitDecadeUD U3 (bluebtn,  u2cu, u2cd , d2 , u3cu , u3cd );
	CMOS17 U4 (clkdown[16], u1o3, {u1o9,u1o8,u1o7,u1o6,u1o5,u1o4,u1o3, U8_41 ,U8_43 ,U8_45 }, D1);
   seg7Decoder U5 ( U8_45?d0:U8_43?d1:d2, { U8_47,U8_49,U8_51, U8_53, U8_55 , U8_57 ,U8_59 });

	
 
  // assign U8_41 = 1'b1 ; 

  //assign D1 = clkdown[24];
  //assign D3 = 0;
	
   //assign U8_41 = 0 ;  
  // assign U8_43 = 0 ;  
  // assign U8_45 = 0 ; 
 //  assign U8_47 = 1 ; // G
 //  assign U8_49 = 0 ; // F 
 //  assign U8_51 = 0 ; // E 
 // assign U8_53 = 0 ; // D 
 //  assign U8_55 = 0 ; // C 
 //  assign U8_57 = 0 ; // B
 //  assign U8_59 = 0 ; // A
	
	
   
endmodule
   
