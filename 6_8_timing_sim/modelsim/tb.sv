// mips.sv
// From Section 7.6 of Digital Design & Computer Architecture
// Updated to SystemVerilog 26 July 2011 David_Harris@hmc.edu
// Error (176205): Can't place 161 pins with 2.5 V I/O standard 
//   because Fitter has only 147 such free pins available 
//   for general purpose I/O placement
// pc와 aluout의 size를 32bit에서 8bit로 변경하여 pin 갯수 줄임 

`timescale 1 ps/ 1 ps
//`define PERIOD 10 // 100GHz 이런 주파수의 CPU는 존재하지 않음
// RTL simulation은 100GHz로 실행했지만 timing simulation에서는 20MHz 수행
// 20MHz이상에서는 setup과 hold timing error 발생
// critical path를 찾아서 timing 개선 필요
`define PERIOD	50_000 // 50ns(20MHz) PASS
//`define PERIOD	25_000 // 25ns(40MHz) FAIL
module tb();

  logic        clk;
  logic        reset;
  int rising_no;
  logic [31:0] writedata;
  logic [7:0] dataadr;
  logic        memwrite;

  // instantiate device to be tested
  top dut(clk, reset, writedata, dataadr, memwrite);

  // reset activate and deactive 
  initial
    begin
      clk =0;
      reset = 1; 
      rising_no =0;
      #(`PERIOD*16/10); // after 2 rising edge + 1/10cycle
      reset = 0; 
    end

  // generate clock
  always 
      #(`PERIOD/2) clk = ~clk;
  
  // count rising edge of clock
  always @(posedge clk)
    if (reset) rising_no <= 0;
    else  rising_no ++;

  // check results
  always @(negedge clk)
    begin
      if(memwrite) begin
        if(dataadr === 84 & writedata === 7) begin
          $display("Simulation succeeded");
          $stop;
        end else if (dataadr !== 80) begin
          $display("Simulation failed");
          $stop;
        end
      end
    end
endmodule

module top(input  logic        clk, reset, 
           output logic [31:0] writedata,
           output logic [7:0] dataadr, 
           output logic        memwrite);

  logic [7:0] pc;
  logic [31:0] instr, readdata;
  
  // instantiate processor and memories
  mips mips(clk, reset, pc, instr, memwrite, dataadr, 
            writedata, readdata);
  imem imem(pc[7:2], instr);
  dmem dmem(clk, memwrite, dataadr, writedata, readdata);
endmodule

module dmem(input  logic        clk, we,
            input  logic [7:0] a,
            input  logic [31:0] wd,
            output logic [31:0] rd);

  logic [31:0] RAM[63:0];

  assign rd = RAM[a[7:2]]; // word aligned

  always_ff @(posedge clk)
    if (we) RAM[a[7:2]] <= wd;
endmodule

module imem(input  logic [5:0] a,
            output logic [31:0] rd);

  logic [31:0] RAM[63:0];

  initial
      $readmemh("memfile-comment.dat",RAM);

  assign rd = RAM[a]; // word aligned
endmodule

