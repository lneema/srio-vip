////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_delayed_pkt_acc_cs_test.sv
// Project :  srio vip
// Purpose :  Packet accepted
// Author  :  Mobiveil
//
// 
//Test for delayed Packet accpeted control symbols.
//Supported by all mode(Gen1,Gen2,Gen3)
////////////////////////////////////////////////////////////////////////////////


class srio_pl_delayed_pkt_acc_cs_test extends srio_base_test;

  `uvm_component_utils(srio_pl_delayed_pkt_acc_cs_test)
  bit [15:0] ack_status,cnt;
  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  srio_pl_pkt_acc_status_cs_seq pl_pkt_acc_cs_seq;
  srio_pl_ll_io_random_seq  pl_ll_io_random_seq; 
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
    
     pl_pkt_acc_cs_seq = srio_pl_pkt_acc_status_cs_seq::type_id::create("pl_pkt_acc_cs_seq");
     pl_ll_io_random_seq = srio_pl_ll_io_random_seq::type_id::create("pl_ll_io_random_seq");
     phase.raise_objection( this );
          
     
     //disable packet accepted
     env2.pl_agent.pl_config.pkt_acc_gen_kind        = PL_DISABLED;
 
     repeat(20)
     pl_ll_io_random_seq.start( env1.e_virtual_sequencer);
    #100ns;
     for(int i=0;i < 20;i=i+1)
      begin //{
     ackid_0 = env_config2.current_ack_id;  
     pl_pkt_acc_cs_seq.stype0_2 = 0;
     pl_pkt_acc_cs_seq.ackid_1 = i;//ackid_0;
     pl_pkt_acc_cs_seq.param_value_0 = param_value_1;
     pl_pkt_acc_cs_seq.start( env2.e_virtual_sequencer);
     ack_status = i+1;
    // ackid_0 = env_config2.current_ack_id;  
     pl_pkt_acc_cs_seq.stype0_2 = 4;
     pl_pkt_acc_cs_seq.ackid_1 = ack_status;//ackid_0;
     pl_pkt_acc_cs_seq.param_value_0 = param_value_1;
     pl_pkt_acc_cs_seq.start( env2.e_virtual_sequencer);

     end //}
     #20000ns; 
    phase.drop_objection(this);
      endtask


endclass


