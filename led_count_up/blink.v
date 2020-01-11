    
module blink(input clk, output U8_41, output U8_43, 
  output U8_45, output U8_47, output U8_49, output U8_51, 
  output U8_53, output U8_54,output U8_57, output U8_59);
	 
	 reg[30:0] count;
	 
	 initial begin
      count <= 26'd0;
		/* compiler didn't like
		assign U8_41 = 1'b0;
		assign U8_43 = 1'b0;
      assign U8_45 = 1'b0;
		assign U8_47 = 1'b0;
		assign U8_49 = 1'b0;
		assign U8_51 = 1'b0;
		assign U8_53 = 1'b0;
		assign U8_54 = 1'b0;
		assign U8_57 = 1'b0;
		assign U8_59 = 1'b0;
		*/
    end
	 
	 always @ (posedge clk)  begin
		count <= count + 1'b1;		 
	 end
	 
	 assign U8_41 = count[30];
	 assign U8_43 = count[29];
	 assign U8_45 = count[28];
	 assign U8_47 = count[27];
	 assign U8_49 = count[26];
	 assign U8_51 = count[25];
	assign U8_53 = count[24];
	assign U8_54 = count[23];
	assign U8_57 = count[22];
	assign U8_59 = count[21];
	 
endmodule
	 


