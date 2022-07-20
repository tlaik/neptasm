.686
.xmm
.model flat, stdcall

include common.inc
include d3d.inc

.code

option prologue:none
option epilogue:none

; Reference: MegaresolutionNeptunia/d3d11devicecontext_wrapper.cpp
omsetrt_rtvs_curr dd 0
OMSetRenderTargets proc
	push eax
	mov eax, [esp+4]
	call IsNepCall
	test eax, eax
	jz omsetrt_normal_call
	
	mov eax, [esp+16]			; ID3D11RenderTargetView *const *ppRenderTargetViews
	mov omsetrt_rtvs_curr, eax
	mov al, just_presented
	test al, al
	jz omsetrt_check_dont_scale
	xor al, al
	mov just_presented, al
	inc al
	mov clearing_bkbuf, al
	jmp omsetrt_normal_call
omsetrt_check_dont_scale:
	mov eax, omsetrt_rtvs_curr
	test eax, eax
	jz omsetrt_normal_call
	mov eax, [eax]
	cmp eax, backbuf_rt
	jne omsetrt_normal_call
	xor al, al
	mov scale_viewport, al
omsetrt_normal_call:
	pop eax
	jmp d3dctx_omsetrt
OMSetRenderTargets endp

RSSetViewports proc
	push eax
	push ebx
	mov eax, [esp+8]
	call IsNepCall
	test eax, eax
	jz rssetrt_normal_call
	
	mov eax, [esp+16]	; UINT NumViewports
	cmp eax, 1
	jne rssetrt_normal_call
	mov eax, [esp+20]	; const D3D11_VIEWPORT *pViewports
	mov ebx, [eax+8]	; Width
	cmp ebx, wdeff
	jne rssetrt_check_gui
	mov ebx, [eax+12]	; Height
	cmp ebx, hdeff
	jne rssetrt_check_gui
	mov bl, scale_viewport
	test bl, bl
	jz rssetrt_set_scale_viewport
	mov ebx, renderwf
	mov [eax+8], ebx
	mov ebx, renderhf
	mov [eax+12], ebx
	jmp rssetrt_normal_call
rssetrt_set_scale_viewport:
	inc bl
	mov scale_viewport, bl
	jmp rssetrt_normal_call
rssetrt_check_gui:
	mov ebx, [eax]			; TopLeftX
	test ebx, ebx
	jz rssetrt_check_gui_y
	cmp ebx, 80000000h		; Negative floats go from 0x80000000 upwards
	jb rssetrt_scale_gui
rssetrt_check_gui_y:
	mov ebx, [eax+4]		; TopLeftY
	test ebx, ebx
	jz rssetrt_normal_call
	cmp ebx, 80000000h
	jae rssetrt_normal_call
rssetrt_scale_gui:
	movups xmm6, [eax]
	movss xmm7, render_scale
	pshufd xmm7, xmm7, 0	; Copy low dword to all 4
	mulps xmm6, xmm7
	movups [eax], xmm6
rssetrt_normal_call:
	pop ebx
	pop eax
	jmp d3dctx_rssetrt
RSSetViewports endp

ClearRenderTargetView proc
	push eax
	mov eax, [esp+4]
	call IsNepCall
	test eax, eax
	jz clrrtv_normal_call
	
	mov al, clearing_bkbuf
	test al, al
	jz clrrtv_normal_call
	xor al, al
	mov clearing_bkbuf, al
	inc al
	mov scale_viewport, al
clrrtv_normal_call:
	pop eax
	jmp d3dctx_clrrtv
ClearRenderTargetView endp

end