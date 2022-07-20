Init proto
NepFail proto msg:dword
GetModules proto
GetProcs proto
LoadConfig proto
D3D11Hook proto
MakeModuleWritable proto
GetProcsFromModule proto module:dword, first:dword, last:dword
HookComMethods proto first:dword, last:dword
GetNepWindow proto
IsNepCall proto
UnlockFPS proto
UnlockCamera proto
AdjustAnimSpeed proto

externdef base:dword
externdef procheap:dword
externdef peb_ldr_data:dword
externdef peb_mod_list:dword
externdef kernel32:dword
externdef nepbase:dword
externdef nepsize:dword
externdef nepend:dword
externdef nepwnd:dword

externdef user32:dword
externdef kbase:dword
externdef crt:dword
externdef dinput8:dword
externdef dxgi:dword
externdef d3d11:dword

externdef getproc:dword
externdef loadlib:dword
externdef exitproc:dword
externdef vprot:dword
externdef qpc:dword
externdef qpf:dword
externdef malloc:dword
externdef free:dword
externdef strstr:dword
externdef sscanf:dword
externdef fgets:dword
externdef fopen:dword
externdef msgbox:dword
externdef getclrect:dword
externdef findwnd:dword
externdef getwndtext:dword
externdef d8crt:dword

externdef wndw:dword
externdef wndh:dword
externdef wdefi:dword
externdef hdefi:dword
externdef wdeff:dword
externdef hdeff:dword
externdef renderwf:dword
externdef renderhf:dword
externdef render_scale:dword
externdef renderwi:dword
externdef renderhi:dword
externdef fps_unlock:dword
externdef cam_unlock:dword

externdef nepu:byte
externdef peb_fail:byte
externdef halloc_fail:byte

externdef temp:dword