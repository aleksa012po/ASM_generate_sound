;
; MusicExample.asm
;
; Created: 20.06.2022. 13:40:38
; Author : Aleksandar Bogdanovic
;

.include "m328pdef.inc"
.org 0x0000

;-------------------Delay podesavanja---------------------------
.def	oLoopR 	= r18		; spoljasni loop register
.def	iLoopRl = r24		; unutrasnji loop register low
.def	iLoopRh = r25		; unutrasnji loop register high
.equ	iVal 	= 39998		; unutrasnji loop value

;---------------------Tonovi------------------------------------
.equ _c4 = 239 ;(16000000 / 256) / 261.63(frequency of C) - 1
.equ _cs4 = 225 ;(16000000 / 256) / 277.18(frequency of C#) - 1
.equ _d4 = 213 ;(16000000 / 256) / 293.66(frequency of D) - 1
.equ _ds4 = 201 ;(16000000 / 256) / 311.13(frequency of D#) - 1
.equ _e4 = 190 ;(16000000 / 256) / 329.63(frequency of E) - 1
.equ _f4 = 179 ;(16000000 / 256) / 349.23(frequency of F) - 1
.equ _fs4 = 169 ;(16000000 / 256) / 369.99(frequency of F#) - 1
.equ _g4 = 159 ;(16000000 / 256) / 392.00(frequency of G) - 1
.equ _gs4 = 150 ;(16000000 / 256) / 415.30(frequency of G#) - 1
.equ _a4 = 141 ;(16000000 / 256) / 440(frequency of A) - 1
.equ _as4 = 133 ;(16000000 / 256) / 466.16(frequency of A#) - 1
.equ _b4 = 126 ;(16000000 / 256) / 493.88(frequency of B) - 1
.equ _c5 = 118 ;(16000000 / 256) / 523.25(frequency of C) - 1
.equ _cs5 = 112 ;(16000000 / 256) / 554.37(frequency of C#) - 1
.equ _d5 = 105 ;(16000000 / 256) / 587.33(frequency of D) - 1
.equ _ds5 = 99 ;(16000000 / 256) / 622.25(frequency of D#) - 1
.equ _e5 = 94 ;(16000000 / 256) / 659.25(frequency of E) - 1
.equ _f5 = 88 ;(16000000 / 256) / 698.46(frequency of F) - 1
.equ _fs5 = 83 ;(16000000 / 256) / 739.99(frequency of F#) - 1
.equ _g5 = 79 ;(16000000 / 256) / 783.99(frequency of G) - 1
.equ _gs5 = 74 ;(16000000 / 256) / 830.61(frequency of G#) - 1
.equ _a5 = 70 ;(16000000 / 256) / 880.00(frequency of A) - 1
.equ _as5 = 67 ;(16000000 / 256) / 932.33(frequency of A#) - 1
.equ _b5 = 63 ;(16000000 / 256) / 987.77(frequency of B) - 1
.equ _c6 = 60 ;(16000000 / 256) / 1046.50(frequency of C) - 1
.equ _cs6 = 56 ;(16000000 / 256) / 1108.73(frequency of C#) - 1
.equ _d6 = 53 ;(16000000 / 256) / 1174.66(frequency of D) - 1
.equ _ds6 = 50 ;(16000000 / 256) / 1244.51(frequency of D#) - 1
.equ _e6 = 47 ;(16000000 / 256) / 1318.51(frequency of E) - 1
.equ _f6 = 44 ;(16000000 / 256) / 1396.91(frequency of F) - 1
.equ _fs6 = 42 ;(16000000 / 256) / 1479.98(frequency of F#) - 1
.equ _g6 = 40 ;(16000000 / 256) / 1567.98(frequency of G) - 1
;-------------------------PWM duzina----------------------------
.equ c4_ = 120 ;(16000000 / 256) / 261.63 / 2(frequency of C) - 1
.equ cs4_ = 113 ;(16000000 / 256) / 277.18 / 2(frequency of C#) - 1
.equ d4_ = 107 ;(16000000 / 256) / 293.66 / 2(frequency of D) - 1
.equ ds4_ = 101 ;(16000000 / 256) / 311.13 / 2(frequency of D#) - 1
.equ e4_ = 95 ;(16000000 / 256) / 329.63 / 2(frequency of E) - 1
.equ f4_ = 90 ;(16000000 / 256) / 349.23 / 2(frequency of F) - 1
.equ fs4_ = 85 ;(16000000 / 256) / 369.99 / 2(frequency of F#) - 1
.equ g4_ = 80 ;(16000000 / 256) / 392.00 / 2(frequency of G) - 1
.equ gs4_ = 75 ;(16000000 / 256) / 415.30 / 2(frequency of G#) - 1
.equ a4_ = 71 ;(16000000 / 256) / 440 / 2(frequency of A) - 1
.equ as4_ = 67 ;(16000000 / 256) / 466.16 / 2(frequency of A#) - 1
.equ b4_ = 63 ;(16000000 / 256) / 493.88 / 2(frequency of B) - 1
.equ c5_ = 59 ;(16000000 / 256) / 523.25 / 2(frequency of C) - 1
.equ cs5_ = 56 ;(16000000 / 256) / 554.37 / 2(frequency of C#) - 1
.equ d5_ = 53 ;(16000000 / 256) / 587.33 / 2(frequency of D) - 1
.equ ds5_ = 50 ;(16000000 / 256) / 622.25 / 2(frequency of D#) - 1
.equ e5_ = 47 ;(16000000 / 256) / 659.25 / 2(frequency of E) - 1
.equ f5_ = 44 ;(16000000 / 256) / 698.46 / 2(frequency of F) - 1
.equ fs5_ = 42 ;(16000000 / 256) / 739.99 / 2(frequency of F#) - 1
.equ g5_ = 40 ;(16000000 / 256) / 783.99 / 2(frequency of G) - 1
.equ gs5_ = 37 ;(16000000 / 256) / 830.61 / 2(frequency of G#) - 1
.equ a5_ = 35 ;(16000000 / 256) / 880.00 / 2(frequency of A) - 1
.equ as5_ = 33 ;(16000000 / 256) / 932.33 / 2(frequency of A#) - 1
.equ b5_ = 31 ;(16000000 / 256) / 987.77 / 2(frequency of B5) - 1
.equ c6_ = 30 ;(16000000 / 256) / 987.77 / 2(frequency of C6) - 1
.equ cs6_ = 28 ;(16000000 / 256) / 277.18 / 2(frequency of C#) - 1
.equ d6_ = 26 ;(16000000 / 256) / 1174.66 / 2(frequency of D) - 1
.equ ds6_ = 25 ;(16000000 / 256) / 1244.51 / 2(frequency of D#) - 1
.equ e6_ = 23 ;(16000000 / 256) / 1318.51 / 2(frequency of E) - 1
.equ f6_ = 22 ;(16000000 / 256) / 1396.91 / 2(frequency of F) - 1
.equ fs6_ = 21 ;(16000000 / 256) / 1479.98 / 2(frequency of F#) - 1
.equ g6_ = 20 ;(16000000 / 256) / 1567.98 / 2(frequency of G) - 1

;-------------------Generisanje tonova--------------------------
.macro tone
  ;wgm02..0 = 7 (fast pwm, top = ocr0a)
  ;cs02..0 = 4	(N=256)
  ;com0b1..0 = 2 (clear on compare match, set at bottom)
  ldi r16, 0b00100011
  out tccr0a, r16 ;treba out!
  ldi r16, 0b00001100
  out tccr0b, r16 ;treba out!
  ;ocr0a = _a za 440Hz
  ldi r16, @0
  out ocr0a, r16
  ;ocr0b = ocr0a/2 da bi duty cycle bio 50%
  ldi r17, @1
  out ocr0b, r17
  ;omogucen izlaz na D5 (oc0b) tj. Arduino pin 5
  sbi ddrd, 5
  .endmacro

;-------------------Nema zvuka / Tisina-------------------------
.macro mute
cbi ddrd, 5
.endmacro

;-------------------Makro za trajanje tona----------------------
.macro	delayms
	push	r18
	push	r24
	push	r25

	ldi	r18,@0/10
	call	delay10ms

	pop	r25
	pop	r24
	pop	r18
	.endmacro

; C -> C#, F - > F#, G -> G#
; Iron Maiden - Fear of the dark

main:
  mute
 delayms 1000
 tone _d5, d5_
 delayms 200
 mute
  delayms 10
tone _d5, d5_
  delayms 200
  mute
  delayms 10
tone _a4, a4_
  delayms 200
  mute
  delayms 10
tone _a4, a4_
  delayms 200
  mute
  delayms 10
tone _d5, d5_
  delayms 200
  mute
  delayms 10
tone _d5, d5_
  delayms 200
  mute
  delayms 10
tone _e5, e5_
  delayms 200
  mute
  delayms 10
tone _e5, e5_
  delayms 200
  mute
  delayms 10
tone _f5, f5_
  delayms 200
  mute
  delayms 10
tone _f5, f5_
  delayms 200
  mute
  delayms 10
tone _e5, e5_
  delayms 200
  mute
  delayms 10
tone _e5, e5_
  delayms 200
  mute
  delayms 10
tone _d5, d5_
  delayms 200
  mute
  delayms 10
tone _d5, d5_
  delayms 200
  mute
  delayms 10
tone _e5, e5_
  delayms 200
  mute
  delayms 10
tone _e5, e5_
  delayms 200
  mute
  delayms 10
tone _c5, c5_
  delayms 200
  mute
  delayms 10
tone _c5, c5_
  delayms 200
  mute
  delayms 10
tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _e5, e5_
  delayms 200
  mute
  delayms 10
tone _e5, e5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _e5, e5_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
   tone _e5, e5_
  delayms 200
  mute
  delayms 10
   tone _e5, e5_
  delayms 200
  mute
  delayms 10
  tone _f5, f5_
  delayms 200
  mute
  delayms 10
tone _f5, f5_
  delayms 200
  mute
  delayms 10
   tone _e5, e5_
  delayms 200
  mute
  delayms 10
   tone _e5, e5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _e5, e5_
  delayms 200
  mute
  delayms 10
   tone _e5, e5_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _e5, e5_
  delayms 200
  mute
  delayms 10
   tone _e5, e5_
  delayms 200
  mute
  delayms 10
   tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _d5, d5_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _e4, e4_
  delayms 200
  mute
  delayms 10
   tone _e4, e4_
  delayms 200
  mute
  delayms 10
   tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _d4, d4_
  delayms 200
  mute
  delayms 10
  tone _d4, d4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
   tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
   tone _a4, a4_
  delayms 200
  mute
  delayms 10
   tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _e4, e4_
  delayms 200
  mute
  delayms 10
   tone _e4, e4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _c5, c5_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _b4, b4_
  delayms 200
  mute
  delayms 10
  tone _f4, f4_
  delayms 200
  mute
  delayms 10
  tone _f4, f4_
  delayms 200
  mute
  delayms 10
  tone _c4, c4_
  delayms 200
  mute
  delayms 10
  tone _c4, c4_
  delayms 200
  mute
  delayms 10
  tone _f4, f4_
  delayms 200
  mute
  delayms 10
  tone _f4, f4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _g4, g4_
  delayms 200
  mute
  delayms 10
  tone _f4, f4_
  delayms 200
  mute
  delayms 10
  tone _f4, f4_
  delayms 200
  mute
  delayms 10
  tone _a4, a4_
  delayms 200
  mute
  delayms 10
  tone _f4, f4_
  delayms 200
  mute
  delayms 10
  tone _f4, f4_
  delayms 500
  mute
  delayms 200
  tone _a5, a5_
  delayms 200
  mute
  delayms 10
  tone _d6, d6_
  delayms 400
  mute
  delayms 10
  tone _e6, e6_
  delayms 200
  mute
  delayms 10
  tone _f6, f6_
  delayms 200
  mute
  delayms 20
  tone _g6, g6_
  delayms 400
  mute
  delayms 10
  tone _f6, f6_
  delayms 400
  mute
  delayms 10
  tone _e6, e6_
  delayms 200
  mute
  delayms 10
  tone _c6, c6_
  delayms 200
  mute
  delayms 30
  tone _c6, c6_
  delayms 400
  mute
  delayms 10
  tone _a5, a5_
  delayms 200
  mute
  delayms 10
  tone _as5, as5_
  delayms 200
  mute
  delayms 20
  tone _c6, c6_
  delayms 400
  mute
  delayms 10
  tone _c6, c6_
  delayms 400
  mute
  delayms 10
  tone _f6, f6_
  delayms 200
  mute
  delayms 10
  tone _d6, d6_
  delayms 200
  mute
  delayms 10
   tone _a5, a5_
  delayms 200
  mute
  delayms 10
  tone _d6, d6_
  delayms 400
  mute
  delayms 10
  tone _e6, e6_
  delayms 200
  mute
  delayms 10
  tone _f6, f6_
  delayms 200
  mute
  delayms 20
  tone _g6, g6_
  delayms 400
  mute
  delayms 10
  tone _f6, f6_
  delayms 400
  mute
  delayms 10
  tone _e6, e6_
  delayms 200
  mute
  delayms 10
  tone _c6, c6_
  delayms 200
  mute
  delayms 1500




  delayms 2000
  jmp main

;------------------------Delay podrutina------------------------
delay10ms:
	ldi	iLoopRl,LOW(iVal)	; inicijalizuje unutrasnji loop count
	ldi	iLoopRh,HIGH(iVal)	; loop high i low registri

iLoop:
  sbiw iLoopRl,1		; umanjuje unutrasnji loop register za 1
  brne iLoop			; grana na iLoop ako je unutrasnji Loop registers != 0

  dec oLoopR			; umanjuje spoljasnji loop register za 1
  brne delay10ms		; grana na oLoop ako je spoljasnji loop register != 0

  nop				; no operation

  ret				; povratak iz subrutine