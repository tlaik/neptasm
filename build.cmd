@echo off
:: UASM: https://www.terraspace.co.uk/uasm.html
:: MASM32: http://www.masm32.com
cd src
C:\uasm32\uasm32.exe -Sp1 -Zp1 -zlf -zlp -zls -coff main.asm dinput8.asm util.asm cfg.asm gamestate.asm init.asm getmod.asm getproc.asm fps.asm camera.asm d3d.asm d3dsc.asm d3ddev.asm d3dctx.asm wnd.asm
C:\masm32\bin\polink.exe /SUBSYSTEM:WINDOWS /MACHINE:X86 /ALIGN:16 /MERGE:.rdata=.text /DLL /FIXED /BASE:0x69420000 /DEF:Neptasm.def /OUT:dinput8.dll *.obj
del *.obj *.exp *.lib
move /y dinput8.dll ..\build\
pause