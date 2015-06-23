////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_gen3_eop_padded_cs_test.sv
// Project :  srio vip
// Purpose :  EOP PADDED
// Author  :  Mobiveil
// 1. send EOP PADDED sequence for GEN3.
// ////////////////////////////////////////////////////////////////////////////////


class srio_pl_gen3_eop_padded_cs_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_eop_padded_cs_test)
  
  rand bit [0:11] param_value_1;
  srio_pl_gen3_eop_padded_seq pl_gen3_eop_padded_seq;
  
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

     pl_gen3_eop_padded_seq = srio_pl_gen3_eop_padded_seq::type_id::create("pl_gen3_eop_padded_seq");

     phase.raise_objection( this );
     //eop nwrite eop  
     pl_gen3_eop_padded_seq.param_value_0 = param_value_1;
     pl_gen3_eop_padded_seq.start( env1.e_virtual_sequencer);
     
    #2000ns;
    phase.drop_objection(this);
      endtask


endclass




