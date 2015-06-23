////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_nxmode_sl_test.sv
// Project :  srio vip
// Purpose :  INIT State Machine- nxmode to silent 
// Author  :  Mobiveil
// 
//Test file for nxmode to silent state transition
// NREAD 
// Supported by all mode (Gen1,Gen2,Gen3)
////////////////////////////////////////////////////////////////////////////////

class srio_pl_nxmode_sl_test extends srio_base_test;
  `uvm_component_utils(srio_pl_nxmode_sl_test)
  srio_pl_nxmode_sl_sm_seq pl_nxmode_sl_sm_seq;
  srio_ll_nread_req_seq nread_req_seq;
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction
  task run_phase( uvm_phase phase );
    super.run_phase(phase);
    pl_nxmode_sl_sm_seq = srio_pl_nxmode_sl_sm_seq::type_id::create("pl_nxmode_sl_sm_seq"); 
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");
    phase.raise_objection( this );
      if(!(env_config1.srio_mode == SRIO_GEN30)) begin //{
         wait(env_config1.pl_tx_mon_init_sm_state == NX_MODE);
         wait(env_config1.pl_rx_mon_init_sm_state == NX_MODE);
         pl_nxmode_sl_sm_seq.start( env1.e_virtual_sequencer);
         wait(env_config1.pl_tx_mon_init_sm_state == SILENT);
         wait(env_config1.pl_rx_mon_init_sm_state == SILENT);
         nread_req_seq.start( env1.e_virtual_sequencer);
       end //}
      else begin //{
        wait(env_config1.pl_tx_mon_init_sm_state == NX_MODE);
        wait(env_config1.pl_rx_mon_init_sm_state == NX_MODE);
  
        pl_nxmode_sl_sm_seq.start(env1.e_virtual_sequencer);
 
        wait(env_config1.pl_tx_mon_init_sm_state == SILENT);
        wait(env_config1.pl_rx_mon_init_sm_state == SILENT);
        nread_req_seq.start( env1.e_virtual_sequencer);
      end //}
    #20000ns;
  phase.drop_objection(this);
endtask
endclass


