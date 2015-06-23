////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_env1_sop_link_req_env2_disabled_test.sv
// Project :  srio vip
// Purpose :  LINK REQUEST
// Author  :  Mobiveil
//
// 1. send stype1 sop
// 2. send link request port status with r stype1 control symbols.
// 3.Send IO
////////////////////////////////////////////////////////////////////////////////


class srio_pl_env1_sop_link_req_env2_disabled_test extends srio_base_test;

  `uvm_component_utils(srio_pl_env1_sop_link_req_env2_disabled_test)

  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  rand bit set_delim,mode;
  srio_ll_nwrite_wrsize_wdptr_req_seq nwrite_req_seq;  
  srio_pl_pkt_crc_corrupt_callback  pl_pkt_crc_corrupt_callback; 
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
   pl_pkt_crc_corrupt_callback = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_pkt_crc_corrupt_callback )::add(env1.pl_agent.pl_driver.idle_gen,pl_pkt_crc_corrupt_callback);
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


    nwrite_req_seq = srio_ll_nwrite_wrsize_wdptr_req_seq::type_id::create("nwrite_req_seq");
     phase.raise_objection( this );

       nwrite_req_seq.start( env1.e_virtual_sequencer);

     
    #50000ns;
    phase.drop_objection(this);
      endtask


endclass


