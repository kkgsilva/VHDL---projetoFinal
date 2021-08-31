transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/merci/OneDrive/Documentos/GitHub/VHDL---projetoFinal/projetoFinal.vhd}

vcom -93 -work work {C:/Users/merci/OneDrive/Documentos/GitHub/VHDL---projetoFinal/tb_projetoFinal.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiv_hssi -L cycloneiv_pcie_hip -L cycloneiv -L rtl_work -L work -voptargs="+acc"  tb_projetoFinal

add wave *
view structure
view signals
run -all
