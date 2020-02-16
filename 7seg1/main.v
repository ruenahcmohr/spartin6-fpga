
module seg7Decoder( d, q);
  input      [3:0] d;
  output reg [6:0] q;

  always @* begin
   case( d )
			4'h0 : q <= ~7'b1000000;  //'0'
			4'h1 : q <= ~7'b1111001;  //'1'
			4'h2 : q <= ~7'b0100100;  //'2'
			4'h3 : q <= ~7'b0110000;  //'3'
			4'h4 : q <= ~7'b0011001;  //'4'
			4'h5 : q <= ~7'b0010010;  //'5'
			4'h6 : q <= ~7'b0000010;  //'6'
			4'h7 : q <= ~7'b1111000;  //'7'
			4'h8 : q <= ~7'b0000000;  //'8'
			4'h9 : q <= ~7'b0010000;  //'9'
			4'hA : q <= ~7'b0001000;  //'A'
			4'hB : q <= ~7'b0000011;  //'b'
			4'hC : q <= ~7'b1000110;  //'C'
			4'hD : q <= ~7'b0100001;  //'d'
			4'hE : q <= ~7'b0000110;  //'E'
			4'hF : q <= ~7'b0001110;  //'F'
		endcase
	end 	

endmodule
   
  
module blink( input clk, input bluebtn, output U8_41, output U8_43, 
  output U8_45, output U8_47, output U8_49, output U8_51, 
  output U8_53, output U8_55,output U8_57, output U8_59);
   
   reg[27:0] clkdown;
   
   reg myClk;	
   
   always @ (posedge clk) begin
     clkdown <= clkdown + 1'b1;	  
   
	// if (clkdown == 8'd254) begin
	//    clkdown <= 0;
	//	 myClk <= !myClk;
	//  end
   end
	
	always @ (posedge myClk) begin
 
	end
	
	
   assign U8_41 = 0 ;  // not connected
   assign U8_43 = 0 ;  // not connected
	
	seg7Decoder U1 (clkdown[27:24], {U8_47, U8_49, U8_51, U8_53, U8_55, U8_57, U8_59});
	
   assign U8_45 = 0 ; 
  // assign U8_47 = 0 ; // G
  // assign U8_49 = 1 ; // F 
  // assign U8_51 = 1 ; // E 
  // assign U8_53 = 1 ; // D 
  // assign U8_55 = 1 ; // C 
  // assign U8_57 = 1 ; // B
  // assign U8_59 = 1 ; // A
   
endmodule
   


