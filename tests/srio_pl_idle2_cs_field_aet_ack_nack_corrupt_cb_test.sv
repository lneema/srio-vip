////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    : srio_pl_idle2_cs_field_aet_ack_nack_corrupt_cb_test.sv
// Project :  srio vip
// Purpose :  AET
// Author  :  Mobiveil
//
////Test for random AET case.
//Supported by only Gen2 mode
//with callback to corrupt Idle2 sequence with unexpected ack or nack
////////////////////////////////////////////////////////////////////////////////
class srio_pl_idle2_cs_field_aet_ack_nack_corrupt_cb_test extends srio_base_test;

  `uvm_component_utils(srio_pl_idle2_cs_field_aet_ack_nack_corrupt_cb_test)

    srio_ll_nread_req_seq ll_nread_req_seq;
    
    srio_pl_idle2_cs_field_aet_ack_nack_corrupt_callback pl_idle2_cs_field_corrupt_callback;

    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
    pl_idle2_cs_field_corrupt_callback = new();
  endfunction

  function void connect_phase( uvm_phase phase );
    super.connect_phase(phase); 
    uvm_callbacks #(srio_pl_idle_gen,srio_pl_idle2_cs_field_aet_ack_nack_corrupt_callback )::add(env1.pl_agent.pl_driver.idle_gen,pl_idle2_cs_field_corrupt_callback);
   endfunction    task run_phase( uvm_phase phase );
    super.run_phase(phase);

	env1.pl_agent.pl_config.aet_en = 1'b1;
	env1.pl_agent.pl_config.aet_cmd_kind = CMD_ENABLED;
	env1.pl_agent.pl_config.aet_cmd_type = CMD_RANDOM;

	if(env1.pl_agent.pl_config.aet_cmd_type == TAPPLUS)
	begin
	
	 env1.pl_agent.pl_config.aet_tplus_kind = TP_RANDOM;
	end
	else
	begin
	
	env1.pl_agent.pl_config.aet_tminus_kind = TM_RANDOM;
	end
         
    ll_nread_req_seq = srio_ll_nread_req_seq::type_id::create("ll_nread_req_seq");

     phase.raise_objection( this );
     ll_nread_req_seq.start( env1.e_virtual_sequencer);
     
    phase.drop_objection(this);
    
  endtask


endclass


