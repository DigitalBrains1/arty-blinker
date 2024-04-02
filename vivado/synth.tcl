source -notrace ../clashConnector.tcl
#set clash::dryRun yes
set clash::verbosity 2
clash::readMetadata ../../verilog/Blinker.topEntity/
clash::createAndReadIp -dir ip
clash::readHdl
clash::readXdc {early normal}
read_xdc ../Arty-A7-35-BlinkerClockWizard.xdc
set_property USED_IN implementation [get_files ../Arty-A7-35-BlinkerClockWizard.xdc]
clash::readXdc late
synth_design -top $clash::topEntity -part xc7a35ticsg324-1L
opt_design
place_design
route_design
write_bitstream ${clash::topEntity}.bit
#start_gui
