; #FUNCTION# ====================================================================================================================
; Name ..........: OpenArmyOverview
; Description ...: Opens and waits for Army Overview window and verifies success
; Syntax ........: OpenArmyOverview()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (01-2016)
; Modified ......: GrumpyHog (11/2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func OpenArmyOverview($bCheckMain = True, $sWhereFrom = "Undefined")

	If $bCheckMain Then
		If Not IsMainPage() Then ; check for main page, avoid random troop drop
			SetLog("Cannot open Army Overview window", $COLOR_ERROR)
			SetError(1)
			Return False
		EndIf
	EndIf

	If WaitforPixel(23, 505 + $g_iBottomOffsetY, 53, 507 + $g_iBottomOffsetY, Hex(0xEEB344, 6), 15, 10) Then
		If $g_bDebugSetlogTrain Then SetLog("Click $aArmyTrainButton" & " (Called from " & $sWhereFrom & ")", $COLOR_SUCCESS)
		ClickP($aArmyTrainButton, 1, 0, "#0293") ; Button Army Overview
	EndIf

	If _Sleep($DELAYRUNBOT6) Then Return ; wait for window to open
	If Not IsTrainPage() Then
		SetError(1)
		Return False ; exit if I'm not in train page
	EndIf
	Return True

EndFunc   ;==>OpenArmyOverview

Func OpenArmyTab($bSetLog = True, $sWhereFrom = "Undefined")
	Return OpenTrainTab("Army Tab", $bSetLog, $sWhereFrom)
EndFunc   ;==>OpenArmyTab

Func OpenTroopsTab($bSetLog = True, $sWhereFrom = "Undefined")
   	Local $bResult = OpenTrainTab("Train Troops Tab", $bSetLog, $sWhereFrom)

	If $bResult Then UpdateNextPageTroop()

	Return $bResult
EndFunc   ;==>OpenTroopsTab

Func OpenSpellsTab($bSetLog = True, $sWhereFrom = "Undefined")
	Return OpenTrainTab("Brew Spells Tab", $bSetLog, $sWhereFrom)
EndFunc   ;==>OpenSpellsTab

Func OpenSiegeMachinesTab($bSetLog = True, $sWhereFrom = "Undefined")
	Return OpenTrainTab("Build Siege Machines Tab", $bSetLog, $sWhereFrom)
EndFunc   ;==>OpenSiegeMachinesTab

Func OpenQuickTrainTab($bSetLog = True, $sWhereFrom = "Undefined")
	Return OpenTrainTab("Quick Train Tab", $bSetLog, $sWhereFrom)
EndFunc   ;==>OpenQuickTrainTab

Func OpenTrainTab($sTab, $bSetLog = True, $sWhereFrom = "Undefined")

	If Not IsTrainPage() Then
		SetDebugLog("Error in OpenTrainTab: Cannot find the Army Overview Window", $COLOR_ERROR)
		SetError(1)
		Return False
	EndIf

	Local $aTabButton = findButton(StringStripWS($sTab, 8), Default, 1, True)
	If IsArray($aTabButton) And UBound($aTabButton, 1) = 2 Then
		$aIsTabOpen[0] = $aTabButton[0]
		If Not _CheckPixel($aIsTabOpen, True) Then
			If $bSetLog Or $g_bDebugSetlogTrain Then SetLog("Open " & $sTab & ($g_bDebugSetlogTrain ? " (Called from " & $sWhereFrom & ")" : ""), $COLOR_INFO)
			ClickP($aTabButton)
			If Not _WaitForCheckPixel($aIsTabOpen, True) Then
				SetLog("Error in OpenTrainTab: Cannot open " & $sTab & ". Pixel to check did not appear", $COLOR_ERROR)
				SetError(1)
				Return False
			EndIf
		EndIf
	Else
		SetDebugLog("Error in OpenTrainTab: $aTabButton is no valid Array", $COLOR_ERROR)
		SetError(1)
		Return False
	EndIf

	If _Sleep(200) Then Return
	Return True
 EndFunc   ;==>OpenTrainTab

 Func UpdateNextPageTroop()
	Local $aSlot0[4] = [615, 465, 705, 370]
	Local $aSlot1[4] = [615, 570, 705, 480]
	Local $aSlot2[4] = [715, 465, 865, 370]
	Local $sEDragTile = @ScriptDir & "\imgxml\ArmyOverview\Troops\EDrag*"

	SetLog("UpdateNextPageTroop...")

	$g_iNextPageTroop = $eMini

	DragIfNeeded($eBarb)

	Local $aiTileCoord = decodeSingleCoord(findImage("UpdateNextPageTroop", $sEDragTile, GetDiamondFromRect("25,375,840,548"), 1, True))

	If IsArray($aiTileCoord) And Ubound($aiTileCoord, 1) = 2 Then
		SetLog("Found EDrag at " & $aiTileCoord[0] & ", " & $aiTileCoord[1])

		If PointInRect($aSlot1[0], $aSlot1[1], $aSlot1[2], $aSlot1[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			$g_iNextPageTroop = $eETitan
			SetLog("Found Edrag moved 1 Slot")
		EndIf

		If PointInRect($aSlot2[0], $aSlot2[1], $aSlot2[2], $aSlot2[3], $aiTileCoord[0], $aiTileCoord[1]) Then
			$g_iNextPageTroop = $eRDrag
			SetLog("Found Edrag moved 2 Slot")
		EndIf
	EndIf

EndFunc

Func PointInRect($iBLx, $iBLy, $iTRx, $iTRy, $iPTx, $iPTy)
	If $iPTx > $iBLx And $iPTx < $iTRx And $iPTy < $iBLy And $iPTy > $iTRy Then Return True

	Return False
EndFunc
