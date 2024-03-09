; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), Boju (11-2016), MR.ViPER (11-2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func radSelectTrainType()
	If GUICtrlRead($g_hRadCustomTrain) = $GUI_CHECKED Then
		_GUICtrlTab_ClickTab($g_hGUI_TRAINARMY_ARMY_TAB, 0)
		For $i = 0 To 2
			_GUI_Value_STATE("DISABLE", $g_ahChkArmy[$i] & "#" & $g_ahChkUseInGameArmy[$i] & "#" & $g_ahLblEditArmy[$i] & "#" & $g_ahBtnEditArmy[$i])
		Next
		_GUI_Value_STATE("ENABLE", $grpTrainTroops & "#" & $grpCookSpell)
		lblTotalCountTroop1()
		lblTotalCountSpell()
	Else
		_GUICtrlTab_ClickTab($g_hGUI_TRAINARMY_ARMY_TAB, 1)
		_GUI_Value_STATE("ENABLE", $g_ahChkArmy[0] & "#" & $g_ahChkArmy[1] & "#" & $g_ahChkArmy[2])
		For $i = 0 To 2
			_chkQuickTrainArmy($i)
		Next
		_GUI_Value_STATE("DISABLE", $grpTrainTroops & "#" & $grpCookSpell)
		GUICtrlSetData($g_hLblTotalTimeCamp, " 0s")
		GUICtrlSetData($g_hLblTotalTimeSpell, " 0s")
		GUICtrlSetData($g_hLblElixirCostCamp, "0")
		GUICtrlSetData($g_hLblDarkCostCamp, "0")
		GUICtrlSetData($g_hLblElixirCostSpell, "0")
		GUICtrlSetData($g_hLblDarkCostSpell, "0")
	EndIf
	lblTotalCountSiege()
EndFunc   ;==>radSelectTrainType

Func chkQuickTrainArmy()
	For $i = 0 To 2
		If @GUI_CtrlId = $g_ahChkArmy[$i] Then
			_chkQuickTrainArmy($i)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>chkQuickTrainArmy

Func chkQuickTrainCombo()
	If GUICtrlRead($g_ahChkArmy[0]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[1]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[2]) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_ahChkArmy[0], $GUI_CHECKED)
		ToolTip("QuickTrainCombo: " & @CRLF & "At least 1 Army Check is required! Default Army 1.")
		Sleep(2000)
		ToolTip('')
		_chkQuickTrainArmy(0)
	EndIf
EndFunc   ;==>chkQuickTrainCombo

Func _chkQuickTrainArmy($i)
	If GUICtrlRead($g_ahChkArmy[$i]) = $GUI_UNCHECKED Then
		_GUI_Value_STATE("DISABLE", $g_ahChkUseInGameArmy[$i] & "#" & $g_ahLblEditArmy[$i] & "#" & $g_ahBtnEditArmy[$i])
		GUICtrlSetState($g_ahLblUseInGameArmyNote[$i], $GUI_HIDE)
		If GUICtrlRead($g_ahChkArmy[0]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[1]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[2]) = $GUI_UNCHECKED Then chkQuickTrainCombo()
	Else
		_GUI_Value_STATE("ENABLE", $g_ahChkUseInGameArmy[$i] & "#" & $g_ahLblEditArmy[$i] & "#" & $g_ahBtnEditArmy[$i])
		_chkUseInGameArmy($i)
	EndIf
EndFunc   ;==>_chkQuickTrainArmy

Func chkUseInGameArmy()
	For $i = 0 To 2
		If @GUI_CtrlId = $g_ahChkUseInGameArmy[$i] Then
			_chkUseInGameArmy($i)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>chkUseInGameArmy

Func _chkUseInGameArmy($i)
	If GUICtrlRead($g_ahChkUseInGameArmy[$i]) = $GUI_CHECKED Then
		For $j = $g_ahBtnEditArmy[$i] To $g_ahLblQuickSpell[$i][6]
			GUICtrlSetState($j, $GUI_HIDE)
		Next
		GUICtrlSetState($g_ahLblUseInGameArmyNote[$i], $GUI_SHOW)
	Else
		_GUI_Value_STATE("SHOW", $g_ahBtnEditArmy[$i] & "#" & $g_ahLblEditArmy[$i] & "#" & $g_ahLblTotalQTroop[$i] & "#" & $g_ahPicTotalQTroop[$i] & "#" & $g_ahLblTotalQSpell[$i] & "#" & $g_ahPicTotalQSpell[$i])
		GUICtrlSetState($g_ahLblUseInGameArmyNote[$i], $GUI_HIDE)
		For $j = 0 To 6
			If $g_aiQuickTroopType[$i][$j] > -1 Then _GUI_Value_STATE("SHOW", $g_ahPicQuickTroop[$i][$j] & "#" & $g_ahLblQuickTroop[$i][$j])
			If $g_aiQuickSpellType[$i][$j] > -1 Then _GUI_Value_STATE("SHOW", $g_ahPicQuickSpell[$i][$j] & "#" & $g_ahLblQuickSpell[$i][$j])
		Next
		ApplyQuickTrainArmy($i)
	EndIf
EndFunc   ;==>_chkUseInGameArmy

Func SetComboTroopComp()
	$g_iTotalCampSpace = $g_iTotalCampForcedValue
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "SetComboTroopComp")
	Local $ArmyCampTemp = 0

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
		$ArmyCampTemp = Floor(GUICtrlRead($g_hTxtTotalCampForced) * GUICtrlRead($g_hTxtFullTroop) / 100)
	Else
		$ArmyCampTemp = Floor($g_iTotalCampSpace * GUICtrlRead($g_hTxtFullTroop) / 100)
	EndIf

	Local $TotalTroopsToTrain = 0

	lblTotalCountTroop1()
	HideSpellsFctTH()
	lblTotalCountSpell()
	HideSiegesFctTH()
	lblTotalCountSiege()
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "SetComboTroopComp")
EndFunc   ;==>SetComboTroopComp

Func chkTotalCampForced()
	GUICtrlSetState($g_hTxtTotalCampForced, GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkTotalCampForced

Func lblTotalCountTroop1()
	; Calculate count of troops, set progress bars, colors
	Local $TotalTroopsToTrain = 0
	Local $ArmyCampTemp = 0

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
		$ArmyCampTemp = Floor(GUICtrlRead($g_hTxtTotalCampForced) * GUICtrlRead($g_hTxtFullTroop) / 100)
	Else
		$ArmyCampTemp = Floor($g_iTotalCampSpace * GUICtrlRead($g_hTxtFullTroop) / 100)
	EndIf

	RemoveAllTmpTrain("Troop")
	Local $iTmpTroops = 0
	For $i = 0 To $eTroopCount - 1
		Local $iCount = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$i])
		If $iCount > 0 Then
			$TotalTroopsToTrain += $iCount * $g_aiTroopSpace[$i]
			;Set Troop Train Info
			If $iTmpTroops > UBound($g_ahPicTrainArmyTroopTmp) - 1 Then ContinueLoop
			_GUICtrlSetImage($g_ahPicTrainArmyTroopTmp[$iTmpTroops], $g_sLibIconPath, $g_aTroopsIcon[$i])
			GUICtrlSetState($g_ahPicTrainArmyTroopTmp[$iTmpTroops], $GUI_SHOW)
			GUICtrlSetData($g_ahLblTrainArmyTroopTmp[$iTmpTroops], $iCount)
			GUICtrlSetState($g_ahLblTrainArmyTroopTmp[$iTmpTroops], $GUI_SHOW)
			$iTmpTroops += 1
		EndIf
	Next

	GUICtrlSetData($g_hLblCountTotal, String($TotalTroopsToTrain))

	For $i = 0 To $eTroopCount - 1
		If $g_iTotalCampForcedValue > 0 Then GUICtrlSetBkColor($g_ahTxtTrainArmyTroopCount[$i], $TotalTroopsToTrain <= GUICtrlRead($g_hTxtTotalCampForced) ? $COLOR_WHITE : $COLOR_RED)
	Next

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED And GUICtrlRead($g_hLblCountTotal) = GUICtrlRead($g_hTxtTotalCampForced) Then
		GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_GREEN)
	ElseIf GUICtrlRead($g_hLblCountTotal) = $ArmyCampTemp Then
		GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_GREEN)
	ElseIf GUICtrlRead($g_hLblCountTotal) > $ArmyCampTemp / 2 And GUICtrlRead($g_hLblCountTotal) < $ArmyCampTemp Then
		GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_OLIVE)
	Else
		If $g_iTotalCampForcedValue > 0 Then GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_RED)
	EndIf

	Local $fPctOfForced = Floor((GUICtrlRead($g_hLblCountTotal) / GUICtrlRead($g_hTxtTotalCampForced)) * 100)
	Local $fPctOfCalculated = Floor((GUICtrlRead($g_hLblCountTotal) / $ArmyCampTemp) * 100)

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
		GUICtrlSetData($g_hCalTotalTroops, $fPctOfForced < 1 ? (GUICtrlRead($g_hLblCountTotal) > 0 ? 1 : 0) : $fPctOfForced)
	Else
		GUICtrlSetData($g_hCalTotalTroops, $fPctOfCalculated < 1 ? (GUICtrlRead($g_hLblCountTotal) > 0 ? 1 : 0) : $fPctOfCalculated)
	EndIf

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
		If Number(GUICtrlRead($g_hLblCountTotal)) <= Number(GUICtrlRead($g_hTxtTotalCampForced)) Then
			GUICtrlSetState($g_hCalTotalTroops, $GUI_SHOW)
		Else
			GUICtrlSetState($g_hCalTotalTroops, $GUI_HIDE)
		EndIf
	Else
		If Number(GUICtrlRead($g_hLblCountTotal)) >= $ArmyCampTemp Then
			GUICtrlSetState($g_hCalTotalTroops, $GUI_SHOW)
		Else
			GUICtrlSetState($g_hCalTotalTroops, $GUI_HIDE)
		EndIf
	EndIf
	lblTotalCountTroop2()
EndFunc   ;==>lblTotalCountTroop1

Func lblTotalCountTroop2()
	; Calculate time for troops
	Local $TotalTotalTimeTroop = 0

	For $i = 0 To $eTroopCount - 1
		$TotalTotalTimeTroop += $g_aiArmyCustomTroops[$i] * $g_aiTroopTrainTime[$i]
	Next

	$TotalTotalTimeTroop = CalculTimeTo($TotalTotalTimeTroop)
	GUICtrlSetData($g_hLblTotalTimeCamp, $TotalTotalTimeTroop)
EndFunc   ;==>lblTotalCountTroop2

Func lblTotalCountSpell()
	; calculate total space and time for spell composition
	Local $iTotalTotalTimeSpell = 0
	$g_iTotalTrainSpaceSpell = 0

	RemoveAllTmpTrain("Spell")
	Local $iTmpSpells = 0
	For $i = 0 To $eSpellCount - 1
		Local $iCount = GUICtrlRead($g_ahTxtTrainArmySpellCount[$i])
		If $iCount > 0 Then
			$g_iTotalTrainSpaceSpell += $g_aiArmyCustomSpells[$i] * $g_aiSpellSpace[$i]

			;Set Spell Train Info
			If $iTmpSpells > UBound($g_ahPicTrainArmySpellTmp) - 1 Then ContinueLoop
			_GUICtrlSetImage($g_ahPicTrainArmySpellTmp[$iTmpSpells], $g_sLibIconPath, $g_aSpellsIcon[$i])
			GUICtrlSetState($g_ahPicTrainArmySpellTmp[$iTmpSpells], $GUI_SHOW)
			GUICtrlSetData($g_ahLblTrainArmySpellTmp[$iTmpSpells], $iCount)
			GUICtrlSetState($g_ahLblTrainArmySpellTmp[$iTmpSpells], $GUI_SHOW)
			$iTmpSpells += 1
		EndIf
	Next

	For $i = 0 To $eSpellCount - 1
		GUICtrlSetBkColor($g_ahTxtTrainArmySpellCount[$i], $g_iTotalTrainSpaceSpell <= Number(GUICtrlRead($g_hTxtTotalCountSpell)) ? $COLOR_WHITE : $COLOR_RED)
	Next

	GUICtrlSetBkColor($g_hLblCountTotalSpells, $g_iTotalTrainSpaceSpell <= Number(GUICtrlRead($g_hTxtTotalCountSpell)) ? $COLOR_GREEN : $COLOR_RED)

	Local $iSpellProgress = Floor(($g_iTotalTrainSpaceSpell / Number(GUICtrlRead($g_hTxtTotalCountSpell))) * 100)
	If $iSpellProgress <= 100 Then
		GUICtrlSetData($g_hCalTotalSpells, $iSpellProgress)
		GUICtrlSetState($g_hCalTotalSpells, $GUI_SHOW)
	Else
		GUICtrlSetState($g_hCalTotalSpells, $GUI_HIDE)
	EndIf

	If $g_iTotalSpellValue > 0 Then
		If $g_iTotalTrainSpaceSpell = $g_iTotalSpellValue Then
			GUICtrlSetBkColor($g_hLblCountTotalSpells, $COLOR_GREEN)
		ElseIf $g_iTotalTrainSpaceSpell > $g_iTotalSpellValue / 2 Then
			GUICtrlSetBkColor($g_hLblCountTotalSpells, $COLOR_OLIVE)
		Else
			GUICtrlSetBkColor($g_hLblCountTotalSpells, $COLOR_RED)
		EndIf
	EndIf

	GUICtrlSetData($g_hLblCountTotalSpells, String($g_iTotalTrainSpaceSpell))
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountSpell

Func lblTotalCountSpell2()
	; calculate total space and time for spell composition
	Local $iTotalTotalTimeSpell = 0

	For $i = 0 To $eSpellCount - 1
		$iTotalTotalTimeSpell += $g_aiArmyCustomSpells[$i] * $g_aiSpellTrainTime[$i]
	Next

	$iTotalTotalTimeSpell = CalculTimeTo($iTotalTotalTimeSpell)
	GUICtrlSetData($g_hLblTotalTimeSpell, $iTotalTotalTimeSpell)
EndFunc   ;==>lblTotalCountSpell2

Func lblTotalCountSiege()
	; calculate total space and time for Siege composition
	Local $iTotalTotalTimeSiege = 0, $indexLevel = 0
	$g_iTotalTrainSpaceSiege = 0
	RemoveAllTmpTrain("Siege")
	Local $iTmpSieges = 0
	For $i = 0 To $eSiegeMachineCount - 1

		Local $iCount = GUICtrlRead($g_ahTxtTrainArmySiegeCount[$i])
		If $iCount > 0 Then
			$g_iTotalTrainSpaceSiege += $g_aiArmyCompSiegeMachines[$i] * $g_aiSiegeMachineSpace[$i]

			;Set Siege Train Info
			If $iTmpSieges > UBound($g_ahPicTrainArmySiegeTmp) - 1 Then ContinueLoop
			_GUICtrlSetImage($g_ahPicTrainArmySiegeTmp[$iTmpSieges], $g_sLibIconPath, $g_aSiegesIcon[$i])
			GUICtrlSetState($g_ahPicTrainArmySiegeTmp[$iTmpSieges], $GUI_SHOW)
			GUICtrlSetData($g_ahLblTrainArmySiegeTmp[$iTmpSieges], $iCount)
			GUICtrlSetState($g_ahLblTrainArmySiegeTmp[$iTmpSieges], $GUI_SHOW)
			$iTmpSieges += 1
		EndIf
	Next

	For $i = 0 To $eSiegeMachineCount - 1
		If ($g_iTotalTrainSpaceSiege <= 3) Then
			GUICtrlSetBkColor($g_ahTxtTrainArmySiegeCount[$i], $COLOR_WHITE)
		Else
			GUICtrlSetBkColor($g_ahTxtTrainArmySiegeCount[$i], $COLOR_RED)
		EndIf
	Next
EndFunc   ;==>lblTotalCountSiege

Func HideSiegesFctTH()
	$g_iTownHallLevel = Int($g_iTownHallLevel)
	$g_iTotalTrainSpaceSiege = 0
	_GUI_Value_STATE("DISABLE", $groupListSieges)

	If $g_iTownHallLevel > 11 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupWallWrecker)
		_GUI_Value_STATE("ENABLE", $groupBattleBlimp)
		_GUI_Value_STATE("ENABLE", $groupStoneSlammer)
	Else
		For $i = 0 To $eSiegeMachineCount - 1
			GUICtrlSetData($g_ahTxtTrainArmySiegeCount[$i], 0)
		Next
		$g_iTotalTrainSpaceSiege = 0
	EndIf

	If $g_iTownHallLevel > 12 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupSiegeBarracks)
		_GUI_Value_STATE("ENABLE", $groupLogLauncher)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySiegeCount[$eSiegeFlameFlinger], 0)
		GUICtrlSetData($g_ahTxtTrainArmySiegeCount[$eSiegeBattleDrill], 0)
	EndIf

	If $g_iTownHallLevel > 13 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupFlameFlinger)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySiegeCount[$eSiegeBattleDrill], 0)
	EndIf

	If $g_iTownHallLevel > 14 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupBattleDrill)
	EndIf

	For $i = 0 To $eSiegeMachineCount - 1
		GUICtrlSetData($g_aiArmyCompSiegeMachines[$i], GUICtrlRead($g_ahTxtTrainArmySiegeCount[$i]))
	Next

EndFunc   ;==>HideSiegesFctTH

Func HideSpellsFctTH()
	_GUI_Value_STATE("DISABLE", $groupListSpells)
	$g_iTownHallLevel = Int($g_iTownHallLevel)

	If $g_iTownHallLevel > 4 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupLightning)
	Else
		For $i = 0 To $eSpellCount - 1
			GUICtrlSetData($g_ahTxtTrainArmySpellCount[$i], 0)
		Next
		GUICtrlSetData($g_hTxtTotalCountSpell, 0)
	EndIf

	If $g_iTownHallLevel > 5 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupHeal)
	Else
		For $i = $eSpellRage To $eSpellOvergrowth
			GUICtrlSetData($g_ahTxtTrainArmySpellCount[$i], 0)
		Next
	EndIf

	If $g_iTownHallLevel > 6 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupRage)
	Else
		For $i = $eSpellJump To $eSpellOvergrowth
			GUICtrlSetData($g_ahTxtTrainArmySpellCount[$i], 0)
		Next
	EndIf

	If $g_iTownHallLevel > 7 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupPoison)
		_GUI_Value_STATE("ENABLE", $groupEarthquake)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellJump], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellFreeze], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellClone], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellInvisibility], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellRecall], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellHaste], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellSkeleton], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellBat], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellOvergrowth], 0)
	EndIf

	If $g_iTownHallLevel > 8 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupJump)
		_GUI_Value_STATE("ENABLE", $groupFreeze)
		_GUI_Value_STATE("ENABLE", $groupHaste)
		_GUI_Value_STATE("ENABLE", $groupSkeleton)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellClone], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellBat], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellInvisibility], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellRecall], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellOvergrowth], 0)
	EndIf

	If $g_iTownHallLevel > 9 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupClone)
		_GUI_Value_STATE("ENABLE", $groupBat)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellInvisibility], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellRecall], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellOvergrowth], 0)
	EndIf

	If $g_iTownHallLevel > 10 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupInvisibility)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellRecall], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellOvergrowth], 0)
	EndIf

	If $g_iTownHallLevel > 11 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupOvergrowth)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellRecall], 0)
	EndIf

	If $g_iTownHallLevel > 12 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupRecall)
	EndIf

EndFunc   ;==>HideSpellsFctTH

Func chkBoostBarracksHoursE1()
	If GUICtrlRead($g_hChkBoostBarracksHoursE1) = $GUI_CHECKED And GUICtrlRead($g_hChkBoostBarracksHours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_hChkBoostBarracksHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_hChkBoostBarracksHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkBoostBarracksHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE1

Func chkBoostBarracksHoursE2()
	If GUICtrlRead($g_hChkBoostBarracksHoursE2) = $GUI_CHECKED And GUICtrlRead($g_hChkBoostBarracksHours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_hChkBoostBarracksHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_hChkBoostBarracksHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkBoostBarracksHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE2

Func chkCloseWaitEnable()
	If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then
		$g_bCloseWhileTrainingEnable = True
		_GUI_Value_STATE("ENABLE", $groupCloseWhileTraining)
		_GUI_Value_STATE("ENABLE", $g_hLblCloseWaitingTroops & "#" & $g_hCmbMinimumTimeClose & "#" & $g_hLblSymbolWaiting & "#" & $g_hLblWaitingInMinutes)
	Else
		$g_bCloseWhileTrainingEnable = False
		_GUI_Value_STATE("DISABLE", $groupCloseWhileTraining)
		_GUI_Value_STATE("DISABLE", $g_hLblCloseWaitingTroops & "#" & $g_hCmbMinimumTimeClose & "#" & $g_hLblSymbolWaiting & "#" & $g_hLblWaitingInMinutes)
	EndIf
	If GUICtrlRead($g_hChkRandomClose) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkCloseEmulator, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($g_hChkSuspendComputer, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then
			GUICtrlSetState($g_hChkCloseEmulator, $GUI_ENABLE)
			GUICtrlSetState($g_hChkSuspendComputer, $GUI_ENABLE)
		EndIf
	EndIf
EndFunc   ;==>chkCloseWaitEnable

Func chkCloseWaitTrain()
	$g_bCloseWithoutShield = (GUICtrlRead($g_hChkCloseWithoutShield) = $GUI_CHECKED)
EndFunc   ;==>chkCloseWaitTrain

Func btnCloseWaitStop()
	$g_bCloseEmulator = (GUICtrlRead($g_hChkCloseEmulator) = $GUI_CHECKED)
EndFunc   ;==>btnCloseWaitStop

Func btnCloseWaitSuspendComputer()
	$g_bSuspendComputer = (GUICtrlRead($g_hChkSuspendComputer) = $GUI_CHECKED)
EndFunc   ;==>btnCloseWaitSuspendComputer

Func btnCloseWaitStopRandom()
	If GUICtrlRead($g_hChkRandomClose) = $GUI_CHECKED Then
		$g_bCloseRandom = True
		$g_bCloseEmulator = False
		$g_bSuspendComputer = False
		GUICtrlSetState($g_hChkCloseEmulator, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($g_hChkSuspendComputer, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		$g_bCloseRandom = False
		If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then
			GUICtrlSetState($g_hChkCloseEmulator, $GUI_ENABLE)
			GUICtrlSetState($g_hChkSuspendComputer, $GUI_ENABLE)
		EndIf
	EndIf
EndFunc   ;==>btnCloseWaitStopRandom

Func btnCloseWaitRandom()
	If GUICtrlRead($g_hRdoCloseWaitExact) = $GUI_CHECKED Then
		$g_bCloseExactTime = True
		$g_bCloseRandomTime = False
		GUICtrlSetState($g_hCmbCloseWaitRdmPercent, $GUI_DISABLE)
	ElseIf GUICtrlRead($g_hRdoCloseWaitRandom) = $GUI_CHECKED Then
		$g_bCloseExactTime = False
		$g_bCloseRandomTime = True
		If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then GUICtrlSetState($g_hCmbCloseWaitRdmPercent, $GUI_ENABLE)
	Else
		$g_bCloseExactTime = False
		$g_bCloseRandomTime = False
		GUICtrlSetState($g_hCmbCloseWaitRdmPercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnCloseWaitRandom

Func sldTrainITDelay()
	$g_iTrainClickDelay = GUICtrlRead($g_hSldTrainITDelay)
	GUICtrlSetData($g_hLblTrainITDelayTime, $g_iTrainClickDelay & " ms")
EndFunc   ;==>sldTrainITDelay

Func chkTroopOrder2()
	;GUI OnEvent functions cannot have parameters, so below call is used for the default parameter
	chkTroopOrder()
EndFunc   ;==>chkTroopOrder2

Func chkTroopOrder($bSetLog = True)
	If GUICtrlRead($g_hChkCustomTrainOrderEnable) = $GUI_CHECKED Then
		$g_bCustomTrainOrderEnable = True
		GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnRemoveTroops, $GUI_ENABLE)
		For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
			GUICtrlSetState($g_ahCmbTroopOrder[$i], $GUI_ENABLE)
		Next
		If IsUseCustomTroopOrder() = True Then _GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight)
	Else
		$g_bCustomTrainOrderEnable = False
		GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_DISABLE) ; disable button
		GUICtrlSetState($g_hBtnRemoveTroops, $GUI_DISABLE)
		For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
			GUICtrlSetState($g_ahCmbTroopOrder[$i], $GUI_DISABLE) ; disable combo boxes
		Next
		SetDefaultTroopGroup($bSetLog) ; Reset troopgroup values to default
		If ($bSetLog Or $g_bDebugSetlogTrain) And $g_bCustomTrainOrderEnable Then
			Local $sNewTrainList = ""
			For $i = 0 To $eTroopCount - 1
				$sNewTrainList &= $g_asTroopShortNames[$g_aiTrainOrder[$i]] & ", "
			Next
			$sNewTrainList = StringTrimRight($sNewTrainList, 2)
			SetLog("Current train order= " & $sNewTrainList, $COLOR_INFO)
		EndIf
	EndIf
EndFunc   ;==>chkTroopOrder

Func chkSpellsOrder()
	If GUICtrlRead($g_hChkCustomBrewOrderEnable) = $GUI_CHECKED Then
		$g_bCustomBrewOrderEnable = True
		For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1
			GUICtrlSetState($g_ahCmbSpellsOrder[$i], $GUI_ENABLE)
		Next
		GUICtrlSetState($g_hBtnRemoveSpells, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnSpellsOrderSet, $GUI_ENABLE)
		If IsUseCustomSpellsOrder() = True Then _GUICtrlSetImage($g_ahImgSpellsOrderSet, $g_sLibIconPath, $eIcnRedLight)
	Else
		$g_bCustomBrewOrderEnable = False
		For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1
			GUICtrlSetState($g_ahCmbSpellsOrder[$i], $GUI_DISABLE)
		Next
		GUICtrlSetState($g_hBtnRemoveSpells, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnSpellsOrderSet, $GUI_DISABLE)
		SetDefaultSpellsGroup(False)
	EndIf

EndFunc   ;==>chkSpellsOrder

Func GUISpellsOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1 ; record control ID for $g_ahImgTroopOrder[$z] based on control of combobox that called this function
	Local $iSpellsIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1 ; find zero based index number of Spell selected in combo box, add one for enum of proper icon

	_GUICtrlSetImage($iCtrlIdImage, $g_sLibIconPath, $g_aiSpellsOrderIcon[$iSpellsIndex]) ; set proper Spell icon

	For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $g_ahCmbSpellsOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbSpellsOrder[$i]) Then
			_GUICtrlSetImage($g_ahImgSpellsOrder[$i], $g_sLibIconPath, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($g_ahCmbSpellsOrder[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next

	If $bDuplicate Then
		GUICtrlSetState($g_hBtnSpellsOrderSet, $GUI_ENABLE) ; enable button to apply new order
		_GUICtrlSetImage($g_ahImgSpellsOrderSet, $g_sLibIconPath, $eIcnRedLight) ; set status indicator to show need to apply new order
		Return
	Else
		GUICtrlSetState($g_hBtnSpellsOrderSet, $GUI_ENABLE) ; enable button to apply new order
	EndIf
EndFunc   ;==>GUISpellsOrder

Func BtnRemoveSpells()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "BtnRemoveSpells")
	Local $sComboData = ""
	For $j = 0 To UBound($g_asSpellsOrderList) - 1
		$sComboData &= $g_asSpellsOrderList[$j] & "|"
	Next
	For $i = 0 To $eSpellCount - 1
		$g_aiCmbCustomBrewOrder[$i] = -1
		_GUICtrlComboBox_ResetContent($g_ahCmbSpellsOrder[$i])
		GUICtrlSetData($g_ahCmbSpellsOrder[$i], $sComboData, "")
		_GUICtrlSetImage($g_ahImgSpellsOrder[$i], $g_sLibIconPath, $eIcnOptions)
	Next
	_GUICtrlSetImage($g_ahImgSpellsOrderSet, $g_sLibIconPath, $eIcnSilverStar)
	SetDefaultSpellsGroup(False)
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "BtnRemoveSpells")
EndFunc   ;==>BtnRemoveSpells

Func GUITrainOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1 ; record control ID for $g_ahImgTroopOrder[$z] based on control of combobox that called this function
	Local $iTroopIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1 ; find zero based index number of troop selected in combo box, add one for enum of proper icon

	_GUICtrlSetImage($iCtrlIdImage, $g_sLibIconPath, $g_aiTroopOrderIcon[$iTroopIndex]) ; set proper troop icon

	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $g_ahCmbTroopOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$i]) Then
			_GUICtrlSetImage($g_ahImgTroopOrder[$i], $g_sLibIconPath, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($g_ahCmbTroopOrder[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next
	If $bDuplicate Then
		GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_ENABLE) ; enable button to apply new order
		_GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight) ; set status indicator to show need to apply new order
		Return
	Else
		GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_ENABLE) ; enable button to apply new order
	EndIf
EndFunc   ;==>GUITrainOrder

Func BtnRemoveTroops()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "BtnRemoveTroops")
	Local $sComboData = ""
	For $j = 0 To UBound($g_asTroopOrderList) - 1
		$sComboData &= $g_asTroopOrderList[$j] & "|"
	Next
	For $i = $eTroopBarbarian To $eTroopCount - 1
		$g_aiCmbCustomTrainOrder[$i] = -1
		_GUICtrlComboBox_ResetContent($g_ahCmbTroopOrder[$i])
		GUICtrlSetData($g_ahCmbTroopOrder[$i], $sComboData, "")
		_GUICtrlSetImage($g_ahImgTroopOrder[$i], $g_sLibIconPath, $eIcnOptions)
	Next
	_GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnSilverStar)
	SetDefaultTroopGroup(False)
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "BtnRemoveTroops")
EndFunc   ;==>BtnRemoveTroops

Func BtnSpellsOrderSet()

	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "BtnSpellsOrderSet")
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewTrainList = ""

	Local $bMissingTroop = False ; flag for when troops are not assigned by user
	Local $aiBrewOrder[$eSpellCount] = [ _
			$eSpellLightning, $eSpellHeal, $eSpellRage, $eSpellJump, $eSpellFreeze, $eSpellClone, _
			$eSpellInvisibility, $eSpellRecall, $eSpellPoison, $eSpellEarthquake, $eSpellHaste, $eSpellSkeleton, $eSpellBat, $eSpellOvergrowth]

	; check for duplicate combobox index and take action
	For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1
		For $j = 0 To UBound($g_ahCmbSpellsOrder) - 1
			If $i = $j Then ContinueLoop ; skip if index are same
			If _GUICtrlComboBox_GetCurSel($g_ahCmbSpellsOrder[$i]) <> -1 And _
					_GUICtrlComboBox_GetCurSel($g_ahCmbSpellsOrder[$i]) = _GUICtrlComboBox_GetCurSel($g_ahCmbSpellsOrder[$j]) Then
				_GUICtrlComboBox_SetCurSel($g_ahCmbSpellsOrder[$j], -1)
				_GUICtrlSetImage($g_ahImgSpellsOrder[$j], $g_sLibIconPath, $eIcnOptions)
				$bReady = False
			Else
				GUICtrlSetColor($g_ahCmbSpellsOrder[$j], $COLOR_BLACK)
			EndIf
		Next
		; update combo array variable with new value
		$g_aiCmbCustomBrewOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbSpellsOrder[$i])
		If $g_aiCmbCustomBrewOrder[$i] = -1 Then $bMissingTroop = True ; check if combo box slot that is not assigned a troop
	Next

	; Automatic random fill missing troops
	If $bReady And $bMissingTroop Then
		; 1st update $aiUsedTroop array with troops not used in $g_aiCmbCustomTrainOrder
		For $i = 0 To UBound($g_aiCmbCustomBrewOrder) - 1
			For $j = 0 To UBound($aiBrewOrder) - 1
				If $g_aiCmbCustomBrewOrder[$i] = $j Then
					$aiBrewOrder[$j] = -1 ; if troop is used, replace enum value with -1
					ExitLoop
				EndIf
			Next
		Next
		_ArrayShuffle($aiBrewOrder) ; make missing training order assignment random
		For $i = 0 To UBound($g_aiCmbCustomBrewOrder) - 1
			If $g_aiCmbCustomBrewOrder[$i] = -1 Then ; check if custom order index is not set
				For $j = 0 To UBound($aiBrewOrder) - 1
					If $aiBrewOrder[$j] <> -1 Then ; loop till find a valid troop enum
						$g_aiCmbCustomBrewOrder[$i] = $aiBrewOrder[$j] ; assign unused troop
						_GUICtrlComboBox_SetCurSel($g_ahCmbSpellsOrder[$i], $aiBrewOrder[$j])
						_GUICtrlSetImage($g_ahImgSpellsOrder[$i], $g_sLibIconPath, $g_aiSpellsOrderIcon[$g_aiCmbCustomBrewOrder[$i] + 1])
						$aiBrewOrder[$j] = -1 ; remove unused troop from array
						ExitLoop
					EndIf
				Next
			EndIf
		Next
	EndIf

	If $bReady Then
		ChangeSpellsBrewOrder() ; code function to record new training order
		If @error Then
			Switch @error
				Case 1
					SetLog("Code problem, can not continue till fixed!", $COLOR_ERROR)
				Case 2
					SetLog("Bad Combobox selections, please fix!", $COLOR_ERROR)
				Case 3
					SetLog("Unable to Change Spells Brew Order due bad change count!", $COLOR_ERROR)
				Case Else
					SetLog("Monkey ate bad banana, something wrong with ChangeSpellsBrewOrder() code!", $COLOR_ERROR)
			EndSwitch
			_GUICtrlSetImage($g_ahImgSpellsOrderSet, $g_sLibIconPath, $eIcnRedLight)
		Else
			SetLog("Spells Brew order changed successfully!", $COLOR_SUCCESS)
			For $i = 0 To $eSpellCount - 1
				$sNewTrainList &= $g_asSpellShortNames[$g_aiBrewOrder[$i]] & ", "
			Next
			$sNewTrainList = StringTrimRight($sNewTrainList, 2)
			SetLog("Spells Brew order= " & $sNewTrainList, $COLOR_INFO)
		EndIf
	Else
		SetLog("Must use all Spells and No duplicate troop names!", $COLOR_ERROR)
		_GUICtrlSetImage($g_ahImgSpellsOrderSet, $g_sLibIconPath, $eIcnRedLight)
	EndIf
	;	GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_DISABLE)
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "BtnSpellsOrderSet")

EndFunc   ;==>BtnSpellsOrderSet

Func BtnTroopOrderSet()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "BtnTroopOrderSet")
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewTrainList = ""

	Local $aiUsedTroop = $g_aiTrainOrder
	Local $aTmpTrainOrder[0], $iStartShuffle = 0

	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
		Local $iValue = _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$i])
		If $iValue <> -1 Then
			_ArrayAdd($aTmpTrainOrder, $iValue)
			Local $iEmpty = _ArraySearch($aiUsedTroop, $iValue)
			If $iEmpty > -1 Then $aiUsedTroop[$iEmpty] = -1
		EndIf
	Next

	$iStartShuffle = UBound($aTmpTrainOrder)

	_ArraySort($aiUsedTroop)

	For $i = 0 To UBound($aTmpTrainOrder) - 1
		If $aiUsedTroop[$i] = -1 Then $aiUsedTroop[$i] = $aTmpTrainOrder[$i]
	Next

	_ArrayShuffle($aiUsedTroop, $iStartShuffle)

	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
		_GUICtrlComboBox_SetCurSel($g_ahCmbTroopOrder[$i], $aiUsedTroop[$i])
		_GUICtrlSetImage($g_ahImgTroopOrder[$i], $g_sLibIconPath, $g_aiTroopOrderIcon[$aiUsedTroop[$i] + 1])
	Next

	$g_aiCmbCustomTrainOrder = $aiUsedTroop
	If $bReady Then
		ChangeTroopTrainOrder() ; code function to record new training order
		If @error Then
			Switch @error
				Case 1
					SetLog("Code problem, can not continue till fixed!", $COLOR_ERROR)
				Case 2
					SetLog("Bad Combobox selections, please fix!", $COLOR_ERROR)
				Case 3
					SetLog("Unable to Change Troop Train Order due bad change count!", $COLOR_ERROR)
				Case Else
					SetLog("Monkey ate bad banana, something wrong with ChangeTroopTrainOrder() code!", $COLOR_ERROR)
			EndSwitch
			_GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight)
		Else
			SetLog("Troop training order changed successfully!", $COLOR_SUCCESS)
			For $i = 0 To $eTroopCount - 1
				If $g_bDebugSetlogTrain Then SetLog("i = " & $i & " g_aiTrainOrder = " & $aiUsedTroop[$i])
				$sNewTrainList &= $g_asTroopShortNames[$aiUsedTroop[$i]] & ", "
			Next
			$sNewTrainList = StringTrimRight($sNewTrainList, 2)
			SetLog("Troop train order= " & $sNewTrainList, $COLOR_INFO)
		EndIf
	Else
		SetLog("Must use all troops and No duplicate troop names!", $COLOR_ERROR)
		_GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight)
	EndIf
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "BtnTroopOrderSet")
EndFunc   ;==>BtnTroopOrderSet

Func ChangeSpellsBrewOrder()
	If $g_bDebugSetlog Or $g_bDebugSetlogTrain Then SetLog("Begin Func ChangeSpellsBrewOrder()", $COLOR_DEBUG) ;Debug

	Local $NewTroopOrder[$eSpellCount]
	Local $iUpdateCount = 0

	If Not IsUseCustomSpellsOrder() Then ; check if no custom troop values saved yet.
		SetError(2, 0, False)
		Return
	EndIf

	; Look for match of combobox text to troopgroup and create new train order
	For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1
		Local $sComboText = GUICtrlRead($g_ahCmbSpellsOrder[$i])
		For $j = 0 To UBound($g_asSpellsOrderList) - 1
			If $sComboText = $g_asSpellsOrderList[$j] Then
				$NewTroopOrder[$i] = $j - 1
				$iUpdateCount += 1
				ExitLoop
			EndIf
		Next
	Next

	If $iUpdateCount = $eSpellCount Then ; safety check that all troops properly assigned to new array.
		For $i = 0 To $eSpellCount - 1
			$g_aiBrewOrder[$i] = $NewTroopOrder[$i]
		Next
		_GUICtrlSetImage($g_ahImgSpellsOrderSet, $g_sLibIconPath, $eIcnGreenLight)
	Else
		SetLog($iUpdateCount & "|" & $eSpellCount & " - Error - Bad Spells assignment in ChangeSpellsBrewOrder()", $COLOR_ERROR)
		SetError(3, 0, False)
		Return
	EndIf

	Return True

EndFunc   ;==>ChangeSpellsBrewOrder

Func ChangeTroopTrainOrder()

	If $g_bDebugSetlog Or $g_bDebugSetlogTrain Then SetLog("Begin Func ChangeTroopTrainOrder()", $COLOR_DEBUG) ;Debug

	Local $NewTroopOrder[$eTroopCount]
	Local $iUpdateCount = 0

	If Not IsUseCustomTroopOrder() Then ; check if no custom troop values saved yet.
		SetError(2, 0, False)
		Return
	EndIf

	; Look for match of combobox text to troopgroup and create new train order
	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
		Local $sComboText = GUICtrlRead($g_ahCmbTroopOrder[$i])
		For $j = 0 To UBound($g_asTroopOrderList) - 1
			If $sComboText = $g_asTroopOrderList[$j] Then
				$NewTroopOrder[$i] = $j - 1
				$iUpdateCount += 1
				ExitLoop
			EndIf
		Next
	Next

	If $iUpdateCount = $eTroopCount Then ; safety check that all troops properly assigned to new array.
		For $i = 0 To $eTroopCount - 1
			$g_aiTrainOrder[$i] = $NewTroopOrder[$i]
		Next
		_GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnGreenLight)
	Else
		SetLog($iUpdateCount & "|" & $eTroopCount & " - Error - Bad troop assignment in ChangeTroopTrainOrder()", $COLOR_ERROR)
		SetError(3, 0, False)
		Return
	EndIf

	Return True
EndFunc   ;==>ChangeTroopTrainOrder

Func SetDefaultTroopGroup($bSetLog = True)
	For $i = 0 To $eTroopCount - 1
		$g_aiTrainOrder[$i] = $i
	Next

	If ($bSetLog Or $g_bDebugSetlogTrain) And $g_bCustomTrainOrderEnable Then SetLog("Default troop training order set", $COLOR_SUCCESS)
EndFunc   ;==>SetDefaultTroopGroup

Func SetDefaultSpellsGroup($bSetLog = True)
	For $i = 0 To $eSpellCount - 1
		$g_aiBrewOrder[$i] = $i
	Next

	If ($bSetLog Or $g_bDebugSetlogTrain) And $g_bCustomTrainOrderEnable Then SetLog("Default Spells Brew order set", $COLOR_SUCCESS)
EndFunc   ;==>SetDefaultSpellsGroup

Func IsUseCustomSpellsOrder()
	For $i = 0 To UBound($g_aiCmbCustomBrewOrder) - 1 ; Check if custom train order has been used, to select log message
		If $g_aiCmbCustomBrewOrder[$i] = -1 Then
			If $g_bDebugSetlogTrain And $g_bCustomBrewOrderEnable Then SetLog("Custom Spell order not used...", $COLOR_DEBUG) ;Debug
			Return False
		EndIf
	Next
	If $g_bDebugSetlogTrain And $g_bCustomBrewOrderEnable Then SetLog("Custom Spell order used...", $COLOR_DEBUG) ;Debug
	Return True
EndFunc   ;==>IsUseCustomSpellsOrder

Func IsUseCustomTroopOrder()
	For $i = 0 To UBound($g_aiCmbCustomTrainOrder) - 1 ; Check if custom train order has been used, to select log message
		If $g_aiCmbCustomTrainOrder[$i] = -1 Then
			If $g_bDebugSetlogTrain And $g_bCustomTrainOrderEnable Then SetLog("Custom train order not used...", $COLOR_DEBUG) ;Debug
			Return False
		EndIf
	Next
	If $g_bDebugSetlogTrain And $g_bCustomTrainOrderEnable Then SetLog("Custom train order used...", $COLOR_DEBUG) ;Debug
	Return True
EndFunc   ;==>IsUseCustomTroopOrder

Func CalculTimeTo($TotalTotalTime)
	Local $HourToTrain = 0
	Local $MinToTrain = 0
	Local $SecToTrain = 0
	Local $TotalTotalTimeTo
	If $TotalTotalTime >= 3600 Then
		$HourToTrain = Int($TotalTotalTime / 3600)
		$MinToTrain = Int(($TotalTotalTime - $HourToTrain * 3600) / 60)
		$SecToTrain = $TotalTotalTime - $HourToTrain * 3600 - $MinToTrain * 60
		$TotalTotalTimeTo = " " & $HourToTrain & "h " & $MinToTrain & "m " & $SecToTrain & "s"
	ElseIf $TotalTotalTime < 3600 And $TotalTotalTime >= 60 Then
		$MinToTrain = Int(($TotalTotalTime - $HourToTrain * 3600) / 60)
		$SecToTrain = $TotalTotalTime - $HourToTrain * 3600 - $MinToTrain * 60
		$TotalTotalTimeTo = " " & $MinToTrain & "m " & $SecToTrain & "s"
	Else
		$SecToTrain = $TotalTotalTime
		$TotalTotalTimeTo = " " & $SecToTrain & "s"
	EndIf
	Return $TotalTotalTimeTo
EndFunc   ;==>CalculTimeTo

Func Removecamp()
	For $T = 0 To $eTroopCount - 1
		$g_aiArmyCustomTroops[$T] = 0
		GUICtrlSetData($g_ahTxtTrainArmyTroopCount[$T], $g_aiArmyCustomTroops[$T])
		GUICtrlSetBkColor($g_ahTxtTrainArmyTroopCount[$T], $COLOR_WHITE)
	Next
	For $S = 0 To $eSpellCount - 1
		$g_aiArmyCustomSpells[$S] = 0
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$S], $g_aiArmyCustomSpells[$S])
		GUICtrlSetBkColor($g_ahTxtTrainArmyTroopCount[$S], $COLOR_WHITE)
	Next
	For $S = 0 To $eSiegeMachineCount - 1
		$g_aiArmyCompSiegeMachines[$S] = 0
		GUICtrlSetData($g_ahTxtTrainArmySiegeCount[$S], $g_aiArmyCompSiegeMachines[$S])
		GUICtrlSetBkColor($g_ahTxtTrainArmySiegeCount[$S], $COLOR_WHITE)
	Next

	RemoveAllTmpTrain("All")

	GUICtrlSetData($g_hCalTotalTroops, 0)
	GUICtrlSetData($g_hCalTotalSpells, 0)
	GUICtrlSetData($g_hLblTotalTimeCamp, " 0s")
	GUICtrlSetData($g_hLblTotalTimeSpell, " 0s")
	GUICtrlSetData($g_hLblElixirCostCamp, "0")
	GUICtrlSetData($g_hLblDarkCostCamp, "0")
	GUICtrlSetData($g_hLblElixirCostSpell, "0")
	GUICtrlSetData($g_hLblDarkCostSpell, "0")
	GUICtrlSetData($g_hLblCountTotal, 0)
	GUICtrlSetData($g_hLblCountTotalSpells, 0)
	GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_RED)
	GUICtrlSetBkColor($g_hLblCountTotalSpells, $COLOR_RED)
EndFunc   ;==>Removecamp

Func TrainTroopCountEdit()
	For $i = 0 To $eTroopCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainArmyTroopCount[$i] Then
			$g_aiArmyCustomTroops[$i] = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$i])
			lblTotalCountTroop1()
			Return
		EndIf
	Next
EndFunc   ;==>TrainTroopCountEdit

Func TrainSiegeCountEdit()
	For $i = 0 To $eSiegeMachineCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainArmySiegeCount[$i] Then
			$g_aiArmyCompSiegeMachines[$i] = GUICtrlRead($g_ahTxtTrainArmySiegeCount[$i])
			lblTotalCountSiege()
			Return
		EndIf
	Next
EndFunc   ;==>TrainSiegeCountEdit

Func TrainSpellCountEdit()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainArmySpellCount[$i] Then
			$g_aiArmyCustomSpells[$i] = GUICtrlRead($g_ahTxtTrainArmySpellCount[$i])
			lblTotalCountSpell()
			Return
		EndIf
	Next
EndFunc   ;==>TrainSpellCountEdit

Func chkAddDelayIdlePhaseEnable()
	$g_bTrainAddRandomDelayEnable = (GUICtrlRead($g_hChkTrainAddRandomDelayEnable) = $GUI_CHECKED)

	For $i = $g_hLblAddDelayIdlePhaseBetween To $g_hLblAddDelayIdlePhaseSec
		GUICtrlSetState($i, $g_bTrainAddRandomDelayEnable ? $GUI_ENABLE : $GUI_DISABLE)
	Next
EndFunc   ;==>chkAddDelayIdlePhaseEnable

#Region QuickTrain
Func EditQuickTrainArmy()
	If $g_bRunState Then Return
	If $g_bRunState Or $g_iQuickTrainEdit > -1 Then
		Local $sMessage = $g_bRunState ? ("Bot is running" & @CRLF & "Please stop the bot completely and try again") : ("Edit window for Army " & $g_iQuickTrainEdit + 1 & " is currently open" & @CRLF & "Please exit and try again")
		ToolTip("EditQuickTrainArmy: " & @CRLF & $sMessage)
		Sleep(2000)
		ToolTip('')
		Return
	EndIf
	For $i = 0 To 2
		If @GUI_CtrlId = $g_ahBtnEditArmy[$i] Then
			$g_iQuickTrainEdit = $i
			_EditQuickTrainArmy($i)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>EditQuickTrainArmy

Func _EditQuickTrainArmy($i)
	GUISetState(@SW_SHOW, $g_hGUI_QuickTrainEdit)
	GUICtrlSetData($g_hGrp_QTEdit, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "GUI_QuickTrainEdit", "Edit troops and spells for quick train") & " Army " & $i + 1)
	For $j = 0 To 6
		$g_aiQTEdit_TroopType[$j] = $g_aiQuickTroopType[$i][$j]
		$g_aiQTEdit_SpellType[$j] = $g_aiQuickSpellType[$i][$j]

		If $g_aiQTEdit_TroopType[$j] > -1 Then
			_GUICtrlSetImage($g_ahPicQTEdit_Troop[$j], $g_sLibIconPath, $g_aQuickTroopIcon[$g_aiQTEdit_TroopType[$j]])
			GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], $g_aiQuickTroopQty[$i][$j])
			_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Troop[$j] & "#" & $g_ahTxtQTEdit_Troop[$j])
			GUICtrlSetTip($g_ahPicQTEdit_Troop[$j], $g_asTroopNames[$g_aiQTEdit_TroopType[$j]])
		EndIf
		If $g_aiQTEdit_SpellType[$j] > -1 Then
			_GUICtrlSetImage($g_ahPicQTEdit_Spell[$j], $g_sLibIconPath, $g_aQuickSpellIcon[$g_aiQTEdit_SpellType[$j]])
			GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], $g_aiQuickSpellQty[$i][$j])
			_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Spell[$j] & "#" & $g_ahTxtQTEdit_Spell[$j])
			GUICtrlSetTip($g_ahPicQTEdit_Spell[$j], $g_asSpellNames[$g_aiQTEdit_SpellType[$j]])
		EndIf
	Next
	TotalTroopCount_QTEdit()
	TotalSpellCount_QTEdit()
EndFunc   ;==>_EditQuickTrainArmy

Func ExitQuickTrainEdit()
	RemoveArmy_QTEdit()
	GUISetState(@SW_HIDE, $g_hGUI_QuickTrainEdit)
	$g_iQuickTrainEdit = -1
EndFunc   ;==>ExitQuickTrainEdit

Func SelectTroop_QTEdit()
	Local $iTroop = -1
	For $i = 0 To $eTroopCount - 1
		If @GUI_CtrlId = $g_ahPicTroop_QTEdit[$i] Then
			$iTroop = $i
			ExitLoop
		EndIf
	Next
	If $iTroop = -1 Then Return
	While _IsPressed(01)
		If Not AddTroop_QTEdit($iTroop) Then ExitLoop
		TotalTroopCount_QTEdit()
		Sleep(100)
	WEnd
EndFunc   ;==>SelectTroop_QTEdit

Func AddTroop_QTEdit($iTroop)
	Local $bOverSpace = False, $bOverSlot = False, $iTotalCampSpace = 0

	$iTotalCampSpace = Number(GUICtrlRead($g_hTxtTotalCampForced))

	If $g_iQTEdit_TotalTroop + $g_aiTroopSpace[$iTroop] > $iTotalCampSpace Then $bOverSpace = True

	For $j = 0 To 6
		If $bOverSpace Then ExitLoop
		Select
			Case $g_aiQTEdit_TroopType[$j] = -1
				$g_aiQTEdit_TroopType[$j] = $iTroop
				_GUICtrlSetImage($g_ahPicQTEdit_Troop[$j], $g_sLibIconPath, $g_aQuickTroopIcon[$iTroop])
				Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$j]) + 1
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], $iQty)
				_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Troop[$j] & "#" & $g_ahTxtQTEdit_Troop[$j])
				GUICtrlSetTip($g_ahPicQTEdit_Troop[$j], $g_asTroopNames[$g_aiQTEdit_TroopType[$j]])
				ExitLoop

			Case $g_aiQTEdit_TroopType[$j] = $iTroop
				Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$j]) + 1
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], $iQty)
				ExitLoop

			Case $g_aiQTEdit_TroopType[$j] > $iTroop And $g_aiQTEdit_TroopType[6] = -1
				For $k = 6 To $j + 1 Step -1 ; shifting the higher troops to the right
					If $g_aiQTEdit_TroopType[$k - 1] >= 0 Then
						$g_aiQTEdit_TroopType[$k] = $g_aiQTEdit_TroopType[$k - 1]
						Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$k - 1])
						_GUICtrlSetImage($g_ahPicQTEdit_Troop[$k], $g_sLibIconPath, $g_aQuickTroopIcon[$g_aiQTEdit_TroopType[$k]])
						GUICtrlSetData($g_ahTxtQTEdit_Troop[$k], $iQty)
						_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Troop[$k] & "#" & $g_ahTxtQTEdit_Troop[$k])
						GUICtrlSetTip($g_ahPicQTEdit_Troop[$k], $g_asTroopNames[$g_aiQTEdit_TroopType[$k]])
					EndIf
				Next
				$g_aiQTEdit_TroopType[$j] = $iTroop
				_GUICtrlSetImage($g_ahPicQTEdit_Troop[$j], $g_sLibIconPath, $g_aQuickTroopIcon[$iTroop])
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], 1)
				GUICtrlSetTip($g_ahPicQTEdit_Troop[$j], $g_asTroopNames[$g_aiQTEdit_TroopType[$j]])
				ExitLoop

		EndSelect
		If $j = 6 Then $bOverSlot = True
	Next

	If $bOverSpace Or $bOverSlot Then
		ToolTip($bOverSlot ? "Quick train does not support more than 7 troop slots" : "Total selected troops exceeds possible camp capacity (" & $iTotalCampSpace & ")")
		Sleep(2000)
		ToolTip('')
	Else
		Return True
	EndIf
EndFunc   ;==>AddTroop_QTEdit

Func RemoveTroop_QTEdit()
	Local $iSlot = -1
	For $i = 0 To 6
		If @GUI_CtrlId = $g_ahPicQTEdit_Troop[$i] Then
			If $g_aiQTEdit_TroopType[$i] = -1 Then Return
			$iSlot = $i
			ExitLoop
		EndIf
	Next
	If $iSlot = -1 Then Return
	While _IsPressed(01)
		_RemoveTroop_QTEdit($iSlot)
		TotalTroopCount_QTEdit()
	WEnd
EndFunc   ;==>RemoveTroop_QTEdit

Func _RemoveTroop_QTEdit($iSlot)
	Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$iSlot])
	If $iQty > 0 Then
		$iQty -= 1
		GUICtrlSetData($g_ahTxtQTEdit_Troop[$iSlot], $iQty)
	EndIf
	Sleep(100)
	If $iQty = 0 Then
		For $k = $iSlot To 6
			If $k < 6 Then
				If $g_aiQTEdit_TroopType[$k] = -1 Then ExitLoop
				$g_aiQTEdit_TroopType[$k] = $g_aiQTEdit_TroopType[$k + 1]
				$iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$k + 1])
			Else
				$g_aiQTEdit_TroopType[$k] = -1
				$iQty = 0
			EndIf
			If $g_aiQTEdit_TroopType[$k] > -1 Then
				_GUICtrlSetImage($g_ahPicQTEdit_Troop[$k], $g_sLibIconPath, $g_aQuickTroopIcon[$g_aiQTEdit_TroopType[$k]])
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$k], $iQty)
				_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Troop[$k] & "#" & $g_ahTxtQTEdit_Troop[$k])
				GUICtrlSetTip($g_ahPicQTEdit_Troop[$k], $g_asTroopNames[$g_aiQTEdit_TroopType[$k]])
			Else
				_GUICtrlSetImage($g_ahPicQTEdit_Troop[$k], $g_sLibIconPath, $eEmpty3)
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$k], 0)
				_GUI_Value_STATE("HIDE", $g_ahPicQTEdit_Troop[$k] & "#" & $g_ahTxtQTEdit_Troop[$k])
				GUICtrlSetTip($g_ahPicQTEdit_Troop[$k], "Empty")
			EndIf
		Next
	EndIf
EndFunc   ;==>_RemoveTroop_QTEdit

Func SelectSpell_QTEdit()
	Local $iSpell = -1
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahPicSpell_QTEdit[$i] Then
			$iSpell = $i
			ExitLoop
		EndIf
	Next
	If $iSpell = -1 Then Return
	While _IsPressed(01)
		If Not AddSpell_QTEdit($iSpell) Then ExitLoop
		TotalSpellCount_QTEdit()
		Sleep(100)
	WEnd
EndFunc   ;==>SelectSpell_QTEdit

Func AddSpell_QTEdit($iSpell)
	Local $bOverSpace = False, $bOverSlot = False, $iTotalSpellSpace = 0

	$iTotalSpellSpace = Number(GUICtrlRead($g_hTxtTotalCountSpell))

	If $g_iQTEdit_TotalSpell + $g_aiSpellSpace[$iSpell] > $iTotalSpellSpace Then $bOverSpace = True

	For $j = 0 To 6
		If $bOverSpace Then ExitLoop
		Select
			Case $g_aiQTEdit_SpellType[$j] = -1
				$g_aiQTEdit_SpellType[$j] = $iSpell
				_GUICtrlSetImage($g_ahPicQTEdit_Spell[$j], $g_sLibIconPath, $g_aQuickSpellIcon[$iSpell])
				Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$j]) + 1
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], $iQty)
				_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Spell[$j] & "#" & $g_ahTxtQTEdit_Spell[$j])
				GUICtrlSetTip($g_ahPicQTEdit_Spell[$j], $g_asSpellNames[$g_aiQTEdit_SpellType[$j]])
				ExitLoop

			Case $g_aiQTEdit_SpellType[$j] = $iSpell
				Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$j]) + 1
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], $iQty)
				ExitLoop

			Case $g_aiQTEdit_SpellType[$j] > $iSpell And $g_aiQTEdit_SpellType[6] = -1
				For $k = 6 To $j + 1 Step -1 ; shifting the higher spells to the right
					If $g_aiQTEdit_SpellType[$k - 1] >= 0 Then
						$g_aiQTEdit_SpellType[$k] = $g_aiQTEdit_SpellType[$k - 1]
						Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$k - 1])
						_GUICtrlSetImage($g_ahPicQTEdit_Spell[$k], $g_sLibIconPath, $g_aQuickSpellIcon[$g_aiQTEdit_SpellType[$k]])
						GUICtrlSetData($g_ahTxtQTEdit_Spell[$k], $iQty)
						_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Spell[$k] & "#" & $g_ahTxtQTEdit_Spell[$k])
						GUICtrlSetTip($g_ahPicQTEdit_Spell[$k], $g_asSpellNames[$g_aiQTEdit_SpellType[$k]])
					EndIf
				Next
				$g_aiQTEdit_SpellType[$j] = $iSpell
				_GUICtrlSetImage($g_ahPicQTEdit_Spell[$j], $g_sLibIconPath, $g_aQuickSpellIcon[$iSpell])
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], 1)
				GUICtrlSetTip($g_ahPicQTEdit_Spell[$j], $g_asSpellNames[$g_aiQTEdit_SpellType[$j]])
				ExitLoop

		EndSelect
		If $j = 6 Then $bOverSlot = True
	Next

	If $bOverSpace Or $bOverSlot Then
		ToolTip($bOverSlot ? "Quick train does not support more than 7 Spell slots" : "Total selected Spells exceeds possible spell camp capacity (" & $iTotalSpellSpace & ")")
		Sleep(2000)
		ToolTip('')
	Else
		Return True
	EndIf
EndFunc   ;==>AddSpell_QTEdit

Func RemoveSpell_QTEdit()
	Local $iSlot = -1
	For $i = 0 To 6
		If @GUI_CtrlId = $g_ahPicQTEdit_Spell[$i] Then
			If $g_aiQTEdit_SpellType[$i] = -1 Then Return
			$iSlot = $i
			ExitLoop
		EndIf
	Next
	If $iSlot = -1 Then Return
	While _IsPressed(01)
		_RemoveSpell_QTEdit($iSlot)
		TotalSpellCount_QTEdit()
	WEnd
EndFunc   ;==>RemoveSpell_QTEdit

Func _RemoveSpell_QTEdit($iSlot)
	Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$iSlot])
	If $iQty > 0 Then
		$iQty -= 1
		GUICtrlSetData($g_ahTxtQTEdit_Spell[$iSlot], $iQty)
	EndIf
	Sleep(100)
	If $iQty = 0 Then
		For $k = $iSlot To 6
			If $k < 6 Then
				If $g_aiQTEdit_SpellType[$k] = -1 Then ExitLoop
				$g_aiQTEdit_SpellType[$k] = $g_aiQTEdit_SpellType[$k + 1]
				$iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$k + 1])
			Else
				$g_aiQTEdit_SpellType[$k] = -1
				$iQty = 0
			EndIf
			If $g_aiQTEdit_SpellType[$k] > -1 Then
				_GUICtrlSetImage($g_ahPicQTEdit_Spell[$k], $g_sLibIconPath, $g_aQuickSpellIcon[$g_aiQTEdit_SpellType[$k]])
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$k], $iQty)
				_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Spell[$k] & "#" & $g_ahTxtQTEdit_Spell[$k])
				GUICtrlSetTip($g_ahPicQTEdit_Spell[$k], $g_asSpellNames[$g_aiQTEdit_SpellType[$k]])
			Else
				_GUICtrlSetImage($g_ahPicQTEdit_Spell[$k], $g_sLibIconPath, $eEmpty3)
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$k], 0)
				_GUI_Value_STATE("HIDE", $g_ahPicQTEdit_Spell[$k] & "#" & $g_ahTxtQTEdit_Spell[$k])
				GUICtrlSetTip($g_ahPicQTEdit_Spell[$k], "Empty")
			EndIf
		Next
	EndIf
EndFunc   ;==>_RemoveSpell_QTEdit

Func RemoveArmy_QTEdit()
	For $j = 0 To 6
		$g_aiQTEdit_TroopType[$j] = -1
		$g_aiQTEdit_SpellType[$j] = -1
		_GUICtrlSetImage($g_ahPicQTEdit_Troop[$j], $g_sLibIconPath, $eEmpty3)
		_GUICtrlSetImage($g_ahPicQTEdit_Spell[$j], $g_sLibIconPath, $eEmpty3)
		GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], 0)
		GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], 0)
		_GUI_Value_STATE("HIDE", $g_ahPicQTEdit_Troop[$j] & "#" & $g_ahTxtQTEdit_Troop[$j] & "#" & $g_ahPicQTEdit_Spell[$j] & "#" & $g_ahTxtQTEdit_Spell[$j])
		GUICtrlSetTip($g_ahPicQTEdit_Troop[$j], "Empty")
		GUICtrlSetTip($g_ahPicQTEdit_Spell[$j], "Empty")
	Next
	TotalTroopCount_QTEdit()
	TotalSpellCount_QTEdit()
EndFunc   ;==>RemoveArmy_QTEdit

Func SaveArmy_QTEdit()
	$i = $g_iQuickTrainEdit
	For $j = 0 To 6
		$g_aiQuickTroopType[$i][$j] = $g_aiQTEdit_TroopType[$j]
		$g_aiQuickSpellType[$i][$j] = $g_aiQTEdit_SpellType[$j]
		$g_aiQuickTroopQty[$i][$j] = GUICtrlRead($g_ahTxtQTEdit_Troop[$j])
		$g_aiQuickSpellQty[$i][$j] = GUICtrlRead($g_ahTxtQTEdit_Spell[$j])
	Next
	$g_aiTotalQuickTroop[$i] = $g_iQTEdit_TotalTroop
	$g_aiTotalQuickSpell[$i] = $g_iQTEdit_TotalSpell
	RemoveArmy_QTEdit()
	GUISetState(@SW_HIDE, $g_hGUI_QuickTrainEdit)
	ApplyQuickTrainArmy($i)
	$g_iQuickTrainEdit = -1
EndFunc   ;==>SaveArmy_QTEdit

Func ApplyQuickTrainArmy($Army)
	For $i = 0 To 2
		If $i <> $Army Then ContinueLoop
		Local $bNoArmy = True
		GUICtrlSetState($g_ahLblQuickTrainNote[$i], $GUI_HIDE)
		For $j = 0 To 6
			If $g_aiQuickTroopType[$i][$j] > -1 Then
				_GUICtrlSetImage($g_ahPicQuickTroop[$i][$j], $g_sLibIconPath, $g_aQuickTroopIcon[$g_aiQuickTroopType[$i][$j]])
				GUICtrlSetData($g_ahLblQuickTroop[$i][$j], $g_aiQuickTroopQty[$i][$j] & "x")
				_GUI_Value_STATE("SHOW", $g_ahPicQuickTroop[$i][$j] & "#" & $g_ahLblQuickTroop[$i][$j])
				GUICtrlSetTip($g_ahPicQuickTroop[$i][$j], $g_asTroopNames[$g_aiQuickTroopType[$i][$j]])
				$bNoArmy = False
			Else
				_GUICtrlSetImage($g_ahPicQuickTroop[$i][$j], $g_sLibIconPath, $eEmpty3)
				_GUI_Value_STATE("HIDE", $g_ahPicQuickTroop[$i][$j] & "#" & $g_ahLblQuickTroop[$i][$j])
				GUICtrlSetTip($g_ahPicQuickTroop[$i][$j], "Empty")
			EndIf
			If $g_aiQuickSpellType[$i][$j] > -1 Then
				_GUICtrlSetImage($g_ahPicQuickSpell[$i][$j], $g_sLibIconPath, $g_aQuickSpellIcon[$g_aiQuickSpellType[$i][$j]])
				GUICtrlSetData($g_ahLblQuickSpell[$i][$j], $g_aiQuickSpellQty[$i][$j] & "x")
				_GUI_Value_STATE("SHOW", $g_ahPicQuickSpell[$i][$j] & "#" & $g_ahLblQuickSpell[$i][$j])
				GUICtrlSetTip($g_ahPicQuickSpell[$i][$j], $g_asSpellNames[$g_aiQuickSpellType[$i][$j]])
				$bNoArmy = False
			Else
				_GUICtrlSetImage($g_ahPicQuickSpell[$i][$j], $g_sLibIconPath, $eEmpty3)
				_GUI_Value_STATE("HIDE", $g_ahPicQuickSpell[$i][$j] & "#" & $g_ahLblQuickSpell[$i][$j])
				GUICtrlSetTip($g_ahPicQuickSpell[$i][$j], "Empty")
			EndIf
		Next
		If $bNoArmy Then GUICtrlSetState($g_ahLblQuickTrainNote[$i], $GUI_SHOW)
		GUICtrlSetData($g_ahLblTotalQTroop[$i], $g_aiTotalQuickTroop[$i])
		GUICtrlSetData($g_ahLblTotalQSpell[$i], $g_aiTotalQuickSpell[$i])
	Next
EndFunc   ;==>ApplyQuickTrainArmy

Func TxtQTEdit_Troop()
	Local $iTroop, $iQty, $iSpace, $iSlot, $iTotalCampSpace = 0

	$iTotalCampSpace = Number(GUICtrlRead($g_hTxtTotalCampForced))

	For $j = 0 To 6
		If @GUI_CtrlId = $g_ahTxtQTEdit_Troop[$j] Then
			$iTroop = $g_aiQTEdit_TroopType[$j]
			$iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$j])
			If _ArrayIndexValid($g_aiTroopSpace, $iTroop) Then $iSpace = $iQty * $g_aiTroopSpace[$iTroop]
			$iSlot = $j
			If $iQty = 0 Then _RemoveTroop_QTEdit($iSlot)
			ExitLoop
		EndIf
		If $j = 6 Then Return
	Next
	TotalTroopCount_QTEdit()

	If $g_iQTEdit_TotalTroop > $iTotalCampSpace Then
		Local $iSpaceLeft = $iTotalCampSpace - ($g_iQTEdit_TotalTroop - $iSpace)
		Local $iMaxQtyLeft = Int($iSpaceLeft / $g_aiTroopSpace[$iTroop])
		ToolTip("Your input of " & $iQty & "x " & $g_asTroopNames[$iTroop] & " makes total troops to exceed possible camp capacity (" & $iTotalCampSpace & ")." & @CRLF & "Automatically changing to: " & $iMaxQtyLeft & "x " & $g_asTroopNames[$iTroop])
		Sleep(2000)
		ToolTip('')
		GUICtrlSetData($g_ahTxtQTEdit_Troop[$iSlot], $iMaxQtyLeft)
		TotalTroopCount_QTEdit()
	EndIf
EndFunc   ;==>TxtQTEdit_Troop

Func TxtQTEdit_Spell()
	Local $iSpell, $iQty, $iSpace, $iSlot, $iTotalSpellSpace = 0

	$iTotalSpellSpace = Number(GUICtrlRead($g_hTxtTotalCountSpell))

	For $j = 0 To 6
		If @GUI_CtrlId = $g_ahTxtQTEdit_Spell[$j] Then
			$iSpell = $g_aiQTEdit_SpellType[$j]
			$iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$j])
			If _ArrayIndexValid($g_aiSpellSpace, $iSpell) Then $iSpace = $iQty * $g_aiSpellSpace[$iSpell]
			$iSlot = $j
			If $iQty = 0 Then _RemoveSpell_QTEdit($iSlot)
			ExitLoop
		EndIf
		If $j = 6 Then Return
	Next
	TotalSpellCount_QTEdit()

	If $g_iQTEdit_TotalSpell > $iTotalSpellSpace Then
		Local $iSpaceLeft = $iTotalSpellSpace - ($g_iQTEdit_TotalSpell - $iSpace)
		Local $iMaxQtyLeft = Int($iSpaceLeft / $g_aiSpellSpace[$iSpell])
		ToolTip("Your input of " & $iQty & "x " & $g_asSpellNames[$iSpell] & " makes total Spells to exceed possible camp capacity (" & $iTotalSpellSpace & ")." & @CRLF & "Automatically changing to: " & $iMaxQtyLeft & "x " & $g_asSpellNames[$iSpell])
		Sleep(2000)
		ToolTip('')
		GUICtrlSetData($g_ahTxtQTEdit_Spell[$iSlot], $iMaxQtyLeft)
		TotalSpellCount_QTEdit()
	EndIf
EndFunc   ;==>TxtQTEdit_Spell

Func TotalTroopCount_QTEdit()
	$g_iQTEdit_TotalTroop = 0
	For $j = 0 To 6
		Local $iCount = GUICtrlRead($g_ahTxtQTEdit_Troop[$j])
		Local $iTroop = $g_aiQTEdit_TroopType[$j]
		If $iCount > 0 Then $g_iQTEdit_TotalTroop += $iCount * $g_aiTroopSpace[$iTroop]
	Next
	GUICtrlSetData($g_ahLblQTEdit_TotalTroop, $g_iQTEdit_TotalTroop)
EndFunc   ;==>TotalTroopCount_QTEdit

Func TotalSpellCount_QTEdit()
	$g_iQTEdit_TotalSpell = 0
	For $j = 0 To 6
		Local $iCount = GUICtrlRead($g_ahTxtQTEdit_Spell[$j])
		Local $iSpell = $g_aiQTEdit_SpellType[$j]
		If $iCount > 0 Then $g_iQTEdit_TotalSpell += $iCount * $g_aiSpellSpace[$iSpell]
	Next
	GUICtrlSetData($g_ahLblQTEdit_TotalSpell, $g_iQTEdit_TotalSpell)
EndFunc   ;==>TotalSpellCount_QTEdit
#EndRegion QuickTrain

Func chkSuperTroops()
	If GUICtrlRead($g_hChkSuperTroops) = $GUI_CHECKED Then
		$g_bSuperTroopsEnable = True
		GUICtrlSetState($g_hChkSkipBoostSuperTroopOnHalt, $GUI_ENABLE)
		GUICtrlSetState($g_hChkUsePotionFirst, $GUI_ENABLE)
		For $i = 0 To $iMaxSupersTroop - 1
			GUICtrlSetState($g_ahLblSuperTroops[$i], $GUI_ENABLE)
			GUICtrlSetState($g_ahCmbSuperTroops[$i], $GUI_ENABLE)
			GUICtrlSetState($g_ahPicSuperTroops[$i], $GUI_SHOW)
			_GUICtrlSetImage($g_ahPicSuperTroops[$i], $g_sLibIconPath, $g_aSuperTroopsIcons[$g_iCmbSuperTroops[$i]])
		Next
	Else
		$g_bSuperTroopsEnable = False
		GUICtrlSetState($g_hChkSkipBoostSuperTroopOnHalt, $GUI_DISABLE)
		GUICtrlSetState($g_hChkUsePotionFirst, $GUI_DISABLE)
		For $i = 0 To $iMaxSupersTroop - 1
			GUICtrlSetState($g_ahLblSuperTroops[$i], $GUI_DISABLE)
			GUICtrlSetState($g_ahCmbSuperTroops[$i], $GUI_DISABLE)
			GUICtrlSetState($g_ahPicSuperTroops[$i], $GUI_HIDE)
			_GUICtrlSetImage($g_ahPicSuperTroops[$i], $g_sLibIconPath, $g_aSuperTroopsIcons[$g_iCmbSuperTroops[$i]])
		Next
	EndIf
	If GUICtrlRead($g_hChkSkipBoostSuperTroopOnHalt) = $GUI_CHECKED Then
		$g_bSkipBoostSuperTroopOnHalt = True
	Else
		$g_bSkipBoostSuperTroopOnHalt = False
	EndIf
	If GUICtrlRead($g_hChkUsePotionFirst) = $GUI_CHECKED Then
		$g_bSuperTroopsBoostUsePotionFirst = True
	Else
		$g_bSuperTroopsBoostUsePotionFirst = False
	EndIf
EndFunc   ;==>chkSuperTroops

Func cmbSuperTroops()
	For $i = 0 To $iMaxSupersTroop - 1
		$g_iCmbSuperTroops[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbSuperTroops[$i])
		_GUICtrlSetImage($g_ahPicSuperTroops[$i], $g_sLibIconPath, $g_aSuperTroopsIcons[$g_iCmbSuperTroops[$i]])
		For $j = 0 To $iMaxSupersTroop - 1
			If $i = $j Then ContinueLoop
			If $g_iCmbSuperTroops[$i] <> 0 And $g_iCmbSuperTroops[$i] = $g_iCmbSuperTroops[$j] Then
				_GUICtrlComboBox_SetCurSel($g_ahCmbSuperTroops[$j], 0)
				_GUICtrlSetImage($g_ahPicSuperTroops[$j], $g_sLibIconPath, $eIcnOptions)
			EndIf
		Next
	Next
EndFunc   ;==>cmbSuperTroops

Func ChkPreciseArmy()
	If GUICtrlRead($g_hChkPreciseArmy) = $GUI_CHECKED Then
		$g_bPreciseArmy = True
	Else
		$g_bPreciseArmy = False
	EndIf
EndFunc   ;==>ChkPreciseArmy

Func RemoveAllTmpTrain($sWhat = "All")
	If $sWhat = "All" Or $sWhat = "Troop" Then
		For $i = 0 To UBound($g_ahPicTrainArmyTroopTmp) - 1
			GUICtrlSetState($g_ahPicTrainArmyTroopTmp[$i], $GUI_HIDE)
			GUICtrlSetState($g_ahLblTrainArmyTroopTmp[$i], $GUI_HIDE)
		Next
	EndIf

	If $sWhat = "All" Or $sWhat = "Spell" Then
		For $i = 0 To UBound($g_ahPicTrainArmySpellTmp) - 1
			GUICtrlSetState($g_ahPicTrainArmySpellTmp[$i], $GUI_HIDE)
			GUICtrlSetState($g_ahLblTrainArmySpellTmp[$i], $GUI_HIDE)
		Next
	EndIf

	If $sWhat = "All" Or $sWhat = "Siege" Then
		For $i = 0 To UBound($g_ahPicTrainArmySiegeTmp) - 1
			GUICtrlSetState($g_ahPicTrainArmySiegeTmp[$i], $GUI_HIDE)
			GUICtrlSetState($g_ahLblTrainArmySiegeTmp[$i], $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>RemoveAllTmpTrain

Func HideAllTroops()
	For $i = $g_ahPicTrainArmyTroop[$eTroopMinion] To $g_ahPicTrainArmyTroop[$eTroopAppWard]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $g_ahTxtTrainArmyTroopCount[$eTroopMinion] To $g_ahTxtTrainArmyTroopCount[$eTroopAppWard]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $g_ahPicTrainArmyTroop[$eTroopBarbarian] To $g_ahPicTrainArmyTroop[$eTroopRootRider]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $g_ahTxtTrainArmyTroopCount[$eTroopBarbarian] To $g_ahTxtTrainArmyTroopCount[$eTroopRootRider]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $g_ahPicTrainArmyTroop[$eTroopSuperBarbarian] To $g_ahPicTrainArmyTroop[$eTroopSuperHogRider]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $g_ahTxtTrainArmyTroopCount[$eTroopSuperBarbarian] To $g_ahTxtTrainArmyTroopCount[$eTroopSuperHogRider]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $g_ahPicTrainArmySpell[$eSpellLightning] To $g_ahPicTrainArmySpell[$eSpellOvergrowth]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $g_ahTxtTrainArmySpellCount[$eSpellLightning] To $g_ahTxtTrainArmySpellCount[$eSpellOvergrowth]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $g_ahPicTrainArmySiege[$eSiegeWallWrecker] To $g_ahPicTrainArmySiege[$eSiegeBattleDrill]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $g_ahTxtTrainArmySiegeCount[$eSiegeWallWrecker] To $g_ahTxtTrainArmySiegeCount[$eSiegeBattleDrill]
		GUICtrlSetState($i, $GUI_HIDE)
	Next
EndFunc   ;==>HideAllTroops

Func SetBtnSelector($sType = "All")
	For $i = $g_hBtnElixirTroops To $g_hBtnSieges
		GUICtrlSetBkColor($i, $COLOR_BLACK)
		GUICtrlSetColor($i, $COLOR_WHITE)
		GUICtrlSetFont($i, 11, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
	Next
	Switch $sType
		Case "ElixirTroops"
			GUICtrlSetColor($g_hBtnElixirTroops, $COLOR_YELLOW)
		Case "DarkElixirTroops"
			GUICtrlSetColor($g_hBtnDarkElixirTroops, $COLOR_YELLOW)
		Case "SuperTroops"
			GUICtrlSetColor($g_hBtnSuperTroops, $COLOR_YELLOW)
		Case "Spells"
			GUICtrlSetColor($g_hBtnSpells, $COLOR_YELLOW)
		Case "Sieges"
			GUICtrlSetColor($g_hBtnSieges, $COLOR_YELLOW)
	EndSwitch
EndFunc   ;==>SetBtnSelector

Func BtnElixirTroops()
	HideAllTroops()
	For $i = $g_ahPicTrainArmyTroop[$eTroopBarbarian] To $g_ahPicTrainArmyTroop[$eTroopRootRider]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	For $i = $g_ahTxtTrainArmyTroopCount[$eTroopBarbarian] To $g_ahTxtTrainArmyTroopCount[$eTroopRootRider]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	SetBtnSelector("ElixirTroops")
EndFunc   ;==>BtnElixirTroops

Func BtnDarkElixirTroops()
	HideAllTroops()
	For $i = $g_ahPicTrainArmyTroop[$eTroopMinion] To $g_ahPicTrainArmyTroop[$eTroopAppWard]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	For $i = $g_ahTxtTrainArmyTroopCount[$eTroopMinion] To $g_ahTxtTrainArmyTroopCount[$eTroopAppWard]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	SetBtnSelector("DarkElixirTroops")
EndFunc   ;==>BtnDarkElixirTroops

Func BtnSuperTroops()
	HideAllTroops()
	For $i = $g_ahPicTrainArmyTroop[$eTroopSuperBarbarian] To $g_ahPicTrainArmyTroop[$eTroopSuperHogRider]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	For $i = $g_ahTxtTrainArmyTroopCount[$eTroopSuperBarbarian] To $g_ahTxtTrainArmyTroopCount[$eTroopSuperHogRider]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	SetBtnSelector("SuperTroops")
EndFunc   ;==>BtnSuperTroops

Func BtnSpells()
	HideAllTroops()
	For $i = $g_ahPicTrainArmySpell[$eSpellLightning] To $g_ahPicTrainArmySpell[$eSpellOvergrowth]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	For $i = $g_ahTxtTrainArmySpellCount[$eSpellLightning] To $g_ahTxtTrainArmySpellCount[$eSpellOvergrowth]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	SetBtnSelector("Spells")
EndFunc   ;==>BtnSpells

Func BtnSieges()
	HideAllTroops()
	For $i = $g_ahPicTrainArmySiege[$eSiegeWallWrecker] To $g_ahPicTrainArmySiege[$eSiegeBattleDrill]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	For $i = $g_ahTxtTrainArmySiegeCount[$eSiegeWallWrecker] To $g_ahTxtTrainArmySiegeCount[$eSiegeBattleDrill]
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	SetBtnSelector("Sieges")
EndFunc   ;==>BtnSieges
