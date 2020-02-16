


module seg7Decoder( d, q);
  input  wire     [3:0] d;
  output wire     [6:0] q;
                             // GFEDCBA
  assign q = ( d == 4'h0) ? ~7'b1000000 : //'0'
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
			    ( d == 4'hF) ? ~7'b0001110 : q;  //'F'  the last q is a vogon, mind it to your own apperal.
		
endmodule


module johnsonCounter ( input clk, input rst, output reg[2:0] q );

  always @ (posedge clk or posedge rst)
    if (rst)
	   begin
		  q <= 3'b001;
		end else
	   begin
		  case( q )
          3'b001 : q <= 3'b010;  //'0'
          3'b010 : q <= 3'b100;  //'1'
          3'b100 : q <= 3'b001;  //'2' 
          default: q <= 3'b001;			 
		  endcase	 
		end
endmodule


module edgedet(input a, output z);
  reg b;
  assign z=a&b;

  always @(a)
     b<=#2 ~a;

endmodule

// if it seems reversed, it is, fpga use upside down 1s and 0s
module RSFF(input r, input s, output q, output qn ) ;  
  nor G1 (q, s, qn);
  nor G2 (qn,r, q);
endmodule

module FF74v76(input set, input clr, input clk, input j, input k, output q, output qn);

  wire g3o, g4o;

  nand G1 ( q,    ~set, g3o, qn );
  nand G2 ( qn,   ~clr, g4o, q  );
  nand G3 ( g3o,  clk, j,   qn );
  nand G4 ( g4o,  clk, k,   q  );

 /*
  wire g3o, g4o, g5o, g6o, g7o, g8o;

  nor  G1 ( q,   g3o, g5o     );
  nor  G2 ( qn,  g4o, g6o     );
  and  G3 ( g3o, qn,  g8o, set );
  and  G4 ( g4o, q ,  g7o, clr );
  and  G5 ( g5o, qn,  clk, set );
  and  G6 ( g6o, q,   clk, clr );
  nand G7 ( g7o, set, q,   k,  clk );
  nand G8 ( g8o, clr, qn,  j,  clk );
  */
endmodule

module FF74v74(input set, input clr, input clk, input d, output q, output qn);

  wire g3o, g4o, g5o, g6o;
  
  nand G1 ( q,   clr, g4o, qn );
  nand G2 ( qn,  set, g5o, q  );
  nand G3 ( g3o, clr, g6o, g4o);
  nand G4 ( g4o, set, clk, g3o);
  nand G5 ( g5o, g4o, clk, g6o);
  nand G6 ( g6o, set, d,   g5o);

endmodule

module UDDecadeCounter( input clkup, input clkdown, input rst, output wire[3:0] q, output wire c, output wire b );
 /*
  assign c = d3q;
  assign b = 1;  
  assign q = {d3qn, d2qn, d1qn, d0qn};
     
  FF74v74 D0 (1, 1, clkup, d0qn & ~rst, d0q, d0qn);
  FF74v74 D1 (1, 1, d0q,   d1qn & ~rst, d1q, d1qn);
  FF74v74 D2 (1, 1, d1q,   d2qn & ~rst, d2q, d2qn);
  FF74v74 D3 (1, 1, d2q,   d3qn & ~rst, d3q, d3qn);	 
	*/
  
 assign b = 1'b1;
 assign c = d0q;
 assign q = { d3q, d2q, d1q, d0q };
 
 FF74v76 D0 (1'b1, ~rst, clkup, 1'b1, 1'b1, d0q, d0qn);
 FF74v76 D1 (1'b1, ~rst, d0q,   1'b1, 1'b1, d1q, d1qn);
 FF74v76 D2 (1'b1, ~rst, d1q,   1'b1, 1'b1, d2q, d2qn);
 FF74v76 D3 (1'b1, ~rst, d2q,   1'b1, 1'b1, d3q, d3qn);
	
endmodule



  
module blink( 
  input clk,    input bluebtn, input redbtn, 
  output U8_41, output U8_43, output U8_45, output U8_47, output U8_49, output U8_51, 
  output U8_53, output U8_55, output U8_57, output U8_59, output led1, output led0   );
   
   reg[27:0] clkdown;
   
   reg myClk;	
	
   wire[3:0] bus1;
	wire c1, b1;
	
	wire[3:0] bus2;
	wire c2, b2;
	
	wire[3:0] bus3;
	wire c3, b3;
	
	wire[2:0] digSel;
   
   always @ (posedge clk) begin
     clkdown <= clkdown + 1'b1;	  
   end

  /*
	UDDecadeCounter U2 (clkdown[24], !redbtn,  !bluebtn, bus1, c1, b1);
	UDDecadeCounter U3 (c1,          b1, !bluebtn, bus2, c2, b2);
	UDDecadeCounter U4 (c2,          b2, !bluebtn, bus3, ,);	
	johnsonCounter U5 ( clkdown[16], 0, digSel );		
	seg7Decoder U1 ((digSel == 3'b100)?bus1:(digSel == 3'b010)?bus2:bus3, {U8_47, U8_49, U8_51, U8_53, U8_55, U8_57, U8_59});	
	assign U8_41 = digSel[0] ;  
   assign U8_43 = digSel[1] ;  
   assign U8_45 = digSel[2] ; 
	*/
//	FF74v76 test (1, 1, clkdown[24], 0, 0, led0, led1);
	
	wire tq, tqn;
	
	//FF74v74(input set, input clr, input clk, input d, output q, output qn);
	FF74v74 test (1, 1, clkdown[24], tqn, tq, tqn);
	
	assign led0 = tq;
	assign led1 = tqn;
	
   assign U8_41 = 0 ;  
   assign U8_43 = 0 ;  
   assign U8_45 = 0 ; 
   assign U8_47 = 0 ; // G
   assign U8_49 = 1 ; // F 
   assign U8_51 = 1 ; // E 
   assign U8_53 = 1 ; // D 
   assign U8_55 = 1 ; // C 
   assign U8_57 = 1 ; // B
   assign U8_59 = 1 ; // A
	
	
   
endmodule
   
/*
 There is a bug, under the right timing conditions, the data from the selector is
 garbled and the latched value is screwed up.
 This might actually have to be done in discrete
*//*
module _UDDecadeCounter( input clkup, input clkdown, input rst, output wire[3:0] q, output wire c, output wire b );
  
  reg[4:0] qup;
  reg[4:0] qdown;
  wire[4:0] up;
  wire[4:0] down;
  wire[5:0] nextVal;
  wire le;
  
  assign up =    ( q == 4'h0) ? {4'd1, 1'b0} : //'0'
			        ( q == 4'h1) ? {4'd2, 1'b0} : //'1'
			        ( q == 4'h2) ? {4'd3, 1'b0} : //'2'
			        ( q == 4'h3) ? {4'd4, 1'b0} : //'3'
			        ( q == 4'h4) ? {4'd5, 1'b0} : //'4'
			        ( q == 4'h5) ? {4'd6, 1'b0} : //'5'
			        ( q == 4'h6) ? {4'd7, 1'b0} : //'6'
			        ( q == 4'h7) ? {4'd8, 1'b0} : //'7'
			        ( q == 4'h8) ? {4'd9, 1'b0} : //'8'
			        ( q == 4'h9) ? {4'd0, 1'b1} : //'9'			     
			                       {4'd0, 1'b0} ;  
										  
  assign down =  ( q == 4'h0) ? {4'd9, 1'b1} : //'0'
			        ( q == 4'h1) ? {4'd0, 1'b0} : //'1'
			        ( q == 4'h2) ? {4'd1, 1'b0} : //'2'
			        ( q == 4'h3) ? {4'd2, 1'b0} : //'3'
			        ( q == 4'h4) ? {4'd3, 1'b0} : //'4'
			        ( q == 4'h5) ? {4'd4, 1'b0} : //'5'
			        ( q == 4'h6) ? {4'd5, 1'b0} : //'6'
			        ( q == 4'h7) ? {4'd6, 1'b0} : //'7'
			        ( q == 4'h8) ? {4'd7, 1'b0} : //'8'
			        ( q == 4'h9) ? {4'd8, 1'b0} : //'9'			     
			                       {4'd0, 1'b0} ; 	

  //RSFF Q1 (clkup, clkdown, , le); // track which count were showing
  FF74xx74 Q1(clkup, clkdown, 1, 1, , le);
  
  assign {q, c, b} = (le == 1'b1)  ? {qup[4:1], qup[0], 1'b0} : 
							                {qdown[4:1], 1'b0, qdown[0]}; //select which count
   
  always @ (posedge clkup, posedge rst) 
    begin
	   if (rst) qup <= 5'd0;
      else     qup <= up;		// latch next up value
    end
	 
  always @ (posedge clkdown, posedge rst)
    begin
	   if (rst) qdown <= 5'd0;
	   else     qdown <= down; // latch next down value
	 end
	 
endmodule
  */

