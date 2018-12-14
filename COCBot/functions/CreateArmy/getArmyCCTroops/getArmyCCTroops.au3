; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCTroops
; Description ...: Obtain the current Troops in the Clan Castle
; Syntax ........: getArmyCCTroops()
; Parameters ....:
; Return values .:
; Author ........: Fliegerfaust(11-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyCCTroops($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True, $bGetSlot = False)

	Local $aTroopWSlot[1][3] = [[0, "", 0]] ; X-Coord, Troop Name index, Quantity

	If $g_bDebugSetlogTrain Then SetLog("getArmyCCTroops():", $COLOR_DEBUG)

	If Not $bOpenArmyWindow  Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyCCTroops()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	Local $sTroopDiamond = GetDiamondFromRect("20,495,462,598") ; Contains iXStart, $iYStart, $iXEnd, $iYEnd
	Local $aCurrentCCTroops = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Troops", $sTroopDiamond, $sTroopDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]

	Local $aTempTroopArray,$aTroops ,$aTroopCoords
	Local $sTroopName = ""
	Local $iTroopIndex = -1
	Local $aCurrentCCTroopsEmpty[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; Local Copy to reset Troops Array

	$g_aiCurrentCCTroops = $aCurrentCCTroopsEmpty ; Reset Current Troops Array
	If UBound($aCurrentCCTroops, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentCCTroops, 1) - 1 ; Loop through found CC Troops
			$aTempTroopArray = $aCurrentCCTroops[$i] ; Declare Array to Temp Array

			$iTroopIndex = TroopIndexLookup($aTempTroopArray[0], "getArmyTroops()") ; Get the Index of the Troop from the ShortName

			If StringInStr($aTempTroopArray[1], "|") Then
				$aTroops = StringSplit($aTempTroopArray[1], "|")
				For $j = 1 To $aTroops[0]
					$aTroopCoords = StringSplit($aTroops[$j], ",", $STR_NOCOUNT) ; Split the Coordinates where the Troop got found into X and Y
					Local $TempQty = Number(getBarracksNewTroopQuantity(Slot($aTroopCoords[0], $aTroopCoords[1]), 498, $bNeedCapture)) ; Get The Quantity of the Troop, Slot() Does return the exact spot to read the Number from
					$g_aiCurrentCCTroops[$iTroopIndex] += $TempQty
					$aTroopWSlot[UBound($aTroopWSlot) - 1][0] = Slot($aTroopCoords[0], $aTroopCoords[1])
					$aTroopWSlot[UBound($aTroopWSlot) - 1][1] = $iTroopIndex
					$aTroopWSlot[UBound($aTroopWSlot) - 1][2] = $TempQty
					ReDim $aTroopWSlot[UBound($aTroopWSlot) + 1][3]
				Next
			Else
				$aTroopCoords = StringSplit($aTempTroopArray[1], ",", $STR_NOCOUNT) ; Split the Coordinates where the Troop got found into X and Y
				$g_aiCurrentCCTroops[$iTroopIndex] = Number(getBarracksNewTroopQuantity(Slot($aTroopCoords[0], $aTroopCoords[1]), 498, $bNeedCapture)) ; Get The Quantity of the Troop, Slot() Does return the exact spot to read the Number from
				$aTroopWSlot[UBound($aTroopWSlot) - 1][0] = Slot($aTroopCoords[0], $aTroopCoords[1])
				$aTroopWSlot[UBound($aTroopWSlot) - 1][1] = $iTroopIndex
				$aTroopWSlot[UBound($aTroopWSlot) - 1][2] = $g_aiCurrentCCTroops[$iTroopIndex]
				ReDim $aTroopWSlot[UBound($aTroopWSlot) + 1][3]
			EndIf

			$sTroopName = $g_aiCurrentCCTroops[$iTroopIndex] >= 2 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex] ; Select the right Troop Name, If more than one then use the Plural
			If $bSetLog Then SetLog(" - " & $g_aiCurrentCCTroops[$iTroopIndex] & "x " & $sTroopName & " (Clan Castle)", $COLOR_SUCCESS) ; Log What Troop is available and How many
		Next
	EndIf

	If $bCloseArmyWindow Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

	If $bGetSlot Then
		If Ubound($aTroopWSlot) > 1 Then _ArrayDelete($aTroopWSlot, Ubound($aTroopWSlot) - 1)
		If UBound($aTroopWSlot) = 1 And $aTroopWSlot[0][0] = 0 And $aTroopWSlot[0][1] = "" Then Return
		_ArraySort($aTroopWSlot)
		Return $aTroopWSlot
	EndIf

EndFunc   ;==>getArmyTroops