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
  ANSEL  = 0x04;
  ANSELH = 0;                 // Configure other AN pins as digital I/O
  C1ON_bit = 0;               // Disable comparators
  C2ON_bit = 0;
  PORTA = 255;
  TRISA = 255;                        // configure PORTA pins as input
  Lcd_Init();                              // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);                     // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);                // Cursor off
  ADC_Init();
  Delay_us(20);
}

void main() {
  init();
  /*
  Para obtener el valor de la temperatura se realiza una conversion. El voltaje de salida del sensor es propocrional
  a la temperatura, y el factor de conversión de temperatura a voltaje es 10mV por centigrados.
  temperatura = (resultado de conversion del ADC) * (5/2^10) * (factor de escala del sensor LM35 que es 10 [mv/C]
  */
  do {
    conversion_adc = ADC_Read(2);   // Get 10-bit results of AD conversion
    conversion_temperatura = (5 * 100 * conversion_adc) / 1024;
    FloatToStr(conversion_temperatura,txt_temperatura);
    Lcd_Out(2,1,"Temperatura LM35:");
    Lcd_Out(3,6,txt_temperatura);
    Delay_ms(600);
  } while(1);
}