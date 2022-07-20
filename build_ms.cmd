@echo off
:: Replace path to vcvars32.bat/vcvarsall.bat with your own if needed.
:: The following path assumes installed Visual Studio 2019.
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars32.bat"
cd src
ml /coff /c main.asm dinput8.asm util.asm cfg.asm init.asm getmod.asm getproc.asm fps.asm camera.asm d3d.asm d3dsc.asm d3ddev.asm d3dctx.asm
link /SUBSYSTEM:WINDOWS /MACHINE:X86 /ALIGN:16 /MERGE:.rdata=.text /FIXED /BASE:0x69420000 /DEF:Neptasm.def /OUT:dinput8.dll *.obj
del *.obj *.exp *.lib
move /y dinput8.dll ..\build\
pause