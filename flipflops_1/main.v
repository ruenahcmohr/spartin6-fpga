

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

module Synch2bit( input clr, input clk, output [1:0] q);
  TTL72 U1 (1, clr, clk, 1,    1,    q[0], u1qn);
  TTL72 U2 (1, clr, clk, q[0], q[0], q[1], u2qn);  
endmodule


module synch4bitBin(input clr, input clk, output [4:0] q);
//TTL72    (input set, input clr, input clk, input j, input k, output q, output qn);
  TTL72 U1 ( 1'b1, clr, clk ,1'b1, 1'b1, u1q, u1qn);
  TTL72 U2 ( 1'b1, clr, clk ,u1q,  u1q,  u2q, u2qn); 
  TTL72 U3 ( 1'b1, clr, clk ,og1,  og1,  u3q, u3qn);
  TTL72 U4 ( 1'b1, clr, clk ,og2,  og2,  u4q, u4qn); 
  
  and G1 ( og1, u1q,  u2q );
  and G2 ( og2, og1,  u3q );
  
  assign q = {u4q, u3q, u2q, u1q};
endmodule



module Synch4bitDecadeUD (input clr, input clkup, input clkdown, output [4:0] q, output CU, output CD);
//TTL72    (input set, input clr, input clk, input j, input k, output q, output qn);
  TTL72 U1 ( 1'b1, clr, ~og5  ,1'b1, 1'b1, u1q, u1qn);
  TTL72 U2 ( 1'b1, clr, ~og11 ,1'b1, 1'b1, u2q, u2qn); 
  TTL72 U3 ( 1'b1, clr, ~og17 ,1'b1, 1'b1, u3q, u3qn);
  TTL72 U4 ( 1'b1, clr, ~og24 ,1'b1, 1'b1, u4q, u4qn);   
  
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
 
   Synch4bitDecadeUD U1 (bluebtn, clkdown[24], 1 , { U8_49 , U8_57 , U8_51 ,U8_55} , D3 , D1 );
  
  // synch4bitBin(bluebtn, clkdown[24], { U8_49 , U8_57 , U8_51 ,U8_55});
 
   assign U8_41 = 1 ; 

  // assign U8_49 = 1 ; // F 
  // assign U8_51 = 1 ; // E 
  // assign U8_55 = 1 ; // C 
  // assign U8_57 = 1 ; // B

	
   //assign U8_41 = 0 ;  
   assign U8_43 = 0 ;  
   assign U8_45 = 0 ; 
   assign U8_47 = 0 ; // G
   //assign U8_49 = 1 ; // F 
   //assign U8_51 = 1 ; // E 
   assign U8_53 = 0 ; // D 
   //assign U8_55 = 1 ; // C 
   //assign U8_57 = 1 ; // B
   assign U8_59 = 0 ; // A
	
	
   
endmodule
   
