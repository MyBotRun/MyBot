; #FUNCTION# ====================================================================================================================
; Name ..........: CheckHeroesHealth
; Description ...:
; Syntax ........: CheckHeroesHealth()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter(03-2017), Fliegerfaust (11-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckHeroesHealth()

	If $g_bCheckKingPower Or $g_bCheckQueenPower Or $g_bCheckWardenPower Then
		ForceCaptureRegion() ; ensure no screenshot caching kicks in

		Local $aDisplayTime[$eHeroCount] = [0, 0, 0] ; array to hold converted timerdiff into seconds

		; Slot11+
		Local $TempKingSlot = $g_iKingSlot
		Local $TempQueenSlot = $g_iQueenSlot
		Local $TempWardenSlot = $g_iWardenSlot
		If $g_iKingSlot >= 11 Or $g_iQueenSlot >= 11 Or $g_iWardenSlot >= 11 Then
			If $g_bDraggedAttackBar = False Then DragAttackBar($g_iTotalAttackSlot, False) ; drag forward
		ElseIf $g_iKingSlot >= 0 And $g_iQueenSlot >= 0 And $g_iWardenSlot >= 0 And ($g_iKingSlot < $g_iTotalAttackSlot - 10 Or $g_iQueenSlot < $g_iTotalAttackSlot - 10 Or $g_iWardenSlot < $g_iTotalAttackSlot - 10) Then
			If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True) ; return drag
		EndIf
		If $g_bDraggedAttackBar Then
			$TempKingSlot -= $g_iTotalAttackSlot - 10
			$TempQueenSlot -= $g_iTotalAttackSlot - 10
			$TempWardenSlot -= $g_iTotalAttackSlot - 10
		EndIf

		If $g_bDebugSetlog Then
			SetDebugLog("CheckHeroesHealth() for Queen started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateQueen = 0 Or $g_iActivateQueen = 2 Then
			If $g_bCheckQueenPower Then
				Local $aQueenHealthCopy = $aQueenHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
				$aQueenHealthCopy[0] = GetXPosOfArmySlot($TempQueenSlot, 68) + $aQueenHealthCopy[4] ; Slot11+
				Local $QueenPixelColor = _GetPixelColor($aQueenHealthCopy[0], $aQueenHealthCopy[1], $g_bCapturePixel)
				If $g_bDebugSetlog Then SetDebugLog(" Queen _GetPixelColor(" & $aQueenHealthCopy[0] & "," & $aQueenHealthCopy[1] & "): " & $QueenPixelColor, $COLOR_DEBUG)
				If Not _CheckPixel2($aQueenHealthCopy, $QueenPixelColor, "Red+Blue") Then
					SetLog("Queen is getting weak, Activating Queen's ability", $COLOR_INFO)
					SelectDropTroop($TempQueenSlot) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iQueenSlot
					$g_bCheckQueenPower = False
				EndIf
			EndIf
		EndIf
		If $g_iActivateQueen = 1 Or $g_iActivateQueen = 2 Then
			If $g_bCheckQueenPower Then
				If $g_aHeroesTimerActivation[$eHeroArcherQueen] <> 0 Then
					$aDisplayTime[$eHeroArcherQueen] = Ceiling(__TimerDiff($g_aHeroesTimerActivation[$eHeroArcherQueen]) / 1000) ; seconds
				EndIf
				If (Int($g_iDelayActivateQueen) / 1000) <= $aDisplayTime[$eHeroArcherQueen] Then
					SetLog("Activating Queen's ability after " & $aDisplayTime[$eHeroArcherQueen] & "'s", $COLOR_INFO)
					SelectDropTroop($TempQueenSlot) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iQueenSlot
					$g_bCheckQueenPower = False ; Reset check power flag
					$g_aHeroesTimerActivation[$eHeroArcherQueen] = 0 ; Reset Timer
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetlog Then
			SetDebugLog("CheckHeroesHealth() for King started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateKing = 0 Or $g_iActivateKing = 2 Then
			If $g_bCheckKingPower Then
				Local $aKingHealthCopy = $aKingHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
				$aKingHealthCopy[0] = GetXPosOfArmySlot($TempKingSlot, 68) + $aKingHealthCopy[4] ; Slot11+
				Local $KingPixelColor = _GetPixelColor($aKingHealthCopy[0], $aKingHealthCopy[1], $g_bCapturePixel)
				If $g_bDebugSetlog Then SetDebugLog(" King _GetPixelColor(" & $aKingHealthCopy[0] & "," & $aKingHealthCopy[1] & "): " & $KingPixelColor, $COLOR_DEBUG)
				If Not _CheckPixel2($aKingHealthCopy, $KingPixelColor, "Red+Blue") Then
					SetLog("King is getting weak, Activating King's ability", $COLOR_INFO)
					SelectDropTroop($TempKingSlot) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iKingSlot
					$g_bCheckKingPower = False
				EndIf
			EndIf
		EndIf
		If $g_iActivateKing = 1 Or $g_iActivateKing = 2 Then
			If $g_bCheckKingPower Then
				If $g_aHeroesTimerActivation[$eHeroBarbarianKing] <> 0 Then
					$aDisplayTime[$eHeroBarbarianKing] = Ceiling(__TimerDiff($g_aHeroesTimerActivation[$eHeroBarbarianKing]) / 1000) ; seconds
				EndIf
				If (Int($g_iDelayActivateKing) / 1000) <= $aDisplayTime[$eHeroBarbarianKing] Then
					SetLog("Activating King's ability after " & $aDisplayTime[$eHeroBarbarianKing] & "'s", $COLOR_INFO)
					SelectDropTroop($TempKingSlot) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iKingSlot
					$g_bCheckKingPower = False ; Reset check power flag
					$g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0 ; Reset Timer
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetlog Then
			SetDebugLog("CheckHeroesHealth() for Warden started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateWarden = 0 Or $g_iActivateWarden = 2 Then
			If $g_bCheckWardenPower Then
				Local $aWardenHealthCopy = $aWardenHealth
				$aWardenHealthCopy[0] = GetXPosOfArmySlot($TempWardenSlot, 68) + $aWardenHealthCopy[4] ; Slot11+
				Local $WardenPixelColor = _GetPixelColor($aWardenHealthCopy[0], $aWardenHealthCopy[1], $g_bCapturePixel)
				If $g_bDebugSetlog Then SetDebugLog(" Grand Warden _GetPixelColor(" & $aWardenHealthCopy[0] & "," & $aWardenHealthCopy[1] & "): " & $WardenPixelColor, $COLOR_DEBUG)
				If Not _CheckPixel2($aWardenHealthCopy, $WardenPixelColor, "Red+Blue") Then
					SetLog("Grand Warden is getting weak, Activating Warden's ability", $COLOR_INFO)
					SelectDropTroop($TempWardenSlot) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iWardenSlot
					$g_bCheckWardenPower = False
				EndIf
			EndIf
		EndIf
		If $g_iActivateWarden = 1 Or $g_iActivateWarden = 2 Then
			If $g_bCheckWardenPower Then
				If $g_aHeroesTimerActivation[$eHeroGrandWarden] <> 0 Then
					$aDisplayTime[$eHeroGrandWarden] = Ceiling(__TimerDiff($g_aHeroesTimerActivation[$eHeroGrandWarden]) / 1000) ; seconds
				EndIf
				If (Int($g_iDelayActivateWarden) / 1000) <= $aDisplayTime[$eHeroGrandWarden] Then
					SetLog("Activating Warden's ability after " & $aDisplayTime[$eHeroGrandWarden] & "'s", $COLOR_INFO)
					SelectDropTroop($TempWardenSlot) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iWardenSlot
					$g_bCheckWardenPower = False ; Reset check power flag
					$g_aHeroesTimerActivation[$eHeroGrandWarden] = 0 ; Reset Timer
				EndIf
			EndIf
		EndIf

		If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
	EndIf
EndFunc   ;==>CheckHeroesHealth

