.386
.model flat, stdcall

include common.inc

.code

cam_max		dd 270.0
cam_min		dd 90.0

UnlockCamera proc
	; Change 2 SSE instructions to use custom camera limits
	; xmm2
	mov edi, nepbase
	add edi, 2C147Bh
	mov byte ptr [edi], 15h
	inc edi
	mov [edi], offset cam_max
	
	; xmm5
	mov edi, nepbase
	add edi, 2C1486h
	mov byte ptr [edi], 2Dh
	inc edi
	mov [edi], offset cam_min
	
	ret
UnlockCamera endp

end