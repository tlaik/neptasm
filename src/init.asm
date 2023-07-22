.386
.model flat, stdcall

include common.inc

.code
assume fs:nothing

base			dd 69420000h
procheap		dd ?
peb_ldr_data	dd ?
peb_mod_list	dd ?
kernel32		dd ?
nepbase			dd ?
nepsize			dd ?
nepend			dd ?

getproc_name	db "GetProcAddress",0
loadlib_name	db "LoadLibraryExA",0

getproc			dd ?
loadlib			dd ?

neptasm			db 'N', 0, 'e', 0, 'p', 0, 't', 0, 'a', 0, 's', 0, 'm', 0

Init proc ; YV78vobCyIo
	mov eax, fs:[30h]		; ptr to PEB
	mov ebx, [eax+18h]
	mov procheap, ebx
	mov eax, [eax+0Ch]		; ptr to PEB_LDR_DATA
	mov peb_ldr_data, eax
	mov eax, [eax+0Ch]		; ptr to InLoadOrderLinks - head of double-linked list of LIST_ENTRY
	mov ebx, [eax+18h]		; First module in InLoadOrderLinks is .exe itself
	mov nepbase, ebx
	mov ebx, [eax+20h]
	mov nepsize, ebx
	add ebx, nepbase
	mov nepend, ebx
	
	mov ebx, eax
	mov ecx, base
module_loop:
	mov eax, [eax]
	cmp eax, ebx
	je module_loop_done
	cmp ecx, [eax+18h]
	je self_found
	jmp module_loop
self_found:
	xor edx, edx
	mov dx, [eax+24h]		; LDR_DATA_TABLE_ENTRY.FullDllName.Length
	sub edx, 4 * 2			; Skip ".dll"
	mov edi, [eax+28h]		; LDR_DATA_TABLE_ENTRY.FullDllName.Buffer
	add edi, edx
	mov esi, offset neptasm
	add esi, 7 * 2
nep_name_loop:				; Overwrite "DINPUT8" with "Neptasm" to use LoadLibraryExA later without full path fuckery
	sub edi, 2
	sub esi, 2
	mov ax, [esi]
	mov [edi], ax
	cmp esi, offset neptasm
	jne nep_name_loop
module_loop_done:
	
	mov eax, fs:[30h]		; ptr to PEB
	mov eax, [eax+0Ch]		; ptr to PEB_LDR_DATA
	mov eax, [eax+14h]		; ptr to InMemoryOrderModuleList - head of double-linked list of LIST_ENTRY
	mov peb_mod_list, eax
	mov eax, [eax]			; 2nd LIST_ENTRY
	mov eax, [eax]			; 3nd LIST_ENTRY
	mov eax, [eax+10h]		; get DllBase ptr in LDR_DATA_TABLE_ENTRY
	mov kernel32, eax
	mov ebx, eax			
	add ebx, [eax+3Ch]		; ptr to IMAGE_NT_HEADERS32
	mov ebx, [ebx + 78h]	; 4h + 14h + 60h: IMAGE_NT_HEADERS32.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress
	add ebx, eax
	
	xor edx, edx
compare_name:
	lea esi, getproc_name
	lea edi, [ebx+20h]		; Function names in IMAGE_EXPORT_DIRECTORY
	mov edi, [edi]
	add edi, kernel32
	add edi, edx
	add edx, 4
	mov edi, [edi]
	add edi, kernel32
compare_char:
	mov ah, [esi]
	mov al, [edi]
	cmp ah, al
	jne compare_name
	test al, al
	jz done
	add esi, 1
	add edi, 1
	jmp compare_char
done:
	sub edx, 4
	
	shr edx, 1
	mov ecx, [ebx+24h]		; Function ordinals
	add ecx, kernel32
	add ecx, edx
	xor edx, edx
	mov dx, [ecx]
	
	mov ecx, [ebx+1Ch]		; Function addresses
	add ecx, kernel32
	shl edx, 2
	add ecx, edx
	mov ecx, [ecx]
	add ecx, kernel32
	mov getproc, ecx		; Gotem
	
	push offset loadlib_name
	push kernel32
	call getproc
	mov loadlib, eax
	
	ret
Init endp

end