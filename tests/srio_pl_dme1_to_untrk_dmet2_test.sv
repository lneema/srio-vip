////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_dme1_to_untrk_dmet2_test.sv
// Project :  srio vip
// Purpose :  DME training for long run
// Author  :  Mobiveil
//
////Test for DME Training for long run to cover DME_TRAINING1 STATE TO UNTRAINED AND DME_TRAINING TO DME_TRAINING1 STATE .
//Supported by only Gen3 mode
////////////////////////////////////////////////////////////////////////////////

class srio_pl_dme1_to_untrk_dmet2_test extends srio_base_test;

  `uvm_component_utils(srio_pl_dme1_to_untrk_dmet2_test)

    srio_ll_nread_req_seq ll_nread_req_seq;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

	env1.pl_agent.pl_config.brc3_training_mode = 1'b1;
`ifdef SRIO_VIP_B2B
	env2.pl_agent.pl_config.brc3_training_mode = 1'b1;
`endif 
    //Command from ENV1
	env1.pl_agent.pl_config.dme_cmd_kind = DME_CMD_ENABLED;
	env1.pl_agent.pl_config.dme_cmd_type = DME_INCR;
if(env_config1.num_of_lanes == 1)
  begin
   fork 
   begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 1;      
    end
    join_none
  end

else if(env_config1.num_of_lanes == 2)
 begin
  fork 
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.from_dme_rcvr_ready[1] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.from_dme_rcvr_ready[1] = 1;      
    end
join_none
 end
else if(env_config1.num_of_lanes == 4)
 begin
  fork 
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.from_dme_rcvr_ready[1] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.from_dme_rcvr_ready[1] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.from_dme_rcvr_ready[2] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.from_dme_rcvr_ready[2] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.from_dme_rcvr_ready[3] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.from_dme_rcvr_ready[3] = 1;      
    end
join_none
end
else if(env_config1.num_of_lanes == 8)
 begin
  fork 
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.from_dme_rcvr_ready[1] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.from_dme_rcvr_ready[1] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.from_dme_rcvr_ready[2] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.from_dme_rcvr_ready[2] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.from_dme_rcvr_ready[3] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.from_dme_rcvr_ready[3] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.from_dme_rcvr_ready[4] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.from_dme_rcvr_ready[4] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.from_dme_rcvr_ready[5] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.from_dme_rcvr_ready[5] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.from_dme_rcvr_ready[6] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.from_dme_rcvr_ready[6] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.from_dme_rcvr_ready[7] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.from_dme_rcvr_ready[7] = 1;      
    end
  join_none 
 end

else if(env_config1.num_of_lanes == 16)
 begin
  fork 
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.drvr_oe[0] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[0].lh_trans.from_dme_rcvr_ready[0] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.drvr_oe[1] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.from_dme_rcvr_ready[1] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[1].lh_trans.from_dme_rcvr_ready[1] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.drvr_oe[2] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.from_dme_rcvr_ready[2] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[2].lh_trans.from_dme_rcvr_ready[2] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.drvr_oe[3] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.from_dme_rcvr_ready[3] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[3].lh_trans.from_dme_rcvr_ready[3] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.drvr_oe[4] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.from_dme_rcvr_ready[4] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[4].lh_trans.from_dme_rcvr_ready[4] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.drvr_oe[5] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.from_dme_rcvr_ready[5] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[5].lh_trans.from_dme_rcvr_ready[5] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.drvr_oe[6] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.from_dme_rcvr_ready[6] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[6].lh_trans.from_dme_rcvr_ready[6] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.drvr_oe[7] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.from_dme_rcvr_ready[7] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[7].lh_trans.from_dme_rcvr_ready[7] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.drvr_oe[8] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.drvr_oe[8] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.from_dme_rcvr_ready[8] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[8].lh_trans.from_dme_rcvr_ready[8] = 1;      
    end

    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.drvr_oe[9] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.drvr_oe[9] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.from_dme_rcvr_ready[9] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[9].lh_trans.from_dme_rcvr_ready[9] = 1;      
    end
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.drvr_oe[10] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.drvr_oe[10] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.from_dme_rcvr_ready[10] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[10].lh_trans.from_dme_rcvr_ready[10] = 1;      
    end
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.drvr_oe[11] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.drvr_oe[11] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.from_dme_rcvr_ready[11] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[11].lh_trans.from_dme_rcvr_ready[11] = 1;      
    end
    begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.drvr_oe[12] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.drvr_oe[12] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.from_dme_rcvr_ready[12] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[12].lh_trans.from_dme_rcvr_ready[12] = 1;      
    end
   begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.drvr_oe[13] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.drvr_oe[13] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.from_dme_rcvr_ready[13] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[13].lh_trans.from_dme_rcvr_ready[13] = 1;      
    end
   begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.drvr_oe[14] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.drvr_oe[14] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.from_dme_rcvr_ready[14] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[14].lh_trans.from_dme_rcvr_ready[14] = 1;      
    end
   begin
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.drvr_oe[15] = 0;
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_dme_train_state == UNTRAINED)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.drvr_oe[15] = 1; 
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_dme_train_state == DME_TRAINING_2)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.from_dme_rcvr_ready[15] = 0;      
      wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].current_dme_train_state == DME_TRAINING_1)
        env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[15].lh_trans.from_dme_rcvr_ready[15] = 1;      
    end
 join_none
end
    //NREAD PACKET
     ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
     #5000ns;
     phase.drop_objection(this);
    
  endtask


endclass
