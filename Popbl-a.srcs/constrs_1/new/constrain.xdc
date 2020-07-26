##clocka
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

# LEDs
###hasierako egoerak
set_property PACKAGE_PIN E19 [get_ports {pauseLed}]
set_property IOSTANDARD LVCMOS33 [get_ports {pauseLed}]
set_property PACKAGE_PIN U19 [get_ports {finishLed}]
set_property IOSTANDARD LVCMOS33 [get_ports {finishLed}]
###egoera berriak

###displaya
set_property PACKAGE_PIN W7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property PACKAGE_PIN W6 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U8 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V5 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U7 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

###display aukeraketa
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


##botoiak
set_property PACKAGE_PIN U18 [get_ports {botoia}]
set_property IOSTANDARD LVCMOS33 [get_ports {botoia}]
set_property PACKAGE_PIN T18 [get_ports {rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]


###switchak
set_property PACKAGE_PIN R2 [get_ports {swPause}]
set_property IOSTANDARD LVCMOS33 [get_ports {swPause}]
#set_property PACKAGE_PIN T1 [get_ports {switch[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {switch[1]}]
#set_property PACKAGE_PIN U1 [get_ports {switch[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {switch[2]}]


##uarteko gauzak
set_property PACKAGE_PIN B15 [get_ports serial_in]
set_property IOSTANDARD LVCMOS33 [get_ports serial_in]

set_property PACKAGE_PIN B16 [get_ports {serial_out}]
set_property IOSTANDARD LVCMOS33 [get_ports {serial_out}]


set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]