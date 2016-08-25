#line 1 "C:/Users/Raúl Pisco/Documents/microcontroladores/Proyecto-De-Microcontroladores/Proyecto.c"
unsigned int conversion_adc;
unsigned short kp, dato_uart;
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
char txt_temperatura[15];
float conversion_temperatura;

void init(){
 ANSEL = 0x04;
 ANSELH = 0;


 TRISA = 0b11110111;

 RA3_bit = 1;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 UART1_Init(9600);
 ADC_Init();
 Delay_us(20);
}

void main() {
 init();
#line 44 "C:/Users/Raúl Pisco/Documents/microcontroladores/Proyecto-De-Microcontroladores/Proyecto.c"
 do {
 conversion_adc = ADC_Read(2);
 conversion_temperatura = (5 * 100 * conversion_adc) / 1024;
 FloatToStr(conversion_temperatura,txt_temperatura);
 Lcd_Out(2,1,"Temperatura LM35:");
 Lcd_Out(3,6,txt_temperatura);
 if(conversion_temperatura > 45){
 RA3_bit = 0;
 Sound_Init(&PORTE,0);
 while(!RA0_bit){
 Sound_Play(1000,250);
 }
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(2,1,"Vehiculo Apagado");
 Delay_ms(3000);
 }
 } while(1);
}
