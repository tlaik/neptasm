.686
.xmm
.model flat, stdcall

include common.inc

.code

renderwi		dd ?
renderhi		dd ?
defwi			dd 1920
defhi			dd 1080
defwf			dd 1920.0
defhf			dd 1080.0
renderwf		dd ?
renderhf		dd ?

cfg_res_scale	db "Resolution scaling: %f",0
cfg_res_width	db "Window width: %d",0
cfg_res_height	db "Window height: %d",0
cfg_fps_unlock	db "FPS Unlock: %d",0
cfg_cam_unlock	db "Camera unlock: %d",0

aspect_ratio	dd 1.77778
uiscalew		dd ?
uiscaleh		dd ?
;				Value		sscanf format			callback if value > 0
renderres		dd 1.0,		offset cfg_res_scale,	0
wndw			dd 1920,	offset cfg_res_width,	0
wndh			dd 1080,	offset cfg_res_height,	0
fps_unlock		dd 1,		offset cfg_fps_unlock,	UnlockFPS
cam_unlock		dd 1,		offset cfg_cam_unlock,	UnlockCamera

uiw				dd ?
uih				dd ?
uw_ui_margin	dd ?

cfg				dd ?
buf				dd ?

open_fail		db "Couldn't read "
cfgname			db "nep.ini",0
filemode		db "rb",0

LoadConfig proc
	push eax
	push ebx
	push edi
	
	push offset filemode
	push offset cfgname
	call fopen
	add esp, 8		; cdecl be like
	test eax, eax
	jz load_config_fail
	mov cfg, eax
	
	push 1024
	call malloc
	add esp, 4
	test eax, eax
	jz load_config_fail
	mov buf, eax
	
config_line_read_loop:
	push cfg
	push 1024
	push buf
	call fgets
	add esp, 12
	test eax, eax
	jz config_read_done
	mov edi, offset renderres
	
config_check_setting_loop:
	push edi
	push [edi+4]
	push buf
	call sscanf
	add esp, 12
	test eax, eax
	jnz config_check_callback
	cmp edi, offset cam_unlock
	je config_line_read_loop
	add edi, 12
	jmp config_check_setting_loop
	
config_check_callback:
	mov eax, [edi]
	test eax, eax
	jz config_line_read_loop
	mov eax, [edi+8]
	test eax, eax
	jz config_line_read_loop
	call eax
	jmp config_line_read_loop
	
config_read_done:
	; uiscalew & uiscaleh are used by UI scaling code in d3dctx.asm
	cvtsi2ss xmm7, wndw
	mulss xmm7, renderres
	movss renderwf, xmm7
	cvtss2si eax, xmm7
	mov renderwi, eax
	
	movss xmm6, defwf
	divss xmm7, xmm6
	movss uiscalew, xmm7
	
	cvtsi2ss xmm7, wndh
	mulss xmm7, renderres
	movss renderhf, xmm7
	cvtss2si eax, xmm7
	mov renderhi, eax
	
	movss xmm6, defhf
	divss xmm7, xmm6
	movss uiscaleh, xmm7
	
	; Calculate aspect ratio from user-supplied width & height
	movss xmm6, renderhf
	movss xmm7, renderwf
	divss xmm7, xmm6
	movss aspect_ratio, xmm7
	
	; UI scaling for ultrawide to show up at 16:9 ratio
	movss uih, xmm6
	mov eax, 1.77778
	movd xmm7, eax
	mulss xmm7, xmm6
	movss uiw, xmm7
	
	; Margins for centering UI in ultrawide ratios
	movss xmm6, uiw
	movss xmm7, renderwf
	subss xmm7, xmm6
	mov eax, 2.0
	movd xmm6, eax
	divss xmm7, xmm6
	movss uw_ui_margin, xmm7
	
	; Change movss in Nep exe to use our calculated aspect ratio
	mov eax, nepbase
	add eax, 1081E1h
	mov byte ptr [eax], 05h
	inc eax
	mov [eax], offset aspect_ratio
	
	; Aspect ratio used by world map
	mov eax, nepbase
	add eax, 5BDC94h
	mov ebx, aspect_ratio
	mov [eax], ebx
	jmp config_parse_done
	
config_parse_done:
	push buf
	call free
	add esp, 4
	
	pop edi
	pop ebx
	pop eax
	ret
load_config_fail:
	push offset open_fail
	call NepFail
LoadConfig endp

end