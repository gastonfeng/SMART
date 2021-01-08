/********************************/
/*	PV charge controller	*/
/*	Hardware Ver:2000.3.12	*/
/*	Software Version:V1.00	*/
/*	program by:fengjiantao	*/
/*	2000.11.17		*/
/*	filename:smart.c	*/
/********************************/
#include "16C711.H"
#include "int16cxx.h"


#define TEMP_COMP

//	Hardware configuration

#pragma bit PWMOUT @ 6.4		//脉宽输出口
#pragma bit LOAD @ 5.3			//负载控制口

#pragma bit LED_CHARGE @ 5.2	//充电指示灯
#pragma bit LEDR	@ 6.2		//电平指示灯
#pragma bit LEDG	@ 6.1		//电平指示灯

//	PWM-module-constant
#define PWMADJUSTVAL 22			//脉宽调整值

#define PWMMAXVAL	29			//最大计数脉宽

#define HVD	214	//14.2V,2.4k//1k,充电截止点	

#define FULL	193	//12.8V,电瓶容量满

#define MID	180		//电瓶容量中

#define LOW	158	//10.5V，电瓶欠压

#define DELAYTIMES 150	//状态改变延迟时间

//	variable define
unsigned char PWMDESIRED,PWMHELP,PWMMAX,delay,delayf,delayl,delaym,ledstatus,voltage;
//脉宽值，辅助变量，辅助变量，脉宽调整延时，指示变化延时，指示变化延时，指示变化延时，指示灯状态，蓄电池电压

unsigned char comp_value(unsigned char index);

#pragma origin = 4

interrupt int_server( void)
{
	unsigned char STACKW,STACKS;
	#asm
	btfsc INTCON,INTF	
	goto OVERINT
PwmInt
	movwf STACKW
	swapf STACKW,F
	swapf STATUS,W
	movwf STACKS
	bcf INTCON,T0IF
	btfsc PORTB,PWMOUT
	goto Lowpulse
Highpulse
	comf PWMDESIRED,W
	movwf PWMHELP
	addwf PWMMAX,F
	btfss STATUS,Carry
	goto HighImpInt
HighImpShrt
	movf PWMMAX,W
	addwf PCL,F
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	comf PWMHELP,W
	addlw PWMADJUSTVAL+5
	movwf TMR0
	goto LowImpInt2
HighImpInt
	addlw PWMADJUSTVAL
	movwf TMR0
HighImpInt2
	bsf PORTB,PWMOUT
	movlw PWMMAXVAL-1
	movwf PWMMAX
	swapf STACKS,W
	movwf STATUS
	swapf STACKW,W
	retfie
Lowpulse
	comf PWMHELP,W
	addwf PWMMAX,F
	btfss STATUS,Carry
	goto LowImpInt
LowImpShrt
	movf PWMMAX,W
	addwf PCL,F
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bcf PORTB,PWMOUT
	bsf PORTB,PWMOUT
	comf PWMDESIRED,W
	movwf PWMHELP
	addlw PWMADJUSTVAL+5
	movwf TMR0
	goto HighImpInt2
LowImpInt
	addlw PWMADJUSTVAL
	movwf TMR0
LowImpInt2
	bcf PORTB,PWMOUT
	movlw PWMMAXVAL
	movwf PWMMAX
	swapf STACKS,W
	movwf STATUS
	swapf STACKW,W
	retfie
	
OVERINT
	bcf PORTA,LOAD
	bcf PORTB,LEDR
	bcf PORTB,LEDG
	bcf INTCON,INTE
	bcf INTCON,INTF
	movwf STACKW
	swapf STACKW,F
	swapf STATUS,W
	movwf STACKS
	clrf delayf
	clrf delaym
	swapf STACKS,W
	movwf STATUS
	swapf STACKW,W
	retfie
	
#endasm
}


unsigned char adc()
{
	union{
		unsigned long s16;
		char s8[2];
	}sum;
	char temp;
	char i;
	sum.s16=0;
	ADCON0=0x81;
	clrwdt();
	clrwdt();
	clrwdt();
	clrwdt();
	i=0;
	do{
		clrwdt();
		clrwdt();
		clrwdt();
		clrwdt();
		GO=1;
		while(GO);
		sum.s16+=ADRES;
		i++;
	}while(i!=0);
	
#ifdef TEMP_COMP
	
	temp=sum.s8[1];
	sum.s16=0;
	ADCON0=0x89;
	clrwdt();
	clrwdt();
	clrwdt();
	clrwdt();
	i=0;
	do{
		clrwdt();
		clrwdt();
		clrwdt();
		clrwdt();
		GO=1;
		while(GO);
		sum.s16+=ADRES;
		i++;
	}while(i!=0);
	sum.s8[0]=comp_value(sum.s8[1]);
	sum.s8[1]=sum.s8[0]+temp;
	
#endif
	return sum.s8[1];
}

void adjust(void)
{
	if(voltage>=HVD){
		if(delay==DELAYTIMES){
			if(PWMDESIRED!=0xff)PWMDESIRED++;
			delay=0;
		}
		else delay++;
	}
	if(voltage>=FULL){
		if(delayf==DELAYTIMES){
			ledstatus=FULL;
			delayl=0;
			delaym=0;
			LOAD=1;
			INTE=1;
		}
		else delayf++;
	}
	if(voltage<LOW){
		if(delayl==DELAYTIMES){
			ledstatus=LOW;
			delayf=0;
			delaym=0;
			PWMDESIRED=0;
			PWMOUT=0;
			INTE=0;
			LOAD=0;
		}
		else delayl++;
	}
	if(voltage>=LOW &&voltage<FULL){
		if(delaym==DELAYTIMES){
			ledstatus=MID;
			delayl=0;
			delayf=0;
			PWMDESIRED=0;
			PWMOUT=0;
			LOAD=1;
			INTE=1;
		}
		else delaym++;
	}
}
	
#ifdef TEMP_COMP
#include "RT_COMP.C"
#endif

void LEDflash(void){
	switch(ledstatus){
		case LOW:{
			LEDR=1;
			LEDG=0;
			break;
		}
		case MID:{
			LEDR=1;
			LEDG=1;
			break;
		}
		case FULL:{
			LEDR=0;
			LEDG=1;
			break;
		}
	}
	if(PWMDESIRED==0xff)LED_CHARGE=0;
	else LED_CHARGE=1;
}
	
void main(void)
{
	TRISA=0x13;
	TRISB=0xe9;
	LOAD=0;
	PWMDESIRED=0;
	PWMOUT=1;
	OPTION=0xf;
	ADCON1=2;
	INTCON=0xa0;
	
	
	LEDR=0;
	LEDG=0;
	LED_CHARGE=1;
	
	while(1){
		clrwdt();
		voltage=adc();
		adjust();
		LEDflash();
	}
}


