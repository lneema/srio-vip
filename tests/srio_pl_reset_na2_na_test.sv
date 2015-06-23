
////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_reset_na2_na_test .sv
// Project :  srio vip
// Purpose :  LANE ALIGN STATE MACHINE
// Author  :  Mobiveil
//
// 1.NREAD.
// 2. apply reset.after that deassarted reset.
// 3. After state changes wait for not aligned2 and apply reset .
// 4.After link initialized,send nread packets.
// Supported by only  Gen2 mode
//
////////////////////////////////////////////////////////////////////////////////

class srio_pl_reset_na2_na_test extends srio_base_test;

  `uvm_component_utils(srio_pl_reset_na2_na_test)

   srio_ll_nread_req_seq nread_req_seq;
   
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

     task run_phase( uvm_phase phase );
    super.run_phase(phase);
    env1.pl_agent.pl_config.sync_break_threshold = 15;   //To avoid sync break the Icounter value to be max.
`ifdef SRIO_VIP_B2B
    env2.pl_agent.pl_config.sync_break_threshold = 15;
`endif
   
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );

      nread_req_seq.start(env1.e_virtual_sequencer);
      #2000ns;     
`ifdef SRIO_VIP_B2B
     wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED); 
`endif
     wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED);
    
    env1.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
`ifdef SRIO_VIP_B2B
    env2.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
`endif
    #1000ns;
    env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
`ifdef SRIO_VIP_B2B
    env2.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
`endif

`ifdef SRIO_VIP_B2B 
    wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED);
`endif 
    wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED);
`ifdef SRIO_VIP_B2B
    wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED_2); 
`endif
    wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED_2);
    env1.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
`ifdef SRIO_VIP_B2B
    env2.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
`endif
    #1000ns;
    env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
`ifdef SRIO_VIP_B2B
    env2.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
`endif
`ifdef SRIO_VIP_B2B
    wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED); 
`endif
    wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state == NOT_ALIGNED);
`ifdef SRIO_VIP_B2B
    wait(env2.pl_agent.pl_monitor.tx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED);
`endif 
    wait(env1.pl_agent.pl_monitor.rx_monitor.srio_pl_sm_ins.current_nx_align_state == ALIGNED);

      nread_req_seq.start( env1.e_virtual_sequencer);
         #2000ns;
 
    phase.drop_objection(this);
    
  endtask

  
endclass


