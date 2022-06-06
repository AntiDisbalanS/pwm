
//Company: PLANAR JSK
//Engineer: Mordashou Anatol
//Create Date: 06/06/2022 
//Design Name: Pulse Width Modulation
//Module Name: pwm
//Project Name: USDFA 
//Target Devices: Cyclone IV
//Tool versions: Quatrus v20 & ModelSim 
//Revision: v4

/* fast copy 
    pwm #(4,4,1) pwm (
        .pwm(pwm),
        .sel_width(sel_width),
        .sel_clk(sel_clk),

        .s_rst(s_rst),
        .clk(clk),
        .rst_n(rst_n));
*/

module pwm #(
    parameter B_WIDTH = 4, //number of pulse width bits  for sel
              B_CLK   = 4, //number of frequency bits to select
              PWM_POL = 1)( //polarity  
    output reg                pwm,
    input [ B_WIDTH - 1 : 0 ] sel_width,
    input [ B_CLK - 1   : 0 ] sel_clk,

    input                     s_rst,
    input                     clk,
    input                     rst_n);

    localparam C_CLK   = 2 ** B_CLK;

    reg   [ B_CLK - 1   : 0 ] sel_clk_buf;
    reg   [ C_CLK - 1   : 0 ] clk_count;
    reg   [ 2 : 0 ]           clk_en_buf;
    wire                      clk_en;
    reg   [ B_WIDTH - 1 : 0 ] width_count;
    reg   [ B_WIDTH - 1 : 0 ] sel_width_buf;

    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            clk_count        <= {C_CLK{1'b0}};
            sel_clk_buf      <= {B_CLK{1'b0}};
            clk_en_buf       <= 2'b0;
        end else begin

            if (s_rst) // counter 1 for create clk
                clk_count <= {C_CLK{1'b0}};
            else 
                clk_count <= clk_count + 1'b1;
            
            if (~|width_count) //delay cycle 
                sel_clk_buf <= sel_clk;   
            
            clk_en_buf[0] <= clk_count[sel_clk];
            clk_en_buf[1] <= clk_en_buf[0];
        end

    assign clk_en = clk_en_buf[0] & ~clk_en_buf[1]; //create strob

    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            width_count   <= {B_WIDTH{1'b0}};
            sel_width_buf <= {B_WIDTH{1'b0}};
			pwm           <= |PWM_POL;
        end else begin
            if (clk_en) //counter 2 for width modulation
                if (s_rst) 
                    width_count <= {B_WIDTH{1'b0}}; 
                else 
                    width_count <= width_count + 1'b1;

			if (~|width_count) //delay cycle 
				sel_width_buf <= sel_width; 

            if (clk_en) 
                if (s_rst) 
                    pwm         <= |PWM_POL;
                else 
                    pwm         <= |PWM_POL ^ (width_count < sel_width_buf); //Comparator for duty cycle 01 - min duty cycle, FF - max duty cycle. 
        end
endmodule
