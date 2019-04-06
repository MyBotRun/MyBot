; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot ADB dummy
; Description ...: This file contens the Sequence that runs all MBR Bot
; Author ........: cosote (04-2019)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; AutoIt pragmas
#NoTrayIcon
#RequireAdmin
#AutoIt3Wrapper_UseX64=7n
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/rsln /MI=3
;/SV=0

#AutoIt3Wrapper_Change2CUI=y
#pragma compile(Console, true)
#include "MyBot.run.version.au3"
#pragma compile(ProductName, My Bot ADB dummy)
#pragma compile(Out, MyBot.run.adb.dummy.exe) ; Required

; Enforce variable declarations
Opt("MustDeclareVars", 1)
