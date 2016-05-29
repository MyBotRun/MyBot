; #FUNCTION# ====================================================================================================================
; Name ..........: AutoStart
; Description ...:
; Syntax ........: AutoStart()
; Parameters ....:
; Return values .: None
; Author ........: Sm0kE
; Modified ......: 2015-06 sardo - parametrized $ichkAutoStartDelay, 2015-07 sardo - insert into a function
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func AutoStart()
	If $ichkAutoStart = 1 Or $restarted = 1 Then
		SetLog("Bot Auto Starting in " & $ichkAutoStartDelay & " seconds", $COLOR_RED)
		Sleep($ichkAutoStartDelay * 1000)
		btnStart()
	EndIf
EndFunc   ;==>AutoStart

