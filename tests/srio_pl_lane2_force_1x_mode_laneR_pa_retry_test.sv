////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_lane2_force_1x_mode_laneR_pa_retry_test.sv
// Project :  srio vip
// Purpose :  force 1x mode portwidth overide
// Author  :  Mobiveil
//
// Test to reinitialize the state changes..
// 1.Force 1x mode lane and lane R enabled.
// 2. Configured packet accepted and packet retry ratio as 50-50.
// 3.After state changes ,wait for link initialization and use nread transcation .
// 4.NREAD transcation
//
////////////////////////////////////////////////////////////////////////////////


class srio_pl_lane2_force_1x_mode_laneR_pa_retry_test extends srio_base_test;

  `uvm_component_utils(srio_pl_lane2_force_1x_mode_laneR_pa_retry_test)
  
 
  srio_ll_nread_req_seq nread_req_seq;
  
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

    //Force 1x_mode and Force 1x_mode_laneR support 
     env1.pl_agent.pl_config.nx_mode_support = 0;
     env1.pl_agent.pl_config.x2_mode_support = 0;  
     env1.pl_agent.pl_agent_rx_trans.force_1x_mode = 1;
     env1.pl_agent.pl_agent_bfm_trans.force_1x_mode = 1;
     env1.pl_agent.pl_agent_rx_trans.force_laneR = 1;
     env1.pl_agent.pl_agent_bfm_trans.force_laneR = 1;


    if ((env_config1.num_of_lanes == 2))  //{
      begin//{
          void'(srio2_reg_model_rx.Port_0_Control_CSR.Port_Width_Override.predict(3'b011));
          void'(srio2_reg_model_rx.Port_0_Control_CSR.Port_Width_Support.predict(2'b00));
      end //}

     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

   // Configuring pl_config packet accepted and packet retry ratio
     
     env2.pl_agent.pl_config.pkt_accept_prob=50;
     env2.pl_agent.pl_config.pkt_retry_prob=50;     
     phase.raise_objection( this );

     nread_req_seq.start( env1.e_virtual_sequencer);  ///NREAD 

     #2000ns;
     phase.drop_objection(this);

  endtask

  
endclass

