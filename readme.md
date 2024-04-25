# Gra w statki - PIC16F877A [Assembly]

Prosty projekt w jezyku assembly pozwalający na grę w statki. Wykonane strzały graczy wyświetlają się na LED MATRIX a informacje pomocnicze na wyświetlaczu LCD.

![Image](https://github.com/Robert-Porada/Projekt-statki/blob/main/img.png)

## Wymagania 
* PicsimLab
* MPLAB X IDE v5.15
## Użytkowanie
Aby uruchomić skompilowaną wersję wystarczy oprogramowanie PicsimLab. 
* Otwórz PicsimLab
* File > Load Workspace i wybierz plik \PicsimLab\final.pzw
* Modules > Spare parts
* W oknie spare parts File > Load configuration i wybierz plik \PicsimLab\final.pcf
* W poprzednim oknie [PICSimLab - Breadboard - PIC16F877A] wybierz opcję file > Load Hex i plik \src\Projekt.X.production.hex

Aby edytować kod lub zmienić podstawową pozycję statków wymagane jest oprogramowanie MPLAB X IDE v5.15
* File > Open Project... i wybierz folder Projekt.X
* Przy pierwszej kompilacji wymagana jest opcja "Clean and Build Project" [Shift+F11]
* Aby uruchomić edytowany kod trzeba zmienić lokalizację pliku hex w PicsimLab na Projekt.X\dist\default\production\Projekt.X.production.hex

Pozycje statków w wersji skompilowanej:

![Image2](https://github.com/Robert-Porada/Projekt-statki/blob/main/board_state.png)

## Dokumentacje
* [PIC16F877A](https://ww1.microchip.com/downloads/en/devicedoc/39582b.pdf) 
* [PICSimLab](https://lcgamboa.github.io/picsimlab_docs/stable/)



