# pwm
Parameters: B_WIDTH - number of pulse width bits  for sel													
	    B_CLK - number of frequency bits to select	
            PWM_POL - polarity, for control leds =1 (off);
            
Remark: final frequency [MAX : MIX) = clk /2 /2^WIDTH_Q : clk /2 /2^CLK_Q /2^WIDTH_Q	
for this project [clk/512 :  clk/65_536]
           
Reg:        clk_count - First counter for divide clk
            clk_en_buf - Buffer for create strob
            width_count - Second counter for divide fclk
            pwm - Comparator for duty cycle | 01 - min duty cycle, FF - max duty cycle (if def parameters) 
            
Example:
            
If WIDTH_Q = 0, CLK_Q = 3 and clk = 1MHz 
	
	cod 	out (ms)				cod		
	X00	logic 0					XFF  	1111111011111110
	0XX	0,5					X80	1111000011110000
	1XX	1					X01	0000000100000001
	2XX	2
	3XX	4
	4XX	8
	5XX	16
	6XX 	32
	7XX 	64
	7FF 	logic 1
  
  In v4 more synchronize and error protection 
