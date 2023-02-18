# 
# Report generation script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7a35tcpg236-1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir D:/Uklady_elektroniki_cyfrowej_2/Lab_3/build/vga_project.cache/wt [current_project]
  set_property parent.project_path D:/Uklady_elektroniki_cyfrowej_2/Lab_3/build/vga_project.xpr [current_project]
  set_property ip_output_repo D:/Uklady_elektroniki_cyfrowej_2/Lab_3/build/vga_project.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  add_files -quiet D:/Uklady_elektroniki_cyfrowej_2/Lab_3/build/vga_project.runs/synth_1/vga_example.dcp
  read_ip -quiet D:/Uklady_elektroniki_cyfrowej_2/Lab_3/build/vga_project.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
  read_xdc D:/Uklady_elektroniki_cyfrowej_2/Lab_3/build/vga_project.srcs/constrs_1/imports/constraints/vga_example.xdc
  link_design -top vga_example -part xc7a35tcpg236-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force vga_example_opt.dcp
  create_report "impl_1_opt_report_drc_0" "report_drc -file vga_example_drc_opted.rpt -pb vga_example_drc_opted.pb -rpx vga_example_drc_opted.rpx"
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force vga_example_placed.dcp
  create_report "impl_1_place_report_io_0" "report_io -file vga_example_io_placed.rpt"
  create_report "impl_1_place_report_utilization_0" "report_utilization -file vga_example_utilization_placed.rpt -pb vga_example_utilization_placed.pb"
  create_report "impl_1_place_report_control_sets_0" "report_control_sets -file vga_example_control_sets_placed.rpt"
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force vga_example_routed.dcp
  create_report "impl_1_route_report_drc_0" "report_drc -file vga_example_drc_routed.rpt -pb vga_example_drc_routed.pb -rpx vga_example_drc_routed.rpx"
  create_report "impl_1_route_report_methodology_0" "report_methodology -file vga_example_methodology_drc_routed.rpt -pb vga_example_methodology_drc_routed.pb -rpx vga_example_methodology_drc_routed.rpx"
  create_report "impl_1_route_report_power_0" "report_power -file vga_example_power_routed.rpt -pb vga_example_power_summary_routed.pb -rpx vga_example_power_routed.rpx"
  create_report "impl_1_route_report_route_status_0" "report_route_status -file vga_example_route_status.rpt -pb vga_example_route_status.pb"
  create_report "impl_1_route_report_timing_summary_0" "report_timing_summary -file vga_example_timing_summary_routed.rpt -warn_on_violation  -rpx vga_example_timing_summary_routed.rpx"
  create_report "impl_1_route_report_incremental_reuse_0" "report_incremental_reuse -file vga_example_incremental_reuse_routed.rpt"
  create_report "impl_1_route_report_clock_utilization_0" "report_clock_utilization -file vga_example_clock_utilization_routed.rpt"
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force vga_example_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  catch { write_mem_info -force vga_example.mmi }
  write_bitstream -force vga_example.bit 
  catch {write_debug_probes -quiet -force vga_example}
  catch {file copy -force vga_example.ltx debug_nets.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

