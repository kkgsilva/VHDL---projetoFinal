#vsim -do tb_script.do
 

if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -93 "projetoFinal.vhd"
vcom -explicit  -93 "tb_projetoFinal.vhd"
vsim -t 1ns   -lib work tb_projetoFinal
add wave sim:/tb_projetoFinal/*
#do {wave.do}
view wave
view structure
#view signals
run 1300ns
#quit -force

