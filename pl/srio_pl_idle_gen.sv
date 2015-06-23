////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_pl_idle_gen.sv
// Project :  srio vip
// Purpose :  Physical Layer Idle Generator and Striping
// Author  :  Mobiveil
//
// Physical Layer Idle Generator and Striping Component.
//
////////////////////////////////////////////////////////////////////////////////  
 typedef class srio_pl_config;
 typedef class srio_pl_common_component_trans;
 typedef class srio_pl_lane_driver;
 typedef class srio_pl_lane_data;
 typedef class srio_pl_pktcs_merger;
 typedef class srio_pl_pkt_handler;

 class srio_pl_idle_gen extends uvm_component;
 
  /// @cond
   `uvm_component_utils(srio_pl_idle_gen)

  `uvm_register_cb(srio_pl_idle_gen, srio_pl_callback)	///< Registering PL callback
  /// @endcond

  virtual srio_interface srio_if;                       ///< Virtual interface

  srio_env_config env_config;                           ///< ENV config instance

  srio_pl_config idle_config;                           ///< PL config instance

  srio_pl_common_component_trans idle_trans;            ///< PL common transaction instance

  // pl pkt merger instance
  srio_pl_pktcs_merger  pktcs_merge_ins;               ///< PL Packet/Conrtrol symbol Merger instance

  srio_pl_pkt_handler  pkt_handler_ins;                ///< PL packet handler instance

  srio_pl_data_trans igen_pkt,igen_pkt_g3,temp_pkt,temp_merge_ins,igen_pkt_g3_tmp; ///< scratchpad variables used for reading from the queue for transmitting on lane

  srio_trans status_cs,trans_push_ins;                 ///< Transaction item instance

  srio_pl_lane_data lane_data_ins[int];                ///< PL lane data instance

  srio_pl_lane_driver lane_driver_ins[int];           ///< PL lane driver instance

  uvm_event srio_tx_lane_event[int];                  ///< event to trigger transmission on lane

  // Methods
  extern function new(string name = "srio_pl_idle_gen", uvm_component parent = null);
  extern task run_phase(uvm_phase phase);
  extern task idle_gen();
  extern task psr_gen();
  extern task push_char();
  extern task gen_stomp_cs();
  extern task CS_Field_Marker();
  extern task idle_gen3();
  extern task idle_gen3_req();
  extern task tb_reset_ackid();
  extern function void choose_idle2_length();
  extern function void inc_lcl_cpy_ackid();

  int idle2_csfield_array[int];                     ///< CS Field Marker data array
  int idle2_csfield_neg_array[int];                 ///< CS Field Marker data array - Compliment
  int idle2_csf_marker_array[int];                  ///< Initial CS Field array
  bit [0:65] status_cs_array[int];

  bit [0:2] CS_field_act_port_wid;                 ///< CS Field Marker Active width 
  bit [0:66] temp_g3;                              ///< Temp Variable to store data to be transmitted on each lane in Gen3

  bit csf_update,stomp_tr,state_exit;             ///< Internal flags to control cs field  update, packet state exit etc
  bit idle3_com_seq_sent;                         ///< IDLE3 compensaction sequence sent
  bit dme_fm_update  ;                            ///< DME Frame to be updated
  bit dme_cof_update ;                            ///< DME Coefficient to be updated
  bit dme_stcs_update;
  bit dme_trn_update ; 
  int pkt_txt_cnt,idle3_cnt;                      ///< Count to be used during transmission
  int oes_size,oes_cnt;
  bit idle_compen_done;                           ///< IDLE3 compensation completed
  bit idle_compen_req;                            ///< IDLE3 compensation requested
  bit [0:6] psuedo_rand_gen;                      ///< Psedu random sequence to be used for A,M,R and K generation
  bit lane_trained;                       
  int num_lanes;
  bit idle_send_k;                                ///< Send K,R,M and A characters randomly
  bit idle_send_m;
  bit idle_send_a;
  bit idle_send_r;
  bit [0:8] idle_field_char[int];                ///< Characters to be transmitted on each lane in IDLE1/2
  bit [0:65] idle_field_char_g3[int];            ///< Characters to be transmitted on each lan ein GEN3
  //bit env_config.scramble_dis;                               ///< Indicates if each character should be scrambled or not
  bit tx_cs_sent;
  bit m_flag;                                    ///< Below variables are used to send four M or M followed by 4 D
  int d0_cnt;
  bit sendm_flag;
  int sendm_cnt;
  bit clear_flag;

  bit [0:8] temp_array[$];                      ///< Array to store generated stomp data
  bit [0:8] temp_array_cs[$];                      ///< Array to store generated stomp data
  bit [0:65] temp_array_g3[$];                      ///< Array to store generated stomp data
  logic [0:65] temp_pkt_g3[$];
  bit oes_flag;                                 ///< Indicates temp_array has data in oes state 

  bit [5:0] a_cnt;                             ///< Used for A character generation
  int compen_cnt;                              ///< Used for clock compensation generation 
  int status_cnt; 
  idle_states state,sen_state;                 ///< State variable declaration
  idle3_states idle3_state;

  bit descr_sync_req;                         ///<Descrambler sync to be transmitted
  bit descr_sync_req_g3;
  //bit [9:0] idle_cnt;                         ///< Count used for chracter transmission
  int  idle_cnt;                         ///< Count used for chracter transmission

  int pkt_to_pop;
  int pkt_size;                              ///< Below are variables which are packet and control symbol
  int pkt_size_g3;                           ///< size and the flags which indicate their availablity for transmission
  int cs_size;                               ///< and completion of transmission
  int cs_size_g3;
  int temp_size;
  bit pkt_req; 
  bit pkt_req_done;
  bit cs_req; 
  bit cs_req_done;
  bit pkt_req_g3; 
  bit pkt_req_done_g3;
  bit cs_req_g3; 
  bit cs_req_done_g3;
  logic [0:8] st_cs_q[$];
  bit gen_flag;
  bit bfm_idle_selected;                   ///< 0-IDLE1 1-IDLE2
  bit drive_012;                           ///< Data to be driven on lanes 0,1 and 2
  bit drive_02;                            ///< Data to be driven on lane 0 and 2
  bit drive_01;                            ///< Data to be driven on lane 0 and 1
  bit drive_0;                             ///< Data to be driven on lan 0
  bit drive_12;                            ///< Data to be driven on lane 1 and 2
  bit drive_1;                             ///< Data to be driven on lane 1
  bit drive_2;                             ///< Data to be driven on lane 2
  logic [0:8] tmp,tmp1,tmp2;               ///< Temprory storage for data to be transmitted on each lane

  // idle3 fields
  bit idle3_compen_done;                   ///< Below are the variables used for controlling
  bit idle3_com_req;                       ///< status ordered sequence, skip ordered sequence
  bit stcs_req,stcs_done;                  ///< Seed ordered sequence forIDLE3
  bit sdos_req,sdos_done;
  int sdos_cnt,stcs_cnt;
  int idle3_com_cnt;
  bit skip_marker_sent;  
  bit skip_flag;                          ///< Indicates skip CW 
  bit scos_update;                        ///< Indicates the various fields which need to 
  bit lc_update;                          ///< be updated in the IDLE3 sequence befire transmission
  bit dseed_update;                       ///< like descrambler seed, status /control word etc
  int asym_stcs_cntr;                     ///< Status/Control word to be transmitted during asymmetry change
  bit en_min_stcs;
  int cpy_bfm_no_lanes;                 ///< no of lanes in bfm logic
  bit once_flag=0;                      ///< Scratch variables to update ackid in control symbols
  bit[0:37] tmp_crc=0;                  ///< before transmission forIDLE1/2
  bit[0:23] cal_crc24=0;
  bit[0:12] cal_crc13=0;
  bit[0:4] cal_crc5=0;
  bit str_flag=0;
  bit TS_tx = 0 ;                      ///< Update CS size for timestamp control symbol transmission
  int idle2_seq_length;                ///< Randomly selected Idle2 sequence length 
  bit CS_tx =0;                        ///< Flags to control transmission of control symbols
  bit [3:0] CS_g13=3'b0;
  int lcl_cpy_ackid;                   ///< Local copy of ackid being transmitted- To be used in stomp CS
  bit idle2_sel=0;                     ///< Local copy of Idle selected
  bit new_cs=0;                        ///< Flag to be used in Packet tremination
  bit   [0:7]  stype1_temp;            ///< Local copy of stype1 in Gen3
  bit   [0:7]  stype1_temp1;            ///< Local copy of stype1 in Gen3
  bit packet_open;
  int index;
  int q_size;
  bit pkt_contains_cs;
virtual task srio_pl_trans_transmit(ref srio_pl_data_trans tx_gen,srio_trans trans_push_ins);
endtask

virtual task srio_pl_char_transmitted_lane0(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane1(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane2(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane3(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane4(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane5(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane6(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane7(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane8(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane9(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane10(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane11(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane12(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane13(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane14(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

virtual task srio_pl_char_transmitted_lane15(ref bit [0:65] idle_field_char,srio_env_config env_config);
endtask

endclass : srio_pl_idle_gen

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : New
/// Description : Constructor method for srio_pl_idle_gen class.
///////////////////////////////////////////////////////////////////////////////////////////////
function srio_pl_idle_gen::new(string name="srio_pl_idle_gen", uvm_component parent=null);
  super.new(name, parent);
endfunction : new



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : run_phase
/// Description : run_phase method of srio_pl_idle_gen class.
/// It triggers all the methods within the class which needs to be run forever.
///////////////////////////////////////////////////////////////////////////////////////////////
  task srio_pl_idle_gen::run_phase(uvm_phase phase);
    if(env_config.srio_mode == SRIO_GEN30)
    begin //{
      fork
       idle_gen3();      
       idle_gen3_req();
       push_char();
       tb_reset_ackid();
      join_none
    end //} 
    else
    begin //{
      fork
          tb_reset_ackid();
          psr_gen();
          idle_gen();      
          push_char();
          CS_Field_Marker();
      join_none
    end //}

  endtask : run_phase

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle_gen3_req
/// Description : This task performs the following function,
/// 1. Based on the configuration and/or the initialization decides the lanes on which data has 
/// to be stripped
/// 2. Fetches the Packet/Control Symbol for transmission and sets the flags which the transmission
/// state machine uses to transmit the packet/control symbol
/// 3. Controls the rate at which ordered sequences are transmitted
///////////////////////////////////////////////////////////////////////////////////////////////
  task srio_pl_idle_gen::idle_gen3_req();
    forever
    begin //{
       @(negedge idle_trans.int_clk or negedge srio_if.srio_rst_n) 
       begin //{
          if(~srio_if.srio_rst_n)
          begin //{
             packet_open=1'b0;
             idle3_com_req     = 1'b0;
             idle3_compen_done = 1'b0;
             stcs_req          = 1'b0;
             stcs_done         = 1'b0;
             sdos_req          = 1'b0; 
             sdos_done         = 1'b0; 
             idle3_com_cnt     = idle_config.clk_compensation_seq_rate-200;
             stcs_cnt          = idle_config.status_cntl_ord_seq_rate_min;
             sdos_cnt          = 48;
             idle_trans.bfm_no_lanes      = env_config.num_of_lanes;
             cpy_bfm_no_lanes             = env_config.num_of_lanes;
             drive_012                    = 0;  
             drive_12                     = 0;
             drive_1                      = 0;  
             drive_2                      = 0;  
             drive_0                      = 0;
             drive_02                     = 0;
             drive_01                     = 0;
             asym_stcs_cntr               = 0;
             en_min_stcs                  = 0;
             str_flag                     = 0;
             idle_trans.cpy_rx_ackid      = 0;

          end //}
          else 
          begin  //{     


            // no of lanes detection
            if(idle_trans.current_init_state == SILENT)
            begin //{
                  idle_trans.bfm_no_lanes = env_config.num_of_lanes;
                  pkt_req_done = 1'b0;
                  pkt_req  = 1'b0;
                  cs_req   = 1'b0;
                  cs_req_done = 1'b0; 
                  pkt_req_g3 = 1'b0;
                  pkt_req_done_g3 = 1'b0;
                  cs_req_g3 = 1'b0;
                  cs_req_done_g3 = 1'b0;
                  pktcs_merge_ins.pkt_avail_req_g3 = 1'b1;
                  pktcs_merge_ins.pkt_avail_req = 1'b1;
                  lane_trained = 1'b0;
            end //}
            if(idle_trans.current_init_state != SILENT)
            begin //{
            if(!idle_config.nx_mode_support && !idle_config.x2_mode_support && idle_config.force_1x_mode_en && idle_trans.force_1x_mode && idle_config.force_laner_en && idle_trans.force_laneR)
            begin //{
                  if(env_config.num_of_lanes > 3)
                  begin//{
                     if(env_config.srio_mode == SRIO_GEN13)
                     begin//{
                       drive_1    = 1'b0;
                       drive_2    = 1'b1;
                       drive_0    = 1'b0;
                       drive_012  = 1'b0;
                       drive_12   = 1'b0;
                       drive_02   = 1'b0;
                       drive_01   = 1'b0;
                       idle_trans.bfm_no_lanes = 3;
                     end //}  
                     else 
                     begin//{
                       drive_1    = 1'b0;
                       drive_2    = 1'b0;
                       drive_0    = 1'b0;
                       drive_012  = 1'b0;
                       drive_12   = 1'b1;
                       drive_02   = 1'b0;
                       drive_01   = 1'b0;
                       idle_trans.bfm_no_lanes = 3;
                     end //}  
                  end //}
                  else if(env_config.num_of_lanes == 2)
                  begin//{
                   idle_trans.bfm_no_lanes = 2; 
                   drive_1    = 1'b1;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_012  = 1'b0;
                   drive_12   = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
                  end //}
                  else
                  begin//{
                   idle_trans.bfm_no_lanes = 1;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_012  = 1'b0;
                   drive_12   = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
                  end //}
            end //}
            else if(!idle_config.nx_mode_support && !idle_config.x2_mode_support && idle_config.force_1x_mode_en && idle_trans.force_1x_mode && !(idle_config.force_laner_en && idle_trans.force_laneR))
            begin //{
                  if(env_config.num_of_lanes > 3)
                  begin//{
                     if(env_config.srio_mode == SRIO_GEN13)
                     begin//{
                       drive_1    = 1'b0;
                       drive_2    = 1'b0;
                       drive_0    = 1'b0;
                       drive_012  = 1'b0;
                       drive_02   = 1'b1;
                       drive_12   = 1'b0;
                       idle_trans.bfm_no_lanes = 3;
                     end //}  
                     else 
                     begin//{
                       drive_1    = 1'b0;
                       drive_2    = 1'b0;
                       drive_0    = 1'b0;
                       drive_012  = 1'b1;
                       drive_12   = 1'b0;
                       drive_02   = 1'b0;
                       drive_01   = 1'b0;
                       idle_trans.bfm_no_lanes = 3;
                     end //}  
                  end //}
                  else if(env_config.num_of_lanes == 2)
                  begin//{
                   idle_trans.bfm_no_lanes = 2; 
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_012  = 1'b0;
                   drive_12   = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b1;
                  end //}
                  else
                  begin//{
                   idle_trans.bfm_no_lanes = 1;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_012  = 1'b0;
                   drive_12   = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
                  end //}
            end //}
           else if(idle_config.nx_mode_support && !idle_config.x2_mode_support)
           begin //{
                  idle_trans.bfm_no_lanes = env_config.num_of_lanes;
                  drive_0    = 1'b0;
                  drive_12   = 1'b0;
                  drive_012  = 1'b0;
                  drive_1    = 1'b0;
                  drive_2    = 1'b0;
                  drive_02   = 1'b0;
                  drive_01   = 1'b0;
           end //}
            else if(!idle_config.nx_mode_support && idle_config.x2_mode_support && env_config.srio_mode != SRIO_GEN13)
            begin //{
                   idle_trans.bfm_no_lanes = 2;
                   drive_0    = 1'b0;
                   drive_12   = 1'b0;
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
            end //}
            else
            begin //{
                  idle_trans.bfm_no_lanes = env_config.num_of_lanes;
            end //}

            if(idle_trans.port_initialized && idle_trans.current_init_state == NX_MODE)
            begin //{
                   idle_trans.bfm_no_lanes = env_config.num_of_lanes; 
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
            end //} 
            else if(idle_trans.port_initialized && idle_trans.current_init_state == X2_MODE)
            begin //{
                   idle_trans.bfm_no_lanes = 2;
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
            end //}
            else if(idle_trans.port_initialized && (idle_trans.current_init_state == X1_M0 || idle_trans.current_init_state == X1_M1 || idle_trans.current_init_state == X1_M2))
            begin //{
                  if(env_config.num_of_lanes > 3)
                   idle_trans.bfm_no_lanes = 3;
                  else
                  begin //{
                    if(env_config.num_of_lanes == 2 && idle_trans.current_init_state == X1_M0)
                      idle_trans.bfm_no_lanes = 1;
                    else if(env_config.num_of_lanes == 2 && idle_trans.current_init_state == X1_M1)
                      idle_trans.bfm_no_lanes = 1;
                  end //} 

                   if(idle_trans.current_init_state == X1_M0 && idle_trans.bfm_no_lanes == 3)
                   begin //{
                     drive_012  = 1'b1;
                     drive_1    = 1'b0;
                     drive_2    = 1'b0;
                     drive_12   = 1'b0;
                     drive_0    = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                   end //}
                   else if(idle_trans.current_init_state == X1_M1)
                   begin //{
                     drive_1  = 1'b1;
                     drive_012    = 1'b0;
                     drive_2    = 1'b0;
                     drive_12   = 1'b0;
                     drive_0    = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                   end //}
                   else if(idle_trans.current_init_state == X1_M2)
                   begin //{
                     drive_2  = 1'b1;
                     drive_012    = 1'b0;
                     drive_1    = 1'b0;
                     drive_12   = 1'b0;
                     drive_0    = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                   end //}
               end //}
            else if(~idle_trans.port_initialized && idle_trans.current_init_state == X1_RECOVERY)
            begin //{
                  if(env_config.num_of_lanes > 3)
                  begin //{
                     idle_trans.bfm_no_lanes = 3;
                     drive_012  = 1'b1;
                     drive_1    = 1'b0;
                     drive_2    = 1'b0;
                     drive_12   = 1'b0;
                     drive_0    = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                  end //}
                  else
                  begin //{
                    if(env_config.num_of_lanes == 2 )
                    begin //{
                      idle_trans.bfm_no_lanes = 1;
                     drive_012  = 1'b0;
                     drive_1    = 1'b0;
                     drive_2    = 1'b0;
                     drive_0    = 1'b0;
                     drive_12   = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                    end //}
                    end //}
                  end //} 
            end //}

              // lane trained information
              if(idle_config.brc3_training_mode)
              begin //{
                  for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                  begin //{
                    if(idle_trans.frame_lock[i])
                    begin //{
                       if(idle_trans.current_dme_train_state[i] == TRAINED)
		       begin
                          lane_trained = 1'b1;
		       end
		       else
		       begin
                          lane_trained = 1'b0;
		          break;
		       end
                     end //}
                     else if(idle_trans.lane_sync[i])
                     begin //{
                          lane_trained = 1'b1;
		          break;
                     end //}
 
                  end //}
              end //}

            if(idle_trans.port_initialized && idle_trans.current_init_state == ASYM_MODE && idle_trans.transmit_enable_tw && (idle_trans.xmt_width=="16x" || idle_trans.xmt_width=="8x" || idle_trans.xmt_width=="4x"))
             begin //{
                   idle_trans.bfm_no_lanes = env_config.num_of_lanes; 
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
                   cpy_bfm_no_lanes  =  env_config.num_of_lanes;
             end //} 
            else if(idle_trans.port_initialized && idle_trans.current_init_state == ASYM_MODE && idle_trans.transmit_enable_tw && idle_trans.xmt_width=="2x")
             begin //{
		   /*if (idle_trans.common_trans_xmit_width_state == SEEK_NX_MODE_XMT)
                     idle_trans.bfm_no_lanes = env_config.num_of_lanes; 
		   else*/
                   idle_trans.bfm_no_lanes = 2; 
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
                   cpy_bfm_no_lanes  =  2;
             end //} 
            else if(idle_trans.port_initialized && idle_trans.current_init_state == ASYM_MODE && idle_trans.transmit_enable_tw && idle_trans.xmt_width=="1x")
             begin //{
		   /*if (idle_trans.common_trans_xmit_width_state == SEEK_NX_MODE_XMT)
                     idle_trans.bfm_no_lanes = env_config.num_of_lanes; 
		   else if (idle_trans.common_trans_xmit_width_state == SEEK_2X_MODE_XMT)
                     idle_trans.bfm_no_lanes = 2; 
		   else*/
                   idle_trans.bfm_no_lanes = 1; 
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
                   cpy_bfm_no_lanes  =  1; 
             end //} 
            else if(idle_trans.port_initialized && idle_trans.current_init_state == ASYM_MODE)
             begin //{
                   idle_trans.bfm_no_lanes = cpy_bfm_no_lanes; 
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
             end //}
             // idle3 compen req
                if(idle3_compen_done)
                   idle3_com_cnt = idle_config.clk_compensation_seq_rate-200; 
                else if(~idle3_com_req && ~str_flag)
                   idle3_com_cnt = idle3_com_cnt - 1;

                if(idle3_com_cnt == 0  && ~idle3_compen_done)
                begin
                 str_flag=1;
                 if(stcs_cnt>6 && sdos_cnt>6  && str_flag==1)
                  begin
                   idle3_com_req = 1'b1;
                   str_flag=0;
                  end
                end
                else if(idle3_com_req && ~idle3_compen_done)
                   idle3_com_req = 1'b1;
                else if(idle3_com_req && idle3_compen_done)
                begin //{
                   idle3_com_req = 1'b0;
                   idle3_compen_done = 1'b0;  
                   str_flag=0;
                end //}     

             // idle3 status/control req
                if (en_min_stcs && (idle_trans.common_trans_xmit_width_state!=X1_MODE_XMT || idle_trans.common_trans_xmit_width_state!=X2_MODE_XMT || idle_trans.common_trans_xmit_width_state!=NX_MODE_XMT) && asym_stcs_cntr==idle_trans.transmit_sc_sequences_cnt)
                 en_min_stcs=0; 
                else if( (idle_trans.common_trans_xmit_width_state==X1_MODE_XMT || idle_trans.common_trans_xmit_width_state==X2_MODE_XMT || idle_trans.common_trans_xmit_width_state==NX_MODE_XMT) && asym_stcs_cntr<idle_trans.transmit_sc_sequences_cnt)
                 en_min_stcs=1; 
                if(stcs_done)
                 begin//{
                  if(en_min_stcs)
                   begin//{
                    stcs_cnt=idle_config.status_cntl_ord_seq_rate_min; 
                    asym_stcs_cntr=asym_stcs_cntr+1;
                   end//}
                  else
                   stcs_cnt = $urandom_range(idle_config.status_cntl_ord_seq_rate_min,44); 
                 end//}
                else if(~stcs_req)
                   stcs_cnt = stcs_cnt - 1;

                if(stcs_cnt == 0  && ~stcs_done)
                   stcs_req = 1'b1;
                else if(stcs_req && ~stcs_done)
                   stcs_req = 1'b1;
                else if(stcs_req && stcs_done)
                begin //{
                   stcs_req = 1'b0;
                   stcs_done = 1'b0;  
                end //}     

               if(asym_stcs_cntr== idle_trans.transmit_sc_sequences_cnt && ~idle_trans.transmit_enable_tw)
		asym_stcs_cntr=0;
             // idle3 seed os req      
                if(sdos_done)
                   sdos_cnt = $urandom_range(18,32); 
                else if(~sdos_req)
                   sdos_cnt = sdos_cnt - 1;

                if(sdos_cnt == 0  && ~sdos_done)
                   sdos_req = 1'b1;
                else if(sdos_req && ~sdos_done)
                   sdos_req = 1'b1;
                else if(sdos_req && sdos_done)
                begin //{
                   sdos_req = 1'b0;
                   sdos_done = 1'b0;  
                end //}     

             // idle3 control symbol and pkt req      
               if(pktcs_merge_ins.pktcs_proc_q.size != 0 && idle_trans.link_initialized && ~pkt_req_done_g3 && ~pkt_req_g3 && ~cs_req_done_g3 && ~cs_req_g3 && idle_trans.transmit_enable)
               begin //{ 
                  for(int i=0;i< pktcs_merge_ins.pktcs_proc_q.size();i++)
                  begin //{
                      igen_pkt_g3 = new pktcs_merge_ins.pktcs_proc_q[i];
                      if(igen_pkt_g3.m_type == MERGED_CS)
                      begin //{
                        cs_size_g3 = igen_pkt_g3.brc3_merged_cs.size();
                        pktcs_merge_ins.pktcs_proc_q.delete(i);
                         if(~idle_config.multiple_ack_support)
                          begin//{                         
                           if (!once_flag)
                            begin//{
                             for(int k=0;k<igen_pkt_g3.brc3_merged_cs.size();k++)
                              begin//{
                               if(igen_pkt_g3.brc3_merged_cs[k][0:1]==2 && igen_pkt_g3.brc3_merged_cs[k][32:33]==1 && igen_pkt_g3.brc3_merged_cs[k][2:5]==4)
                                idle_trans.cpy_rx_ackid =igen_pkt_g3.brc3_merged_cs[k][6:17];
                              end//} 
                              once_flag=1;
                            end//}
                           else
                            begin//{
                             for(int k=0;k<igen_pkt_g3.brc3_merged_cs.size();k++)
                              begin//{
                               trans_push_ins=new();
                               if(igen_pkt_g3.brc3_merged_cs[k][0:1]==2 && igen_pkt_g3.brc3_merged_cs[k][32:33]==1 && (igen_pkt_g3.brc3_merged_cs[k][2:5]!=3 || igen_pkt_g3.brc3_merged_cs[k][2:5]!=4'hB))
                                begin//{
                                 igen_pkt_g3.brc3_merged_cs[k][6:17]=idle_trans.cpy_rx_ackid;
                                 tmp_crc={igen_pkt_g3.brc3_merged_cs[k][2:31],2'b00,igen_pkt_g3.brc3_merged_cs[k+1][2:7]};
                                 cal_crc24=      trans_push_ins.calccrc24(tmp_crc);
                                 igen_pkt_g3.brc3_merged_cs[k+1][8:31]=cal_crc24;
                                 if(igen_pkt_g3.brc3_merged_cs[k][2:5]==0)
                                  idle_trans.cpy_rx_ackid =igen_pkt_g3.brc3_merged_cs[k][6:17]+1;
                                end//}
                               else if(igen_pkt_g3.brc3_merged_cs[k][0:1]==2 && igen_pkt_g3.brc3_merged_cs[k][32:33]==3 && (igen_pkt_g3.brc3_merged_cs[k][34:37]!=3 || igen_pkt_g3.brc3_merged_cs[k][34:37]!=4'hB))
                                begin//{
                                 igen_pkt_g3.brc3_merged_cs[k][38:49]=idle_trans.cpy_rx_ackid;
                                 tmp_crc={igen_pkt_g3.brc3_merged_cs[k][34:65],igen_pkt_g3.brc3_merged_cs[k+1][2:7]};
                                 cal_crc24=      trans_push_ins.calccrc24(tmp_crc);
                                 igen_pkt_g3.brc3_merged_cs[k+1][8:31]=cal_crc24;
                                 if(igen_pkt_g3.brc3_merged_cs[k][34:37]==0)
                                  idle_trans.cpy_rx_ackid =igen_pkt_g3.brc3_merged_cs[k][38:49]+1;
                                end//}
                              end//} 
                            end//}
                          end//}

                        if(igen_pkt_g3.link_req_en == 1'b1 )
                        begin //{
                          cs_req_g3 = 1'b1;
                          descr_sync_req_g3 = 1'b1; 
                        end //} 
                        else if(igen_pkt_g3.link_resp_en == 1'b1)
                        begin //{
                          cs_req_g3 = 1'b1;
                          idle_trans.ies_state = 1'b0; 
                          descr_sync_req_g3 = 1'b0; 
                        end //} 
                        else if(igen_pkt_g3.rst_frm_rty_en == 1'b1)
                        begin //{
                          cs_req_g3 = 1'b1;
                          idle_trans.ors_state = 1'b0; 
                          descr_sync_req_g3 = 1'b0; 
                        end //} 
                        else
                        begin //{
                          cs_req_g3 = 1'b1;
                          pkt_req_g3 = 1'b0;
                        end //} 
                        `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_trans_transmit(igen_pkt_g3,trans_push_ins))
                        break;
                      end //}
                      else if(igen_pkt_g3.m_type == MERGED_PKT)
                      begin //{
                        pkt_size_g3 = igen_pkt_g3.brc3_merged_pkt.size();
                        if (idle_trans.bfm_no_lanes>4 && ((pkt_size_g3%idle_trans.bfm_no_lanes) > 0))
                         begin //{
                           pkt_size_g3 = (pkt_size_g3/idle_trans.bfm_no_lanes) ;
                         end //}
                         else
                         begin //{
                           if (idle_trans.bfm_no_lanes == 3)
                             pkt_size_g3 = pkt_size_g3-1 ;
                           else
                             pkt_size_g3 = (pkt_size_g3/idle_trans.bfm_no_lanes)-1 ;
                         end //}
                        pktcs_merge_ins.pktcs_proc_q.delete(i);
                        if(~idle_config.multiple_ack_support)
                         begin//{                         
                          for(int k=0;k<igen_pkt_g3.brc3_merged_pkt.size();k++)
                           begin//{
                               trans_push_ins=new();
                               if(igen_pkt_g3.brc3_merged_pkt[k][0:1]==2 && igen_pkt_g3.brc3_merged_pkt[k][32:33]==1 && (igen_pkt_g3.brc3_merged_pkt[k][2:5]!=3 || igen_pkt_g3.brc3_merged_pkt[k][2:5]!=4'hB))
                                begin//{
                                 igen_pkt_g3.brc3_merged_pkt[k][6:17]=idle_trans.cpy_rx_ackid;
                                 tmp_crc={igen_pkt_g3.brc3_merged_pkt[k][2:31],2'b00,igen_pkt_g3.brc3_merged_pkt[k+1][2:7]};
                                 cal_crc24=      trans_push_ins.calccrc24(tmp_crc);
                                 igen_pkt_g3.brc3_merged_pkt[k+1][8:31]=cal_crc24;
                                 if(igen_pkt_g3.brc3_merged_pkt[k][2:5]==0)
                                  idle_trans.cpy_rx_ackid =igen_pkt_g3.brc3_merged_pkt[k][6:17]+1;
                                end//}
                               else if(igen_pkt_g3.brc3_merged_pkt[k][0:1]==2 && igen_pkt_g3.brc3_merged_pkt[k][32:33]==3 && (igen_pkt_g3.brc3_merged_pkt[k][34:37]!=3 || igen_pkt_g3.brc3_merged_pkt[k][34:37]!=4'hB))
                                begin//{
                                 igen_pkt_g3.brc3_merged_pkt[k][38:49]=idle_trans.cpy_rx_ackid;
                                 tmp_crc={igen_pkt_g3.brc3_merged_pkt[k][34:65],igen_pkt_g3.brc3_merged_pkt[k+1][2:7]};
                                 cal_crc24=      trans_push_ins.calccrc24(tmp_crc);
                                 igen_pkt_g3.brc3_merged_pkt[k+1][8:31]=cal_crc24;
                                 if(igen_pkt_g3.brc3_merged_pkt[k][34:37]==0)
                                  idle_trans.cpy_rx_ackid =igen_pkt_g3.brc3_merged_pkt[k][38:49]+1;
                                end//}
                           end//}
                         end//}
                         if(idle_trans.ors_state || idle_trans.oes_state)
                           begin//{
                             q_size=igen_pkt_g3.brc3_merged_pkt.size();
                             for(int k=0;k<q_size;k++)
                              begin//{
                               if(igen_pkt_g3.brc3_merged_pkt.size()!=0)
                                begin//{
                                 if(igen_pkt_g3.brc3_merged_pkt[k][0:1]==2 && igen_pkt_g3.brc3_merged_pkt[k][32:33]==1 && (igen_pkt_g3.brc3_merged_pkt[k][2:5]==0 || igen_pkt_g3.brc3_merged_pkt[k][2:5]==1 || igen_pkt_g3.brc3_merged_pkt[k][2:5]==4'h2 || igen_pkt_g3.brc3_merged_pkt[k][2:5]==6))
                                  begin//{
                                   temp_pkt_g3.push_back({igen_pkt_g3.brc3_merged_pkt[k][0:29],2'b0,2'h1,32'h0});
                                   tmp_crc={temp_pkt_g3[(temp_pkt_g3.size()-1)][2:31],2'b00,6'h38};
                                   cal_crc24=      trans_push_ins.calccrc24(tmp_crc);
                                   temp_pkt_g3.push_back({2'h2,6'h38,cal_crc24,2'h2,32'h0});
                                  end//}
                                 else if(igen_pkt_g3.brc3_merged_pkt[k][0:1]==2 && igen_pkt_g3.brc3_merged_pkt[k][32:33]==3 && (igen_pkt_g3.brc3_merged_pkt[k][34:37]==0 || igen_pkt_g3.brc3_merged_pkt[k][34:37]==4'h1 || igen_pkt_g3.brc3_merged_pkt[k][2:5]==2 || igen_pkt_g3.brc3_merged_pkt[k][2:5]==6))
                                  begin//{
                                   temp_pkt_g3.push_back({igen_pkt_g3.brc3_merged_pkt[k][34:65],2'b0,2'h1,32'h0});
                                   tmp_crc={temp_pkt_g3[(temp_pkt_g3.size()-1)][2:31],2'b00,6'h38};
                                   cal_crc24=      trans_push_ins.calccrc24(tmp_crc);
                                   temp_pkt_g3.push_back({2'h2,6'h38,cal_crc24,2'h2,32'h0});
                                  end//}
                                end//}
                              end//}
                              igen_pkt_g3.brc3_merged_pkt.delete();
                              igen_pkt_g3.brc3_merged_cs=temp_pkt_g3;
                              temp_pkt_g3.delete();
                              pkt_size_g3=igen_pkt_g3.brc3_merged_pkt.size();   
                              cs_req_g3 = 1'b1;
                           end//}
                        if(pkt_size_g3>idle3_com_cnt)
                         idle3_com_req=1;
                        if(igen_pkt_g3.brc3_merged_pkt.size()!=0)
                         begin//{
                          pkt_req_g3 = 1'b1;
                          cs_req_g3 = 1'b0;
                         end//}
                        descr_sync_req_g3 = 1'b0; 
                        pktcs_merge_ins.pkt_avail_req_g3 = 1'b0;
                        `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_trans_transmit(igen_pkt_g3,trans_push_ins))
                        break;
                      end //}
                  end //}
               end //}
                else if(pktcs_merge_ins.pktcs_proc_q.size != 0 && ~idle_trans.link_initialized && idle_trans.port_initialized  && ~pkt_req_done_g3 && ~pkt_req_g3 && ~cs_req_done_g3 && ~cs_req_g3)
                begin //{ 
                   for(int i=0;i< pktcs_merge_ins.pktcs_proc_q.size();i++)
                   begin //{
                    //   igen_pkt = new(); 
                       igen_pkt_g3 = new pktcs_merge_ins.pktcs_proc_q[i];
                       if(igen_pkt_g3.m_type == MERGED_CS)
                       begin //{
                         cs_size_g3 = igen_pkt_g3.bs_merged_cs.size();
                         pktcs_merge_ins.pktcs_proc_q.delete(i);
                         if(igen_pkt_g3.link_req_en == 1'b1 )
                         begin //{
                           cs_req_g3 = 1'b1;
                           descr_sync_req_g3 = 1'b1; 
                         end //} 
                         else if(igen_pkt_g3.link_resp_en == 1'b1)
                         begin //{
                           cs_req_g3 = 1'b1;
                           idle_trans.ies_state = 1'b0; 
                           descr_sync_req_g3 = 1'b0; 
                         end //} 
                         else if(igen_pkt_g3.rst_frm_rty_en == 1'b1)
                         begin //{
                           cs_req_g3 = 1'b1;
                           idle_trans.ors_state = 1'b0; 
                           descr_sync_req_g3 = 1'b0; 
                         end //} 
                         else
                         begin //{
                           cs_req_g3 = 1'b1;
                           pkt_req_g3 = 1'b0;
                         end //} 
                        `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_trans_transmit(igen_pkt_g3,trans_push_ins))
                         break;
                       end //}
                   end //}
                end //}
               else if(pkt_req_g3 && pkt_req_done_g3 && idle_trans.link_initialized)
               begin //{ 
                  pkt_req_g3 = 1'b0;
                  pkt_req_done_g3 = 1'b0;
//                  cs_req_g3 = 1'b0;
//                  cs_req_done_g3 = 1'b0;
                  pktcs_merge_ins.pkt_avail_req_g3 = 1'b1;
               end //}  
                else if(cs_req_g3 && cs_req_done_g3 && ~idle_trans.link_initialized && idle_trans.port_initialized)
                begin //{ 
                   cs_req_g3 = 1'b0;
                   cs_req_done_g3 = 1'b0;
                   pkt_req_g3 = 1'b0;
                   pkt_req_done_g3 = 1'b0;
                end //}  
               else if(cs_req_g3 && cs_req_done_g3 && idle_trans.link_initialized)
               begin //{ 
                  cs_req_g3 = 1'b0;
                  cs_req_done_g3 = 1'b0;
                  pkt_req_g3 = 1'b0;
                  pkt_req_done_g3 = 1'b0;
               end //}  

             end //}
          end //}
       end //}
  endtask : idle_gen3_req

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle_gen3
/// Description : Task which forms the final queue for transmission on a per lane basis for IDLE3.
/// This queue will include IDLE3 sequence and stripped packet and control symbol
///////////////////////////////////////////////////////////////////////////////////////////////
  task srio_pl_idle_gen::idle_gen3();
    forever
    begin //{
       @(posedge idle_trans.int_clk or negedge srio_if.srio_rst_n) 
       begin //{
          if(~srio_if.srio_rst_n)
          begin //{
           idle_trans.xmting_idle=1'b0;
           stype1_temp1=0;
           if(idle_config.brc3_training_mode)
           begin //{
             idle3_state        = IDLE3_DME_FM;
             skip_flag          = 1'b0;
             scos_update        = 1'b0; 
             dseed_update       = 1'b0; 
    	     skip_marker_sent   = 1'b0;
             lc_update          = 1'b0; 
             idle3_com_seq_sent = 1'b0;
             dme_fm_update      = 1'b0;
             dme_cof_update     = 1'b0;
             dme_stcs_update    = 1'b0;
             dme_trn_update     = 1'b0; 
             idle3_cnt          = 0;
           end //}
           else 
           begin //{
             idle3_state        = IDLE3_PSR;
             skip_flag          = 1'b0;
             scos_update        = 1'b0; 
             dseed_update       = 1'b0; 
    	     skip_marker_sent   = 1'b0;
             lc_update          = 1'b0; 
             idle3_com_seq_sent = 1'b0;
             dme_fm_update      = 1'b0;
             dme_cof_update     = 1'b0;
             dme_stcs_update    = 1'b0;
             dme_trn_update     = 1'b0; 
             idle3_cnt          = 0;
           end //}
          end //}
          else 
          begin  //{     
             case(idle3_state)
                // DME FM 
                IDLE3_DME_FM : begin //{
                               if(drive_012)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b1;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_02)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b1;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_12)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b1;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_1)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b1;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_2)
                               begin //{
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b1;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else
                               begin //{
                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                     begin //{
                                         idle_field_char_g3[i] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                         dme_fm_update      = 1'b1;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b0;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                     end //}
                               end //} 
                               idle3_state = IDLE3_DME_COF_UP;
                             end //} 

               IDLE3_DME_COF_UP : begin //{
                               if(drive_012)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b1;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_02)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b1;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_12)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b1;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_1)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b1;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_2)
                               begin //{
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b1;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else
                               begin //{
                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                     begin //{
                                         idle_field_char_g3[i] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b1;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b0;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                     end //}
                               end //} 
                                  idle3_state = IDLE3_DME_STCS;
                                  end //} 

               IDLE3_DME_STCS : begin //{
                               if(drive_012)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b1;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_02)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b1;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_12)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b1;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_1)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b1;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_2)
                               begin //{
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b1;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else
                               begin //{
                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                     begin //{
                                         idle_field_char_g3[i] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b1;
                                         dme_trn_update     = 1'b0; 
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b0;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                     end //}
                               end //} 
                                  idle3_state = IDLE3_DME_TRN_PAT;
                                  idle3_cnt   = 61;
                              end //} 

               IDLE3_DME_TRN_PAT : begin //{
                               if(drive_012)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_02)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_12)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_1)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else if(drive_2)
                               begin //{
                                     idle_field_char_g3[2] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                               end //}  
                               else
                               begin //{
                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                     begin //{
                                         idle_field_char_g3[i] = {1'b0,1'b0,32'hFFFF_0000,32'h0000_0000};
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b0;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                     end //}
                               end //} 
                                  idle3_cnt = idle3_cnt - 1;
                                  if(idle3_cnt == 0)
                                  begin //{
                                     dme_trn_update     = 1'b1; 
                                     if(idle_config.brc3_training_mode && lane_trained)
                                     begin //{ 
                                        idle3_state = IDLE3_PSR;
                                     end //}
                                     else
                                     begin //{ 
                                        idle3_state = IDLE3_DME_FM;
                                     end //}
                                  end //} 
                                  else
                                    idle3_state = IDLE3_DME_TRN_PAT;
                              end //} 
                // PSR Sequence 
                IDLE3_PSR :  begin //{
                               if(drive_012)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                     idle_field_char_g3[1] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_02)
                               begin //{
                                     idle_field_char_g3[0] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                     idle_field_char_g3[2] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_12)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_1)
                               begin //{
                                     idle_field_char_g3[1] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_2)
                               begin //{
                                     idle_field_char_g3[2] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else
                               begin //{
                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                     begin //{
                                         idle_field_char_g3[i] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b0;
                                         dseed_update       = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                         lc_update          = 1'b0; 
                                     end //}
                               end //}  
                               if(stcs_req)
                               begin //{
                                   idle3_state = IDLE3_SCOS1;
                               end //}
                               else if(descr_sync_req_g3)
                               begin //{
                                   idle3_state = IDLE3_SOOS1;
                               end //}
                               else if(idle3_com_req)
                                begin//{
                                   idle3_state = IDLE3_COMPEN_SM;
                                end//}
                               else if(cs_req_g3)
                               begin //{
                                   idle3_state = IDLE3_CS_STATE;
                               end //}
                               else if(pkt_req_g3)
                               begin //{
                                   idle3_state = IDLE3_PKT_STATE;				   
                               end //}
                               else if(sdos_req)
                               begin //{
                                   idle3_state = IDLE3_SOOS1;
                               end //}
                               else 
                               begin //{
                                   idle3_state = IDLE3_PSR;
                               end //}

                               if(idle_trans.current_init_state == SILENT)
                                   idle3_state = IDLE3_PSR;
                               if(idle_trans.transmit_enable)
                                idle_trans.xmting_idle=0;

                               else
                                idle_trans.xmting_idle=1;
                               idle3_com_seq_sent = 1'b0;
                             end //}
               // Status/Command one OS
               IDLE3_SCOS1 :  begin //{ 
                               if(drive_012)
                               begin //{
                                     idle_field_char_g3[0] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     idle_field_char_g3[1] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     idle_field_char_g3[2] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_02)
                               begin //{
                                     idle_field_char_g3[0] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     idle_field_char_g3[2] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_12)
                               begin //{
                                     idle_field_char_g3[1] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_1)
                               begin //{
                                     idle_field_char_g3[1] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_2)
                               begin //{
                                     idle_field_char_g3[2] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else
                               begin //{
                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                     begin //{
                                         idle_field_char_g3[i] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                         scos_update        = 1'b1; 
                                         skip_flag          = 1'b0;
                                         dseed_update        = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                     end //}
                               end //}  
                               if(~idle_trans.transmit_enable)
                                idle_trans.xmting_idle=1'b1;
                               else
                                idle_trans.xmting_idle=1'b0;
                               idle3_state = IDLE3_SCOS2;
                               idle3_com_seq_sent = 1'b0;
                             end //}
               // Status/Command two OS
               IDLE3_SCOS2 :  begin //{ 
                               if(drive_012)
                               begin //{
                                     idle_field_char_g3[0] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     idle_field_char_g3[1] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     idle_field_char_g3[2] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_02)
                               begin //{
                                     idle_field_char_g3[0] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     idle_field_char_g3[2] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_12)
                               begin //{
                                     idle_field_char_g3[1] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_1)
                               begin //{
                                     idle_field_char_g3[1] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_2)
                               begin //{
                                     idle_field_char_g3[2] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                     scos_update        = 1'b1; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else
                               begin //{
                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                     begin //{
                                         idle_field_char_g3[i] = {1'b1,1'b0,30'h0,6'b001111,28'h0};
                                         scos_update        = 1'b1; 
                                         skip_flag          = 1'b0;
                                         dseed_update        = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b1;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                     end //}
                               end //}  
                               if(~idle_trans.transmit_enable)
                                idle_trans.xmting_idle=1'b1;
                               else
                                idle_trans.xmting_idle=1'b0;
                               if(idle3_com_req)
                               begin //{
                                   idle3_state = IDLE3_COMPEN_SM;
                               end //}
                               else if(sdos_req)
                               begin //{
                                   idle3_state = IDLE3_SOOS1;
                               end //}
                               else 
                               begin //{
                                   idle3_state = IDLE3_PSR;
                               end //}
                               stcs_done    = 1'b1;
                               idle3_com_seq_sent = 1'b0;
                             end //}
                // Seed Ordered one OS 
               IDLE3_SOOS1 :  begin //{ 
                               if(drive_012)
                               begin //{
                                     idle_field_char_g3[0] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     idle_field_char_g3[1] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     idle_field_char_g3[2] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_02)
                               begin //{
                                     idle_field_char_g3[0] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     idle_field_char_g3[2] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_12)
                               begin //{
                                     idle_field_char_g3[1] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_1)
                               begin //{
                                     idle_field_char_g3[1] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_2)
                               begin //{
                                     idle_field_char_g3[2] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else
                               begin //{
                                  for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                  begin //{
                                      idle_field_char_g3[i] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                      scos_update        = 1'b0; 
                                      skip_flag          = 1'b0;
                                      dseed_update       = 1'b1; 
                                      lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                  end //}
                               end //}  
                               if(~idle_trans.transmit_enable)
                                idle_trans.xmting_idle=1'b1;
                               else
                                idle_trans.xmting_idle=1'b0;
                               if(idle3_com_req) 
                                   idle3_com_seq_sent = 1'b1;
                               else
                                   idle3_com_seq_sent = 1'b0;
                               idle3_state = IDLE3_SOOS2;
                             end //}

                // Seed Ordered two OS 
               IDLE3_SOOS2 :  begin //{ 
                               if(drive_012)
                               begin //{
                                     idle_field_char_g3[0] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     idle_field_char_g3[1] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     idle_field_char_g3[2] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_02)
                               begin //{
                                     idle_field_char_g3[0] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     idle_field_char_g3[2] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_12)
                               begin //{
                                     idle_field_char_g3[1] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_1)
                               begin //{
                                     idle_field_char_g3[1] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else if(drive_2)
                               begin //{
                                     idle_field_char_g3[2] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b1; 
                                     lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                               end //}  
                               else
                               begin //{
                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                     begin //{
                                         idle_field_char_g3[i] = {1'b1,1'b0,64'h0000_0000_0000_0000};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b0;
                                         dseed_update       = 1'b1; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                     end //}
                               end //}  

                               if(idle3_com_req && idle3_com_seq_sent)
                               begin //{
                                  idle3_compen_done = 1'b1;
                                  idle3_com_seq_sent = 1'b0;
                               end //} 
                               else 
                                if(sdos_req)
                                  sdos_done    = 1'b1;

                               if(~idle_trans.transmit_enable)
                                 idle_trans.xmting_idle=1'b1;
                                else
                                 idle_trans.xmting_idle=1'b0;
                               if(descr_sync_req_g3 && cs_req_g3)
                               begin //{
                                   idle3_state = IDLE3_CS_STATE;
                                   skip_marker_sent = 1'b0;
                                   descr_sync_req_g3=0;
                               end //}
                               else if(idle3_com_req && ~skip_marker_sent)
                               begin //{
                                   idle3_state = IDLE3_COMPEN_SM;
                                   skip_marker_sent = 1'b0;
                               end //}
                               else if(stcs_req)
                               begin //{
                                   idle3_state = IDLE3_SCOS1;
                                   skip_marker_sent = 1'b0;
                               end //}
                               else 
                               if(cs_req_g3)
                               begin //{
                                   idle3_state = IDLE3_CS_STATE;
                                   skip_marker_sent = 1'b0;
                               end //}
                               else 
                               begin //{
                                   idle3_state = IDLE3_PSR;
                                   skip_marker_sent = 1'b0;
                               end //}
                             end //}
               // Compensation Skip Marker OS 
               IDLE3_COMPEN_SM :  begin //{ 
                                  if(drive_012)
                                  begin //{
                                        idle_field_char_g3[0] = {1'b1,1'b0,30'h394D_E8D1,6'b001011,28'h85E_2FA0};
                                        idle_field_char_g3[1] = {1'b1,1'b0,30'h394D_E8D1,6'b001011,28'h85E_2FA0};
                                        idle_field_char_g3[2] = {1'b1,1'b0,30'h394D_E8D1,6'b001011,28'h85E_2FA0};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b0; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else if(drive_02)
                                  begin //{
                                        idle_field_char_g3[0] = {1'b1,1'b0,30'h394D_E8D1,6'b001011,28'h85E_2FA0};
                                        idle_field_char_g3[2] = {1'b1,1'b0,30'h394D_E8D1,6'b001011,28'h85E_2FA0};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b0; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else if(drive_12)
                                  begin //{
                                        idle_field_char_g3[1] = {1'b1,1'b0,30'h394D_E8D1,6'b001011,28'h85E_2FA0};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b0; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else if(drive_1)
                                  begin //{
                                        idle_field_char_g3[1] = {1'b1,1'b0,30'h394D_E8D1,6'b001011,28'h85E_2FA0};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b0; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else if(drive_2)
                                  begin //{
                                        idle_field_char_g3[2] = {1'b1,1'b0,30'h394D_E8D1,6'b001011,28'h85E_2FA0};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b0; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else
                                  begin //{
                                       for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                       begin //{
                                           idle_field_char_g3[i] = {1'b1,1'b0,30'h394D_E8D1,6'b001011,28'h85E_2FA0};
                                           scos_update        = 1'b0; 
                                           skip_flag          = 1'b0;
                                           dseed_update       = 1'b0; 
                                           lc_update          = 1'b0; 
                                           dme_fm_update      = 1'b0;
                                           dme_cof_update     = 1'b0;
                                           dme_stcs_update    = 1'b0;
                                           dme_trn_update     = 1'b0; 
                                       end //}
                                  end //}  
                                  if(~idle_trans.transmit_enable)
                                   idle_trans.xmting_idle=1'b1;
                                  else
                                   idle_trans.xmting_idle=1'b0;
                                  skip_marker_sent = 1'b1;
                                  idle3_com_seq_sent = 1'b1;
                                  idle3_state = IDLE3_COMPEN_SC1;
                                  end //}
               // Compensation Skip Control one OS 
               IDLE3_COMPEN_SC1 :  begin //{ 
                                   if(drive_012)
                                   begin //{
                                         idle_field_char_g3[0] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         idle_field_char_g3[1] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         idle_field_char_g3[2] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_02)
                                   begin //{
                                         idle_field_char_g3[0] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         idle_field_char_g3[2] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_12)
                                   begin //{
                                         idle_field_char_g3[1] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_1)
                                   begin //{
                                         idle_field_char_g3[1] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_2)
                                   begin //{
                                         idle_field_char_g3[2] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else
                                   begin //{
                                        for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                        begin //{
                                            idle_field_char_g3[i] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b1;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                        end //}
                                   end //}  
                                  if(~idle_trans.transmit_enable)
                                   idle_trans.xmting_idle=1'b1;
                                  else
                                   idle_trans.xmting_idle=1'b0;
                                  idle3_com_seq_sent = 1'b1;
                                  idle3_state = IDLE3_COMPEN_SC2;
                                  end //}
               // Compensation Skip Control one OS 
               IDLE3_COMPEN_SC2 :  begin //{ 
                                   if(drive_012)
                                   begin //{
                                         idle_field_char_g3[0] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         idle_field_char_g3[1] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         idle_field_char_g3[2] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_02)
                                   begin //{
                                         idle_field_char_g3[0] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         idle_field_char_g3[2] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_12)
                                   begin //{
                                         idle_field_char_g3[1] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_1)
                                   begin //{
                                         idle_field_char_g3[1] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_2)
                                   begin //{
                                         idle_field_char_g3[2] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else
                                   begin //{
                                        for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                        begin //{
                                            idle_field_char_g3[i] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b1;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                        end //}
                                   end //}  
                                  if(~idle_trans.transmit_enable)
                                   idle_trans.xmting_idle=1'b1;
                                  else
                                   idle_trans.xmting_idle=1'b0;
                                  idle3_com_seq_sent = 1'b1;
                                  idle3_state = IDLE3_COMPEN_SC3;
                                  end //}

               // Compensation Skip Control one OS 
               IDLE3_COMPEN_SC3 :  begin //{ 
                                   if(drive_012)
                                   begin //{
                                         idle_field_char_g3[0] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         idle_field_char_g3[1] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         idle_field_char_g3[2] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_02)
                                   begin //{
                                         idle_field_char_g3[0] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         idle_field_char_g3[2] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_12)
                                   begin //{
                                         idle_field_char_g3[1] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_1)
                                   begin //{
                                         idle_field_char_g3[1] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else if(drive_2)
                                   begin //{
                                         idle_field_char_g3[2] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                         scos_update        = 1'b0; 
                                         skip_flag          = 1'b1;
                                         dseed_update       = 1'b0; 
                                         lc_update          = 1'b0; 
                                         dme_fm_update      = 1'b0;
                                         dme_cof_update     = 1'b0;
                                         dme_stcs_update    = 1'b0;
                                         dme_trn_update     = 1'b0; 
                                   end //}  
                                   else
                                   begin //{
                                        for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                        begin //{
                                            idle_field_char_g3[i] = {1'b1,1'b0,30'h2E17_8BE8,6'b001110,28'h537_A344};
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b1;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                        end //}
                                   end //}  
                                  if(~idle_trans.transmit_enable)
                                   idle_trans.xmting_idle=1'b1;
                                  else
                                   idle_trans.xmting_idle=1'b0;
                                  idle3_com_seq_sent = 1'b1;
                                  idle3_state = IDLE3_COMPEN_LC;
                                  end //}
               // Compensation Lane Check OS 
               IDLE3_COMPEN_LC :  begin //{ 
                                  if(drive_012)
                                  begin //{
                                        idle_field_char_g3[0] = {1'b1,1'b0,30'h000_0000,6'b001100,28'h000_0000};
                                        idle_field_char_g3[1] = {1'b1,1'b0,30'h000_0000,6'b001100,28'h000_0000};
                                        idle_field_char_g3[2] = {1'b1,1'b0,30'h000_0000,6'b001100,28'h000_0000};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b1; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else if(drive_02)
                                  begin //{
                                        idle_field_char_g3[0] = {1'b1,1'b0,30'h000_0000,6'b001100,28'h000_0000};
                                        idle_field_char_g3[2] = {1'b1,1'b0,30'h000_0000,6'b001100,28'h000_0000};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b1; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else if(drive_12)
                                  begin //{
                                        idle_field_char_g3[1] = {1'b1,1'b0,30'h000_0000,6'b001100,28'h000_0000};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b1; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else if(drive_1)
                                  begin //{
                                        idle_field_char_g3[1] = {1'b1,1'b0,30'h000_0000,6'b001100,28'h000_0000};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b1; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else if(drive_2)
                                  begin //{
                                        idle_field_char_g3[2] = {1'b1,1'b0,30'h000_0000,6'b001100,28'h000_0000};
                                        scos_update        = 1'b0; 
                                        skip_flag          = 1'b0;
                                        dseed_update       = 1'b0; 
                                        lc_update          = 1'b1; 
                                        dme_fm_update      = 1'b0;
                                        dme_cof_update     = 1'b0;
                                        dme_stcs_update    = 1'b0;
                                        dme_trn_update     = 1'b0; 
                                  end //}  
                                  else
                                  begin //{
                                       for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                       begin //{
                                           idle_field_char_g3[i] = {1'b1,1'b0,30'h000_0000,6'b001100,28'h000_0000};
                                           scos_update        = 1'b0; 
                                           skip_flag          = 1'b0;
                                           dseed_update       = 1'b0; 
                                           lc_update          = 1'b1; 
                                           dme_fm_update      = 1'b0;
                                           dme_cof_update     = 1'b0;
                                           dme_stcs_update    = 1'b0;
                                           dme_trn_update     = 1'b0; 
                                       end //}
                                  end //}  
                                  if(~idle_trans.transmit_enable)
                                   idle_trans.xmting_idle=1'b1;
                                  else
                                   idle_trans.xmting_idle=1'b0;
                                  idle3_com_seq_sent = 1'b1;
                                  idle3_state = IDLE3_SOOS1;
                                  end //} 
               // Packet State
               IDLE3_PKT_STATE :  begin //{ 
                                    if(drive_012)
                                    begin //{
                                          if(temp_array_g3.size() != 0)
                                          begin //{
                                            temp_g3             = temp_array_g3.pop_front();
                                            idle_field_char_g3[0] = temp_g3;
                                            idle_field_char_g3[1] = temp_g3;
                                            idle_field_char_g3[2] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            igen_pkt_g3.brc3_merged_pkt.delete();
                                          end //}
                                          else if(igen_pkt_g3.brc3_merged_pkt.size() != 0)
                                          begin //{
                                            temp_g3             = igen_pkt_g3.brc3_merged_pkt.pop_front();
                                            idle_field_char_g3[0] = temp_g3;
                                            idle_field_char_g3[1] = temp_g3;
                                            idle_field_char_g3[2] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                              lcl_cpy_ackid=temp_g3[6:17];
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01 && temp_g3[2:5]==0)
                                              void'(inc_lcl_cpy_ackid());
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b01)
                                                CS_tx=1;
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b10)
                                                CS_tx=0;
                                            if((temp_g3[0:1]==2'b10 && (temp_g3[30:31]==2'b10 || temp_g3[30:31]==2'b11)) && (temp_g3[32:33]==2'b01 || temp_g3[32:33]==2'b11))
                                              packet_open=1;
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                             stype1_temp1[0:1]=temp_g3[30:31];
                                            if(temp_g3[0:1]==2'b10 && (temp_g3[32:33]==2'b11 || temp_g3[32:33]==2'b10))
                                             stype1_temp1[2:7]=temp_g3[2:7];
                                             if(packet_open && (stype1_temp1==8'h10 || stype1_temp1==8'h11))
                                              begin//{
                                               packet_open=0;
                                               stype1_temp1=0;
                                              end//}
                                          end //}
                                    end //}  
                                    else if(drive_02)
                                    begin //{
                                          if(temp_array_g3.size() != 0)
                                          begin //{
                                            temp_g3             = temp_array_g3.pop_front();
                                            idle_field_char_g3[0] = temp_g3;
                                            idle_field_char_g3[2] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            igen_pkt_g3.brc3_merged_pkt.delete();
                                          end //}
                                          else if(igen_pkt_g3.brc3_merged_pkt.size() != 0)
                                          begin //{
                                            temp_g3             = igen_pkt_g3.brc3_merged_pkt.pop_front();
                                            idle_field_char_g3[0] = temp_g3;
                                            idle_field_char_g3[2] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                              lcl_cpy_ackid=temp_g3[6:17];
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01 && temp_g3[2:5]==0)
                                              void'(inc_lcl_cpy_ackid());
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b01)
                                                CS_tx=1;
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b10)
                                                CS_tx=0;
                                            if((temp_g3[0:1]==2'b10 && (temp_g3[30:31]==2'b10 || temp_g3[30:31]==2'b11)) && (temp_g3[32:33]==2'b01 || temp_g3[32:33]==2'b11))
                                              packet_open=1;
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                             stype1_temp1[0:1]=temp_g3[30:31];
                                            if(temp_g3[0:1]==2'b10 && (temp_g3[32:33]==2'b11 || temp_g3[32:33]==2'b10))
                                             stype1_temp1[2:7]=temp_g3[2:7];
                                             if(packet_open && (stype1_temp1==8'h10 || stype1_temp1==8'h11))
                                              begin//{
                                               packet_open=0;
                                               stype1_temp1=0;
                                              end//}
                                          end //}
                                    end //}  
                                    else if(drive_12)
                                    begin //{
                                          if(temp_array_g3.size() != 0)
                                          begin //{
                                            temp_g3             = temp_array_g3.pop_front();
                                            idle_field_char_g3[1] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            igen_pkt_g3.brc3_merged_pkt.delete();
                                          end //}
                                          else if(igen_pkt_g3.brc3_merged_pkt.size() != 0)
                                          begin //{
                                            temp_g3             = igen_pkt_g3.brc3_merged_pkt.pop_front();
                                            idle_field_char_g3[1] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                              lcl_cpy_ackid=temp_g3[6:17];
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01 && temp_g3[2:5]==0)
                                              void'(inc_lcl_cpy_ackid());
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b01)
                                                CS_tx=1;
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b10)
                                                CS_tx=0;
                                            if((temp_g3[0:1]==2'b10 && (temp_g3[30:31]==2'b10 || temp_g3[30:31]==2'b11)) && (temp_g3[32:33]==2'b01 || temp_g3[32:33]==2'b11))
                                              packet_open=1;
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                             stype1_temp1[0:1]=temp_g3[30:31];
                                            if(temp_g3[0:1]==2'b10 && (temp_g3[32:33]==2'b11 || temp_g3[32:33]==2'b10))
                                             stype1_temp1[2:7]=temp_g3[2:7];
                                             if(packet_open && (stype1_temp1==8'h10 || stype1_temp1==8'h11))
                                              begin//{
                                               packet_open=0;
                                               stype1_temp1=0;
                                              end//}
                                          end //}
                                    end //}
                                    else if(drive_1)
                                    begin //{
                                          if(temp_array_g3.size() != 0)
                                          begin //{
                                            temp_g3             = temp_array_g3.pop_front();
                                            idle_field_char_g3[1] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            igen_pkt_g3.brc3_merged_pkt.delete();
                                          end //}
                                          else if(igen_pkt_g3.brc3_merged_pkt.size() != 0)
                                          begin //{
                                            temp_g3             = igen_pkt_g3.brc3_merged_pkt.pop_front();
                                            idle_field_char_g3[1] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                              lcl_cpy_ackid=temp_g3[6:17];
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01 && temp_g3[2:5]==0)
                                              void'(inc_lcl_cpy_ackid());
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b01)
                                                CS_tx=1;
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b10)
                                                CS_tx=0;
                                            if((temp_g3[0:1]==2'b10 && (temp_g3[30:31]==2'b10 || temp_g3[30:31]==2'b11)) && (temp_g3[32:33]==2'b01 || temp_g3[32:33]==2'b11))
                                              packet_open=1;
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                             stype1_temp1[0:1]=temp_g3[30:31];
                                            if(temp_g3[0:1]==2'b10 && (temp_g3[32:33]==2'b11 || temp_g3[32:33]==2'b10))
                                             stype1_temp1[2:7]=temp_g3[2:7];
                                             if(packet_open && (stype1_temp1==8'h10 || stype1_temp1==8'h11))
                                              begin//{
                                               packet_open=0;
                                               stype1_temp1=0;
                                              end//}
                                          end //}
                                    end //}
                                    else if(drive_2)
                                    begin //{
                                          if(temp_array_g3.size() != 0)
                                          begin //{
                                            temp_g3             = temp_array_g3.pop_front();
                                            idle_field_char_g3[2] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            igen_pkt_g3.brc3_merged_pkt.delete();
                                          end //}
                                          else if(igen_pkt_g3.brc3_merged_pkt.size() != 0)
                                          begin //{
                                            temp_g3             = igen_pkt_g3.brc3_merged_pkt.pop_front();
                                            idle_field_char_g3[2] = temp_g3;
                                            scos_update        = 1'b0; 
                                            skip_flag          = 1'b0;
                                            dseed_update       = 1'b0; 
                                            lc_update          = 1'b0; 
                                            dme_fm_update      = 1'b0;
                                            dme_cof_update     = 1'b0;
                                            dme_stcs_update    = 1'b0;
                                            dme_trn_update     = 1'b0; 
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                              lcl_cpy_ackid=temp_g3[6:17];
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01 && temp_g3[2:5]==0)
                                              void'(inc_lcl_cpy_ackid());
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b01)
                                                CS_tx=1;
                                            if(temp_g3[0:1]==2'b10  && temp_g3[32:33]==2'b10)
                                                CS_tx=0;
                                            if((temp_g3[0:1]==2'b10 && (temp_g3[30:31]==2'b10 || temp_g3[30:31]==2'b11)) && (temp_g3[32:33]==2'b01 || temp_g3[32:33]==2'b11))
                                              packet_open=1;
                                            if(temp_g3[0:1]==2'b10 && temp_g3[32:33]==2'b01)
                                             stype1_temp1[0:1]=temp_g3[30:31];
                                            if(temp_g3[0:1]==2'b10 && (temp_g3[32:33]==2'b11 || temp_g3[32:33]==2'b10))
                                             stype1_temp1[2:7]=temp_g3[2:7];
                                             if(packet_open && (stype1_temp1==8'h10 || stype1_temp1==8'h11))
                                              begin//{
                                               packet_open=0;
                                               stype1_temp1=0;
                                              end//}
                                          end //}
                                    end //}
                                    else
                                    begin //{
                                         for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                         begin //{
                                              if (oes_flag)
                                               begin//{
                                                if(temp_array_g3.size() != 0)
                                                 begin //{
                                                  idle_field_char_g3[i] = temp_array_g3.pop_front();
                                                  scos_update        = 1'b0; 
                                                  skip_flag          = 1'b0;
                                                  dseed_update       = 1'b0; 
                                                  lc_update          = 1'b0; 
                                                  dme_fm_update      = 1'b0;
                                                  dme_cof_update     = 1'b0;
                                                  dme_stcs_update    = 1'b0;
                                                  dme_trn_update     = 1'b0;
                                                  igen_pkt_g3.brc3_merged_pkt.delete();
                                                 end//}
                                                else
                                                 begin //{
                                                  if(descr_sync_req_g3)
                                                   idle_field_char_g3[i] = igen_pkt_g3.brc3_merged_pkt.pop_front(); 
                                                  else
                                                  idle_field_char_g3[i] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                                  scos_update        = 1'b0;
                                                  skip_flag          = 1'b0;
                                                  dseed_update       = 1'b0;
                                                  lc_update          = 1'b0;
                                                  dme_fm_update      = 1'b0;
                                                  dme_cof_update     = 1'b0;
                                                  dme_stcs_update    = 1'b0;
                                                  dme_trn_update     = 1'b0;
                                                 end//}
                                              if(idle_field_char_g3[i][0:1]==2'b10 && idle_field_char_g3[i][32:33]==2'b01)
                                                  CS_tx=1;
                                              if(idle_field_char_g3[i][0:1]==2'b10 && idle_field_char_g3[i][32:33]==2'b10)
                                                  CS_tx=0;
                                               end//}
                                            else if(igen_pkt_g3.brc3_merged_pkt.size() != 0)
                                            begin //{
                                              idle_field_char_g3[i] = igen_pkt_g3.brc3_merged_pkt.pop_front();
                                              scos_update        = 1'b0; 
                                              skip_flag          = 1'b0;
                                              dseed_update       = 1'b0; 
                                              lc_update          = 1'b0; 
                                              dme_fm_update      = 1'b0;
                                              dme_cof_update     = 1'b0;
                                              dme_stcs_update    = 1'b0;
                                              dme_trn_update     = 1'b0; 
                                              if(idle_field_char_g3[i][0:1]==2'b10 && idle_field_char_g3[i][32:33]==2'b01)
                                                lcl_cpy_ackid=idle_field_char_g3[i][6:17];
                                              if(idle_field_char_g3[i][0:1]==2'b10 && idle_field_char_g3[i][32:33]==2'b01 && idle_field_char_g3[i][2:5]==0)
                                                void'(inc_lcl_cpy_ackid());
                                              if(idle_field_char_g3[i][0:1]==2'b10 && idle_field_char_g3[i][32:33]==2'b01)
                                                  CS_tx=1;
                                              if(idle_field_char_g3[i][0:1]==2'b10 && idle_field_char_g3[i][32:33]==2'b10)
                                                  CS_tx=0;
                                              if((idle_field_char_g3[i][0:1]==2'b10 && (idle_field_char_g3[i][30:31]==2'b10 || idle_field_char_g3[i][30:31]==2'b11)) && (idle_field_char_g3[i][32:33]==2'b01 || idle_field_char_g3[i][32:33]==2'b11))
                                                packet_open=1;
                                              if(idle_field_char_g3[i][0:1]==2'b10 && idle_field_char_g3[i][32:33]==2'b01)
                                               stype1_temp1[0:1]=idle_field_char_g3[i][30:31];
                                              if(idle_field_char_g3[i][0:1]==2'b10 && (idle_field_char_g3[i][32:33]==2'b11 || idle_field_char_g3[i][32:33]==2'b10))
                                               stype1_temp1[2:7]=idle_field_char_g3[i][2:7];
                                               if(packet_open && (stype1_temp1==8'h10 || stype1_temp1==8'h11))
                                                begin//{
                                                 packet_open=0;
                                                 stype1_temp1=0;
                                                end//}
                                            end //}
                                            else
                                            begin //{
                                              idle_field_char_g3[i] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                              scos_update        = 1'b0; 
                                              skip_flag          = 1'b0;
                                              dseed_update       = 1'b0; 
                                              lc_update          = 1'b0; 
                                              dme_fm_update      = 1'b0;
                                              dme_cof_update     = 1'b0;
                                              dme_stcs_update    = 1'b0;
                                              dme_trn_update     = 1'b0; 
                                            end //}  
                                           if((idle_trans.oes_state || idle_trans.ors_state) && ~oes_flag && !CS_tx && packet_open)
                                            begin//{
                                             if(pktcs_merge_ins.pktcs_proc_q.size()!=0)
                                              begin//{
                                               temp_merge_ins = new pktcs_merge_ins.pktcs_proc_q[0];
                                               new_cs=1;
                                               stype1_temp={temp_merge_ins.brc3_merged_cs[0][30:31],temp_merge_ins.brc3_merged_cs[1][2:7]};
                                              end//}
                                              if(new_cs==1 &&temp_merge_ins.m_type == MERGED_CS && stype1_temp==8'h18)
                                               begin//{
                                                new_cs=0;
                                                pktcs_merge_ins.pktcs_proc_q.delete(0);
                                                for(int k=0;k<temp_merge_ins.brc3_merged_cs.size();k++)
                                                begin//{
                                                 temp_array_g3.push_back(temp_merge_ins.brc3_merged_cs[k]);
                                                end//}
                                                 idle_trans.ors_state = 1'b0; 
                                                 oes_flag = 1'b1;
                                               end//}
                                              else if(new_cs==1 &&temp_merge_ins.m_type == MERGED_CS && (stype1_temp==8'h22 || stype1_temp==8'h23 || stype1_temp==8'h24))
                                               begin//{
                                                new_cs=0;
                                                oes_flag = 1'b1;
                                                igen_pkt_g3_tmp = new pktcs_merge_ins.pktcs_proc_q[0];
                                                pktcs_merge_ins.pktcs_proc_q.delete(0);
                                                cs_req_g3 = 1'b1;
                                                descr_sync_req_g3 = 1'b1; 
                                                idle_cnt=0;
                                               end//}
                                              else
                                               begin//{
                                                 new_cs=0;
                                                 gen_stomp_cs();
                                                 temp_array_g3[0] = {2'b10,trans_push_ins.stype0,trans_push_ins.param0,trans_push_ins.param1,trans_push_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                                 temp_array_g3[1] = {2'b10,trans_push_ins.stype1,trans_push_ins.cmd,trans_push_ins.cs_crc24,2'b10,32'h0000_0000};
                                                 oes_flag = 1'b1;
                                               end//}
                                            end//}
                                       end //}  
                                    end //}  
                                    if(drive_012 || drive_02 || drive_12 || drive_1 || drive_2)
                                     begin//{
                                      if((idle_trans.oes_state || idle_trans.ors_state) && ~oes_flag && !CS_tx && packet_open)
                                         begin//{
                                          if(pktcs_merge_ins.pktcs_proc_q.size()!=0)
                                           begin//{
                                            temp_merge_ins = new pktcs_merge_ins.pktcs_proc_q[0];
                                            new_cs=1;
                                            stype1_temp={temp_merge_ins.brc3_merged_cs[0][30:31],temp_merge_ins.brc3_merged_cs[1][2:7]};
                                           end//}
                                           if(new_cs==1 &&temp_merge_ins.m_type == MERGED_CS && stype1_temp==8'h18)
                                            begin//{
                                             new_cs=0;
                                             pktcs_merge_ins.pktcs_proc_q.delete(0);
                                             for(int k=0;k<temp_merge_ins.brc3_merged_cs.size();k++)
                                             begin//{
                                              temp_array_g3.push_back(temp_merge_ins.brc3_merged_cs[k]);
                                             end//}
                                              idle_trans.ors_state = 1'b0; 
                                              oes_flag = 1'b1;
                                            end//}
                                           else if(new_cs==1 &&temp_merge_ins.m_type == MERGED_CS && (stype1_temp==8'h22 || stype1_temp==8'h23 || stype1_temp==8'h24))
                                            begin//{
                                             new_cs=0;
                                             oes_flag = 1'b1;
                                             igen_pkt_g3_tmp = new pktcs_merge_ins.pktcs_proc_q[0];
                                             pktcs_merge_ins.pktcs_proc_q.delete(0);
                                             cs_req_g3 = 1'b1;
                                             descr_sync_req_g3 = 1'b1; 
                                             idle_cnt=0;
                                            end//}
                                             else
                                              begin//{
                                               gen_stomp_cs();
                                               temp_array_g3[0] = {2'b10,trans_push_ins.stype0,trans_push_ins.param0,trans_push_ins.param1,trans_push_ins.brc3_stype1_msb,2'b01,32'h0000_0000};
                                               temp_array_g3[1] = {2'b10,trans_push_ins.stype1,trans_push_ins.cmd,trans_push_ins.cs_crc24,2'b10,32'h0000_0000};
                                               oes_flag = 1'b1;
                                              end//}
                                         end//}
                                     end//}
                                    idle_trans.xmting_idle=1'b0;
                                    if(descr_sync_req_g3 && oes_flag&& ~CS_tx)
                                    begin //{ 
                                         igen_pkt_g3 = new igen_pkt_g3_tmp;
                                         pkt_req_done_g3 = 1'b1;
                                         idle3_state = IDLE3_SOOS1;
                                         idle3_com_seq_sent = 1'b0;
                                         oes_flag=0;
                                    end //} 
                                    else if(oes_flag && temp_array_g3.size()!=0)
                                    begin //{
                                         idle3_state = IDLE3_PKT_STATE;
                                         idle3_com_seq_sent = 1'b0;
                                    end //}
                                    else if(igen_pkt_g3.brc3_merged_pkt.size() != 0)
                                    begin //{
                                         idle3_state = IDLE3_PKT_STATE;
                                         idle3_com_seq_sent = 1'b0;
                                    end //}
                                    else
                                    begin //{ 
                                         pkt_req_done_g3 = 1'b1;
                                         idle3_state = IDLE3_PSR;
                                         idle3_com_seq_sent = 1'b0;
                                         oes_flag=0;
                                    end //} 
                                   end //}
               // Control Symbol
               IDLE3_CS_STATE :  begin //{ 
                                   if(drive_012)
                                   begin //{
                                         if(igen_pkt_g3.brc3_merged_cs.size() != 0)
                                         begin //{
                                           temp_g3               = igen_pkt_g3.brc3_merged_cs.pop_front();
                                           idle_field_char_g3[0] = temp_g3;
                                           idle_field_char_g3[1] = temp_g3;
                                           idle_field_char_g3[2] = temp_g3;
                                           scos_update        = 1'b0; 
                                           skip_flag          = 1'b0;
                                           dseed_update       = 1'b0; 
                                           lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                         end //}
                                   end //}  
                                   else if(drive_02)
                                   begin //{
                                         if(igen_pkt_g3.brc3_merged_cs.size() != 0)
                                         begin //{
                                           temp_g3               = igen_pkt_g3.brc3_merged_cs.pop_front();
                                           idle_field_char_g3[0] = temp_g3;
                                           idle_field_char_g3[2] = temp_g3;
                                           scos_update        = 1'b0; 
                                           skip_flag          = 1'b0;
                                           dseed_update       = 1'b0; 
                                           lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                         end //}
                                   end //}  
                                   else if(drive_12)
                                   begin //{
                                         if(igen_pkt_g3.brc3_merged_cs.size() != 0)
                                         begin //{
                                           temp_g3               = igen_pkt_g3.brc3_merged_cs.pop_front();
                                           idle_field_char_g3[1] = temp_g3;
                                           scos_update        = 1'b0; 
                                           skip_flag          = 1'b0;
                                           dseed_update       = 1'b0; 
                                           lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                         end //}
                                   end //}  
                                   else if(drive_1)
                                   begin //{
                                         if(igen_pkt_g3.brc3_merged_cs.size() != 0)
                                         begin //{
                                           temp_g3               = igen_pkt_g3.brc3_merged_cs.pop_front();
                                           idle_field_char_g3[1] = temp_g3;
                                           scos_update        = 1'b0; 
                                           skip_flag          = 1'b0;
                                           dseed_update       = 1'b0; 
                                           lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                         end //}
                                   end //}  
                                   else if(drive_2)
                                   begin //{
                                         if(igen_pkt_g3.brc3_merged_cs.size() != 0)
                                         begin //{
                                           temp_g3               = igen_pkt_g3.brc3_merged_cs.pop_front();
                                           idle_field_char_g3[2] = temp_g3;
                                           scos_update        = 1'b0; 
                                           skip_flag          = 1'b0;
                                           dseed_update       = 1'b0; 
                                           lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                         end //}
                                   end //}  
                                   else
                                   begin //{
                                       for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                       begin //{
                                           if(igen_pkt_g3.brc3_merged_cs.size() != 0)
                                           begin //{
                                             idle_field_char_g3[i] = igen_pkt_g3.brc3_merged_cs.pop_front();
                                             scos_update        = 1'b0; 
                                             skip_flag          = 1'b0;
                                             dseed_update       = 1'b0; 
                                             lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                           end //}
                                           else
                                           begin //{
                                             idle_field_char_g3[i] = {1'b0,1'b1,64'h0000_0000_0000_0000};
                                             scos_update        = 1'b0; 
                                             skip_flag          = 1'b0;
                                             dseed_update       = 1'b0; 
                                             lc_update          = 1'b0; 
                                     dme_fm_update      = 1'b0;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                           end //}  
                                       end //}
                                   end //}  
                                   idle_trans.xmting_idle=1'b0;
                                   if(igen_pkt_g3.brc3_merged_cs.size() != 0)
                                   begin //{
                                        idle3_state = IDLE3_CS_STATE;
                                        idle3_com_seq_sent = 1'b0;
                                   end //}
                                   else
                                   begin //{ 
                                        cs_req_done_g3 = 1'b1;
                                        idle3_state = IDLE3_PSR;
                                        idle3_com_seq_sent = 1'b0;
                                   end //} 
                                 end //}
             endcase
          end //}
       end //} 
    end //}
  endtask : idle_gen3

//////////////////////////////////////////////////////////////////////////
/// Name: CS_Field_Marker \n
/// Description: Forming the CS field marker to be transmitted in IDLE2 
//////////////////////////////////////////////////////////////////////////

 task srio_pl_idle_gen::CS_Field_Marker();

  idle2_csf_marker_array[31] = {1'b0,8'h67};
  idle2_csf_marker_array[30] = {1'b0,8'hF8};
  idle2_csf_marker_array[29] = {1'b0,8'h67};
  idle2_csf_marker_array[28] = {1'b0,8'h67};
  idle2_csf_marker_array[27] = {1'b0,8'h67};
  idle2_csf_marker_array[26] = {1'b0,8'h67};
  idle2_csf_marker_array[25] = {1'b0,8'h67};
  idle2_csf_marker_array[24] = {1'b0,8'h67};
  idle2_csf_marker_array[23] = {1'b0,8'h67};
  idle2_csf_marker_array[22] = {1'b0,8'h67};
  idle2_csf_marker_array[21] = {1'b0,8'h67};
  idle2_csf_marker_array[20] = {1'b0,8'h67};
  idle2_csf_marker_array[19] = {1'b0,8'h67};
  idle2_csf_marker_array[18] = {1'b0,8'h67};
  idle2_csf_marker_array[17] = {1'b0,8'h67};
  idle2_csf_marker_array[16] = {1'b0,8'h67};
  idle2_csf_marker_array[15] = {1'b0,8'hF8};
  idle2_csf_marker_array[14] = {1'b0,8'h67};
  idle2_csf_marker_array[13] = {1'b0,8'hF8};
  idle2_csf_marker_array[12] = {1'b0,8'hF8};
  idle2_csf_marker_array[11] = {1'b0,8'hF8};
  idle2_csf_marker_array[10] = {1'b0,8'hF8};
  idle2_csf_marker_array[9]  = {1'b0,8'hF8};
  idle2_csf_marker_array[8]  = {1'b0,8'hF8};
  idle2_csf_marker_array[7]  = {1'b0,8'hF8};
  idle2_csf_marker_array[6]  = {1'b0,8'hF8};
  idle2_csf_marker_array[5]  = {1'b0,8'hF8};
  idle2_csf_marker_array[4]  = {1'b0,8'hF8};
  idle2_csf_marker_array[3]  = {1'b0,8'hF8};
  idle2_csf_marker_array[2]  = {1'b0,8'hF8};
  idle2_csf_marker_array[1]  = {1'b0,8'hF8};
  idle2_csf_marker_array[0]  = {1'b0,8'hF8};
  forever
  begin //{
   @(negedge idle_trans.int_clk or negedge srio_if.srio_rst_n)
    begin //{
     if(~idle_trans.port_initialized)
      begin//{
 if(env_config.num_of_lanes == 16)
    CS_field_act_port_wid = 3'b100;
 else if(env_config.num_of_lanes == 8)
    CS_field_act_port_wid = 3'b011;
 else if(env_config.num_of_lanes == 4)
    CS_field_act_port_wid = 3'b010;
 else if(env_config.num_of_lanes == 2)
    CS_field_act_port_wid = 3'b001;
 else if(env_config.num_of_lanes == 1)
    CS_field_act_port_wid = 3'b000;
      end //}
     else
      begin//{
       case (idle_trans.max_width)
       "16x": CS_field_act_port_wid = 3'b100;
       "8x" : CS_field_act_port_wid = 3'b011;
       "4x" : CS_field_act_port_wid = 3'b010;
       "2x" : CS_field_act_port_wid = 3'b001;
       "1x" : 
         begin//{
          if(env_config.srio_mode != SRIO_GEN21 && (idle_trans.lane_sync[0] && idle_trans.lane_sync[1]) && idle_trans.lane_sync[2] )
           CS_field_act_port_wid = 3'b101;
          else if (idle_trans.lane_sync[0] && idle_trans.lane_sync[1] )
           CS_field_act_port_wid = 3'b110;
          else if (idle_trans.lane_sync[0] && idle_trans.lane_sync[2] )
           CS_field_act_port_wid = 3'b111;
          else
           CS_field_act_port_wid = 3'b000;
         end //}
        endcase 
      end //}

  // idle generation array
 idle2_csfield_array[0]  = {1'b0,CS_field_act_port_wid, 5'h0 };
 idle2_csfield_array[1]  = {1'b0,CS_field_act_port_wid, 5'h1 };
 idle2_csfield_array[2]  = {1'b0,CS_field_act_port_wid, 5'h2 };
 idle2_csfield_array[3]  = {1'b0,CS_field_act_port_wid, 5'h3 };
 idle2_csfield_array[4]  = {1'b0,CS_field_act_port_wid, 5'h4 };
 idle2_csfield_array[5]  = {1'b0,CS_field_act_port_wid, 5'h5 };
 idle2_csfield_array[6]  = {1'b0,CS_field_act_port_wid, 5'h6 };
 idle2_csfield_array[7]  = {1'b0,CS_field_act_port_wid, 5'h7 };
 idle2_csfield_array[8]  = {1'b0,CS_field_act_port_wid, 5'h8 };
 idle2_csfield_array[9]  = {1'b0,CS_field_act_port_wid, 5'h9 };
 idle2_csfield_array[10] = {1'b0,CS_field_act_port_wid, 5'hA };
 idle2_csfield_array[11] = {1'b0,CS_field_act_port_wid, 5'hB };
 idle2_csfield_array[12] = {1'b0,CS_field_act_port_wid, 5'hC };
 idle2_csfield_array[13] = {1'b0,CS_field_act_port_wid, 5'hD };
 idle2_csfield_array[14] = {1'b0,CS_field_act_port_wid, 5'hE };
 idle2_csfield_array[15] = {1'b0,CS_field_act_port_wid, 5'hF };


 idle2_csfield_neg_array[0]  = {1'b0,~CS_field_act_port_wid, 5'h1F };
 idle2_csfield_neg_array[1]  = {1'b0,~CS_field_act_port_wid, 5'h1E };
 idle2_csfield_neg_array[2]  = {1'b0,~CS_field_act_port_wid, 5'h1D };
 idle2_csfield_neg_array[3]  = {1'b0,~CS_field_act_port_wid, 5'h1C };
 idle2_csfield_neg_array[4]  = {1'b0,~CS_field_act_port_wid, 5'h1B };
 idle2_csfield_neg_array[5]  = {1'b0,~CS_field_act_port_wid, 5'h1A };
 idle2_csfield_neg_array[6]  = {1'b0,~CS_field_act_port_wid, 5'h19 };
 idle2_csfield_neg_array[7]  = {1'b0,~CS_field_act_port_wid, 5'h18 };
 idle2_csfield_neg_array[8]  = {1'b0,~CS_field_act_port_wid, 5'h17 };
 idle2_csfield_neg_array[9]  = {1'b0,~CS_field_act_port_wid, 5'h16 };
 idle2_csfield_neg_array[10] = {1'b0,~CS_field_act_port_wid, 5'h15 };
 idle2_csfield_neg_array[11] = {1'b0,~CS_field_act_port_wid, 5'h14 };
 idle2_csfield_neg_array[12] = {1'b0,~CS_field_act_port_wid, 5'h13 };
 idle2_csfield_neg_array[13] = {1'b0,~CS_field_act_port_wid, 5'h12 };
 idle2_csfield_neg_array[14] = {1'b0,~CS_field_act_port_wid, 5'h11 };
 idle2_csfield_neg_array[15] = {1'b0,~CS_field_act_port_wid, 5'h10 };
    end //}
  end //}
 endtask : CS_Field_Marker

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : push_char
/// Description : Task which fetches character to be transmitted on each lane and triggers 
/// the event which will perform this.
/// Also this task will break the required lanes for state transition request from the sequence
///////////////////////////////////////////////////////////////////////////////////////////////
 task srio_pl_idle_gen::push_char();
 bit [0:8] temp;
 bit [0:65] temp_gen3;
 bit [0:65] temp_gen12;
 for(int i=0;i<env_config.num_of_lanes;i++)
 begin //{
  lane_data_ins[i] = new();
  lane_data_ins[i].curr_rd       = NEG;
 end //}
 forever
 begin //{
      @(negedge idle_trans.int_clk or negedge srio_if.srio_rst_n)
      begin //{
         if(~srio_if.srio_rst_n)
         begin //{
              temp = 0;
              temp_gen3 = 0;
         end //}
         else
         begin //{ 
                   for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                   begin //{

	             if(drive_1 && idle_trans.bfm_no_lanes == 1)
	               i = 1;

                     if(env_config.srio_mode == SRIO_GEN30) 
                     begin //{
                         if(idle_field_char_g3.exists(i))
                           temp_gen3        = idle_field_char_g3[i];
                         if(idle_trans.current_init_state==SILENT)
                           temp_gen3             = 0;       
                         if (i == 0)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane0(temp_gen3,env_config))
                         else if (i == 1)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane1(temp_gen3,env_config))
                         else if (i == 2)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane2(temp_gen3,env_config))
                         else if (i == 3)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane3(temp_gen3,env_config))
                         else if (i == 4)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane4(temp_gen3,env_config))
                         else if (i == 5)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane5(temp_gen3,env_config))
                         else if (i == 6)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane6(temp_gen3,env_config))
                         else if (i == 7)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane7(temp_gen3,env_config))
                         else if (i == 8)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane8(temp_gen3,env_config))
                         else if (i == 9)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane9(temp_gen3,env_config))
                         else if (i == 10)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane10(temp_gen3,env_config))
                         else if (i == 11)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane11(temp_gen3,env_config))
                         else if (i == 12)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane12(temp_gen3,env_config))
                         else if (i == 13)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane13(temp_gen3,env_config))
                         else if (i == 14)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane14(temp_gen3,env_config))
                         else if (i == 15)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane15(temp_gen3,env_config))

                           lane_data_ins[i].brc3_cw   = temp_gen3[2:65];
                           lane_data_ins[i].brc3_type = temp_gen3[1];
                           lane_data_ins[i].brc3_cc_type = temp_gen3[32:33];

                           if(idle_trans.current_init_state==SILENT)
                            begin//{
                                     dme_fm_update      = 1'b1;
                                     dme_cof_update     = 1'b0;
                                     dme_stcs_update    = 1'b0;
                                     dme_trn_update     = 1'b0; 
                                     scos_update        = 1'b0; 
                                     skip_flag          = 1'b0;
                                     dseed_update       = 1'b0; 
                                     lc_update          = 1'b0; 
                            end//}

                           if(dme_fm_update)
                              lane_data_ins[i].brc3_fm_update = 1'b1;
                           else
                              lane_data_ins[i].brc3_fm_update = 1'b0;
                           if(dme_cof_update)
                              lane_data_ins[i].brc3_cof_update = 1'b1;
                           else
                              lane_data_ins[i].brc3_cof_update = 1'b0;
                           if(dme_stcs_update)
                              lane_data_ins[i].brc3_stat_update = 1'b1;
                           else
                              lane_data_ins[i].brc3_stat_update = 1'b0;

                           if(dme_trn_update)
                              lane_data_ins[i].brc3_trn_update = 1'b1;
                           else
                              lane_data_ins[i].brc3_trn_update = 1'b0;

                           if(scos_update)
                           begin //{
                              lane_data_ins[i].brc3_stcs_update = 1'b1;
                           end //}
                           else
                              lane_data_ins[i].brc3_stcs_update = 1'b0;

                           if(skip_flag)
                           begin //{
                              lane_data_ins[i].brc3_skip = 1'b1;
                           end //}
                           else
                              lane_data_ins[i].brc3_skip = 1'b0;

                           if(dseed_update)
                              lane_data_ins[i].brc3_sdos_update = 1'b1;
                           else
                              lane_data_ins[i].brc3_sdos_update = 1'b0;

                           if(lc_update)
                              lane_data_ins[i].brc3_lc_update = 1'b1; 
                           else
                              lane_data_ins[i].brc3_lc_update = 1'b0; 

	                   if(idle_trans.ism_change_req == FALSE)
                           begin
                             lane_data_ins[i].invalid_cg = 0; 
                           end 

                             if(drive_12 && (i == 0) && (i==2))
                             begin //{
                              lane_data_ins[i].brc3_cw   = 0;
                              lane_data_ins[i].brc3_type = 0;
                              lane_data_ins[i].brc3_cc_type = 0;
                              lane_data_ins[i].invalid_cg = 1; 
                             end //}    

                           if(drive_2 && ((i == 1) || (i == 0)))
                           begin //{
                              lane_data_ins[i].brc3_cw   = 0;
                              lane_data_ins[i].brc3_type = 0;
                              lane_data_ins[i].brc3_cc_type = 0;
                              lane_data_ins[i].invalid_cg = 1; 
                           end //}    

                           if(drive_1 && ((i == 0) || (i == 2)))
                           begin //{
                              lane_data_ins[i].brc3_cw   = 0;
                              lane_data_ins[i].brc3_type = 0;
                              lane_data_ins[i].brc3_cc_type = 0;
                              lane_data_ins[i].invalid_cg = 1; 
                           end //}    
                     end //}
                     else
                     begin //{
                         if(idle_field_char.exists(i)) 
                           temp             = idle_field_char[i];       
                         if(idle_trans.current_init_state==SILENT)
                           temp             = 0;       
                         if(idle_trans.current_init_state==SEEK && i>2)
                           temp             = 0;       
                         if(idle_trans.current_init_state==SEEK && i==1 && env_config.srio_mode == SRIO_GEN13)
                           temp             = 0;       
                           temp_gen12={57'h0,temp};
                         if (i == 0)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane0(temp_gen12,env_config))
                         else if (i == 1)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane1(temp_gen12,env_config))
                         else if (i == 2)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane2(temp_gen12,env_config))
                         else if (i == 3)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane3(temp_gen12,env_config))
                         else if (i == 4)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane4(temp_gen12,env_config))
                         else if (i == 5)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane5(temp_gen12,env_config))
                         else if (i == 6)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane6(temp_gen12,env_config))
                         else if (i == 7)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane7(temp_gen12,env_config))
                         else if (i == 8)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane8(temp_gen12,env_config))
                         else if (i == 9)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane9(temp_gen12,env_config))
                         else if (i == 10)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane10(temp_gen12,env_config))
                         else if (i == 11)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane11(temp_gen12,env_config))
                         else if (i == 12)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane12(temp_gen12,env_config))
                         else if (i == 13)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane13(temp_gen12,env_config))
                         else if (i == 14)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane14(temp_gen12,env_config))
                         else if (i == 15)
                          `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_char_transmitted_lane15(temp_gen12,env_config))
                           
                           temp=temp_gen12[57:65];
                           lane_data_ins[i].character = temp[1:8];
                           lane_data_ins[i].cntl = temp[0]; 

                           if(env_config.scramble_dis == 1)
                             lane_data_ins[i].idle2_cs = 1'b1;
                           else
                             lane_data_ins[i].idle2_cs = 1'b0;

                           if(csf_update == 1'b1)
                             lane_data_ins[i].csfield_update = 1'b1;
                           else  
                             lane_data_ins[i].csfield_update = 1'b0;

	                   if(idle_trans.ism_change_req == FALSE)
                           begin
                             lane_data_ins[i].invalid_cg = 0; 
                           end 

                           if(drive_2 && ((i == 1) || (i == 0)))
                           begin //{
                              lane_data_ins[i].character = 0;
                              lane_data_ins[i].cntl = 0; 
                              lane_data_ins[i].invalid_cg = 1; 
                           end //}    

                           if(drive_1 && ((i == 0) || (i == 2)))
                           begin //{
                              lane_data_ins[i].character = 0;
                              lane_data_ins[i].cntl = 0; 
                              lane_data_ins[i].invalid_cg = 1; 
                           end //}    

                           if(drive_12 && ((i == 0) || (i == 2)))
                           begin //{
                              lane_data_ins[i].character = 0;
                              lane_data_ins[i].cntl = 0; 
                              lane_data_ins[i].invalid_cg = 1; 
                           end //}    

         end //} 


   
                      if((idle_trans.ism_change_req == TRUE) && idle_trans.current_init_state != idle_trans.ism_req_state)
                      begin //{
                        case(idle_trans.ism_req_state)
                          SILENT:begin
                                   if(env_config.srio_mode == SRIO_GEN30)
                                   begin //{
                                       lane_data_ins[i].brc3_cw   = 0;
                                       lane_data_ins[i].brc3_type = 0;
                                       lane_data_ins[i].brc3_cc_type = 0;
                                       lane_data_ins[i].invalid_cg = 1; 
                                   end //}
                                   else
                                   begin //{ 
                                       lane_data_ins[i].character = 0;
                                       lane_data_ins[i].cntl = 0; 
                                       lane_data_ins[i].invalid_cg = 1; 
                                   end //}
                                 end 
                          DISCOVERY:begin
                                       if(i > 2 )
                                       begin //{
                                          if(env_config.srio_mode == SRIO_GEN30)
                                          begin //{
                                              lane_data_ins[i].brc3_cw   = 0;
                                              lane_data_ins[i].brc3_type = 0;
                                              lane_data_ins[i].brc3_cc_type = 0;
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                          else
                                          begin //{ 
                                              lane_data_ins[i].character = 0;
                                              lane_data_ins[i].cntl = 0; 
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                       end //}
                                    end 

                          X2_MODE:begin
                                       if(i > 1 )
                                       begin //{
                                          if(env_config.srio_mode == SRIO_GEN30)
                                          begin //{
                                              lane_data_ins[i].brc3_cw   = 0;
                                              lane_data_ins[i].brc3_type = 0;
                                              lane_data_ins[i].brc3_cc_type = 0;
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                          else
                                          begin //{ 
                                              lane_data_ins[i].character = 0;
                                              lane_data_ins[i].cntl = 0; 
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                       end //}
                                  end 
                          X2_RECOVERY:begin
                                       if(i > 0 )
                                       begin //{
                                          if(env_config.srio_mode == SRIO_GEN30)
                                          begin //{
                                              lane_data_ins[i].brc3_cw   = 0;
                                              lane_data_ins[i].brc3_type = 0;
                                              lane_data_ins[i].brc3_cc_type = 0;
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                          else
                                          begin //{ 
                                              lane_data_ins[i].character = 0;
                                              lane_data_ins[i].cntl = 0; 
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                       end //}
                                      end 
                          X1_M0:begin
                                       if(i != 0 )
                                       begin //{
                                          if(env_config.srio_mode == SRIO_GEN30)
                                          begin //{
                                              lane_data_ins[i].brc3_cw   = 0;
                                              lane_data_ins[i].brc3_type = 0;
                                              lane_data_ins[i].brc3_cc_type = 0;
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                          else
                                          begin //{ 
                                              lane_data_ins[i].character = 0;
                                              lane_data_ins[i].cntl = 0; 
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                       end //}
                                end 
                          X1_M1:begin
                                       if(i != 1 )
                                       begin //{
                                          if(env_config.srio_mode == SRIO_GEN30)
                                          begin //{
                                              lane_data_ins[i].brc3_cw   = 0;
                                              lane_data_ins[i].brc3_type = 0;
                                              lane_data_ins[i].brc3_cc_type = 0;
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                          else
                                          begin //{ 
                                              lane_data_ins[i].character = 0;
                                              lane_data_ins[i].cntl = 0; 
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                       end //}
                                end 
                          X1_M2:begin
                                       if(i != 2 )
                                       begin //{
                                          if(env_config.srio_mode == SRIO_GEN30)
                                          begin //{
                                              lane_data_ins[i].brc3_cw   = 0;
                                              lane_data_ins[i].brc3_type = 0;
                                              lane_data_ins[i].brc3_cc_type = 0;
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                          else
                                          begin //{ 
                                              lane_data_ins[i].character = 0;
                                              lane_data_ins[i].cntl = 0; 
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                       end //}
                                end 
                          X1_RECOVERY:begin //{
                                        if( (idle_trans.current_init_state == X1_M0 && i == 0) || (idle_trans.current_init_state == X1_M1 && i == 1)
                                            || (idle_trans.current_init_state == X1_M2 && i == 2) )
                                        begin //{
                                          if(env_config.srio_mode == SRIO_GEN30)
                                          begin //{
                                              lane_data_ins[i].brc3_cw   = 0;
                                              lane_data_ins[i].brc3_type = 0;
                                              lane_data_ins[i].brc3_cc_type = 0;
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                          else
                                          begin //{ 
                                              lane_data_ins[i].character = 0;
                                              lane_data_ins[i].cntl = 0; 
                                              lane_data_ins[i].invalid_cg = 1; 
                                          end //}
                                        end //}
                                      end  //}
                        endcase
                      end //}
                      if((idle_trans.ism_change_req == TRUE) &&  (idle_trans.ism_req_state==X1_M0 || idle_trans.ism_req_state==X1_M1 || idle_trans.ism_req_state==X1_M2))
                       begin//{
                        if(idle_trans.current_init_state==X1_M0 || idle_trans.current_init_state==X1_M1 || idle_trans.current_init_state==X1_M2)
                         idle_trans.ism_change_req = FALSE;
                       end//}
                      if((idle_trans.ism_change_req == TRUE) && idle_trans.current_init_state == idle_trans.ism_req_state)
                      begin
                        idle_trans.ism_change_req = FALSE;
                      end
                   srio_tx_lane_event[i].trigger(lane_data_ins[i]);
                   end // } end for 
         end // }else
      end //} // end negedge

 end //} forever 
 endtask : push_char



///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : psr_gen
/// Description : Task which forms the final queue for transmission on a per lane basis for 
/// IDLE1/2.
/// This queue will include IDLE1/2 sequence and stripped packet and control symbol
/// Also this task controls the clock compensation rate
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_idle_gen::psr_gen();
    bit[0:8] lcl_cs_array[$];
    forever
    begin //{
       @(negedge idle_trans.int_clk or negedge srio_if.srio_rst_n) 
       begin //{    
           if(~srio_if.srio_rst_n)
           begin //{
              idle_trans.cpy_rx_ackid=0;
              once_flag=0;
              tmp_crc=0;
              cal_crc24=0;
              cal_crc13=0;
              cal_crc5=0;
              index=0;
              q_size=0;
              psuedo_rand_gen = 7'b111_1111;
              a_cnt           = 5'b0;   
              compen_cnt = idle_config.clk_compensation_seq_rate;
	      if (env_config.srio_mode == SRIO_GEN13)
                idle_trans.bfm_idle_selected = 0;
	      else
                idle_trans.bfm_idle_selected = idle_config.idle_sel;
              idle_trans.bfm_no_lanes      = env_config.num_of_lanes;
              drive_012                    = 0;  
              drive_12                     = 0;
              drive_1                      = 0;  
              drive_2                      = 0;  
              drive_0                      = 0;
              drive_02                     = 0;
              drive_01                     = 0;
              clear_flag                   = 0;
              temp_size                    = 0;
              pkt_txt_cnt                  = 0;
              pkt_contains_cs              = 0;
           end  //}
           else
           begin //{
               psuedo_rand_gen[0] = psuedo_rand_gen[6] ^ psuedo_rand_gen[5];
               psuedo_rand_gen[1:6] = psuedo_rand_gen[0:5];    
            
               if(idle_send_a || (idle_trans.bfm_idle_selected && idle_send_m) || (idle_trans.bfm_idle_selected && (idle_cnt== idle2_seq_length)) || (idle_trans.bfm_idle_selected && idle_cnt < 10'd44) || ~(state ==IDLE_NORMAL) )
               begin //{
                    a_cnt = {2'b01,psuedo_rand_gen[3:6]};
                    if(idle_trans.bfm_idle_selected && (idle_cnt== idle2_seq_length))
                     a_cnt=a_cnt+4;
                    if(idle_trans.bfm_idle_selected && (idle_cnt== 74))
                     a_cnt=35;
               end //}
               else if(|a_cnt)
               begin //{
                    a_cnt = a_cnt - 1;
               end //}

               idle_send_k = (~idle_trans.bfm_idle_selected && (psuedo_rand_gen[0] && a_cnt!=0));

               idle_send_a = ((~idle_trans.bfm_idle_selected || psuedo_rand_gen[6]) && (a_cnt == 0) && (~idle_trans.bfm_idle_selected || ~(state == IDLE_COMPEN)));

               idle_send_m = (idle_trans.bfm_idle_selected && ~psuedo_rand_gen[6] && (a_cnt == 0) && ~(state == IDLE_COMPEN)) || idle_compen_done;
 
               idle_send_r  = ~idle_trans.bfm_idle_selected  && ~psuedo_rand_gen[0] && |a_cnt;


            if(idle_trans.idle_detected && idle_trans.idle_selected)
                idle_trans.bfm_idle_selected = 1; // idle2 selected
            else if(idle_trans.idle_detected && ~idle_trans.idle_selected)
                idle_trans.bfm_idle_selected = 0; // idle1 selected


            // no of lanes detection
            if(idle_trans.current_init_state == SILENT)
            begin //{
                  idle_trans.bfm_no_lanes = env_config.num_of_lanes;
                  pkt_req_done = 1'b0;
                  pkt_req  = 1'b0;
                  cs_req   = 1'b0;
                  cs_req_done = 1'b0; 
                  pktcs_merge_ins.pkt_avail_req = 1'b1;
                  pktcs_merge_ins.pkt_avail_req_g3 = 1'b1;
                  lane_trained = 1'b0;
            end //}

            if(idle_trans.current_init_state != SILENT)
            begin //{
            if(!idle_config.nx_mode_support && !idle_config.x2_mode_support && idle_config.force_1x_mode_en && idle_trans.force_1x_mode && idle_config.force_laner_en && idle_trans.force_laneR)
            begin //{
                  if(env_config.num_of_lanes > 3)
                  begin//{
                     if(env_config.srio_mode == SRIO_GEN13)
                     begin//{
                       drive_1    = 1'b0;
                       drive_2    = 1'b1;
                       drive_0    = 1'b0;
                       drive_012  = 1'b0;
                       drive_12   = 1'b0;
                       drive_02   = 1'b0;
                       drive_01   = 1'b0;
                       idle_trans.bfm_no_lanes = 3;
                     end //}  
                     else 
                     begin//{
                       drive_1    = 1'b0;
                       drive_2    = 1'b0;
                       drive_0    = 1'b0;
                       drive_012  = 1'b0;
                       drive_12   = 1'b1;
                       drive_02   = 1'b0;
                       drive_01   = 1'b0;
                       idle_trans.bfm_no_lanes = 3;
                     end //}  
                  end //}
                  else if(env_config.num_of_lanes == 2)
                  begin//{
                   idle_trans.bfm_no_lanes = 2;
                   drive_1    = 1'b1;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_012  = 1'b0;
                   drive_12   = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
                  end //}
                  else
                  begin//{
                   idle_trans.bfm_no_lanes = 1;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_012  = 1'b0;
                   drive_12   = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
                  end //}
            end //}
            else if(!idle_config.nx_mode_support && !idle_config.x2_mode_support && idle_config.force_1x_mode_en && idle_trans.force_1x_mode && !(idle_config.force_laner_en && idle_trans.force_laneR))
            begin //{
                  if(env_config.num_of_lanes > 3)
                  begin//{
                     if(env_config.srio_mode == SRIO_GEN13)
                     begin//{
                       drive_1    = 1'b0;
                       drive_2    = 1'b0;
                       drive_0    = 1'b0;
                       drive_012  = 1'b0;
                       drive_02   = 1'b1;
                       drive_12   = 1'b0;
                       drive_01   = 1'b0;
                       idle_trans.bfm_no_lanes = 3;
                     end //}  
                     else 
                     begin//{
                       drive_1    = 1'b0;
                       drive_2    = 1'b0;
                       drive_0    = 1'b0;
                       drive_012  = 1'b1;
                       drive_12   = 1'b0;
                       drive_02   = 1'b0;
                       drive_01   = 1'b0;
                       idle_trans.bfm_no_lanes = 3;
                     end //}  
                  end //}
                  else if(env_config.num_of_lanes == 2)
                  begin//{
                   idle_trans.bfm_no_lanes = 2;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_012  = 1'b0;
                   drive_12   = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b1;
                  end //}
                  else
                  begin//{
                   idle_trans.bfm_no_lanes = 1;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_012  = 1'b0;
                   drive_12   = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
                  end //}
            end //}
           else if(idle_config.nx_mode_support && !idle_config.x2_mode_support)
           begin //{
                  idle_trans.bfm_no_lanes = env_config.num_of_lanes;
                  drive_0    = 1'b0;
                  drive_12   = 1'b0;
                  drive_012  = 1'b0;
                  drive_1    = 1'b0;
                  drive_2    = 1'b0;
                  drive_02   = 1'b0;
                  drive_01   = 1'b0;
                  if(idle_trans.current_init_state == SEEK)
                   begin//{
                    drive_02   = 1'b1;
                   end//}
                  if(idle_trans.current_init_state == DISCOVERY)
                   begin//{
                    drive_02   = 1'b0;
                   end//}
           end //}
            else if(!idle_config.nx_mode_support && idle_config.x2_mode_support && env_config.srio_mode != SRIO_GEN13)
            begin //{
                   idle_trans.bfm_no_lanes = 2;
                   drive_0    = 1'b0;
                   drive_12   = 1'b0;
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
            end //}
            else
            begin //{
                  idle_trans.bfm_no_lanes = env_config.num_of_lanes;
                  if(idle_trans.current_init_state == SEEK && env_config.srio_mode != SRIO_GEN13)
                   begin//{
                    drive_012   = 1'b1;
                   end//}
                  else if(idle_trans.current_init_state == SEEK ) 
                   begin//{
                    drive_02   = 1'b1;
                   end//}
                  if(idle_trans.current_init_state == DISCOVERY)
                   begin//{
                    drive_02   = 1'b0;
                    drive_012   = 1'b0;
                   end//}
            end //}

            if(idle_trans.port_initialized && idle_trans.current_init_state == NX_MODE)
            begin //{
                   idle_trans.bfm_no_lanes = env_config.num_of_lanes; 
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
            end //} 
            else if(idle_trans.port_initialized && idle_trans.current_init_state == X2_MODE)
            begin //{
                   idle_trans.bfm_no_lanes = 2;
                   drive_012  = 1'b0;
                   drive_1    = 1'b0;
                   drive_2    = 1'b0;
                   drive_0    = 1'b0;
                   drive_02   = 1'b0;
                   drive_01   = 1'b0;
            end //}
            else if(idle_trans.port_initialized && (idle_trans.current_init_state == X1_M0 || idle_trans.current_init_state == X1_M1 || idle_trans.current_init_state == X1_M2))
            begin //{
                  if(env_config.num_of_lanes > 3)
                   idle_trans.bfm_no_lanes = 3;
                  else
                  begin //{
                    if(env_config.num_of_lanes == 2 && idle_trans.current_init_state == X1_M0)
                     begin//{
                      idle_trans.bfm_no_lanes = 2;
                     end//}
                    else if(env_config.num_of_lanes == 2 && idle_trans.current_init_state == X1_M1)
                      idle_trans.bfm_no_lanes = 1;
                  end //} 

                   if(idle_trans.current_init_state == X1_M0 && idle_trans.bfm_no_lanes == 3)
                   begin //{
                     drive_012  = 1'b1;
                     drive_1    = 1'b0;
                     drive_2    = 1'b0;
                     drive_12   = 1'b0;
                     drive_0    = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                   end //}
                   else if(idle_trans.current_init_state == X1_M0 && idle_trans.bfm_no_lanes == 2)
                   begin //{
                     drive_012  = 1'b0;
                     drive_1    = 1'b0;
                     drive_2    = 1'b0;
                     drive_12   = 1'b0;
                     drive_0    = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b1;
                   end //}
                   else if(idle_trans.current_init_state == X1_M1)
                   begin //{
                     drive_1  = 1'b1;
                     drive_012    = 1'b0;
                     drive_2    = 1'b0;
                     drive_12   = 1'b0;
                     drive_0    = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                   end //}
                   else if(idle_trans.current_init_state == X1_M2)
                   begin //{
                     drive_2  = 1'b1;
                     drive_012    = 1'b0;
                     drive_1    = 1'b0;
                     drive_12   = 1'b0;
                     drive_0    = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                   end //}
               end //}
            else if(~idle_trans.port_initialized && idle_trans.current_init_state == X1_RECOVERY)
            begin //{
                  if(env_config.num_of_lanes > 3)
                  begin //{
                     idle_trans.bfm_no_lanes = 3;
                     drive_012  = 1'b1;
                     drive_1    = 1'b0;
                     drive_2    = 1'b0;
                     drive_12   = 1'b0;
                     drive_0    = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                  end //}
                  else
                  begin //{
                    if(env_config.num_of_lanes == 2 )
                    begin //{
                      idle_trans.bfm_no_lanes = 1;
                     drive_012  = 1'b0;
                     drive_1    = 1'b0;
                     drive_2    = 1'b0;
                     drive_0    = 1'b0;
                     drive_12   = 1'b0;
                     drive_02   = 1'b0;
                     drive_01   = 1'b0;
                    end //}
                    end //}
                  end //} 
            end //}


               if(idle_trans.bfm_idle_selected && idle_send_m && ~sendm_flag)
               begin //{
                  sendm_flag = 1'b1;
                  sendm_cnt  = 0;  
               end //}  
               else if(sendm_flag && idle_trans.bfm_idle_selected && sendm_cnt == 4)
               begin //{
                  sendm_flag = 1'b0;
                  sendm_cnt  = 0;  
               end //}
               else if(sendm_flag && idle_trans.bfm_idle_selected && sendm_cnt != 4)
               begin //{
                  sendm_cnt = sendm_cnt + 1;
               end //}

                if(idle_compen_done)
                   compen_cnt = idle_config.clk_compensation_seq_rate-200; 
                else if(~idle_compen_req)
                   compen_cnt = compen_cnt - 1;

                if(compen_cnt == 0  && ~idle_compen_done)
                   idle_compen_req = 1'b1;
                else if(idle_compen_req && ~idle_compen_done)
                   idle_compen_req = 1'b1;
                else if(idle_compen_req && idle_compen_done)
                begin //{
                   idle_compen_req = 1'b0;
                   idle_compen_done = 1'b0;  
                end //}     
                else if(idle_compen_done)
                begin //{
                  idle_compen_done = 1'b0;
                end //}

                // pkt and cs req logic
                if(pktcs_merge_ins.pktcs_proc_q.size != 0 && idle_trans.link_initialized && ~pkt_req_done && ~pkt_req && ~cs_req_done && ~cs_req)
                begin //{ 
                   for(int i=0;i< pktcs_merge_ins.pktcs_proc_q.size();i++)
                   begin //{
                       igen_pkt = new pktcs_merge_ins.pktcs_proc_q[i];
                       if(igen_pkt.m_type == MERGED_CS)
                       begin //{
                         cs_size = igen_pkt.bs_merged_cs.size();
                         if(cs_size==64 || cs_size==32)
                          TS_tx=1;
	                 if((cs_size/idle_trans.bfm_no_lanes)>0)
	        	 begin //{
	        	   if (idle_trans.bfm_no_lanes == 3)
                             cs_size = cs_size-1 ;
                           else if(idle_trans.bfm_no_lanes == 2 && idle_trans.current_init_state == X1_M0)
                             cs_size = cs_size-1 ;
	        	   else
                             cs_size = (cs_size/idle_trans.bfm_no_lanes)-1 ;
	        	 end //}
	                 else
                           cs_size = 0;
                         pktcs_merge_ins.pktcs_proc_q.delete(i);
                         if(~idle_config.multiple_ack_support)
                          begin//{                         
                           if (!once_flag)
                            begin//{
                             if(env_config.srio_mode!=SRIO_GEN13  && idle_trans.idle_selected) 
                              idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_cs[1][4:8],igen_pkt.bs_merged_cs[2][1]};
                             else
                              idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_cs[1][4:8]};
                             if(igen_pkt.bs_merged_cs[1][1:3]==0)
                              idle_trans.cpy_rx_ackid++;
                             once_flag=1;
                            end//}
                           else 
                            begin//{
                             /*if(igen_pkt.bs_merged_cs[1][1:3]!=3'b011)
                               begin//{            
                                if(env_config.srio_mode!=SRIO_GEN13 && idle_trans.idle_selected) 
                                 begin//{
                                  igen_pkt.bs_merged_cs[1][4:8]=idle_trans.cpy_rx_ackid[6:10];
                                  igen_pkt.bs_merged_cs[2][1]=idle_trans.cpy_rx_ackid[11];
                               end//}
                             else
                               igen_pkt.bs_merged_cs[1][4:8]=idle_trans.cpy_rx_ackid[7:11];
                             trans_push_ins=new();
                             if(env_config.srio_mode!=SRIO_GEN13  && idle_trans.idle_selected) 
                              begin//{
                                tmp_crc={igen_pkt.bs_merged_cs[1][1:8],igen_pkt.bs_merged_cs[2][1:8],igen_pkt.bs_merged_cs[3][1:5]};
                                cal_crc13=      trans_push_ins.calccrc13(tmp_crc);
                                igen_pkt.bs_merged_cs[5][4:8]=cal_crc13[0:4];
                                igen_pkt.bs_merged_cs[6][1:8]=cal_crc13[5:12];
                                idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_cs[1][4:8],igen_pkt.bs_merged_cs[2][1]};
                              end//}
                             else
                              begin//{
                               tmp_crc={1'b0,igen_pkt.bs_merged_cs[1][1:3],1'b0,igen_pkt.bs_merged_cs[1][4:8],1'b0,igen_pkt.bs_merged_cs[2][1:8],igen_pkt.bs_merged_cs[3][1:3]};
                               cal_crc5=      trans_push_ins.calccrc5(tmp_crc);
                               igen_pkt.bs_merged_cs[3][4:8]=cal_crc5;
                               idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_cs[1][4:8]};
                              end//}
                             if(igen_pkt.bs_merged_cs[1][1:3]==0)
                               idle_trans.cpy_rx_ackid++;
                             once_flag=1;
                            end//}
*/
                             if(env_config.srio_mode!=SRIO_GEN13  && idle_trans.idle_selected) 
                              begin//{
                               for(int k=0;k<igen_pkt.bs_merged_cs.size();k=k+8)
                                begin//{
                                 if(igen_pkt.bs_merged_cs[k+1][1:3]!=3'b011)
                                  begin//{            
                                   igen_pkt.bs_merged_cs[k+1][4:8]=idle_trans.cpy_rx_ackid[6:10];
                                   igen_pkt.bs_merged_cs[k+2][1]=idle_trans.cpy_rx_ackid[11];
                                  end//}            
                                  trans_push_ins=new();
                                  tmp_crc={igen_pkt.bs_merged_cs[k+1][1:8],igen_pkt.bs_merged_cs[k+2][1:8],igen_pkt.bs_merged_cs[k+3][1:5]};
                                  cal_crc13=      trans_push_ins.calccrc13(tmp_crc);
                                  igen_pkt.bs_merged_cs[k+5][4:8]=cal_crc13[0:4];
                                  igen_pkt.bs_merged_cs[k+6][1:8]=cal_crc13[5:12];
                                  idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_cs[k+1][4:8],igen_pkt.bs_merged_cs[k+2][1]};
                                  if(igen_pkt.bs_merged_cs[k+1][1:3]==0)
                                    idle_trans.cpy_rx_ackid++;
                                end//}
                              end//}
                             else
                              begin//{
                               for(int k=0;k<igen_pkt.bs_merged_cs.size();k=k+4)
                                begin//{
                                 if(igen_pkt.bs_merged_cs[k+1][1:3]!=3'b011)
                                   igen_pkt.bs_merged_cs[k+1][4:8]=idle_trans.cpy_rx_ackid[7:11];
                                 trans_push_ins=new();
                                 tmp_crc={1'b0,igen_pkt.bs_merged_cs[k+1][1:3],1'b0,igen_pkt.bs_merged_cs[k+1][4:8],1'b0,igen_pkt.bs_merged_cs[k+2][1:8],igen_pkt.bs_merged_cs[k+3][1:3]};
                                 cal_crc5=      trans_push_ins.calccrc5(tmp_crc);
                                 igen_pkt.bs_merged_cs[k+3][4:8]=cal_crc5;
                                 idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_cs[k+1][4:8]};
                                  if(igen_pkt.bs_merged_cs[k+1][1:3]==0)
                                    idle_trans.cpy_rx_ackid++;
                                end//}
                              end//}
                             once_flag=1;
                           end//}
                          end //}
                         else
                          begin//{
                             if(env_config.srio_mode!=SRIO_GEN13  && idle_trans.idle_selected) 
                              idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_cs[1][4:8],igen_pkt.bs_merged_cs[2][1]};
                             else
                              idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_cs[1][4:8]};
                          end //}
                         if(igen_pkt.cs_txt)
                         begin //{
                           for(int j=0;j< pktcs_merge_ins.pktcs_proc_q.size();j++)
                           begin //{
                               temp_merge_ins = new pktcs_merge_ins.pktcs_proc_q[j]; 
                               if(temp_merge_ins.cs_txt)
                                  pktcs_merge_ins.pktcs_proc_q.delete(j);
                              
                           end //}
                         end //}

                         if(igen_pkt.link_req_en == 1'b1 && idle_trans.bfm_idle_selected)
                         begin //{
                           cs_req = 1'b1;
                           descr_sync_req = 1'b1; 
                         end //} 
                         else if(igen_pkt.link_req_en == 1'b1 && ~idle_trans.bfm_idle_selected)
                         begin //{
                           cs_req = 1'b1;
                           descr_sync_req = 1'b0;
                         end //}
                         else if(igen_pkt.link_resp_en == 1'b1)
                         begin //{
                           cs_req = 1'b1;
                           idle_trans.ies_state = 1'b0; 
                           descr_sync_req = 1'b0; 
                         end //} 
                         else if(igen_pkt.rst_frm_rty_en == 1'b1)
                         begin //{
                           cs_req = 1'b1;
                           idle_trans.ors_state = 1'b0; 
                           descr_sync_req = 1'b0; 
                         end //} 
                         else
                         begin //{
                           cs_req = 1'b1;
                           pkt_req = 1'b0;
                         end //} 
                         `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_trans_transmit(igen_pkt,trans_push_ins))
                          if(igen_pkt.bs_merged_cs.size()==0)
                           cs_req = 1'b0;
                         break;
                       end //}
                       else if(igen_pkt.m_type == MERGED_PKT)
                       begin //{
                         pkt_size = igen_pkt.bs_merged_pkt.size();

                       if(~idle_config.multiple_ack_support)
                         begin//{                         
                         if (!once_flag)
                          begin//{
                           if(env_config.srio_mode!=SRIO_GEN13 && idle_trans.idle_selected) 
                            idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_pkt[1][4:8],igen_pkt.bs_merged_pkt[2][1]};
                           else
                            idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_pkt[1][4:8]};
                           if(igen_pkt.bs_merged_pkt[1][1:3]==0)
                             idle_trans.cpy_rx_ackid++;
                           once_flag=1;
                          end//}
                         else 
                          begin//{
                           if(env_config.srio_mode!=SRIO_GEN13  && idle_trans.idle_selected) 
                            begin//{
                             igen_pkt.bs_merged_pkt[1][4:8]=idle_trans.cpy_rx_ackid[6:10];
                             igen_pkt.bs_merged_pkt[2][1]=idle_trans.cpy_rx_ackid[11];
                            end//}
                           else
                             igen_pkt.bs_merged_pkt[1][4:8]=idle_trans.cpy_rx_ackid[7:11];
                           trans_push_ins=new();
                           if(env_config.srio_mode!=SRIO_GEN13  && idle_trans.idle_selected) 
                            begin//{
                             tmp_crc={igen_pkt.bs_merged_pkt[1][1:8],igen_pkt.bs_merged_pkt[2][1:8],igen_pkt.bs_merged_pkt[3][1:5]};
                             cal_crc13=      trans_push_ins.calccrc13(tmp_crc);
                             igen_pkt.bs_merged_pkt[5][4:8]=cal_crc13[0:4];
                             igen_pkt.bs_merged_pkt[6][1:8]=cal_crc13[5:12];
                             idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_pkt[1][4:8],igen_pkt.bs_merged_pkt[2][1]};
                             if(igen_pkt.bs_merged_pkt[1][1:3]==0)
                               idle_trans.cpy_rx_ackid++;
                             for(int j=8;j<igen_pkt.bs_merged_pkt.size();j++)
                              begin//{
                               if((igen_pkt.bs_merged_pkt[j]==9'h17c && igen_pkt.bs_merged_pkt[j+7]==9'h17c) || igen_pkt.bs_merged_pkt[j]==9'h11c && igen_pkt.bs_merged_pkt[j+7]==9'h11c )
                                begin//{
                                 igen_pkt.bs_merged_pkt[j+1][4:8]=idle_trans.cpy_rx_ackid[6:10];
                                 igen_pkt.bs_merged_pkt[j+2][1]=idle_trans.cpy_rx_ackid[11];
                                 trans_push_ins=new();
                                 tmp_crc={igen_pkt.bs_merged_pkt[j+1][1:8],igen_pkt.bs_merged_pkt[j+2][1:8],igen_pkt.bs_merged_pkt[j+3][1:5]};
                                 cal_crc13=      trans_push_ins.calccrc13(tmp_crc);
                                 igen_pkt.bs_merged_pkt[j+5][4:8]=cal_crc13[0:4];
                                 igen_pkt.bs_merged_pkt[j+6][1:8]=cal_crc13[5:12];
                                 if(igen_pkt.bs_merged_pkt[j+1][1:3]==0)
                                  idle_trans.cpy_rx_ackid++;
                                 j=j+7;
                                 //break;
                                end//}
                              end//}
                            end//}
                            else
                             begin//{
                             tmp_crc={1'b0,igen_pkt.bs_merged_pkt[1][1:3],1'b0,igen_pkt.bs_merged_pkt[1][4:8],1'b0,igen_pkt.bs_merged_pkt[2][1:8],igen_pkt.bs_merged_pkt[3][1:3]};
                             cal_crc5=      trans_push_ins.calccrc5(tmp_crc);
                             igen_pkt.bs_merged_pkt[3][4:8]=cal_crc5;
                             idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_pkt[1][4:8]};
                             if(igen_pkt.bs_merged_pkt[1][1:3]==0)
                               idle_trans.cpy_rx_ackid++;
                             for(int j=4;j<igen_pkt.bs_merged_pkt.size();j++)
                              begin//{
                               if(igen_pkt.bs_merged_pkt[j]==9'h17c ||  igen_pkt.bs_merged_pkt[j]==9'h11c )
                                begin//{
                                 igen_pkt.bs_merged_pkt[j+1][4:8]=idle_trans.cpy_rx_ackid[7:11];
                                 trans_push_ins=new();
                                 tmp_crc={1'b0,igen_pkt.bs_merged_pkt[j+1][1:3],1'b0,igen_pkt.bs_merged_pkt[j+1][4:8],1'b0,igen_pkt.bs_merged_pkt[j+2][1:8],igen_pkt.bs_merged_pkt[j+3][1:3]};
                                 cal_crc5=      trans_push_ins.calccrc5(tmp_crc);
                                 igen_pkt.bs_merged_pkt[j+3][4:8]=cal_crc5;
                                 if(igen_pkt.bs_merged_pkt[j+1][1:3]==0)
                                  idle_trans.cpy_rx_ackid++;
                                 j=j+3;
                                 //break;
                                end//}  
                              end //}

                             end//}
                           once_flag=1;
                           end//}
                         end//}
                        else
                         begin//{
                            if(env_config.srio_mode!=SRIO_GEN13 && idle_trans.idle_selected) 
                             idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_pkt[$-6][4:8],igen_pkt.bs_merged_pkt[$-5][1]};
                            else
                             idle_trans.cpy_rx_ackid ={igen_pkt.bs_merged_pkt[$-2][4:8]};
                          end//}
                          if(idle2_sel) 
	                   begin //{
                            for(int k=8;k<igen_pkt.bs_merged_pkt.size();k++)
	                     begin //{
                              if(igen_pkt.bs_merged_pkt[k]==9'h11c && igen_pkt.bs_merged_pkt[k+7]==9'h11c)
	                       begin //{
                                for(int j=k;j<=(k+7);j++)
                                 temp_array_cs.push_back(igen_pkt.bs_merged_pkt[j]);
                                k=k+7; 
	                       end //}
                              if(k==(igen_pkt.bs_merged_pkt.size()-1))
                               break;
                              if(igen_pkt.bs_merged_pkt[k]==9'h17c && igen_pkt.bs_merged_pkt[k+7]==9'h17c && (igen_pkt.bs_merged_pkt[k+1][1:3]!=4))
	                       begin //{
                                for(int j=k;j<=(k+7);j++)
	                         begin //{
                                 if(j==k || j==(k+7))
                                  lcl_cs_array.push_back(9'h11C);
                                 else
                                  lcl_cs_array.push_back(igen_pkt.bs_merged_pkt[j]);
	                         end //}
                                 lcl_cs_array[2][8]=1;
                                 lcl_cs_array[3][1:2]=2'h3;
                                 lcl_cs_array[3][3:5]=0;
                                 trans_push_ins=new();
                                 tmp_crc={lcl_cs_array[1][1:8],lcl_cs_array[2][1:8],lcl_cs_array[3][1:5]};
                                 cal_crc13=      trans_push_ins.calccrc13(tmp_crc);
                                 lcl_cs_array[5][4:8]=cal_crc13[0:4];
                                 lcl_cs_array[6][1:8]=cal_crc13[5:12];
                                 for(int l=0;l<lcl_cs_array.size();l++)
                                  temp_array_cs.push_back(lcl_cs_array[l]);
                                 k=k+7; 
                                 lcl_cs_array.delete();
	                        end //}
	                     end //}
	                   end //}
	                  else 
	                   begin //{
                            for(int k=4;k<igen_pkt.bs_merged_pkt.size();k++)
	                     begin //{
                              if(igen_pkt.bs_merged_pkt[k]==9'h11c)
	                       begin //{
                                for(int j=k;j<=(k+3);j++)
                                 temp_array_cs.push_back(igen_pkt.bs_merged_pkt[j]);
                                k=k+3; 
	                       end //}
                              if(igen_pkt.bs_merged_pkt[k]==9'h17c && (igen_pkt.bs_merged_pkt[k+1][1:3]!=4))
	                       begin //{
                                for(int j=k;j<=(k+3);j++)
	                         begin //{
                                 if(j==k)
                                  lcl_cs_array.push_back(9'h11C);
                                 else
                                  lcl_cs_array.push_back(igen_pkt.bs_merged_pkt[j]);
	                         end //}
                                 lcl_cs_array[2][6:8]=3'h3;
                                 lcl_cs_array[3][1:3]=0;
                                 trans_push_ins=new();
                                 tmp_crc={lcl_cs_array[1][1:8],lcl_cs_array[2][1:8],lcl_cs_array[3][1:5]};
                                 tmp_crc={1'b0,lcl_cs_array[1][1:3],1'b0,lcl_cs_array[1][4:8],1'b0,lcl_cs_array[2][1:8],lcl_cs_array[3][1:3]};
                                 cal_crc5=      trans_push_ins.calccrc5(tmp_crc);
                                 lcl_cs_array[3][4:8]=cal_crc5;
                                 for(int l=0;l<lcl_cs_array.size();l++)
                                  temp_array_cs.push_back(lcl_cs_array[l]);
                                 k=k+3; 
	                        end //}
	                     end //}
	                   end //}
                           if(idle_trans.ors_state || idle_trans.oes_state)
                            begin//{
                             index=0;
                             q_size=igen_pkt.bs_merged_pkt.size();
                              for(int k=0;k<q_size;k++)
	                       begin //{
                                if(igen_pkt.bs_merged_pkt.size()!=0 && (index<igen_pkt.bs_merged_pkt.size()))
                                  begin//{
                                   if(idle2_sel)
                                    begin//{ 
                                     if((igen_pkt.bs_merged_pkt[index]==9'h17C && (igen_pkt.bs_merged_pkt[index+7]==9'h17C)) && (igen_pkt.bs_merged_pkt[index+1][1:3]==0 || igen_pkt.bs_merged_pkt[index+1][1:3]==1 || igen_pkt.bs_merged_pkt[index+1][1:3]==2 || igen_pkt.bs_merged_pkt[index+1][1:3]==6  ))
                                       begin//{
                                         igen_pkt.bs_merged_pkt[index]=9'h11C;
                                         igen_pkt.bs_merged_pkt[index+7]=9'h11C;
                                         igen_pkt.bs_merged_pkt[index+2][8]=1; 
                                         igen_pkt.bs_merged_pkt[index+3][1:2]=2'h3; 
                                         igen_pkt.bs_merged_pkt[index+3][3:5]=0;
                                         trans_push_ins=new();
                                         tmp_crc={igen_pkt.bs_merged_pkt[index+1][1:8],igen_pkt.bs_merged_pkt[index+2][1:8],igen_pkt.bs_merged_pkt[index+3][1:5]};
                                         cal_crc13=      trans_push_ins.calccrc13(tmp_crc);
                                         igen_pkt.bs_merged_pkt[index+5][4:8]=cal_crc13[0:4];
                                         igen_pkt.bs_merged_pkt[index+6][1:8]=cal_crc13[5:12];
                                         index=index+8;
                                       end//}
                                     else if(igen_pkt.bs_merged_pkt[index]==9'h11C && igen_pkt.bs_merged_pkt[index+7]==9'h11C )
                                       begin//{
                                         index=index+8;
                                       end//}
                                     else
                                      igen_pkt.bs_merged_pkt.delete(index); 
                                   end//}
                                  else
                                   begin//{
                                     if(igen_pkt.bs_merged_pkt[index]==9'h17C && (igen_pkt.bs_merged_pkt[index+1][1:3]==0 || igen_pkt.bs_merged_pkt[index+1][1:3]==1 || igen_pkt.bs_merged_pkt[index+1][1:3]==2 || igen_pkt.bs_merged_pkt[index+1][1:3]==6   ))
                                       begin//{
                                         igen_pkt.bs_merged_pkt[index]=9'h11C;
                                         igen_pkt.bs_merged_pkt[index+2][6:8]=3'h7;
                                         igen_pkt.bs_merged_pkt[index+3][1:3]=0;
                                         trans_push_ins=new();
                                         tmp_crc={igen_pkt.bs_merged_pkt[index+1][1:8],igen_pkt.bs_merged_pkt[index+2][1:8],igen_pkt.bs_merged_pkt[index+3][1:5]};
                                         tmp_crc={1'b0,igen_pkt.bs_merged_pkt[index+1][1:3],1'b0,igen_pkt.bs_merged_pkt[index+1][4:8],1'b0,igen_pkt.bs_merged_pkt[index+2][1:8],igen_pkt.bs_merged_pkt[index+3][1:3]};
                                         cal_crc5=      trans_push_ins.calccrc5(tmp_crc);
                                         igen_pkt.bs_merged_pkt[3][4:8]=cal_crc5;
                                       end//}
                                     else if(igen_pkt.bs_merged_pkt[index]==9'h11C) 
                                       begin//{
                                         index=index+4;
                                       end//}
                                     else
                                      igen_pkt.bs_merged_pkt.delete(index); 
                                   end//}
                               end//}
                             end//}
                             if(igen_pkt.bs_merged_pkt.size()!=0)
                              pkt_contains_cs=1;
                            end//}
	                 if (idle_trans.bfm_no_lanes>4 && ((pkt_size%idle_trans.bfm_no_lanes) > 0))
	                 begin //{
                           pkt_size = (pkt_size/idle_trans.bfm_no_lanes) ;
	                 end //}
	                 else
	                 begin //{
	        	   if (idle_trans.bfm_no_lanes == 3)
                             pkt_size = pkt_size-1 ;
                           else if(idle_trans.bfm_no_lanes == 2 && idle_trans.current_init_state == X1_M0)
                             pkt_size = pkt_size-1 ;
	        	   else
                             pkt_size = (pkt_size/idle_trans.bfm_no_lanes)-1 ;
	                 end //}
                         pktcs_merge_ins.pktcs_proc_q.delete(i);
                         if(igen_pkt.bs_merged_pkt.size()!=0)
	                  begin //{
                           pkt_req = 1'b1;
                           cs_req = 1'b0;
	                  end //}
                         descr_sync_req = 1'b0; 
                         pktcs_merge_ins.pkt_avail_req = 1'b0;
                         if(pkt_size>compen_cnt)
                          idle_compen_req = 1'b1;
                         `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_trans_transmit(igen_pkt,trans_push_ins))
                         break;
                       end //}
                   end //}
                end //}
                else if(pktcs_merge_ins.pktcs_proc_q.size != 0 && ~idle_trans.link_initialized && idle_trans.port_initialized  && ~pkt_req_done && ~pkt_req && ~cs_req_done && ~cs_req)
                begin //{ 
                   for(int i=0;i< pktcs_merge_ins.pktcs_proc_q.size();i++)
                   begin //{
                       igen_pkt = new pktcs_merge_ins.pktcs_proc_q[i];
                       if(igen_pkt.m_type == MERGED_CS)
                       begin //{
                         cs_size = igen_pkt.bs_merged_cs.size();
	                 if((cs_size/idle_trans.bfm_no_lanes)>0)
	        	 begin //{
	        	   if (idle_trans.bfm_no_lanes == 3)
                             cs_size = cs_size-1 ;
                           else if(idle_trans.bfm_no_lanes == 2 && idle_trans.current_init_state == X1_M0)
                             cs_size = cs_size-1 ;
	        	   else
                             cs_size = (cs_size/idle_trans.bfm_no_lanes)-1 ;
	        	 end //}
	                 else
                           cs_size = 0;
                         pktcs_merge_ins.pktcs_proc_q.delete(i);
                         if(igen_pkt.link_req_en == 1'b1 && idle_trans.bfm_idle_selected)
                         begin //{
                           cs_req = 1'b1;
                           descr_sync_req = 1'b1; 
                         end //} 
                         else if(igen_pkt.link_req_en == 1'b1 && ~idle_trans.bfm_idle_selected)
                         begin //{
                           cs_req = 1'b1;
                           descr_sync_req = 1'b0;
                         end //}
                         else if(igen_pkt.link_resp_en == 1'b1)
                         begin //{
                           cs_req = 1'b1;
                           idle_trans.ies_state = 1'b0; 
                           descr_sync_req = 1'b0; 
                         end //} 
                         else if(igen_pkt.rst_frm_rty_en == 1'b1)
                         begin //{
                           cs_req = 1'b1;
                           idle_trans.ors_state = 1'b0; 
                           descr_sync_req = 1'b0; 
                         end //} 
                         else
                         begin //{
                           cs_req = 1'b1;
                           pkt_req = 1'b0;
                         end //} 
                        `uvm_do_callbacks(srio_pl_idle_gen, srio_pl_callback, srio_pl_trans_transmit(igen_pkt,trans_push_ins))
                         break;
                       end //}
                   end //}
                end //}
                else if(pkt_req && pkt_req_done && idle_trans.link_initialized)
                begin //{ 
                   pkt_req = 1'b0;
                   pkt_req_done = 1'b0;
//                   cs_req = 1'b0;
//                   cs_req_done = 1'b0;
                   pktcs_merge_ins.pkt_avail_req = 1'b1;
                end //}  
                else if(cs_req && cs_req_done && ~idle_trans.link_initialized && idle_trans.port_initialized)
                begin //{ 
                   cs_req = 1'b0;
                   cs_req_done = 1'b0;
                   pkt_req = 1'b0;
                   pkt_req_done = 1'b0;
                end //}  
                else if(cs_req && cs_req_done && idle_trans.link_initialized)
                begin //{ 
                   cs_req = 1'b0;
                   cs_req_done = 1'b0;
                   pkt_req = 1'b0;
                   pkt_req_done = 1'b0;
                end //}  

           end //} 
       end //}
    end //}
endtask : psr_gen


///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : idle_gen
/// Description : Task which forms the final queue for transmission on a per lane basis for 
/// IDLE1/2.
/// This queue will include IDLE1/2 sequence and stripped packet and control symbol
///////////////////////////////////////////////////////////////////////////////////////////////
  task srio_pl_idle_gen::idle_gen();
   bit new_cs=0;
   bit [3:0]stype0=0;
   bit [1:0]get_ack=0;
   int byte_cntr;
    forever
    begin //{
       @(posedge idle_trans.int_clk or negedge srio_if.srio_rst_n) 
       begin //{
        if(sen_state != state)
        begin
          sen_state = state;   
        end 
        if(~srio_if.srio_rst_n)
        begin //{
            byte_cntr=0;
            new_cs=0;
            get_ack=0;
            idle2_sel=0;
            state = IDLE_COMPEN;
            idle_cnt = 3;
            CS_tx=0;
            CS_g13=0;
            for(int i = 0;i< env_config.num_of_lanes;i++)
            begin //{ 
              idle_field_char[i] = 9'h1BC; 
              env_config.scramble_dis = 1'b1;
              csf_update  = 1'b0;
              oes_cnt     = 0;
            end //}
        end //}
        else 
        begin  //{     
            idle2_sel=idle_trans.idle_selected && env_config.srio_mode != SRIO_GEN30 && idle_trans.idle_detected;
            begin //{
             case(state)

             IDLE_NORMAL :  begin //{
                            if(idle_trans.bfm_idle_selected) 
                            begin //{
                            case(idle_cnt)
                                   10'd39,
                                   10'd38,
                                   10'd37,
                                   10'd36 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  idle_field_char[0] = 9'h1_3C;
                                                  idle_field_char[1] = 9'h1_3C;
                                                  idle_field_char[2] = 9'h1_3C;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  idle_field_char[0] = 9'h1_3C;
                                                  idle_field_char[1] = 9'h1_3C;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  idle_field_char[0] = 9'h1_3C;
                                                  idle_field_char[2] = 9'h1_3C;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  idle_field_char[1] = 9'h1_3C;
                                                //  idle_field_char[2] = 9'h1_3C;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  idle_field_char[1] = 9'h1_3C;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  idle_field_char[2] = 9'h1_3C;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = 9'h1_3C;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                               end //}  
                                            end //}
                                           end //} 
                                   10'd33,
                                   10'd35 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  idle_field_char[0] = 9'h0_B5;
                                                  idle_field_char[1] = 9'h0_B5;
                                                  idle_field_char[2] = 9'h0_B5;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  idle_field_char[0] = 9'h0_B5;
                                                  idle_field_char[1] = 9'h0_B5;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  idle_field_char[0] = 9'h0_B5;
                                                  idle_field_char[2] = 9'h0_B5;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  idle_field_char[1] = 9'h0_B5;
                                                 // idle_field_char[2] = 9'h0_B5;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  idle_field_char[1] = 9'h0_B5;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  idle_field_char[2] = 9'h0_B5;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = 9'h0_B5;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                               end //}
                                            end //}
                                           end //}
                                   10'd34 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csfield_array[0];
                                                  tmp1 = idle2_csfield_array[1];
                                                  tmp2 = idle2_csfield_array[2];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp1;
                                                  idle_field_char[2] = tmp2;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csfield_array[0];
                                                  tmp2 = idle2_csfield_array[2];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp2;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csfield_array[1];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csfield_array[1];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csfield_array[2];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csfield_array[i];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                               end //}
                                            end //}
                                          end //}

                                   10'd32 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csfield_neg_array[0];
                                                  tmp1 = idle2_csfield_neg_array[1];
                                                  tmp2 = idle2_csfield_neg_array[2];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp1;
                                                  idle_field_char[2] = tmp2;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csfield_neg_array[0];
                                                  tmp2 = idle2_csfield_neg_array[1];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp2;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csfield_neg_array[0];
                                                  tmp2 = idle2_csfield_neg_array[2];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp2;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csfield_neg_array[1];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csfield_neg_array[1];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csfield_neg_array[2];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csfield_neg_array[i];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b0;
                                               end //}
                                            end //}   
                                          end //}   

                                   10'd31 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[31];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[31];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[31];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[31];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[31];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[31];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[31];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd30 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[30];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[30];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[30];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[30];
                                                  idle_field_char[1] = tmp;
                                          //        idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[30];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[30];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[30];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd29 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[29];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[29];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[29];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[29];
                                                  idle_field_char[1] = tmp;
                                            //      idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[29];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[29];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[29];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd28 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[28];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[28];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[28];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[28];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[28];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[28];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[28];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd27 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[27];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[27];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[27];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[27];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[27];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[27];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[27];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd26 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[26];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[26];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[26];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[26];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[26];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[26];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[26];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd25 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[25];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[25];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[25];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[25];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[25];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[25];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[25];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd24 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[24];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[24];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[24];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[24];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[24];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[24];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[24];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd23 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[23];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[23];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[23];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[23];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[23];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[23];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[23];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd22 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[22];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[22];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[22];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[22];
                                                  idle_field_char[1] = tmp;
                                          //        idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[22];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[22];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[22];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd21 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp  = idle2_csf_marker_array[21];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp  = idle2_csf_marker_array[21];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp  = idle2_csf_marker_array[21];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[21];
                                                  idle_field_char[1] = tmp;
                                             //     idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp  = idle2_csf_marker_array[21];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp  = idle2_csf_marker_array[21];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[21];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd20 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[20];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[20];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[20];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[20];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[20];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[20];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[20];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd19 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[19];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[19];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[19];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[19];
                                                  idle_field_char[1] = tmp;
                                             //     idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[19];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[19];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[19];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd18 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[18];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[18];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[18];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[18];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[18];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[18];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[18];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd17 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[17];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[17];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[17];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[17];
                                                  idle_field_char[1] = tmp;
                                             //     idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[17];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[17];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[17];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd16 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[16];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[16];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[16];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[16];
                                                  idle_field_char[1] = tmp;
                                               //   idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[16];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[16];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[16];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                  10'd15 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[15];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[15];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[15];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[15];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[15];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[15];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[15];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd14 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[14];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[14];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[14];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[14];
                                                  idle_field_char[1] = tmp;
                                                 // idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[14];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[14];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[14];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd13 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[13];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[13];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[13];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[13];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[13];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[13];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[13];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd12 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[12];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[12];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[12];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[12];
                                                  idle_field_char[1] = tmp;
                                                 // idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[12];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[12];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[12];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd11 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[11];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[11];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[11];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[11];
                                                  idle_field_char[1] = tmp;
                                                  //idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[11];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[11];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[11];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd10 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[10];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[10];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[10];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[10];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[10];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[10];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[10];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd9 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[9];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[9];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[9];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[9];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[9];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[9];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[9];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd8 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[8];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[8];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[8];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[8];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[8];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[8];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[8];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                         end //}

                                   10'd7 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[7];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[7];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[7];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[7];
                                                  idle_field_char[1] = tmp;
                                               //   idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[7];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[7];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[7];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd6 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[6];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[6];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[6];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[6];
                                                  idle_field_char[1] = tmp;
                                               //   idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[6];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[6];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[6];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd5 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[5];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[5];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[5];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[5];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[5];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[5];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[5];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd4 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[4];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[4];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[4];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[4];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[4];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[4];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[4];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd3 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[3];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[3];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[3];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[3];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[3];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[3];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[3];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd2 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[2];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[2];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[2];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[2];
                                                  idle_field_char[1] = tmp;
                                                //  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[2];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[2];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[2];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                         end //}

                                   10'd1 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[1];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[1];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[1];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[1];
                                                  idle_field_char[1] = tmp;
                                                 // idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[1];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[1];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[1];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                          end //}

                                   10'd0 : begin //{
                                            if(drive_012)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[0];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_01)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[0];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_02)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[0];
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_12)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[0];
                                                  idle_field_char[1] = tmp;
                                                 // idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_1)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[0];
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else if(drive_2)
                                            begin //{
                                                  tmp = idle2_csf_marker_array[0];
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                            end //}  
                                            else
                                            begin //{
                                              for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                               begin //{
                                                  idle_field_char[i] = idle2_csf_marker_array[0];
                                                  env_config.scramble_dis = 1'b1;
                                                  csf_update  = 1'b1;
                                               end //}
                                            end //}
                                           end //}

                                    default : begin //{
                                                if(idle_send_a) 
                                                begin //{
                                                   if(drive_012)
                                                   begin //{
                                                         idle_field_char[0] = 9'h1_FB;
                                                         idle_field_char[1] = 9'h1_FB;
                                                         idle_field_char[2] = 9'h1_FB;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_01)
                                                   begin //{
                                                         idle_field_char[0] = 9'h1_FB;
                                                         idle_field_char[1] = 9'h1_FB;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_02)
                                                   begin //{
                                                         idle_field_char[0] = 9'h1_FB;
                                                         idle_field_char[2] = 9'h1_FB;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_12)
                                                   begin //{
                                                         idle_field_char[1] = 9'h1_FB;
                                                  //       idle_field_char[2] = 9'h1_FB;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_1)
                                                   begin //{
                                                         idle_field_char[1] = 9'h1_FB;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_2)
                                                   begin //{
                                                         idle_field_char[2] = 9'h1_FB;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else
                                                   begin //{
                                                      for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                                      begin //{
                                                       idle_field_char[i] = 9'h1FB;
                                                       env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                      end //}
                                                   end //}
                                                end //}
                                                else if(idle_send_m)
                                                begin //{
                                                   if(drive_012)
                                                   begin //{
                                                         idle_field_char[0] = 9'h1_3C;
                                                         idle_field_char[1] = 9'h1_3C;
                                                         idle_field_char[2] = 9'h1_3C;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_01)
                                                   begin //{
                                                         idle_field_char[0] = 9'h1_3C;
                                                         idle_field_char[1] = 9'h1_3C;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_02)
                                                   begin //{
                                                         idle_field_char[0] = 9'h1_3C;
                                                         idle_field_char[2] = 9'h1_3C;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_12)
                                                   begin //{
                                                         idle_field_char[1] = 9'h1_3C;
                                                   //      idle_field_char[2] = 9'h1_3C;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_1)
                                                   begin //{
                                                         idle_field_char[1] = 9'h1_3C;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_2)
                                                   begin //{
                                                         idle_field_char[2] = 9'h1_3C;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else
                                                   begin //{
                                                      for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                                      begin //{
                                                       idle_field_char[i] = 9'h13C;
                                                       env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                      end //}
                                                   end //}
                                                end //}
                                                else
                                                begin //{
                                                   if(drive_012)
                                                   begin //{
                                                         idle_field_char[0] = 9'h00;
                                                         idle_field_char[1] = 9'h00;
                                                         idle_field_char[2] = 9'h00;
                                                         env_config.scramble_dis = 1'b0;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_01)
                                                   begin //{
                                                         idle_field_char[0] = 9'h00;
                                                         idle_field_char[1] = 9'h00;
                                                         env_config.scramble_dis = 1'b0;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_02)
                                                   begin //{
                                                         idle_field_char[0] = 9'h00;
                                                         idle_field_char[2] = 9'h00;
                                                         env_config.scramble_dis = 1'b0;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_12)
                                                   begin //{
                                                         idle_field_char[1] = 9'h00;
                                                    //     idle_field_char[2] = 9'h00;
                                                         env_config.scramble_dis = 1'b1;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_1)
                                                   begin //{
                                                         idle_field_char[1] = 9'h00;
                                                         env_config.scramble_dis = 1'b0;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else if(drive_2)
                                                   begin //{
                                                         idle_field_char[2] = 9'h00;
                                                         env_config.scramble_dis = 1'b0;
                                                         csf_update  = 1'b0;
                                                   end //}  
                                                   else
                                                   begin //{
                                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                                     begin //{
                                                      idle_field_char[i] = 9'h00;
                                                      env_config.scramble_dis = 1'b0;
                                                         csf_update  = 1'b0;
                                                     end //}
                                                   end //}   
                                               end //}  
                                         end //}  
                                endcase

                             if(idle_compen_req  && idle_cnt==0/*&& idle_trans.link_initialized && ((idle_cnt > 39 && idle_cnt < 555) || (idle_cnt >=0 && idle_cnt <= 36))*/)
                             begin //{
                               if(sendm_flag && sendm_cnt == 0 && ~m_flag)
                               begin //{
                                 d0_cnt = 3;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 1 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 2 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 3 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 4 && ~m_flag)
                               begin //{
                                idle_cnt = 3;
                                state    = IDLE_COMPEN;
                                d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag && d0_cnt == 0)
                               begin //{
                                idle_cnt = 3;
                                state    = IDLE_COMPEN;
                                d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag)
                               begin //{
                                 d0_cnt = d0_cnt - 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else
                               begin //{
                                   idle_cnt = 3;
                                   state    = IDLE_COMPEN;
                               end //}
                             end //}
                            else if(idle_compen_req && ~idle_trans.link_initialized && idle_cnt == 0)
                               begin //{
                                   idle_cnt = 3;
                                   state    = IDLE_COMPEN;
                               end //}
                             else if(descr_sync_req /*&& idle_trans.link_initialized*/ && ((idle_cnt > 39 && idle_cnt < 555) || (idle_cnt >=0 && idle_cnt <= 36)))
                             begin //{
                               if(sendm_flag && sendm_cnt == 0 && ~m_flag)
                               begin //{
                                 d0_cnt = 3;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 1 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 2 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 3 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 4 && ~m_flag)
                               begin //{
                                   idle_cnt = 19;
                                state    = IDLE_DESCR_SYNC; 
                                d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag && d0_cnt == 0)
                               begin //{
                                   idle_cnt = 19;
                                state    = IDLE_DESCR_SYNC; 
                                d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag)
                               begin //{
                                 d0_cnt = d0_cnt - 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else
                               begin //{
                                   state    = IDLE_DESCR_SYNC;
                                   idle_cnt = 19;
                               end //}
                             end //} 
                             else if(idle_trans.link_initialized && cs_req && ((idle_cnt > 39 && idle_cnt < 555) || (idle_cnt >=0 && idle_cnt <= 36)))
                             begin //{
                               if(sendm_flag && sendm_cnt == 0 && ~m_flag)
                               begin //{
                                 d0_cnt = 3;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 1 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 2 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 3 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 4 && ~m_flag)
                               begin //{
                                      if (TS_tx)
                                       begin//{
                                        idle_cnt=cs_size;
                                        TS_tx=0;
                                       end//}
				 if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes > 4)
                                   idle_cnt = 0;
				 else if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes == 4)
                                   idle_cnt = 1;
				 else if (idle_trans.current_init_state == X2_MODE)
                                   idle_cnt = 3;
				 else
                                   idle_cnt = 7;
                                 //idle_cnt = 1;
                                state    = CS_STATE; 
                                d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag && d0_cnt == 0)
                               begin //{
				 if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes > 4)
                                   idle_cnt = 0;
				 else if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes == 4)
                                   idle_cnt = 1;
				 else if (idle_trans.current_init_state == X2_MODE)
                                   idle_cnt = 3;
				 else
                                   idle_cnt = 7;
                                //idle_cnt = 1;
                                state    = CS_STATE; 
                                d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag)
                               begin //{
                                 d0_cnt = d0_cnt - 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else
                               begin //{
                                  state    = CS_STATE;
				 if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes > 4)
                                   idle_cnt = 0;
				 else if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes == 4)
                                   idle_cnt = 1;
				 else if (idle_trans.current_init_state == X2_MODE)
                                   idle_cnt = 3;
				 else
                                   idle_cnt = 7;
                                  //idle_cnt = 1;
                               end //}
                             end //}
                             else if(idle_trans.link_initialized && pkt_req && ((idle_cnt > 39 && idle_cnt < 555) || (idle_cnt >=0 && idle_cnt <= 36)))
                             begin //{
                               if(sendm_flag && sendm_cnt == 0 && ~m_flag)
                               begin //{
                                 d0_cnt = 3;
                                 m_flag = 1;
                                 idle_cnt = idle_cnt - 1;
                                 state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 1 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 2 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                 idle_cnt = idle_cnt - 1;
                                 state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 3 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                 idle_cnt = idle_cnt - 1;
                                 state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 4 && ~m_flag)
                               begin //{
                                 idle_cnt = pkt_size;
                                state    = PKT_STATE; 
                                d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag && d0_cnt == 0)
                               begin //{
                                 idle_cnt = pkt_size;
                                 state    = PKT_STATE; 
                                 d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag)
                               begin //{
                                 d0_cnt = d0_cnt - 1;
                                 idle_cnt = idle_cnt - 1;
                                 state   = IDLE_NORMAL;
                               end //}
                               else
                               begin //{
                                  idle_cnt = pkt_size;
                                  state    = PKT_STATE; 
                               end //}
                             end //}
                             else if(~idle_trans.link_initialized  && idle_trans.port_initialized && cs_req && ((idle_cnt > 39 && idle_cnt < 555) || (idle_cnt >=0 && idle_cnt <= 36)))
                             begin //{
                               if(sendm_flag && sendm_cnt == 0 && ~m_flag)
                               begin //{
                                 d0_cnt = 3;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 1 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 2 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 3 && ~m_flag)
                               begin //{
                                 d0_cnt = 2;
                                 m_flag = 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else if(sendm_flag && sendm_cnt == 4 && ~m_flag)
                               begin //{
				 if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes > 4)
                                   idle_cnt = 0;
				 else if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes == 4)
                                   idle_cnt = 1;
				 else if (idle_trans.current_init_state == X2_MODE)
                                   idle_cnt = 3;
				 else
                                   idle_cnt = 7;
                                 //idle_cnt = 1;
                                state    = CS_STATE; 
                                d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag && d0_cnt == 0)
                               begin //{
				 if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes > 4)
                                   idle_cnt = 0;
				 else if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes == 4)
                                   idle_cnt = 1;
				 else if (idle_trans.current_init_state == X2_MODE)
                                   idle_cnt = 3;
				 else
                                   idle_cnt = 7;
                                //idle_cnt = 1;
                                state    = CS_STATE; 
                                d0_cnt   = 0;
                                 m_flag = 0;
                               end //}
                               else if(m_flag)
                               begin //{
                                 d0_cnt = d0_cnt - 1;
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}
                               else
                               begin //{
                                  state    = CS_STATE;
				 if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes > 4)
                                   idle_cnt = 0;
				 else if (idle_trans.current_init_state == NX_MODE && idle_trans.bfm_no_lanes == 4)
                                   idle_cnt = 1;
				 else if (idle_trans.current_init_state == X2_MODE)
                                   idle_cnt = 3;
				 else
                                   idle_cnt = 7;
                                  //idle_cnt = 1;
                               end //}
                             end //}
                             else
                             begin //{
                               if(idle_cnt == 0)
                               begin //{
                                 void'(choose_idle2_length());
                                 idle_cnt = idle2_seq_length;
                                 state   = IDLE_NORMAL;
                                 if(compen_cnt<=600)
                                  begin//{
                                   idle_cnt = 3;
                                   state   = IDLE_COMPEN;
                                  end//}
                               end //}   
                               else
                               begin //{
                                idle_cnt = idle_cnt - 1;
                                state   = IDLE_NORMAL;
                               end //}   
                             end //}   
                              end //}  
                              else 
                              begin //{
                               if(idle_send_a) 
                               begin //{
                                  if(drive_012)
                                  begin //{
                                        idle_field_char[0] = {1'b1,SRIO_A};
                                        idle_field_char[1] = {1'b1,SRIO_A};
                                        idle_field_char[2] = {1'b1,SRIO_A};
                                        env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                  end //}  
                                  else if(drive_01)
                                  begin //{
                                        idle_field_char[0] = {1'b1,SRIO_A};
                                        idle_field_char[1] = {1'b1,SRIO_A};
                                        env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                  end //}  
                                  else if(drive_02)
                                  begin //{
                                        idle_field_char[0] = {1'b1,SRIO_A};
                                        idle_field_char[2] = {1'b1,SRIO_A};
                                        env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                  end //}  
                                  else if(drive_12)
                                  begin //{
                                        idle_field_char[1] = {1'b1,SRIO_A};
                                   //     idle_field_char[2] = {1'b1,SRIO_A};
                                        env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                  end //}  
                                  else if(drive_1)
                                  begin //{
                                        idle_field_char[1] = {1'b1,SRIO_A};
                                        env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                  end //}  
                                  else if(drive_2)
                                  begin //{
                                        idle_field_char[2] = {1'b1,SRIO_A};
                                        env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                  end //}  
                                  else
                                  begin //{
                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                     begin //{
                                      idle_field_char[i] = {1'b1,SRIO_A};
                                      env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                     end //}
                                  end //}
                                end //}
                               else if(idle_send_k)
                               begin //{
                                 if(drive_012)
                                 begin //{
                                       idle_field_char[0] = {1'b1,SRIO_K};
                                       idle_field_char[1] = {1'b1,SRIO_K};
                                       idle_field_char[2] = {1'b1,SRIO_K};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                 else if(drive_01)
                                 begin //{
                                       idle_field_char[0] = {1'b1,SRIO_K};
                                       idle_field_char[1] = {1'b1,SRIO_K};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                 else if(drive_02)
                                 begin //{
                                       idle_field_char[0] = {1'b1,SRIO_K};
                                       idle_field_char[2] = {1'b1,SRIO_K};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                  else if(drive_12)
                                  begin //{
                                        idle_field_char[1] = {1'b1,SRIO_K};
                                     //   idle_field_char[2] = {1'b1,SRIO_K};
                                        env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                  end //}  
                                 else if(drive_1)
                                 begin //{
                                       idle_field_char[1] = {1'b1,SRIO_K};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                 else if(drive_2)
                                 begin //{
                                       idle_field_char[2] = {1'b1,SRIO_K};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                 else
                                 begin //{
                                    for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                    begin //{
                                     idle_field_char[i] = {1'b1,SRIO_K};
                                     env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                    end //}
                                 end //}
                               end //}
                               else if(idle_send_r)
                               begin //{
                                 if(drive_012)
                                 begin //{
                                       idle_field_char[0] = {1'b1,SRIO_R};
                                       idle_field_char[1] = {1'b1,SRIO_R};
                                       idle_field_char[2] = {1'b1,SRIO_R};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                 else if(drive_01)
                                 begin //{
                                       idle_field_char[0] = {1'b1,SRIO_R};
                                       idle_field_char[1] = {1'b1,SRIO_R};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                 else if(drive_02)
                                 begin //{
                                       idle_field_char[0] = {1'b1,SRIO_R};
                                       idle_field_char[2] = {1'b1,SRIO_R};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                  else if(drive_12)
                                  begin //{
                                        idle_field_char[1] = {1'b1,SRIO_R};
                                       // idle_field_char[2] = {1'b1,SRIO_R};
                                        env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                  end //}  
                                 else if(drive_1)
                                 begin //{
                                       idle_field_char[1] = {1'b1,SRIO_R};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                 else if(drive_2)
                                 begin //{
                                       idle_field_char[2] = {1'b1,SRIO_R};
                                       env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                 end //}  
                                 else
                                 begin //{
                                    for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                    begin //{
                                     idle_field_char[i] = {1'b1,SRIO_R};
                                     env_config.scramble_dis = 1'b0;
                                        csf_update  = 1'b0;
                                    end //}
                                 end //}
                              end //}
                             if(idle_compen_req )
                             begin //{
                                idle_cnt = 3;
                                state    = IDLE_COMPEN;
                             end //}
                             else if(idle_trans.link_initialized && cs_req)
                             begin //{
                                      if (TS_tx)
                                       begin//{
                                        idle_cnt=cs_size;
                                        TS_tx=0;
                                       end//}
                                  idle_cnt = cs_size;
                                  state    = CS_STATE; 
                             end //}
                             else if(idle_trans.link_initialized && pkt_req)
                             begin //{
                                  idle_cnt = pkt_size;
                                  state    = PKT_STATE; 
                             end //}
                             else if(~idle_trans.link_initialized && idle_trans.port_initialized && cs_req)
                             begin //{
                                  idle_cnt = cs_size;
                                  state    = CS_STATE; 
                             end //}
                             end //}
                           end //}

                                           
             IDLE_DESCR_SYNC         :  begin //{
                                         case( idle_cnt )
                                           10'd 19,
                                           10'd 14,
                                           10'd 9,
                                           10'd 4  : begin // {
                                                     if(drive_012)
                                                     begin //{
                                                           idle_field_char[0] = 9'h1_3C;
                                                           idle_field_char[1] = 9'h1_3C;
                                                           idle_field_char[2] = 9'h1_3C;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_01)
                                                     begin //{
                                                           idle_field_char[0] = 9'h1_3C;
                                                           idle_field_char[1] = 9'h1_3C;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_02)
                                                     begin //{
                                                           idle_field_char[0] = 9'h1_3C;
                                                           idle_field_char[2] = 9'h1_3C;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_12)
                                                     begin //{
                                                           idle_field_char[1] = 9'h1_3C;
                                                         //  idle_field_char[2] = 9'h1_3C;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_1)
                                                     begin //{
                                                           idle_field_char[1] = 9'h1_3C;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_2)
                                                     begin //{
                                                           idle_field_char[2] = 9'h1_3C;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else
                                                     begin //{
                                                       for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                                          begin //{
                                                           idle_field_char[i] = {1'b1,8'h3C};
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                          end //}
                                                       end //}
                                                     end //}
                                           default : begin //{
                                                     if(drive_012)
                                                     begin //{
                                                           idle_field_char[0] = 9'h0_00;
                                                           idle_field_char[1] = 9'h0_00;
                                                           idle_field_char[2] = 9'h0_00;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_01)
                                                     begin //{
                                                           idle_field_char[0] = 9'h0_00;
                                                           idle_field_char[1] = 9'h0_00;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_02)
                                                     begin //{
                                                           idle_field_char[0] = 9'h0_00;
                                                           idle_field_char[2] = 9'h0_00;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_12)
                                                     begin //{
                                                           idle_field_char[1] = 9'h00;
                                                         //  idle_field_char[2] = 9'h00;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_1)
                                                     begin //{
                                                           idle_field_char[1] = 9'h0_00;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else if(drive_2)
                                                     begin //{
                                                           idle_field_char[2] = 9'h0_00;
                                                           env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                     end //}  
                                                     else
                                                     begin //{
                                                     for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                                        begin //{
                                                         idle_field_char[i] = {1'b0,8'h00};
                                                         env_config.scramble_dis = 1'b0;
                                                           csf_update  = 1'b0;
                                                        end //}
                                                     end //}
                                                   end //}
                                           endcase
                                      if (TS_tx)
                                       begin//{
                                        idle_cnt=cs_size;
                                        TS_tx=0;
                                       end//}
                                        if(idle_cnt == 0)
                                        begin //{
                                           idle_cnt = cs_size;
                                           state    = CS_STATE;
                                        end //}
                                        else
                                        begin //{
                                           idle_cnt = idle_cnt - 1;
                                           state = IDLE_DESCR_SYNC;
                                        end //} 
              // `uvm_info("SRIO_IDLE_GEN : IDLE_GEN IDLE DESCR SYNC", $sformatf(" idle_cnt is %0d idle_field_char[0] is %0h idle_field_char[1] is %0h idle_field_char[2] is %0h idle_field_char[3] is %0h Present sync state is %0s", idle_cnt ,idle_field_char[0],idle_field_char[1],idle_field_char[2],idle_field_char[3],state.name()), UVM_LOW)
                                        end //}

             PKT_STATE              : begin //{
                                      if(drive_012)
                                      begin //{
                                          if(oes_flag)
                                          begin //{
                                            if(temp_array.size() != 0)
                                              begin //{
                                               tmp = temp_array.pop_front();
                                               idle_field_char[0] = tmp;
                                               idle_field_char[1] = tmp;
                                               idle_field_char[2] = tmp;
                                               env_config.scramble_dis = 1'b0;
                                               csf_update  = 1'b0;
                                               oes_cnt = 0;
                                               if(temp_array_cs.size() != 0)
                                                 idle_cnt=temp_array_cs.size();
                                               else
                                                 idle_cnt=temp_array.size();
                                               end //}
                                            else if(temp_array_cs.size() != 0)
                                               begin //{    
                                                  tmp = temp_array_cs.pop_front();
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[1] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                                  idle_cnt=temp_array_cs.size();
                                               end //}
                                          end //}
                                          else    
                                          begin //{
                                            if(igen_pkt.bs_merged_pkt.size() != 0)
                                              tmp = igen_pkt.bs_merged_pkt.pop_front();
                                            idle_field_char[0] = tmp;
                                            idle_field_char[1] = tmp;
                                            idle_field_char[2] = tmp;
                                            byte_cntr=byte_cntr+1;
                                            env_config.scramble_dis = 1'b0;
                                            csf_update  = 1'b0;
                                            oes_cnt = oes_cnt + 1;
                                            idle_cnt=igen_pkt.bs_merged_pkt.size();
                                            if(CS_tx && ((get_ack<2 && idle2_sel) || (!get_ack && !idle2_sel)))
                                             begin//{
                                              if(idle2_sel)
                                               begin//{
                                                if(!get_ack)
                                                 begin//{
                                                  lcl_cpy_ackid=tmp[4:8]<<1;
                                                  stype0=tmp[1:3];
                                                  if(temp_array_cs.size() != 0) 
                                                  begin //{
                                                    if(temp_array_cs[1]==tmp && byte_cntr>7)
                                                     begin//{
                                                      for(int h=0;h<8;h++)
                                                       temp_array_cs.delete(0); 
                                                     end//}
                                                   end//}
                                                 end//}
                                                else
                                                 lcl_cpy_ackid[0]=tmp[1];
                                                if(get_ack)
                                                 begin//{
                                                  get_ack=2;
                                                  if(!stype0)
                                                   void'(inc_lcl_cpy_ackid());
                                                 end//}
                                               end//}
                                              else
                                               begin//{
                                                 lcl_cpy_ackid=tmp[4:8];
                                                 if(!tmp[1:3])
                                                   void'(inc_lcl_cpy_ackid());
                                               end//}
                                              if(!get_ack)
                                               get_ack=1;
                                             end//}
                                            else if(!CS_tx)
                                             get_ack=0;
                                            if(!idle2_sel)
                                              begin//{
                                               if(CS_tx)
                                                CS_g13= {CS_g13[3:1],CS_tx} <<1;
                                               if(CS_g13[3])
                                                begin//{
                                                 CS_tx=0;
                                                 CS_g13=0;
                                                end//}
                                              end//}
                                            if(tmp==9'h17C || tmp==9'h11C)
                                              CS_tx=~CS_tx;
                                          end //}
                                      end //}  
                                      else if(drive_01)
                                      begin //{
                                          if(oes_flag)
                                          begin //{
                                            if(temp_array.size() != 0)
                                              begin //{
                                               tmp = temp_array.pop_front();
                                               idle_field_char[0] = tmp;
                                               idle_field_char[1] = tmp;
                                               env_config.scramble_dis = 1'b0;
                                               csf_update  = 1'b0;
                                               oes_cnt = 0;
                                               if(temp_array_cs.size() != 0)
                                                 idle_cnt=temp_array_cs.size();
                                               else
                                                 idle_cnt=temp_array.size();
                                               end //}
                                            else if(temp_array_cs.size() != 0)
                                               begin //{    
                                                  tmp = temp_array_cs.pop_front();
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                                  idle_cnt=temp_array_cs.size();
                                               end //}
                                          end //}
                                          else    
                                          begin //{
                                            if(igen_pkt.bs_merged_pkt.size() != 0)
                                              tmp = igen_pkt.bs_merged_pkt.pop_front();
                                            idle_field_char[0] = tmp;
                                            idle_field_char[1] = tmp;
                                            byte_cntr=byte_cntr+1;
                                            env_config.scramble_dis = 1'b0;
                                            csf_update  = 1'b0;
                                            oes_cnt = oes_cnt + 1;
                                            idle_cnt=igen_pkt.bs_merged_pkt.size();
                                            if(CS_tx && ((get_ack<2 && idle2_sel) || (!get_ack && !idle2_sel)))
                                             begin//{
                                              if(idle2_sel)
                                               begin//{
                                                if(!get_ack)
                                                 begin//{
                                                  lcl_cpy_ackid=tmp[4:8]<<1;
                                                  stype0=tmp[1:3];
                                                  if(temp_array_cs[1]==tmp && byte_cntr>7)
                                                   begin//{
                                                    for(int h=0;h<8;h++)
                                                     temp_array_cs.delete(0); 
                                                   end//}
                                                 end//}
                                                else
                                                 lcl_cpy_ackid[0]=tmp[1];
                                                if(get_ack)
                                                 begin//{
                                                  get_ack=2;
                                                  if(!stype0)
                                                   void'(inc_lcl_cpy_ackid());
                                                 end//}
                                               end//}
                                              else
                                               begin//{
                                                 lcl_cpy_ackid=tmp[4:8];
                                                 if(!tmp[1:3])
                                                   void'(inc_lcl_cpy_ackid());
                                               end//}
                                              if(!get_ack)
                                               get_ack=1;
                                             end//}
                                            else if(!CS_tx)
                                             get_ack=0;
                                            if(!idle2_sel)
                                              begin//{
                                               if(CS_tx)
                                                CS_g13= {CS_g13[3:1],CS_tx} <<1;
                                               if(CS_g13[3])
                                                begin//{
                                                 CS_tx=0;
                                                 CS_g13=0;
                                                end//}
                                              end//}
                                            if(tmp==9'h17C || tmp==9'h11C)
                                              CS_tx=~CS_tx;
                                          end //}
                                      end //}  
                                      else if(drive_02)
                                      begin //{
                                          if(oes_flag)
                                          begin //{
                                            if(temp_array.size() != 0)
                                              begin //{
                                               tmp = temp_array.pop_front();
                                               idle_field_char[0] = tmp;
                                               idle_field_char[2] = tmp;
                                               env_config.scramble_dis = 1'b0;
                                               csf_update  = 1'b0;
                                               oes_cnt = 0;
                                               if(temp_array_cs.size() != 0)
                                                 idle_cnt=temp_array_cs.size();
                                               else
                                                 idle_cnt=temp_array.size();
                                               end //}
                                            else if(temp_array_cs.size() != 0)
                                               begin //{    
                                                  tmp = temp_array_cs.pop_front();
                                                  idle_field_char[0] = tmp;
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                                  idle_cnt=temp_array_cs.size();
                                               end //}
                                          end //}
                                          else    
                                          begin //{
                                            if(igen_pkt.bs_merged_pkt.size() != 0)
                                              tmp = igen_pkt.bs_merged_pkt.pop_front();
                                            idle_field_char[0] = tmp;
                                            idle_field_char[2] = tmp;
                                            byte_cntr=byte_cntr+1;
                                            env_config.scramble_dis = 1'b0;
                                            csf_update  = 1'b0;
                                            oes_cnt = oes_cnt + 1;
                                            idle_cnt=igen_pkt.bs_merged_pkt.size();
                                            if(CS_tx && ((get_ack<2 && idle2_sel) || (!get_ack && !idle2_sel)))
                                             begin//{
                                              if(idle2_sel)
                                               begin//{
                                                if(!get_ack)
                                                 begin//{
                                                  lcl_cpy_ackid=tmp[4:8]<<1;
                                                  stype0=tmp[1:3];
                                                  if(temp_array_cs[1]==tmp && byte_cntr>7)
                                                   begin//{
                                                    for(int h=0;h<8;h++)
                                                     temp_array_cs.delete(0); 
                                                   end//}
                                                 end//}
                                                else
                                                 lcl_cpy_ackid[0]=tmp[1];
                                                if(get_ack)
                                                 begin//{
                                                  get_ack=2;
                                                  if(!stype0)
                                                   void'(inc_lcl_cpy_ackid());
                                                 end//}
                                               end//}
                                              else
                                               begin//{
                                                 lcl_cpy_ackid=tmp[4:8];
                                                 if(!tmp[1:3])
                                                   void'(inc_lcl_cpy_ackid());
                                               end//}
                                              if(!get_ack)
                                               get_ack=1;
                                             end//}
                                            else if(!CS_tx)
                                             get_ack=0;
                                            if(!idle2_sel)
                                              begin//{
                                               if(CS_tx)
                                                CS_g13= {CS_g13[3:1],CS_tx} <<1;
                                               if(CS_g13[3])
                                                begin//{
                                                 CS_tx=0;
                                                 CS_g13=0;
                                                end//}
                                              end//}
                                            if(tmp==9'h17C || tmp==9'h11C)
                                              CS_tx=~CS_tx;
                                          end //}
                                      end //}  
                                      else if(drive_12)
                                      begin //{
                                          if(oes_flag)
                                          begin //{
                                            if(temp_array.size() != 0)
                                              begin //{
                                               tmp = temp_array.pop_front();
                                               idle_field_char[1] = tmp;
                                         //      idle_field_char[2] = tmp;
                                               env_config.scramble_dis = 1'b0;
                                               csf_update  = 1'b0;
                                               oes_cnt = 0;
                                               if(temp_array_cs.size() != 0)
                                                 idle_cnt=temp_array_cs.size();
                                               else
                                                 idle_cnt=temp_array.size();
                                               end //}
                                               else if(temp_array_cs.size() != 0)
                                               begin //{    
                                                  tmp = temp_array_cs.pop_front();
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                                  idle_cnt=temp_array_cs.size();
                                               end //}
                                          end //}
                                          else    
                                          begin //{
                                            if(igen_pkt.bs_merged_pkt.size() != 0)
                                              tmp = igen_pkt.bs_merged_pkt.pop_front();
                                            idle_field_char[1] = tmp;
                                            byte_cntr=byte_cntr+1;
                                        //    idle_field_char[2] = tmp;
                                            env_config.scramble_dis = 1'b0;
                                            csf_update  = 1'b0;
                                            oes_cnt = oes_cnt + 1;
                                            idle_cnt=igen_pkt.bs_merged_pkt.size();
                                            if(CS_tx && ((get_ack<2 && idle2_sel) || (!get_ack && !idle2_sel)))
                                             begin//{
                                              if(idle2_sel)
                                               begin//{
                                                if(!get_ack)
                                                 begin//{
                                                  lcl_cpy_ackid=tmp[4:8]<<1;
                                                  stype0=tmp[1:3];
                                                  if(temp_array_cs[1]==tmp && byte_cntr>7)
                                                   begin//{
                                                    for(int h=0;h<8;h++)
                                                     temp_array_cs.delete(0); 
                                                   end//}
                                                 end//}
                                                else
                                                 lcl_cpy_ackid[0]=tmp[1];
                                                if(get_ack)
                                                 begin//{
                                                  get_ack=2;
                                                  if(!stype0)
                                                   void'(inc_lcl_cpy_ackid());
                                                 end//}
                                               end//}
                                              else
                                               begin//{
                                                 lcl_cpy_ackid=tmp[4:8];
                                                 if(!tmp[1:3])
                                                   void'(inc_lcl_cpy_ackid());
                                               end//}
                                              if(!get_ack)
                                               get_ack=1;
                                             end//}
                                            else if(!CS_tx)
                                             get_ack=0;
                                            if(!idle2_sel)
                                              begin//{
                                               if(CS_tx)
                                                CS_g13= {CS_g13[3:1],CS_tx} <<1;
                                               if(CS_g13[3])
                                                begin//{
                                                 CS_tx=0;
                                                 CS_g13=0;
                                                end//}
                                              end//}
                                            if(tmp==9'h17C || tmp==9'h11C)
                                              CS_tx=~CS_tx;
                                          end //}
                                      end //}  
                                      else if(drive_1)
                                      begin //{
                                          if(oes_flag)
                                          begin //{
                                            if(temp_array.size() != 0)
                                             begin //{
                                               tmp = temp_array.pop_front();
                                               idle_field_char[1] = tmp;
                                               env_config.scramble_dis = 1'b0;
                                               csf_update  = 1'b0;
                                               oes_cnt = 0;
                                               if(temp_array_cs.size() != 0)
                                                 idle_cnt=temp_array_cs.size();
                                               else
                                                 idle_cnt=temp_array.size();
                                               end //}
                                               else if(temp_array_cs.size() != 0)
                                               begin //{    
                                                  tmp = temp_array_cs.pop_front();
                                                  idle_field_char[1] = tmp;
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                                  idle_cnt=temp_array_cs.size();
                                               end //}
                                          end //}
                                          else    
                                          begin //{
                                            if(igen_pkt.bs_merged_pkt.size() != 0)
                                              tmp = igen_pkt.bs_merged_pkt.pop_front();
                                            byte_cntr=byte_cntr+1;
                                            idle_field_char[1] = tmp;
                                            env_config.scramble_dis = 1'b0;
                                            csf_update  = 1'b0;
                                            oes_cnt = oes_cnt + 1;
                                            idle_cnt=igen_pkt.bs_merged_pkt.size();
                                            if(CS_tx && ((get_ack<2 && idle2_sel) || (!get_ack && !idle2_sel)))
                                             begin//{
                                              if(idle2_sel)
                                               begin//{
                                                if(!get_ack)
                                                 begin//{
                                                  lcl_cpy_ackid=tmp[4:8]<<1;
                                                  stype0=tmp[1:3];
                                                  if(temp_array_cs[1]==tmp && byte_cntr>7)
                                                   begin//{
                                                    for(int h=0;h<8;h++)
                                                     temp_array_cs.delete(0); 
                                                   end//}
                                                 end//}
                                                else
                                                 lcl_cpy_ackid[0]=tmp[1];
                                                if(get_ack)
                                                 begin//{
                                                  get_ack=2;
                                                  if(!stype0)
                                                   void'(inc_lcl_cpy_ackid());
                                                 end//}
                                               end//}
                                              else
                                               begin//{
                                                 lcl_cpy_ackid=tmp[4:8];
                                                 if(!tmp[1:3])
                                                   void'(inc_lcl_cpy_ackid());
                                               end//}
                                              if(!get_ack)
                                               get_ack=1;
                                             end//}
                                            else if(!CS_tx)
                                             get_ack=0;
                                            if(!idle2_sel)
                                              begin//{
                                               if(CS_tx)
                                                CS_g13= {CS_g13[3:1],CS_tx} <<1;
                                               if(CS_g13[3])
                                                begin//{
                                                 CS_tx=0;
                                                 CS_g13=0;
                                                end//}
                                              end//}
                                            if(tmp==9'h17C || tmp==9'h11C)
                                              CS_tx=~CS_tx;
                                          end //}
                                      end //}  
                                      else if(drive_2)
                                      begin //{
                                          if(oes_flag)
                                          begin //{
                                            if(temp_array.size() != 0)
                                              begin//{
                                               tmp = temp_array.pop_front();
                                               idle_field_char[2] = tmp;
                                               env_config.scramble_dis = 1'b0;
                                               csf_update  = 1'b0;
                                               oes_cnt = 0;
                                               if(temp_array_cs.size() != 0)
                                                 idle_cnt=temp_array_cs.size();
                                               else
                                                 idle_cnt=temp_array.size();
                                               end //}
                                               else if(temp_array_cs.size() != 0)
                                               begin //{    
                                                  tmp = temp_array_cs.pop_front();
                                                  idle_field_char[2] = tmp;
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                                  idle_cnt=temp_array_cs.size();
                                               end //}
                                          end //}
                                          else    
                                          begin //{
                                            if(igen_pkt.bs_merged_pkt.size() != 0)
                                              tmp = igen_pkt.bs_merged_pkt.pop_front();
                                            byte_cntr=byte_cntr+1;
                                            idle_field_char[2] = tmp;
                                            env_config.scramble_dis = 1'b0;
                                            csf_update  = 1'b0;
                                            oes_cnt = oes_cnt + 1;
                                            idle_cnt=igen_pkt.bs_merged_pkt.size();
                                            if(CS_tx && ((get_ack<2 && idle2_sel) || (!get_ack && !idle2_sel)))
                                             begin//{
                                              if(idle2_sel)
                                               begin//{
                                                if(!get_ack)
                                                 begin//{
                                                  lcl_cpy_ackid=tmp[4:8]<<1;
                                                  stype0=tmp[1:3];
                                                  if(temp_array_cs[1]==tmp && byte_cntr>7)
                                                   begin//{
                                                    for(int h=0;h<8;h++)
                                                     temp_array_cs.delete(0); 
                                                   end//}
                                                 end//}
                                                else
                                                 lcl_cpy_ackid[0]=tmp[1];
                                                if(get_ack)
                                                 begin//{
                                                  get_ack=2;
                                                  if(!stype0)
                                                   void'(inc_lcl_cpy_ackid());
                                                 end//}
                                               end//}
                                              else
                                               begin//{
                                                 lcl_cpy_ackid=tmp[4:8];
                                                 if(!tmp[1:3])
                                                   void'(inc_lcl_cpy_ackid());
                                               end//}
                                              if(!get_ack)
                                               get_ack=1;
                                             end//}
                                            else if(!CS_tx)
                                             get_ack=0;
                                            if(!idle2_sel)
                                              begin//{
                                               if(CS_tx)
                                                CS_g13= {CS_g13[3:1],CS_tx} <<1;
                                               if(CS_g13[3])
                                                begin//{
                                                 CS_tx=0;
                                                 CS_g13=0;
                                                end//}
                                              end//}
                                            if(tmp==9'h17C || tmp==9'h11C)
                                              CS_tx=~CS_tx;
                                          end //}
                                      end //}  
                                      else
                                      begin //{
                                          if(oes_flag)
                                          begin //{
                                            oes_cnt = 0;
                                            for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                            begin //{
                                               if(temp_array.size() != 0)
                                               begin //{    
                                                  idle_field_char[i] = temp_array.pop_front();
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                                  if(temp_array_cs.size() != 0)
                                                    idle_cnt=temp_array_cs.size();
                                                  else
                                                    idle_cnt=temp_array.size();
                                               end //}
                                               else if(temp_array_cs.size() != 0)
                                               begin //{    
                                                  idle_field_char[i] = temp_array_cs.pop_front();
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                                  idle_cnt=temp_array_cs.size();
                                               end //}
                                               else
                                               begin //{
                                                  idle_field_char[i] = 9'b0; 
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                               end  //}
                                            end  //}
                                          end //}
                                          else
                                          begin //{
                                            for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                            begin //{
                                               if(igen_pkt.bs_merged_pkt.size() != 0)
                                               begin //{    
                                                  byte_cntr=byte_cntr+1;
                                                  idle_field_char[i] = igen_pkt.bs_merged_pkt.pop_front();
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                                  if(CS_tx && ((get_ack<2 && idle2_sel) || (!get_ack && !idle2_sel)))
                                                   begin//{
                                                    if(idle2_sel)
                                                     begin//{
                                                      if(!get_ack)
                                                       begin//{
                                                        lcl_cpy_ackid=idle_field_char[i][4:8]<<1;
                                                        stype0=idle_field_char[i][1:3];
                                                        if(temp_array_cs.size() != 0) 
                                                        begin //{
                                                          if(temp_array_cs[1]==idle_field_char[i] && byte_cntr>7)
                                                           begin//{
                                                            for(int h=0;h<8;h++)
                                                             temp_array_cs.delete(0); 
                                                           end//}
                                                         end//}
                                                       end//}
                                                      else
                                                       lcl_cpy_ackid[0]=idle_field_char[i][1];
                                                      if(get_ack)
                                                       begin//{
                                                        get_ack=2;
                                                        if(stype0==0)
                                                         void'(inc_lcl_cpy_ackid());
                                                       end//}
                                                     end//}
                                                    else
                                                     begin//{
                                                       lcl_cpy_ackid=idle_field_char[i][4:8];
                                                        if(temp_array_cs.size() != 0) 
                                                        begin //{
                                                         if(temp_array_cs[1]==idle_field_char[i] && byte_cntr>3)
                                                          begin//{
                                                           for(int h=0;h<4;h++)
                                                            temp_array_cs.delete(0); 
                                                          end//}
                                                        end//}
                                                       if(idle_field_char[i][1:3]==0)
                                                        void'(inc_lcl_cpy_ackid());
                                                     end//}
                                                    if(!get_ack)
                                                     get_ack=1;
                                                   end//}
                                                  else if(!CS_tx)
                                                   get_ack=0;
                                                  if(!idle2_sel)
                                                    begin//{
                                                     if(CS_tx)
                                                      CS_g13= {CS_g13[3:1],CS_tx} <<1;
                                                     if(CS_g13[3])
                                                      begin//{
                                                       CS_tx=0;
                                                       CS_g13=0;
                                                      end//}
                                                    end//}
                                                  if(idle_field_char[i]==9'h17C || idle_field_char[i]==9'h11C)
                                                    CS_tx=~CS_tx;
                                               end //}
                                               else
                                               begin //{
                                                  idle_field_char[i] = 9'b0; 
                                                  env_config.scramble_dis = 1'b0;
                                                  csf_update  = 1'b0;
                                               end  //}
                                            end  //}
                                             idle_cnt=igen_pkt.bs_merged_pkt.size();
                                            oes_cnt = oes_cnt + 1;
                                          end //}
                                     end //} 
                                     if(descr_sync_req && idle_cnt == 0 )
                                     begin //{
                                        pkt_req_done = 1;
                                        state = IDLE_DESCR_SYNC;
                                        idle_cnt = 19;
                                        oes_flag = 1'b0;
                                        state_exit = 1'b1;
					oes_cnt = 0;
                                        byte_cntr = 0;
                                        pkt_contains_cs=0; 
                                     end //}
                                     else if(idle_compen_req && idle_cnt == 0)
                                     begin //{
                                        pkt_req_done = 1;
                                        state = IDLE_COMPEN;
                                        idle_cnt = 3;
                                        oes_flag = 1'b0;
                                        state_exit = 1'b1;
                                        oes_cnt = 0;
                                        byte_cntr = 0;
                                     end //}
                                     else if(idle_cnt == 0)
                                     begin //{
                                        pkt_req_done = 1;
                                        state = IDLE_NORMAL;
                                        void'(choose_idle2_length());
                                        idle_cnt = idle2_seq_length;
                                        oes_flag = 1'b0;
                                        state_exit = 1'b1;
                                        oes_cnt = 0;
                                        byte_cntr = 0;
                                        /*state = IDLE_NORMAL;
                                        void'(choose_idle2_length());
                                        idle_cnt = idle2_seq_length;
                                        if(compen_cnt<=600)*/
                                         begin//{
                                          idle_cnt = 3;
                                          state   = IDLE_COMPEN;
                                         end//}
                                     end //}
                                     else
                                     begin //{
                                         idle_cnt = idle_cnt - 1;
                                         state    = PKT_STATE; 
                                     end //}
                                     if((idle_trans.oes_state || idle_trans.ors_state) && ~oes_flag && ~state_exit && ~pkt_contains_cs)
                                      begin //{
                                       if(((idle_trans.bfm_no_lanes == 2 && idle_trans.bfm_idle_selected && oes_cnt > 5 ) || (idle_trans.bfm_no_lanes == 2 && ~idle_trans.bfm_idle_selected && oes_cnt > 3 ) || (idle_trans.bfm_no_lanes == 1 && idle_trans.bfm_idle_selected && oes_cnt > 10 ) || (idle_trans.bfm_no_lanes == 1 && ~idle_trans.bfm_idle_selected && oes_cnt > 6 ) || (idle_trans.bfm_no_lanes == 4 && oes_cnt > 2 ) || (idle_trans.bfm_no_lanes >= 8 && idle_trans.bfm_idle_selected && oes_cnt > 1 )) && ((igen_pkt.bs_merged_pkt.size() > 8 && idle_trans.bfm_idle_selected) || igen_pkt.bs_merged_pkt.size() > 4 && ~idle_trans.bfm_idle_selected)  && !CS_tx)
                                       begin //{ 
                                        if(pktcs_merge_ins.pktcs_proc_q.size()!=0)
                                         begin//{
                                          temp_merge_ins = new pktcs_merge_ins.pktcs_proc_q[0];
                                          new_cs=1;
                                         end//}
                                          if(new_cs==1 &&temp_merge_ins.m_type == MERGED_CS && (({temp_merge_ins.bs_merged_cs[2][8],temp_merge_ins.bs_merged_cs[3][1:2]}==3 && idle2_sel ) || ((temp_merge_ins.bs_merged_cs[2][6:8]==3  || temp_merge_ins.bs_merged_cs[2][6:8]==4 )&& !idle2_sel)))
                                           begin//{
                                            new_cs=0;
                                            pktcs_merge_ins.pktcs_proc_q.delete(0);
                                            for(int k=0;k<temp_merge_ins.bs_merged_cs.size();k++)
                                            begin//{
                                             if(k==0 || (k==(temp_merge_ins.bs_merged_cs.size()-1) && idle2_sel))
                                              temp_array.push_back(9'h17C);
                                             else
                                              temp_array.push_back(temp_merge_ins.bs_merged_cs[k]);
                                            end//}
                                            if((temp_merge_ins.bs_merged_cs[2][6:8]==3 && !idle2_sel) || ({temp_merge_ins.bs_merged_cs[2][8],temp_merge_ins.bs_merged_cs[3][1:2]}==3 && idle2_sel))
                                             idle_trans.ors_state = 1'b0; 
                                            oes_cnt = 0; 
                                            oes_flag = 1'b1;
                                            oes_size = temp_array.size();
                                            if((oes_size/idle_trans.bfm_no_lanes)>0)
                                            begin //{
                                              if (idle_trans.bfm_no_lanes == 3)
                                               oes_size  = oes_size-1 ;
                                              else if(idle_trans.bfm_no_lanes == 2 && idle_trans.current_init_state == X1_M0)
                                               oes_size  = oes_size-1 ;
                                              else 
                                                oes_size = (oes_size/idle_trans.bfm_no_lanes)-1 ;
                                            end //}
                                            else 
                                              oes_size = 0; 
                                              idle_cnt = oes_size;
                                           end//}
                                          else if(new_cs==1 && temp_merge_ins.m_type == MERGED_CS && ({temp_merge_ins.bs_merged_cs[2][8],temp_merge_ins.bs_merged_cs[3][1:2]}==4 && idle2_sel))
                                          begin//{
                                           new_cs=0; 
                                           oes_flag = 1'b1;
                                           igen_pkt = new pktcs_merge_ins.pktcs_proc_q[0];
                                           igen_pkt.bs_merged_cs[0]=9'h17C;
                                           igen_pkt.bs_merged_cs[$]=9'h17C;
                                           pktcs_merge_ins.pktcs_proc_q.delete(0);
                                           cs_req = 1'b1;
                                           descr_sync_req = 1'b1; 
                                           idle_cnt=0;
                                          end//}
                                        else
                                         begin//{
                                           new_cs=0; 
                                           gen_stomp_cs();
                                           for(int i=0;i<trans_push_ins.bytestream_cs.size();i++)
                                           begin //{ 
                                            if(i == 0)
                                             temp_array.push_back({1'b1,trans_push_ins.bytestream_cs[i]});
                                            else if(i == trans_push_ins.bytestream_cs.size()-1 && idle_trans.bfm_idle_selected)
                                             temp_array.push_back({1'b1,trans_push_ins.bytestream_cs[i]});
                                            else
                                             temp_array.push_back({1'b0,trans_push_ins.bytestream_cs[i]});
                                           end //}

                                           oes_cnt = 0; 
                                           oes_flag = 1'b1;
                                           oes_size = temp_array.size();
                                           if((oes_size/idle_trans.bfm_no_lanes)>0)
                                           begin //{
                                             if (idle_trans.bfm_no_lanes == 3)
                                              oes_size  = oes_size-1 ;
                                             else if(idle_trans.bfm_no_lanes == 2 && idle_trans.current_init_state == X1_M0)
                                              oes_size  = oes_size-1 ;
                                             else 
                                               oes_size = (oes_size/idle_trans.bfm_no_lanes)-1 ;
                                           end //}
                                           else 
                                             oes_size = 0; 
                                             idle_cnt = oes_size;
                                           end//}
                                       end //} 
                                      end //}
                                     if(state_exit)
                                         state_exit = 1'b0;
                                     end //}  
                          
             CS_STATE              : begin //{
                                      if(drive_012)
                                      begin //{
                                          if(igen_pkt.bs_merged_cs.size() != 0)
                                            tmp =  igen_pkt.bs_merged_cs.pop_front();
                                          idle_field_char[0] = tmp;
                                          idle_field_char[1] = tmp;
                                          idle_field_char[2] = tmp;
                                          env_config.scramble_dis = 1'b0;
                                          csf_update  = 1'b0;
                                      end //}  
                                      else if(drive_01)
                                      begin //{
                                          if(igen_pkt.bs_merged_cs.size() != 0)
                                            tmp =  igen_pkt.bs_merged_cs.pop_front();
                                          idle_field_char[0] = tmp;
                                          idle_field_char[1] = tmp;
                                          env_config.scramble_dis = 1'b0;
                                          csf_update  = 1'b0;
                                      end //}  
                                      else if(drive_02)
                                      begin //{
                                          if(igen_pkt.bs_merged_cs.size() != 0)
                                            tmp =  igen_pkt.bs_merged_cs.pop_front();
                                          idle_field_char[0] = tmp;
                                          idle_field_char[2] = tmp;
                                          env_config.scramble_dis = 1'b0;
                                          csf_update  = 1'b0;
                                      end //}  
                                      else if(drive_12)
                                      begin //{
                                          if(igen_pkt.bs_merged_cs.size() != 0)
                                            tmp =  igen_pkt.bs_merged_cs.pop_front();
                                          idle_field_char[1] = tmp;
                                       //   idle_field_char[2] = tmp;
                                          env_config.scramble_dis = 1'b0;
                                          csf_update  = 1'b0;
                                      end //}  
                                      else if(drive_1)
                                      begin //{
                                          if(igen_pkt.bs_merged_cs.size() != 0)
                                            tmp =  igen_pkt.bs_merged_cs.pop_front();
                                          idle_field_char[1] = tmp;
                                          env_config.scramble_dis = 1'b0;
                                          csf_update  = 1'b0;
                                      end //}  
                                      else if(drive_2)
                                      begin //{
                                          if(igen_pkt.bs_merged_cs.size() != 0)
                                            tmp =  igen_pkt.bs_merged_cs.pop_front();
                                          idle_field_char[2] = tmp;
                                          env_config.scramble_dis = 1'b0;
                                          csf_update  = 1'b0;
                                      end //}  
                                      else
                                      begin //{
                                        for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                        begin //{
                                          if(igen_pkt.bs_merged_cs.size() != 0)
                                          begin //{
                                             idle_field_char[i] = igen_pkt.bs_merged_cs.pop_front();
                                             env_config.scramble_dis = 1'b0;
                                          csf_update  = 1'b0;
                                          end //}
                                          else
                                          begin //{
                                           idle_field_char[i] = 9'b0; 
                                             env_config.scramble_dis = 1'b0;
                                          csf_update  = 1'b0;
                                          end //}
                                        end //}
                                      end //}
                                      idle_cnt=igen_pkt.bs_merged_cs.size();
                                      if (TS_tx)
                                       begin//{
                                        idle_cnt=cs_size;
                                        TS_tx=0;
                                       end//}
                                      if(idle_compen_req && idle_cnt == 0)
                                      begin //{
                                         cs_req_done = 1;
                                         descr_sync_req = 0;
                                         state = IDLE_COMPEN;
                                         idle_cnt = 3;
                                      end //}
                                      else if(idle_cnt == 0)
                                      begin //{
                                         cs_req_done = 1;
                                         descr_sync_req = 0;
                                         state = IDLE_NORMAL;
                                         void'(choose_idle2_length());
                                         idle_cnt = idle2_seq_length;
                                         if(compen_cnt<=3000)
                                          begin//{
                                           idle_cnt = 3;
                                           state   = IDLE_COMPEN;
                                          end//}
                                      end //}
                                      else
                                      begin //{
                                          idle_cnt = idle_cnt - 1;
                                          state    = CS_STATE; 
                                      end //}
                                      end //}  

             IDLE_COMPEN            : begin //{
                                        case( idle_cnt )
                                            10'd3  :  begin // {
                                                      if(drive_012)
                                                      begin //{
                                                            idle_field_char[0] = 9'h1_BC;
                                                            idle_field_char[1] = 9'h1_BC;
                                                            idle_field_char[2] = 9'h1_BC;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_01)
                                                      begin //{
                                                            idle_field_char[0] = 9'h1_BC;
                                                            idle_field_char[1] = 9'h1_BC;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_02)
                                                      begin //{
                                                            idle_field_char[0] = 9'h1_BC;
                                                            idle_field_char[2] = 9'h1_BC;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_012)
                                                      begin //{
                                                            idle_field_char[1] = 9'h1_BC;
                                                            idle_field_char[2] = 9'h1_BC;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_1)
                                                      begin //{
                                                            idle_field_char[1] = 9'h1_BC;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_2)
                                                      begin //{
                                                            idle_field_char[2] = 9'h1_BC;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else
                                                      begin //{
                                                       for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                                       begin //{
                                                           idle_field_char[i] = {1'b1,8'hBC};
                                                           env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                       end //}
                                                      end //}
                                                     end //}
                                            
                                            10'd2,
                                            10'd1,
                                            10'd0  :  begin // {
                                                      if(drive_012)
                                                      begin //{
                                                            idle_field_char[0] = 9'h1_FD;
                                                            idle_field_char[1] = 9'h1_FD;
                                                            idle_field_char[2] = 9'h1_FD;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_01)
                                                      begin //{
                                                            idle_field_char[0] = 9'h1_FD;
                                                            idle_field_char[1] = 9'h1_FD;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_02)
                                                      begin //{
                                                            idle_field_char[0] = 9'h1_FD;
                                                            idle_field_char[2] = 9'h1_FD;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_12)
                                                      begin //{
                                                            idle_field_char[1] = 9'h1_FD;
                                                         //   idle_field_char[2] = 9'h1_FD;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_1)
                                                      begin //{
                                                            idle_field_char[1] = 9'h1_FD;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else if(drive_2)
                                                      begin //{
                                                            idle_field_char[2] = 9'h1_FD;
                                                            env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                      end //}  
                                                      else
                                                      begin //{
                                                         for(int i=0;i<idle_trans.bfm_no_lanes;i++)
                                                         begin //{
                                                           idle_field_char[i] = {1'b1,8'hFD};
                                                           env_config.scramble_dis = 1'b0;
                                                            csf_update  = 1'b0;
                                                         end //}
                                                      end //} 
                                                      if(idle_cnt == 0)
                                                        idle_compen_done = 1'b1;  
                                                    end //}  
                                            endcase                                
                                         if(descr_sync_req && idle_cnt == 0 && idle_trans.bfm_idle_selected)
                                         begin //{
                                            state = IDLE_DESCR_SYNC;
                                            idle_cnt = 19;
                                         end //}
                                         else if(idle_cnt == 0 && idle_trans.bfm_idle_selected)
                                         begin //{
                                            state = IDLE_NORMAL;
                                            void'(choose_idle2_length());
                                            idle_cnt = idle2_seq_length;
                                         end //}
                                         else if(idle_cnt == 0 && ~idle_trans.bfm_idle_selected)
                                         begin //{
                                            state = IDLE_NORMAL;
                                         end //}
                                         else
                                         begin //{
                                             idle_cnt = idle_cnt - 1;
                                             state    = IDLE_COMPEN; 
                                         end //}
                                         end //}
                  endcase
              end //} // idle_config.idle_sel 
            end //} // posedge
        end //} // forever
    end //}
  endtask : idle_gen  

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name : gen_stomp_cs
/// Description : Task which generates the stomp control symbol if a packet is in progress
///////////////////////////////////////////////////////////////////////////////////////////////
task srio_pl_idle_gen::gen_stomp_cs();

    trans_push_ins = new();
    trans_push_ins.pkt_type = SRIO_PL_PACKET;
    trans_push_ins.transaction_kind = SRIO_CS;
    trans_push_ins.stype0 = 4'b0100;
   
    if(env_config.srio_mode == SRIO_GEN30)
      trans_push_ins.cstype = CS64;
    else if(idle_trans.bfm_idle_selected)
      trans_push_ins.cstype = CS48;
    else
      trans_push_ins.cstype = CS24;

    if(env_config.srio_mode == SRIO_GEN30)
     begin
      trans_push_ins.param0 = idle_trans.curr_rx_ackid;
      trans_push_ins.param0 = lcl_cpy_ackid;
     end
    else if(idle_trans.bfm_idle_selected)
     begin
      trans_push_ins.param0 = idle_trans.curr_rx_ackid;
      trans_push_ins.param0 = lcl_cpy_ackid;
     end
    else
     begin
      trans_push_ins.param0 = idle_trans.curr_rx_ackid;
      trans_push_ins.param0 = lcl_cpy_ackid;
     end

    if(idle_config.flow_control_mode == RECEIVE)
      trans_push_ins.param1 = 12'hFFF;
    else
    begin //{
      if(env_config.multi_vc_support == 1'b0)
        trans_push_ins.param1 = idle_config.buffer_space - pkt_handler_ins.receive_pkt_q.size();
      else
        trans_push_ins.param1 = idle_config.buffer_space - pkt_handler_ins.receive_pkt_vc0_q.size();
    end //}

    trans_push_ins.stype1  = 3'b001;
    trans_push_ins.cmd     = 3'b000;
    trans_push_ins.brc3_stype1_msb = 2'b00; 

    if(env_config.srio_mode == SRIO_GEN30)
      void'(trans_push_ins.calccrc24(trans_push_ins.pack_cs()));
    else if(idle_trans.bfm_idle_selected)
      void'(trans_push_ins.calccrc13(trans_push_ins.pack_cs()));
    else
      void'(trans_push_ins.calccrc5(trans_push_ins.pack_cs()));
      
    if(env_config.srio_mode != SRIO_GEN30)
       trans_push_ins.delimiter = 8'h7C;

    void'(trans_push_ins.pack_cs_bytes());
  
endtask : gen_stomp_cs

//////////////////////////////////////////////////////////////////////////
/// Name: choose_idle2_length
/// Description: Randomly choose the idle2 sequence length 
//////////////////////////////////////////////////////////////////////////
 function void srio_pl_idle_gen::choose_idle2_length();
   idle2_seq_length = $urandom_range(idle_config.idle2_seq_len_min,idle_config.idle2_seq_len_max); 
 endfunction:choose_idle2_length


//////////////////////////////////////////////////////////////////////////
/// Name: inc_lcl_cpy_ackid
/// Description:Increment local copy of ackid 
//////////////////////////////////////////////////////////////////////////
 function void srio_pl_idle_gen::inc_lcl_cpy_ackid();
   if(env_config.srio_mode == SRIO_GEN30)
   begin //{
      if(lcl_cpy_ackid == 4095)
        lcl_cpy_ackid = 0;
      else
        lcl_cpy_ackid = lcl_cpy_ackid+ 1; 
   end //}
   else if(idle_trans.bfm_idle_selected)
   begin //{
      if(lcl_cpy_ackid == 63)
        lcl_cpy_ackid = 0;
      else
        lcl_cpy_ackid = lcl_cpy_ackid + 1; 
   end //}
   else
   begin //{
      if(lcl_cpy_ackid == 31)
        lcl_cpy_ackid = 0;
      else
        lcl_cpy_ackid = lcl_cpy_ackid + 1; 
   end //}
endfunction:inc_lcl_cpy_ackid

///////////////////////////////////////////////////////////////////////////////////////////////
/// Name :tb_reset_ackid 
/// Description :Task to reset BFM packet ackid 
///////////////////////////////////////////////////////////////////////////////////////////////

 task srio_pl_idle_gen::tb_reset_ackid();
 forever
  begin//{
   wait(env_config.reset_ackid==1);
        idle_trans.cpy_rx_ackid      = 0;
        lcl_cpy_ackid = 0;
   wait(env_config.reset_ackid==0);
  end//}
endtask:tb_reset_ackid
