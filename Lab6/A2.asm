// Elabora una calculadora con un teclado matricial 4x4 en la cual puedas introducir dos dígitos del 0 
// al 9 y con las teclas A, B, C y D esos dos dígitos puedan ser sumados, restados, multiplicados y 
// divididos respectivamente.  

// Tanto los resultados como los operandos deben ser desplegados por medio de los LEDs en formato 
// binario. También puedes mostrar el operador con alguna secuencia para asegurar que leyó el botón. 
// Utiliza * como la tecla igual y # para borrar los LEDs.
    
RADIX     DEC              	 
PROCESSOR 18F45K50	          
#include  "pic18f45k50.inc"
    
Cont1	    equ 0x30			// Registros para retardo
Cont2	    equ 0x31
Num1	    equ 0x32			// Registros para digitos
Num2	    equ 0x33
Resultado   equ	0x34
Aux	    equ 0x35			// Registro para checar si esta ocupado y que operacion
Aux2	    equ	0x36			// Registro auxiliar para division
	    
    
PSECT resetVec, class=CODE, reloc=2, abs
ORG	  0	   
    
resetVec:  
    ORG   32	       
    GOTO  Start 
    
Start:
    movlb 15
    clrf TRISB,A		// Teclado Matricial
    clrf TRISD,A		// Leds
    clrf TRISA,A
    clrf LATD,A
    clrf LATA,A
    clrf STATUS,A
    clrf Aux,A
    clrf Aux2,A
    
// CONFIGURACION PARA EL TECLADO
    //clrf ANSELB,BANKED
    bcf INTCON2,7,A
    movlw 0b00001111
    movwf TRISB,A
    movwf WPUB,A
    
Revisar_1_Columna:
    movlw 0b11101111			
    movwf LATB,A		
    btfss PORTB,0,A			
	call Boton1			
	btfss PORTB,1,A			
	    call Boton4
	    btfss PORTB,2,A		
		call Boton7
		btfss PORTB,3,A		
		    call BotonE

Revisar_2_Columna:
    movlw 0b11011111			
    movwf LATB,A
    btfss PORTB,0,A			
	call Boton2
	btfss PORTB,1,A			
	    call Boton5
	    btfss PORTB,2,A		
		call Boton8
		btfss PORTB,3,A		
		    call Boton0
		
Revisar_3_Columna:
    movlw 0b10111111			
    movwf LATB,A
    btfss PORTB,0,A			
	call Boton3
	btfss PORTB,1,A			
	    call Boton6
	    btfss PORTB,2,A		
		call Boton9
		btfss PORTB,3,A		
		    call BotonF
		
Revisar_4_Columna:
    movlw 0b01111111			
    movwf LATB,A
    btfss PORTB,0,A			
	call BotonA
	btfss PORTB,1,A			
	    call BotonB
	    btfss PORTB,2,A		
		call BotonC
		btfss PORTB,3,A		
		    call BotonD
		    bra Revisar_1_Columna	
		
Boton1:
    call Retardo		 
    btfss PORTB,0,A		
	bra Boton1		
	movlw 0b00000001	
	movwf LATD,A
	call GuardarNumero
	return
    
Boton2:
    call Retardo
    btfss PORTB,0,A
	bra Boton2
	movlw 0b00000010
	movwf LATD,A	
	call GuardarNumero
	return

Boton3:
    call Retardo
    btfss PORTB,0,A
	bra Boton3
	movlw 0b00000011
	movwf LATD,A	
	call GuardarNumero
	return
    
Boton4:
    call Retardo
    btfss PORTB,1,A
	bra Boton4
	movlw 0b00000100
	movwf LATD,A	
	call GuardarNumero
	return
    
Boton5:
    call Retardo
    btfss PORTB,1,A
	bra Boton5
	movlw 0b00000101
	movwf LATD,A	
	call GuardarNumero
	return
    
Boton6:
    call Retardo
    btfss PORTB,1,A
	bra Boton6
	movlw 0b00000110
	movwf LATD,A	
	call GuardarNumero
	return
    
Boton7:
    call Retardo
    btfss PORTB,2,A
	bra Boton7
	movlw 0b00000111
	movwf LATD,A	
	call GuardarNumero
	return
    
Boton8:
    call Retardo
    btfss PORTB,2,A
	bra Boton8
	movlw 0b00001000
	movwf LATD,A	
	call GuardarNumero
	return
    
Boton9:
    call Retardo
    btfss PORTB,2,A
	bra Boton9
	movlw 0b00001001
	movwf LATD,A	
	call GuardarNumero
	return
	    
Boton0:
    call Retardo
    btfss PORTB,3,A
	bra Boton0
	movlw 0b00000000
	movwf LATD,A
	call GuardarNumero
	return
    
BotonA:
    call Retardo
    btfss PORTB,0,A
	bra BotonA
	clrf LATA,A		
	bsf LATA,4,A
	bsf Aux,7,A
	bsf Aux,0,A
	return
    
BotonB:
    call Retardo
    btfss PORTB,1,A
	bra BotonB
	clrf LATA,A		
	bsf LATA,5,A
	bsf Aux,7,A
	bsf Aux,1,A
	return
    
BotonC:
    call Retardo
    btfss PORTB,2,A
	bra BotonC
	clrf LATA,A		
	bsf LATA,6,A
	bsf Aux,7,A
	bsf Aux,2,A
	return
    
BotonD:
    call Retardo
    btfss PORTB,3,A
	bra BotonD
	clrf LATA,A		
	bsf LATA,7,A
	bsf Aux,7,A
	bsf Aux,3,A
	return
    
BotonE:				// Boton *
    call Retardo
    btfss PORTB,3,A
	bra BotonE
	clrf LATA,A
	
	btfsc Aux,0,A
	    call Suma
	    btfsc Aux,1,A
		call Resta
		btfsc Aux,2,A
		    call Multiplicacion
		    btfsc Aux,3,A
			call Division
			bsf LATA,4,A
	    		return
	
Suma:
    movf Num1,W,A
    addwf Num2,W,A
    call Total
    return
    
Resta:
    movf Num2,W,A
    subwf Num1,W,A
    btfss WREG,7,A
	bra Total
	negf WREG,A
	bsf WREG,7,A
	call Total
	return

Multiplicacion:
    movf Num1,W,A
    mulwf Num2,A
    movf PRODH,W,A
    addwf PRODL,W,A
    call Total
    return
    
Division:
    movlw 0
    subwf Num2,W,A		// Checar si es 0 el segundo numero
    btfsc STATUS,2,A
	call PrendeTodo		// Si es 0 Prende todos los leds
	
    movf Num2,W,A
    subwf Num1,W,A
    btfss STATUS,4,A
	bra Rest
	bra PrendeTodo
	
	Rest:
	    incf Aux2,A
	    movwf Num1,A
	    movf Num2,W,A
	    subwf Num1,W,A
	    btfss STATUS,4,A
		bra Rest
		movf Aux2,W,A
		call Total		
    return
    
PrendeTodo:
    setf LATD,A
    return
    
Total:
    movwf Resultado,A
    movff Resultado,LATD
    return
    
BotonF:				// Boton #
    call Retardo
    btfss PORTB,3,A
	bra BotonF
	clrf LATA,A
	clrf LATD,A
	clrf Num1,A
	clrf Num2,A
	clrf Aux,A
	clrf Aux2,A
	clrf Resultado,A
	return
		
	
GuardarNumero:
    btfss Aux,7,A
	goto Numero1
	goto Numero2
	
Numero1:
    movwf Num1,A
    goto Revisar_1_Columna
    
Numero2:
    movwf Num2,A
    goto Revisar_1_Columna
    
	
Retardo:
    movlw 220
    movwf Cont2,A		// Inicia contador2 en 220
    clrf Cont2,A		// Limpia contador2
    goto limpiar
limpiar:
    clrf WREG,A			// Limpia registro de trabajo
    clrf Cont1,A		// Limpia contador1
new:
    incf Cont1,F,A		// Va incrementando 1 y guardando en el mismo registro contador1
    movf Cont1,W,A		// Mueve lo del contador1 a el registro de trabajo
    btfss STATUS,0,A		// Checa si se activo la bandera de carry 
	goto new
	goto siguiente
siguiente:
    incf Cont2,F,A		// Hace lo mismo con el contador2
    movf Cont2,W,A
    btfss STATUS,0,A
	goto limpiar
	goto limpiar2
limpiar2:			// Limpia todo antes de regresar al programa
    clrf WREG,A
    clrf Cont1,A
    clrf Cont2,A
    return


    
 
 //
// CONFIGURATION BITS SETTING, THIS IS REQUIRED TO CONFITURE THE OPERATION OF THE MICROCONTROLLER
// AFTER RESET. ONCE PROGRAMMED IN THIS PRACTICA THIS IS NOT NECESARY TO INCLUDE IN FUTURE PROGRAMS
// IF THIS SETTINGS ARE NOT CHANGED. SEE SECTION 26 OF DATA SHEET. 
//   
// CONFIG1L
    CONFIG  PLLSEL = PLL4X        // PLL Selection (4x clock multiplier)
    CONFIG  CFGPLLEN = OFF        // PLL Enable Configuration bit (PLL Disabled (firmware controlled))
    CONFIG  CPUDIV = NOCLKDIV     // CPU System Clock Postscaler (CPU uses system clock (no divide))
    CONFIG  LS48MHZ = SYS24X4     // Low Speed USB mode with 48 MHz system clock (System clock at 24 MHz, USB clock divider is set to 4)
// CONFIG1H
    CONFIG  FOSC = INTOSCIO       // Oscillator Selection (Internal oscillator) 
    CONFIG  PCLKEN = ON           // Primary Oscillator Shutdown (Primary oscillator enabled)
    CONFIG  FCMEN = OFF           // Fail-Safe Clock Monitor (Fail-Safe Clock Monitor disabled)
    CONFIG  IESO = OFF            // Internal/External Oscillator Switchover (Oscillator Switchover mode disabled)
// CONFIG2L
    CONFIG  nPWRTEN = OFF         // Power-up Timer Enable (Power up timer disabled)
    CONFIG  BOREN = SBORDIS       // Brown-out Reset Enable (BOR enabled in hardware (SBOREN is ignored))
    CONFIG  BORV = 190            // Brown-out Reset Voltage (BOR set to 1.9V nominal)
    CONFIG  nLPBOR = OFF          // Low-Power Brown-out Reset (Low-Power Brown-out Reset disabled)
// CONFIG2H
    CONFIG  WDTEN = OFF           // Watchdog Timer Enable bits (WDT disabled in hardware (SWDTEN ignored))
    CONFIG  WDTPS = 32768         // Watchdog Timer Postscaler (1:32768)
// CONFIG3H
    CONFIG  CCP2MX = RC1          // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          // PORTB A/D Enable bit (PORTB<5:0> pins are configured as analog input channels on Reset)
    CONFIG  T3CMX = RC0           // Timer3 Clock Input MUX bit (T3CKI function is on RC0)
    CONFIG  SDOMX = RB3           // SDO Output MUX bit (SDO function is on RB3)
    CONFIG  MCLRE = ON            // Master Clear Reset Pin Enable (MCLR pin enabled; RE3 input disabled)
// CONFIG4L
    CONFIG  STVREN = ON           // Stack Full/Underflow Reset (Stack full/underflow will cause Reset)
    CONFIG  LVP = ON              // Single-Supply ICSP Enable bit (Single-Supply ICSP enabled if MCLRE is also 1)
    CONFIG  ICPRT = OFF           // Dedicated In-Circuit Debug/Programming Port Enable (ICPORT disabled)
    CONFIG  XINST = OFF           // Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled)
//
// DEFAULT CONFIGURATION FOR THE REST OF THE REGISTERS
//
    CONFIG  CONFIG5L = 0x0F	  // BLOCKS ARE NOT CODE-PROTECTED
    CONFIG  CONFIG5H = 0xC0	  // BOOT BLOCK IS NOT CODE-PROTECTED
    CONFIG  CONFIG6L = 0x0F	  // BLOCKS NOT PROTECTED FROM WRITING
    CONFIG  CONFIG6H = 0xE0	  // CONFIGURATION REGISTERS NOT PROTECTED FROM WRITING
    CONFIG  CONFIG7L = 0x0F	  // BLOCKS NOT PROTECTED FROM TABLE READS
    CONFIG  CONFIG7H = 0x40	  // BOOT BLOCK IS NOT PROTECTED FROM TABLE READS  
    
end resetVec
    
