; #FUNCTION# ====================================================================================================================
; Name ..........: Time
; Description ...: Gives the time in '[00:00:00 AM/PM]' format
; Syntax ........: Time()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Time() ;Gives the time in '[00:00:00 AM/PM]' format
	Return "[" & _NowTime(3) & "] "
EndFunc   ;==>Time

Func TimeDebug() ;Gives the time in '[14:00:00.000]' format
	Return "[" & @YEAR & "-" & @MON & "-" & @MDAY & " " & _NowTime(5) & "." & @MSEC & "] "
EndFunc   ;==>TimeDebug
