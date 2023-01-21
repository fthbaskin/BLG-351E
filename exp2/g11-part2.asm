; group 11 wed.
;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
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
			mov.w	#0d, P2SEL


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

			bis.b	#000h,&P1DIR
			bis.b	#00Ch,&P2DIR
			mov.w	#004h,&P2OUT
			mov.w	#000h,&P1IN
			mov.w	#000h,&P1OUT

		 	mov.w	#000h,R15
		 	mov.w	#000h,R14
			mov.w	#0FFh, R13
prebounce	bit.b #10h, &P1IN
			jnz prebounce
			mov.w	#000h,R15


debouncer	bit.b #10h, &P1IN
			jz debouncer
			inc R15
			cmp R15, R13
			jn 	program
			jmp debouncer

program		bit.b	#001h,R14
			jnz tog1
			jmp tog2

tog1		inc R14
			mov.w #08h ,&P2OUT
			jmp prebounce

tog2		inc R14
			mov.w	#004h,&P2OUT
			jmp prebounce

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
            
