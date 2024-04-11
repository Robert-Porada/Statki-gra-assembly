#include <p16f877a.inc>
__CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_ON & _CPD_OFF & _WRT_OFF & _CP_OFF
RES_VECT CODE 0x0000
    goto START
MAIN_PROG CODE
 
START
;   DANE O GRZE - BOARD STATE ZAPISUJEMY W BANKU 00
    bcf STATUS, RP1
    bcf STATUS, RP0
;    Reprezentacja board state gracza pierwszego
;    Statki do roz?o?enia:
;    1 statek 4x1
;    2 statki 3x1
;    3 statki 2x1
;    4 statki 1x1
;
;    Pocz?tkowy board state pierwszego gracza:
    movlw   b'11110000'
    movwf   0x20
    movlw   b'00000111'
    movwf   0x21
    movlw   b'11000000'
    movwf   0x22
    movlw   b'00001100'
    movwf   0x23
    movlw   b'11000000'
    movwf   0x24
    movlw   b'00001110'
    movwf   0x25
    movlw   b'10100000'
    movwf   0x26
    movlw   b'01010000'
    movwf   0x27
; 
;    Pocz?tkowy board state drugiego gracza:
    movlw   b'01010000'
    movwf   0x28
    movlw   b'00000101'
    movwf   0x29
    movlw   b'00110000'
    movwf   0x30
    movlw   b'11001100'
    movwf   0x31
    movlw   b'00110000'
    movwf   0x32
    movlw   b'00000111'
    movwf   0x33
    movlw   b'11100000'
    movwf   0x34
    movlw   b'00001111'
    movwf   0x35
;    
;    Pocz?tkowe strza?y pierwszego gracza:
    movlw   b'00000001'
    movwf   0x36
    movlw   b'00000010'
    movwf   0x37
    movlw   b'00000000'
    movwf   0x38
    movlw   b'00000000'
    movwf   0x39
    movlw   b'00000000'
    movwf   0x40
    movlw   b'00000000'
    movwf   0x41
    movlw   b'00000000'
    movwf   0x42
    movlw   b'00000000'
    movwf   0x43
;    
;    Pocz?tkowe strza?y drugiego gracza:
    movlw   b'00000000'
    movwf   0x44
    movlw   b'00000000'
    movwf   0x45
    movlw   b'00000000'
    movwf   0x46
    movlw   b'00000000'
    movwf   0x47
    movlw   b'00000000'
    movwf   0x48
    movlw   b'00000000'
    movwf   0x49
    movlw   b'10000000'
    movwf   0x50
    movlw   b'10000000'
    movwf   0x51
    
;    DANE ODNO?NIE TURY GRACZA
;    JE?LI 0x2A = 0 gracz 1
;    JE?LI 0x2A = 1 gracz 2
    movlw   0x00
    movwf   0x2A
    
    
MAIN
;   POCZ?TKOWY SETUP
;   ZMIANA WEJ??/WYJ?? PORTÓW NAST?PUJE W BANKU 01
    bcf STATUS, RP1
    bsf STATUS, RP0
    
;   PORTA JAKO WYJ?CIA DO WY?WIETLACZA LED - u?ywam tylko bitów {0,1,2} Do wy?wietlacza mo?e by? potrzebne wi?cej ni? 8.
    MOVLW   0x00
    MOVWF   TRISA
;   PORTB JAKO WEJ?CIA DO KOORDYNATÓW
    MOVLW   0xFF
    MOVWF   TRISB
;   PORTC JAKO WEJ?CIA DO KOORDYNATÓW
    MOVLW   0xFF
    MOVWF   TRISC
;   PORTD JAKO WYJ?CIA DO WY?WIETLACZA
    MOVLW   0x00
    MOVWF   TRISD
    
;   POWRÓT DO BANKU 00
    bcf STATUS, RP1
    bcf STATUS, RP0

;   TEST DZIA?ANIA WY?WIETLACZA
    call CLOCK_TURN_ON


TURY_GRACZY
;    DLA GRACZA 1
;    ||
;    Wy?wietl tura gracza 1 i 
;    Zapyraj o ruch
;    Przyjmij ruch
call DISPLAY_PLAYER_BOARD
    
call PRZYJMIJ_RUCH

call DISPLAY_PLAYER_BOARD
    
call PRZYJMIJ_RUCH
   
call DISPLAY_PLAYER_BOARD

    
;    TEST CZY PRZYJMOWANIE RUCHÓW DZIA?A
    MOVLW   0x00
    MOVWF   PORTD
    
;    sprawd? czy trafi?
;    POWIEDZ NA WY?WIETLACZU CZY TRAFI? 
;    sprawd? czy gra si? sko?czy?a je?li tak wy?wietl i zatrzymaj program
;    
;    DLA GRACZA 2
;    ||
;    Wy?wietl tura gracza 2 i 
;    Zapyraj o ruch
;    Przyjmij ruch
;    sprawd? czy trafi?
;    POWIEDZ NA WY?WIETLACZU CZY TRAFI? 
;    sprawd? czy gra si? sko?czy?a je?li tak wy?wietl i zatrzymaj program
    
    
    goto TURY_GRACZY
    goto MAIN

;   ==============================================================
;   ============================FUNKCJE===========================    
;   ==============================================================
    
;   ================PRZYJMOWANIE RUCHU GRACZY=====================
PRZYJMIJ_RUCH
;    Wybieranie kolumny
    BTFSC   PORTB, 0
    BSF	    0x52, 0
    BTFSC   PORTB, 1
    BSF	    0x52, 1
    BTFSC   PORTB, 2
    BSF	    0x52, 2
    BTFSC   PORTB, 3
    BSF	    0x52, 3
    BTFSC   PORTB, 4
    BSF	    0x52, 4
    BTFSC   PORTB, 5
    BSF	    0x52, 5
    BTFSC   PORTB, 6
    BSF	    0x52, 6
    BTFSC   PORTB, 7
    BSF	    0x52, 7
;    JE?LI CO? ZOSTA?O KLIKNI?TE TO PRZECHODZI DO PRZYJMIJ_RUCH_WIERSZ
;    JE?LI NIE TO CZEKA NA INPUT
    INCF    0x52, 1
    DECFSZ  0x52, 1
    goto PRZYJMIJ_RUCH_WIERSZ
    goto PRZYJMIJ_RUCH
    
PRZYJMIJ_RUCH_WIERSZ
;    POMOC W TESTACH DO USUNI?CIA
    MOVF    0x52, W
    MOVWF   PORTD

    BTFSC   PORTC, 0
    BSF	    0x53, 0
    BTFSC   PORTC, 1
    BSF	    0x53, 1
    BTFSC   PORTC, 2
    BSF	    0x53, 2
    BTFSC   PORTC, 3
    BSF	    0x53, 3
    BTFSC   PORTC, 4
    BSF	    0x53, 4
    BTFSC   PORTC, 5
    BSF	    0x53, 5
    BTFSC   PORTC, 6
    BSF	    0x53, 6
    BTFSC   PORTC, 7
    BSF	    0x53, 7

;    JE?LI CO? ZOSTA?O KLIKNI?TE TO PRZECHODZI DO ZAPISZ_RUCH_GRACZ_1
;    JE?LI NIE TO CZEKA NA INPUT
    INCF    0x53, 1
    DECFSZ  0x53, 1
    goto ZAPISZ_RUCH_GRACZY
    goto PRZYJMIJ_RUCH_WIERSZ    
    
ZAPISZ_RUCH_GRACZY
;    POMOC W TESTACH DO USUNI?CIA
    MOVF    0x53, W
    MOVWF   PORTD
    
;    Wybieranie gracza
    BTFSS   0x2A, 0 ;BIT TEST SKIP IF SET
    goto    ZAPIS_RUCHU_GRACZ_1
    goto    ZAPIS_RUCHU_GRACZ_2
    
ZAPIS_RUCHU_GRACZ_1
;    ODZYSKIWANIE ADRESU KOLUMNY ZE ZMIENNEJ 0x52
    BTFSC   0x52, 0
    MOVLW   0x36
    BTFSC   0x52, 1
    MOVLW   0x37
    BTFSC   0x52, 2
    MOVLW   0x38
    BTFSC   0x52, 3
    MOVLW   0x39
    BTFSC   0x52, 4
    MOVLW   0x40
    BTFSC   0x52, 5
    MOVLW   0x41
    BTFSC   0x52, 6
    MOVLW   0x42
    BTFSC   0x52, 7
    MOVLW   0x43
    
;    PO?REDNIA ADRESACJA, ZMIANA W MACIERZY STRZA?ÓW
    MOVWF   FSR
    CLRF INDF
    BCF	    STATUS, IRP
    MOVF    0x53, W
    MOVWF   INDF
    
;    POMOC W TESTACH DO USUNI?CIA
    MOVF    0x36, W
    MOVWF   PORTA
    
;   ZMIANA NA NEXT GRACZA
    BSF	    0x2A, 0

;   CZYSZCZENIE ZAWARTO?CI ADRESÓW
    MOVLW   0x00
    MOVWF   0x52
    MOVLW   0x00
    MOVWF   0x53
  
    return

ZAPIS_RUCHU_GRACZ_2
;    ODZYSKIWANIE ADRESU KOLUMNY ZE ZMIENNEJ 0x52
    BTFSC   0x52, 0
    MOVLW   0x44
    BTFSC   0x52, 1
    MOVLW   0x45
    BTFSC   0x52, 2
    MOVLW   0x46
    BTFSC   0x52, 3
    MOVLW   0x47
    BTFSC   0x52, 4
    MOVLW   0x48
    BTFSC   0x52, 5
    MOVLW   0x49
    BTFSC   0x52, 6
    MOVLW   0x50
    BTFSC   0x52, 7
    MOVLW   0x51
    
    ;    PO?REDNIA ADRESACJA, ZMIANA W MACIERZY STRZA?ÓW
    MOVWF   FSR
    CLRF INDF
    BCF	    STATUS, IRP
    MOVF    0x53, W
    MOVWF   INDF
    
;    POMOC W TESTACH DO USUNI?CIA
    MOVF    0x52, W
    MOVWF   PORTA
    
;   ZMIANA NA NEXT GRACZA
    BCF	    0x2A, 0
    
;   CZYSZCZENIE ZAWARTO?CI ADRESÓW
    MOVLW   0x00
    MOVWF   0x52
    MOVLW   0x00
    MOVWF   0x53
    
    return
    
    
    
;   ================ KONTROLA LED MATRIX=======================
;   WYKONUJE PULS ZEGARA MULTIPLEKSERA
CLOCK_PULSE
    BSF	    PORTA, 2
    BCF	    PORTA, 2
    return

;   WYKONUJE PULS PINU LOAD, WYSYLA ZAPISANE BITY DO WY?WIETLACZA
LOAD_PULSE
    BSF	    PORTA, 1
    BCF	    PORTA, 1
    return
    
; NAJCZARNIEJSZA MAGIA
CLOCK_TURN_ON
;   TURN ON LED MATRIX - ADRES
    BCF	    PORTA, 0
    call CLOCK_PULSE
    call CLOCK_PULSE
    call CLOCK_PULSE
    call CLOCK_PULSE
    BSF	    PORTA, 0
    call CLOCK_PULSE
    call CLOCK_PULSE
    BCF	    PORTA, 0
    call CLOCK_PULSE
    call CLOCK_PULSE
;   TURN ON LED MATRIX - DATA
    call CLOCK_PULSE
    call CLOCK_PULSE
    call CLOCK_PULSE
    call CLOCK_PULSE
    call CLOCK_PULSE
    call CLOCK_PULSE
    call CLOCK_PULSE
    BSF	    PORTA, 0
    call CLOCK_PULSE
    call LOAD_PULSE
    return    


DISPLAY_PLAYER_BOARD
;    Wybieranie gracza
    BTFSS   0x2A, 0 ;BIT TEST SKIP IF SET
    goto    DISPLAY_PLAYER_BOARD_PLAYER_1
    goto    DISPLAY_PLAYER_BOARD_PLAYER_2    
    
    
DISPLAY_PLAYER_BOARD_PLAYER_1
    MOVLW   0x01
    MOVWF   0x2B
    MOVF 0x36, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x02
    MOVWF   0x2B
    MOVF 0x37, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x03
    MOVWF   0x2B
    MOVF 0x38, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x04
    MOVWF   0x2B
    MOVF 0x39, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x05
    MOVWF   0x2B
    MOVF 0x40, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x06
    MOVWF   0x2B
    MOVF 0x41, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x07
    MOVWF   0x2B
    MOVF 0x42, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x08
    MOVWF   0x2B
    MOVF 0x43, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA

    return

DISPLAY_PLAYER_BOARD_PLAYER_2
    MOVLW   0x01
    MOVWF   0x2B
    MOVF 0x44, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x02
    MOVWF   0x2B
    MOVF 0x45, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x03
    MOVWF   0x2B
    MOVF 0x46, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x04
    MOVWF   0x2B
    MOVF 0x47, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x05
    MOVWF   0x2B
    MOVF 0x48, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x06
    MOVWF   0x2B
    MOVF 0x49, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x07
    MOVWF   0x2B
    MOVF 0x50, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x08
    MOVWF   0x2B
    MOVF 0x51, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA

    return    
    
DISPLAY_ON_MATRIX_ROW_DATA
    BCF	    PORTA, 0
    MOVLW   0x08
    MOVWF   0x3B   
DISPLAY_ADRESS_LOOP
    BTFSC   0x2B, 7 ;bit test skip if clear
    BSF	    PORTA, 0
    call    CLOCK_PULSE
    BCF	    PORTA, 0
    BCF	    STATUS, C
    RLF	    0x2B, 1
    
    DECFSZ  0x3B, 1
    goto DISPLAY_ADRESS_LOOP

    
    MOVLW   0x08
    MOVWF   0x3B
DISPLAY_VALUE_LOOP
    BCF	    PORTA, 0
    BTFSC   0x2C, 7 ;bit test skip if clear
    BSF	    PORTA, 0
    call    CLOCK_PULSE
    BCF	    PORTA, 0
    BCF	    STATUS, C
    RLF	    0x2C, 1
    
    DECFSZ  0x3B, 1
    goto DISPLAY_VALUE_LOOP
    call LOAD_PULSE
    return
    
    
    end
    
   