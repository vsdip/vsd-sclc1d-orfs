module DFFRAM_4K (
    CLK,
    WE,
    EN,
    Di,
    Do,
    A
);
  input CLK;
  input [3:0] WE;
  input EN;
  input [31:0] Di;
  output [31:0] Do;
  input [9:0] A;
endmodule

module DMC_32x16HC (
    clk,
    rst_n,
    A,
    A_h,
    Do,
    hit,
    line,
    wr
);
  input clk;
  input rst_n;
  input [23:0] A;
  input [23:0] A_h;
  output [31:0] Do;
  output hit;
  input [127:0] line;
  input wr;
endmodule

module ibex_wrapper (
    HCLK,
    HRESETn,
    HADDR,
    HSIZE,
    HTRANS,
    HWDATA,
    HWRITE,
    HRDATA,
    HREADY,
    NMI,
    EXT_IRQ,
    IRQ,
    SYSTICKCLKDIV
);
  input HCLK;
  input HRESETn;
  output [31:0] HADDR;
  output [2:0] HSIZE;
  output [1:0] HTRANS;
  output [31:0] HWDATA;
  output HWRITE;
  input [31:0] HRDATA;
  input HREADY;
  input NMI;
  input EXT_IRQ;
  input [14:0] IRQ;
  input [23:0] SYSTICKCLKDIV;
endmodule

module apb_sys_0 (
    HCLK,
    HRESETn,
    HADDR,
    HTRANS,
    HWRITE,
    HWDATA,
    HSEL,
    HREADY,
    HRDATA,
    HREADYOUT,
    RsRx_S0,
    RsTx_S0,
    RsRx_S1,
    RsTx_S1,
    MSI_S2,
    MSO_S2,
    SSn_S2,
    SCLK_S2,
    MSI_S3,
    MSO_S3,
    SSn_S3,
    SCLK_S3,
    scl_i_S4,
    scl_o_S4,
    scl_oen_o_S4,
    sda_i_S4,
    sda_o_S4,
    sda_oen_o_S4,
    scl_i_S5,
    scl_o_S5,
    scl_oen_o_S5,
    sda_i_S5,
    sda_o_S5,
    sda_oen_o_S5,
    pwm_S6,
    pwm_S7,
    IRQ
);
  input HCLK;
  input HRESETn;
  input [31:0] HADDR;
  input [1:0] HTRANS;
  input HWRITE;
  input [31:0] HWDATA;
  input HSEL;
  input HREADY;
  output [31:0] HRDATA;
  output HREADYOUT;
  input [0:0] RsRx_S0;
  output [0:0] RsTx_S0;
  input [0:0] RsRx_S1;
  output [0:0] RsTx_S1;
  input [0:0] MSI_S2;
  output [0:0] MSO_S2;
  output [0:0] SSn_S2;
  output [0:0] SCLK_S2;
  input [0:0] MSI_S3;
  output [0:0] MSO_S3;
  output [0:0] SSn_S3;
  output [0:0] SCLK_S3;
  input [0:0] scl_i_S4;
  output [0:0] scl_o_S4;
  output [0:0] scl_oen_o_S4;
  input [0:0] sda_i_S4;
  output [0:0] sda_o_S4;
  output [0:0] sda_oen_o_S4;
  input [0:0] scl_i_S5;
  output [0:0] scl_o_S5;
  output [0:0] scl_oen_o_S5;
  input [0:0] sda_i_S5;
  output [0:0] sda_o_S5;
  output [0:0] sda_oen_o_S5;
  output [0:0] pwm_S6;
  output [0:0] pwm_S7;
  output [15:0] IRQ;
endmodule
