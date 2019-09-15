; #FUNCTION# ====================================================================================================================
; Name ..........: BotComError
; Description ...: This function intercept com ( Component Object Model )error and write in log
; Syntax ........: BotComError()
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (aug-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $oMyError = ObjEvent("AutoIt.Error", "BotComError") ; Initialize a COM error handler

; This is my custom defined error handler
Func BotComError()

	SetError(0, 0, 0)
	If $g_bDebugSetlog Then
		SetDebugLog("We intercepted a COM Error !", $COLOR_ERROR)
		SetDebugLog("err.description is: " & $oMyError.description, $COLOR_ERROR)
		SetDebugLog("err.windescription:" & $oMyError.windescription, $COLOR_ERROR)
		SetDebugLog("err.number is: " & Hex($oMyError.number, 8), $COLOR_ERROR)
		SetDebugLog("err.lastdllerror is: " & $oMyError.lastdllerror, $COLOR_ERROR)
		SetDebugLog("err.scriptline is: " & $oMyError.scriptline, $COLOR_ERROR)
		SetDebugLog("err.source is: " & $oMyError.source, $COLOR_ERROR)
		SetDebugLog("err.helpfile is: " & $oMyError.helpfile, $COLOR_ERROR)
		SetDebugLog("err.helpcontext is: " & $oMyError.helpcontext, $COLOR_ERROR)
	EndIf
	SetError(0, 0, 0)

EndFunc   ;==>BotComError
