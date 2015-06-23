////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_pkt_flow_control_mode_transmit_test .sv
// Project :  srio vip
// Purpose :  Packet not accepted
// Author  :  Mobiveil
//
// 
//Test for flow control mode enabled with transmit mode selection..
//Supported by only Gen2 mode
////////////////////////////////////////////////////////////////////////////////


class srio_pl_pkt_flow_control_mode_transmit_test extends srio_base_test;

  `uvm_component_utils(srio_pl_pkt_flow_control_mode_transmit_test)

  srio_ll_nread_req_seq ll_nread_req_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

    env1.pl_agent.pl_config.flow_control_mode = TRANSMIT;
    env2.pl_agent.pl_config.flow_control_mode = TRANSMIT;

    ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");
   
     phase.raise_objection( this );
          ll_nread_req_seq.start( env1.e_virtual_sequencer);
          #500ns;
          ll_nread_req_seq.start( env2.e_virtual_sequencer);
     #2000ns; 
    phase.drop_objection(this);
      endtask

  
endclass


