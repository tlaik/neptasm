.386
.model flat, stdcall

include common.inc
include d3d.inc

.code

frame_time_ret	dd	?
fps_max			dd	1024.0

UnlockFPS proc
	push edi
	
	; Redirect Nep exe's code to set target frame time to 0 (instead of 16666 us)
	mov edi, nepbase
	add edi, 404B4Ch
	mov byte ptr [edi], 0E9h
	push eax
	mov eax, set_frame_time - 404B4Ch - 5
	sub eax, nepbase
	inc edi
	mov [edi], eax
	mov eax, nepbase
	add eax, 404B51h
	mov frame_time_ret, eax
	pop eax
	
	; Jump over slow & unnecessary audio call
	mov edi, nepbase
	add edi, 46BB12h
	mov ax, 05EBh
	mov [edi], ax
	
	; Certain UI code needs constant high FPS value to work correctly
	mov edi, nepbase
	add edi, 3B20A8h
	mov [edi], offset fps_max
	
	pop edi
	ret
UnlockFPS endp

set_frame_time:
	xor edi, edi
	test edi, edi
	
set_frame_time_ret:
	jmp frame_time_ret
	

end