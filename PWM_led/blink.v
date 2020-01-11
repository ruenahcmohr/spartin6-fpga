

/*
module slow_clock(input a_clk, wire slow_clk, dcount);
  
  reg[21:0] dcount;
  reg preout;
  
	always @ (posedge a_clk)  begin
		dcount <= dcount + 1'b1;		
	end
	
	assign slow_clk = preout;
	
endmodule
  */
 /* 
module pwm(c, v, q);
  input c, v;
  output q;
  reg q;
  reg cnt;
  
  always @ (posedge c) begin
    if ((c == v) && (v != 0 )) q <= 1;
	 if ((c == 0) && (v != 
  end
  
endmodule
*/
  
  
module blink( input clk,  output U8_41, output U8_43, 
  output U8_45, output U8_47, output U8_49, output U8_51, 
  output U8_53, output U8_55,output U8_57, output U8_59);
	 
	 reg[19:0] clkdown;
	 
	 reg[5:0] count;
	 wire my_clk;
	 reg dir;
	 
	 //slow_clock  clocker(clk, my_clk);
	 always @ (posedge clk) begin
	   clkdown <= clkdown + 1'b1;
	 end
	 
	 initial begin
      count <= 6'd3;		
		dir <= 1;
    end	 	
	 
	 always @ (posedge clkdown[18])  begin
	   if (count == 0) begin
		  dir <= 1;
		end
		
		if (count == 6'b111111) begin
		  dir <= 0;
		end	
	 end
	 
	 always @ (negedge clkdown[18]) begin
	   if (dir == 1) count <= count + 1'b1;		 
		else          count <= count - 1'b1;
	 end
	 
	 assign U8_41 = 0;
	 assign U8_43 = 0;
	 assign U8_45 = clkdown[5:0] > count[5:0] ? 0 : 1;  
	 assign U8_47 = 0;
	 assign U8_49 = count[5];
	 assign U8_51 = count[4];
	 assign U8_53 = count[3];
	 assign U8_55 = count[2];
	 assign U8_57 = count[1];
	 assign U8_59 = count[0];
	 
endmodule
	 


