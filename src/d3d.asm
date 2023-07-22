.686
.xmm
.model flat, stdcall

include common.inc
include d3d.inc

.code
; Original address		offset in VTable	hook
sc_present		dd ?,	8,					Present
sc_getbuffer	dd ?,	9,					GetBuffer
				
d3ddev_crtt2d	dd ?,	5,					CreateTexture2D
d3ddev_crtrtv	dd ?,	9,					CreateRenderTargetView
				
d3dctx_omsetrt	dd ?,	33,					OMSetRenderTargets
d3dctx_rssetrt	dd ?,	44,					RSSetViewports
d3dctx_clrrtv	dd ?,	50,					ClearRenderTargetView

backbuf_tex		dd 0
backbuf_rt		dd 0

scale_viewport	db 1
just_presented	db 0
clearing_bkbuf	db 0

present_ret		dd ?	; Used by AdjustAnimSpeed in fps.asm

D3D11Hook proc
	mov eax, dxgi
	call MakeModuleWritable
	mov eax, d3d11
	call MakeModuleWritable

	; Hook Nep exe's call to d3d11.dll instead of the actual function in case the latter
	; is also getting hooked by something else - like Steam overlay.
	mov eax, nepbase
	add eax, 38D430h
	mov bl, 0E9h
	mov [eax], bl
	mov ebx, D3D11CreateDeviceAndSwapChain
	sub ebx, eax
	sub ebx, 5
	inc eax
	mov [eax], ebx
	
	ret
D3D11Hook endp

option prologue:none
option epilogue:none

D3D11CreateDeviceAndSwapChain proc
	mov eax, [esp+32]		; ptr to ptr to (future) swapchain object
	mov sc_present, eax
	mov eax, [esp+36]		; d3d device
	mov d3ddev_crtt2d, eax
	mov eax, [esp+44]		; d3d device context
	mov d3dctx_omsetrt, eax
	
	; Nep exe's jump to D3D11CreateDeviceAndSwapChain
	; Nep exe has internal table of redirecting jumps between normal code and external API
	mov eax, nepbase
	add eax, 398FACh
	call eax
	
	test eax, eax
	js createsc_hook_exit
	
	push offset sc_getbuffer
	push offset sc_present
	call HookComMethods
	
	push offset d3ddev_crtrtv
	push offset d3ddev_crtt2d
	call HookComMethods
	
	push offset d3dctx_clrrtv
	push offset d3dctx_omsetrt
	call HookComMethods
	
createsc_hook_exit:
	mov eax, nepbase
	add eax, 38D47Bh
	jmp eax
D3D11CreateDeviceAndSwapChain endp

end