.386
.model flat, stdcall

include common.inc
include d3d.inc

.code

base_framerate	dd	60.0
base_frametime	dd	16.66666667
ms_in_s			dd	1000.0
qpc_freq		dq	1
time			dq	1
last_frame		dq	1
const_fps		dd	1E1C08h,1E1D18h,22E753h,4201F2h,42020Eh,3B20A8h,235E32h,235E5Bh,
					3C900Dh,316BF0h,3A3F58h,30020Dh,3A4178h,3A5368h,41104Dh,301BCCh,
					3E991Dh,3C04BDh

UnlockFPS proc
	push edi
	; Set engine frame delay to 0
	mov edi, nepbase
	add edi, 36FF17h
	mov eax, 9090006Ah		; push 0 & 2 nop's
	mov [edi], eax
	
	; Jump over slow & unnecessary audio call
	mov edi, nepbase
	add edi, 46BB12h
	mov ax, 05EBh
	mov [edi], ax
	
	; Certain code (especially some UI elements) needs constant FPS value to work correctly
	mov esi, offset const_fps
set_const_fps:
	mov edi, nepbase
	add edi, [esi]
	mov [edi], offset base_framerate
	add esi, 4
	cmp esi, UnlockFPS
	jne set_const_fps
	
	push offset qpc_freq
	call qpf
	
	push offset last_frame
	call qpc
	
	pop edi
	ret
UnlockFPS endp

option prologue:none
option epilogue:none

; Called from the Present hook
AdjustAnimSpeed proc
	push edi
	
	push offset time
	call qpc
	
	fild time
	fild last_frame
	fsub
	fmul ms_in_s
	fild qpc_freq
	fdiv
	fld base_frametime
	fdiv
	fld base_framerate
	fmul
	
	; Variable that controls game logic speed - normally stays at 60.0
	; With unlocked FPS, needs to be adjusted on every frame to keep effective logic/physics speed constant
	; Simple formula is 60 * (60 / Actual FPS), but the code above uses actual frame time vs. expected (16.667 ms) instead.
	mov edi, nepbase
	add edi, 4F2B80h
	fstp dword ptr [edi]
	
	push offset last_frame
	call qpc
	
	pop edi
	jmp present_ret
AdjustAnimSpeed endp

end