.386
.model flat, stdcall

include common.inc
include d3d.inc

.code

InitWndControl proc
	; Overwrite available window sizes with config values (10 combinations)
	mov edi, nepbase
	add edi, 6F04C8h
	xor ecx, ecx
	
wnd_size_loop:
	inc ecx
	mov eax, wndw
	mov [edi], eax
	mov eax, wndh
	mov [edi+4], eax
	add edi, 8
	cmp ecx, 10
	jl wnd_size_loop
	ret
	
InitWndControl endp

end