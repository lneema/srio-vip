

////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_nxmode_enabled_2x_disabled_portwidth_override_test.sv
// Project :  srio vip
// Purpose :  nxmode enabled 2x disabled portwidth overide
// Author  :  Mobiveil
//
// Test to reinitialize the state changes..
//
// 1.nxmode enabled 2x disabled portwidth overide
// 2.After state changes ,wait for link initialization and use nread transcation .
// 3.NREAD transcation
//Supported by only Gen2 mode
////////////////////////////////////////////////////////////////////////////////


class srio_pl_nxmode_enabled_2x_disabled_portwidth_override_test extends srio_base_test;

  `uvm_component_utils(srio_pl_nxmode_enabled_2x_disabled_portwidth_override_test)

  srio_ll_nread_req_seq nread_req_seq;
 
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    
     env1.pl_agent.pl_config.nx_mode_support = 1;
     env1.pl_agent.pl_config.x2_mode_support = 0;
     env1.pl_agent.pl_agent_rx_trans.force_1x_mode = 0;
     env1.pl_agent.pl_agent_bfm_trans.force_1x_mode = 0; // Force 1x mode support
     env1.pl_agent.pl_agent_rx_trans.force_laneR = 0;
     env1.pl_agent.pl_agent_bfm_trans.force_laneR = 0; // Force 1x mode support

 
      if ((env_config1.srio_mode == SRIO_GEN21)) begin //{
      void'(srio2_reg_model_rx.Port_0_Control_CSR.Port_Width_Support.predict(2'b01));
      void'(srio2_reg_model_rx.Port_0_Control_CSR.Port_Width_Override.predict(3'b011));
      void'(srio2_reg_model_rx.Port_0_Control_CSR.Extended_Port_Width_Override.predict(2'b11));
      end //}
      else  begin //{
      void'(srio2_reg_model_rx.Port_0_Control_CSR.Port_Width_Support.predict(2'b10));
      void'(srio2_reg_model_rx.Port_0_Control_CSR.Port_Width_Override.predict(3'b011));
      void'(srio2_reg_model_rx.Port_0_Control_CSR.Extended_Port_Width_Override.predict(2'b11));
      end //}
     nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
       
     phase.raise_objection( this );

     nread_req_seq.start( env1.e_virtual_sequencer);  ///NREAD 

     #100ns;
     phase.drop_objection(this);

       
     
  endtask

  
endclass


