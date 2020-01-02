CODE	SEGMENT
		ASSUME	CS:CODE, DS:CODE, ES:CODE

		ORG 100H
START:
M_LOOP:
; -- get char -- ;
		MOV		AH, 8
		INT		21H
; -- get char end -- ;

ESC:
; -- transfer routine -- ;
		CMP		ESCFLAG, BYTE PTR 1
		JE		NORMCHK
		CMP		AL, '['
		JNE		THROUGH

; -- start reverse output -- ;
		MOV		ESCFLAG, BYTE PTR 1
		MOV		BX, OFFSET REVSTR
		MOV		CX, 4
		JMP		PUTS

NORMCHK:
; -- check reverse end ? -- ;
		CMP		AL, ']'
		JNE		THROUGH
; -- end reverse output -- ;
		MOV		ESCFLAG, BYTE PTR 0
		MOV		BX, OFFSET NORMSTR
		MOV		CX, 4
		JMP		PUTS

THROUGH:
; -- output through -- ;
		MOV		CHRBUF, AL
		MOV		BX, OFFSET CHRBUF
		MOV		CX, 1
; -- escape sequence insertion end -- ;

; -- put char -- ;
PUTS:
		MOV		DL, [BX]
		INC		BX
		MOV		AH, 2
		INT		21H
		LOOP	PUTS

		CMP		DL, 'Z' - 'A' + 1
		JNE		M_LOOP

; -- end of program -- ;
		MOV		AH, 4CH
		MOV		AL, 0
		INT		21H

; -- DB define -- ;

CHRBUF	DB		?
ESCFLAG	DB		0
REVSTR	DB		1BH, '[7m'
NORMSTR	DB		1BH, '[0m'

CODE	ENDS

		END		START
