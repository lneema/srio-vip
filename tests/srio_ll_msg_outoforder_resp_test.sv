////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_msg_outoforder_resp_test.sv
// Project :  srio vip
// Purpose :  Message  test
// Author  :  Mobiveil
//
// Message Packet  with out of order packet test.
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_msg_outoforder_resp_test  extends srio_base_test;

  `uvm_component_utils(srio_ll_msg_outoforder_resp_test)

  srio_ll_msg_outoforder_resp_seq msg_outoforder_resp_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
	env2.ll_agent.ll_config.en_out_of_order_gen = TRUE;	
	env2.ll_agent.ll_config.resp_gen_mode = RANDOM;
		
    msg_outoforder_resp_seq = srio_ll_msg_outoforder_resp_seq::type_id::create("msg_outoforder_resp_seq");
      phase.raise_objection( this );
     msg_outoforder_resp_seq.start( env1.e_virtual_sequencer);
	#20000ns;
    phase.drop_objection(this);
    
  endtask

  
endclass


