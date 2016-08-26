#line 1 "C:/Users/Raúl Pisco/Documents/microcontroladores/Proyecto-De-Microcontroladores/Proyecto.c"
unsigned int conversion_adc;
unsigned short kp, kp2, cont_distancia, kp3;
char keypadPort at PORTD;
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;
sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;
char txt_temperatura[15], txt_distancia[5];
float conversion_temperatura;

void init(){
 ANSEL = 0x04;
 ANSELH = 0;


 TRISA = 0b11110111;

 RA3_bit = 1;
 TRISC=0x80;
 PORTC=0x80;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 UART1_Init(9600);
 ADC_Init();
}
void transmision(char *cadena){
 int size,i;
 size=strlen(cadena);
 Delay_ms(1000);
 for(i=0; i<size; i++){
 UART1_Write(cadena[i]);
 Delay_ms(10);
 }
}

void set_distance(char *cadena, unsigned short caracter, unsigned short *posicion){
 cadena[*posicion] = caracter;
 *posicion = *posicion + 1;
}

void main() {
 bit flag_temperatura, flag_distancia, flag_sensor;
 init();
#line 58 "C:/Users/Raúl Pisco/Documents/microcontroladores/Proyecto-De-Microcontroladores/Proyecto.c"
 do {
 kp = flag_temperatura = flag_distancia = cont_distancia = flag_sensor = kp3 = 0;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,6,"Seleccione:");
 Lcd_Out(2,1,"1)Ver Temperatura");
 Lcd_Out(3,1,"2)Set Distancia");
 memset(txt_distancia,'\0',strlen(txt_distancia));
 do{
 kp = Keypad_Key_Click();
 }while (!kp);
 switch(kp){
 case 1:
 Lcd_Cmd(_LCD_CLEAR);

 do{
 kp3 = Keypad_Key_Click();

 conversion_adc = ADC_Read(2);
 conversion_temperatura = (5 * 100 * conversion_adc) / 1024;
 FloatToStr(conversion_temperatura,txt_temperatura);
 Lcd_Out(2,1,"Temperatura LM35:");
 Lcd_Out(3,6,txt_temperatura);

 if(conversion_temperatura > 45){
 RA3_bit = 0;
 Sound_Init(&PORTE,0);
 while(!RA0_bit && !flag_temperatura){
 Sound_Play(1000,250);
 }
 flag_temperatura = 1;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(2,1,"Vehiculo Apagado");
 Delay_ms(4000);
 }else{ flag_temperatura = 0; }
 }while(!kp3);


 break;
 case 2:
 while(!flag_distancia){
 kp2=0;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"Nueva Distancia:");
 Lcd_Out(4,1, "(*)Enviar");
 Lcd_Out(4,11,"(#)Salir");
 do{
 kp2 = Keypad_Key_Click();
 }while(!kp2);
 switch(kp2){
 case 1:
 set_distance(&txt_distancia, 49, &cont_distancia);kp2=49;
 Lcd_Out(3,4,"1");
 break;
 case 2:
 set_distance(&txt_distancia, 50, &cont_distancia);kp2=50;
 Lcd_Chr(2,4,'2');
 break;
 case 3:
 set_distance(&txt_distancia, 51, &cont_distancia);kp2=51;
 Lcd_Chr(2,4,'3');
 break;
 case 5:
 set_distance(&txt_distancia, 52, &cont_distancia);kp2=52;
 Lcd_Chr(2,4,'4');
 break;
 case 6:
 kp2 = 53;
 set_distance(&txt_distancia, 53, &cont_distancia);kp2=53;
 Lcd_Chr(2,4,'5');
 break;
 case 7:
 kp2 = 54;
 set_distance(&txt_distancia, 54, &cont_distancia);kp2=54;
 Lcd_Chr(2,4,'6');
 break;
 case 9:
 kp2 = 55;
 set_distance(&txt_distancia, 55, &cont_distancia);kp2=55;
 Lcd_Chr(2,4,'7');
 break;
 case 10:
 kp2 = 56;
 set_distance(&txt_distancia, 56, &cont_distancia);kp2=56;
 Lcd_Chr(2,4,'8');
 break;
 case 11:
 kp2 = 57;
 set_distance(&txt_distancia, 57, &cont_distancia);kp2=57;
 Lcd_Chr(2,4,'9');
 break;
 case 13:


 flag_distancia = 1;
 transmision(&txt_distancia);
 break;
 case 14:
 kp2 = 48;
 set_distance(&txt_distancia, 48, &cont_distancia);kp2=48;
 Lcd_Chr(2,4,'i');
 break;
 case 15:

 flag_distancia = 1;
 break;
 }
 }
 break;
 }
 } while(1);
}
