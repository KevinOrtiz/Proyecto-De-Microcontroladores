#line 1 "C:/Users/Raúl Pisco/Documents/microcontroladores/Proyecto-De-Microcontroladores/Proyecto.c"
unsigned int conversion_adc;
unsigned short kp;
char keypadPort at PORTD;
sbit LCD_RS at RC2_bit;
sbit LCD_EN at RC3_bit;
sbit LCD_D4 at RC4_bit;
sbit LCD_D5 at RC5_bit;
sbit LCD_D6 at RC6_bit;
sbit LCD_D7 at RC7_bit;
sbit LCD_RS_Direction at TRISC2_bit;
sbit LCD_EN_Direction at TRISC3_bit;
sbit LCD_D4_Direction at TRISC4_bit;
sbit LCD_D5_Direction at TRISC5_bit;
sbit LCD_D6_Direction at TRISC6_bit;
sbit LCD_D7_Direction at TRISC7_bit;
char txt_temperatura[15];
float conversion_temperatura;

void init(){
 ANSEL = 0x04;
 ANSELH = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;
 PORTA = 255;
 TRISA = 255;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 ADC_Init();
 Delay_us(20);
}

void main() {
 init();
#line 40 "C:/Users/Raúl Pisco/Documents/microcontroladores/Proyecto-De-Microcontroladores/Proyecto.c"
 do {
 conversion_adc = ADC_Read(2);
 conversion_temperatura = (5 * 100 * conversion_adc) / 1024;
 FloatToStr(conversion_temperatura,txt_temperatura);
 Lcd_Out(2,1,"Temperatura LM35:");
 Lcd_Out(3,6,txt_temperatura);
 Delay_ms(600);
 } while(1);
}
