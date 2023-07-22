.386
.model flat, stdcall

include common.inc

.code

user32_name		db "user32.dll",0
kbase_name		db "kernelbase.dll",0
crt_name		db "msvcrt.dll",0
dinput8_name	db "dinput8.dll",0
dxgi_name		db "dxgi.dll",0
d3d11_name		db "d3d11.dll",0

user32			dd offset user32_name
kbase			dd offset kbase_name
crt				dd offset crt_name
dinput8			dd offset dinput8_name
dxgi			dd offset dxgi_name
d3d11			dd offset d3d11_name

GetModules proc
	mov edi, offset user32
get_module:
	mov esi, [edi]
	push 0800h
	push 0
	push esi
	call loadlib
	mov [edi], eax
	add edi, 4
	cmp edi, offset d3d11
	jle get_module
	
	ret
GetModules endp

end