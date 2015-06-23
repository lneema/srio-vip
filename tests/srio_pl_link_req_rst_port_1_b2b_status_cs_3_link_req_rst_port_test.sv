



////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_link_req_rst_port_1_b2b_status_cs_3_link_req_rst_port_test.sv
// Project :  srio vip
// Purpose :  LINK REQUEST
// Author  :  Mobiveil
//
// 1. send 1 link request reset with  stype1 control symbols.
// 2. Non Status Control symbols
// 3. 3 Link request reset  
// 4. IO packets
////////////////////////////////////////////////////////////////////////////////


class srio_pl_link_req_rst_port_1_b2b_status_cs_3_link_req_rst_port_test extends srio_base_test;

  `uvm_component_utils(srio_pl_link_req_rst_port_1_b2b_status_cs_3_link_req_rst_port_test)

   rand bit [0:11] ackid_0 ;
   rand bit [0:11] param_value_1;
   
   srio_pl_link_req_rst_port_cs_seq pl_link_req_rst_port_cs_seq;
   srio_pl_ll_io_random_seq  pl_ll_io_random_seq;  
   srio_pl_pkt_acc_cs_seq pl_pkt_acc_cs_seq;
   srio_pl_delimiter_changes_status_non_status_cs_callback pl_delimiter_changes_status_non_status_cs_callback
;
   function new(string name, uvm_component parent=null);
   super.new(name, parent);
   pl_delimiter_changes_status_non_status_cs_callback = new();
   endfunction
   function void connect_phase( uvm_phase phase );
    super.connect_phase(phase);
     pl_delimiter_changes_status_non_status_cs_callback.pl_agent_cb = env1.pl_agent;
     uvm_callbacks #(srio_pl_idle_gen,srio_pl_delimiter_changes_status_non_status_cs_callback )::add(env1.pl_agent.pl_driver.idle_gen,pl_delimiter_changes_status_non_status_cs_callback);
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
      pl_pkt_acc_cs_seq = srio_pl_pkt_acc_cs_seq::type_id::create("pl_pkt_acc_cs_seq");
     phase.raise_objection( this );
     //link req 
     repeat(1) begin //{
     pl_link_req_rst_port_cs_seq.param_value_0 = param_value_1;     
     pl_link_req_rst_port_cs_seq.start( env1.e_virtual_sequencer);
     end //}
     //Status 
     pl_pkt_acc_cs_seq.ackid_1 = 6'b0;
     pl_pkt_acc_cs_seq.param_value_0 = param_value_1;
     pl_pkt_acc_cs_seq.start( env1.e_virtual_sequencer);
    // Link req reset
     repeat(3) begin //{
     pl_link_req_rst_port_cs_seq.param_value_0 = param_value_1;     
     pl_link_req_rst_port_cs_seq.start( env1.e_virtual_sequencer);
     end //}
     // IO
     pl_ll_io_random_seq.start( env1.e_virtual_sequencer);

  
    #5000ns;
    phase.drop_objection(this);
      endtask


endclass



