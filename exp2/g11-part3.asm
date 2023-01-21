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
           	.data
COUNTER     .int counter

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
			mov.w	#16d, R13
prebounce	bit.b #10h, &P1IN
			jnz prebounce
			mov.w	#00h,COUNTER


debouncer	bit.b #10h, &P1IN
			jz debouncer
			mov.w COUNTER, &P1OUT
			inc COUNTER
			cmp COUNTER, R13
			jz	reset
			jmp prebounce

reset		mov.w #00h, COUNTER
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
            
