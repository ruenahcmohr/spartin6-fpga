


module slow_clock(wire a_clk, wire slow_clk);
  
  reg[21:0] count;
  reg preout;
  
	always @ (posedge a_clk)  begin
		count <= count + 1'b1;
		if (count == 0) begin
		  preout = !preout;
		end		
	end
	
	assign slow_clk = preout;
	
endmodule
  
  
module blink( input clk,  output U8_41, output U8_43, 
  output U8_45, output U8_47, output U8_49, output U8_51, 
  output U8_53, output U8_55,output U8_57, output U8_59);
	 
	 reg[5:0] count;
	 wire my_clk;
	 reg dir;
	 
	 
	 initial begin
      count <= 6'd3;		
		dir <= 1;
    end
	 
	 slow_clock  clocker(clk, my_clk);
	 
	 always @ (posedge my_clk)  begin
	   if (count == 0) begin
		  dir <= 1;
		end
		
		if (count == 6'b111111) begin
		  dir <= 0;
		end	
	 end
	 
	 always @ (negedge my_clk) begin
	   if (dir == 1) count <= count + 1'b1;		 
		else          count <= count - 1'b1;
	 end
	 
	 assign U8_41 = 0;
	 assign U8_43 = 0;
	 assign U8_45 = 0;
	 assign U8_47 = 0;
	 assign U8_49 = count[5];
	 assign U8_51 = count[4];
	 assign U8_53 = count[3];
	 assign U8_55 = count[2];
	 assign U8_57 = count[1];
	 assign U8_59 = count[0];
	 
endmodule
	 


