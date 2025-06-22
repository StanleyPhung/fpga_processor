# fpga_processor
This is my project on ELEC2602: Digital Logic

This is the datapath and all of its functions with a small 255-register RAM (16-bit length). Additionally, it has functions like ADDI, BRNE, CMP, XOR, PUSH POP, LOAD, and STR as the base functions.
most instructions will have a format like this: STR Rx Ry padding. please have a look at the datapath for more details.
to run simply have all of the files in 1 folder, write:
1. iverilog -g2012 -o cpu_sim ControlFSM.v alu16.v sixteen_bit_reg.v processor.v processor_extensionwithPUSH_TB.v tri_state_buffer.v PC.v PMEM.v RAM.v
2. vvp cpu_sim
3. gtkwave processor_extensionwithPUSH_TB.vcd (for simulation)
If you have an fpga, then you can use the project_instantiate.v as the real TB.
https://drive.google.com/file/d/1OVlzmJymDFhGlbulag3j8oL8A3L5ePao/view?usp=sharing
