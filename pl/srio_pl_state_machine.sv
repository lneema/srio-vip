////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_pl_state_machine.sv
// Project    :  srio vip
// Purpose    :  PL state machines.
// 		 1. Align state machines
// 		 2. Initialization state machine
// 		 3. 1x/2x Mode detect state machine
// Author     :  Mobiveil
//
// Physical layer state machine class.
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

class srio_pl_state_machine extends uvm_component;

  /// @cond
  `uvm_component_utils(srio_pl_state_machine)
  /// @endcond

  virtual srio_interface srio_if;				///< Virtual interface
                                                                                                            
  srio_env_config pl_sm_env_config;                             ///< ENV config instance
                                                                                                            
  srio_pl_config pl_sm_config;                                  ///< PL Config instance
                                                                                                            
  srio_pl_tx_rx_mon_common_trans pl_sm_common_mon_trans;        ///< Common monitor transction instance
                                                                                                            
  srio_pl_common_component_trans pl_sm_trans;                   ///< PL monitor common transaction instance
                                                                                                            
  srio_reg_block pl_sm_reg_model;                               ///< Register model instance

  // Properties

  bit bfm_or_mon;
  bit mon_type;					///< Monitor type
  bit report_error;				///< Report error or warning.
                                                  
  int x2_align_A_counter;			///< A column counter for 2X alignment.
  int x2_align_MA_counter;			///< MisAlignment column counter for 2X alignment.
                                                 
  int nx_align_A_counter;			///< A column counter for NX alignment.
  int nx_align_MA_counter;			///< MisAlignment column counter for NX alignment.
                                                
  int D_counter;                                ///< D_counter for 1x_2x mode detect state machine.
                                              
  bit temp_2_lanes_aligned;			///< local variable for 2x align sm to indicate 2x alignment.
                                             
  bit x2_a_col_detected;			///< Column of A detected in 2X align sm.
  bit nx_a_col_detected;			///< Column of A detected in NX align sm.
                                            
  bit x2_align_err;				///< Align error detected in 2X align sm.
  bit nx_align_err;				///< Align error detected in NX align sm.
                                           
  srio_2x_align_data pl_sm_x2_align_data;	///< x2 lane align data to be used by 2x align s/m
  srio_nx_align_data pl_sm_nx_align_data;	///< nx lane align data to be used by nx align s/m

  align_sm_states prev_2x_align_state, current_2x_align_state;		///< current  & previous 2X alignment state
  align_sm_states prev_nx_align_state, current_nx_align_state;		///< current  & previous NX alignment state

  align_sm_states current_2x_align_state_q[$];				///< current 2X alignment state queue for FC to hit intermediate states.
  align_sm_states current_nx_align_state_q[$];				///< current NX alignment state queue for FC to hit intermediate states.

  init_sm_states prev_init_state;					///< Previous init state.
  init_sm_states current_init_state_q[$];				///< Current init state queue for coverage purpose.
  mode_detect_sm_states prev_mode_detect_state, curr_mode_detect_state;	///< previous and current mode detect state.
  mode_detect_sm_states curr_mode_detect_state_q[$];			///< current mode detect state queue for FC to hit intermediate states.

  // State machine variables.
  integer pl_sm_silence_timer;			///< Silence timer value.
  integer pl_sm_discovery_timer;		///< Discovery timer value.
  integer pl_sm_recovery_timer;			///< Recovery timer value.

  bit silence_timer_start;			///< Starts silence timer when init sm enters SILENT state.
  bit silence_timer_done;			///< Indicates silence timer is completed.
  bit disc_timer_start;				///< Starts the discovery timer when init sm enters discovery state.
  bit disc_timer_done;				///< Indicates discovery timer is completed.
  bit sltosk;					///< Indicates SILENT to SEEK state transition.
  bit sktod;					///< Indicates SEEK to DISCOVERY state transition.
  bit skto1xm0;					///< Indicates SEEK to X1_M0 state transition.
  bit skto1xm2;					///< Indicates SEEK to X1_M2 state transition.
  bit dtonxm;					///< Indicates DISCOVERY to NX_MODE state transition.
  bit dto2xm;					///< Indicates DISCOVERY to X2_MODE state transition.
  bit dto1xm0;					///< Indicates DISCOVERY to X1_M0 state transition.
  bit dto1xm1;					///< Indicates DISCOVERY to X1_M1 state transition.
  bit dto1xm2;					///< Indicates DISCOVERY to X1_M2 state transition.
  bit dtosl;					///< Indicates DISCOVERY to SILENT state transition.
  bit nxmtod;					///< Indicates NX_MODE to DISCOVERY state transition.
  bit nxmtosl;					///< Indicates NX_MODE to SILENT state transition.
  bit x2mtox2r;					///< Indicates X2_MODE to X2_RECOVERY state transition.
  bit x2mtosl;					///< Indicates X2_MODE to SILENT state transition.
  bit x2rto1xm0;				///< Indicates X2_RECOVERY to X1_M0 state transition.
  bit x2rto1xm1;				///< Indicates X2_RECOVERY to X1_M1 state transition.
  bit x2rtox2m;					///< Indicates X2_RECOVERY to X2_MODE state transition.
  bit x2rtosl;					///< Indicates X2_RECOVERY to SILENT state transition.
  bit x1m0tox1r;				///< Indicates X1_M0 to X1_RECOVERY state transition.
  bit x1m0tosl;					///< Indicates X1_M0 to SILENT state transition.
  bit x1m1tox1r;				///< Indicates X1_M1 to X1_RECOVERY state transition.
  bit x1m1tosl;					///< Indicates X1_M1 to SILENT state transition.
  bit x1m2tox1r;				///< Indicates X1_M2 to X1_RECOVERY state transition.
  bit x1m2tosl;					///< Indicates X1_M2 to SILENT state transition.
  bit x1rtox1m0;				///< Indicates X1_RECOVERY to X1_M0 state transition.
  bit x1rtox1m1;				///< Indicates X1_RECOVERY to X1_M1 state transition.
  bit x1rtox1m2;				///< Indicates X1_RECOVERY to X1_M2 state transition.
  bit x1rtosl;					///< Indicates X1_RECOVERY to SILENT state transition.

  bit stop_disc_timer;				///< Stops discovery timer when any of the condition to move out of discovery state is satisfied.

  event port_width_registers_read;		///< Event to indicate port_width related register fields are read.

  bit check_nx_mode_supp_for_dut_if;		///< Flag used to read the nx_mode_support value thro' pl_config or thro' register model.
  bit pl_sm_nx_mode_support;			///< Indicates Nx mode support.

  bit check_x2_mode_supp_for_dut_if;		///< Flag used to read the x2_mode_support value thro' pl_config or thro' register model.
  bit pl_sm_2x_mode_support;            	///< Indicates 2X mode support.

  bit check_force_1x_mode_supp_for_dut_if;	///< Flag used to read the force_1x_mode support value thro' pl_config or thro' register model.
  bit pl_sm_force_1x_mode;                    	///< Indicates force 1x mode support.

  bit check_force_lane_r_supp_for_dut_if;	///< Flag used to read the force_1x_mode_laneR support value thro' pl_config or thro' register model.
  bit pl_sm_force_1x_mode_laneR;             	///< Indicates force 1x mode laneR support.

  bit [0:1] pnccsr_pw_support;			///< Holds the port_width_support value read from register model.
  bit [0:2] pnccsr_pwo;				///< Holds the port_width_override value read from register model.

  bit [0:1] pnccsr_epw_support;			///< Holds the extended_port_width_support value read from register model.
  bit [0:1] pnccsr_epwo;			///< Holds the extended_port_width_override value read from register model.

  // GEN3.0 specific variables
  bit x2_sc_col_detected;			///< Indicates status/control control cw column detected for gen3 x2 align sm.
  bit x2_part_sc_col_detected;			///< Indicates part of status/control control cw column detected for gen3 x2 align sm.

  bit nx_sc_col_detected;			///< Indicates status/control control cw column detected for gen3 nx align sm.
  bit nx_part_sc_col_detected;			///< Indicates part of status/control control cw column detected for gen3 nx align sm.

  bit recovery_timer_start;			///< Starts the recovery timer value when any of the recovery state is entered.
  bit recovery_timer_done;			///< Indicates completion of recovery timer.

  bit stop_rec_timer;				///< Stops recovery timer when any of the condition to move out of the recovery state is satisfied.

  bit nxmtonxr;					///< Indicates NX_MODE to NX_RECOVERY state transition.
  bit nxmtoam;					///< Indicates NX_MODE to ASYM_MODE state transition.
  bit nxrtonxm;					///< Indicates NX_RECOVERY to NX_MODE state transition.
  bit nxrto2xm;					///< Indicates NX_RECOVERY to X2_MODE state transition.
  bit nxrto1xm0;				///< Indicates NX_RECOVERY to X1_M0 state transition.
  bit nxrto1xm1;				///< Indicates NX_RECOVERY to X1_M1 state transition.
  bit nxrto1xm2;				///< Indicates NX_RECOVERY to X1_M2 state transition.
  bit nxrtosl;					///< Indicates NX_RECOVERY to SILENT state transition.
  bit nxrtonxtr;				///< Indicates NX_RECOVERY to NX_RETRAIN state transition.

  bit x2mtoam;					///< Indicates X2_MODE to ASYM_MODE state transition.
  bit x2rtox2tr;				///< Indicates X2_RECOVERY to X2_RETRAIN state transition.

  bit x1rtox1tr;				///< Indicates X1_RECOVERY to X1_RETRAIN state transition.

  bit temp_2_lanes_ready;			///< local variable for 2 lanes ready. Set by temp_2_lanes_aligned along with x2_lanes_ready. Used in rcv_width_sm

  bit bad_xmt_width_cmd;			///< Indicates bad transmit width command.
  bit bad_rcv_width_cmd;			///< Indicates bad receive width command.

  bit pl_sm_asym_mode_support;			///< Indicates asymmetric mode support.
  bit pl_sm_1x_asym_mode_support;		///< Indicates 1x mode support in asymmetric mode.
  bit pl_sm_2x_asym_mode_support;		///< Indicates 2x mode support in asymmetric mode.
  bit pl_sm_nx_asym_mode_support;		///< Indicates nx mode support in asymmetric mode.
  bit pl_sm_asym_mode_en;			///< Indicates asymmetric mode enable.
  bit check_asym_mode_supp_for_dut_if;		///< Flag used to read the asymmetric mode support value thro' pl_config or thro' register model.
  bit [2:0] pl_sm_xmt_width_port_cmd;		///< Transmit width port command.
  bit [2:0] pl_sm_change_lp_xmt_width;		///< Command to change the link partner transmit width.
  bit [2:0] received_xmt_width_req_cmd;		///< Transmit width request command.
  bit xmt_width_req_timeout_occured;		///< Timeout for transmit width request command.

  bit [2:0] received_rcv_width_cmd;		///< Receive width command.
  bit received_ack;				///< Received ACK for receive width command.
  bit received_nack;				///< Received NACK for receive width command.
  bit rcv_width_cmd_timeout_occured;		///< Timeout for receive width command.

  bit [0:4] pnpmcsr_asym_support;			///< Holds the asymmetric_support value read from the register model.
  bit [0:4] pnpmcsr_asym_en;				///< Holds the asymmetric_enable value read from the register model.
  bit [0:2] pnpmcsr_tx_width_status;			///< Holds the transmit width status value read from the register model.
  bit [0:2] pnpmcsr_rx_width_status;			///< Holds the receive width status value read from the register model.
  bit [0:2] pnpmcsr_change_local_tx_width;		///< Holds the change local tx width command value read from the register model.
  bit [0:2] pnpmcsr_change_lp_tx_width;			///< Holds the change link partner tx width command value read from the register model.
  bit [0:1] pnpmcsr_change_local_tx_width_status;	///< Holds the change local tx width command status value read from the register model.
  bit [0:1] pnpmcsr_change_lp_tx_width_status;		///< Holds the chaneg link partner tx width command status value read from the register model.

  bit xmt_width_req_cmd_in_progress;			///< Indicates tx width request command in progress.
  bit xmt_width_req_cmd_scheduled;			///< Indicates tx width request command is scheduled to be processed next.
  bit change_my_xmt_width_cmd_in_progress;		///< Indicates change local tx width request command in progress.
  bit change_my_xmt_width_cmd_scheduled;      		///< Indicates change local tx width request command is scheduled to be processed next.
  bit [2:0] next_xmt_width_cmd_q[$];			///< Queue to hold the scheduled tx width commands that are to be processed.

  string prev_xmt_width;				///< Holds the previous transmit width.
  bit xmt_width_tmr_en;					///< Enables transmit width timer.
  bit xmt_width_tmr_done;				///< Indicates transmit width timer is completed.
  
  bit rcv_width_tmr_en;					///< Enables receive width timer.
  bit rcv_width_tmr_done;				///< Indicates receive width timer completed.

  retrain_xmt_width_ctrl_sm_states prev_cw_retrain_state, current_cw_retrain_state;	///< Current & previous codeword retrain state.
  xmt_width_cmd_sm_states prev_xmit_width_cmd_state, current_xmit_width_cmd_state;	///< Current & previous tx width command state.
  xmt_width_sm_states prev_xmit_width_state, current_xmit_width_state;			///< Current & previous tx width state.
  rcv_width_cmd_sm_states prev_rcv_width_cmd_state, current_rcv_width_cmd_state;	///< Current & previous rx width command state.
  rcv_width_sm_states prev_rcv_width_state, current_rcv_width_state;			///< Current & previous rx width state.

  retrain_xmt_width_ctrl_sm_states current_cw_retrain_state_q[$];	///< Current codeword retrain state queue for FC purpose.
  xmt_width_cmd_sm_states current_xmit_width_cmd_state_q[$];		///< Current tx width command state queue for FC purpose.
  xmt_width_sm_states current_xmit_width_state_q[$];			///< Current tx width state queue for FC purpose.
  rcv_width_cmd_sm_states current_rcv_width_cmd_state_q[$];		///< Current rx width command state queue for FC purpose.
  rcv_width_sm_states current_rcv_width_state_q[$];			///< Current rx width state queue for FC purpose.

  uvm_reg_field reqd_field_name[string];				///< Associative array to get respective field name from register_update_method.

  event gen3_power_mgmt_registers_read;					///< Event to indicate power management register fields are read.

  // Methods
  extern function new(string name = "srio_pl_state_machine", uvm_component parent = null);
  extern task run_phase(uvm_phase phase);

  extern task x2_align_sm();
  extern task nx_align_sm();
  extern task set_2_lanes_aligned();

  extern task check_2x_align_err();
  extern task check_nx_align_err();

  extern task detect_2x_column_of_A();
  extern task detect_nx_column_of_A();

  // Methods which sets and clears the variables used in the initialization s/m.
  extern task disc_timer();
  extern task gen_pl_sm_nx_mode_support();
  extern task gen_pl_sm_2x_mode_support();
  extern task gen_pl_sm_force_1x_mode();
  extern task gen_pl_sm_force_1x_mode_laneR();
  extern task gen_sltosk();
  extern task gen_sktod();
  extern task gen_skto1xm0();
  extern task gen_skto1xm2();
  extern task gen_dtonxm();
  extern task gen_dto2xm();
  extern task gen_dto1xm0();
  extern task gen_dto1xm1();
  extern task gen_dto1xm2();
  extern task gen_dtosl();
  extern task gen_nxmtod();
  extern task gen_nxmtosl();
  extern task gen_2xmto2xr();
  extern task gen_2xmtosl();
  extern task gen_2xrto1xm0();
  extern task gen_2xrto1xm1();
  extern task gen_2xrto2xm();
  extern task gen_2xrtosl();
  extern task gen_1xm0to1xr();
  extern task gen_1xm0tosl();
  extern task gen_1xm1to1xr();
  extern task gen_1xm1tosl();
  extern task gen_1xm2to1xr();
  extern task gen_1xm2tosl();
  extern task gen_1xrto1xm0();
  extern task gen_1xrto1xm1();
  extern task gen_1xrto1xm2();
  extern task gen_1xrtosl();
  extern task initialization_sm();
  extern task x1_x2_mode_detect_sm();
  extern task nx_lanes_ready_gen();
  extern task x2_lanes_ready_gen();

  // GEN3.0 specific methods
  extern task check_for_x2_sc_column();
  extern task check_for_nx_sc_column();

  extern task gen3_x2_align_sm();
  extern task gen3_nx_align_sm();

  extern task recovery_timer();

  extern task gen_nxmtonxr();
  extern task gen_nxmtoam();
  extern task gen_nxrtonxm();
  extern task gen_nxrto2xm();
  extern task gen_nxrto1xm0();
  extern task gen_nxrto1xm1();
  extern task gen_nxrto1xm2();
  extern task gen_nxrtonxtr();
  extern task gen_nxrtosl();
  extern task gen_x2mtoam();
  extern task gen_x2rtox2tr();
  extern task gen_x1rtox1tr();

  extern task gen3_cw_retrain_timer();
  extern task gen_receive_enable();
  extern task gen_transmit_enable();
  extern task gen_retrain_pending();
  extern task gen_retraining();
  extern task gen3_cw_retraining_sm();

  extern task gen_bad_xmt_width_cmd();
  extern task schedule_next_xmt_width_cmd();
  extern task gen_1x_mode_xmt_cmd();
  extern task gen_2x_mode_xmt_cmd();
  extern task gen_nx_mode_xmt_cmd();
  extern task gen_xmt_width_cmd_pending();
  extern task gen3_xmit_width_cmd_sm();
  extern task gen3_xmit_width_sm();
  extern task xmt_width_timer_method();

  extern task gen_bad_rcv_width_cmd();
  extern task gen_1x_mode_rcv_cmd();
  extern task gen_2x_mode_rcv_cmd();
  extern task gen_nx_mode_rcv_cmd();
  extern task gen3_rcv_width_cmd_sm();
  extern task gen3_rcv_width_sm();
  extern task rcv_width_timer_method();

  extern task update_power_management_csr_from_mon();

  extern task xmt_width_req_check();
  extern task rcv_width_cmd_check();

  extern virtual task automatic register_update_method(string reg_name, string field_name, int offset, output uvm_reg_field out_field_name);

endclass


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_state_machine class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_state_machine::new(string name="srio_pl_state_machine", uvm_component parent=null);
  super.new(name, parent);
endfunction : new




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : run_phase
/// Description : run_phase method of srio_pl_state_machine class.
/// It triggers all the methods within the class which needs to be run forever.
/// It also registers the callback for uvm_error demote logic.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::run_phase(uvm_phase phase);

  err_demoter pl_sm_err_demoter = new();
  pl_sm_err_demoter.en_err_demote = !report_error;
  uvm_report_cb::add(this, pl_sm_err_demoter);

  #1ps;

  if (pl_sm_env_config.srio_mode != SRIO_GEN30)
    pl_sm_trans.transmit_enable = 1;

  fork

    begin //{
    if (pl_sm_env_config.num_of_lanes>1 && pl_sm_env_config.srio_mode != SRIO_GEN30)
      x2_align_sm();
    end //}

    begin //{
    if (pl_sm_env_config.num_of_lanes>2 && pl_sm_env_config.srio_mode != SRIO_GEN30)
      nx_align_sm();
    end //}

    begin //{
    if (pl_sm_env_config.num_of_lanes>1 && pl_sm_env_config.srio_mode == SRIO_GEN30)
      gen3_x2_align_sm();
    end //}

    begin //{
    if (pl_sm_env_config.num_of_lanes>2 && pl_sm_env_config.srio_mode == SRIO_GEN30)
      gen3_nx_align_sm();
    end //}

    begin //{
    if (pl_sm_env_config.srio_mode != SRIO_GEN30)
      x1_x2_mode_detect_sm();
    end //}

    set_2_lanes_aligned();

    disc_timer();
    gen_pl_sm_nx_mode_support();
    gen_pl_sm_2x_mode_support();
    gen_pl_sm_force_1x_mode();
    gen_pl_sm_force_1x_mode_laneR();
    gen_sltosk();
    gen_sktod();
    gen_skto1xm0();
    gen_skto1xm2();
    gen_dtonxm();
    gen_dto2xm();
    gen_dto1xm0();
    gen_dto1xm1();
    gen_dto1xm2();
    gen_dtosl();
    gen_nxmtod();
    gen_nxmtosl();
    gen_2xmto2xr();
    gen_2xmtosl();
    gen_2xrto1xm0();
    gen_2xrto1xm1();
    gen_2xrto2xm();
    gen_2xrtosl();
    gen_1xm0to1xr();
    gen_1xm0tosl();
    gen_1xm1to1xr();
    gen_1xm1tosl();
    gen_1xm2to1xr();
    gen_1xm2tosl();
    gen_1xrto1xm0();
    gen_1xrto1xm1();
    gen_1xrto1xm2();
    gen_1xrtosl();
    initialization_sm();
    nx_lanes_ready_gen();
    x2_lanes_ready_gen();

    if (pl_sm_env_config.srio_mode == SRIO_GEN30)
    begin //{

      fork

  	recovery_timer();
        gen_nxmtonxr();
        gen_nxrtonxm();
        gen_nxrto2xm();
        gen_nxrto1xm0();
        gen_nxrto1xm1();
        gen_nxrto1xm2();
        gen_nxrtonxtr();
        gen_nxrtosl();
        gen_nxmtoam();
        gen_x2mtoam();
        gen_x2rtox2tr();
        gen_x1rtox1tr();

  	gen3_cw_retrain_timer();
  	gen_receive_enable();
  	gen_transmit_enable();
  	gen_retrain_pending();
  	gen_retraining();
  	gen3_cw_retraining_sm();
  	gen_bad_xmt_width_cmd();
  	schedule_next_xmt_width_cmd();
  	gen_1x_mode_xmt_cmd();
  	gen_2x_mode_xmt_cmd();
  	gen_nx_mode_xmt_cmd();
  	gen_xmt_width_cmd_pending();
  	gen3_xmit_width_cmd_sm();
  	gen3_xmit_width_sm();
  	xmt_width_timer_method();

  	gen_bad_rcv_width_cmd();
  	gen_1x_mode_rcv_cmd();
  	gen_2x_mode_rcv_cmd();
  	gen_nx_mode_rcv_cmd();
  	gen3_rcv_width_cmd_sm();
  	gen3_rcv_width_sm();
  	rcv_width_timer_method();

  	update_power_management_csr_from_mon();

	if (~bfm_or_mon)
	  xmt_width_req_check();

	if (~bfm_or_mon)
	  rcv_width_cmd_check();

      join_none

    end //}

  join_none

endtask : run_phase




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : set_2_lanes_aligned
/// Description : It sets the two_lanes_aligned variable which is used in all the init state
/// machine variable generations.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::set_2_lanes_aligned();

  forever begin //{

    @(temp_2_lanes_aligned or pl_sm_trans.N_lanes_aligned);
    pl_sm_trans.two_lanes_aligned = (temp_2_lanes_aligned & pl_sm_trans.N_lanes_aligned & pl_sm_trans.current_init_state != X2_MODE) ? 0 : temp_2_lanes_aligned;

    //`uvm_info("SRIO_PL_STATE_MACHINE : set_2_lanes_aligned", $sformatf(" temp_2_lanes_aligned is %0d. pl_sm_trans.N_lanes_aligned is %0d, pl_sm_trans.two_lanes_aligned is %0d", temp_2_lanes_aligned, pl_sm_trans.N_lanes_aligned, pl_sm_trans.two_lanes_aligned), UVM_LOW)

  end //}

endtask : set_2_lanes_aligned




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : check_2x_align_err
/// Description : It detects any align error for 2x align state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::check_2x_align_err();

  bit [7:0] temp_char;
  bit temp_cntl;

  x2_align_err = 0;

  for (int x2_align_err_chk=0; x2_align_err_chk<2; x2_align_err_chk++)
  begin //{
  
    if (!pl_sm_x2_align_data.character.exists(x2_align_err_chk))
    begin //{
      x2_align_err = 1;
      break;
    end //}
  
    if (x2_align_err_chk == 0 && pl_sm_x2_align_data.cntl[x2_align_err_chk])
    begin //{
  
      temp_char = pl_sm_x2_align_data.character[x2_align_err_chk];
      temp_cntl = pl_sm_x2_align_data.cntl[x2_align_err_chk];
  
    end //}
    else if(x2_align_err_chk == 0 && pl_sm_x2_align_data.cntl[x2_align_err_chk] == 0)
    begin //{
      temp_cntl = 0;
    end //}
    else
    begin //{
  
      if (temp_cntl && (temp_char != SRIO_SC && temp_char != SRIO_PD))
      begin //{
  
        if (pl_sm_x2_align_data.cntl[x2_align_err_chk] != temp_cntl)
        begin //{
          x2_align_err = 1;
          break;
        end //}
  
        if (pl_sm_x2_align_data.character[x2_align_err_chk] != temp_char)
        begin //{
          x2_align_err = 1;
          break;
        end //}
  
      end //}
      else if (pl_sm_x2_align_data.cntl[x2_align_err_chk] && (pl_sm_x2_align_data.character[x2_align_err_chk] != SRIO_SC && pl_sm_x2_align_data.character[x2_align_err_chk] != SRIO_PD))
      begin //{

        if (pl_sm_x2_align_data.cntl[x2_align_err_chk] != temp_cntl)
        begin //{
          x2_align_err = 1;
          break;
        end //}
  
      end //}
  
    end //}
  
  end //}

endtask : check_2x_align_err


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : detect_2x_column_of_A
/// Description : It detects A column for 2x align state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::detect_2x_column_of_A();

  for (int x2_a_col_chk=0; x2_a_col_chk<2; x2_a_col_chk++)
  begin //{

    if (!pl_sm_x2_align_data.character.exists(x2_a_col_chk))
    begin //{
      x2_a_col_detected = 0;
      break;
    end //}
  
    if (pl_sm_x2_align_data.character[x2_a_col_chk] == SRIO_A && pl_sm_x2_align_data.cntl[x2_a_col_chk])
      x2_a_col_detected = 1;
    else
    begin //{
      x2_a_col_detected = 0;
      break;
    end //}

  end //}

endtask : detect_2x_column_of_A


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : check_nx_align_err
/// Description : It detects any align error for nx align state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::check_nx_align_err();

  bit [7:0] temp_char;
  bit temp_cntl;

  nx_align_err = 0;

  for (int nx_align_err_chk=0; nx_align_err_chk<pl_sm_env_config.num_of_lanes; nx_align_err_chk++)
  begin //{

    if (!pl_sm_nx_align_data.character.exists(nx_align_err_chk))
    begin //{
      nx_align_err = 1;
      break;
    end //}
  
    if (nx_align_err_chk == 0 && pl_sm_nx_align_data.cntl[nx_align_err_chk])
    begin //{
  
      temp_char = pl_sm_nx_align_data.character[nx_align_err_chk];
      temp_cntl = pl_sm_nx_align_data.cntl[nx_align_err_chk];
  
    end //}
    else if(nx_align_err_chk == 0 && pl_sm_nx_align_data.cntl[nx_align_err_chk] == 0)
    begin //{
      temp_cntl = 0;
    end //}
    else
    begin //{
  
      if (temp_cntl && (temp_char != SRIO_SC && temp_char != SRIO_PD))
      begin //{
  
        if (pl_sm_nx_align_data.cntl[nx_align_err_chk] != temp_cntl)
        begin //{
          nx_align_err = 1;
          break;
        end //}
  
        if (pl_sm_nx_align_data.character[nx_align_err_chk] != temp_char)
        begin //{
          nx_align_err = 1;
          break;
        end //}
  
      end //}
      else if (pl_sm_nx_align_data.cntl[nx_align_err_chk] && (pl_sm_nx_align_data.character[nx_align_err_chk] != SRIO_SC && pl_sm_nx_align_data.character[nx_align_err_chk] != SRIO_PD))
      begin //{

        if (pl_sm_nx_align_data.cntl[nx_align_err_chk] != temp_cntl)
        begin //{
          nx_align_err = 1;
          break;
        end //}
  
      end //}
  
    end //}
  
  end //}

endtask : check_nx_align_err


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : detect_nx_column_of_A
/// Description : It detects A column for nx align state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::detect_nx_column_of_A();

  for (int nx_a_col_chk=0; nx_a_col_chk<pl_sm_env_config.num_of_lanes; nx_a_col_chk++)
  begin //{
    if (!pl_sm_nx_align_data.character.exists(nx_a_col_chk))
    begin //{
      nx_a_col_detected = 0;
      break;
    end //}
    else if (pl_sm_nx_align_data.character[nx_a_col_chk] == SRIO_A && pl_sm_nx_align_data.cntl[nx_a_col_chk])
      nx_a_col_detected = 1;
    else
    begin //{
      nx_a_col_detected = 0;
      break;
    end //}
  end //}

endtask : detect_nx_column_of_A



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : x2_align_sm
/// Description : 2x align state machine method. This method will only execute if 2x
/// destriping logic is satisfied in rx_data_handler block. Once alignment is detected, this
/// method will set "temp_2_lanes_aligned" variable. "two_lanes_aligned" variable is set based
/// on whether nx alignment is achieved or not.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::x2_align_sm();

  bit x2_sync_break;

  current_2x_align_state = NOT_ALIGNED;

  if (~bfm_or_mon)
    current_2x_align_state_q.push_back(current_2x_align_state);

  forever begin //{

    wait (pl_sm_trans.temp_2x_alignment_done == 1 && pl_sm_trans.x2_align_data_valid == 1);

    if (!(prev_2x_align_state == NOT_ALIGNED_1 && current_2x_align_state == NOT_ALIGNED_2) && !(prev_2x_align_state == ALIGNED_1 && current_2x_align_state == ALIGNED_2) && !(prev_2x_align_state == ALIGNED_3 && current_2x_align_state == ALIGNED_2))
      @(negedge srio_if.sim_clk or negedge srio_if.srio_rst_n);

    if (pl_sm_trans.temp_2x_alignment_done == 0 || pl_sm_trans.x2_align_data_valid == 0)
      continue;

    for (int x2_sm_lane_sync_chk = 0; x2_sm_lane_sync_chk<2; x2_sm_lane_sync_chk++)
    begin //{

      if (pl_sm_trans.lane_sync[x2_sm_lane_sync_chk] == 0)
      begin //{
	x2_sync_break = 1;
	break;
      end //}

    end //}

    if (~srio_if.srio_rst_n || x2_sync_break)
    begin //{

      prev_2x_align_state = current_2x_align_state;

      current_2x_align_state = NOT_ALIGNED;
      x2_sync_break = 0;
      pl_sm_trans.temp_2x_alignment_done = 0;
      temp_2_lanes_aligned = 0;
      x2_align_A_counter = 0;

      if (~bfm_or_mon && prev_2x_align_state != current_2x_align_state)
	current_2x_align_state_q.push_back(current_2x_align_state);

    end //}
    else
    begin //{

      //`uvm_info("SRIO_PL_STATE_MACHINE : 2X_ALIGN_SM", $sformatf(" temp_2_lanes_aligned is %0d. Present 2x align state is %0s", temp_2_lanes_aligned, current_2x_align_state.name()), UVM_LOW)

      prev_2x_align_state = current_2x_align_state;

      case (current_2x_align_state)

	NOT_ALIGNED : begin //{

			temp_2_lanes_aligned = 0;
      			pl_sm_trans.temp_2x_alignment_done = 0;
			x2_align_A_counter = 0;
			x2_a_col_detected = 0;

			detect_2x_column_of_A();

			if (~x2_a_col_detected)
			  current_2x_align_state = NOT_ALIGNED;
			else
			  current_2x_align_state = NOT_ALIGNED_1;

		      end //}

	NOT_ALIGNED_1 : begin //{

			  x2_align_A_counter++;

			  if(x2_align_A_counter < pl_sm_config.align_threshold)
			    current_2x_align_state = NOT_ALIGNED_2;
			  else
			    current_2x_align_state = ALIGNED;

			end //}

	NOT_ALIGNED_2 : begin //{

			  x2_a_col_detected = 0;
			  x2_align_err = 0;

			  check_2x_align_err();

			  detect_2x_column_of_A();

			  if(x2_align_err)
			    current_2x_align_state = NOT_ALIGNED;
			  else if (x2_a_col_detected)
			    current_2x_align_state = NOT_ALIGNED_1;
			  else
			    current_2x_align_state = NOT_ALIGNED_2;

			  //if (current_2x_align_state == NOT_ALIGNED)
			  //  pl_sm_trans.temp_2x_alignment_done = 0;

			end //}

	ALIGNED	: begin //{

		    temp_2_lanes_aligned = 1;
		    x2_align_MA_counter = 0;

		    check_2x_align_err();

		    if(x2_align_err)
		      current_2x_align_state = ALIGNED_1;
		    else
		      current_2x_align_state = ALIGNED;

		  end //}

	ALIGNED_1 : begin //{

		      temp_2_lanes_aligned = 1;
		      x2_align_A_counter = 0;
		      x2_align_MA_counter++;

		      if(x2_align_MA_counter < pl_sm_config.lane_misalignment_threshold)
		        current_2x_align_state = ALIGNED_2;
		      else
		        current_2x_align_state = NOT_ALIGNED;

		      //if (current_2x_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_2x_alignment_done = 0;

		    end //}

	ALIGNED_2 : begin //{

		      temp_2_lanes_aligned = 1;
		      x2_a_col_detected = 0;
		      x2_align_err = 0;

		      check_2x_align_err();

		      detect_2x_column_of_A();

		      if(x2_align_err)
		        current_2x_align_state = ALIGNED_1;
		      else if (x2_a_col_detected)
		        current_2x_align_state = ALIGNED_3;
		      else
		        current_2x_align_state = ALIGNED_2;

		    end //}

	ALIGNED_3 : begin //{

		      temp_2_lanes_aligned = 1;
		      x2_align_A_counter++;

		      if(x2_align_A_counter < pl_sm_config.align_threshold)
		        current_2x_align_state = ALIGNED_2;
		      else
		        current_2x_align_state = ALIGNED;

		    end //}

      endcase

      if (prev_2x_align_state != current_2x_align_state && (current_2x_align_state == ALIGNED || prev_2x_align_state == ALIGNED))
        `uvm_info("SRIO_PL_STATE_MACHINE : 2X_ALIGN_SM", $sformatf(" temp_2_lanes_aligned is %0d. Next 2x align state is %0s", temp_2_lanes_aligned, current_2x_align_state.name()), UVM_LOW)

      if (~bfm_or_mon && prev_2x_align_state != current_2x_align_state)
	current_2x_align_state_q.push_back(current_2x_align_state);

    end //}

  end //}

endtask : x2_align_sm




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : nx_align_sm
/// Description : NX alignement state machine. This method will only execute if nx
/// destriping logic is satisfied in rx_data_handler block.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::nx_align_sm();

  bit nx_sync_break;

  current_nx_align_state = NOT_ALIGNED;

  if (~bfm_or_mon)
    current_nx_align_state_q.push_back(current_nx_align_state);

  forever begin //{

    wait (pl_sm_trans.temp_nx_alignment_done == 1 && pl_sm_trans.nx_align_data_valid == 1);

    if (!(prev_nx_align_state == NOT_ALIGNED_1 && current_nx_align_state == NOT_ALIGNED_2) && !(prev_nx_align_state == ALIGNED_1 && current_nx_align_state == ALIGNED_2) && !(prev_nx_align_state == ALIGNED_3 && current_nx_align_state == ALIGNED_2))
    @(negedge srio_if.sim_clk or negedge srio_if.srio_rst_n);

    if (pl_sm_trans.temp_nx_alignment_done == 0 || pl_sm_trans.nx_align_data_valid == 0)
      continue;

    for (int nx_sm_lane_sync_chk = 0; nx_sm_lane_sync_chk<pl_sm_env_config.num_of_lanes; nx_sm_lane_sync_chk++)
    begin //{

      if (pl_sm_trans.lane_sync[nx_sm_lane_sync_chk] == 0)
      begin //{
	nx_sync_break = 1;
	break;
      end //}

    end //}

    if (~srio_if.srio_rst_n || nx_sync_break)
    begin //{

      prev_nx_align_state = current_nx_align_state;

      current_nx_align_state = NOT_ALIGNED;
      nx_sync_break = 0;
      pl_sm_trans.temp_nx_alignment_done = 0;
      pl_sm_trans.N_lanes_aligned = 0;
      nx_align_A_counter = 0;

      if (~bfm_or_mon && prev_nx_align_state != current_nx_align_state)
	current_nx_align_state_q.push_back(current_nx_align_state);

    end //}
    else
    begin //{

      //`uvm_info("SRIO_PL_STATE_MACHINE : NX_ALIGN_SM", $sformatf(" pl_sm_trans.N_lanes_aligned is %0d. Present nx align state is %0s", pl_sm_trans.N_lanes_aligned, current_nx_align_state.name()), UVM_LOW)

      prev_nx_align_state = current_nx_align_state;

      case (current_nx_align_state)

	NOT_ALIGNED : begin //{

		   //$display($time, " : Entered NOT_ALIGNED in NX_ALIGN_SM");

			pl_sm_trans.N_lanes_aligned = 0;
      			pl_sm_trans.temp_nx_alignment_done = 0;
			nx_align_A_counter = 0;
			nx_a_col_detected = 0;

			detect_nx_column_of_A();

			if (~nx_a_col_detected)
			  current_nx_align_state = NOT_ALIGNED;
			else
			  current_nx_align_state = NOT_ALIGNED_1;

		      end //}

	NOT_ALIGNED_1 : begin //{

			  nx_align_A_counter++;

			  if(nx_align_A_counter < pl_sm_config.align_threshold)
			    current_nx_align_state = NOT_ALIGNED_2;
			  else
			    current_nx_align_state = ALIGNED;

			end //}

	NOT_ALIGNED_2 : begin //{

			  nx_a_col_detected = 0;
			  nx_align_err = 0;

			  check_nx_align_err();

			  detect_nx_column_of_A();

			  if(nx_align_err)
			    current_nx_align_state = NOT_ALIGNED;
			  else if (nx_a_col_detected)
			    current_nx_align_state = NOT_ALIGNED_1;
			  else
			    current_nx_align_state = NOT_ALIGNED_2;

			  //if (current_nx_align_state == NOT_ALIGNED)
			  //  pl_sm_trans.temp_nx_alignment_done = 0;

			end //}

	ALIGNED	: begin //{

		    pl_sm_trans.N_lanes_aligned = 1;
		    nx_align_MA_counter = 0;

		    check_nx_align_err();

		    if(nx_align_err)
		      current_nx_align_state = ALIGNED_1;
		    else
		      current_nx_align_state = ALIGNED;

		  end //}

	ALIGNED_1 : begin //{

		   //$display($time, " : Entered ALIGNED_1 in NX_ALIGN_SM");

		      pl_sm_trans.N_lanes_aligned = 1;
		      nx_align_A_counter = 0;
		      nx_align_MA_counter++;

		      if(nx_align_MA_counter < pl_sm_config.lane_misalignment_threshold)
		        current_nx_align_state = ALIGNED_2;
		      else
		        current_nx_align_state = NOT_ALIGNED;

		      //if (current_nx_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_nx_alignment_done = 0;

		    end //}

	ALIGNED_2 : begin //{

		   //$display($time, " : Entered ALIGNED_2 in NX_ALIGN_SM");

		      pl_sm_trans.N_lanes_aligned = 1;
		      nx_a_col_detected = 0;
		      nx_align_err = 0;

		      check_nx_align_err();

		      detect_nx_column_of_A();

		      if(nx_align_err)
		        current_nx_align_state = ALIGNED_1;
		      else if (nx_a_col_detected)
		        current_nx_align_state = ALIGNED_3;
		      else
		        current_nx_align_state = ALIGNED_2;

		    end //}

	ALIGNED_3 : begin //{

		   //$display($time, " : Entered ALIGNED_3 in NX_ALIGN_SM");

		      pl_sm_trans.N_lanes_aligned = 1;
		      nx_align_A_counter++;

		      if(nx_align_A_counter < pl_sm_config.align_threshold)
		        current_nx_align_state = ALIGNED_2;
		      else
		        current_nx_align_state = ALIGNED;

		    end //}

      endcase

      if (prev_nx_align_state != current_nx_align_state && (current_nx_align_state == ALIGNED || prev_nx_align_state == ALIGNED))
        `uvm_info("SRIO_PL_STATE_MACHINE : NX_ALIGN_SM", $sformatf(" pl_sm_trans.N_lanes_aligned is %0d. Next nx align state is %0s", pl_sm_trans.N_lanes_aligned, current_nx_align_state.name()), UVM_LOW)

      if (~bfm_or_mon && prev_nx_align_state != current_nx_align_state)
	current_nx_align_state_q.push_back(current_nx_align_state);

    end //}

  end //}

endtask : nx_align_sm




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_sltosk
/// Description : This method runs the silence timer when init sm enters silent state, 
/// and also sets the sltosk variable once the silence timer is completed.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_sltosk();

  forever begin //{

    wait(silence_timer_start == 1 && silence_timer_done == 0);

    if (bfm_or_mon)
    begin //{

      pl_sm_silence_timer = pl_sm_config.bfm_silence_timer;

    end //}
    else if (~bfm_or_mon)
    begin //{

	// If mon_if is DUT, then it means, the particular monitor
	// will check the DUT's tx data, which inturn means, it has
	// to behave like BFM. Hence, it'll work as per BFM's timer 
	// values and vice-versa.

      if (mon_type && pl_sm_env_config.srio_tx_mon_if == DUT)
        pl_sm_silence_timer = pl_sm_config.bfm_silence_timer;
      else if (mon_type && pl_sm_env_config.srio_tx_mon_if == BFM)
        pl_sm_silence_timer = pl_sm_config.lp_silence_timer;

      if (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT)
        pl_sm_silence_timer = pl_sm_config.bfm_silence_timer;
      else if (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM)
        pl_sm_silence_timer = pl_sm_config.lp_silence_timer;

    end //}

    `uvm_info(" SRIO_PL_SM : SILENCE_TIMER ", $sformatf(" STARTED"), UVM_LOW)

    repeat(pl_sm_silence_timer) @(posedge srio_if.sim_clk);

    `uvm_info(" SRIO_PL_SM : SILENCE_TIMER ", $sformatf(" ENDED"), UVM_LOW)


    silence_timer_done = 1;

    sltosk = 1;

  end //}

endtask : gen_sltosk



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : disc_timer
/// Description : This method runs the discovery timer when init sm enters discovery state.
/// When any of discovery state exit condition which doesn't depend on the discovery timer
/// is set, the this timer is stopped and again waits for disc_timer_start.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::disc_timer();

  forever begin //{

    wait(disc_timer_start == 1 && disc_timer_done == 0);

    if (bfm_or_mon)
    begin //{

      pl_sm_discovery_timer = pl_sm_config.bfm_discovery_timer;

    end //}
    else if (~bfm_or_mon)
    begin //{

	// If mon_if is DUT, then it means, the particular monitor
	// will check the DUT's tx data, which inturn means, it has
	// to behave like BFM. Hence, it'll work as per BFM's timer 
	// values and vice-versa.

      if (mon_type && pl_sm_env_config.srio_tx_mon_if == DUT)
        pl_sm_discovery_timer = pl_sm_config.bfm_discovery_timer;
      else if (mon_type && pl_sm_env_config.srio_tx_mon_if == BFM)
        pl_sm_discovery_timer = pl_sm_config.lp_discovery_timer;

      if (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT)
        pl_sm_discovery_timer = pl_sm_config.bfm_discovery_timer;
      else if (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM)
        pl_sm_discovery_timer = pl_sm_config.lp_discovery_timer;

    end //}

    `uvm_info(" SRIO_PL_SM : DISC_TIMER ", $sformatf(" STARTED"), UVM_LOW)

    fork

      begin : disc_timer_blk //{
        repeat(pl_sm_discovery_timer) 
	begin //{
	  if (~stop_disc_timer)
	  begin //{
	    //$display($time, " Inside discovery timer loop, dtonxm is %0d", dtonxm);
	    @(posedge srio_if.sim_clk);
	  end //}
	  else
	  begin //{
	    //$display($time, " Breaking discovery timer loop");
	    stop_disc_timer = 0;
	    break;
	  end //}
	end //}

    	disc_timer_done = 1;

	//disable disc_state_change_blk;
      end //}

      begin : disc_state_change_blk //{
        wait (dtonxm == 1 || dto2xm == 1 || dto1xm0 == 1 || dto1xm1 == 1 || dto1xm2 == 1 || x2rto1xm0 == 1 || dtosl == 1 || x1rtosl == 1 || x2rtosl == 1);
	stop_disc_timer = 1;

	//$display($time, "   : dtonxm is %0d", dtonxm);
	//$display($time, "   : dto2xm is %0d", dto2xm);
	//$display($time, "   : dto1xm0 is %0d", dto1xm0);
	//$display($time, "   : dto1xm1 is %0d", dto1xm1);
	//$display($time, "   : dto1xm2 is %0d", dto1xm2);
	//$display($time, "   : x2rto1xm0 is %0d", x2rto1xm0);
	//$display($time, "   : dtosl is %0d", dtosl);
	//$display($time, "   : x1rtosl is %0d", x1rtosl);
	//$display($time, "   : x2rtosl is %0d", x2rtosl);
	//disable disc_timer_blk;
      end //}

    join

    stop_disc_timer = 0;
    `uvm_info(" SRIO_PL_SM : DISC_TIMER ", $sformatf(" ENDED"), UVM_LOW)


  end //}

endtask : disc_timer



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : recovery_timer
/// Description : This method runs the recovery timer when init sm enters any of the recovery
/// state. When recovery state exit condition which doesn't depend on the recoery timer
/// is set, the this timer is stopped and again waits for recovery_timer_start.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::recovery_timer();

  forever begin //{

    wait(recovery_timer_start == 1 && recovery_timer_done == 0);

    if (bfm_or_mon)
    begin //{

      pl_sm_recovery_timer = pl_sm_config.bfm_recovery_timer;

    end //}
    else if (~bfm_or_mon)
    begin //{

        // If mon_if is DUT, then it means, the particular monitor
        // will check the DUT's tx data, which inturn means, it has
        // to behave like BFM. Hence, it'll work as per BFM's timer 
        // values and vice-versa.

      if (mon_type && pl_sm_env_config.srio_tx_mon_if == DUT)
        pl_sm_recovery_timer = pl_sm_config.bfm_recovery_timer;
      else if (mon_type && pl_sm_env_config.srio_tx_mon_if == BFM)
        pl_sm_recovery_timer = pl_sm_config.lp_recovery_timer;

      if (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT)
        pl_sm_recovery_timer = pl_sm_config.bfm_recovery_timer;
      else if (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM)
        pl_sm_recovery_timer = pl_sm_config.lp_recovery_timer;

    end //}

    `uvm_info(" SRIO_PL_SM : RECOVERY_TIMER ", $sformatf(" STARTED"), UVM_LOW)

    fork

      begin : rec_timer_blk //{
        repeat(pl_sm_recovery_timer) 
	begin //{
	  if (~stop_rec_timer)
	  begin //{
	    //$display($time, " Inside discovery timer loop, dtonxm is %0d", dtonxm);
	    @(posedge srio_if.sim_clk);
	  end //}
	  else
	  begin //{
	    //$display($time, " Breaking discovery timer loop");
	    stop_rec_timer = 0;
	    break;
	  end //}
	end //}

    	recovery_timer_done = 1;

	//disable disc_state_change_blk;
      end //}

      begin : rec_state_change_blk //{
	// TODO: validate the below wait statement
        wait (nxrtonxm == 1 || nxrtosl == 1 || x2rto1xm0 == 1 || x2rtox2m == 1 || x2rtosl == 1 || x1rtox1m0 == 1 || x1rtox1m1 == 1 || x1rtox1m2 == 1 || x1rtosl == 1);
	stop_rec_timer = 1;

	//$display($time, "   : dtonxm is %0d", dtonxm);
	//$display($time, "   : dto2xm is %0d", dto2xm);
	//$display($time, "   : dto1xm0 is %0d", dto1xm0);
	//$display($time, "   : dto1xm1 is %0d", dto1xm1);
	//$display($time, "   : dto1xm2 is %0d", dto1xm2);
	//$display($time, "   : x2rto1xm0 is %0d", x2rto1xm0);
	//$display($time, "   : dtosl is %0d", dtosl);
	//$display($time, "   : x1rtosl is %0d", x1rtosl);
	//$display($time, "   : x2rtosl is %0d", x2rtosl);
	//disable disc_timer_blk;
      end //}

    join

    stop_rec_timer = 0;
    `uvm_info(" SRIO_PL_SM : RECOVERY_TIMER ", $sformatf(" ENDED"), UVM_LOW)


  end //}

endtask : recovery_timer



////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_pl_sm_force_1x_mode
/// Description : This method controls the assertion and deassertion logic for pl_sm_force_1x_mode
/// based on the config/common trans variable or through the register model.
////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_pl_sm_force_1x_mode();

  if (bfm_or_mon)
  begin //{

    pl_sm_force_1x_mode = (pl_sm_config.force_1x_mode_en & pl_sm_trans.force_1x_mode) || (pl_sm_env_config.num_of_lanes==1);

  end //}
  else
  begin //{

    if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
    begin //{

      pl_sm_force_1x_mode = (pl_sm_config.force_1x_mode_en & pl_sm_trans.force_1x_mode) || (pl_sm_env_config.num_of_lanes==1);

    end //}

  end //}

  forever begin //{

    if (bfm_or_mon)
    begin //{

      @(pl_sm_trans.force_1x_mode or  pl_sm_config.force_1x_mode_en);

      pl_sm_force_1x_mode = (pl_sm_config.force_1x_mode_en & pl_sm_trans.force_1x_mode) || (pl_sm_env_config.num_of_lanes==1);

    end //}
    else if (~bfm_or_mon)
    begin //{

	// if the monitor interface type is BFM, it means, it monitors
	// BFM's tx data, thus it matches DUT's behaviour. Hence, DUT's
	// register model has to be looked at inorder to decide which
	// mode is supported. On the other hand, if the interface type
	// is DUT, it means, the monitor monitors the DUT's tx data, thus
	// it behaves similar to the BFM. Hence, it is enough to look at
	// the BFM's config variable to decide on the mode supported.

      if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
      begin //{
	check_force_1x_mode_supp_for_dut_if = 1;
      end //}
      else if ((mon_type && pl_sm_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM))
      begin //{
	check_force_1x_mode_supp_for_dut_if = 0;
      end //}

      if (check_force_1x_mode_supp_for_dut_if)
      begin //{

        @(pl_sm_trans.force_1x_mode or  pl_sm_config.force_1x_mode_en);

        pl_sm_force_1x_mode = (pl_sm_config.force_1x_mode_en & pl_sm_trans.force_1x_mode) || (pl_sm_env_config.num_of_lanes==1);

      end //}
      else
      begin //{

	@(posedge srio_if.sim_clk);

	wait(port_width_registers_read.triggered);

	pl_sm_force_1x_mode = (pnccsr_pwo == 3'b010 || pnccsr_pwo == 3'b011 || (pnccsr_pw_support == 0 && pnccsr_epw_support == 0)) ? 1 : 0;

      end //}

    end //}

  end //}

endtask : gen_pl_sm_force_1x_mode




///////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_pl_sm_force_1x_mode_laneR
/// Description : This method controls the assertion and deassertion logic for pl_sm_force_1x_mode_laneR
/// based on the config/common trans variable or through the register model.
///////////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_pl_sm_force_1x_mode_laneR();

  if (bfm_or_mon)
  begin //{

    pl_sm_force_1x_mode_laneR = pl_sm_config.force_laner_en & pl_sm_trans.force_laneR;

  end //}
  else
  begin //{

    if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
    begin //{

      pl_sm_force_1x_mode_laneR = pl_sm_config.force_laner_en & pl_sm_trans.force_laneR;

    end //}

  end //}

  forever begin //{

    if (bfm_or_mon)
    begin //{

      @(pl_sm_trans.force_laneR or  pl_sm_config.force_laner_en);

      pl_sm_force_1x_mode_laneR = pl_sm_config.force_laner_en & pl_sm_trans.force_laneR;

    end //}
    else if (~bfm_or_mon)
    begin //{

	// if the monitor interface type is BFM, it means, it monitors
	// BFM's tx data, thus it matches DUT's behaviour. Hence, DUT's
	// register model has to be looked at inorder to decide which
	// mode is supported. On the other hand, if the interface type
	// is DUT, it means, the monitor monitors the DUT's tx data, thus
	// it behaves similar to the BFM. Hence, it is enough to look at
	// the BFM's config variable to decide on the mode supported.

      if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
      begin //{
	check_force_lane_r_supp_for_dut_if = 1;
      end //}
      else if ((mon_type && pl_sm_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM))
      begin //{
	check_force_lane_r_supp_for_dut_if = 0;
      end //}

      if (check_force_lane_r_supp_for_dut_if)
      begin //{

        @(pl_sm_trans.force_laneR or  pl_sm_config.force_laner_en);

        pl_sm_force_1x_mode_laneR = pl_sm_config.force_laner_en & pl_sm_trans.force_laneR;

      end //}
      else
      begin //{

	@(posedge srio_if.sim_clk);

	wait(port_width_registers_read.triggered);

	pl_sm_force_1x_mode_laneR = (pnccsr_pwo == 3'b011) ? 1 : 0;

      end //}

    end //}

  end //}

endtask : gen_pl_sm_force_1x_mode_laneR



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_sktod
/// Description : This method controls the assertion and deassertion logic for sktod
/// state machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_sktod();

  forever begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN21 || pl_sm_env_config.srio_mode == SRIO_GEN22)
    begin //{

      wait(pl_sm_trans.lane_sync.num()>0);

      @(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2] or pl_sm_trans.idle_detected);

      if ((pl_sm_trans.lane_sync[0] == 1 || pl_sm_trans.lane_sync[1] == 1 || pl_sm_trans.lane_sync[2] == 1) && pl_sm_trans.idle_detected)
	sktod = 1;
      else
	sktod = 0;

    end //}
    else if (pl_sm_env_config.srio_mode ==  SRIO_GEN13)
    begin //{

      wait(pl_sm_trans.lane_sync.num()>0);

      @(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[2] or pl_sm_force_1x_mode);

      if ((pl_sm_trans.lane_sync[0] == 1 || pl_sm_trans.lane_sync[2] == 1) && ~pl_sm_force_1x_mode)
	sktod = 1;
      else
	sktod = 0;

    end //}
    else if (pl_sm_env_config.srio_mode ==  SRIO_GEN30)
    begin //{

      if (pl_sm_config.brc3_training_mode)
        wait(pl_sm_trans.frame_lock.num()>0);

      wait(pl_sm_trans.lane_sync.num()>0);

      @(pl_sm_trans.lane_sync[0]  or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2] or pl_sm_trans.frame_lock[0]  or pl_sm_trans.frame_lock[1] or pl_sm_trans.frame_lock[2] or pl_sm_2x_mode_support or pl_sm_nx_mode_support or pl_sm_force_1x_mode);

      sktod = pl_sm_trans.frame_lock[0] ^ pl_sm_trans.lane_sync[0] | (pl_sm_2x_mode_support | pl_sm_force_1x_mode & pl_sm_2x_mode_support) &
		pl_sm_trans.frame_lock[1] ^ pl_sm_trans.lane_sync[1] | (pl_sm_nx_mode_support | pl_sm_force_1x_mode & pl_sm_nx_mode_support) &
		  pl_sm_trans.frame_lock[2] ^ pl_sm_trans.lane_sync[2];

    end //}

  end //}

endtask : gen_sktod


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_skto1xm0
/// Description : This method controls the assertion and deassertion logic for skto1xm0
/// state machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_skto1xm0();

  if (pl_sm_env_config.srio_mode == SRIO_GEN13)
  begin //{

    forever begin //{

      wait (pl_sm_trans.lane_sync.num()>0);

      @(pl_sm_trans.lane_sync[0] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR);

      if (pl_sm_trans.lane_sync[0] && pl_sm_force_1x_mode && ~pl_sm_force_1x_mode_laneR)
	skto1xm0 = 1;
      else
	skto1xm0 = 0;

    end //}

  end //}

endtask : gen_skto1xm0



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_skto1xm2
/// Description : This method controls assertion and deassertion logic for skto1xm2 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_skto1xm2();

  if (pl_sm_env_config.srio_mode == SRIO_GEN13)
  begin //{

    forever begin //{

      wait (pl_sm_trans.lane_sync.num()>0);

      @(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[2] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR);

      if (pl_sm_trans.lane_sync[2] && pl_sm_force_1x_mode && (~pl_sm_trans.lane_sync[0] || pl_sm_force_1x_mode_laneR))
	skto1xm2 = 1;
      else
	skto1xm2 = 0;

    end //}

  end //}

endtask : gen_skto1xm2



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : x2_lanes_ready_gen
/// Description : This method controls two_lanes_ready variable based on lanes 0 & 1's
/// lane_ready and two_lanes_aligned. It also generates temp_2_lanes_ready based on
/// temp_2_lanes_aligned for asymmetric purpose.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::x2_lanes_ready_gen();

  bit x2_lanes_ready;

  if (pl_sm_env_config.num_of_lanes > 1)
  begin //{

    forever begin //{

      wait (pl_sm_trans.lane_ready.num() > 0);

      @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.two_lanes_aligned or temp_2_lanes_aligned);

      for(int x2lr_chk=0; x2lr_chk<2; x2lr_chk++)
      begin //{

        if (pl_sm_trans.lane_ready.exists(x2lr_chk) && pl_sm_trans.lane_ready[x2lr_chk] == 1)
          x2_lanes_ready = 1;
        else
        begin //{
          x2_lanes_ready = 0;
          break;
        end //}

      end //}

      pl_sm_trans.two_lanes_ready = x2_lanes_ready & pl_sm_trans.two_lanes_aligned;

      temp_2_lanes_ready = x2_lanes_ready & temp_2_lanes_aligned;

    end //}

  end //}

endtask : x2_lanes_ready_gen



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : nx_lanes_ready_gen
/// Description : This method generates N_lanes_ready based on lanes 0 to N's lane_ready and
/// N_lanes_aligned variable.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::nx_lanes_ready_gen();

  bit nx_lanes_ready;

  if (pl_sm_env_config.num_of_lanes>2)
  begin //{

    forever begin //{

      wait (pl_sm_trans.lane_ready.num() > 0);

      if (pl_sm_env_config.num_of_lanes == 4)
        @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_trans.lane_ready[3] or pl_sm_trans.N_lanes_aligned);

      else if (pl_sm_env_config.num_of_lanes == 8)
        @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_trans.lane_ready[3] or pl_sm_trans.lane_ready[4] or pl_sm_trans.lane_ready[5] or pl_sm_trans.lane_ready[6] or pl_sm_trans.lane_ready[7] or pl_sm_trans.N_lanes_aligned);

      else if (pl_sm_env_config.num_of_lanes == 16)
        @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_trans.lane_ready[3] or pl_sm_trans.lane_ready[4] or pl_sm_trans.lane_ready[5] or pl_sm_trans.lane_ready[6] or pl_sm_trans.lane_ready[7] or pl_sm_trans.lane_ready[8] or pl_sm_trans.lane_ready[9] or pl_sm_trans.lane_ready[10] or pl_sm_trans.lane_ready[11] or pl_sm_trans.lane_ready[12] or pl_sm_trans.lane_ready[13] or pl_sm_trans.lane_ready[14] or pl_sm_trans.lane_ready[15] or pl_sm_trans.N_lanes_aligned);


      for(int nlr_chk=0; nlr_chk<pl_sm_env_config.num_of_lanes; nlr_chk++)
      begin //{

        if (pl_sm_trans.lane_ready.exists(nlr_chk) && pl_sm_trans.lane_ready[nlr_chk] == 1)
          nx_lanes_ready = 1;
        else
        begin //{
          nx_lanes_ready = 0;
          break;
        end //}

      end //}

      pl_sm_trans.N_lanes_ready = nx_lanes_ready & pl_sm_trans.N_lanes_aligned;

    end //}

  end //}


endtask : nx_lanes_ready_gen



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_pl_sm_nx_mode_support
/// Description : This method generates pl_sm_nx_mode_support variable based on either
/// config variable or by reading register model.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_pl_sm_nx_mode_support();

  if (bfm_or_mon)
  begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    begin //{
      if (pl_sm_env_config.num_of_lanes == 4)
        pl_sm_nx_mode_support = pl_sm_config.nx_mode_support;
      else
        pl_sm_nx_mode_support = 0;
    end //}
    else
    begin //{
      if (pl_sm_env_config.num_of_lanes > 2)
        pl_sm_nx_mode_support = pl_sm_config.nx_mode_support;
      else
        pl_sm_nx_mode_support = 0;
    end //}

  end //}
  else
  begin //{

    if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
    begin //{

      if (pl_sm_env_config.srio_mode == SRIO_GEN13)
      begin //{
        if (pl_sm_env_config.num_of_lanes == 4)
          pl_sm_nx_mode_support = pl_sm_config.nx_mode_support;
        else
          pl_sm_nx_mode_support = 0;
      end //}
      else
      begin //{
        if (pl_sm_env_config.num_of_lanes > 2)
          pl_sm_nx_mode_support = pl_sm_config.nx_mode_support;
        else
          pl_sm_nx_mode_support = 0;
      end //}

    end //}

  end //}

  forever begin //{

    if (bfm_or_mon)
    begin //{

      @(pl_sm_config.nx_mode_support);

      if (pl_sm_env_config.srio_mode == SRIO_GEN13)
      begin //{
        if (pl_sm_env_config.num_of_lanes == 4)
          pl_sm_nx_mode_support = pl_sm_config.nx_mode_support;
        else
          pl_sm_nx_mode_support = 0;
      end //}
      else
      begin //{
        if (pl_sm_env_config.num_of_lanes > 2)
          pl_sm_nx_mode_support = pl_sm_config.nx_mode_support;
        else
          pl_sm_nx_mode_support = 0;
      end //}

    end //}
    else if (~bfm_or_mon)
    begin //{

	// if the monitor interface type is BFM, it means, it monitors
	// BFM's tx data, thus it matches DUT's behaviour. Hence, DUT's
	// register model has to be looked at inorder to decide which
	// mode is supported. On the other hand, if the interface type
	// is DUT, it means, the monitor monitors the DUT's tx data, thus
	// it behaves similar to the BFM. Hence, it is enough to look at
	// the BFM's config variable to decide on the mode supported.

      if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
      begin //{
	check_nx_mode_supp_for_dut_if = 1;
      end //}
      else if ((mon_type && pl_sm_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM))
      begin //{
	check_nx_mode_supp_for_dut_if = 0;
      end //}

      if (check_nx_mode_supp_for_dut_if)
      begin //{

      	@(pl_sm_config.nx_mode_support);

	if (pl_sm_env_config.srio_mode == SRIO_GEN13)
	begin //{
	  if (pl_sm_env_config.num_of_lanes == 4)
      	    pl_sm_nx_mode_support = pl_sm_config.nx_mode_support;
	  else
      	    pl_sm_nx_mode_support = 0;
	end //}
	else
        begin //{
          if (pl_sm_env_config.num_of_lanes > 2)
            pl_sm_nx_mode_support = pl_sm_config.nx_mode_support;
          else
            pl_sm_nx_mode_support = 0;
        end //}

      end //}
      else
      begin //{

	@(posedge srio_if.sim_clk);

	register_update_method("Control_CSR", "Port_Width_Support", 64, reqd_field_name["Port_Width_Support"]);
	pnccsr_pw_support = reqd_field_name["Port_Width_Support"].get();
	//pnccsr_pw_support = pl_sm_reg_model.Port_0_Control_CSR.Port_Width_Support.get();
	pnccsr_pw_support = {pnccsr_pw_support[1], pnccsr_pw_support[0]};

	register_update_method("Control_CSR", "Port_Width_Override", 64, reqd_field_name["Port_Width_Override"]);
	pnccsr_pwo = reqd_field_name["Port_Width_Override"].get();
	//pnccsr_pwo = pl_sm_reg_model.Port_0_Control_CSR.Port_Width_Override.get();
	pnccsr_pwo = {pnccsr_pwo[2], pnccsr_pwo[1], pnccsr_pwo[0]};

	register_update_method("Control_CSR", "Extended_Port_Width_Support", 64, reqd_field_name["Extended_Port_Width_Support"]);
	pnccsr_epw_support = reqd_field_name["Extended_Port_Width_Support"].get();
	//pnccsr_epw_support = pl_sm_reg_model.Port_0_Control_CSR.Extended_Port_Width_Support.get();
	pnccsr_epw_support = {pnccsr_epw_support[1], pnccsr_epw_support[0]};

	register_update_method("Control_CSR", "Extended_Port_Width_Override", 64, reqd_field_name["Extended_Port_Width_Override"]);
	pnccsr_epwo = reqd_field_name["Extended_Port_Width_Override"].get();
	//pnccsr_epwo = pl_sm_reg_model.Port_0_Control_CSR.Extended_Port_Width_Override.get();
	pnccsr_epwo = {pnccsr_epwo[1], pnccsr_epwo[0]};

	->port_width_registers_read;

	if (pl_sm_env_config.srio_mode == SRIO_GEN22 || pl_sm_env_config.srio_mode == SRIO_GEN21 || pl_sm_env_config.srio_mode == SRIO_GEN30)
	begin //{

	  if (pl_sm_env_config.num_of_lanes == 4)
	  begin //{

	    if (pl_sm_env_config.srio_mode == SRIO_GEN21)
	    begin //{

	      pl_sm_nx_mode_support = pnccsr_pw_support[0] && (pnccsr_pwo !== 3'b010 && pnccsr_pwo !== 3'b011 
					&& (~pnccsr_pwo[0] || (pnccsr_pwo[0] && pnccsr_pwo[1])));

	    end //}
	    else if (pl_sm_env_config.srio_mode == SRIO_GEN22 || pl_sm_env_config.srio_mode == SRIO_GEN30)
	    begin //{

	      pl_sm_nx_mode_support = pnccsr_pw_support[1] && (pnccsr_pwo !== 3'b010 && pnccsr_pwo !== 3'b011 
					&& (~pnccsr_pwo[0] || (pnccsr_pwo[0] && pnccsr_pwo[1])));

	    end //}

	  end //}
	  else if (pl_sm_env_config.num_of_lanes == 8)
	  begin //{

	    pl_sm_nx_mode_support = pnccsr_epw_support[0] && (pnccsr_pwo !== 3'b010 && pnccsr_pwo !== 3'b011 && 
					(~pnccsr_pwo[0] || (pnccsr_pwo[0] && pnccsr_epwo[0])));

	  end //}
	  else if (pl_sm_env_config.num_of_lanes == 16)
	  begin //{

	    pl_sm_nx_mode_support = pnccsr_epw_support[1] && (pnccsr_pwo !== 3'b010 && pnccsr_pwo !== 3'b011 &&
					(~pnccsr_pwo[0] || (pnccsr_pwo[0] && pnccsr_epwo[1])));

	  end //}

	end //}
	else if (pl_sm_env_config.srio_mode == SRIO_GEN13)
	begin //{

	  if (pl_sm_env_config.num_of_lanes == 4)
	  begin //{

	    pl_sm_nx_mode_support = (pnccsr_pw_support == 2'b01) && 
					(pnccsr_pwo !== 3'b010 && pnccsr_pwo !== 3'b011);

	  end //}
	  else
	  begin //{

	    pl_sm_nx_mode_support = 0;

	  end //}

	end //}

      end //}

    end //}

  end //}

endtask : gen_pl_sm_nx_mode_support



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_pl_sm_2x_mode_support
/// Description : This method generates pl_sm_2x_mode_support variable based on either
/// config variable or by reading register model.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_pl_sm_2x_mode_support();

  if (bfm_or_mon)
  begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    begin //{
      pl_sm_2x_mode_support = 0;
      return;
    end //}
    else
      pl_sm_2x_mode_support = pl_sm_config.x2_mode_support;

  end //}
  else
  begin //{

    if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
    begin //{

      if (pl_sm_env_config.srio_mode == SRIO_GEN13)
      begin //{
        pl_sm_2x_mode_support = 0;
        return;
      end //}
      else
        pl_sm_2x_mode_support = pl_sm_config.x2_mode_support;

    end //}

  end //}

  forever begin //{

    if (bfm_or_mon)
    begin //{

      @(pl_sm_config.x2_mode_support);

      pl_sm_2x_mode_support = pl_sm_config.x2_mode_support;

    end //}
    else if (~bfm_or_mon)
    begin //{

	// if the monitor interface type is BFM, it means, it monitors
	// BFM's tx data, thus it matches DUT's behaviour. Hence, DUT's
	// register model has to be looked at inorder to decide which
	// mode is supported. On the other hand, if the interface type
	// is DUT, it means, the monitor monitors the DUT's tx data, thus
	// it behaves similar to the BFM. Hence, it is enough to look at
	// the BFM's config variable to decide on the mode supported.

      if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
      begin //{
	check_x2_mode_supp_for_dut_if = 1;
      end //}
      else if ((mon_type && pl_sm_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM))
      begin //{
	check_x2_mode_supp_for_dut_if = 0;
      end //}

      if (check_x2_mode_supp_for_dut_if)
      begin //{

      	@(pl_sm_config.x2_mode_support);

      	pl_sm_2x_mode_support = pl_sm_config.x2_mode_support;

      end //}
      else
      begin //{

	@(posedge srio_if.sim_clk);

	wait(port_width_registers_read.triggered);

	if (pl_sm_env_config.srio_mode == SRIO_GEN21)
	begin //{

	  pl_sm_2x_mode_support = pnccsr_pw_support[1] && (pnccsr_pwo !== 3'b010 && pnccsr_pwo !== 3'b011 
	    			&& (~pnccsr_pwo[0] || (pnccsr_pwo[0] && pnccsr_pwo[2])));

	end //}
	else if (pl_sm_env_config.srio_mode == SRIO_GEN22 || pl_sm_env_config.srio_mode == SRIO_GEN30)
	begin //{

	  pl_sm_2x_mode_support = pnccsr_pw_support[0] && (pnccsr_pwo !== 3'b010 && pnccsr_pwo !== 3'b011 
	    			&& (~pnccsr_pwo[0] || (pnccsr_pwo[0] && pnccsr_pwo[2])));

	end //}
	else if (pl_sm_env_config.srio_mode == SRIO_GEN13)
	begin //{

	  pl_sm_2x_mode_support = 0;

	end //}

      end //}

    end //}

  end //}

endtask : gen_pl_sm_2x_mode_support




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_dtonxm
/// Description : This method controls the assertion and deassertion logic for dtonxm state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_dtonxm();

  forever begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    begin //{

      @(pl_sm_trans.N_lanes_aligned);

      dtonxm = pl_sm_trans.N_lanes_aligned;

    end //}
    else
    begin //{

      // TODO: add the PWO register values in the below event wait statement.
      // because NX_mode_enabled also depends it.

      @(pl_sm_trans.N_lanes_ready);

      dtonxm = pl_sm_nx_mode_support & pl_sm_trans.N_lanes_ready;

    end //}

  end //}

endtask : gen_dtonxm


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_dto2xm
/// Description : This method controls the assertion and deassertion logic for dto2xm state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_dto2xm();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode != SRIO_GEN30)
      begin //{

        @(pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support or pl_sm_trans.N_lanes_ready or disc_timer_done);

        dto2xm = pl_sm_2x_mode_support & pl_sm_trans.two_lanes_ready & (~pl_sm_nx_mode_support | disc_timer_done & ~pl_sm_trans.N_lanes_ready);

      end //}
      else
      begin //{

        @(pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support or pl_sm_trans.N_lanes_ready or disc_timer_done or pl_sm_trans.from_sc_xmt_1x_mode);

        dto2xm = pl_sm_2x_mode_support & pl_sm_trans.two_lanes_ready & (~pl_sm_nx_mode_support | disc_timer_done)
		 & !pl_sm_trans.from_sc_xmt_1x_mode & !(pl_sm_nx_mode_support & pl_sm_trans.N_lanes_ready);

      end //}

    end //}

  end //}

endtask : gen_dto2xm


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_dto1xm0
/// Description : This method controls the assertion and deassertion logic for dto1xm0 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_dto1xm0();

  forever begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    begin //{

      @(disc_timer_done or pl_sm_trans.N_lanes_aligned or pl_sm_trans.lane_sync[0]);

      dto1xm0 = disc_timer_done & ~pl_sm_trans.N_lanes_aligned & pl_sm_trans.lane_sync[0];

    end //}
    else if (pl_sm_env_config.srio_mode == SRIO_GEN21)
    begin //{

      @(pl_sm_trans.lane_ready[0] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR or disc_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support);

      dto1xm0 = pl_sm_trans.lane_ready[0] & (pl_sm_force_1x_mode & ~pl_sm_force_1x_mode_laneR 
						| disc_timer_done & 
						((~pl_sm_nx_mode_support | ~pl_sm_trans.N_lanes_ready) 
						& ~pl_sm_trans.two_lanes_ready | ~pl_sm_trans.N_lanes_ready 
						& ~pl_sm_2x_mode_support));

    end //}
    else if (pl_sm_env_config.srio_mode == SRIO_GEN22)
    begin //{

      @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR or disc_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support);

      dto1xm0 = pl_sm_trans.lane_ready[0] & (pl_sm_force_1x_mode & (~pl_sm_force_1x_mode_laneR
						| pl_sm_force_1x_mode_laneR & disc_timer_done &
						~pl_sm_trans.lane_ready[1] & ~pl_sm_trans.lane_ready[2])
						| ~pl_sm_force_1x_mode & disc_timer_done &
						(~pl_sm_nx_mode_support | ~pl_sm_trans.N_lanes_ready)
						& (~pl_sm_2x_mode_support | ~pl_sm_trans.two_lanes_ready)
						);

    end //}
    else if (pl_sm_env_config.srio_mode == SRIO_GEN30)
    begin //{

      @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR or disc_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support or pl_sm_trans.from_sc_xmt_1x_mode);

      dto1xm0 = pl_sm_trans.lane_ready[0] & (pl_sm_force_1x_mode & (~pl_sm_force_1x_mode_laneR
						| pl_sm_force_1x_mode_laneR & disc_timer_done
						& !(pl_sm_trans.lane_ready[1] & pl_sm_2x_mode_support)
						& !(pl_sm_trans.lane_ready[2] & pl_sm_nx_mode_support))
						| ~pl_sm_force_1x_mode & disc_timer_done
						& !(pl_sm_nx_mode_support & pl_sm_trans.N_lanes_ready)
						& (!(pl_sm_2x_mode_support & pl_sm_trans.two_lanes_ready)
						| pl_sm_trans.two_lanes_ready & pl_sm_trans.from_sc_xmt_1x_mode)
						| ~pl_sm_2x_mode_support & ~pl_sm_nx_mode_support);

    end //}

  end //}

endtask : gen_dto1xm0


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_dto1xm1
/// Description : This method controls the assertion and deassertion logic for dto1xm1 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_dto1xm1();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode == SRIO_GEN21)
      begin //{

        @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR or disc_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support);

        dto1xm1 = pl_sm_trans.lane_ready[1] & ~pl_sm_trans.lane_ready[2] &
						(pl_sm_force_1x_mode & pl_sm_force_1x_mode_laneR 
          					| disc_timer_done & ~pl_sm_trans.lane_ready[0] &
          					((~pl_sm_nx_mode_support | ~pl_sm_trans.N_lanes_ready) 
          					& ~pl_sm_trans.two_lanes_ready | ~pl_sm_trans.N_lanes_ready 
          					& ~pl_sm_2x_mode_support));
	//$display($time, " : in dto1xm1 is %0d. disc_timer_done is %0d", dto1xm1, disc_timer_done);

      end //}
      else if (pl_sm_env_config.srio_mode == SRIO_GEN22)
      begin //{

        @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR or disc_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support);

        dto1xm1 = disc_timer_done & pl_sm_trans.lane_ready[1] & ~pl_sm_trans.lane_ready[2]
						 & (pl_sm_force_1x_mode & (~pl_sm_force_1x_mode_laneR
          					| pl_sm_force_1x_mode_laneR & disc_timer_done &
          					~pl_sm_trans.lane_ready[0])
          					| ~pl_sm_force_1x_mode & ~pl_sm_trans.lane_ready[0] &
          					(~pl_sm_nx_mode_support | ~pl_sm_trans.N_lanes_ready)
          					& (~pl_sm_2x_mode_support | ~pl_sm_trans.two_lanes_ready)
          					);

      end //}
      else if (pl_sm_env_config.srio_mode == SRIO_GEN30)
      begin //{

        @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR or disc_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support);

        dto1xm1 = pl_sm_trans.lane_ready[1] & (pl_sm_force_1x_mode & pl_sm_2x_mode_support 
					    & !(pl_sm_nx_mode_support & pl_sm_trans.lane_ready[2])
					    & (pl_sm_force_1x_mode_laneR & (!pl_sm_nx_mode_support | disc_timer_done & !pl_sm_trans.lane_ready[2])
					    | !pl_sm_force_1x_mode_laneR & disc_timer_done & !pl_sm_trans.lane_ready[0]
					    & !(pl_sm_nx_mode_support & pl_sm_trans.lane_ready[2])) | !pl_sm_force_1x_mode
					    & pl_sm_2x_mode_support & !(pl_sm_nx_mode_support & pl_sm_trans.lane_ready[2])
					    & disc_timer_done & !pl_sm_trans.lane_ready[0]
					    );

      end //}

    end //}

  end //}

endtask : gen_dto1xm1



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_dto1xm2
/// Description : This method controls the assertion and deassertion logic for dto1xm2 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_dto1xm2();

  forever begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    begin //{

      @(disc_timer_done or pl_sm_trans.N_lanes_aligned or pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[2]);

      dto1xm2 = disc_timer_done & ~pl_sm_trans.N_lanes_aligned & ~pl_sm_trans.lane_sync[0] & pl_sm_trans.lane_sync[2];

    end //}
    else if (pl_sm_env_config.srio_mode == SRIO_GEN21)
    begin //{

      @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[2] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR or disc_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support);

      dto1xm2 = pl_sm_trans.lane_ready[2] & (pl_sm_force_1x_mode & pl_sm_force_1x_mode_laneR 
        					| disc_timer_done & ~pl_sm_trans.lane_ready[0] &
        					((~pl_sm_nx_mode_support | ~pl_sm_trans.N_lanes_ready) 
        					& ~pl_sm_trans.two_lanes_ready | ~pl_sm_trans.N_lanes_ready 
        					& ~pl_sm_2x_mode_support));

    end //}
    else if (pl_sm_env_config.srio_mode == SRIO_GEN22)
    begin //{

      @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[2] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR or disc_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support);

      dto1xm2 = pl_sm_trans.lane_ready[2] & (pl_sm_force_1x_mode & (~pl_sm_force_1x_mode_laneR
        					| pl_sm_force_1x_mode_laneR & disc_timer_done &
        					~pl_sm_trans.lane_ready[0])
        					| ~pl_sm_force_1x_mode & disc_timer_done &
						~pl_sm_trans.lane_ready[0] &
        					(~pl_sm_nx_mode_support | ~pl_sm_trans.N_lanes_ready)
        					& (~pl_sm_2x_mode_support | ~pl_sm_trans.two_lanes_ready)
        					);

    end //}
    else if (pl_sm_env_config.srio_mode == SRIO_GEN30)
    begin //{

      @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[2] or pl_sm_force_1x_mode or pl_sm_force_1x_mode_laneR or disc_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.two_lanes_ready or pl_sm_2x_mode_support or pl_sm_nx_mode_support);

      dto1xm2 = pl_sm_trans.lane_ready[2] & (pl_sm_force_1x_mode & pl_sm_nx_mode_support
        					& (pl_sm_force_1x_mode_laneR | !pl_sm_force_1x_mode_laneR
        					& disc_timer_done & !pl_sm_trans.lane_ready[0]) | !pl_sm_force_1x_mode
        					& pl_sm_nx_mode_support & disc_timer_done & !pl_sm_trans.lane_ready[0]
        					);

    end //}

  end //}

endtask : gen_dto1xm2


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_dtosl
/// Description : This method controls the assertion and deassertion logic for dtosl state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_dtosl();

  forever begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    begin //{

      @(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[2]);

      dtosl = (pl_sm_trans.current_init_state == DISCOVERY) ? ~pl_sm_trans.lane_sync[0] & ~pl_sm_trans.lane_sync[2] : 0;

    end //}
    else if (pl_sm_env_config.srio_mode != SRIO_GEN30)
    begin //{

      @(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2] or pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or disc_timer_done);

      dtosl = (pl_sm_trans.current_init_state == DISCOVERY) ? ~pl_sm_trans.lane_sync[0] & ~pl_sm_trans.lane_sync[1] & ~pl_sm_trans.lane_sync[2]
		| disc_timer_done & ~pl_sm_trans.lane_ready[0] & ~pl_sm_trans.lane_ready[1] & 
		~pl_sm_trans.lane_ready[2] : 0;

    end //}
    else if (pl_sm_env_config.srio_mode == SRIO_GEN30)
    begin //{

      @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or disc_timer_done or pl_sm_2x_mode_support or pl_sm_nx_mode_support or pl_sm_force_1x_mode);

      dtosl = (pl_sm_trans.current_init_state == DISCOVERY) ? disc_timer_done & !pl_sm_trans.lane_ready[0]
			& !(pl_sm_trans.lane_ready[1] & (pl_sm_2x_mode_support | pl_sm_force_1x_mode & pl_sm_2x_mode_support))
			& !(pl_sm_trans.lane_ready[2] & (pl_sm_nx_mode_support | pl_sm_force_1x_mode & pl_sm_nx_mode_support)) : 0;

    end //}

  end //}

endtask : gen_dtosl


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxmtod
/// Description : This method controls the assertion and deassertion logic for nxmtod state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxmtod();

  if (pl_sm_env_config.srio_mode != SRIO_GEN30)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode == SRIO_GEN13)
      begin //{

        @(pl_sm_trans.N_lanes_aligned or pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[2]);

        nxmtod = (pl_sm_trans.current_init_state == NX_MODE) ? ~pl_sm_trans.N_lanes_aligned & (pl_sm_trans.lane_sync[0] | pl_sm_trans.lane_sync[2]) : 0;

      end //}
      else
      begin //{

        @(pl_sm_trans.N_lanes_ready or pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[2]);

        nxmtod = (pl_sm_trans.current_init_state == NX_MODE) ? ~pl_sm_trans.N_lanes_ready & (pl_sm_trans.lane_sync[0] | pl_sm_trans.lane_sync[2]) : 0;

      end //}

    end //}

  end //}

endtask : gen_nxmtod


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxmtosl
/// Description : This method controls the assertion and deassertion logic for nxmtosl state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxmtosl();

  forever begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    begin //{

      @(pl_sm_trans.N_lanes_aligned or pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[2] or pl_sm_trans.force_reinit);

      nxmtosl = (pl_sm_trans.current_init_state == NX_MODE) ? (~pl_sm_trans.N_lanes_aligned & !pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[2])
		| pl_sm_trans.force_reinit : 0;

    end //}
    else if (pl_sm_env_config.srio_mode != SRIO_GEN30)
    begin //{

      @(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[2]);

      nxmtosl = (pl_sm_trans.current_init_state == NX_MODE) ? ~pl_sm_trans.lane_sync[0] & ~pl_sm_trans.lane_sync[2] : 0;

    end //}
    else if (pl_sm_env_config.srio_mode == SRIO_GEN30)
    begin //{

      @(pl_sm_trans.lane_sync[0]  or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2] or pl_sm_2x_mode_support);

      nxmtosl = (pl_sm_trans.current_init_state == NX_MODE) ? ~pl_sm_trans.lane_sync[0] & !(pl_sm_trans.lane_sync[1] & pl_sm_2x_mode_support) & ~pl_sm_trans.lane_sync[2] : 0;

    end //}

  end //}

endtask : gen_nxmtosl



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_2xmto2xr
/// Description : This method controls the assertion and deassertion logic for x2mtox2r state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_2xmto2xr();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode != SRIO_GEN30)
      begin //{

      	@(pl_sm_trans.two_lanes_ready or pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[1] or pl_sm_trans.x1_mode_detected or pl_sm_trans.current_init_state);

      	x2mtox2r = (pl_sm_trans.current_init_state == X2_MODE) ? !pl_sm_trans.two_lanes_ready & (pl_sm_trans.lane_sync[0] | pl_sm_trans.lane_sync[1])
			| pl_sm_trans.two_lanes_ready & pl_sm_trans.x1_mode_detected : 0;

      end //}
      else
      begin //{

      	@(pl_sm_trans.two_lanes_ready or pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[1] or pl_sm_trans.from_sc_xmt_1x_mode or pl_sm_trans.current_init_state);

      	x2mtox2r = (pl_sm_trans.current_init_state == X2_MODE) ? !pl_sm_trans.two_lanes_ready & (pl_sm_trans.lane_sync[0] | pl_sm_trans.lane_sync[1])
			| pl_sm_trans.two_lanes_ready & pl_sm_trans.from_sc_xmt_1x_mode : 0;

      end //}

    end //}

  end //}

endtask : gen_2xmto2xr



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_2xmtosl
/// Description : This method controls the assertion and deassertion logic for x2mtosl state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_2xmtosl();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      @(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[1]);

      x2mtosl = (pl_sm_trans.current_init_state == X2_MODE) ? !pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[1] : 0;

    end //}

  end //}

endtask : gen_2xmtosl



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_2xrto1xm0
/// Description : This method controls the assertion and deassertion logic for x2rto1xm0 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_2xrto1xm0();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode != SRIO_GEN30)
      begin //{

      	@(disc_timer_done or pl_sm_trans.two_lanes_ready or pl_sm_trans.lane_ready[0] or pl_sm_trans.x1_mode_detected);

      	x2rto1xm0 = disc_timer_done & !pl_sm_trans.two_lanes_ready & pl_sm_trans.lane_ready[0]
			| pl_sm_trans.two_lanes_ready & pl_sm_trans.x1_mode_detected;

      end //}
      else
      begin //{

	// TODO: Set xmting_idle in monitor and also get it generated from active tx part.
      	@(recovery_timer_done or pl_sm_trans.two_lanes_ready or pl_sm_trans.lane_ready[0] or pl_sm_trans.from_sc_xmt_1x_mode or pl_sm_trans.xmting_idle or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

      	x2rto1xm0 = (recovery_timer_done & !pl_sm_trans.two_lanes_ready & pl_sm_trans.lane_ready[0]
			| pl_sm_trans.two_lanes_ready & pl_sm_trans.from_sc_xmt_1x_mode) 
			& pl_sm_trans.xmting_idle & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);

      end //}

    end //}

  end //}

endtask : gen_2xrto1xm0


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_2xrto1xm1
/// Description : This method controls the assertion and deassertion logic for x2rto1xm1 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_2xrto1xm1();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode != SRIO_GEN30)
      begin //{

      	@(disc_timer_done or pl_sm_trans.two_lanes_ready or pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1]);

      	x2rto1xm1 = disc_timer_done & !pl_sm_trans.two_lanes_ready & 
			!pl_sm_trans.lane_ready[0] & pl_sm_trans.lane_ready[1];
	//$display($time, " : in x2rtom1 is %0d. disc_timer_done is %0d", x2rto1xm1, disc_timer_done);

      end //}
      else
      begin //{

      	@(recovery_timer_done  or pl_sm_trans.two_lanes_ready or pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.xmting_idle or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

      	x2rto1xm1 = (recovery_timer_done & !pl_sm_trans.two_lanes_ready & 
			!pl_sm_trans.lane_ready[0] & pl_sm_trans.lane_ready[1]) 
			& pl_sm_trans.xmting_idle & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);
	//$display($time, " : in x2rtom1 is %0d. recovery_timer_done is %0d", x2rto1xm1, recovery_timer_done);

      end //}

    end //}

  end //}

endtask : gen_2xrto1xm1



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_2xrto2xm
/// Description : This method controls the assertion and deassertion logic for x2rto2xm state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_2xrto2xm();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode != SRIO_GEN30)
      begin //{

      	@(pl_sm_trans.two_lanes_ready or pl_sm_trans.x1_mode_detected);

      	x2rtox2m = pl_sm_trans.two_lanes_ready & !pl_sm_trans.x1_mode_detected;

      end //}
      else
      begin //{

      	@(pl_sm_trans.two_lanes_ready or pl_sm_trans.from_sc_xmt_1x_mode or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

      	x2rtox2m = pl_sm_trans.two_lanes_ready & !pl_sm_trans.from_sc_xmt_1x_mode & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);

      end //}

    end //}

  end //}

endtask : gen_2xrto2xm


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_2xrtosl
/// Description : This method controls the assertion and deassertion logic for x2rtosl state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_2xrtosl();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode != SRIO_GEN30)
      begin //{

      	@(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or disc_timer_done);

      	x2rtosl = (pl_sm_trans.current_init_state == X2_RECOVERY) ? !pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[1]
		| disc_timer_done & !pl_sm_trans.lane_ready[0] & !pl_sm_trans.lane_ready[1] : 0;

      end //}
      else
      begin //{

      	@(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or recovery_timer_done);

      	x2rtosl = (pl_sm_trans.current_init_state == X2_RECOVERY) ? !pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[1]
		| recovery_timer_done & !pl_sm_trans.lane_ready[0] & !pl_sm_trans.lane_ready[1] : 0;

      end //}

    end //}

  end //}

endtask : gen_2xrtosl


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xm0to1xr
/// Description : This method controls the assertion and deassertion logic for x1m0tox1r state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xm0to1xr();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      @(pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_sync[0]);

      x1m0tox1r = !pl_sm_trans.lane_ready[0] & pl_sm_trans.lane_sync[0];

    end //}

  end //}

endtask : gen_1xm0to1xr



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xm0tosl
/// Description : This method controls the assertion and deassertion logic for x1m0tosl state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xm0tosl();

  forever begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    begin //{

      @(pl_sm_trans.force_reinit or pl_sm_trans.lane_sync[0]);

      x1m0tosl = (pl_sm_trans.current_init_state == X1_M0) ? !pl_sm_trans.lane_sync[0] | pl_sm_trans.force_reinit : 0;

    end //}
    else
    begin //{

      @(pl_sm_trans.lane_sync[0]);

      x1m0tosl = (pl_sm_trans.current_init_state == X1_M0) ? !pl_sm_trans.lane_sync[0] : 0;

    end //}

  end //}

endtask : gen_1xm0tosl



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xm1to1xr
/// Description : This method controls the assertion and deassertion logic for x1m1tox1r state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xm1to1xr();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      @(pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_sync[1]);

      x1m1tox1r = !pl_sm_trans.lane_ready[1] & pl_sm_trans.lane_sync[1];

    end //}

  end //}

endtask : gen_1xm1to1xr



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xm1tosl
/// Description : This method controls the assertion and deassertion logic for x1m1tosl state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xm1tosl();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

  forever begin //{

    @(pl_sm_trans.lane_sync[1]);

    x1m1tosl = (pl_sm_trans.current_init_state == X1_M1) ? !pl_sm_trans.lane_sync[1] : 0;

    end //}

  end //}

endtask : gen_1xm1tosl



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xm2to1xr
/// Description : This method controls the assertion and deassertion logic for x1m2tox1r state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xm2to1xr();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      @(pl_sm_trans.lane_ready[2] or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2]);

      x1m2tox1r = !pl_sm_trans.lane_ready[2] & (pl_sm_trans.lane_sync[1] | pl_sm_trans.lane_sync[2]);

    end //}

  end //}

endtask : gen_1xm2to1xr



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xm2tosl
/// Description : This method controls the assertion and deassertion logic for x1m2tosl state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xm2tosl();

  forever begin //{

    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    begin //{

      @(pl_sm_trans.force_reinit or pl_sm_trans.lane_sync[2]);

      x1m2tosl = (pl_sm_trans.current_init_state == X1_M2) ? !pl_sm_trans.lane_sync[2] | pl_sm_trans.force_reinit : 0;

    end //}
    else
    begin //{

      @(pl_sm_trans.lane_sync[2] or pl_sm_trans.lane_sync[1]);

      x1m2tosl = (pl_sm_trans.current_init_state == X1_M2) ? !pl_sm_trans.lane_sync[2] & !pl_sm_trans.lane_sync[1] : 0;

    end //}

  end //}

endtask : gen_1xm2tosl


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xrto1xm0
/// Description : This method controls the assertion and deassertion logic for x1rtox1m0 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xrto1xm0();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode != SRIO_GEN30)
      begin //{

      	@(disc_timer_done or pl_sm_trans.lane_ready[0] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2);

      	x1rtox1m0 = !disc_timer_done & !pl_sm_trans.receive_lane1 &
			!pl_sm_trans.receive_lane2 & pl_sm_trans.lane_ready[0];

      end //}
      else
      begin //{

      	@(recovery_timer_done or pl_sm_trans.lane_ready[0] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2 or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

      	x1rtox1m0 = (pl_sm_trans.current_init_state == X1_RECOVERY) ? !recovery_timer_done & !pl_sm_trans.receive_lane1 &
			!pl_sm_trans.receive_lane2 & pl_sm_trans.lane_ready[0] & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain) : 0;

      end //}

    end //}

  end //}

endtask : gen_1xrto1xm0



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xrto1xm1
/// Description : This method controls the assertion and deassertion logic for x1rtox1m1 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xrto1xm1();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode == SRIO_GEN21)
      begin //{

        @(disc_timer_done or pl_sm_trans.lane_ready[1] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2);

        x1rtox1m1 = disc_timer_done & pl_sm_trans.lane_ready[1] &
			(pl_sm_trans.receive_lane1 | pl_sm_trans.receive_lane2);

      end //}
      else if (pl_sm_env_config.srio_mode == SRIO_GEN22)
      begin //{

        @(disc_timer_done or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2);

        x1rtox1m1 = !disc_timer_done & pl_sm_trans.lane_ready[1] &
			(pl_sm_trans.receive_lane1 | pl_sm_trans.receive_lane2 & pl_sm_trans.lane_ready[2]);

      end //}
      else if (pl_sm_env_config.srio_mode == SRIO_GEN30)
      begin //{

        @(recovery_timer_done or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2 or pl_sm_2x_mode_support or pl_sm_force_1x_mode or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

        x1rtox1m1 = !recovery_timer_done & (pl_sm_trans.receive_lane1 | pl_sm_trans.receive_lane2 & !pl_sm_trans.lane_ready[2]
		 	& (pl_sm_2x_mode_support | pl_sm_force_1x_mode & pl_sm_2x_mode_support)) & pl_sm_trans.lane_ready[1]
			 & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);

      end //}

    end //}

  end //}

endtask : gen_1xrto1xm1



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xrto1xm2
/// Description : This method controls the assertion and deassertion logic for x1rtox1m2 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xrto1xm2();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode != SRIO_GEN30)
      begin //{

      	@(disc_timer_done or pl_sm_trans.lane_ready[2] or pl_sm_trans.receive_lane2);

      	x1rtox1m2 = !disc_timer_done & pl_sm_trans.receive_lane2 & pl_sm_trans.lane_ready[2];

      end //}
      else
      begin //{

      	@(recovery_timer_done or pl_sm_trans.lane_ready[2] or pl_sm_trans.receive_lane2 or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

      	x1rtox1m2 = !recovery_timer_done & pl_sm_trans.receive_lane2 & pl_sm_trans.lane_ready[2]
			 & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);

      end //}

    end //}

  end //}

endtask : gen_1xrto1xm2



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1xrtosl
/// Description : This method controls the assertion and deassertion logic for x1rtosl state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1xrtosl();

  if (pl_sm_env_config.srio_mode != SRIO_GEN13)
  begin //{

    forever begin //{

      if (pl_sm_env_config.srio_mode == SRIO_GEN21)
      begin //{

        @(disc_timer_done or pl_sm_trans.lane_sync[0]  or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2);

        x1rtosl = (pl_sm_trans.current_init_state == X1_RECOVERY) ? !pl_sm_trans.receive_lane1 & !pl_sm_trans.receive_lane2 & !pl_sm_trans.lane_sync[0]
			| pl_sm_trans.receive_lane1 & !pl_sm_trans.lane_sync[1]
			| pl_sm_trans.receive_lane2 & !pl_sm_trans.lane_sync[2]
			| disc_timer_done : 0;

      end //}
      else if (pl_sm_env_config.srio_mode == SRIO_GEN22)
      begin //{

        @(disc_timer_done or pl_sm_trans.lane_sync[0]  or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2]);

        x1rtosl = (pl_sm_trans.current_init_state == X1_RECOVERY) ? !pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[1] & !pl_sm_trans.lane_sync[2]
			| disc_timer_done : 0;

      end //}
      else if (pl_sm_env_config.srio_mode == SRIO_GEN30)
      begin //{

        @(recovery_timer_done or pl_sm_trans.lane_sync[0]  or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2]);

        x1rtosl = (pl_sm_trans.current_init_state == X1_RECOVERY) ? !pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[1] & !pl_sm_trans.lane_sync[2]
			| recovery_timer_done : 0;

      end //}


    end //}

  end //}

endtask : gen_1xrtosl



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxmtonxr
/// Description : This method controls the assertion and deassertion logic for nxmtonxr state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxmtonxr();

  forever begin //{

    @(pl_sm_trans.N_lanes_ready or pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2] or pl_sm_2x_mode_support);

    nxmtonxr = !pl_sm_trans.N_lanes_ready & (pl_sm_trans.lane_sync[0] | (pl_sm_trans.lane_sync[1]
			& pl_sm_2x_mode_support) | pl_sm_trans.lane_sync[2]);

  end //}

endtask : gen_nxmtonxr



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxrto1xm0
/// Description : This method controls the assertion and deassertion logic for nxrto1xm0 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxrto1xm0();

  forever begin //{

    @(recovery_timer_done or pl_sm_trans.N_lanes_ready or pl_sm_trans.lane_ready[0] or pl_sm_trans.two_lanes_ready or pl_sm_trans.from_sc_xmt_1x_mode or pl_sm_2x_mode_support or pl_sm_trans.xmting_idle or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

    nxrto1xm0 = recovery_timer_done & pl_sm_trans.lane_ready[0] & !pl_sm_trans.N_lanes_ready
			& (!(pl_sm_2x_mode_support & pl_sm_trans.two_lanes_ready)
			| pl_sm_trans.two_lanes_ready & pl_sm_trans.from_sc_xmt_1x_mode)
			& pl_sm_trans.xmting_idle & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);

  end //}

endtask : gen_nxrto1xm0




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxrto1xm1
/// Description : This method controls the assertion and deassertion logic for nxrto1xm1 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxrto1xm1();

  forever begin //{

    @(recovery_timer_done or pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_2x_mode_support or pl_sm_trans.xmting_idle or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

    nxrto1xm1 = recovery_timer_done & !pl_sm_trans.lane_ready[2] & !pl_sm_trans.lane_ready[0]
			& pl_sm_trans.lane_ready[1] & pl_sm_2x_mode_support 
			& pl_sm_trans.xmting_idle & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);

  end //}

endtask : gen_nxrto1xm1




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxrto1xm2
/// Description : This method controls the assertion and deassertion logic for nxrto1xm2 state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxrto1xm2();

  forever begin //{

    @(recovery_timer_done or pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[2] or pl_sm_trans.xmting_idle or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

    nxrto1xm2 = recovery_timer_done & pl_sm_trans.lane_ready[2] & !pl_sm_trans.lane_ready[0]
			& pl_sm_trans.xmting_idle & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);

  end //}

endtask : gen_nxrto1xm2




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxrto2xm
/// Description : This method controls the assertion and deassertion logic for nxrto2xm state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxrto2xm();

  forever begin //{

    @(recovery_timer_done or pl_sm_trans.two_lanes_ready or pl_sm_trans.N_lanes_ready or pl_sm_2x_mode_support or pl_sm_trans.from_sc_xmt_1x_mode or pl_sm_trans.xmting_idle or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

    nxrto2xm = pl_sm_2x_mode_support & pl_sm_trans.two_lanes_ready & recovery_timer_done
			& !pl_sm_trans.from_sc_xmt_1x_mode & !pl_sm_trans.N_lanes_ready
			& pl_sm_trans.xmting_idle & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);

  end //}

endtask : gen_nxrto2xm




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxrtonxm
/// Description : This method controls the assertion and deassertion logic for nxrtonxm state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxrtonxm();

  forever begin //{

    @(pl_sm_trans.N_lanes_ready or pl_sm_trans.retrain or pl_sm_trans.recovery_retrain);

    nxrtonxm = pl_sm_trans.N_lanes_ready & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain);

  end //}

endtask : gen_nxrtonxm




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxrtonxtr
/// Description : This method controls the assertion and deassertion logic for nxrtonxtr state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxrtonxtr();

  forever begin //{

    @(pl_sm_trans.retrain or pl_sm_trans.recovery_retrain or pl_sm_trans.current_init_state);

    nxrtonxtr = (pl_sm_trans.current_init_state == NX_RECOVERY) ? pl_sm_trans.retrain & !pl_sm_trans.recovery_retrain : 0;

  end //}

endtask : gen_nxrtonxtr




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxrtosl
/// Description : This method controls the assertion and deassertion logic for nxrtosl state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxrtosl();

  forever begin //{

    @(pl_sm_trans.lane_sync[0] or pl_sm_trans.lane_sync[1] or pl_sm_trans.lane_sync[2] or recovery_timer_done or pl_sm_trans.lane_ready[0] or pl_sm_trans.lane_ready[1] or pl_sm_trans.lane_ready[2] or pl_sm_2x_mode_support)

    nxrtosl = !pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[2] & !(pl_sm_trans.lane_sync[1] & pl_sm_2x_mode_support)
		| recovery_timer_done & !pl_sm_trans.lane_ready[0] & !pl_sm_trans.lane_ready[2] & !(pl_sm_trans.lane_ready[1] & pl_sm_2x_mode_support); 

  end //}

endtask : gen_nxrtosl




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nxmtoam
/// Description : This method controls the assertion and deassertion logic for nxrtoam state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nxmtoam();

  forever begin //{

    @(pl_sm_asym_mode_en or pl_sm_trans.from_sc_asym_mode_en or pl_sm_trans.port_initialized or pl_sm_trans.from_sc_initialized or pl_sm_trans.from_sc_rcv_width_int or pl_sm_trans.N_lanes_ready);

    nxmtoam = pl_sm_asym_mode_en & pl_sm_trans.from_sc_asym_mode_en & pl_sm_trans.port_initialized
		& pl_sm_trans.from_sc_initialized & ((pl_sm_trans.from_sc_rcv_width_int == 4) || (pl_sm_trans.from_sc_rcv_width_int == 8) || (pl_sm_trans.from_sc_rcv_width_int == 16)) & pl_sm_trans.N_lanes_ready;

  end //}

endtask : gen_nxmtoam




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_x2mtoam
/// Description : This method controls the assertion and deassertion logic for x2mtoam state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_x2mtoam();

  forever begin //{

    @(pl_sm_asym_mode_en or pl_sm_trans.from_sc_asym_mode_en or pl_sm_trans.port_initialized or pl_sm_trans.from_sc_initialized or pl_sm_trans.from_sc_rcv_width_int or pl_sm_trans.two_lanes_ready or pl_sm_trans.from_sc_xmt_1x_mode);

    x2mtoam = pl_sm_asym_mode_en & pl_sm_trans.from_sc_asym_mode_en & pl_sm_trans.port_initialized
		& pl_sm_trans.from_sc_initialized & (pl_sm_trans.from_sc_rcv_width_int == 2) 
		& pl_sm_trans.two_lanes_ready & !pl_sm_trans.from_sc_xmt_1x_mode;

  end //}

endtask : gen_x2mtoam



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_x2rtox2tr
/// Description : This method controls the assertion and deassertion logic for x2rtox2tr state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_x2rtox2tr();

  forever begin //{

    @(pl_sm_trans.retrain or pl_sm_trans.recovery_retrain or pl_sm_trans.current_init_state);

    x2rtox2tr = (pl_sm_trans.current_init_state == X2_RECOVERY) ? pl_sm_trans.retrain & !pl_sm_trans.recovery_retrain : 0;

  end //}

endtask : gen_x2rtox2tr




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_x1rtox1tr
/// Description : This method controls the assertion and deassertion logic for x1rtox1tr state
/// machine variable based on the mode in which env is configured.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_x1rtox1tr();

  forever begin //{

    @(pl_sm_trans.retrain or pl_sm_trans.recovery_retrain or pl_sm_trans.current_init_state);

    x1rtox1tr = (pl_sm_trans.current_init_state == X1_RECOVERY) ? pl_sm_trans.retrain & !pl_sm_trans.recovery_retrain : 0;

  end //}

endtask : gen_x1rtox1tr




/////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : initialization_sm
/// Description : This method is the initialization state machine. The state transition conditions
/// and other state variables assignments are done based on the mode in which env is configured.
/////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::initialization_sm();


  pl_sm_trans.current_init_state = SILENT;

  if (~bfm_or_mon)
    current_init_state_q.push_back(pl_sm_trans.current_init_state);

  disc_timer_start = 0;
  silence_timer_start = 0;
  pl_sm_trans.lanes02_drvr_oe = 0;
  pl_sm_trans.port_initialized = 0;
  pl_sm_trans.Nx_mode= 0;
  pl_sm_trans.x2_mode= 0;
  pl_sm_trans.receive_lane1 = 0;
  pl_sm_trans.receive_lane2 = 0;
  pl_sm_trans.force_reinit = 0;
  pl_sm_trans.idle_detected = 0;

  if (bfm_or_mon)
    pl_sm_env_config.idle_detected = 0;


  if (~bfm_or_mon)
  begin //{

    pl_sm_common_mon_trans.port_initialized[mon_type] = 1;

    pl_sm_common_mon_trans.idle_selection_done[mon_type] = 0;
    pl_sm_common_mon_trans.port_initialized[mon_type] = 0;
    pl_sm_common_mon_trans.current_init_state[mon_type] = SILENT;

    if (mon_type)
      pl_sm_env_config.pl_tx_mon_init_sm_state = SILENT;
    else
      pl_sm_env_config.pl_rx_mon_init_sm_state = SILENT;

  end //}

  if (pl_sm_env_config.srio_mode == SRIO_GEN13)
    pl_sm_trans.lanes13_drvr_oe = 0;
  else
  begin //{
    pl_sm_trans.lanes01_drvr_oe = 0;
    pl_sm_trans.N_lanes_drvr_oe = 0;
  end //}

  forever begin //{

    @(negedge srio_if.sim_clk or negedge srio_if.srio_rst_n or posedge pl_sm_trans.force_reinit);

    if (~srio_if.srio_rst_n || pl_sm_trans.force_reinit)
    begin //{

      if (pl_sm_trans.force_reinit)
	-> pl_sm_trans.force_reinit_set;

      prev_init_state = pl_sm_trans.current_init_state;

      pl_sm_trans.current_init_state = SILENT;
      disc_timer_start = 0;
      disc_timer_done = 0;
      silence_timer_start = 0;
      silence_timer_done = 0;
      pl_sm_trans.lanes02_drvr_oe = 0;
      pl_sm_trans.port_initialized = 0;
      pl_sm_trans.Nx_mode= 0;
      pl_sm_trans.x2_mode= 0;
      pl_sm_trans.receive_lane1 = 0;
      pl_sm_trans.receive_lane2 = 0;
      pl_sm_trans.force_reinit = 0;
      pl_sm_trans.idle_detected = 0;
      pl_sm_trans.max_width = "0x";

      if (bfm_or_mon)
        pl_sm_env_config.idle_detected = 0;

      if (~bfm_or_mon)
        pl_sm_common_mon_trans.idle_selection_done[mon_type] = 0;

      if (pl_sm_env_config.srio_mode == SRIO_GEN13)
        pl_sm_trans.lanes13_drvr_oe = 0;
      else
      begin //{
        pl_sm_trans.lanes01_drvr_oe = 0;
        pl_sm_trans.N_lanes_drvr_oe = 0;
      end //}

      if (pl_sm_env_config.srio_mode == SRIO_GEN30)
      begin //{
        pl_sm_trans.lane0_drvr_oe = 0;
        pl_sm_trans.asym_mode = 0;
        pl_sm_trans.receive_enable_pi = 0;
        pl_sm_trans.transmit_enable_pi = 0;
        pl_sm_trans.recovery_retrain = 0;
      end //}

      if (~bfm_or_mon)
      begin //{

        if (mon_type)
          pl_sm_env_config.pl_tx_mon_init_sm_state = SILENT;
        else
          pl_sm_env_config.pl_rx_mon_init_sm_state = SILENT;

      end //}

      if (~bfm_or_mon && prev_init_state != pl_sm_trans.current_init_state)
        current_init_state_q.push_back(pl_sm_trans.current_init_state);

    end //}
    else
    begin //{

      //`uvm_info("SRIO_PL_STATE_MACHINE : INIT_SM ", $sformatf(" Present init state is %0s", pl_sm_trans.current_init_state.name()), UVM_LOW)

      prev_init_state = pl_sm_trans.current_init_state;

      case (pl_sm_trans.current_init_state)

	SILENT	: begin //{

		    dtosl = 0;
		    x1rtosl = 0;

      		    disc_timer_start = 0;
      		    disc_timer_done = 0;
      		    pl_sm_trans.lanes02_drvr_oe = 0;
      		    pl_sm_trans.port_initialized = 0;
      		    pl_sm_trans.Nx_mode= 0;
      		    pl_sm_trans.x2_mode= 0;
      		    pl_sm_trans.receive_lane1 = 0;
      		    pl_sm_trans.receive_lane2 = 0;
      		    pl_sm_trans.force_reinit = 0;
  		    pl_sm_trans.idle_detected = 0;
      		    pl_sm_trans.max_width = "0x";

      		    if (bfm_or_mon)
      		      pl_sm_env_config.idle_detected = 0;

      		    if (~bfm_or_mon)
      		      pl_sm_common_mon_trans.idle_selection_done[mon_type] = 0;

      		    silence_timer_start = 1;

      		    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
      		      pl_sm_trans.lanes13_drvr_oe = 0;
      		    else
		    begin //{
      		      pl_sm_trans.lanes01_drvr_oe = 0;
      		      pl_sm_trans.N_lanes_drvr_oe = 0;
		    end //}

      		    if (pl_sm_env_config.srio_mode == SRIO_GEN30)
      		    begin //{
      		      pl_sm_trans.lane0_drvr_oe = 0;
      		      pl_sm_trans.asym_mode = 0;
      		      pl_sm_trans.receive_enable_pi = 0;
      		      pl_sm_trans.transmit_enable_pi = 0;
      		      pl_sm_trans.recovery_retrain = 0;
      		    end //}

		    if (sltosk)
		    begin //{
		      sltosk = 0;
		      pl_sm_trans.current_init_state = SEEK;
		    end //}
		    else
		    begin //{
		      pl_sm_trans.current_init_state = SILENT;
		    end //}

		  end //}

	SEEK	: begin //{

		    silence_timer_start = 0;
		    silence_timer_done = 0;

		    pl_sm_trans.receive_lane1 = 0;
		    pl_sm_trans.receive_lane2 = 0;

      		    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
      		      pl_sm_trans.lanes02_drvr_oe = 1;
      		    else if (pl_sm_env_config.srio_mode == SRIO_GEN21 || pl_sm_env_config.srio_mode == SRIO_GEN22)
      		      pl_sm_trans.lanes02_drvr_oe = pl_sm_nx_mode_support | !pl_sm_2x_mode_support;
      		    else if (pl_sm_env_config.srio_mode == SRIO_GEN30)
      		      pl_sm_trans.lanes02_drvr_oe = pl_sm_nx_mode_support | (pl_sm_force_1x_mode & pl_sm_nx_mode_support);

      		    if (pl_sm_env_config.srio_mode == SRIO_GEN21 || pl_sm_env_config.srio_mode == SRIO_GEN22)
      		      pl_sm_trans.lanes01_drvr_oe = pl_sm_2x_mode_support;
      		    else if (pl_sm_env_config.srio_mode == SRIO_GEN30)
      		      pl_sm_trans.lanes01_drvr_oe = pl_sm_2x_mode_support | (pl_sm_force_1x_mode & pl_sm_2x_mode_support);

		    if (pl_sm_env_config.srio_mode == SRIO_GEN30)
      		      pl_sm_trans.lane0_drvr_oe = !pl_sm_2x_mode_support & !pl_sm_nx_mode_support;

		    if (sktod)
		    begin //{
		      sktod = 0;
		      pl_sm_trans.current_init_state = DISCOVERY;
		    end //}
		    else if (skto1xm0)
		    begin //{
		      skto1xm0 = 0;
		      pl_sm_trans.current_init_state = X1_M0;
		    end //}
		    else if (skto1xm2)
		    begin //{
		      skto1xm2 = 0;
		      pl_sm_trans.current_init_state = X1_M2;
		    end //}
		    

		  end //}

	DISCOVERY : begin //{

		      pl_sm_trans.port_initialized = 0;
		      pl_sm_trans.Nx_mode = 0;

		      pl_sm_trans.receive_lane1 = 0;
		      pl_sm_trans.receive_lane2 = 0;

		      if (pl_sm_env_config.srio_mode == SRIO_GEN13)
			pl_sm_trans.lanes13_drvr_oe = 1;
		      else
			pl_sm_trans.N_lanes_drvr_oe = pl_sm_nx_mode_support;

		      disc_timer_start = 1;

		      if (dtonxm)
		      begin //{
			//dtonxm = 0;
			pl_sm_trans.current_init_state = NX_MODE;
		      end //}
		      else if (dto2xm)
		      begin //{
			//dto2xm = 0;
			pl_sm_trans.current_init_state = X2_MODE;
		      end //}
		      else if (dto1xm0)
		      begin //{
			//dto1xm0 = 0;
			pl_sm_trans.current_init_state = X1_M0;
		      end //}
		      else if (dto1xm1)
		      begin //{
			//dto1xm1 = 0;
			pl_sm_trans.current_init_state = X1_M1;
		      end //}
		      else if (dto1xm2)
		      begin //{
			//dto1xm2 = 0;
			pl_sm_trans.current_init_state = X1_M2;
		      end //}
		      else if (dtosl)
		      begin //{
			//dtosl = 0;
			pl_sm_trans.current_init_state = SILENT;
		      end //}

		    end //}

	NX_MODE	: begin //{

		    dtonxm = 0;

		    disc_timer_start = 0;
		    disc_timer_done = 0;

		    pl_sm_trans.receive_lane1 = 0;
		    pl_sm_trans.receive_lane2 = 0;

		    pl_sm_trans.Nx_mode = 1;

		    if (pl_sm_env_config.num_of_lanes == 4)
		      pl_sm_trans.max_width = "4x";
		    else if (pl_sm_env_config.num_of_lanes == 8)
		      pl_sm_trans.max_width = "8x";
		    else if (pl_sm_env_config.num_of_lanes == 16)
		      pl_sm_trans.max_width = "16x";

		    pl_sm_trans.port_initialized = 1;

		    if (pl_sm_env_config.srio_mode == SRIO_GEN30)
		    begin //{

		      nxrtonxm = 0;

		      pl_sm_trans.receive_enable_pi = 1;
		      pl_sm_trans.transmit_enable_pi = 1;
		      pl_sm_trans.recovery_retrain = 0;

		      recovery_timer_start = 0;
		      recovery_timer_done = 0;

		    end //}

		    if (nxmtod)
		    begin //{
		      nxmtod = 0;
		      pl_sm_trans.current_init_state = DISCOVERY;
		    end //}
		    else if (nxmtosl)
		    begin //{
		      nxmtosl = 0;
		      pl_sm_trans.current_init_state = SILENT;
		    end //}
		    else if (nxmtonxr)
		    begin //{
		      nxmtonxr = 0;
		      pl_sm_trans.current_init_state = NX_RECOVERY;
		    end //}
		    else if (nxmtoam)
		    begin //{
		      nxmtoam = 0;
		      pl_sm_trans.current_init_state = ASYM_MODE;
		    end //}

		  end //}

	NX_RECOVERY : begin //{

			recovery_timer_start = 1;

			pl_sm_trans.port_initialized = 0;
			pl_sm_trans.Nx_mode = 0;

		    	pl_sm_trans.receive_lane1 = 0;
		    	pl_sm_trans.receive_lane2 = 0;

		    	if (pl_sm_env_config.srio_mode == SRIO_GEN30)
		    	begin //{

		    	  pl_sm_trans.receive_enable_pi = 0;
		    	  pl_sm_trans.transmit_enable_pi = 0;

		    	end //}

			if (nxrtonxm)
			begin //{
			  //nxrtonxm = 0;
			  pl_sm_trans.current_init_state = NX_MODE;
			end //}
			if (nxrto2xm)
			begin //{
			  nxrto2xm = 0;
			  pl_sm_trans.current_init_state = X2_MODE;
			end //}
			else if (nxrto1xm0)
			begin //{
			  nxrto1xm0 = 0;
			  pl_sm_trans.current_init_state = X1_M0;
			end //}
			else if (nxrto1xm1)
			begin //{
			  nxrto1xm1 = 0;
			  pl_sm_trans.current_init_state = X1_M1;
			end //}
			else if (nxrto1xm2)
			begin //{
			  nxrto1xm2 = 0;
			  pl_sm_trans.current_init_state = X1_M2;
			end //}
			else if (nxrtosl)
			begin //{
			  nxrtosl = 0;
			  pl_sm_trans.current_init_state = SILENT;
			end //}
			else if (nxrtonxtr)
			begin //{
			  //nxrtonxtr = 0;
			  pl_sm_trans.current_init_state = NX_RETRAIN;
			end //}

		      end //}

	NX_RETRAIN :  begin //{

			nxrtonxtr = 0;

			pl_sm_trans.recovery_retrain = 1;

			pl_sm_trans.current_init_state = NX_RECOVERY;

		      end //}

	X2_MODE	: begin //{

		    dto2xm = 0;

		    disc_timer_start = 0;
		    disc_timer_done = 0;

		    pl_sm_trans.receive_lane1 = 0;
		    pl_sm_trans.receive_lane2 = 0;

		    pl_sm_trans.lanes02_drvr_oe = 0;
		    pl_sm_trans.N_lanes_drvr_oe = 0;
		    pl_sm_trans.x2_mode = 1;

		    pl_sm_trans.max_width = "2x";

		    pl_sm_trans.port_initialized = 1;

		    if (pl_sm_env_config.srio_mode == SRIO_GEN30)
		    begin //{

		      x2rtox2m = 0;

		      pl_sm_trans.receive_enable_pi = 1;
		      pl_sm_trans.transmit_enable_pi = 1;
		      pl_sm_trans.recovery_retrain = 0;

		      recovery_timer_start = 0;
		      recovery_timer_done = 0;

		    end //}

		    if (x2mtox2r)
		    begin //{
		      x2mtox2r = 0;
		      pl_sm_trans.current_init_state = X2_RECOVERY;
		    end //}
		    else if (x2mtosl)
		    begin //{
		      x2mtosl = 0;
		      pl_sm_trans.current_init_state = SILENT;
		    end //}
		    else if (x2mtoam)
		    begin //{
		      x2mtoam = 0;
		      pl_sm_trans.current_init_state = ASYM_MODE;
		    end //}

		  end //}

	X2_RECOVERY : begin //{

			if (pl_sm_env_config.srio_mode == SRIO_GEN30)
			  recovery_timer_start = 1;
			else
			  disc_timer_start = 1;

			pl_sm_trans.port_initialized = 0;
			pl_sm_trans.x2_mode = 0;

		    	pl_sm_trans.receive_lane1 = 0;
		    	pl_sm_trans.receive_lane2 = 0;

		    	if (pl_sm_env_config.srio_mode == SRIO_GEN30)
		    	begin //{

		    	  pl_sm_trans.receive_enable_pi = 0;
		    	  pl_sm_trans.transmit_enable_pi = 0;

		    	end //}

			if (x2rtox2m)
			begin //{

		    	  if (pl_sm_env_config.srio_mode != SRIO_GEN30)
			    x2rtox2m = 0;

			  pl_sm_trans.current_init_state = X2_MODE;

			end //}
			else if (x2rto1xm0)
			begin //{
			  //x2rto1xm0 = 0;
			  pl_sm_trans.current_init_state = X1_M0;
			end //}
			else if (x2rto1xm1)
			begin //{
			  x2rto1xm1 = 0;
			  pl_sm_trans.current_init_state = X1_M1;
			end //}
			else if (x2rtosl)
			begin //{
			  x2rtosl = 0;
			  pl_sm_trans.current_init_state = SILENT;
			end //}
			else if (x2rtox2tr)
			begin //{
			  //x2rtox2tr = 0;
			  pl_sm_trans.current_init_state = X2_RETRAIN;
			end //}

		      end //}

	X2_RETRAIN :  begin //{

			x2rtox2tr = 0;

			pl_sm_trans.recovery_retrain = 1;

			pl_sm_trans.current_init_state = X2_RECOVERY;

		      end //}

	X1_M0	: begin //{

		    dto1xm0 = 0;
		    x1rtox1m0 = 0;
		    x2rto1xm0 = 0;

		    disc_timer_start = 0;
		    disc_timer_done = 0;

		    pl_sm_trans.receive_lane1 = 0;
		    pl_sm_trans.receive_lane2 = 0;

		    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
		      pl_sm_trans.lanes13_drvr_oe = 0;
		    else
		      pl_sm_trans.N_lanes_drvr_oe = 0;

		    pl_sm_trans.max_width = "1x";

		    pl_sm_trans.port_initialized = 1;

		    if (pl_sm_env_config.srio_mode == SRIO_GEN30)
		    begin //{

		      pl_sm_trans.receive_enable_pi = 1;
		      pl_sm_trans.transmit_enable_pi = 1;
		      pl_sm_trans.recovery_retrain = 0;

		      recovery_timer_start = 0;
		      recovery_timer_done = 0;

		    end //}

		    if (x1m0tox1r)
		    begin //{
		      x1m0tox1r = 0;
		      pl_sm_trans.current_init_state = X1_RECOVERY;
		    end //}
		    else if (x1m0tosl)
		    begin //{
		      x1m0tosl = 0;
		      pl_sm_trans.current_init_state = SILENT;
		    end //}

		  end //}

	X1_M1	: begin //{

		    dto1xm1 = 0;
		    x1rtox1m1 = 0;

		    disc_timer_start = 0;
		    disc_timer_done = 0;

		    pl_sm_trans.receive_lane1 = 1;
		    pl_sm_trans.receive_lane2 = 0;

		    pl_sm_trans.N_lanes_drvr_oe = 0;

		    pl_sm_trans.max_width = "1x";

		    pl_sm_trans.port_initialized = 1;

		    if (pl_sm_env_config.srio_mode == SRIO_GEN30)
		    begin //{

		      pl_sm_trans.receive_enable_pi = 1;
		      pl_sm_trans.transmit_enable_pi = 1;
		      pl_sm_trans.recovery_retrain = 0;

		      recovery_timer_start = 0;
		      recovery_timer_done = 0;

		    end //}

		    if (x1m1tox1r)
		    begin //{
		      x1m1tox1r = 0;
		      pl_sm_trans.current_init_state = X1_RECOVERY;
		    end //}
		    else if (x1m1tosl)
		    begin //{
		      x1m1tosl = 0;
		      pl_sm_trans.current_init_state = SILENT;
		    end //}

		  end //}

	X1_M2	: begin //{

		    dto1xm2 = 0;
		    x1rtox1m2 = 0;

		    disc_timer_start = 0;
		    disc_timer_done = 0;

		    pl_sm_trans.receive_lane1 = 0;
		    pl_sm_trans.receive_lane2 = 1;

		    if (pl_sm_env_config.srio_mode == SRIO_GEN13)
		      pl_sm_trans.lanes13_drvr_oe = 0;
		    else
		      pl_sm_trans.N_lanes_drvr_oe = 0;

		    pl_sm_trans.max_width = "1x";

		    pl_sm_trans.port_initialized = 1;

		    if (pl_sm_env_config.srio_mode == SRIO_GEN30)
		    begin //{

		      pl_sm_trans.receive_enable_pi = 1;
		      pl_sm_trans.transmit_enable_pi = 1;
		      pl_sm_trans.recovery_retrain = 0;

		      recovery_timer_start = 0;
		      recovery_timer_done = 0;

		    end //}

		    if (x1m2tox1r)
		    begin //{
		      x1m2tox1r = 0;
		      pl_sm_trans.current_init_state = X1_RECOVERY;
		    end //}
		    else if (x1m2tosl)
		    begin //{
		      x1m2tosl = 0;
		      pl_sm_trans.current_init_state = SILENT;
		    end //}

		  end //}

	X1_RECOVERY : begin //{

		    	if (pl_sm_env_config.srio_mode == SRIO_GEN30)
			  recovery_timer_start = 1;
		    	else
			  disc_timer_start = 1;

			pl_sm_trans.port_initialized = 0;

		    	if (pl_sm_env_config.srio_mode == SRIO_GEN30)
		    	begin //{

		    	  pl_sm_trans.receive_enable_pi = 0;
		      	  pl_sm_trans.transmit_enable_pi = 0;

		    	end //}

			if (x1rtox1m0)
			begin //{
			  //x1rtox1m0 = 0;
			  pl_sm_trans.current_init_state = X1_M0;
			end //}
			else if (x1rtox1m1)
			begin //{
			  //x1rtox1m1 = 0;
			  pl_sm_trans.current_init_state = X1_M1;
			end //}
			else if (x1rtox1m2)
			begin //{
			  //x1rtox1m2 = 0;
			  pl_sm_trans.current_init_state = X1_M2;
			end //}
			else if (x1rtosl)
			begin //{
			  //x1rtosl = 0;
			  pl_sm_trans.current_init_state = SILENT;
			end //}
			else if (x1rtox1tr)
			begin //{
			  //x1rtox1tr = 0;
			  pl_sm_trans.current_init_state = X1_RETRAIN;
			end //}

		      end //}

	X1_RETRAIN :  begin //{

			x1rtox1tr = 0;

			pl_sm_trans.recovery_retrain = 1;

			pl_sm_trans.current_init_state = X1_RECOVERY;

		      end //}

	ASYM_MODE :  begin //{

			pl_sm_trans.asym_mode = 1;

			if (pl_sm_trans.end_asym_mode)
			  pl_sm_trans.current_init_state = SILENT;

		      end //}

      endcase

      if (prev_init_state != pl_sm_trans.current_init_state)
      begin //{

        `uvm_info("SRIO_PL_STATE_MACHINE : INIT_SM ", $sformatf(" Next init state is %0s", pl_sm_trans.current_init_state.name()), UVM_LOW)

	if (~bfm_or_mon && mon_type && pl_sm_env_config.srio_tx_mon_if == BFM)
	  $fdisplay(pl_sm_env_config.file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " LINK PARTNER ENTERED INTO %0s STATE\n", pl_sm_trans.current_init_state.name());
	else if (~bfm_or_mon && mon_type && pl_sm_env_config.srio_tx_mon_if == DUT)
	  $fdisplay(pl_sm_env_config.file_h, "==> @%0t", $time, " BFM ENTERED INTO %0s STATE\n", pl_sm_trans.current_init_state.name());
	
	if (~bfm_or_mon && ~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM)
	  $fdisplay(pl_sm_env_config.file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " LINK PARTNER ENTERED INTO %0s STATE\n", pl_sm_trans.current_init_state.name());
	else if (~bfm_or_mon && ~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT)
	  $fdisplay(pl_sm_env_config.file_h, "==> @%0t", $time, " BFM ENTERED INTO %0s STATE\n", pl_sm_trans.current_init_state.name());
	
      end //}

      if (~bfm_or_mon && prev_init_state != pl_sm_trans.current_init_state)
        current_init_state_q.push_back(pl_sm_trans.current_init_state);

    end //}

    if (~bfm_or_mon)
    begin //{

      pl_sm_common_mon_trans.port_initialized[mon_type] = pl_sm_trans.port_initialized;
      pl_sm_common_mon_trans.current_init_state[mon_type] = pl_sm_trans.current_init_state;

      if (mon_type)
	pl_sm_env_config.pl_tx_mon_init_sm_state = pl_sm_trans.current_init_state;
      else
	pl_sm_env_config.pl_rx_mon_init_sm_state = pl_sm_trans.current_init_state;

	//$display($time, " 3: pl_sm_trans.port_initialized is %0d", pl_sm_trans.port_initialized);
	//$display($time, " 3: pl_sm_common_mon_trans.port_initialized[%0d] is %0d", mon_type, pl_sm_common_mon_trans.port_initialized[mon_type]);

    end //}

  end //}

endtask : initialization_sm




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : x1_x2_mode_detect_sm
/// Description : 1x_2x mode detect state machine used for non GEN3.0 models. The method
/// doesn't wait for clock edge for intermediate state transitions which only performs counter
/// increments/decrements. It only waits for the clock edge to get the next character.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::x1_x2_mode_detect_sm();

  //int D_counter;

  #1;
  if (~srio_if.srio_rst_n)
  begin //{

    D_counter = 3;
    pl_sm_trans.x1_mode_detected = 0;

    curr_mode_detect_state = INITIALIZE;

    if (~bfm_or_mon)
      curr_mode_detect_state_q.push_back(curr_mode_detect_state);

  end //}

  forever begin //{

    if (!(prev_mode_detect_state == INITIALIZE && curr_mode_detect_state == GET_COLUMN) && !(prev_mode_detect_state == X1_DELIMITER && curr_mode_detect_state == GET_COLUMN)&& !(prev_mode_detect_state == X2_DELIMITER && curr_mode_detect_state == GET_COLUMN)&& !(prev_mode_detect_state == SET_1X_MODE && curr_mode_detect_state == GET_COLUMN)&& !(prev_mode_detect_state == SET_2X_MODE && curr_mode_detect_state == GET_COLUMN))
      @(negedge srio_if.sim_clk or negedge srio_if.srio_rst_n or negedge pl_sm_trans.two_lanes_aligned);

    if (~srio_if.srio_rst_n || ~pl_sm_trans.two_lanes_aligned)
    begin //{

      prev_mode_detect_state = curr_mode_detect_state;

      D_counter = 3;
      pl_sm_trans.x1_mode_detected = 0;
      curr_mode_detect_state = INITIALIZE;

      if (~bfm_or_mon && prev_mode_detect_state != curr_mode_detect_state)
	curr_mode_detect_state_q.push_back(curr_mode_detect_state);

    end //}
    else
    begin //{

      //`uvm_info("SRIO_PL_STATE_MACHINE : 1X_2X_MODE_DETECT_SM ", $sformatf(" Present x1_x2_mode_detect state is %0s", curr_mode_detect_state.name()), UVM_LOW)

      prev_mode_detect_state = curr_mode_detect_state;

      case (curr_mode_detect_state)

	INITIALIZE  : begin //{

			pl_sm_trans.x1_mode_detected = 0;
			D_counter = 3;

			if (pl_sm_trans.two_lanes_aligned)
			  curr_mode_detect_state = GET_COLUMN;
			else
			  curr_mode_detect_state = INITIALIZE;

		      end //}

	GET_COLUMN  : begin //{

  			if ((pl_sm_x2_align_data.character[0] == SRIO_SC || pl_sm_x2_align_data.character[0] == SRIO_PD) && pl_sm_x2_align_data.cntl[0])
			begin //{

  			  if ((pl_sm_x2_align_data.character[1] == SRIO_SC || pl_sm_x2_align_data.character[1] == SRIO_PD) && pl_sm_x2_align_data.cntl[1])
			  begin //{
			    pl_sm_trans.x1_mode_delimiter = 1;
			    pl_sm_trans.x2_mode_delimiter = 0;
			  end //}
  			  else
			  begin //{
			    pl_sm_trans.x1_mode_delimiter = 0;
			    pl_sm_trans.x2_mode_delimiter = 1;
			  end //}

			end //}
			else
			begin //{
			  pl_sm_trans.x1_mode_delimiter = 0;
			  pl_sm_trans.x2_mode_delimiter = 0;
			end //}


			if (pl_sm_trans.x1_mode_delimiter == 1)
			  curr_mode_detect_state = X1_DELIMITER;
			else if (pl_sm_trans.x2_mode_delimiter == 1)
			  curr_mode_detect_state = X2_DELIMITER;
			else
			  curr_mode_detect_state = GET_COLUMN;

		      end //}

	X1_DELIMITER :  begin //{

			  if (D_counter > 0)
			    D_counter--;

			  if (D_counter > 0)
			    curr_mode_detect_state = GET_COLUMN;
			  else
			    curr_mode_detect_state = SET_1X_MODE;

			end //}

	X2_DELIMITER :  begin //{

			  if (D_counter < 3)
			    D_counter++;

			  if (D_counter < 3)
			    curr_mode_detect_state = GET_COLUMN;
			  else
			    curr_mode_detect_state = SET_2X_MODE;

			end //}

	SET_1X_MODE  :  begin //{

			  pl_sm_trans.x1_mode_detected = 1;
			  curr_mode_detect_state = GET_COLUMN;

			end //}

	SET_2X_MODE  :  begin //{

			  pl_sm_trans.x1_mode_detected = 0;
			  curr_mode_detect_state = GET_COLUMN;

			end //}

      endcase

      //if (prev_mode_detect_state != curr_mode_detect_state && (curr_mode_detect_state == SET_1X_MODE || curr_mode_detect_state == SET_2X_MODE || prev_mode_detect_state == SET_1X_MODE || prev_mode_detect_state == SET_2X_MODE))
      //  `uvm_info("SRIO_PL_STATE_MACHINE : 1X_2X_MODE_DETECT_SM ", $sformatf(" Next x1_x2_mode_detect state is %0s", curr_mode_detect_state.name()), UVM_LOW)

      if (~bfm_or_mon && prev_mode_detect_state != curr_mode_detect_state)
	curr_mode_detect_state_q.push_back(curr_mode_detect_state);

    end //}

  end //}

endtask : x1_x2_mode_detect_sm




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : check_for_x2_sc_column
/// Description : This method detects STATUS/CONTROL control codeword column for GEN3.0
/// 2x align state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::check_for_x2_sc_column();

  x2_sc_col_detected = 0;
  x2_part_sc_col_detected = 0;

  for (int x2_sc_col_chk=0; x2_sc_col_chk<2; x2_sc_col_chk++)
  begin //{

    if (!pl_sm_x2_align_data.brc3_cntl_cw_type.exists(x2_sc_col_chk))
    begin //{
      x2_sc_col_detected = 0;
      break;
    end //}
  
    if (pl_sm_x2_align_data.brc3_cntl_cw_type[x2_sc_col_chk] == STATUS_CNTL)
    begin //{
      if(x2_sc_col_chk == 0)
        x2_sc_col_detected = 1;
      x2_part_sc_col_detected = 1;
    end //}
    else
    begin //{
      x2_sc_col_detected = 0;
    end //}

  end //}

  if (x2_sc_col_detected && x2_part_sc_col_detected)
    x2_part_sc_col_detected = 0;

endtask : check_for_x2_sc_column




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : check_for_nx_sc_column
/// Description : This method detects STATUS/CONTROL control codeword column for GEN3.0
/// Nx align state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::check_for_nx_sc_column();

  nx_sc_col_detected = 0;
  nx_part_sc_col_detected = 0;

  for (int nx_sc_col_chk=0; nx_sc_col_chk<pl_sm_env_config.num_of_lanes; nx_sc_col_chk++)
  begin //{

    if (!pl_sm_nx_align_data.brc3_cntl_cw_type.exists(nx_sc_col_chk))
    begin //{
      nx_sc_col_detected = 0;
      break;
    end //}
  
    if (pl_sm_nx_align_data.brc3_cntl_cw_type[nx_sc_col_chk] == STATUS_CNTL)
    begin //{
      if(nx_sc_col_chk == 0)
        nx_sc_col_detected = 1;
      nx_part_sc_col_detected = 1;
    end //}
    else
    begin //{
      nx_sc_col_detected = 0;
    end //}

  end //}

  if (nx_sc_col_detected && nx_part_sc_col_detected)
    nx_part_sc_col_detected = 0;

endtask : check_for_nx_sc_column




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_x2_align_sm
/// Description : 2x align state machine for GEN3.0 device.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen3_x2_align_sm();

  bit x2_sync_break;

  current_2x_align_state = NOT_ALIGNED;

  if (~bfm_or_mon)
    current_2x_align_state_q.push_back(current_2x_align_state);

  forever begin //{

    wait (pl_sm_trans.temp_2x_alignment_done == 1 && pl_sm_trans.x2_align_data_valid == 1);

    if (!(prev_2x_align_state == NOT_ALIGNED_3 && current_2x_align_state == NOT_ALIGNED_1) && !(prev_2x_align_state == NOT_ALIGNED_3 && current_2x_align_state == ALIGNED) && !(prev_2x_align_state == ALIGNED_3 && current_2x_align_state == ALIGNED_4) && !(prev_2x_align_state == ALIGNED_7 && current_2x_align_state == ALIGNED_4) && !(prev_2x_align_state == ALIGNED_7 && current_2x_align_state == ALIGNED))
      @(negedge srio_if.sim_clk or negedge srio_if.srio_rst_n);

    if (pl_sm_trans.temp_2x_alignment_done == 0 || pl_sm_trans.x2_align_data_valid == 0)
      continue;

    for (int x2_sm_lane_sync_chk = 0; x2_sm_lane_sync_chk<2; x2_sm_lane_sync_chk++)
    begin //{

      if (pl_sm_trans.lane_sync[x2_sm_lane_sync_chk] == 0)
      begin //{
	x2_sync_break = 1;
	break;
      end //}

    end //}

    if (~srio_if.srio_rst_n || x2_sync_break)
    begin //{

      prev_2x_align_state = current_2x_align_state;

      current_2x_align_state = NOT_ALIGNED;
      x2_sync_break = 0;
      pl_sm_trans.temp_2x_alignment_done = 0;
      temp_2_lanes_aligned = 0;
      x2_align_A_counter = 0;

      if (~bfm_or_mon && prev_2x_align_state != current_2x_align_state)
	current_2x_align_state_q.push_back(current_2x_align_state);

    end //}
    else
    begin //{

      //`uvm_info("SRIO_PL_STATE_MACHINE : 2X_ALIGN_SM", $sformatf(" temp_2_lanes_aligned is %0d. Present 2x align state is %0s", temp_2_lanes_aligned, current_2x_align_state.name()), UVM_LOW)

      prev_2x_align_state = current_2x_align_state;

      case (current_2x_align_state)

	NOT_ALIGNED : begin //{

			temp_2_lanes_aligned = 0;
      			pl_sm_trans.temp_2x_alignment_done = 0;
			x2_align_A_counter = 0;
			x2_sc_col_detected = 0;

    			for (int x2_sm_lane_sync_chk = 0; x2_sm_lane_sync_chk<2; x2_sm_lane_sync_chk++)
    			begin //{

    			  if (pl_sm_trans.lane_sync[x2_sm_lane_sync_chk] == 0)
    			  begin //{
    			    x2_sync_break = 1;
    			    break;
    			  end //}
			  else
    			  begin //{
    			    x2_sync_break = 0;
    			  end //}

    			end //}

			if (~x2_sync_break)
			  current_2x_align_state = NOT_ALIGNED_1;

		      end //}

	NOT_ALIGNED_1 : begin //{

			  check_for_x2_sc_column();

			  if(x2_sc_col_detected)
			    current_2x_align_state = NOT_ALIGNED_2;

			end //}

	NOT_ALIGNED_2 : begin //{

			  check_for_x2_sc_column();

			  if(x2_sc_col_detected)
			    current_2x_align_state = NOT_ALIGNED_3;
			  else
			    current_2x_align_state = NOT_ALIGNED;

			end //}

	NOT_ALIGNED_3 : begin //{

			  x2_align_A_counter++;

			  if(x2_align_A_counter < pl_sm_config.align_threshold)
			    current_2x_align_state = NOT_ALIGNED_1;
			  else
			    current_2x_align_state = ALIGNED;

			  //if (current_2x_align_state == NOT_ALIGNED)
			  //  pl_sm_trans.temp_2x_alignment_done = 0;

			end //}

	ALIGNED	: begin //{

		    temp_2_lanes_aligned = 1;
		    x2_align_MA_counter = 0;

		    check_for_x2_sc_column();

		    if(x2_sc_col_detected)
		      current_2x_align_state = ALIGNED_1;
		    else if(x2_part_sc_col_detected)
		      current_2x_align_state = ALIGNED_2;

		  end //}

	ALIGNED_1 : begin //{

		      temp_2_lanes_aligned = 1;

		      check_for_x2_sc_column();

		      if(x2_sc_col_detected)
		        current_2x_align_state = ALIGNED;
		      else
		        current_2x_align_state = ALIGNED_3;

		      //if (current_2x_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_2x_alignment_done = 0;

		    end //}

	ALIGNED_2 : begin //{

		      current_2x_align_state = ALIGNED_3;

		      //if (current_2x_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_2x_alignment_done = 0;

		    end //}

	ALIGNED_3 : begin //{

		      x2_align_A_counter = 0;
		      x2_align_MA_counter++;

		      if(x2_align_MA_counter < pl_sm_config.lane_misalignment_threshold)
		        current_2x_align_state = ALIGNED_4;
		      else
		        current_2x_align_state = NOT_ALIGNED;

		    end //}

	ALIGNED_4 : begin //{

		      check_for_x2_sc_column();

		      if(x2_sc_col_detected)
		        current_2x_align_state = ALIGNED_5;
		      else if(x2_part_sc_col_detected)
		        current_2x_align_state = ALIGNED_6;

		  end //}

	ALIGNED_5 : begin //{

		      check_for_x2_sc_column();

		      if(x2_sc_col_detected)
		        current_2x_align_state = ALIGNED_7;
		      else
		        current_2x_align_state = ALIGNED_3;

		      //if (current_2x_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_2x_alignment_done = 0;

		    end //}

	ALIGNED_6 : begin //{

		      current_2x_align_state = ALIGNED_3;

		      //if (current_2x_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_2x_alignment_done = 0;

		    end //}

	ALIGNED_7 : begin //{

		      x2_align_A_counter++;

		      if(x2_align_A_counter < pl_sm_config.align_threshold)
		        current_2x_align_state = ALIGNED_4;
		      else
		        current_2x_align_state = ALIGNED;

		      //if (current_2x_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_2x_alignment_done = 0;

		    end //}


      endcase

      //if (prev_2x_align_state != current_2x_align_state && (current_2x_align_state == ALIGNED || prev_2x_align_state == ALIGNED))
      //  `uvm_info("SRIO_PL_STATE_MACHINE : 2X_ALIGN_SM", $sformatf(" temp_2_lanes_aligned is %0d. Next 2x align state is %0s", temp_2_lanes_aligned, current_2x_align_state.name()), UVM_LOW)

      if (~bfm_or_mon && prev_2x_align_state != current_2x_align_state)
	current_2x_align_state_q.push_back(current_2x_align_state);

    end //}

  end //}

endtask : gen3_x2_align_sm



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_nx_align_sm
/// Description : Nx align state machine for GEN3.0 device.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen3_nx_align_sm();

  bit nx_sync_break;

  current_nx_align_state = NOT_ALIGNED;

  if (~bfm_or_mon)
    current_nx_align_state_q.push_back(current_nx_align_state);

  forever begin //{

    wait (pl_sm_trans.temp_nx_alignment_done == 1 && pl_sm_trans.nx_align_data_valid == 1);

    if (!(prev_nx_align_state == NOT_ALIGNED_3 && current_nx_align_state == NOT_ALIGNED_1) && !(prev_nx_align_state == NOT_ALIGNED_3 && current_nx_align_state == ALIGNED) && !(prev_nx_align_state == ALIGNED_3 && current_nx_align_state == ALIGNED_4) && !(prev_nx_align_state == ALIGNED_7 && current_nx_align_state == ALIGNED_4) && !(prev_nx_align_state == ALIGNED_7 && current_nx_align_state == ALIGNED))
      @(negedge srio_if.sim_clk or negedge srio_if.srio_rst_n);

    if(pl_sm_trans.temp_nx_alignment_done == 0 || pl_sm_trans.nx_align_data_valid == 0)
      continue;

    for (int nx_sm_lane_sync_chk = 0; nx_sm_lane_sync_chk<pl_sm_env_config.num_of_lanes; nx_sm_lane_sync_chk++)
    begin //{

      if (pl_sm_trans.lane_sync[nx_sm_lane_sync_chk] == 0)
      begin //{
	nx_sync_break = 1;
	break;
      end //}

    end //}

    if (~srio_if.srio_rst_n || nx_sync_break)
    begin //{

      prev_nx_align_state = current_nx_align_state;

      current_nx_align_state = NOT_ALIGNED;
      nx_sync_break = 0;
      pl_sm_trans.temp_nx_alignment_done = 0;
      pl_sm_trans.N_lanes_aligned = 0;
      nx_align_A_counter = 0;
      nx_sc_col_detected = 0;

      if (~bfm_or_mon && prev_nx_align_state != current_nx_align_state)
	current_nx_align_state_q.push_back(current_nx_align_state);

    end //}
    else
    begin //{

      //`uvm_info("SRIO_PL_STATE_MACHINE : NX_ALIGN_SM", $sformatf(" temp_nx_alignment_done is %0d. Present nx align state is %0s", pl_sm_trans.temp_nx_alignment_done, current_nx_align_state.name()), UVM_LOW)

      prev_nx_align_state = current_nx_align_state;

      case (current_nx_align_state)

	NOT_ALIGNED : begin //{

			pl_sm_trans.N_lanes_aligned = 0;
      			pl_sm_trans.temp_nx_alignment_done = 0;
			nx_align_A_counter = 0;
			nx_sc_col_detected = 0;

    			for (int nx_sm_lane_sync_chk = 0; nx_sm_lane_sync_chk<pl_sm_env_config.num_of_lanes; nx_sm_lane_sync_chk++)
    			begin //{

    			  if (pl_sm_trans.lane_sync[nx_sm_lane_sync_chk] == 0)
    			  begin //{
    			    nx_sync_break = 1;
    			    break;
    			  end //}
			  else
    			  begin //{
    			    nx_sync_break = 0;
    			  end //}

    			end //}

			if (~nx_sync_break)
			  current_nx_align_state = NOT_ALIGNED_1;

		      end //}

	NOT_ALIGNED_1 : begin //{

			  check_for_nx_sc_column();

			  if(nx_sc_col_detected)
			    current_nx_align_state = NOT_ALIGNED_2;

			end //}

	NOT_ALIGNED_2 : begin //{

			  check_for_nx_sc_column();

			  if(nx_sc_col_detected)
			    current_nx_align_state = NOT_ALIGNED_3;
			  else
			    current_nx_align_state = NOT_ALIGNED;

			end //}

	NOT_ALIGNED_3 : begin //{

			  nx_align_A_counter++;

			  if(nx_align_A_counter < pl_sm_config.align_threshold)
			    current_nx_align_state = NOT_ALIGNED_1;
			  else
			    current_nx_align_state = ALIGNED;

			  //if (current_nx_align_state == NOT_ALIGNED)
			  //  pl_sm_trans.temp_nx_alignment_done = 0;

			end //}

	ALIGNED	: begin //{

		    pl_sm_trans.N_lanes_aligned = 1;
		    nx_align_MA_counter = 0;

		    check_for_nx_sc_column();

		    if(nx_sc_col_detected)
		      current_nx_align_state = ALIGNED_1;
		    else if(nx_part_sc_col_detected)
		      current_nx_align_state = ALIGNED_2;

		  end //}

	ALIGNED_1 : begin //{

		      pl_sm_trans.N_lanes_aligned = 1;

		      check_for_nx_sc_column();

		      if(nx_sc_col_detected)
		        current_nx_align_state = ALIGNED;
		      else
		        current_nx_align_state = ALIGNED_3;

		      //if (current_nx_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_nx_alignment_done = 0;

		    end //}

	ALIGNED_2 : begin //{

		      current_nx_align_state = ALIGNED_3;

		      //if (current_nx_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_nx_alignment_done = 0;

		    end //}

	ALIGNED_3 : begin //{

		      nx_align_A_counter = 0;
		      nx_align_MA_counter++;

		      if(nx_align_MA_counter < pl_sm_config.lane_misalignment_threshold)
		        current_nx_align_state = ALIGNED_4;
		      else
		        current_nx_align_state = NOT_ALIGNED;

		    end //}

	ALIGNED_4 : begin //{

		      check_for_nx_sc_column();

		      if(nx_sc_col_detected)
		        current_nx_align_state = ALIGNED_5;
		      else if(nx_part_sc_col_detected)
		        current_nx_align_state = ALIGNED_6;

		  end //}

	ALIGNED_5 : begin //{

		      check_for_nx_sc_column();

		      if(nx_sc_col_detected)
		        current_nx_align_state = ALIGNED_7;
		      else
		        current_nx_align_state = ALIGNED_3;

		      //if (current_nx_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_nx_alignment_done = 0;

		    end //}

	ALIGNED_6 : begin //{

		      current_nx_align_state = ALIGNED_3;

		      //if (current_nx_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_nx_alignment_done = 0;

		    end //}

	ALIGNED_7 : begin //{

		      nx_align_A_counter++;

		      if(nx_align_A_counter < pl_sm_config.align_threshold)
		        current_nx_align_state = ALIGNED_4;
		      else
		        current_nx_align_state = ALIGNED;

		      //if (current_nx_align_state == NOT_ALIGNED)
		      //  pl_sm_trans.temp_nx_alignment_done = 0;

		    end //}


      endcase

      //if (prev_nx_align_state != current_nx_align_state && (current_nx_align_state == ALIGNED || prev_nx_align_state == ALIGNED))
      //  `uvm_info("SRIO_PL_STATE_MACHINE : NX_ALIGN_SM", $sformatf(" N_lanes_aligned is %0d. Next nx align state is %0s", pl_sm_trans.N_lanes_aligned, current_nx_align_state.name()), UVM_LOW)

      if (~bfm_or_mon && prev_nx_align_state != current_nx_align_state)
	current_nx_align_state_q.push_back(current_nx_align_state);

    end //}

  end //}

endtask : gen3_nx_align_sm



//////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_cw_retrain_timer
/// Description : This method runs the retrain timer for GEN3.0 device when retrain timer is enabled.
//////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen3_cw_retrain_timer();

  forever begin //{

    wait (pl_sm_trans.retrain_timer_en == 1);

    repeat (pl_sm_config.gen3_training_timer)
    begin //{

      if (pl_sm_trans.retrain_timer_en)
        @(posedge srio_if.sim_clk);
      else
        break;

    end //}

    if (pl_sm_trans.retrain_timer_en)
    begin //{
      pl_sm_trans.retrain_timer_done = 1;
    end //}

  ///< 5 clock delay given so that retrain_timer_done if set, can be sampled by the
  ///< state machine and move the state accordingly.
    repeat(5) @(posedge srio_if.sim_clk);
    pl_sm_trans.retrain_timer_done = 0;

    wait (pl_sm_trans.retrain_timer_en == 0);

  end //}

endtask : gen3_cw_retrain_timer



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_receive_enable
/// Description : This method controls the assertion and deassertion logic for receive_enable.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_receive_enable();

  forever begin //{

    @(pl_sm_trans.receive_enable_pi or pl_sm_trans.receive_enable_rw);

    pl_sm_trans.receive_enable = pl_sm_trans.receive_enable_pi & pl_sm_trans.receive_enable_rw;

  end //}

endtask : gen_receive_enable




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_transmit_enable
/// Description : This method controls the assertion and deassertion logic for transmit_enable.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_transmit_enable();

  forever begin //{

    @(pl_sm_trans.transmit_enable_pi or pl_sm_trans.transmit_enable_tw or pl_sm_trans.transmit_enable_rtwc);

    pl_sm_trans.transmit_enable = pl_sm_trans.transmit_enable_pi & pl_sm_trans.transmit_enable_tw & pl_sm_trans.transmit_enable_rtwc;

  end //}

endtask : gen_transmit_enable



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_retrain_pending
/// Description : This method controls the assertion and deassertion logic for retrain_pending
/// based on the max_width.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_retrain_pending();

  wait (pl_sm_trans.port_initialized == 1);

  forever begin //{

    if (pl_sm_trans.current_init_state == SILENT)
      wait (pl_sm_trans.port_initialized == 1);

    if (pl_sm_trans.max_width == "1x")
    begin //{

      @(pl_sm_trans.lane_degraded[0] or pl_sm_trans.lane_degraded[1] or pl_sm_trans.lane_degraded[2] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2 or pl_sm_config.retrain_en or pl_sm_trans.from_sc_retrain_en or pl_sm_trans.port_initialized or pl_sm_trans.from_sc_initialized);

      pl_sm_trans.retrain_pending = pl_sm_trans.lane_degraded[0] & (pl_sm_trans.max_width != "0x" & pl_sm_trans.max_width != "1x") 
					| (pl_sm_trans.max_width == "1x") & (pl_sm_trans.lane_degraded[0] 
					& (!pl_sm_trans.receive_lane1 & !pl_sm_trans.receive_lane2)
					| pl_sm_trans.lane_degraded[1] & pl_sm_trans.receive_lane1
					| pl_sm_trans.lane_degraded[2] & pl_sm_trans.receive_lane2)
					& pl_sm_config.retrain_en & pl_sm_trans.from_sc_retrain_en 
					& pl_sm_trans.port_initialized & pl_sm_trans.from_sc_initialized;

    end //}
    else if (pl_sm_trans.max_width == "2x")
    begin //{

      @(pl_sm_trans.lane_degraded[0] or pl_sm_trans.lane_degraded[1]  or pl_sm_trans.lane_degraded[2] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2 or pl_sm_config.retrain_en or pl_sm_trans.from_sc_retrain_en or pl_sm_trans.port_initialized or pl_sm_trans.from_sc_initialized);

      pl_sm_trans.retrain_pending = (pl_sm_trans.lane_degraded[0] | pl_sm_trans.lane_degraded[1]) & (pl_sm_trans.max_width != "0x" 
					& pl_sm_trans.max_width != "1x") | (pl_sm_trans.max_width == "1x")
					& (pl_sm_trans.lane_degraded[0] & (!pl_sm_trans.receive_lane1 & !pl_sm_trans.receive_lane2)
					| pl_sm_trans.lane_degraded[1] & pl_sm_trans.receive_lane1
					| pl_sm_trans.lane_degraded[2] & pl_sm_trans.receive_lane2)
					& pl_sm_config.retrain_en & pl_sm_trans.from_sc_retrain_en 
					& pl_sm_trans.port_initialized & pl_sm_trans.from_sc_initialized;

    end //}
    else if (pl_sm_trans.max_width == "4x")
    begin //{

      @(pl_sm_trans.lane_degraded[0] or pl_sm_trans.lane_degraded[1] or pl_sm_trans.lane_degraded[2] or pl_sm_trans.lane_degraded[3] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2 or pl_sm_config.retrain_en or pl_sm_trans.from_sc_retrain_en or pl_sm_trans.port_initialized or pl_sm_trans.from_sc_initialized);

      pl_sm_trans.retrain_pending = (pl_sm_trans.lane_degraded[0] | pl_sm_trans.lane_degraded[1] | pl_sm_trans.lane_degraded[2] 
					| pl_sm_trans.lane_degraded[3]) & (pl_sm_trans.max_width != "0x"
					& pl_sm_trans.max_width != "1x") | (pl_sm_trans.max_width == "1x")
					& (pl_sm_trans.lane_degraded[0] & (!pl_sm_trans.receive_lane1 & !pl_sm_trans.receive_lane2)
					| pl_sm_trans.lane_degraded[1] & pl_sm_trans.receive_lane1
					| pl_sm_trans.lane_degraded[2] & pl_sm_trans.receive_lane2)
					& pl_sm_config.retrain_en & pl_sm_trans.from_sc_retrain_en 
					& pl_sm_trans.port_initialized & pl_sm_trans.from_sc_initialized;

    end //}
    else if (pl_sm_trans.max_width == "8x")
    begin //{

      @(pl_sm_trans.lane_degraded[0] or pl_sm_trans.lane_degraded[1] or pl_sm_trans.lane_degraded[2] or pl_sm_trans.lane_degraded[3] or pl_sm_trans.lane_degraded[4] or pl_sm_trans.lane_degraded[5] or pl_sm_trans.lane_degraded[6] or pl_sm_trans.lane_degraded[7] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2 or pl_sm_config.retrain_en or pl_sm_trans.from_sc_retrain_en or pl_sm_trans.port_initialized or pl_sm_trans.from_sc_initialized);

      pl_sm_trans.retrain_pending = (pl_sm_trans.lane_degraded[0] | pl_sm_trans.lane_degraded[1] | pl_sm_trans.lane_degraded[2] 
					| pl_sm_trans.lane_degraded[3] | pl_sm_trans.lane_degraded[4] | pl_sm_trans.lane_degraded[5] 
					| pl_sm_trans.lane_degraded[6] | pl_sm_trans.lane_degraded[7]) & (pl_sm_trans.max_width != "0x"
					& pl_sm_trans.max_width != "1x") | (pl_sm_trans.max_width == "1x")
					& (pl_sm_trans.lane_degraded[0] & (!pl_sm_trans.receive_lane1 & !pl_sm_trans.receive_lane2)
					| pl_sm_trans.lane_degraded[1] & pl_sm_trans.receive_lane1
					| pl_sm_trans.lane_degraded[2] & pl_sm_trans.receive_lane2)
					& pl_sm_config.retrain_en & pl_sm_trans.from_sc_retrain_en 
					& pl_sm_trans.port_initialized & pl_sm_trans.from_sc_initialized;

    end //}
    else if (pl_sm_trans.max_width == "16x")
    begin //{

      @(pl_sm_trans.lane_degraded[0] or pl_sm_trans.lane_degraded[1] or pl_sm_trans.lane_degraded[2] or pl_sm_trans.lane_degraded[3] or pl_sm_trans.lane_degraded[4] or pl_sm_trans.lane_degraded[5] or pl_sm_trans.lane_degraded[6] or pl_sm_trans.lane_degraded[7] or pl_sm_trans.lane_degraded[8] or pl_sm_trans.lane_degraded[9] or pl_sm_trans.lane_degraded[10] or pl_sm_trans.lane_degraded[11] or pl_sm_trans.lane_degraded[12] or pl_sm_trans.lane_degraded[13] or pl_sm_trans.lane_degraded[14] or pl_sm_trans.lane_degraded[15] or pl_sm_trans.receive_lane1 or pl_sm_trans.receive_lane2 or pl_sm_config.retrain_en or pl_sm_trans.from_sc_retrain_en or pl_sm_trans.port_initialized or pl_sm_trans.from_sc_initialized);

      pl_sm_trans.retrain_pending = (pl_sm_trans.lane_degraded[0] | pl_sm_trans.lane_degraded[1] | pl_sm_trans.lane_degraded[2] 
					| pl_sm_trans.lane_degraded[3] | pl_sm_trans.lane_degraded[4] | pl_sm_trans.lane_degraded[5] 
					| pl_sm_trans.lane_degraded[6] | pl_sm_trans.lane_degraded[7] | pl_sm_trans.lane_degraded[8] 
					| pl_sm_trans.lane_degraded[9] | pl_sm_trans.lane_degraded[10] | pl_sm_trans.lane_degraded[11] 
					| pl_sm_trans.lane_degraded[12] | pl_sm_trans.lane_degraded[13] | pl_sm_trans.lane_degraded[14] 
					| pl_sm_trans.lane_degraded[15]) & (pl_sm_trans.max_width != "0x"
					& pl_sm_trans.max_width != "1x") | (pl_sm_trans.max_width == "1x")
					& (pl_sm_trans.lane_degraded[0] & (!pl_sm_trans.receive_lane1 & !pl_sm_trans.receive_lane2)
					| pl_sm_trans.lane_degraded[1] & pl_sm_trans.receive_lane1
					| pl_sm_trans.lane_degraded[2] & pl_sm_trans.receive_lane2)
					& pl_sm_config.retrain_en & pl_sm_trans.from_sc_retrain_en 
					& pl_sm_trans.port_initialized & pl_sm_trans.from_sc_initialized;

    end //}

  end //}

endtask : gen_retrain_pending



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_retraining
/// Description : This method controls the assertion and deassertion logic for retraining
/// based on the max_width.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_retraining();

  if (~bfm_or_mon)
  begin //{
    pl_sm_common_mon_trans.retraining[mon_type] = 1;
    pl_sm_common_mon_trans.retraining[mon_type] = 0;
  end //}

  wait (pl_sm_trans.port_initialized == 1);

  forever begin //{

    if (pl_sm_trans.current_init_state == SILENT)
      wait (pl_sm_trans.port_initialized == 1);

    if (pl_sm_trans.max_width == "1x")
    begin //{

      @(pl_sm_trans.lane_retraining[0] or pl_sm_trans.lane_retraining[1] or pl_sm_trans.lane_retraining[2]);

      pl_sm_trans.retraining = pl_sm_trans.lane_retraining[0] & (pl_sm_trans.max_width != "0x" & pl_sm_trans.max_width != "1x")
				| (pl_sm_trans.max_width == "1x") & (pl_sm_trans.lane_retraining[0]
				| pl_sm_trans.lane_retraining[1] | pl_sm_trans.lane_retraining[2]);

    end //}
    else if (pl_sm_trans.max_width == "2x")
    begin //{

      @(pl_sm_trans.lane_retraining[0] or pl_sm_trans.lane_retraining[1] or pl_sm_trans.lane_retraining[2]);

      pl_sm_trans.retraining = (pl_sm_trans.lane_retraining[0] | pl_sm_trans.lane_retraining[1]) & (pl_sm_trans.max_width != "0x" 
				& pl_sm_trans.max_width != "1x") | (pl_sm_trans.max_width == "1x") & (pl_sm_trans.lane_retraining[0]
				| pl_sm_trans.lane_retraining[1] | pl_sm_trans.lane_retraining[2]);

    end //}
    else if (pl_sm_trans.max_width == "4x")
    begin //{

      @(pl_sm_trans.lane_retraining[0] or pl_sm_trans.lane_retraining[1] or pl_sm_trans.lane_retraining[2] or pl_sm_trans.lane_retraining[3]);

      pl_sm_trans.retraining = (pl_sm_trans.lane_retraining[0] | pl_sm_trans.lane_retraining[1] 
				| pl_sm_trans.lane_retraining[2] | pl_sm_trans.lane_retraining[3]) & (pl_sm_trans.max_width != "0x" 
				& pl_sm_trans.max_width != "1x") | (pl_sm_trans.max_width == "1x") & (pl_sm_trans.lane_retraining[0]
				| pl_sm_trans.lane_retraining[1] | pl_sm_trans.lane_retraining[2]);

    end //}
    else if (pl_sm_trans.max_width == "8x")
    begin //{

      @(pl_sm_trans.lane_retraining[0] or pl_sm_trans.lane_retraining[1] or pl_sm_trans.lane_retraining[2] or pl_sm_trans.lane_retraining[3] or pl_sm_trans.lane_retraining[4] or pl_sm_trans.lane_retraining[5] or pl_sm_trans.lane_retraining[6] or pl_sm_trans.lane_retraining[7]);

      pl_sm_trans.retraining = (pl_sm_trans.lane_retraining[0] | pl_sm_trans.lane_retraining[1] | pl_sm_trans.lane_retraining[2] 
				| pl_sm_trans.lane_retraining[3] | pl_sm_trans.lane_retraining[4] | pl_sm_trans.lane_retraining[5] 
				| pl_sm_trans.lane_retraining[6] | pl_sm_trans.lane_retraining[7]) & (pl_sm_trans.max_width != "0x"
				& pl_sm_trans.max_width != "1x") | (pl_sm_trans.max_width == "1x") & (pl_sm_trans.lane_retraining[0]
				| pl_sm_trans.lane_retraining[1] | pl_sm_trans.lane_retraining[2]);

    end //}
    else if (pl_sm_trans.max_width == "16x")
    begin //{

      @(pl_sm_trans.lane_retraining[0] or pl_sm_trans.lane_retraining[1] or pl_sm_trans.lane_retraining[2] or pl_sm_trans.lane_retraining[3] or pl_sm_trans.lane_retraining[4] or pl_sm_trans.lane_retraining[5] or pl_sm_trans.lane_retraining[6] or pl_sm_trans.lane_retraining[7] or pl_sm_trans.lane_retraining[8] or pl_sm_trans.lane_retraining[9] or pl_sm_trans.lane_retraining[10] or pl_sm_trans.lane_retraining[11] or pl_sm_trans.lane_retraining[12] or pl_sm_trans.lane_retraining[13] or pl_sm_trans.lane_retraining[14] or pl_sm_trans.lane_retraining[15]);

      pl_sm_trans.retraining = (pl_sm_trans.lane_retraining[0] | pl_sm_trans.lane_retraining[1] | pl_sm_trans.lane_retraining[2] 
				| pl_sm_trans.lane_retraining[3] | pl_sm_trans.lane_retraining[4] | pl_sm_trans.lane_retraining[5] 
				| pl_sm_trans.lane_retraining[6] | pl_sm_trans.lane_retraining[7] | pl_sm_trans.lane_retraining[8] 
				| pl_sm_trans.lane_retraining[9] | pl_sm_trans.lane_retraining[10] | pl_sm_trans.lane_retraining[11] 
				| pl_sm_trans.lane_retraining[12] | pl_sm_trans.lane_retraining[13] | pl_sm_trans.lane_retraining[14] 
				| pl_sm_trans.lane_retraining[15]) & (pl_sm_trans.max_width != "0x" & pl_sm_trans.max_width != "1x")
				| (pl_sm_trans.max_width == "1x") & (pl_sm_trans.lane_retraining[0]
				| pl_sm_trans.lane_retraining[1] | pl_sm_trans.lane_retraining[2]);

    end //}

    if (~bfm_or_mon)
      pl_sm_common_mon_trans.retraining[mon_type] = pl_sm_trans.retraining;

  end //}

endtask : gen_retraining




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_cw_retraining_sm
/// Description : GEN3.0 "Retrain / Transmit width control" state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen3_cw_retraining_sm();

#1;
  if (~srio_if.srio_rst_n)
  begin //{

    current_cw_retrain_state = IDLE;

    if (~bfm_or_mon)
    begin //{

      pl_sm_common_mon_trans.retrain_ready[mon_type] = 1;
      pl_sm_common_mon_trans.retrain_ready[mon_type] = 0;

      pl_sm_common_mon_trans.retrain_grnt[mon_type] = 1;
      pl_sm_common_mon_trans.retrain_grnt[mon_type] = 0;

    end //}

    if (~bfm_or_mon)
      current_cw_retrain_state_q.push_back(current_cw_retrain_state);

  end //}

  forever
  begin //{

    @(negedge srio_if.sim_clk);

    if (pl_sm_trans.current_init_state == SILENT)
    begin //{

      prev_cw_retrain_state = current_cw_retrain_state;

      current_cw_retrain_state = IDLE;
      pl_sm_trans.retrain = 0;
      pl_sm_trans.retrain_grnt = 0;
      pl_sm_trans.retrain_ready = 0;
      pl_sm_trans.retrain_timer_en = 0;
      pl_sm_trans.xmt_width_grnt = 0;
      pl_sm_trans.transmit_enable_rtwc = 1;

      if (~bfm_or_mon && prev_cw_retrain_state != current_cw_retrain_state)
	current_cw_retrain_state_q.push_back(current_cw_retrain_state);

    end //}
    else
    begin //{

      prev_cw_retrain_state = current_cw_retrain_state;

      case (current_cw_retrain_state)

	IDLE 	: begin //{

      		    pl_sm_trans.retrain = 0;
      		    pl_sm_trans.retrain_grnt = 0;
      		    pl_sm_trans.retrain_ready = 0;
      		    pl_sm_trans.retrain_timer_en = 0;
      		    pl_sm_trans.xmt_width_grnt = 0;
      		    pl_sm_trans.transmit_enable_rtwc = 1;

		    if ((pl_sm_trans.retrain_pending | pl_sm_trans.from_sc_retrain_grnt & pl_sm_config.retrain_en) & pl_sm_trans.port_initialized)
		    begin //{
      		      current_cw_retrain_state = RETRAIN_0;
		    end //}
		    else if (pl_sm_trans.xmt_width_cmd_pending & !((pl_sm_trans.retrain_pending | pl_sm_trans.from_sc_retrain_grnt & pl_sm_config.retrain_en) & pl_sm_trans.port_initialized))
		    begin //{
      		      current_cw_retrain_state = XMT_WIDTH;
		    end //}

		  end //}

	XMT_WIDTH : begin //{

			  pl_sm_trans.xmt_width_grnt = 1;

		      	  if (!pl_sm_trans.xmt_width_cmd_pending)
		      	    current_cw_retrain_state = IDLE;

		    end //}

	RETRAIN_0 : begin //{

		      pl_sm_trans.retrain_grnt = 1;
		      pl_sm_trans.retrain_timer_en = 1;

		      if (pl_sm_trans.from_sc_retrain_grnt & !pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_1;
		      else if (pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_TIMEOUT;

		    end //}

	RETRAIN_1 : begin //{

		      pl_sm_trans.transmit_enable_rtwc = 0;

		      if (pl_sm_trans.xmting_idle & !pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_2;
		      else if (pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_TIMEOUT;

		    end //}

	RETRAIN_2 : begin //{

		      pl_sm_trans.retrain_ready = 1;

		      if (pl_sm_trans.from_sc_retrain_ready & !pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_3;
		      else if (pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_TIMEOUT;

		    end //}

	RETRAIN_3 : begin //{

		      pl_sm_trans.retrain_grnt = 0;

		      if (!pl_sm_trans.retraining & !pl_sm_trans.retrain_timer_done & !pl_sm_trans.from_sc_retrain_grnt)
		        current_cw_retrain_state = RETRAIN_4;
		      else if (pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_TIMEOUT;

		    end //}

	RETRAIN_4 : begin //{

		      pl_sm_trans.retrain = 1;

		      if (pl_sm_trans.retraining & !pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_5;
		      else if (pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_TIMEOUT;

		    end //}

	RETRAIN_5 : begin //{

		      pl_sm_trans.retrain = 0;
		      pl_sm_trans.retrain_ready = 0;

		      if (!pl_sm_trans.retraining & !pl_sm_trans.from_sc_retraining & !pl_sm_trans.from_sc_retrain_ready & pl_sm_trans.receive_enable)
		        current_cw_retrain_state = IDLE;
		      else if ((pl_sm_trans.retraining | pl_sm_trans.from_sc_retraining | pl_sm_trans.from_sc_retrain_ready | !pl_sm_trans.receive_enable) & pl_sm_trans.retrain_timer_done)
		        current_cw_retrain_state = RETRAIN_TIMEOUT;

		    end //}

	RETRAIN_TIMEOUT : begin //{

		      	    pl_sm_trans.retrain = 0;
		      	    pl_sm_trans.retrain_grnt = 0;
		      	    pl_sm_trans.retrain_ready = 0;

		      	    if (pl_sm_trans.receive_enable)
		      	      current_cw_retrain_state = IDLE;

		    	  end //}

      endcase

      if (prev_cw_retrain_state != current_cw_retrain_state && (current_cw_retrain_state == RETRAIN_5 || prev_cw_retrain_state == RETRAIN_5))
        `uvm_info("SRIO_LANE_HANDLER : GEN3_CW_RETRAIN_SM", $sformatf(" Next cw retrain state is %0s", current_cw_retrain_state.name()), UVM_LOW)

      if (~bfm_or_mon && prev_cw_retrain_state != current_cw_retrain_state)
	current_cw_retrain_state_q.push_back(current_cw_retrain_state);

      if (~bfm_or_mon)
      begin //{

        pl_sm_common_mon_trans.retrain_ready[mon_type] = pl_sm_trans.retrain_ready;
        pl_sm_common_mon_trans.retrain_grnt[mon_type] = pl_sm_trans.retrain_grnt;

      end //}

    end //}

  end //}

endtask : gen3_cw_retraining_sm





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_bad_xmt_width_cmd
/// Description : This method controls the generation of bad_xmt_width_cmd based on the
/// asymmetric mode support and enable for the corresponding transmit width command received.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_bad_xmt_width_cmd();

  // Either "Change_My_Transmit_Width" can initiate a "Receive width change request" or
  // when a "Transmit width request" is received, it can initiate a "Receive width change request".
  // Hence, currently, these two cases are considered as the only sources for initiating asymmetric operation.
  // A "Transmit width request" will be initiated when "Change Link partner width request" is set.

  if (bfm_or_mon)
  begin //{
    pl_sm_asym_mode_support = pl_sm_config.asymmetric_support;
    pl_sm_1x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_1x_mode_en;
    pl_sm_2x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_2x_mode_en;
    pl_sm_nx_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_nx_mode_en;
    pl_sm_asym_mode_en = pl_sm_1x_asym_mode_support | pl_sm_2x_asym_mode_support | pl_sm_nx_asym_mode_support;
    pl_sm_xmt_width_port_cmd = pl_sm_trans.xmt_width_port_req_cmd;
    pl_sm_change_lp_xmt_width = pl_sm_trans.change_lp_xmt_width;

  end //}
  else
  begin //{

    if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
    begin //{

        pl_sm_asym_mode_support = pl_sm_config.asymmetric_support;
    	pl_sm_1x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_1x_mode_en;
    	pl_sm_2x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_2x_mode_en;
    	pl_sm_nx_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_nx_mode_en;
    	pl_sm_asym_mode_en = pl_sm_1x_asym_mode_support | pl_sm_2x_asym_mode_support | pl_sm_nx_asym_mode_support;
    	pl_sm_xmt_width_port_cmd = pl_sm_trans.xmt_width_port_req_cmd;
    	pl_sm_change_lp_xmt_width = pl_sm_trans.change_lp_xmt_width;

    end //}

  end //}

  forever begin //{

    if (bfm_or_mon)
    begin //{

      @(pl_sm_config.asymmetric_support or pl_sm_config.asym_1x_mode_en or pl_sm_config.asym_2x_mode_en or pl_sm_config.asym_nx_mode_en or pl_sm_trans.xmt_width_port_req_cmd or pl_sm_trans.change_my_xmt_width or pl_sm_trans.change_lp_xmt_width);

      pl_sm_asym_mode_support = pl_sm_config.asymmetric_support;
      pl_sm_change_lp_xmt_width = pl_sm_trans.change_lp_xmt_width;
      pl_sm_1x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_1x_mode_en;
      pl_sm_2x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_2x_mode_en;
      pl_sm_nx_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_nx_mode_en;
      pl_sm_asym_mode_en = pl_sm_1x_asym_mode_support | pl_sm_2x_asym_mode_support | pl_sm_nx_asym_mode_support;

      if (pl_sm_xmt_width_port_cmd == 3'b000)
      begin //{

	if (pl_sm_trans.change_my_xmt_width != 3'b000)
	begin //{
          pl_sm_xmt_width_port_cmd = pl_sm_trans.change_my_xmt_width;
	  change_my_xmt_width_cmd_in_progress = 1;
	end //}
	else if (pl_sm_trans.xmt_width_port_req_cmd != 3'b000)
	begin //{
          pl_sm_xmt_width_port_cmd = pl_sm_trans.xmt_width_port_req_cmd;
	  xmt_width_req_cmd_in_progress = 1;
	end //}

      end //}
      else
      begin //{

	if (change_my_xmt_width_cmd_in_progress && pl_sm_trans.xmt_width_port_req_cmd != 3'b000 && ~xmt_width_req_cmd_scheduled)
	begin //{

	  next_xmt_width_cmd_q.push_back(pl_sm_trans.xmt_width_port_req_cmd);
	  xmt_width_req_cmd_scheduled = 1;

	end //}
	else if (xmt_width_req_cmd_in_progress && pl_sm_trans.change_my_xmt_width != 3'b000 && ~change_my_xmt_width_cmd_scheduled)
	begin //{

	  next_xmt_width_cmd_q.push_back(pl_sm_trans.change_my_xmt_width);
	  change_my_xmt_width_cmd_scheduled = 1;

	end //}
	else if ((xmt_width_req_cmd_scheduled && pl_sm_trans.xmt_width_port_req_cmd == 3'b000) || (change_my_xmt_width_cmd_scheduled && pl_sm_trans.change_my_xmt_width == 3'b000))
	begin //{
	  void'(next_xmt_width_cmd_q.pop_front());
	  xmt_width_req_cmd_scheduled = 0;
	  change_my_xmt_width_cmd_scheduled = 0;
	end //}
	else if (pl_sm_trans.xmt_width_port_req_cmd == 3'b000 && pl_sm_trans.change_my_xmt_width == 3'b000 && (xmt_width_req_cmd_in_progress || change_my_xmt_width_cmd_in_progress))
	begin //{
      	  pl_sm_xmt_width_port_cmd = 3'b000;
	  xmt_width_req_cmd_in_progress = 0;
	  change_my_xmt_width_cmd_in_progress = 0;
	end //}

      end //}

    end //}
    else if (~bfm_or_mon)
    begin //{

	// if the monitor interface type is BFM, it means, it monitors
	// BFM's tx data, thus it matches DUT's behaviour. Hence, DUT's
	// register model has to be looked at inorder to decide which
	// mode is supported. On the other hand, if the interface type
	// is DUT, it means, the monitor monitors the DUT's tx data, thus
	// it behaves similar to the BFM. Hence, it is enough to look at
	// the BFM's config variable to decide on the mode supported.

      if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
      begin //{
	check_asym_mode_supp_for_dut_if = 1;
      end //}
      else if ((mon_type && pl_sm_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM))
      begin //{
	check_asym_mode_supp_for_dut_if = 0;
      end //}

      if (check_asym_mode_supp_for_dut_if)
      begin //{

        @(pl_sm_config.asymmetric_support or pl_sm_config.asym_1x_mode_en or pl_sm_config.asym_2x_mode_en or pl_sm_config.asym_nx_mode_en or pl_sm_trans.xmt_width_port_req_cmd or pl_sm_trans.change_my_xmt_width or pl_sm_trans.change_lp_xmt_width);

        pl_sm_asym_mode_support = pl_sm_config.asymmetric_support;
        pl_sm_change_lp_xmt_width = pl_sm_trans.change_lp_xmt_width;
        pl_sm_1x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_1x_mode_en;
        pl_sm_2x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_2x_mode_en;
        pl_sm_nx_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_nx_mode_en;
    	pl_sm_asym_mode_en = pl_sm_1x_asym_mode_support | pl_sm_2x_asym_mode_support | pl_sm_nx_asym_mode_support;

        if (pl_sm_xmt_width_port_cmd == 3'b000)
        begin //{

	  if (pl_sm_trans.change_my_xmt_width != 3'b000)
	  begin //{
            pl_sm_xmt_width_port_cmd = pl_sm_trans.change_my_xmt_width;
	    change_my_xmt_width_cmd_in_progress = 1;
	  end //}
	  else if (pl_sm_trans.xmt_width_port_req_cmd != 3'b000)
	  begin //{
            pl_sm_xmt_width_port_cmd = pl_sm_trans.xmt_width_port_req_cmd;
	    xmt_width_req_cmd_in_progress = 1;
	  end //}

        end //}
        else
        begin //{

	  if (change_my_xmt_width_cmd_in_progress && pl_sm_trans.xmt_width_port_req_cmd != 3'b000 && ~xmt_width_req_cmd_scheduled)
	  begin //{

	    next_xmt_width_cmd_q.push_back(pl_sm_trans.xmt_width_port_req_cmd);
	    xmt_width_req_cmd_scheduled = 1;

	  end //}
	  else if (xmt_width_req_cmd_in_progress && pl_sm_trans.change_my_xmt_width != 3'b000 && ~change_my_xmt_width_cmd_scheduled)
	  begin //{

	    next_xmt_width_cmd_q.push_back(pl_sm_trans.change_my_xmt_width);
	    change_my_xmt_width_cmd_scheduled = 1;

	  end //}
	  else if ((xmt_width_req_cmd_scheduled && pl_sm_trans.xmt_width_port_req_cmd == 3'b000) || (change_my_xmt_width_cmd_scheduled && pl_sm_trans.change_my_xmt_width == 3'b000))
	  begin //{
	    void'(next_xmt_width_cmd_q.pop_front());
	    xmt_width_req_cmd_scheduled = 0;
	    change_my_xmt_width_cmd_scheduled = 0;
	  end //}
	  else if (pl_sm_trans.xmt_width_port_req_cmd == 3'b000 && pl_sm_trans.change_my_xmt_width == 3'b000 && (xmt_width_req_cmd_in_progress || change_my_xmt_width_cmd_in_progress))
	  begin //{
      	    pl_sm_xmt_width_port_cmd = 3'b000;
	    xmt_width_req_cmd_in_progress = 0;
	    change_my_xmt_width_cmd_in_progress = 0;
	  end //}

        end //}

      end //}
      else
      begin //{

	@(posedge srio_if.sim_clk);

	register_update_method("Power_Management_CSR", "Asymmetric_Modes_Supported", 64, reqd_field_name["Asymmetric_Modes_Supported"]);
	pnpmcsr_asym_support = reqd_field_name["Asymmetric_Modes_Supported"].get();
	//pnpmcsr_asym_support = pl_sm_reg_model.Port_0_Power_Management_CSR.Asymmetric_Modes_Supported.get();
	pnpmcsr_asym_support = {pnpmcsr_asym_support[4], pnpmcsr_asym_support[3], pnpmcsr_asym_support[2], pnpmcsr_asym_support[1], pnpmcsr_asym_support[0]};

	register_update_method("Power_Management_CSR", "Asymmetric_Modes_Enabled", 64, reqd_field_name["Asymmetric_Modes_Enabled"]);
	pnpmcsr_asym_en = reqd_field_name["Asymmetric_Modes_Enabled"].get();
	//pnpmcsr_asym_en = pl_sm_reg_model.Port_0_Power_Management_CSR.Asymmetric_Modes_Enabled.get();
	pnpmcsr_asym_en = {pnpmcsr_asym_en[4], pnpmcsr_asym_en[3], pnpmcsr_asym_en[2], pnpmcsr_asym_en[1], pnpmcsr_asym_en[0]};

	register_update_method("Power_Management_CSR", "Transmit_Width_Status", 64, reqd_field_name["Transmit_Width_Status"]);
	pnpmcsr_tx_width_status = reqd_field_name["Transmit_Width_Status"].get();
	//pnpmcsr_tx_width_status = pl_sm_reg_model.Port_0_Power_Management_CSR.Transmit_Width_Status.get();
	pnpmcsr_tx_width_status = {pnpmcsr_tx_width_status[2], pnpmcsr_tx_width_status[1], pnpmcsr_tx_width_status[0]};

	register_update_method("Power_Management_CSR", "Reciever_Width_Status", 64, reqd_field_name["Reciever_Width_Status"]);
	pnpmcsr_rx_width_status = reqd_field_name["Reciever_Width_Status"].get();
	//pnpmcsr_rx_width_status = pl_sm_reg_model.Port_0_Power_Management_CSR.Reciever_Width_Status.get();
	pnpmcsr_rx_width_status = {pnpmcsr_rx_width_status[2], pnpmcsr_rx_width_status[1], pnpmcsr_rx_width_status[0]};

	register_update_method("Power_Management_CSR", "Change_My_Transmit_Width", 64, reqd_field_name["Change_My_Transmit_Width"]);
	pnpmcsr_change_local_tx_width = reqd_field_name["Change_My_Transmit_Width"].get();
	//pnpmcsr_change_local_tx_width = pl_sm_reg_model.Port_0_Power_Management_CSR.Change_My_Transmit_Width.get();
	pnpmcsr_change_local_tx_width = {pnpmcsr_change_local_tx_width[2], pnpmcsr_change_local_tx_width[1], pnpmcsr_change_local_tx_width[0]};

	register_update_method("Power_Management_CSR", "Status_of_My_Transmit_Width_Change", 64, reqd_field_name["Status_of_My_Transmit_Width_Change"]);
	pnpmcsr_change_local_tx_width_status = reqd_field_name["Status_of_My_Transmit_Width_Change"].get();
	//pnpmcsr_change_local_tx_width_status = pl_sm_reg_model.Port_0_Power_Management_CSR.Status_of_My_Transmit_Width_Change.get();
	pnpmcsr_change_local_tx_width_status = {pnpmcsr_change_local_tx_width_status[1], pnpmcsr_change_local_tx_width_status[0]};

	register_update_method("Power_Management_CSR", "Change_Link_Partner_Transmit_width", 64, reqd_field_name["Change_Link_Partner_Transmit_width"]);
	pnpmcsr_change_lp_tx_width = reqd_field_name["Change_Link_Partner_Transmit_width"].get();
	//pnpmcsr_change_lp_tx_width = pl_sm_reg_model.Port_0_Power_Management_CSR.Change_Link_Partner_Transmit_width.get();
	pnpmcsr_change_lp_tx_width = {pnpmcsr_change_lp_tx_width[2], pnpmcsr_change_lp_tx_width[1], pnpmcsr_change_lp_tx_width[0]};
        pl_sm_change_lp_xmt_width = pnpmcsr_change_lp_tx_width;

	register_update_method("Power_Management_CSR", "Status_of_Link_Partner_Transmit_Width_Change", 64, reqd_field_name["Status_of_Link_Partner_Transmit_Width_Change"]);
	pnpmcsr_change_lp_tx_width_status = reqd_field_name["Status_of_Link_Partner_Transmit_Width_Change"].get();
	//pnpmcsr_change_lp_tx_width_status = pl_sm_reg_model.Port_0_Power_Management_CSR.Status_of_Link_Partner_Transmit_Width_Change.get();
	pnpmcsr_change_lp_tx_width_status = {pnpmcsr_change_lp_tx_width_status[1], pnpmcsr_change_lp_tx_width_status[0]};

        pl_sm_asym_mode_support = |pnpmcsr_asym_support;
        pl_sm_1x_asym_mode_support = pl_sm_asym_mode_support & pnpmcsr_asym_en[0];
        pl_sm_2x_asym_mode_support = pl_sm_asym_mode_support & pnpmcsr_asym_en[1];
        pl_sm_nx_asym_mode_support = pl_sm_asym_mode_support & ((pl_sm_env_config.num_of_lanes == 4 & pnpmcsr_asym_en[2]) | (pl_sm_env_config.num_of_lanes == 8 & pnpmcsr_asym_en[3]) | (pl_sm_env_config.num_of_lanes == 16 & pnpmcsr_asym_en[4]));
    	pl_sm_asym_mode_en = pl_sm_1x_asym_mode_support | pl_sm_2x_asym_mode_support | pl_sm_nx_asym_mode_support;

        if (pl_sm_xmt_width_port_cmd == 3'b000)
        begin //{

	  if (pnpmcsr_change_local_tx_width != 3'b000)
	  begin //{
            pl_sm_xmt_width_port_cmd = pnpmcsr_change_local_tx_width;
	    change_my_xmt_width_cmd_in_progress = 1;
	  end //}
	  else if (pl_sm_trans.xmt_width_port_req_cmd != 3'b000)
	  begin //{
            pl_sm_xmt_width_port_cmd = pl_sm_trans.xmt_width_port_req_cmd;
	    xmt_width_req_cmd_in_progress = 1;
	  end //}

        end //}
        else
        begin //{

	  if (change_my_xmt_width_cmd_in_progress && pl_sm_trans.xmt_width_port_req_cmd != 3'b000 && ~xmt_width_req_cmd_scheduled)
	  begin //{

	    next_xmt_width_cmd_q.push_back(pl_sm_trans.xmt_width_port_req_cmd);
	    xmt_width_req_cmd_scheduled = 1;

	  end //}
	  else if (xmt_width_req_cmd_in_progress && pnpmcsr_change_local_tx_width != 3'b000 && ~change_my_xmt_width_cmd_scheduled)
	  begin //{

	    next_xmt_width_cmd_q.push_back(pnpmcsr_change_local_tx_width);
	    change_my_xmt_width_cmd_scheduled = 1;

	  end //}
	  else if ((xmt_width_req_cmd_scheduled && pl_sm_trans.xmt_width_port_req_cmd == 3'b000) || (change_my_xmt_width_cmd_scheduled && pnpmcsr_change_local_tx_width == 3'b000))
	  begin //{
	    void'(next_xmt_width_cmd_q.pop_front());
	    xmt_width_req_cmd_scheduled = 0;
	    change_my_xmt_width_cmd_scheduled = 0;
	  end //}
	  else if (pl_sm_trans.xmt_width_port_req_cmd == 3'b000 && pnpmcsr_change_local_tx_width == 3'b000 && (xmt_width_req_cmd_in_progress || change_my_xmt_width_cmd_in_progress))
	  begin //{
      	    pl_sm_xmt_width_port_cmd = 3'b000;
	    xmt_width_req_cmd_in_progress = 0;
	    change_my_xmt_width_cmd_in_progress = 0;
	  end //}

        end //}

	->gen3_power_mgmt_registers_read;

      end //}

    end //}

    // The expression is modified to support only 1x/2x/Nx.
    bad_xmt_width_cmd = !pl_sm_trans.xmt_width_port_cmd_ack & !pl_sm_trans.xmt_width_port_cmd_nack
			& (!pl_sm_trans.asym_mode & (pl_sm_xmt_width_port_cmd != 3'b000)
			| (pl_sm_xmt_width_port_cmd == 3'b010) & !pl_sm_2x_asym_mode_support
			| (pl_sm_xmt_width_port_cmd == 3'b011 | pl_sm_xmt_width_port_cmd == 3'b100 
			| pl_sm_xmt_width_port_cmd == 3'b101) & (!pl_sm_nx_asym_mode_support
			| (pl_sm_trans.max_width == "0x" | pl_sm_trans.max_width == "1x" | pl_sm_trans.max_width == "2x"))
			| (pl_sm_xmt_width_port_cmd == 3'b110 | pl_sm_xmt_width_port_cmd == 3'b111));

  end //}

endtask : gen_bad_xmt_width_cmd




////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : schedule_next_xmt_width_cmd
/// Description : This method will schedule the next transmit width command, if issued,
/// in a queue, if already a transmit width command is in progress. Currently only two sources
/// are identified to issue a transmit width command. One is by configuring "Change_my_xmt_width"
/// and the other is by receiving "Transmit width request" from the received status/control os.
/// "Transmit width request" is issued by configuring "Change_lp_xmt_width" appropriately.
////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::schedule_next_xmt_width_cmd();

    fork //{

      begin //{

  	forever begin //{

	  wait (change_my_xmt_width_cmd_in_progress == 1);

	  if (bfm_or_mon || (~bfm_or_mon && check_asym_mode_supp_for_dut_if))
	  begin //{

	    wait (pl_sm_trans.change_my_xmt_width == 3'b000 && pl_sm_trans.xmt_width_port_cmd_ack == 2'b00 && pl_sm_trans.xmt_width_port_cmd_nack == 2'b00);

	    change_my_xmt_width_cmd_in_progress = 0;

	    if (xmt_width_req_cmd_scheduled && next_xmt_width_cmd_q.size()>0)
	    begin //{
              pl_sm_xmt_width_port_cmd = next_xmt_width_cmd_q.pop_front();
	      xmt_width_req_cmd_scheduled = 0;
	    end //}

	  end //}
	  else if (~bfm_or_mon && ~check_asym_mode_supp_for_dut_if)
	  begin //{

	    wait (pnpmcsr_change_local_tx_width == 3'b000 && pnpmcsr_change_local_tx_width_status == 2'b00);

	    change_my_xmt_width_cmd_in_progress = 0;

	    if (xmt_width_req_cmd_scheduled && next_xmt_width_cmd_q.size()>0)
	    begin //{
              pl_sm_xmt_width_port_cmd = next_xmt_width_cmd_q.pop_front();
	      xmt_width_req_cmd_scheduled = 0;
	    end //}

	  end //}

	end //}

      end //}

      begin //{

  	forever begin //{

	  wait (xmt_width_req_cmd_in_progress == 1);

	  wait (pl_sm_trans.xmt_width_port_req_cmd == 3'b000 && pl_sm_trans.xmt_width_port_req_pending == 1'b0);

	  xmt_width_req_cmd_in_progress = 0;

	  if (change_my_xmt_width_cmd_scheduled && next_xmt_width_cmd_q.size()>0)
	  begin //{
            pl_sm_xmt_width_port_cmd = next_xmt_width_cmd_q.pop_front();
	    change_my_xmt_width_cmd_scheduled = 0;
	  end //}

	end //}

      end //}

    join //}

endtask : schedule_next_xmt_width_cmd




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1x_mode_xmt_cmd
/// Description : This method controls the assertion and deassertion logic for x1_mode_xmt_cmd.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1x_mode_xmt_cmd();

  forever begin //{

    @(pl_sm_trans.asym_mode or pl_sm_xmt_width_port_cmd or pl_sm_trans.xmt_width_port_cmd_ack or pl_sm_trans.xmt_width_port_cmd_nack);

    pl_sm_trans.x1_mode_xmt_cmd = pl_sm_trans.asym_mode & (pl_sm_xmt_width_port_cmd == 3'b001)
					& !pl_sm_trans.xmt_width_port_cmd_ack & !pl_sm_trans.xmt_width_port_cmd_nack;

  end //}

endtask : gen_1x_mode_xmt_cmd




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_2x_mode_xmt_cmd
/// Description : This method controls the assertion and deassertion logic for x2_mode_xmt_cmd.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_2x_mode_xmt_cmd();

  forever begin //{

    @(pl_sm_trans.asym_mode or pl_sm_xmt_width_port_cmd or pl_sm_2x_asym_mode_support or pl_sm_trans.xmt_width_port_cmd_ack or pl_sm_trans.xmt_width_port_cmd_nack);

    pl_sm_trans.x2_mode_xmt_cmd = pl_sm_trans.asym_mode & (pl_sm_xmt_width_port_cmd == 3'b010) & pl_sm_2x_asym_mode_support
					& !pl_sm_trans.xmt_width_port_cmd_ack & !pl_sm_trans.xmt_width_port_cmd_nack;

  end //}

endtask : gen_2x_mode_xmt_cmd




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nx_mode_xmt_cmd
/// Description : This method controls the assertion and deassertion logic for nx_mode_xmt_cmd.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nx_mode_xmt_cmd();

  forever begin //{

    @(pl_sm_trans.asym_mode or pl_sm_xmt_width_port_cmd or pl_sm_nx_asym_mode_support or pl_sm_trans.xmt_width_port_cmd_ack or pl_sm_trans.xmt_width_port_cmd_nack);

    pl_sm_trans.nx_mode_xmt_cmd = pl_sm_trans.asym_mode & ((pl_sm_xmt_width_port_cmd == 3'b011 & pl_sm_trans.max_width == "4x")
					| (pl_sm_xmt_width_port_cmd == 3'b100 & pl_sm_trans.max_width == "8x")
					| (pl_sm_xmt_width_port_cmd == 3'b101 & pl_sm_trans.max_width == "16x"))
					& pl_sm_nx_asym_mode_support & !pl_sm_trans.xmt_width_port_cmd_ack & !pl_sm_trans.xmt_width_port_cmd_nack;

  end //}

endtask : gen_nx_mode_xmt_cmd




/////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_xmt_width_cmd_pending
/// Description : This method controls the assertion and deassertion logic for xmt_width_cmd_pending.
/////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_xmt_width_cmd_pending();

  forever begin //{

    @(pl_sm_trans.x1_mode_xmt_cmd or pl_sm_trans.x2_mode_xmt_cmd or pl_sm_trans.nx_mode_xmt_cmd);

    pl_sm_trans.xmt_width_cmd_pending = pl_sm_trans.x1_mode_xmt_cmd | pl_sm_trans.x2_mode_xmt_cmd | pl_sm_trans.nx_mode_xmt_cmd;

  end //}

endtask : gen_xmt_width_cmd_pending




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_xmit_width_cmd_sm
/// Description : GEN3.0 "Transmit width command" state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen3_xmit_width_cmd_sm();

#1;
  if (~srio_if.srio_rst_n)
  begin //{

    current_xmit_width_cmd_state = XMT_WIDTH_CMD_3;

    pl_sm_trans.xmt_width_port_cmd_ack = 0;
    pl_sm_trans.xmt_width_port_cmd_nack = 0;

    if (~bfm_or_mon)
      current_xmit_width_cmd_state_q.push_back(current_xmit_width_cmd_state);

  end //}

  forever
  begin //{

    @(negedge srio_if.sim_clk);

    if (pl_sm_trans.current_init_state == SILENT)
    begin //{

      prev_xmit_width_cmd_state = current_xmit_width_cmd_state;

      current_xmit_width_cmd_state = XMT_WIDTH_CMD_3;

      pl_sm_trans.xmt_width_port_cmd_ack = 0;
      pl_sm_trans.xmt_width_port_cmd_nack = 0;

      if (~bfm_or_mon && prev_xmit_width_cmd_state != current_xmit_width_cmd_state)
	current_xmit_width_cmd_state_q.push_back(current_xmit_width_cmd_state);
 
    end //}
    else
    begin //{

      prev_xmit_width_cmd_state = current_xmit_width_cmd_state;

      case (current_xmit_width_cmd_state)

	XMT_WIDTH_CMD_3 : begin //{

			    pl_sm_trans.xmt_width_port_cmd_ack = 0;
			    pl_sm_trans.xmt_width_port_cmd_nack = 0;

			    current_xmit_width_cmd_state = XMT_WIDTH_CMD_IDLE;

		  	  end //}

	XMT_WIDTH_CMD_IDLE : begin //{

		      	        if (bad_xmt_width_cmd)
		      	          current_xmit_width_cmd_state = XMT_WIDTH_CMD_1;
		      	        else if (pl_sm_xmt_width_port_cmd != 3'b000 & (pl_sm_trans.xmt_width_port_cmd_ack | pl_sm_trans.xmt_width_port_cmd_nack)) // != HOLD
		      	          current_xmit_width_cmd_state = XMT_WIDTH_CMD_2;

		    	      end //}

	XMT_WIDTH_CMD_2 : begin //{

		      	    if (pl_sm_xmt_width_port_cmd == 3'b000) // == HOLD
		      	      current_xmit_width_cmd_state = XMT_WIDTH_CMD_3;

		    	  end //}

	XMT_WIDTH_CMD_1 : begin //{

			    pl_sm_trans.xmt_width_port_cmd_nack = 1;

		      	    current_xmit_width_cmd_state = XMT_WIDTH_CMD_2;

		    	  end //}

      endcase

      if (prev_xmit_width_cmd_state != current_xmit_width_cmd_state)
        `uvm_info("SRIO_LANE_HANDLER : GEN3_XMT_WIDTH_CMD_SM", $sformatf(" Next xmt_width_cmd state is %0s", current_xmit_width_cmd_state.name()), UVM_LOW)

      if (~bfm_or_mon && prev_xmit_width_cmd_state != current_xmit_width_cmd_state)
	current_xmit_width_cmd_state_q.push_back(current_xmit_width_cmd_state);

    end //}

  end //}

endtask : gen3_xmit_width_cmd_sm




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_xmit_width_sm
/// Description : GEN3.0 "Transmit width" state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen3_xmit_width_sm();

#1;
  if (~srio_if.srio_rst_n)
  begin //{

    current_xmit_width_state = ASYM_XMT_IDLE;

    pl_sm_trans.end_asym_mode = 0;
    pl_sm_trans.rcv_width_link_cmd = 3'b000;
    xmt_width_tmr_en = 0;
    pl_sm_trans.xmt_width = pl_sm_trans.max_width;
    pl_sm_trans.xmt_sc_seq = 0;
    pl_sm_trans.transmit_enable_tw = 1;

    pl_sm_trans.common_trans_xmit_width_state = current_xmit_width_state;

    if (~bfm_or_mon)
      current_xmit_width_state_q.push_back(current_xmit_width_state);

  end //}

  forever
  begin //{

    @(negedge srio_if.sim_clk);

    if (pl_sm_trans.current_init_state == SILENT | !pl_sm_trans.asym_mode)
    begin //{

      prev_xmit_width_state = current_xmit_width_state;

      current_xmit_width_state = ASYM_XMT_IDLE;

      pl_sm_trans.end_asym_mode = 0;
      pl_sm_trans.rcv_width_link_cmd = 3'b000;
      xmt_width_tmr_en = 0;
      pl_sm_trans.xmt_width = pl_sm_trans.max_width;
      pl_sm_trans.xmt_sc_seq = 0;
      pl_sm_trans.transmit_enable_tw = 1;

      pl_sm_trans.common_trans_xmit_width_state = current_xmit_width_state;

      if (~bfm_or_mon && prev_xmit_width_state != current_xmit_width_state)
        current_xmit_width_state_q.push_back(current_xmit_width_state);

    end //}
    else
    begin //{

      prev_xmit_width_state = current_xmit_width_state;

      case (current_xmit_width_state)

	ASYM_XMT_IDLE : begin //{

      			  pl_sm_trans.end_asym_mode = 0;
      			  pl_sm_trans.rcv_width_link_cmd = 3'b000;
      			  xmt_width_tmr_en = 0;
      			  pl_sm_trans.xmt_width = pl_sm_trans.max_width;
      			  pl_sm_trans.xmt_sc_seq = 0;
      			  pl_sm_trans.transmit_enable_tw = 1;

			  if (pl_sm_trans.asym_mode & (pl_sm_trans.max_width == "2x"))
			    current_xmit_width_state = X2_MODE_XMT;
			  else if (pl_sm_trans.asym_mode & (pl_sm_trans.max_width == "4x" || pl_sm_trans.max_width == "8x" || pl_sm_trans.max_width == "16x"))
			    current_xmit_width_state = NX_MODE_XMT;

		  	end //}

	X1_MODE_XMT : begin //{

			xmt_width_tmr_en = 0;
			pl_sm_trans.lanes01_drvr_oe = 0;
			pl_sm_trans.lanes02_drvr_oe = 0;
			pl_sm_trans.N_lanes_drvr_oe = 0;
			pl_sm_trans.xmt_width = "1x";
			pl_sm_trans.transmit_sc_sequences_cnt = 4;
			pl_sm_trans.xmt_sc_seq = 0;
			pl_sm_trans.transmit_enable_tw = 1;

		      	if (pl_sm_trans.x1_mode_xmt_cmd && pl_sm_trans.xmt_width_grnt)
		      	  current_xmit_width_state = X1_MODE_XMT_ACK;
		      	else if (pl_sm_trans.x2_mode_xmt_cmd && pl_sm_trans.xmt_width_grnt)
		      	  current_xmit_width_state = SEEK_2X_MODE_XMT;
		      	else if (pl_sm_trans.nx_mode_xmt_cmd && pl_sm_trans.xmt_width_grnt)
		      	  current_xmit_width_state = SEEK_NX_MODE_XMT;

			if (~bfm_or_mon)
			begin //{
			  register_update_method("Power_Management_CSR", "Transmit_Width_Status", 64, reqd_field_name["Transmit_Width_Status"]);
			  void'(reqd_field_name["Transmit_Width_Status"].predict(3'b100));
      			  //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Transmit_Width_Status.predict(3'b100));
			end //}

		      end //}

	SEEK_1X_MODE_XMT : begin //{

			     pl_sm_trans.lane0_drvr_oe = 1;
			     pl_sm_trans.xmt_sc_seq = 1;
			     xmt_width_tmr_en = 1;
			     prev_xmt_width = pl_sm_trans.xmt_width;

		      	     if (pl_sm_trans.from_sc_receive_lanes_ready >= 3'b001)
		      	       current_xmit_width_state = SEEK_1X_MODE_XMT_1;
		      	     else if (xmt_width_tmr_done & (pl_sm_trans.from_sc_receive_lanes_ready < 3'b001))
		      	       current_xmit_width_state = SEEK_1X_MODE_XMT_3;

			     if (~bfm_or_mon)
			     begin //{
				if (current_xmit_width_state == SEEK_1X_MODE_XMT_3 && xmt_width_tmr_done)
				  `uvm_error("SRIO_PL_STATE_MACHINE : 1X_TRANSMIT_WIDTH_CMD_TIMEOUT_CHECK_1", $sformatf(" Spec reference 5.16.1. Timeout occured for transmit width port command in SEEK_1X_MODE_XMT state."))
			     end //}

		    	  end //}

	SEEK_1X_MODE_XMT_1 : begin //{

			       pl_sm_trans.transmit_enable_tw = 0;

			       if (pl_sm_trans.xmting_idle)
		      	         current_xmit_width_state = SEEK_1X_MODE_XMT_2;
			       else if (xmt_width_tmr_done & !pl_sm_trans.xmting_idle)
		      	         current_xmit_width_state = SEEK_1X_MODE_XMT_3;

			     	if (~bfm_or_mon)
			     	begin //{
			     	   if (current_xmit_width_state == SEEK_1X_MODE_XMT_3 && xmt_width_tmr_done)
			     	     `uvm_error("SRIO_PL_STATE_MACHINE : 1X_TRANSMIT_WIDTH_CMD_TIMEOUT_CHECK_2", $sformatf(" Spec reference 5.16.1. Timeout occured for transmit width port command in SEEK_1X_MODE_XMT_1 state."))
			     	end //}

		    	     end //}

	SEEK_1X_MODE_XMT_2 : begin //{

			       pl_sm_trans.xmt_width = "1x";
			       pl_sm_trans.rcv_width_link_cmd = 3'b001;

			       if (!xmt_width_tmr_done & pl_sm_trans.from_sc_rcv_width_link_cmd_nack & pl_sm_trans.from_sc_rcv_width == prev_xmt_width)
		      	         current_xmit_width_state = SEEK_1X_MODE_XMT_3;
			       else if (!xmt_width_tmr_done & pl_sm_trans.from_sc_rcv_width_link_cmd_ack & pl_sm_trans.from_sc_rcv_width == "1x")
		      	         current_xmit_width_state = X1_MODE_XMT_ACK;
			       else if (xmt_width_tmr_done)
		      	         current_xmit_width_state = ASYM_XMT_EXIT;

			     	if (~bfm_or_mon)
			     	begin //{
			     	   if (current_xmit_width_state == ASYM_XMT_EXIT && xmt_width_tmr_done)
			     	     `uvm_error("SRIO_PL_STATE_MACHINE : 1X_TRANSMIT_WIDTH_CMD_TIMEOUT_CHECK_3", $sformatf(" Spec reference 5.16.1. Timeout occured for transmit width port command in SEEK_1X_MODE_XMT_2 state."))
			     	end //}

		    	     end //}

	SEEK_1X_MODE_XMT_3 : begin //{

			       pl_sm_trans.lane0_drvr_oe = 0;
			       pl_sm_trans.xmt_width = prev_xmt_width;

		      	       current_xmit_width_state = XMT_WIDTH_NACK;

		    	     end //}

	X1_MODE_XMT_ACK : begin //{

			    pl_sm_trans.rcv_width_link_cmd = 3'b000;
			    pl_sm_trans.xmt_width_port_cmd_ack = 1;

		      	    current_xmit_width_state = X1_MODE_XMT;

		    	  end //}

	X2_MODE_XMT : begin //{

			xmt_width_tmr_en = 0;
			pl_sm_trans.lanes02_drvr_oe = 0;
			pl_sm_trans.N_lanes_drvr_oe = 0;
			pl_sm_trans.xmt_width = "2x";
			pl_sm_trans.transmit_sc_sequences_cnt = 4;
			pl_sm_trans.xmt_sc_seq = 0;
			pl_sm_trans.transmit_enable_tw = 1;

		      	if (pl_sm_trans.x1_mode_xmt_cmd && pl_sm_trans.xmt_width_grnt)
		      	  current_xmit_width_state = SEEK_1X_MODE_XMT;
		      	else if (pl_sm_trans.x2_mode_xmt_cmd && pl_sm_trans.xmt_width_grnt)
		      	  current_xmit_width_state = X2_MODE_XMT_ACK;
		      	else if (pl_sm_trans.nx_mode_xmt_cmd && pl_sm_trans.xmt_width_grnt)
		      	  current_xmit_width_state = SEEK_NX_MODE_XMT;

			if (~bfm_or_mon)
			begin //{
			  register_update_method("Power_Management_CSR", "Transmit_Width_Status", 64, reqd_field_name["Transmit_Width_Status"]);
			  void'(reqd_field_name["Transmit_Width_Status"].predict(3'b010));
      			  //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Transmit_Width_Status.predict(3'b010));
			end //}

		      end //}

	SEEK_2X_MODE_XMT : begin //{

			     pl_sm_trans.lanes01_drvr_oe = 1;
			     pl_sm_trans.xmt_sc_seq = 1;
			     xmt_width_tmr_en = 1;
			     prev_xmt_width = pl_sm_trans.xmt_width;

		      	     if (pl_sm_trans.from_sc_receive_lanes_ready >= 3'b010)
		      	       current_xmit_width_state = SEEK_2X_MODE_XMT_1;
		      	     else if (xmt_width_tmr_done & (pl_sm_trans.from_sc_receive_lanes_ready < 3'b010))
		      	       current_xmit_width_state = SEEK_2X_MODE_XMT_3;

			     if (~bfm_or_mon)
			     begin //{
				if (current_xmit_width_state == SEEK_2X_MODE_XMT_3 && xmt_width_tmr_done)
				  `uvm_error("SRIO_PL_STATE_MACHINE : 2X_TRANSMIT_WIDTH_CMD_TIMEOUT_CHECK_1", $sformatf(" Spec reference 5.16.1. Timeout occured for transmit width port command in SEEK_2X_MODE_XMT state."))
			     end //}

		    	  end //}

	SEEK_2X_MODE_XMT_1 : begin //{

			       pl_sm_trans.transmit_enable_tw = 0;

			       if (pl_sm_trans.xmting_idle)
		      	         current_xmit_width_state = SEEK_2X_MODE_XMT_2;
			       else if (xmt_width_tmr_done & !pl_sm_trans.xmting_idle)
		      	         current_xmit_width_state = SEEK_2X_MODE_XMT_3;

			     	if (~bfm_or_mon)
			     	begin //{
			     	   if (current_xmit_width_state == SEEK_2X_MODE_XMT_3 && xmt_width_tmr_done)
			     	     `uvm_error("SRIO_PL_STATE_MACHINE : 2X_TRANSMIT_WIDTH_CMD_TIMEOUT_CHECK_2", $sformatf(" Spec reference 5.16.1. Timeout occured for transmit width port command in SEEK_2X_MODE_XMT_1 state."))
			     	end //}

		    	     end //}

	SEEK_2X_MODE_XMT_2 : begin //{

			       pl_sm_trans.xmt_width = "2x";
			       pl_sm_trans.rcv_width_link_cmd = 3'b010;

			       if (!xmt_width_tmr_done & pl_sm_trans.from_sc_rcv_width_link_cmd_nack & pl_sm_trans.from_sc_rcv_width == prev_xmt_width)
		      	         current_xmit_width_state = SEEK_2X_MODE_XMT_3;
			       else if (!xmt_width_tmr_done & pl_sm_trans.from_sc_rcv_width_link_cmd_ack & pl_sm_trans.from_sc_rcv_width == "2x")
		      	         current_xmit_width_state = X2_MODE_XMT_ACK;
			       else if (xmt_width_tmr_done)
		      	         current_xmit_width_state = ASYM_XMT_EXIT;

			     	if (~bfm_or_mon)
			     	begin //{
			     	   if (current_xmit_width_state == ASYM_XMT_EXIT && xmt_width_tmr_done)
			     	     `uvm_error("SRIO_PL_STATE_MACHINE : 2X_TRANSMIT_WIDTH_CMD_TIMEOUT_CHECK_3", $sformatf(" Spec reference 5.16.1. Timeout occured for transmit width port command in SEEK_2X_MODE_XMT_2 state."))
			     	end //}

		    	     end //}

	SEEK_2X_MODE_XMT_3 : begin //{

			       pl_sm_trans.lanes01_drvr_oe = 0;
			       pl_sm_trans.xmt_width = prev_xmt_width;

		      	       current_xmit_width_state = XMT_WIDTH_NACK;

		    	     end //}

	X2_MODE_XMT_ACK : begin //{

			    pl_sm_trans.rcv_width_link_cmd = 3'b000;
			    pl_sm_trans.xmt_width_port_cmd_ack = 1;

		      	    current_xmit_width_state = X2_MODE_XMT;

		    	  end //}

	NX_MODE_XMT : begin //{

			xmt_width_tmr_en = 0;
			pl_sm_trans.lanes01_drvr_oe = 0;
			pl_sm_trans.lanes02_drvr_oe = 0;

			if (pl_sm_env_config.num_of_lanes == 4)
			  pl_sm_trans.xmt_width = "4x";
			else if (pl_sm_env_config.num_of_lanes == 8)
			  pl_sm_trans.xmt_width = "8x";
			else if (pl_sm_env_config.num_of_lanes == 16)
			  pl_sm_trans.xmt_width = "16x";

			pl_sm_trans.transmit_sc_sequences_cnt = 4;
			pl_sm_trans.xmt_sc_seq = 0;
			pl_sm_trans.transmit_enable_tw = 1;

		      	if (pl_sm_trans.x1_mode_xmt_cmd && pl_sm_trans.xmt_width_grnt)
		      	  current_xmit_width_state = SEEK_1X_MODE_XMT;
		      	else if (pl_sm_trans.x2_mode_xmt_cmd && pl_sm_trans.xmt_width_grnt)
		      	  current_xmit_width_state = SEEK_2X_MODE_XMT;
		      	else if (pl_sm_trans.nx_mode_xmt_cmd && pl_sm_trans.xmt_width_grnt)
		      	  current_xmit_width_state = NX_MODE_XMT_ACK;

			if (~bfm_or_mon)
			begin //{
			  if (pl_sm_env_config.num_of_lanes == 4)
			  begin //{
			    register_update_method("Power_Management_CSR", "Transmit_Width_Status", 64, reqd_field_name["Transmit_Width_Status"]);
			    void'(reqd_field_name["Transmit_Width_Status"].predict(3'b110));
      			    //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Transmit_Width_Status.predict(3'b110));
			  end //}
			  else if (pl_sm_env_config.num_of_lanes == 8)
			  begin //{
			    register_update_method("Power_Management_CSR", "Transmit_Width_Status", 64, reqd_field_name["Transmit_Width_Status"]);
			    void'(reqd_field_name["Transmit_Width_Status"].predict(3'b001));
      			    //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Transmit_Width_Status.predict(3'b001));
			  end //}
			  else if (pl_sm_env_config.num_of_lanes == 16)
			  begin //{
			    register_update_method("Power_Management_CSR", "Transmit_Width_Status", 64, reqd_field_name["Transmit_Width_Status"]);
			    void'(reqd_field_name["Transmit_Width_Status"].predict(3'b101));
      			    //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Transmit_Width_Status.predict(3'b101));
			  end //}
			end //}

		      end //}

	SEEK_NX_MODE_XMT : begin //{

			     pl_sm_trans.N_lanes_drvr_oe = 1;
			     pl_sm_trans.xmt_sc_seq = 1;
			     xmt_width_tmr_en = 1;
			     prev_xmt_width = pl_sm_trans.xmt_width;

		      	     if ((pl_sm_trans.max_width == "4x" && pl_sm_trans.from_sc_receive_lanes_ready == 3'b011) || (pl_sm_trans.max_width == "8x" && pl_sm_trans.from_sc_receive_lanes_ready == 3'b100) || (pl_sm_trans.max_width == "16x" && pl_sm_trans.from_sc_receive_lanes_ready == 3'b101))
		      	       current_xmit_width_state = SEEK_NX_MODE_XMT_1;
		      	     else if (xmt_width_tmr_done & ((pl_sm_trans.max_width == "4x" && pl_sm_trans.from_sc_receive_lanes_ready < 3'b011) || (pl_sm_trans.max_width == "8x" && pl_sm_trans.from_sc_receive_lanes_ready < 3'b100) || (pl_sm_trans.max_width == "16x" && pl_sm_trans.from_sc_receive_lanes_ready < 3'b101)))
		      	       current_xmit_width_state = SEEK_NX_MODE_XMT_3;

			     if (~bfm_or_mon)
			     begin //{
				if (current_xmit_width_state == SEEK_NX_MODE_XMT_3 && xmt_width_tmr_done)
				  `uvm_error("SRIO_PL_STATE_MACHINE : NX_TRANSMIT_WIDTH_CMD_TIMEOUT_CHECK_1", $sformatf(" Spec reference 5.16.1. Timeout occured for transmit width port command in SEEK_NX_MODE_XMT state."))
			     end //}

		    	  end //}

	SEEK_NX_MODE_XMT_1 : begin //{

			       pl_sm_trans.transmit_enable_tw = 0;

			       if (pl_sm_trans.xmting_idle)
		      	         current_xmit_width_state = SEEK_NX_MODE_XMT_2;
			       else if (xmt_width_tmr_done & !pl_sm_trans.xmting_idle)
		      	         current_xmit_width_state = SEEK_NX_MODE_XMT_3;

			     	if (~bfm_or_mon)
			     	begin //{
			     	   if (current_xmit_width_state == SEEK_NX_MODE_XMT_3 && xmt_width_tmr_done)
			     	     `uvm_error("SRIO_PL_STATE_MACHINE : NX_TRANSMIT_WIDTH_CMD_TIMEOUT_CHECK_2", $sformatf(" Spec reference 5.16.1. Timeout occured for transmit width port command in SEEK_NX_MODE_XMT_1 state."))
			     	end //}

		    	     end //}

	SEEK_NX_MODE_XMT_2 : begin //{

			        if (pl_sm_env_config.num_of_lanes == 4)
				begin //{
			          pl_sm_trans.xmt_width = "4x";
			          pl_sm_trans.rcv_width_link_cmd = 3'b011;
				end //}
			        else if (pl_sm_env_config.num_of_lanes == 8)
				begin //{
			          pl_sm_trans.xmt_width = "8x";
			          pl_sm_trans.rcv_width_link_cmd = 3'b100;
				end //}
			        else if (pl_sm_env_config.num_of_lanes == 16)
				begin //{
			          pl_sm_trans.xmt_width = "16x";
			          pl_sm_trans.rcv_width_link_cmd = 3'b101;
				end //}

			        if (!xmt_width_tmr_done & pl_sm_trans.from_sc_rcv_width_link_cmd_nack & pl_sm_trans.from_sc_rcv_width == prev_xmt_width)
		      	          current_xmit_width_state = SEEK_NX_MODE_XMT_3;
			        else if (!xmt_width_tmr_done & pl_sm_trans.from_sc_rcv_width_link_cmd_ack & pl_sm_trans.from_sc_rcv_width == pl_sm_trans.xmt_width)
		      	          current_xmit_width_state = NX_MODE_XMT_ACK;
			        else if (xmt_width_tmr_done)
		      	          current_xmit_width_state = ASYM_XMT_EXIT;

			     	if (~bfm_or_mon)
			     	begin //{
			     	   if (current_xmit_width_state == ASYM_XMT_EXIT && xmt_width_tmr_done)
			     	     `uvm_error("SRIO_PL_STATE_MACHINE : NX_TRANSMIT_WIDTH_CMD_TIMEOUT_CHECK_3", $sformatf(" Spec reference 5.16.1. Timeout occured for transmit width port command in SEEK_NX_MODE_XMT_2 state."))
			     	end //}

		    	     end //}

	SEEK_NX_MODE_XMT_3 : begin //{

			       pl_sm_trans.N_lanes_drvr_oe = 0;
			       pl_sm_trans.xmt_width = prev_xmt_width;

		      	       current_xmit_width_state = XMT_WIDTH_NACK;

		    	     end //}

	NX_MODE_XMT_ACK : begin //{

			    pl_sm_trans.rcv_width_link_cmd = 3'b000;
			    pl_sm_trans.xmt_width_port_cmd_ack = 1;

		      	    current_xmit_width_state = NX_MODE_XMT;

		    	  end //}

	XMT_WIDTH_NACK : begin //{

			    pl_sm_trans.rcv_width_link_cmd = 3'b000;
			    pl_sm_trans.xmt_sc_seq = 0;
			    pl_sm_trans.xmt_width_port_cmd_nack = 1;

			    if (pl_sm_trans.xmt_width == "1x")
		      	      current_xmit_width_state = X1_MODE_XMT;
			    else if (pl_sm_trans.xmt_width == "2x")
		      	      current_xmit_width_state = X2_MODE_XMT;
			    else if (pl_sm_trans.xmt_width == "4x" || pl_sm_trans.xmt_width == "8x" || pl_sm_trans.xmt_width == "16x")
		      	      current_xmit_width_state = NX_MODE_XMT;

		    	 end //}

	ASYM_XMT_EXIT : begin //{

			    pl_sm_trans.xmt_width_port_cmd_nack = 1;
			    pl_sm_trans.xmt_sc_seq = 0;
			    pl_sm_trans.end_asym_mode = 1;

		      	    if (!pl_sm_trans.asym_mode)
		      	      current_xmit_width_state = ASYM_XMT_IDLE;

		    	end //}

      endcase

      if (prev_xmit_width_state != current_xmit_width_state)
        `uvm_info("SRIO_LANE_HANDLER : GEN3_XMT_WIDTH_SM", $sformatf(" Next xmt_width state is %0s", current_xmit_width_state.name()), UVM_LOW)

      pl_sm_trans.common_trans_xmit_width_state = current_xmit_width_state;

      if (~bfm_or_mon && prev_xmit_width_state != current_xmit_width_state)
        current_xmit_width_state_q.push_back(current_xmit_width_state);

    end //}

  end //}

endtask : gen3_xmit_width_sm





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_bad_rcv_width_cmd
/// Description : This method generates bad_rcv_width_cmd based on the asymmetric mode
/// support and enable for the corresponding receive width command received.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_bad_rcv_width_cmd();

  if (bfm_or_mon)
  begin //{
    pl_sm_asym_mode_support = pl_sm_config.asymmetric_support;
    pl_sm_1x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_1x_mode_en;
    pl_sm_2x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_2x_mode_en;
    pl_sm_nx_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_nx_mode_en;
    pl_sm_asym_mode_en = pl_sm_1x_asym_mode_support | pl_sm_2x_asym_mode_support | pl_sm_nx_asym_mode_support;

  end //}
  else
  begin //{

    if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
    begin //{

        pl_sm_asym_mode_support = pl_sm_config.asymmetric_support;
    	pl_sm_1x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_1x_mode_en;
    	pl_sm_2x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_2x_mode_en;
    	pl_sm_nx_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_nx_mode_en;
    	pl_sm_asym_mode_en = pl_sm_1x_asym_mode_support | pl_sm_2x_asym_mode_support | pl_sm_nx_asym_mode_support;

    end //}

  end //}

  forever begin //{

    if (bfm_or_mon)
    begin //{

      @(pl_sm_config.asymmetric_support or pl_sm_config.asym_1x_mode_en or pl_sm_config.asym_2x_mode_en or pl_sm_config.asym_nx_mode_en or pl_sm_trans.from_sc_rcv_width_link_cmd or pl_sm_trans.from_sc_rcv_width_link_cmd_ack or pl_sm_trans.from_sc_rcv_width_link_cmd_nack);

      pl_sm_asym_mode_support = pl_sm_config.asymmetric_support;
      pl_sm_1x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_1x_mode_en;
      pl_sm_2x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_2x_mode_en;
      pl_sm_nx_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_nx_mode_en;
      pl_sm_asym_mode_en = pl_sm_1x_asym_mode_support | pl_sm_2x_asym_mode_support | pl_sm_nx_asym_mode_support;

    end //}
    else if (~bfm_or_mon)
    begin //{

	// if the monitor interface type is BFM, it means, it monitors
	// BFM's tx data, thus it matches DUT's behaviour. Hence, DUT's
	// register model has to be looked at inorder to decide which
	// mode is supported. On the other hand, if the interface type
	// is DUT, it means, the monitor monitors the DUT's tx data, thus
	// it behaves similar to the BFM. Hence, it is enough to look at
	// the BFM's config variable to decide on the mode supported.

      if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
      begin //{
	check_asym_mode_supp_for_dut_if = 1;
      end //}
      else if ((mon_type && pl_sm_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM))
      begin //{
	check_asym_mode_supp_for_dut_if = 0;
      end //}

      if (check_asym_mode_supp_for_dut_if)
      begin //{

        @(pl_sm_config.asymmetric_support or pl_sm_config.asym_1x_mode_en or pl_sm_config.asym_2x_mode_en or pl_sm_config.asym_nx_mode_en or pl_sm_trans.from_sc_rcv_width_link_cmd or pl_sm_trans.from_sc_rcv_width_link_cmd_ack or pl_sm_trans.from_sc_rcv_width_link_cmd_nack);

        pl_sm_asym_mode_support = pl_sm_config.asymmetric_support;
        pl_sm_1x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_1x_mode_en;
        pl_sm_2x_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_2x_mode_en;
        pl_sm_nx_asym_mode_support = pl_sm_asym_mode_support & pl_sm_config.asym_nx_mode_en;
    	pl_sm_asym_mode_en = pl_sm_1x_asym_mode_support | pl_sm_2x_asym_mode_support | pl_sm_nx_asym_mode_support;

      end //}
      else
      begin //{

	@(posedge srio_if.sim_clk);

	wait(gen3_power_mgmt_registers_read.triggered);

      end //}

    end //}

    // The expression is modified to support only 1x/2x/Nx.
    bad_rcv_width_cmd = !pl_sm_trans.rcv_width_link_cmd_ack & !pl_sm_trans.rcv_width_link_cmd_nack
			& (!pl_sm_trans.asym_mode & (pl_sm_trans.from_sc_rcv_width_link_cmd != 3'b000)
			| (pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b010) & !pl_sm_2x_asym_mode_support
			| (pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b011 | pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b100 
			| pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b101) & (!pl_sm_nx_asym_mode_support
			| (pl_sm_trans.max_width == "0x" | pl_sm_trans.max_width == "1x" | pl_sm_trans.max_width == "2x"))
			| (pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b110 | pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b111));

  end //}

endtask : gen_bad_rcv_width_cmd




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_1x_mode_rcv_cmd
/// Description : This method controls the assertion and deassertion logic for x1_mode_rcv_cmd.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_1x_mode_rcv_cmd();

  forever begin //{

    @(pl_sm_trans.asym_mode or pl_sm_trans.from_sc_rcv_width_link_cmd or pl_sm_trans.rcv_width_link_cmd_ack or pl_sm_trans.rcv_width_link_cmd_nack);

    pl_sm_trans.x1_mode_rcv_cmd = pl_sm_trans.asym_mode & (pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b001)
					& !pl_sm_trans.rcv_width_link_cmd_ack & !pl_sm_trans.rcv_width_link_cmd_nack;

  end //}

endtask : gen_1x_mode_rcv_cmd




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_2x_mode_rcv_cmd
/// Description : This method controls the assertion and deassertion logic for x2_mode_rcv_cmd.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_2x_mode_rcv_cmd();

  forever begin //{

    @(pl_sm_trans.asym_mode or pl_sm_trans.from_sc_rcv_width_link_cmd or pl_sm_2x_asym_mode_support or pl_sm_trans.rcv_width_link_cmd_ack or pl_sm_trans.rcv_width_link_cmd_nack);

    pl_sm_trans.x2_mode_rcv_cmd = pl_sm_trans.asym_mode & (pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b010) & pl_sm_2x_asym_mode_support
					& !pl_sm_trans.rcv_width_link_cmd_ack & !pl_sm_trans.rcv_width_link_cmd_nack;

  end //}

endtask : gen_2x_mode_rcv_cmd




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_nx_mode_rcv_cmd
/// Description : This method controls the assertion and deassertion logic for nx_mode_rcv_cmd.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen_nx_mode_rcv_cmd();

  forever begin //{

    @(pl_sm_trans.asym_mode or pl_sm_trans.from_sc_rcv_width_link_cmd or pl_sm_nx_asym_mode_support or pl_sm_trans.rcv_width_link_cmd_ack or pl_sm_trans.rcv_width_link_cmd_nack);

    pl_sm_trans.nx_mode_rcv_cmd = pl_sm_trans.asym_mode & ((pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b011 & pl_sm_trans.max_width == "4x")
					| (pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b100 & pl_sm_trans.max_width == "8x")
					| (pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b101 & pl_sm_trans.max_width == "16x"))
					& pl_sm_nx_asym_mode_support & !pl_sm_trans.rcv_width_link_cmd_ack & !pl_sm_trans.rcv_width_link_cmd_nack;

  end //}

endtask : gen_nx_mode_rcv_cmd





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_rcv_width_cmd_sm
/// Description : GEN3.0 "Receive width command" state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen3_rcv_width_cmd_sm();

#1;
  if (~srio_if.srio_rst_n)
  begin //{

    current_rcv_width_cmd_state = RCV_WIDTH_CMD_3;

    pl_sm_trans.rcv_width_link_cmd_ack = 0;
    pl_sm_trans.rcv_width_link_cmd_nack = 0;

    if (~bfm_or_mon)
      current_rcv_width_cmd_state_q.push_back(current_rcv_width_cmd_state);

  end //}

  forever
  begin //{

    @(negedge srio_if.sim_clk);

    if (pl_sm_trans.current_init_state == SILENT)
    begin //{

      prev_rcv_width_cmd_state = current_rcv_width_cmd_state;

      current_rcv_width_cmd_state = RCV_WIDTH_CMD_3;

      pl_sm_trans.rcv_width_link_cmd_ack = 0;
      pl_sm_trans.rcv_width_link_cmd_nack = 0;

      if (~bfm_or_mon && prev_rcv_width_cmd_state != current_rcv_width_cmd_state)
        current_rcv_width_cmd_state_q.push_back(current_rcv_width_cmd_state);

    end //}
    else
    begin //{

      prev_rcv_width_cmd_state = current_rcv_width_cmd_state;

      case (current_rcv_width_cmd_state)

	RCV_WIDTH_CMD_3 : begin //{

			    pl_sm_trans.rcv_width_link_cmd_ack = 0;
			    pl_sm_trans.rcv_width_link_cmd_nack = 0;

			    current_rcv_width_cmd_state = RCV_WIDTH_CMD_IDLE;

		  	  end //}

	RCV_WIDTH_CMD_IDLE : begin //{

		      	        if (bad_rcv_width_cmd)
		      	          current_rcv_width_cmd_state = RCV_WIDTH_CMD_1;
		      	        else if (pl_sm_trans.from_sc_rcv_width_link_cmd != 3'b000 & (pl_sm_trans.rcv_width_link_cmd_ack | pl_sm_trans.rcv_width_link_cmd_nack)) // != HOLD
		      	          current_rcv_width_cmd_state = RCV_WIDTH_CMD_2;

		    	      end //}

	RCV_WIDTH_CMD_2 : begin //{

		      	    if (pl_sm_trans.from_sc_rcv_width_link_cmd == 3'b000) // == HOLD
		      	      current_rcv_width_cmd_state = RCV_WIDTH_CMD_3;

		    	  end //}

	RCV_WIDTH_CMD_1 : begin //{

			    pl_sm_trans.rcv_width_link_cmd_nack = 1;

		      	    current_rcv_width_cmd_state = RCV_WIDTH_CMD_2;

		    	  end //}

      endcase

      if (prev_rcv_width_cmd_state != current_rcv_width_cmd_state)
        `uvm_info("SRIO_LANE_HANDLER : GEN3_RCV_WIDTH_CMD_SM", $sformatf(" Next rcv_width_cmd state is %0s", current_rcv_width_cmd_state.name()), UVM_LOW)

      if (~bfm_or_mon && prev_rcv_width_cmd_state != current_rcv_width_cmd_state)
        current_rcv_width_cmd_state_q.push_back(current_rcv_width_cmd_state);


    end //}

  end //}

endtask : gen3_rcv_width_cmd_sm




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen3_rcv_width_sm
/// Description : GEN3.0 "Receive width" state machine.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::gen3_rcv_width_sm();

#1;
  if (~srio_if.srio_rst_n)
  begin //{

    current_rcv_width_state = ASYM_RCV_IDLE;

    pl_sm_trans.end_asym_mode = 0;
    pl_sm_trans.rcv_width = pl_sm_trans.max_width;
    pl_sm_trans.receive_enable_rw = 1;
    pl_sm_trans.recovery_retrain = 0;

    if (~bfm_or_mon)
      current_rcv_width_state_q.push_back(current_rcv_width_state);

  end //}

  forever
  begin //{

    @(negedge srio_if.sim_clk);

    if (pl_sm_trans.current_init_state == SILENT | !pl_sm_trans.asym_mode)
    begin //{

      prev_rcv_width_state = current_rcv_width_state;

      current_rcv_width_state = ASYM_RCV_IDLE;

      pl_sm_trans.end_asym_mode = 0;
      pl_sm_trans.rcv_width = pl_sm_trans.max_width;
      pl_sm_trans.receive_enable_rw = 1;
      //pl_sm_trans.recovery_retrain = 0;

      if (~bfm_or_mon && prev_rcv_width_state != current_rcv_width_state)
        current_rcv_width_state_q.push_back(current_rcv_width_state);

    end //}
    else
    begin //{

      prev_rcv_width_state = current_rcv_width_state;

      case (current_rcv_width_state)

	ASYM_RCV_IDLE : begin //{

      			  pl_sm_trans.end_asym_mode = 0;
      			  pl_sm_trans.rcv_width = pl_sm_trans.max_width;
      			  pl_sm_trans.receive_enable_rw = 1;
      			  //pl_sm_trans.recovery_retrain = 0;

			  if (pl_sm_trans.asym_mode & (pl_sm_trans.max_width == "2x"))
			    current_rcv_width_state = X2_MODE_RCV;
			  else if (pl_sm_trans.asym_mode & (pl_sm_trans.max_width == "4x" || pl_sm_trans.max_width == "8x" || pl_sm_trans.max_width == "16x"))
			    current_rcv_width_state = NX_MODE_RCV;

		  	end //}

	X1_MODE_RCV : begin //{

			pl_sm_trans.rcv_width = "1x";
			pl_sm_trans.receive_enable_rw = 1;
      			pl_sm_trans.recovery_retrain = 0;

		      	if (pl_sm_trans.x1_mode_rcv_cmd && pl_sm_trans.lane_ready[0])
		      	  current_rcv_width_state = X1_MODE_RCV_ACK;
		      	else if (pl_sm_trans.x2_mode_rcv_cmd && pl_sm_trans.lane_ready[0])
		      	  current_rcv_width_state = SEEK_2X_MODE_RCV;
		      	else if (pl_sm_trans.nx_mode_rcv_cmd && pl_sm_trans.lane_ready[0])
		      	  current_rcv_width_state = SEEK_NX_MODE_RCV;
		      	else if (pl_sm_trans.lane_sync[0] && !pl_sm_trans.lane_ready[0])
		      	  current_rcv_width_state = X1_RECOVERY_RCV;
		      	else if (!pl_sm_trans.lane_sync[0])
		      	  current_rcv_width_state = ASYM_RCV_EXIT;

			if (~bfm_or_mon)
			begin //{
			  register_update_method("Power_Management_CSR", "Reciever_Width_Status", 64, reqd_field_name["Reciever_Width_Status"]);
			  void'(reqd_field_name["Reciever_Width_Status"].predict(3'b100));
      			  //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Reciever_Width_Status.predict(3'b100));
			end //}

		      end //}

	SEEK_1X_MODE_RCV : begin //{

			     rcv_width_tmr_en = 1;
			     pl_sm_trans.receive_enable_rw = 0;

		      	     if (pl_sm_trans.lane_ready[0])
		      	       current_rcv_width_state = X1_MODE_RCV_ACK;
		      	     else if (!pl_sm_trans.lane_sync[0])
		      	       current_rcv_width_state = ASYM_RCV_EXIT;
		      	     else if (rcv_width_tmr_done & !pl_sm_trans.lane_ready[0] & pl_sm_trans.lane_sync[0])
		      	       current_rcv_width_state = RCV_WIDTH_NACK;

		    	  end //}

	X1_MODE_RCV_ACK : begin //{

			    rcv_width_tmr_en = 0;
			    pl_sm_trans.rcv_width = "1x";
			    pl_sm_trans.rcv_width_link_cmd_ack = 1;

		      	    current_rcv_width_state = X1_MODE_RCV;

		    	  end //}

	X1_RECOVERY_RCV : begin //{

			    pl_sm_trans.receive_enable_rw = 0;
			    recovery_timer_start = 1;

		      	    if (pl_sm_trans.retrain & !pl_sm_trans.recovery_retrain)
		      	      current_rcv_width_state = X1_RETRAIN_RCV;
		      	    else if (pl_sm_trans.lane_ready[0] & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain))
		      	      current_rcv_width_state = X1_MODE_RCV;
		      	    else if (recovery_timer_done & !pl_sm_trans.lane_ready[0] & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain))
		      	      current_rcv_width_state = ASYM_RCV_EXIT;

		    	  end //}

	X1_RETRAIN_RCV : begin //{

			    pl_sm_trans.recovery_retrain = 1;

		      	    current_rcv_width_state = X1_RECOVERY_RCV;

		    	  end //}

	X2_MODE_RCV : begin //{

			pl_sm_trans.rcv_width = "2x";
			pl_sm_trans.receive_enable_rw = 1;
			pl_sm_trans.recovery_retrain = 0;

		      	if (pl_sm_trans.x1_mode_rcv_cmd && pl_sm_trans.two_lanes_ready)
		      	  current_rcv_width_state = SEEK_1X_MODE_RCV;
		      	else if (pl_sm_trans.x2_mode_rcv_cmd && pl_sm_trans.two_lanes_ready)
		      	  current_rcv_width_state = X2_MODE_RCV_ACK;
		      	else if (pl_sm_trans.nx_mode_rcv_cmd && pl_sm_trans.two_lanes_ready)
		      	  current_rcv_width_state = SEEK_NX_MODE_RCV;
		      	else if (!temp_2_lanes_ready && (pl_sm_trans.lane_sync[0] | pl_sm_trans.lane_sync[1]))
		      	  current_rcv_width_state = X2_RECOVERY_RCV;
		      	else if (!pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[1])
		      	  current_rcv_width_state = ASYM_RCV_EXIT;

			if (~bfm_or_mon)
			begin //{
			  register_update_method("Power_Management_CSR", "Reciever_Width_Status", 64, reqd_field_name["Reciever_Width_Status"]);
			  void'(reqd_field_name["Reciever_Width_Status"].predict(3'b010));
      			  //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Reciever_Width_Status.predict(3'b010));
			end //}

		      end //}

	SEEK_2X_MODE_RCV : begin //{

			     rcv_width_tmr_en = 1;
			     pl_sm_trans.receive_enable_rw = 0;

		      	     if (temp_2_lanes_ready)
		      	       current_rcv_width_state = X2_MODE_RCV_ACK;
		      	     else if (!pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[1])
		      	       current_rcv_width_state = ASYM_RCV_EXIT;
		      	     else if (rcv_width_tmr_done & !temp_2_lanes_ready & (pl_sm_trans.lane_sync[0] | pl_sm_trans.lane_sync[1]))
		      	       current_rcv_width_state = RCV_WIDTH_NACK;

		    	  end //}

	X2_MODE_RCV_ACK : begin //{

			    rcv_width_tmr_en = 0;
			    pl_sm_trans.rcv_width = "2x";
			    pl_sm_trans.rcv_width_link_cmd_ack = 1;

		      	    current_rcv_width_state = X2_MODE_RCV;

		    	  end //}

	X2_RECOVERY_RCV : begin //{

			    pl_sm_trans.receive_enable_rw = 0;
			    recovery_timer_start = 1;

		      	    if (pl_sm_trans.retrain & !pl_sm_trans.recovery_retrain)
		      	      current_rcv_width_state = X2_RETRAIN_RCV;
		      	    else if (pl_sm_trans.two_lanes_ready & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain))
		      	      current_rcv_width_state = X2_MODE_RCV;
		      	    else if (recovery_timer_done & !pl_sm_trans.two_lanes_ready & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain))
		      	      current_rcv_width_state = ASYM_RCV_EXIT;

		    	  end //}

	X2_RETRAIN_RCV : begin //{

			    pl_sm_trans.recovery_retrain = 1;

		      	    current_rcv_width_state = X2_RECOVERY_RCV;

		    	  end //}

	NX_MODE_RCV : begin //{

			if (pl_sm_env_config.num_of_lanes == 4)
			  pl_sm_trans.rcv_width = "4x";
			else if (pl_sm_env_config.num_of_lanes == 8)
			  pl_sm_trans.rcv_width = "8x";
			else if (pl_sm_env_config.num_of_lanes == 16)
			  pl_sm_trans.rcv_width = "16x";

			pl_sm_trans.receive_enable_rw = 1;
			pl_sm_trans.recovery_retrain = 0;

		      	if (pl_sm_trans.x1_mode_rcv_cmd && pl_sm_trans.N_lanes_ready)
		      	  current_rcv_width_state = SEEK_1X_MODE_RCV;
		      	else if (pl_sm_trans.x2_mode_rcv_cmd && pl_sm_trans.N_lanes_ready)
		      	  current_rcv_width_state = SEEK_2X_MODE_RCV;
		      	else if (pl_sm_trans.nx_mode_rcv_cmd && pl_sm_trans.N_lanes_ready)
		      	  current_rcv_width_state = NX_MODE_RCV_ACK;
		      	else if (!pl_sm_trans.N_lanes_ready && (pl_sm_trans.lane_sync[0] | pl_sm_trans.lane_sync[2]))
		      	  current_rcv_width_state = NX_RECOVERY_RCV;
		      	else if (!pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[2])
		      	  current_rcv_width_state = ASYM_RCV_EXIT;

			if (~bfm_or_mon)
			begin //{
			  if (pl_sm_env_config.num_of_lanes == 4)
			  begin //{
			    register_update_method("Power_Management_CSR", "Reciever_Width_Status", 64, reqd_field_name["Reciever_Width_Status"]);
			    void'(reqd_field_name["Reciever_Width_Status"].predict(3'b110));
      			    //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Reciever_Width_Status.predict(3'b110));
			  end //}
			  else if (pl_sm_env_config.num_of_lanes == 8)
			  begin //{
			    register_update_method("Power_Management_CSR", "Reciever_Width_Status", 64, reqd_field_name["Reciever_Width_Status"]);
			    void'(reqd_field_name["Reciever_Width_Status"].predict(3'b001));
      			    //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Reciever_Width_Status.predict(3'b001));
			  end //}
			  else if (pl_sm_env_config.num_of_lanes == 16)
			  begin //{
			    register_update_method("Power_Management_CSR", "Reciever_Width_Status", 64, reqd_field_name["Reciever_Width_Status"]);
			    void'(reqd_field_name["Reciever_Width_Status"].predict(3'b101));
      			    //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Reciever_Width_Status.predict(3'b101));
			  end //}
			end //}

		      end //}

	SEEK_NX_MODE_RCV : begin //{

			     rcv_width_tmr_en = 1;
			     pl_sm_trans.receive_enable_rw = 0;

		      	     if (pl_sm_trans.N_lanes_ready)
		      	       current_rcv_width_state = NX_MODE_RCV_ACK;
		      	     else if (!pl_sm_trans.lane_sync[0] & !pl_sm_trans.lane_sync[2])
		      	       current_rcv_width_state = ASYM_RCV_EXIT;
		      	     else if (rcv_width_tmr_done & !pl_sm_trans.N_lanes_ready & (pl_sm_trans.lane_sync[0] | pl_sm_trans.lane_sync[2]))
		      	       current_rcv_width_state = RCV_WIDTH_NACK;

		    	  end //}

	NX_MODE_RCV_ACK : begin //{

			    rcv_width_tmr_en = 0;
			    pl_sm_trans.rcv_width = "Nx";
			    pl_sm_trans.rcv_width_link_cmd_ack = 1;

		      	    current_rcv_width_state = NX_MODE_RCV;

		    	  end //}

	NX_RECOVERY_RCV : begin //{

			    pl_sm_trans.receive_enable_rw = 0;
			    recovery_timer_start = 1;

		      	    if (pl_sm_trans.retrain & !pl_sm_trans.recovery_retrain)
		      	      current_rcv_width_state = NX_RETRAIN_RCV;
		      	    else if (pl_sm_trans.N_lanes_ready & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain))
		      	      current_rcv_width_state = NX_MODE_RCV;
		      	    else if (recovery_timer_done & !pl_sm_trans.N_lanes_ready & (!pl_sm_trans.retrain | pl_sm_trans.recovery_retrain))
		      	      current_rcv_width_state = ASYM_RCV_EXIT;

		    	  end //}

	NX_RETRAIN_RCV : begin //{

			    pl_sm_trans.recovery_retrain = 1;

		      	    current_rcv_width_state = NX_RECOVERY_RCV;

		    	  end //}

	RCV_WIDTH_NACK : begin //{

			    rcv_width_tmr_en = 0;
			    pl_sm_trans.rcv_width_link_cmd_nack = 1;

			    if (pl_sm_trans.rcv_width == "1x")
		      	      current_rcv_width_state = X1_RECOVERY_RCV;
			    else if (pl_sm_trans.rcv_width == "2x")
		      	      current_rcv_width_state = X2_RECOVERY_RCV;
			    else if (pl_sm_trans.rcv_width == "4x" || pl_sm_trans.rcv_width == "8x" || pl_sm_trans.rcv_width == "16x")
		      	      current_rcv_width_state = NX_RECOVERY_RCV;

		    	 end //}

	ASYM_RCV_EXIT : begin //{

			    rcv_width_tmr_en = 0;
			    pl_sm_trans.end_asym_mode = 1;

		      	    if (!pl_sm_trans.asym_mode)
		      	      current_rcv_width_state = ASYM_RCV_IDLE;

		    	end //}

      endcase

      if (prev_rcv_width_state != current_rcv_width_state)
        `uvm_info("SRIO_LANE_HANDLER : GEN3_RCV_WIDTH_SM", $sformatf(" Next rcv_width state is %0s", current_rcv_width_state.name()), UVM_LOW)

      if (~bfm_or_mon && prev_rcv_width_state != current_rcv_width_state)
        current_rcv_width_state_q.push_back(current_rcv_width_state);

    end //}

  end //}

endtask : gen3_rcv_width_sm




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : xmt_width_timer_method
/// Description : This method runs the transmit width timer when it is enabled. If the timer
/// expires before the transmit width command is completed, then xmt_width_tmr_done is set,
/// and it is cleared once the xmt_width_tmr_en is cleared.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::xmt_width_timer_method();

  forever begin //{

    wait (xmt_width_tmr_en == 1 && xmt_width_tmr_done == 0);

    repeat (pl_sm_config.xmt_width_timer)
    begin //{

      if (xmt_width_tmr_en)
	@(posedge srio_if.sim_clk);
      else
	break;

    end //}

    if(xmt_width_tmr_en)
    begin //{

      xmt_width_tmr_done = 1;
      wait (xmt_width_tmr_en == 0);
      xmt_width_tmr_done = 0;

    end //}

  end //}

endtask : xmt_width_timer_method




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : rcv_width_timer_method
/// Description : This method runs the receive width timer when it is enabled. If the timer
/// expires before the receive width command is completed, then rcv_width_tmr_done is set,
/// and it is cleared once the rcv_width_tmr_en is cleared.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::rcv_width_timer_method();

  forever begin //{

    wait (rcv_width_tmr_en == 1 && rcv_width_tmr_done == 0);

    repeat (pl_sm_config.rcv_width_timer)
    begin //{

      if (rcv_width_tmr_en)
	@(posedge srio_if.sim_clk);
      else
	break;

    end //}

    // As per spec, rcv_width_tmr_en is cleared when the state
    // in which the rcv_width_tmr_en is set is exited.
    if(rcv_width_tmr_en)
    begin //{

      rcv_width_tmr_done = 1;
      wait (rcv_width_tmr_en == 0);
      rcv_width_tmr_done = 0;

    end //}

  end //}

endtask : rcv_width_timer_method



////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name : update_power_management_csr_from_mon
/// Description : This method updates "Status_of_My_Transmit_Width_Change" in power management CSR.
////////////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::update_power_management_csr_from_mon();

  bit update_pwr_mgmt_reg;

  @(posedge srio_if.sim_clk);

  if ((mon_type && pl_sm_env_config.srio_tx_mon_if == DUT) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == DUT))
  begin //{
    update_pwr_mgmt_reg = 0;
  end //}
  else if ((mon_type && pl_sm_env_config.srio_tx_mon_if == BFM) || (~mon_type && pl_sm_env_config.srio_rx_mon_if == BFM))
  begin //{
    update_pwr_mgmt_reg = 1;
  end //}

  if (~update_pwr_mgmt_reg)
    return;
    
  forever begin //{

    @(pl_sm_trans.xmt_width_port_cmd_ack or pl_sm_trans.xmt_width_port_cmd_nack);

    if (pl_sm_trans.xmt_width_port_cmd_ack)
    begin //{
      register_update_method("Power_Management_CSR", "Status_of_My_Transmit_Width_Change", 64, reqd_field_name["Status_of_My_Transmit_Width_Change"]);
      void'(reqd_field_name["Status_of_My_Transmit_Width_Change"].predict(2'b01));
      //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Status_of_My_Transmit_Width_Change.predict(2'b01));
    end //}
    else if (pl_sm_trans.xmt_width_port_cmd_nack)
    begin //{
      register_update_method("Power_Management_CSR", "Status_of_My_Transmit_Width_Change", 64, reqd_field_name["Status_of_My_Transmit_Width_Change"]);
      void'(reqd_field_name["Status_of_My_Transmit_Width_Change"].predict(2'b10));
      //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Status_of_My_Transmit_Width_Change.predict(2'b10));
    end //}
    else
    begin //{
      register_update_method("Power_Management_CSR", "Status_of_My_Transmit_Width_Change", 64, reqd_field_name["Status_of_My_Transmit_Width_Change"]);
      void'(reqd_field_name["Status_of_My_Transmit_Width_Change"].predict(2'b00));
      //void'(pl_sm_reg_model.Port_0_Power_Management_CSR.Status_of_My_Transmit_Width_Change.predict(2'b00));
    end //}

  end //}

endtask : update_power_management_csr_from_mon




///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : xmt_width_req_check
/// Description : This method performs the protocol checks for Transmit width command and
/// its status.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::xmt_width_req_check();

  pl_sm_common_mon_trans.xmt_width_req_cmd[mon_type] = 1;
  pl_sm_common_mon_trans.xmt_width_req_cmd[mon_type] = 0;

  pl_sm_common_mon_trans.xmt_width_req_pending[mon_type] = 1;
  pl_sm_common_mon_trans.xmt_width_req_pending[mon_type] = 0;

  forever begin //{

    wait (pl_sm_change_lp_xmt_width != 3'b000);

    fork //{

      begin //{

	repeat(pl_sm_config.xmt_lp_cmd_timer)
	begin //{

	  if (pl_sm_change_lp_xmt_width != 3'b000 || pl_sm_common_mon_trans.xmt_width_req_pending[mon_type])
	    @(posedge srio_if.sim_clk);
	  else
	  begin //{
	    break;
	  end //}

	end //}

	if (pl_sm_change_lp_xmt_width != 3'b000 || pl_sm_common_mon_trans.xmt_width_req_pending[mon_type])
	  xmt_width_req_timeout_occured = 1;

      end //}

      begin //{

	wait (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != 3'b000 || xmt_width_req_timeout_occured == 1);

	received_xmt_width_req_cmd = pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type];

	if (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != pl_sm_change_lp_xmt_width && ~xmt_width_req_timeout_occured)
	begin //{
	  `uvm_error("SRIO_PL_STATE_MACHINE : TRANSMIT_WIDTH_REQ_CMD_SET_CHECK_1", $sformatf(" Spec reference 5.16.1. Incorrect transmit width request detected in the STATUS/CNTL control cw. Expected request command is %0d, Received request command is %0d", pl_sm_change_lp_xmt_width, pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type]))
	end //}
	else if (xmt_width_req_timeout_occured)
	begin //{
	  `uvm_error("SRIO_PL_STATE_MACHINE : TRANSMIT_WIDTH_REQ_CMD_TIMEOUT_CHECK_1", $sformatf(" Spec reference 5.16.1. Timeout occured while waiting for transmit width request command to be set in the STATUS/CNTL control cw."))
	end //}
	else if (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != 3'b000)
	begin //{
	  `uvm_info("SRIO_PL_STATE_MACHINE : XMT_WIDTH_CMD_INFO", $sformatf(" xmt_width_cmd is %0d", pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type]), UVM_LOW)
	end //}

	if (~xmt_width_req_timeout_occured)
	begin //{

	  wait (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != received_xmt_width_req_cmd  || pl_sm_common_mon_trans.xmt_width_req_pending[mon_type] == 1 || xmt_width_req_timeout_occured == 1);

	  if (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != received_xmt_width_req_cmd && ~pl_sm_common_mon_trans.xmt_width_req_pending[mon_type] && ~xmt_width_req_timeout_occured)
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : TRANSMIT_WIDTH_REQ_CMD_SET_CHECK_2", $sformatf(" Spec reference 5.16.1. Transmit width request shall not change until timeout occurs or till request pending is received. Expected request command is %0d, Received request command is %0d", received_xmt_width_req_cmd, pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type]))
	  end //}
	  else if (xmt_width_req_timeout_occured)
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : TRANSMIT_WIDTH_REQ_CMD_TIMEOUT_CHECK_2", $sformatf(" Spec reference 5.16.1. Timeout occured while waiting for transmit width request pending to be set in the STATUS/CNTL control cw."))
	  end //}
	  else if (pl_sm_common_mon_trans.xmt_width_req_pending[mon_type])
	  begin //{
	    `uvm_info("SRIO_PL_STATE_MACHINE : XMT_WIDTH_STATUS_INFO", $sformatf(" xmt_width_req_pending is %0d", pl_sm_common_mon_trans.xmt_width_req_pending[mon_type]), UVM_LOW)
	  end //}

	end //}

	if (~xmt_width_req_timeout_occured && pl_sm_common_mon_trans.xmt_width_req_pending[mon_type])
	begin //{

	  wait (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] == 3'b000 || pl_sm_common_mon_trans.xmt_width_req_pending[mon_type] == 0 || pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != received_xmt_width_req_cmd || xmt_width_req_timeout_occured == 1);

	  if (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != 3'b000 && ~pl_sm_common_mon_trans.xmt_width_req_pending[mon_type])
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : TRANSMIT_WIDTH_REQ_CMD_PENDING_CHECK_1", $sformatf(" Spec reference 5.16.1. Transmit width request pending shall not be deasserted before transmit width request returns to hold."))
	  end //}
	  else if (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != 3'b000 && pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != received_xmt_width_req_cmd && pl_sm_common_mon_trans.xmt_width_req_pending[mon_type])
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : TRANSMIT_WIDTH_REQ_CMD_CHECK_3", $sformatf(" Spec reference 5.16.1. Transmit width request shall only return to hold after transmit width request pending is received. Expected request command is 0 or %0d, Received request command is %0d", received_xmt_width_req_cmd, pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type]))
	  end //}
	  else if (xmt_width_req_timeout_occured)
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : TRANSMIT_WIDTH_REQ_CMD_TIMEOUT_CHECK_3", $sformatf(" Spec reference 5.16.1. Timeout occured while waiting for transmit width request command to be cleared in the STATUS/CNTL control cw."))
	  end //}
	  else if (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] == 3'b000)
	  begin //{
	    `uvm_info("SRIO_PL_STATE_MACHINE : XMT_WIDTH_CMD_INFO", $sformatf(" xmt_width_cmd cleared"), UVM_LOW)
	  end //}

	end //}

	if (~xmt_width_req_timeout_occured && pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] == 3'b000)
	begin //{

	  wait (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != 3'b000 || pl_sm_common_mon_trans.xmt_width_req_pending[mon_type] == 0 || xmt_width_req_timeout_occured == 1);

	  if (pl_sm_common_mon_trans.xmt_width_req_cmd[~mon_type] != 3'b000 && pl_sm_common_mon_trans.xmt_width_req_pending[mon_type])
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : TRANSMIT_WIDTH_REQ_CMD_PENDING_CHECK_2", $sformatf(" Spec reference 5.16.1. Transmit width request shall not be set again before transmit width request pending is deasserted."))
	  end //}
	  else if (xmt_width_req_timeout_occured)
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : TRANSMIT_WIDTH_REQ_CMD_TIMEOUT_CHECK_4", $sformatf(" Spec reference 5.16.1. Timeout occured while waiting for transmit width request pending to be cleared in the STATUS/CNTL control cw."))
	  end //}
	  else if (~pl_sm_common_mon_trans.xmt_width_req_pending[mon_type])
	  begin //{
	    `uvm_info("SRIO_PL_STATE_MACHINE : RCV_WIDTH_STATUS_INFO", $sformatf(" xmt_width_req_pending cleared"), UVM_LOW)
	  end //}

	end //}

      end //}

    join //}

    wait (pl_sm_change_lp_xmt_width == 3'b000 && pl_sm_common_mon_trans.xmt_width_req_pending[mon_type] == 0);

    xmt_width_req_timeout_occured = 0;

  end //}

endtask : xmt_width_req_check





///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : rcv_width_cmd_check
/// Description : This method performs the protocol checks for receive width command and
/// its status.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_state_machine::rcv_width_cmd_check();

  pl_sm_common_mon_trans.rcv_width_cmd[mon_type] = 1;
  pl_sm_common_mon_trans.rcv_width_cmd[mon_type] = 0;

  pl_sm_common_mon_trans.rcv_width_ack[mon_type] = 1;
  pl_sm_common_mon_trans.rcv_width_ack[mon_type] = 0;

  pl_sm_common_mon_trans.rcv_width_nack[mon_type] = 1;
  pl_sm_common_mon_trans.rcv_width_nack[mon_type] = 0;

  forever begin //{

    wait (pl_sm_trans.rcv_width_link_cmd != 3'b000);

    fork //{

      begin //{

	repeat(pl_sm_config.rcv_width_timer)
	begin //{

	  if (pl_sm_trans.rcv_width_link_cmd != 3'b000 || pl_sm_common_mon_trans.rcv_width_ack[mon_type] || pl_sm_common_mon_trans.rcv_width_nack[mon_type])
	    @(posedge srio_if.sim_clk);
	  else
	  begin //{
	    break;
	  end //}

	end //}

	if (pl_sm_trans.rcv_width_link_cmd != 3'b000 || pl_sm_common_mon_trans.rcv_width_ack[mon_type] || pl_sm_common_mon_trans.rcv_width_nack[mon_type])
	  rcv_width_cmd_timeout_occured = 1;

      end //}

      begin //{

	wait (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != 3'b000 || rcv_width_cmd_timeout_occured == 1);

	received_rcv_width_cmd = pl_sm_common_mon_trans.rcv_width_cmd[~mon_type];

	if (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != pl_sm_trans.rcv_width_link_cmd && ~rcv_width_cmd_timeout_occured)
	begin //{
	  `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_REQ_CMD_SET_CHECK_1", $sformatf(" Spec reference 5.16.2. Incorrect receive width request detected in the STATUS/CNTL control cw. Expected request command is %0d, Received request command is %0d", pl_sm_trans.rcv_width_link_cmd, pl_sm_common_mon_trans.rcv_width_cmd[~mon_type]))
	end //}
	else if (rcv_width_cmd_timeout_occured)
	begin //{
	  `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_REQ_CMD_TIMEOUT_CHECK_1", $sformatf(" Spec reference 5.16.2. Timeout occured while waiting for receive width request command to be set in the STATUS/CNTL control cw."))
	end //}
	else if (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != 3'b000)
	begin //{
	  `uvm_info("SRIO_PL_STATE_MACHINE : RCV_WIDTH_CMD_INFO", $sformatf(" rcv_width_cmd is %0d", pl_sm_common_mon_trans.rcv_width_cmd[~mon_type]), UVM_LOW)
	end //}

	if (~rcv_width_cmd_timeout_occured)
	begin //{

	  wait (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != received_rcv_width_cmd  || pl_sm_common_mon_trans.rcv_width_ack[mon_type] == 1 || pl_sm_common_mon_trans.rcv_width_nack[mon_type] == 1 || rcv_width_cmd_timeout_occured == 1);

	  if (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != received_rcv_width_cmd && ~pl_sm_common_mon_trans.rcv_width_ack[mon_type] && ~pl_sm_common_mon_trans.rcv_width_nack[mon_type] && ~rcv_width_cmd_timeout_occured)
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_REQ_CMD_SET_CHECK_2", $sformatf(" Spec reference 5.16.2. Receive width request shall not change until timeout occurs or till ack/nack is received. Expected request command is %0d, Received request command is %0d", received_rcv_width_cmd, pl_sm_common_mon_trans.rcv_width_cmd[~mon_type]))
	  end //}
	  else if (pl_sm_common_mon_trans.rcv_width_ack[mon_type] && pl_sm_common_mon_trans.rcv_width_nack[mon_type])
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_STATUS_CHECK_1", $sformatf(" Spec reference 5.16.2. ACK and NACK shall not be set together for receive width command status."))
	  end //}
	  else if (rcv_width_cmd_timeout_occured)
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_REQ_CMD_TIMEOUT_CHECK_2", $sformatf(" Spec reference 5.16.2. Timeout occured while waiting for receive width request command to be set in the STATUS/CNTL control cw."))
	  end //}
	  else if (pl_sm_common_mon_trans.rcv_width_ack[mon_type] || pl_sm_common_mon_trans.rcv_width_nack[mon_type])
	  begin //{
	    `uvm_info("SRIO_PL_STATE_MACHINE : RCV_WIDTH_STATUS_INFO", $sformatf(" rcv_width_ack is %0d rcv_width_nack is %0d", pl_sm_common_mon_trans.rcv_width_ack[mon_type], pl_sm_common_mon_trans.rcv_width_nack[mon_type]), UVM_LOW)
	  end //}

	  received_ack = pl_sm_common_mon_trans.rcv_width_ack[mon_type];
	  received_nack = pl_sm_common_mon_trans.rcv_width_nack[mon_type];

	end //}

	if (~rcv_width_cmd_timeout_occured && (pl_sm_common_mon_trans.rcv_width_ack[mon_type] || pl_sm_common_mon_trans.rcv_width_nack[mon_type]))
	begin //{

	  wait (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] == 3'b000 || (pl_sm_common_mon_trans.rcv_width_ack[mon_type] == 0 && pl_sm_common_mon_trans.rcv_width_nack[mon_type] == 0) || pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != received_rcv_width_cmd || rcv_width_cmd_timeout_occured == 1);

	  if (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != 3'b000 && ~pl_sm_common_mon_trans.rcv_width_ack[mon_type] && ~pl_sm_common_mon_trans.rcv_width_nack[mon_type])
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_STATUS_CHECK_2", $sformatf(" Spec reference 5.16.2. Receive width status shall not be deasserted before receive width request returns to hold."))
	  end //}
	  else if (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != 3'b000 && pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != received_rcv_width_cmd && (pl_sm_common_mon_trans.rcv_width_ack[mon_type] || pl_sm_common_mon_trans.rcv_width_nack[mon_type]))
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_REQ_CMD_CHECK_3", $sformatf(" Spec reference 5.16.2. Receive width request shall only return to hold after receive width status is received. Expected request command is 0 or %0d, Received request command is %0d", received_rcv_width_cmd, pl_sm_common_mon_trans.rcv_width_cmd[~mon_type]))
	  end //}
	  else if ((pl_sm_common_mon_trans.rcv_width_ack[mon_type] != received_ack) || (pl_sm_common_mon_trans.rcv_width_nack[mon_type] != received_nack))
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_STATUS_CHECK_3", $sformatf(" Spec reference 5.16.2. ACK and NACK values once set, shall not change before receive width command returns to hold. Expected ACK value is %0d, Received ACK value is %0d, Expected NACK value is %0d, Received NACK value is %0d", received_ack, pl_sm_common_mon_trans.rcv_width_ack[mon_type], received_nack, pl_sm_common_mon_trans.rcv_width_nack[mon_type]))
	  end //}
	  else if (rcv_width_cmd_timeout_occured)
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_REQ_CMD_TIMEOUT_CHECK_3", $sformatf(" Spec reference 5.16.2. Timeout occured while waiting for receive width request command to be cleared in the STATUS/CNTL control cw."))
	  end //}
	  else if (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] == 3'b000)
	  begin //{
	    `uvm_info("SRIO_PL_STATE_MACHINE : RCV_WIDTH_CMD_INFO", $sformatf(" rcv_width_cmd cleared"), UVM_LOW)
	  end //}

	end //}

	if (~rcv_width_cmd_timeout_occured && pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] == 3'b000)
	begin //{

	  wait (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != 3'b000 || (pl_sm_common_mon_trans.rcv_width_ack[mon_type] == 0 && pl_sm_common_mon_trans.rcv_width_nack[mon_type] == 0) || rcv_width_cmd_timeout_occured == 1);

	  if (pl_sm_common_mon_trans.rcv_width_cmd[~mon_type] != 3'b000 && (pl_sm_common_mon_trans.rcv_width_ack[mon_type] || pl_sm_common_mon_trans.rcv_width_nack[mon_type]))
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_REQ_CMD_PENDING_CHECK_3", $sformatf(" Spec reference 5.16.2. Receive width command shall not be set again before receive width status is deasserted."))
	  end //}
	  else if (rcv_width_cmd_timeout_occured)
	  begin //{
	    `uvm_error("SRIO_PL_STATE_MACHINE : RECEIVE_WIDTH_REQ_CMD_TIMEOUT_CHECK_4", $sformatf(" Spec reference 5.16.2. Timeout occured while waiting for receive width status to be cleared in the STATUS/CNTL control cw."))
	  end //}
	  else if (~pl_sm_common_mon_trans.rcv_width_ack[mon_type] && ~pl_sm_common_mon_trans.rcv_width_nack[mon_type])
	  begin //{
	    `uvm_info("SRIO_PL_STATE_MACHINE : RCV_WIDTH_STATUS_INFO", $sformatf(" rcv_width_ack/nack cleared"), UVM_LOW)
	  end //}

	end //}

      end //}

    join //}

    wait (pl_sm_trans.rcv_width_link_cmd == 3'b000 && pl_sm_common_mon_trans.rcv_width_ack[mon_type] == 0 && pl_sm_common_mon_trans.rcv_width_nack[mon_type] == 0);

    rcv_width_cmd_timeout_occured = 0;

  end //}

endtask : rcv_width_cmd_check



////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Name :register_update_method 
/// Description : This method updates the appropriate register based on the port number configured.
/// It initially does a string concatenation based on the port number to form the register name, and then
/// gets the register name using the get_reg_by_name function. It then calculates the offset of the 
/// required register and then gets its name through get_reg_by_offset function. With the required register
/// name, the required field name is obtained from the get_field_by_name function and returned.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
task automatic srio_pl_state_machine::register_update_method(string reg_name, string field_name, int offset, output uvm_reg_field out_field_name);

  string temp_reg_name;
  string reg_name_prefix;
  uvm_reg_addr_t reg_addr;
  uvm_reg reqd_reg_name;
  uvm_reg reg_name1;

  if (pl_sm_env_config.port_number == 0)
    reg_name_prefix = "Port_0_";
  else if (pl_sm_env_config.port_number == 1)
    reg_name_prefix = "Port_1_";
  else if (pl_sm_env_config.port_number == 2)
    reg_name_prefix = "Port_2_";
  else if (pl_sm_env_config.port_number == 3)
    reg_name_prefix = "Port_3_";
  else if (pl_sm_env_config.port_number == 4)
    reg_name_prefix = "Port_4_";
  else if (pl_sm_env_config.port_number == 5)
    reg_name_prefix = "Port_5_";
  else if (pl_sm_env_config.port_number == 6)
    reg_name_prefix = "Port_6_";
  else if (pl_sm_env_config.port_number == 7)
    reg_name_prefix = "Port_7_";
  else if (pl_sm_env_config.port_number == 8)
    reg_name_prefix = "Port_8_";
  else if (pl_sm_env_config.port_number == 9)
    reg_name_prefix = "Port_9_";
  else if (pl_sm_env_config.port_number == 10)
    reg_name_prefix = "Port_10_";
  else if (pl_sm_env_config.port_number == 11)
    reg_name_prefix = "Port_11_";
  else if (pl_sm_env_config.port_number == 12)
    reg_name_prefix = "Port_12_";
  else if (pl_sm_env_config.port_number == 13)
    reg_name_prefix = "Port_13_";
  else if (pl_sm_env_config.port_number == 14)
    reg_name_prefix = "Port_14_";
  else if (pl_sm_env_config.port_number == 15)
    reg_name_prefix = "Port_15_";
  else
    reg_name_prefix = "Port_0_";

  temp_reg_name = {reg_name_prefix, reg_name};
  reg_name1 = pl_sm_reg_model.get_reg_by_name(temp_reg_name);
  if (reg_name1 == null)
    `uvm_warning("NULL_REGISTER_ACCESS", $sformatf(" No register found with name %0s", temp_reg_name))
  reg_addr = reg_name1.get_offset();

  if (pl_sm_env_config.srio_mode != SRIO_GEN30 && pl_sm_env_config.spec_support != V30)
  begin //{
    if (reg_name == "Link_Maintenance_Response_CSR" || reg_name == "Control_2_CSR" || reg_name == "Error_and_Status_CSR" || reg_name == "Control_CSR")
      offset = 32;
  end //}

  reqd_reg_name = pl_sm_reg_model.srio_reg_block_map.get_reg_by_offset(reg_addr+(pl_sm_env_config.port_number*offset));
  if (reqd_reg_name == null)
    `uvm_warning("NULL_REGISTER_ACCESS", $sformatf(" Register %0s. Base address : %0h, Accessed address : %0h", temp_reg_name, reg_addr, reg_addr+(pl_sm_env_config.port_number*offset)))
  else
  begin //{
    out_field_name = reqd_reg_name.get_field_by_name(field_name);
  end //}

endtask : register_update_method
