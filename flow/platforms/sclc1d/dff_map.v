// Explicit mapping required because dfflibmap does not recognize the
// sequential description of DFFL11 in the supplied SCL Liberty file.
module $_DFF_P_ (input D, C, output Q);
  DFFL11 _TECHMAP_REPLACE_ (
    .D(D),
    .C(C),
    .Q(Q)
  );
  wire _TECHMAP_REMOVEINIT_Q_ = 1'b1;
endmodule
