set sdc_version 2.1

# Clock
create_clock [get_ports clock] -name CLOCK -period 1.000
set_clock_uncertainty 0.017 [get_clocks CLOCK] # From PLL uncertainty

# Driving cell is minimum sized inverter
set_driving_cell -lib_cell INVX1_HVT -library saed32hvt_ss0p95v125c [all_inputs]

# Load cell is medium sized DFF
set_load [load_of saed32hvt_ss0p95v125c/DFFARX2/D] [all_outputs]

# Max delay from reset
set_max_delay 10 -from reset_n
