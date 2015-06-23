

////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_env1_sop_restart_rty_env2_disabled_test.sv
// Project :  srio vip
// Purpose :  LINK REQUEST
// Author  :  Mobiveil
//
// 1. send stype1 sop
// 2. send restart from retry.
// 3. Send IO
////////////////////////////////////////////////////////////////////////////////
class srio_pl_env1_sop_restart_rty_env2_disabled_test extends srio_base_test;

  `uvm_component_utils(srio_pl_env1_sop_restart_rty_env2_disabled_test)
  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  rand bit set_delim,mode;

  srio_pl_restart_rty_cs_seq pl_restart_rty_cs_seq;
  srio_pl_ll_io_random_seq  pl_ll_io_random_seq;  
  srio_pl_sop_cs_seq pl_sop_cs_seq;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
`ifdef SRIO_VIP_B2B
    env_config2.pl_config.pkt_acc_gen_kind = PL_DISABLED;
`endif
     if(env_config1.srio_mode == SRIO_GEN13) begin //{
       param_value_1 = 6'd31;            
       end //}
       else if((env_config1.srio_mode == SRIO_GEN21) || (env_config1.srio_mode == SRIO_GEN22)) begin //{
       param_value_1 = 6'd63; 
       end //} 
       else  begin //{
       param_value_1 = 12'd4095; 
       end //}

       pl_restart_rty_cs_seq = srio_pl_restart_rty_cs_seq::type_id::create("pl_restart_rty_cs_seq");

      pl_ll_io_random_seq = srio_pl_ll_io_random_seq::type_id::create("pl_ll_io_random_seq");
      pl_sop_cs_seq = srio_pl_sop_cs_seq::type_id::create("pl_sop_cs_seq");
     phase.raise_objection( this );

     //SOP 
     pl_sop_cs_seq.param_value_0 = param_value_1;
       
     pl_sop_cs_seq.start( env1.e_virtual_sequencer);

     //link req 
     pl_restart_rty_cs_seq.param_value_0 = param_value_1;
     
     pl_restart_rty_cs_seq.start( env1.e_virtual_sequencer);
    
    
     // IO
     pl_ll_io_random_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
    // Enabling env2 side
    env_config2.pl_config.pkt_acc_gen_kind = PL_IMMEDIATE;
`endif
     
    #50000ns;
    phase.drop_objection(this);
      endtask


endclass


