; #FUNCTION# ====================================================================================================================
; Name ..........: FindPos
; Description ...:
; Syntax ........: FindPos()
; Parameters ....:
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func FindPos()
	getBSPos()
	Local $Pos[2]
	While 1
		If _IsPressed("01") Then
			$Pos[0] = MouseGetPos()[0] - $BSpos[0]
			$Pos[1] = MouseGetPos()[1] - $BSpos[1]
			Return $Pos
		EndIf
	WEnd
EndFunc   ;==>FindPos
