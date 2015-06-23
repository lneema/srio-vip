////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    : srio_pl_dme1_dmef_test.sv
// Project :  srio vip
// Purpose :  DME training for long run
// Author  :  Mobiveil
//
////Test for DME Training for long run to cover DME_TRAINING_FAIL state.
//Supported by only Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_dme1_dmef_test extends srio_base_test;

  `uvm_component_utils(srio_pl_dme1_dmef_test)

    srio_ll_nread_req_seq ll_nread_req_seq;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

	env1.pl_agent.pl_config.brc3_training_mode = 1'b1;

    //configuring aet training timer greater than the gen3 timer for env1
	env1.pl_agent.pl_config.aet_training_period = 10000;
	env1.pl_agent.pl_config.gen3_training_timer = 5000;

    //configuring aet training timer greater than the gen3 timer for env2
	env1.pl_agent.pl_config.aet_training_period = 10000;
	env1.pl_agent.pl_config.gen3_training_timer = 5000;

    //Command from ENV1
	env1.pl_agent.pl_config.dme_cmd_kind = DME_CMD_ENABLED;
	env1.pl_agent.pl_config.dme_cmd_type = DME_CMD_RANDOM;

`ifdef SRIO_VIP_B2B
    //Command from ENV2
	env2.pl_agent.pl_config.brc3_training_mode = 1'b1;
	env2.pl_agent.pl_config.dme_cmd_kind = DME_CMD_ENABLED;
	env2.pl_agent.pl_config.dme_cmd_type = DME_CMD_RANDOM;
`endif
    //NREAD PACKET
     ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
     #5000ns;
     phase.drop_objection(this);
    
  endtask


endclass
