set bitfile [lindex $argv 0]

if {$bitfile eq ""} {
    puts "ERROR: You must provide a .bit file path"
    exit 1
}

if {![file exists $bitfile]} {
    puts "ERROR: Bitstream not found: $bitfile"
    exit 1
}

puts "Opening Hardware Manager..."
open_hw
connect_hw_server
open_hw_target

# Try to get the first connected device (Basys3)
set hw_device [lindex [get_hw_devices] 0]

if {$hw_device eq ""} {
    puts "ERROR: No FPGA device found."
    exit 1
}

puts "Using device: $hw_device"

# Program FPGA
set_property PROGRAM.FILE $bitfile $hw_device
program_hw_devices $hw_device

puts "SUCCESS: FPGA programmed."

close_hw

