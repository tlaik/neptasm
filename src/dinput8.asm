.386
.model flat, stdcall

include common.inc

.code

DirectInput8Create proc hinst:dword, ver:dword, riid:dword, ppvOut:dword, punkOuter:dword
	mov edi,edi				; dinput8.dll has hotpatch support & requires 2 extra code bytes at the beginning
	
	; call real DirectInput8Create 
	push [ebp+18h]
	push [ebp+14h]
	push [ebp+10h]
	push [ebp+0Ch]
	push [ebp+08h]
	call d8crt
	
	ret 20
DirectInput8Create endp

end