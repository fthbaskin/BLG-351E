; G11 - Wednesday
;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

Setup		mov.b #0ffh, &P1DIR
			mov.b #0ffh, &P2DIR
			mov.b #00000000b, &P2SEL
			mov.b #00000000b, &P2SEL2
			clr.b &P1OUT
			clr.b &P2OUT


            ;implementation of the flow chart in the experiment document.
InitLCD     mov &Delay100ms, R15 ;Wait 100ms
            call #Delay

            mov.b #00110000b, &P1OUT ;Send 0011
            call #TrigEn
            mov &Delay4ms, R15 ;Wait 4ms
            call #Delay

            call #TrigEn ;Send 0011
            mov &Delay100us, R15 ;Wait 100us
            call #Delay

            call #TrigEn ;Send 0011
            mov &Delay100us, R15 ;Wait 100us
            call #Delay

            mov.b #00100000b, &P1OUT ;Send 0010
            call #TrigEn
            mov &Delay100us, R15 ;Wait 100us
            call #Delay

            ;LCD is now in 4-bit mode, which means we will send our commands nibble by nibble.

            mov.b #00100000b, &P1OUT ;Send 0010 1000
            call #TrigEn
            mov.b #00000000b, &P1OUT
            call #TrigEn

            mov &Delay100us, R15 ;Wait 53us+
            call #Delay

            mov.b #00000000b, &P1OUT ;Send 0000 1000
            call #TrigEn
            mov.b #10000000b, &P1OUT
            call #TrigEn

            mov &Delay100us, R15 ;Wait 53us+
            call #Delay

            mov.b #00000000b, &P1OUT ;Send 0000 0001
            call #TrigEn
            mov.b #00010000b, &P1OUT
            call #TrigEn

            mov &Delay4ms, R15 ;Wait 3ms+
            call #Delay

            mov.b #00000000b, &P1OUT ;Send 0000 0110
            call #TrigEn
            mov.b #01100000b, &P1OUT
            call #TrigEn
            mov &Delay100us, R15
            call #Delay

            ;initialization is over. Now we will start sending data to our LCD display

Main		clr R5
			mov.b #00001111b, R5
			call #SendCMD
			mov &Delay50us, R15
			call #Delay
			mov #string, R13
			add.w #14d, R13
			mov #string, R12
			add.w #56d, R12
			mov #string, R7
			clr R8 ;this is for indexing

Loop		clr R6 ;word writing address
			mov.b 0(R7), R6
			inc R7
			cmp R12, R7
			jne Checkflag
			mov #string, R7

Checkflag	cmp #00h, flag
			jne flag1
			call #NorW
			cmp R7, R13
			jne Loop
			mov.w #01d, flag
			jmp Loop

flag1		call #ShiftW
			jmp Loop

ShiftW		clr R5
			mov.b	#00011000b, R5
			call #SendCMD
			mov &Delay50us, R15
			call #Delay
			call #SendData
			mov &Delay50us, R15
			call #Delay
			mov &Delay100ms, R15
			call #Delay
			mov &Delay100ms, R15
			call #Delay
			ret

NorW		call #SendData
			mov &Delay50us, R15
			call #Delay
			ret

TrigEn		bis.b #01000000b, &P2OUT
			bic.b #01000000b, &P2OUT
			ret

SendCMD		mov.b R5, &P1OUT
			call #TrigEn
			rla R5
			rla R5
			rla R5
			rla R5
			mov.b R5, &P1OUT
			call #TrigEn
			ret

SendData	bis.b #10000000b, &P2OUT
			mov.b R6, &P1OUT
			call #TrigEn
			rla R6
			rla R6
			rla R6
			rla R6
			mov.b R6, &P1OUT
			call #TrigEn
			bic.b #10000000b, &P2OUT
			ret

Delay		dec.w R15
			jnz Delay
			ret

;-------------------------------------------------------------------------------
			.data
flag		.byte 00h; flag to switch between directly writing and shifting

string		.byte "ITU Computer Engineering Microprocessor Laboratory 2022." ;string to be written to the LCD

Delay50us	.word	011h
Delay100us	.word 	022h
Delay2ms	.word 	0250h
Delay4ms	.word 	0510h
Delay100ms	.word	07A10h

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack

;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
