
; CC5X Version 3.1C, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  27. Jul 2002  15:54  *************

	processor  16C711
	radix  DEC

TMR0        EQU   0x01
OPTION_REG  EQU   0x81
PCL         EQU   0x02
STATUS      EQU   0x03
TRISA       EQU   0x85
TRISB       EQU   0x86
PCLATH      EQU   0x0A
INTCON      EQU   0x0B
Carry       EQU   0
Zero_       EQU   2
RP0         EQU   5
INTF        EQU   1
T0IF        EQU   2
INTE        EQU   4
ADCON0      EQU   0x08
ADRES       EQU   0x09
ADCON1      EQU   0x88
GO          EQU   2
PWMOUT      EQU   4
LOAD        EQU   3
LED_CHARGE  EQU   2
LEDR        EQU   2
LEDG        EQU   1
PWMDESIRED  EQU   0x13
PWMHELP     EQU   0x14
PWMMAX      EQU   0x15
delay       EQU   0x16
delayf      EQU   0x17
delayl      EQU   0x18
delaym      EQU   0x19
ledstatus   EQU   0x1A
voltage     EQU   0x1B
STACKW      EQU   0x0C
STACKS      EQU   0x0D
sum         EQU   0x0E
temp        EQU   0x10
i           EQU   0x11
index       EQU   0x12

	GOTO main

  ; FILE F:\PRODUCT\SMART\PROGRAM\SMART.C
			;/********************************/
			;/*	PV charge controller	*/
			;/*	Hardware Ver:2000.3.12	*/
			;/*	Software Version:V1.00	*/
			;/*	program by:fengjiantao	*/
			;/*	2000.11.17		*/
			;/*	filename:smart.c	*/
			;/********************************/
			;#include "16C711.H"
			;#include "int16cxx.h"
			;
			;
			;#define TEMP_COMP
			;
			;//	Hardware configuration
			;
			;#pragma bit PWMOUT @ 6.4		//脉宽输出口
			;#pragma bit LOAD @ 5.3			//负载控制口
			;
			;#pragma bit LED_CHARGE @ 5.2	//充电指示灯
			;#pragma bit LEDR	@ 6.2		//电平指示灯
			;#pragma bit LEDG	@ 6.1		//电平指示灯
			;
			;//	PWM-module-constant
			;#define PWMADJUSTVAL 22			//脉宽调整值
			;
			;#define PWMMAXVAL	29			//最大计数脉宽
			;
			;#define HVD	214	//14.2V,2.4k//1k,充电截止点	
			;
			;#define FULL	193	//12.8V,电瓶容量满
			;
			;#define MID	180		//电瓶容量中
			;
			;#define LOW	158	//10.5V，电瓶欠压
			;
			;#define DELAYTIMES 150	//状态改变延迟时间
			;
			;//	variable define
			;unsigned char PWMDESIRED,PWMHELP,PWMMAX,delay,delayf,delayl,delaym,ledstatus,voltage;
			;//脉宽值，辅助变量，辅助变量，脉宽调整延时，指示变化延时，指示变化延时，指示变化延时，指示灯状态，蓄电池电压
			;
			;unsigned char comp_value(unsigned char index);
			;
			;#pragma origin = 4
	ORG 0x0004
			;
			;interrupt int_server( void)
			;{
int_server
			;	unsigned char STACKW,STACKS;
			;	#asm
			;	btfsc INTCON,INTF	
	BTFSC 0x0B,INTF
			;	goto OVERINT
	GOTO  m006
			;PwmInt
			;	movwf STACKW
	MOVWF STACKW
			;	swapf STACKW,F
	SWAPF STACKW,1
			;	swapf STATUS,W
	SWAPF STATUS,W
			;	movwf STACKS
	MOVWF STACKS
			;	bcf INTCON,T0IF
	BCF   0x0B,T0IF
			;	btfsc PORTB,PWMOUT
	BTFSC 0x06,PWMOUT
			;	goto Lowpulse
	GOTO  m003
			;Highpulse
			;	comf PWMDESIRED,W
	COMF  PWMDESIRED,W
			;	movwf PWMHELP
	MOVWF PWMHELP
			;	addwf PWMMAX,F
	ADDWF PWMMAX,1
			;	btfss STATUS,Carry
	BTFSS 0x03,Carry
			;	goto HighImpInt
	GOTO  m001
			;HighImpShrt
			;	movf PWMMAX,W
	MOVF  PWMMAX,W
			;	addwf PCL,F
	ADDWF PCL,1
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	comf PWMHELP,W
	COMF  PWMHELP,W
			;	addlw PWMADJUSTVAL+5
	ADDLW .27
			;	movwf TMR0
	MOVWF TMR0
			;	goto LowImpInt2
	GOTO  m005
			;HighImpInt
			;	addlw PWMADJUSTVAL
m001	ADDLW .22
			;	movwf TMR0
	MOVWF TMR0
			;HighImpInt2
			;	bsf PORTB,PWMOUT
m002	BSF   0x06,PWMOUT
			;	movlw PWMMAXVAL-1
	MOVLW .28
			;	movwf PWMMAX
	MOVWF PWMMAX
			;	swapf STACKS,W
	SWAPF STACKS,W
			;	movwf STATUS
	MOVWF STATUS
			;	swapf STACKW,W
	SWAPF STACKW,W
			;	retfie
	RETFIE
			;Lowpulse
			;	comf PWMHELP,W
m003	COMF  PWMHELP,W
			;	addwf PWMMAX,F
	ADDWF PWMMAX,1
			;	btfss STATUS,Carry
	BTFSS 0x03,Carry
			;	goto LowImpInt
	GOTO  m004
			;LowImpShrt
			;	movf PWMMAX,W
	MOVF  PWMMAX,W
			;	addwf PCL,F
	ADDWF PCL,1
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bcf PORTB,PWMOUT
	BCF   0x06,PWMOUT
			;	bsf PORTB,PWMOUT
	BSF   0x06,PWMOUT
			;	comf PWMDESIRED,W
	COMF  PWMDESIRED,W
			;	movwf PWMHELP
	MOVWF PWMHELP
			;	addlw PWMADJUSTVAL+5
	ADDLW .27
			;	movwf TMR0
	MOVWF TMR0
			;	goto HighImpInt2
	GOTO  m002
			;LowImpInt
			;	addlw PWMADJUSTVAL
m004	ADDLW .22
			;	movwf TMR0
	MOVWF TMR0
			;LowImpInt2
			;	bcf PORTB,PWMOUT
m005	BCF   0x06,PWMOUT
			;	movlw PWMMAXVAL
	MOVLW .29
			;	movwf PWMMAX
	MOVWF PWMMAX
			;	swapf STACKS,W
	SWAPF STACKS,W
			;	movwf STATUS
	MOVWF STATUS
			;	swapf STACKW,W
	SWAPF STACKW,W
			;	retfie
	RETFIE
			;	
			;OVERINT
			;	bcf PORTA,LOAD
m006	BCF   0x05,LOAD
			;	bcf PORTB,LEDR
	BCF   0x06,LEDR
			;	bcf PORTB,LEDG
	BCF   0x06,LEDG
			;	bcf INTCON,INTE
	BCF   0x0B,INTE
			;	bcf INTCON,INTF
	BCF   0x0B,INTF
			;	movwf STACKW
	MOVWF STACKW
			;	swapf STACKW,F
	SWAPF STACKW,1
			;	swapf STATUS,W
	SWAPF STATUS,W
			;	movwf STACKS
	MOVWF STACKS
			;	clrf delayf
	CLRF  delayf
			;	clrf delaym
	CLRF  delaym
			;	swapf STACKS,W
	SWAPF STACKS,W
			;	movwf STATUS
	MOVWF STATUS
			;	swapf STACKW,W
	SWAPF STACKW,W
			;	retfie
	RETFIE
			;	
			;#endasm
			;}
			;
			;
			;unsigned char adc()
			;{
adc
			;	union{
			;		unsigned long s16;
			;		char s8[2];
			;	}sum;
			;	char temp;
			;	char i;
			;	sum.s16=0;
	CLRF  sum
	CLRF  sum+1
			;	ADCON0=0x81;
	MOVLW .129
	BCF   0x03,RP0
	MOVWF ADCON0
			;	clrwdt();
	CLRWDT
			;	clrwdt();
	CLRWDT
			;	clrwdt();
	CLRWDT
			;	clrwdt();
	CLRWDT
			;	i=0;
	CLRF  i
			;	do{
			;		clrwdt();
m007	CLRWDT
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		GO=1;
	BCF   0x03,RP0
	BSF   0x08,GO
			;		while(GO);
m008	BCF   0x03,RP0
	BTFSC 0x08,GO
	GOTO  m008
			;		sum.s16+=ADRES;
	MOVF  ADRES,W
	ADDWF sum,1
	BTFSC 0x03,Carry
	INCF  sum+1,1
			;		i++;
	INCFSZ i,1
			;	}while(i!=0);
	GOTO  m007
			;	
			;#ifdef TEMP_COMP
			;	
			;	temp=sum.s8[1];
	MOVF  sum+1,W
	MOVWF temp
			;	sum.s16=0;
	CLRF  sum
	CLRF  sum+1
			;	ADCON0=0x89;
	MOVLW .137
	BCF   0x03,RP0
	MOVWF ADCON0
			;	clrwdt();
	CLRWDT
			;	clrwdt();
	CLRWDT
			;	clrwdt();
	CLRWDT
			;	clrwdt();
	CLRWDT
			;	i=0;
	CLRF  i
			;	do{
			;		clrwdt();
m009	CLRWDT
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		clrwdt();
	CLRWDT
			;		GO=1;
	BCF   0x03,RP0
	BSF   0x08,GO
			;		while(GO);
m010	BCF   0x03,RP0
	BTFSC 0x08,GO
	GOTO  m010
			;		sum.s16+=ADRES;
	MOVF  ADRES,W
	ADDWF sum,1
	BTFSC 0x03,Carry
	INCF  sum+1,1
			;		i++;
	INCFSZ i,1
			;	}while(i!=0);
	GOTO  m009
			;	sum.s8[0]=comp_value(sum.s8[1]);
	MOVF  sum+1,W
	CALL  comp_value
	MOVWF sum
			;	sum.s8[1]=sum.s8[0]+temp;
	MOVF  temp,W
	ADDWF sum,W
	MOVWF sum+1
			;	
			;#endif
			;	return sum.s8[1];
	MOVF  sum+1,W
	RETURN
			;}
			;
			;void adjust(void)
			;{
adjust
			;	if(voltage>=HVD){
	MOVLW .214
	SUBWF voltage,W
	BTFSS 0x03,Carry
	GOTO  m012
			;		if(delay==DELAYTIMES){
	MOVF  delay,W
	XORLW .150
	BTFSS 0x03,Zero_
	GOTO  m011
			;			if(PWMDESIRED!=0xff)PWMDESIRED++;
	INCFSZ PWMDESIRED,W
	INCF  PWMDESIRED,1
			;			delay=0;
	CLRF  delay
			;		}
			;		else delay++;
	GOTO  m012
m011	INCF  delay,1
			;	}
			;	if(voltage>=FULL){
m012	MOVLW .193
	SUBWF voltage,W
	BTFSS 0x03,Carry
	GOTO  m014
			;		if(delayf==DELAYTIMES){
	MOVF  delayf,W
	XORLW .150
	BTFSS 0x03,Zero_
	GOTO  m013
			;			ledstatus=FULL;
	MOVLW .193
	MOVWF ledstatus
			;			delayl=0;
	CLRF  delayl
			;			delaym=0;
	CLRF  delaym
			;			LOAD=1;
	BCF   0x03,RP0
	BSF   0x05,LOAD
			;			INTE=1;
	BSF   0x0B,INTE
			;		}
			;		else delayf++;
	GOTO  m014
m013	INCF  delayf,1
			;	}
			;	if(voltage<LOW){
m014	MOVLW .158
	SUBWF voltage,W
	BTFSC 0x03,Carry
	GOTO  m016
			;		if(delayl==DELAYTIMES){
	MOVF  delayl,W
	XORLW .150
	BTFSS 0x03,Zero_
	GOTO  m015
			;			ledstatus=LOW;
	MOVLW .158
	MOVWF ledstatus
			;			delayf=0;
	CLRF  delayf
			;			delaym=0;
	CLRF  delaym
			;			PWMDESIRED=0;
	CLRF  PWMDESIRED
			;			PWMOUT=0;
	BCF   0x03,RP0
	BCF   0x06,PWMOUT
			;			INTE=0;
	BCF   0x0B,INTE
			;			LOAD=0;
	BCF   0x05,LOAD
			;		}
			;		else delayl++;
	GOTO  m016
m015	INCF  delayl,1
			;	}
			;	if(voltage>=LOW &&voltage<FULL){
m016	MOVLW .158
	SUBWF voltage,W
	BTFSS 0x03,Carry
	GOTO  m018
	MOVLW .193
	SUBWF voltage,W
	BTFSC 0x03,Carry
	GOTO  m018
			;		if(delaym==DELAYTIMES){
	MOVF  delaym,W
	XORLW .150
	BTFSS 0x03,Zero_
	GOTO  m017
			;			ledstatus=MID;
	MOVLW .180
	MOVWF ledstatus
			;			delayl=0;
	CLRF  delayl
			;			delayf=0;
	CLRF  delayf
			;			PWMDESIRED=0;
	CLRF  PWMDESIRED
			;			PWMOUT=0;
	BCF   0x03,RP0
	BCF   0x06,PWMOUT
			;			LOAD=1;
	BSF   0x05,LOAD
			;			INTE=1;
	BSF   0x0B,INTE
			;		}
			;		else delaym++;
	GOTO  m018
m017	INCF  delaym,1
			;	}
			;}
m018	RETURN

  ; FILE RT_COMP.C
			;unsigned char comp_value(unsigned char index)
			;{
comp_value
	MOVWF index
			;    if(index<50)return 0;
	MOVLW .50
	SUBWF index,W
	BTFSS 0x03,Carry
	RETLW .0
			;    if(index>227)return 0;
	MOVLW .228
	SUBWF index,W
	BTFSC 0x03,Carry
	RETLW .0
			;    index-=50;
	MOVLW .50
	SUBWF index,1
			;    PCLATH=1;
	MOVLW .1
	MOVWF PCLATH
			;    PCL+=index;
	MOVF  index,W
	ADDWF PCL,1
			;    return 243 ;
	RETLW .243
			;    return 244 ;
	RETLW .244
			;    return 244 ;
	RETLW .244
			;    return 244 ;
	RETLW .244
			;    return 245 ;
	RETLW .245
			;    return 245 ;
	RETLW .245
			;    return 245 ;
	RETLW .245
			;    return 245 ;
	RETLW .245
			;    return 245 ;
	RETLW .245
			;    return 246 ;
	RETLW .246
			;    return 246 ;
	RETLW .246
			;    return 246 ;
	RETLW .246
			;    return 246 ;
	RETLW .246
			;    return 247 ;
	RETLW .247
			;    return 247 ;
	RETLW .247
			;    return 247 ;
	RETLW .247
			;    return 247 ;
	RETLW .247
			;    return 247 ;
	RETLW .247
			;    return 248 ;
	RETLW .248
			;    return 248 ;
	RETLW .248
			;    return 248 ;
	RETLW .248
			;    return 248 ;
	RETLW .248
			;    return 248 ;
	RETLW .248
			;    return 249 ;
	RETLW .249
			;    return 249 ;
	RETLW .249
			;    return 249 ;
	RETLW .249
			;    return 249 ;
	RETLW .249
			;    return 249 ;
	RETLW .249
			;    return 249 ;
	RETLW .249
			;    return 250 ;
	RETLW .250
			;    return 250 ;
	RETLW .250
			;    return 250 ;
	RETLW .250
			;    return 250 ;
	RETLW .250
			;    return 250 ;
	RETLW .250
			;    return 250 ;
	RETLW .250
			;    return 251 ;
	RETLW .251
			;    return 251 ;
	RETLW .251
			;    return 251 ;
	RETLW .251
			;    return 251 ;
	RETLW .251
			;    return 251 ;
	RETLW .251
			;    return 251 ;
	RETLW .251
			;    return 252 ;
	RETLW .252
			;    return 252 ;
	RETLW .252
			;    return 252 ;
	RETLW .252
			;    return 252 ;
	RETLW .252
			;    return 252 ;
	RETLW .252
			;    return 252 ;
	RETLW .252
			;    return 253 ;
	RETLW .253
			;    return 253 ;
	RETLW .253
			;    return 253 ;
	RETLW .253
			;    return 253 ;
	RETLW .253
			;    return 253 ;
	RETLW .253
			;    return 253 ;
	RETLW .253
			;    return 253 ;
	RETLW .253
			;    return 254 ;
	RETLW .254
			;    return 254 ;
	RETLW .254
			;    return 254 ;
	RETLW .254
			;    return 254 ;
	RETLW .254
			;    return 254 ;
	RETLW .254
			;    return 254 ;
	RETLW .254
			;    return 254 ;
	RETLW .254
			;    return 255 ;
	RETLW .255
			;    return 255 ;
	RETLW .255
			;    return 255 ;
	RETLW .255
			;    return 255 ;
	RETLW .255
			;    return 255 ;
	RETLW .255
			;    return 255 ;
	RETLW .255
			;    return 255 ;
	RETLW .255
			;    return 255 ;
	RETLW .255
			;    return 0 ;
	RETLW .0
			;    return 0 ;
	RETLW .0
			;    return 0 ;
	RETLW .0
			;    return 0 ;
	RETLW .0
			;    return 0 ;
	RETLW .0
			;    return 0 ;
	RETLW .0
			;    return 0 ;
	RETLW .0
			;    return 1 ;
	RETLW .1
			;    return 1 ;
	RETLW .1
			;    return 1 ;
	RETLW .1
			;    return 1 ;
	RETLW .1
			;    return 1 ;
	RETLW .1
			;    return 1 ;
	RETLW .1
			;    return 1 ;
	RETLW .1
			;    return 1 ;
	RETLW .1
			;    return 2 ;
	RETLW .2
			;    return 2 ;
	RETLW .2
			;    return 2 ;
	RETLW .2
			;    return 2 ;
	RETLW .2
			;    return 2 ;
	RETLW .2
			;    return 2 ;
	RETLW .2
			;    return 2 ;
	RETLW .2
			;    return 2 ;
	RETLW .2
			;    return 3 ;
	RETLW .3
			;    return 3 ;
	RETLW .3
			;    return 3 ;
	RETLW .3
			;    return 3 ;
	RETLW .3
			;    return 3 ;
	RETLW .3
			;    return 3 ;
	RETLW .3
			;    return 3 ;
	RETLW .3
			;    return 3 ;
	RETLW .3
			;    return 4 ;
	RETLW .4
			;    return 4 ;
	RETLW .4
			;    return 4 ;
	RETLW .4
			;    return 4 ;
	RETLW .4
			;    return 4 ;
	RETLW .4
			;    return 4 ;
	RETLW .4
			;    return 4 ;
	RETLW .4
			;    return 5 ;
	RETLW .5
			;    return 5 ;
	RETLW .5
			;    return 5 ;
	RETLW .5
			;    return 5 ;
	RETLW .5
			;    return 5 ;
	RETLW .5
			;    return 5 ;
	RETLW .5
			;    return 5 ;
	RETLW .5
			;    return 5 ;
	RETLW .5
			;    return 6 ;
	RETLW .6
			;    return 6 ;
	RETLW .6
			;    return 6 ;
	RETLW .6
			;    return 6 ;
	RETLW .6
			;    return 6 ;
	RETLW .6
			;    return 6 ;
	RETLW .6
			;    return 6 ;
	RETLW .6
			;    return 6 ;
	RETLW .6
			;    return 7 ;
	RETLW .7
			;    return 7 ;
	RETLW .7
			;    return 7 ;
	RETLW .7
			;    return 7 ;
	RETLW .7
			;    return 7 ;
	RETLW .7
			;    return 7 ;
	RETLW .7
			;    return 7 ;
	RETLW .7
			;    return 8 ;
	RETLW .8
			;    return 8 ;
	RETLW .8
			;    return 8 ;
	RETLW .8
			;    return 8 ;
	RETLW .8
			;    return 8 ;
	RETLW .8
			;    return 8 ;
	RETLW .8
			;    return 8 ;
	RETLW .8
			;    return 8 ;
	RETLW .8
			;    return 9 ;
	RETLW .9
			;    return 9 ;
	RETLW .9
			;    return 9 ;
	RETLW .9
			;    return 9 ;
	RETLW .9
			;    return 9 ;
	RETLW .9
			;    return 9 ;
	RETLW .9
			;    return 10 ;
	RETLW .10
			;    return 10 ;
	RETLW .10
			;    return 10 ;
	RETLW .10
			;    return 10 ;
	RETLW .10
			;    return 10 ;
	RETLW .10
			;    return 10 ;
	RETLW .10
			;    return 10 ;
	RETLW .10
			;    return 11 ;
	RETLW .11
			;    return 11 ;
	RETLW .11
			;    return 11 ;
	RETLW .11
			;    return 11 ;
	RETLW .11
			;    return 11 ;
	RETLW .11
			;    return 11 ;
	RETLW .11
			;    return 12 ;
	RETLW .12
			;    return 12 ;
	RETLW .12
			;    return 12 ;
	RETLW .12
			;    return 12 ;
	RETLW .12
			;    return 12 ;
	RETLW .12
			;    return 12 ;
	RETLW .12
			;    return 13 ;
	RETLW .13
			;    return 13 ;
	RETLW .13
			;    return 13 ;
	RETLW .13
			;    return 13 ;
	RETLW .13
			;    return 13 ;
	RETLW .13
			;    return 14 ;
	RETLW .14
			;    return 14 ;
	RETLW .14
			;    return 14 ;
	RETLW .14
			;    return 14 ;
	RETLW .14
			;    return 14 ;
	RETLW .14
			;    return 15 ;
	RETLW .15
			;    return 15 ;
	RETLW .15
			;    return 15 ;
	RETLW .15
			;    return 15 ;
	RETLW .15
			;    return 16 ;
	RETLW .16

  ; FILE F:\PRODUCT\SMART\PROGRAM\SMART.C
			;	
			;#ifdef TEMP_COMP
			;#include "RT_COMP.C"
			;#endif
			;
			;void LEDflash(void){
LEDflash
			;	switch(ledstatus){
	MOVF  ledstatus,W
	XORLW .158
	BTFSC 0x03,Zero_
	GOTO  m019
	XORLW .42
	BTFSC 0x03,Zero_
	GOTO  m020
	XORLW .117
	BTFSC 0x03,Zero_
	GOTO  m021
	GOTO  m022
			;		case LOW:{
			;			LEDR=1;
m019	BCF   0x03,RP0
	BSF   0x06,LEDR
			;			LEDG=0;
	BCF   0x06,LEDG
			;			break;
	GOTO  m022
			;		}
			;		case MID:{
			;			LEDR=1;
m020	BCF   0x03,RP0
	BSF   0x06,LEDR
			;			LEDG=1;
	BSF   0x06,LEDG
			;			break;
	GOTO  m022
			;		}
			;		case FULL:{
			;			LEDR=0;
m021	BCF   0x03,RP0
	BCF   0x06,LEDR
			;			LEDG=1;
	BSF   0x06,LEDG
			;			break;
			;		}
			;	}
			;	if(PWMDESIRED==0xff)LED_CHARGE=0;
m022	INCFSZ PWMDESIRED,W
	GOTO  m023
	BCF   0x03,RP0
	BCF   0x05,LED_CHARGE
			;	else LED_CHARGE=1;
	GOTO  m024
m023	BCF   0x03,RP0
	BSF   0x05,LED_CHARGE
			;}
m024	RETURN
			;	
			;void main(void)
			;{
main
			;	TRISA=0x13;
	MOVLW .19
	BSF   0x03,RP0
	MOVWF TRISA
			;	TRISB=0xe9;
	MOVLW .233
	MOVWF TRISB
			;	LOAD=0;
	BCF   0x03,RP0
	BCF   0x05,LOAD
			;	PWMDESIRED=0;
	CLRF  PWMDESIRED
			;	PWMOUT=1;
	BSF   0x06,PWMOUT
			;	OPTION=0xf;
	MOVLW .15
	BSF   0x03,RP0
	MOVWF OPTION_REG
			;	ADCON1=2;
	MOVLW .2
	MOVWF ADCON1
			;	INTCON=0xa0;
	MOVLW .160
	MOVWF INTCON
			;	
			;	
			;	LEDR=0;
	BCF   0x03,RP0
	BCF   0x06,LEDR
			;	LEDG=0;
	BCF   0x06,LEDG
			;	LED_CHARGE=1;
	BSF   0x05,LED_CHARGE
			;	
			;	while(1){
			;		clrwdt();
m025	CLRWDT
			;		voltage=adc();
	CALL  adc
	MOVWF voltage
			;		adjust();
	CALL  adjust
			;		LEDflash();
	CALL  LEDflash
			;	}
	GOTO  m025

	END
