////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_port_resp_timeout_reg_test .sv
// Project :  srio vip
// Purpose :  Register configure --Port response timeout
// Author  :  Mobiveil
//
// Test for port repsonse timeout register
//
////////////////////////////////////////////////////////////////////////////////

class srio_ll_port_resp_timeout_reg_test extends srio_base_test;

  `uvm_component_utils(srio_ll_port_resp_timeout_reg_test)

  srio_ll_port_resp_timeout_reg_seq port_resp_timeout_reg_seq;

    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

          
    port_resp_timeout_reg_seq = srio_ll_port_resp_timeout_reg_seq::type_id::create("port_resp_timeout_reg_seq");

     phase.raise_objection( this );
     port_resp_timeout_reg_seq.start( env1.e_virtual_sequencer);
    
    #5000ns; 
    phase.drop_objection(this);
    
  endtask

endclass


