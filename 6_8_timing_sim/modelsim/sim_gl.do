# 7.6 MIPS single cycle processor simulation do file
### 1�ܰ� : ���� �̵�
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch7/single_10inst
### 2�ܰ� : do single_sv.do # compile and simulation
vlib gl_work
vmap work gl_work
# compile
vlog -sv tb.sv synthesis.svo
#vlog -sv tb.sv synthesis_min_1200mv_0c_fast.svo
# simulation
vsim -t ps -L cycloneive_ver -L altera_ver work.tb 
# For changing VSIM(paused)> prompt to Modelsim> prompt
# using abort command
# For changing VSIM 3> prompt to Modelsim> prompt
# using quit -sim command
# waveform setting
add wave /clk
add wave /reset
add wave /rising_no
add wave -radix dec  /writedata
add wave -radix dec  /dataadr
add wave -radix bin  /memwrite
add wave -divider {state element}
#add wave -radix hex  /dut/mips/dp/pc
add wave -radix hex  /dut/imem/RAM
#add wave -radix hex  /dut/mips/dp/rf/rf
add wave -radix hex  /dut/dmem/RAM
add wave -divider {temp signal}
run -all
### 3�ܰ� : quit # modelsim ����
