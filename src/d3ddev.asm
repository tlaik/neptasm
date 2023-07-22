.686
.xmm
.model flat, stdcall

include common.inc
include d3d.inc

.code

option prologue:none
option epilogue:none

; Reference: MegaresolutionNeptunia/d3d11device_wrapper.cpp
CreateTexture2D proc
	push eax
	push ebx
	mov eax, [esp+8]
	call IsNepCall
	test eax, eax
	jz crtt2d_normal_call
	
	mov eax, [esp+16]	; D3D11_TEXTURE2D_DESC
	mov ebx, [eax]		; Width
	cmp ebx, defwi
	jne crtt2d_normal_call
	mov ebx, [eax+4]	; Height
	cmp ebx, defhi
	jne crtt2d_normal_call
	mov ebx, [eax+16]	; Format
	cmp ebx, 28			; DXGI_FORMAT_R8G8B8A8_UNORM
	je crtt2d_format_ok
	cmp ebx, 40			; DXGI_FORMAT_D32_FLOAT
	je crtt2d_format_ok
	cmp ebx, 41			; DXGI_FORMAT_R32_FLOAT
	jne crtt2d_normal_call
	
crtt2d_format_ok:
	mov ebx, [eax+28]	; Usage
	cmp ebx, 2			; D3D11_USAGE_DYNAMIC
	je crtt2d_normal_call
	mov eax, [esp+20]	; D3D11_SUBRESOURCE_DATA *pInitialData
	test eax, eax
	jnz crtt2d_normal_call
	mov eax, [esp+16]
	mov ebx, renderwi
	mov [eax], ebx
	mov ebx, renderhi
	mov [eax+4], ebx
	
crtt2d_normal_call:
	pop ebx
	pop eax
	jmp d3ddev_crtt2d
CreateTexture2D endp

rtv_curr		dd 0
crtrtv_res_curr	dd 0
crtrtv_ret		dd 0
CreateRenderTargetView proc
	push eax
	mov eax, [esp+4]
	call IsNepCall
	test eax, eax
	jz crtrtv_normal_call
	
	mov eax, [esp+4]
	mov crtrtv_ret, eax
	mov eax, [esp+12]			; ID3D11Resource *pResource
	mov crtrtv_res_curr, eax
	mov eax, [esp+20]			; ID3D11RenderTargetView **ppRTView
	mov rtv_curr, eax
	pop eax
	mov [esp], crtrtv_postcall
	jmp d3ddev_crtrtv
	
crtrtv_postcall:
	push eax
	mov eax, crtrtv_res_curr
	cmp eax, backbuf_tex
	jne crtrtv_post_exit
	mov eax, rtv_curr
	mov eax, [eax]
	mov backbuf_rt, eax
	
crtrtv_post_exit:
	pop eax
	jmp crtrtv_ret
	
crtrtv_normal_call:
	pop eax
	jmp d3ddev_crtrtv
CreateRenderTargetView endp

end