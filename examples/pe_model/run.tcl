


set dump 1
set dump_type TRN
set wave_depth -1
set wave_memory 0
set wave_exclude [list ]
set wave_addition [list ]
set debug 0
set memory 0
proc trace {scope_name maxdepth} {
	global debug memory
	scope $scope_name
	if {$memory!=0} {
      set mem_str "-memories"
   } else {
      set mem_str ""
	}
	if { $maxdepth == 0 } {
	} elseif { $maxdepth == -1 } {
      set dep_str "-depth all"
	} elseif { $maxdepth == -2 } {
	} else {
   }

	puts "probe -all $mem_str $dep_str "
   eval "probe -all $mem_str $dep_str"

	if {$debug >= 5} {puts "Tracing Started..."}
}

proc trace_init {wavetype} {
	database -open trace1 -$wavetype
}

proc set_memory {memory_int} {
	global memory
	set memory $memory_int
}



if {$dump} {
   if {$dump_type == "TRN" || $dump_type == "SHM" || $dump_type == "VCD"} {
      # Capture all waves
      if {$dump_type == "TRN" || $dump_type == "SHM"} {
         trace_init shm
      }
      if {$dump_type == "VCD"} {
         trace_init vcd
      }

      set_memory $wave_memory

      set log [open "wave.log" "w"]

      foreach mod [scope -tops] {
         puts "waves in $mod"
         foreach pat $wave_exclude {
            if {[regexp $pat $mod] == 1} {
               set exclude 1
            }
         }
         catch {
            puts $log "trace $mod $wave_depth"
            trace $mod $wave_depth
         } errmsg
         puts "message $errmsg"
      }

      foreach mod $wave_addition {
         catch {
            puts $log "trace $mod $wave_depth"
            trace $mod $wave_depth
         } errmsg
         puts "message $errmsg"
      }
   }
}
source code_cov.tcl
run
exit
