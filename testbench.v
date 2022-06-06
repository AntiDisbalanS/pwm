`include "../pwm.v"
`timescale 1ns / 1ns
module testbench;

    wire          pwm; 

    reg [ 3 : 0 ] sel_width;
    reg [ 3 : 0 ] sel_clk;

    reg           s_rst;
    reg           clk;
    reg           rst_n;

    integer       i;

    pwm #(4,4,1) dut (
            .pwm(pwm),
            .sel_width(sel_width),
            .sel_clk(sel_clk),

            .s_rst(s_rst),
            .clk(clk),
            .rst_n(rst_n));

    initial begin 
        clk = 1'b0;
        forever
            #10 clk = !clk;
    end

    initial begin
        rst_n = 1'b0;
        #10;
        rst_n = 1'b1;
    end
    initial begin
        s_rst = 1'b1;
        sel_clk = 4'b0;
        sel_width = 4'b0;
        #20;
        s_rst = 1'b0;
        #60
        for (i = 0; i < 16; i = i + 1) begin
           #3200 sel_width = sel_width + 1'b1;
        end 
    end

    initial begin
        #60000;
        $finish;
    end

    initial 
        $monitor ("pwm=%b sel_clk=%b sel_width=%b", pwm, sel_clk, sel_width);
    initial
        $dumpvars();
endmodule  
        