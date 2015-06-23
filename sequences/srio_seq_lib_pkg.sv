////////////////////////////////////////////////////////////////////////////////
//(c) Copyright 2013 Mobiveil, Inc. All rights reserved
//
// File    :  srio_seq_lib_pkg.sv
// Project :  srio vip
// Purpose :  Package for all layer sequences 
// Author  :  Mobiveil
//
// Included all layered sequences and virtual sequences.
//
////////////////////////////////////////////////////////////////////////////////

package srio_seq_lib_pkg;

   `include "uvm_macros.svh"
    import uvm_pkg::*;
    import srio_env_pkg ::*;
   
   `include "srio_ll_sequence_lib.sv"
   `include "srio_tl_sequence_lib.sv"
   `include "srio_pl_sequence_lib.sv"
   `include "srio_virtual_sequence_lib.sv" 
endpackage :srio_seq_lib_pkg
