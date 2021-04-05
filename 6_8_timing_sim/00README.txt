1. gate level netlist 생성방법
quartus>assignment>settings>EDA Tool Setting>simulation
Tool name, Format, TimeScale 설정

2. SDF 생성방법
gate level netlist를 생성하면 device에 따라 SDF생성됨
16.1, 18.1, 20.1은 Cyclone-4용 sdf 생성함

3. cycloneive_io_obuf등 gate level source코드 위치
C:\intelFPGA\18.1\modelsim_ase\altera\verilog\src

4. singleCycleCPU의 경우 
  4.1 slow corner : PVT = SS/1.2V/85c
     20MHz성공
     30MHz실패
  4.2 fast corner : PVT = FF/1.2V/0c
     40MHz성공
     50MHz실패

5. Timing Analyzer STA를 통한 Fmax 도출 필요
