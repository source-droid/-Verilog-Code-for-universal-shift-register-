
module univ_shift_reg(clk, reset, ctrl, d, q);

parameter N = 8;
input wire clk, reset;
input wire [1:0] ctrl;
input wire [N-1:0] d;
output wire [N-1:0] q;


// signal declaration
reg [N-1:0] r_reg, r_next;
// body/register
always@(posedge clk, posedge reset)
 if(reset)
 r_reg <= 0;
 else
 r_reg <= r_next;


// next_state logic
always@(*)
 case(ctrl)
 2'b00 : r_next = r_reg; // no operation
 2'b01 : r_next = {r_reg[N-2:0], d[0]}; // shift left
 2'b10 : r_next = {d[N-1], r_reg[N-1:1]}; // shift right
 default: r_next = d; // load
 endcase

// output logic
assign q = r_reg;
endmodule





module test();
parameter N=8;

 reg clk, reset;
 reg [1:0] ctrl;
 reg [N-1:0] d;
 wire [N-1:0] q;
 
 
 initial
 clk = 0;
 always
 #10 clk = ~ clk;
 
 initial
 begin
    // testing reset for N clock cycles 
    reset  = 0;
    @(negedge clk) reset = 1;
    repeat (N) @(negedge clk) reset = 0;
    
    // testing shift left for N clock cycles
    @(negedge clk) ctrl = 2'b01; d[0] = 1'b1;
    @(negedge clk) ctrl = 2'b01; d[0] = 1'b0;
    repeat(N) @(negedge clk); ctrl = 2'b00;
    repeat(N) @(negedge clk); ctrl = 2'b00;

    
    // testing shift right for N clock cycles
    @(negedge clk) ctrl = 2'b10; d[N-1] = 1'b1;
    @(negedge clk) ctrl = 2'b10; d[N-1] = 1'b0;
    repeat(N) @(negedge clk); ctrl = 2'b00;
    repeat(N) @(negedge clk); ctrl = 2'b00; 
    
    
    // testing shift right for N clock cycles
    @(negedge clk) ctrl = 2'b11; d = 8'b10101010;
    @(negedge clk) ctrl = 2'b11; d = 8'b10101010;
    repeat(N) @(negedge clk); ctrl = 2'b00;
    repeat(N) @(negedge clk); ctrl = 2'b00; 
    
    // stop the simulation
    $stop;
     
 end

univ_shift_reg inst0(clk, reset, ctrl,  d,  q );

endmodule 
