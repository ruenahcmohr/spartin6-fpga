module first(led, bluebtn, redbtn);

  input bluebtn;
  input redbtn;
  output [0:1] led;
  //reg [0:1] led;

  //assign led[0] = !button1 ^ !button2;
  //assign led[1] = !button1 | !button2;

  //assign led[0] =  button1 ? button2 : 1'b1;
  //assign led[1] = !button1 ? button2 : 1'b1; 

   assign led[0] = bluebtn;
	assign led[1] = redbtn;

  /*
  always
    begin
     led[0] <= !button2;
     led[1] <= button2;
    end	*/
	 
endmodule


