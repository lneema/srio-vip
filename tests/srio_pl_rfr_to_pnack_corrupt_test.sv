////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_rfr_to_pnack_corrupt_test.sv
// Project :  srio vip
// Purpose :  Corruption of CS
// Author  :  Mobiveil
//
//
// Test for corrupting  restart from retry to pnack
// Supported by only  Gen2 mode
////////////////////////////////////////////////////////////////////////////////


class srio_pl_rfr_to_pnack_corrupt_test extends srio_base_test;

  `uvm_component_utils(srio_pl_rfr_to_pnack_corrupt_test)

  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  rand bit [0:11] ackid_1 ;
  rand bit [0:11] param_value_2;

  int rx_pkt_cnt;
  bit flag; 

  srio_ll_nread_req_seq  ll_nread_req_seq;
  srio_pl_pkt_acc_cs_seq pl_pkt_acc_cs_seq,pl_pkt_acc_cs_seq1;
  srio_pl_pkt_rty_cs_seq pl_pkt_rty_cs_seq;     
  srio_pl_transmit_rfr_to_pnack_cs_cb  pl_transmit_rfr_to_pnack_cs_cb; 
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_transmit_rfr_to_pnack_cs_cb = new();
  endfunction


  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_transmit_rfr_to_pnack_cs_cb )::add(env1.pl_agent.pl_driver.idle_gen,pl_transmit_rfr_to_pnack_cs_cb);
   endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
     env_config1.pl_config.pkt_acc_gen_kind = PL_DISABLED;
     env_config2.pl_config.pkt_acc_gen_kind = PL_DISABLED;

    if(env_config1.srio_mode == SRIO_GEN13) begin //{
       param_value_1 = 6'd31;            
       end //}
       else if((env_config1.srio_mode == SRIO_GEN21) || (env_config1.srio_mode == SRIO_GEN22))        begin //{
       param_value_1 = 6'd63; 
       end //} 
       else  begin //{
       param_value_1 = 12'd4095; 
       end //}

    pl_pkt_acc_cs_seq = srio_pl_pkt_acc_cs_seq::type_id::create("pl_pkt_acc_cs_seq");
    pl_pkt_acc_cs_seq1 = srio_pl_pkt_acc_cs_seq::type_id::create("pl_pkt_acc_cs_seq1");
    ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");
    pl_pkt_rty_cs_seq = srio_pl_pkt_rty_cs_seq::type_id::create("pl_pkt_rty_cs_seq");
     phase.raise_objection( this );
        
 /*    fork 
     begin //{
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
     begin //{
     for(int i=0;i<5;i++) 
     begin //{
     wait(env_config1.packet_rx_started);
     ackid_1 = i; 
     pl_pkt_acc_cs_seq1.ackid_1 = ackid_1;
     pl_pkt_acc_cs_seq1.param_value_0 = param_value_2;
     pl_pkt_acc_cs_seq1.start( env1.e_virtual_sequencer);
     end //}
     end //}
     end //}
 
     begin //{
     for(int i=0;i<2;i++) 
     begin //{
     wait(env_config2.packet_rx_started);
     ackid_0 = i; 
     pl_pkt_acc_cs_seq.ackid_1 = ackid_0;
     pl_pkt_acc_cs_seq.param_value_0 = param_value_1;
     pl_pkt_acc_cs_seq.start( env2.e_virtual_sequencer);
     end //}
     begin //{
     wait(env_config2.packet_rx_started);
     pl_pkt_rty_cs_seq.ackid_1 = 2;
     pl_pkt_rty_cs_seq.param_value_0 = param_value_1;
     pl_pkt_rty_cs_seq.start( env2.e_virtual_sequencer);
     end //}
     end //}
     join
 */
     ll_nread_req_seq.start( env1.e_virtual_sequencer);  

     @(env_config2.packet_rx_started);
     ackid_0 = 0; 
     pl_pkt_acc_cs_seq.ackid_1 = ackid_0;
     pl_pkt_acc_cs_seq.param_value_0 = param_value_1;
     pl_pkt_acc_cs_seq.start( env2.e_virtual_sequencer);

     @(env_config1.packet_rx_started);
     ackid_1 = 0; 
     pl_pkt_acc_cs_seq1.ackid_1 = ackid_1;
     pl_pkt_acc_cs_seq1.param_value_0 = param_value_2;
     pl_pkt_acc_cs_seq1.start( env1.e_virtual_sequencer);

     ll_nread_req_seq.start( env1.e_virtual_sequencer); 
 
     @(env_config2.packet_rx_started);
     ackid_0 = 1; 
     pl_pkt_acc_cs_seq.ackid_1 = ackid_0;
     pl_pkt_acc_cs_seq.param_value_0 = param_value_1;
     pl_pkt_acc_cs_seq.start( env2.e_virtual_sequencer);

     @(env_config1.packet_rx_started);
     ackid_1 = 1; 
     pl_pkt_acc_cs_seq1.ackid_1 = ackid_1;
     pl_pkt_acc_cs_seq1.param_value_0 = param_value_2;
     pl_pkt_acc_cs_seq1.start( env1.e_virtual_sequencer);

     ll_nread_req_seq.start( env1.e_virtual_sequencer); 

     @(env_config2.packet_rx_started);
     pl_pkt_rty_cs_seq.ackid_1 = 2;
     pl_pkt_rty_cs_seq.param_value_0 = param_value_1;
     pl_pkt_rty_cs_seq.start( env2.e_virtual_sequencer);

     @(env_config1.packet_rx_started);
     ackid_1 = 2; 
     pl_pkt_acc_cs_seq1.ackid_1 = ackid_1;
     pl_pkt_acc_cs_seq1.param_value_0 = param_value_2;
     pl_pkt_acc_cs_seq1.start( env1.e_virtual_sequencer);

    #200000ns;
    phase.drop_objection(this);
      endtask


endclass

