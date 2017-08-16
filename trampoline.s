#include "runtime_amd64.h"
#include "textflag.h"

#ifdef GOOS_windows
#define RARG0 CX
#define RARG1 DX
#define RARG2 R8
#define RARG3 R9
#else
#define RARG0 DI
#define RARG1 SI
#define RARG2 DX
#define RARG3 CX
#endif
	
// func trampoline(fn *byte, arg0, arg1, arg2, arg3 uintptr)
// Switches SP to g0 stack and calls fn.
TEXT ·trampoline(SB), NOSPLIT, $0-0
	MOVQ fn+0(FP), AX
	MOVQ arg0+8(FP), RARG0
	MOVQ arg1+16(FP), RARG1
	MOVQ arg2+24(FP), RARG2
	MOVQ arg3+32(FP), RARG3
	// Switch stack to g0.
	MOVQ (TLS), R14                   // Load g
	MOVQ g_m(R14), R13                // Load g.m
	MOVQ SP, R12                      // Save SP in a callee-saved registry
	MOVQ m_g0(R13), R10               // Load m.go
	MOVQ (g_sched+gobuf_sp)(R10), SP  // Load g0.sched.sp
	ANDQ $~15, SP                     // Align the stack to 16-bytes
	CALL AX
	MOVQ R12, SP                      // Restore SP
	RET
