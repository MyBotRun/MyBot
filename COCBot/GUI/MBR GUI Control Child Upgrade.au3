; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Upgrade
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func InitTranslatedTextUpgradeTab()
	GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Warning_Title", "Warning about your settings...")
	GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Warning_Text", "Warning ! You selected 2 resources to ignore... That can be a problem,\r\n" & _
		"and Auto Upgrade can be ineffective, by not launching any upgrade...\r\n" & _
		"I recommend you to select only one resource, not more...")
	GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Invalid_Title", "Invalid settings...")
	GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Invalid_Text", "Warning ! You selected 3 resources to ignore... And you can't...\r\n" & _
		"With your settings, Auto Upgrade will be completely ineffective\r\n" & _
		"and will not launch any upgrade... You must deselect one or more\r\n" & _
		"ignored resource.")
EndFunc   ;==>InitTranslatedTextUpgradeTab

Func btnLocateUpgrades()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	LocateUpgrades()
	$g_bRunState = $wasRunState
EndFunc   ;==>btnLocateUpgrades

Func btnchkbxUpgrade()
	For $i = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If GUICtrlRead($g_hChkUpgrade[$i]) = $GUI_CHECKED Then
			$g_abBuildingUpgradeEnable[$i] = True
		Else
			$g_abBuildingUpgradeEnable[$i] = False
		EndIf
	Next
EndFunc   ;==>btnchkbxUpgrade

Func btnchkbxRepeat()
	For $i = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If GUICtrlRead($g_hChkUpgradeRepeat[$i]) = $GUI_CHECKED Then
			$g_abUpgradeRepeatEnable[$i] = True
		Else
			$g_abUpgradeRepeatEnable[$i] = False
		EndIf
	Next
EndFunc   ;==>btnchkbxRepeat

Func picUpgradeTypeLocation()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	PureClick(1, 40, 1, 0, "#9999") ; Clear screen
	Sleep(100)
	Zoomout() ; Zoom out if needed
	Local $inum
	For $inum = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If @GUI_CtrlId = $g_hPicUpgradeType[$inum] Then
			Local $x = $g_avBuildingUpgrades[$inum][0]
			Local $y = $g_avBuildingUpgrades[$inum][1]
			Local $n = $g_avBuildingUpgrades[$inum][4]
			SetDebugLog("Selecting #" & $inum + 1 & ": " & $n & ", " & $x & "/" & $y)
			If isInsideDiamondXY($x, $y) Then ; check for valid location
				BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1], "#9999")
				Sleep(100)
				If StringInStr($n, "collect", $STR_NOCASESENSEBASIC) Or _
						StringInStr($n, "mine", $STR_NOCASESENSEBASIC) Or _
						StringInStr($n, "drill", $STR_NOCASESENSEBASIC) Then
					Click(1, 40, 1, 0, "#0999") ;Click away to deselect collector if was not full, and collected with previous click
					Sleep(100)
					BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1], "#9999") ;Select collector
				EndIf
			EndIf
			ExitLoop
		EndIf
	Next
	$g_bRunState = $wasRunState
EndFunc   ;==>picUpgradeTypeLocation

Func btnResetUpgrade()
	For $i = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If GUICtrlRead($g_hChkUpgradeRepeat[$i]) = $GUI_CHECKED Then ContinueLoop
		$g_avBuildingUpgrades[$i][0] = -1 ; clear location and loot value in $g_avBuildingUpgrades variable
		$g_avBuildingUpgrades[$i][1] = -1 ; clear location and loot value in $g_avBuildingUpgrades variable
		$g_avBuildingUpgrades[$i][2] = -1 ; clear location and loot value in $g_avBuildingUpgrades variable
		$g_avBuildingUpgrades[$i][3] = "" ;Clear Upgrade Type
		$g_avBuildingUpgrades[$i][4] = "" ;Clear Upgrade Unit Name
		$g_avBuildingUpgrades[$i][5] = "" ;Clear Upgrade Level
		$g_avBuildingUpgrades[$i][6] = "" ;Clear Upgrade Time
		$g_avBuildingUpgrades[$i][7] = "" ;Clear Upgrade Starting Time
		GUICtrlSetData($g_hTxtUpgradeName[$i], "") ; Clear GUI Unit Name
		GUICtrlSetData($g_hTxtUpgradeLevel[$i], "") ; Clear GUI Unit Level
		GUICtrlSetData($g_hTxtUpgradeValue[$i], "") ; Clear Upgrade value in GUI
		GUICtrlSetData($g_hTxtUpgradeTime[$i], "") ; Clear Upgrade time in GUI
		_GUICtrlSetImage($g_hPicUpgradeType[$i], $g_sLibIconPath, $eIcnBlank) ; change GUI upgrade image to blank
		$g_aiPicUpgradeStatus[$i] = $eIcnTroops
		_GUICtrlSetImage($g_hPicUpgradeStatus[$i], $g_sLibIconPath, $g_aiPicUpgradeStatus[$i]) ; Change GUI upgrade status to not ready
		GUICtrlSetState($g_hChkUpgrade[$i], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
		GUICtrlSetData($g_hTxtUpgradeEndTime[$i], "") ; Clear Upgrade time in GUI
		GUICtrlSetState($g_hChkUpgradeRepeat[$i], $GUI_UNCHECKED) ; Change repeat box to unchecked
	Next
EndFunc   ;==>btnResetUpgrade

Func chkLab()
	If GUICtrlRead($g_hChkAutoLabUpgrades) = $GUI_CHECKED Then
		$g_bAutoLabUpgradeEnable = True
		GUICtrlSetState($g_hPicLabUpgrade, $GUI_SHOW)
		GUICtrlSetState($g_hLblNextUpgrade, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbLaboratory, $GUI_ENABLE)
		;GUICtrlSetState($g_hBtnLocateLaboratory, $GUI_SHOW)
		_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[$g_iCmbLaboratory][4])
	Else
		$g_bAutoLabUpgradeEnable = False
		GUICtrlSetState($g_hPicLabUpgrade, $GUI_HIDE)
		GUICtrlSetState($g_hLblNextUpgrade, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbLaboratory, $GUI_DISABLE)
		;GUICtrlSetState($g_hBtnLocateLaboratory, $GUI_HIDE)
		_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[0][4])
	EndIf
	LabStatusGUIUpdate()
EndFunc   ;==>chkLab

Func LabStatusGUIUpdate()
	If _DateIsValid($g_sLabUpgradeTime) Then
		_GUICtrlSetTip($g_hBtnResetLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_06", "Troop Upgrade started") & ", " & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_07", "Will begin to check completion at:") & " " & $g_sLabUpgradeTime & @CRLF & " ")
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_HIDE) ; comment this line out to edit GUI
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>LabStatusGUIUpdate

Func cmbLab()
	$g_iCmbLaboratory = _GUICtrlComboBox_GetCurSel($g_hCmbLaboratory)
	_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[$g_iCmbLaboratory][4])
EndFunc   ;==>cmbLab

Func ResetLabUpgradeTime()
	; Display are you sure message
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	Local $stext = @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_07", "Are you 100% sure you want to reset lab upgrade timer?") & @CRLF & _
			GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_08", "Click OK to reset") & @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_09", "Or Click Cancel to exit") & @CRLF
	Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_10", "Reset timer") & "|" & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_11", "Cancel and Return"), _
							   GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_12", "Reset laboratory upgrade timer?"), $stext, 120, $g_hFrmBot)
	If $g_bDebugSetlog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
	If $MsgBox = 1 Then
		$g_sLabUpgradeTime = ""
		_GUICtrlSetTip($g_hBtnResetLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	EndIf
	If _DateIsValid($g_sLabUpgradeTime) Then
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_HIDE)
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ResetLabUpgradeTime

Func chkUpgradeKing()
	If $g_iTownHallLevel > 6 Then ; Must be TH7 or above to have King
		GUICtrlSetState($g_hChkUpgradeKing, $GUI_ENABLE)
		If GUICtrlRead($g_hChkUpgradeKing) = $GUI_CHECKED Then
			$g_bUpgradeKingEnable = True
			GUICtrlSetState($g_hChkDBKingWait, $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkABKingWait, $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDBKingWait, $GUI_DISABLE)
			GUICtrlSetState($g_hChkABKingWait, $GUI_DISABLE)
			_GUI_Value_STATE("SHOW", $groupKingSleeping)
		Else
			$g_bUpgradeKingEnable = False
			GUICtrlSetState($g_hChkDBKingWait, $GUI_ENABLE)
			GUICtrlSetState($g_hChkABKingWait, $GUI_ENABLE)
			_GUI_Value_STATE("HIDE", $groupKingSleeping)
		EndIf

		If GUICtrlRead($g_hCmbBoostBarbarianKing) > 0 Then
			GUICtrlSetState($g_hChkUpgradeKing, $GUI_DISABLE)
			GUICtrlSetState($g_hChkUpgradeKing, $GUI_UNCHECKED)
			$g_bUpgradeKingEnable = False
		Else
			GUICtrlSetState($g_hChkUpgradeKing, $GUI_ENABLE)
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeKing, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeKing

Func chkUpgradeQueen()
	If $g_iTownHallLevel > 8 Then ; Must be TH9 or above to have Queen
		GUICtrlSetState($g_hChkUpgradeQueen, $GUI_ENABLE)
		If GUICtrlRead($g_hChkUpgradeQueen) = $GUI_CHECKED Then
			$g_bUpgradeQueenEnable = True
			GUICtrlSetState($g_hChkDBQueenWait, $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkABQueenWait, $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDBQueenWait, $GUI_DISABLE)
			GUICtrlSetState($g_hChkABQueenWait, $GUI_DISABLE)
			_GUI_Value_STATE("SHOW", $groupQueenSleeping)
		Else
			$g_bUpgradeQueenEnable = False
			GUICtrlSetState($g_hChkDBQueenWait, $GUI_ENABLE)
			GUICtrlSetState($g_hChkABQueenWait, $GUI_ENABLE)
			_GUI_Value_STATE("HIDE", $groupQueenSleeping)
		EndIf

		If GUICtrlRead($g_hCmbBoostArcherQueen) > 0 Then
			GUICtrlSetState($g_hChkUpgradeQueen, $GUI_DISABLE)
			GUICtrlSetState($g_hChkUpgradeQueen, $GUI_UNCHECKED)
			$g_bUpgradeQueenEnable = False
		Else
			GUICtrlSetState($g_hChkUpgradeQueen, $GUI_ENABLE)
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeQueen, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeQueen

Func chkUpgradeWarden()
	If $g_iTownHallLevel > 10 Then ; Must be TH11 to have warden
		GUICtrlSetState($g_hChkUpgradeWarden, $GUI_ENABLE)
		If GUICtrlRead($g_hChkUpgradeWarden) = $GUI_CHECKED Then
			$g_bUpgradeWardenEnable = True
			GUICtrlSetState($g_hChkDBWardenWait, $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkABWardenWait, $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDBWardenWait, $GUI_DISABLE)
			GUICtrlSetState($g_hChkABWardenWait, $GUI_DISABLE)
			_GUI_Value_STATE("SHOW", $groupWardenSleeping)
		Else
			$g_bUpgradeWardenEnable = False
			GUICtrlSetState($g_hChkDBWardenWait, $GUI_ENABLE)
			GUICtrlSetState($g_hChkABWardenWait, $GUI_ENABLE)
			_GUI_Value_STATE("HIDE", $groupWardenSleeping)
		EndIf

		If GUICtrlRead($g_hCmbBoostWarden) > 0 Then
			GUICtrlSetState($g_hChkUpgradeWarden, $GUI_DISABLE)
			GUICtrlSetState($g_hChkUpgradeWarden, $GUI_UNCHECKED)
			$g_bUpgradeWardenEnable = False
		Else
			GUICtrlSetState($g_hChkUpgradeWarden, $GUI_ENABLE)
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeWarden, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeWarden

Func cmbHeroReservedBuilder()
	$g_iHeroReservedBuilder = _GUICtrlComboBox_GetCurSel($g_hCmbHeroReservedBuilder)
	If $g_iTownHallLevel > 6 Then ; Must be TH7 or above to have Heroes
		If $g_iTownHallLevel > 10 Then ; For TH11 enable up to 3 reserved builders
			GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1|2|3", "0")
		ElseIf $g_iTownHallLevel > 8 Then ; For TH9 enable up to 2 reserved builders
			GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1|2", "0")
		Else ; For TH7 enable up to 1 reserved builder
			GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1", "0")
		EndIf
		GUICtrlSetState($g_hCmbHeroReservedBuilder, $GUI_ENABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderTop, $GUI_ENABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderBottom, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbHeroReservedBuilder, $GUI_DISABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderTop, $GUI_DISABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderBottom, $GUI_DISABLE)
	EndIf
	_GUICtrlComboBox_SetCurSel($g_hCmbHeroReservedBuilder, $g_iHeroReservedBuilder)
EndFunc   ;==>cmbHeroReservedBuilder
	
Func chkWalls()
	If GUICtrlRead($g_hChkWalls) = $GUI_CHECKED Then
		$g_bAutoUpgradeWallsEnable = True
		GUICtrlSetState($g_hRdoUseGold, $GUI_ENABLE)
		; GUICtrlSetState($sldMaxNbWall, $GUI_ENABLE)
		;GUICtrlSetState($sldToleranceWall, $GUI_ENABLE)
		;GUICtrlSetState($g_hBtnFindWalls, $GUI_ENABLE)
		;		GUICtrlSetState($g_hRdoUseElixir, $GUI_ENABLE)
		;		GUICtrlSetState($g_hRdoUseElixirGold, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbWalls, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtWallMinGold, $GUI_ENABLE)
		;		GUICtrlSetState($g_hTxtWallMinElixir, $GUI_ENABLE)
		cmbWalls()
	Else
		$g_bAutoUpgradeWallsEnable = False
		GUICtrlSetState($g_hRdoUseGold, $GUI_DISABLE)
		GUICtrlSetState($g_hRdoUseElixir, $GUI_DISABLE)
		GUICtrlSetState($g_hRdoUseElixirGold, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbWalls, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtWallMinGold, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtWallMinElixir, $GUI_DISABLE)
		; GUICtrlSetState($sldMaxNbWall, $GUI_DISABLE)
		;GUICtrlSetState($sldToleranceWall, $GUI_DISABLE)
		;GUICtrlSetState($g_hBtnFindWalls, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkWalls

Func chkSaveWallBldr()
	$g_bUpgradeWallSaveBuilder = (GUICtrlRead($g_hChkSaveWallBldr) = $GUI_CHECKED)
EndFunc   ;==>chkSaveWallBldr

Func cmbWalls()
	$g_iCmbUpgradeWallsLevel = _GUICtrlComboBox_GetCurSel($g_hCmbWalls)
	$g_iWallCost = $g_aiWallCost[$g_iCmbUpgradeWallsLevel]
	GUICtrlSetData($g_hLblWallCost, _NumberFormat($g_iWallCost))

   For $i = 4 To $g_iCmbUpgradeWallsLevel+5
	  GUICtrlSetState($g_ahWallsCurrentCount[$i], $GUI_SHOW)
	  GUICtrlSetState($g_ahPicWallsLevel[$i], $GUI_SHOW)
   Next
   For $i = $g_iCmbUpgradeWallsLevel+6 To 13
	  GUICtrlSetState($g_ahWallsCurrentCount[$i], $GUI_HIDE)
	  GUICtrlSetState($g_ahPicWallsLevel[$i], $GUI_HIDE)
   Next

   If $g_iCmbUpgradeWallsLevel <= 3 Then GUICtrlSetState($g_hRdoUseGold, $GUI_CHECKED)

   GUICtrlSetState($g_hRdoUseElixir, $g_iCmbUpgradeWallsLevel <= 3 ? $GUI_DISABLE : $GUI_ENABLE)
   GUICtrlSetState($g_hRdoUseElixirGold, $g_iCmbUpgradeWallsLevel <= 3 ? $GUI_DISABLE : $GUI_ENABLE)
   GUICtrlSetState($g_hTxtWallMinElixir, $g_iCmbUpgradeWallsLevel <= 3 ? $GUI_DISABLE : $GUI_ENABLE)
EndFunc   ;==>cmbWalls

Func btnWalls()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	Zoomout()
	$g_iCmbUpgradeWallsLevel = _GUICtrlComboBox_GetCurSel($g_hCmbWalls)
	If imglocCheckWall() Then SetLog("Hei Chef! We found the Wall!")
	$g_bRunState = $wasRunState
	AndroidShield("btnWalls") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnWalls

Func chkAutoUpgrade()
	If GUICtrlRead($g_hChkAutoUpgrade) = $GUI_CHECKED Then
		$g_iChkAutoUpgrade = 1
		For $i = $g_hLblAutoUpgrade To $g_hTxtAutoUpgradeLog
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_iChkAutoUpgrade = 0
		For $i = $g_hLblAutoUpgrade To $g_hTxtAutoUpgradeLog
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkAutoUpgrade

Func chkResourcesToIgnore()
	For $i = 0 To 2
		$g_iChkResourcesToIgnore[$i] = GUICtrlRead($g_hChkResourcesToIgnore[$i]) = $GUI_CHECKED ? 1 : 0
	Next

	Local $iIgnoredResources = 0
	For $i = 0 To 2
		If $g_iChkResourcesToIgnore[$i] = 1 Then $iIgnoredResources += 1
	Next
	Switch $iIgnoredResources
		Case 2
			MsgBox(0 + 16, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Warning_Title", "-1"), _
					GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Warning_Text", "-1"))
		Case 3
			MsgBox(0 + 16, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Invalid_Title", "-1"), _
					GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Invalid_Text", "-1"))
	EndSwitch
EndFunc   ;==>chkResourcesToIgnore

Func chkUpgradesToIgnore()
	For $i = 0 To 12
		$g_iChkUpgradesToIgnore[$i] = GUICtrlRead($g_hChkUpgradesToIgnore[$i]) = $GUI_CHECKED ? 1 : 0
	Next
EndFunc   ;==>chkUpgradesToIgnore
