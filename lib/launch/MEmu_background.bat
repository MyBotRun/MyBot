@echo off
cd /d "%~dp0"
Setlocal EnableDelayedExpansion

set instance="%1"
set vboxmanage="D:\ProgramData\Microvirt\MEmuHyperv\MEmuManage.exe"
set vboxxml="D:\ProgramData\Microvirt\MEmu\MemuHyperv VMs\%1\%1.memu"
set emulator="D:\ProgramData\Microvirt\MEmu\MEmu.exe"
set i=2
if "!i!" equ "1" set emulator_processprio=/BELOWNORMAL
if "!i!" equ "2" set emulator_processprio=/NORMAL
if "!i!" equ "3" set emulator_processprio=/ABOVENORMAL
set registervm=1

set "log=%~dpn0 (%1).log"
echo [%date% %time%] %~f0 %*>!log!
echo [%date% %time%] emulator=!emulator!>>!log!
echo [%date% %time%] instance=!instance!>>!log!
echo [%date% %time%] vboxmanage=!vboxmanage!>>!log!
echo [%date% %time%] vboxxml=!vboxxml!>>!log!
echo [%date% %time%] List of available instances:>>!log!
!vboxmanage! list vms 1>>!log! 2>&1
echo [%date% %time%] Poweroff !instance!:>>!log!
!vboxmanage! controlvm !instance! poweroff 1>>!log! 2>&1
if "!registervm!" equ "1" (
	echo [%date% %time%] Unregistervm !instance!>>!log!
	!vboxmanage! unregistervm !instance! 1>>!log! 2>&1
	echo [%date% %time%] Registervm !instance!>>!log!
	!vboxmanage! registervm !vboxxml! 1>>!log! 2>&1
	echo [%date% %time%] List of available instances:>>!log!
	!vboxmanage! list vms 1>>!log! 2>&1
)
echo [%date% %time%] Starting !instance!... 1>>!log! 2>&1
start !instance! /WAIT !emulator_processprio! !emulator! !instance!
echo [%date% %time%] Poweroff !instance!:>>!log!
!vboxmanage! controlvm !instance! poweroff 1>>!log! 2>&1
if "!registervm!" equ "1" (
	echo [%date% %time%] Unregistervm !instance!>>!log!
	!vboxmanage! unregistervm !instance! 1>>!log! 2>&1
	echo [%date% %time%] List of available instances:>>!log!
	!vboxmanage! list vms 1>>!log! 2>&1
)