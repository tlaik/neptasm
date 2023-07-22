.386
.model flat, stdcall

include common.inc

.code

temp			dd ?

; Expects module in eax
MakeModuleWritable proc
	push ebx
	mov ebx, eax
	mov eax, peb_mod_list
module_search:
	mov ecx, [eax+10h]		; Get DllBase
	cmp ecx, ebx
	je module_found
	mov eax, [eax]
	cmp eax, peb_mod_list
	jne module_search
	push offset peb_fail
	call NepFail
	ret
module_found:
	mov eax, [eax+18h]		; Module size
	
	push offset temp
	push 40h				; PAGE_EXECUTE_READWRITE
	push eax
	push ebx
	call vprot
	
	pop ebx
	ret
MakeModuleWritable endp

GetProcsFromModule proc module:dword, first:dword, last:dword
	push edi
	mov edi, first
get_proc:
	push [edi]
	push module
	call getproc
	mov [edi], eax
	add edi, 4
	cmp edi, last
	jle get_proc
	
	pop edi
	ret 12
GetProcsFromModule endp

; Expects start & end of 2D array of [[first ptr, method ID, hook],[second ptr, method ID, hook], ...]
; first ptr should contain pointer to COM object, will be overwritten with pointer to the first method.
HookComMethods proc first:dword, last:dword
	push eax
	push ebx
	push edi
	push esi
	
	mov esi, [first]		; ptr to ptr to object
	mov esi, [esi]			; ptr to object
	mov esi, [esi]			; object
	mov esi, [esi]			; VTable
	mov edi, first
	
get_methods_loop:
	mov eax, [edi+4]		; Get original method ID in VTable
	shl eax, 2
	add eax, esi
	mov ebx, [eax]
	mov [edi], ebx			; Store ptr to original method
	mov ebx, [edi+8]
	mov [eax], ebx			; Overwrite ptr to original with hook
	mov eax, last
	cmp edi, eax
	je get_methods_done
	add edi, 12
	jmp get_methods_loop
	
get_methods_done:
	pop esi
	pop edi
	pop ebx
	pop eax
	ret
HookComMethods endp

option prologue:none
option epilogue:none

; Expects return address in eax
IsNepCall proc
	cmp eax, nepbase
	jl not_nep
	cmp eax, nepend
	jg not_nep
	mov eax, 1
	retn
	
not_nep:
	xor eax, eax
	retn
IsNepCall endp

end