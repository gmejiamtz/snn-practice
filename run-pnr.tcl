# ---- Arguments ----
set part     [lindex $argv 0]
set name     [lindex $argv 1]

# ---- Paths ----
set repo_root .
set proj_root [file dirname [file normalize [info script]]]

# Project directory
set proj_dir "${proj_root}/${name}-${part}"

# ---- Open project ----
if {![file exists "$proj_dir/$name.xpr"]} {
    puts "ERROR: Project not found: $proj_dir/$name.xpr"
    exit 1
}

open_project "$proj_dir/$name.xpr"

# ---- Run Synthesis ----
puts "Running synthesis..."
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    puts "ERROR: Synthesis failed."
    exit 1
}

# ---- Run Implementation (Place & Route) ----
puts "Running implementation..."
reset_run impl_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1

if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    puts "ERROR: Implementation failed."
    exit 1
}

# ---- Generate Bitstream ----
puts "Generating bitstream..."
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

set bitfiles [glob -nocomplain "$proj_dir/$name.runs/impl_1/*.bit"]

if {[llength $bitfiles] > 0} {
    puts "SUCCESS: Bitstream generated."
} else {
    puts "ERROR: Bitstream generation failed."
    exit 1
}

# ---- Close project ----
close_project

