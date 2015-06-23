////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_ll_ds_cov_test.sv
// Project :  srio vip
// Purpose :  Data streaming test
// Author  :  Mobiveil
//
// 1.Configuring DS MTU.
// 2.Data streaming with Multi segment packet
//
////////////////////////////////////////////////////////////////////////////////
class srio_ll_ds_cov_test extends srio_base_test;

  `uvm_component_utils(srio_ll_ds_cov_test)

  rand bit [7:0] mtusize_2;
  rand bit [15:0] pdu_length_2;

  srio_ll_ds_mseg_req_seq ds_mseg_req_seq;
  srio_ll_maintenance_ds_support_reg_seq ll_maintenance_ds_support_reg_seq; 
  
  function new(string name, uvm_component parent=null);
  super.new(name, parent);
  endfunction

    task run_phase( uvm_phase phase );
    super.run_phase(phase);

          //MTU range1 and PDU min value
          ds_mseg_req_seq = srio_ll_ds_mseg_req_seq::type_id::create("ds_mseg_req_seq");
          ll_maintenance_ds_support_reg_seq = srio_ll_maintenance_ds_support_reg_seq::type_id::create("ll_maintenance_ds_support_reg_seq");
          phase.raise_objection( this );

          mtusize_2 = $urandom_range(24,8);
          pdu_length_2 = 0;

          // Configuring MTU
          ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
          ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
          //Configuring MTU 
          ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
          ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);

          #50000ns;

       //MTU range1 and PDU small value
          pdu_length_2 = $urandom_range(511,1);

          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;
       //MTU range1 and PDU medium value
          pdu_length_2 = $urandom_range(4095,512);

          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;
       //MTU range1 and PDU large value
          pdu_length_2 = $urandom_range(65535,4096);

          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;

          //MTU range2 and PDU min value
          mtusize_2 = $urandom_range(41,25);
          pdu_length_2 = 0;

          // Configuring MTU
          ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
          ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
          //Configuring MTU 
          ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
          ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;
         #100ns;
       //MTU range2 and PDU small value
          pdu_length_2 = $urandom_range(511,1);

          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;
       //MTU range2 and PDU medium value
          pdu_length_2 = $urandom_range(4095,512);

          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;
       //MTU range2 and PDU large value
          pdu_length_2 = $urandom_range(65535,4096);

          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;
          //MTU range3 and PDU min value
          mtusize_2 = $urandom_range(57,42);
          pdu_length_2 = 0;

          // Configuring MTU
          ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
          ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
          //Configuring MTU 
          ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
          ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;
         #100ns;
       //MTU range3 and PDU small value
          pdu_length_2 = $urandom_range(511,1);

          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;
       //MTU range3 and PDU medium value
          pdu_length_2 = $urandom_range(4095,512);

          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;
       //MTU range3 and PDU large value
          pdu_length_2 = $urandom_range(65535,4096);

          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;



         //MTU range1 and PDU min value
          mtusize_2 = $urandom_range(58,64);
          pdu_length_2 = 1;

          // Configuring MTU
          ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
          ll_maintenance_ds_support_reg_seq.start( env1.e_virtual_sequencer);
`ifdef SRIO_VIP_B2B
          //Configuring MTU 
          ll_maintenance_ds_support_reg_seq.mtusize_1 = mtusize_2;
          ll_maintenance_ds_support_reg_seq.start( env2.e_virtual_sequencer);
`endif
          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;


        pdu_length_2 = 2;
#100ns;
          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;

       pdu_length_2 = 3;
#100ns;
          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;

       pdu_length_2 = 4;
#100ns;
          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;

      pdu_length_2 = 4099;
#100ns;
          //DS Packet 
          ds_mseg_req_seq.mtusize_1 = mtusize_2;
          ds_mseg_req_seq.pdu_length_1 = pdu_length_2;
          ds_mseg_req_seq.start( env1.e_virtual_sequencer);
          #50000ns;

          phase.drop_objection(this);
          #100ns;

  endtask
endclass


