

   
  
module blink( input clk, input bluebtn, output U8_41, output U8_43, 
  output U8_45, output U8_47, output U8_49, output U8_51, 
  output U8_53, output U8_55,output U8_57, output U8_59);
   
   reg[5:0] clkdown;
	reg[7:0] colCtr;  // 0 to 239
	reg[4:0] linCtr;     // 0 to 32
   
   reg myClk;
	reg FLM;
	reg M;
   
   always @ (posedge clk) begin
     clkdown <= clkdown + 1'b1;	  
   
    if (clkdown == 6'd49) begin
	// if (clkdown == 8'd127) begin
	    clkdown <= 0;
		 myClk <= !myClk;
	  end
   end
	
	always @ (posedge myClk) begin
	  colCtr <= (colCtr == 239) ? 0 : colCtr + 1;
	  linCtr <= (colCtr == 239) ? linCtr + 1 : linCtr;
     M      <= ((colCtr == 239)&&(linCtr == 0))? !M : M;	  
	end
	
	always @ (negedge myClk) begin
	  FLM  <= (linCtr == 0)   ? 1 : 0;
	end
	
   assign U8_41 = 0;  // not connected
   assign U8_43 = 0;  // not connected
   assign U8_45 = myClk;                                   // CL2
   assign U8_47 = ((colCtr == 239)&&(myClk == 0)) ? 1 : 0; // CL1
   assign U8_49 = FLM;                                     // FLM
   assign U8_51 = M;                                       // M
   assign U8_53 = (colCtr[2:0] == 0) | (linCtr[2:0] == 0) ;  // video data 1 (top)
   assign U8_55 = (colCtr[2:0] == 0) | (linCtr[2:0] == 0) ;  // video data 2 (bottom)
   assign U8_57 = 0;
   assign U8_59 = 0;
   
endmodule
   


