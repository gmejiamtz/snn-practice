# This script creates a project in the $name-$platform directory that
set part [lindex $argv 0]
set name [lindex $argv 1]
set repo_root .
set proj_root [ file dirname [ file normalize [ info script ] ] ]
create_project $name $name-$part/ -part $part
set_property board_part digilentinc.com:basys3:part0:1.2 [current_project]

# Add all sources for project. If they are included in an IP diagram,
# they must be verilog files for some reason, not .sv.
add_files -norecurse ./common/rtl/snn_axil.sv
add_files -norecurse ./common/rtl/snn_axil.sv
add_files -norecurse ./common/rtl/lif_neuron.sv
add_files -norecurse ./common/rtl/lif.sv
add_files -norecurse ./common/rtl/current_acc.sv
add_files -norecurse ./common/rtl/spiking_neural_net.sv
add_files -fileset constrs_1 -norecurse ./common/contraints/Basys-3-Master.xdc
add_files -fileset sim_1 -norecurse ./common/sim/tb_snn_axil.sv
add_files -fileset sim_1 -norecurse ./common/sim/tb_lif_neuron.sv
add_files -fileset sim_1 -norecurse ./common/sim/tb_current_acc.sv
add_files -fileset sim_1 -norecurse ./common/sim/tb_lif_acc.sv
add_files -fileset sim_1 -norecurse ./common/sim/tb_spiking_neural_net.sv

update_compile_order -fileset sources_1

#Adding custom ip

# Assuming repo_root is already defined
set ip_repo [file join $repo_root "ip_repo"]

# Add this repository to the current project
set_property ip_repo_paths $ip_repo [current_project]

# Update the catalog so Vivado sees your IP
update_ip_catalog -rebuild

source $proj_root/bd.tcl

#Create wrapper for top block design
make_wrapper -files [get_files $name-$part/$name.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $name-$part/$name.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
set_property top design_1_wrapper [current_fileset]

update_compile_order -fileset sources_1
