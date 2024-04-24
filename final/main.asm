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
;   0x54,	--> zawiera 0xFF uzywany przy sprawdzaniu konca gry
;   0x70 - 0x71	--> czas dla LCD
;   0x72        --> 00000001 - gracz1, 00000010 - gracz2 
;   0x73        --> flaga wyswietlenia "WYBIERZ KOLUMNE"
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
    BCF	    STATUS, RP1
    BCF	    STATUS, RP0
;   Reprezentacja board state gracza pierwszego
;   Statki do rozlozenia:
;   1 statek 4x1
;   2 statki 3x1
;   3 statki 2x1
;   4 statki 1x1
;
;   W celu testow, rozlozona minimalna ilosc statkow
;   Poczatkowy board state pierwszego gracza:
    movlw   b'10000000'
    movwf   0x20
    movlw   b'00000000'
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
;   Poczatkowy board state drugiego gracza:
    movlw   b'00000001'
    movwf   0x28
    movlw   b'00000001'
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
;   Poczatkowe strzaly pierwszego gracza:
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
;   Poczatkowe strzaly drugiego gracza:
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
    
;   DANE ODNOSNIE TURY GRACZA
;   JESLI 0x2A = 0 gracz 1
;   JESLI 0x2A = 1 gracz 2
    MOVLW   0x00
    MOVWF   0x2A

;   Stosowane przy sprawdzaniu konca gry
    MOVLW   0xFF
    MOVWF   0x54
    
;   Dane odnosnie trafienia
;   Jesli 0x3C = 0 ostatni strzal nie trafiony
;   Jesli 0x3C = 1 ostatni strzal trafiony
    BCF	    0x3C, 0

;   Dane odnosnie konca gry
;   0x3C, 1	--> Flaga konca gry, dla gracza 1
;		    1 - wygral, 0 - nie wygral
;   0x3C, 2	--> Flaga konca gry, dla gracza 2
;		    1 - wygral, 0 - nie wygral
    BCF	    0x3C, 1
    BCF	    0x3C, 2
    
;   POCZSTKOWY SETUP
;   ZMIANA WEJSC/WYJSC PORTÓW NASTEPUJE W BANKU 01
    BCF	    STATUS, RP1
    BSF	    STATUS, RP0
    
;   PORTA JAKO WYJ?CIA DO WY?WIETLACZA LED - uzywam tylko bitów {0,1,2}
;   Do wyswietlacza moze byc potrzebne wiecej niz 8. (?)
    MOVLW   0x00
    MOVWF   TRISA
;   PORTB JAKO WEJSCIA DO KOORDYNATÓW
    MOVLW   0xFF
    MOVWF   TRISB
;   PORTC JAKO WEJSCIA DO KOORDYNATÓW
    MOVLW   0xFF
    MOVWF   TRISC
;   PORTD JAKO WYJSCIA DO WYSWIETLACZA
    MOVLW   0x00
    MOVWF   TRISD
;   PORTE JAKO WYJSCIA SPECJALNE DO WYSWIETLACZA
    MOVLW   0x00
    MOVWF   TRISE
    
;   POWRÓT DO BANKU 00
    BCF	    STATUS, RP1
    BCF	    STATUS, RP0

;   Wlacza LED MATRIX
    call CLOCK_TURN_ON
    call INIT_LCD
;   G?ówna p?tla rozgrywki
TURY_GRACZY
;   DLA GRACZA 1
;    ||
;   TODO Wyswietl 'tura gracza 1' i
    movlw b'00000001' ;Tura gracza 1
    movwf 0x72
    call WIERSZ
    movlw 0x00
    movwf 0x73
    
;   TODO Zapyraj o ruch
    call DISPLAY_PLAYER_BOARD ; Wy?wietla na LED matrix strza?y gracza 1
    call PRZYJMIJ_RUCH ; Przyjmuje ruch od gracza 1
    call CZY_TRAFIL_TEKST ; TODO wy?wietla tekst 'trafiony albo nie trafiony'
    call SPRAWDZ_CZY_GRACZ_1_WYGRAL ; Sprawdza czy gracz 1 wygra?
    BTFSC   0x3C, 1 ; Je?li wygra? gracz 1 to wywo?aj funkcj?
    call WYGRAL_GRACZ_1_TEKST ; TODO wy?wietla 'wygral gracz 1'

;   DLA GRACZA 2
;    ||
;   TODO Wyswietl 'tura gracza 2' i
    movlw b'00000010' ;Tura gracza 2
    movwf 0x72
    call WIERSZ
    movlw 0x00
    movwf 0x73
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
    call WYGRANA
    ; DO PODMIANY NA TEKST WY?WIETLACZA
;    MOVLW   0xFF ; ZAPALA WSZYSTKIE LAMPKI PORTD 
;    MOVWF   PORTD
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
    call WYGRANA
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
    call TRAFIONY
;    BSF	    PORTA, 4; TRAFIONY!!!
    
    BTFSS   0x3C, 0 ; skip if set
    call NIETRAFIONY
;    BSF	    PORTA, 5; Nie trafiony 
    
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
    decfsz 0x73
    call KOLUMNA
    movlw 0x01
    movwf 0x73
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
    
;   Wybieranie gracza
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

;   CZYSZCZENIE ZAWARTOSCI ADRESÓW
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
    
;   CZYSZCZENIE ZAWARTOSCI ADRESÓW
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
    MOVF    0x36, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x02
    MOVWF   0x2B
    MOVF    0x37, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x03
    MOVWF   0x2B
    MOVF    0x38, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x04
    MOVWF   0x2B
    MOVF    0x39, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x05
    MOVWF   0x2B
    MOVF    0x40, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x06
    MOVWF   0x2B
    MOVF    0x41, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x07
    MOVWF   0x2B
    MOVF    0x42, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x08
    MOVWF   0x2B
    MOVF    0x43, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA

    return

DISPLAY_PLAYER_BOARD_PLAYER_2
    MOVLW   0x01
    MOVWF   0x2B
    MOVF    0x44, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x02
    MOVWF   0x2B
    MOVF    0x45, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x03
    MOVWF   0x2B
    MOVF    0x46, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x04
    MOVWF   0x2B
    MOVF    0x47, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x05
    MOVWF   0x2B
    MOVF    0x48, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x06
    MOVWF   0x2B
    MOVF    0x49, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x07
    MOVWF   0x2B
    MOVF    0x50, W
    MOVWF   0x2C
    call DISPLAY_ON_MATRIX_ROW_DATA
    MOVLW   0x08
    MOVWF   0x2B
    MOVF    0x51, W
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
    
;================ Funkcje LCD ======================= 
 
 CZEKAJ_LCD
    movlw 0x02
    movwf 0x70
 CZEKAJ1_LCD
    movlw 0x02
    movwf 0x71
    decf 0x70
    btfsc STATUS,Z
    return
 CZEKAJ2_LCD
    decf 0x71
    btfsc STATUS,Z
    goto CZEKAJ1_LCD
    goto CZEKAJ2_LCD
 
 INIT_LCD
    movlw b'00000000' ;pierwsza linijka
    movwf PORTE
    
    movlw b'00111000' ;kursor
    movwf PORTD
    call ZATWIERDZ
;    
    movlw b'00001110' ;tryb wpisywania
    movwf PORTD
    call ZATWIERDZ
    return
 
 NEXT_LINE
    movlw b'0000001' ;druga linijka
    movwf PORTE
;    
    movlw b'11000000' ;kursor
    movwf PORTD
    call ZATWIERDZ
 
 WRITE
    movlw b'00000101'
    movwf PORTE
    return
    
 ZATWIERDZ
    btfss PORTE, 0
    incf PORTE, 1
    call CZEKAJ_LCD
    movlw b'11111110'
    andwf PORTE, 1
    call CZEKAJ_LCD
    return
    
 MAKE_SHIFT
    movlw b'00000111' ;shift
    movwf PORTD
    movlw b'00000001'
    movwf PORTE
    call ZATWIERDZ
    return
 
 WRITE_A
    movlw b'01000001' ;A
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_B
    movlw b'01000010' ;B
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_C
    movlw b'01000011' ;C
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_D
    movlw b'01000100' ;D
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_E
    movlw b'01000101' ;E
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_F
    movlw b'01000110' ;F
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_G
    movlw b'01000111' ;G
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_H
    movlw b'01001000' ;H
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_I
    movlw b'01001001' ;I
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_J
    movlw b'01001010' ;J
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_K
    movlw b'01001011' ;K
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_L
    movlw b'01001100' ;L
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_M
    movlw b'01001101' ;M
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_N
    movlw b'01001110' ;N
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_O
    movlw b'01001111' ;O
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_P
    movlw b'01010000' ;P
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_R
    movlw b'01010010' ;R
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_S
    movlw b'01010011' ;S
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_T
    movlw b'01010100' ;T
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_U
    movlw b'01010101' ;U
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_W
    movlw b'01010111' ;W
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_Y
    movlw b'01011001' ;Y
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_Z
    movlw b'01011010' ;Z
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_ONE
    movlw b'00110001' ;1
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_TWO
    movlw b'00110010' ;2
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_WHITESPACE
    movlw b'00100000' ;_
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_DOT
    movlw b'00101110' ;.
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 WRITE_EXCLAMATION
    movlw b'00100001' ;.
    movwf PORTD
    call WRITE
    call ZATWIERDZ
    return
 CLEAR_LCD
    movlw b'00000001' ;kursor
    movwf PORTD
    movlw b'00000001' ;pierwsza linijka
    movwf PORTE
    call ZATWIERDZ
    movlw b'00000010' ;kursor
    movwf PORTD
    movlw b'00000001' ;pierwsza linijka
    movwf PORTE
    call ZATWIERDZ
    return
 KOLUMNA
    BTFSC 0x72, 0
    call GRACZ_1
    BTFSC 0x72, 1
    call GRACZ_2
    call NEXT_LINE
    call WRITE_W
    call WRITE_Y
    call WRITE_B
    call WRITE_I
    call WRITE_E
    call WRITE_R
    call WRITE_Z
    call WRITE_WHITESPACE
    call WRITE_K
    call WRITE_O
    call WRITE_L
    call WRITE_U
    call WRITE_M
    call WRITE_N
    call WRITE_E
    return

 WIERSZ
    BTFSC 0x72, 0
    call GRACZ_1
    BTFSC 0x72, 1
    call GRACZ_2
    call NEXT_LINE
    
    call WRITE_W
    call WRITE_Y
    call WRITE_B
    call WRITE_I
    call WRITE_E
    call WRITE_R
    call WRITE_Z
    call WRITE_WHITESPACE
    call WRITE_W
    call WRITE_I
    call WRITE_E
    call WRITE_R
    call WRITE_S
    call WRITE_Z
    return
 TRAFIONY
    BTFSC 0x72, 0
    call GRACZ_1
    BTFSC 0x72, 1
    call GRACZ_2
    call NEXT_LINE
    
    call WRITE_T
    call WRITE_R
    call WRITE_A
    call WRITE_F
    call WRITE_I
    call WRITE_O
    call WRITE_N
    call WRITE_Y
    return
  NIETRAFIONY
    BTFSC 0x72, 0
    call GRACZ_1
    BTFSC 0x72, 1
    call GRACZ_2
    call NEXT_LINE
    
    call WRITE_N
    call WRITE_I
    call WRITE_E
    call WRITE_T
    call WRITE_R
    call WRITE_A
    call WRITE_F
    call WRITE_I
    call WRITE_O
    call WRITE_N
    call WRITE_Y
    return
 WYGRANA
    BTFSC 0x72, 0
    call GRACZ_1
    BTFSC 0x72, 1
    call GRACZ_2
    call NEXT_LINE
    
    call WRITE_W
    call WRITE_Y
    call WRITE_G
    call WRITE_R
    call WRITE_A
    call WRITE_N
    call WRITE_A
    call WRITE_EXCLAMATION
    return
 GRACZ_1
    call CLEAR_LCD
    call WRITE_G
    call WRITE_R
    call WRITE_A
    call WRITE_C
    call WRITE_Z
    call WRITE_WHITESPACE
    call WRITE_ONE
    return
 GRACZ_2
    call CLEAR_LCD
    call WRITE_G
    call WRITE_R
    call WRITE_A
    call WRITE_C
    call WRITE_Z
    call WRITE_WHITESPACE
    call WRITE_TWO
    return
   end
