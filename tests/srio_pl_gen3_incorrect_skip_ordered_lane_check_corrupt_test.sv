////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_incorrect_skip_ordered_lane_check_corrupt_test .sv
// Project :  srio vip
// Purpose :  CORRUPTION ORDERED SEQUENCES
// Author  :  Mobiveil
//
// Test for NREAD request class with corrupting orederd sequnces using callback.
// Supported by only  Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_incorrect_skip_ordered_lane_check_corrupt_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_incorrect_skip_ordered_lane_check_corrupt_test)

  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_gen3_invalid_ordered_seq_callback pl_gen3_invalid_ordered_seq_callback;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  pl_gen3_invalid_ordered_seq_callback = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
        uvm_callbacks #(srio_pl_idle_gen, srio_pl_gen3_invalid_ordered_seq_callback)::add(env1.pl_agent.pl_driver.idle_gen, pl_gen3_invalid_ordered_seq_callback);
  endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );

     nread_req_seq.start( env1.e_virtual_sequencer);
    #20000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass
 


