#########
# Example don't use file
# Add any cells here that should not be considered during synthesis
########

# Remove all previous don't use attributes
# remove_attribute -quiet [get_lib_cells */*] dont_use

# Scan chain cells
# set_attribute -quiet [get_lib_cells */RSDFFARX*_HVT*] dont_use true
# set_attribute -quiet [get_lib_cells */RSDFFARX*_HVT*] dont_touch true

# pmos/nmos transistor cells
set_attribute -quiet [get_lib_cells */PMT*_*VT] dont_use true
set_attribute -quiet [get_lib_cells */NMT*_*VT] dont_use true
