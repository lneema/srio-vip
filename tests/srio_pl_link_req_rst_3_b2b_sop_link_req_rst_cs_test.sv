
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_link_req_rst_3_b2b_sop_link_req_rst_cs_test.sv
// Project :  srio vip
// Purpose :  LINK REQUEST
// Author  :  Mobiveil
//
// 1. send 3 link request reset with  stype1 control symbols.
// 2. send stype1 sop
// 3. send link request reset with  stype1 control symbols.
// 4. IO packets
//Supported by only Gen2 mode
////////////////////////////////////////////////////////////////////////////////


class srio_pl_link_req_rst_3_b2b_sop_link_req_rst_cs_test extends srio_base_test;

  `uvm_component_utils(srio_pl_link_req_rst_3_b2b_sop_link_req_rst_cs_test)

  rand bit [0:11] ackid_0 ;
  rand bit [0:11] param_value_1;
  
  srio_pl_link_req_rst_dev_cs_seq pl_link_req_rst_dev_cs_seq;
  srio_pl_ll_io_random_seq  pl_ll_io_random_seq;  
  srio_pl_sop_cs_seq pl_sop_cs_seq;
  srio_pl_delimiter_change_callback pl_delimiter_change_callback;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    pl_delimiter_change_callback = new();
  endfunction
 function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
    pl_delimiter_change_callback.pl_agent_cb = env1.pl_agent;
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_delimiter_change_callback )::add(env1.pl_agent.pl_driver.idle_gen,pl_delimiter_change_callback);
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

       pl_link_req_rst_dev_cs_seq = srio_pl_link_req_rst_dev_cs_seq::type_id::create("pl_link_req_rst_dev_cs_seq");

      pl_ll_io_random_seq = srio_pl_ll_io_random_seq::type_id::create("pl_ll_io_random_seq");
      pl_sop_cs_seq = srio_pl_sop_cs_seq::type_id::create("pl_sop_cs_seq");
     phase.raise_objection( this );
     //link req 
     repeat(3) begin //{
     pl_link_req_rst_dev_cs_seq.param_value_0 = param_value_1;
     
     pl_link_req_rst_dev_cs_seq.start( env1.e_virtual_sequencer);
     end //}
     // IO
     pl_ll_io_random_seq.start( env1.e_virtual_sequencer);

     //SOP   
     //pl_sop_cs_seq.param_value_0 = param_value_1;       
    // pl_sop_cs_seq.start( env1.e_virtual_sequencer);
     // link req
    // pl_link_req_rst_dev_cs_seq.param_value_0 = param_value_1;     
    // pl_link_req_rst_dev_cs_seq.start( env1.e_virtual_sequencer);
     

        
    #5000ns;
    phase.drop_objection(this);
      endtask


endclass



