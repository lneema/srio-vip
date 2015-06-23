`define PREFIX(__prefix, __name) __prefix``__name

`define CG_PL_SYNC_SM_LANE(__num) covergroup `PREFIX(CG_PL_SYNC_SM_LANE,__num);\
    option.per_instance = 1;\
    CP_PL_NEXT_STATE    : coverpoint `PREFIX(sync_sm_lane,__num)\
                          {\
                             bins lane_sync_states[] = {NO_SYNC, NO_SYNC_1, NO_SYNC_2, NO_SYNC_3, SYNC, SYNC_1, SYNC_2, SYNC_3, SYNC_4};\
                          }\
    `PREFIX(CP_PL_SIGNAL_DETECT, __num) : coverpoint `PREFIX(signal_detect,__num);\
    CR_PL_SYNC_NEXT_STATE_SIGNAL_DETECT : cross CP_PL_NEXT_STATE, `PREFIX(CP_PL_SIGNAL_DETECT, __num)\
                                          {\
                                            ignore_bins int_state = binsof(CP_PL_NEXT_STATE) intersect {NO_SYNC_2, SYNC_2} && binsof(`PREFIX(CP_PL_SIGNAL_DETECT,__num)) intersect {0};\
                                          }\
    CP_PL_SYNC_TO_NS    : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins ns1_to_ns = (NO_SYNC_1 => NO_SYNC);\
                            bins ns3_to_ns = (NO_SYNC_3 => NO_SYNC);\
                            bins s_to_ns = (SYNC => NO_SYNC);\
                            bins s1_to_ns = (SYNC_1 => NO_SYNC);\
                            bins s2_to_ns = (SYNC_2 => NO_SYNC);\
                            bins s3_to_ns = (SYNC_3 => NO_SYNC);\
                            bins s4_to_ns = (SYNC_4 => NO_SYNC);\
                          }\
    CP_PL_SYNC_TO_NS1   : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins ns_to_ns1 = (NO_SYNC => NO_SYNC_1);\
                            bins ns2_to_ns1 = (NO_SYNC_2 => NO_SYNC_1);\
                          }\
    CP_PL_SYNC_TO_NS2   : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins ns1_to_ns2 = (NO_SYNC_1 => NO_SYNC_2);\
                            bins ns3_to_ns2 = (NO_SYNC_3 => NO_SYNC_2);\
                          }\
    CP_PL_SYNC_TO_NS3   : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins ns2_to_ns3 = (NO_SYNC_2 => NO_SYNC_3);\
                          }\
    CP_PL_SYNC_TO_S     : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins ns1_to_s = (NO_SYNC_1 => SYNC);\
                            bins s4_to_s = (SYNC_4 => SYNC);\
                          }\
    CP_PL_SYNC_TO_S1    : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins s_to_s1 = (SYNC => SYNC_1);\
                            bins s2_to_s1 = (SYNC_2 => SYNC_1);\
                          }\
    CP_PL_SYNC_TO_S2    : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins s1_to_s2 = (SYNC_1 => SYNC_2);\
                            bins s3_to_s2 = (SYNC_3 => SYNC_2);\
                            bins s4_to_s2 = (SYNC_4 => SYNC_2);\
                          }\
    CP_PL_SYNC_TO_S3    : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins s2_to_s3 = (SYNC_2 => SYNC_3);\
                          }\
    CP_PL_SYNC_TO_S4    : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins s3_to_s4 = (SYNC_3 => SYNC_4);\
                          }\
    CP_PL_SYNC_PATH_TRANSITIONS : coverpoint `PREFIX(sync_sm_lane,__num) \
                          {\
                            bins s_s1_s2_s1 = (SYNC => SYNC_1 => SYNC_2 => SYNC_1);\
                            bins s1_s2_s1_ns = (SYNC_1 => SYNC_2 => SYNC_1 => NO_SYNC);\
                            bins s1_s2_s3_s2 = (SYNC_1 => SYNC_2 => SYNC_3 => SYNC_2);\
                            bins s2_s3_s4_s = (SYNC_2 => SYNC_3 => SYNC_4 => SYNC);\
                            bins s2_s3_s4_s2 = (SYNC_2 => SYNC_3 => SYNC_4 => SYNC_2);\
                            bins ns_ns1_ns2 = (NO_SYNC => NO_SYNC_1 => NO_SYNC_2);\
                            bins ns1_ns2_ns1_ns2 = (NO_SYNC_1 => NO_SYNC_2 => NO_SYNC_1 => NO_SYNC_2);\
                            bins ns1_ns2_ns1_s = (NO_SYNC_1 => NO_SYNC_2 => NO_SYNC_1 => SYNC);\
                            bins ns1_ns2_ns3_ns2 = (NO_SYNC_1 => NO_SYNC_2 => NO_SYNC_3 => NO_SYNC_2);\
                            bins ns1_ns2_ns = (NO_SYNC_1 => NO_SYNC_2 => NO_SYNC);\
                            bins gen2_s_s1_s2_s1 = (SYNC => SYNC_1 => SYNC_2 => SYNC_1);\
                            bins gen2_s1_s2_s1_ns = (SYNC_1 => SYNC_2 => SYNC_1 => NO_SYNC);\
                            bins gen2_s1_s2_s3_s2 = (SYNC_1 => SYNC_2 => SYNC_3 => SYNC_2);\
                            bins gen2_s2_s3_s4_s2 = (SYNC_2 => SYNC_3 => SYNC_4 => SYNC_2);\
                            bins gen2_s2_s3_s4_s = (SYNC_2 => SYNC_3 => SYNC_4 => SYNC);\
                          }\
  endgroup

`define sync_sm_state_mon(__num) if(env_config.num_of_lanes > __num``) \
  begin //{\
      while(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_sync_state_q.size() != 0)\
      begin //{\
        `PREFIX(sync_sm_lane,__num) = pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_sync_state_q.pop_front();\
        `PREFIX(CG_PL_SYNC_SM_LANE,__num).sample();\
      end //}\
  end //} \

`define lane_ready(__num) if(env_config.num_of_lanes > __num``) \
  begin //{\
      `PREFIX(lane_ready,__num) =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.lane_ready[__num``];\
  end //}\

`define lane_sync(__num) if(env_config.num_of_lanes > __num``) \
  begin //{ \
      `PREFIX(lane_sync,__num) =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.lane_sync[__num``];\
  end //} \

`define rcvr_trained(__num) if(env_config.num_of_lanes > __num``) \
  begin //{ \
      `PREFIX(rcvr_trained,__num) =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.rcvr_trained[__num``];\
  end //} \

`define signal_detect(__num) if(env_config.num_of_lanes > __num``) \
  begin //{ \
      `PREFIX(signal_detect,__num) =  pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.signal_detect[__num``];\
  end //} \

`define cw_lock_lane(__num) if(env_config.num_of_lanes > __num``) \
   begin //{ \
     `PREFIX(cw_lock_lane,__num) =  pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].lh_trans.cw_lock[__num``];\
   end //} \

`define gen3_sync_sm_state_mon(__num) if(env_config.num_of_lanes > __num``) \
      begin //{ \
        while(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_sync_state_q.size() != 0)\
        begin //{ \
          `PREFIX(gen3_sync_sm_lane,__num) = pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_sync_state_q.pop_front();\
          `PREFIX(CG_GEN3_PL_LANE_SYNC_SM,__num).sample();\
        end //}\
      end //} \

`define CG_GEN3_PL_LANE_SYNC_SM(__num) covergroup `PREFIX(CG_GEN3_PL_LANE_SYNC_SM,__num);\
    option.per_instance = 1;\
    CP_PL_GEN3_LANE_SYNC_NEXT_STATE    : coverpoint `PREFIX(gen3_sync_sm_lane,__num)\
                                       {  \
                                         bins gen3_lane_sync_states[] = {NO_SYNC, NO_SYNC_1, NO_SYNC_2, NO_SYNC_3, NO_SYNC_4, SYNC, SYNC_1, SYNC_2};\
                                       }\
    `PREFIX(CP_PL_CW_LOCK, __num) : coverpoint `PREFIX(cw_lock_lane,__num);\
    CR_PL_GEN3_LANE_SYNC_NEXT_STATE_CW_LOCK : cross CP_PL_GEN3_LANE_SYNC_NEXT_STATE, `PREFIX(CP_PL_CW_LOCK, __num)\
                                              {\
                                                 ignore_bins cw_lock = binsof(`PREFIX(CP_PL_CW_LOCK, __num)) intersect {0};\
                                              }\
    CP_PL_GEN3_LANE_SYNC_TO_NO_SYNC    : coverpoint `PREFIX(gen3_sync_sm_lane,__num)\
                                       {\
                                         bins ns1_to_ns = (NO_SYNC_1 => NO_SYNC);\
                                         bins ns3_to_ns = (NO_SYNC_3 => NO_SYNC);\
                                         bins ns4_to_ns = (NO_SYNC_4 => NO_SYNC);\
                                         bins s_to_ns = (SYNC => NO_SYNC);\
                                         bins s1_to_ns = (SYNC_1 => NO_SYNC);\
                                         bins s2_to_ns = (SYNC_2 => NO_SYNC);\
                                       }\
    CP_PL_GEN3_LANE_SYNC_TO_NO_SYNC1   : coverpoint `PREFIX(gen3_sync_sm_lane,__num) \
                                       {\
                                         bins ns_to_ns1 = (NO_SYNC => NO_SYNC_1);\
                                         bins ns3_to_ns1 = (NO_SYNC_3 => NO_SYNC_1);\
                                       }\
    CP_PL_GEN3_LANE_SYNC_TO_NO_SYNC2   : coverpoint `PREFIX(gen3_sync_sm_lane,__num) \
                                       {\
                                         bins ns1_to_ns2 = (NO_SYNC_1 => NO_SYNC_2);\
                                         bins ns3_to_ns2 = (NO_SYNC_3 => NO_SYNC_2);\
                                         bins ns4_to_ns2 = (NO_SYNC_4 => NO_SYNC_2);\
                                       }\
    CP_PL_GEN3_LANE_SYNC_TO_NO_SYNC3   : coverpoint `PREFIX(gen3_sync_sm_lane,__num) \
                                       {\
                                         bins ns2_to_ns3 = (NO_SYNC_2 => NO_SYNC_3);\
                                       }\
    CP_PL_GEN3_LANE_SYNC_TO_NO_SYNC4   : coverpoint `PREFIX(gen3_sync_sm_lane,__num) \
                                       {\
                                         bins ns3_to_ns4 = (NO_SYNC_3 => NO_SYNC_4);\
                                       }\
    CP_PL_GEN3_LANE_SYNC_TO_SYNC     : coverpoint `PREFIX(gen3_sync_sm_lane,__num) \
                                       {\
                                         bins ns4_to_s = (NO_SYNC_4 => SYNC);\
                                       }\
    CP_PL_GEN3_LANE_SYNC_TO_SYNC1    : coverpoint `PREFIX(gen3_sync_sm_lane,__num) \
                                       {\
                                         bins s_to_s1 = (SYNC => SYNC_1);\
                                       }\
    CP_PL_GEN3_LANE_SYNC_TO_SYNC2    : coverpoint `PREFIX(gen3_sync_sm_lane,__num) \
                                       {\
                                         bins s1_to_s2 = (SYNC_1 => SYNC_2);\
                                       }\
    CP_PL_GEN3_SYNC_PATH_TRANSITIONS : coverpoint `PREFIX(gen3_sync_sm_lane,__num) \
                                       {\
                                         bins ns_ns1_ns2_ns3 = (NO_SYNC => NO_SYNC_1 => NO_SYNC_2 => NO_SYNC_3);\
                                         bins ns2_ns3_ns2 = (NO_SYNC_2 => NO_SYNC_3 => NO_SYNC_2);\
                                         bins ns2_ns3_ns1 = (NO_SYNC_2 => NO_SYNC_3 => NO_SYNC_1);\
                                         bins ns2_ns3_ns4 = (NO_SYNC_2 => NO_SYNC_3 => NO_SYNC_4);\
                                         bins ns2_ns3_ns4_ns2 = (NO_SYNC_2 => NO_SYNC_3 => NO_SYNC_4 => NO_SYNC_2);\
                                         bins ns2_ns3_ns4_s = (NO_SYNC_2 => NO_SYNC_3 => NO_SYNC_4 => SYNC);\
                                         bins s_s1_s2 = (SYNC => SYNC_1 => SYNC_2);\
                                       }\
  endgroup

`define cw_lock_sm_mon(__num) if(env_config.num_of_lanes > __num``) \
      begin //{ \
      while(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_cw_lock_state_q.size() != 0)\
      begin //{\
        `PREFIX(cw_lock_sm,__num) = pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_cw_lock_state_q.pop_front();\
        `PREFIX(CG_GEN3_PL_CW_LOCK_SM,__num).sample();\
      end //}\
      end //} \

`define CG_GEN3_PL_CW_LOCK_SM(__num) covergroup `PREFIX(CG_GEN3_PL_CW_LOCK_SM,__num);\
    option.per_instance = 1;\
    CP_PL_CW_LOCK_NEXT_STATE : coverpoint `PREFIX(cw_lock_sm,__num);\
    CP_PL_RESET         : coverpoint srio_if.srio_rst_n;\
    CP_PL_CW_LOCK_TO_NO_LOCK : coverpoint `PREFIX(cw_lock_sm,__num)\
                               {\
                                 bins lck2_to_no_lck = ( LOCK_2 => NO_LOCK );\
                               }\
    CP_PL_CW_LOCK_TO_NO_LOCK1 : coverpoint `PREFIX(cw_lock_sm,__num)\
                               {\
                                 bins no_lck4_to_sa = ( NO_LOCK => NO_LOCK_1 );\
                                 bins sa_to_no_lck1 = ( SLIP_ALIGNMENT => NO_LOCK_1 );\
                               }\
    CP_PL_CW_LOCK_TO_NO_LOCK2 : coverpoint `PREFIX(cw_lock_sm,__num)\
                               {\
                                 bins no_lck1_to_no_lck2 = ( NO_LOCK_1 => NO_LOCK_2 );\
                                 bins no_lck3_to_no_lck2 = ( NO_LOCK_3 => NO_LOCK_2 );\
                               }\
    CP_PL_CW_LOCK_TO_NO_LOCK3 : coverpoint `PREFIX(cw_lock_sm,__num)\
                               {\
                                 bins no_lck2_to_no_lck3 = ( NO_LOCK_2 => NO_LOCK_3 );\
                               }\
    CP_PL_CW_LOCK_TO_LOCK : coverpoint `PREFIX(cw_lock_sm,__num)\
                               {\
                                 bins no_lck3_to_lck = ( NO_LOCK_3 => LOCK );\
                                 bins lck3_to_lck = ( LOCK_3 => LOCK );\
                               }\
    CP_PL_CW_LOCK_TO_LOCK1 : coverpoint `PREFIX(cw_lock_sm,__num)\
                               {\
                                 bins lck_to_lck1 = ( LOCK => LOCK_1 );\
                                 bins lck2_to_lck1 = ( LOCK_2 => LOCK_1 );\
                                 bins lck3_to_lck1 = ( LOCK_3 => LOCK_1 );\
                               }\
    CP_PL_CW_LOCK_TO_LOCK2 : coverpoint `PREFIX(cw_lock_sm,__num)\
                               {\
                                 bins lck1_to_lck2 = ( LOCK_1 => LOCK_2 );\
                               }\
    CP_PL_CW_LOCK_TO_LOCK3 : coverpoint `PREFIX(cw_lock_sm,__num)\
                               {\
                                 bins lck1_to_lck3 = ( LOCK_1 => LOCK_3 );\
                               }\
   CP_PL_CW_LOCK_PATH_TRANSITIONS : coverpoint `PREFIX(cw_lock_sm,__num)\
                               {\
                                 bins nl_nl1_nl2_slp = (NO_LOCK => NO_LOCK_1 => NO_LOCK_2 => SLIP_ALIGNMENT);\
                                 bins nl_nl1_nl2_nl3 = (NO_LOCK => NO_LOCK_1 => NO_LOCK_2 => NO_LOCK_3);\
                                 bins nl2_nl3_nl2 = (NO_LOCK_2 => NO_LOCK_3 => NO_LOCK_2);\
                                 bins nl2_nl3_l = (NO_LOCK_2 => NO_LOCK_3 => LOCK);\
                                 bins l_l1_l2_l1 = (LOCK => LOCK_1=> LOCK_2 => LOCK_1);\
                                 bins l_l1_l3_l1 = (LOCK => LOCK_1=> LOCK_3 => LOCK_1);\
                                 bins l1_l2_nl = (LOCK_1=> LOCK_2 => NO_LOCK);\
                                 bins l1_l3_l = (LOCK_1=> LOCK_3 => LOCK);\
                               }\
  endgroup 

`define long_run_link_train_sm_mon(__num) if(env_config.num_of_lanes > __num``) \
   begin //{ \
     while(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_dme_train_state_q.size() != 0)\
     begin //{\
        `PREFIX(long_run_link_train_sm,__num) = pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_dme_train_state_q.pop_front();\
        `PREFIX(CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM,__num).sample();\
     end //} \
   end //} \

`define CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM(__num) covergroup `PREFIX(CG_GEN3_PL_LONG_RUN_LINK_TRAIN_SM,__num);\
    option.per_instance = 1;\
    CP_PL_LONG_RUN_LINK_TRAIN_NEXT_STATE : coverpoint `PREFIX(long_run_link_train_sm,__num)\
                                           {\
                                              bins long_run_states[] = { UNTRAINED, DME_TRAINING_0, DME_TRAINING_1, DME_TRAINING_2, DME_TRAINING_FAIL, TRAINED };\
                                           }\
    CP_PL_LONG_RUN_LINK_TRAIN_TO_UNTRAINED : coverpoint `PREFIX(long_run_link_train_sm,__num)\
                                             {\
                                               bins dmet1_to_un = ( DME_TRAINING_1 => UNTRAINED );\
                                               bins dmetf_to_un = ( DME_TRAINING_FAIL => UNTRAINED );\
                                             }\
    CP_PL_LONG_RUN_LINK_TRAIN_TO_DME_TRAINING0 : coverpoint `PREFIX(long_run_link_train_sm,__num)\
                                             {\
                                               bins un_to_dmet0 = ( UNTRAINED =>  DME_TRAINING_0);\
                                             }\
    CP_PL_LONG_RUN_LINK_TRAIN_TO_DME_TRAINING1 : coverpoint `PREFIX(long_run_link_train_sm,__num)\
                                             {\
                                               bins dmet0_to_dmet1 = ( DME_TRAINING_0 =>  DME_TRAINING_1);\
                                               bins dmet2_to_dmet1 = ( DME_TRAINING_2 =>  DME_TRAINING_1);\
                                             }\
    CP_PL_LONG_RUN_LINK_TRAIN_TO_DME_TRAINING2 : coverpoint `PREFIX(long_run_link_train_sm,__num)\
                                             {\
                                               bins dmet1_to_dmet2 = ( DME_TRAINING_1 =>  DME_TRAINING_2);\
                                             }\
    CP_PL_LONG_RUN_LINK_TRAIN_TO_DME_TRAINING_FAIL : coverpoint `PREFIX(long_run_link_train_sm,__num)\
                                             {\
                                               bins dmet0_to_dmetf = ( DME_TRAINING_0 =>  DME_TRAINING_FAIL);\
                                               bins dmet1_to_dmetf = ( DME_TRAINING_1 =>  DME_TRAINING_FAIL);\
                                             }\
    CP_PL_LONG_RUN_LINK_TRAIN_TO_TRAINED : coverpoint `PREFIX(long_run_link_train_sm,__num)\
                                             {\
                                               bins dmet2_to_t = ( DME_TRAINING_2 =>  TRAINED);\
                                             }\
    CP_PL_LONG_RUN_LINK_TRAIN_PATH_TRANSITIONS : coverpoint `PREFIX(long_run_link_train_sm,__num)\
                                                  {\
                                                    bins dmet0_dmetf_un = (DME_TRAINING_0 => DME_TRAINING_FAIL => UNTRAINED);\
                                                    bins dmet0_dmet1_dmetf = (DME_TRAINING_0 => DME_TRAINING_1 => DME_TRAINING_FAIL);\
                                                    bins dmet0_dmet1_un = (DME_TRAINING_0 => DME_TRAINING_1 => UNTRAINED);\
                                                    bins dmet0_dmet1_dmet2_dmet1 = (DME_TRAINING_0 => DME_TRAINING_1 => DME_TRAINING_2 => DME_TRAINING_1);\
                                                  }\
   endgroup

`define short_run_link_train_sm_mon(__num) if(env_config.num_of_lanes > __num``) \
   begin //{ \
     while(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_cw_train_state_q.size() != 0)\
     begin //{\
        `PREFIX(short_run_link_train_sm,__num) = pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_cw_train_state_q.pop_front();\
        `PREFIX(CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM,__num).sample();\
      end //} \
   end //} \

`define CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM(__num) covergroup `PREFIX(CG_GEN3_PL_SHORT_RUN_LINK_TRAIN_SM,__num);\
    option.per_instance = 1;\
    CP_PL_SHORT_RUN_LINK_TRAIN_NEXT_STATE : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                            {\
                                              bins short_run_states[] = { UNTRAINED, CW_TRAINING_0, CW_TRAINING_1, CW_TRAINING_FAIL, TRAINED, KEEP_ALIVE, RETRAINING_0, RETRAINING_1, RETRAINING_2, RETRAIN_FAIL };\
                                            }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_UNTRAINED : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins cwt1_to_un = ( CW_TRAINING_1 => UNTRAINED );\
                                               bins cwtf_to_un = ( CW_TRAINING_FAIL => UNTRAINED );\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_CW_TRAINING0 : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins un_to_cwt0 = ( UNTRAINED =>  CW_TRAINING_0);\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_CW_TRAINING1 : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins cwt0_to_cwt1 = ( CW_TRAINING_0 =>  CW_TRAINING_1);\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_CW_TRAINING_FAIL : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins cwt0_to_cwtf = ( CW_TRAINING_0 =>  CW_TRAINING_FAIL);\
                                               bins cwt1_to_cwtf = ( CW_TRAINING_1 =>  CW_TRAINING_FAIL);\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_TRAINED : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins cwt1_to_t = ( CW_TRAINING_1 =>  TRAINED);\
                                               bins ka_to_t = ( KEEP_ALIVE =>  TRAINED);\
                                               bins r2_to_t = ( RETRAINING_2 =>  TRAINED);\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_KEEP_ALIVE : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins t_to_ka = ( TRAINED => KEEP_ALIVE );\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_RETRAINING0 : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins t_to_r0 = ( TRAINED =>  RETRAINING_0);\
                                               bins ka_to_r0 = ( KEEP_ALIVE =>  RETRAINING_0);\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_RETRAINING1 : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins r0_to_r1 = ( RETRAINING_0 =>  RETRAINING_1);\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_RETRAINING2 : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins r1_to_r2 = ( RETRAINING_1 =>  RETRAINING_2);\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_TO_RETRAIN_FAIL : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                             {\
                                               bins r0_to_rf = ( RETRAINING_0 =>  RETRAIN_FAIL);\
                                               bins r1_to_rf = ( RETRAINING_1 =>  RETRAIN_FAIL);\
                                               bins r2_to_rf = ( RETRAINING_2 =>  RETRAIN_FAIL);\
                                             }\
    CP_PL_SHORT_RUN_LINK_TRAIN_PATH_TRANSITIONS : coverpoint `PREFIX(short_run_link_train_sm,__num)\
                                                  {\
                                                    bins cwt0_cwtf_un = (CW_TRAINING_0 => CW_TRAINING_FAIL => UNTRAINED);\
                                                    bins cwt0_cwt1_t = (CW_TRAINING_0 => CW_TRAINING_1 => TRAINED);\
                                                    bins t_ka_t = (TRAINED => KEEP_ALIVE => TRAINED);\
                                                    bins t_r0_rf = (TRAINED => RETRAINING_0 => RETRAIN_FAIL);\
                                                    bins t_r0_r1_rf = (TRAINED => RETRAINING_0 => RETRAINING_1 => RETRAIN_FAIL);\
                                                    bins t_r0_r1_r2_rf = (TRAINED => RETRAINING_0 => RETRAINING_1 => RETRAINING_2 => RETRAIN_FAIL);\
                                                    bins t_r0_r1_r2_t = (TRAINED => RETRAINING_0 => RETRAINING_1 => RETRAINING_2 => TRAINED);\
                                                  }\
  endgroup


`define frame_lock_sm(__num) if(env_config.num_of_lanes > __num``) \
  begin //{\
      while(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_frame_lock_state_q.size() != 0)\
      begin //{\
        `PREFIX(gen3_frame_lock_sm_lane,__num) =  pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_frame_lock_state_q.pop_front();\
        `PREFIX(CG_GEN3_PL_FRAME_LOCK_SM,__num).sample();\
      end //}\
  end //}\


`define CG_GEN3_PL_FRAME_LOCK_SM(__num) covergroup `PREFIX(CG_GEN3_PL_FRAME_LOCK_SM,__num);\
    option.per_instance = 1;\
    CP_PL_GEN3_FRAME_LOCK_NEXT_STATE   : coverpoint `PREFIX(gen3_frame_lock_sm_lane,__num)\
                                       {\
                                           bins gen3_frame_lock_states[] = {OUT_OF_FRAME, RESET_COUNT, GET_NEW_MARKER, TEST_MARKER, VALID_MARKER, INVALID_MARKER, IN_FRAME, SLIP};\
                                       }\
    CP_PL_GEN3_FRAME_LOCK_TO_RSTCNT   : coverpoint `PREFIX(gen3_frame_lock_sm_lane,__num)\
                                       {\
                                           bins oof_rstcnt    = (OUT_OF_FRAME => RESET_COUNT);\
                                           bins if_rstcnt   = (IN_FRAME => RESET_COUNT);\
                                           bins slip_rstcnt = (SLIP => RESET_COUNT);\
                                       }\
    CP_PL_GEN3_FRAME_LOCK_TO_GNM       : coverpoint `PREFIX(gen3_frame_lock_sm_lane,__num)\
                                         { \
                                           bins rstcnt_gnm = (RESET_COUNT => GET_NEW_MARKER);\
                                           bins vm_gnm = (VALID_MARKER => GET_NEW_MARKER);\
                                           bins ivm_gnm = (INVALID_MARKER => GET_NEW_MARKER);\
                                         } \
    CP_PL_GEN3_FRAME_LOCK_TO_TM        : coverpoint `PREFIX(gen3_frame_lock_sm_lane,__num)\
                                         { \
                                           bins gnm_tm = (GET_NEW_MARKER => TEST_MARKER);\
                                         } \
    CP_PL_GEN3_FRAME_LOCK_TO_VM_IVM      : coverpoint `PREFIX(gen3_frame_lock_sm_lane,__num)\
                                         { \
                                           bins tm_vm = (TEST_MARKER => VALID_MARKER);\
                                           bins tm_ivm = (TEST_MARKER => INVALID_MARKER);\
                                         } \
    CP_PL_GEN3_FRAME_LOCK_TO_INF       : coverpoint `PREFIX(gen3_frame_lock_sm_lane,__num)\
                                         { \
                                           bins vm_if = (VALID_MARKER => IN_FRAME);\
                                         } \
    CP_PL_GEN3_FRAME_LOCK_TO_SLIP      : coverpoint `PREFIX(gen3_frame_lock_sm_lane,__num)\
                                         { \
                                           bins ivm_slip = ( INVALID_MARKER => SLIP);\
                                         } \
    CP_PL_GEN3_FRAME_LOCK_PATH_TRANSITIONS :  coverpoint `PREFIX(gen3_frame_lock_sm_lane,__num)\
                                              { \
                                                bins oof_rstcnt_gnm = (OUT_OF_FRAME => RESET_COUNT => GET_NEW_MARKER);\
                                                bins gnm_tm_vm_gnm = (GET_NEW_MARKER => TEST_MARKER => VALID_MARKER => GET_NEW_MARKER);\
                                                bins gnm_tm_ivm_gnm = (GET_NEW_MARKER => TEST_MARKER => INVALID_MARKER => GET_NEW_MARKER);\
                                                bins gnm_tm_vm_if = (GET_NEW_MARKER => TEST_MARKER => VALID_MARKER => IN_FRAME);\
                                                bins gnm_tm_ivm_slip = (GET_NEW_MARKER => TEST_MARKER => INVALID_MARKER => SLIP);\
                                                bins if_rstcnt_gnm = (IN_FRAME => RESET_COUNT => GET_NEW_MARKER);\
                                                bins slip_rstcnt_gnm = (SLIP => RESET_COUNT => GET_NEW_MARKER);\
                                              }\
  endgroup

`define c0_coeff_update_sm(__num) if(env_config.num_of_lanes > __num``) \
  begin //{\
      while(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_c0_coeff_update_state_q.size() != 0)\
      begin //{\
        `PREFIX(gen3_c0_coeff_update_sm_lane,__num) =  pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_c0_coeff_update_state_q.pop_front();\
        `PREFIX(CG_GEN3_PL_C0_COEFF_UPDATE_SM,__num).sample();\
      end //}\
  end //}\

`define cp1_coeff_update_sm(__num) if(env_config.num_of_lanes > __num``) \
  begin //{\
      while(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_cp1_coeff_update_state_q.size() != 0)\
      begin //{\
        `PREFIX(gen3_cp1_coeff_update_sm_lane,__num) =  pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_cp1_coeff_update_state_q.pop_front();\
        `PREFIX(CG_GEN3_PL_CP1_COEFF_UPDATE_SM,__num).sample();\
      end //}\
  end //}\

`define cn1_coeff_update_sm(__num) if(env_config.num_of_lanes > __num``) \
  begin //{\
      while(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_cn1_coeff_update_state_q.size() != 0)\
      begin //{\
        `PREFIX(gen3_cn1_coeff_update_sm_lane,__num) =  pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].current_cn1_coeff_update_state_q.pop_front();\
        `PREFIX(CG_GEN3_PL_CN1_COEFF_UPDATE_SM,__num).sample();\
      end //}\
  end //}\


`define CG_GEN3_PL_C0_COEFF_UPDATE_SM(__num) covergroup `PREFIX(CG_GEN3_PL_C0_COEFF_UPDATE_SM,__num);\
    option.per_instance = 1;\
    CP_PL_GEN3_PL_C0_COEFF_UPDATE_NEXT_STATE   : coverpoint `PREFIX(gen3_c0_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins gen3_c0_update_sm_states[] = {NOT_UPDATED, UPDATE_COEFF, MAXIMUM, UPDATED, MINIMUM};\
                                                 }\
    CP_PL_GEN3_PL_C0_COEFF_UPDATE_NU           : coverpoint `PREFIX(gen3_c0_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins max_nu = (MAXIMUM => NOT_UPDATED);\
                                                   bins min_nu = (MINIMUM => NOT_UPDATED);\
                                                   bins up_nu = (UPDATED => NOT_UPDATED);\
                                                 }\
    CP_PL_GEN3_PL_C0_COEFF_UPDATE_UPCOEFF      : coverpoint `PREFIX(gen3_c0_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins nu_upco = (NOT_UPDATED => UPDATE_COEFF);\
                                                 }\
    CP_PL_GEN3_PL_C0_COEFF_UPDATE_UP           : coverpoint `PREFIX(gen3_c0_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins upco_up = (UPDATE_COEFF => UPDATED);\
                                                 }\
    CP_PL_GEN3_PL_C0_COEFF_UPDATE_MAX          : coverpoint `PREFIX(gen3_c0_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins upco_max = (UPDATE_COEFF => MAXIMUM);\
                                                 }\
    CP_PL_GEN3_PL_C0_COEFF_UPDATE_MIN          : coverpoint `PREFIX(gen3_c0_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins upco_min = (UPDATE_COEFF => MINIMUM);\
                                                 }\
    CP_PL_GEN3_PL_C0_COEFF_UPDATE_PATH         : coverpoint `PREFIX(gen3_c0_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins nu_upco_max_nu = (NOT_UPDATED => UPDATE_COEFF => MAXIMUM => NOT_UPDATED);\
                                                   bins nu_upco_min_nu = (NOT_UPDATED => UPDATE_COEFF => MINIMUM => NOT_UPDATED);\
                                                   bins nu_upco_up_nu  = (NOT_UPDATED => UPDATE_COEFF => UPDATED => NOT_UPDATED);\
                                                 }\
endgroup

`define CG_GEN3_PL_CP1_COEFF_UPDATE_SM(__num) covergroup `PREFIX(CG_GEN3_PL_CP1_COEFF_UPDATE_SM,__num);\
    option.per_instance = 1;\
    CP_PL_GEN3_PL_CP1_COEFF_UPDATE_NEXT_STATE   : coverpoint `PREFIX(gen3_cp1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins gen3_cp1_update_sm_states[] = {NOT_UPDATED, UPDATE_COEFF, MAXIMUM, UPDATED, MINIMUM};\
                                                 }\
    CP_PL_GEN3_PL_CP1_COEFF_UPDATE_NU           : coverpoint `PREFIX(gen3_cp1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins max_nu = (MAXIMUM => NOT_UPDATED);\
                                                   bins min_nu = (MINIMUM => NOT_UPDATED);\
                                                   bins up_nu = (UPDATED => NOT_UPDATED);\
                                                 }\
    CP_PL_GEN3_PL_CP1_COEFF_UPDATE_UPCOEFF      : coverpoint `PREFIX(gen3_cp1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins nu_upco = (NOT_UPDATED => UPDATE_COEFF);\
                                                 }\
    CP_PL_GEN3_PL_CP1_COEFF_UPDATE_UP           : coverpoint `PREFIX(gen3_cp1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins upco_up = (UPDATE_COEFF => UPDATED);\
                                                 }\
    CP_PL_GEN3_PL_CP1_COEFF_UPDATE_MAX          : coverpoint `PREFIX(gen3_cp1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins upco_max = (UPDATE_COEFF => MAXIMUM);\
                                                 }\
    CP_PL_GEN3_PL_CP1_COEFF_UPDATE_MIN          : coverpoint `PREFIX(gen3_cp1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins upco_min = (UPDATE_COEFF => MINIMUM);\
                                                 }\
    CP_PL_GEN3_PL_CP1_COEFF_UPDATE_PATH         : coverpoint `PREFIX(gen3_cp1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins nu_upco_max_nu = (NOT_UPDATED => UPDATE_COEFF => MAXIMUM => NOT_UPDATED);\
                                                   bins nu_upco_min_nu = (NOT_UPDATED => UPDATE_COEFF => MINIMUM => NOT_UPDATED);\
                                                   bins nu_upco_up_nu  = (NOT_UPDATED => UPDATE_COEFF => UPDATED => NOT_UPDATED);\
                                                 }\
endgroup

`define CG_GEN3_PL_CN1_COEFF_UPDATE_SM(__num) covergroup `PREFIX(CG_GEN3_PL_CN1_COEFF_UPDATE_SM,__num);\
    option.per_instance = 1;\
    CP_PL_GEN3_PL_CN1_COEFF_UPDATE_NEXT_STATE   : coverpoint `PREFIX(gen3_cn1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins gen3_cn1_update_sm_states[] = {NOT_UPDATED, UPDATE_COEFF, MAXIMUM, UPDATED, MINIMUM};\
                                                 }\
    CP_PL_GEN3_PL_CN1_COEFF_UPDATE_NU           : coverpoint `PREFIX(gen3_cn1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins max_nu = (MAXIMUM => NOT_UPDATED);\
                                                   bins min_nu = (MINIMUM => NOT_UPDATED);\
                                                   bins up_nu = (UPDATED => NOT_UPDATED);\
                                                 }\
    CP_PL_GEN3_PL_CN1_COEFF_UPDATE_UPCOEFF      : coverpoint `PREFIX(gen3_cn1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins nu_upco = (NOT_UPDATED => UPDATE_COEFF);\
                                                 }\
    CP_PL_GEN3_PL_CN1_COEFF_UPDATE_UP           : coverpoint `PREFIX(gen3_cn1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins upco_up = (UPDATE_COEFF => UPDATED);\
                                                 }\
    CP_PL_GEN3_PL_CN1_COEFF_UPDATE_MAX          : coverpoint `PREFIX(gen3_cn1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins upco_max = (UPDATE_COEFF => MAXIMUM);\
                                                 }\
    CP_PL_GEN3_PL_CN1_COEFF_UPDATE_MIN          : coverpoint `PREFIX(gen3_cn1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins upco_min = (UPDATE_COEFF => MINIMUM);\
                                                 }\
    CP_PL_GEN3_PL_CN1_COEFF_UPDATE_PATH         : coverpoint `PREFIX(gen3_cn1_coeff_update_sm_lane,__num)\
                                                 {\
                                                   bins nu_upco_max_nu = (NOT_UPDATED => UPDATE_COEFF => MAXIMUM => NOT_UPDATED);\
                                                   bins nu_upco_min_nu = (NOT_UPDATED => UPDATE_COEFF => MINIMUM => NOT_UPDATED);\
                                                   bins nu_upco_up_nu  = (NOT_UPDATED => UPDATE_COEFF => UPDATED => NOT_UPDATED);\
                                                 }\
endgroup

`define i_counter(__num) if(env_config.num_of_lanes > __num``) \
  begin //{\
    `PREFIX(i_counter,__num) =  pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].I_counter;\
  end //}\

`define k_counter(__num)  if(env_config.num_of_lanes > __num``) \
  begin //{\
    `PREFIX(k_counter,__num) =  pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].K_counter;\
  end //}\

`define v_counter(__num)  if(env_config.num_of_lanes > __num``) \
  begin //{\
    `PREFIX(v_counter,__num) =  pl_agent.pl_monitor.rx_monitor.lane_handle_ins[__num``].V_counter;\
  end //}\

`define CP_PL_SM_I_COUNTER(__num) `PREFIX(CP_PL_SM_I_COUNTER,__num) : coverpoint `PREFIX(i_counter,__num)\
                                                                      {\
                                                                        bins i_count[] = {[0:3]};\
                                                                      }\

`define CP_PL_SM_K_COUNTER(__num) `PREFIX(CP_PL_SM_K_COUNTER,__num) : coverpoint `PREFIX(k_counter,__num)\
                                                                      {\
                                                                        bins k_count[] = {[0:127]};\
                                                                      }\


`define CP_PL_SM_V_COUNTER(__num) `PREFIX(CP_PL_SM_V_COUNTER,__num) : coverpoint `PREFIX(v_counter,__num)\
                                                                      {\
                                                                        bins v_count[] = {[0:1024]};\
                                                                      }\


`define CG_GEN3_PL_RX_AET(_lanenum)                                   \
  covergroup  CG_GEN3_PL_RX_AET_LANE``_lanenum``;                     \
    option.per_instance = 1;                                          \
                                                                      \
    CP_PL_LANE_DEGRADED_N:                                            \
      coverpoint rx_lane_degraded[_lanenum``];                        \
                                                                      \
    CP_PL_LANE_TRAINED_N:                                             \
      coverpoint rx_lane_trained[_lanenum``];                         \
                                                                      \
    CP_PL_10G_RETRAIN_ENABLE_N:                                       \
      coverpoint retrain_en;                                          \
                                                                      \
    CP_PL_LANE_DEGRADED_TRAINED_10G_RETRAIN_ENABLE_N:                 \
      coverpoint rx_lane_degraded_trained_sync[_lanenum``];           \
                                                                      \
    CP_PL_RX_LANE:                                                    \
      coverpoint rx_lane_ready[_lanenum``] {                          \
        bins lane_ready = {1};}                                       \
                                                                      \
  endgroup: CG_GEN3_PL_RX_AET_LANE``_lanenum``                        

`define CG_GEN3_PL_RX_AET_TAP_CMDSTS(_lanenum)                        \
  covergroup  CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE``_lanenum``;          \
    option.per_instance = 1;                                          \
                                                                      \
    CP_PL_RX_EQUALIZER_TAP:                                           \
      coverpoint rx_brc3_cg[_lanenum``][41:44] {                      \
        bins tap0       = {4'h0};                                     \
        bins tap_plus1  = {4'h1};                                     \
        bins tap_plus2  = {4'h2};                                     \
        bins tap_plus3  = {4'h3};                                     \
        bins tap_plus4  = {4'h4};                                     \
        bins tap_plus5  = {4'h5};                                     \
        bins tap_plus6  = {4'h6};                                     \
        bins tap_plus7  = {4'h7};                                     \
        bins tap_minus8 = {4'h8};                                     \
        bins tap_minus7 = {4'h9};                                     \
        bins tap_minus6 = {4'hA};                                     \
        bins tap_minus5 = {4'hB};                                     \
        bins tap_minus4 = {4'hC};                                     \
        bins tap_minus3 = {4'hD};                                     \
        bins tap_minus2 = {4'hE};                                     \
        bins tap_minus1 = {4'hF};}                                    \
                                                                      \
    CP_PL_RX_EQUALIZER_CMD:                                           \
      coverpoint rx_brc3_cg[_lanenum``][45:47] {                      \
        bins hold_nocmd   = {3'h0};                                   \
        bins decrement    = {3'h1};                                   \
        bins increment    = {3'h2};                                   \
        bins initialize   = {3'h5};                                   \
        bins preset_coeff = {3'h6};                                   \
        bins ind_sts      = {3'h7}; }                                 \
                                                                      \
    CP_PL_RX_EQUALIZER_STATUS:                                        \
      coverpoint rx_brc3_cg[_lanenum``][48:50] {                      \
        bins not_updated         = {3'h0};                            \
        bins updated             = {3'h1};                            \
        bins minimum             = {3'h2};                            \
        bins maximum             = {3'h3};                            \
        bins preset_executed     = {3'h4};                            \
        bins tap_not_implemented = {3'h6};                            \
        bins tap_implemented     = {3'h7};}                           \
                                                                      \
    CP_PL_RX_EQUALIZER_CMD_STATUS:                                    \
      coverpoint ({tx_equi_cmd, rx_equi_sts}) {                       \
        bins hold_notupdated       = {{3'h0, 3'h0}};                  \
        bins hold_updated          = {{3'h0, 3'h1}};                  \
        bins dec_notupdated        = {{3'h1, 3'h0}};                  \
        bins dec_updated           = {{3'h1, 3'h1}};                  \
        bins dec_min               = {{3'h1, 3'h2}};                  \
        bins inc_notupdated        = {{3'h2, 3'h0}};                  \
        bins inc_updated           = {{3'h2, 3'h1}};                  \
        bins inc_max               = {{3'h2, 3'h3}};                  \
        bins init_notupdated       = {{3'h5, 3'h0}};                  \
        bins init_updated          = {{3'h5, 3'h1}};                  \
        bins precoef_executed      = {{3'h6, 3'h4}};                  \
        bins precoef_notupdated    = {{3'h6, 3'h0}};                  \
        bins indsts_implemented    = {{3'h7, 3'h7}};                  \
        bins indsts_notimplemented = {{3'h7, 3'h6}};}                 \
  endgroup: CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE``_lanenum``                        


`define CG_GEN3_PL_TX_AET(_lanenum)                                   \
  covergroup  CG_GEN3_PL_TX_AET_LANE``_lanenum``;                     \
    option.per_instance = 1;                                          \
                                                                      \
    CP_PL_LANE_DEGRADED_N:                                            \
      coverpoint tx_lane_degraded[_lanenum``];                        \
                                                                      \
    CP_PL_LANE_TRAINED_N:                                             \
      coverpoint tx_lane_trained[_lanenum``];                         \
                                                                      \
    CP_PL_10G_RETRAIN_ENABLE_N:                                       \
      coverpoint retrain_en;                                          \
                                                                      \
    CP_PL_LANE_DEGRADED_TRAINED_10G_RETRAIN_ENABLE_N:                 \
      coverpoint tx_lane_degraded_trained_sync[_lanenum``];           \
                                                                      \
    CP_PL_TX_LANE:                                                    \
      coverpoint tx_lane_ready[_lanenum``] {                          \
        bins lane_ready = {1};}                                       \
                                                                      \
  endgroup: CG_GEN3_PL_TX_AET_LANE``_lanenum`` 
 
`define CG_GEN3_PL_TX_AET_TAP_CMDSTS(_lanenum)                        \
  covergroup  CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE``_lanenum``;          \
    option.per_instance = 1;                                          \
                                                                      \
    CP_PL_TX_EQUALIZER_TAP:                                           \
      coverpoint tx_brc3_cg[_lanenum``][41:44] {                      \
        bins tap0       = {4'h0};                                     \
        bins tap_plus1  = {4'h1};                                     \
        bins tap_plus2  = {4'h2};                                     \
        bins tap_plus3  = {4'h3};                                     \
        bins tap_plus4  = {4'h4};                                     \
        bins tap_plus5  = {4'h5};                                     \
        bins tap_plus6  = {4'h6};                                     \
        bins tap_plus7  = {4'h7};                                     \
        bins tap_minus8 = {4'h8};                                     \
        bins tap_minus7 = {4'h9};                                     \
        bins tap_minus6 = {4'hA};                                     \
        bins tap_minus5 = {4'hB};                                     \
        bins tap_minus4 = {4'hC};                                     \
        bins tap_minus3 = {4'hD};                                     \
        bins tap_minus2 = {4'hE};                                     \
        bins tap_minus1 = {4'hF};}                                    \
                                                                      \
    CP_PL_TX_EQUALIZER_CMD:                                           \
      coverpoint tx_brc3_cg[_lanenum``][45:47] {                      \
        bins hold_nocmd   = {3'h0};                                   \
        bins decrement    = {3'h1};                                   \
        bins increment    = {3'h2};                                   \
        bins initialize   = {3'h5};                                   \
        bins preset_coeff = {3'h6};                                   \
        bins ind_sts      = {3'h7}; }                                 \
                                                                      \
    CP_PL_TX_EQUALIZER_STATUS:                                        \
      coverpoint tx_brc3_cg[_lanenum``][48:50] {                      \
        bins not_updated         = {3'h0};                            \
        bins updated             = {3'h1};                            \
        bins minimum             = {3'h2};                            \
        bins maximum             = {3'h3};                            \
        bins preset_executed     = {3'h4};                            \
        bins tap_not_implemented = {3'h6};                            \
        bins tap_implemented     = {3'h7};}                           \
                                                                      \
    CP_PL_TX_EQUALIZER_CMD_STATUS:                                    \
      coverpoint ({tx_equi_cmd, tx_equi_sts}) {                       \
        bins hold_notupdated       = {{3'h0, 3'h0}};                  \
        bins hold_updated          = {{3'h0, 3'h1}};                  \
        bins dec_notupdated        = {{3'h1, 3'h0}};                  \
        bins dec_updated           = {{3'h1, 3'h1}};                  \
        bins dec_min               = {{3'h1, 3'h2}};                  \
        bins inc_notupdated        = {{3'h2, 3'h0}};                  \
        bins inc_updated           = {{3'h2, 3'h1}};                  \
        bins inc_max               = {{3'h2, 3'h3}};                  \
        bins init_notupdated       = {{3'h5, 3'h0}};                  \
        bins init_updated          = {{3'h5, 3'h1}};                  \
        bins precoef_executed      = {{3'h6, 3'h4}};                  \
        bins precoef_notupdated    = {{3'h6, 3'h0}};                  \
        bins indsts_implemented    = {{3'h7, 3'h7}};                  \
        bins indsts_notimplemented = {{3'h7, 3'h6}};}                 \
  endgroup: CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE``_lanenum``                                                                        

`define CG_GEN3_PL_RX_CODE_WORD(_lanenum)                             \
  covergroup  CG_GEN3_PL_RX_CODE_WORD_LANE``_lanenum``;               \
    option.per_instance = 1;                                          \
                                                                      \
    CP_PL_RX_TYPE_NOT_TYPE:                                           \
      coverpoint rx_brc3_cg[_lanenum``][1:2] {                        \
        bins type_nottype_val[] = {1,2};}                             \
                                                                      \
    CP_PL_RX_INVERTED:                                                \
      coverpoint rx_inverted_cg[_lanenum``] {                         \
      bins inverted_fld_val[] = {0,1};}                               \
                                                                      \
    CR_PL_RX_TYPE_NOT_TYPE_INVERTED :                                 \
      cross CP_PL_RX_TYPE_NOT_TYPE, CP_PL_RX_INVERTED;                \
                                                                      \
    CP_PL_RX_CC_TYPE:                                                 \
      coverpoint rx_brc3_cg[_lanenum``][33:34] {                      \
        bins cc_type_00   = {0};                                      \
        bins cc_type_csb  = {1};                                      \
        bins cc_type_cse  = {2};                                      \
        bins cc_type_cseb = {3};}                                     \
                                                                      \
    CP_PL_RX_DATA_TYPE:                                               \
      coverpoint rx_brc3_cg[_lanenum``][35:38] {                      \
        bins data_skip_marker  = {4'b1011};                           \
        bins data_lane_check   = {4'b1100};                           \
        bins data_descram_seed = {4'b1101};                           \
        bins data_skip         = {4'b1110};                           \
        bins data_sts_control  = {4'b1111};                           \
        bins data_00           = {4'b0000};}                          \
                                                                      \
    CR_PL_RX_CC_TYPE_DATA_TYPE:                                       \
      cross CP_PL_RX_CC_TYPE,  CP_PL_RX_DATA_TYPE{                    \
        ignore_bins not_reqd_bins = binsof(CP_PL_RX_CC_TYPE) intersect {[1:3]};    \
        bins skip_marker      = binsof(CP_PL_RX_CC_TYPE.cc_type_00) && binsof(CP_PL_RX_DATA_TYPE.data_skip_marker);    \
        bins lane_check       = binsof(CP_PL_RX_CC_TYPE.cc_type_00) && binsof(CP_PL_RX_DATA_TYPE.data_lane_check);     \
        bins descram_seed     = binsof(CP_PL_RX_CC_TYPE.cc_type_00) && binsof(CP_PL_RX_DATA_TYPE.data_descram_seed);   \
        bins skip             = binsof(CP_PL_RX_CC_TYPE.cc_type_00) && binsof(CP_PL_RX_DATA_TYPE.data_skip);           \
        bins data_sts_control = binsof(CP_PL_RX_CC_TYPE.cc_type_00) && binsof(CP_PL_RX_DATA_TYPE.data_sts_control);}   \
                                                                                      \
    CP_PL_RX_CSB_DATA_00:                                                             \
      cross CP_PL_RX_CC_TYPE, CP_PL_RX_DATA_TYPE {                                    \
        ignore_bins not_reqd_cc_type   = !binsof(CP_PL_RX_CC_TYPE)   intersect {1};   \
        ignore_bins not_reqd_data_type = !binsof(CP_PL_RX_DATA_TYPE) intersect {0};   \
        bins csb_data00  = binsof(CP_PL_RX_CC_TYPE.cc_type_csb) && binsof(CP_PL_RX_DATA_TYPE.data_00);} \
                                                                                      \
    CP_PL_RX_CSE_DATA_00:                                                             \
      cross CP_PL_RX_CC_TYPE, CP_PL_RX_DATA_TYPE{                                     \
        ignore_bins not_reqd_cc_type   = !binsof(CP_PL_RX_CC_TYPE)   intersect {2};   \
        ignore_bins not_reqd_data_type = !binsof(CP_PL_RX_DATA_TYPE) intersect {0};   \
        bins cse_data00  = binsof(CP_PL_RX_CC_TYPE.cc_type_cse) && binsof(CP_PL_RX_DATA_TYPE.data_00);} \
                                                                      \
  endgroup: CG_GEN3_PL_RX_CODE_WORD_LANE``_lanenum``                                            

`define CG_GEN3_PL_TX_CODE_WORD(_lanenum)                             \
  covergroup  CG_GEN3_PL_TX_CODE_WORD_LANE``_lanenum``;               \
    option.per_instance = 1;                                          \
                                                                      \
    CP_PL_TX_TYPE_NOT_TYPE:                                           \
      coverpoint tx_brc3_cg[_lanenum``][1:2] {                        \
        bins type_nottype_val[] = {1,2};}                             \
                                                                      \
    CP_PL_TX_INVERTED:                                                \
      coverpoint tx_inverted_cg[_lanenum``] {                         \
      bins inverted_fld_val[] = {0,1};}                               \
                                                                      \
    CR_PL_TX_TYPE_NOT_TYPE_INVERTED :                                 \
      cross CP_PL_TX_TYPE_NOT_TYPE, CP_PL_TX_INVERTED;                \
                                                                      \
    CP_PL_TX_CC_TYPE:                                                 \
      coverpoint tx_brc3_cg[_lanenum``][33:34] {                      \
        bins cc_type_00   = {0};                                      \
        bins cc_type_csb  = {1};                                      \
        bins cc_type_cse  = {2};                                      \
        bins cc_type_cseb = {3};}                                     \
                                                                      \
    CP_PL_TX_DATA_TYPE:                                               \
      coverpoint tx_brc3_cg[_lanenum``][35:38] {                      \
        bins data_skip_marker  = {4'b1011};                           \
        bins data_lane_check   = {4'b1100};                           \
        bins data_descram_seed = {4'b1101};                           \
        bins data_skip         = {4'b1110};                           \
        bins data_sts_control  = {4'b1111};                           \
        bins data_00           = {4'b0000};}                          \
                                                                      \
    CR_PL_TX_CC_TYPE_DATA_TYPE:                                       \
      cross CP_PL_TX_CC_TYPE,  CP_PL_TX_DATA_TYPE{                    \
        ignore_bins not_reqd_bins = binsof(CP_PL_TX_CC_TYPE) intersect {[1:3]}; \
        bins skip_marker      = binsof(CP_PL_TX_CC_TYPE.cc_type_00) && binsof(CP_PL_TX_DATA_TYPE.data_skip_marker);    \
        bins lane_check       = binsof(CP_PL_TX_CC_TYPE.cc_type_00) && binsof(CP_PL_TX_DATA_TYPE.data_lane_check);     \
        bins descram_seed     = binsof(CP_PL_TX_CC_TYPE.cc_type_00) && binsof(CP_PL_TX_DATA_TYPE.data_descram_seed);   \
        bins skip             = binsof(CP_PL_TX_CC_TYPE.cc_type_00) && binsof(CP_PL_TX_DATA_TYPE.data_skip);           \
        bins data_sts_control = binsof(CP_PL_TX_CC_TYPE.cc_type_00) && binsof(CP_PL_TX_DATA_TYPE.data_sts_control);}   \
                                                                                    \
    CP_PL_TX_CSB_DATA_00:                                                           \
      cross CP_PL_TX_CC_TYPE, CP_PL_TX_DATA_TYPE {                                  \
        ignore_bins not_reqd_cc_type   = !binsof(CP_PL_TX_CC_TYPE)   intersect {1}; \
        ignore_bins not_reqd_data_type = !binsof(CP_PL_TX_DATA_TYPE) intersect {0}; \
        bins csb_data00  = binsof(CP_PL_TX_CC_TYPE.cc_type_csb) && binsof(CP_PL_TX_DATA_TYPE.data_00);} \
                                                                                    \
    CP_PL_TX_CSE_DATA_00:                                                           \
      cross CP_PL_TX_CC_TYPE, CP_PL_TX_DATA_TYPE{                                   \
        ignore_bins not_reqd_cc_type   = !binsof(CP_PL_TX_CC_TYPE)   intersect {2}; \
        ignore_bins not_reqd_data_type = !binsof(CP_PL_TX_DATA_TYPE) intersect {0}; \
        bins cse_data00  = binsof(CP_PL_TX_CC_TYPE.cc_type_cse) && binsof(CP_PL_TX_DATA_TYPE.data_00);} \
                                                                              \
  endgroup: CG_GEN3_PL_TX_CODE_WORD_LANE``_lanenum``    


`define CG_GEN3_PL_RX_OS(_lanenum)                      \
  covergroup  CG_GEN3_PL_RX_OS_LANE``_lanenum;          \
    option.per_instance = 1;                            \
                                                        \
    CP_PL_RX_SKIP_OS:                                   \
      coverpoint rx_ctrl_cw_func_type[_lanenum``]{      \
        bins skip_os_done``_lanenum``_sts = (SKIP_MARKER=>SKIP=>SKIP=>SKIP=>LANE_CHECK=>DESCR_SEED=>DESCR_SEED);}   \
                                                        \
    CP_PL_RX_STATUS_CONTROL_OS:                         \
      coverpoint rx_ctrl_cw_func_type[_lanenum``]{      \
        bins stsctrl_os_done_lanenum``_sts = (STATUS_CNTL=>STATUS_CNTL);} \
                                                        \
    CP_PL_RX_SEED_OS:                                   \
      coverpoint rx_ctrl_cw_func_type[_lanenum``]{      \
        bins seed_os_done``_lanenum``_sts = (DESCR_SEED=>DESCR_SEED);}      \
                                                        \
    CP_PL_LANE_SYNC_N:                                  \
      coverpoint rx_lane_sync[_lanenum``];              \
                                                        \
  endgroup: CG_GEN3_PL_RX_OS_LANE``_lanenum                                                                      
   
`define CG_GEN3_PL_TX_OS(_lanenum)                      \
  covergroup  CG_GEN3_PL_TX_OS_LANE``_lanenum``;        \
    option.per_instance = 1;                            \
                                                        \
    CP_PL_TX_INCORRECT_SKIP:                            \
      coverpoint tx_ctrl_cw_func_type[_lanenum``]{      \
        bins incorrect_skip1 = (LANE_CHECK, DESCR_SEED, SKIP,STATUS_CNTL, CSB,     \
                                CSE, CSEB, DATA, INVALID_CW=>SKIP);                \
        bins incorrect_skip2 = (SKIP_MARKER=>SKIP_MARKER, LANE_CHECK,DESCR_SEED,   \
                                STATUS_CNTL, CSB, CSE, CSEB, DATA, INVALID_CW);    \
                                                                                   \
        bins incorrect_skip3 = (SKIP_MARKER=>SKIP=>SKIP=>SKIP=> SKIP_MARKER,       \
                                DESCR_SEED, SKIP, STATUS_CNTL, CSB, CSE, CSEB,     \
                                DATA, INVALID_CW);                                 \
                                                                                   \
        bins incorrect_skip4 = (SKIP_MARKER=>SKIP=>SKIP=>SKIP=>LANE_CHECK=>        \
                                SKIP_MARKER, LANE_CHECK, SKIP, STATUS_CNTL, CSB,   \
                                CSE, CSEB, DATA, INVALID_CW);                      \
                                                                                   \
        bins incorrect_skip5 = (SKIP_MARKER=>SKIP=>SKIP=>SKIP=>LANE_CHECK=>DESCR_SEED=> \
                                SKIP_MARKER, LANE_CHECK, SKIP, STATUS_CNTL, CSB, CSE,   \
                                CSEB, DATA, INVALID_CW);} \
                                                          \
    CP_PL_TX_SKIP_OS:                                     \
      coverpoint tx_ctrl_cw_func_type[_lanenum``]{        \
        bins skip_os_done``_lanenum``_sts = (SKIP_MARKER=>SKIP=>SKIP=>SKIP=>LANE_CHECK=>DESCR_SEED=>DESCR_SEED);}    \
                                                          \
    CP_PL_TX_STATUS_CONTROL_OS:                           \
      coverpoint tx_ctrl_cw_func_type[_lanenum``]{        \
        bins stsctrl_os_done``_lanenum``_sts = (STATUS_CNTL=>STATUS_CNTL);} \
                                                          \
    CP_PL_TX_SEED_OS:                                     \
      coverpoint tx_ctrl_cw_func_type[_lanenum``]{        \
        bins seed_os_done``_lanenum``_sts = (DESCR_SEED=>DESCR_SEED);} \
                                                          \
    CP_PL_TX_MULTI_LANE_OS_NONALIGN:                      \
      coverpoint tx_diffos_difflane{                      \
        bins nonalign_os = {1};}                          \
                                                          \
    CP_PL_LANE_SYNC_N:                                    \
      coverpoint tx_lane_sync[_lanenum``];                \
                                                          \
  endgroup: CG_GEN3_PL_TX_OS_LANE``_lanenum``           


`define SAMPLE_RX_LANE_DETAILS(_lanenum)                      \
    begin                                                     \
      if (env_config.num_of_lanes > _lanenum)                 \
      begin                                                   \
        while(1)                                              \
        begin                                                 \
          @(negedge pl_agent.pl_monitor.rx_monitor.lane_handle_ins[_lanenum``].divide_clk); \
          rx_brc3_cg[_lanenum``] = pl_agent.pl_monitor.rx_monitor.lane_handle_ins[_lanenum``].lane_data_ins.brc3_cg;   \
                                                                \
          if (rx_brc3_cg[_lanenum``][0])                        \
          begin                                                 \
            rx_brc3_cg[_lanenum``] = ~rx_brc3_cg[_lanenum``];   \
          end                                                   \
                                                                \
          rx_equi_cmd = rx_brc3_cg[_lanenum``][45:47];          \
          rx_equi_sts = rx_brc3_cg[_lanenum``][48:50];          \
                                                                \
          rx_ctrl_cw_func_type[_lanenum``] = brc3_cntl_cw_func_type'(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[_lanenum``].lane_data_ins.brc3_cntl_cw_type);  \
          rx_lane_degraded[_lanenum``]              = pl_agent.pl_agent_rx_trans.lane_degraded[_lanenum``];  \
          rx_lane_trained[_lanenum``]               = pl_agent.pl_agent_rx_trans.lane_trained[_lanenum``];   \
          rx_lane_sync[_lanenum``]                  = pl_agent.pl_agent_rx_trans.lane_sync[_lanenum``];      \
          rx_lane_degraded_trained_sync[_lanenum``] = rx_lane_degraded[_lanenum``] & rx_lane_sync[_lanenum``];   \
          rx_lane_ready[_lanenum``]                 = pl_agent.pl_monitor.rx_monitor.pl_link_mon_trans.lane_ready[_lanenum``];        \
                                                                  \
          CG_GEN3_PL_RX_CODE_WORD_LANE``_lanenum``.sample();      \
          CG_GEN3_PL_RX_OS_LANE``_lanenum``.sample();             \
          CG_GEN3_PL_RX_AET_LANE``_lanenum``.sample();            \
                                                                  \
          if (rx_brc3_cg[_lanenum``][33:38] == 6'b001111)         \
          begin                                                   \
            CG_GEN3_PL_RX_AET_TAP_CMDSTS_LANE``_lanenum``.sample(); \
          end                                                     \
        end                                                       \
      end                                                         \
    end           


`define SAMPLE_TX_LANE_DETAILS(_lanenum)                      \
    begin                                                     \
      if (env_config.num_of_lanes > _lanenum)                 \
      begin                                                   \
        while(1)                                              \
        begin                                                 \
          @(negedge pl_agent.pl_monitor.tx_monitor.lane_handle_ins[_lanenum``].divide_clk);  \
          tx_brc3_cg[_lanenum``] = pl_agent.pl_monitor.tx_monitor.lane_handle_ins[_lanenum``].lane_data_ins.brc3_cg;   \
          retrain_en = pl_agent.pl_config.retrain_en;             \
                                                                  \
          if (tx_brc3_cg[_lanenum``][0])                          \
          begin                                                   \
            tx_brc3_cg[_lanenum``] = ~tx_brc3_cg[_lanenum``];     \
          end                                                     \
                                                                  \
          tx_equi_cmd = tx_brc3_cg[_lanenum``][45:47];            \
          tx_equi_sts = tx_brc3_cg[_lanenum``][48:50];            \
                                                                  \
          tx_ctrl_cw_func_type[_lanenum``]       = brc3_cntl_cw_func_type'(pl_agent.pl_monitor.tx_monitor.lane_handle_ins[_lanenum``].lane_data_ins.brc3_cntl_cw_type); \
          tx_lane_degraded[_lanenum``]              = pl_agent.pl_agent_tx_trans.lane_degraded[_lanenum``];                         \
          tx_lane_trained[_lanenum``]               = pl_agent.pl_agent_tx_trans.lane_trained[_lanenum``];                          \
          tx_lane_sync[_lanenum``]                  = pl_agent.pl_agent_tx_trans.lane_sync[_lanenum``];                             \
          tx_lane_degraded_trained_sync[_lanenum``] = tx_lane_degraded[_lanenum``] & tx_lane_sync[_lanenum``]; \
          tx_lane_ready[_lanenum``]                 = pl_agent.pl_monitor.tx_monitor.pl_link_mon_trans.lane_ready[_lanenum``];     \
                                                            \
          CG_GEN3_PL_TX_CODE_WORD_LANE``_lanenum``.sample();\
          CG_GEN3_PL_TX_AET_LANE``_lanenum``.sample();      \
                                                            \
          if (tx_brc3_cg[_lanenum``][33:38] == 6'b001111)   \
          begin                                             \
            CG_GEN3_PL_TX_AET_TAP_CMDSTS_LANE``_lanenum``.sample();    \
          end                                               \
                                                            \
          for (int i=0; i<env_config.num_of_lanes; i++)     \
          begin                                             \
            tx_ctrl_cw_func_type_lane[i] = brc3_cntl_cw_func_type'(pl_agent.pl_monitor.tx_monitor.lane_handle_ins[i].lane_data_ins.brc3_cntl_cw_type);\
          end                                                \
          tx_diffos_difflane = ((tx_ctrl_cw_func_type_lane[15] != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[14] != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[13] != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[12] != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[11] != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[10] != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[9]  != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[8]  != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[7]  != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[6]  != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[5]  != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[4]  != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[3]  != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[2]  != tx_ctrl_cw_func_type_lane[0]) ||  \
                                (tx_ctrl_cw_func_type_lane[1]  != tx_ctrl_cw_func_type_lane[0]));   \
          CG_GEN3_PL_TX_OS_LANE``_lanenum``.sample();       \
        end                               \
      end                                 \
    end       

`define SAMPLE_TX_INVERTED_BIT(_lanenum)  \
    begin                                 \
      if (env_config.num_of_lanes > _lanenum)  \
      begin                              \
        while(1)                         \
        begin                            \
          @(pl_agent.pl_monitor.tx_monitor.lane_handle_ins[_lanenum``].lh_trans.invert_bit_high); \
          tx_inverted_cg[_lanenum``] = 1;\
          @(posedge divide_clk);         \
          tx_inverted_cg[_lanenum``] = 0;\
        end                              \
      end                                \
    end 

`define SAMPLE_RX_INVERTED_BIT(_lanenum)  \
    begin                                 \
      if (env_config.num_of_lanes > _lanenum)  \
      begin                              \
        while(1)                         \
        begin                            \
          @(pl_agent.pl_monitor.rx_monitor.lane_handle_ins[_lanenum``].lh_trans.invert_bit_high); \
          rx_inverted_cg[_lanenum``] = 1;\
          @(posedge divide_clk);         \
          rx_inverted_cg[_lanenum``] = 0;\
        end                              \
      end                                \
    end 


