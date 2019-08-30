;�Q�Τ��_��99��p�ɾ� �A�ʺA���˨��ƽX��
;P0�f��J3�A�ƾںݤf
;P2.2�� J2 B�ݤl�A��ܬq�X��s
;P2.3�� J2 A�ݤl�A�лx��X��s

;LATCH1 BIT P2.2
;LATCH2 BIT P2.3
	ORG 00H
	JMP START
	ORG 0BH
	JMP TIM0
START:
	MOV R3,#00   ;���_�`������
	MOV R4,#0    ;�ɶ����
	MOV R2,#2
	MOV DPTR,#TABLE
	MOV SP,#40H
	MOV TMOD,#01H  ;�w�ɾ��u�@�覡
	MOV TH0,#HIGH(60736)
	MOV TL0,#LOW(60736)  ;���4MS
	SETB TR0
	MOV IE,#82H  ;�}���_
TIM0:
	MOV TH0,#HIGH(60736)
	MOV TL0,#LOW(60736)
	INC R3
	CJNE R3,#200,X1  ;1S
	MOV R3,#0
	MOV A,R4 ;�Q�i���ഫ
	MOV B,#10
	DIV AB
	MOV 20H,B  ; �Ӧ�
	MOV 21H,A  ; �Q��
	DEC R4
	CJNE R4,#255,LEDSCAN  ;��100�h�M�s
	MOV R4,#59
LEDSCAN:
	CJNE R4,#58,LEDSCAN2
	DEC R2
	CJNE R2, #255, LEDSCAN2
	MOV IE, #00H
	JMP BUZZER
LEDSCAN2:
	CALL KEY  ;�եμƽX�ޱ���
X1:
	PUSH ACC
	PUSH PSW
	CALL SCAN
	POP PSW
	POP ACC
	RETI
KEY:
	 MOV R0, #0			; clear R0 - the first key is key0
	 MOV A,#10
		; scan row0
	 SETB P3.3			; set row3
	 CLR P3.0			; clear row0
	 CALL colScan		; call column-scan subroutine
	 JB F0, FINISH		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)

		; scan row1
	 SETB P3.0			; set row0
	 CLR P3.1			; clear row1
	 CALL colScan		; call column-scan subroutine
	 JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)

		; scan row2
	 SETB P3.1			; set row1
	 CLR P3.2			; clear row2
	 CALL colScan		; call column-scan subroutine
	 JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)

		; scan row3
	 SETB P3.2			; set row2
	 CLR P3.3			; clear row3
	 CALL colScan		; call column-scan subroutine
	 JB F0, finish		; | if F0 is set, jump to end of program 

	 CALL SCAN
	 RET
colScan:
	JNB P3.4, gotKey	; if col0 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P3.5, gotKey	; if col1 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P3.6, gotKey	; if col2 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P3.7, gotKey
	INC R0
	RET					; return from subroutine - key not found
gotKey:
	MOV P3, #0FFH
	JMP INPUT1
	SETB F0				; key found - set F0
	RET					; and return from subroutine	
INPUT1:
	MOV A, R0
	MOV DPTR, #TABLE2
	MOVC A, @A+DPTR
	CJNE R1,#0,INPUT2
	MOV 22H,#0
	MOV 23H, A
	INC R1
	MOV DPTR,#TABLE
	JMP SCAN
INPUT2:
	MOV B,23H
	MOV 22H,B
	MOV 23H, A
	MOV R1,#0
	MOV DPTR,#TABLE
;-------�H�U�Y�j�����2, �������1, �p�����0
	MOV A, 22H
	CLR C
	SUBB A, #8
	MOV 24H,#0
	JC SCAN
	MOV 24H,#2
	CJNE A, #0, SCAN
	CLR C
;-------------------------------���Q���
	MOV A, 23H
	SUBB A,#9
	MOV 24H,#0
	JC SCAN
	MOV 24H,#2
	CJNE A, #0, SCAN
	CLR C
	MOV 24H,#1
;-------------------------------���Ӧ��
	MOV IE,#00H  ;�����_
FINISH:
	CALL SCAN
	CALL DELAY2
	JMP FINISH
DELAY2:
	MOV R7,#200
D2:
	MOV R6,#200
	DJNZ R6,$
	DJNZ R7,D2
	RET
SCAN:
	MOV A, R2
	MOVC A, @A+DPTR
	MOV P0, A
;	SETB LATCH1
;	CLR LATCH1
	SETB P2.2
	CLR P2.2
	MOV P0,#11111110B ;���ˤl�{��
;	SETB LATCH2
;	CLR LATCH2
	SETB P2.3
	CLR P2.3
	CALL DELAY1

	MOV P0, #040H
;	SETB LATCH1
;	CLR LATCH1
	SETB P2.2
	CLR P2.2
	MOV P0,#11111101B ;���ˤl�{��
;	SETB LATCH2
;	CLR LATCH2
	SETB P2.3
	CLR P2.3
	CALL DELAY1

	MOV A,21H
	MOVC A,@A+DPTR
	MOV P0,A
;	SETB LATCH1
;	CLR LATCH1
	SETB P2.2
	CLR P2.2
	MOV P0,#11111011B ;���ˤl�{��
;	SETB LATCH2
;	CLR LATCH2
	SETB P2.3
	CLR P2.3
	CALL DELAY1

	MOV A,20H
	MOVC A,@A+DPTR
	MOV P0,A
;	SETB LATCH1
;	CLR LATCH1
	SETB P2.2
	CLR P2.2
	MOV P0,#11110111B  ;0�N���q�Ӧ�ƽX��
;	SETB LATCH2
;	CLR LATCH2
	SETB P2.3
	CLR P2.3
	CALL DELAY1

	MOV A, 22H
	MOVC A, @A+DPTR
	MOV P0,A
;	SETB LATCH1
;	CLR LATCH1
	SETB P2.2
	CLR P2.2
	MOV P0,#10111111B ;���ˤl�{��
;	SETB LATCH2
;	CLR LATCH2
	SETB P2.3
	CLR P2.3
	CALL DELAY1

	MOV A, 23H
	MOVC A, @A+DPTR
	MOV P0,A
;	SETB LATCH1
;	CLR LATCH1
	SETB P2.2
	CLR P2.2
	MOV P0,#01111111B ;���ˤl�{��
;	SETB LATCH2
;	CLR LATCH2
	SETB P2.3
	CLR P2.3
	CALL DELAY1

	MOV A, 24H
	MOVC A, @A+DPTR
	MOV P0,A
;	SETB LATCH1
;	CLR LATCH1
	SETB P2.2
	CLR P2.2
	MOV P0,#11101111B ;���ˤl�{��
;	SETB LATCH2
;	CLR LATCH2
	SETB P2.3
	CLR P2.3
	CALL DELAY1
	RET
DELAY1:
	MOV R6,#4    ;���˩���
D3:
	MOV R7,#148
	DJNZ R7,$
	DJNZ R6,D3
	RET
BUZZER:
	MOV A, #0
LOOP:
	SETB P1.2
	CALL DELAY
	INC A
	CLR P1.2
	CALL DELAY
	JMP LOOP
DELAY:
	MOV R7, A
	DJNZ R7, $
	RET
TABLE2:
	DB 0FH,03H,02H,01H,0EH,06H,05H
	DB 04H,0DH,09H,08H,07H,0CH,0BH
	DB 0AH,0H
TABLE:
	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,0x77,0x7C,0x39,0x5E,0x79,0x71    ;�@���r�X��
	END
