

////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    : srio_pl_gen3_reset_ns2_ns_test .sv
// Project :  srio vip
// Purpose :  LANE ALIGN STATE MACHINE
// Author  :  Mobiveil
//
// // 1.wait for  NO_SYNC_2  .
// 2. apply reset.after that deassarted reset.
// 3. After state changes wait for NO_SYNC_2.
// 4.After link initialized,send nread packets.

////////////////////////////////////////////////////////////////////////////////

class srio_pl_gen3_reset_ns2_ns_test extends srio_base_test;

  `uvm_component_utils(srio_pl_gen3_reset_ns2_ns_test)
   rand int num;
   srio_ll_nread_req_seq nread_req_seq;
   
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
     endfunction
  
     task run_phase( uvm_phase phase );
    super.run_phase(phase);
      
    nread_req_seq = srio_ll_nread_req_seq::type_id::create("nread_req_seq");

     phase.raise_objection( this );
       if(env_config1.num_of_lanes == 1) begin //{ 
       num = 0;
       end //}
       else if(env_config1.num_of_lanes == 2) begin //{ 
       num = 1;
       end //}
       else if(env_config1.num_of_lanes == 4) begin //{ 
       num = 3;
       end //}
       else if(env_config1.num_of_lanes == 8) begin //{ 
       num = $urandom_range(32'd7,32'd4);
       end //}
       else  begin //{ 
       num = $urandom_range(32'd15,32'd8);
        end //}
       $display($time,"value of num is = %d ",num);
       wait(env1.pl_agent.pl_monitor.rx_monitor.lane_handle_ins[num].current_sync_state == NO_SYNC_2);
       wait(env2.pl_agent.pl_monitor.tx_monitor.lane_handle_ins[num].current_sync_state == NO_SYNC_2);  
            
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
      env2.pl_agent.pl_driver.srio_if.srio_rst_n = 0;
      #1000ns;
      env1.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
      env2.pl_agent.pl_driver.srio_if.srio_rst_n = 1;
      
      nread_req_seq.start(env1.e_virtual_sequencer);
      #2000ns;         
      phase.drop_objection(this);
    
  endtask

  
endclass


