
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_align_error_2_sm_test.sv
// Project :  srio vip
// Purpose :  Sync Break
// Author  :  Mobiveil
// 1. Add callbacks for align break
// 2.set sync break threshold value to more than Mmax
 // 3. wait for aligned states and corrupt 2 times.
// 4. send nread.
// Supported by only  Gen2 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_align_error_2_sm_test extends srio_base_test;

   `uvm_component_utils(srio_pl_align_error_2_sm_test)

   srio_ll_nread_req_seq nread_req_seq; 
  
   srio_pl_align_error_2_sm_callback pl_align_error_2_sm_callback_ins;
   
  function new(string name, uvm_component parent=null);
    super.new(name, parent);

  pl_align_error_2_sm_callback_ins = new();
    
  endfunction 
 
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_align_error_2_sm_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_align_error_2_sm_callback_ins);
  endfunction

     task run_phase( uvm_phase phase );
    super.run_phase(phase);
    env1.pl_agent.pl_config.sync_break_threshold = 15;   //To avoid sync break the Icounter value to be max.

    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     nread_req_seq.start( env1.e_virtual_sequencer);
    #2000ns;
 
    phase.drop_objection(this);
    
  endtask

 
endclass


