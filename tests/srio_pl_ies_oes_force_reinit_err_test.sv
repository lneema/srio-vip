////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_ies_oes_force_reinit_err_test.sv
// Project :  srio vip
// Purpose :  SOP PADDED
// Author  :  Mobiveil
// 1. send SOP PADDED sequence for GEN3.
// 2. send EOP PADDED sequence for GEN3.
// 3. after ies and oes ,force reinit is applied
// Supported by only  Gen3 mode
// ////////////////////////////////////////////////////////////////////////////////


class srio_pl_ies_oes_force_reinit_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_ies_oes_force_reinit_err_test)
  
  rand bit [0:11] param_value_1;
  srio_pl_gen3_sop_padded_seq pl_gen3_sop_padded_seq;
  srio_pl_gen3_eop_padded_seq pl_gen3_eop_padded_seq;
  srio_ll_nread_req_seq nread_req_seq;  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
   

     if(env_config1.srio_mode == SRIO_GEN13) begin //{
       param_value_1 = 6'd31;            
       end //}
       else if((env_config1.srio_mode == SRIO_GEN21) || (env_config1.srio_mode == SRIO_GEN22)) begin //{
       param_value_1 = 6'd63; 
       end //} 
       else  begin //{
       param_value_1 = 12'd4095; 
       end //}

     pl_gen3_sop_padded_seq = srio_pl_gen3_sop_padded_seq::type_id::create("pl_gen3_sop_padded_seq");
     pl_gen3_eop_padded_seq = srio_pl_gen3_eop_padded_seq::type_id::create("pl_gen3_eop_padded_seq");
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
     phase.raise_objection( this );
     //sop 
     pl_gen3_sop_padded_seq.param_value_0 = param_value_1;
     pl_gen3_sop_padded_seq.start( env1.e_virtual_sequencer);
     //eop
     pl_gen3_eop_padded_seq.param_value_0 = param_value_1;
     pl_gen3_eop_padded_seq.start( env1.e_virtual_sequencer);
     wait(env2.pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.ies_state == 1);
     wait(env1.pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.ies_state == 1);
     wait(env2.pl_agent.pl_driver.driver_trans.ies_state == 1);
     wait(env1.pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.oes_state == 1);
     wait(env2.pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.oes_state == 1);
     wait(env1.pl_agent.pl_driver.driver_trans.oes_state == 1);

     env1.pl_agent.pl_agent_rx_trans.force_reinit  = 1'b1;
     env2.pl_agent.pl_agent_rx_trans.force_reinit  = 1'b1;
     env1.pl_agent.pl_agent_bfm_trans.force_reinit = 1'b1;
     env2.pl_agent.pl_agent_bfm_trans.force_reinit = 1'b1;
     env1.pl_agent.pl_agent_tx_trans.force_reinit  = 1'b1;
     env2.pl_agent.pl_agent_tx_trans.force_reinit  = 1'b1;


     nread_req_seq.start( env1.e_virtual_sequencer);
 
    #20000ns;
    phase.drop_objection(this);
      endtask


endclass



