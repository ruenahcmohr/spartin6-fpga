    
	 module blink(input clk);
	 
	 
	 
	 endmodule;
	
	 
	 library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
	 
	 
    entity blinky is
        Port ( clk : in  STD_LOGIC;
               led_one : out  STD_LOGIC;
               led_two : out  STD_LOGIC);
    end blinky;
	 
    architecture Behavioral of blinky is
    signal cnt:integer range 0 to 25000000;
    signal sig_led_one:std_logic:='0';
    signal sig_led_two:std_logic:='0';
    begin
	 
	 
    process(clk)
      begin
      if(rising_edge(clk))then
        cnt<=cnt+1;
        if(cnt=24999999)then
          cnt<=0;
          sig_led_one<=not sig_led_one;
          sig_led_two<= sig_led_one;
        end if;
      end if;
    end process;
	 
    led_one<=sig_led_one;
    led_two<=not sig_led_one;
	 
    end Behavioral;

    

