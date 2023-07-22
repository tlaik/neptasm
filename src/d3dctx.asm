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
	; Caused certain menu backgrounds not to scale in ultrawide?
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

game_state			dd 0
rssv_call_id		db 0
RSSetViewports proc
	push eax
	push ebx
	mov eax, [esp+8]
	call IsNepCall
	test eax, eax
	jz rssetrt_normal_call
	
	push ecx
	call GetGameState
	mov game_state, ecx
	pop ecx
	
	mov eax, [esp+16]	; UINT NumViewports
	cmp eax, 1
	jne rssetrt_normal_call
	mov eax, [esp+20]	; const D3D11_VIEWPORT *pViewports
	
	mov bl, scale_viewport
	test bl, bl
	jnz rssetrt_scale
	inc bl
	mov scale_viewport, bl
	jmp rssetrt_normal_call
	
rssetrt_scale:
	mov ebx, [eax+8]	; Width
	cmp ebx, defwf
	jne rssetrt_check_gui_map
	mov ebx, [eax+12]	; Height
	cmp ebx, defhf
	jne rssetrt_check_gui_map
	
	inc rssv_call_id
	; Some commented code for underdeveloped ultrawide UI support follows.
	; Ultrawide problems are:
	; Different shaders and render viewports are used during general gameplay, combat, transition to game menu,
	; various menus inside and some other states. Some need their size fixed to 16:9, others must be stretched to the real aspect ratio.
	; Their order needs to be determined for every little case.
	; Menu backgrounds are even harder to fix for ultrawide due to several renders from different game states being
	; merged together for the blur effect.
	; Fixing them properly would take figuring out how to detect all those possible states and which renders
	; should or shouldn't be scaled in each. Lots and lots of time I'm not willing to spend. I'm tired, boss.
	
	; In-dungeon UI renders 3 to 8 need to be stretched to the entire screen -
	; shaders that handle them expect 16:9 ratio and create weird ass hall of mirror effects
	; in the menu mode when we're trying to keep UI at 16:9 in ultrawide.
	; cba to search, debug and fix the shaders responsible for this crap.
	;cmp game_state, 1		; Game
	;je rssetrt_ui_game_world_fix
	;cmp game_state, 2		; Game menu
	;je rssetrt_ui_menu_fix
	;cmp game_state, 3		; World
	;je rssetrt_ui_game_world_fix
	;cmp game_state, 4		; World menu
	;je rssetrt_ui_menu_fix
	;cmp game_state, 5		; Game to menu transition
	;je rssetrt_ui_game_to_menu_fix
	cmp game_state, 6		; Start video
	je rssetrt_start_menu_fix
	jmp rssetrt_render_cont
	
;rssetrt_ui_game_world_fix:
	; Fixes the in-dungeon UI to be in 16:9 ratio, but breaks it during combat and victory screen -
	; once again, due to different number & purpose of render viewports
	;cmp rssv_call_id, 9
	;jge rssetrt_ui_fix_end
	;jmp rssetrt_render_cont

;rssetrt_ui_game_to_menu_fix:
	;jmp rssetrt_render_cont

;rssetrt_ui_menu_fix:
	; Fixes ultrawide mode menu to be rendered in 16:9, but mouse inputs still act as if it's stretched all the way
	;cmp rssv_call_id, 5
	;jle rssetrt_ui_fix_end
	;cmp rssv_call_id, 14
	;jge rssetrt_ui_fix_end
	;jmp rssetrt_render_cont

rssetrt_start_menu_fix:
	; Avoids squashing the intro Nep animation
	cmp rssv_call_id, 3
	je rssetrt_render_cont
	cmp rssv_call_id, 4
	je rssetrt_render_cont
	mov ebx, uw_ui_margin
	mov [eax], ebx
	mov ebx, uiw
	mov [eax+8], ebx
	mov ebx, uih
	mov [eax+12], ebx
	jmp rssetrt_normal_call
	
rssetrt_render_cont:
	mov ebx, renderwf
	mov [eax+8], ebx
	mov ebx, renderhf
	mov [eax+12], ebx
	jmp rssetrt_normal_call
	
;rssetrt_ui_fix_end:
	;mov ebx, uiw
	;mov [eax+8], ebx
	;mov ebx, uih
	;mov [eax+12], ebx
	
rssetrt_check_gui_map:
	mov ebx, [eax]			; TopLeftX
	test ebx, ebx
	jz rssetrt_check_gui_map_y
	cmp ebx, 80000001h		; Negative floats go from 0x80000000 upwards
	jb rssetrt_scale_gui_map
	
rssetrt_check_gui_map_y:
	mov ebx, [eax+4]		; TopLeftY
	test ebx, ebx
	jz rssetrt_normal_call
	cmp ebx, 80000001h
	jae rssetrt_normal_call
	
rssetrt_scale_gui_map:
	; Scale X/Y pos and X/Y size
	movups xmm6, [eax]
	movlps xmm7, qword ptr uiscalew
	pshufd xmm7, xmm7, 01000100b
	; Use this for ultrawide instead of previous 2 commands
	;movd xmm7, uiscaleh
	;pshufd xmm7, xmm7, 0
	mulps xmm6, xmm7
	; Uncomment for ultrawide 16:9 UI scaling
	;addss xmm6, uw_ui_margin
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