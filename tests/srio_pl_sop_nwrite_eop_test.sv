

////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sop_nwrite_eop_test.sv
// Project :  srio vip
// Purpose :  SOP NWRITE EOP 
// Author  :  Mobiveil
//
// ////////////////////////////////////////////////////////////////////////////////


class srio_pl_sop_nwrite_eop_test extends srio_base_test;

  `uvm_component_utils(srio_pl_sop_nwrite_eop_test)
  
  rand bit [0:11] param_value_1;
  srio_pl_sop_nwrite_eop_seq pl_sop_nwrite_eop_seq;
  
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
    //env_config2.pl_config.pkt_acc_gen_kind = PL_DISABLED;

     if(env_config1.srio_mode == SRIO_GEN13) begin //{
       param_value_1 = 6'd31;            
       end //}
       else if((env_config1.srio_mode == SRIO_GEN21) || (env_config1.srio_mode == SRIO_GEN22)) begin //{
       param_value_1 = 6'd63; 
       end //} 
       else  begin //{
       param_value_1 = 12'd4095; 
       end //}

     pl_sop_nwrite_eop_seq = srio_pl_sop_nwrite_eop_seq::type_id::create("pl_sop_nwrite_eop_seq");

     phase.raise_objection( this );
     //sop nwrite eop  
     pl_sop_nwrite_eop_seq.param_value_0 = param_value_1;
     pl_sop_nwrite_eop_seq.start( env1.e_virtual_sequencer);
     
    #2000ns;
    phase.drop_objection(this);
      endtask


endclass



