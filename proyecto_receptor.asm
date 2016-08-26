
_main:

;proyecto_receptor.c,14 :: 		void main() {
;proyecto_receptor.c,15 :: 		ANSEL=0X00;
	CLRF       ANSEL+0
;proyecto_receptor.c,16 :: 		ANSELH=0X00;
	CLRF       ANSELH+0
;proyecto_receptor.c,17 :: 		C1ON_bit=0;
	BCF        C1ON_bit+0, BitPos(C1ON_bit+0)
;proyecto_receptor.c,18 :: 		C2ON_bit=0;
	BCF        C2ON_bit+0, BitPos(C2ON_bit+0)
;proyecto_receptor.c,19 :: 		Lcd_Init();                              // Initialize LCD
	CALL       _Lcd_Init+0
;proyecto_receptor.c,20 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;proyecto_receptor.c,21 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;proyecto_receptor.c,22 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;proyecto_receptor.c,23 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
;proyecto_receptor.c,24 :: 		Lcd_Out(1,1,"Distancia Recibida:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_proyecto_receptor+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;proyecto_receptor.c,25 :: 		Lcd_Cmd(_LCD_THIRD_ROW);
	MOVLW      148
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;proyecto_receptor.c,26 :: 		while(1){
L_main1:
;proyecto_receptor.c,28 :: 		if(UART1_Data_Ready()){
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main3
;proyecto_receptor.c,29 :: 		i=UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _i+0
;proyecto_receptor.c,30 :: 		Lcd_Chr_CP(i);
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;proyecto_receptor.c,31 :: 		}
L_main3:
;proyecto_receptor.c,32 :: 		}
	GOTO       L_main1
;proyecto_receptor.c,33 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
