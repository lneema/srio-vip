////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_start_cw_open_context_err_test.sv
// Project :  srio vip
// Purpose :  Start code word in open context error
// Author  :  Mobiveil
//
// Tests for corrupted code word i.e.,CSB followed by CSB not of CSE or CSEB.
// Supported by only  Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_start_cw_open_context_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_start_cw_open_context_err_test)

   srio_ll_nread_req_seq nread_req_seq; 
  //callback handle 
   srio_pl_start_cw_open_context_err_cb pl_start_cw_open_context_err_cb;
   
  function new(string name, uvm_component parent=null);
    super.new(name, parent);

  pl_start_cw_open_context_err_cb = new();
    
  endfunction 
              
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    
  uvm_callbacks #(srio_pl_lane_driver, srio_pl_start_cw_open_context_err_cb)::add(env1.pl_agent.pl_driver.lane_driver_ins[0], pl_start_cw_open_context_err_cb);
    endfunction

     task run_phase( uvm_phase phase );
    super.run_phase(phase);

     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
     nread_req_seq.start( env1.e_virtual_sequencer);
     #2000ns;
     phase.drop_objection(this);
    
  endtask

  

endclass

