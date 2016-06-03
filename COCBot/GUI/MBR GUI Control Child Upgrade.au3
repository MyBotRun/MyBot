; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Upgrade
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func btnLocateUpgrades()
	$RunState = True
	While 1
		LocateUpgrades()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateUpgrades

Func btnchkbxUpgrade()
	For $i = 0 To UBound($aUpgrades, 1) - 1
		If GUICtrlRead($chkbxUpgrade[$i]) = $GUI_CHECKED Then
			$ichkbxUpgrade[$i] = 1
		Else
			$ichkbxUpgrade[$i] = 0
		EndIf
	Next
EndFunc   ;==>btnchkbxUpgrade

Func btnchkbxRepeat()
	For $i = 0 To UBound($aUpgrades, 1) - 1
		If GUICtrlRead($chkUpgrdeRepeat[$i]) = $GUI_CHECKED Then
			$ichkUpgrdeRepeat[$i] = 1
		Else
			$ichkUpgrdeRepeat[$i] = 0
		EndIf
	Next
EndFunc   ;==>btnchkbxRepeat

Func picUpgradeTypeLocation()
	$RunState = True
	PureClick(1, 40, 1, 0, "#9999") ; Clear screen
	Sleep(100)
	Zoomout() ; Zoom out if needed
	For $j = 0 To UBound($aUpgrades, 1) - 1
		If @GUI_CtrlId = $picUpgradeType[$j] Then
			If isInsideDiamondXY($aUpgrades[$j][0], $aUpgrades[$j][0]) Then ; check for valid location
				Click($aUpgrades[$j][0], $aUpgrades[$j][1], 1, 0, "#9999")
				Sleep(100)
				If StringInStr($aUpgrades[$j][4], "collect", $STR_NOCASESENSEBASIC) Or _
						StringInStr($aUpgrades[$j][4], "mine", $STR_NOCASESENSEBASIC) Or _
						StringInStr($aUpgrades[$j][4], "drill", $STR_NOCASESENSEBASIC) Then
					Click(1, 40, 1, 0, "#0999") ;Click away to deselect collector if was not full, and collected with previous click
					Sleep(100)
					Click($aUpgrades[$j][0], $aUpgrades[$j][1], 1, 0, "#9999") ;Select collector
				EndIf
			EndIf
		EndIf
	Next
	$RunState = False
EndFunc   ;==>picUpgradeTypeLocation

Func btnResetUpgrade()
	For $i = 0 To UBound($aUpgrades, 1) - 1
		If GUICtrlRead($chkUpgrdeRepeat[$i]) = $GUI_CHECKED Then ContinueLoop
		$aUpgrades[$i][0] = -1 ; clear location and loot value in $aUpgrades variable
		$aUpgrades[$i][1] = -1 ; clear location and loot value in $aUpgrades variable
		$aUpgrades[$i][2] = -1 ; clear location and loot value in $aUpgrades variable
		$aUpgrades[$i][3] = "" ;Clear Upgrade Type
		$aUpgrades[$i][4] = "" ;Clear Upgrade Unit Name
		$aUpgrades[$i][5] = "" ;Clear Upgrade Level
		$aUpgrades[$i][6] = "" ;Clear Upgrade Time
		$aUpgrades[$i][7] = "" ;Clear Upgrade Starting Time
		GUICtrlSetData($txtUpgradeName[$i], "") ; Clear GUI Unit Name
		GUICtrlSetData($txtUpgradeLevel[$i], "") ; Clear GUI Unit Level
		GUICtrlSetData($txtUpgradeValue[$i], "") ; Clear Upgrade value in GUI
		GUICtrlSetData($txtUpgradeTime[$i], "") ; Clear Upgrade time in GUI
		GUICtrlSetImage($picUpgradeType[$i], $pIconLib, $eIcnBlank) ; change GUI upgrade image to blank
		$ipicUpgradeStatus[$i] = $eIcnTroops
		GUICtrlSetImage($picUpgradeStatus[$i], $pIconLib, $ipicUpgradeStatus[$i]) ; Change GUI upgrade status to not ready
		GUICtrlSetState($chkbxUpgrade[$i], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
		GUICtrlSetState($chkUpgrdeRepeat[$i], $GUI_UNCHECKED) ; Change repeat box to unchecked
	Next
EndFunc   ;==>btnResetUpgrade

Func chkLab()
	If GUICtrlRead($chkLab) = $GUI_CHECKED Then
		$ichkLab = 1
		GUICtrlSetState($icnLabUpgrade, $GUI_SHOW)
		GUICtrlSetState($lblNextUpgrade, $GUI_ENABLE)
		GUICtrlSetState($cmbLaboratory, $GUI_ENABLE)
		GUICtrlSetState($btnLocateLaboratory, $GUI_SHOW)
		GUICtrlSetImage($icnLabUpgrade, $pIconLib, $aLabTroops[$icmbLaboratory][4])
	Else
		$ichkLab = 0
		GUICtrlSetState($icnLabUpgrade, $GUI_HIDE)
		GUICtrlSetState($lblNextUpgrade, $GUI_DISABLE)
		GUICtrlSetState($cmbLaboratory, $GUI_DISABLE)
		GUICtrlSetState($btnLocateLaboratory, $GUI_HIDE)
		GUICtrlSetImage($icnLabUpgrade, $pIconLib, $aLabTroops[0][4])
	EndIf
	If _DateIsValid($sLabUpgradeTime) Then
		$txtTip = GetTranslated(614, 8, "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslated(614, 9, "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslated(614, 10, "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslated(614, 11, "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslated(614, 12, "Caution - Unnecessary timer reset will force constant checks for lab status") & @CRLF & @CRLF & _
				GetTranslated(614, 19, "Troop Upgrade started") & ", " & _
				GetTranslated(614, 20, "Will begin to check completion at:") & " " & $sLabUpgradeTime & @CRLF & " "
		GUICtrlSetTip($btnResetLabUpgradeTime, $txtTip)
		GUICtrlSetState($btnResetLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($btnResetLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($btnResetLabUpgradeTime, $GUI_HIDE) ; comment this line out to edit GUI
		GUICtrlSetState($btnResetLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkLab

Func cmbLab()
	$icmbLaboratory = _GUICtrlComboBox_GetCurSel($cmbLaboratory)
	GUICtrlSetImage($icnLabUpgrade, $pIconLib, $aLabTroops[$icmbLaboratory][4])
EndFunc   ;==>cmbLab

Func ResetLabUpgradeTime()
	; Display are you sure message
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	Local $stext = @CRLF & GetTranslated(614, 13, "Are you 100% sure you want to reset lab upgrade timer?") & @CRLF & _
			GetTranslated(614, 14, "Click OK to reset") & @CRLF & GetTranslated(614, 15, "Or Click Cancel to exit") & @CRLF
	Local $MsgBox = _ExtMsgBox(0, GetTranslated(614, 16, "Reset timer") & "|" & GetTranslated(614, 17, "Cancel and Return"), GetTranslated(614, 18, "Reset laboratory upgrade timer?"), $stext, 120, $frmBot)
	If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_PURPLE)
	If $MsgBox = 1 Then
		$sLabUpgradeTime = ""
		$txtTip = GetTranslated(614, 8, "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslated(614, 9, "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslated(614, 10, "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslated(614, 11, "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslated(614, 12, "Caution - Unnecessary timer reset will force constant checks for lab status")
		GUICtrlSetTip($btnResetLabUpgradeTime, $txtTip)
	EndIf
	If _DateIsValid($sLabUpgradeTime) Then
		GUICtrlSetState($btnResetLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($btnResetLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($btnResetLabUpgradeTime, $GUI_HIDE)
		GUICtrlSetState($btnResetLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ResetLabUpgradeTime

Func chkUpgradeKing()
	If $iTownHallLevel > 6 Or $iTownHallLevel = 0 Then ; Must be TH7 or above to have King
		GUICtrlSetState($chkUpgradeKing, $GUI_ENABLE)
		If GUICtrlRead($chkUpgradeKing) = $GUI_CHECKED Then
			$ichkUpgradeKing = 1
			GUICtrlSetState($chkDBKingWait, $GUI_UNCHECKED)
			GUICtrlSetState($chkABKingWait, $GUI_UNCHECKED)
			GUICtrlSetState($chkDBKingWait, $GUI_DISABLE)
			GUICtrlSetState($chkABKingWait, $GUI_DISABLE)
			_GUI_Value_STATE("SHOW", $groupKingSleeping)
		Else
			$ichkUpgradeKing = 0
			GUICtrlSetState($chkDBKingWait, $GUI_ENABLE)
			GUICtrlSetState($chkABKingWait, $GUI_ENABLE)
			_GUI_Value_STATE("HIDE", $groupKingSleeping)
		EndIf

		If GUICtrlRead($cmbBoostBarbarianKing) > 0 Then
			GUICtrlSetState($chkUpgradeKing, $GUI_DISABLE)
			GUICtrlSetState($chkUpgradeKing, $GUI_UNCHECKED)
			$ichkUpgradeKing = 0
		Else
			GUICtrlSetState($chkUpgradeKing, $GUI_ENABLE)
		EndIf
	Else
		GUICtrlSetState($chkUpgradeKing, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeKing

Func chkUpgradeQueen()
	If $iTownHallLevel > 8 Or $iTownHallLevel = 0 Then ; Must be TH9 or above to have Queen
		GUICtrlSetState($chkUpgradeQueen, $GUI_ENABLE)
		If GUICtrlRead($chkUpgradeQueen) = $GUI_CHECKED Then
			$ichkUpgradeQueen = 1
			GUICtrlSetState($chkDBQueenWait, $GUI_UNCHECKED)
			GUICtrlSetState($chkABQueenWait, $GUI_UNCHECKED)
			GUICtrlSetState($chkDBQueenWait, $GUI_DISABLE)
			GUICtrlSetState($chkABQueenWait, $GUI_DISABLE)
			_GUI_Value_STATE("SHOW", $groupQueenSleeping)
		Else
			$ichkUpgradeQueen = 0
			GUICtrlSetState($chkDBQueenWait, $GUI_ENABLE)
			GUICtrlSetState($chkABQueenWait, $GUI_ENABLE)
			_GUI_Value_STATE("HIDE", $groupQueenSleeping)
		EndIf

		If GUICtrlRead($cmbBoostArcherQueen) > 0 Then
			GUICtrlSetState($chkUpgradeQueen, $GUI_DISABLE)
			GUICtrlSetState($chkUpgradeQueen, $GUI_UNCHECKED)
			$ichkUpgradeQueen = 0
		Else
			GUICtrlSetState($chkUpgradeQueen, $GUI_ENABLE)
		EndIf
	Else
		GUICtrlSetState($chkUpgradeQueen, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeQueen

Func chkUpgradeWarden()
	If $iTownHallLevel > 10 Or $iTownHallLevel = 0 Then ; Must be TH11 to have warden
		GUICtrlSetState($chkUpgradeWarden, $GUI_ENABLE)
		If GUICtrlRead($chkUpgradeWarden) = $GUI_CHECKED Then
			$ichkUpgradeWarden = 1
			GUICtrlSetState($chkDBWardenWait, $GUI_UNCHECKED)
			GUICtrlSetState($chkABWardenWait, $GUI_UNCHECKED)
			GUICtrlSetState($chkDBWardenWait, $GUI_DISABLE)
			GUICtrlSetState($chkABWardenWait, $GUI_DISABLE)
			_GUI_Value_STATE("SHOW", $groupWardenSleeping)
		Else
			$ichkUpgradeWarden = 0
			GUICtrlSetState($chkDBWardenWait, $GUI_ENABLE)
			GUICtrlSetState($chkABWardenWait, $GUI_ENABLE)
			_GUI_Value_STATE("HIDE", $groupWardenSleeping)
		EndIf

		If GUICtrlRead($cmbBoostWarden) > 0 Then
			GUICtrlSetState($chkUpgradeWarden, $GUI_DISABLE)
			GUICtrlSetState($chkUpgradeWarden, $GUI_UNCHECKED)
			$ichkUpgradeWarden = 0
		Else
			GUICtrlSetState($chkUpgradeWarden, $GUI_ENABLE)
		EndIf
	Else
		GUICtrlSetState($chkUpgradeWarden, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeWarden

Func chkWalls()
	If GUICtrlRead($chkWalls) = $GUI_CHECKED Then
		$ichkWalls = 1
		GUICtrlSetState($UseGold, $GUI_ENABLE)
		GUICtrlSetState($sldMaxNbWall, $GUI_ENABLE)
		;GUICtrlSetState($sldToleranceWall, $GUI_ENABLE)
		;GUICtrlSetState($btnFindWalls, $GUI_ENABLE)
		;		GUICtrlSetState($UseElixir, $GUI_ENABLE)
		;		GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
		GUICtrlSetState($cmbWalls, $GUI_ENABLE)
		GUICtrlSetState($txtWallMinGold, $GUI_ENABLE)
		;		GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
		cmbWalls()
	Else
		$ichkWalls = 0
		GUICtrlSetState($UseGold, $GUI_DISABLE)
		GUICtrlSetState($UseElixir, $GUI_DISABLE)
		GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
		GUICtrlSetState($cmbWalls, $GUI_DISABLE)
		GUICtrlSetState($txtWallMinGold, $GUI_DISABLE)
		GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		GUICtrlSetState($sldMaxNbWall, $GUI_DISABLE)
		;GUICtrlSetState($sldToleranceWall, $GUI_DISABLE)
		;GUICtrlSetState($btnFindWalls, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkWalls


Func chkSaveWallBldr()
	If GUICtrlRead($chkSaveWallBldr) = $GUI_CHECKED Then
		$iSaveWallBldr = 1
	Else
		$iSaveWallBldr = 0
	EndIf
EndFunc   ;==>chkSaveWallBldr

Func cmbWalls()
	$icmbWalls = _GUICtrlComboBox_GetCurSel($cmbWalls)
	$WallCost = $WallCosts[_GUICtrlComboBox_GetCurSel($cmbWalls)]
	GUICtrlSetData($lblWallCost, _NumberFormat($WallCost))
	_GUI_Value_STATE("HIDE", $txtWall04ST & "#" & $txtWall05ST & "#" & $txtWall06ST & "#" & $txtWall07ST & "#" & $txtWall08ST & "#" & $txtWall09ST & "#" & $txtWall10ST & "#" & $txtWall11ST)
	_GUI_Value_STATE("HIDE", $Wall04ST & "#" & $Wall05ST & "#" & $Wall06ST & "#" & $Wall07ST & "#" & $Wall08ST & "#" & $Wall09ST & "#" & $Wall10ST & "#" & $Wall11ST)
	Switch $icmbWalls ;
		Case 0
			_GUI_Value_STATE("SHOW", $txtWall04ST & "#" & $Wall04ST & "#" & $txtWall05ST & "#" & $Wall05ST)
			$WallCost = 30000
			GUICtrlSetData($lblWallCost, _NumberFormat($WallCost))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
			GUICtrlSetState($UseElixir, $GUI_DISABLE)
			GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 1
			_GUI_Value_STATE("SHOW", $txtWall04ST & "#" & $Wall04ST & "#" & $txtWall05ST & "#" & $Wall05ST & "#" & $txtWall06ST & "#" & $Wall06ST)
			$WallCost = 75000
			GUICtrlSetData($lblWallCost, _NumberFormat($WallCost))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
			GUICtrlSetState($UseElixir, $GUI_DISABLE)
			GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 2
			_GUI_Value_STATE("SHOW", $txtWall04ST & "#" & $Wall04ST & "#" & $txtWall05ST & "#" & $Wall05ST & "#" & $txtWall06ST & "#" & $Wall06ST & "#" & $txtWall07ST & "#" & $Wall07ST)
			$WallCost = 200000
			GUICtrlSetData($lblWallCost, _NumberFormat($WallCost))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
			GUICtrlSetState($UseElixir, $GUI_DISABLE)
			GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 3
			_GUI_Value_STATE("SHOW", $txtWall04ST & "#" & $Wall04ST & "#" & $txtWall05ST & "#" & $Wall05ST & "#" & $txtWall06ST & "#" & $Wall06ST & "#" & $txtWall07ST & "#" & $Wall07ST & "#" & $txtWall08ST & "#" & $Wall08ST)
			$WallCost = 500000
			GUICtrlSetData($lblWallCost, _NumberFormat($WallCost))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
			GUICtrlSetState($UseElixir, $GUI_DISABLE)
			GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 4
			_GUI_Value_STATE("SHOW", $txtWall04ST & "#" & $Wall04ST & "#" & $txtWall05ST & "#" & $Wall05ST & "#" & $txtWall06ST & "#" & $Wall06ST & "#" & $txtWall07ST & "#" & $Wall07ST & "#" & $txtWall08ST & "#" & $Wall08ST & "#" & $txtWall09ST & "#" & $Wall09ST)
			$WallCost = 1000000
			GUICtrlSetData($lblWallCost, _NumberFormat($WallCost))
			GUICtrlSetState($UseElixir, $GUI_ENABLE)
			GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
		Case 5
			_GUI_Value_STATE("SHOW", $txtWall04ST & "#" & $Wall04ST & "#" & $txtWall05ST & "#" & $Wall05ST & "#" & $txtWall06ST & "#" & $Wall06ST & "#" & $txtWall07ST & "#" & $Wall07ST & "#" & $txtWall08ST & "#" & $Wall08ST & "#" & $txtWall09ST & "#" & $Wall09ST & "#" & $txtWall10ST & "#" & $Wall10ST)
			$WallCost = 3000000
			GUICtrlSetData($lblWallCost, _NumberFormat($WallCost))
			GUICtrlSetState($UseElixir, $GUI_ENABLE)
			GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
		Case 6
			_GUI_Value_STATE("SHOW", $txtWall04ST & "#" & $Wall04ST & "#" & $txtWall05ST & "#" & $Wall05ST & "#" & $txtWall06ST & "#" & $Wall06ST & "#" & $txtWall07ST & "#" & $Wall07ST & "#" & $txtWall08ST & "#" & $Wall08ST & "#" & $txtWall09ST & "#" & $Wall09ST & "#" & $txtWall10ST & "#" & $Wall10ST & "#" & $txtWall11ST & "#" & $Wall11ST)
			$WallCost = 4000000
			GUICtrlSetData($lblWallCost, _NumberFormat($WallCost))
			GUICtrlSetState($UseElixir, $GUI_ENABLE)
			GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
	EndSwitch

EndFunc   ;==>cmbWalls

Func btnWalls()
	$RunState = True
	Zoomout()
	$icmbWalls = _GUICtrlComboBox_GetCurSel($cmbWalls)
	;$debugWalls = 1
	If CheckWall() Then Setlog("Hei Chef! We found the Wall!")
	;$debugWalls = 0
	$RunState = False
EndFunc   ;==>btnWalls
