set part [lindex $argv 0]
set name [lindex $argv 1]

set proj_root [file dirname [file normalize [info script]]]

create_project $name $name-$part/ -part $part
set_property board_part digilentinc.com:basys3:part0:1.2 [current_project]

add_files -norecurse ./common/rtl/snn_axil.v
add_files -fileset constrs_1 -norecurse ./common/contraints/Basys-3-Master.xdc
update_compile_order -fileset sources_1

set local_ip_dir "$proj_root/ip_repo"
file mkdir $local_ip_dir

ipx::package_project -root_dir "$local_ip_dir/snn_axil_ip"
set core [ipx::current_core]

set fg [lindex [ipx::get_file_groups "*"] 0]
ipx::add_file "$proj_root/common/rtl/snn_axil.v" $fg

set_property vendor user.org $core
set_property library user $core
set_property name snn_axil $core
set_property version 1.0 $core
set_property display_name "SNN AXI Lite Master" $core
set_property description "Custom AXI Lite Master for UART-based ALU" $core
set_property taxonomy {/UserIP/AXI} $core

ipx::infer_bus_interfaces $core

ipx::check_integrity $core
ipx::create_xgui_files $core
ipx::save_core $core

set_property ip_repo_paths $local_ip_dir [current_project]
update_ip_catalog

source $proj_root/bd.tcl

make_wrapper \
    -files [get_files $name-$part/$name.srcs/sources_1/bd/design_1/design_1.bd] \
    -top

add_files -norecurse \
    "$name-$part/$name.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v"

update_compile_order -fileset sources_1

