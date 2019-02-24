puts "Info: Running script [info script]"
source "scripts/common/saed32.tcl"
source "scripts/common/design.tcl"

if {![shell_is_in_topographical_mode]} {
  puts "Error: dc_shell must be run in topographical mode."
  exit 1
}

###############################################################################
# Variable name setup
###############################################################################
# Milkyway library
set MW_LIBRARY_NAME  ${DESIGN_NAME}_LIB

# Constraint files
set SDC_INPUT_FILE   scripts/sdc/${DESIGN_NAME}.sdc

# Check reports
set CHECK_LIBRARY_REPORT      ${DESIGN_NAME}.check_library.rpt
set CHECK_DESIGN_REPORT       ${DESIGN_NAME}.check_design.rpt

# Final reports
set FINAL_QOR_REPORT                     ${DESIGN_NAME}.mapped.qor.rpt
set FINAL_TIMING_REPORT                  ${DESIGN_NAME}.mapped.timing.rpt
set FINAL_AREA_REPORT                    ${DESIGN_NAME}.mapped.area.rpt
set FINAL_POWER_REPORT                   ${DESIGN_NAME}.mapped.power.rpt
set FINAL_DESIGNWARE_AREA_REPORT         ${DESIGN_NAME}.mapped.designware_area.rpt
set FINAL_RESOURCES_REPORT               ${DESIGN_NAME}.mapped.final_resources.rpt
set FINAL_CLOCK_GATING_REPORT            ${DESIGN_NAME}.mapped.clock_gating.rpt
set FINAL_SELF_GATING_REPORT             ${DESIGN_NAME}.mapped.self_gating.rpt
set THRESHOLD_VOLTAGE_GROUP_REPORT       ${DESIGN_NAME}.mapped.threshold.voltage.group.rpt

# DCT reports
set DCT_PHYSICAL_CONSTRAINTS_REPORT ${DESIGN_NAME}.physical_constraints.rpt

# Design outputs
set ELABORATED_DESIGN_DDC_OUTPUT_FILE ${DESIGN_NAME}.elab.ddc
set FINAL_DDC_OUTPUT_FILE             ${DESIGN_NAME}.mapped.ddc
set FINAL_SDC_OUTPUT_FILE             ${DESIGN_NAME}.mapped.sdc

# Create the reports/results dir if not already created
set REPORTS_DIR "reports"
set RESULTS_DIR "results"
file mkdir ${REPORTS_DIR}
file mkdir ${RESULTS_DIR}

###############################################################################
# Milkyway library setup
###############################################################################
# Milkyway variable settings
set mw_reference_library ${MW_REFERENCE_LIB_DIRS}
set mw_design_library    ${MW_LIBRARY_NAME}
set mw_site_name_mapping { {CORE unit} {Core unit} {core unit} }

# Only create new Milkyway design library if it doesn't already exist
if {![file isdirectory $mw_design_library ]} {
  create_mw_lib \
    -technology $TECH_FILE \
    -mw_reference_library $mw_reference_library \
    $mw_design_library
} else {
  # If Milkyway design library already exists, ensure that it is consistent with specified Milkyway reference libraries
  set_mw_lib_reference \
    $mw_design_library \
    -mw_reference_library $mw_reference_library
}

open_mw_lib $mw_design_library

check_library > ${REPORTS_DIR}/${CHECK_LIBRARY_REPORT}

set_tlu_plus_files \
  -max_tluplus $TLUPLUS_MAX_FILE \
  -min_tluplus $TLUPLUS_MIN_FILE \
  -tech2itf_map $MAP_FILE

check_tlu_plus_files

###############################################################################
# Library setup
###############################################################################
set_app_var search_path ". ${ADDITIONAL_SEARCH_PATH} $search_path"
set_app_var target_library ${TARGET_LIBRARY_FILES}
set_app_var synthetic_library {dw_minpower.sldb dw_foundation.sldb}
set_app_var link_library "* $target_library $ADDITIONAL_LINK_LIB_FILES $synthetic_library"
foreach {max_library min_library} $MIN_LIBRARY_FILES {
  set_min_library $max_library -min_version $min_library
}

###############################################################################
# Don't use file
###############################################################################
if {[file exists [which ${LIBRARY_DONT_USE_FILE}]]} {
  puts "Info: Sourcing script file [which ${LIBRARY_DONT_USE_FILE}]\n"
  source ${LIBRARY_DONT_USE_FILE}
}

puts "Info: Completed script [info script]"
