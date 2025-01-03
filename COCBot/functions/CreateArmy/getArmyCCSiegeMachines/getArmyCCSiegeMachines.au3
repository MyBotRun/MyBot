; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCSiegeMachines
; Description ...: Obtain the current Clan Castle Siege Machines
; Syntax ........: getArmyCCSiegeMachines()
; Parameters ....:
; Return values .:
; Author ........: Fliegerfaust(06-2018)
; Modified ......: Moebius14 (04-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyCCSiegeCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = True, $bSetLog = True, $bNeedCapture = True)

	If $g_iTownHallLevel < 10 And $g_iTownHallLevel <> -1 Then
		SetDebugLog("getArmyCCSiegeCapacity(): Early exit because clan castle cannot fit sieges", $COLOR_DEBUG)
		Return
	EndIf

	If $g_bDebugSetLogTrain Or $g_bDebugSetLog Then SetLog("Begin getArmyCCSiegeCapacity:", $COLOR_DEBUG1)

	If $bCheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview(True, "getArmyCCSiegeCapacity()") Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	; Get CC Siege Capacities
	Local $sSiegeInfo = getCCSiegeCampCap(578, 428 + $g_iMidOffsetY, $bNeedCapture) ; OCR read Siege built and total
	If $g_bDebugSetLogTrain Then SetLog("OCR $sSiegeInfo = " & $sSiegeInfo, $COLOR_DEBUG)
	Local $aGetSiegeCap = StringSplit($sSiegeInfo, "#", $STR_NOCOUNT) ; split the built Siege number from the total Siege number
	If $bSetLog And UBound($aGetSiegeCap) = 2 Then SetLog("Clan Castle Siege" & ($aGetSiegeCap[1] > 1 ? "s" : "") & ": " & $aGetSiegeCap[0] & "/" & $aGetSiegeCap[1])

	If $bCloseArmyWindow Then CloseWindow()

EndFunc   ;==>getArmyCCSiegeCapacity

Func getArmyCCSiegeMachines($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True)

	Local $aSiegeWSlot[1][4] = [[0, "", 0, 0]] ; Page, Siege Name index, Quantity, X Coord for Remove

	If $g_bDebugSetLogTrain Then SetLog("getArmyCCSiegeMachines():", $COLOR_DEBUG)

	If Not $bOpenArmyWindow Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyCCSiegeMachines()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	Local $aCurrentCCSiegeMachines = CCSiegeMachinesArray($bNeedCapture)

	Local $aTempCCSiegeArray
	Local $sSiegeName = ""
	Local $iCCSiegeIndex = -1
	Local $aCurrentCCSiegeEmpty[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0] ; Local Copy to reset Siege Machine Array

	$g_aiCurrentCCSiegeMachines = $aCurrentCCSiegeEmpty ; Reset Current Siege Machine Array

	If IsArray($aCurrentCCSiegeMachines) And UBound($aCurrentCCSiegeMachines, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentCCSiegeMachines, 1) - 1 ; Loop through found Troops
			$aTempCCSiegeArray = $aCurrentCCSiegeMachines[$i] ; Declare Array to Temp Array

			$iCCSiegeIndex = TroopIndexLookup($aTempCCSiegeArray[0], "getArmyCCSiegeMachines()") - $eWallW ; Get the Index of the Siege M from the ShortName
			If $iCCSiegeIndex < 0 Then ContinueLoop

			$aSiegeWSlot[UBound($aSiegeWSlot) - 1][0] = $aTempCCSiegeArray[2]   ; Page Number
			$aSiegeWSlot[UBound($aSiegeWSlot) - 1][1] = $iCCSiegeIndex            ; Siege Number
			$aSiegeWSlot[UBound($aSiegeWSlot) - 1][2] = $aTempCCSiegeArray[3]   ; Siege Quantity
			$g_aiCurrentCCSiegeMachines[$iCCSiegeIndex] = $aTempCCSiegeArray[3] ; Siege Quantity
			$aSiegeWSlot[UBound($aSiegeWSlot) - 1][3] = $aTempCCSiegeArray[4]   ; X Coord for Remove
			ReDim $aSiegeWSlot[UBound($aSiegeWSlot) + 1][4]

			$sSiegeName = $g_aiCurrentCCSiegeMachines[$iCCSiegeIndex] >= 2 ? $g_asSiegeMachineNames[$iCCSiegeIndex] & " Sieges (Clan Castle)" : $g_asSiegeMachineNames[$iCCSiegeIndex] & " Siege (Clan Castle)" ; Select the right Siege Name, If more than one then use Sieges at the end
			If $bSetLog Then SetLog(" - " & $g_aiCurrentCCSiegeMachines[$iCCSiegeIndex] & "x " & $sSiegeName, $COLOR_SUCCESS) ; Log What Siege is available and How many

		Next

		_ArrayDelete($aSiegeWSlot, UBound($aSiegeWSlot) - 1)

		If $bCloseArmyWindow Then CloseWindow()

		Return $aSiegeWSlot

	EndIf

	If $bCloseArmyWindow Then CloseWindow()

	Return 0
EndFunc   ;==>getArmyCCSiegeMachines

Func CCSiegeMachinesArray($bNeedCapture = True)
	Local $TempQty = 0
	Local $b_XRemoveClick[3] = [630, 613, 645]
	If IsArray(_PixelSearch(569, 490 + $g_iMidOffsetY, 573, 490 + $g_iMidOffsetY, Hex(0xCFCFC8, 6), 20, True)) Then
		Local $sCCSiegeDiamond = GetDiamondFromRect2(580, 454 + $g_iMidOffsetY, 642, 530 + $g_iMidOffsetY)
		Local $aCurrentCCSiegeMachines = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\SiegeMachines", $sCCSiegeDiamond, $sCCSiegeDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
		If IsArray($aCurrentCCSiegeMachines) Then
			$TempQty = Number(getBarracksNewTroopQuantity(590, 454 + $g_iMidOffsetY))
			_ArrayAdd($aCurrentCCSiegeMachines[0], 0 & "|" & $TempQty & "|" & $b_XRemoveClick[0]) ; Page 0, only one Siege slot
		EndIf
		Return $aCurrentCCSiegeMachines
	Else
		Local $sCCSiegeDiamond = GetDiamondFromRect2(558, 454 + $g_iMidOffsetY, 628, 530 + $g_iMidOffsetY) ; First Siege slot
		Local $aCurrentCCSiegeMachines = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\SiegeMachines", $sCCSiegeDiamond, $sCCSiegeDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
		If IsArray($aCurrentCCSiegeMachines) Then
			$TempQty = Number(getBarracksNewTroopQuantity(570, 454 + $g_iMidOffsetY))
			_ArrayAdd($aCurrentCCSiegeMachines[0], 1 & "|" & $TempQty & "|" & $b_XRemoveClick[1]) ; Page 1
		EndIf
		If Not IsArray(_PixelSearch(658, 490 + $g_iMidOffsetY, 662, 490 + $g_iMidOffsetY, Hex(0xCFCFC8, 6), 20, True)) Then ; Second Siege slot
			ClickDrag(645, 495 + $g_iMidOffsetY, 573, 495 + $g_iMidOffsetY, 300)
			If _Sleep(2000) Then Return
			Local $sCCSiegeDiamond = GetDiamondFromRect2(593, 454 + $g_iMidOffsetY, 658, 530 + $g_iMidOffsetY)
			Local $aCurrentCCSiegeMachines2 = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\SiegeMachines", $sCCSiegeDiamond, $sCCSiegeDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
			If IsArray($aCurrentCCSiegeMachines2) And IsArray($aCurrentCCSiegeMachines) Then
				$TempQty = Number(getBarracksNewTroopQuantity(600, 454 + $g_iMidOffsetY))
				_ArrayAdd($aCurrentCCSiegeMachines2[0], 2 & "|" & $TempQty & "|" & $b_XRemoveClick[2]) ; Page 2
				ReDim $aCurrentCCSiegeMachines[UBound($aCurrentCCSiegeMachines) + 1]
				$aCurrentCCSiegeMachines[1] = $aCurrentCCSiegeMachines2[0]
			EndIf
			ClickDrag(573, 495 + $g_iMidOffsetY, 618, 495 + $g_iMidOffsetY, 300)
			If _Sleep(1000) Then Return
		EndIf
	EndIf
	Return $aCurrentCCSiegeMachines
EndFunc   ;==>CCSiegeMachinesArray
