////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    : srio_pl_aet_tminus_random_test .sv
// Project :  srio vip
// Purpose :  AET
// Author  :  Mobiveil
//
//// Test for TAP MINUS command and selecting random operation for getting the emphasis 
//value.
//Supported by only Gen2 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_aet_tminus_random_test extends srio_base_test;

  `uvm_component_utils(srio_pl_aet_tminus_random_test)

    srio_ll_nread_req_seq ll_nread_req_seq;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

	env1.pl_agent.pl_config.aet_en = 1'b1;
	env1.pl_agent.pl_config.aet_cmd_kind = CMD_ENABLED;
	env1.pl_agent.pl_config.aet_cmd_type = TAPMINUS;
	env1.pl_agent.pl_config.aet_tminus_kind = TM_RANDOM;
	
    ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
     
    phase.drop_objection(this);
    
  endtask



endclass


