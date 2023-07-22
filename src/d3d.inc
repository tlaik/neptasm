Present proto
GetBuffer proto
CreateTexture2D proto
CreateRenderTargetView proto
OMSetRenderTargets proto
RSSetViewports proto
ClearRenderTargetView proto
ClearDepthStencilView proto

externdef backbuf_tex:dword
externdef backbuf_rt:dword

externdef scale_viewport:byte
externdef just_presented:byte
externdef clearing_bkbuf:byte
externdef clearing_dsv:byte

externdef sc_present:dword
externdef present_ret:dword
externdef sc_getbuffer:dword

externdef d3ddev_crtt2d:dword
externdef d3ddev_crtrtv:dword

externdef d3dctx_omsetrt:dword
externdef d3dctx_rssetrt:dword
externdef d3dctx_clrrtv:dword

;externdef _1080_calls:dword
externdef rssv_call_id:byte