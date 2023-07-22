Init proto
NepFail proto msg:dword
GetModules proto
GetProcs proto
LoadConfig proto
GetGameState proto
D3D11Hook proto
MakeModuleWritable proto
GetProcsFromModule proto module:dword, first:dword, last:dword
HookComMethods proto first:dword, last:dword
IsNepCall proto
UnlockFPS proto
UnlockCamera proto
AdjustAnimSpeed proto
InitWndControl proto

externdef base:dword
externdef procheap:dword
externdef peb_ldr_data:dword
externdef peb_mod_list:dword
externdef kernel32:dword
externdef nepbase:dword
externdef nepsize:dword
externdef nepend:dword
externdef nepwnd:dword
;externdef neplog:dword

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
externdef malloc:dword
externdef free:dword
externdef sscanf:dword
externdef fgets:dword
externdef fopen:dword
externdef msgbox:dword
externdef d8crt:dword

externdef renderwi:dword
externdef renderhi:dword
externdef defwi:dword
externdef defhi:dword
externdef defwf:dword
externdef defhf:dword
externdef renderwf:dword
externdef renderhf:dword
externdef uiscalew:dword
externdef uiscaleh:dword
externdef renderres:dword
externdef wndw:dword
externdef wndh:dword
externdef fps_unlock:dword
externdef cam_unlock:dword
externdef uiw:dword
externdef uih:dword
externdef uw_ui_margin:dword

externdef nepu:byte
externdef peb_fail:byte
externdef halloc_fail:byte

externdef temp:dword