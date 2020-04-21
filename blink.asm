;-------------------------------------------------------------------
;                           BLINK
;-------------------------------------------------------------------
;AUTHOR: LUAN FERREIRA REIS DE JESUS       LAST REVISION: 20/04/2020
;V 1.0.0
;-------------------------------------------------------------------
;                        DESCRIPTION
;-------------------------------------------------------------------
; Simple code to bink a RGB LED
;-------------------------------------------------------------------
;                     DEFINITION FILES
;-------------------------------------------------------------------
#INCLUDE <p16f15376.inc>

;-------------------------------------------------------------------
;                   DEVICE CONFIGURATION
;-------------------------------------------------------------------
    __CONFIG _CONFIG1, _FEXTOSC_OFF & _RSTOSC_HFINT32   ; Turn off external oscilator and set internal oscilator to 32 MHz
    __CONFIG _CONFIG2, _MCLRE_ON & _PWRTE_ON            ; Enable Master Clear and Powerup Timer
    __CONFIG _CONFIG3, _WDTE_OFF                        ; Turn off the watchdog timmer
    __CONFIG _CONFIG4, _LVP_ON                          ; Low voltage programming on

;-------------------------------------------------------------------
;                        VARIABLES
;-------------------------------------------------------------------
    CBLOCK 0X20
        DELAYTEMP2
        DELAYTEMP
        SysWaitTempMS
        SysWaitTempMS_H
    ENDC
;-------------------------------------------------------------------
;                        RESET VECTOR
;-------------------------------------------------------------------
    ORG     0x0000          ; Initial Address
    GOTO    INICIO
;-------------------------------------------------------------------
;                        SUBSOUTINES
;-------------------------------------------------------------------
DELAY_MS
    INCF    SysWaitTempMS_H, 1
DMS_START
    MOVLW   D'14'
    MOVWF   DELAYTEMP2
DMS_OUTER
    MOVLW   D'189'
    MOVWF   DELAYTEMP
DMS_INNER
    DECFSZ  DELAYTEMP, 1
    GOTO    DMS_INNER
    DECFSZ  DELAYTEMP2, 1
    GOTO    DMS_OUTER
    DECFSZ  SysWaitTempMS, 1
    GOTO    DMS_START
    DECFSZ  SysWaitTempMS_H, 1
    GOTO    DMS_START
    RETURN
    
CLOCK_INIT
    BANKSEL OSCCON1         ; Go to bank 17
    MOVLW   B'01100000'     ; HFINTOSC and NDIV = 1
    MOVWF   OSCCON1
    CLRF    OSCCON3         ; Enable
    CLRF    OSCEN
    CLRF    OSCTUNE
    MOVLW   B'00000110'     ; 32MHz
    MOVWF   OSCFRQ
    RETURN

;-------------------------------------------------------------------
;                           MAIN ROUTINE
;-------------------------------------------------------------------
INICIO:
    CALL    CLOCK_INIT
    MOVLB   0x0000          ; Vai para o banco 0
    
    MOVLW   B'11111000'
    MOVWF   TRISB

R1:
    BANKSEL PORTB
    CLRF    PORTB               ; Turn off all leds
    
    MOVLW   B'00000001'         ; turn on led 1
    MOVWF   PORTB
    MOVLW   0X03                ; Define the delay in ms
    MOVWF   SysWaitTempMS_H     ; 1000ms 0x03E8 in HEX
    MOVLW   0XE8
    MOVWF   SysWaitTempMS
    CALL    DELAY_MS
    MOVLW   B'00000010'         ; turn on led 2
    MOVWF   PORTB
    MOVLW   0X03
    MOVWF   SysWaitTempMS_H
    MOVLW   0XE8
    MOVWF   SysWaitTempMS
    CALL    DELAY_MS
    MOVLW   B'00000100'         ; turn on led 3
    MOVWF   PORTB
    MOVLW   0X03
    MOVWF   SysWaitTempMS_H
    MOVLW   0XE8
    MOVWF   SysWaitTempMS
    CALL    DELAY_MS
    GOTO    R1
;-------------------------------------------------------------------
;                           END OF PROGRAM
;-------------------------------------------------------------------
    END