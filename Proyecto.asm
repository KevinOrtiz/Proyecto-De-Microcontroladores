
_init:

;Proyecto.c,19 :: 		void init(){
;Proyecto.c,20 :: 		ANSEL  = 0x04;
	MOVLW      4
	MOVWF      ANSEL+0
;Proyecto.c,21 :: 		ANSELH = 0;                 // Configure other AN pins as digital I/O
	CLRF       ANSELH+0
;Proyecto.c,22 :: 		C1ON_bit = 0;               // Disable comparators
	BCF        C1ON_bit+0, BitPos(C1ON_bit+0)
;Proyecto.c,23 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, BitPos(C2ON_bit+0)
;Proyecto.c,24 :: 		PORTA = 255;
	MOVLW      255
	MOVWF      PORTA+0
;Proyecto.c,25 :: 		TRISA = 255;                        // configure PORTA pins as input
	MOVLW      255
	MOVWF      TRISA+0
;Proyecto.c,26 :: 		Lcd_Init();                              // Initialize LCD
	CALL       _Lcd_Init+0
;Proyecto.c,27 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,28 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,29 :: 		ADC_Init();
	CALL       _ADC_Init+0
;Proyecto.c,30 :: 		Delay_us(20);
	MOVLW      13
	MOVWF      R13+0
L_init0:
	DECFSZ     R13+0, 1
	GOTO       L_init0
;Proyecto.c,31 :: 		}
L_end_init:
	RETURN
; end of _init

_main:

;Proyecto.c,33 :: 		void main() {
;Proyecto.c,34 :: 		init();
	CALL       _init+0
;Proyecto.c,40 :: 		do {
L_main1:
;Proyecto.c,41 :: 		conversion_adc = ADC_Read(2);   // Get 10-bit results of AD conversion
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _conversion_adc+0
	MOVF       R0+1, 0
	MOVWF      _conversion_adc+1
;Proyecto.c,42 :: 		conversion_temperatura = (5 * 100 * conversion_adc) / 1024;
	MOVLW      244
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      10
	MOVWF      R2+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R2+0, 0
L__main7:
	BTFSC      STATUS+0, 2
	GOTO       L__main8
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+1, 7
	ADDLW      255
	GOTO       L__main7
L__main8:
	MOVF       R4+0, 0
	MOVWF      R0+0
	MOVF       R4+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVF       R0+0, 0
	MOVWF      _conversion_temperatura+0
	MOVF       R0+1, 0
	MOVWF      _conversion_temperatura+1
	MOVF       R0+2, 0
	MOVWF      _conversion_temperatura+2
	MOVF       R0+3, 0
	MOVWF      _conversion_temperatura+3
;Proyecto.c,43 :: 		FloatToStr(conversion_temperatura,txt_temperatura);
	MOVF       R0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       R0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       R0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       R0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _txt_temperatura+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Proyecto.c,44 :: 		Lcd_Out(2,1,"Temperatura LM35:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,45 :: 		Lcd_Out(3,6,txt_temperatura);
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt_temperatura+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,46 :: 		Delay_ms(600);
	MOVLW      7
	MOVWF      R11+0
	MOVLW      23
	MOVWF      R12+0
	MOVLW      106
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	DECFSZ     R11+0, 1
	GOTO       L_main4
	NOP
;Proyecto.c,47 :: 		} while(1);
	GOTO       L_main1
;Proyecto.c,48 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
