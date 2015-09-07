; #FUNCTION# ====================================================================================================================
; Name ..........: CheckHeroesHealth
; Description ...:
; Syntax ........: CheckHeroesHealth()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func CheckHeroesHealth()

	If $checkKPower Or $checkQPower Then
		Local $aKingHealthCopy = $aKingHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
		$aKingHealthCopy[0] = GetXPosOfArmySlot($King, 68)
		Local $aQueenHealthCopy = $aQueenHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
		$aQueenHealthCopy[0] = GetXPosOfArmySlot($Queen, 68)

		If $debugSetlog = 1 Then
			Setlog(" CheckHeroesHealth started ")
			Local $KingPixelColor = _GetPixelColor($aKingHealthCopy[0], $aKingHealthCopy[1], $bCapturePixel)
			Local $QueenPixelColor = _GetPixelColor($aQueenHealthCopy[0], $aQueenHealthCopy[1], $bCapturePixel)
		EndIf

		If $checkKPower Then
			If $debugSetlog = 1 Then Setlog(" King _GetPixelColor(" & $aKingHealthCopy[0] & "," & $aKingHealthCopy[1] & "): " & $KingPixelColor, $COLOR_PURPLE)
			If _CheckPixel($aKingHealthCopy, $bCapturePixel, "Red") Then

				SetLog("King is getting weak, Activating King's power", $COLOR_BLUE)
				SelectDropTroop($King)
				$checkKPower = False
			EndIf
		EndIf
		If $checkQPower Then
			If $debugSetlog = 1 Then Setlog(" Queen _GetPixelColor(" & $aQueenHealthCopy[0] & "," & $aQueenHealthCopy[1] & "): " & $QueenPixelColor, $COLOR_PURPLE)
			If _CheckPixel($aQueenHealthCopy, $bCapturePixel, "Red") Then
				SetLog("Queen is getting weak, Activating Queen's power", $COLOR_BLUE)
				SelectDropTroop($Queen)
				$checkQPower = False
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CheckHeroesHealth

