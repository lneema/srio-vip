////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_pa_cs_seq_ackid_test.sv
// Project :  srio vip
// Purpose :  Packet Retry control test
// Author  :  Mobiveil
//
//
// Test for Packet Accepted CS sequence.
// Supported by only  Gen2 mode
////////////////////////////////////////////////////////////////////////////////


class srio_pl_pa_cs_seq_ackid_test extends srio_base_test;

  `uvm_component_utils(srio_pl_pa_cs_seq_ackid_test)

  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  int rx_pkt_cnt;
  bit flag; 

  srio_ll_nwrite_req_seq  ll_nwrite_req_seq;
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

    pl_pkt_acc_cs_seq = srio_pl_pkt_acc_cs_seq::type_id::create("pl_pkt_acc_cs_seq");
    ll_nwrite_req_seq = srio_ll_nwrite_req_seq::type_id::create("ll_nwrite_req_seq");
     phase.raise_objection( this );
        
     ll_nwrite_req_seq.start( env1.e_virtual_sequencer);
     begin
     #2000ns;
     for(int i=0;i<10;i++) 
     begin
     ackid_0 = i; 
     pl_pkt_acc_cs_seq.ackid_1 = ackid_0;
     pl_pkt_acc_cs_seq.param_value_0 = param_value_1;
     pl_pkt_acc_cs_seq.start( env2.e_virtual_sequencer);
     end   
    end //}
   
    #20000ns;
    phase.drop_objection(this);
      endtask


endclass

