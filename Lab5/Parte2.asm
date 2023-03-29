//
// Main.asm
// Programa para familiarizarse con MPLAB
// Arturo Peña Cardosa
//
RADIX     DEC              	    //Seleccionar decimal como base numÈrica
    PROCESSOR 18F45K50	            //Seleccionar procesador a utilizar
    #include  "pic18f45k50.inc"	    //Incluir librerÌas de PIC18F45K50
    
    Cont1 equ 0x30
    Cont2 equ 0x31
    Cont3 equ 0x32
    Cont4 equ 0x33
    Cont5 equ 0x34
    contador equ 0x35
    auxiliar_a equ 0x36

// Memory Allocation

  PSECT resetVec, class=CODE, reloc=2, abs
  ORG	  0	    //Ir al espacio e memoria 0 para comenzar 

// Reset Vector

resetVec:  
    ORG   32	       
    GOTO  Start        

Start: 
    
    MOVLB 15
    CLRF TRISA,A      //leds para saber si entra a la rutina
    CLRF TRISB,A      //leds
    SETF TRISC,A      //botones 0,1,2,6,7
    SETF TRISD,A
    clrf LATB, A
    clrf LATA,A
    clrf contador
    clrf auxiliar_a

LOOP:
    ;goto RUTINA_C
    ;goto RUTINA_B
    goto RUTINA_A
    goto LOOP

RUTINA_A:
    btfss PORTC, 0, A
    call INCREMENTO_A
    btfss PORTC, 1, A
    call DECREMENTO_A
    movff contador, auxiliar_a, A
    rrncf auxiliar_a, 1, 0
    call COMPARAR
    call COMPARAR_2
    movf contador, W, A
    XORWF auxiliar_a, 1
    movff auxiliar_a, LATB, A
    call RETARDO
    goto RUTINA_A

RUTINA_C:
    clrf LATB, A
    btfss PORTC, 0, A
    call INCREMENTO
    btfss PORTC, 1, A
    call DECREMENTO
    clrf LATB, A
    btfss contador,0,A
    movff contador, LATB
    call RETARDO
    goto RUTINA_C
 
COMPARAR:
    btfss contador,7,A
    return
    btfss auxiliar_a,7,A
    bsf auxiliar_a,7,A
    return
    
COMPARAR_2:
    btfsc contador,7,A
    return
    btfsc auxiliar_a,7,A
    bcf auxiliar_a,7,A
    return
    
RUTINA_B:
    clrf LATB, A
    btfss PORTC, 0, A
    call REVISAR_INC_B
    btfss PORTC, 1, A
    call REVISAR_DEC_B
    clrf LATB, A
    btfsc contador,0,A
    movff contador, LATB
    call RETARDO
    goto RUTINA_B

REVISAR_INC_B:
    btfss contador,0,A
    goto PRIMER_INC_B
    call INCREMENTO
    return
    
REVISAR_DEC_B:
    btfsc contador,7,A
    goto DECREMENTO_B
    btfsc contador,6,A
    goto DECREMENTO_B
    btfsc contador,5,A
    goto DECREMENTO_B
    btfsc contador,4,A
    goto DECREMENTO_B
    btfsc contador,3,A
    goto DECREMENTO_B
    btfsc contador,2,A
    goto DECREMENTO_B
    btfsc contador,1,A
    goto DECREMENTO_B
    goto PRIMER_DEC_B
    
INCREMENTO_A:
    bsf LATA, 5
    incf contador, 1
    call RETARDO
    bcf LATA, 5
    return
    
DECREMENTO_A:
    bsf LATA, 6
    decf contador, 1
    call RETARDO
    bcf LATA, 6
    return
    
INCREMENTO:
    bsf LATA, 7
    incf contador, 1
    incf contador, 1
    call RETARDO
    bcf LATA, 7
    return

DECREMENTO:
    bsf LATA, 6
    decf contador, 1
    decf contador, 1
    call RETARDO
    bcf LATA, 6
    return
    
DECREMENTO_B:
    bsf LATA, 6
    decf contador, 1
    decf contador, 1
    call RETARDO
    bcf LATA, 6
    goto RUTINA_B

PRIMER_INC_B:
    bsf LATA, 7
    incf contador, 1
    call RETARDO
    bcf LATA, 7
    goto RUTINA_B
    
PRIMER_DEC_B:
    bsf LATA, 6
    decf contador, 1
    call RETARDO
    bcf LATA, 6
    goto RUTINA_B
    
RETARDO:
    movlw 220
    movwf Cont2,A
    clrf Cont2,A
    goto LIMPIAR
LIMPIAR:
    clrf WREG,A
    clrf Cont1,A
NEW:
    incf Cont1,F,A
    movf Cont1,W,A
    btfss STATUS,0,A
    goto NEW
    goto SIGUIENTE
SIGUIENTE:
    incf Cont2,F,A
    movf Cont2,W,A
    btfss STATUS,0,A
    goto LIMPIAR
    goto LIMPIAR2
LIMPIAR2:
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
