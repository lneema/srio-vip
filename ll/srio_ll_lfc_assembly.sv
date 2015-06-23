////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_ll_lfc_assembly.sv
// Project :  srio vip
// Purpose :  LFC Assembly
// Author  :  Mobiveil
//
// Contains srio_ll_lfc_assembly class used for LFC assembly and testing in LL
// monitor
// 
//////////////////////////////////////////////////////////////////////////////// 

class srio_ll_lfc_assembly extends uvm_object;
  /// @cond
  `uvm_object_utils(srio_ll_lfc_assembly)
  
  int        req_xonxoff_timer0 ;
  int        rel_deall_timer0   ;
  int        xoff_rel_timer0    ;
  int        xon_pdu_timer0     ;
  int        req_xonxoff_timer1 ;
  int        rel_deall_timer1   ;
  int        xoff_rel_timer1    ;
  int        xon_pdu_timer1     ;
  bit        pdu_completed      ;
  bit        pdu_started        ;
  bit        req_type0          ; // 1 - multi; 0 -single 
  bit        req_type1          ; // 1 - multi; 0 -single 
  bit [6:0]  pdu_flowid         ;
  bit [6:0]  req0_flowid        ;
  bit [6:0]  req1_flowid        ;
  /// @endcond

////////////////////////////////////////////////////////////////////////////////
/// Name: new \n
/// Description: LL LFC assembly class's new function \n
/// new
//////////////////////////////////////////////////////////////////////////////// 
  function new(string name="srio_ll_lfc_assembly");
    super.new(name);
    req_xonxoff_timer0 = 0;
    rel_deall_timer0   = 0;
    xoff_rel_timer0    = 0;
    xon_pdu_timer0     = 0;
    req_xonxoff_timer1 = 0;
    rel_deall_timer1   = 0;
    xoff_rel_timer1    = 0;
    xon_pdu_timer1     = 0;
    pdu_flowid         = 0;     
    pdu_completed      = 0;    
    pdu_started        = 0;       
    req0_flowid        = 0;     
    req1_flowid        = 0;        
    req_type0          = 0;    
    req_type1          = 0;    
  endfunction: new

endclass: srio_ll_lfc_assembly

// =============================================================================
