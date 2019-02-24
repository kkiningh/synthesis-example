source -echo -verbose "scripts/dc/dc_setup.tcl"

# Enable support for via RC estimation
set_app_var spg_enable_via_resistance_support true

# Define the folder to use for temporary files
define_design_lib WORK -path ./WORK

# Read and link the design
analyze -format sverilog ${RTL_SOURCE_FILES}
elaborate ${DESIGN_NAME}
current_design ${DESIGN_NAME}
link

# Check design for consistancy
check_design -summary
