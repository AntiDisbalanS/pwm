`timescale 1ns/1ps

	//Company: 			PLANAR JSK
	//Engineer: 		Mordashou Anatol
	//Create Date: 		15/04/2022 
	//Design Name: 		Pulse-Width Modulation
	//Module Name: 		pwm
	//Project Name: 	UKDF_MAX, USDFA 
	//Target Devices: 	MAX3, Cyclone IV
	//Tool versions: 	Quartus v9.1 & v13.1
	//Revision: 		v3 


module pwm #(																																	//	|ForExample
	parameter 	CLK_Q 	= 3, 								//Quantity of frequencies for sel														|= 3
				WIDTH_Q	= 8, 								//Quantity of pulse width for sel														|= 8
				CLK_S	= 3'b0,
				WIDTH_S	= 8'b0)(
															//Remark: final frequency [MAX : MIX) = clk /2 /2^WIDTH_Q : clk /2 /2^CLK_Q /2^WIDTH_Q	|clk/512 :  clk/65_536
	input									wr,
	output									out,
	input 		[CLK_Q + WIDTH_Q - 1 : 0]	code,			//MSB bit for high logic level in out 													|[10:0]
	input 									clk, res);							

	
	reg			[CLK_Q - 1 : 0]				sel_clk;																							//	|[3:0]
	reg			[WIDTH_Q - 1 : 0]			sel_width; 																							//	|[7:0]
	reg			[2 ** CLK_Q - 1 : 0]		count_1; 		//Width 2^CLK_Q
	reg										fclk; 
	reg			[WIDTH_Q - 1 : 0]			count_2;																							//	|[7:0]
	reg										out_;			//Buffer

					
				
	assign out = out_ || &{sel_clk, sel_width}; //out or high
	
	always @(negedge wr or negedge res) //write reg
	
		if(!res) begin sel_clk <= CLK_S; sel_width <= WIDTH_S; end //starting values
		else begin
		
			sel_clk <= code[CLK_Q + WIDTH_Q - 1 : WIDTH_Q];
			sel_width <= code[WIDTH_Q - 1 : 0];  
					
		end
	
	always @(posedge clk or negedge res) 
	
		if (!res) begin fclk <= 1'b0; count_1 <= 1'b0;  end	//res DFF
		else begin
			
			count_1 <= count_1 + 1'b1;				//First counter for divide clk	
			fclk <= count_1[sel_clk];	//Buffer after first divide. When MSB = 1 => out=1
				
		end
		
			
	always @(posedge fclk or negedge res) 
	
		if (!res) begin count_2 <= 1'b0; out_ <= 1'b0;  end //res DFF
		else begin
						
			count_2 <= count_2 + 1'b1;				//Second counter for divide fclk
			out_ <= (count_2 < sel_width);	//Comparator for duty cycle | 01 - max duty cycle, FF - min duty cycle. 															 
										
		end

	
endmodule

// In v3 replase sel_high reg to &cod. Add start parameters. 

/*	EXAMPLE

If WIDTH_Q = 0, CLK_Q = 3 and clk = 1MHz 
	
	cod 	out (ms)				cod		
	X00		logic 0					XFF    	1111111011111110
	0XX		0,5						X80		1111000011110000
	1XX		1						X01		0000000100000001
	2XX		2
	3XX		4
	4XX		8
	5XX		16
	6XX 	32
	7XX 	64
	7FF 	logic 1
*/	
