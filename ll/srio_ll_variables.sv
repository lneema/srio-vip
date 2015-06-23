////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_variables.sv
// Project :  srio vip
// Purpose :  Logical Layer Variables
// Author  :  Mobiveil
//
// Contains the Enum variables used by the logical layer components
// 
//////////////////////////////////////////////////////////////////////////////// 
`define TX_EXP_RESP_ARRAY shared_class.tx_exp_resp_array 
`define RX_EXP_RESP_ARRAY shared_class.rx_exp_resp_array 

`define TX_RESP_TRACK_ARRAY shared_class.tx_resp_track_array 
`define RX_RESP_TRACK_ARRAY shared_class.rx_resp_track_array 

`define TX_LFC_ARRAY shared_class.tx_lfc_array 
`define RX_LFC_ARRAY shared_class.rx_lfc_array

`define TX_DS_TM_XOFF_ARRAY shared_class.tx_ds_tm_xoff_array 
`define RX_DS_TM_XOFF_ARRAY shared_class.rx_ds_tm_xoff_array 

`define TX_DS_TM_CREDIT_ARRAY shared_class.tx_ds_tm_credit_array 
`define RX_DS_TM_CREDIT_ARRAY shared_class.rx_ds_tm_credit_array 

`define TX_DS_XOFF_ALL shared_class.tx_ds_xoff_all 
`define RX_DS_XOFF_ALL shared_class.rx_ds_xoff_all 

`define TX_XOFF_CNT shared_class.tx_xoff_cnt_array 
`define RX_XOFF_CNT shared_class.rx_xoff_cnt_array 

`define TX_ORPHXOFF_TIMER_ARRAY shared_class.tx_orphxoff_timer_array
`define RX_ORPHXOFF_TIMER_ARRAY shared_class.rx_orphxoff_timer_array

`define TX_REQ_TRACK_ARRAY shared_class.tx_req_track_array
`define RX_REQ_TRACK_ARRAY shared_class.rx_req_track_array

`define TX_LAST_REQ shared_class.tx_last_req
`define RX_LAST_REQ shared_class.rx_last_req

`define TX_DS_TM_WC shared_class.tx_ds_tm_wc
`define RX_DS_TM_WC shared_class.rx_ds_tm_wc

`define TX_MSG_ARRAY shared_class.tx_msg_array
`define RX_MSG_ARRAY shared_class.rx_msg_array

`define TX_ATO_REQ_ARRAY shared_class.tx_ato_req_array
`define RX_ATO_REQ_ARRAY shared_class.rx_ato_req_array
///< Packet Arbitration type
typedef enum {
              SRIO_LL_RR,    ///< Round Robin
              SRIO_LL_WRR    ///< Based on the ratio programmed in the ll_config
              } pkt_arb_type;

///< Response generation mode
typedef enum {
              IMMEDIATE,  ///< Response generated immediately ,no delay
              RANDOM,     ///< Random delay
              DISABLED    ///< Response is not generated
             } srio_ll_resp_gen_mode;

typedef bit[39:0] index;

///< Flow Arbitration command values
typedef enum {
              XOFF           =  0, // 4'b0000,
              XOFF_ARB0      =  2, // 4'b0010,
              XOFF_ARB1      =  3, // 4'b0011,
              RELEASE0       =  4, // 4'b0100,
              RELEASE1       =  5, // 4'b0101,
              XON            =  8, // 4'b1000, 
              XON_ARB0       = 10, // 4'b1010, 
              XON_ARB1       = 11, // 4'b1011, 
              REQ_SINGLE0    = 12, // 4'b1100, 
              REQ_SINGLE1    = 13, // 4'b1101, 
              REQ_MULTI0     = 14, // 4'b1110, 
              REQ_MULTI1     = 15  // 4'b1111                  
             }flow_arb_cmd;

typedef enum{
              PRI0,
              PRI1,
              PRI2,
              PRI3I
             }pkt_prio;

///< FTYPE ENUM 
typedef enum {
               TYPE0          =  0,
               TYPE1          =  1,
               TYPE2          =  2,
               TYPE3          =  3,
               TYPE4          =  4, 
               TYPE5          =  5, 
               TYPE6          =  6, 
               TYPE7          =  7, 
               TYPE8          =  8, 
               TYPE9          =  9,
               TYPE10         = 10, 
               TYPE11         = 11,
               TYPE12         = 12, 
               TYPE13         = 13, 
               TYPE14         = 14,
               TYPE15         = 15  
             } srio_ftype;

///< TTYPE for FTYPE1
typedef enum {
              RD_OWNER        =  0,
              RD_OWN_OWNER    =  1,
              IO_RD_OWNER     =  2
             }type1_ttype;

///< TTYPE for FTYPE2
typedef enum {
              RD_HOME         =  0, 
              RD_OWN_HOME     =  1, 
              IORD_HOME       =  2,    
              DKILL_HOME      =  3,    
              NRD             =  4, 
              IKILL_HOME      =  5,    
              TLBIE           =  6, 
              TLBSYNC         =  7, 
              IRD_HOME        =  8,    
              FLUSH_WO_DATA   =  9,    
              IKILL_SHARER    = 10 ,     
              DKILL_SHARER    = 11 ,     
              ATO_INC         = 12 ,  
              ATO_DEC         = 13 ,
              ATO_SET         = 14 ,  
              ATO_CLR         = 15   
             }type2_ttype;

///< TTYPE for FTYPE5
typedef enum {
              CAST_OUT        =  0, 
              FLUSH_WD        =  1, 
              NWR             =  4,
              NWR_R           =  5,
              ATO_SWAP        = 12,
              ATO_COMP_SWAP   = 13, 
              ATO_TEST_SWAP   = 14 
             }type5_ttype;

///< TTYPE for FTYPE8
typedef enum {
              MAINT_RD_REQ         =  0, 
              MAINT_WR_REQ         =  1, 
              MAINT_RD_RES         =  2,
              MAINT_WR_RES         =  3, 
              MAINT_PORT_WR_REQ    =  4
             }type8_ttype;

///< TTYPE for FTYPE13
typedef enum {
              RES_WO_DP            =  0, 
              MSG_RES              =  1, 
              RES_WITH_DP          =  8,
              RESERVED_RES_TTYPE2  =  2,
              RESERVED_RES_TTYPE3  =  3,
              RESERVED_RES_TTYPE4  =  4,
              RESERVED_RES_TTYPE5  =  5,
              RESERVED_RES_TTYPE6  =  6,
              RESERVED_RES_TTYPE7  =  7,
              RESERVED_RES_TTYPE9  =  9,
              RESERVED_RES_TTYPE10 =  10,
              RESERVED_RES_TTYPE11 =  11,
              RESERVED_RES_TTYPE12 =  12,
              RESERVED_RES_TTYPE13 =  13,
              RESERVED_RES_TTYPE14 =  14,
              RESERVED_RES_TTYPE15 =  15
             }type13_ttype;

///< Various response status
typedef enum {
              STS_DONE            =  0, 
              STS_DATA_ONLY       =  1,
              STS_NOT_OWNER       =  2,
              STS_RETRY           =  3, 
              STS_INTERVENTION    =  4, 
              STS_DONE_INT        =  5,
              STS_ERROR           =  7,
              STS_RESERVED6       =  6,
              STS_RESERVED8       =  8,
              STS_RESERVED9       =  9,
              STS_RESERVED10      =  10,
              STS_RESERVED11      =  11,
              STS_RESERVED12      =  12,
              STS_RESERVED13      =  13,
              STS_RESERVED14      =  14,
              STS_RESERVED15      =  15
             }pkt_sts;

typedef enum {
              FLOW_0A             =  0, // 7'b0000000,
              FLOW_0B             =  1, // 7'b0000001,
              FLOW_0C             =  2, // 7'b0000010,
              FLOW_0D             =  3, // 7'b0000011,
              FLOW_0E             =  4, // 7'b0000100,
              FLOW_0F             =  5, // 7'b0000101,
              FLOW_1A             = 65, // 7'b1000001,
              FLOW_2A             = 66, // 7'b1000010,
              FLOW_3A             = 67, // 7'b1000011,
              FLOW_4A             = 68, // 7'b1000100,
              FLOW_5A             = 69, // 7'b1000101,
              FLOW_6A             = 70, // 7'b1000110,
              FLOW_7A             = 71, // 7'b1000111,
              FLOW_8A             = 72  // 7'b1001000
             }flowid;

typedef class srio_ll_base_generator; 
typedef class srio_ds_generator; 
typedef class srio_ll_common_class;
typedef class srio_ll_txrx_monitor;
typedef class srio_gsm_generator;  
typedef class srio_ll_config;       
typedef class srio_io_generator;   
typedef class srio_ll_ds_assembly;   
typedef class srio_logical_transaction_generator;
typedef class srio_lfc_generator;  
typedef class srio_ll_monitor;       
typedef class srio_msg_db_generator;
typedef class srio_ll_msg_assembly;  
typedef class srio_ll_lfc_assembly;  
typedef class srio_packet_handler;
typedef class srio_ll_agent;       
typedef class srio_ll_sequencer;     
typedef class srio_resp_generator;
typedef class srio_ll_bfm;         
typedef class srio_ll_shared_class;
