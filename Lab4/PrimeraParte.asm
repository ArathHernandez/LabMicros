    RADIX DEC	// Seleccionar Decimal como base numerica
    PROCESSOR 18F45K50	// Seleccionar Procesador a utilizar
    #include "pic18f45k50.inc"	// Incluir librerias de la PIC18F45K50

    PSECT resetVec, class=Code, reloc=2, abs
    ORG 0   // Ir al espacio de memoria 0 para comenzar
    
resetVec:
    ORG 32  // Guardar programa desde el espacio de memoria 0020
    GOTO start	// Saltar a seccion start
    
start:
    MOVLB 15	// Mueve el valor 15 a BSR
    
    BCF TRISB,0,0   // En el registro TRISB se limpia/pone a cero el bit 0
    BCF TRISB,1,0   // En el registro TRISB se limpia/pone a cero el bit 1
    
    SETF TRISC,0    // Pone todos los bits del registro TRISC en 1
    
    CLRF LATB,0	    // Pone todos llos bits del registro LATB en 0
    
LOOP:
    BTFSC PORTC,0,0	// Pregunta si el bit 0 del registro PORTC se encuentra en 0 para saltar o no linea
    CALL CASE_A		// Llama a la funcion CASE_A
    BTFSC PORTC,1,0	// Pregunta si el bit 1 del registro PORTC se encuentra en 0  para saltar o no linea
    CALL CASE_B		// Lama a la funcion CASE B
    BRA LOOP		// Brinca a LOOP
    
CASE_A:
    BTG LATB,0,0	// Invierte el bit de la posicion 0 del registro LATB
    RETURN		// Regresa a donde fue llamada la funcion CASE_A
    
CASE_B:
    BTG LATB,1,0	// Invierte el bit de la posicion 0 del registro LATB
    RETURN		// Regresa a donde fue llamada la funcion CASE_B
    
    END resetVec
