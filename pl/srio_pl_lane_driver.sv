////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_lane_driver.sv
// Project :  srio vip
// Purpose :  Physical Layer Lane Driver 
// Author  :  Mobiveil
//
// Physical Layer Lane Driver component.
//
////////////////////////////////////////////////////////////////////////////////  
typedef class srio_pl_lane_data;
typedef class srio_pl_config;
typedef class srio_pl_common_component_trans;

class srio_pl_lane_driver extends uvm_component;

  /// @cond
  `uvm_component_utils(srio_pl_lane_driver)
  /// @endcond
 

  `uvm_register_cb(srio_pl_lane_driver, srio_pl_callback)	///< Registering PL callback

  virtual srio_interface srio_if;                               ///< Virtual interface  

  srio_pl_config ld_config;                                     ///< PL config instance

  srio_pl_common_component_trans ld_trans;                      ///< PL common transaction instance

  int lane_num;	                                                ///< Lane number

  uvm_event srio_tx_lane_event;                                 ///<Event to capture any dartda to be transmitted on lane 

  srio_pl_lane_data lane_data_ins;	                        ///< PL Lane data instance. 
  
  srio_pl_lane_data lane_data_q[$];                             ///< PL Lane data queue 

  srio_env_config  ld_env_config;                               ///< ENV config instance

  uvm_object uvm_data_ins;                                      ///< UVM Object to get lane data 

  // Methods
  extern function new(string name = "srio_pl_lane_driver", uvm_component parent = null);
  extern task run_phase(uvm_phase phase);
 
  extern task update_cs_field(input int ln_num,bit [0:31] update_value); 
  extern task drive(input srio_pl_lane_data lane_data_ins,int lane_num);
  extern task eightb_10b_encode();
  extern task sixty4_67b_encode();
  extern task scramble();
  extern task scramble_gen3();
  extern task shift_scr_lfsr();
  extern task capture_lane_event();
  extern task get_lane_data();
  extern task calc_curr_rd(input int data);
  extern task calc_curr_rd_gen3(input bit [0:66] data);
  extern task calc_cw_disp(input bit [0:65] data);
  extern task calc_BIP(input bit [0:65] data);
  extern task init_lfsr;
  extern task pop_char();
  extern task drive_lane(int lane_num);
  extern task aet_lane();
  extern task cw_training();
  extern task dme_training_command();
  extern function void trn_prbs_gen();
  extern function [0:9]  choose_invalid_cg(); ///< Function to randomly choose invalid codegroup
  extern task update_scos(input int lane_num,bit [0:63] update_val);
  extern task update_dme_trn_cmd(input int lane_num,bit [0:15] update_val);
  extern task update_dme_trn_stcs(input int lane_num,bit [0:15] update_val);
  extern task dme(input bit [0:15] value,input bit ctrl) ;
  extern task drive_training(input srio_pl_lane_data lane_data_ins,input int lane_num);
  int       cw_cmd_sel,cw_tap_sel; ///< Used for codeword training
  bit       stcs_cp1_drive_flag;   ///< Below variables are used in DME training
  bit       stcs_cp0_drive_flag;
  bit       stcs_cn1_drive_flag;
  bit       coef0_st_set     ;
  bit       coefplus1_set ;
  bit       coefminus1_set;
  int        stcs_cnt;             ///< Used in Status/Control codeword update
  bit  [0:63] temp_stcs_data;
  int        dme_frame_cnt;        ///< Count DME frames transmitted
  bit        dme_cnt_flag;
  bit        form_trn_frame;
  bit        wait_frame;
  bit        gen3_trn_frame[$];
  bit        temp_q[$];           ///< DME frame variable
  bit        cw_cmd_init_flag;
  bit [0:66] training_frame[$];   ///< Training frame queue
  bit [0:3]  cw_txtap_rxed;       ///< Received training command
  bit [0:15] idle3_dme_cmd_array[int];
  bit [0:15] idle3_dme_stcs_array[int];
  bit [0:15] dme_training_command_g3; 
  bit        transit;
  int        tap0_min_value;     ///< Used in codeword training
  int        tplus1_min_value; 
  int        tplus2_min_value; 
  int        tplus3_min_value; 
  int        tplus4_min_value; 
  int        tplus5_min_value; 
  int        tplus6_min_value; 
  int        tplus7_min_value; 
  int        tminus8_min_value; 
  int        tminus7_min_value; 
  int        tminus6_min_value; 
  int        tminus5_min_value; 
  int        tminus4_min_value; 
  int        tminus3_min_value; 
  int        tminus2_min_value; 
  int        tminus1_min_value; 
  int        tap0_max_value;
  int        tplus1_max_value; 
  int        tplus2_max_value; 
  int        tplus3_max_value; 
  int        tplus4_max_value; 
  int        tplus5_max_value; 
  int        tplus6_max_value; 
  int        tplus7_max_value; 
  int        tminus8_max_value; 
  int        tminus7_max_value; 
  int        tminus6_max_value; 
  int        tminus5_max_value; 
  int        tminus4_max_value; 
  int        tminus3_max_value; 
  int        tminus2_max_value; 
  int        tminus1_max_value; 
  int        tap0_init_value;
  int        tplus1_init_value; 
  int        tplus2_init_value; 
  int        tplus3_init_value; 
  int        tplus4_init_value; 
  int        tplus5_init_value; 
  int        tplus6_init_value; 
  int        tplus7_init_value; 
  int        tminus8_init_value; 
  int        tminus7_init_value; 
  int        tminus6_init_value; 
  int        tminus5_init_value; 
  int        tminus4_init_value; 
  int        tminus3_init_value; 
  int        tminus2_init_value; 
  int        tminus1_init_value; 
  int        tap0_prst_value;
  int        tplus1_prst_value; 
  int        tplus2_prst_value; 
  int        tplus3_prst_value; 
  int        tplus4_prst_value; 
  int        tplus5_prst_value; 
  int        tplus6_prst_value; 
  int        tplus7_prst_value; 
  int        tminus8_prst_value; 
  int        tminus7_prst_value; 
  int        tminus6_prst_value; 
  int        tminus5_prst_value; 
  int        tminus4_prst_value; 
  int        tminus3_prst_value; 
  int        tminus2_prst_value; 
  int        tminus1_prst_value; 
  bit [0:66] sixty7_bit_data;    ///< Encoded 67 bit data
  bit [0:16] scr_lfsr;           ///< scrambler for GEN2
  bit [0:57] lfsr_q,lfsr_c;      ///< Scrambler info for GEN3
  bit [0:57] temp_lfsrq;
  bit update_cmd_set,update_set,start_aet; ///< Flags to control AET
  running_disparity cur_dis;     ///< Disparity variables
  running_disparity cur_dis_gen3,curr_cw_dis;

  // gen3 specific
  bit [0:63] idle3_scos_array[int];  ///<Below are vriables used 
  bit [0:63] stcs_data;              ///<for status/control codeword
  bit [0:7] port_num;                ///< generation
  bit [0:3] ln_num;
  bit       remote_trn_sup;
  bit       retrain_en;
  bit       asym_mode_en;
  bit       port_init;
  bit       txt_1xmode;
  bit [0:2] rx_width;
  bit [0:2] rx_lanes_rdy;
  bit       rx_ln_rdy;
  bit       ln_trned;
  bit [0:2] rx_width_cmd;
  bit       rx_width_cmd_ack;         
  bit       rx_width_cmd_nack;         
  bit [0:2] tx_width_req;
  bit       tx_width_pend_req;
  bit       tx_scos;
  bit [0:3] tx_equ_tap;
  bit [0:2] tx_equ_cmd;
  bit [0:2] tx_equ_st;
  bit       retrn_gnt;
  bit       retrn_rdy;
  bit       retrning;
  bit       port_ent_sil;      
  bit       lane_ent_sil;      

  int cmd_drive_cnt;
  int dme_cmd_drive_cnt;
  int dme_cmd_sel;
  bit csflag;
  bit cw_csflag;
  int csf_cnt;
  int csf_marker_array[int];     ///< Encoded CS commands
  static bit [57:0] scrambler_gen3_init_array[int]; ///< Gen3 Scrambler initial array
  bit [1:0] tplus_status_min;    ///< Below variables are used in 
  bit [1:0] tplus_status_max;    ///< AET
  bit [1:0] tplus_rst_val   ;
  bit [1:0] tplus_prst_val  ;
  bit [1:0] tminus_status_min;
  bit [1:0] tminus_status_max;
  bit [1:0] tminus_rst_val   ;
  bit [1:0] tminus_prst_val  ;
  bit [1:0] tplus_cmd_val    ;
  bit [1:0] tminus_cmd_val   ;
  bit       rst_cmd_val      ;
  bit       prst_cmd_val     ; 
  bit       ack; 
  bit       nack; 
  bit [0:31] update_value;
  bit rst_cmd;
  bit prst_cmd;
  bit rxr_trained;
  bit drive_flag;
  bit wait_flag;
  int drive_cnt;
  int dly_cnt;
  int ack_wait_cnt;
  bit timer_flag  ;
  bit ack_wait_flag,load_flag;
  bit cw_load_flag,dme_load_flag,dme_wait_flag;
  int timer_cnt   ; 
  int cnt;
  bit tx_scr_en;                   ///< Scrambler enabled
  bit cmd;                         ///< AET command
  bit [0:1] tminus_status_sent;    ///< Below variables are used in AET 
  bit [0:1] tplus_status_sent;
  bit [0:1] tap_plus_cmd;
  bit [0:1] tap_minus_cmd;
  bit [0:1] tplus_status;
  bit [0:1] tminus_status;
  bit [0:9] invalid_cg;            ///< Random invalid Codegroup to be forced on the lane to be broken

  int skew[0:15];                  ///< Random skew on each lane

  bit  lane_q[int][$];             ///< Serial data to be transmitte don each lane

  //cw training fields
  int  tap0_status_min     ;       ///< Below variables are used in codeword training
  int  tap0_status_max     ;
  int  tap0_init_val       ;
  int  tap0_prst_val       ;
  int  tplus1_status_min   ;
  int  tplus1_status_max   ;
  int  tplus1_init_val     ;
  int  tplus1_prst_val     ;
  int  tplus2_status_min   ;
  int  tplus2_status_max   ;
  int  tplus2_init_val     ;
  int  tplus2_prst_val     ;
  int  tplus3_status_min   ;
  int  tplus3_status_max   ;
  int  tplus3_init_val     ;
  int  tplus3_prst_val     ;
  int  tplus4_status_min   ;
  int  tplus4_status_max   ;
  int  tplus4_init_val     ;
  int  tplus4_prst_val     ;
  int  tplus5_status_min   ;
  int  tplus5_status_max   ;
  int  tplus5_init_val     ;
  int  tplus5_prst_val     ;
  int  tplus6_status_min   ;
  int  tplus6_status_max   ;
  int  tplus6_init_val     ;
  int  tplus6_prst_val     ;
  int  tplus7_status_min   ;
  int  tplus7_status_max   ;
  int  tplus7_init_val     ;
  int  tplus7_prst_val     ;
  int  tminus8_status_min  ;
  int  tminus8_status_max  ;
  int  tminus8_init_val    ;
  int  tminus8_prst_val    ;
  int  tminus7_status_min  ;
  int  tminus7_status_max  ;
  int  tminus7_init_val    ;
  int  tminus7_prst_val    ;
  int  tminus6_status_min  ;
  int  tminus6_status_max  ;
  int  tminus6_init_val    ;
  int  tminus6_prst_val    ;
  int  tminus5_status_min  ;
  int  tminus5_status_max  ;
  int  tminus5_init_val    ;
  int  tminus5_prst_val    ;
  int  tminus4_status_min  ;
  int  tminus4_status_max  ;
  int  tminus4_init_val    ;
  int  tminus4_prst_val    ;
  int  tminus3_status_min  ;
  int  tminus3_status_max  ;
  int  tminus3_init_val    ;
  int  tminus3_prst_val    ;
  int  tminus2_status_min  ;
  int  tminus2_status_max  ;
  int  tminus2_init_val    ;
  int  tminus2_prst_val    ;
  int  tminus1_status_min  ;
  int  tminus1_status_max  ;
  int  tminus1_init_val    ;
  int  tminus1_prst_val    ;
  int  tap0_status         ; 
  int  tplus1_status       ; 
  int  tplus2_status       ; 
  int  tplus3_status       ; 
  int  tplus4_status       ; 
  int  tplus5_status       ; 
  int  tplus6_status       ; 
  int  tplus7_status       ; 
  int  tminus8_status      ; 
  int  tminus7_status      ; 
  int  tminus6_status      ; 
  int  tminus5_status      ; 
  int  tminus4_status      ; 
  int  tminus3_status      ; 
  int  tminus2_status      ; 
  int  tminus1_status      ; 
  bit [0:63] cw_update_value     ;
  bit cw_drive_flag       ;
  bit cw_wait_flag        ;
  int cw_drive_cnt        ;
  int cw_cmd_drive_cnt    ;
  bit start_cw_trn        ;
  bit cw_update_set       ;
  bit cw_update_cmd_set   ;
  int cw_ack_wait_cnt     ;
  bit cw_timer_flag       ;
  int cw_timer_cnt        ; 
  int cw_dly_cnt          ;
  bit [0:11] prbs_reg;
  bit        prbs_out;
  int  coef0_status_min       ;                      ////< Below variables are used in DME training
  int  coef0_status_max       ;
  int  coef0_init_val         ;
  int  coef0_prst_val         ;
  int  coefplus1_status_min   ;
  int  coefplus1_status_max   ;
  int  coefplus1_init_val     ;
  int  coefplus1_prst_val     ;
  int  coefminus1_status_min  ;
  int  coefminus1_status_max  ;
  int  coefminus1_init_val    ;
  int  coefminus1_prst_val    ;
  int  coef0_status           ; 
  int  coefplus1_status       ; 
  int  coefminus1_status      ; 
  bit [0:15]  dme_cmd_update_value;
  bit [0:15]  dme_stcs_update_value;
  bit  start_dme_trn;
  bit  dme_update_stcs_set;
  bit  dme_update_cmd_set;
  bit  dme_prst_cmd;
  bit  dme_init_cmd;
  bit [0:1]  coefplus1_update;
  bit [0:1]  coefminus1_update;
  bit [0:1]  coef0_update;
  bit  dme_rxr_rdy;
  bit [0:1]  coefplus1_equ_st;
  bit [0:1]  coefminus1_equ_st;
  bit [0:1]  coef0_equ_st;
  bit lane_rdy_0_15;                ///< Lane ready to be calculated for status/control codeword
  bit lane_rdy_0_7;
  bit lane_rdy_0_3;
  bit lane_rdy_0_1;
  bit [0:22] BIP_23;
  bit lanecheck_1;
  bit ack_rcvd;
  bit nak_rcvd;
  bit [0:7] prev;

  virtual task srio_pl_cg_generated_lane0(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane1(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane2(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane3(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane4(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane5(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane6(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane7(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane8(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane9(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane10(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane11(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane12(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane13(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane14(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 
  
  virtual task srio_pl_cg_generated_lane15(ref srio_pl_lane_data tx_srio_cg, srio_env_config  ld_env_config);
  endtask 


endclass


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_lane_driver class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_lane_driver::new(string name="srio_pl_lane_driver", uvm_component parent=null);
  super.new(name, parent);
  lane_data_ins = new();
  lane_data_ins.curr_rd = NEG;
endfunction : new


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : run_phase
/// Description : run_phase method of srio_pl_lane_driver class.
/// It triggers all the methods within the class which needs to be run forever.
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::run_phase(uvm_phase phase);

 lane_q[lane_num].push_back(1);
 void'(lane_q[lane_num].pop_front());

  fork
    init_lfsr();
    pop_char();
    get_lane_data();
    if(ld_config.aet_en == 1'b1 && ld_env_config.srio_mode != SRIO_GEN30 && ld_env_config.srio_mode != SRIO_GEN13)
      aet_lane();
    if(ld_env_config.srio_interface_mode == SRIO_SERIAL)
      drive_lane(lane_num);
   if(ld_env_config.srio_mode == SRIO_GEN30)
     cw_training();
   if(ld_env_config.srio_mode == SRIO_GEN30)
     dme_training_command();
  join_none

endtask : run_phase


//////////////////////////////////////////////////////////////////////////
/// Name: choose_invalid_cg
/// Description: Randomly choose the invalid codegroup value to be placed
/// on the lane to be broken 
//////////////////////////////////////////////////////////////////////////
 function [0:9] srio_pl_lane_driver::choose_invalid_cg();
   bit [1:0] random_invalidcg;
   random_invalidcg=$urandom;
   choose_invalid_cg = INVALID_CG_ARR[random_invalidcg];
 endfunction:choose_invalid_cg


//////////////////////////////////////////////////////////////////////////
/// Name: get_lane_data
/// Description: Task to invoke capture_lane_event() 
//////////////////////////////////////////////////////////////////////////
 task srio_pl_lane_driver::get_lane_data();

  fork
      capture_lane_event();
  join
 endtask : get_lane_data 
 
//////////////////////////////////////////////////////////////////////////
/// Name: capture_lane_event
/// Description: Task to wait for lane data trigger. Based on the trigger
/// data to be transmitted on the lane is put into the transmission queue  
//////////////////////////////////////////////////////////////////////////
 task srio_pl_lane_driver::capture_lane_event();

  forever begin //{

    #1;
    srio_tx_lane_event.wait_ptrigger_data(uvm_data_ins);
    $cast(lane_data_ins, uvm_data_ins);

    lane_data_q.push_back(lane_data_ins);

  end //}

 endtask : capture_lane_event


function void srio_pl_lane_driver::trn_prbs_gen();
bit prbs_temp;

  for(int i=0;i<4096;i++)
  begin //{
   prbs_temp = prbs_reg[8] ^ prbs_reg[10];

   prbs_reg = prbs_reg >>1; 
   prbs_reg[0] = prbs_temp;

//   gen3_trn_frame.push_back(prbs_temp);
   if (i < 4094)
     gen3_trn_frame.push_back(prbs_temp);
   else
     gen3_trn_frame.push_back(0);
 end //} 


endfunction : trn_prbs_gen


task srio_pl_lane_driver::dme(input bit [0:15] value,input bit ctrl) ;
bit [0:15] temp_value;
bit temp_ctrl;
int temp_size;
bit [0:7] temp0;
temp_value = value;
temp_ctrl  = ctrl;

/*
  for(int i=0;i<16;i++)
  begin //{
    if(temp_value[i] == 1 && !transit)
    begin //{
        temp0 = 8'h0F;
        transit  = 0; 
    end //} 
    else if(temp_value[i] == 1 && transit) 
    begin //{
        temp0 = 8'hF0;
        transit  = 1;
    end //} 
    else if(temp_value[i] == 0 && !transit)
    begin //{
        temp0 = 8'h00;
        transit  = 1; 
    end //} 
    else if(temp_value[i] == 0 && transit) 
    begin //{
        temp0 = 8'hFF;
        transit  = 0;
    end //} 


    for(int j=0;j<8;j++)
    begin//{
        gen3_trn_frame.push_back(temp0[j]);
    end //}
  
  end //}
*/
  for(int i=0;i<16;i++)
  begin //{
   case (temp_value[i])
    0:
     begin//{
      case(prev)
       'hFF,
       'h0F:
          begin//{
           temp0='h00;
           prev='h00;
          end//}
       'hF0,
       'h00:
          begin//{
           temp0='hFF;
           prev='hFF;
          end//}
      endcase
     end//}
    1:
     begin//{
      case(prev)
       'hFF,
       'h0F:
          begin//{
           temp0='h0F;
           prev='h0F;
          end//}
       'hF0,
       'h00:
          begin//{
           temp0='hF0;
           prev='hF0;
          end//}
      endcase
     end//}
   endcase
    for(int j=0;j<8;j++)
    begin//{
        gen3_trn_frame.push_back(temp0[j]);
    end //}
  end //}
   
endtask : dme
 

//////////////////////////////////////////////////////////////////////////
/// Name: update_scos
/// Description: Task to store the status/control codeword to be transmitted
//////////////////////////////////////////////////////////////////////////

  task srio_pl_lane_driver::update_scos(input int lane_num,bit [0:63] update_val);

  idle3_scos_array[lane_num] = update_val;

  endtask : update_scos

//////////////////////////////////////////////////////////////////////////
/// Name: update_dme_trn_cmd
/// Description: Task to store the DME Command to be transmitted
//////////////////////////////////////////////////////////////////////////

  task srio_pl_lane_driver::update_dme_trn_cmd(input int lane_num,bit [0:15] update_val);

  idle3_dme_cmd_array[lane_num] = update_val;

  endtask : update_dme_trn_cmd

  task srio_pl_lane_driver::update_dme_trn_stcs(input int lane_num,bit [0:15] update_val);

  idle3_dme_stcs_array[lane_num] = update_val;

  endtask : update_dme_trn_stcs


//////////////////////////////////////////////////////////////////////////
/// Name: dme_training_command
/// Description: Task to generatethe DME training Command 
//////////////////////////////////////////////////////////////////////////
  task srio_pl_lane_driver::dme_training_command();
  int temp,temp1;
  forever
  begin //{
       @(negedge ld_trans.int_clk or negedge srio_if.srio_rst_n)
       begin //{
          if(~srio_if.srio_rst_n)
          begin //{
            coef0_status_min       = ld_config.bfm_dme_training_c0_min_value;
            coef0_status_max       = ld_config.bfm_dme_training_c0_max_value;
            coef0_init_val         = ld_config.bfm_dme_training_c0_init_value;
            coef0_prst_val         = ld_config.bfm_dme_training_c0_preset_value;
            coefplus1_status_min   = ld_config.bfm_dme_training_cp1_min_value;
            coefplus1_status_max   = ld_config.bfm_dme_training_cp1_max_value;
            coefplus1_init_val     = ld_config.bfm_dme_training_cp1_preset_value;
            coefplus1_prst_val     = ld_config.bfm_dme_training_cp1_preset_value;
            coefminus1_status_min  = ld_config.bfm_dme_training_cn1_min_value;
            coefminus1_status_max  = ld_config.bfm_dme_training_cn1_max_value;
            coefminus1_init_val    = ld_config.bfm_dme_training_cn1_init_value;
            coefminus1_prst_val    = ld_config.bfm_dme_training_cn1_preset_value;
            coef0_status           = ld_config.bfm_dme_training_c0_init_value; 
            coefplus1_status       = ld_config.bfm_dme_training_cp1_init_value; 
            coefminus1_status      = ld_config.bfm_dme_training_cn1_init_value; 
            dme_cmd_update_value   = 16'h0000;
            dme_stcs_update_value  = 16'h0000;
            start_dme_trn         = 0;
            dme_update_stcs_set        = 0;
            dme_update_cmd_set    = 0;
            dme_prst_cmd          = 0;
            dme_init_cmd          = 0;
            coefplus1_update      = 2'b00;
            coefminus1_update     = 2'b00;
            coef0_update          = 2'b00;
            dme_rxr_rdy           = 1'b0;
            coefplus1_equ_st      = 2'b00;
            coefminus1_equ_st     = 2'b00;
            coef0_equ_st          = 2'b00;
            dme_load_flag         = 1'b0;
            dme_wait_flag         = 1'b0;
            dme_cmd_drive_cnt     = 0;
            dme_cmd_sel           = 0; 
            coef0_st_set          = 1'b0;
            coefplus1_set      = 1'b0;
            coefminus1_set     = 1'b0;
            stcs_cn1_drive_flag = 1'b0;
            stcs_cp0_drive_flag = 1'b0;
            stcs_cp1_drive_flag = 1'b0;
          end //}
          else
          begin //{ 
              if(ld_trans.frame_lock[lane_num] == 1 && ld_env_config.srio_mode == SRIO_GEN30  && ~start_dme_trn)
              begin //{
                  start_dme_trn = 1'b1;
              end //} 
              if(start_dme_trn && ~ld_trans.lane_trained [lane_num])
              begin //{
                   // coef 0 logic
                   if(ld_trans.gen3_training_cmd_set[lane_num] && (ld_trans.gen3_training_equalizer_cmd[lane_num] != 3'b000) && ~stcs_cp0_drive_flag)
                   begin //{
                     stcs_cp0_drive_flag= 1'b1;
                     // coef0 cmd
                     case(ld_trans.gen3_training_equalizer_cmd[lane_num])

                            // transmitter equalizer tap0 received
                            3'b001   :  begin //{
                                                    if(coef0_status <= coef0_status_min)
                                                    begin //{
                                                       coef0_status = coef0_status;
                                                       coef0_equ_st   = 2'b10; 
                                                    end //}
                                                    else if(coef0_status > coef0_status_min) 
                                                    begin //{
                                                       coef0_status = coef0_status - 1;
                                                       if(coef0_status == coef0_status_min)
                                                         coef0_equ_st   = 2'b10; 
                                                       else
                                                         coef0_equ_st   = 2'b01; 
                                                    end //}
                                             end //}

                            3'b010   :  begin //{
                                                    if(coef0_status >= coef0_status_max)
                                                    begin //{
                                                       coef0_status = coef0_status;
                                                       coef0_equ_st   = 2'b11; 
                                                    end //}
                                                    else if(coef0_status < coef0_status_max) 
                                                    begin //{
                                                       coef0_status = coef0_status + 1;
                                                       if(coef0_status == coef0_status_max)
                                                         coef0_equ_st   = 2'b11; 
                                                       else
                                                         coef0_equ_st   = 2'b01; 
                                                    end //}
                                             end //}

                            3'b101   :  begin //{
                                                       coef0_status      = coef0_init_val;
                                                       coefplus1_status  = coefplus1_init_val;
                                                       coefminus1_status = coefminus1_init_val;
                                                       if(coef0_status == coef0_status_min)
                                                          coef0_equ_st = 2'b10;
                                                       else if(coef0_status == coef0_status_max)
                                                          coef0_equ_st = 2'b11;
                                                       else if(coef0_status > coef0_status_min && coef0_status < coef0_status_max)
                                                          coef0_equ_st = 2'b01;
                                                       if(coefplus1_status == coef0_status_min)
                                                          coefplus1_equ_st = 2'b10;
                                                       else if(coefplus1_status == coefplus1_status_max)
                                                          coefplus1_equ_st = 2'b11;
                                                       else if(coefplus1_status > coef0_status_min && coefplus1_status < coefplus1_status_max)
                                                          coefplus1_equ_st = 2'b01;
                                                       if(coefminus1_status == coefminus1_status_min)
                                                          coefminus1_equ_st = 2'b10;
                                                       else if(coefminus1_status == coefminus1_status_max)
                                                          coefminus1_equ_st = 2'b11;
                                                       else if(coefminus1_status > coefminus1_status_min && coefminus1_status < coefminus1_status_max)
                                                          coefminus1_equ_st = 2'b01;

                                             end //}

                            3'b110   :  begin //{
                                                       coef0_status      = coef0_prst_val;
                                                       coefplus1_status  = coefplus1_prst_val;
                                                       coefminus1_status = coefminus1_prst_val;
                                                       if(coef0_status == coef0_status_min)
                                                          coef0_equ_st = 2'b10;
                                                       else if(coef0_status == coef0_status_max)
                                                          coef0_equ_st = 2'b11;
                                                       else if(coef0_status > coef0_status_min && coef0_status < coef0_status_max)
                                                          coef0_equ_st = 2'b01;
                                                       if(coefplus1_status == coef0_status_min)
                                                          coefplus1_equ_st = 2'b10;
                                                       else if(coefplus1_status == coefplus1_status_max)
                                                          coefplus1_equ_st = 2'b11;
                                                       else if(coefplus1_status > coef0_status_min && coefplus1_status < coefplus1_status_max)
                                                          coefplus1_equ_st = 2'b01;
                                                       if(coefminus1_status == coefminus1_status_min)
                                                          coefminus1_equ_st = 2'b10;
                                                       else if(coefminus1_status == coefminus1_status_max)
                                                          coefminus1_equ_st = 2'b11;
                                                       else if(coefminus1_status > coefminus1_status_min && coefminus1_status < coefminus1_status_max)
                                                          coefminus1_equ_st = 2'b01;
                                             end //}
                           endcase
                           dme_update_stcs_set = 1'b1;
                   end //}
                   else if(ld_trans.gen3_training_cmd_set[lane_num] == 1'b0 && ld_trans.gen3_training_equalizer_cmd[lane_num] == 3'b000 && stcs_cp0_drive_flag) 
                   begin //{
                       coef0_equ_st   = 3'b000; 
                       dme_update_stcs_set = 1'b1;
                       stcs_cp0_drive_flag = 1'b0;
                   end //} 

                   // coef plus1 logic
                   if(ld_trans.gen3_training_cp1_cmd_set[lane_num] && (ld_trans.gen3_training_equalizer_cp1_cmd[lane_num] != 2'b00) && ~stcs_cp1_drive_flag)
                   begin //{
                     stcs_cp1_drive_flag= 1'b1;
                     // coef plus1 cmd
                     case(ld_trans.gen3_training_equalizer_cp1_cmd[lane_num])

                            // transmitter equalizer tap0 received
                            2'b01   :  begin //{
                                                    if(coefplus1_status <= coef0_status_min)
                                                    begin //{
                                                       coefplus1_status = coefplus1_status;
                                                       coefplus1_equ_st   = 2'b10; 
                                                    end //}
                                                    else if(coefplus1_status > coef0_status_min) 
                                                    begin //{
                                                       coefplus1_status = coefplus1_status - 1;
                                                       if(coefplus1_status == coef0_status_min)
                                                         coefplus1_equ_st   = 2'b10; 
                                                       else
                                                         coefplus1_equ_st   = 2'b01; 
                                                    end //}
                                             end //}

                            2'b10   :  begin //{
                                                    if(coefplus1_status >= coefplus1_status_max)
                                                    begin //{
                                                       coefplus1_status = coefplus1_status;
                                                       coefplus1_equ_st   = 2'b11; 
                                                    end //}
                                                    else if(coefplus1_status < coefplus1_status_max) 
                                                    begin //{
                                                       coefplus1_status = coefplus1_status + 1;
                                                       if(coefplus1_status == coefplus1_status_max)
                                                         coefplus1_equ_st   = 2'b11; 
                                                       else
                                                         coefplus1_equ_st   = 2'b01; 
                                                    end //}
                                             end //}
                           endcase
                           dme_update_stcs_set = 1'b1;
                   end //}
                   else if(ld_trans.gen3_training_cp1_cmd_set[lane_num] == 1'b0 && ld_trans.gen3_training_equalizer_cp1_cmd[lane_num] == 2'b00 && stcs_cp1_drive_flag) 
                   begin //{
                       coefplus1_equ_st   = 2'b00; 
                       dme_update_stcs_set = 1'b1;
                       stcs_cp1_drive_flag= 1'b0;
                   end //} 

                   // coef minus1 logic
                   if(ld_trans.gen3_training_cn1_cmd_set[lane_num] && (ld_trans.gen3_training_equalizer_cn1_cmd[lane_num] != 2'b00) && ~stcs_cn1_drive_flag)
                   begin //{
                     stcs_cn1_drive_flag = 1'b1;
                     // coef minus1 cmd
                     case(ld_trans.gen3_training_equalizer_cn1_cmd[lane_num])

                            // transmitter equalizer tap0 received
                            2'b01   :  begin //{
                                                    if(coefminus1_status <= coefminus1_status_min)
                                                    begin //{
                                                       coefminus1_status = coefminus1_status;
                                                       coefminus1_equ_st   = 2'b10; 
                                                    end //}
                                                    else if(coefminus1_status > coefminus1_status_min) 
                                                    begin //{
                                                       coefminus1_status = coefminus1_status - 1;
                                                       if(coefminus1_status == coefminus1_status_min)
                                                         coefminus1_equ_st   = 2'b10; 
                                                       else
                                                         coefminus1_equ_st   = 2'b01; 
                                                    end //}
                                             end //}

                            2'b10   :  begin //{
                                                    if(coefminus1_status >= coefminus1_status_max)
                                                    begin //{
                                                       coefminus1_status = coefminus1_status;
                                                       coefminus1_equ_st   = 2'b11; 
                                                    end //}
                                                    else if(coefminus1_status < coefminus1_status_max) 
                                                    begin //{
                                                       coefminus1_status = coefminus1_status + 1;
                                                       if(coefminus1_status == coefminus1_status_max)
                                                         coefminus1_equ_st   = 2'b11; 
                                                       else
                                                         coefminus1_equ_st   = 2'b01; 
                                                    end //}
                                             end //}
                           endcase
                           dme_update_stcs_set = 1'b1;
                   end //}
                   else if(ld_trans.gen3_training_cn1_cmd_set[lane_num] == 1'b0 && ld_trans.gen3_training_equalizer_cn1_cmd[lane_num] == 2'b00 && stcs_cn1_drive_flag) 
                   begin //{
                       coefminus1_equ_st   = 2'b00; 
                       dme_update_stcs_set = 1'b1;
                       stcs_cn1_drive_flag = 1'b0;
                   end //} 

                 // start of cmd drive logic
                 // drive cmd logic
               if(ld_config.dme_cmd_kind == DME_CMD_DISABLED )
               begin //{
                    `uvm_info("SRIO_PL_LANE DRIVER : ", $sformatf("DME TRAINING COMMAND DRIVE IS DISABLED lane_num is %d",lane_num), UVM_LOW)
               end //}
               else if(ld_config.dme_cmd_kind == DME_CMD_ENABLED && ld_config.dme_cmd_cnt == dme_cmd_drive_cnt && ~dme_load_flag )
               begin //{
                //    `uvm_info("SRIO_PL_LANE DRIVER : ", $sformatf("DME TRAINING COMMAND DRIVE CNT REACHED STOPPED SENDING COMMANDS lane_num is %d",lane_num), UVM_LOW)
               end //}
               else if(ld_config.dme_cmd_kind == DME_CMD_ENABLED && ld_config.dme_cmd_cnt != dme_cmd_drive_cnt && ~dme_load_flag && ~coef0_st_set && ~coefplus1_set && ~coefminus1_set )
               begin //{
                    dme_load_flag = 1'b1;
                    case(ld_config.dme_cmd_type)
                       DME_HOLD             : begin //{
                                                coef0_update      = 2'b00;
                                                coefplus1_update  = 2'b00;
                                                coefminus1_update = 2'b00;
                                                dme_init_cmd = 1'b0;
                                                dme_prst_cmd = 1'b0;
                                             end  //} 
                       DME_DECR             : begin //{
                                                coef0_update      = 2'b10;
                                                coefplus1_update  = 2'b10;
                                                coefminus1_update = 2'b10;
                                                dme_init_cmd = 1'b0;
                                                dme_prst_cmd = 1'b0;
                                             end  //} 
                       DME_INCR             : begin //{
                                                coef0_update      = 2'b01;
                                                coefplus1_update  = 2'b01;
                                                coefminus1_update = 2'b01;
                                                dme_init_cmd = 1'b0;
                                                dme_prst_cmd = 1'b0;
                                             end  //} 
                       DME_INIT             : begin //{
                                                coef0_update      = 2'b00;
                                                coefplus1_update  = 2'b00;
                                                coefminus1_update = 2'b00;
                                                dme_init_cmd = 1'b1;
                                                dme_prst_cmd = 1'b0;
                                             end  //} 
                       DME_PRST             : begin //{
                                                coef0_update      = 2'b00;
                                                coefplus1_update  = 2'b00;
                                                coefminus1_update = 2'b00;
                                                dme_prst_cmd = 1'b1;
                                                dme_init_cmd = 1'b0;
                                             end  //} 

                       DME_CMD_RANDOM       : begin //{
                                                 dme_cmd_sel = $urandom_range(1,5);
                                                 case(dme_cmd_sel)
                                            
                                                      1   : begin //{
                                                              coef0_update      = 2'b00;
                                                              coefplus1_update  = 2'b00;
                                                              coefminus1_update = 2'b00;
                                                              dme_init_cmd = 1'b0;
                                                              dme_prst_cmd = 1'b0;
                                                            end //}
                                                   
                                                      2   : begin //{
                                                              coef0_update      = 2'b10;
                                                              coefplus1_update  = 2'b10;
                                                              coefminus1_update = 2'b10;
                                                              dme_init_cmd = 1'b0;
                                                              dme_prst_cmd = 1'b0;
                                                            end //}
                                                      3   : begin //{
                                                              coef0_update      = 2'b01;
                                                              coefplus1_update  = 2'b01;
                                                              coefminus1_update = 2'b01;
                                                              dme_init_cmd = 1'b0;
                                                              dme_prst_cmd = 1'b0;
                                                            end //}
                                                      4   : begin //{
                                                              coef0_update      = 2'b00;
                                                              coefplus1_update  = 2'b00;
                                                              coefminus1_update = 2'b00;
                                                              dme_init_cmd = 1'b1;
                                                              dme_prst_cmd = 1'b0;
                                                            end //}
                                                      5   : begin //{
                                                              coef0_update      = 2'b00;
                                                              coefplus1_update  = 2'b00;
                                                              coefminus1_update = 2'b00;
                                                              dme_init_cmd = 1'b0;
                                                              dme_prst_cmd = 1'b1;
                                                            end //}
                                                endcase

                                              end //}  
                   
                    endcase // cw cmd type
                    dme_update_cmd_set = 1'b1;
                    dme_cmd_drive_cnt = dme_cmd_drive_cnt + 1;
                end //}
                else if(dme_load_flag && coef0_st_set && coefplus1_set && coefminus1_set )
                begin //{
                    if(ld_trans.gen3_training_equalizer_status[lane_num] == 3'b000 && ld_trans.gen3_training_equalizer_cp1_status[lane_num] == 2'b00 && ld_trans.gen3_training_equalizer_cn1_status[lane_num] == 2'b00)
                    begin //{ 
                      dme_load_flag = 1'b0;
                      coef0_st_set  = 1'b0;
                      coefplus1_set  = 1'b0;
                      coefminus1_set  = 1'b0;
                      coef0_update      = 2'b00;
                      coefplus1_update  = 2'b00;
                      coefminus1_update = 2'b00;
                      dme_init_cmd = 1'b0;
                      dme_prst_cmd = 1'b0;
                      dme_update_cmd_set = 1'b1;
                    end //}
                end //}
                else if(dme_load_flag && ~coef0_st_set &&  ~coefplus1_set && ~coefminus1_set)
                begin //{
                    if(ld_trans.gen3_training_equalizer_status[lane_num] != 3'b000)
                    begin //{ 
                        coef0_update = 2'b00;
                        dme_init_cmd = 1'b0;
                        dme_prst_cmd = 1'b0;
                        coef0_st_set = 1'b1;
                    end //}
                    if(ld_trans.gen3_training_equalizer_cp1_status[lane_num] != 2'b00)
                    begin //{ 
                        coefplus1_update = 2'b00;
                        dme_init_cmd = 1'b0;
                        dme_prst_cmd = 1'b0;
                        coefplus1_set = 1'b1;
                    end //}
                    if(ld_trans.gen3_training_equalizer_cn1_status[lane_num] != 2'b00)
                    begin //{ 
                        coefminus1_update = 2'b00;
                        dme_init_cmd = 1'b0;
                        dme_prst_cmd = 1'b0;
                        coefminus1_set = 1'b1;
                    end //}
                    if(coefminus1_set && coefplus1_set && coef0_st_set)
                    begin //{
                        dme_update_cmd_set = 1'b1;
                    end //}
                end //}

                  if(dme_update_cmd_set)
                  begin //{
                       dme_cmd_update_value = {2'b00,dme_prst_cmd,dme_init_cmd,6'b000000,coefplus1_update,coef0_update,coefminus1_update};
                       update_dme_trn_cmd(lane_num,dme_cmd_update_value);
                       dme_update_cmd_set = 1'b0;
                  end //}
                  if(dme_update_stcs_set)
                  begin //{
                       dme_stcs_update_value = {dme_rxr_rdy,1'b0,8'h00,coefplus1_equ_st,coef0_equ_st,coefminus1_equ_st};
                       update_dme_trn_stcs(lane_num,dme_stcs_update_value);
                       dme_update_stcs_set     = 1'b0;
                  end //}

              end //}
              else if(ld_trans.lane_trained [lane_num]) 
              begin //{
                dme_stcs_update_value = {ld_trans.lane_trained [lane_num],1'b0,8'h00,6'b000000};
                update_dme_trn_stcs(lane_num,dme_stcs_update_value);
              end //}
          end //} 
       end //}
  end //}
 
  endtask : dme_training_command


//////////////////////////////////////////////////////////////////////////
/// Name: cw_training
/// Description: Task to generate the CW training Command 
//////////////////////////////////////////////////////////////////////////
  task srio_pl_lane_driver::cw_training();
  int temp,temp1;
  bit dis_onc=0;
  forever
  begin //{
       @(negedge ld_trans.int_clk or negedge srio_if.srio_rst_n)
       begin //{
          if(~srio_if.srio_rst_n)
          begin //{
            port_num            = 8'h00;
            ln_num              = lane_num;
            remote_trn_sup      = ld_config.aet_en;
            retrain_en          = ld_config.retrain_en ;
            asym_mode_en        = ld_config.asymmetric_support;
            port_init           = ld_trans.port_initialized;
            txt_1xmode          = 1'b0;
            rx_width            = 3'b011;
            rx_lanes_rdy        = 3'b000; 
            rx_ln_rdy           = 1'b0;
            ln_trned            = 1'b0 ;
            rx_width_cmd        = 3'b000;
            rx_width_cmd_ack    = 1'b0;         
            rx_width_cmd_nack   = 1'b0;         
            tx_width_req        = 3'b000;
            tx_width_pend_req   = 1'b0;
            tx_scos             = 1'b0;
            tx_equ_tap          = 4'h0;
            tx_equ_cmd          = 3'b000;
            tx_equ_st           = 3'b000;
            retrn_gnt           = 1'b0;
            retrn_rdy           = 1'b0;
            retrning            = 1'b0;
            cw_cmd_init_flag    = 1'b0;   
            port_ent_sil        = 1'b0;      
            lane_ent_sil        = 1'b0;      
            tap0_status_min     = ld_config.tap0_min_value;
            tap0_status_max     = ld_config.tap0_max_value;
            tap0_init_val       = ld_config.tap0_init_value;
            tap0_prst_val       = ld_config.tap0_prst_value;
            tplus1_status_min   = ld_config.tplus1_min_value;
            tplus1_status_max   = ld_config.tplus1_max_value;
            tplus1_init_val     = ld_config.tplus1_init_value;
            tplus1_prst_val     = ld_config.tplus1_prst_value;
            tplus2_status_min   = ld_config.tplus2_min_value;
            tplus2_status_max   = ld_config.tplus2_max_value;
            tplus2_init_val     = ld_config.tplus2_init_value;
            tplus2_prst_val     = ld_config.tplus2_prst_value;
            tplus3_status_min   = ld_config.tplus3_min_value;
            tplus3_status_max   = ld_config.tplus3_max_value;
            tplus3_init_val     = ld_config.tplus3_init_value;
            tplus3_prst_val     = ld_config.tplus3_prst_value;
            tplus4_status_min   = ld_config.tplus4_min_value;
            tplus4_status_max   = ld_config.tplus4_max_value;
            tplus4_init_val     = ld_config.tplus4_init_value;
            tplus4_prst_val     = ld_config.tplus4_prst_value;
            tplus5_status_min   = ld_config.tplus5_min_value;
            tplus5_status_max   = ld_config.tplus5_max_value;
            tplus5_init_val     = ld_config.tplus5_init_value;
            tplus5_prst_val     = ld_config.tplus5_prst_value;
            tplus6_status_min   = ld_config.tplus6_min_value;
            tplus6_status_max   = ld_config.tplus6_max_value;
            tplus6_init_val     = ld_config.tplus6_init_value;
            tplus6_prst_val     = ld_config.tplus6_prst_value;
            tplus7_status_min   = ld_config.tplus7_min_value;
            tplus7_status_max   = ld_config.tplus7_max_value;
            tplus7_init_val     = ld_config.tplus7_init_value;
            tplus7_prst_val     = ld_config.tplus7_prst_value;
            tminus8_status_min   = ld_config.tminus8_min_value;
            tminus8_status_max   = ld_config.tminus8_max_value;
            tminus8_init_val     = ld_config.tminus8_init_value;
            tminus8_prst_val     = ld_config.tminus8_prst_value;
            tminus7_status_min   = ld_config.tminus7_min_value;
            tminus7_status_max   = ld_config.tminus7_max_value;
            tminus7_init_val     = ld_config.tminus7_init_value;
            tminus7_prst_val     = ld_config.tminus7_prst_value;
            tminus6_status_min   = ld_config.tminus6_min_value;
            tminus6_status_max   = ld_config.tminus6_max_value;
            tminus6_init_val     = ld_config.tminus6_init_value;
            tminus6_prst_val     = ld_config.tminus6_prst_value;
            tminus5_status_min   = ld_config.tminus5_min_value;
            tminus5_status_max   = ld_config.tminus5_max_value;
            tminus5_init_val     = ld_config.tminus5_init_value;
            tminus5_prst_val     = ld_config.tminus5_prst_value;
            tminus4_status_min   = ld_config.tminus4_min_value;
            tminus4_status_max   = ld_config.tminus4_max_value;
            tminus4_init_val     = ld_config.tminus4_init_value;
            tminus4_prst_val     = ld_config.tminus4_prst_value;
            tminus3_status_min   = ld_config.tminus3_min_value;
            tminus3_status_max   = ld_config.tminus3_max_value;
            tminus3_init_val     = ld_config.tminus3_init_value;
            tminus3_prst_val     = ld_config.tminus3_prst_value;
            tminus2_status_min   = ld_config.tminus2_min_value;
            tminus2_status_max   = ld_config.tminus2_max_value;
            tminus2_init_val     = ld_config.tminus2_init_value;
            tminus2_prst_val     = ld_config.tminus2_prst_value;
            tminus1_status_min   = ld_config.tminus1_min_value;
            tminus1_status_max   = ld_config.tminus1_max_value;
            tminus1_init_val     = ld_config.tminus1_init_value;
            tminus1_prst_val     = ld_config.tminus1_prst_value;
            tap0_status          = ld_config.tap0_max_value; 
            tplus1_status        = ld_config.tplus1_max_value; 
            tplus2_status        = ld_config.tplus2_max_value; 
            tplus3_status        = ld_config.tplus3_max_value; 
            tplus4_status        = ld_config.tplus4_max_value; 
            tplus5_status        = ld_config.tplus5_max_value; 
            tplus6_status        = ld_config.tplus6_max_value; 
            tplus7_status        = ld_config.tplus7_max_value; 
            tminus8_status       = ld_config.tminus8_max_value; 
            tminus7_status       = ld_config.tminus7_max_value; 
            tminus6_status       = ld_config.tminus6_max_value; 
            tminus5_status       = ld_config.tminus5_max_value; 
            tminus4_status       = ld_config.tminus4_max_value; 
            tminus3_status       = ld_config.tminus3_max_value; 
            tminus2_status       = ld_config.tminus2_max_value; 
            tminus1_status       = ld_config.tminus1_max_value; 
            cw_update_value      = 64'h0000;
            cw_drive_flag        = 1'b0;
            cw_wait_flag         = 1'b0;
            cw_drive_cnt         = 0;
            cw_cmd_drive_cnt     = 0;
            start_cw_trn         = 0;
            cw_update_set        = 0;
            cw_update_cmd_set    = 0;
            cw_ack_wait_cnt      = 0;
            cw_timer_flag        = 0;
            cw_timer_cnt         = 0; 
            cw_dly_cnt           = 0;
          end //}
          else
          begin //{ 
              if(ld_trans.lane_sync[lane_num] == 1 && ld_env_config.srio_mode == SRIO_GEN30  && ~start_cw_trn)
              begin //{
                  start_cw_trn = 1'b1;
              end //} 
              if(start_cw_trn && ~ld_trans.lane_trained [lane_num])
              begin //{
                   if(ld_trans.gen3_training_cmd_set[lane_num] && (ld_trans.gen3_training_equalizer_cmd[lane_num] != 3'b000))
                   begin //{
                     // decrement cmd rxed
                     if(ld_trans.gen3_training_equalizer_cmd[lane_num] == 3'b001)
                     begin //{
                       cw_txtap_rxed = ld_trans.gen3_training_equalizer_tap[lane_num];  
                   
                       case(cw_txtap_rxed) 

                            // transmitter equalizer tap0 received
                            CW_CMD_TAP0   :  begin //{
                                                    if(tap0_status <= tap0_status_min)
                                                    begin //{
                                                       tap0_status = tap0_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tap0_status > tap0_status_min) 
                                                    begin //{
                                                       tap0_status = tap0_status - 1;
                                                       if(tap0_status == tap0_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus1 received
                            CW_CMD_TPLUS1 :  begin //{
                                                    if(tplus1_status <= tplus1_status_min)
                                                    begin //{
                                                       tplus1_status = tplus1_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tplus1_status > tplus1_status_min) 
                                                    begin //{
                                                       tplus1_status = tplus1_status - 1;
                                                       if(tplus1_status == tplus1_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}


                            // transmitter equalizer tplus2 received
                            CW_CMD_TPLUS2 :  begin //{
                                                    if(tplus2_status <= tplus2_status_min)
                                                    begin //{
                                                       tplus2_status = tplus2_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tplus2_status > tplus2_status_min) 
                                                    begin //{
                                                       tplus2_status = tplus2_status - 1;
                                                       if(tplus2_status == tplus2_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus3 received
                            CW_CMD_TPLUS3 :  begin //{
                                                    if(tplus3_status <= tplus3_status_min)
                                                    begin //{
                                                       tplus3_status = tplus3_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tplus3_status > tplus3_status_min) 
                                                    begin //{
                                                       tplus3_status = tplus3_status - 1;
                                                       if(tplus3_status == tplus3_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus4 received
                            CW_CMD_TPLUS4 :  begin //{
                                                    if(tplus4_status <= tplus4_status_min)
                                                    begin //{
                                                       tplus4_status = tplus4_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tplus4_status > tplus4_status_min) 
                                                    begin //{
                                                       tplus4_status = tplus4_status - 1;
                                                       if(tplus4_status == tplus4_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus5 received
                            CW_CMD_TPLUS5 :  begin //{
                                                    if(tplus5_status <= tplus5_status_min)
                                                    begin //{
                                                       tplus5_status = tplus5_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tplus5_status > tplus5_status_min) 
                                                    begin //{
                                                       tplus5_status = tplus5_status - 1;
                                                       if(tplus5_status == tplus5_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus6 received
                            CW_CMD_TPLUS6 :  begin //{
                                                    if(tplus6_status <= tplus6_status_min)
                                                    begin //{
                                                       tplus6_status = tplus6_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tplus6_status > tplus6_status_min) 
                                                    begin //{
                                                       tplus6_status = tplus6_status - 1;
                                                       if(tplus6_status == tplus6_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus7 received
                            CW_CMD_TPLUS7 :  begin //{
                                                    if(tplus7_status <= tplus7_status_min)
                                                    begin //{
                                                       tplus7_status = tplus7_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tplus7_status > tplus7_status_min) 
                                                    begin //{
                                                       tplus7_status = tplus7_status - 1;
                                                       if(tplus7_status == tplus7_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus8 received
                            CW_CMD_TMINUS8 :  begin //{
                                                    if(tminus8_status <= tminus8_status_min)
                                                    begin //{
                                                       tminus8_status = tminus8_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tminus8_status > tminus8_status_min) 
                                                    begin //{
                                                       tminus8_status = tminus8_status - 1;
                                                       if(tminus8_status == tminus8_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus7 received
                            CW_CMD_TMINUS7 :  begin //{
                                                    if(tminus7_status <= tminus7_status_min)
                                                    begin //{
                                                       tminus7_status = tminus7_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tminus7_status > tminus7_status_min) 
                                                    begin //{
                                                       tminus7_status = tminus7_status - 1;
                                                       if(tminus7_status == tminus7_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus6 received
                            CW_CMD_TMINUS6 :  begin //{
                                                    if(tminus6_status <= tminus6_status_min)
                                                    begin //{
                                                       tminus6_status = tminus6_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tminus6_status > tminus6_status_min) 
                                                    begin //{
                                                       tminus6_status = tminus6_status - 1;
                                                       if(tminus6_status == tminus6_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus5 received
                            CW_CMD_TMINUS5 :  begin //{
                                                    if(tminus5_status <= tminus5_status_min)
                                                    begin //{
                                                       tminus5_status = tminus5_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tminus5_status > tminus5_status_min) 
                                                    begin //{
                                                       tminus5_status = tminus5_status - 1;
                                                       if(tminus5_status == tminus5_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus4 received
                            CW_CMD_TMINUS4 :  begin //{
                                                    if(tminus4_status <= tminus4_status_min)
                                                    begin //{
                                                       tminus4_status = tminus4_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tminus4_status > tminus4_status_min) 
                                                    begin //{
                                                       tminus4_status = tminus4_status - 1;
                                                       if(tminus4_status == tminus4_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus3 received
                            CW_CMD_TMINUS3 :  begin //{
                                                    if(tminus3_status <= tminus3_status_min)
                                                    begin //{
                                                       tminus3_status = tminus3_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tminus3_status > tminus3_status_min) 
                                                    begin //{
                                                       tminus3_status = tminus3_status - 1;
                                                       if(tminus3_status == tminus3_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus2 received
                            CW_CMD_TMINUS2 :  begin //{
                                                    if(tminus2_status <= tminus2_status_min)
                                                    begin //{
                                                       tminus2_status = tminus2_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tminus2_status > tminus2_status_min) 
                                                    begin //{
                                                       tminus2_status = tminus2_status - 1;
                                                       if(tminus2_status == tminus2_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus1 received
                            CW_CMD_TMINUS1 :  begin //{
                                                    if(tminus1_status <= tminus1_status_min)
                                                    begin //{
                                                       tminus1_status = tminus1_status;
                                                       tx_equ_st   = 3'b010; 
                                                    end //}
                                                    else if(tminus1_status > tminus1_status_min) 
                                                    begin //{
                                                       tminus1_status = tminus1_status - 1;
                                                       if(tminus1_status == tminus1_status_min)
                                                         tx_equ_st   = 3'b010; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}
                       endcase
                       cw_update_set = 1'b1;
                     end //}
                     // increment cmd rxed
                     else if(ld_trans.gen3_training_equalizer_cmd[lane_num] == 3'b010)
                     begin //{
                       cw_txtap_rxed = ld_trans.gen3_training_equalizer_tap[lane_num];  
                   
                       case(cw_txtap_rxed) 

                            // transmitter equalizer tap0 received
                            CW_CMD_TAP0   :  begin //{
                                                    if(tap0_status >= tap0_status_max)
                                                    begin //{
                                                       tap0_status = tap0_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tap0_status < tap0_status_max) 
                                                    begin //{
                                                       tap0_status = tap0_status + 1;
                                                       if(tap0_status == tap0_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus1 received
                            CW_CMD_TPLUS1 :  begin //{
                                                    if(tplus1_status >= tplus1_status_max)
                                                    begin //{
                                                       tplus1_status = tplus1_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tplus1_status < tplus1_status_max) 
                                                    begin //{
                                                       tplus1_status = tplus1_status + 1;
                                                       if(tplus1_status == tplus1_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}


                            // transmitter equalizer tplus2 received
                            CW_CMD_TPLUS2 :  begin //{
                                                    if(tplus2_status >= tplus2_status_max)
                                                    begin //{
                                                       tplus2_status = tplus2_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tplus2_status < tplus2_status_max) 
                                                    begin //{
                                                       tplus2_status = tplus2_status + 1;
                                                       if(tplus2_status == tplus2_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus3 received
                            CW_CMD_TPLUS3 :  begin //{
                                                    if(tplus3_status >= tplus3_status_max)
                                                    begin //{
                                                       tplus3_status = tplus3_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tplus3_status < tplus3_status_max) 
                                                    begin //{
                                                       tplus3_status = tplus3_status + 1;
                                                       if(tplus3_status == tplus3_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus4 received
                            CW_CMD_TPLUS4 :  begin //{
                                                    if(tplus4_status >= tplus4_status_max)
                                                    begin //{
                                                       tplus4_status = tplus4_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tplus4_status < tplus4_status_max) 
                                                    begin //{
                                                       tplus4_status = tplus4_status + 1;
                                                       if(tplus4_status == tplus4_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus5 received
                            CW_CMD_TPLUS5 :  begin //{
                                                    if(tplus5_status >= tplus5_status_max)
                                                    begin //{
                                                       tplus5_status = tplus5_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tplus5_status < tplus5_status_max) 
                                                    begin //{
                                                       tplus5_status = tplus5_status + 1;
                                                       if(tplus5_status == tplus5_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus6 received
                            CW_CMD_TPLUS6 :  begin //{
                                                    if(tplus6_status >= tplus6_status_max)
                                                    begin //{
                                                       tplus6_status = tplus6_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tplus6_status < tplus6_status_max) 
                                                    begin //{
                                                       tplus6_status = tplus6_status + 1;
                                                       if(tplus6_status == tplus6_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tplus7 received
                            CW_CMD_TPLUS7 :  begin //{
                                                    if(tplus7_status >= tplus7_status_max)
                                                    begin //{
                                                       tplus7_status = tplus7_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tplus7_status < tplus7_status_max) 
                                                    begin //{
                                                       tplus7_status = tplus7_status + 1;
                                                       if(tplus7_status == tplus7_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus8 received
                            CW_CMD_TMINUS8 :  begin //{
                                                    if(tminus8_status >= tminus8_status_max)
                                                    begin //{
                                                       tminus8_status = tminus8_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tminus8_status < tminus8_status_max) 
                                                    begin //{
                                                       tminus8_status = tminus8_status + 1;
                                                       if(tminus8_status == tminus8_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus7 received
                            CW_CMD_TMINUS7 :  begin //{
                                                    if(tminus7_status >= tminus7_status_max)
                                                    begin //{
                                                       tminus7_status = tminus7_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tminus7_status < tminus7_status_max) 
                                                    begin //{
                                                       tminus7_status = tminus7_status + 1;
                                                       if(tminus7_status == tminus7_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus6 received
                            CW_CMD_TMINUS6 :  begin //{
                                                    if(tminus6_status >= tminus6_status_max)
                                                    begin //{
                                                       tminus6_status = tminus6_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tminus6_status < tminus6_status_max) 
                                                    begin //{
                                                       tminus6_status = tminus6_status + 1;
                                                       if(tminus6_status == tminus6_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus5 received
                            CW_CMD_TMINUS5 :  begin //{
                                                    if(tminus5_status >= tminus5_status_max)
                                                    begin //{
                                                       tminus5_status = tminus5_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tminus5_status < tminus5_status_max) 
                                                    begin //{
                                                       tminus5_status = tminus5_status + 1;
                                                       if(tminus5_status == tminus5_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus4 received
                            CW_CMD_TMINUS4 :  begin //{
                                                    if(tminus4_status >= tminus4_status_max)
                                                    begin //{
                                                       tminus4_status = tminus4_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tminus4_status < tminus4_status_max) 
                                                    begin //{
                                                       tminus4_status = tminus4_status + 1;
                                                       if(tminus4_status == tminus4_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus3 received
                            CW_CMD_TMINUS3 :  begin //{
                                                    if(tminus3_status >= tminus3_status_max)
                                                    begin //{
                                                       tminus3_status = tminus3_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tminus3_status < tminus3_status_max) 
                                                    begin //{
                                                       tminus3_status = tminus3_status + 1;
                                                       if(tminus3_status == tminus3_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus2 received
                            CW_CMD_TMINUS2 :  begin //{
                                                    if(tminus2_status >= tminus2_status_max)
                                                    begin //{
                                                       tminus2_status = tminus2_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tminus2_status < tminus2_status_max) 
                                                    begin //{
                                                       tminus2_status = tminus2_status + 1;
                                                       if(tminus2_status == tminus2_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}

                            // transmitter equalizer tminus1 received
                            CW_CMD_TMINUS1 :  begin //{
                                                    if(tminus1_status >= tminus1_status_max)
                                                    begin //{
                                                       tminus1_status = tminus1_status;
                                                       tx_equ_st   = 3'b011; 
                                                    end //}
                                                    else if(tminus1_status < tminus1_status_max) 
                                                    begin //{
                                                       tminus1_status = tminus1_status + 1;
                                                       if(tminus1_status == tminus1_status_max)
                                                         tx_equ_st   = 3'b011; 
                                                       else
                                                         tx_equ_st   = 3'b001; 
                                                    end //}
                                             end //}
                       endcase
                       cw_update_set = 1'b1;
                     end //}
                     // initialize cmd rxed
                     else if(ld_trans.gen3_training_equalizer_cmd[lane_num] == 3'b101)
                     begin //{
                       cw_txtap_rxed = ld_trans.gen3_training_equalizer_tap[lane_num];  
                   
                       case(cw_txtap_rxed) 

                            // transmitter equalizer tap0 received
                            CW_CMD_TAP0   :  begin //{
                                                tap0_status = tap0_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus1 received
                            CW_CMD_TPLUS1 :  begin //{
                                                tplus1_status = tplus1_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}


                            // transmitter equalizer tplus2 received
                            CW_CMD_TPLUS2 :  begin //{
                                                tplus2_status = tplus2_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus3 received
                            CW_CMD_TPLUS3 :  begin //{
                                                tplus3_status = tplus3_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus4 received
                            CW_CMD_TPLUS4 :  begin //{
                                                tplus4_status = tplus4_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus5 received
                            CW_CMD_TPLUS5 :  begin //{
                                                tplus5_status = tplus5_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus6 received
                            CW_CMD_TPLUS6 :  begin //{
                                                tplus6_status = tplus6_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus7 received
                            CW_CMD_TPLUS7 :  begin //{
                                                tplus7_status = tplus7_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus8 received
                            CW_CMD_TMINUS8 :  begin //{
                                                tminus8_status = tminus8_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus7 received
                            CW_CMD_TMINUS7 :  begin //{
                                                tminus7_status = tminus7_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus6 received
                            CW_CMD_TMINUS6 :  begin //{
                                                tminus6_status = tminus6_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus5 received
                            CW_CMD_TMINUS5 :  begin //{
                                                tminus5_status = tminus5_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus4 received
                            CW_CMD_TMINUS4 :  begin //{
                                                tminus4_status = tminus4_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus3 received
                            CW_CMD_TMINUS3 :  begin //{
                                                tminus3_status = tminus3_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus2 received
                            CW_CMD_TMINUS2 :  begin //{
                                                tminus2_status = tminus2_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus1 received
                            CW_CMD_TMINUS1 :  begin //{
                                                tminus1_status = tminus1_init_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}
                       endcase
                       cw_update_set = 1'b1;
                     end //}
                     // preset coefficeints status cmd rxed
                     else if(ld_trans.gen3_training_equalizer_cmd[lane_num] == 3'b110)
                     begin //{
                       cw_txtap_rxed = ld_trans.gen3_training_equalizer_tap[lane_num];  
                   
                       case(cw_txtap_rxed) 

                            // transmitter equalizer tap0 received
                            CW_CMD_TAP0   :  begin //{
                                                tap0_status = tap0_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus1 received
                            CW_CMD_TPLUS1 :  begin //{
                                                tplus1_status = tplus1_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}


                            // transmitter equalizer tplus2 received
                            CW_CMD_TPLUS2 :  begin //{
                                                tplus2_status = tplus2_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus3 received
                            CW_CMD_TPLUS3 :  begin //{
                                                tplus3_status = tplus3_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus4 received
                            CW_CMD_TPLUS4 :  begin //{
                                                tplus4_status = tplus4_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus5 received
                            CW_CMD_TPLUS5 :  begin //{
                                                tplus5_status = tplus5_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus6 received
                            CW_CMD_TPLUS6 :  begin //{
                                                tplus6_status = tplus6_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tplus7 received
                            CW_CMD_TPLUS7 :  begin //{
                                                tplus7_status = tplus7_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus8 received
                            CW_CMD_TMINUS8 :  begin //{
                                                tminus8_status = tminus8_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus7 received
                            CW_CMD_TMINUS7 :  begin //{
                                                tminus7_status = tminus7_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus6 received
                            CW_CMD_TMINUS6 :  begin //{
                                                tminus6_status = tminus6_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus5 received
                            CW_CMD_TMINUS5 :  begin //{
                                                tminus5_status = tminus5_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus4 received
                            CW_CMD_TMINUS4 :  begin //{
                                                tminus4_status = tminus4_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus3 received
                            CW_CMD_TMINUS3 :  begin //{
                                                tminus3_status = tminus3_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus2 received
                            CW_CMD_TMINUS2 :  begin //{
                                                tminus2_status = tminus2_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}

                            // transmitter equalizer tminus1 received
                            CW_CMD_TMINUS1 :  begin //{
                                                tminus1_status = tminus1_prst_value;
                                                tx_equ_st   = 3'b100; 
                                             end //}
                       endcase
                       cw_update_set = 1'b1;
                     end //}
                     // specificed tap implementation status cmd rxed
                     else if(ld_trans.gen3_training_equalizer_cmd[lane_num] == 3'b111)
                     begin //{
                       cw_txtap_rxed = ld_trans.gen3_training_equalizer_tap[lane_num];  
                   
                       case(cw_txtap_rxed) 

                            // transmitter equalizer tap0 received
                            CW_CMD_TAP0   :  begin //{
                                                if(ld_config.tap0_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tplus1 received
                            CW_CMD_TPLUS1 :  begin //{
                                                if(ld_config.tplus1_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}


                            // transmitter equalizer tplus2 received
                            CW_CMD_TPLUS2 :  begin //{
                                                if(ld_config.tplus2_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tplus3 received
                            CW_CMD_TPLUS3 :  begin //{
                                                if(ld_config.tplus3_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tplus4 received
                            CW_CMD_TPLUS4 :  begin //{
                                                if(ld_config.tplus4_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tplus5 received
                            CW_CMD_TPLUS5 :  begin //{
                                                if(ld_config.tplus5_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tplus6 received
                            CW_CMD_TPLUS6 :  begin //{
                                                if(ld_config.tplus6_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tplus7 received
                            CW_CMD_TPLUS7 :  begin //{
                                                if(ld_config.tplus7_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tminus8 received
                            CW_CMD_TMINUS8 :  begin //{
                                                if(ld_config.tminus8_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tminus7 received
                            CW_CMD_TMINUS7 :  begin //{
                                                if(ld_config.tminus7_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tminus6 received
                            CW_CMD_TMINUS6 :  begin //{
                                                if(ld_config.tminus6_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tminus5 received
                            CW_CMD_TMINUS5 :  begin //{
                                                if(ld_config.tminus5_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tminus4 received
                            CW_CMD_TMINUS4 :  begin //{
                                                if(ld_config.tminus4_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tminus3 received
                            CW_CMD_TMINUS3 :  begin //{
                                                if(ld_config.tminus3_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tminus2 received
                            CW_CMD_TMINUS2 :  begin //{
                                                if(ld_config.tminus2_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}

                            // transmitter equalizer tminus1 received
                            CW_CMD_TMINUS1 :  begin //{
                                                if(ld_config.tminus1_impl_en)
                                                   tx_equ_st   = 3'b111; 
                                                else
                                                   tx_equ_st   = 3'b110; 
                                             end //}
                       endcase
                       cw_update_set = 1'b1;
                     end //}
                     // reserved cmd rxed
                     else if(ld_trans.gen3_training_equalizer_cmd[lane_num] == 3'b011 || ld_trans.gen3_training_equalizer_cmd[lane_num] == 3'b100)
                     begin //{
                       tx_equ_st   = 3'b101; 
                       cw_update_set = 1'b1;
                     end //}
                   end //}
                   else if(ld_trans.gen3_training_cmd_set[lane_num] == 1'b0 && ld_trans.gen3_training_equalizer_cmd[lane_num] == 3'b000) 
                   begin //{
                       tx_equ_st   = 3'b000; 
                       cw_update_set = 1'b1;
                   end //} 
                  
                    
                      
                 // start of cmd drive logic
                 // drive cmd logic
                 if(ld_config.cw_cmd_kind == CW_CMD_DISABLED  && !dis_onc)
                 begin //{
                      `uvm_info("SRIO_PL_LANE DRIVER : ", $sformatf("CODEWORD TRAINING COMMAND DRIVE IS DISABLED lane_num is %d",lane_num), UVM_LOW)
                       dis_onc=1;
                 end //}
                 else if(ld_config.cw_cmd_kind == CW_CMD_ENABLED && ~cw_drive_flag &&  ~cw_wait_flag && ld_config.cw_cmd_cnt == cw_cmd_drive_cnt)
                 begin //{
                  //    `uvm_info("SRIO_PL_LANE DRIVER : ", $sformatf("CODEWORD TRAINING COMMAND DRIVE CNT REACHED STOPPED SENDING COMMANDS lane_num is %d",lane_num), UVM_LOW)
                 end //}
                 else if(ld_config.cw_cmd_kind == CW_CMD_ENABLED && ~cw_drive_flag &&  ~cw_wait_flag && ld_config.cw_cmd_cnt != cw_cmd_drive_cnt && ~cw_load_flag && ld_trans.gen3_training_equalizer_status[lane_num] == 3'b000)
                 begin //{

                      cw_drive_flag = 1'b1;  
                      cw_load_flag = 1'b0;
                      case(ld_config.cw_tap_type)

                         CW_CMD_TAP0        : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h0;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h0;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h0;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h0;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h0;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h0;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h0;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h0;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h0;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h0;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h0;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h0;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h0;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h0;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h0;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h0;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                                   end //}
                         CW_CMD_TPLUS1      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h1;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h1;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h1;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h1;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h1;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h1;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h1;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h1;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h1;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h1;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h1;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h1;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h1;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h1;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h1;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h1;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TPLUS2      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h2;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h2;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h2;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h2;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h2;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h2;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h2;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h2;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h2;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h2;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h2;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h2;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h2;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h2;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h2;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h2;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TPLUS3      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h3;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h3;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h3;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h3;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h3;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h3;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h3;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h3;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h3;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h3;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h3;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h3;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h3;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h3;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h3;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h3;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TPLUS4      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h4;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h4;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h4;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h4;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h4;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h4;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h4;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h4;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h4;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h4;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h4;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h4;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h4;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h4;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h4;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h4;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TPLUS5      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h5;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h5;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h5;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h5;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h5;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h5;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h5;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h5;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h5;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h5;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h5;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h5;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h5;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h5;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h5;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h5;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TPLUS6      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h6;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h6;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h6;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h6;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h6;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h6;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h6;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h6;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h6;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h6;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h6;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h6;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h6;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h6;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h6;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h6;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TPLUS7      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h7;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h7;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h7;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h7;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h7;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h7;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h7;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h7;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h7;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h7;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h7;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h7;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h7;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h7;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h7;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h7;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TMINUS8      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h8;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h8;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h8;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h8;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h8;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h8;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h8;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h8;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h8;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h8;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h8;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h8;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h8;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h8;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h8;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h8;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TMINUS7      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h9;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'h9;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'h9;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h9;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'h9;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'h9;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'h9;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'h9;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'h9;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'h9;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'h9;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'h9;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'h9;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'h9;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'h9;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'h9;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TMINUS6      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hA;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'hA;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'hA;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hA;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hA;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'hA;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'hA;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'hA;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TMINUS5      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hB;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'hB;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'hB;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hB;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hB;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'hB;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'hB;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'hB;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hB;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'hB;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'hB;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'hB;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'hB;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'hB;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'hB;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'hB;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TMINUS4      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hC;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'hC;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'hC;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hC;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hC;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'hC;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'hC;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'hC;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hC;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'hC;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'hC;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'hC;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'hC;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'hC;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'hC;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'hC;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TMINUS3      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hD;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'hD;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'hD;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hD;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hD;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'hD;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'hD;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'hD;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hD;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'hD;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'hD;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'hD;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'hD;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'hD;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'hD;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'hD;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TMINUS2      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hE;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'hE;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'hE;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hE;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hE;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'hE;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'hE;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'hE;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TMINUS1      : begin //{
                                                  case(ld_config.cw_cmd_type)

                                                     CW_HOLD             : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hF;
                                                                           end  //} 
                                                     CW_DECR             : begin //{
                                                                             tx_equ_cmd = 3'b001;
                                                                             tx_equ_tap = 4'hF;
                                                                           end //} 

                                                     CW_INCR             : begin //{
                                                                             tx_equ_cmd = 3'b010;
                                                                             tx_equ_tap = 4'hF;
                                                                           end  //} 
                                                     CW_RSVD1            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hF;
                                                                           end  //} 
                                                     CW_RSVD2            : begin //{
                                                                             tx_equ_cmd = 3'b000;
                                                                             tx_equ_tap = 4'hF;
                                                                           end  //} 
                                                     CW_INIT             : begin //{
                                                                             tx_equ_cmd = 3'b101;
                                                                             tx_equ_tap = 4'hF;
                                                                           end  //} 
                                                     CW_PRST             : begin //{
                                                                             tx_equ_cmd = 3'b110;
                                                                             tx_equ_tap = 4'hF;
                                                                           end  //} 
                                                     CW_SPC_CMD_STAT     : begin //{
                                                                             tx_equ_cmd = 3'b111;
                                                                             tx_equ_tap = 4'hF;
                                                                           end  //} 

                                                    CW_CMD_RANDOM : begin //{
                                                                             cw_cmd_sel = $urandom_range(1,8);
                                                                             case(cw_cmd_sel)

                                                                               1  : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hF;
                                                                                    end //} 
                                                                               2  : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'hF;
                                                                                    end //} 
                                                                               3  : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'hF;
                                                                                    end //} 
                                                                               4  : begin //{
                                                                                      tx_equ_cmd = 3'b011;
                                                                                      tx_equ_tap = 4'hF;
                                                                                    end //} 
                                                                               5  : begin //{
                                                                                      tx_equ_cmd = 3'b100;
                                                                                      tx_equ_tap = 4'hF;
                                                                                    end //} 
                                                                               6  : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'hF;
                                                                                    end //} 
                                                                               7  : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'hF;
                                                                                    end //} 
                                                                               8  : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'hF;
                                                                                    end //} 
                                                                            endcase
                                                                          end //}
                                                      endcase 
                                              end //}
                         CW_CMD_TRANDOM      :begin //{ 
                                                  cw_tap_sel = $urandom_range(1,16); 
                                                  case(cw_tap_sel)
                                                    1 : begin //{
                                                         case(ld_config.cw_cmd_type)

                                                            CW_HOLD             : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h0;
                                                                                  end  //} 
                                                            CW_DECR             : begin //{
                                                                                    tx_equ_cmd = 3'b001;
                                                                                    tx_equ_tap = 4'h0;
                                                                                  end //} 

                                                            CW_INCR             : begin //{
                                                                                    tx_equ_cmd = 3'b010;
                                                                                    tx_equ_tap = 4'h0;
                                                                                  end  //} 
                                                            CW_RSVD1            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h0;
                                                                                  end  //} 
                                                            CW_RSVD2            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h0;
                                                                                  end  //} 
                                                            CW_INIT             : begin //{
                                                                                    tx_equ_cmd = 3'b101;
                                                                                    tx_equ_tap = 4'h0;
                                                                                  end  //} 
                                                            CW_PRST             : begin //{
                                                                                    tx_equ_cmd = 3'b110;
                                                                                    tx_equ_tap = 4'h0;
                                                                                  end  //} 
                                                            CW_SPC_CMD_STAT     : begin //{
                                                                                    tx_equ_cmd = 3'b111;
                                                                                    tx_equ_tap = 4'h0;
                                                                                  end  //} 

                                                           CW_CMD_RANDOM : begin //{
                                                                                    cw_cmd_sel = $urandom_range(1,8);
                                                                                    case(cw_cmd_sel)

                                                                                      1  : begin //{
                                                                                             tx_equ_cmd = 3'b000;
                                                                                             tx_equ_tap = 4'h0;
                                                                                           end //} 
                                                                                      2  : begin //{
                                                                                             tx_equ_cmd = 3'b001;
                                                                                             tx_equ_tap = 4'h0;
                                                                                           end //} 
                                                                                      3  : begin //{
                                                                                             tx_equ_cmd = 3'b010;
                                                                                             tx_equ_tap = 4'h0;
                                                                                           end //} 
                                                                                      4  : begin //{
                                                                                             tx_equ_cmd = 3'b011;
                                                                                             tx_equ_tap = 4'h0;
                                                                                           end //} 
                                                                                      5  : begin //{
                                                                                             tx_equ_cmd = 3'b100;
                                                                                             tx_equ_tap = 4'h0;
                                                                                           end //} 
                                                                                      6  : begin //{
                                                                                             tx_equ_cmd = 3'b101;
                                                                                             tx_equ_tap = 4'h0;
                                                                                           end //} 
                                                                                      7  : begin //{
                                                                                             tx_equ_cmd = 3'b110;
                                                                                             tx_equ_tap = 4'h0;
                                                                                           end //} 
                                                                                      8  : begin //{
                                                                                             tx_equ_cmd = 3'b111;
                                                                                             tx_equ_tap = 4'h0;
                                                                                           end //} 
                                                                                   endcase
                                                                                 end //}
                                                             endcase 
                                                                         end //}
                                                    2 : begin //{
                                                         case(ld_config.cw_cmd_type)

                                                            CW_HOLD             : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h1;
                                                                                  end  //} 
                                                            CW_DECR             : begin //{
                                                                                    tx_equ_cmd = 3'b001;
                                                                                    tx_equ_tap = 4'h1;
                                                                                  end //} 

                                                            CW_INCR             : begin //{
                                                                                    tx_equ_cmd = 3'b010;
                                                                                    tx_equ_tap = 4'h1;
                                                                                  end  //} 
                                                            CW_RSVD1            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h1;
                                                                                  end  //} 
                                                            CW_RSVD2            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h1;
                                                                                  end  //} 
                                                            CW_INIT             : begin //{
                                                                                    tx_equ_cmd = 3'b101;
                                                                                    tx_equ_tap = 4'h1;
                                                                                  end  //} 
                                                            CW_PRST             : begin //{
                                                                                    tx_equ_cmd = 3'b110;
                                                                                    tx_equ_tap = 4'h1;
                                                                                  end  //} 
                                                            CW_SPC_CMD_STAT     : begin //{
                                                                                    tx_equ_cmd = 3'b111;
                                                                                    tx_equ_tap = 4'h1;
                                                                                  end  //} 

                                                           CW_CMD_RANDOM : begin //{
                                                                                    cw_cmd_sel = $urandom_range(1,8);
                                                                                    case(cw_cmd_sel)

                                                                                      1  : begin //{
                                                                                             tx_equ_cmd = 3'b000;
                                                                                             tx_equ_tap = 4'h1;
                                                                                           end //} 
                                                                                      2  : begin //{
                                                                                             tx_equ_cmd = 3'b001;
                                                                                             tx_equ_tap = 4'h1;
                                                                                           end //} 
                                                                                      3  : begin //{
                                                                                             tx_equ_cmd = 3'b010;
                                                                                             tx_equ_tap = 4'h1;
                                                                                           end //} 
                                                                                      4  : begin //{
                                                                                             tx_equ_cmd = 3'b011;
                                                                                             tx_equ_tap = 4'h1;
                                                                                           end //} 
                                                                                      5  : begin //{
                                                                                             tx_equ_cmd = 3'b100;
                                                                                             tx_equ_tap = 4'h1;
                                                                                           end //} 
                                                                                      6  : begin //{
                                                                                             tx_equ_cmd = 3'b101;
                                                                                             tx_equ_tap = 4'h1;
                                                                                           end //} 
                                                                                      7  : begin //{
                                                                                             tx_equ_cmd = 3'b110;
                                                                                             tx_equ_tap = 4'h1;
                                                                                           end //} 
                                                                                      8  : begin //{
                                                                                             tx_equ_cmd = 3'b111;
                                                                                             tx_equ_tap = 4'h1;
                                                                                           end //} 
                                                                                   endcase
                                                                                 end //}
                                                             endcase 
                                                                         end //}
                                                    3 : begin //{
                                                         case(ld_config.cw_cmd_type)

                                                            CW_HOLD             : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h2;
                                                                                  end  //} 
                                                            CW_DECR             : begin //{
                                                                                    tx_equ_cmd = 3'b001;
                                                                                    tx_equ_tap = 4'h2;
                                                                                  end //} 

                                                            CW_INCR             : begin //{
                                                                                    tx_equ_cmd = 3'b010;
                                                                                    tx_equ_tap = 4'h2;
                                                                                  end  //} 
                                                            CW_RSVD1            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h2;
                                                                                  end  //} 
                                                            CW_RSVD2            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h2;
                                                                                  end  //} 
                                                            CW_INIT             : begin //{
                                                                                    tx_equ_cmd = 3'b101;
                                                                                    tx_equ_tap = 4'h2;
                                                                                  end  //} 
                                                            CW_PRST             : begin //{
                                                                                    tx_equ_cmd = 3'b110;
                                                                                    tx_equ_tap = 4'h2;
                                                                                  end  //} 
                                                            CW_SPC_CMD_STAT     : begin //{
                                                                                    tx_equ_cmd = 3'b111;
                                                                                    tx_equ_tap = 4'h2;
                                                                                  end  //} 

                                                           CW_CMD_RANDOM : begin //{
                                                                                    cw_cmd_sel = $urandom_range(1,8);
                                                                                    case(cw_cmd_sel)

                                                                                      1  : begin //{
                                                                                             tx_equ_cmd = 3'b000;
                                                                                             tx_equ_tap = 4'h2;
                                                                                           end //} 
                                                                                      2  : begin //{
                                                                                             tx_equ_cmd = 3'b001;
                                                                                             tx_equ_tap = 4'h2;
                                                                                           end //} 
                                                                                      3  : begin //{
                                                                                             tx_equ_cmd = 3'b010;
                                                                                             tx_equ_tap = 4'h2;
                                                                                           end //} 
                                                                                      4  : begin //{
                                                                                             tx_equ_cmd = 3'b011;
                                                                                             tx_equ_tap = 4'h2;
                                                                                           end //} 
                                                                                      5  : begin //{
                                                                                             tx_equ_cmd = 3'b100;
                                                                                             tx_equ_tap = 4'h2;
                                                                                           end //} 
                                                                                      6  : begin //{
                                                                                             tx_equ_cmd = 3'b101;
                                                                                             tx_equ_tap = 4'h2;
                                                                                           end //} 
                                                                                      7  : begin //{
                                                                                             tx_equ_cmd = 3'b110;
                                                                                             tx_equ_tap = 4'h2;
                                                                                           end //} 
                                                                                      8  : begin //{
                                                                                             tx_equ_cmd = 3'b111;
                                                                                             tx_equ_tap = 4'h2;
                                                                                           end //} 
                                                                                   endcase
                                                                                 end //}
                                                             endcase 
                                                                         end //}
                                                    4 : begin //{
                                                         case(ld_config.cw_cmd_type)

                                                            CW_HOLD             : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h3;
                                                                                  end  //} 
                                                            CW_DECR             : begin //{
                                                                                    tx_equ_cmd = 3'b001;
                                                                                    tx_equ_tap = 4'h3;
                                                                                  end //} 

                                                            CW_INCR             : begin //{
                                                                                    tx_equ_cmd = 3'b010;
                                                                                    tx_equ_tap = 4'h3;
                                                                                  end  //} 
                                                            CW_RSVD1            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h3;
                                                                                  end  //} 
                                                            CW_RSVD2            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h3;
                                                                                  end  //} 
                                                            CW_INIT             : begin //{
                                                                                    tx_equ_cmd = 3'b101;
                                                                                    tx_equ_tap = 4'h3;
                                                                                  end  //} 
                                                            CW_PRST             : begin //{
                                                                                    tx_equ_cmd = 3'b110;
                                                                                    tx_equ_tap = 4'h3;
                                                                                  end  //} 
                                                            CW_SPC_CMD_STAT     : begin //{
                                                                                    tx_equ_cmd = 3'b111;
                                                                                    tx_equ_tap = 4'h3;
                                                                                  end  //} 

                                                           CW_CMD_RANDOM : begin //{
                                                                                    cw_cmd_sel = $urandom_range(1,8);
                                                                                    case(cw_cmd_sel)

                                                                                      1  : begin //{
                                                                                             tx_equ_cmd = 3'b000;
                                                                                             tx_equ_tap = 4'h3;
                                                                                           end //} 
                                                                                      2  : begin //{
                                                                                             tx_equ_cmd = 3'b001;
                                                                                             tx_equ_tap = 4'h3;
                                                                                           end //} 
                                                                                      3  : begin //{
                                                                                             tx_equ_cmd = 3'b010;
                                                                                             tx_equ_tap = 4'h3;
                                                                                           end //} 
                                                                                      4  : begin //{
                                                                                             tx_equ_cmd = 3'b011;
                                                                                             tx_equ_tap = 4'h3;
                                                                                           end //} 
                                                                                      5  : begin //{
                                                                                             tx_equ_cmd = 3'b100;
                                                                                             tx_equ_tap = 4'h3;
                                                                                           end //} 
                                                                                      6  : begin //{
                                                                                             tx_equ_cmd = 3'b101;
                                                                                             tx_equ_tap = 4'h3;
                                                                                           end //} 
                                                                                      7  : begin //{
                                                                                             tx_equ_cmd = 3'b110;
                                                                                             tx_equ_tap = 4'h3;
                                                                                           end //} 
                                                                                      8  : begin //{
                                                                                             tx_equ_cmd = 3'b111;
                                                                                             tx_equ_tap = 4'h3;
                                                                                           end //} 
                                                                                   endcase
                                                                                 end //}
                                                             endcase 
                                                                         end //}
                                                    5 : begin //{
                                                         case(ld_config.cw_cmd_type)

                                                            CW_HOLD             : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h4;
                                                                                  end  //} 
                                                            CW_DECR             : begin //{
                                                                                    tx_equ_cmd = 3'b001;
                                                                                    tx_equ_tap = 4'h4;
                                                                                  end //} 

                                                            CW_INCR             : begin //{
                                                                                    tx_equ_cmd = 3'b010;
                                                                                    tx_equ_tap = 4'h4;
                                                                                  end  //} 
                                                            CW_RSVD1            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h4;
                                                                                  end  //} 
                                                            CW_RSVD2            : begin //{
                                                                                    tx_equ_cmd = 3'b000;
                                                                                    tx_equ_tap = 4'h4;
                                                                                  end  //} 
                                                            CW_INIT             : begin //{
                                                                                    tx_equ_cmd = 3'b101;
                                                                                    tx_equ_tap = 4'h4;
                                                                                  end  //} 
                                                            CW_PRST             : begin //{
                                                                                    tx_equ_cmd = 3'b110;
                                                                                    tx_equ_tap = 4'h4;
                                                                                  end  //} 
                                                            CW_SPC_CMD_STAT     : begin //{
                                                                                    tx_equ_cmd = 3'b111;
                                                                                    tx_equ_tap = 4'h4;
                                                                                  end  //} 

                                                           CW_CMD_RANDOM : begin //{
                                                                                    cw_cmd_sel = $urandom_range(1,8);
                                                                                    case(cw_cmd_sel)

                                                                                      1  : begin //{
                                                                                             tx_equ_cmd = 3'b000;
                                                                                             tx_equ_tap = 4'h4;
                                                                                           end //} 
                                                                                      2  : begin //{
                                                                                             tx_equ_cmd = 3'b001;
                                                                                             tx_equ_tap = 4'h4;
                                                                                           end //} 
                                                                                      3  : begin //{
                                                                                             tx_equ_cmd = 3'b010;
                                                                                             tx_equ_tap = 4'h4;
                                                                                           end //} 
                                                                                      4  : begin //{
                                                                                             tx_equ_cmd = 3'b011;
                                                                                             tx_equ_tap = 4'h4;
                                                                                           end //} 
                                                                                      5  : begin //{
                                                                                             tx_equ_cmd = 3'b100;
                                                                                             tx_equ_tap = 4'h4;
                                                                                           end //} 
                                                                                      6  : begin //{
                                                                                             tx_equ_cmd = 3'b101;
                                                                                             tx_equ_tap = 4'h4;
                                                                                           end //} 
                                                                                      7  : begin //{
                                                                                             tx_equ_cmd = 3'b110;
                                                                                             tx_equ_tap = 4'h4;
                                                                                           end //} 
                                                                                      8  : begin //{
                                                                                             tx_equ_cmd = 3'b111;
                                                                                             tx_equ_tap = 4'h4;
                                                                                           end //} 
                                                                                   endcase
                                                                                 end //}
                                                             endcase 
                                                                         end //}
                                                    6 : begin //{
                                                          case(ld_config.cw_cmd_type)

                                                             CW_HOLD             : begin //{
                                                                                     tx_equ_cmd = 3'b000;
                                                                                     tx_equ_tap = 4'h5;
                                                                                   end  //} 
                                                             CW_DECR             : begin //{
                                                                                     tx_equ_cmd = 3'b001;
                                                                                     tx_equ_tap = 4'h5;
                                                                                   end //} 

                                                             CW_INCR             : begin //{
                                                                                     tx_equ_cmd = 3'b010;
                                                                                     tx_equ_tap = 4'h5;
                                                                                   end  //} 
                                                             CW_RSVD1            : begin //{
                                                                                     tx_equ_cmd = 3'b000;
                                                                                     tx_equ_tap = 4'h5;
                                                                                   end  //} 
                                                             CW_RSVD2            : begin //{
                                                                                     tx_equ_cmd = 3'b000;
                                                                                     tx_equ_tap = 4'h5;
                                                                                   end  //} 
                                                             CW_INIT             : begin //{
                                                                                     tx_equ_cmd = 3'b101;
                                                                                     tx_equ_tap = 4'h5;
                                                                                   end  //} 
                                                             CW_PRST             : begin //{
                                                                                     tx_equ_cmd = 3'b110;
                                                                                     tx_equ_tap = 4'h5;
                                                                                   end  //} 
                                                             CW_SPC_CMD_STAT     : begin //{
                                                                                     tx_equ_cmd = 3'b111;
                                                                                     tx_equ_tap = 4'h5;
                                                                                   end  //} 

                                                            CW_CMD_RANDOM : begin //{
                                                                                     cw_cmd_sel = $urandom_range(1,8);
                                                                                     case(cw_cmd_sel)

                                                                                       1  : begin //{
                                                                                              tx_equ_cmd = 3'b000;
                                                                                              tx_equ_tap = 4'h5;
                                                                                            end //} 
                                                                                       2  : begin //{
                                                                                              tx_equ_cmd = 3'b001;
                                                                                              tx_equ_tap = 4'h5;
                                                                                            end //} 
                                                                                       3  : begin //{
                                                                                              tx_equ_cmd = 3'b010;
                                                                                              tx_equ_tap = 4'h5;
                                                                                            end //} 
                                                                                       4  : begin //{
                                                                                              tx_equ_cmd = 3'b011;
                                                                                              tx_equ_tap = 4'h5;
                                                                                            end //} 
                                                                                       5  : begin //{
                                                                                              tx_equ_cmd = 3'b100;
                                                                                              tx_equ_tap = 4'h5;
                                                                                            end //} 
                                                                                       6  : begin //{
                                                                                              tx_equ_cmd = 3'b101;
                                                                                              tx_equ_tap = 4'h5;
                                                                                            end //} 
                                                                                       7  : begin //{
                                                                                              tx_equ_cmd = 3'b110;
                                                                                              tx_equ_tap = 4'h5;
                                                                                            end //} 
                                                                                       8  : begin //{
                                                                                              tx_equ_cmd = 3'b111;
                                                                                              tx_equ_tap = 4'h5;
                                                                                            end //} 
                                                                                    endcase
                                                                                  end //}
                                                              endcase 
                                                                         end //}
                                                    7 : begin //{
                                                          case(ld_config.cw_cmd_type)

                                                             CW_HOLD             : begin //{
                                                                                     tx_equ_cmd = 3'b000;
                                                                                     tx_equ_tap = 4'h6;
                                                                                   end  //} 
                                                             CW_DECR             : begin //{
                                                                                     tx_equ_cmd = 3'b001;
                                                                                     tx_equ_tap = 4'h6;
                                                                                   end //} 

                                                             CW_INCR             : begin //{
                                                                                     tx_equ_cmd = 3'b010;
                                                                                     tx_equ_tap = 4'h6;
                                                                                   end  //} 
                                                             CW_RSVD1            : begin //{
                                                                                     tx_equ_cmd = 3'b000;
                                                                                     tx_equ_tap = 4'h6;
                                                                                   end  //} 
                                                             CW_RSVD2            : begin //{
                                                                                     tx_equ_cmd = 3'b000;
                                                                                     tx_equ_tap = 4'h6;
                                                                                   end  //} 
                                                             CW_INIT             : begin //{
                                                                                     tx_equ_cmd = 3'b101;
                                                                                     tx_equ_tap = 4'h6;
                                                                                   end  //} 
                                                             CW_PRST             : begin //{
                                                                                     tx_equ_cmd = 3'b110;
                                                                                     tx_equ_tap = 4'h6;
                                                                                   end  //} 
                                                             CW_SPC_CMD_STAT     : begin //{
                                                                                     tx_equ_cmd = 3'b111;
                                                                                     tx_equ_tap = 4'h6;
                                                                                   end  //} 

                                                            CW_CMD_RANDOM : begin //{
                                                                                     cw_cmd_sel = $urandom_range(1,8);
                                                                                     case(cw_cmd_sel)

                                                                                       1  : begin //{
                                                                                              tx_equ_cmd = 3'b000;
                                                                                              tx_equ_tap = 4'h6;
                                                                                            end //} 
                                                                                       2  : begin //{
                                                                                              tx_equ_cmd = 3'b001;
                                                                                              tx_equ_tap = 4'h6;
                                                                                            end //} 
                                                                                       3  : begin //{
                                                                                              tx_equ_cmd = 3'b010;
                                                                                              tx_equ_tap = 4'h6;
                                                                                            end //} 
                                                                                       4  : begin //{
                                                                                              tx_equ_cmd = 3'b011;
                                                                                              tx_equ_tap = 4'h6;
                                                                                            end //} 
                                                                                       5  : begin //{
                                                                                              tx_equ_cmd = 3'b100;
                                                                                              tx_equ_tap = 4'h6;
                                                                                            end //} 
                                                                                       6  : begin //{
                                                                                              tx_equ_cmd = 3'b101;
                                                                                              tx_equ_tap = 4'h6;
                                                                                            end //} 
                                                                                       7  : begin //{
                                                                                              tx_equ_cmd = 3'b110;
                                                                                              tx_equ_tap = 4'h6;
                                                                                            end //} 
                                                                                       8  : begin //{
                                                                                              tx_equ_cmd = 3'b111;
                                                                                              tx_equ_tap = 4'h6;
                                                                                            end //} 
                                                                                    endcase
                                                                                  end //}
                                                              endcase 
                                                                         end //}
                                                    8 : begin //{
                                                          case(ld_config.cw_cmd_type)

                                                             CW_HOLD             : begin //{
                                                                                     tx_equ_cmd = 3'b000;
                                                                                     tx_equ_tap = 4'h7;
                                                                                   end  //} 
                                                             CW_DECR             : begin //{
                                                                                     tx_equ_cmd = 3'b001;
                                                                                     tx_equ_tap = 4'h7;
                                                                                   end //} 

                                                             CW_INCR             : begin //{
                                                                                     tx_equ_cmd = 3'b010;
                                                                                     tx_equ_tap = 4'h7;
                                                                                   end  //} 
                                                             CW_RSVD1            : begin //{
                                                                                     tx_equ_cmd = 3'b000;
                                                                                     tx_equ_tap = 4'h7;
                                                                                   end  //} 
                                                             CW_RSVD2            : begin //{
                                                                                     tx_equ_cmd = 3'b000;
                                                                                     tx_equ_tap = 4'h7;
                                                                                   end  //} 
                                                             CW_INIT             : begin //{
                                                                                     tx_equ_cmd = 3'b101;
                                                                                     tx_equ_tap = 4'h7;
                                                                                   end  //} 
                                                             CW_PRST             : begin //{
                                                                                     tx_equ_cmd = 3'b110;
                                                                                     tx_equ_tap = 4'h7;
                                                                                   end  //} 
                                                             CW_SPC_CMD_STAT     : begin //{
                                                                                     tx_equ_cmd = 3'b111;
                                                                                     tx_equ_tap = 4'h7;
                                                                                   end  //} 

                                                            CW_CMD_RANDOM : begin //{
                                                                                     cw_cmd_sel = $urandom_range(1,8);
                                                                                     case(cw_cmd_sel)

                                                                                       1  : begin //{
                                                                                              tx_equ_cmd = 3'b000;
                                                                                              tx_equ_tap = 4'h7;
                                                                                            end //} 
                                                                                       2  : begin //{
                                                                                              tx_equ_cmd = 3'b001;
                                                                                              tx_equ_tap = 4'h7;
                                                                                            end //} 
                                                                                       3  : begin //{
                                                                                              tx_equ_cmd = 3'b010;
                                                                                              tx_equ_tap = 4'h7;
                                                                                            end //} 
                                                                                       4  : begin //{
                                                                                              tx_equ_cmd = 3'b011;
                                                                                              tx_equ_tap = 4'h7;
                                                                                            end //} 
                                                                                       5  : begin //{
                                                                                              tx_equ_cmd = 3'b100;
                                                                                              tx_equ_tap = 4'h7;
                                                                                            end //} 
                                                                                       6  : begin //{
                                                                                              tx_equ_cmd = 3'b101;
                                                                                              tx_equ_tap = 4'h7;
                                                                                            end //} 
                                                                                       7  : begin //{
                                                                                              tx_equ_cmd = 3'b110;
                                                                                              tx_equ_tap = 4'h7;
                                                                                            end //} 
                                                                                       8  : begin //{
                                                                                              tx_equ_cmd = 3'b111;
                                                                                              tx_equ_tap = 4'h7;
                                                                                            end //} 
                                                                                    endcase
                                                                                  end //}
                                                              endcase 
                                                                         end //}
                                                    9 : begin //{
                                                            case(ld_config.cw_cmd_type)

                                                               CW_HOLD             : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'h8;
                                                                                     end  //} 
                                                               CW_DECR             : begin //{
                                                                                       tx_equ_cmd = 3'b001;
                                                                                       tx_equ_tap = 4'h8;
                                                                                     end //} 

                                                               CW_INCR             : begin //{
                                                                                       tx_equ_cmd = 3'b010;
                                                                                       tx_equ_tap = 4'h8;
                                                                                     end  //} 
                                                               CW_RSVD1            : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'h8;
                                                                                     end  //} 
                                                               CW_RSVD2            : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'h8;
                                                                                     end  //} 
                                                               CW_INIT             : begin //{
                                                                                       tx_equ_cmd = 3'b101;
                                                                                       tx_equ_tap = 4'h8;
                                                                                     end  //} 
                                                               CW_PRST             : begin //{
                                                                                       tx_equ_cmd = 3'b110;
                                                                                       tx_equ_tap = 4'h8;
                                                                                     end  //} 
                                                               CW_SPC_CMD_STAT     : begin //{
                                                                                       tx_equ_cmd = 3'b111;
                                                                                       tx_equ_tap = 4'h8;
                                                                                     end  //} 

                                                              CW_CMD_RANDOM : begin //{
                                                                                       cw_cmd_sel = $urandom_range(1,8);
                                                                                       case(cw_cmd_sel)

                                                                                         1  : begin //{
                                                                                                tx_equ_cmd = 3'b000;
                                                                                                tx_equ_tap = 4'h8;
                                                                                              end //} 
                                                                                         2  : begin //{
                                                                                                tx_equ_cmd = 3'b001;
                                                                                                tx_equ_tap = 4'h8;
                                                                                              end //} 
                                                                                         3  : begin //{
                                                                                                tx_equ_cmd = 3'b010;
                                                                                                tx_equ_tap = 4'h8;
                                                                                              end //} 
                                                                                         4  : begin //{
                                                                                                tx_equ_cmd = 3'b011;
                                                                                                tx_equ_tap = 4'h8;
                                                                                              end //} 
                                                                                         5  : begin //{
                                                                                                tx_equ_cmd = 3'b100;
                                                                                                tx_equ_tap = 4'h8;
                                                                                              end //} 
                                                                                         6  : begin //{
                                                                                                tx_equ_cmd = 3'b101;
                                                                                                tx_equ_tap = 4'h8;
                                                                                              end //} 
                                                                                         7  : begin //{
                                                                                                tx_equ_cmd = 3'b110;
                                                                                                tx_equ_tap = 4'h8;
                                                                                              end //} 
                                                                                         8  : begin //{
                                                                                                tx_equ_cmd = 3'b111;
                                                                                                tx_equ_tap = 4'h8;
                                                                                              end //} 
                                                                                      endcase
                                                                                    end //}
                                                                endcase 
                                                                         end //}
                                                    10 : begin //{
                                                            case(ld_config.cw_cmd_type)

                                                               CW_HOLD             : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'h9;
                                                                                     end  //} 
                                                               CW_DECR             : begin //{
                                                                                       tx_equ_cmd = 3'b001;
                                                                                       tx_equ_tap = 4'h9;
                                                                                     end //} 

                                                               CW_INCR             : begin //{
                                                                                       tx_equ_cmd = 3'b010;
                                                                                       tx_equ_tap = 4'h9;
                                                                                     end  //} 
                                                               CW_RSVD1            : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'h9;
                                                                                     end  //} 
                                                               CW_RSVD2            : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'h9;
                                                                                     end  //} 
                                                               CW_INIT             : begin //{
                                                                                       tx_equ_cmd = 3'b101;
                                                                                       tx_equ_tap = 4'h9;
                                                                                     end  //} 
                                                               CW_PRST             : begin //{
                                                                                       tx_equ_cmd = 3'b110;
                                                                                       tx_equ_tap = 4'h9;
                                                                                     end  //} 
                                                               CW_SPC_CMD_STAT     : begin //{
                                                                                       tx_equ_cmd = 3'b111;
                                                                                       tx_equ_tap = 4'h9;
                                                                                     end  //} 

                                                              CW_CMD_RANDOM : begin //{
                                                                                       cw_cmd_sel = $urandom_range(1,8);
                                                                                       case(cw_cmd_sel)

                                                                                         1  : begin //{
                                                                                                tx_equ_cmd = 3'b000;
                                                                                                tx_equ_tap = 4'h9;
                                                                                              end //} 
                                                                                         2  : begin //{
                                                                                                tx_equ_cmd = 3'b001;
                                                                                                tx_equ_tap = 4'h9;
                                                                                              end //} 
                                                                                         3  : begin //{
                                                                                                tx_equ_cmd = 3'b010;
                                                                                                tx_equ_tap = 4'h9;
                                                                                              end //} 
                                                                                         4  : begin //{
                                                                                                tx_equ_cmd = 3'b011;
                                                                                                tx_equ_tap = 4'h9;
                                                                                              end //} 
                                                                                         5  : begin //{
                                                                                                tx_equ_cmd = 3'b100;
                                                                                                tx_equ_tap = 4'h9;
                                                                                              end //} 
                                                                                         6  : begin //{
                                                                                                tx_equ_cmd = 3'b101;
                                                                                                tx_equ_tap = 4'h9;
                                                                                              end //} 
                                                                                         7  : begin //{
                                                                                                tx_equ_cmd = 3'b110;
                                                                                                tx_equ_tap = 4'h9;
                                                                                              end //} 
                                                                                         8  : begin //{
                                                                                                tx_equ_cmd = 3'b111;
                                                                                                tx_equ_tap = 4'h9;
                                                                                              end //} 
                                                                                      endcase
                                                                                    end //}
                                                                endcase 
                                                                         end //}
                                                    11 : begin //{
                                                           case(ld_config.cw_cmd_type)

                                                              CW_HOLD             : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end  //} 
                                                              CW_DECR             : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end //} 

                                                              CW_INCR             : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end  //} 
                                                              CW_RSVD1            : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end  //} 
                                                              CW_RSVD2            : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end  //} 
                                                              CW_INIT             : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end  //} 
                                                              CW_PRST             : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end  //} 
                                                              CW_SPC_CMD_STAT     : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'hA;
                                                                                    end  //} 

                                                             CW_CMD_RANDOM : begin //{
                                                                                      cw_cmd_sel = $urandom_range(1,8);
                                                                                      case(cw_cmd_sel)

                                                                                        1  : begin //{
                                                                                               tx_equ_cmd = 3'b000;
                                                                                               tx_equ_tap = 4'hA;
                                                                                             end //} 
                                                                                        2  : begin //{
                                                                                               tx_equ_cmd = 3'b001;
                                                                                               tx_equ_tap = 4'hA;
                                                                                             end //} 
                                                                                        3  : begin //{
                                                                                               tx_equ_cmd = 3'b010;
                                                                                               tx_equ_tap = 4'hA;
                                                                                             end //} 
                                                                                        4  : begin //{
                                                                                               tx_equ_cmd = 3'b011;
                                                                                               tx_equ_tap = 4'hA;
                                                                                             end //} 
                                                                                        5  : begin //{
                                                                                               tx_equ_cmd = 3'b100;
                                                                                               tx_equ_tap = 4'hA;
                                                                                             end //} 
                                                                                        6  : begin //{
                                                                                               tx_equ_cmd = 3'b101;
                                                                                               tx_equ_tap = 4'hA;
                                                                                             end //} 
                                                                                        7  : begin //{
                                                                                               tx_equ_cmd = 3'b110;
                                                                                               tx_equ_tap = 4'hA;
                                                                                             end //} 
                                                                                        8  : begin //{
                                                                                               tx_equ_cmd = 3'b111;
                                                                                               tx_equ_tap = 4'hA;
                                                                                             end //} 
                                                                                     endcase
                                                                                   end //}
                                                               endcase 
                                                                         end //}
                                                    12 : begin //{
                                                             case(ld_config.cw_cmd_type)

                                                                CW_HOLD             : begin //{
                                                                                        tx_equ_cmd = 3'b000;
                                                                                        tx_equ_tap = 4'hB;
                                                                                      end  //} 
                                                                CW_DECR             : begin //{
                                                                                        tx_equ_cmd = 3'b001;
                                                                                        tx_equ_tap = 4'hB;
                                                                                      end //} 

                                                                CW_INCR             : begin //{
                                                                                        tx_equ_cmd = 3'b010;
                                                                                        tx_equ_tap = 4'hB;
                                                                                      end  //} 
                                                                CW_RSVD1            : begin //{
                                                                                        tx_equ_cmd = 3'b000;
                                                                                        tx_equ_tap = 4'hB;
                                                                                      end  //} 
                                                                CW_RSVD2            : begin //{
                                                                                        tx_equ_cmd = 3'b000;
                                                                                        tx_equ_tap = 4'hB;
                                                                                      end  //} 
                                                                CW_INIT             : begin //{
                                                                                        tx_equ_cmd = 3'b101;
                                                                                        tx_equ_tap = 4'hB;
                                                                                      end  //} 
                                                                CW_PRST             : begin //{
                                                                                        tx_equ_cmd = 3'b110;
                                                                                        tx_equ_tap = 4'hB;
                                                                                      end  //} 
                                                                CW_SPC_CMD_STAT     : begin //{
                                                                                        tx_equ_cmd = 3'b111;
                                                                                        tx_equ_tap = 4'hB;
                                                                                      end  //} 

                                                               CW_CMD_RANDOM : begin //{
                                                                                        cw_cmd_sel = $urandom_range(1,8);
                                                                                        case(cw_cmd_sel)

                                                                                          1  : begin //{
                                                                                                 tx_equ_cmd = 3'b000;
                                                                                                 tx_equ_tap = 4'hB;
                                                                                               end //} 
                                                                                          2  : begin //{
                                                                                                 tx_equ_cmd = 3'b001;
                                                                                                 tx_equ_tap = 4'hB;
                                                                                               end //} 
                                                                                          3  : begin //{
                                                                                                 tx_equ_cmd = 3'b010;
                                                                                                 tx_equ_tap = 4'hB;
                                                                                               end //} 
                                                                                          4  : begin //{
                                                                                                 tx_equ_cmd = 3'b011;
                                                                                                 tx_equ_tap = 4'hB;
                                                                                               end //} 
                                                                                          5  : begin //{
                                                                                                 tx_equ_cmd = 3'b100;
                                                                                                 tx_equ_tap = 4'hB;
                                                                                               end //} 
                                                                                          6  : begin //{
                                                                                                 tx_equ_cmd = 3'b101;
                                                                                                 tx_equ_tap = 4'hB;
                                                                                               end //} 
                                                                                          7  : begin //{
                                                                                                 tx_equ_cmd = 3'b110;
                                                                                                 tx_equ_tap = 4'hB;
                                                                                               end //} 
                                                                                          8  : begin //{
                                                                                                 tx_equ_cmd = 3'b111;
                                                                                                 tx_equ_tap = 4'hB;
                                                                                               end //} 
                                                                                       endcase
                                                                                     end //}
                                                                 endcase 
                                                                         end //}
                                                    13 : begin //{
                                                              case(ld_config.cw_cmd_type)

                                                                 CW_HOLD             : begin //{
                                                                                         tx_equ_cmd = 3'b000;
                                                                                         tx_equ_tap = 4'hC;
                                                                                       end  //} 
                                                                 CW_DECR             : begin //{
                                                                                         tx_equ_cmd = 3'b001;
                                                                                         tx_equ_tap = 4'hC;
                                                                                       end //} 

                                                                 CW_INCR             : begin //{
                                                                                         tx_equ_cmd = 3'b010;
                                                                                         tx_equ_tap = 4'hC;
                                                                                       end  //} 
                                                                 CW_RSVD1            : begin //{
                                                                                         tx_equ_cmd = 3'b000;
                                                                                         tx_equ_tap = 4'hC;
                                                                                       end  //} 
                                                                 CW_RSVD2            : begin //{
                                                                                         tx_equ_cmd = 3'b000;
                                                                                         tx_equ_tap = 4'hC;
                                                                                       end  //} 
                                                                 CW_INIT             : begin //{
                                                                                         tx_equ_cmd = 3'b101;
                                                                                         tx_equ_tap = 4'hC;
                                                                                       end  //} 
                                                                 CW_PRST             : begin //{
                                                                                         tx_equ_cmd = 3'b110;
                                                                                         tx_equ_tap = 4'hC;
                                                                                       end  //} 
                                                                 CW_SPC_CMD_STAT     : begin //{
                                                                                         tx_equ_cmd = 3'b111;
                                                                                         tx_equ_tap = 4'hC;
                                                                                       end  //} 

                                                                CW_CMD_RANDOM : begin //{
                                                                                         cw_cmd_sel = $urandom_range(1,8);
                                                                                         case(cw_cmd_sel)

                                                                                           1  : begin //{
                                                                                                  tx_equ_cmd = 3'b000;
                                                                                                  tx_equ_tap = 4'hC;
                                                                                                end //} 
                                                                                           2  : begin //{
                                                                                                  tx_equ_cmd = 3'b001;
                                                                                                  tx_equ_tap = 4'hC;
                                                                                                end //} 
                                                                                           3  : begin //{
                                                                                                  tx_equ_cmd = 3'b010;
                                                                                                  tx_equ_tap = 4'hC;
                                                                                                end //} 
                                                                                           4  : begin //{
                                                                                                  tx_equ_cmd = 3'b011;
                                                                                                  tx_equ_tap = 4'hC;
                                                                                                end //} 
                                                                                           5  : begin //{
                                                                                                  tx_equ_cmd = 3'b100;
                                                                                                  tx_equ_tap = 4'hC;
                                                                                                end //} 
                                                                                           6  : begin //{
                                                                                                  tx_equ_cmd = 3'b101;
                                                                                                  tx_equ_tap = 4'hC;
                                                                                                end //} 
                                                                                           7  : begin //{
                                                                                                  tx_equ_cmd = 3'b110;
                                                                                                  tx_equ_tap = 4'hC;
                                                                                                end //} 
                                                                                           8  : begin //{
                                                                                                  tx_equ_cmd = 3'b111;
                                                                                                  tx_equ_tap = 4'hC;
                                                                                                end //} 
                                                                                        endcase
                                                                                      end //}
                                                                  endcase 
                                                                         end //}
                                                    14 : begin //{
                                                            case(ld_config.cw_cmd_type)

                                                               CW_HOLD             : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'hD;
                                                                                     end  //} 
                                                               CW_DECR             : begin //{
                                                                                       tx_equ_cmd = 3'b001;
                                                                                       tx_equ_tap = 4'hD;
                                                                                     end //} 

                                                               CW_INCR             : begin //{
                                                                                       tx_equ_cmd = 3'b010;
                                                                                       tx_equ_tap = 4'hD;
                                                                                     end  //} 
                                                               CW_RSVD1            : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'hD;
                                                                                     end  //} 
                                                               CW_RSVD2            : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'hD;
                                                                                     end  //} 
                                                               CW_INIT             : begin //{
                                                                                       tx_equ_cmd = 3'b101;
                                                                                       tx_equ_tap = 4'hD;
                                                                                     end  //} 
                                                               CW_PRST             : begin //{
                                                                                       tx_equ_cmd = 3'b110;
                                                                                       tx_equ_tap = 4'hD;
                                                                                     end  //} 
                                                               CW_SPC_CMD_STAT     : begin //{
                                                                                       tx_equ_cmd = 3'b111;
                                                                                       tx_equ_tap = 4'hD;
                                                                                     end  //} 

                                                              CW_CMD_RANDOM : begin //{
                                                                                       cw_cmd_sel = $urandom_range(1,8);
                                                                                       case(cw_cmd_sel)

                                                                                         1  : begin //{
                                                                                                tx_equ_cmd = 3'b000;
                                                                                                tx_equ_tap = 4'hD;
                                                                                              end //} 
                                                                                         2  : begin //{
                                                                                                tx_equ_cmd = 3'b001;
                                                                                                tx_equ_tap = 4'hD;
                                                                                              end //} 
                                                                                         3  : begin //{
                                                                                                tx_equ_cmd = 3'b010;
                                                                                                tx_equ_tap = 4'hD;
                                                                                              end //} 
                                                                                         4  : begin //{
                                                                                                tx_equ_cmd = 3'b011;
                                                                                                tx_equ_tap = 4'hD;
                                                                                              end //} 
                                                                                         5  : begin //{
                                                                                                tx_equ_cmd = 3'b100;
                                                                                                tx_equ_tap = 4'hD;
                                                                                              end //} 
                                                                                         6  : begin //{
                                                                                                tx_equ_cmd = 3'b101;
                                                                                                tx_equ_tap = 4'hD;
                                                                                              end //} 
                                                                                         7  : begin //{
                                                                                                tx_equ_cmd = 3'b110;
                                                                                                tx_equ_tap = 4'hD;
                                                                                              end //} 
                                                                                         8  : begin //{
                                                                                                tx_equ_cmd = 3'b111;
                                                                                                tx_equ_tap = 4'hD;
                                                                                              end //} 
                                                                                      endcase
                                                                                    end //}
                                                                endcase 
                                                                         end //}
                                                    15 : begin //{
                                                           case(ld_config.cw_cmd_type)

                                                              CW_HOLD             : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end  //} 
                                                              CW_DECR             : begin //{
                                                                                      tx_equ_cmd = 3'b001;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end //} 

                                                              CW_INCR             : begin //{
                                                                                      tx_equ_cmd = 3'b010;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end  //} 
                                                              CW_RSVD1            : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end  //} 
                                                              CW_RSVD2            : begin //{
                                                                                      tx_equ_cmd = 3'b000;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end  //} 
                                                              CW_INIT             : begin //{
                                                                                      tx_equ_cmd = 3'b101;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end  //} 
                                                              CW_PRST             : begin //{
                                                                                      tx_equ_cmd = 3'b110;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end  //} 
                                                              CW_SPC_CMD_STAT     : begin //{
                                                                                      tx_equ_cmd = 3'b111;
                                                                                      tx_equ_tap = 4'hE;
                                                                                    end  //} 

                                                             CW_CMD_RANDOM : begin //{
                                                                                      cw_cmd_sel = $urandom_range(1,8);
                                                                                      case(cw_cmd_sel)

                                                                                        1  : begin //{
                                                                                               tx_equ_cmd = 3'b000;
                                                                                               tx_equ_tap = 4'hE;
                                                                                             end //} 
                                                                                        2  : begin //{
                                                                                               tx_equ_cmd = 3'b001;
                                                                                               tx_equ_tap = 4'hE;
                                                                                             end //} 
                                                                                        3  : begin //{
                                                                                               tx_equ_cmd = 3'b010;
                                                                                               tx_equ_tap = 4'hE;
                                                                                             end //} 
                                                                                        4  : begin //{
                                                                                               tx_equ_cmd = 3'b011;
                                                                                               tx_equ_tap = 4'hE;
                                                                                             end //} 
                                                                                        5  : begin //{
                                                                                               tx_equ_cmd = 3'b100;
                                                                                               tx_equ_tap = 4'hE;
                                                                                             end //} 
                                                                                        6  : begin //{
                                                                                               tx_equ_cmd = 3'b101;
                                                                                               tx_equ_tap = 4'hE;
                                                                                             end //} 
                                                                                        7  : begin //{
                                                                                               tx_equ_cmd = 3'b110;
                                                                                               tx_equ_tap = 4'hE;
                                                                                             end //} 
                                                                                        8  : begin //{
                                                                                               tx_equ_cmd = 3'b111;
                                                                                               tx_equ_tap = 4'hE;
                                                                                             end //} 
                                                                                     endcase
                                                                                   end //}
                                                               endcase 
                                                          end //}
                                                    16 : begin //{
                                                            case(ld_config.cw_cmd_type)

                                                               CW_HOLD             : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'hF;
                                                                                     end  //} 
                                                               CW_DECR             : begin //{
                                                                                       tx_equ_cmd = 3'b001;
                                                                                       tx_equ_tap = 4'hF;
                                                                                     end //} 

                                                               CW_INCR             : begin //{
                                                                                       tx_equ_cmd = 3'b010;
                                                                                       tx_equ_tap = 4'hF;
                                                                                     end  //} 
                                                               CW_RSVD1            : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'hF;
                                                                                     end  //} 
                                                               CW_RSVD2            : begin //{
                                                                                       tx_equ_cmd = 3'b000;
                                                                                       tx_equ_tap = 4'hF;
                                                                                     end  //} 
                                                               CW_INIT             : begin //{
                                                                                       tx_equ_cmd = 3'b101;
                                                                                       tx_equ_tap = 4'hF;
                                                                                     end  //} 
                                                               CW_PRST             : begin //{
                                                                                       tx_equ_cmd = 3'b110;
                                                                                       tx_equ_tap = 4'hF;
                                                                                     end  //} 
                                                               CW_SPC_CMD_STAT     : begin //{
                                                                                       tx_equ_cmd = 3'b111;
                                                                                       tx_equ_tap = 4'hF;
                                                                                     end  //} 

                                                              CW_CMD_RANDOM : begin //{
                                                                                       cw_cmd_sel = $urandom_range(1,8);
                                                                                       case(cw_cmd_sel)

                                                                                         1  : begin //{
                                                                                                tx_equ_cmd = 3'b000;
                                                                                                tx_equ_tap = 4'hF;
                                                                                              end //} 
                                                                                         2  : begin //{
                                                                                                tx_equ_cmd = 3'b001;
                                                                                                tx_equ_tap = 4'hF;
                                                                                              end //} 
                                                                                         3  : begin //{
                                                                                                tx_equ_cmd = 3'b010;
                                                                                                tx_equ_tap = 4'hF;
                                                                                              end //} 
                                                                                         4  : begin //{
                                                                                                tx_equ_cmd = 3'b011;
                                                                                                tx_equ_tap = 4'hF;
                                                                                              end //} 
                                                                                         5  : begin //{
                                                                                                tx_equ_cmd = 3'b100;
                                                                                                tx_equ_tap = 4'hF;
                                                                                              end //} 
                                                                                         6  : begin //{
                                                                                                tx_equ_cmd = 3'b101;
                                                                                                tx_equ_tap = 4'hF;
                                                                                              end //} 
                                                                                         7  : begin //{
                                                                                                tx_equ_cmd = 3'b110;
                                                                                                tx_equ_tap = 4'hF;
                                                                                              end //} 
                                                                                         8  : begin //{
                                                                                                tx_equ_cmd = 3'b111;
                                                                                                tx_equ_tap = 4'hF;
                                                                                              end //} 
                                                                                      endcase
                                                                                    end //}
                                                                endcase 
                                                       end //}
                                                  endcase   
                                              end //}
                      endcase // cw tap type
                      cw_update_cmd_set = 1'b1;
                      cw_cmd_drive_cnt = cw_cmd_drive_cnt + 1;
                  end //}
                  else if(cw_drive_flag && cw_csflag && ~cw_load_flag && ~cw_wait_flag)
                  begin //{
                      cw_drive_cnt = ld_config.cw_training_ack_timeout_period;
                      cw_load_flag = 1'b1;
                      cw_update_cmd_set = 1'b0;
                  end //}
                 else if(cw_drive_flag && cw_wait_flag && cw_drive_cnt == 1 && ~cw_load_flag)
                 begin //{
                         cw_drive_cnt = cw_drive_cnt - 1;
                         cw_wait_flag = 1'b0;
                         cw_drive_flag = 1'b0;
                         cw_load_flag = 1'b0;
                          cw_update_cmd_set = 1'b0;
                 end //}
                  else if(cw_drive_flag && cw_wait_flag && cw_drive_cnt != 1 && ~cw_load_flag)
                  begin //{
                          cw_drive_cnt = cw_drive_cnt - 1;
                          cw_update_cmd_set = 1'b0;
                  end //}
                  else if(cw_drive_flag && cw_drive_cnt == 0 && ~cw_wait_flag && cw_load_flag)
                  begin //{
                          tx_equ_cmd = 3'b000;
                          cw_update_cmd_set = 1'b1;
                          cw_wait_flag = 1'b1;  
                          cw_drive_cnt = 50;
                          cw_load_flag = 1'b0;
                  end //}
                  else if(cw_drive_flag && cw_drive_cnt != 0 && ~cw_wait_flag && cw_load_flag)
                  begin //{
                      if(ld_trans.gen3_training_equalizer_status[lane_num] != 3'b000)
                      begin //{ 
                          tx_equ_cmd = 3'b000;
                          cw_update_cmd_set = 1'b1;
                          cw_wait_flag = 1'b1; 
                          cw_load_flag = 1'b0;
                          cw_drive_cnt = 50;
                      end //}
                      else
                      begin //{
                        cw_drive_cnt = cw_drive_cnt - 1;
                        cw_update_cmd_set = 1'b0;
                      end //} 
                  end //}

                  if(cw_update_cmd_set || cw_update_set)
                  begin //{
                       cw_update_value = {port_num,lane_num,remote_trn_sup,retrain_en,asym_mode_en,port_init,txt_1xmode,rx_width,rx_lanes_rdy,rx_ln_rdy,ln_trned,rx_width_cmd,rx_width_cmd_ack,rx_width_cmd_nack,6'b001111,tx_width_req,tx_width_pend_req,tx_scos,tx_equ_tap,tx_equ_cmd,tx_equ_st,retrn_gnt,retrn_rdy,retrning,port_ent_sil,lane_ent_sil,8'h00};
                       update_scos(lane_num,cw_update_value);
                       cw_update_cmd_set = 1'b0;
                       cw_update_set     = 1'b0;
                  end //}

              end //}
              else if(ld_trans.lane_trained [lane_num]) 
               begin //{
                cw_cmd_drive_cnt=0; 
               end //}

              remote_trn_sup      = ld_config.aet_en;
              port_init           = ld_trans.port_initialized;

              if(ld_trans.max_width == "1x") 
              begin //{
                  txt_1xmode = 1'b1;
              end //}
              else 
              begin //{
                  txt_1xmode = 1'b0;
              end //}

              if(ld_trans.max_width == "1x" && ld_trans.current_init_state == X1_M0) 
              begin //{
                  rx_width = 3'b001;
              end //}
              else if(ld_trans.max_width == "1x" && ld_trans.current_init_state == X1_M1) 
              begin //{
                  rx_width = 3'b110;
              end //}
              else if(ld_trans.max_width == "1x" && ld_trans.current_init_state == X1_M2) 
              begin //{
                  rx_width = 3'b111;
              end //}
              else if(ld_trans.max_width == "2x") 
              begin //{
                  rx_width = 3'b010;
              end //}
              else if(ld_trans.max_width == "4x") 
              begin //{
                  rx_width = 3'b011;
              end //}
              else if(ld_trans.max_width == "8x") 
              begin //{
                  rx_width = 3'b100;
              end //}
              else if(ld_trans.max_width == "16x") 
              begin //{
                  rx_width = 3'b101;
              end //}
              else 
              begin //{
                  rx_width = 3'b000;
              end //}

	      if (ld_trans.current_init_state == ASYM_MODE)
	      begin //{

                if(ld_trans.rcv_width == "1x") 
                begin //{
                    rx_width = 3'b001;
                end //}
                else if(ld_trans.rcv_width == "2x") 
                begin //{
                    rx_width = 3'b010;
                end //}
                else if(ld_trans.rcv_width == "4x") 
                begin //{
                    rx_width = 3'b011;
                end //}
                else if(ld_trans.rcv_width == "8x") 
                begin //{
                    rx_width = 3'b100;
                end //}
                else if(ld_trans.rcv_width == "16x") 
                begin //{
                    rx_width = 3'b101;
                end //}
                else 
                begin //{
                    rx_width = 3'b000;
                end //}

	      end //}

              asym_mode_en = (ld_config.asym_1x_mode_en || ld_config.asym_2x_mode_en || ld_config.asym_nx_mode_en) && ld_config.asymmetric_support; //Indicates port is allowed to enter asymmetric mode
              for(int i=0;i<=15;i++)
                 lane_rdy_0_15=ld_trans.lane_ready[0] && ld_trans.lane_ready[i];
              for(int i=0;i<=7;i++)
                 lane_rdy_0_7=ld_trans.lane_ready[0] && ld_trans.lane_ready[i];
              for(int i=0;i<=3;i++)
                 lane_rdy_0_3=ld_trans.lane_ready[0] && ld_trans.lane_ready[i];
              for(int i=0;i<=1;i++)
                 lane_rdy_0_1=ld_trans.lane_ready[0] && ld_trans.lane_ready[i];
              if(lane_rdy_0_15) 
               rx_lanes_rdy=3'b101;                 
              else if (lane_rdy_0_7)
               rx_lanes_rdy=3'b100;                 
              else if (lane_rdy_0_3)
               rx_lanes_rdy=3'b011;                 
              else if (lane_rdy_0_1)
               rx_lanes_rdy=3'b010;                 
              else if (ld_trans.lane_ready[0])
               rx_lanes_rdy=3'b001;
              else                 
               rx_lanes_rdy=3'b000;
              rx_ln_rdy=ld_trans.lane_ready[lane_num];
              ln_trned =ld_trans.lane_trained[lane_num];
              rx_width_cmd=ld_trans.rcv_width_link_cmd;
              rx_width_cmd_ack=ld_trans.rcv_width_link_cmd_ack;
              rx_width_cmd_nack=ld_trans.rcv_width_link_cmd_nack;
              tx_width_req=ld_trans.change_lp_xmt_width;
              tx_width_pend_req=ld_trans.xmt_width_port_req_pending;
              tx_scos=ld_trans.xmt_sc_seq;
              retrn_gnt=ld_trans.retrain_grnt;
              retrn_rdy=ld_trans.retrain_ready;
              retrning=ld_trans.retraining;
              cw_update_value = {port_num,lane_num,remote_trn_sup,retrain_en,asym_mode_en,port_init,txt_1xmode,rx_width,rx_lanes_rdy,rx_ln_rdy,ln_trned,rx_width_cmd,rx_width_cmd_ack,rx_width_cmd_nack,6'b001111,tx_width_req,tx_width_pend_req,tx_scos,tx_equ_tap,tx_equ_cmd,tx_equ_st,retrn_gnt,retrn_rdy,retrning,port_ent_sil,lane_ent_sil,8'h00};
              update_scos(lane_num,cw_update_value);


          end //} 
       end //}
  end //}
 
  endtask : cw_training


//////////////////////////////////////////////////////////////////////////
/// Name: aet_lane
/// Description: Task to generate the AET Commands 
//////////////////////////////////////////////////////////////////////////
 task srio_pl_lane_driver::aet_lane();
 int temp,temp1;
 update_value = {2'b00,1'b0,ld_config.tx_scr_en,20'h00000,8'h00};
 update_cs_field(lane_num,update_value);
 forever
 begin //{
      @(negedge ld_trans.int_clk or negedge srio_if.srio_rst_n)
      begin //{
         if(~srio_if.srio_rst_n)
         begin //{
           tplus_status_min   = ld_config.tap_plus_min_value;
           tplus_status_max   = ld_config.tap_plus_max_value;
           tplus_rst_val      = ld_config.tap_plus_rst_value;
           tplus_prst_val     = ld_config.tap_plus_prst_value;
           tminus_status_min  = ld_config.tap_minus_min_value;
           tminus_status_max  = ld_config.tap_minus_max_value;
           tminus_rst_val     = ld_config.tap_minus_rst_value;
           tminus_prst_val    = ld_config.tap_minus_prst_value;
           tplus_cmd_val      = 2'b00;
           tminus_cmd_val     = 2'b00;
           rst_cmd_val        = 1'b0;
           prst_cmd_val       = 1'b0; 
           tplus_status       = ld_config.tap_plus_max_value;
           tminus_status      = ld_config.tap_minus_max_value;
           tplus_status_sent  = 2'b00;
           tminus_status_sent  = 2'b00;
           ack                 = 1'b0;
           nack                = 1'b0;
           cmd                 = 1'b0;
           rxr_trained         = 1'b0;
           tx_scr_en           = ld_config.tx_scr_en;
           tap_minus_cmd       = 2'b00;
           tap_plus_cmd        = 2'b00;
           rst_cmd             = 1'b0;
           prst_cmd            = 1'b0;
           update_value        = 32'h0000;
           drive_flag          = 1'b0;
           wait_flag           = 1'b0;
           drive_cnt           = 0;
           cmd_drive_cnt       = 0;
           start_aet           = 0;
           update_set          = 0;
           update_cmd_set      = 0;
           ack_wait_cnt        = 0;
           timer_flag          = 0;
           ack_wait_flag       = 0;
           timer_cnt           = 0; 
           dly_cnt             = 0;
           ack_rcvd            = 0;
           nak_rcvd            = 0;
         end //}
         else
         begin //{ 
             if(ld_trans.lane_sync[lane_num] == 1 && ld_trans.idle_detected == 1 && ld_trans.idle_selected == 1 && ~start_aet)
             begin //{
                 start_aet = 1'b1;
             end //} 
             if(start_aet)
             begin //{
                if(~ld_trans.rcvr_trained [lane_num])
                begin //{
                  if(ld_trans.idle2_aet_command_set[lane_num] && (ld_trans.idle2_aet_cs_fld_tap_plus1_cmd[lane_num] || ld_trans.idle2_aet_cs_fld_tap_minus1_cmd[lane_num] || ld_trans.idle2_aet_cs_fld_reset_cmd[lane_num] || ld_trans.idle2_aet_cs_fld_preset_cmd[lane_num]) && ~timer_flag && ~ack_wait_flag)
                  begin //{
                     timer_flag = 1'b1;
                     timer_cnt =  ld_config.cs_field_ack_timer;
                    if(ld_trans.idle2_aet_cs_fld_tap_plus1_cmd[lane_num] == 1'b1)
                    begin //{
                      tplus_cmd_val = ld_trans.idle2_aet_cs_fld_tap_plus1_cmd_val[lane_num]; 
                      // decrement cmd rxed 
                      if(tplus_cmd_val == 2'b01 && (tplus_status > tplus_status_min))
                      begin //{
                         tplus_status = tplus_status_max - 1;
                         tplus_status_sent = 2'b11;
                         ack          = 1'b1;
                         nack         = 1'b0;
                      end //}
                      else if(tplus_cmd_val == 2'b01 && (tplus_status <= tplus_status_min))
                      begin //{
                         tplus_status = tplus_status;
                         tplus_status_sent = 2'b01; 
                         ack          = 1'b0;
                         nack         = 1'b1;
                      end //}
                      // inc cmd rxed
                      else if(tplus_cmd_val == 2'b10 && (tplus_status >= tplus_status_max))
                      begin //{
                         tplus_status = tplus_status;
                         tplus_status_sent = 2'b10;
                         ack          = 1'b0;
                         nack         = 1'b1;
                      end //}
                      else if(tplus_cmd_val == 2'b10 && (tplus_status < tplus_status_max))
                      begin //{
                         tplus_status = tplus_status + 1;
                         tplus_status_sent = 2'b11;
                         ack          = 1'b1;
                         nack         = 1'b0;
                      end //}
                      else if(tplus_cmd_val == 2'b00)
                      begin //{
                         ack          = 1'b1;
                         nack         = 1'b0;
                      end //}
                    end //}  
                    else if(ld_trans.idle2_aet_cs_fld_tap_minus1_cmd[lane_num] == 1'b1 )
                    begin //{
                      tminus_cmd_val = ld_trans.idle2_aet_cs_fld_tap_minus1_cmd_val[lane_num]; 
                      // decrement cmd rxed 
                      if(tminus_cmd_val == 2'b01 && (tminus_status > tminus_status_min))
                      begin //{
                         tminus_status = tminus_status_max - 1;
                         tminus_status_sent = 2'b11;
                         ack          = 1'b1;
                         nack         = 1'b0;
                      end //}
                      else if(tminus_cmd_val == 2'b01 && (tminus_status <= tminus_status_min))
                      begin //{
                         tminus_status = tminus_status;
                         tminus_status_sent = 2'b01; 
                         ack          = 1'b0;
                         nack         = 1'b1;
                      end //}
                      // inc cmd rxed
                      else if(tminus_cmd_val == 2'b10 && (tminus_status >= tminus_status_max))
                      begin //{
                         tminus_status = tminus_status;
                         tminus_status_sent = 2'b10;
                         ack          = 1'b0;
                         nack         = 1'b1;
                      end //}
                      else if(tminus_cmd_val == 2'b10 && (tminus_status < tminus_status_max))
                      begin //{
                         tminus_status = tminus_status + 1;
                         tminus_status_sent = 2'b11;
                         ack          = 1'b1;
                         nack         = 1'b0;
                      end //}
                      else if(tminus_cmd_val == 2'b00)
                      begin //{
                         ack          = 1'b1;
                         nack         = 1'b0;
                      end //}
                    end //}  
                    else if(ld_trans.idle2_aet_cs_fld_reset_cmd[lane_num] == 1'b1 ) 
                    begin //{
                      rst_cmd_val = ld_trans.idle2_aet_cs_fld_reset_cmd[lane_num]; 
                      tminus_status = ld_config.tap_minus_rst_value;
                      tplus_status = ld_config.tap_plus_rst_value;
                      ack          = 1'b1;
                      nack         = 1'b0;
                    end //}  
                    else if(ld_trans.idle2_aet_cs_fld_preset_cmd[lane_num] == 1'b1 )
                    begin //{
                      prst_cmd_val = ld_trans.idle2_aet_cs_fld_preset_cmd[lane_num]; 
                      tminus_status = ld_config.tap_minus_prst_value;
                      tplus_status = ld_config.tap_plus_prst_value;
                      ack          = 1'b1;
                      nack         = 1'b0;
                    end //}  
                     update_set = 1'b1;
                  end //}  
                  else if(~timer_flag && ack_wait_cnt == 0 && ack_wait_flag)
                  begin //{
                         ack_wait_cnt  = 0;
                         ack_wait_flag = 1'b0;
                         if(ack)
                           ack = 0;
                         else if(nack)
                           nack = 0;
                         update_set = 1'b1;
                  end //}
                  else if(~timer_flag && ack_wait_cnt != 0 && ack_wait_flag)
                  begin //{
                         ack_wait_cnt  = ack_wait_cnt - 1;
                  end //}
                  else if(timer_flag && timer_cnt == 0 && ~ack_wait_flag)
                  begin //{
                         timer_cnt = 0;
                         timer_flag = 0;
                         ack_wait_flag = 1'b1;
                         ack_wait_cnt  = ld_config.cs_field_ack_timer;
                  end //}
                  else if(timer_flag && timer_cnt != 0 && ~ack_wait_flag)
                  begin //{
                      update_set = 1'b0;
                      if(~ld_trans.idle2_aet_command_set[lane_num])
                      begin //{
                         timer_cnt = 0;
                         timer_flag = 0;
                         ack_wait_flag = 1'b1;
                         ack_wait_cnt  = ld_config.cs_field_ack_timer;
                      end //}
                      else
                      begin //{
                         timer_cnt = timer_cnt - 1;
                      end //} 
                  end //}
                  end //}
                  else if(ld_trans.rcvr_trained [lane_num])
                  begin //{
                       rxr_trained = 1'b1;
                  end //}

                  // drive cmd logic
                  if(ld_config.aet_cmd_kind == CMD_DISABLED )
                  begin //{
                       `uvm_info("SRIO_PL_LANE DRIVER : ", $sformatf("AET COMMAND DRIVE IS DISABLED lane_num is %d",lane_num), UVM_LOW)
                  end //}
                  else if(ld_config.aet_cmd_kind == CMD_ENABLED && ~drive_flag &&  ~wait_flag && ld_config.aet_cmd_cnt == cmd_drive_cnt)
                  begin //{
                   //    `uvm_info("SRIO_PL_LANE DRIVER : ", $sformatf("AET COMMAND DRIVE CNT REACHED STOPPED SENDING COMMANDS lane_num is %d",lane_num), UVM_LOW)
                  end //}
                  else if(ld_config.aet_cmd_kind == CMD_ENABLED && ~drive_flag &&  ~wait_flag && ld_config.aet_cmd_cnt != cmd_drive_cnt && ~load_flag)
                  begin //{
                       drive_flag = 1'b1;  
                       load_flag = 1'b0;
                       if(ld_config.aet_cmd_type == TAPPLUS)
                       begin //{  
                            cmd = 1'b1;
                            if(ld_config.aet_tplus_kind == TP_INCR)
                               tap_plus_cmd = 2'b10;
                            else if(ld_config.aet_tplus_kind == TP_DECR)
                               tap_plus_cmd = 2'b01;
                            else if(ld_config.aet_tplus_kind == TP_HOLD)
                               tap_plus_cmd = 2'b00;
                            else if(ld_config.aet_tplus_kind == TP_RANDOM)
                            begin //{
                               temp      = $urandom_range(0,2);
                               if(temp == 0)
                                 tap_plus_cmd = 2'b00;
                               else if(temp == 1)
                                 tap_plus_cmd = 2'b01;
                               else if(temp == 2)
                                 tap_plus_cmd = 2'b10;
                            end //}
                       end //}
                       else if(ld_config.aet_cmd_type == TAPMINUS)
                       begin //{  
                            cmd = 1'b1;
                            if(ld_config.aet_tminus_kind == TM_INCR)
                               tap_minus_cmd = 2'b10;
                            else if(ld_config.aet_tminus_kind == TM_DECR)
                               tap_minus_cmd = 2'b01;
                            else if(ld_config.aet_tminus_kind == TM_HOLD)
                               tap_minus_cmd = 2'b00;
                            else if(ld_config.aet_tminus_kind == TM_RANDOM)
                            begin //{
                               temp      = $urandom_range(0,2);
                               if(temp == 0)
                                 tap_minus_cmd = 2'b00;
                               else if(temp == 1)
                                 tap_minus_cmd = 2'b01;
                               else if(temp == 2)
                                 tap_minus_cmd = 2'b10;
                            end //}
                       end //}
                       else if(ld_config.aet_cmd_type == RST)
                       begin //{  
                            cmd = 1'b1;
                            rst_cmd = 1'b1;
                       end //}
                       else if(ld_config.aet_cmd_type == PRST)
                       begin //{  
                            cmd = 1'b1;
                            prst_cmd = 1'b1;
                       end //}
                       else if(ld_config.aet_cmd_type == CMD_RANDOM)
                       begin //{  
                            cmd = 1'b1;
                            temp      = $urandom_range(0,3);
                            if(temp == 0)
                            begin //{
                               temp1      = $urandom_range(0,2);
                               if(temp1 == 0)
                                 tap_plus_cmd = 2'b00;
                               else if(temp1 == 1)
                                 tap_plus_cmd = 2'b01;
                               else if(temp1 == 2)
                                 tap_plus_cmd = 2'b10;
                            end //}
                            else if(temp == 1)
                            begin //{
                               temp1      = $urandom_range(0,2);
                               if(temp1 == 0)
                                 tap_minus_cmd = 2'b00;
                               else if(temp1 == 1)
                                 tap_minus_cmd = 2'b01;
                               else if(temp1 == 2)
                                 tap_minus_cmd = 2'b10;
                            end //}
                            else if(temp == 2)
                            begin //{
                              rst_cmd = 1'b1;
                            end //}
                            else if(temp == 3)
                            begin //{
                              prst_cmd = 1'b1;
                            end //}
                       end //}
                       update_cmd_set = 1'b1;
                       //cmd_drive_cnt = cmd_drive_cnt + 1;
                   end //}
                   else if(drive_flag && wait_flag && drive_cnt == 1 && ~load_flag)
                   begin //{
                           drive_cnt = drive_cnt - 1;
                           wait_flag = 1'b0;
                           drive_flag = 1'b0;
                           load_flag = 1'b0;
                   end //}
                   else if(drive_flag && wait_flag && drive_cnt != 1 && ~load_flag)
                   begin //{
                           drive_cnt = drive_cnt - 1;
                           update_cmd_set = 1'b0;
                           if(nak_rcvd)
                            begin//{
                             if(ld_trans.idle2_aet_cs_fld_nack[lane_num]==0)
                              begin//{
                               drive_cnt=1;
                               nak_rcvd=0;
                              end//}
                            end//}
                           else if(ack_rcvd)
                            begin//{
                             if(ld_trans.idle2_aet_cs_fld_ack[lane_num]==0)
                              begin//{
                               drive_cnt=1;
                               ack_rcvd=0;
                              end//}
                            end//}
                   end //}
                   else if(drive_flag && drive_cnt == 0 && ~wait_flag && load_flag)
                   begin //{
                           cmd = 1'b0;
                           update_cmd_set = 1'b1;
                           cmd_drive_cnt = cmd_drive_cnt + 1;
                           wait_flag = 1'b1;  
                           drive_cnt = ld_config.aet_command_period;
                           load_flag = 1'b0;
                   end //}
                   else if(drive_flag && csflag && ~load_flag)
                   begin //{
                       drive_cnt = ld_config.cs_field_ack_timer;
                       load_flag = 1'b1;
                   end //}
                   else if(drive_flag && drive_cnt != 0 && ~wait_flag && load_flag)
                   begin //{
                       update_cmd_set = 1'b0;
                       if(ld_trans.idle2_aet_cs_fld_ack[lane_num] || ld_trans.idle2_aet_cs_fld_nack[lane_num])
                       begin //{ 
                           cmd = 1'b0;
                           update_cmd_set = 1'b1;
                           wait_flag = 1'b1; 
                           load_flag = 1'b0;
                           drive_cnt = ld_config.aet_command_period;
                           cmd_drive_cnt = cmd_drive_cnt + 1;
                           ack_rcvd=(ld_trans.idle2_aet_cs_fld_ack[lane_num]==1)?1:0;
                           nak_rcvd=(ld_trans.idle2_aet_cs_fld_nack[lane_num]==1)?1:0;
                       end //}
                       else
                       begin //{
                         drive_cnt = drive_cnt - 1;
                         update_cmd_set = 1'b0;
                       end //} 
                   end //}
            if(update_cmd_set || update_set)
            begin //{
                 update_value = {cmd,1'b0,rxr_trained,tx_scr_en,tminus_status,tplus_status,16'h00,tap_minus_cmd,tap_plus_cmd,rst_cmd,prst_cmd,ack,nack};
                 update_cs_field(lane_num,update_value);
                 update_cmd_set = 1'b0;
                 update_set     = 1'b0;
            end //}
         end //} 
       end //} 
      end //} 
 end //}
 endtask : aet_lane

//////////////////////////////////////////////////////////////////////////
/// Name: update_cs_field
/// Description: Task to encode the CS fields 
//////////////////////////////////////////////////////////////////////////
 task srio_pl_lane_driver::update_cs_field(input int ln_num, bit [0:31] update_value);

 bit [0:31] temp;
 temp =  update_value;

 if(temp[0:1] == 2'b00)
   csf_marker_array[31] = {1'b0, 8'h67};
 else if(temp[0:1] == 2'b01)
   csf_marker_array[31] = {1'b0, 8'h78};
 else if(temp[0:1] == 2'b10)
   csf_marker_array[31] = {1'b0, 8'h7E};
 else if(temp[0:1] == 2'b11)
   csf_marker_array[31] = {1'b0, 8'hF8};

 if(temp[2:3] == 2'b00)
   csf_marker_array[30] = {1'b0, 8'h67};
 else if(temp[2:3] == 2'b01)
   csf_marker_array[30] = {1'b0, 8'h78};
 else if(temp[2:3] == 2'b10)
   csf_marker_array[30] = {1'b0, 8'h7E};
 else if(temp[2:3] == 2'b11)
   csf_marker_array[30] = {1'b0, 8'hF8};

 if(temp[4:5] == 2'b00)
   csf_marker_array[29] = {1'b0, 8'h67};
 else if(temp[4:5] == 2'b01)
   csf_marker_array[29] = {1'b0, 8'h78};
 else if(temp[4:5] == 2'b10)
   csf_marker_array[29] = {1'b0, 8'h7E};
 else if(temp[4:5] == 2'b11)
   csf_marker_array[29] = {1'b0, 8'hF8};

 if(temp[6:7] == 2'b00)
   csf_marker_array[28] = {1'b0, 8'h67};
 else if(temp[6:7] == 2'b01)
   csf_marker_array[28] = {1'b0, 8'h78};
 else if(temp[6:7] == 2'b10)
   csf_marker_array[28] = {1'b0, 8'h7E};
 else if(temp[6:7] == 2'b11)
   csf_marker_array[28] = {1'b0, 8'hF8};


 if(temp[8:9] == 2'b00)
   csf_marker_array[27] = {1'b0, 8'h67};
 else if(temp[8:9] == 2'b01)
   csf_marker_array[27] = {1'b0, 8'h78};
 else if(temp[8:9] == 2'b10)
   csf_marker_array[27] = {1'b0, 8'h7E};
 else if(temp[8:9] == 2'b11)
   csf_marker_array[27] = {1'b0, 8'hF8};

 if(temp[10:11] == 2'b00)
   csf_marker_array[26] = {1'b0, 8'h67};
 else if(temp[10:11] == 2'b01)
   csf_marker_array[26] = {1'b0, 8'h78};
 else if(temp[10:11] == 2'b10)
   csf_marker_array[26] = {1'b0, 8'h7E};
 else if(temp[10:11] == 2'b11)
   csf_marker_array[26] = {1'b0, 8'hF8};

 if(temp[12:13] == 2'b00)
   csf_marker_array[25] = {1'b0, 8'h67};
 else if(temp[12:13] == 2'b01)
   csf_marker_array[25] = {1'b0, 8'h78};
 else if(temp[12:13] == 2'b10)
   csf_marker_array[25] = {1'b0, 8'h7E};
 else if(temp[12:13] == 2'b11)
   csf_marker_array[25] = {1'b0, 8'hF8};

 if(temp[14:15] == 2'b00)
   csf_marker_array[24] = {1'b0, 8'h67};
 else if(temp[14:15] == 2'b01)
   csf_marker_array[24] = {1'b0, 8'h78};
 else if(temp[14:15] == 2'b10)
   csf_marker_array[24] = {1'b0, 8'h7E};
 else if(temp[14:15] == 2'b11)
   csf_marker_array[24] = {1'b0, 8'hF8};

 if(temp[16:17] == 2'b00)
   csf_marker_array[23] = {1'b0, 8'h67};
 else if(temp[16:17] == 2'b01)
   csf_marker_array[23] = {1'b0, 8'h78};
 else if(temp[16:17] == 2'b10)
   csf_marker_array[23] = {1'b0, 8'h7E};
 else if(temp[16:17] == 2'b11)
   csf_marker_array[23] = {1'b0, 8'hF8};

 if(temp[18:19] == 2'b00)
   csf_marker_array[22] = {1'b0, 8'h67};
 else if(temp[18:19] == 2'b01)
   csf_marker_array[22] = {1'b0, 8'h78};
 else if(temp[18:19] == 2'b10)
   csf_marker_array[22] = {1'b0, 8'h7E};
 else if(temp[18:19] == 2'b11)
   csf_marker_array[22] = {1'b0, 8'hF8};

 if(temp[20:21] == 2'b00)
   csf_marker_array[21] = {1'b0, 8'h67};
 else if(temp[20:21] == 2'b01)
   csf_marker_array[21] = {1'b0, 8'h78};
 else if(temp[20:21] == 2'b10)
   csf_marker_array[21] = {1'b0, 8'h7E};
 else if(temp[20:21] == 2'b11)
   csf_marker_array[21] = {1'b0, 8'hF8};

 if(temp[22:23] == 2'b00)
   csf_marker_array[20] = {1'b0, 8'h67};
 else if(temp[22:23] == 2'b01)
   csf_marker_array[20] = {1'b0, 8'h78};
 else if(temp[22:23] == 2'b10)
   csf_marker_array[20] = {1'b0, 8'h7E};
 else if(temp[22:23] == 2'b11)
   csf_marker_array[20] = {1'b0, 8'hF8};

 if(temp[24:25] == 2'b00)
   csf_marker_array[19] = {1'b0, 8'h67};
 else if(temp[24:25] == 2'b01)
   csf_marker_array[19] = {1'b0, 8'h78};
 else if(temp[24:25] == 2'b10)
   csf_marker_array[19] = {1'b0, 8'h7E};
 else if(temp[24:25] == 2'b11)
   csf_marker_array[19] = {1'b0, 8'hF8};

 if(temp[26:27] == 2'b00)
   csf_marker_array[18] = {1'b0, 8'h67};
 else if(temp[26:27] == 2'b01)
   csf_marker_array[18] = {1'b0, 8'h78};
 else if(temp[26:27] == 2'b10)
   csf_marker_array[18] = {1'b0, 8'h7E};
 else if(temp[26:27] == 2'b11)
   csf_marker_array[18] = {1'b0, 8'hF8};

 if(temp[28:29] == 2'b00)
   csf_marker_array[17] = {1'b0, 8'h67};
 else if(temp[28:29] == 2'b01)
   csf_marker_array[17] = {1'b0, 8'h78};
 else if(temp[28:29] == 2'b10)
   csf_marker_array[17] = {1'b0, 8'h7E};
 else if(temp[28:29] == 2'b11)
   csf_marker_array[17] = {1'b0, 8'hF8};

 if(temp[30:31] == 2'b00)
   csf_marker_array[16] = {1'b0, 8'h67};
 else if(temp[30:31] == 2'b01)
   csf_marker_array[16] = {1'b0, 8'h78};
 else if(temp[30:31] == 2'b10)
   csf_marker_array[16] = {1'b0, 8'h7E};
 else if(temp[30:31] == 2'b11)
   csf_marker_array[16] = {1'b0, 8'hF8};

 // inversion 
 if(temp[0:1] == 2'b00)
   csf_marker_array[15] = {1'b0, 8'hF8};
 else if(temp[0:1] == 2'b01)
   csf_marker_array[15] = {1'b0, 8'h7E};
 else if(temp[0:1] == 2'b10)
   csf_marker_array[15] = {1'b0, 8'h78};
 else if(temp[0:1] == 2'b11)
   csf_marker_array[15] = {1'b0, 8'h67};

 if(temp[2:3] == 2'b00)
   csf_marker_array[14] = {1'b0, 8'hF8};
 else if(temp[2:3] == 2'b01)
   csf_marker_array[14] = {1'b0, 8'h7E};
 else if(temp[2:3] == 2'b10)
   csf_marker_array[14] = {1'b0, 8'h78};
 else if(temp[2:3] == 2'b11)
   csf_marker_array[14] = {1'b0, 8'h67};

 if(temp[4:5] == 2'b00)
   csf_marker_array[13] = {1'b0, 8'hF8};
 else if(temp[4:5] == 2'b01)
   csf_marker_array[13] = {1'b0, 8'h7E};
 else if(temp[4:5] == 2'b10)
   csf_marker_array[13] = {1'b0, 8'h78};
 else if(temp[4:5] == 2'b11)
   csf_marker_array[13] = {1'b0, 8'h67};

 if(temp[6:7] == 2'b00)
   csf_marker_array[12] = {1'b0, 8'hF8};
 else if(temp[6:7] == 2'b01)
   csf_marker_array[12] = {1'b0, 8'h7E};
 else if(temp[6:7] == 2'b10)
   csf_marker_array[12] = {1'b0, 8'h78};
 else if(temp[6:7] == 2'b11)
   csf_marker_array[12] = {1'b0, 8'h67};


 if(temp[8:9] == 2'b00)
   csf_marker_array[11] = {1'b0, 8'hF8};
 else if(temp[8:9] == 2'b01)
   csf_marker_array[11] = {1'b0, 8'h7E};
 else if(temp[8:9] == 2'b10)
   csf_marker_array[11] = {1'b0, 8'h78};
 else if(temp[8:9] == 2'b11)
   csf_marker_array[11] = {1'b0, 8'h67};

 if(temp[10:11] == 2'b00)
   csf_marker_array[10] = {1'b0, 8'hF8};
 else if(temp[10:11] == 2'b01)
   csf_marker_array[10] = {1'b0, 8'h7E};
 else if(temp[10:11] == 2'b10)
   csf_marker_array[10] = {1'b0, 8'h78};
 else if(temp[10:11] == 2'b11)
   csf_marker_array[10] = {1'b0, 8'h67};

 if(temp[12:13] == 2'b00)
   csf_marker_array[9] = {1'b0, 8'hF8};
 else if(temp[12:13] == 2'b01)
   csf_marker_array[9] = {1'b0, 8'h7E};
 else if(temp[12:13] == 2'b10)
   csf_marker_array[9] = {1'b0, 8'h78};
 else if(temp[12:13] == 2'b11)
   csf_marker_array[9] = {1'b0, 8'h67};

 if(temp[14:15] == 2'b00)
   csf_marker_array[8] = {1'b0, 8'hF8};
 else if(temp[14:15] == 2'b01)
   csf_marker_array[8] = {1'b0, 8'h7E};
 else if(temp[14:15] == 2'b10)
   csf_marker_array[8] = {1'b0, 8'h78};
 else if(temp[14:15] == 2'b11)
   csf_marker_array[8] = {1'b0, 8'h67};

 if(temp[16:17] == 2'b00)
   csf_marker_array[7] = {1'b0, 8'hF8};
 else if(temp[16:17] == 2'b01)
   csf_marker_array[7] = {1'b0, 8'h7E};
 else if(temp[16:17] == 2'b10)
   csf_marker_array[7] = {1'b0, 8'h78};
 else if(temp[16:17] == 2'b11)
   csf_marker_array[7] = {1'b0, 8'h67};

 if(temp[18:19] == 2'b00)
   csf_marker_array[6] = {1'b0, 8'hF8};
 else if(temp[18:19] == 2'b01)
   csf_marker_array[6] = {1'b0, 8'h7E};
 else if(temp[18:19] == 2'b10)
   csf_marker_array[6] = {1'b0, 8'h78};
 else if(temp[18:19] == 2'b11)
   csf_marker_array[6] = {1'b0, 8'h67};

 if(temp[20:21] == 2'b00)
   csf_marker_array[5] = {1'b0, 8'hF8};
 else if(temp[20:21] == 2'b01)
   csf_marker_array[5] = {1'b0, 8'h7E};
 else if(temp[20:21] == 2'b10)
   csf_marker_array[5] = {1'b0, 8'h78};
 else if(temp[20:21] == 2'b11)
   csf_marker_array[5] = {1'b0, 8'h67};

 if(temp[22:23] == 2'b00)
   csf_marker_array[4] = {1'b0, 8'hF8};
 else if(temp[22:23] == 2'b01)
   csf_marker_array[4] = {1'b0, 8'h7E};
 else if(temp[22:23] == 2'b10)
   csf_marker_array[4] = {1'b0, 8'h78};
 else if(temp[22:23] == 2'b11)
   csf_marker_array[4] = {1'b0, 8'h67};

 if(temp[24:25] == 2'b00)
   csf_marker_array[3] = {1'b0, 8'hF8};
 else if(temp[24:25] == 2'b01)
   csf_marker_array[3] = {1'b0, 8'h7E};
 else if(temp[24:25] == 2'b10)
   csf_marker_array[3] = {1'b0, 8'h78};
 else if(temp[24:25] == 2'b11)
   csf_marker_array[3] = {1'b0, 8'h67};

 if(temp[26:27] == 2'b00)
   csf_marker_array[2] = {1'b0, 8'hF8};
 else if(temp[26:27] == 2'b01)
   csf_marker_array[2] = {1'b0, 8'h7E};
 else if(temp[26:27] == 2'b10)
   csf_marker_array[2] = {1'b0, 8'h78};
 else if(temp[26:27] == 2'b11)
   csf_marker_array[2] = {1'b0, 8'h67};

 if(temp[28:29] == 2'b00)
   csf_marker_array[1] = {1'b0, 8'hF8};
 else if(temp[28:29] == 2'b01)
   csf_marker_array[1] = {1'b0, 8'h7E};
 else if(temp[28:29] == 2'b10)
   csf_marker_array[1] = {1'b0, 8'h78};
 else if(temp[28:29] == 2'b11)
   csf_marker_array[1] = {1'b0, 8'h67};

 if(temp[30:31] == 2'b00)
   csf_marker_array[0] = {1'b0, 8'hF8};
 else if(temp[30:31] == 2'b01)
   csf_marker_array[0] = {1'b0, 8'h7E};
 else if(temp[30:31] == 2'b10)
   csf_marker_array[0] = {1'b0, 8'h78};
 else if(temp[30:31] == 2'b11)
   csf_marker_array[0] = {1'b0, 8'h67};

 endtask : update_cs_field

//////////////////////////////////////////////////////////////////////////
/// Name: pop_char
/// Description: Task to pop the data from the queue for transmission  
/// 
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::pop_char();
 bit [0:8] temp;
  forever
  begin //{
    @(posedge ld_trans.int_clk or negedge srio_if.srio_rst_n)
    begin //{
       if(~srio_if.srio_rst_n)
       begin //{
         srio_if.tx_pdata[lane_num] = 9'b0; 
         cw_csflag = 1'b0;
         csflag = 1'b0;
         csf_cnt = 0;
         wait_frame = 1'b0;
         dme_frame_cnt = 0;
         dme_cnt_flag  = 1'b0;
         stcs_cnt      = 0;
         temp_stcs_data = 64'h0000_0000_0000_0000; 
         BIP_23=0;
         lanecheck_1=0;
       end //}
       else
       begin //{   
           if(lane_data_q.size() > 3)
           begin //{
             lane_data_ins  =  lane_data_q.pop_front();

             if(ld_env_config.srio_mode == SRIO_GEN30)
             begin //{
                 if(lane_data_ins.brc3_sdos_update == 1'b1)
                 begin //{
                     lane_data_ins.brc3_cw = {lfsr_q[0:29],6'b001101,lfsr_q[30:57]}; 
                 end //} 
                 if(lane_data_ins.brc3_lc_update == 1'b1)
                 begin //{
                     lane_data_ins.brc3_cw = {BIP_23,7'b1011010,6'b001100,5'b10101,~BIP_23}; 
                     lanecheck_1=1;
                 end //} 

                 if(lane_data_ins.brc3_fm_update == 1'b1)
                 begin //{
                      form_trn_frame = 1'b1;
                      wait_frame = 1'b0;
                      dme_training_command_g3 = idle3_dme_cmd_array[lane_num]; 
                      if(dme_training_command_g3[2] == 1'b1 || dme_training_command_g3[3] == 1'b1 || dme_training_command_g3[10:11] != 2'b00 || dme_training_command_g3[12:13] != 2'b00 || dme_training_command_g3[14:15] != 2'b00) 
                      begin //{
                         ld_trans.gen3_bfm_training_command_set[lane_num] = 1'b1;
                      end //} 
                      else 
                      begin //{
                         ld_trans.gen3_bfm_training_command_set[lane_num] = 1'b0;
                      end //} 
             
                 end //}

                 if(lane_data_ins.brc3_cof_update == 1'b1)
                 begin //{
                      form_trn_frame = 1'b0;
                 end //}

                 if(lane_data_ins.brc3_stat_update == 1'b1)
                 begin //{
                 end //}
                 if(lane_data_ins.brc3_trn_update == 1'b1)
                 begin //{
                      wait_frame = 1'b1;
                 end //}

                 if(lane_data_ins.brc3_trn_update == 1'b0)
                 begin //{
                 end //}

                 if(lane_data_ins.brc3_stcs_update == 1'b1 )
                 begin //{
                     if(stcs_cnt == 0)
                     begin //{
                         temp_stcs_data = idle3_scos_array[lane_num];
                         lane_data_ins.brc3_cw = temp_stcs_data;
                         stcs_cnt = stcs_cnt + 1;
                     end //} 
                     else if(stcs_cnt == 1)
                     begin //{
                         lane_data_ins.brc3_cw = temp_stcs_data;
                         stcs_cnt = 0;
                     end //} 
                  
                     cw_csflag = 1'b1; 
                     if(lane_data_ins.brc3_cw[45:47] != 3'b000)
                     begin //{
                        ld_trans.gen3_bfm_training_command_set[lane_num] = 1'b1;
                     end //} 
                     else 
                     begin //{
                        ld_trans.gen3_bfm_training_command_set[lane_num] = 1'b0;
                     end //} 
                 end //} 

                 if(lane_data_ins.brc3_stcs_update != 1'b1)
                 begin //{
                     cw_csflag = 1'b0; 
                 end //} 
             end //}   

             if(lane_data_ins.csfield_update == 1 && ~csflag && ld_config.aet_en && (ld_env_config.srio_mode == SRIO_GEN21 || ld_env_config.srio_mode == SRIO_GEN22))
             begin //{
                csflag = 1'b1;
                csf_cnt = 31;
                temp = csf_marker_array[csf_cnt];
                lane_data_ins.character = temp[1:8];
                if(temp[1:8] == 8'hF8 || temp[1:8] == 8'h7E)
                begin 
                   ld_trans.idle2_bfm_aet_command_set[lane_num] = 1'b1;
                end 
                else
                begin 
                   ld_trans.idle2_bfm_aet_command_set[lane_num] = 1'b0;
                end 
             end //}
             else if(lane_data_ins.csfield_update == 1 && csflag && ld_config.aet_en && csf_cnt != 0 && (ld_env_config.srio_mode == SRIO_GEN21 || ld_env_config.srio_mode == SRIO_GEN22))
             begin //{
                csflag = 1'b1;
                csf_cnt = csf_cnt - 1;
                temp = csf_marker_array[csf_cnt];
                lane_data_ins.character = temp[1:8];
                if(csf_cnt == 0)
                begin //{
                  csflag = 1'b0;
                  csf_cnt = 31;
                end //}    
             end //}

         /* 
          if(lane_num == 0)
          begin //{
            if(ld_env_config.srio_mode == SRIO_GEN30)
              srio_if.char_to_send0 = {~lane_data_ins.brc3_type,lane_data_ins.brc3_type,lane_data_ins.brc3_cw};
            else  
              srio_if.char_to_send0 = {lane_data_ins.cntl,lane_data_ins.character};
          end //}
          else if(lane_num == 1)
          begin //{
            if(ld_env_config.srio_mode == SRIO_GEN30)
               srio_if.char_to_send1 = {~lane_data_ins.brc3_type,lane_data_ins.brc3_type,lane_data_ins.brc3_cw};
            else  
               srio_if.char_to_send1 = {lane_data_ins.cntl,lane_data_ins.character};
          end //}
          else if(lane_num == 2)
          begin //{
            if(ld_env_config.srio_mode == SRIO_GEN30)
               srio_if.char_to_send2 = {~lane_data_ins.brc3_type,lane_data_ins.brc3_type,lane_data_ins.brc3_cw};
            else  
               srio_if.char_to_send2 = {lane_data_ins.cntl,lane_data_ins.character};
          end //}
          else if(lane_num == 3)
          begin //{
            if(ld_env_config.srio_mode == SRIO_GEN30)
               srio_if.char_to_send3 = {~lane_data_ins.brc3_type,lane_data_ins.brc3_type,lane_data_ins.brc3_cw};
            else  
               srio_if.char_to_send3 = {lane_data_ins.cntl,lane_data_ins.character};
          end //}  
          */

//            if(ld_env_config.srio_mode == SRIO_GEN30 && ld_config.brc3_training_mode && (~ld_trans.lane_trained[lane_num] || (ld_trans.current_dme_train_state[lane_num] != TRAINED && ld_trans.frame_lock[lane_num])))
              if(ld_env_config.srio_mode == SRIO_GEN30 && ld_trans.dme_mode[lane_num])
                begin //{


               if(lane_data_ins.brc3_fm_update)      
               begin //{ 
                 drive_training(lane_data_ins,lane_num);
               end //}

               if(lane_data_ins.brc3_trn_update && ld_trans.dme_wait_timer_en[lane_num] && ~ld_trans.dme_wait_timer_done[lane_num])
               begin //{
                   dme_frame_cnt = dme_frame_cnt + 1;
                   if(dme_frame_cnt == ld_config.dme_wait_timer_frame_cnt)
                      ld_trans.dme_wait_timer_done[lane_num] = 1'b1;
                    
               end //}
               else if(~ld_trans.dme_wait_timer_en[lane_num] && ld_trans.dme_wait_timer_done[lane_num])
               begin //{
                   ld_trans.dme_wait_timer_done[lane_num] = 1'b0;
               end //}
                
                  
            end //}




            drive(lane_data_ins,lane_num);

           end //}
      end //}
    end //}
 end //}

endtask : pop_char

 task srio_pl_lane_driver::drive_training(input srio_pl_lane_data lane_data_ins,input int lane_num);

 bit [0:31] temp_fm;
 bit [0:31] int_reg;
 bit [0:15] coef_value;
 int temp_size;
 int residue_size;
 bit [0:66] temp67;

      temp_fm = 32'hFFFF_0000;
      for(int i =0;i<32;i++)
      begin //{
         gen3_trn_frame.push_back(temp_fm[i]);   
      end //}

      coef_value = idle3_dme_cmd_array[lane_num];
      dme(coef_value,0);
      coef_value = idle3_dme_stcs_array[lane_num];
      dme(coef_value,1);
      void'(trn_prbs_gen()); 

     if(temp_q.size != 0)
     begin //{
         temp_size = temp_q.size();
         for(int i=0;i<temp_size;i++)
         begin //{
             //gen3_trn_frame.push_front(temp_q.pop_front());
             gen3_trn_frame.push_front(temp_q.pop_back());
         end //} 
         temp_size = gen3_trn_frame.size();
         for(int i =0;i<temp_size/67;i++)
         begin //{
            for(int j=0;j<67;j++)
            begin //{
               temp67[66] = gen3_trn_frame.pop_front();
               if(j!= 66)
                 temp67 = temp67<<1;
            end //}   
             training_frame.push_back(temp67);
         end //}
     end //}
     else
     begin //{
         temp_size = gen3_trn_frame.size();
         for(int i =0;i<temp_size/67;i++)
         begin //{
            for(int j=0;j<67;j++)
            begin //{
               temp67[66] = gen3_trn_frame.pop_front();
               if(j!= 66)
                 temp67 = temp67<<1;
            end //}   
             training_frame.push_back(temp67);
         end //}
     end //}  

     residue_size = gen3_trn_frame.size();
    
     for(int i=0;i<residue_size;i++)
     begin //{
         temp_q.push_back(gen3_trn_frame.pop_front());
     end //}
     
 endtask : drive_training

//////////////////////////////////////////////////////////////////////////
/// Name: drive_lane \n
/// Description:Transmitting serial data on line 
//////////////////////////////////////////////////////////////////////////
 task srio_pl_lane_driver::drive_lane(input int lane_num);
 bit temp;
 forever
 begin //{
    @(negedge srio_if.tx_sclk[lane_num] or negedge srio_if.srio_rst_n)
    begin //{  
      if(~srio_if.srio_rst_n)
      begin //{
         srio_if.txp[lane_num]  = 0;
         srio_if.txn[lane_num]  = 0;
       end //}
      else
      begin //{   
           if(lane_q[lane_num].size() !=0 && lane_q[lane_num].size() > skew[lane_num] )
           begin //{
               temp          = lane_q[lane_num].pop_front();  
               srio_if.txp[lane_num]  = temp;
               srio_if.txn[lane_num]  = ~temp;
           end //}
      end //}
   end //}
 end //}
    
 endtask : drive_lane


//////////////////////////////////////////////////////////////////////////
/// Name: drive \n
/// Description:Task to scramble,encode and serialize data to be transmitted
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::drive(input srio_pl_lane_data lane_data_ins,int lane_num);

         bit [0:9] ten_bit_data;

         if(ld_trans.current_init_state == SILENT && cnt == 25)
         begin
               lane_data_ins.invalid_cg = 1'b0;
         end 
         else if(ld_trans.current_init_state == SILENT && cnt < 25)
         begin
               lane_data_ins.invalid_cg = 1'b1;
               cnt = cnt+1;
         end 
         else if(ld_trans.current_init_state != SILENT )
         begin
               cnt = 0;
         end 

//         if(ld_env_config.srio_mode == SRIO_GEN30 && ld_config.brc3_training_mode  && ~ld_trans.lane_sync[lane_num]  && (~ld_trans.lane_trained[lane_num] || (ld_trans.current_dme_train_state[lane_num] != TRAINED && ld_trans.frame_lock[lane_num])))
           if(ld_env_config.srio_mode == SRIO_GEN30 && ld_trans.dme_mode[lane_num])
            begin //{
              if(training_frame.size() != 0)
                sixty7_bit_data = training_frame.pop_front();
         end //}  
         else
         begin //{
              if(ld_env_config.srio_mode == SRIO_GEN30)
              begin //{
                scramble_gen3();
              end //}  
              // disable scrambler if tx_scr_en or idle_sel is 0
              else if(ld_config.tx_scr_en && ld_trans.bfm_idle_selected && ld_env_config.srio_mode != SRIO_GEN13)
              begin //{
                scramble();
              end //}

              if(ld_env_config.srio_mode == SRIO_GEN30)
              begin //{
                 sixty4_67b_encode();
              end //}
              else
              begin //{
                 eightb_10b_encode();
              end //}  

             // callback for cg generated
	     if (lane_num == 0)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane0(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 1)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane1(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 2)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane2(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 3)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane3(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 4)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane4(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 5)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane5(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 6)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane6(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 7)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane7(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 8)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane8(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 9)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane9(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 10)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane10(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 11)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane11(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 12)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane12(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 13)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane13(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 14)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane14(lane_data_ins, ld_env_config))
             end //}
	     else if (lane_num == 15)
             begin //{
                   `uvm_do_callbacks(srio_pl_lane_driver, srio_pl_callback, srio_pl_cg_generated_lane15(lane_data_ins, ld_env_config))
             end //}


              if(ld_env_config.srio_mode == SRIO_GEN30)
              begin //{
                 sixty7_bit_data = lane_data_ins.brc3_cg; 
              end //}
              else
              begin //{
                 ten_bit_data = lane_data_ins.cg; 
              end //}
         end //}  
               
         if(ld_env_config.srio_interface_mode == SRIO_SERIAL)
         begin //{ 
            if(ld_env_config.srio_mode == SRIO_GEN30)
            begin //{
               for(int i=0;i<67;i=i+1) 
               begin //{
                     @(posedge srio_if.tx_sclk[lane_num]);
                      lane_q[lane_num].push_back(sixty7_bit_data[i]); 
             end //}
            end //} 
            else
            begin //{ 
               for(int i=0;i<10;i=i+1) 
               begin //{
                     @(posedge srio_if.tx_sclk[lane_num]);
                      lane_q[lane_num].push_back(ten_bit_data[i]); 
             end //}
          end //}
       end //}
       else if(ld_env_config.srio_interface_mode == SRIO_PARALLEL)
       begin //{
               @(posedge srio_if.tx_pclk[lane_num]);
               begin //{
                 if(ld_env_config.srio_mode == SRIO_GEN30)
                   srio_if.gen3_tx_pdata[lane_num] = sixty7_bit_data;
                 else
                   srio_if.tx_pdata[lane_num] = ten_bit_data; 
               end //}    
       end //}
endtask : drive


//////////////////////////////////////////////////////////////////////////
/// Name: scramble_gen3 \n
/// Description:Task to scramble data in GEN30 
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::scramble_gen3();
bit [0:63] gen3_temp,gen3_temp1;
bit gen3_temp_q0;

    if(lane_data_ins.brc3_skip == 1'b1)
     return;
    if(lane_data_ins.brc3_cntl_cw_type == SKIP && ~lane_data_ins.brc3_type) // Skip character received. Don't shift the lfsr 
    begin //{
    /*  if(lane_num == 0)
      begin //{
        srio_if.scr3_out0 = lane_data_ins.brc3_cw; 
        srio_if.scr3_type0 = lane_data_ins.brc3_type;
        srio_if.scr3_cc0   = lane_data_ins.brc3_cc_type;
      end //} 
      else if(lane_num == 1)
      begin //{
        srio_if.scr3_out1 = lane_data_ins.brc3_cw; 
        srio_if.scr3_type1 = lane_data_ins.brc3_type;
        srio_if.scr3_cc1   = lane_data_ins.brc3_cc_type;
      end //} 
      else if(lane_num == 2)
      begin //{
        srio_if.scr3_out2 = lane_data_ins.brc3_cw; 
        srio_if.scr3_type2 = lane_data_ins.brc3_type;
        srio_if.scr3_cc2   = lane_data_ins.brc3_cc_type;
      end //} 
      else if(lane_num == 3)
      begin //{
        srio_if.scr3_out3 = lane_data_ins.brc3_cw; 
        srio_if.scr3_type3 = lane_data_ins.brc3_type;
        srio_if.scr3_cc3   = lane_data_ins.brc3_cc_type;
      end //} */
      return;
    end //}

   gen3_temp1 = 64'h0;
   gen3_temp = lane_data_ins.brc3_cw;

   if((lane_data_ins.brc3_cc_type != 2'b00 && ~lane_data_ins.brc3_type) || lane_data_ins.brc3_type)
   begin //{
        for(int i=0;i<64;i++)
        begin //{
           gen3_temp1[63] = lfsr_q[57] ^ gen3_temp[i];
           if(i != 63)
           gen3_temp1 = gen3_temp1<<1;
  
           gen3_temp_q0 = lfsr_q[57] ^ lfsr_q[38]; 
           lfsr_q = lfsr_q>>1;
           lfsr_q[0] = gen3_temp_q0;

        end //}
       lane_data_ins.brc3_cw = gen3_temp1;
   end //} 
   else
   begin //{
        lane_data_ins.brc3_cw = gen3_temp;
        for(int i=0;i<64;i++)
        begin //{
           gen3_temp_q0 = lfsr_q[57] ^ lfsr_q[38]; 
           lfsr_q= lfsr_q>>1;
           lfsr_q[0] = gen3_temp_q0;
        end //}
   end //}

    lane_data_ins.brc3_cw[30:31] = lane_data_ins.brc3_type ? lane_data_ins.brc3_cw[30:31] : lane_data_ins.brc3_cc_type;

   /*
   if(lane_num == 0)
   begin //{
     srio_if.scr3_out0 = lane_data_ins.brc3_cw; 
     srio_if.scr3_type0 = lane_data_ins.brc3_type;
     srio_if.scr3_cc0   = lane_data_ins.brc3_cc_type;
     srio_if.scr3_lfsr0   = lfsr_q;
   end //} 
   else if(lane_num == 1)
   begin //{
     srio_if.scr3_out1 = lane_data_ins.brc3_cw; 
     srio_if.scr3_type1 = lane_data_ins.brc3_type;
     srio_if.scr3_cc1   = lane_data_ins.brc3_cc_type;
     srio_if.scr3_lfsr1   = lfsr_q;
   end //} 
   else if(lane_num == 2)
   begin //{
     srio_if.scr3_out2 = lane_data_ins.brc3_cw; 
     srio_if.scr3_type2 = lane_data_ins.brc3_type;
     srio_if.scr3_cc2   = lane_data_ins.brc3_cc_type;
     srio_if.scr3_lfsr2   = lfsr_q;
   end //} 
   else if(lane_num == 3)
   begin //{
     srio_if.scr3_out3 = lane_data_ins.brc3_cw; 
     srio_if.scr3_type3 = lane_data_ins.brc3_type;
     srio_if.scr3_cc3   = lane_data_ins.brc3_cc_type;
     srio_if.scr3_lfsr3   = lfsr_q;
   end //}  
  */

endtask : scramble_gen3

//////////////////////////////////////////////////////////////////////////
/// Name: scramble \n
/// Description:Task to scramble data for GEN2 
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::scramble();

    if(lane_data_ins.character == 8'hFD && lane_data_ins.cntl) // Skip character received. Don't shift the lfsr 
    begin //{
       return;
    end //}

    lane_data_ins.character = (lane_data_ins.cntl || lane_data_ins.idle2_cs)? lane_data_ins.character : { scr_lfsr[16] ^ lane_data_ins.character[0],
                              scr_lfsr[15] ^ lane_data_ins.character[1],
                              scr_lfsr[14] ^ lane_data_ins.character[2],
                              scr_lfsr[13] ^ lane_data_ins.character[3],
                              scr_lfsr[12] ^ lane_data_ins.character[4],
                              scr_lfsr[11] ^ lane_data_ins.character[5],
                              scr_lfsr[10] ^ lane_data_ins.character[6],
                              scr_lfsr[9]  ^ lane_data_ins.character[7] };

    shift_scr_lfsr();

endtask : scramble


//////////////////////////////////////////////////////////////////////////
/// Name: shift_scr_lfsr \n
/// Description:LFSR Task to be used in scrambler
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::shift_scr_lfsr();

  bit [0:7] temp_lfsr_byte;
  int temp_lfsr_byte_var;

  temp_lfsr_byte_var = 0;

  for (int lfsr_loop_var = 9; lfsr_loop_var <= 16; lfsr_loop_var++)
  begin //{
    temp_lfsr_byte[temp_lfsr_byte_var] = scr_lfsr[lfsr_loop_var] ^ scr_lfsr[lfsr_loop_var-9];
    temp_lfsr_byte_var++;
  end //}

  scr_lfsr = scr_lfsr>>8;
  scr_lfsr[0:7] = temp_lfsr_byte;

endtask : shift_scr_lfsr


//////////////////////////////////////////////////////////////////////////
/// Name: init_lfsr \n
/// Description:Task to initialize LFSR to be used in GEN30 scrambler
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver:: init_lfsr();
   prbs_reg  = $random;
   transit   = 0;
   prev=0;
   scr_lfsr = ld_trans.scrambler_init_array[lane_num];
  // tx scrambler initialisation array
  scrambler_gen3_init_array[0]  = 58'h1ec_f564_79a8_b120;
  scrambler_gen3_init_array[1]  = 58'h1a1_af7d_7264_5f9e;
  scrambler_gen3_init_array[2]  = 58'h2ef_2b62_302b_d094;
  scrambler_gen3_init_array[3]  = 58'h14a_da90_3a26_68aa;
  scrambler_gen3_init_array[4]  = 58'h1fe_d572_55e7_da1d;
  scrambler_gen3_init_array[5]  = 58'h283_8ff2_c69c_3618;
  scrambler_gen3_init_array[6]  = 58'h3bc_111d_3429_3ece;
  scrambler_gen3_init_array[7]  = 58'h1c0_3994_44ae_4a2b;
  scrambler_gen3_init_array[8]  = 58'h09f_ebc2_faee_77fb;
  scrambler_gen3_init_array[9]  = 58'h239_7200_3b8e_9cff;
  scrambler_gen3_init_array[10] = 58'h00a_45db_c14e_f218;
  scrambler_gen3_init_array[11] = 58'h36d_3a42_6876_e9c4;
  scrambler_gen3_init_array[12] = 58'h2c1_a537_55d7_8dea;
  scrambler_gen3_init_array[13] = 58'h2b9_e833_dd9d_6b34;
  scrambler_gen3_init_array[14] = 58'h1cb_c090_ab7f_79b3;
  scrambler_gen3_init_array[15] = 58'h26f_aa25_7342_3ae5;
   lfsr_q = scrambler_gen3_init_array[lane_num];
   cur_dis  = NEG;
   cur_dis_gen3 = NEG;
   sixty7_bit_data = 0;

   if(ld_config.skew_en[lane_num])
   begin //{
      skew[lane_num] = $urandom_range(ld_config.skew_min[lane_num],ld_config.skew_max[lane_num]);
      `uvm_info("SRIO_PL_LANE_DRIVER",$sformatf("SKEW_VAL[%0d]:%0d",lane_num,skew[lane_num]),UVM_LOW)
   end //}
   else
      skew[lane_num] = 0;

endtask : init_lfsr


//////////////////////////////////////////////////////////////////////////
/// Name: sixty4_67b_encode \n
/// Description:Task to encode data for GEN30 
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::sixty4_67b_encode();

  bit [0:65] temp_66b_data;

  if (lane_data_ins.invalid_cg)
  begin //{
    lane_data_ins.brc3_cg = 67'h0;
    calc_curr_rd_gen3(lane_data_ins.brc3_cg);
    return;
  end //}
  temp_66b_data = {~lane_data_ins.brc3_type,lane_data_ins.brc3_type,lane_data_ins.brc3_cw};

  calc_cw_disp(temp_66b_data);
  if(((temp_66b_data[32:37]!=6'hB) && (temp_66b_data[32:37]!=6'hE) && temp_66b_data[0]) || temp_66b_data[1]) 
  if(lanecheck_1)
   calc_BIP(temp_66b_data);
 
  if(curr_cw_dis == cur_dis_gen3)
  begin //{
      lane_data_ins.brc3_cg = {1'b1,~lane_data_ins.brc3_type,lane_data_ins.brc3_type,~lane_data_ins.brc3_cw};
  end //}
  else
  begin //{
      lane_data_ins.brc3_cg = {1'b0,~lane_data_ins.brc3_type,lane_data_ins.brc3_type,lane_data_ins.brc3_cw};
  end //} 
  calc_curr_rd_gen3(lane_data_ins.brc3_cg);

   /*
   if(lane_num == 0)
   begin //{
     srio_if.enc3_data0= lane_data_ins.brc3_cg;
     srio_if.rd3_0= (lane_data_ins.curr_rd == POS)?1:0;
   end //} 
   else if(lane_num == 1)
   begin //{
     srio_if.enc3_data1= lane_data_ins.brc3_cg;
     srio_if.rd3_1= (lane_data_ins.curr_rd == POS)?1:0;
   end //} 
   else if(lane_num == 2)
   begin //{
     srio_if.enc3_data2= lane_data_ins.brc3_cg;
     srio_if.rd3_2= (lane_data_ins.curr_rd == POS)?1:0;
   end //} 
   else if(lane_num == 3)
   begin //{
     srio_if.enc3_data3= lane_data_ins.brc3_cg;
     srio_if.rd3_3= (lane_data_ins.curr_rd == POS)?1:0;
   end //}  */


endtask : sixty4_67b_encode 


//////////////////////////////////////////////////////////////////////////
/// Name: calc_curr_rd_gen3 \n
/// Description: Calculate running disparity for GEN30
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::calc_curr_rd_gen3(input bit [0:66] data);

  bit [0:66] temp_data;

  int ones_cnt;
  int zeros_cnt;
  

  running_disparity curr_disp_gen3;

 ones_cnt = 0;
 zeros_cnt = 0;

 temp_data = data;

 for (int find_ones_cnt=0; find_ones_cnt<=66; find_ones_cnt++)
 begin //{
   if (temp_data[find_ones_cnt] == 1)
     ones_cnt++;
   else
     zeros_cnt++;
 end //}

 if (ones_cnt > zeros_cnt)
    curr_disp_gen3 = POS;
 else if(ones_cnt < zeros_cnt)
    curr_disp_gen3 = NEG;
 else
    curr_disp_gen3 = cur_dis_gen3;
 
  cur_dis_gen3 = curr_disp_gen3;
  lane_data_ins.curr_rd = cur_dis_gen3;

endtask : calc_curr_rd_gen3 

//////////////////////////////////////////////////////////////////////////
/// Name: calc_cw_disp \n
/// Description: Calculate codeword disparity for GEN30
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::calc_cw_disp(input bit [0:65] data);

  bit [0:65] temp_data;

  int ones_cnt;
  int zeros_cnt;
  

  running_disparity curr_disp_gen3;

 ones_cnt = 0;
 zeros_cnt = 0;

 temp_data = data;

 for (int find_ones_cnt=0; find_ones_cnt<=65; find_ones_cnt++)
 begin //{
   if (temp_data[find_ones_cnt] == 1)
     ones_cnt++;
   else
     zeros_cnt++;
 end //}

 if (ones_cnt > zeros_cnt)
    curr_disp_gen3 = POS;
 else if(ones_cnt < zeros_cnt)
    curr_disp_gen3 = NEG;
 else
    curr_disp_gen3 = cur_dis_gen3;
 
  curr_cw_dis = curr_disp_gen3;

endtask : calc_cw_disp

//////////////////////////////////////////////////////////////////////////
/// Name: eightb_10b_encode \n
/// Description:Task to encode data in GEN13 and GEN2 
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::eightb_10b_encode();

  int temp_8b_data;

  temp_8b_data = lane_data_ins.character;

  if (lane_data_ins.invalid_cg)
  begin //{
    lane_data_ins.cg = choose_invalid_cg();
    calc_curr_rd(lane_data_ins.cg);
    return;
  end //}

  if (ld_trans.enc_data_pos_rd_array.exists(temp_8b_data) && ~lane_data_ins.cntl  && cur_dis == POS)
  begin //{

    lane_data_ins.cg = ld_trans.enc_data_pos_rd_array[temp_8b_data];
    lane_data_ins.invalid_cg = 0;
    calc_curr_rd(lane_data_ins.cg);
    return;
  end //}

  if (ld_trans.enc_data_neg_rd_array.exists(temp_8b_data) && cur_dis == NEG && ~lane_data_ins.cntl )
  begin //{

    lane_data_ins.cg = ld_trans.enc_data_neg_rd_array[temp_8b_data];
    lane_data_ins.invalid_cg = 0;
    calc_curr_rd(lane_data_ins.cg);
    return;
  end //}

  if (ld_trans.enc_cntl_pos_rd_array.exists(temp_8b_data) && cur_dis == POS && lane_data_ins.cntl  )
  begin //{

    lane_data_ins.cg = ld_trans.enc_cntl_pos_rd_array[temp_8b_data];
    lane_data_ins.invalid_cg = 0;
    calc_curr_rd(lane_data_ins.cg);
    return;
  end //}

  if (ld_trans.enc_cntl_neg_rd_array.exists(temp_8b_data) && cur_dis == NEG && lane_data_ins.cntl)
  begin //{

    lane_data_ins.cg = ld_trans.enc_cntl_neg_rd_array[temp_8b_data];
    lane_data_ins.invalid_cg = 0;
    calc_curr_rd(lane_data_ins.cg);
    return;
  end //}

  lane_data_ins.invalid_cg = 1;

endtask : eightb_10b_encode


//////////////////////////////////////////////////////////////////////////
/// Name: calc_curr_rd \n
/// Description:Task to calculate running disparity for GEN2
/// (Algorithm described in Part6, Section 4.5.3) 
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::calc_curr_rd(input int data);

  bit [0:9] temp_data;

  int ones_cnt;
  int zeros_cnt;
  

  running_disparity curr_disp;

 ones_cnt = 0;
 zeros_cnt = 0;

 temp_data = data;

 for (int find_ones_cnt=0; find_ones_cnt<=9; find_ones_cnt++)
 begin //{
   if (temp_data[find_ones_cnt] == 1)
     ones_cnt++;
   else
     zeros_cnt++;
 end //}

 if (ones_cnt > zeros_cnt)
    curr_disp = POS;
 else if(ones_cnt < zeros_cnt)
    curr_disp = NEG;
 else
    curr_disp = cur_dis;

  lane_data_ins.curr_rd = curr_disp;
  cur_dis =  curr_disp;

endtask : calc_curr_rd
//////////////////////////////////////////////////////////////////////////
/// Name: calc_BIP \n
/// Description: Calculate BIP for GEN30
//////////////////////////////////////////////////////////////////////////
task srio_pl_lane_driver::calc_BIP(input bit [0:65] data);
  bit [0:66] temp_data;
  temp_data={1'b0,data};
  if(temp_data[1] && temp_data[33:38]==6'hc)
   begin//{
    temp_data[3:25]=0;
    BIP_23=0;
   end//}
  BIP_23[0]=BIP_23[0] ^ temp_data[21] ^ temp_data[44];
  BIP_23[1]=BIP_23[1] ^ temp_data[0] ^ temp_data[22] ^ temp_data[45];
  BIP_23[2]=BIP_23[2] ^ temp_data[1] ^ temp_data[23] ^ temp_data[46];
  BIP_23[3]=BIP_23[3] ^ temp_data[2] ^ temp_data[24] ^ temp_data[47];
  BIP_23[4]=BIP_23[4] ^ temp_data[3] ^ temp_data[25] ^ temp_data[48];
  BIP_23[5]=BIP_23[5] ^ temp_data[4] ^ temp_data[26] ^ temp_data[49];
  BIP_23[6]=BIP_23[6] ^ temp_data[5] ^ temp_data[27] ^ temp_data[50];
  BIP_23[7]=BIP_23[7] ^ temp_data[6] ^ temp_data[28] ^ temp_data[51];
  BIP_23[8]=BIP_23[8] ^ temp_data[7] ^ temp_data[29] ^ temp_data[52];
  BIP_23[9]=BIP_23[9] ^ temp_data[8] ^ temp_data[30] ^ temp_data[53];
  BIP_23[10]=BIP_23[10] ^ temp_data[9] ^ temp_data[31] ^ temp_data[54];
  BIP_23[11]=BIP_23[11] ^ temp_data[10] ^ temp_data[32] ^ temp_data[55];
  BIP_23[12]=BIP_23[12] ^ temp_data[11] ^ temp_data[33] ^ temp_data[56];
  BIP_23[13]=BIP_23[13] ^ temp_data[12] ^ temp_data[34] ^ temp_data[57];
  BIP_23[14]=BIP_23[14] ^ temp_data[13] ^ temp_data[35] ^ temp_data[58];
  BIP_23[15]=BIP_23[15] ^ temp_data[14] ^ temp_data[36] ^ temp_data[59];
  BIP_23[16]=BIP_23[16] ^ temp_data[15] ^ temp_data[37] ^ temp_data[60];
  BIP_23[17]=BIP_23[17] ^ temp_data[16] ^ temp_data[38] ^ temp_data[61];
  BIP_23[18]=BIP_23[18] ^ temp_data[17] ^ temp_data[39] ^ temp_data[62];
  BIP_23[19]=BIP_23[19] ^ temp_data[18] ^ temp_data[40] ^ temp_data[63];
  BIP_23[20]=BIP_23[20] ^ temp_data[19] ^ temp_data[41] ^ temp_data[64];
  BIP_23[21]=BIP_23[21] ^ temp_data[20] ^ temp_data[42] ^ temp_data[65];
  BIP_23[22]=BIP_23[22] ^ temp_data[43] ^ temp_data[66];

endtask : calc_BIP
