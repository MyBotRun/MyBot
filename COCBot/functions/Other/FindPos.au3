; #FUNCTION# ====================================================================================================================
; Name ..........: FindPos
; Description ...:
; Syntax ........: FindPos()
; Parameters ....:
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func FindPos()
	getBSPos()
	AndroidToFront(Default, "FindPos") ; Activate Android Window
	Local $wasDown = AndroidShieldForceDown(True, True)
	While 1
		If _IsPressed("01") Or _IsPressed("02") Then
			Local $Pos = MouseGetPos()
			; adjust Android Control Position
			$Pos[0] -= $g_aiBSpos[0]
			$Pos[1] -= $g_aiBSpos[1]
			; adjust village offset
			ConvertFromVillagePos($Pos[0], $Pos[1])
			; wait till released
			While _IsPressed("01") Or _IsPressed("02")
				Sleep(10)
			WEnd
			AndroidShieldForceDown($wasDown, True)
			Return $Pos
		EndIf
		Sleep(10)
	WEnd
EndFunc   ;==>FindPos
