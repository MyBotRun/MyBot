; #FUNCTION# ====================================================================================================================
; Name ..........: CheckHeroesHealth
; Description ...:
; Syntax ........: CheckHeroesHealth()
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
Func CheckHeroesHealth()

	If $checkKPower Or $checkQPower or $checkWPower Then
		ForceCaptureRegion() ; ensure no screenshot caching kicks in

		Local $aKingHealthCopy = $aKingHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
		$aKingHealthCopy[0] = GetXPosOfArmySlot($King, 68) + 2
		Local $aQueenHealthCopy = $aQueenHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
		$aQueenHealthCopy[0] = GetXPosOfArmySlot($Queen, 68) + 3
		Local $aWardenHealthCopy = $aWardenHealth
		$aWardenHealthCopy[0] = GetXPosOfArmySlot($Warden, 68)
		If _Sleep($iDelayRespond) Then Return  ; improve pause button response

		If $debugSetlog = 1 Then
			Setlog(" CheckHeroesHealth started ")
			Local $KingPixelColor = _GetPixelColor($aKingHealthCopy[0], $aKingHealthCopy[1], $bCapturePixel)
			Local $QueenPixelColor = _GetPixelColor($aQueenHealthCopy[0], $aQueenHealthCopy[1], $bCapturePixel)
			Local $WardenPixelColor = _GetPixelColor($aWardenHealthCopy[0], $aWardenHealthCopy[1], $bCapturePixel)
		EndIf

		If $checkKPower Then
			If $debugSetlog = 1 Then Setlog(" King _GetPixelColor(" & $aKingHealthCopy[0] & "," & $aKingHealthCopy[1] & "): " & $KingPixelColor, $COLOR_DEBUG)
			If _CheckPixel($aKingHealthCopy, $bCapturePixel, "Red") Then
				SetLog("King is getting weak, Activating King's power", $COLOR_INFO)
				SelectDropTroop($King)
				$checkKPower = False
			EndIf
		EndIf
		If $checkQPower Then
			If $debugSetlog = 1 Then Setlog(" Queen _GetPixelColor(" & $aQueenHealthCopy[0] & "," & $aQueenHealthCopy[1] & "): " & $QueenPixelColor, $COLOR_DEBUG)
			If _CheckPixel($aQueenHealthCopy, $bCapturePixel, "Red") Then
				SetLog("Queen is getting weak, Activating Queen's power", $COLOR_INFO)
				SelectDropTroop($Queen)
				$checkQPower = False
			EndIf
		EndIf
		If $checkWPower Then
			If $debugSetlog = 1 Then Setlog(" Grand Warden _GetPixelColor(" & $aWardenHealthCopy[0] & "," & $aWardenHealthCopy[1] & "): " & $WardenPixelColor, $COLOR_DEBUG)
			If _CheckPixel($aWardenHealthCopy, $bCapturePixel, "Red") Then
				SetLog("Grand Warden is getting weak, Activating Warden's power", $COLOR_INFO)
				SelectDropTroop($Warden)
				$checkWPower = False
			EndIf
		EndIf
		If _Sleep($iDelayRespond) Then Return ; improve pause button response
	EndIf
EndFunc   ;==>CheckHeroesHealth

