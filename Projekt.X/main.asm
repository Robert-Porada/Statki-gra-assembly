#include <p16f877a.inc>
__CONFIG _FOSC_EXTRC & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_ON & _CPD_OFF & _WRT_OFF & _CP_OFF
RES_VECT CODE 0x0000
    goto START
MAIN_PROG CODE
 
START
;   DANE O ADRESACH W U?YCIU
;   0x20 - 0x29 --> przechowywuje board
;   0x30 - 0x35 --> przechowywuje board
;   0x36 - 0x39 --> przechowywuje strzaly
;   0x40 - 0x49 --> przechowywuje strzaly
;   0x50 - 0x51 --> przechowywuje strzaly
;   0x52, 0x53	--> adresowanie posrednie, adres, wartosc
;   0x54,	--> zawiera 0xFF u?ywany przy sprawdzaniu ko?ca gry
;   0x2A, 0	--> informacja o tym ktorego gracza tura
;   0x2B, 0x2C	--> stosowane do wyswietlania ruchów graczy
;   0x3A	--> stosowany w zapisywaniu kolejnych ruchow
;   0x3B	--> stosowane do wyswietlania ruchów graczy
;   0x3C, 0	--> Flaga czy ostatni strzal byl trafiony
;		    1 - trafiony, 0 - nie trafiony
;   0x3C, 1	--> Flaga konca gry, dla gracza 1
;		    1 - wygral, 0 - nie wygra?
;   0x3C, 2	--> Flaga konca gry, dla gracza 2
;		    1 - wygral, 0 - nie wygra?
;   0x2D 0x2E, 0x2F --> funkcja czekaj
;
;   DANE O GRZE - BOARD STATE ZAPISUJEMY W BANKU 00
    bcf STATUS, RP1
    bcf STATUS, RP0
;   Reprezentacja board state gracza pierwszego
;   Statki do rozlozenia:
;   1 statek 4x1
;   2 statki 3x1
;   3 statki 2x1
;   4 statki 1x1
;
;   W celu testow, rozlozona minimalna ilosc statkow
;   Poczatkowy board state pierwszego gracza:
    movlw   b'00000000'
    movwf   0x20
    movlw   b'00000011'
    movwf   0x21
    movlw   b'00000000'
    movwf   0x22
    movlw   b'00000000'
    movwf   0x23
    movlw   b'00000000'
    movwf   0x24
    movlw   b'00000000'
    movwf   0x25
    movlw   b'00000000'
    movwf   0x26
    movlw   b'00000000'
    movwf   0x27
; 
;    Pocz?tkowy board state drugiego gracza:
    movlw   b'01100000'
    movwf   0x28
    movlw   b'00000000'
    movwf   0x29
    movlw   b'00000000'
    movwf   0x30
    movlw   b'00000000'
    movwf   0x31
    movlw   b'00000000'
    movwf   0x32
    movlw   b'00000000'
    movwf   0x33
    movlw   b'00000000'
    movwf   0x34
    movlw   b'00000000'
    movwf   0x35
;    
;    Pocz?tkowe strza?y pierwszego gracza:
    movlw   b'00000000'
    movwf   0x36
    movlw   b'00000000'
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
    movlw   b'00000000'
    movwf   0x50
    movlw   b'00000000'
    movwf   0x51
    
;    DANE ODNO?NIE TURY GRACZA
;    JE?LI 0x2A = 0 gracz 1
;    JE?LI 0x2A = 1 gracz 2
    movlw   0x00
    movwf   0x2A

;   Stosowane przy sprawdzaniu ko?ca gry
    MOVLW   0xFF
    MOVWF   0x54
    
;   Dane odno?nie trafienia
;   Jesli 0x3C = 0 ostatni strzal nie trafiony
;   Jesli 0x3C = 1 ostatni strzal trafiony
    BCF	    0x3C, 0

;   Dane odno?nie ko?ca gry
;   0x3C, 1	--> Flaga konca gry, dla gracza 1
;		    1 - wygral, 0 - nie wygra?
;   0x3C, 2	--> Flaga konca gry, dla gracza 2
;		    1 - wygral, 0 - nie wygra?
    BCF	    0x3C, 1
    BCF	    0x3C, 2
    
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

;   Wlacza LED MATRIX
    call CLOCK_TURN_ON


TURY_GRACZY
;    DLA GRACZA 1
;    ||
;   TODO Wyswietl 'tura gracza 1' i 
;   TODO Zapyraj o ruch
    call DISPLAY_PLAYER_BOARD ; Wy?wietla na LED matrix strza?y gracza 1
    call PRZYJMIJ_RUCH ; Przyjmuje ruch od gracza 1
    call CZY_TRAFIL_TEKST ; TODO wy?wietla tekst 'trafiony albo nie trafiony'
    call SPRAWDZ_CZY_GRACZ_1_WYGRAL ; Sprawdza czy gracz 1 wygra?
    BTFSC   0x3C, 1 ; Je?li wygra? gracz 1 to wywo?aj funkcj?
    call WYGRAL_GRACZ_1_TEKST ; TODO wy?wietla 'wygra? gracz 1'

;    DLA GRACZA 2
;    ||
;   TODO Wyswietl 'tura gracza 2' i 
;   TODO Zapyraj o ruch
    call DISPLAY_PLAYER_BOARD ; Wy?wietla na LED matrix strza?y gracza 2
    call PRZYJMIJ_RUCH ; Przyjmuje ruch od gracza 2
    call CZY_TRAFIL_TEKST ; TODO wy?wietla tekst 'trafiony albo nie trafiony'
    call SPRAWDZ_CZY_GRACZ_2_WYGRAL ; Sprawdza czy gracz 2 wygra?
    BTFSC   0x3C, 2 ; Je?li wygra? gracz 2 to wywo?aj funkcj?
    call WYGRAL_GRACZ_2_TEKST ; TODO wy?wietla 'wygra? gracz 2'

    goto TURY_GRACZY

;   ==============================================================
;   ============================FUNKCJE===========================    
;   ==============================================================
;
;   ================Wiadomosc o wygranej gracz 1==================
WYGRAL_GRACZ_1_TEKST
    
    MOVLW   0xFF ; ZAPALA WSZYSTKIE LAMPKI PORTD 
    MOVWF   PORTD
    goto $ ; KO?CZY PROGRAM
    return
;
;   =================sprawdz czy gracz 1 wygral===================
SPRAWDZ_CZY_GRACZ_1_WYGRAL
; Wst?pnie ustawiona na tak, je?li obleje który?
; z warunków b?dzie ustawiona na 0
    BSF	    0x3C, 1
    
; Procedura sprawdzania polega na implikacji a => b
; Gdzie 'a' to pozycje statków, a 'b' to strza?y 
    COMF    0x28, 0 ; statki gracza 2 w pierwszym wierszu
    IORWF   0x36, 0 ; strza?y gracza 1 w pierwszym wierszu
    SUBWF   0x54, 0
    BTFSS   STATUS, Z ; Je?li Z = 1 to nie wykonyje linijki ni?ej
    BCF	    0x3C, 1 ; Je?li Z = 0 to warunek nie spe?niony
; Powtórzone dla kolejnych 7 kolumn.
    COMF    0x29, 0
    IORWF   0x37, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 1

    COMF    0x30, 0
    IORWF   0x38, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 1

    COMF    0x31, 0
    IORWF   0x39, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 1

    COMF    0x32, 0
    IORWF   0x40, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 1

    COMF    0x33, 0
    IORWF   0x41, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 1

    COMF    0x34, 0
    IORWF   0x42, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 1

    COMF    0x35, 0
    IORWF   0x43, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 1
    
    return
;   ================Wiadomosc o wygranej gracz 2==================
WYGRAL_GRACZ_2_TEKST
    
    MOVLW   0x0F ; ZAPALA pierwsze 4 lampki portu D 
    MOVWF   PORTD
    goto $ ; KO?CZY PROGRAM
    return
;
;   =================sprawdz czy gracz 2 wygral===================
SPRAWDZ_CZY_GRACZ_2_WYGRAL
    BSF	    0x3C, 2
    
    COMF    0x20, 0 ; statki gracza 1 w pierwszym wierszu
    IORWF   0x44, 0 ; strza?y gracza 2 w pierwszym wierszu
    SUBWF   0x54, 0
    BTFSS   STATUS, Z ; Je?li Z = 1 to nie wykonyje linijki ni?ej
    BCF	    0x3C, 2 ; Je?li Z = 0 to warunek nie spe?niony
; Powtórzone dla kolejnych 7 kolumn.
    COMF    0x21, 0
    IORWF   0x45, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 2

    COMF    0x22, 0
    IORWF   0x46, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 2

    COMF    0x23, 0
    IORWF   0x47, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 2

    COMF    0x24, 0
    IORWF   0x48, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 2

    COMF    0x25, 0
    IORWF   0x49, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 2

    COMF    0x26, 0
    IORWF   0x50, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 2

    COMF    0x27, 0
    IORWF   0x51, 0
    SUBWF   0x54, 0
    BTFSS   STATUS, Z 
    BCF	    0x3C, 2
    
    return
;   ==================Wyswietl czy trafione=======================
CZY_TRAFIL_TEKST
; jak na razie tylko miejsce do sprawdzania czy logika flagi
; trafienia dziala ale pó?niej mo?na w tym miejscu dodac 
; wyswietlanie na wyswietlaczu wiadomosci
    BTFSC   0x3C, 0 ; skip if clear
    BSF	    PORTA, 4; TRAFIONY!!!
    BTFSS   0x3C, 0 ; skip if set
    BSF	    PORTA, 5; Nie trafiony 
    
    MOVLW   0x03 ; Dioda zapala si? na chwil? 
    MOVWF   0x2D ; Je?li trafiono dioda A4
    call CZEKAJ	 ; Je?li nie trafiono dioda A5
    
    BCF	    PORTA, 4 ; Ca?a funkcja do zast?pienia 
    BCF	    PORTA, 5 ; Wy?wietlaniem
    
return
    
    
    
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

    
;    Wybieranie gracza
    BTFSS   0x2A, 0 ;BIT TEST SKIP IF SET
    goto    ZAPIS_RUCHU_GRACZ_1
    BTFSC   0x2A, 0 ;Bit Test, Skip if Clear
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
    BCF	    STATUS, IRP
    
    BTFSC   0x52, 0
    MOVF    0x36, W
    BTFSC   0x52, 1
    MOVF    0x37, W
    BTFSC   0x52, 2
    MOVF    0x38, W
    BTFSC   0x52, 3
    MOVF    0x39, W
    BTFSC   0x52, 4
    MOVF    0x40, W
    BTFSC   0x52, 5
    MOVF    0x41, W
    BTFSC   0x52, 6
    MOVF    0x42, W
    BTFSC   0x52, 7
    MOVF    0x43, W
    
    MOVWF   0x3A
    
    BTFSC   0x53, 0
    BSF	    0x3A, 0
    BTFSC   0x53, 1
    BSF	    0x3A, 1
    BTFSC   0x53, 2
    BSF	    0x3A, 2
    BTFSC   0x53, 3
    BSF	    0x3A, 3
    BTFSC   0x53, 4
    BSF	    0x3A, 4
    BTFSC   0x53, 5
    BSF	    0x3A, 5
    BTFSC   0x53, 6
    BSF	    0x3A, 6
    BTFSC   0x53, 7
    BSF	    0x3A, 7
    
    MOVF    0x3A, W
    MOVWF   INDF
    
    ; Wyczyszczanie flagi trafienia po ostatnim graczu
    BCF	    0x3C, 0 
    ; Sprawdzanie czy gracz 1 trafi? gracza 2
    BTFSC   0x52, 0
    MOVF    0x28, W
    BTFSC   0x52, 1
    MOVF    0x29, W
    BTFSC   0x52, 2
    MOVF    0x30, W
    BTFSC   0x52, 3
    MOVF    0x31, W
    BTFSC   0x52, 4
    MOVF    0x32, W
    BTFSC   0x52, 5
    MOVF    0x33, W
    BTFSC   0x52, 6
    MOVF    0x34, W
    BTFSC   0x52, 7
    MOVF    0x35, W
    
    ; Logiczne and pozycji statku ze strza?em
    ANDWF   0x53, 0
    ; Bit Z z rejestru status:
    ; Z = 1 , The result of an arithmetic or logic operation is zero
    ; Z = 0 , The result of an arithmetic or logic operation is not zero
    BTFSS   STATUS, Z ; Bit Test f, Skip if Set, je?li Z = 1 skipuje.
    BSF	    0x3C, 0; Ustawienie flagi trafienia.
    
    
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
    BCF	    STATUS, IRP
    
    BTFSC   0x52, 0
    MOVF    0x44, W
    BTFSC   0x52, 1
    MOVF    0x45, W
    BTFSC   0x52, 2
    MOVF    0x46, W
    BTFSC   0x52, 3
    MOVF    0x47, W
    BTFSC   0x52, 4
    MOVF    0x48, W
    BTFSC   0x52, 5
    MOVF    0x48, W
    BTFSC   0x52, 6
    MOVF    0x50, W
    BTFSC   0x52, 7
    MOVF    0x51, W
    
    MOVWF   0x3A
    
    BTFSC   0x53, 0
    BSF	    0x3A, 0
    BTFSC   0x53, 1
    BSF	    0x3A, 1
    BTFSC   0x53, 2
    BSF	    0x3A, 2
    BTFSC   0x53, 3
    BSF	    0x3A, 3
    BTFSC   0x53, 4
    BSF	    0x3A, 4
    BTFSC   0x53, 5
    BSF	    0x3A, 5
    BTFSC   0x53, 6
    BSF	    0x3A, 6
    BTFSC   0x53, 7
    BSF	    0x3A, 7
    
    MOVF    0x3A, W
    MOVWF   INDF

    ; Wyczyszczanie flagi trafienia po ostatnim graczu
    BCF	    0x3C, 0 
    ; Sprawdzanie czy gracz 2 trafi? gracza 1
    BTFSC   0x52, 0
    MOVF    0x20, W
    BTFSC   0x52, 1
    MOVF    0x21, W
    BTFSC   0x52, 2
    MOVF    0x22, W
    BTFSC   0x52, 3
    MOVF    0x23, W
    BTFSC   0x52, 4
    MOVF    0x24, W
    BTFSC   0x52, 5
    MOVF    0x25, W
    BTFSC   0x52, 6
    MOVF    0x26, W
    BTFSC   0x52, 7
    MOVF    0x27, W
    
    ; Logiczne and pozycji statku ze strza?em
    ANDWF   0x53, 0
    ; Bit Z z rejestru status:
    ; Z = 1 , The result of an arithmetic or logic operation is zero
    ; Z = 0 , The result of an arithmetic or logic operation is not zero
    BTFSS   STATUS, Z ; Bit Test f, Skip if Set, je?li Z = 1 skipuje.
    BSF	    0x3C, 0; Ustawienie flagi trafienia.
    
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
    
;================ Funkcja Czekaj =======================
CZEKAJ
    movlw 0xff
    movwf 0x2E
    decfsz 0x2D, 1
    goto CZEKAJ1
    return
CZEKAJ1
    movlw 0xff
    movwf 0x2F
    decfsz 0x2E, 1
    goto CZEKAJ2
    goto CZEKAJ
CZEKAJ2
    decfsz 0x2F
    goto CZEKAJ2
    goto CZEKAJ1

    
    
    
    end
    
   