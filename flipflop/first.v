
/*
module forward(out, in);

  input in;
  output out;

  assign out = !in;
   
endmodule
*/

module top(redbtn, bluebtn, led0, led1);
  input redbtn, bluebtn;
  output led0, led1;
  
 
 // assign w0 = led0 = !redbtn  ~&   led1  ;
  //assign w1 = led1 = !bluebtn ~&   led0  ;
  
  nand(led0, redbtn, led1);
  nand(led1, bluebtn, led0); 

 // wire redbtn, bluebtn, led[0:1];
 // forward  fwd1(led0, redbtn);
 // forward  fwd2(led1, bluebtn);

endmodule