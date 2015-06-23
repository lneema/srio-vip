////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_cg_invalid_for_skip_cb_test.sv
// Project :  srio vip
// Purpose :  Base test
// Author  :  Mobiveil
//
// Test to corrupt code group
// Supported by only  Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_cg_invalid_for_skip_cb_test extends srio_base_test;

  `uvm_component_utils(srio_pl_cg_invalid_for_skip_cb_test)
     srio_ll_nread_req_seq ll_nread_req_seq;
     srio_pl_cg_invalid_for_skip_callback pl_cg_invalid_for_skip_callback_ins;
  bit [1:0] cmd_ack_status;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
    pl_cg_invalid_for_skip_callback_ins = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
       pl_cg_invalid_for_skip_callback_ins.pl_agent_cb = env1.pl_agent;
  uvm_callbacks #(srio_pl_lane_driver, srio_pl_cg_invalid_for_skip_callback)::add(env1.pl_agent.pl_driver.lane_driver_ins[0],pl_cg_invalid_for_skip_callback_ins);

  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
     phase.raise_objection( this );

    	ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");
       ll_nread_req_seq.start( env1.e_virtual_sequencer);

    	#10000ns;
     
    	phase.drop_objection(this);
    
  endtask

endclass

