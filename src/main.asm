.386
.model flat, stdcall

include common.inc

.code

nepwnd		dd 0
nepu		db "Nepu!",0
peb_fail	db "PEB lookup fail",0
;neplog		dd 0
;log_name	db "nep.log",0
;log_mode	db "w",0

NepMain proc inst:dword, reason:dword, unused:dword
	mov eax, reason
	cmp eax, 1			; DLL_PROCESS_ATTACH
	jne main_skip
	
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	call Init
	call GetModules
	call GetProcs
	
	mov eax, nepbase
	call MakeModuleWritable
	
	;push offset log_mode
	;push offset log_name
	;call fopen
	;add esp, 8
	;mov neplog, eax
	
	call D3D11Hook
	call LoadConfig
	call InitWndControl
	
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	
main_skip:
	mov eax, 1
main_ret:
	ret 12
NepMain endp

NepFail proc msg:dword
	push 10h
	push offset nepu
	push msg
	push 0
	call msgbox
	
	push 1
	call exitproc
	
	ret
NepFail endp

end NepMain