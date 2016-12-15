; #FUNCTION# ====================================================================================================================
; Name ..........: CloseDroid4X
; Description ...: Forces Droid4X processes to close, and watches processes and services to make sure it has stopped
; Syntax ........: CloseDroid4X()
; Parameters ....: None
; Return values .: None
; Author ........: cosote
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CloseDroid4X()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseDroid4X