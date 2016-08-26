
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
;Proyecto.c,27 :: 		TRISC=0x80;         //Utiliza RC7 como entrada
	MOVLW      128
	MOVWF      TRISC+0
;Proyecto.c,28 :: 		PORTC=0x80;
	MOVLW      128
	MOVWF      PORTC+0
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
;Proyecto.c,34 :: 		}
L_end_init:
	RETURN
; end of _init

_transmision:

;Proyecto.c,35 :: 		void transmision(char *cadena){ //Funcion que permite enviar cadenas de caracteres de cualquier tamaño vía UART
;Proyecto.c,37 :: 		size=strlen(cadena);
	MOVF       FARG_transmision_cadena+0, 0
	MOVWF      FARG_strlen_s+0
	CALL       _strlen+0
	MOVF       R0+0, 0
	MOVWF      transmision_size_L0+0
	MOVF       R0+1, 0
	MOVWF      transmision_size_L0+1
;Proyecto.c,38 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_transmision0:
	DECFSZ     R13+0, 1
	GOTO       L_transmision0
	DECFSZ     R12+0, 1
	GOTO       L_transmision0
	DECFSZ     R11+0, 1
	GOTO       L_transmision0
	NOP
	NOP
;Proyecto.c,39 :: 		for(i=0; i<size; i++){
	CLRF       transmision_i_L0+0
	CLRF       transmision_i_L0+1
L_transmision1:
	MOVLW      128
	XORWF      transmision_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      transmision_size_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__transmision47
	MOVF       transmision_size_L0+0, 0
	SUBWF      transmision_i_L0+0, 0
L__transmision47:
	BTFSC      STATUS+0, 0
	GOTO       L_transmision2
;Proyecto.c,40 :: 		UART1_Write(cadena[i]);
	MOVF       transmision_i_L0+0, 0
	ADDWF      FARG_transmision_cadena+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Proyecto.c,41 :: 		Delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_transmision4:
	DECFSZ     R13+0, 1
	GOTO       L_transmision4
	DECFSZ     R12+0, 1
	GOTO       L_transmision4
	NOP
;Proyecto.c,39 :: 		for(i=0; i<size; i++){
	INCF       transmision_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       transmision_i_L0+1, 1
;Proyecto.c,42 :: 		}
	GOTO       L_transmision1
L_transmision2:
;Proyecto.c,43 :: 		}
L_end_transmision:
	RETURN
; end of _transmision

_set_distance:

;Proyecto.c,45 :: 		void set_distance(char *cadena, unsigned short caracter, unsigned short *posicion){
;Proyecto.c,46 :: 		cadena[*posicion] = caracter;
	MOVF       FARG_set_distance_posicion+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDWF      FARG_set_distance_cadena+0, 0
	MOVWF      FSR
	MOVF       FARG_set_distance_caracter+0, 0
	MOVWF      INDF+0
;Proyecto.c,47 :: 		*posicion = *posicion + 1;
	MOVF       FARG_set_distance_posicion+0, 0
	MOVWF      FSR
	INCF       INDF+0, 0
	MOVWF      R0+0
	MOVF       FARG_set_distance_posicion+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Proyecto.c,48 :: 		}
L_end_set_distance:
	RETURN
; end of _set_distance

_main:

;Proyecto.c,50 :: 		void main() {
;Proyecto.c,52 :: 		init();
	CALL       _init+0
;Proyecto.c,58 :: 		do {
L_main5:
;Proyecto.c,59 :: 		kp = flag_temperatura = flag_distancia = cont_distancia = flag_sensor = kp3 = 0;
	CLRF       _kp3+0
	BCF        main_flag_sensor_L0+0, BitPos(main_flag_sensor_L0+0)
	MOVLW      0
	BTFSC      main_flag_sensor_L0+0, BitPos(main_flag_sensor_L0+0)
	MOVLW      1
	MOVWF      _cont_distancia+0
	BTFSC      _cont_distancia+0, 0
	GOTO       L__main50
	BCF        main_flag_distancia_L0+0, BitPos(main_flag_distancia_L0+0)
	GOTO       L__main51
L__main50:
	BSF        main_flag_distancia_L0+0, BitPos(main_flag_distancia_L0+0)
L__main51:
	BTFSC      main_flag_distancia_L0+0, BitPos(main_flag_distancia_L0+0)
	GOTO       L__main52
	BCF        main_flag_temperatura_L0+0, BitPos(main_flag_temperatura_L0+0)
	GOTO       L__main53
L__main52:
	BSF        main_flag_temperatura_L0+0, BitPos(main_flag_temperatura_L0+0)
L__main53:
	MOVLW      0
	BTFSC      main_flag_temperatura_L0+0, BitPos(main_flag_temperatura_L0+0)
	MOVLW      1
	MOVWF      _kp+0
;Proyecto.c,60 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,61 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,62 :: 		Lcd_Out(1,6,"Seleccione:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,63 :: 		Lcd_Out(2,1,"1)Ver Temperatura");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,64 :: 		Lcd_Out(3,1,"2)Set Distancia");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,65 :: 		memset(txt_distancia,'\0',strlen(txt_distancia));
	MOVLW      _txt_distancia+0
	MOVWF      FARG_strlen_s+0
	CALL       _strlen+0
	MOVF       R0+0, 0
	MOVWF      FARG_memset_n+0
	MOVF       R0+1, 0
	MOVWF      FARG_memset_n+1
	MOVLW      _txt_distancia+0
	MOVWF      FARG_memset_p1+0
	CLRF       FARG_memset_character+0
	CALL       _memset+0
;Proyecto.c,66 :: 		do{
L_main8:
;Proyecto.c,67 :: 		kp = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;Proyecto.c,68 :: 		}while (!kp);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main8
;Proyecto.c,69 :: 		switch(kp){
	GOTO       L_main11
;Proyecto.c,70 :: 		case 1:
L_main13:
;Proyecto.c,71 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,73 :: 		do{
L_main14:
;Proyecto.c,74 :: 		kp3 = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp3+0
;Proyecto.c,76 :: 		conversion_adc = ADC_Read(2);   // Get 10-bit results of AD conversion
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _conversion_adc+0
	MOVF       R0+1, 0
	MOVWF      _conversion_adc+1
;Proyecto.c,77 :: 		conversion_temperatura = (5 * 100 * conversion_adc) / 1024;
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
L__main54:
	BTFSC      STATUS+0, 2
	GOTO       L__main55
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+1, 7
	ADDLW      255
	GOTO       L__main54
L__main55:
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
;Proyecto.c,78 :: 		FloatToStr(conversion_temperatura,txt_temperatura);
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
;Proyecto.c,79 :: 		Lcd_Out(2,1,"Temperatura LM35:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,80 :: 		Lcd_Out(3,6,txt_temperatura);
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt_temperatura+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,82 :: 		if(conversion_temperatura > 45){
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
	GOTO       L_main17
;Proyecto.c,83 :: 		RA3_bit = 0;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;Proyecto.c,84 :: 		Sound_Init(&PORTE,0);
	MOVLW      PORTE+0
	MOVWF      FARG_Sound_Init_snd_port+0
	CLRF       FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;Proyecto.c,85 :: 		while(!RA0_bit && !flag_temperatura){
L_main18:
	BTFSC      RA0_bit+0, BitPos(RA0_bit+0)
	GOTO       L_main19
	BTFSC      main_flag_temperatura_L0+0, BitPos(main_flag_temperatura_L0+0)
	GOTO       L_main19
L__main44:
;Proyecto.c,86 :: 		Sound_Play(1000,250);
	MOVLW      232
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      3
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      250
	MOVWF      FARG_Sound_Play_duration_ms+0
	CLRF       FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Proyecto.c,87 :: 		}
	GOTO       L_main18
L_main19:
;Proyecto.c,88 :: 		flag_temperatura = 1;
	BSF        main_flag_temperatura_L0+0, BitPos(main_flag_temperatura_L0+0)
;Proyecto.c,89 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,90 :: 		Lcd_Out(2,1,"Vehiculo Apagado");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,91 :: 		Delay_ms(4000);
	MOVLW      41
	MOVWF      R11+0
	MOVLW      150
	MOVWF      R12+0
	MOVLW      127
	MOVWF      R13+0
L_main22:
	DECFSZ     R13+0, 1
	GOTO       L_main22
	DECFSZ     R12+0, 1
	GOTO       L_main22
	DECFSZ     R11+0, 1
	GOTO       L_main22
;Proyecto.c,92 :: 		}else{ flag_temperatura = 0; }
	GOTO       L_main23
L_main17:
	BCF        main_flag_temperatura_L0+0, BitPos(main_flag_temperatura_L0+0)
L_main23:
;Proyecto.c,93 :: 		}while(!kp3);
	MOVF       _kp3+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main14
;Proyecto.c,96 :: 		break;
	GOTO       L_main12
;Proyecto.c,97 :: 		case 2:
L_main24:
;Proyecto.c,98 :: 		while(!flag_distancia){
L_main25:
	BTFSC      main_flag_distancia_L0+0, BitPos(main_flag_distancia_L0+0)
	GOTO       L_main26
;Proyecto.c,99 :: 		kp2=0;
	CLRF       _kp2+0
;Proyecto.c,100 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,101 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Proyecto.c,102 :: 		Lcd_Out(1,1,"Nueva Distancia:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,103 :: 		Lcd_Out(4,1, "(*)Enviar");
	MOVLW      4
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,104 :: 		Lcd_Out(4,11,"(#)Salir");
	MOVLW      4
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,105 :: 		do{
L_main27:
;Proyecto.c,106 :: 		kp2 = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp2+0
;Proyecto.c,107 :: 		}while(!kp2);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main27
;Proyecto.c,108 :: 		switch(kp2){
	GOTO       L_main30
;Proyecto.c,109 :: 		case  1: // 1
L_main32:
;Proyecto.c,110 :: 		set_distance(&txt_distancia, 49, &cont_distancia);kp2=49;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      49
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      49
	MOVWF      _kp2+0
;Proyecto.c,111 :: 		Lcd_Out(3,4,"1");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_Proyecto+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Proyecto.c,112 :: 		break;
	GOTO       L_main31
;Proyecto.c,113 :: 		case  2:// 2
L_main33:
;Proyecto.c,114 :: 		set_distance(&txt_distancia, 50, &cont_distancia);kp2=50;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      50
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      50
	MOVWF      _kp2+0
;Proyecto.c,115 :: 		Lcd_Chr(2,4,'2');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      50
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Proyecto.c,116 :: 		break;
	GOTO       L_main31
;Proyecto.c,117 :: 		case  3: // 3
L_main34:
;Proyecto.c,118 :: 		set_distance(&txt_distancia, 51, &cont_distancia);kp2=51;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      51
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      51
	MOVWF      _kp2+0
;Proyecto.c,119 :: 		Lcd_Chr(2,4,'3');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      51
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Proyecto.c,120 :: 		break;
	GOTO       L_main31
;Proyecto.c,121 :: 		case  5:  // 4
L_main35:
;Proyecto.c,122 :: 		set_distance(&txt_distancia, 52, &cont_distancia);kp2=52;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      52
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      52
	MOVWF      _kp2+0
;Proyecto.c,123 :: 		Lcd_Chr(2,4,'4');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      52
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Proyecto.c,124 :: 		break;
	GOTO       L_main31
;Proyecto.c,125 :: 		case  6:// 5
L_main36:
;Proyecto.c,126 :: 		kp2 = 53;
	MOVLW      53
	MOVWF      _kp2+0
;Proyecto.c,127 :: 		set_distance(&txt_distancia, 53, &cont_distancia);kp2=53;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      53
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      53
	MOVWF      _kp2+0
;Proyecto.c,128 :: 		Lcd_Chr(2,4,'5');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      53
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Proyecto.c,129 :: 		break;
	GOTO       L_main31
;Proyecto.c,130 :: 		case  7: // 6
L_main37:
;Proyecto.c,131 :: 		kp2 = 54;
	MOVLW      54
	MOVWF      _kp2+0
;Proyecto.c,132 :: 		set_distance(&txt_distancia, 54, &cont_distancia);kp2=54;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      54
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      54
	MOVWF      _kp2+0
;Proyecto.c,133 :: 		Lcd_Chr(2,4,'6');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      54
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Proyecto.c,134 :: 		break;
	GOTO       L_main31
;Proyecto.c,135 :: 		case  9: // 7
L_main38:
;Proyecto.c,136 :: 		kp2 = 55;
	MOVLW      55
	MOVWF      _kp2+0
;Proyecto.c,137 :: 		set_distance(&txt_distancia, 55, &cont_distancia);kp2=55;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      55
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      55
	MOVWF      _kp2+0
;Proyecto.c,138 :: 		Lcd_Chr(2,4,'7');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      55
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Proyecto.c,139 :: 		break;
	GOTO       L_main31
;Proyecto.c,140 :: 		case 10: // 8
L_main39:
;Proyecto.c,141 :: 		kp2 = 56;
	MOVLW      56
	MOVWF      _kp2+0
;Proyecto.c,142 :: 		set_distance(&txt_distancia, 56, &cont_distancia);kp2=56;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      56
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      56
	MOVWF      _kp2+0
;Proyecto.c,143 :: 		Lcd_Chr(2,4,'8');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      56
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Proyecto.c,144 :: 		break;
	GOTO       L_main31
;Proyecto.c,145 :: 		case 11: // 9
L_main40:
;Proyecto.c,146 :: 		kp2 = 57;
	MOVLW      57
	MOVWF      _kp2+0
;Proyecto.c,147 :: 		set_distance(&txt_distancia, 57, &cont_distancia);kp2=57;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      57
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      57
	MOVWF      _kp2+0
;Proyecto.c,148 :: 		Lcd_Chr(2,4,'9');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      57
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Proyecto.c,149 :: 		break;
	GOTO       L_main31
;Proyecto.c,150 :: 		case 13:  // *
L_main41:
;Proyecto.c,153 :: 		flag_distancia = 1;
	BSF        main_flag_distancia_L0+0, BitPos(main_flag_distancia_L0+0)
;Proyecto.c,154 :: 		transmision(&txt_distancia);
	MOVLW      _txt_distancia+0
	MOVWF      FARG_transmision_cadena+0
	CALL       _transmision+0
;Proyecto.c,155 :: 		break;
	GOTO       L_main31
;Proyecto.c,156 :: 		case 14: // 0
L_main42:
;Proyecto.c,157 :: 		kp2 = 48;
	MOVLW      48
	MOVWF      _kp2+0
;Proyecto.c,158 :: 		set_distance(&txt_distancia, 48, &cont_distancia);kp2=48;
	MOVLW      _txt_distancia+0
	MOVWF      FARG_set_distance_cadena+0
	MOVLW      48
	MOVWF      FARG_set_distance_caracter+0
	MOVLW      _cont_distancia+0
	MOVWF      FARG_set_distance_posicion+0
	CALL       _set_distance+0
	MOVLW      48
	MOVWF      _kp2+0
;Proyecto.c,159 :: 		Lcd_Chr(2,4,'i');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      105
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Proyecto.c,160 :: 		break;
	GOTO       L_main31
;Proyecto.c,161 :: 		case 15:  // #
L_main43:
;Proyecto.c,163 :: 		flag_distancia = 1;
	BSF        main_flag_distancia_L0+0, BitPos(main_flag_distancia_L0+0)
;Proyecto.c,164 :: 		break;
	GOTO       L_main31
;Proyecto.c,165 :: 		}
L_main30:
	MOVF       _kp2+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main32
	MOVF       _kp2+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main33
	MOVF       _kp2+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main34
	MOVF       _kp2+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main35
	MOVF       _kp2+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_main36
	MOVF       _kp2+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_main37
	MOVF       _kp2+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_main38
	MOVF       _kp2+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_main39
	MOVF       _kp2+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_main40
	MOVF       _kp2+0, 0
	XORLW      13
	BTFSC      STATUS+0, 2
	GOTO       L_main41
	MOVF       _kp2+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_main42
	MOVF       _kp2+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_main43
L_main31:
;Proyecto.c,166 :: 		}
	GOTO       L_main25
L_main26:
;Proyecto.c,167 :: 		break;
	GOTO       L_main12
;Proyecto.c,168 :: 		}
L_main11:
	MOVF       _kp+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main13
	MOVF       _kp+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main24
L_main12:
;Proyecto.c,169 :: 		} while(1);
	GOTO       L_main5
;Proyecto.c,170 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
