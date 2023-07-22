.686
.xmm
.model flat, stdcall

include common.inc
include d3d.inc

.code

option prologue:none
option epilogue:none

; Reference: MegaresolutionNeptunia/idxgiswapchain_wrapper.cpp
Present proc
	push eax
	; Bypass calls that aren't coming from Nep exe - such as Steam overlay calls
	mov eax, [esp+4]
	call IsNepCall
	test eax, eax
	jz present_normal_call
	
	mov eax, [esp+4]
	mov present_ret, eax
	mov just_presented, 1
	mov rssv_call_id, 0
	
present_normal_call:
	pop eax
	jmp sc_present
Present endp

backbuf_tex_curr	dd 0
getbuf_ret			dd 0
GetBuffer proc
	push eax
	mov eax, [esp+4]
	call IsNepCall
	test eax, eax
	jz getbuffer_normal_call
	
	mov eax, [esp+12]			; UINT Buffer
	test eax, eax
	jnz getbuffer_normal_call
	mov eax, [esp+20]			; void **ppSurface
	mov backbuf_tex_curr, eax
	mov eax, [esp+4]
	mov getbuf_ret, eax
	pop eax
	mov [esp], getbuffer_postcall
	jmp sc_getbuffer
	
getbuffer_postcall:
	push eax
	mov eax, backbuf_tex_curr	; ptr to ID3D11Texture2D*
	mov eax, [eax]				; ID3D11Texture2D*
	mov backbuf_tex, eax
	pop eax
	jmp getbuf_ret
	
getbuffer_normal_call:
	pop eax
	jmp sc_getbuffer
GetBuffer endp

end