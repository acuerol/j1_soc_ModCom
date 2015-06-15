`timescale 1ns / 1ps

`define SIMULATION

module peripheral_mult_TB;
	reg clk;
	reg rst;
	reg reset;
	reg start;
	reg [15:0] d_in;
	reg cs;
	reg [3:0] addr;
	reg rd;
	reg wr;
	
	wire [15:0] d_out;
	
	peripheral_mult uut (.clk(clk) , .rst(rst) , .d_in(d_in) , .cs(cs) , .addr(addr) , .rd(rd) , .wr(wr), .d_out(d_out) );
	
	parameter PERIOD= 20;
	parameter real DUTY_CYCLE = 0.5;
	parameter OFFSET= 0;
	
	reg [20:0] i;
	
	event reset_trigger;

	initial begin// Initialize Inputs
		clk = 0;
		reset = 1;
		start = 0;
		d_in = 16'd0000;
		addr = 4'h0000;
		cs=1;
		rd=0;
		wr=1;
		rst = 1;
	end

	initial begin// Process for clk
		#OFFSET;
		forever begin
			clk = 1'b0;
			#(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
			#(PERIOD*DUTY_CYCLE);
		end
	end

	initial begin // Reset the system, Start the image capture process
		forever begin 
			@ (reset_trigger);
			@ (posedge clk);
			
			start = 0;
			@ (posedge clk);
			
			start = 1;

			for(i=0; i<2; i=i+1) begin
				@ (posedge clk);
			end
			start = 0;

			// Stimulus here

			rst = 0;

			for(i=0; i<4; i=i+1) begin
				@ (posedge clk);
			end

			d_in = 16'd0005;	//envio A
			addr = 4'h0;
			cs=1; rd=0; wr=1;

			for(i=0; i<4; i=i+1) begin
				@ (posedge clk);
			end

			d_in = 16'd0002;	//envio B
			addr = 4'h2;
			cs=1; rd=0; wr=1;

			for(i=0; i<4; i=i+1) begin
				@ (posedge clk);
			end

			d_in = 16'd0001;	//envio init
			addr = 4'h4;
			cs=1; rd=0; wr=1;

			for(i=0; i<4; i=i+1) begin
				@ (posedge clk);
			end

			d_in = 16'd0000;	//recivo dato
			addr = 4'h6;
			cs=0;	rd=1;	wr=0;
			
			for(i=0; i<4; i=i+1) begin
				@ (posedge clk);
			end
			
			d_in = 16'd0000;	//recivo dato
			addr = 4'h8;
			cs=0;	rd=1;	wr=0;
			
			for(i=0; i<4; i=i+1) begin
				@ (posedge clk);
			end
			
			d_in = 16'd0000;	//recivo dato
			addr = 4'hA;
			cs=0;	rd=1;	wr=0;
			
			for(i=0; i<4; i=i+1) begin
				@ (posedge clk);
			end
		end
	end

	initial begin: TEST_CASE
		$dumpfile("peripheral_mult_TB.vcd");
		$dumpvars(-1, uut);

		#10 -> reset_trigger;
		#((PERIOD*DUTY_CYCLE)*200) $finish;
	end
endmodule
