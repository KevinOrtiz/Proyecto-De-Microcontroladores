#line 1 "C:/Users/Raúl Pisco/Documents/microcontroladores/Proyecto-De-Microcontroladores/proyecto_receptor.c"
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
unsigned short i;
void main() {
 ANSEL=0X00;
 ANSELH=0X00;
 C1ON_bit=0;
 C2ON_bit=0;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 UART1_Init(9600);
 Delay_ms(100);
 Lcd_Out(1,1,"Distancia Recibida:");
 Lcd_Cmd(_LCD_THIRD_ROW);
 while(1){

 if(UART1_Data_Ready()){
 i=UART1_Read();
 Lcd_Chr_CP(i);
 }
 }
}
