	global progProdASM
	section .text

progProdASM:
	XORPD	XMM0,XMM0
	XORPD	XMM1,XMM1
	XORPD	XMM2,XMM2
	CMP	    RDX,	0
	JE	    done
next:
	MOVSS	XMM0,	[RDI]
	MOVSS	XMM1,	[RSI]
	MULSS	XMM0,	XMM1
	ADDSS	XMM2,	XMM0
	ADD	    RDI,	4
	ADD	    RSI,	4
	SUB	    RDX,	1
	JNZ	    next	
done:
	MOVSS	XMM0,	XMM2
	ret