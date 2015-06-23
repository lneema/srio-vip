////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_trans_decoder.sv
// Project :  srio vip
// Purpose :  
// Author  :  Mobiveil
//
// SRIO Transaction Decoder receives the srio_trans sequence item from the LL or PL agents 
// monitor component and passes only the transactions that can access 
// SRIO registers (Mainte-nance and NWRITE_R or NREAD packets) to 
// SRIO register predictor module. The received Maintenance, NWRITE_R or NREAD transactions
// are queued and sent one by one to SRIO Register Predictor module, after receiving 
// DONE response for that particular transaction.
// If the VIP is configured as PE model, the input ports of SRIOtransaction decoder 
// are con-nected to Tx and Rx analysis ports of LL monitor. If the VIP is configured 
// as PL model, then the input ports are connected to Tx and Rx analysis ports 
// of PL monitor
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_trans_decoder extends uvm_component;

  `uvm_component_utils(srio_trans_decoder)
  
  /// srio_tx_trans_decoder decodes the NWRITE_R, NREAD, MAINT_WR, MAINT_RD transactions transmitted from BFM
  srio_tx_trans_decoder tx_decoder;
  /// srio_tx_trans_decoder decodes the response transactions received by BFM
  srio_rx_trans_decoder rx_decoder;

  ///queue to store the txns to be sent to predictor
  srio_trans txn_to_predictor[int]; ///< index is SrcTID of srio_trans
  srio_trans T;
  srio_trans trans[int];
  event srio_trans_decoder_done;
  bit [6:0] req_size;
  
  uvm_analysis_port #(srio_trans) ap;
  
  extern function new(string name = "srio_trans_decoder", uvm_component parent = null);
  extern function void connect();
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function bit [6:0] size_of_txn(bit wdptr, bit [3:0] txn_size);

endclass: srio_trans_decoder

function srio_trans_decoder::new(string name = "srio_trans_decoder", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void srio_trans_decoder::build_phase(uvm_phase phase);
    ap = new("analysis_port", this);
    tx_decoder = srio_tx_trans_decoder::type_id::create("tx_decoder", this);
    rx_decoder = srio_rx_trans_decoder::type_id::create("rx_decoder", this);
endfunction : build_phase

function void srio_trans_decoder::connect();
endfunction : connect

//////////////////////////////////////////////////////////////////////////
/// Name: size_of_txn
/// Description: returns the size of each txn in bytes
/// size_of_txn
//////////////////////////////////////////////////////////////////////////

function bit [6:0] srio_trans_decoder::size_of_txn(bit wdptr, bit [3:0] txn_size);
  if(txn_size==8)
  begin //{
    size_of_txn = 4;
  end //}
  else if(txn_size==11 && wdptr==0)
  begin //{
    size_of_txn = 8;
  end //}
  else if(txn_size==11 && wdptr==1)
  begin //{
    size_of_txn = 16;
  end //}
  else if(txn_size==12 && wdptr==0)
  begin //{
    size_of_txn = 32;
  end //}
  else if(txn_size==12 && wdptr==1)
  begin //{
    size_of_txn = 64;
  end //}
  else
  begin //{
    size_of_txn = 4;
  end //}
endfunction : size_of_txn

task srio_trans_decoder::run_phase(uvm_phase phase);

  fork
    begin : tx_trans_receiver
      while(1)
      begin //{
        /// wait for the event trigger from srio_tx_trans_decoder
        @(tx_decoder.tx_trans_done);
        /// update the txn_to_predictor array with the srio_trans decoded by srio_tx_trans_decoder
        txn_to_predictor[tx_decoder.tx_trans.SrcTID] = tx_decoder.tx_trans;
      end //}
    end ///< tx_trans_receiver
    begin : rx_trans_receiver
      while(1)
      begin //{
        /// wait for the event trigger from srio_tx_trans_decoder
        @(rx_decoder.rx_trans_done);
        /// Check if the corresponding request txn already exists for the received response txn
        if(txn_to_predictor.exists(rx_decoder.rx_trans.targetID_Info))
        begin //{
          T = srio_trans::type_id::create("srio_trans", this);
          T = txn_to_predictor[rx_decoder.rx_trans.targetID_Info];
        
          /// check whether the response is DONE
          if(rx_decoder.rx_trans.trans_status == 0) ///< 0 - DONE
          begin //{
            /// check if it is read txn
            if( (T.ftype==2 && T.ttype==4) || (T.ftype==8 && T.ttype==0) ) ///< NREAD , MAINT_RD
            begin //{
              foreach(rx_decoder.rx_trans.payload[i])
                T.payload[i] = rx_decoder.rx_trans.payload[i];
              /// get the payload size of the rd request
              req_size = size_of_txn(T.wdptr, T.rdsize);
            end //}
            else ///< WRITE
            begin //{
              /// get the payload size of the wr request
              req_size = size_of_txn(T.wdptr, T.wrsize);
            end //}
            if(T.ftype != 8)
              T.address = T.address << 3;
            if(req_size==4 && T.wdptr==1)
            begin //{
              if(T.ftype==8)
                T.config_offset = T.config_offset+4;
              else
                T.address = T.address + 4;
              T.payload[0] = T.payload[4];
              T.payload[1] = T.payload[5];
              T.payload[2] = T.payload[6];
              T.payload[3] = T.payload[7];
            end //}
            for(int i=0; i<(req_size/4); i++)
            begin //{
              trans[i] = new T;
              trans[i].payload[0] = T.payload[(i*4)];
              trans[i].payload[1] = T.payload[(i*4)+1];
              trans[i].payload[2] = T.payload[(i*4)+2];
              trans[i].payload[3] = T.payload[(i*4)+3];
              if(T.ftype==8)
                trans[i].config_offset = T.config_offset + (i*4);
              else
                trans[i].address = T.address + (i*4);
                
              /// send  the txn to Predictor through analysis port
              ap.write(trans[i]);
            end //}
            //ap.write(T);
            txn_to_predictor.delete(rx_decoder.rx_trans.targetID_Info);
            -> srio_trans_decoder_done;
          end //} //DONE
          else
          begin //{
            /// remove the request from queue if the response is != DONE
            txn_to_predictor.delete(rx_decoder.rx_trans.targetID_Info);
          end //}
        end //}
        else
        begin //{
//          uvm_report_warning(get_full_name(), $psprintf("Response with wrong targetID(=%h) received", rx_decoder.rx_trans.targetID_Info),UVM_LOW);
        end //}
      end //} //while(1)
    end // rx_trans_receiver
  join_none

endtask : run_phase
