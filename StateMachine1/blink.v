

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

module FSMLUT(OP, FBO, I, FBI);
  output reg [3:0] OP;
  output reg [1:0] FBO;
  input[1:0]       I;
  input[1:0]       FBI;

  always @* begin
    case({FBI, I})
      {2'd0, 2'd0}:  {OP, FBO} = {4'd1, 2'd1};
      {2'd0, 2'd1}:  {OP, FBO} = {4'd1, 2'd0};
      {2'd0, 2'd2}:  {OP, FBO} = {4'd0, 2'd1};
      {2'd0, 2'd3}:  {OP, FBO} = {4'd0, 2'd1};
		
      {2'd1, 2'd0}:  {OP, FBO} = {4'd2, 2'd2};
      {2'd1, 2'd1}:  {OP, FBO} = {4'd2, 2'd0};
      {2'd1, 2'd2}:  {OP, FBO} = {4'd0, 2'd2};
      {2'd1, 2'd3}:  {OP, FBO} = {4'd0, 2'd2};
		
      {2'd2, 2'd0}:  {OP, FBO} = {4'd4, 2'd3};
      {2'd2, 2'd1}:  {OP, FBO} = {4'd4, 2'd1};
      {2'd2, 2'd2}:  {OP, FBO} = {4'd0, 2'd3};
      {2'd2, 2'd3}:  {OP, FBO} = {4'd0, 2'd3};
		
      {2'd3, 2'd0}:  {OP, FBO} = {4'd8, 2'd3};
      {2'd3, 2'd1}:  {OP, FBO} = {4'd8, 2'd2};
      {2'd3, 2'd2}:  {OP, FBO} = {4'd0, 2'd0};
      {2'd3, 2'd3}:  {OP, FBO} = {4'd0, 2'd0};  
    endcase
  end

endmodule

   
  
module blink( input clk, input bluebtn, output U8_41, output U8_43, 
  output U8_45, output U8_47, output U8_49, output U8_51, 
  output U8_53, output U8_55,output U8_57, output U8_59);
   
   reg[22:0] clkdown;
   
   reg[5:0] count;
   wire my_clk;
   reg dir;
   
   reg[1:0] LUTLATCHO;
   wire[1:0] LUTLATCHN;
   
   //slow_clock  clocker(clk, my_clk);
   always @ (posedge clk) begin
     clkdown <= clkdown + 1'b1;
   end
   
   initial begin
     count <= 6'd3;    
     dir <= 1;
   end     
   
   always @ (posedge clkdown[21])  begin
     if (count == 0) begin
       dir <= 1;
     end
    
     if (count == 6'b111111) begin
       dir <= 0;
     end  
   end
   
   always @ (negedge clkdown[21]) begin
     if (dir == 1) count <= count + 1'b1;     
     else          count <= count - 1'b1;
    
     LUTLATCHO <= LUTLATCHN;    
          
   end
   
   FSMLUT({U8_59, U8_57, U8_55, U8_53}, LUTLATCHN, bluebtn, LUTLATCHO);
   
   assign U8_41 = 0;
   assign U8_43 = 0;
   assign U8_45 = clkdown[5:0] > count[5:0] ? 1'b0 : 1'b1;  
   assign U8_47 = 0;
   assign U8_49 = 0;
   assign U8_51 = 0;
  // assign U8_53 = 0; //LUTLATCHN[1];
  // assign U8_55 = 0; //LUTLATCHN[0];
   
   
   
   //assign U8_57 = 0;
   //assign U8_59 = 0;
   /*
   //test(U8_47, count[5]);
   //test(U8_47, {count[4], count[5]}, count[3]);
   assign U8_49 = count[5];
   assign U8_51 = count[4];
   assign U8_53 = count[3];
   assign U8_55 = count[2];
   assign U8_57 = count[1];
   assign U8_59 = count[0];
   */
endmodule
   


