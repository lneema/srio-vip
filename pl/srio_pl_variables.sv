////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_pl_variables.sv
// Project    :  srio vip
// Purpose    :  Declares all enum types, parameters and defines used by PL components.
// Author     :  Mobiveil
//
// Physical layer variables.
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////


typedef enum {BRC1, BRC2, BRC3} baud_rate_class;
typedef enum {TRANSMIT, RECEIVE} flow_control;
typedef enum {PL_IMMEDIATE, PL_RANDOM, PL_DISABLED} ack_gen_kind;
typedef enum {PL_PKT_IMMEDIATE,PL_PKT_RANDOM,PL_PKT_DISABLED} pkt_resp_kind;
typedef enum {CMD_ENABLED,CMD_DISABLED} aet_cmd_drive_kind;
typedef enum {TAPPLUS,TAPMINUS,RST,PRST,CMD_RANDOM} aet_cmd_type;
typedef enum {TP_HOLD,TP_INCR,TP_DECR,TP_RANDOM} aet_tplus_kind;
typedef enum {TM_HOLD,TM_INCR,TM_DECR,TM_RANDOM} aet_tminus_kind;

//gen3 dme training
typedef enum {DME_CMD_ENABLED,DME_CMD_DISABLED} dme_trn_cmd_drive_kind;
typedef enum {DME_HOLD,DME_DECR,DME_INCR,DME_INIT,DME_PRST,DME_CMD_RANDOM} dme_cmd_type;
typedef enum {DME_CMD_COEF0,DME_CMD_COEFPLUS1,DME_CMD_COEFMINUS1} dme_cmd_tap_type;
typedef enum {DME_STCS_NOT_UPDATED,DME_STCS_UPDATED,DME_STCS_MIN,DME_STCS_MAX} dme_stcs_type;
typedef enum {COEF0_INCR,COEF0_DECR,COEF0_INIT,COEF0_PRST,COEF0_RANDOM} dme_coef0_kind;
typedef enum {COEFPLUS1_INCR,COEFPLUS1_DECR,COEFPLUS1_INIT,COEFPLUS1_PRST,COEFPLUS1_RANDOM} dme_coefplus1_kind;
typedef enum {COEFMINUS1_INCR,COEFMINUS1_DECR,COEFMINUS1_INIT,COEFMINUS1_PRST,COEFMINUS1_RANDOM} dme_coefminus1_kind;
//gen3 cw training 
typedef enum {CW_CMD_ENABLED,CW_CMD_DISABLED} cw_trn_cmd_drive_kind;
typedef enum {CW_HOLD,CW_DECR,CW_INCR,CW_RSVD1,CW_RSVD2,CW_INIT,CW_PRST,CW_SPC_CMD_STAT,CW_CMD_RANDOM} cw_cmd_type;
typedef enum {CW_CMD_TAP0,CW_CMD_TPLUS1,CW_CMD_TPLUS2,CW_CMD_TPLUS3,CW_CMD_TPLUS4,CW_CMD_TPLUS5,CW_CMD_TPLUS6,CW_CMD_TPLUS7,CW_CMD_TMINUS8,CW_CMD_TMINUS7,CW_CMD_TMINUS6,CW_CMD_TMINUS5,CW_CMD_TMINUS4,CW_CMD_TMINUS3,CW_CMD_TMINUS2,CW_CMD_TMINUS1,CW_CMD_TRANDOM} cw_cmd_tap_type;
typedef enum {STCS_NOT_UPDATED,STCS_UPDATED,STCS_MIN,STCS_MAX,STCS_PRST_CMD_EXC,STCS_RSVD,STCS_TAP_NI,STCS_TAP_IMP} cw_eq_stcs_type;
typedef enum {TP0_INCR,TP0_DECR,TP0_INIT,TP0_PRST,TP0_RANDOM} cw_tp0_kind;
typedef enum {TPLUS1_INCR,TPLUS1_DECR,TPLUS1_INIT,TPLUS1_PRST,TPLUS1_RANDOM} cw_tplus1_kind;
typedef enum {TPLUS2_INCR,TPLUS2_DECR,TPLUS2_INIT,TPLUS2_PRST,TPLUS2_RANDOM} cw_tplus2_kind;
typedef enum {TPLUS3_INCR,TPLUS3_DECR,TPLUS3_INIT,TPLUS3_PRST,TPLUS3_RANDOM} cw_tplus3_kind;
typedef enum {TPLUS4_INCR,TPLUS4_DECR,TPLUS4_INIT,TPLUS4_PRST,TPLUS4_RANDOM} cw_tplus4_kind;
typedef enum {TPLUS5_INCR,TPLUS5_DECR,TPLUS5_INIT,TPLUS5_PRST,TPLUS5_RANDOM} cw_tplus5_kind;
typedef enum {TPLUS6_INCR,TPLUS6_DECR,TPLUS6_INIT,TPLUS6_PRST,TPLUS6_RANDOM} cw_tplus6_kind;
typedef enum {TPLUS7_INCR,TPLUS7_DECR,TPLUS7_INIT,TPLUS7_PRST,TPLUS7_RANDOM} cw_tplus7_kind;
typedef enum {TMINUS8_INCR,TMINUS8_DECR,TMINUS8_INIT,TMINUS8_PRST,TMINUS8_RANDOM} cw_tminus8_kind;
typedef enum {TMINUS7_INCR,TMINUS7_DECR,TMINUS7_INIT,TMINUS7_PRST,TMINUS7_RANDOM} cw_tminus7_kind;
typedef enum {TMINUS6_INCR,TMINUS6_DECR,TMINUS6_INIT,TMINUS6_PRST,TMINUS6_RANDOM} cw_tminus6_kind;
typedef enum {TMINUS5_INCR,TMINUS5_DECR,TMINUS5_INIT,TMINUS5_PRST,TMINUS5_RANDOM} cw_tminus5_kind;
typedef enum {TMINUS4_INCR,TMINUS4_DECR,TMINUS4_INIT,TMINUS4_PRST,TMINUS4_RANDOM} cw_tminus4_kind;
typedef enum {TMINUS3_INCR,TMINUS3_DECR,TMINUS3_INIT,TMINUS3_PRST,TMINUS3_RANDOM} cw_tminus3_kind;
typedef enum {TMINUS2_INCR,TMINUS2_DECR,TMINUS2_INIT,TMINUS2_PRST,TMINUS2_RANDOM} cw_tminus2_kind;
typedef enum {TMINUS1_INCR,TMINUS1_DECR,TMINUS1_INIT,TMINUS1_PRST,TMINUS1_RANDOM} cw_tminus1_kind;
 
typedef enum {POS, NEG} running_disparity;

typedef enum {IDLE_NORMAL,IDLE_COMPEN,IDLE_DESCR_SYNC,STATUS_CS,PKT_STATE,CS_STATE} idle_states;
typedef enum {IDLE3_DME_FM,IDLE3_DME_COF_UP,IDLE3_DME_STCS,IDLE3_DME_TRN_PAT,IDLE3_PSR,IDLE3_SCOS1,IDLE3_SCOS2,IDLE3_SOOS1,IDLE3_SOOS2,IDLE3_COMPEN_LC,IDLE3_COMPEN_SM,IDLE3_COMPEN_SC1,IDLE3_COMPEN_SC2,IDLE3_COMPEN_SC3,IDLE3_PKT_STATE,IDLE3_CS_STATE} idle3_states;
typedef enum {MERGE_NORMAL,MERGE_NORMAL_G3,MERGE_IES,MERGE_IES_G3,MERGE_OES,MERGE_OES_G3,MERGE_IRS,MERGE_IRS_G3,MERGE_ORS,MERGE_ORS_G3} merge_states;

typedef enum {PACKET,CS,STATE_MC} srio_pl_trans_kind;
typedef enum {MERGED_PKT,MERGED_CS} merge_type;

typedef enum {SKIP_MARKER, LANE_CHECK, DESCR_SEED, SKIP, STATUS_CNTL, CSB, CSE, CSEB, DATA, INVALID_CW} brc3_cntl_cw_func_type;

typedef class srio_pl_pktcs_merger;
typedef class srio_pl_pkt_handler;

parameter SRIO_K = 8'hBC;
parameter SRIO_A = 8'hFB;
parameter SRIO_R = 8'hFD;
parameter SRIO_M = 8'h3C;
parameter SRIO_SC = 8'h1C;
parameter SRIO_PD = 8'h7C;
parameter SRIO_D00 = 8'h00;
parameter SRIO_D21_5 = 8'hB5;
parameter SRIO_D10_2 = 8'h4A;
parameter SRIO_INVALID = 10'h100;
parameter SRIO_IDLE3_D00 = 64'h0000_0000_0000_0000;
bit [0:9] INVALID_CG_ARR[0:3]='{10'h100,10'h044,10'h035,10'h3B5};

`define GEN1_COMMA_CHAR (lane_data_ins.character == SRIO_K && lane_data_ins.cntl == 1)
`define GEN2_COMMA_CHAR ((lane_data_ins.character == SRIO_K || lane_data_ins.character == SRIO_M) && lane_data_ins.cntl == 1)
