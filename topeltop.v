module topeltop #(parameter W = 8)
(   input wire i_top_clk, 
    input wire i_top_rst, //active high rst signal
    //input wire [2:0] i_top_phase,
    output reg o_top_halt
);

// Interface between controller and rest of the CPU:
wire sel, rd, ld_ir, inc_pc, halt, ld_ac, data_e, ld_pc, wr;

// Internal connections:
wire [4:0] ir_addr;
wire [4:0] addr;
wire [7:0] data;
wire [2:0] opcode;
wire [2:0] phase;

//Interface with Program Counter:
wire [4:0] pc_addr;

//Interface with ALU:
wire [W-1:0] alu_out; 
wire zero; 
wire [W-1:0] ac_out;


//Phase Generator
counter phase_gen(
    .clk(i_top_clk),
    .rst(i_top_rst),
    .load(1'b0),
    .en(~halt),
    .cnt_in(3'b0),
    .cnt_out(phase)
);

//Main Controller
 controller controller_inst(
    .zero(zero),
    .opcode(opcode),
    .phase(phase),
    .sel(sel),
    .rd(rd),
    .ld_ir(ld_ir),
    .inc_pc(inc_pc),
    .halt(halt),
    .ld_ac(ld_ac),
    .data_e(data_e),
    .ld_pc(ld_pc),
    .wr(wr)
 );
//Assign halt signal to output
assign o_top_halt = halt;

//Program counter to increment or load instr address
 counter pc(
    .clk(i_top_clk),
    .rst(i_top_rst),
    .load(ld_pc),
    .en(inc_pc),
    .cnt_in(ir_addr),
    .cnt_out(pc_addr)
 );

//Multiplexer to select between pc address and instr address
assign addr = (sel) ? pc_addr : ir_addr;

//Memory
 mem memory_inst(
    .rd(rd),
    .clk(i_top_clk),
    .wr(wr),
    .address_in(addr),
    .data(data)
 );

//Instruction register to hold opcode and instr address
  regfile reg_ir(
    .clk(i_top_clk),
    .rst(i_top_rst),
    .data_in(data),
    .load(ld_ir),
    .data_out({opcode,ir_addr})
 );

//ALU
 alu alu1(
    .opcode(opcode),
    .in_a(ac_out),
    .in_b(data),
    .a_is_zero(zero),
    .alu_out(alu_out)
 );

//Accumulator Register for ALU
 regfile reg_acc(
    .clk(i_top_clk),
    .rst(i_top_rst),
    .data_in(alu_out),
    .load(ld_ac),
    .data_out(ac_out)
 );
//Tristate buffer to drive data bus from ALU output
 tristate_buffer buff (
    .data_in(alu_out),
    .en(data_e),
    .data_out(data)
 );

    
endmodule