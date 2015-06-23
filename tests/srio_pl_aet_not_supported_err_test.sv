////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. Apl rights reserved
//
// File    :  srio_pl_aet_not_supported_err_test.sv
// Project :  srio vip
// Purpose :  AET
// Author  :  Mobiveil
//
////Test for random AET case.
//Supported by only Gen2 mode
//works for baud rate lesser than 6.25G
////////////////////////////////////////////////////////////////////////////////

class srio_pl_aet_not_supported_err_test extends srio_base_test;

  `uvm_component_utils(srio_pl_aet_not_supported_err_test)

    srio_ll_nread_req_seq ll_nread_req_seq;
    
  function new(string name, uvm_component parent=null);

    super.new(name, parent);
  endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   //configuring register feild to disable the support
    void'(srio1_reg_model_tx.Port_0_Control_2_CSR.Remote_Transmit_Emphasis_Control_Support.predict(0));
    void'(srio1_reg_model_tx.Port_0_Control_2_CSR.Remote_Transmit_Emphasis_Control_Enable.predict(0));
endfunction


    task run_phase( uvm_phase phase );
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
     #2000ns; 
    phase.drop_objection(this);
    
  endtask


endclass


