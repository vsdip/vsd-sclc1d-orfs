// Map the positive-level Yosys latch to the SCL active-high D latch.
module $_DLATCH_P_ (input D, E, output Q);
  LTCH11 _TECHMAP_REPLACE_ (
    .D(D),
    .C(E),
    .Q(Q)
  );
  wire _TECHMAP_REMOVEINIT_Q_ = 1'b1;
endmodule
