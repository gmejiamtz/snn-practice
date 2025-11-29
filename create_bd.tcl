# This script creates a project in the $name-$platform directory that
set part [lindex $argv 0]
set name [lindex $argv 1]
set repo_root .
set proj_root [ file dirname [ file normalize [ info script ] ] ]
create_project $name $name-$part/ -part $part
set_property board_part digilentinc.com:basys3:part0:1.2 [current_project]

# Add all sources for project. If they are included in an IP diagram,
# they must be verilog files for some reason, not .sv.
add_files -norecurse ./common/rtl/xor_gate.v
add_files -norecurse ./common/rtl/snn_axil.v
add_files -fileset constrs_1 -norecurse ./common/contraints/Basys-3-Master.xdc

update_compile_order -fileset sources_1

source $proj_root/bd.tcl

#Create wrapper for top block design
make_wrapper -files [get_files $name-$part/$name.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $name-$part/$name.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1
