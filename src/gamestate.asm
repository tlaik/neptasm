.686
.xmm
.model flat, stdcall

include common.inc

.code

;ofs_1	dd	47C90E8h	; 3CA3D70A (0.02) = World, 3DCCCCCD (0.1) = World Menu & Game Menu, 3D591687 (0.053) = Game
;ofs_2	dd	47C90D4h	; 3E99999A (0.3) = World & World Menu, 0.135 (3E0A3D71) = Game, 0.25 (3E800000) = Start video

; state			id	eax				ebx
;game			dd	1,	3D591687h,	3E0A3D71h
;game_menu		dd	2,	3DCCCCCDh,	3E0A3D71h
;world			dd	3,	3CA3D70Ah,	3E99999Ah
;world_menu		dd	4,	3DCCCCCDh,	3E99999Ah
;game_to_menu	dd	5,	3CA3D70Ah,	3E0A3D71h
; States above are useful if you'll try to get ultrawide UI working.
; Also, more states will be needed (UI breaks in combat & victory screens).
start_menu		dd	6,	3CA3D70Ah,	3E800000h

GetGameState proc
	push eax
	push ebx
	push esi
	
	mov esi, nepbase
	mov eax, [esi + 47C90E8h]
	mov ebx, [esi + 47C90D4h]
	
	;mov esi, offset game - 12
	mov esi, offset start_menu - 12
	
state_loop:
	add esi, 12
	cmp esi, offset start_menu + 12
	je default_state
	
	cmp eax, [esi+4]
	jne state_loop
	cmp ebx, [esi+8]
	jne state_loop
	mov ecx, [esi]
	jmp got_state
	
default_state:
	xor ecx, ecx
	
got_state:
	pop esi
	pop ebx
	pop eax

	ret
GetGameState endp

end