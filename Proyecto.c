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
  ANSEL  = 0x04;
  ANSELH = 0;                 // Configure other AN pins as digital I/O
  //C1ON_bit = 0;               // Disable comparators
  //C2ON_bit = 0;
  TRISA = 0b11110111;                        // configure PORTA pins as input
  //PORTA = 0b00001000;
  RA3_bit = 1;
  //TRISC=0x80;         //Utiliza RC7 como entrada
  //PORTC=0x80;
  Lcd_Init();                              // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);                     // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);                // Cursor off
  UART1_Init(9600);
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
    if(conversion_temperatura > 45){
        RA3_bit = 0;
        Sound_Init(&PORTE,0);
        while(!RA0_bit){
           Sound_Play(1000,250);
        }
        Lcd_Cmd(_LCD_CLEAR);                     // Clear display
        Lcd_Out(2,1,"Vehiculo Apagado");
        Delay_ms(3000);
    }
  } while(1);
}