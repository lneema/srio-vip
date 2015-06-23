////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_outstanding_unack_req_test.sv
// Project :  srio vip
// Purpose :  Random request test 
// Author  :  Mobiveil
//
// Test for random request with 2^n outstanding unacknowledged response
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_outstanding_unack_req_test extends srio_base_test;

  `uvm_component_utils(srio_ll_outstanding_unack_req_test)

  srio_ll_outstanding_unack_req_seq outstanding_unack_req_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
      outstanding_unack_req_seq = srio_ll_outstanding_unack_req_seq::type_id::create("outstanding_unack_req_seq");
      phase.raise_objection( this );
     //disable packet accepted
     env2.pl_agent.pl_config.pkt_acc_gen_kind        = PL_DISABLED;  
     outstanding_unack_req_seq.start( env1.e_virtual_sequencer);

    #20000ns;
    phase.drop_objection(this);
    
  endtask


endclass


