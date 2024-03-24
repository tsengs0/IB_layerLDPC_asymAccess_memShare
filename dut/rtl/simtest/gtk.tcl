# clear all
set nfacs [ gtkwave::getNumFacs ]
set signals [list]
for {set i 0} {$i < $nfacs } {incr i} {
    set facname [ gtkwave::getFacName $i ]
    lappend signals "$facname"
}
gtkwave::deleteSignalsFromList $signals

# add instance port
set ports [list tb_extend_memOut_port.extend_port_o tb_extend_memOut_port.real_port_i tb_extend_memOut_port.sys_clk tb_extend_memOut_port.rstn]
gtkwave::addSignalsFromList $ports
