


////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_fam_no_req_no_xon_no_ds_release_1_test.sv
// Project :  srio vip
// Purpose :  LFC Test 
// Author  :  Mobiveil
//
// 1.flow arbiration support and configure DS MTU in CSR register.

// 2.No Request multi PDU for sequence number 1
// 3.NO LFC XON for sequence number 1.
// 4.NO DS multi PDU.
// 5. Release 1.
////////////////////////////////////////////////////////////////////////////////

class srio_ll_fam_no_req_no_xon_no_ds_release_1_test extends srio_base_test;

  `uvm_component_utils(srio_ll_fam_no_req_no_xon_no_ds_release_1_test)

   rand bit [1:0] pri;
   rand bit crf_2;
   rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;
 
  srio_ll_lfc_release_1_seq   ll_lfc_release_1_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;

  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

function void connect_phase( uvm_phase phase );
 super.connect_phase( phase );  
 void'(srio1_reg_model_tx.Processing_Element_Features_CAR.Flow_Arbitration_Support.predict(1'b1));
 void'(srio1_reg_model_rx.Processing_Element_Features_CAR.Flow_Arbitration_Support.predict(1'b1));
 void'(srio2_reg_model_tx.Processing_Element_Features_CAR.Flow_Arbitration_Support.predict(1'b1));
 void'(srio2_reg_model_rx.Processing_Element_Features_CAR.Flow_Arbitration_Support.predict(1'b1));
endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);


    env1.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env1.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env1.tl_agent.tl_config.usr_sourceid = 32'h2;
    env1.tl_agent.tl_config.usr_destinationid = 32'h1;
    env2.tl_agent.tl_config.usr_sourceid_en = TRUE;
    env2.tl_agent.tl_config.usr_destinationid_en = TRUE;
    env2.tl_agent.tl_config.usr_sourceid = 32'h1;
    env2.tl_agent.tl_config.usr_destinationid = 32'h2;
    ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");

     
ll_lfc_release_1_seq = srio_ll_lfc_release_1_seq::type_id::create("ll_lfc_release_1_seq");

    phase.raise_objection( this );
   mtusize_2 = $urandom_range(32'd64,32'd8);
    pdu_length_2 = $urandom_range(32'h 0000_00FF,32'h1);
// Priority and crf randomise
     
    pri = $urandom_range(32'h0,32'h2);
    crf_2 = 1'b0;
//CONFIGURING MTUSIZE 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
    //CONFIGURING MTUSIZE 
      ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
      ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
 
// Release
     ll_lfc_release_1_seq.flowid = {pri,crf_2};

     ll_lfc_release_1_seq.start( env1.e_virtual_sequencer);    

        #5000ns;	

       phase.drop_objection(this);
    
  endtask

  
endclass



