# pwm
Parameters: CLK_Q - Quantity of frequencies for sel													
				    WIDTH_Q	- Quantity of pulse width for sel	
            CLK_S and WIDTH_S	- starting values
            
Remark: final frequency [MAX : MIX) = clk /2 /2^WIDTH_Q : clk /2 /2^CLK_Q /2^WIDTH_Q	
for this project [clk/512 :  clk/65_536]
           
Reg:        count_1 - First counter for divide clk
            fclk - Buffer after first divide
            count_2 - Second counter for divide fclk
            out_ - Comparator for duty cycle | 01 - max duty cycle, FF - min duty cycle. 
            
Example:
            
If WIDTH_Q = 0, CLK_Q = 3 and clk = 1MHz 
	
	cod 	out (ms)				cod		
	X00		logic 0					XFF   1111111011111110
	0XX		0,5						  X80		1111000011110000
	1XX		1					    	X01		0000000100000001
	2XX		2
	3XX		4
	4XX		8
	5XX		16
	6XX 	32
	7XX 	64
	7FF 	logic 1
  
  In v3 replase sel_high reg to &cod. Add start parameters. 
