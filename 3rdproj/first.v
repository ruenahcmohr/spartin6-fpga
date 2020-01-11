

module forward(out, in);

  input in;
  output out;

  assign out = !in;
   
endmodule


module top(redbtn, bluebtn, led0, led1);
  input redbtn, bluebtn;
  output led0, led1;

 // wire redbtn, bluebtn, led[0:1];
  forward  fwd1(led0, redbtn);
  forward  fwd2(led1, bluebtn);

endmodule