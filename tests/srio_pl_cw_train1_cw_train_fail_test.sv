////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_cw_train1_cw_train_fail_test.sv
// Project :  srio vip
// Purpose :  CW training.
// Author  :  Mobiveil
//
////1.Set short run.
// 2. set the low value to timer for getting fail state.
// 3.Set increment and decrement command with Tap value random.
//Supported by only Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_cw_train1_cw_train_fail_test extends srio_base_test;

  `uvm_component_utils(srio_pl_cw_train1_cw_train_fail_test)

    srio_ll_nread_req_seq ll_nread_req_seq;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

	env1.pl_agent.pl_config.brc3_training_mode = 1'b0;
    // Timer value
        env1.pl_agent.pl_config.gen3_training_timer = 100;
`ifdef SRIO_VIP_B2B
	    env2.pl_agent.pl_config.brc3_training_mode = 1'b0;
        env2.pl_agent.pl_config.gen3_training_timer = 100;
`endif
    //Command from ENV1
	env1.pl_agent.pl_config.cw_cmd_kind = CW_CMD_ENABLED;
	env1.pl_agent.pl_config.cw_cmd_type = CW_INCR;
        env1.pl_agent.pl_config.cw_tap_type = CW_CMD_TRANDOM;
    //Command from ENV2
	env1.pl_agent.pl_config.cw_cmd_kind = CW_CMD_ENABLED;
	env1.pl_agent.pl_config.cw_cmd_type = CW_DECR;
        env1.pl_agent.pl_config.cw_tap_type = CW_CMD_TRANDOM;
      //NREAD PACKET
     ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
     #5000ns;
     phase.drop_objection(this);
    
  endtask


endclass
