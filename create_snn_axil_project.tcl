# This script creates a project in the $name-$platform directory that
set part [lindex $argv 0]
set name [lindex $argv 1]
set ip_dir [lindex $argv 2]
set repo_root .
set proj_root [ file dirname [ file normalize [ info script ] ] ] 
create_project $name $name-$part/ -part $part
set_property board_part digilentinc.com:basys3:part0:1.2 [current_project]

# Add all sources for project. If they are included in an IP diagram,
# they must be verilog files for some reason, not .sv.
add_files -norecurse ./common/rtl/snn_axil.sv
add_files -norecurse ./common/rtl/lif_neuron.sv
add_files -norecurse ./common/rtl/spiking_neural_net.sv
add_files -fileset constrs_1 -norecurse ./common/contraints/Basys-3-Master.xdc
add_files -fileset sim_1 -norecurse ./common/sim/tb_snn_axil.sv

update_compile_order -fileset sources_1

set_property top snn_axil [current_fileset]

update_compile_order -fileset sources_1

# IP repository path
set ip_repo "${repo_root}/${ip_dir}"

ipx::package_project -root_dir $ip_repo -vendor user.org -library user -taxonomy /UserIP -import_files
update_compile_order -fileset sources_1
set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  $ip_repo [current_project]

update_ip_catalog -rebuild