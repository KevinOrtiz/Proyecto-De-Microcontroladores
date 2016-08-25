
_init:

;Proyecto.c,19 :: 		void init(){
;Proyecto.c,20 :: 		ANSEL  = 0x04;
	MOVLW      4
	MOVWF      ANSEL+0
;Proyecto.c,21 :: 		ANSELH = 0;                 // Configure other AN pins as digital I/O
	CLRF       ANSELH+0
;Proyecto.c,24 :: 		TRISA = 0b11110111;                        // configure PORTA pins as input
	MOVLW      247
	MOVWF      TRISA+0
;Proyecto.c,26 :: 		RA3_bit = 1;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;Proyecto.c,29 :: 		Lcd_Init();                              // Initialize LCD
	CALL       _Lcd_Init+0
;Proyecto.c,30 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,31 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,32 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Proyecto.c,33 :: 		ADC_Init();
	CALL       _ADC_Init+0
;Proyecto.c,34 :: 		Delay_us(20);
	MOVLW      13
	MOVWF      R13+0
L_init0:
	DECFSZ     R13+0, 1
	GOTO       L_init0
;Proyecto.c,35 :: 		}
L_end_init:
	RETURN
; end of _init

_main:

;Proyecto.c,37 :: 		void main() {
;Proyecto.c,38 :: 		init();
	CALL       _init+0
;Proyecto.c,44 :: 		do {
L_main1:
;Proyecto.c,45 :: 		conversion_adc = ADC_Read(2);   // Get 10-bit results of AD conversion
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _conversion_adc+0
	MOVF       R0+1, 0
	MOVWF      _conversion_adc+1
;Proyecto.c,46 :: 		conversion_temperatura = (5 * 100 * conversion_adc) / 1024;
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
L__main10:
	BTFSC      STATUS+0, 2
	GOTO       L__main11
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+1, 7
	ADDLW      255
	GOTO       L__main10
L__main11:
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
;Proyecto.c,47 :: 		FloatToStr(conversion_temperatura,txt_temperatura);
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
;Proyecto.c,48 :: 		Lcd_Out(2,1,"Temperatura LM35:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,49 :: 		Lcd_Out(3,6,txt_temperatura);
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt_temperatura+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,50 :: 		if(conversion_temperatura > 45){
	MOVF       _conversion_temperatura+0, 0
	MOVWF      R4+0
	MOVF       _conversion_temperatura+1, 0
	MOVWF      R4+1
	MOVF       _conversion_temperatura+2, 0
	MOVWF      R4+2
	MOVF       _conversion_temperatura+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      52
	MOVWF      R0+2
	MOVLW      132
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main4
;Proyecto.c,51 :: 		RA3_bit = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;Proyecto.c,52 :: 		Sound_Init(&PORTE,0);
	MOVLW      PORTE+0
	MOVWF      FARG_Sound_Init_snd_port+0
	CLRF       FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;Proyecto.c,53 :: 		while(!RA0_bit){
L_main5:
	BTFSC      RA0_bit+0, BitPos(RA0_bit+0)
	GOTO       L_main6
;Proyecto.c,54 :: 		Sound_Play(1000,250);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      250
	MOVWF      FARG_Sound_Play_duration_ms+0
	CLRF       FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Proyecto.c,55 :: 		}
	GOTO       L_main5
L_main6:
;Proyecto.c,56 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,57 :: 		Lcd_Out(2,1,"Vehiculo Apagado");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,58 :: 		Delay_ms(3000);
	MOVLW      31
	MOVWF      R11+0
	MOVLW      113
	MOVWF      R12+0
	MOVLW      30
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
;Proyecto.c,59 :: 		}
L_main4:
;Proyecto.c,60 :: 		} while(1);
	GOTO       L_main1
;Proyecto.c,61 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
