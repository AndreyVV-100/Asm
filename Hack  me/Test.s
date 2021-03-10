	.file	"Test.c"
	.code16gcc
	.text
	.globl	MAGIC1
	.section	.rodata
	.align 4
	.type	MAGIC1, @object
	.size	MAGIC1, 4
MAGIC1:
	.long	1488
	.globl	MAGIC2
	.align 4
	.type	MAGIC2, @object
	.size	MAGIC2, 4
MAGIC2:
	.long	228
.LC0:
	.string	"%c%c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr32
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x78,0x6
	.cfi_escape 0x10,0x3,0x2,0x75,0x7c
	subl	$16, %esp
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	movl	$0, -12(%ebp)
	jmp	.L2
.L3:
	movl	stdin@GOT(%ebx), %eax
	movl	(%eax), %eax
	subl	$8, %esp
	pushl	%eax
	pushl	$0
	call	fputc@PLT
	addl	$16, %esp
	addl	$1, -12(%ebp)
.L2:
	movl	$1488, %eax
	cmpl	%eax, -12(%ebp)
	jl	.L3
	movl	$228, %edx
	movl	stdin@GOT(%ebx), %eax
	movl	(%eax), %eax
	pushl	$0
	pushl	%edx
	leal	.LC0@GOTOFF(%ebx), %edx
	pushl	%edx
	pushl	%eax
	call	fprintf@PLT
	addl	$16, %esp
	call	Start@PLT
	movl	$0, %eax
	leal	-8(%ebp), %esp
	popl	%ecx
	.cfi_restore 1
	.cfi_def_cfa 1, 0
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.text.__x86.get_pc_thunk.bx,"axG",@progbits,__x86.get_pc_thunk.bx,comdat
	.globl	__x86.get_pc_thunk.bx
	.hidden	__x86.get_pc_thunk.bx
	.type	__x86.get_pc_thunk.bx, @function
__x86.get_pc_thunk.bx:
.LFB1:
	.cfi_startproc
	movl	(%esp), %ebx
	ret
	.cfi_endproc
.LFE1:
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 4
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 4
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 4
4:
