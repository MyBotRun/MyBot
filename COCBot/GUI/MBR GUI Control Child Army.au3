; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), Boju (11-2016), MR.ViPER (11-2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkUseQTrain()
	If GUICtrlRead($g_hChkUseQuickTrain) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_hRdoArmy1 & "#" & $g_hRdoArmy2 & "#" & $g_hRdoArmy3)
		_GUI_Value_STATE("DISABLE", $grpTrainTroops)
		_GUI_Value_STATE("DISABLE", $grpCookSpell)
		GUICtrlSetData($g_hLblTotalTimeCamp, " 0s")
		GUICtrlSetData($g_hLblTotalTimeSpell, " 0s")
		GUICtrlSetData($g_hLblElixirCostCamp, "0")
		GUICtrlSetData($g_hLblDarkCostCamp, "0")
		GUICtrlSetData($g_hLblElixirCostSpell, "0")
		GUICtrlSetData($g_hLblDarkCostSpell, "0")
	Else
		_GUI_Value_STATE("DISABLE", $g_hRdoArmy1 & "#" & $g_hRdoArmy2 & "#" & $g_hRdoArmy3)
		_GUI_Value_STATE("ENABLE", $grpTrainTroops)
		_GUI_Value_STATE("ENABLE", $grpCookSpell)
		lblTotalCountTroop1()
		TotalSpellCountClick()
	EndIf
EndFunc   ;==>chkUseQTrain

Func SetComboTroopComp()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "SetComboTroopComp")
	Local $ArmyCampTemp = 0

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
		$ArmyCampTemp = Floor(GUICtrlRead($g_hTxtTotalCampForced) * GUICtrlRead($g_hTxtFullTroop) / 100)
	Else
		$ArmyCampTemp = Floor($TotalCamp * GUICtrlRead($g_hTxtFullTroop) / 100)
	EndIf

	Local $TotalTroopsToTrain = 0

	lblTotalCountTroop1()
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
		$ArmyCampTemp = Floor($TotalCamp * GUICtrlRead($g_hTxtFullTroop) / 100)
	EndIf

	For $i = 0 To $eTroopCount - 1
	    Local $iCount = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$i])
		If $iCount > 0 Then
			$TotalTroopsToTrain += $iCount * $g_aiTroopSpace[$i]
		Else
			GUICtrlSetData($g_ahTxtTrainArmyTroopCount[$i], 0)
		EndIf
	Next

	GUICtrlSetData($g_hLblCountTotal, String($TotalTroopsToTrain))

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED And GUICtrlRead($g_hLblCountTotal) = GUICtrlRead($g_hTxtTotalCampForced) Then
		GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($g_hLblCountTotal) = $ArmyCampTemp Then
		GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($g_hLblCountTotal) > $ArmyCampTemp / 2 And GUICtrlRead($g_hLblCountTotal) < $ArmyCampTemp Then
		GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_ORANGE)
	Else
		GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_RED)
    EndIf

	Local $fPctOfForced = Floor((GUICtrlRead($g_hLblCountTotal) / GUICtrlRead($g_hTxtTotalCampForced)) * 100)
    Local $fPctOfCalculated = Floor((GUICtrlRead($g_hLblCountTotal) / $ArmyCampTemp) * 100)

    If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
		GUICtrlSetData($g_hCalTotalTroops, $fPctOfForced < 1 ? (GUICtrlRead($g_hLblCountTotal) > 0 ? 1 : 0) : $fPctOfForced)
	Else
		GUICtrlSetData($g_hCalTotalTroops, $fPctOfCalculated < 1 ? (GUICtrlRead($g_hLblCountTotal) > 0 ? 1 : 0) : $fPctOfCalculated)
	EndIf

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED And GUICtrlRead($g_hLblCountTotal) > GUICtrlRead($g_hTxtTotalCampForced) Then
		GUICtrlSetState($g_hLblTotalProgress, $GUI_SHOW)
	ElseIf GUICtrlRead($g_hLblCountTotal) > $ArmyCampTemp Then
		GUICtrlSetState($g_hLblTotalProgress, $GUI_SHOW)
	Else
		GUICtrlSetState($g_hLblTotalProgress, $GUI_HIDE)
	EndIf

	lblTotalCountTroop2()
EndFunc   ;==>lblTotalCountTroop1

Func lblTotalCountTroop2()
    ; Calculate time for troops
	Local $TotalTotalTimeTroop = 0
	Local $NbrOfBarrack = 4 ;For the moment fix to 4 until fine detect level of each Barrack
	Local $NbrOfDarkBarrack = 2 ;For the moment fix to 2 until fine detect level of each Barrack
	For $i = $eTroopBarbarian To $eTroopMiner
		Local $NbrOfTroop = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$i])
		Local $LevOfTroop = $g_aiTrainArmyTroopLevel[$i]

		If $NbrOfTroop > 0 And $LevOfTroop > 0 Then
			If IsInt($NbrOfTroop / $NbrOfBarrack) = 1 then
			   $TotalTotalTimeTroop += ($NbrOfTroop / $NbrOfBarrack) * $g_aiTroopTrainTime[$i]
			Else
			   $TotalTotalTimeTroop += (Ceiling($NbrOfTroop / $NbrOfBarrack)) * $g_aiTroopTrainTime[$i]
			   $TotalTotalTimeTroop += ((Ceiling($NbrOfTroop / $NbrOfBarrack) - 1) - (Floor($NbrOfTroop / $NbrOfBarrack))) * $g_aiTroopTrainTime[$i]
			EndIf
		EndIf
	Next

	For $i = $eTroopMinion To $eTroopBowler
		Local $NbrOfTroop = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$i])
		Local $LevOfTroop = $g_aiTrainArmyTroopLevel[$i]

		If $NbrOfTroop > 0 And $LevOfTroop > 0 Then
			If IsInt($NbrOfTroop / $NbrOfDarkBarrack) = 1 then
			   $TotalTotalTimeTroop += ($NbrOfTroop / $NbrOfDarkBarrack) * $g_aiTroopTrainTime[$i]
			Else
			   $TotalTotalTimeTroop += (Ceiling($NbrOfTroop / $NbrOfDarkBarrack)) * $g_aiTroopTrainTime[$i]
			   $TotalTotalTimeTroop += ((Ceiling($NbrOfTroop / $NbrOfDarkBarrack) - 1) - (Floor($NbrOfTroop / $NbrOfDarkBarrack))) * $g_aiTroopTrainTime[$i]
			EndIf
	    EndIf
	Next

	$TotalTotalTimeTroop = CalculTimeTo($TotalTotalTimeTroop)
	GUICtrlSetData($g_hLblTotalTimeCamp, $TotalTotalTimeTroop)

	CalCostCamp()
EndFunc   ;==>lblTotalCountTroop2

Func lblTotalCountSpell2()
	; calculate total space and time for spell composition
	Local $iTotalTotalTimeSpell = 0
	$iTotalTrainSpaceSpell = 0

	For $i = 0 To $eSpellCount-1
	   $iTotalTrainSpaceSpell += $g_aiArmyCompSpells[$i] * $g_aiSpellSpace[$i]
	   $iTotalTotalTimeSpell += $g_aiArmyCompSpells[$i] * $g_aiSpellTrainTime[$i]
    Next

	For $i = 0 To $eSpellCount - 1
	   GUICtrlSetBkColor($g_ahTxtTrainArmySpellCount[$i], $iTotalTrainSpaceSpell <= GUICtrlRead($g_hTxtTotalCountSpell) ? $COLOR_WHITE : $COLOR_RED)
	Next

	GUICtrlSetData($g_hLblTotalTimeSpell, CalculTimeTo($iTotalTotalTimeSpell))

	CalCostSpell()
EndFunc   ;==>lblTotalCountSpell2

Func TotalSpellCountClick()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "TotalSpellCountClick")
	_GUI_Value_STATE("HIDE", $groupListSpells)
	$iTownHallLevel = Int($iTownHallLevel)

	If $iTownHallLevel > 4 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellLightning] > 0 ? $groupLightning : $groupIcnLightning)
    Else
		 For $i = 0 To $eSpellCount - 1
			GUICtrlSetData($g_ahTxtTrainArmySpellCount[$i], 0)
			GUICtrlSetData($g_ahLblTrainArmySpellLevel[$i], 0)
		 Next
		 GUICtrlSetData($g_hTxtTotalCountSpell, 0)
    EndIf

	If $iTownHallLevel > 5 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellHeal] > 0 ? $groupHeal : $groupIcnHeal)
    Else
		 For $i = $eSpellRage To $eSpellSkeleton
			GUICtrlSetData($g_ahTxtTrainArmySpellCount[$i], 0)
			GUICtrlSetData($g_ahLblTrainArmySpellLevel[$i], 0)
		 Next
	 EndIf

	If $iTownHallLevel > 6 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellRage] > 0 ? $groupRage : $groupIcnRage)
	Else
		 For $i = $eSpellJump To $eSpellSkeleton
			GUICtrlSetData($g_ahTxtTrainArmySpellCount[$i], 0)
			GUICtrlSetData($g_ahLblTrainArmySpellLevel[$i], 0)
		 Next
    EndIf

	If $iTownHallLevel > 7 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellPoison] > 0 ? $groupPoison : $groupIcnPoison)
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellEarthquake] > 0 ? $groupEarthquake : $groupIcnEarthquake)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellJump], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellFreeze], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellClone], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellHaste], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellSkeleton], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellJump], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellFreeze], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellClone], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellHaste], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellSkeleton], 0)
    EndIf

	If $iTownHallLevel > 8 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellJump] > 0 ? $groupJumpSpell : $groupIcnJumpSpell)
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellFreeze] > 0 ? $groupFreeze : $groupIcnFreeze)
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellHaste] > 0 ? $groupHaste : $groupIcnHaste)
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellSkeleton] > 0 ? $groupSkeleton : $groupIcnSkeleton)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellClone], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellClone], 0)
    EndIf

	If $iTownHallLevel > 9 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $g_aiTrainArmySpellLevel[$eSpellClone] > 0 ? $groupClone : $groupIcnClone)
	EndIf

    lblTotalCountSpell2()
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "TotalSpellCountClick")
EndFunc   ;==>TotalSpellCountClick

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
	Else
		If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then GUICtrlSetState($g_hChkCloseEmulator, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkCloseWaitEnable

Func chkCloseWaitTrain()
	$g_bCloseWithoutShield = (GUICtrlRead($g_hChkCloseWithoutShield) = $GUI_CHECKED)
EndFunc

Func btnCloseWaitStop()
	$g_bCloseEmulator = (GUICtrlRead($g_hChkCloseEmulator) = $GUI_CHECKED)
EndFunc

Func btnCloseWaitStopRandom()
	If GUICtrlRead($g_hChkRandomClose) = $GUI_CHECKED Then
		$g_bCloseRandom = True
		$g_bCloseEmulator = False
		GUICtrlSetState($g_hChkCloseEmulator, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		$g_bCloseRandom = False
		If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then GUICtrlSetState($g_hChkCloseEmulator, $GUI_ENABLE)
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

Func chkTroopOrder($bNoiseMode = True)
	If GUICtrlRead($g_hChkCustomTrainOrderEnable) = $GUI_CHECKED Then
		$g_bCustomTrainOrderEnable = True
		GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_ENABLE)
		For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
			GUICtrlSetState($g_ahCmbTroopOrder[$i], $GUI_ENABLE)
		Next
		If IsUseCustomTroopOrder() = True Then GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight)
	Else
		$g_bCustomTrainOrderEnable = False
		GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_DISABLE) ; disable button
		For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
			GUICtrlSetState($g_ahCmbTroopOrder[$i], $GUI_DISABLE) ; disable combo boxes
		Next
		SetDefaultTroopGroup($bNoiseMode) ; Reset troopgroup values to default
		If $bNoiseMode Or $g_iDebugSetlogTrain = 1 Then
			Local $sNewTrainList = ""
			For $i = 0 To $eTroopCount - 1
				$sNewTrainList &= $g_asTroopShortNames[$g_aiTrainOrder[$i]] & ", "
			Next
			$sNewTrainList = StringTrimRight($sNewTrainList, 2)
			Setlog("Current train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	EndIf
EndFunc   ;==>chkTroopOrder

Func GUITrainOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1 ; record control ID for $g_ahImgTroopOrder[$z] based on control of combobox that called this function
	Local $iTroopIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1 ; find zero based index number of troop selected in combo box, add one for enum of proper icon

	GUICtrlSetImage($iCtrlIdImage, $g_sLibIconPath, $g_aiTroopOrderIcon[$iTroopIndex]) ; set proper troop icon

	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $g_ahCmbTroopOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$i]) Then
			GUICtrlSetImage($g_ahImgTroopOrder[$i], $g_sLibIconPath, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($g_ahCmbTroopOrder[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next
	If $bDuplicate = True Then
		GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_DISABLE) ; enable button to apply new order
		Return
	Else
		GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_ENABLE) ; enable button to apply new order
		GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight) ; set status indicator to show need to apply new order
	EndIf
EndFunc   ;==>GUITrainOrder

Func BtnTroopOrderSet()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "BtnTroopOrderSet")
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewTrainList = ""

	; check for duplicate combobox index and flag with read color
	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
		For $j = 0 To UBound($g_ahCmbTroopOrder) - 1
			If $i = $j Then ContinueLoop ; skip if index are same
			If _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$i]) = _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$j]) Then
				_GUICtrlComboBox_SetCurSel($g_ahCmbTroopOrder[$j], -1)
				GUICtrlSetImage($g_ahImgTroopOrder[$j], $g_sLibIconPath, $eIcnOptions)
				$bReady = False
			Else
				GUICtrlSetColor($g_ahCmbTroopOrder[$j], $COLOR_BLACK)
			EndIf
		Next

	    ; update combo array variable with new value
		$g_aiCmbCustomTrainOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$i])
    Next

	If $bReady Then
		ChangeTroopTrainOrder() ; code function to record new training order
		If @error Then
			Switch @error
				Case 1
					Setlog("Code problem, can not continue till fixed!", $COLOR_RED)
				Case 2
					Setlog("Bad Combobox selections, please fix!", $COLOR_RED)
				Case 3
					Setlog("Unable to Change Troop Train Order due bad change count!", $COLOR_RED)
				Case Else
					Setlog("Monkey ate bad banana, something wrong with ChangeTroopTrainOrder() code!", $COLOR_RED)
			EndSwitch
			GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight)
		Else
			Setlog("Troop training order changed successfully!", $COLOR_GREEN)
			For $i = 0 To $eTroopCount - 1
				$sNewTrainList &= $g_asTroopShortNames[$g_aiTrainOrder[$i]] & ", "
			Next
			$sNewTrainList = StringTrimRight($sNewTrainList, 2)
			Setlog("Troop train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	Else
		Setlog("Must use all troops and No duplicate troop names!", $COLOR_RED)
		GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnRedLight)
	EndIf
	GUICtrlSetState(BtnTroopOrderSet, $GUI_DISABLE)
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "BtnTroopOrderSet")
EndFunc   ;==>BtnTroopOrderSet

Func ChangeTroopTrainOrder()
	If $g_iDebugSetlog = 1 Or $g_iDebugSetlogTrain = 1 Then Setlog("Begin Func ChangeTroopTrainOrder()", $COLOR_DEBUG) ;Debug

	Local $NewTroopOrder[$eTroopCount]
	Local $iUpdateCount = 0

	If IsUseCustomTroopOrder() = False Then ; check if no custom troop values saved yet.
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
		GUICtrlSetImage($g_ahImgTroopOrderSet, $g_sLibIconPath, $eIcnGreenLight)
	Else
		Setlog($iUpdateCount & "|" & $eTroopCount & " - Error - Bad troop assignment in ChangeTroopTrainOrder()", $COLOR_RED)
		SetError(3, 0, False)
		Return
	EndIf

	Return True
EndFunc   ;==>ChangeTroopTrainOrder

Func SetDefaultTroopGroup($bNoiseMode = True)
	For $i = 0 To $eTroopCount - 1
		$g_aiTrainOrder[$i] = $i
	Next

	If $bNoiseMode Or $g_iDebugSetlogTrain = 1 Then Setlog("Default troop training order set", $COLOR_GREEN)
EndFunc   ;==>SetDefaultTroopGroup

Func IsUseCustomTroopOrder()
	For $i = 0 To UBound($g_aiCmbCustomTrainOrder) - 1 ; Check if custom train order has been used, to select log message
		If $g_aiCmbCustomTrainOrder[$i] = -1 Then
			If $g_iDebugSetlogTrain = 1 Then Setlog("Custom train order not used...", $COLOR_DEBUG) ;Debug
			Return False
		EndIf
	Next
	If $g_iDebugSetlogTrain = 1 Then Setlog("Custom train order used...", $COLOR_DEBUG) ;Debug
	Return True
EndFunc   ;==>IsUseCustomTroopOrder

Func LevUpDownTroop($iTroopIndex, $NoChangeLev = True)
	Local $MaxLev = $g_aiTroopCostPerLevel[$iTroopIndex][0]
	Local $TempLev = 0

	If $NoChangeLev Then
		If _IsPressed("10") Or _IsPressed("02") Then
			$TempLev = $g_aiTrainArmyTroopLevel[$iTroopIndex] - 1
		Else
			$TempLev = $g_aiTrainArmyTroopLevel[$iTroopIndex] + 1
		EndIf
	Else
		$TempLev = $g_aiTrainArmyTroopLevel[$iTroopIndex]
    EndIf

	Local $hLevel = $g_ahLblTrainArmyTroopLevel[$iTroopIndex]
    Local $hCount = $g_ahTxtTrainArmyTroopCount[$iTroopIndex]

    If $TempLev > $MaxLev Or $TempLev = 0 Then
		$TempLev = 0
		GUICtrlSetData($hCount, 0)
		$g_aiArmyCompTroops[$iTroopIndex] = 0
		If IsGUICtrlHidden($hCount) = False Then GUICtrlSetState($hCount, $GUI_HIDE)
		If $NoChangeLev Then lblTotalCountTroop1()
	ElseIf $TempLev < 0 Then
		$TempLev = $MaxLev
		If IsGUICtrlHidden($hCount) Then GUICtrlSetState($hCount, $GUI_SHOW)
    ElseIf $TempLev > 0 And $TempLev <= $MaxLev And IsGUICtrlHidden($hCount) Then
		GUICtrlSetState($hCount, $GUI_SHOW)
    EndIf

	$g_aiTrainArmyTroopLevel[$iTroopIndex] = $TempLev

	Local $iColor = ($TempLev = $MaxLev ? $COLOR_YELLOW : $COLOR_WHITE)
	GUICtrlSetData($hLevel, $TempLev)
	If GUICtrlGetBkColor($hLevel) <> $iColor Then GUICtrlSetBkColor($hLevel, $iColor)
EndFunc   ;==>LevUpDownTroop

Func LevUpDownSpell($iSpellIndex, $NoChangeLev = True)
	Local $MaxLev = $g_aiSpellCostPerLevel[$iSpellIndex][0]
	Local $TempLev = 0

	If $NoChangeLev Then
		If _IsPressed("10") Or _IsPressed("02") Then
			$TempLev = $g_aiTrainArmySpellLevel[$iSpellIndex] - 1
		Else
			$TempLev = $g_aiTrainArmySpellLevel[$iSpellIndex] + 1
		EndIf
	Else
		$TempLev = $g_aiTrainArmySpellLevel[$iSpellIndex]
	EndIf

    Local $hLevel = $g_ahLblTrainArmySpellLevel[$iSpellIndex]
    Local $hCount = $g_ahTxtTrainArmySpellCount[$iSpellIndex]

	If $TempLev > $MaxLev Or $TempLev = 0 Then
		$TempLev = 0
		GUICtrlSetData($hCount, 0)
		$g_aiArmyCompSpells[$iSpellIndex] = 0
		If IsGUICtrlHidden($hCount) = False Then GUICtrlSetState($hCount, $GUI_HIDE)
		If $NoChangeLev Then lblTotalCountSpell2()
	ElseIf $TempLev < 0 Then
		$TempLev = $MaxLev
		If IsGUICtrlHidden($hCount) Then GUICtrlSetState($hCount, $GUI_SHOW)
    ElseIf $TempLev > 0 And $TempLev <= $MaxLev And IsGUICtrlHidden($hCount) Then
		GUICtrlSetState($hCount, $GUI_SHOW)
    EndIf

	$g_aiTrainArmySpellLevel[$iSpellIndex] = $TempLev

	Local $iColor = ($TempLev = $MaxLev ? $COLOR_YELLOW : $COLOR_WHITE)
	GUICtrlSetData($hLevel, $TempLev)
	If GUICtrlGetBkColor($hLevel) <> $iColor Then GUICtrlSetBkColor($hLevel, $iColor)
EndFunc   ;==>LevUpDownSpell

Func TrainTroopLevelClick()
	If $g_bRunState = True Then Return

	Local $iTroop = -1
    For $i = 0 To $eTroopCount - 1
	   If @GUI_CtrlId = $g_ahPicTrainArmyTroop[$i] Then
		  $iTroop = $i
		  ExitLoop
	   EndIf
    Next

	If $iTroop = -1 Then Return

    While _IsPressed(01)
	   LevUpDownTroop($iTroop)
	   Sleep($iDelayLvUP)
	   lblTotalCountTroop2()
	WEnd
EndFunc


Func TrainSpellLevelClick()
	If $g_bRunState = True Then Return

	Local $iSpell = -1
    For $i = 0 To $eSpellCount - 1
	   If @GUI_CtrlId = $g_ahPicTrainArmySpell[$i] Then
		  $iSpell = $i
		  ExitLoop
	   EndIf
    Next

	If $iSpell = -1 Then Return

    While _IsPressed(01)
	   LevUpDownSpell($iSpell)
	   Sleep($iDelayLvUP)
	   lblTotalCountSpell2()
	WEnd
 EndFunc

Func CalCostCamp()
	Local $iElixirCostCamp = 0, $iDarkCostCamp = 0

   For $i = $eTroopBarbarian To $eTroopMiner
	  $iElixirCostCamp += $g_aiArmyCompTroops[$i] * $g_aiTroopCostPerLevel[$i][$g_aiTrainArmyTroopLevel[$i]]
   Next

   For $i = $eTroopMinion To $eTroopBowler
	  $iDarkCostCamp += $g_aiArmyCompTroops[$i] * $g_aiTroopCostPerLevel[$i][$g_aiTrainArmyTroopLevel[$i]]
   Next

	GUICtrlSetData($g_hLblElixirCostCamp, _NumberFormat($iElixirCostCamp, True))
	GUICtrlSetData($g_hLblDarkCostCamp, _NumberFormat($iDarkCostCamp, True))
EndFunc   ;==>CalCostCamp

Func CalCostSpell()
	Local $iElixirCostSpell = 0, $iDarkCostSpell = 0

   For $i = $eSpellLightning To $eSpellClone
	  $iElixirCostSpell += $g_aiArmyCompSpells[$i] * $g_aiSpellCostPerLevel[$i][$g_aiTrainArmySpellLevel[$i]]
   Next

   For $i = $eSpellPoison To $eSpellSkeleton
	  $iDarkCostSpell += $g_aiArmyCompSpells[$i] * $g_aiSpellCostPerLevel[$i][$g_aiTrainArmySpellLevel[$i]]
   Next

	GUICtrlSetData($g_hLblElixirCostSpell, _NumberFormat($iElixirCostSpell, True))
	GUICtrlSetData($g_hLblDarkCostSpell, _NumberFormat($iDarkCostSpell, True))
EndFunc   ;==>CalCostSpell

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
		$g_aiArmyCompTroops[$T] = 0
		GUICtrlSetData($g_ahTxtTrainArmyTroopCount[$T], 0)
	Next
	For $S = 0 To $eSpellCount - 1
		$g_aiArmyCompSpells[$S] = 0
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$S], $g_aiArmyCompSpells[$S])
	Next
	GUICtrlSetData($g_hLblTotalTimeCamp, " 0s")
	GUICtrlSetData($g_hLblTotalTimeSpell, " 0s")
	GUICtrlSetData($g_hLblElixirCostCamp, "0")
	GUICtrlSetData($g_hLblDarkCostCamp, "0")
	GUICtrlSetData($g_hLblElixirCostSpell, "0")
	GUICtrlSetData($g_hLblDarkCostSpell, "0")
	GUICtrlSetData($g_hLblCountTotal, 0)
EndFunc   ;==>Removecamp

Func TrainTroopCountEdit()
    For $i = 0 To $eTroopCount - 1
	   If @GUI_CtrlId = $g_ahTxtTrainArmyTroopCount[$i] Then
		  $g_aiArmyCompTroops[$i] = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$i])
		  lblTotalCountTroop1()
		  Return
	   EndIf
    Next
EndFunc

Func TrainSpellCountEdit()
    For $i = 0 To $eSpellCount - 1
	   If @GUI_CtrlId = $g_ahTxtTrainArmySpellCount[$i] Then
		  $g_aiArmyCompSpells[$i] = GUICtrlRead($g_ahTxtTrainArmySpellCount[$i])
		  lblTotalCountSpell2()
		  Return
	   EndIf
    Next
EndFunc

Func chkAddDelayIdlePhaseEnable()
    $g_bTrainAddRandomDelayEnable = (GUICtrlRead($g_hChkTrainAddRandomDelayEnable) = $GUI_CHECKED)

    For $i = $g_hLblAddDelayIdlePhaseBetween to $g_hLblAddDelayIdlePhaseSec
	   GUICtrlSetState($i, $g_bTrainAddRandomDelayEnable ? $GUI_ENABLE : $GUI_DISABLE)
    Next
EndFunc   ;==>chkAddDelayIdlePhaseEnable
