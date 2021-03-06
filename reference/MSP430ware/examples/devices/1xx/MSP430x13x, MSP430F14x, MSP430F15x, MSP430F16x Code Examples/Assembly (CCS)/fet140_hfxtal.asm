;******************************************************************************
;   MSP-FET430P140 Demo - Basic Clock, LFXT1/MCLK Sourced from HF XTAL
;
;   Description: Proper selection of an external HF XTAL for MCLK is shown by
;   first polling the OSC fault until XTAL is stable - only then is MCLK
;   sourced by LFXT1.  MCLK is on P5.4
;   ACLK = MCLK = LFXT1 = HFXTAL
;   //* HF XTAL NOT INSTALLED ON FET *//
;   //* Min Vcc required varies with MCLK frequency - refer to datasheet *//	
;
;                MSP430F149
;             -----------------
;         /|\|              XIN|-
;          | |                 | HF XTAL (455k - 8Mhz)
;          --|RST          XOUT|-
;            |                 |
;            |             P5.4|-->MCLK = XTAL
;
;   M. Buccini / G. Morton
;   Texas Instruments Inc.
;   May 2005
;   Built with Code Composer Essentials Version: 1.0
;******************************************************************************
 .cdecls C,LIST,  "msp430x14x.h"
;------------------------------------------------------------------------------
            .text                           ; Program Start
;------------------------------------------------------------------------------
RESET       mov.w   #0A00h,SP               ; Initialize stackpointer
SetupWDT    mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupP5     bis.b   #010h,&P5DIR            ; P5.4 output
            bis.b   #010h,&P5SEL            ; P5.4 option
                                            ;
SetupBC     bis.b   #XTS,&BCSCTL1           ; LFXT1= HF XTAL
SetupOsc    bic.b   #OFIFG,&IFG1            ; Clear OSC fault flag
            mov.w   #0FFh,R15               ; R15 = Delay
SetupOsc1   dec.w   R15                     ; Additional delay to ensure start
            jnz     SetupOsc1               ;
            bit.b   #OFIFG,&IFG1            ; OSC fault flag set?
            jnz     SetupOsc                ; OSC Fault, clear flag again
            bis.b   #SELM_3,&BCSCTL2        ; MCLK = LFXT1
                                            ;
Mainloop    jmp     Mainloop                ; Repeat
                                            ;
;------------------------------------------------------------------------------
;           Interrupt Vectors
;------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .end
