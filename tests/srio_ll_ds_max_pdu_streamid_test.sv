////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_ds_max_pdu_streamid_test.sv
// Project :  srio vip
// Purpose :  DS with maximum PDU and streamID 
// Author  :  Mobiveil
//
// Test for DS packet with maximum PDU and streamID
////////////////////////////////////////////////////////////////////////////////

class srio_ll_ds_max_pdu_streamid_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_max_pdu_streamid_test)
          
   srio_ll_ds_max_streamid_seq  ll_ds_max_pdu_streamID_seq;
   srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq;
    
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);
        ll_ds_max_pdu_streamID_seq = srio_ll_ds_max_streamid_seq::type_id::create("ll_ds_max_pdu_streamID_seq");
        ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");

        phase.raise_objection( this );

        //CONFIGURING MTUSIZE AND TM MODE 
        ll_maintenance_ds_support_reg_seq.mtusize_1 = 64;
        ll_maintenance_ds_support_reg_seq.tm_mode_1 =  4'b0001;
        ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);

`ifdef SRIO_VIP_B2B
        //CONFIGURING MTUSIZE AND TM MODE
        ll_maintenance_ds_support_reg_seq.mtusize_1 = 64;
        ll_maintenance_ds_support_reg_seq.tm_mode_1 =  4'b0001;
        ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
        //DS PACKET
        ll_ds_max_pdu_streamID_seq.mtusize_1 = 64;
        ll_ds_max_pdu_streamID_seq.pdu_length_1 = 16'hffff;
        ll_ds_max_pdu_streamID_seq.start(env1.e_virtual_sequencer);

       #50000ns;
       phase.drop_objection(this);

  endtask
endclass


