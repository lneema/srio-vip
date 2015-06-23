////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_pnack_diff_cause_gen1_err_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for NREAD request class with callback to corrupt ackid and crc
// Support only gen1
////////////////////////////////////////////////////////////////////////////////

class srio_pl_pnack_diff_cause_gen1_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_pnack_diff_cause_gen1_err_test)

  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_pnack_diff_cause_gen1_err_cb pl_pnack_diff_cause_gen1_err_cb; 
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_pnack_diff_cause_gen1_err_cb = new();
  endfunction

   function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
     pl_pnack_diff_cause_gen1_err_cb.pl_agent_cb = env1.pl_agent;
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_pnack_diff_cause_gen1_err_cb)::add(env1.pl_agent.pl_driver.idle_gen,pl_pnack_diff_cause_gen1_err_cb);
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
