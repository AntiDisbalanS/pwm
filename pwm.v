`timescale 1ns/1ps

	//Company: 		PLANAR JSK
	//Engineer: 		Mordashou Anatol
	//Create Date: 		15/04/2022 
	//Design Name: 		Pulse-Width Modulation
	//Module Name: 		pwm
	//Project Name: 	UKDF_MAX, USDFA 
	//Target Devices: 	MAX3, Cyclone IV
	//Tool versions: 	Quartus v9.1 & v13.1
	//Revision: 		v3 


module pwm #(													
	parameter 	CLK_Q 	= 3, 	//Quantity of frequencies for sel					
			WIDTH_Q	= 8, 	//Quantity of pulse width for sel						
			CLK_S	= 3'b0,
			WIDTH_S	= 8'b0)(
//Remark: final frequency [MAX : MIX) = clk /2 /2^WIDTH_Q : clk /2 /2^CLK_Q /2^WIDTH_Q	|clk/512 :  clk/65_536]
	input						wr,
	output						out,
	input 	[CLK_Q + WIDTH_Q - 1 : 0]		code,			
	input 						clk, res);							

	
	reg	[CLK_Q - 1 : 0]				sel_clk;																							//	|[3:0]
	reg	[WIDTH_Q - 1 : 0]			sel_width; 																							//	|[7:0]
	reg	[2 ** CLK_Q - 1 : 0]			count_1; //Width 2^CLK_Q
	reg						fclk; 
	reg	[WIDTH_Q - 1 : 0]			count_2;																							//	|[7:0]
	reg						out_;			

					
				
	assign out = out_ || &{sel_clk, sel_width}; //out or high
	
	always @(negedge wr or negedge res) //write reg for VME or USB
	
		if(!res) begin sel_clk <= CLK_S; sel_width <= WIDTH_S; end //starting values
		else begin
		
			sel_clk <= code[CLK_Q + WIDTH_Q - 1 : WIDTH_Q];
			sel_width <= code[WIDTH_Q - 1 : 0];  
					
		end
	
	always @(posedge clk or negedge res) 
	
		if (!res) begin fclk <= 1'b0; count_1 <= 1'b0;  end	
		else begin
			
			count_1 <= count_1 + 1'b1;	//First counter for divide clk	
			fclk <= count_1[sel_clk];	//Buffer after first divide. 
				
		end
		
			
	always @(posedge fclk or negedge res) 
	
		if (!res) begin count_2 <= 1'b0; out_ <= 1'b0;  end //res DFF
		else begin
						
			count_2 <= count_2 + 1'b1;	//Second counter for divide fclk
			out_ <= (count_2 < sel_width);	//Comparator for duty cycle | ex: 01 - max duty cycle, FF - min duty cycle. 															 
										
		end	
	
endmodule


