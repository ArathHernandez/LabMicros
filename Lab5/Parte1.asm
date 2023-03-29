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
    bit_actual equ 0x35
    ultimo_bit equ 0x36
    rotacion equ 0x37

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
    clrf bit_actual
    clrf ultimo_bit
    clrf rotacion
    bsf ultimo_bit, 7
    bsf rotacion, 0

LOOP:
    BTFSS PORTC,0,A
    CALL RUTINA_A
    CALL RETARDO
    BTFSS PORTC,1,A
    CALL RUTINA_B
    BTFSS PORTC,2,A
    CALL RUTINA_C
    CALL CERO
    CALL UNO
    CALL DOS
    CALL TRES
    CALL CUATRO
    CALL CINCO
    CALL SEIS
    CALL SIETE
    CALL RETARDO
    goto LOOP

CERO:
    BTFSC bit_actual, 0
    return
    BTFSC bit_actual, 1
    return
    BTFSC bit_actual, 2
    return
    BTG LATB,0,A
    return
UNO:
    BTFSS bit_actual, 0
    return
    BTFSC bit_actual, 1
    return
    BTFSC bit_actual, 2
    return
    BTG LATB,1,A
    return
DOS:
    BTFSC bit_actual, 0
    return
    BTFSS bit_actual, 1
    return
    BTFSC bit_actual, 2
    return
    BTG LATB,2,A
    return
TRES:
    BTFSS bit_actual, 0
    return
    BTFSS bit_actual, 1
    return
    BTFSC bit_actual, 2
    return
    BTG LATB,3,A
    return
CUATRO:
    BTFSC bit_actual, 0
    return
    BTFSC bit_actual, 1
    return
    BTFSS bit_actual, 2
    return
    BTG LATB,4,A
    return
CINCO:
    BTFSS bit_actual, 0
    return
    BTFSC bit_actual, 1
    return
    BTFSS bit_actual, 2
    return
    BTG LATB,5,A
    return
SEIS:
    BTFSC bit_actual, 0
    return
    BTFSS bit_actual, 1
    return
    BTFSS bit_actual, 2
    return
    BTG LATB,6,A
    return
SIETE:
    BTFSS bit_actual, 0
    return
    BTFSS bit_actual, 1
    return
    BTFSS bit_actual, 2
    return
    BTG LATB,7,A
    return

RUTINA_A:
    bsf LATA,7,A
    call RETARDO
    BTFSC LATB,0
    bsf LATB, 0
RUTINA_AA:
    rlncf LATB,1,0
    incf bit_actual,1
    call RETARDO
    BTFSS PORTC,6,A
    call PAUSA
    BTFSC PORTC,0,0
    bra RUTINA_AA
SALIDA_A:
    clrf LATA,A
    clrf LATB,A
    call RETARDO
    return
    
RUTINA_B:
    bsf LATA,6,A
    call RETARDO
    BTFSC LATB,0
    bsf LATB, 0
RUTINA_BB:
    rrncf LATB,1,0
    decf bit_actual,1
    call LIMITE_DOWN
    call RETARDO
    BTFSS PORTC,6,A
    call PAUSA
    BTFSC PORTC,1,0
    bra RUTINA_BB
SALIDA_B:
    clrf LATA,A
    clrf LATB,A
    call RETARDO
    return

RUTINA_C:
    bsf LATA,5,A
    call RETARDO
    BTFSC LATB,0
    bsf LATB, 0
RUTINA_CC:
    call LAT_CERO
    call LAT_SIETE
    btfsc rotacion, 0
    call IZQUIERDA
    btfsc rotacion, 7
    call DERECHA
    BTFSS PORTC,6,A
    call PAUSA
    BTFSC PORTC,2,0
    bra RUTINA_CC
SALIDA_C:
    clrf LATA,A
    clrf LATB,A
    bsf rotacion, 0
    bcf rotacion, 7
    call RETARDO
    return

PAUSA:
    call RETARDO
    BTFSC PORTC,6,0
    BRA PAUSA
    return
 
LAT_CERO:
    BTFSS LATB, 0
    return
    bsf rotacion, 0
    bcf rotacion, 7
    return

LAT_SIETE:
    BTFSS LATB, 7
    return
    bsf rotacion, 7
    bcf rotacion, 0
    return
    
IZQUIERDA:
    rlncf LATB,1,0
    incf bit_actual,1
    call RETARDO
    return

DERECHA:
    rrncf LATB,1,0
    decf bit_actual,1
    call LIMITE_DOWN
    call RETARDO
    return

LIMITE_UP:
    BTFSS bit_actual, 3
    return
    movff LATB, bit_actual
    return

LIMITE_DOWN:
    BTFSC bit_actual, 0
    return
    BTFSC bit_actual, 1
    return
    BTFSC bit_actual, 2
    return
    movff ultimo_bit, bit_actual
    return
    
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
