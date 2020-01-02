DGROUP	GROUP	DATA1, DATA2
CODE	SEGMENT
		ASSUME	CS:CODE, DS:DGROUP, ES:DATA3, SS:STACK

START:
; --- set segment registor --- ;
		MOV		AX, DGROUP
		MOV		DS, AX
		MOV		AX, DATA3
		MOV		ES, AX
; --- init buffer for read/write --- ;
		MOV		WORD PTR IN_LEN, 0
		MOV		WORD PTR ES:OUT_LEN, 0
		MOV		ES:OUT_PTR, OFFSET ES:OUT_BUF

M_LOOP:
; --- get char --- ;
		CMP		WORD PTR IN_LEN, 0
		JE		GETC_1

		MOV		DI, IN_PTR
		MOV		AL, [DI]
		INC		WORD PTR IN_PTR
		DEC		WORD PTR IN_LEN
		CLC
		JMP		GETC_END

GETC_1:
		MOV		AH, 3FH
		MOV		BX, 0
		MOV		CX, 1000H
		MOV		DX, OFFSET DGROUP:IN_BUF
		INT		21H
		JC		GETC_END
		OR		AX, AX
		MOV		IN_LEN, AX
		MOV		AL, IN_BUF
		MOV		IN_PTR, OFFSET DGROUP:IN_BUF + 1
		CLC

GETC_END:
;--- get char end --- ;
		JNC		ESC
		JMP		FLUSH

ESC:
; --- transfer routine --- ;
		CMP		ESCFLAG, BYTE PTR 1
		JE		NORMCHK
		CMP		AL, '['
		JNE		THROUGH
; --- start reverse output --- ;
		MOV		ESCFLAG, BYTE PTR 1
		MOV		BX, OFFSET REVSTR
		MOV		CX, 4
		JMP		PUTS

NORMCHK:
; --- check reverse end --- ;
		CMP		AL, ']'
		JNE		THROUGH
; --- end reverse output --- ;
		MOV		ESCFLAG, BYTE PTR 0
		MOV		BX, OFFSET NORMSTR
		MOV		CX, 4
		JMP		PUTS

THROUGH:
; --- output through --- ;
		MOV		CHRBUF, AL
		MOV		BX, OFFSET CHRBUF
		MOV		CX, 1
; --- escape squence insetion end --- ;

; --- put char --- ;
PUTS:
		CMP		CX, 0
		JE		PUTS_END
		MOV		AL, [BX]

		CMP		AL, 'Z' - 'A' + 1
		JE		FLUSH

		INC		BX
		PUSH	BX
		PUSH	CX
; --- put char --- ;
		CMP		WORD PTR ES:OUT_LEN, 1000H
		JE		PUTC_1
		INC		WORD PTR ES:OUT_LEN
		MOV		BX, ES:OUT_PTR
		MOV		ES:[BX], AL
		INC		WORD PTR ES:OUT_PTR
		CLC
		JMP		PUTC_END

PUTC_1:
		PUSH	AX
; --- buffer flush --- ;
		PUSH	DS
		MOV		BX, ES
		MOV		DS, BX
		MOV		AH, 40H
		MOV		BX, 1
		MOV		CX, ES:OUT_LEN
		MOV		DX, OFFSET ES:OUT_BUF
		INT		21H
		POP		DS
; --- buffer flush end --- ;
		POP		BX
		JC		PUTC_END
		CMP		AX, ES:OUT_LEN
		STC
		JNE		PUTC_END
		MOV		ES:OUT_BUF, BL
		MOV		WORD PTR ES:OUT_LEN, 1
		MOV		ES:OUT_PTR, OFFSET ES:OUT_BUF + 1
		CLC

PUTC_END:
; --- put char end --- ;
		POP		CX
		POP		BX
		JC		QUIT
		LOOP	PUTS

PUTS_END:
		JMP		M_LOOP

FLUSH:
; --- remain output buffer ? --- ;
		CMP		WORD PTR ES:OUT_LEN, 0
		JE		QUIT
; --- buffer flush --- ;
		PUSH	DS
		MOV		BX, ES
		MOV		DS, BX
		MOV		AH, 40H
		MOV		BX, 1
		MOV		CX, ES:OUT_LEN
		MOV		DX, OFFSET ES:OUT_BUF
		INT		21H
		POP		DS
; --- buffer flush end --- ;

QUIT:
		MOV		AH, 4CH
		INT		21H

CODE	ENDS

DATA1	SEGMENT

CHRBUF	DB		?
ESCFLAG DB		0
REVSTR	DB		1BH, '[7m'
NORMSTR	DB		1BH, '[0m'

DATA1	ENDS

DATA2	SEGMENT

IN_LEN	DW		?
IN_PTR	DW		?
IN_BUF	DB		1000H DUP (?)

DATA2	ENDS

DATA3	SEGMENT

OUT_LEN	DW		?
OUT_PTR	DW		?
OUT_BUF	DB		1000H DUP (?)

DATA3	ENDS

STACK	SEGMENT STACK
		DB		100H DUP (?)
STACK	ENDS

		END START
