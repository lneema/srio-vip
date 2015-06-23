


////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_link_req_rst_port_4_b2b_cs_test.sv
// Project :  srio vip
// Purpose :  LINK REQUEST
// Author  :  Mobiveil
//
// 1. send 4 link request reset with  stype1 control symbols.
// 
// 2. IO packets
////////////////////////////////////////////////////////////////////////////////


class srio_pl_link_req_rst_port_4_b2b_cs_test extends srio_base_test;

  `uvm_component_utils(srio_pl_link_req_rst_port_4_b2b_cs_test)

  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  
  srio_pl_link_req_rst_port_cs_seq pl_link_req_rst_port_cs_seq;
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

       pl_link_req_rst_port_cs_seq = srio_pl_link_req_rst_port_cs_seq::type_id::create("pl_link_req_rst_port_cs_seq");

      pl_ll_io_random_seq = srio_pl_ll_io_random_seq::type_id::create("pl_ll_io_random_seq");
      pl_sop_cs_seq = srio_pl_sop_cs_seq::type_id::create("pl_sop_cs_seq");
     phase.raise_objection( this );
     //link req 
     repeat(4) begin //{
     pl_link_req_rst_port_cs_seq.param_value_0 = param_value_1;
     
     pl_link_req_rst_port_cs_seq.start( env1.e_virtual_sequencer);
     end //}
     // IO
     pl_ll_io_random_seq.start( env1.e_virtual_sequencer);

  
    #5000ns;
    phase.drop_objection(this);
      endtask


endclass



