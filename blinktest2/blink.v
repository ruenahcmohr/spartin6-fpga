    
module blink(input clk, output led0, output led1);
	 
	 reg[31:0] count;
	 reg       OL_led0;
	 
	 initial begin
      //count   <= 32'b0; //count up
      count <= 32'd50000000; //count down
		OL_led0 <= 1'b0;
    end
	 
	 always @ (posedge clk)  begin
      // count up
		/*
		count <= count + 1'b1;
        if (count == 50000000) begin
          OL_led0 <= !OL_led0;
          count <= 32'b0;
        end
		*/
		// count down
		
		count <= count - 1'b1;
        if (count == 0) begin
          OL_led0 <= !OL_led0;
          count <= 32'd50000000;
        end
		 
	 end
	 
	 assign led0 = OL_led0;
	 assign led1 = 1'b1;
	 
endmodule
	 


