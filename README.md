# pwm
Parameters: B_WIDTH - number of pulse width bits  for sel													
	    B_CLK - number of frequency bits to select	
            PWM_POL - polarity, for control leds =1 (off);
            
Remark: final frequency [MAX : MIX) = clk /2 /2^WIDTH_Q : clk /2 /2^CLK_Q /2^WIDTH_Q	
for this project [clk/512 :  clk/65_536]
            
Example:
            
If WIDTH_Q = 8, CLK_Q = 3 and clk = 1MHz 
	
	cod 	out (ms)				cod		
                                			XFF  	1111111011111110
	0XX	0,5					X80	1111000011110000
	1XX	1					X01	0000000100000001
	2XX	2
	3XX	4
	4XX	8
	5XX	16
	6XX 	32
	7XX 	64

  
  In v4 more synchronize and error protection 
  In v5 add generate block for create pipeline processing
