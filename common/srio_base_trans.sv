////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_base_trans.sv
// Project :  srio vip
// Purpose :  Sequence Base Item
// Author  :  Mobiveil
//
// SRIO VIP's Base Sequence Item. Includes all the packets/control symbols
// Fields along with misc fields.
////////////////////////////////////////////////////////////////////////////////
  
typedef enum {TRUE = 1, FALSE = 0} bool;

typedef enum {LL_DONE = 0, LL_DATA_ONLY = 1, LL_NOT_OWNER = 2, LL_RETRY = 3, LL_INTERV = 4,
              LL_DONE_INTERV = 5, LL_ERROR = 7, LL_NO_RESP = 256} srio_ll_response_kind;

typedef enum {TL_NULL_ERR, DEST_ID_MISMATCH_ERR, UNSUPPORTED_TT_ERR, RESERVED_TT_ERR} tl_err_type;

typedef enum {PL_ACCEPT = 0, PL_NOT_ACCEPT = 1,PL_RETRY = 2} srio_pl_ack_kind;

typedef enum {UNEXP_ACKID = 0, BAD_CRC = 1, PKT_RECP_STOP = 2, PKT_BAD_CRC = 3,
              INV_CHAR = 4,PNA_LBF_RES = 5, LOSS_DSCR=6, GNRL_ERR = 7} srio_pl_nac_cause;

typedef enum {SRIO_LL_PACKET,SRIO_TL_PACKET,SRIO_PL_PACKET,SRIO_PL_CS} layer_pkt;

typedef enum {PKT_ACC, PKT_RETRY, PKT_NACC, RSVD_STYPE0, STATUS, VC_STATUS, 
              LINK_RESP, IMP_DEF} brc12_stype0_type;

typedef enum {SOP, STOMP, EOP, RFR, LINK_REQ, MULTICAST, RSVD_STYPE1, NOP} brc12_stype1_type;

typedef enum {CS24,CS48,CS64} cs_type;

typedef enum {SRIO_CS, SRIO_PACKET,SRIO_STATE_MC} pl_trans_kind;

typedef enum {SRIO_DELIM_SC,SRIO_DELIM_PD} brc12_cs_kind;

typedef enum {NONE, MAX_SIZE_ERR, FTYPE_ERR, TTYPE_ERR, PAYLOAD_ERR, RESP_RSVD_STS_ERR,
              RESP_PRI_ERR, RESP_PAYLOAD_ERR, SIZE_ERR, NO_PAYLOAD_ERR, PAYLOAD_EXIST_ERR,
              ATAS_PAYLOAD_ERR, AS_PAYLOAD_ERR, ACAS_PAYLOAD_ERR, DW_ALIGN_ERR, LFC_PRI_ERR,
              DS_MTU_ERR, DS_PDU_ERR, DS_SOP_ERR, DS_EOP_ERR, DS_ODD_ERR, DS_PAD_ERR,
              MSG_SSIZE_ERR, MSGSEG_ERR, SRC_OP_UNSUPPORTED_ERR, DEST_OP_UNSUPPORTED_ERR,
              OUTSTANDING_REQ_ERR, OUTSTANDING_SEQNO_ERR, UNEXP_RESP_ERR, UNEXP_RESP_STS_ERR,
              HOP_COUNT_ERR, TM_BLOCKED_DS_ERR, LFC_BLOCKED_PKT_ERR, MISSING_DS_CONTEXT_ERR,  
              DSSEG_ERR, REQ_TIMEOUT_ERR, RESP_TIMEOUT_ERR, VC_ERR, INVALID_PRI_ERR,
              INVALID_FLOWID_ERR, REQ_PIPELINING_ERR, IMPROPER_RELEASE_ERR, INVALID_FLOWARB_CMD_ERR,
              NONZERO_RESERVED_FLD_ERR, REG_CONFIG_ERR, RESERVED_MASK_ERR, RESERVED_PARAMETER_ERR, 
              RESERVED_TMOP_ERR} ll_err_kind;

typedef enum {NO_ERR,EARLY_CRC_ERR,FINAL_CRC_ERR,LINK_CRC_ERR,ACKID_ERR,CS_FIELD_COR,
              PSR_COR,CSMARKER_COR,DESC_SYNC_BREAK,CS_FIELD_TRU,PSR_TRU,CSMARKER_TRU,
              CSFIELD_UPDATE} pl_err_kind;

typedef enum {FTYPE0 = 0,FTYPE1,FTYPE2,FTYPE3,FTYPE4,FTYPE5,FTYPE6,FTYPE7,FTYPE8,
              FTYPE9,FTYPE10,FTYPE11,FTYPE12,FTYPE13,FTYPE14,FTYPE15} srio_trans_ftype;

typedef enum {READ_OWNER = 0, READ_OWN_OWNER, IO_READ_OWNER}srio_trans_ttype1;

typedef enum {READ_HOME = 0,READ_OWN_HOME, IO_READ_HOME,D_KILL_HOME,NREAD,I_KILL_HOME,
              TLB_IE,TLB_SYNC,IREAD_HOME, FLUSH_WITHOUT_DATA,I_KILL_SHARER, 
              D_KILL_SHARER,ATOMIC_INC,ATOMIC_DEC,ATOMIC_SET,ATOMIC_CLR}srio_trans_ttype2;

typedef enum {CASTOUT= 0,FLUSH_WITH_DATA = 1,NWRITE=4,NWRITE_R=5,ATOMIC_SWAP=12,
              ATOMIC_COMP_SWAP=13,ATOMIC_TEST_SWAP=14}srio_trans_ttype5; 

typedef enum {MAINT_READ_REQ= 0,MAINT_WRITE_REQ,MAINT_READ_RES,MAINT_WRITE_RES,
              MAINT_PORT_WRITE_REQ}srio_trans_ttype8; 

typedef enum {RES_WITHOUT_DPL= 0,MSG_RESPONSE=1,RES_WITH_DPL=8}srio_trans_ttype13;

typedef enum {IO = 0,MSG_DB,DS,GSM,LFC,RESP,INVALID}srio_ll_gen_kind;
 
class srio_base_trans extends uvm_sequence_item;

  srio_env_config env_config;                                  ///< Pointer to env config object 
  layer_pkt pkt_type = SRIO_LL_PACKET;                         ///< Indicates the layer 

  /// @cond
  int                     dpl_size                       = 0;  // Data Payload size in the packet
  bit                     retry_reqd                     = 0;  // Gets set when the packet receives retry response    
  bit                     tl_pkt_valid                   = 0;
  tl_err_type             tl_err_detected                   ;  ///< TL Error detected by the TL monitor
  rand tl_err_type        tl_err_kind                       ;  ///< TL Error kind to be injected
  /// @endcond

  bit                     tl_err_encountered             = 0;
  bit                     ll_err_encountered             = 0;
  bit          [2:0]      ll_pkt_type                    = 0;
  bit                     msg_type                       = 0;

  rand  bit    [3:0]      ftype                          = 0;  ///< Packet Field: Format Type 
  rand  bit    [31:0]     SourceID                       = 0;  ///< Packet Field: Source ID
  rand  bit    [31:0]     DestinationID                  = 0;  ///< Packet Field: Destination ID
  bit          [1:0]      tt                             = 0;  ///< Packet Field: Transport Type    
  rand  bit    [7:0]      payload[$]                        ;  ///< Packet Field: Data Payload   
  rand  bit               crf                            = 0;  ///< Packet Field: CRF    
  rand  bit    [1:0]      prio                           = 0;  ///< Packet Field: Priority        
  bit   signed [4095:0]   packed_bitstream                  ;  //   Packed Bytestream        

  // I/O Packet Fields
  rand  bit               wdptr                          = 0;  ///< Packet Field: wdptr -WD Pointer       
  rand  bit    [3:0]      wrsize                         = 0;  ///< Packet Field: Write Size         
  rand  bit    [3:0]      rdsize                         = 0;  ///< Packet Field: Read Size      
  randc bit    [7:0]      SrcTID                         = 0;  ///< Packet Field: Source Transaction ID    
  rand  bit    [3:0]      ttype                          = 0;  ///< Packet Field: Transaction Type       
  rand  bit    [31:0]     ext_address                    = 0;  ///< Packet Field: Extended Address      
  rand  bit    [28:0]     address                        = 0;  ///< Packet Field: Address       
  rand  bit    [1:0]      xamsbs                         = 0;  ///< Packet Field: MSB of Extended Address        
  rand  bit    [20:0]     config_offset                  = 0;  ///< Packet Field: DW offset into the CAR/CSR reg block for reads and writes      
  rand  bit    [7:0]      hop_count                         ;  ///< Packet Field: Hop Count     

  // Message/DB Packet Fields  
  rand  bit    [3:0]      msg_len                        = 0;  ///< Packet Field: Message Length (Number of segments in a Msg)       
  rand  bit    [3:0]      ssize                          = 0;  ///< Packet Field: Segment Size      
  rand  bit    [1:0]      letter                         = 0;  ///< Packet Field: Identifies a slot within a mailbox   
  rand  bit    [1:0]      mbox                           = 0;  ///< Packet Field: Target Mail Box      
  rand  bit    [3:0]      msgseg_xmbox                   = 0;  ///< Packet Field: Msg Seg/Upper 4 bits of the Mailbox     
  rand  bit    [7:0]      info_lsb                       = 0;  ///< Packet Field: Info LSB     
  rand  bit    [7:0]      info_msb                       = 0;  ///< Packet Field: Info MSB      
  rand  int               message_length                 = 0;          

  // Data Stream Packet Fields  
  rand  bit               S                              = 0;  ///< Packet Field: Start Segment
  rand  bit               E                              = 0;  ///< Packet Field: End Segment 
  rand  bit               O                              = 0;  ///< Packet Field: Odd       
  rand  bit               P                              = 0;  ///< Packet Field: Pad      
  rand  bit               xh                             = 0;  ///< Packet Field: Extended Header     
  randc bit    [7:0]      cos                            = 0;  ///< Packet Field: Class of Service       
  rand  bit    [2:0]      xtype                          = 0;  ///< Packet Field: 1-> Indicates TM Packet      
  rand  bit    [2:0]      wild_card                      = 0;  ///< Packet Field: Wild card         
  rand  bit    [7:0]      parameter1                     = 0;  ///< Packet Field: Parameter 1       
  rand  bit    [7:0]      parameter2                     = 0;  ///< Packet Field: Parameter 2       
  rand  bit    [3:0]      TMOP                           = 0;  ///< Packet Field: TM Operand       
  rand  bit    [7:0]      mask                           = 0;  ///< Packet Field: Mask       
  rand  bit    [15:0]     streamID                       = 0;  ///< Packet Field: Stream ID         
  rand  bit    [15:0]     pdulength                      = 0;  ///< Packet Field: PDU Lengh         
  rand  bit    [7:0]      mtusize                        = 0;  ///< Packet Field: MTU Size        
       
  // GSM Packet Fields  
  rand  bit    [7:0]      SecTID                         = 0;  ///< Packet Field: Secondary TID      
  rand  bit    [3:0]      SecID                          = 0;  ///< Packet Field: Secondary ID        
  rand  bit    [3:0]      sec_domain                     = 0;  ///< Packet Field: Secondary Domain         
   

  // LFC Packet Fields
  rand  bit    [31:0]     tgtdestID                      = 0;  ///< Packet Field: Target Destination ID      
  rand  bit    [2:0]      FAM                            = 0;  ///< Packet Field: Flow Arbitration Message       
  rand  bit    [6:0]      flowID                         = 0;  ///< Packet Field: Flow ID    
  rand  bit               SOC                            = 0;  ///< Packet Field: Source of Congestion    
  rand  bit               xon_xoff                       = 0;  ///< Packet Field: XON/XOFF   

  // Response Packet Fields  
  rand  bit    [7:0]      targetID_Info                  = 0;  ///< Packet Field: Target ID Info     
  rand  bit    [3:0]      trans_status                   = 0;  ///< Packet Field: Transaction Status        
  
  // ERROR fields  
  bit                     ackID_err                      = 0;      
  rand  bit               payload_err                    = 0;      
  rand  bit               crc_err                        = 0;     
  rand  bit               stomp_err                      = 0;
  rand  bit               wdptr_rdsize_err               = 0;
  rand  bit               wdptr_wrsize_err               = 0;
  byte  unsigned          bytestream[]                      ;
  byte  unsigned          bytestream_cs[]                   ;
  ll_err_kind             ll_err_detected                   ;  ///< LL Error detected by the LL monitor
  rand  ll_err_kind       ll_err_kind                       ;  ///< LL Error kind to be injected

  // pl fields
  rand  bit               sop                            = 0;  
  rand  bit               eop                            = 0;
  rand  bit    [0:11]     ackid                          = 0; 
  rand  bit    [0:5]      gen3_ackid_msb                 = 0; 
  rand  bit    [3:0]      vcid                           = 0;
  rand  bit    [0:31]     crc32                          = 0;
  rand  bit               crc32_err                      = 0;
  rand  bit    unsigned[8:0]payload_size                    ;
  bit                     vc                             = 0;
  bit          [0:15]     early_crc                      = 0;
  bit          [0:15]     final_crc                      = 0;
  bit                     early_crc_err                  = 0;
  bit                     final_crc_err                  = 0;
  int                     pad_gen3                       = 0;
  int                     pad                            = 0; 
  rand  pl_err_kind       pl_err_kind                       ; //= NONE;
  bit                     pl_err_encountered             = 0;
  pl_trans_kind           transaction_kind               = SRIO_PACKET;
  brc12_cs_kind           cs_kind                          ;
  init_sm_states          current_state, next_state        ;

  // cs fields
  cs_type                 cstype                         = CS48;
  rand  bit    [0:7]      delimiter                      = 0;
  rand  bit    [0:3]      stype0                         = 4'b0100;
  rand  bit    [0:11]     param0                         = 0;
  rand  bit    [0:11]     param1                         = 0;
  rand  bit    [0:2]      stype1                         = 3'b111;
  rand  bit    [0:1]      brc3_stype1_msb                = 2'b00;
  rand  bit    [0:2]      cmd                            = 0;
  rand  bit    [0:13]     reserved                       = 14'b0;
  rand  bit    [0:4]      cs_crc5                        = 0;
  rand  bit    [0:12]     cs_crc13                       = 0;
  rand  bit    [0:23]     cs_crc24                       = 0;
  bit                     cs_crc5_err                    = 0;
  bit                     cs_crc13_err                   = 0;
  bit                     cs_crc24_err                   = 0;
 
  int                     total_hdr_byte                 = 0;
  int                     total_pkt_bytes                = 0;
  int                     total_pld_byte                 = 0;
  int                     crc_bytes                         ;
  int                     gen3_crc_bytes                    ;
  int                     gen3_pad_bytes                    ;
  bit                     usr_gen_pkt                    = 0;  ///< Indicates that the packet is completely generated by user
  logic        [31:0]     gen3_data_q[$]                    ;

  // Misc fields
  bit                     usr_directed_pl_response_en    = 0;
  bit                     usr_directed_pl_ack_en         = 0;
  bit                     usr_directed_ll_response_en    = 0;  ///< Enable/disable the response value given by user 
  int                     usr_directed_port_status       = 0;
  int                     usr_directed_pl_ack_delay         ;
  integer                 usr_directed_pl_response_delay = 0;
  integer                 usr_directed_ll_response_delay = 0;  ///< Response delay vaue from user
  srio_ll_response_kind   usr_directed_ll_response_type  = LL_DONE; ///< Response status value from user
  srio_pl_ack_kind        usr_directed_pl_ack_type          ;
  srio_pl_nac_cause       usr_directed_pl_nac_cause         ;
  srio_ll_gen_kind        ll_gen_kind                    = IO;  ///< Indicates the Packet group, IO,GSM,MSG_DB,DS,LFC,RESP

  bit          [31:0]     ll_rd                          = 0;   // Used to store the response delay value of this packet
  bit          [31:0]     ll_rd_cnter                    = 0;   // Used as counter for response delay and timeout logic
  bit          [31:0]     lfc_orphan_cnter               = 0;   // User as counter for LFC orphan timing functionality
  bit          [31:0]     pl_rd                          = 0;  
  bit          [31:0]     pl_rd_cnter                    = 0;
  bit          [31:0]     pl_pkt_rd                      = 0;  
  bit          [31:0]     pl_pkt_rd_cnter                = 0;
  bit          [31:0]     ll_pkt_id                      = 0;  // Stores the packet id

  rand         int        packet_gap                     = 0;  ///<Delay for the packet
  /// @cond
  `uvm_object_utils_begin(srio_base_trans)
    uvm_default_packer.use_metadata = 1;
    `uvm_field_int(ftype               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SourceID            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(DestinationID       , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(tt                  , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(crf                 , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(prio                , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(wdptr               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(wrsize              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(rdsize              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SrcTID              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(ttype               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(ext_address         , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(address             , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(xamsbs              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(config_offset       , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(hop_count           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(msg_len             , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(ssize               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(letter              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(mbox                , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(msgseg_xmbox        , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(info_lsb            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(info_msb            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(cos                 , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(S                   , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(E                   , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(O                   , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(P                   , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(xh                  , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(xtype               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(wild_card           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(parameter1          , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(parameter2          , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(TMOP                , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(mask                , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(streamID            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(pdulength           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(mtusize             , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SecTID              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SecID               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(sec_domain          , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(tgtdestID           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(xon_xoff            , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(SOC                 , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(flowID              , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(targetID_Info       , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(trans_status        , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(ackid               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(vc                  , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(crc32               , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(early_crc           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
    `uvm_field_int(final_crc           , UVM_ALL_ON|UVM_NOPACK|UVM_NOPRINT|UVM_NOCOPY|UVM_NOCOMPARE)
  `uvm_object_utils_end 
  /// @endcond

  // Constraints
  constraint ll_err {  ll_err_kind inside { NONE} ;}
  constraint tl_err {  tl_err_kind inside { TL_NULL_ERR} ;}
  constraint pl_err {  pl_err_kind inside { NO_ERR} ;}
  constraint tt_c {tt inside {[0:2]};}
  constraint Ftype {ftype dist {1:=5, 2:=10 ,5:=10, 6:=10, 7:=2, 8:=10, 9:=15, 10:=10, 11:=15};}

  constraint Ttype {
             if      (ftype == 4'h1) {ttype inside {[0:2]};}
             else if (ftype == 4'h2) {ttype inside {[0:15]};} 
             else if (ftype == 4'h5) {ttype inside {0,1,4,5,12,13,14};}
             else if (ftype == 4'h8) {ttype inside {0,1,4};}
             else                    {ttype inside {0};}}
 
  constraint prior {
             if (ftype == 4'h7) {prio inside {3};} 
             else               {prio inside {[0:2]};}}

  constraint Crf {
             if (ftype == 4'h7) {crf inside {1};}
             else               {crf inside {0,1};}}

  constraint Ftype_1 { 
             if((ftype == 4'h1) && ((ttype == 4'h0) || (ttype == 4'h1) || (ttype == 4'h2))) {
               SecID inside{[0:15]}; SecTID inside{[0:15]}; sec_domain inside{[0:15]};}
             else {
               SecID inside{0};      SecTID inside{0};      sec_domain inside{0};}}

  // wdptr and wrsize are randomly generated in SWrite to generate random payload
  // It will be reassigned with 0 while packing
  constraint Wdptr { 
             if       ((ftype == 4'h5) && (ttype == 4'hD))  {wdptr inside {1};} 
             else if  ((ftype == 4'h2) && ((ttype == 4'h3) || (ttype == 4'h5) || (ttype == 4'h6) || 
                                           (ttype == 4'h7) || (ttype == 4'h9) || (ttype == 4'hA) || 
                                           (ttype == 4'hB) ))   
                                                            {wdptr inside {0};} 
             else                                           {wdptr inside {0,1};}}

  constraint wrsize_0 {
             if (((ftype == 4'h2) && 
                  (ttype == 4'h4 || ttype== 4'hC || ttype == 4'hD || ttype == 4'hE || ttype == 4'hF)) || 
                  (ftype == 4'h6)                                                                     ||      
                 ((ftype == 4'h5) && 
                  (ttype == 4'h4 || ttype == 4'h5 ))) {  
               if (wdptr == 1'b0)   {wrsize inside {[0:12]};}
               else                 {wrsize inside {[0:13],15};}}
             else if(((ftype == 4'h2) && 
                      !(ttype == 4'h4  || ttype== 4'hC || ttype == 4'hD || ttype == 4'hE || ttype == 4'hF )) || 
                      ((ftype == 4'h5) && 
                      !(ttype == 4'hC || ttype == 4'hD || ttype == 4'hE ))) {
               if(wdptr == 1'b0)  {wrsize inside {[0:12]};}
               else               {wrsize inside {[0:12]};}}
             else if ((ftype == 4'h8) && ((ttype == 4'h1) ||  (ttype == 4'h4))) {wrsize inside {8,11,12};}
             else if ((ftype == 4'h5) && (ttype == 4'hE ||ttype == 4'hC  )) {
               if (wdptr == 1'b0) {wrsize inside {[0:3],4,6,8};}
               else               {wrsize inside{[0:3],4,6,8};}}
             else if ((ftype == 4'h5) && (ttype == 4'hD)) {
               if (wdptr == 1'b1) {wrsize inside {11};}
               else               {wrsize inside{0};}}
             else                 {wrsize inside{0};}}


  constraint rdsize_0 {                                   // GSM Packet
             if (((ftype == 4'h2) && 
                 ((ttype == 4'h0) || (ttype == 4'h1) || (ttype == 4'h2) || (ttype == 4'h8)))  ||      
                 ((ftype == 4'h1) && 
                  (ttype == 4'h0 || ttype== 4'h1 || ttype == 4'h2)))   
                  {rdsize inside {[0:12]};}
             else if ((ftype == 4'h2) && (ttype == 4'h4)) // NREAD 
                  {rdsize inside {[0:15]};}
             else if ((ftype == 4'h2) && 
                 (ttype== 4'hC || ttype == 4'hD || ttype == 4'hE || ttype == 4'hF ))  
                  {rdsize inside {[0:3],4,6,8};}          // ATOMIC
             else if((ftype == 4'h8) && (ttype == 4'h0))  // MAINTENANCE
                  {rdsize inside {8,11,12};}
             else {rdsize inside{0};}}      
                   
  constraint ext_adress_xamsbs{
             if((ftype == 4'h1) || (ftype == 4'h2 && ttype != 4'h7) || (ftype == 4'h5) || (ftype == 4'h6)) {
               address inside {[0:29'h1FFF_FFFF]}; xamsbs inside {[0:3]}; ext_address inside {[0:32'hFFFF_FFFF]};}
             else {
               address inside{0};                 xamsbs inside{0};      ext_address inside{0};}}
    
  constraint Ftype_7_xon_xoff { 
             if (ftype == 4'h7){xon_xoff inside{0,1};}
             else              {xon_xoff inside{0};}}

  constraint Ftype_7 {
             if (ftype == 4'h7){tgtdestID inside{[0:32'hFFFF_FFFF]}; SOC inside{0,1};}
             else              {tgtdestID inside{0};                 SOC inside{0};}}

  constraint Ftype7_flowid {
             if(ftype == 4'h7){
               if (vc == 1'b1){flowID inside {[0:5],[65:72]};}
               else           {flowID inside {[0:5]};}}
             else             {flowID inside {0};}}

  constraint Ftype_7_fam {
             if(ftype == 4'h7) {
               if(xon_xoff == 1'b0){FAM inside {0,2,3,4,5};}
               else                {FAM inside {0,2,3,4,5,6,7};}}
             else                  {FAM inside{0};}}
     
  constraint Ftype_8 {
             if(ftype == 4'h8) {config_offset inside {[0:21'h1F_FFFF]};} 
             else              {config_offset inside{0}; targetID_Info inside{0};}}        
     
  constraint Xh{
             if(ftype == 4'h9) {xh inside {0,1};} 
             else              {xh inside {0};}}

  constraint Ftype_9 {
             if((ftype == 4'h9) && (xh == 1'b0)) {pdulength inside {[0:16'hFFFF]};}
             else                                {pdulength inside{0};}}

  constraint Ftype_9A {
             if ((ftype == 4'h9) && (xh == 1'b0)) {S inside{0,1};E inside{0,1};O inside{0,1};P inside{0,1};}
             else                                 {S inside{0};  E inside{0};  O inside{0};  P inside{0};}}

  constraint streamid {
             if((ftype == 4'h9) && ( xh == 1'b0 || xh == 1'b1)) {streamID inside{[0:16'hFFFF]};} 
             else                                               {streamID inside{0};}}

  constraint Ftype_9_Xtype {
             if ((ftype == 4'h9) && (xh == 1'b1)) {xtype inside {0}; mask inside {0,1,3,7,15,31,63,127,255};}
             else                                 {xtype inside {0}; mask inside {0};}}

  constraint traffic_mgt {
             if ((ftype == 4'h9) && (xh == 1'b1)) {wild_card inside {0,1,3,7};} 
             else                                 {wild_card inside {0};}}

  constraint Tmop {
             if ((ftype == 4'h9) && (xh == 1'b1)) {TMOP inside {[0:2]};} 
             else                                 {TMOP inside {0};}} 

  constraint traffic_parameter1 {
             if       ((ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h0)) {parameter1 inside {0,3};}
             else {if ((ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h1)) {parameter1 inside {[0:3],5,6};}
             else {if ((ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h2)) {parameter1 inside {0,[16:48]};}
             else                                                         {parameter1 inside {0};}}}}

  constraint Ftype_9_TM_0 {
             if      ((ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h0 || TMOP == 4'h1 || TMOP == 4'h2 ) && (parameter1 == 8'h0 )){
               parameter2 inside {0,255};} 
             else if ((ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h1) && (parameter1 == 8'h1 || parameter1 == 8'h5 )) {
               parameter2 inside {[0:255]};}
             else if( (ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h1) && (parameter1 == 8'h2 || parameter1 == 8'h3 || parameter1 == 8'h6)) {
               parameter2 inside {[1:255]};}
             else if ((ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h2) && (parameter1 >= 16 && parameter1 <=31)) {  
               parameter2 inside {[0:255]};}
             else if ((ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h2) && (parameter1 >=32 && parameter1 <=47)) {
               parameter2 inside {[0:255]};}
             else if ((ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h2) && (parameter1 == 48 )) {
               parameter2 inside {[0:255]};}
             else if ((ftype == 4'h9) && (xh == 1'b1) && (TMOP == 4'h0) && (parameter1 == 8'h3 )) {
               parameter2 inside {[0:255]};}
             else {
               parameter2 inside {0};}}  

  constraint Ftype_A {
             if(ftype == 4'hA) {info_lsb inside {[0:255]};info_msb inside {[0:255]};}
             else              {info_lsb inside {0};      info_msb inside{0};} }

  constraint Ftype_B {
             if(ftype == 4'hB) {ssize inside {[9:14]};}
             else              {ssize inside  {0};}}

  constraint Ftype_B_2 {
             if(ftype == 4'hB) {message_length inside {[1:(2**(ssize-9)*16)]};}
             else              {message_length inside{0};}}

  constraint Ftype_B_1 { 
             if(ftype == 4'hB) {
               msg_len inside{[0:15]}; msgseg_xmbox inside {[0:15]}; mbox inside{[0:3]};letter inside{[0:3]};}
             else {
               msg_len inside{0};      msgseg_xmbox inside{0};       mbox inside{0};    letter inside{0};}}

  constraint trans_status_c { 
             if(ftype == 4'hD) {trans_status inside {0,1,2,3,4,5,7};}
             else              {trans_status inside{0};}}
   
  constraint Ftype_8_hop {
             if( ftype == 4'h8) {hop_count inside {[0:255]};} 
             else               {hop_count inside {0};}}

  constraint Stype0 {stype0 inside {[0:6]};}
          
  constraint stype0_const {
             if       (stype0 == 3'b010) {param1 inside {[1:7],31};} 
             else {if (stype0 == 3'b110) {param1 inside {2,4,5,16};}
             else                        {param1 inside {6'h3F} ;}}}

  constraint Stype1 {stype1 inside {[0:5],7};} 

  constraint Stype1_const { 
             if (stype1 == 3'b100) {cmd inside {3,4};}
             else                  {cmd == 3'b0;}}
  constraint packet_gap_c {packet_gap inside {[0:100]};}  //Constraint for the packet delay

  extern function new(string name="srio_base_trans");

endclass: srio_base_trans

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n 
/// Description: srio_base_trans's new function \n
/// new
//////////////////////////////////////////////////////////////////////////////// 

function srio_base_trans::new(string name="srio_base_trans");
  super.new(name);
endfunction : new

// =============================================================================

