; #FUNCTION# ====================================================================================================================
; Name ..........: GetAttackBarBB
; Description ...: Gets the troops and there quantities for the current attack
; Syntax ........:
; Parameters ....: None
; Return values .: array attackBar
; Author ........: xbebenk
; Modified ......: Moebius14 (09/2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetAttackBarBB($bRemaining = False, $bSecondAttack = False)
	Local $iTroopBanners = 585 + $g_iBottomOffsetY ; y location of where to find troop quantities
	Local $iSelectTroopY = 610 + $g_iBottomOffsetY ; y location to select troop on attackbar
	Local $aBBAttackBar[0][5]
	Local $aEmpty[0][2]
	Local $BMFound = 0
	Local $BMDeadX = 71, $BMDeadColor
	Local $BMDeadY = 663 + $g_iBottomOffsetY
	For $i = 0 To 8
		$BomberDead[$i] = 0
	Next
	If Not $bRemaining Then
		$g_bMachineAliveOnAttackBar = True
		$g_bBomberOnAttackBar = False
		$g_aBomberOnAttackBar = $aEmpty
	EndIf

	Local $iMaxSlot = 9, $iSlotOffset = 75.5
	Local $aSlotX[$iMaxSlot], $iStartSlot = 100

	Local $aBMPosInit = GetMachinePos()
	If $aBMPosInit = 0 Then
		If $g_DeployedMachine Then
			SetDebugLog("Machine Already Deployed", $COLOR_DEBUG)
			$BMFound += 1
		Else
			SetDebugLog("Machine Unavailable", $COLOR_DEBUG)
			If Not $bSecondAttack Then
				$iStartSlot = $iStartSlotMem
			Else
				$iStartSlot = $iStartSlotMem2
			EndIf
		EndIf
		For $i = 0 To UBound($aSlotX) - 1
			$aSlotX[$i] = $iStartSlot + ($i * $iSlotOffset)
		Next
	Else
		If Not StringInStr($aBMPosInit[2], "Dead") And Not $g_DeployedMachine Then
			Local $aTempElement[1][5] = [["BattleMachine", 18, 620 + $g_iBottomOffsetY, 0, 1]] ; element to add to attack bar list
			_ArrayAdd($aBBAttackBar, $aTempElement)
			SetDebugLog("Found Machine Ready to be deployed", $COLOR_DEBUG)
		Else
			SetDebugLog("Found Machine Dead Or Deployed", $COLOR_DEBUG)
			$BMDeadColor = _GetPixelColor($BMDeadX, $BMDeadY, True)
			If Not $bRemaining And _ColorCheck($BMDeadColor, Hex(0x4E4E4E, 6), 20, Default) Then $g_bMachineAliveOnAttackBar = False
		EndIf
		$BMFound += 1
		For $i = 0 To UBound($aSlotX) - 1
			$aSlotX[$i] = $iStartSlot + ($i * $iSlotOffset)
		Next
	EndIf

	If Not $g_bRunState Then Return ; Stop Button

	Local $iCount = 1, $isBlueBanner = False, $isVioletBanner = False, $isVioletBannerSelected = False, $isGreyBanner = False, $isVioletBannerDeployed = False
	Local $isVioletBanner2 = False, $isVioletBanner2Selected = False, $isGreyBanner = False, $isVioletBanner2Deployed = False
	Local $aBBAttackBarResult, $Troop = "", $Troopx = 0, $Troopy = 0, $ColorPickBannerX = 0
	Local $bReadTroop = False

	For $k = 0 To UBound($aSlotX) - 1
		If Not $g_bRunState Then Return

		$Troopx = $aSlotX[$k]
		$ColorPickBannerX = $aSlotX[$k] + 34 ; location to pick color from TroopSlot banner

		If $bRemaining Then
			If QuickMIS("BC1", $g_sImgDirBBTroops, $Troopx, $iTroopBanners, $Troopx + 70, 670 + $g_iBottomOffsetY) Then
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: TroopBanner ColorpickX=" & $ColorPickBannerX, $COLOR_DEBUG2)
				$isGreyBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x7B7B7B, 6), 10, Default) ;Grey Banner on TroopSlot = Troop Die
				If $isGreyBanner Then
					If Number(getOcrAndCapture("coc-tbb", $ColorPickBannerX, $iTroopBanners - 8, 31, 16, True)) > 0 Then $isGreyBanner = False ;Just in case but should not happens
				EndIf
				$isVioletBannerDeployed = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners - 15, True), Hex(0xCA49FF, 6), 30, Default) ;Violet Banner on Big TroopSlot = Troop Deployed
				$isVioletBanner2Deployed = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners - 15, True), Hex(0x232323, 6), 10, Default) ;Violet Banner on Giant TroopSlot = Troop Deployed / ability used
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: isGreyBanner=" & String($isGreyBanner) & " isVioletBannerDeployed=" & String($isVioletBannerDeployed) & " isVioletBanner2Deployed=" & String($isVioletBanner2Deployed), $COLOR_DEBUG2)
				If $isGreyBanner Or $isVioletBannerDeployed Or $isVioletBanner2Deployed Then ContinueLoop

				$isVioletBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0xCA4AFF, 6), 30, Default) ; Violet Banner on TroopSlot = TroopSlot Quantity = 1
				$isVioletBanner2 = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x12244B, 6), 30, Default) ; Violet Banner on Giant TroopSlot = TroopSlot Quantity = 1 / ability used
				$isVioletBannerSelected = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0xD77AFF, 6), 30, Default) ; Violet Banner on TroopSlot = TroopSlot Quantity = 1, Selected But Not Dropped
				$isVioletBanner2Selected = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x15274A, 6), 30, Default) ; Violet Banner on Giant TroopSlot = TroopSlot Quantity = 1, Selected But Not Dropped / ability used
				$isBlueBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x4482FE, 6), 30, Default) ; Blue Banner on TroopSlot = TroopSlot Quantity > 1
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: isBlueBanner=" & String($isBlueBanner) & " isVioletBanner=" & String($isVioletBanner) & " isVioletBannerSelected=" & String($isVioletBannerSelected), $COLOR_DEBUG2)
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: isVioletBanner2=" & String($isVioletBanner2) & " isVioletBanner2Selected=" & String($isVioletBanner2Selected), $COLOR_DEBUG2)

				If $isBlueBanner Or $isVioletBanner Or $isVioletBannerSelected Or $isVioletBanner2 Or $isVioletBanner2Selected Then
					$Troop = $g_iQuickMISName
					$Troopy = $iSelectTroopY
					If $isBlueBanner Then
						$iCount = Number(getOcrAndCapture("coc-tbb", $ColorPickBannerX, $iTroopBanners - 8, 31, 16, True))
						If $iCount = "" Then $iCount = Number(getOcrAndCapture("coc-tbb", $ColorPickBannerX, $iTroopBanners - 14, 31, 16, True)) ;Maybe this Troop is Selected ? => $y-5
					EndIf
					If $isVioletBanner Or $isVioletBannerSelected Or $isVioletBanner2 Or $isVioletBanner2Selected Then $iCount = 1

					Local $aTempElement[1][5] = [[$Troop, $Troopx, $Troopy, $k + $BMFound, $iCount]] ; element to add to attack bar list
					_ArrayAdd($aBBAttackBar, $aTempElement)
				EndIf
			EndIf
		Else
			If QuickMIS("BC1", $g_sImgDirBBTroops, $Troopx, $iTroopBanners, $Troopx + 70, 670 + $g_iBottomOffsetY) Then
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: TroopBanner ColorpickX=" & $ColorPickBannerX, $COLOR_DEBUG2)
				$isVioletBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0xCA4AFF, 6), 30, Default) ; Violet Banner on TroopSlot = TroopSlot Quantity = 1
				$isBlueBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x3E7BFF, 6), 30, Default) ; Blue Banner on TroopSlot = TroopSlot Quantity > 1
				If Not $isVioletBanner And $bSecondAttack Then $isVioletBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x12244B, 6), 30, Default) ; Violet Banner on TroopSlot = TroopSlot Quantity = 1 / ability used
				If $g_bDebugSetLog Then SetLog("Slot [" & $k + $BMFound & "]: isBlueBanner=" & String($isBlueBanner) & " isVioletBanner=" & String($isVioletBanner), $COLOR_DEBUG2)

				$bReadTroop = $isBlueBanner Or $isVioletBanner
				If $bReadTroop Then
					$Troop = $g_iQuickMISName
					$Troopy = $iSelectTroopY
					If $isBlueBanner Then $iCount = Number(getOcrAndCapture("coc-tbb", $ColorPickBannerX, $iTroopBanners - 8, 31, 16, True))
					If $isVioletBanner Then $iCount = 1

					Local $aTempElement[1][5] = [[$Troop, $Troopx, $Troopy, $k + $BMFound, $iCount]] ; element to add to attack bar list
					_ArrayAdd($aBBAttackBar, $aTempElement)
				EndIf
			EndIf
		EndIf
	Next

	If UBound($aBBAttackBar) = 0 Then Return ""

	_ArraySort($aBBAttackBar, 0, 0, 0, 3)
	For $i = 0 To UBound($aBBAttackBar) - 1
		If $aBBAttackBar[$i][0] = "BattleMachine" Then
			Local $aBMPos = GetMachinePos()
			If IsArray($aBMPos) And $aBMPos <> 0 Then
				If StringInStr($aBMPos[2], "Copter") Then
					SetLog("Slot[" & $aBBAttackBar[$i][3] & "] Battle Copter, (" & $aBBAttackBar[$i][1] & "," & $aBBAttackBar[$i][2] & ")", $COLOR_SUCCESS)
				Else
					SetLog("Slot[" & $aBBAttackBar[$i][3] & "] Battle Machine, (" & $aBBAttackBar[$i][1] & "," & $aBBAttackBar[$i][2] & ")", $COLOR_SUCCESS)
				EndIf
			Else
				SetLog("Slot[" & $aBBAttackBar[$i][3] & "] " & $aBBAttackBar[$i][0] & ", (" & $aBBAttackBar[$i][1] & "," & $aBBAttackBar[$i][2] & "), Count: " & $aBBAttackBar[$i][4], $COLOR_SUCCESS)
			EndIf
		Else
			SetLog("Slot[" & $aBBAttackBar[$i][3] & "] " & $aBBAttackBar[$i][0] & ", (" & $aBBAttackBar[$i][1] & "," & $aBBAttackBar[$i][2] & "), Count: " & $aBBAttackBar[$i][4], $COLOR_SUCCESS)
		EndIf
		If Not $bRemaining And $aBBAttackBar[$i][0] = "Bomber" Then
			$g_bBomberOnAttackBar = True
			_ArrayAdd($g_aBomberOnAttackBar, $aBBAttackBar[$i][1] & "|" & $aBBAttackBar[$i][2])
		EndIf
	Next
	Return $aBBAttackBar
EndFunc   ;==>GetAttackBarBB
