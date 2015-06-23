////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sop_stomp_cs_test.sv
// Project :  srio vip
// Purpose :  STOMP
// Author  :  Mobiveil
//
// 1. send IO packtes
// 2. send stype1 sop
// 3. send stomp stype1 control symbols .
// 4. For Gen3 also we can use.
////////////////////////////////////////////////////////////////////////////////


class srio_pl_sop_stomp_cs_test extends srio_base_test;

  `uvm_component_utils(srio_pl_sop_stomp_cs_test)

  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  rand bit set_delim,mode;

  srio_pl_stomp_cs_seq pl_stomp_cs_seq;
  srio_pl_ll_io_random_seq  pl_ll_io_random_seq;  
  srio_pl_sop_cs_seq pl_sop_cs_seq;
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


    pl_stomp_cs_seq = srio_pl_stomp_cs_seq::type_id::create("pl_stomp_cs_seq");
    pl_ll_io_random_seq = srio_pl_ll_io_random_seq::type_id::create("pl_ll_io_random_seq");
    pl_sop_cs_seq = srio_pl_sop_cs_seq::type_id::create("pl_sop_cs_seq");
     phase.raise_objection( this );
    //SOP
     pl_sop_cs_seq.param_value_0 = param_value_1;
       
     pl_sop_cs_seq.start( env1.e_virtual_sequencer);

     //Stomp
     pl_stomp_cs_seq.param_value_0 = param_value_1;
     
     pl_stomp_cs_seq.start( env1.e_virtual_sequencer);
     // IO
     pl_ll_io_random_seq.start( env1.e_virtual_sequencer);

        #5000ns;
    phase.drop_objection(this);
      endtask


endclass


