transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/1prettylaco/Desktop/FPGA\ Labs/Laba\ 2 {C:/Users/1prettylaco/Desktop/FPGA Labs/Laba 2/lab2.v}
vlog -vlog01compat -work work +incdir+C:/Users/1prettylaco/Desktop/FPGA\ Labs/Laba\ 2 {C:/Users/1prettylaco/Desktop/FPGA Labs/Laba 2/bin2bcd.v}
vlog -vlog01compat -work work +incdir+C:/Users/1prettylaco/Desktop/FPGA\ Labs/Laba\ 2 {C:/Users/1prettylaco/Desktop/FPGA Labs/Laba 2/bcd2sev.v}
vlog -vlog01compat -work work +incdir+C:/Users/1prettylaco/Desktop/FPGA\ Labs/Laba\ 2 {C:/Users/1prettylaco/Desktop/FPGA Labs/Laba 2/board_top.v}

vlog -vlog01compat -work work +incdir+C:/Users/1prettylaco/Desktop/FPGA\ Labs/Laba\ 2 {C:/Users/1prettylaco/Desktop/FPGA Labs/Laba 2/test.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  test

add wave *
view structure
view signals
run -all
