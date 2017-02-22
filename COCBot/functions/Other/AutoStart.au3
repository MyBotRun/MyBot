; #FUNCTION# ====================================================================================================================
; Name ..........: AutoStart
; Description ...:
; Syntax ........: AutoStart()
; Parameters ....:
; Return values .: None
; Author ........: Sm0kE
; Modified ......: 2015-06 sardo - parametrized $ichkAutoStartDelay, 2015-07 sardo - insert into a function,
;				   Codeslinger69 (2017) - force log flush
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func AutoStart()
	If $ichkAutoStart = 1 Or $g_bRestarted = True Then
		Local $iDelay = $ichkAutoStartDelay
		If $g_bRestarted = True Then $iDelay = 0
		SetLog("Bot Auto Starting in " & $iDelay & " seconds", $COLOR_ERROR)
		FlushGuiLog($g_hTxtLog, $aTxtLogInitText, True)
		Sleep($iDelay * 1000)
		btnStart()
	EndIf
EndFunc   ;==>AutoStart

