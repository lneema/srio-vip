////////////////////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File       :  srio_gen_trans_tracker.sv
// Project    :  srio vip
// Purpose    :  Writes the transactions to the tracker file.
// Author     :  Mobiveil
//
// Transaction tracker methods.
//
//
//////////////////////////////////////////////////////////////////////////////////////////////////

class srio_gen_trans_tracker;

  integer file_h;				///< File handler instance.
  srio_trans_ttype1   trans_ttype1; 		///< Variable used to store the srio_trans_ttype1 cast of ttype.
  srio_trans_ttype2   trans_ttype2;  		///< Variable used to store the srio_trans_ttype2 cast of ttype.
  srio_trans_ttype5   trans_ttype5;  		///< Variable used to store the srio_trans_ttype5 cast of ttype.
  srio_trans_ttype8   trans_ttype8;  		///< Variable used to store the srio_trans_ttype8 cast of ttype.
  srio_trans_ttype13  trans_ttype13; 		///< Variable used to store the srio_trans_ttype13 cast of ttype.

  srio_env_config trans_tracker_env_config;	///< Env config instance.



  ///////////////////////////////////////////////////////////////////////////////////////////////
  /// Name : bfm_tx_pkt_tracker
  /// Description : Writes the BFM TX packet into the tracker file.
  ///////////////////////////////////////////////////////////////////////////////////////////////
  task bfm_tx_pkt_tracker(srio_trans temp_pc_trans_ins);
  
    int i = 0;
    int dpl_size;

    trans_ttype1   = srio_trans_ttype1'(temp_pc_trans_ins.ttype);
    trans_ttype2   = srio_trans_ttype2'(temp_pc_trans_ins.ttype);
    trans_ttype5   = srio_trans_ttype5'(temp_pc_trans_ins.ttype);
    trans_ttype8   = srio_trans_ttype8'(temp_pc_trans_ins.ttype);
    trans_ttype13  = srio_trans_ttype13'(temp_pc_trans_ins.ttype);
 
            if (temp_pc_trans_ins.ftype == 1)
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO %s PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t rdsize     = %0h\t SrcTID     = %0h\t sec_domain = %0h\n\
  \t SecID      = %0h\t SecTID     = %0h\t ext_addr   = %0h\n\
  \t xamsbs     = %0h\t wdptr      = %0h\t addr       = %0h\n", 
  trans_ttype1.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.rdsize, temp_pc_trans_ins.SrcTID, temp_pc_trans_ins.sec_domain,
  temp_pc_trans_ins.SecID, temp_pc_trans_ins.SecTID, temp_pc_trans_ins.ext_address,
  temp_pc_trans_ins.xamsbs, temp_pc_trans_ins.wdptr, temp_pc_trans_ins.address);
            end // }
  
            else if (temp_pc_trans_ins.ftype == 2)
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO %s PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t rdsize     = %0h\t SrcTID     = %0h\n\
  \t ext_addr   = %0h\n\
  \t xamsbs     = %0h\t wdptr      = %0h\t addr       = %0h\n",  
  trans_ttype2.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.rdsize, temp_pc_trans_ins.SrcTID, temp_pc_trans_ins.ext_address,
  temp_pc_trans_ins.xamsbs, temp_pc_trans_ins.wdptr, temp_pc_trans_ins.address);
            end // }
  
            else if (temp_pc_trans_ins.ftype == 5)
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO %s PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t wrsize     = %0h\t SrcTID     = %0h\n\
  \t ext_addr   = %0h\n\
  \t xamsbs     = %0h\t wdptr      = %0h\t addr       = %0h\n",  
  trans_ttype5.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.wrsize, temp_pc_trans_ins.SrcTID, temp_pc_trans_ins.ext_address,
  temp_pc_trans_ins.xamsbs, temp_pc_trans_ins.wdptr, temp_pc_trans_ins.address);
            end // }
  
            else if (temp_pc_trans_ins.ftype == 6)
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO SWRITE PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t ext_addr   = %0h\n\
  \t xamsbs     = %0h\t                    addr       = %0h\n\
                                           SrcID      = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc,   temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, 
  temp_pc_trans_ins.ext_address,temp_pc_trans_ins.xamsbs, 
  temp_pc_trans_ins.address,temp_pc_trans_ins.SourceID);
            end // }
  
            else if (temp_pc_trans_ins.ftype == 7)
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO LFC PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t xon_xoff   = %0h\t tgtdestID  = %0h\n\
  \t FAM        = %0h\t flowID     = %0h\t SOC        = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.xon_xoff, 
  temp_pc_trans_ins.tgtdestID, temp_pc_trans_ins.FAM, temp_pc_trans_ins.flowID,
  temp_pc_trans_ins.SOC);
            end // }
  
  
            else if ((temp_pc_trans_ins.ftype == 8) && (temp_pc_trans_ins.ttype == 0))
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO %s PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t rdsize     = %0h\t SrcTID     = %0h\t hop_count  = %0h\n\
  \t cfg_off    = %0h\t wdptr      = %0h\n", 
  trans_ttype8.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.rdsize, temp_pc_trans_ins.SrcTID,
  temp_pc_trans_ins.hop_count, temp_pc_trans_ins.config_offset,
  temp_pc_trans_ins.wdptr);
            end // }
  
            else if ((temp_pc_trans_ins.ftype == 8) && 
                    ((temp_pc_trans_ins.ttype == 1) || (temp_pc_trans_ins.ttype == 4)))
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO %s PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t wrsize     = %0h\t SrcTID     = %0h\t hop_count  = %0h\n\
  \t cfg_off    = %0h\t wdptr      = %0h\n", 
  trans_ttype8.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.wrsize, temp_pc_trans_ins.SrcTID,
  temp_pc_trans_ins.hop_count, temp_pc_trans_ins.config_offset,
  temp_pc_trans_ins.wdptr);
            end // }
  
  
            else if ((temp_pc_trans_ins.ftype == 8) && 
                    ((temp_pc_trans_ins.ttype == 2) || (temp_pc_trans_ins.ttype == 3)))
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO %s PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t status     = %0h\t TarTID     = %0h\t hop_count  = %0h\n\
  \t cfg_off    = %0h\t wdptr      = %0h\n", 
  trans_ttype8.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.trans_status, temp_pc_trans_ins.targetID_Info,
  temp_pc_trans_ins.hop_count, temp_pc_trans_ins.config_offset,
  temp_pc_trans_ins.wdptr);
            end // }
  
  
            else if (temp_pc_trans_ins.ftype == 8)
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " FTYPE_8 SRIO MAINTENANCE PACKET WITH RESERVED TTYPE RECEIVED in BFM TX : \n\
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t rdsize     = %0h\t SrcTID     = %0h\t hop_count  = %0h\n\
  \t wrsize     = %0h\t TarTID     = %0h\n\
  \t status     = %0h\t wdptr      = %0h\n\
  \t cfg_off    = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.rdsize, temp_pc_trans_ins.SrcTID, temp_pc_trans_ins.hop_count,
  temp_pc_trans_ins.wrsize, temp_pc_trans_ins.targetID_Info,
  temp_pc_trans_ins.trans_status, temp_pc_trans_ins.wdptr, 
  temp_pc_trans_ins.config_offset);
            end // }
  
            else if ((temp_pc_trans_ins.ftype == 9) && (temp_pc_trans_ins.xh))
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO DS TRAFFIC MGT PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t cos        = %0h\n\
  \t Start      = %0h\t End        = %0h\t xh         = %0h\n\
  \t Odd        = %0h\t Pad        = %0h\t streamID   = %0h\n\
  \t TMOP       = %0h\t wild_card  = %0h\t mask       = %0h\n\
  \t xtype      = %0h\t parameter1 = %0h\t parameter2 = %0h\n\
                                           SrcID      = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid,   
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,  
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.cos,  
  temp_pc_trans_ins.S, temp_pc_trans_ins.E, temp_pc_trans_ins.xh, temp_pc_trans_ins.O, 
  temp_pc_trans_ins.P, temp_pc_trans_ins.streamID, temp_pc_trans_ins.TMOP, 
  temp_pc_trans_ins.wild_card, temp_pc_trans_ins.mask, temp_pc_trans_ins.xtype, 
  temp_pc_trans_ins.parameter1, temp_pc_trans_ins.parameter2,temp_pc_trans_ins.SourceID);
            end // }

            else if (temp_pc_trans_ins.ftype == 9)
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO DS PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t cos        = %0h\n\
  \t Start      = %0h\t End        = %0h\t xh         = %0h\n\
  \t Odd        = %0h\t Pad        = %0h\t streamID   = %0h\n\
  \t pdu_len    = %0h                      SrcID      = %0h\n", 
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.cos,
  temp_pc_trans_ins.S, temp_pc_trans_ins.E, temp_pc_trans_ins.xh,
  temp_pc_trans_ins.O, temp_pc_trans_ins.P, temp_pc_trans_ins.streamID,
  temp_pc_trans_ins.pdulength,temp_pc_trans_ins.SourceID);
            end // }
  
            else if (temp_pc_trans_ins.ftype == 10)
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO DOOR BELL PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t info_msb   = %0h\t info_lsb   = %0h\n\
  \t                    SrcTID     = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.info_msb, temp_pc_trans_ins.info_lsb, temp_pc_trans_ins.SrcTID);
            end // }
  
  
            else if (temp_pc_trans_ins.ftype == 11)
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO MESSAGE PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t msg_len    = %0h\t ssize      = %0h\t letter     = %0h\n\
  \t mbox       = %0h\t MsgsegXmbox= %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.msg_len, temp_pc_trans_ins.ssize, temp_pc_trans_ins.letter,
  temp_pc_trans_ins.mbox, temp_pc_trans_ins.msgseg_xmbox); 
            end // }
  
  
            else if (temp_pc_trans_ins.ftype == 13) 
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO %s PACKET RECEIVED in BFM TX : \n \
  \t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t status     = %0h\t TarTID     = %0h\n", 
  trans_ttype13.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.trans_status, temp_pc_trans_ins.targetID_Info);
            end // }
  
            else  
            begin // {
              $fwrite(file_h, "==> @%0t", $time, " SRIO PACKET WITH RESERVED FTYPE RECEIVED in BFM TX");
            end // }

            $fwrite(file_h, "  \t Early_CRC  = %h\t\t Final_CRC  = %h\t\t LINK CRC32  =%h\t\t\n\n",
            temp_pc_trans_ins.early_crc, temp_pc_trans_ins.final_crc,temp_pc_trans_ins.crc32); 
           
            dpl_size = temp_pc_trans_ins.payload.size(); 
            if (dpl_size > 0) 
            begin // {
              $fwrite (file_h, "\tData Payload\n"); 
              while ((dpl_size - i) >= 4) 
              begin // {
                $fwrite (file_h, "\t D[%0d]:%h \t D[%0d]:%h \t D[%0d]:%h \t D[%0d]:%h\n", 
                i, temp_pc_trans_ins.payload[i], i+1, temp_pc_trans_ins.payload[i+1], 
                i+2, temp_pc_trans_ins.payload[i+2], i+3, temp_pc_trans_ins.payload[i+3]);
                i = i + 4;  
              end // }
              if ((dpl_size - i) == 3) 
                $fwrite (file_h, "\t D[%0d]:%h \t D[%0d]:%h \t D[%0d]:%h\n", i, temp_pc_trans_ins.payload[i], 
                i+1, temp_pc_trans_ins.payload[i+1], i+2, temp_pc_trans_ins.payload[i+2]);
              else if ((dpl_size - i) == 2) 
                $fwrite (file_h, "\t D[%0d]:%h \t D[%0d]:%h \n", i, temp_pc_trans_ins.payload[i], 
                i+1, temp_pc_trans_ins.payload[i+1]);
              else if ((dpl_size - i) == 1) 
                $fwrite (file_h, "\t D[%0d]:%h\n", i, temp_pc_trans_ins.payload[i]);
              $fwrite (file_h, "\n");
            end // }   
  
  endtask: bfm_tx_pkt_tracker
  


  ///////////////////////////////////////////////////////////////////////////////////////////////
  /// Name : bfm_rx_pkt_tracker
  /// Description : Writes the BFM RX packet into the tracker file.
  ///////////////////////////////////////////////////////////////////////////////////////////////
  task bfm_rx_pkt_tracker(srio_trans temp_pc_trans_ins);
  
    int i = 0;
    int dpl_size;

    trans_ttype1   = srio_trans_ttype1'(temp_pc_trans_ins.ttype);
    trans_ttype2   = srio_trans_ttype2'(temp_pc_trans_ins.ttype);
    trans_ttype5   = srio_trans_ttype5'(temp_pc_trans_ins.ttype);
    trans_ttype8   = srio_trans_ttype8'(temp_pc_trans_ins.ttype);
    trans_ttype13  = srio_trans_ttype13'(temp_pc_trans_ins.ttype);
 
            if (temp_pc_trans_ins.ftype == 1)
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO %s PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t rdsize     = %0h\t SrcTID     = %0h\t sec_domain = %0h\n\
  \t\t\t\t\t\t\t SecID      = %0h\t SecTID     = %0h\t ext_addr   = %0h\n\
  \t\t\t\t\t\t\t xamsbs     = %0h\t wdptr      = %0h\t addr       = %0h\n", 
  trans_ttype1.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.rdsize, temp_pc_trans_ins.SrcTID, temp_pc_trans_ins.sec_domain,
  temp_pc_trans_ins.SecID, temp_pc_trans_ins.SecTID, temp_pc_trans_ins.ext_address,
  temp_pc_trans_ins.xamsbs, temp_pc_trans_ins.wdptr, temp_pc_trans_ins.address);
            end // }
  
            else if (temp_pc_trans_ins.ftype == 2)
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO %s PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t rdsize     = %0h\t SrcTID     = %0h\n\
  \t\t\t\t\t\t\t ext_addr   = %0h\n\
  \t\t\t\t\t\t\t xamsbs     = %0h\t wdptr      = %0h\t addr       = %0h\n",  
  trans_ttype2.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.rdsize, temp_pc_trans_ins.SrcTID, temp_pc_trans_ins.ext_address,
  temp_pc_trans_ins.xamsbs, temp_pc_trans_ins.wdptr, temp_pc_trans_ins.address);
            end // }
  
            else if (temp_pc_trans_ins.ftype == 5)
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO %s PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t wrsize     = %0h\t SrcTID     = %0h\n\
  \t\t\t\t\t\t\t ext_addr   = %0h\n\
  \t\t\t\t\t\t\t xamsbs     = %0h\t wdptr      = %0h\t addr       = %0h\n",  
  trans_ttype5.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.wrsize, temp_pc_trans_ins.SrcTID, temp_pc_trans_ins.ext_address,
  temp_pc_trans_ins.xamsbs, temp_pc_trans_ins.wdptr, temp_pc_trans_ins.address);
            end // }
  
            else if (temp_pc_trans_ins.ftype == 6)
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO SWRITE PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t ext_addr   = %0h\n\
  \t\t\t\t\t\t\t xamsbs     = %0h\t                    addr       = %0h\n\
  \t\t\t\t\t\t\t                                       SrcID      = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc,   temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, 
  temp_pc_trans_ins.ext_address,temp_pc_trans_ins.xamsbs, 
  temp_pc_trans_ins.address,temp_pc_trans_ins.SourceID);
            end // }
  
            else if (temp_pc_trans_ins.ftype == 7)
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO LFC PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t xon_xoff   = %0h\t tgtdestID  = %0h\n\
  \t\t\t\t\t\t\t FAM        = %0h\t flowID     = %0h\t SOC        = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.xon_xoff, 
  temp_pc_trans_ins.tgtdestID, temp_pc_trans_ins.FAM, temp_pc_trans_ins.flowID,
  temp_pc_trans_ins.SOC);
            end // }
  
  
            else if ((temp_pc_trans_ins.ftype == 8) && (temp_pc_trans_ins.ttype == 0))
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO %s PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t rdsize     = %0h\t SrcTID     = %0h\t hop_count  = %0h\n\
  \t\t\t\t\t\t\t cfg_off    = %0h\t wdptr      = %0h\n", 
  trans_ttype8.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.rdsize, temp_pc_trans_ins.SrcTID,
  temp_pc_trans_ins.hop_count, temp_pc_trans_ins.config_offset,
  temp_pc_trans_ins.wdptr);
            end // }
  
            else if ((temp_pc_trans_ins.ftype == 8) && 
                    ((temp_pc_trans_ins.ttype == 1) || (temp_pc_trans_ins.ttype == 4)))
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO %s PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t wrsize     = %0h\t SrcTID     = %0h\t hop_count  = %0h\n\
  \t\t\t\t\t\t\t cfg_off    = %0h\t wdptr      = %0h\n", 
  trans_ttype8.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.wrsize, temp_pc_trans_ins.SrcTID,
  temp_pc_trans_ins.hop_count, temp_pc_trans_ins.config_offset,
  temp_pc_trans_ins.wdptr);
            end // }
  
  
            else if ((temp_pc_trans_ins.ftype == 8) && 
                    ((temp_pc_trans_ins.ttype == 2) || (temp_pc_trans_ins.ttype == 3)))
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO %s PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t status     = %0h\t TarTID     = %0h\t hop_count  = %0h\n\
  \t\t\t\t\t\t\t cfg_off    = %0h\t wdptr      = %0h\n", 
  trans_ttype8.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.trans_status, temp_pc_trans_ins.targetID_Info,
  temp_pc_trans_ins.hop_count, temp_pc_trans_ins.config_offset,
  temp_pc_trans_ins.wdptr);
            end // }
  
  
            else if (temp_pc_trans_ins.ftype == 8)
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " FTYPE_8 SRIO MAINTENANCE PACKET WITH RESERVED TTYPE RECEIVED in BFM RX : \n\
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t rdsize     = %0h\t SrcTID     = %0h\t hop_count  = %0h\n\
  \t\t\t\t\t\t\t wrsize     = %0h\t TarTID     = %0h\n\
  \t\t\t\t\t\t\t status     = %0h\t wdptr      = %0h\n\
  \t\t\t\t\t\t\t cfg_off    = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.rdsize, temp_pc_trans_ins.SrcTID, temp_pc_trans_ins.hop_count,
  temp_pc_trans_ins.wrsize, temp_pc_trans_ins.targetID_Info,
  temp_pc_trans_ins.trans_status, temp_pc_trans_ins.wdptr, 
  temp_pc_trans_ins.config_offset);
            end // }

            else if ((temp_pc_trans_ins.ftype == 9) && (temp_pc_trans_ins.xh))
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO DS TRAFFIC MGT PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t cos        = %0h\n\
  \t\t\t\t\t\t\t Start      = %0h\t End        = %0h\t xh         = %0h\n\
  \t\t\t\t\t\t\t Odd        = %0h\t Pad        = %0h\t streamID   = %0h\n\
  \t\t\t\t\t\t\t TMOP       = %0h\t wild_card  = %0h\t mask       = %0h\n\
  \t\t\t\t\t\t\t xtype      = %0h\t parameter1 = %0h\t parameter2 = %0h\n\
  \t\t\t\t\t\t\t                                       SrcID      = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid,   
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,  
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.cos,  
  temp_pc_trans_ins.S, temp_pc_trans_ins.E, temp_pc_trans_ins.xh, temp_pc_trans_ins.O, 
  temp_pc_trans_ins.P, temp_pc_trans_ins.streamID, temp_pc_trans_ins.TMOP, 
  temp_pc_trans_ins.wild_card, temp_pc_trans_ins.mask, temp_pc_trans_ins.xtype, 
  temp_pc_trans_ins.parameter1, temp_pc_trans_ins.parameter2,
  temp_pc_trans_ins.SourceID);
            end // }

            else if (temp_pc_trans_ins.ftype == 9)
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO DS PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t cos        = %0h\n\
  \t\t\t\t\t\t\t Start      = %0h\t End        = %0h\t xh         = %0h\n\
  \t\t\t\t\t\t\t Odd        = %0h\t Pad        = %0h\t streamID   = %0h\n\
  \t\t\t\t\t\t\t pdu_len    = %0h                      SrcID      = %0h\n", 
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.cos,
  temp_pc_trans_ins.S, temp_pc_trans_ins.E, temp_pc_trans_ins.xh,
  temp_pc_trans_ins.O, temp_pc_trans_ins.P, temp_pc_trans_ins.streamID,
  temp_pc_trans_ins.pdulength,temp_pc_trans_ins.SourceID);
            end // }

            else if (temp_pc_trans_ins.ftype == 10)
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO DOOR BELL PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t info_msb   = %0h\t info_lsb   = %0h\n\
  \t\t\t\t\t\t\t                    SrcTID     = %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.info_msb, temp_pc_trans_ins.info_lsb, temp_pc_trans_ins.SrcTID);
            end // }
  
  
            else if (temp_pc_trans_ins.ftype == 11)
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO MESSAGE PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t msg_len    = %0h\t ssize      = %0h\t letter     = %0h\n\
  \t\t\t\t\t\t\t mbox       = %0h\t MsgsegXmbox= %0h\n",
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.msg_len, temp_pc_trans_ins.ssize, temp_pc_trans_ins.letter,
  temp_pc_trans_ins.mbox, temp_pc_trans_ins.msgseg_xmbox); 
            end // }
  
  
            else if (temp_pc_trans_ins.ftype == 13) 
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO %s PACKET RECEIVED in BFM RX : \n \
  \t\t\t\t\t\t\t crf        = %0h\t vc         = %0h\t ackid      = %0h\n\
  \t\t\t\t\t\t\t prio       = %0h\t tt         = %0h\t DestID     = %0h\n\
  \t\t\t\t\t\t\t ftype      = %0h\t ttype      = %0h\t SrcID      = %0h\n\
  \t\t\t\t\t\t\t status     = %0h\t TarTID     = %0h\n", 
  trans_ttype13.name,
  temp_pc_trans_ins.crf, temp_pc_trans_ins.vc, temp_pc_trans_ins.ackid, 
  temp_pc_trans_ins.prio, temp_pc_trans_ins.tt, temp_pc_trans_ins.DestinationID,
  temp_pc_trans_ins.ftype, temp_pc_trans_ins.ttype, temp_pc_trans_ins.SourceID,
  temp_pc_trans_ins.trans_status, temp_pc_trans_ins.targetID_Info);
            end // }
  
            else  
            begin // {
              $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " SRIO PACKET WITH RESERVED FTYPE RECEIVED in BFM RX");
            end // }

            $fwrite(file_h, "  \t\t\t\t\t\t\t Early_CRC  = %h\t\t Final_CRC  = %h\t\t LINK CRC32  =%ht\t \n\n",
            temp_pc_trans_ins.early_crc, temp_pc_trans_ins.final_crc,temp_pc_trans_ins.crc32); 
           
            dpl_size = temp_pc_trans_ins.payload.size(); 
            if (dpl_size > 0) 
            begin // {
              $fwrite (file_h, "\t\t\t\t\t\t\tData Payload\n"); 
              while ((dpl_size - i) >= 4) 
              begin // {
                $fwrite (file_h, "\t\t\t\t\t\t\t D[%0d]:%h \t D[%0d]:%h \t D[%0d]:%h \t D[%0d]:%h\n", 
                i, temp_pc_trans_ins.payload[i], i+1, temp_pc_trans_ins.payload[i+1], 
                i+2, temp_pc_trans_ins.payload[i+2], i+3, temp_pc_trans_ins.payload[i+3]);
                i = i + 4;  
              end // }
              if ((dpl_size - i) == 3) 
                $fwrite (file_h, "\t\t\t\t\t\t\t D[%0d]:%h \t D[%0d]:%h \t D[%0d]:%h\n", i, temp_pc_trans_ins.payload[i], 
                i+1, temp_pc_trans_ins.payload[i+1], i+2, temp_pc_trans_ins.payload[i+2]);
              else if ((dpl_size - i) == 2) 
                $fwrite (file_h, "\t\t\t\t\t\t\t D[%0d]:%h \t D[%0d]:%h \n", i, temp_pc_trans_ins.payload[i], 
                i+1, temp_pc_trans_ins.payload[i+1]);
              else if ((dpl_size - i) == 1) 
                $fwrite (file_h, "\t\t\t\t\t\t\t D[%0d]:%h\n", i, temp_pc_trans_ins.payload[i]);
              $fwrite (file_h, "\n");
            end // }   
  
  endtask : bfm_rx_pkt_tracker
  
  
  

  ///////////////////////////////////////////////////////////////////////////////////////////////
  /// Name : bfm_tx_control_symbol_tracker
  /// Description : Writes the BFM TX control symbol into the tracker file.
  ///////////////////////////////////////////////////////////////////////////////////////////////
  task bfm_tx_control_symbol_tracker(srio_trans temp_pc_trans_ins);
  
    if (temp_pc_trans_ins.stype0 == 3'b000)
      $fwrite(file_h, "==> @%0t", $time, " PACKET ACCEPTED CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b010)
      $fwrite(file_h, "==> @%0t", $time, " PACKET NOT ACCEPTED CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b001)
      $fwrite(file_h, "==> @%0t", $time, " PACKET RETRY CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b100)
      $fwrite(file_h, "==> @%0t", $time, " STATUS CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b101)
      $fwrite(file_h, "==> @%0t", $time, " VC STATUS CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b110)
      $fwrite(file_h, "==> @%0t", $time, " LINK RESPONSE CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 4'b0011)
    begin //{
      if (trans_tracker_env_config.srio_mode != SRIO_GEN30)
        $fwrite(file_h, "==> @%0t", $time, " LOOP RESPONSE or TIMESTAMP SEQUENCE CONTROL SYMBOL");
      else
        $fwrite(file_h, "==> @%0t", $time, " TIMESTAMP SEQUENCE CONTROL SYMBOL");
    end //}
    else if (temp_pc_trans_ins.stype0 == 4'b1011 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, "==> @%0t", $time, " LOOP RESPONSE CONTROL SYMBOL");
    
    if (temp_pc_trans_ins.stype1 == 3'b111)
      $fwrite(file_h, " RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b000 && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / SOP CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b001 && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / STOMP CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b001 && temp_pc_trans_ins.cmd == 3'b000 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / STOMP CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b010 && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / EOP CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b011  && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / RESTART-FROM-RETRY CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b011 && temp_pc_trans_ins.cmd == 3'b000 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / RESTART-FROM-RETRY CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b100 && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / LINK REQUEST WITH INPUT-STATUS CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b100 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / LINK REQUEST WITH INPUT-STATUS CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b011 && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / LINK REQUEST WITH RESET-DEVICE CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b011 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / LINK REQUEST WITH RESET-DEVICE CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b010 && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / LINK REQUEST WITH RESET-PORT CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b010 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / LINK REQUEST WITH RESET-PORT CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b101 && temp_pc_trans_ins.cmd == 3'b011 && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / LOOP REQUEST CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b101 && temp_pc_trans_ins.cmd == 3'b011 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / LOOP REQUEST CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (trans_tracker_env_config.srio_mode == SRIO_GEN30)
    begin //{

      if (temp_pc_trans_ins.brc3_stype1_msb == 2'b10)
        $fwrite(file_h, " / SOP-UNPADDED CONTROL SYMBOL RECEIVED in BFM TX : \n");
      else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b11)
        $fwrite(file_h, " / SOP-PADDED CONTROL SYMBOL RECEIVED in BFM TX : \n");
      else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b010 && temp_pc_trans_ins.cmd == 3'b000)
        $fwrite(file_h, " / EOP-UNPADDED CONTROL SYMBOL RECEIVED in BFM TX : \n");
      else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b010 && temp_pc_trans_ins.cmd == 3'b001)
        $fwrite(file_h, " / EOP-PADDED CONTROL SYMBOL RECEIVED in BFM TX : \n");

    end //}

    if (trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, "\t stype0 = %0h\t param0 = %0h\t param1 = %0h\t\n\t stype1 = %0h\t cmd = %0h\n\n", temp_pc_trans_ins.stype0, temp_pc_trans_ins.param0, temp_pc_trans_ins.param1, temp_pc_trans_ins.stype1, temp_pc_trans_ins.cmd);
    else
      $fwrite(file_h, "\t stype0 = %0h\t param0 = %0h\t param1 = %0h\t\n\t brc3_stype1_msb = %0h\t stype1 = %0h\t cmd = %0h\n\n", temp_pc_trans_ins.stype0, temp_pc_trans_ins.param0, temp_pc_trans_ins.param1, temp_pc_trans_ins.brc3_stype1_msb, temp_pc_trans_ins.stype1, temp_pc_trans_ins.cmd);
  
  endtask : bfm_tx_control_symbol_tracker



  ///////////////////////////////////////////////////////////////////////////////////////////////
  /// Name : bfm_rx_control_symbol_tracker
  /// Description : Writes the BFM RX control symbol into the tracker file.
  ///////////////////////////////////////////////////////////////////////////////////////////////
  task bfm_rx_control_symbol_tracker(srio_trans temp_pc_trans_ins);

    if (temp_pc_trans_ins.stype0 == 3'b000)
      $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " PACKET ACCEPTED CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b010)
      $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " PACKET NOT ACCEPTED CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b001)
      $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " PACKET RETRY CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b100)
      $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " STATUS CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b101)
      $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " VC STATUS CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 3'b110)
      $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " LINK RESPONSE CONTROL SYMBOL");
    else if (temp_pc_trans_ins.stype0 == 4'b0011)
    begin //{
      if (trans_tracker_env_config.srio_mode != SRIO_GEN30)
        $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " LOOP RESPONSE or TIMESTAMP SEQUENCE CONTROL SYMBOL");
      else
        $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " TIMESTAMP SEQUENCE CONTROL SYMBOL");
    end //}
    else if (temp_pc_trans_ins.stype0 == 4'b1011 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, "\t\t\t\t\t\t\t<== @%0t", $time, " LOOP RESPONSE CONTROL SYMBOL");
    
    if (temp_pc_trans_ins.stype1 == 3'b111)
      $fwrite(file_h, " RECEIVED in BFM RX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b000 && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / SOP CONTROL SYMBOL RECEIVED in BFM RX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b001)
      $fwrite(file_h, " / STOMP CONTROL SYMBOL RECEIVED in BFM RX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b001 && temp_pc_trans_ins.cmd == 3'b000 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / STOMP CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b010 && trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, " / EOP CONTROL SYMBOL RECEIVED in BFM RX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b011)
      $fwrite(file_h, " / RESTART-FROM-RETRY CONTROL SYMBOL RECEIVED in BFM RX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b011 && temp_pc_trans_ins.cmd == 3'b000 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / RESTART-FROM-RETRY CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b100)
      $fwrite(file_h, " / LINK REQUEST WITH INPUT-STATUS CONTROL SYMBOL RECEIVED in BFM RX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b100 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / LINK REQUEST WITH INPUT-STATUS CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b011)
      $fwrite(file_h, " / LINK REQUEST WITH RESET-DEVICE CONTROL SYMBOL RECEIVED in BFM RX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b011 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / LINK REQUEST WITH RESET-DEVICE CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b010)
      $fwrite(file_h, " / LINK REQUEST WITH RESET-PORT CONTROL SYMBOL RECEIVED in BFM RX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b100 && temp_pc_trans_ins.cmd == 3'b010 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / LINK REQUEST WITH RESET-PORT CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (temp_pc_trans_ins.stype1 == 3'b101 && temp_pc_trans_ins.cmd == 3'b011)
      $fwrite(file_h, " / LOOP REQUEST CONTROL SYMBOL RECEIVED in BFM RX : \n");
    else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b101 && temp_pc_trans_ins.cmd == 3'b011 && trans_tracker_env_config.srio_mode == SRIO_GEN30)
      $fwrite(file_h, " / LOOP REQUEST CONTROL SYMBOL RECEIVED in BFM TX : \n");
    else if (trans_tracker_env_config.srio_mode == SRIO_GEN30)
    begin //{

      if (temp_pc_trans_ins.brc3_stype1_msb == 2'b10)
        $fwrite(file_h, " / SOP-UNPADDED CONTROL SYMBOL RECEIVED in BFM RX : \n");
      else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b11)
        $fwrite(file_h, " / SOP-PADDED CONTROL SYMBOL RECEIVED in BFM RX : \n");
      else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b010 && temp_pc_trans_ins.cmd == 3'b000)
        $fwrite(file_h, " / EOP-UNPADDED CONTROL SYMBOL RECEIVED in BFM RX : \n");
      else if (temp_pc_trans_ins.brc3_stype1_msb == 2'b00 && temp_pc_trans_ins.stype1 == 3'b010 && temp_pc_trans_ins.cmd == 3'b001)
        $fwrite(file_h, " / EOP-PADDED CONTROL SYMBOL RECEIVED in BFM RX : \n");

    end //}
  
    if (trans_tracker_env_config.srio_mode != SRIO_GEN30)
      $fwrite(file_h, "\t\t\t\t\t\t\t stype0 = %0h\t param0 = %0h\t param1 = %0h\t\n\t\t\t\t\t\t\t stype1 = %0h\t cmd = %0h\n\n", temp_pc_trans_ins.stype0, temp_pc_trans_ins.param0, temp_pc_trans_ins.param1, temp_pc_trans_ins.stype1, temp_pc_trans_ins.cmd);
    else
      $fwrite(file_h, "\t\t\t\t\t\t\t stype0 = %0h\t param0 = %0h\t param1 = %0h\t\n\t\t\t\t\t\t\t brc3_stype1_msb = %0h \t stype1 = %0h\t cmd = %0h\n\n", temp_pc_trans_ins.stype0, temp_pc_trans_ins.param0, temp_pc_trans_ins.param1, temp_pc_trans_ins.brc3_stype1_msb, temp_pc_trans_ins.stype1, temp_pc_trans_ins.cmd);
  
  endtask : bfm_rx_control_symbol_tracker

endclass
