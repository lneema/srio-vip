////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_timestamp_seq_err_test.sv
// Project :  srio vip
// Purpose :  NREAD
// Author  :  Mobiveil
//
// Test for NREAD request class
// Supported by only Gen3 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_timestamp_seq_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_timestamp_seq_err_test)

  srio_ll_nread_req_seq nread_req_seq;
  srio_pl_timestamp_seq_err_cb pl_timestamp_seq_err_cb;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_timestamp_seq_err_cb = new();
  endfunction
  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
   //callback which is used to corrupt timestamp sequence 
    uvm_callbacks #(srio_pl_lane_driver, srio_pl_timestamp_seq_err_cb)::add(env2.pl_agent.pl_driver.lane_driver_ins[0], pl_timestamp_seq_err_cb);

   endfunction
    task run_phase( uvm_phase phase );
    super.run_phase(phase);
       
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

    env_config1.spec_support = V30;
    env_config2.spec_support = V30;
    env1.pl_agent.pl_config.timestamp_master_slave_support = 1;
    env1.pl_agent.pl_config.timestamp_sync_support = 1;
    env1.pl_agent.pl_agent_bfm_trans.timestamp_master = 1;
    env1.pl_agent.pl_agent_rx_trans.timestamp_master = 1;
    void'(srio2_reg_model_rx.Port_0_Timestamp_Generator_Synchronization_CSR.Port_Opening_Mode.predict(2'b01));
    void'(srio2_reg_model_rx.Timestamp_CAR.Timestamp_Master_Supported.predict(1'b1));
    env2.pl_agent.pl_config.timestamp_sync_support = 1;
    void'(srio1_reg_model_rx.Port_0_Timestamp_Generator_Synchronization_CSR.Port_Opening_Mode.predict(2'b10));
    void'(srio1_reg_model_rx.Timestamp_CAR.Timestamp_Slave_Supported.predict(1'b1));
     phase.raise_objection( this );
     nread_req_seq.start( env1.e_virtual_sequencer);
    #2000ns;
    env1.pl_agent.pl_agent_bfm_trans.send_loop_request = 1;
    env1.pl_agent.pl_agent_rx_trans.send_loop_request = 1;
    void'(srio2_reg_model_rx.Port_0_Timestamp_Synchronization_Command_CSR.Command.predict(3'b110));

#250ns;
    env1.pl_agent.pl_agent_bfm_trans.send_loop_request = 0;
    env1.pl_agent.pl_agent_bfm_trans.send_timestamp = 1;
    env1.pl_agent.pl_agent_rx_trans.send_timestamp = 1;
    void'(srio2_reg_model_rx.Port_0_Timestamp_Synchronization_Command_CSR.Send_Timestamp.predict(1'b1));
#7500ns;
    env1.pl_agent.pl_agent_bfm_trans.send_timestamp = 0;
#7500ns;
//    env1.pl_agent.pl_agent_bfm_trans.send_timestamp = 1;
   env1.pl_agent.pl_agent_bfm_trans.send_zero_timestamp = 1;
    env1.pl_agent.pl_agent_rx_trans.send_timestamp = 1;
    void'(srio2_reg_model_rx.Port_0_Timestamp_Synchronization_Command_CSR.Send_Timestamp.predict(1'b1));
#17500ns;
    env1.pl_agent.pl_agent_bfm_trans.send_loop_request = 1;
    env1.pl_agent.pl_agent_rx_trans.send_loop_request = 1;
    void'(srio2_reg_model_rx.Port_0_Timestamp_Synchronization_Command_CSR.Command.predict(3'b110));
#17500ns;
    env1.pl_agent.pl_agent_bfm_trans.send_loop_request = 0;
    env1.pl_agent.pl_config.timestamp_auto_update_en = 1;
    void'(srio2_reg_model_rx.Port_0_Timestamp_Generator_Synchronization_CSR.Auto_Update_Link_Partner_Timestamp_Generators.predict(1'b1));
#17500ns;
    phase.drop_objection(this);
    
  endtask

  
endclass

