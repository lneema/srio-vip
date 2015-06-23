////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_txrx_model_test.sv
// Project :  srio vip
// Purpose :  TX RX Model Test 
// Author  :  Mobiveil
//
// Test for TXRX model
//
////////////////////////////////////////////////////////////////////////////////

class srio_txrx_model_test extends srio_base_test;
  `uvm_component_utils(srio_txrx_model_test)

   srio_txrx_seq  txrx_seq1;
   srio_txrx_seq  txrx_seq2;
   srio_pl_nwrite_swrite_req_seq pl_nwrite_swrite_req_seq;
   srio_pl_sop_nwrite_eop_seq pl_sop_nwrite_eop_seq;

   rand bit [0:11] ackid_0 ;
   rand bit [0:11] param_value_1;
   srio_pl_pkt_acc_cs_seq pl_pkt_acc_cs_seq;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

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

     txrx_seq1 = srio_txrx_seq::type_id::create("txrx_seq1");
     txrx_seq2 = srio_txrx_seq::type_id::create("txrx_seq2");
     pl_nwrite_swrite_req_seq = srio_pl_nwrite_swrite_req_seq::type_id::create("pl_nwrite_swrite_req_seq");
     pl_sop_nwrite_eop_seq= srio_pl_sop_nwrite_eop_seq::type_id::create("pl_sop_nwrite_eop_seq");
     pl_pkt_acc_cs_seq = srio_pl_pkt_acc_cs_seq::type_id::create("pl_pkt_acc_cs_seq");
     phase.raise_objection( this );
     wait (env1.pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.port_initialized == 1);
     wait (env1.pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.port_initialized == 1);
    fork
      txrx_seq1.start( env1.e_virtual_sequencer);
      txrx_seq2.start( env2.e_virtual_sequencer);
//      pl_nwrite_swrite_req_seq.start( env1.e_virtual_sequencer);
//      pl_sop_nwrite_eop_seq.start( env1.e_virtual_sequencer);
      begin
#10000;
     pl_sop_nwrite_eop_seq.param_value_0 = param_value_1;
     //pl_sop_nwrite_eop_seq.set_delim_0 = 1 ;

      pl_sop_nwrite_eop_seq.start( env1.e_virtual_sequencer);
         @(env_config2.packet_rx_started);
         ackid_0 = env_config2.current_ack_id;
         pl_pkt_acc_cs_seq.ackid_1 = ackid_0;
         pl_pkt_acc_cs_seq.param_value_0 = param_value_1;
         pl_pkt_acc_cs_seq.start( env2.e_virtual_sequencer);
      end 
    join
    #1000ns;
     phase.drop_objection(this);
  endtask

  
endclass
