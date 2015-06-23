////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_sop_with_eop_cs_test.sv
// Project :  srio vip
// Purpose :  Packet not accepted
// Author  :  Mobiveil
//
// 
//Test file for Start of Packet stype1 control symbols and eop for GEN3 also. 
// 2. For Gen3 also we can use.
///////////////////////////////////////////////////////////////////////

class srio_pl_sop_with_eop_cs_test extends srio_base_test;

  `uvm_component_utils(srio_pl_sop_with_eop_cs_test)

  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  
  rand bit mode;
  srio_pl_sop_cs_seq pl_sop_cs_seq;
  srio_pl_ll_io_random_seq  pl_ll_io_random_seq;
  srio_pl_pkt_acc_cs_seq pl_pkt_acc_cs_seq;
  srio_pl_eop_cs_seq pl_eop_cs_seq; 
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
    pl_pkt_acc_cs_seq = srio_pl_pkt_acc_cs_seq::type_id::create("pl_pkt_acc_cs_seq");
    pl_ll_io_random_seq = srio_pl_ll_io_random_seq::type_id::create("pl_ll_io_random_seq");
    pl_sop_cs_seq = srio_pl_sop_cs_seq::type_id::create("pl_sop_cs_seq");
    pl_eop_cs_seq = srio_pl_eop_cs_seq::type_id::create("pl_eop_cs_seq");

     phase.raise_objection( this );
         // IO
     pl_sop_cs_seq.param_value_0 = param_value_1;
       
     pl_sop_cs_seq.start( env1.e_virtual_sequencer);
     //EOP
    
     pl_eop_cs_seq.param_value_0 = param_value_1;
     
     pl_eop_cs_seq.start( env1.e_virtual_sequencer);
    // IO
     pl_ll_io_random_seq.start( env1.e_virtual_sequencer); 
    
     #2000ns;  
    phase.drop_objection(this);
   
      endtask


endclass

