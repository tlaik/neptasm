.386
.model flat, stdcall

include common.inc

.code

exitproc_name	db "ExitProcess",0
vprot_name		db "VirtualProtect",0
malloc_name		db "malloc",0
free_name		db "free",0
sscanf_name		db "sscanf",0
fgets_name		db "fgets",0
fopen_name		db "fopen",0
msgbox_name		db "MessageBoxA",0
d8crt_name		db "DirectInput8Create",0

exitproc		dd offset exitproc_name
vprot			dd offset vprot_name
malloc			dd offset malloc_name
free			dd offset free_name
sscanf			dd offset sscanf_name
fgets			dd offset fgets_name
fopen			dd offset fopen_name
msgbox			dd offset msgbox_name
d8crt			dd ?

GetProcs proc
	push offset vprot
	push offset exitproc
	push kernel32
	call GetProcsFromModule
	
	push offset fopen
	push offset malloc
	push crt
	call GetProcsFromModule
	
	push offset msgbox
	push offset msgbox
	push user32
	call GetProcsFromModule
	
	push offset d8crt_name
	push dinput8
	call getproc
	mov d8crt, eax
	
	ret
GetProcs endp

end