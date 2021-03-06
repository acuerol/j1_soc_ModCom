`timescale 1ns / 1ps

`define SIMULATION

module peripheral_strRAM_TB;

	reg clk;

	reg cs;
	reg rd;
	reg wr;

	reg [3:0]addr;


	wire [7:0]dat_out;
	reg [7:0]dat_in;
			
	parameter PERIOD = 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET = 0;
	
	reg [20:0] i;
	event reset_trigger;

	peripheral_strRAM strRAM(.clk(clk), .addr(addr), .dat_in(dat_in), .dat_out(dat_out), .cs(cs), .wr(wr), .rd(rd));
	
	initial begin// Initialize Inputs
		clk = 1;
		
		cs = 0;
		wr = 0;
		rd = 0;
		
		addr = 0;
		
		dat_in = 0;
	end

	initial begin// Process for sys_clk_i
		#OFFSET;
		forever begin
			clk = 1'b0;
			#(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
			#(PERIOD*DUTY_CYCLE);
		end
	end
	
	initial begin
		for(i = 0; i < 10000; i = i+1) begin
			@ (posedge clk);
			
			//-------------------Escribe
			if(i == 20) begin
				addr = 4'h0;
				cs = 1;
				wr = 1;
				rd = 0;
				dat_in = 8'hB;
			end
			
			if(i == 30) begin
				addr = 4'h4;
				cs = 1;
				wr = 1;
				rd = 0;
				dat_in = 8'h80;
			end
			
			if(i == 40) begin
				addr = 4'h8;
				cs = 1;
				wr = 1;
				rd = 0;
			end

			//-------------------Escribe
			if(i == 50) begin
				addr = 4'h0;
				cs = 1;
				wr = 1;
				rd = 0;
				dat_in = 8'hFF;
			end
			
			if(i == 60) begin
				addr = 4'h4;
				cs = 1;
				wr = 1;
				rd = 0;
				dat_in = 8'h55;
			end
			
			if(i == 70) begin
				addr = 4'h8;
				cs = 1;
				wr = 1;
				rd = 0;
			end
			
			//-------------------Lee
			if(i == 90) begin
				addr = 4'h4;
				cs = 1;
				wr = 1;
				rd = 0;
				dat_in = 8'h55;
			end
			
			if(i == 100) begin
				addr = 4'h8;
				cs = 1;
				wr = 0;
				rd = 1;
			end
			
			if(i == 110) begin
				addr = 4'h2;
				cs = 1;
				wr = 0;
				rd = 1;
			end
			
			//-------------------------Lee
			if(i == 120) begin
				addr = 4'h4;
				cs = 1;
				wr = 1;
				rd = 0;
				dat_in = 8'h80;
			end
			
			if(i == 130) begin
				addr = 4'h8;
				cs = 1;
				wr = 0;
				rd = 1;
			end
			
			if(i == 140) begin
				addr = 4'h2;
				cs = 1;
				wr = 0;
				rd = 1;
			end
			
		end
	end
	
	initial begin: TEST_CASE
	  	$dumpfile("peripheral_strRAM_TB.vcd");
	  	$dumpvars(-1, peripheral_strRAM_TB);
	
	  	#10 -> reset_trigger;
	  	#((PERIOD*DUTY_CYCLE)*10000) $finish;
	end

endmodule
