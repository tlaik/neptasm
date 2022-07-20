.686
.xmm
.model flat, stdcall

include common.inc

.code

wndw			dd 0
wndh			dd 0
wdefi			dd 1920
hdefi			dd 1080
wdeff			dd 1920.0
hdeff			dd 1080.0
renderwf		dd 0.0
renderhf		dd 0.0

cfg_res_scale	db "Resolution scaling: %f",0
cfg_res_width	db "Render width: %d",0
cfg_res_height	db "Render height: %d",0
cfg_fps_unlock	db "FPS Unlock: %d",0
cfg_cam_unlock	db "Camera unlock: %d",0

;				Value		sscanf format			callback if value > 0
render_scale	dd 2.0,		offset cfg_res_scale,	0
renderwi		dd 1920,	offset cfg_res_width,	0
renderhi		dd 1080,	offset cfg_res_height,	0
fps_unlock		dd 1,		offset cfg_fps_unlock,	UnlockFPS
cam_unlock		dd 1,		offset cfg_cam_unlock,	UnlockCamera

cfg				dd ?
buf				dd ?

res_fail		db "Scaling, width and height are zero!",0
open_fail		db "Couldn't read "
cfgname			db "nep.ini",0
filemode		db "rb",0

LoadConfig proc
	push eax
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
	
	mov edi, offset render_scale
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
	mov eax, renderwi
	test eax, eax
	jz use_scaling
	mov eax, renderhi
	test eax, eax
	jz use_scaling
	cvtsi2ss xmm7, renderwi
	movss renderwf, xmm7
	cvtsi2ss xmm7, renderhi
	movss renderhf, xmm7
	movss xmm6, hdeff
	divss xmm7, xmm6
	movss render_scale, xmm7
	jmp config_parse_done
use_scaling:
	mov eax, render_scale
	test eax, eax
	jz wrong_res_fail
	call GetNepWindow
	cvtpi2ps xmm7, qword ptr wndw
	movss xmm6, render_scale
	pshufd xmm6, xmm6, 0
	mulps xmm7, xmm6
	movlps qword ptr renderwf, xmm7
	cvttps2dq xmm7, xmm7
	movd renderwi, xmm7
	pshufd xmm7, xmm7, 1
	movd renderhi, xmm7
config_parse_done:
	push buf
	call free
	add esp, 4
	
	pop edi
	pop eax
	ret
load_config_fail:
	push offset open_fail
	call NepFail
wrong_res_fail:
	push offset res_fail
	call NepFail
LoadConfig endp

end