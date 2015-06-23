////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_dme_prst_test.sv
// Project :  srio vip
// Purpose :  DME training for long run
// Author  :  Mobiveil
//
////Test for DME Preset Training for long run.
//Supported by only Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_dme_prst_test extends srio_base_test;

  `uvm_component_utils(srio_pl_dme_prst_test)

    srio_ll_nread_req_seq ll_nread_req_seq;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

    //Command from ENV1
	env1.pl_agent.pl_config.brc3_training_mode = 1'b1;
	env1.pl_agent.pl_config.dme_cmd_kind = DME_CMD_ENABLED;
	env1.pl_agent.pl_config.dme_cmd_type = DME_PRST;
`ifdef SRIO_VIP_B2B
    //Command from ENV2
	env2.pl_agent.pl_config.brc3_training_mode = 1'b1;
	env2.pl_agent.pl_config.dme_cmd_kind = DME_CMD_ENABLED;
	env2.pl_agent.pl_config.dme_cmd_type = DME_PRST;
`endif
    //NREAD PACKET
     ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
     #5000ns;
     phase.drop_objection(this);
    
  endtask


endclass
