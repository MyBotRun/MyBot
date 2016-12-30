; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), Boju (11-2016), MR.ViPER (11-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkUseQTrain()
	If GUICtrlRead($hChk_UseQTrain) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $hRadio_Army1 & "#" & $hRadio_Army2 & "#" & $hRadio_Army3)
		_GUI_Value_STATE("DISABLE", $grpTrainTroops)
		_GUI_Value_STATE("DISABLE", $grpCookSpell)
		GUICtrlSetData($lblTotalCountCamp, " 0s")
		GUICtrlSetData($lblTotalCountSpell, " 0s")
		GUICtrlSetData($lblElixirCostCamp, "0")
		GUICtrlSetData($lblDarkCostCamp, "0")
		GUICtrlSetData($lblElixirCostSpell, "0")
		GUICtrlSetData($lblDarkCostSpell, "0")
	Else
		_GUI_Value_STATE("DISABLE", $hRadio_Army1 & "#" & $hRadio_Army2 & "#" & $hRadio_Army3)
		_GUI_Value_STATE("ENABLE", $grpTrainTroops)
		_GUI_Value_STATE("ENABLE", $grpCookSpell)
		lblTotalCount()
		lblTotalCountSpell()
	EndIf
EndFunc   ;==>chkUseQTrain

Func SetComboTroopComp()
	Local $bWasRedraw = SetRedrawBotWindow(False)
	Local $ArmyCampTemp = 0

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED Then
		$ArmyCampTemp = Floor(GUICtrlRead($txtTotalCampForced) * GUICtrlRead($txtFullTroop) / 100)
	Else
		$ArmyCampTemp = Floor($TotalCamp * GUICtrlRead($txtFullTroop) / 100)
	EndIf

	Local $TotalTroopsTOtrain = 0

	lblTotalCount()
	SetRedrawBotWindow($bWasRedraw)
EndFunc   ;==>SetComboTroopComp

Func chkTotalCampForced()
	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED Then
		GUICtrlSetState($txtTotalCampForced, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtTotalCampForced, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTotalCampForced

Func lblTotalCount()

	Local $TotalTroopsTOtrain = 0
	Local $ArmyCampTemp = 0

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED Then
		$ArmyCampTemp = Floor(GUICtrlRead($txtTotalCampForced) * GUICtrlRead($txtFullTroop) / 100)
	Else
		$ArmyCampTemp = Floor($TotalCamp * GUICtrlRead($txtFullTroop) / 100)
	EndIf

	For $i = 0 To UBound($TroopName) - 1
		If GUICtrlRead(Eval("txtNum" & $TroopName[$i])) > 0 Then
			$TotalTroopsTOtrain += GUICtrlRead(Eval("txtNum" & $TroopName[$i])) * $TroopHeight[$i]
		Else
			GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), 0)
		EndIf
	Next

	GUICtrlSetData($lblCountTotal, String($TotalTroopsTOtrain))

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED And GUICtrlRead($lblCountTotal) = GUICtrlRead($txtTotalCampForced) Then
		GUICtrlSetBkColor($lblCountTotal, $COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($lblCountTotal) = $ArmyCampTemp Then
		GUICtrlSetBkColor($lblCountTotal, $COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($lblCountTotal) > $ArmyCampTemp / 2 And GUICtrlRead($lblCountTotal) < $ArmyCampTemp Then
		GUICtrlSetBkColor($lblCountTotal, $COLOR_ORANGE)
	Else
		GUICtrlSetBkColor($lblCountTotal, $COLOR_RED)
	EndIf

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED Then
		GUICtrlSetData($caltotaltroops, (Floor((GUICtrlRead($lblCountTotal) / GUICtrlRead($txtTotalCampForced)) * 100) < 1 ? (GUICtrlRead($lblCountTotal) > 0 ? 1 : 0) : Floor((GUICtrlRead($lblCountTotal) / GUICtrlRead($txtTotalCampForced)) * 100)))
	Else
		GUICtrlSetData($caltotaltroops, (Floor((GUICtrlRead($lblCountTotal) / $ArmyCampTemp) * 100) < 1 ? (GUICtrlRead($lblCountTotal) > 0 ? 1 : 0) : Floor((GUICtrlRead($lblCountTotal) / $ArmyCampTemp) * 100)))
	EndIf

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED And GUICtrlRead($lblCountTotal) > GUICtrlRead($txtTotalCampForced) Then
		GUICtrlSetState($lbltotalprogress, $GUI_SHOW)
	ElseIf GUICtrlRead($lblCountTotal) > $ArmyCampTemp Then
		GUICtrlSetState($lbltotalprogress, $GUI_SHOW)
	Else
		GUICtrlSetState($lbltotalprogress, $GUI_HIDE)
	EndIf

	lblTotalCount2()
EndFunc   ;==>lblTotalCount

Func lblTotalCount2()
	Local $TotalTotalTimeTroop = 0
	Local $NbrOfBarrack = 4 ;For the moment fix to 4 until fine detect level of each Barrack
	Local $NbrOfDarkBarrack = 2 ;For the moment fix to 2 until fine detect level of each Barrack
	For $i = 0 To UBound($TroopName) - 1
		Local $NbrOfTroop = GUICtrlRead(Eval("txtNum" & $TroopName[$i]))
		Local $LevOfTroop = Eval("itxtLev" & $TroopName[$i])
		If $NbrOfTroop > 0 And $LevOfTroop > 0 Then
			If $TroopType[$i] = "e" Then
				If IsInt($NbrOfTroop / $NbrOfBarrack) = 1 then
					$TotalTotalTimeTroop += ($NbrOfTroop / $NbrOfBarrack) * $TroopTimes[$i]
				Else
					$TotalTotalTimeTroop += (Ceiling($NbrOfTroop / $NbrOfBarrack)) * $TroopTimes[$i]
					$TotalTotalTimeTroop += ((Ceiling($NbrOfTroop / $NbrOfBarrack) - 1) - (Floor($NbrOfTroop / $NbrOfBarrack))) * $TroopTimes[$i]
				EndIf
			ElseIf $TroopType[$i] = "d" Then
				If IsInt($NbrOfTroop / $NbrOfDarkBarrack) = 1 then
					$TotalTotalTimeTroop += ($NbrOfTroop / $NbrOfDarkBarrack) * $TroopTimes[$i]
				Else
					$TotalTotalTimeTroop += (Ceiling($NbrOfTroop / $NbrOfDarkBarrack)) * $TroopTimes[$i]
					$TotalTotalTimeTroop += ((Ceiling($NbrOfTroop / $NbrOfDarkBarrack) - 1) - (Floor($NbrOfTroop / $NbrOfDarkBarrack))) * $TroopTimes[$i]
				EndIf
			EndIf
		EndIf
	Next

	$TotalTotalTimeTroop = CalculTimeTo($TotalTotalTimeTroop)
	GUICtrlSetData($lblTotalCountCamp, $TotalTotalTimeTroop)

	CalCostCamp()
EndFunc   ;==>lblTotalCount2

Func lblTotalCountSpell2()
	Local $tmpTotalTrainSpaceSpell = -1
	; calculate $iTotalTrainSpaceSpell value
	$tmpTotalTrainSpaceSpell = (Eval("LSpell" & "Comp") * 2) + (Eval("HSpell" & "Comp") * 2) + (Eval("RSpell" & "Comp") * 2) + (Eval("JSpell" & "Comp") * 2) + _
			(Eval("FSpell" & "Comp") * 2) + (Eval("CSpell" & "Comp") * 4) + Eval("PSpell" & "Comp") + Eval("HaSpell" & "Comp") + Eval("ESpell" & "Comp") + Eval("SkSpell" & "Comp")
	$iTotalTrainSpaceSpell = $tmpTotalTrainSpaceSpell
	;If $tmpTotalTrainSpaceSpell <> $iTotalTrainSpaceSpell Then
		If $iTotalTrainSpaceSpell < GUICtrlRead($txtTotalCountSpell) + 1 Then
			GUICtrlSetBkColor($txtNumLSpell, $COLOR_MONEYGREEN)
			GUICtrlSetBkColor($txtNumHSpell, $COLOR_MONEYGREEN)
			GUICtrlSetBkColor($txtNumRSpell, $COLOR_MONEYGREEN)
			GUICtrlSetBkColor($txtNumJSpell, $COLOR_MONEYGREEN)
			GUICtrlSetBkColor($txtNumFSpell, $COLOR_MONEYGREEN)
			GUICtrlSetBkColor($txtNumCSpell, $COLOR_MONEYGREEN)
			GUICtrlSetBkColor($txtNumPSpell, $COLOR_MONEYGREEN)
			GUICtrlSetBkColor($txtNumESpell, $COLOR_MONEYGREEN)
			GUICtrlSetBkColor($txtNumHaSpell, $COLOR_MONEYGREEN)
			GUICtrlSetBkColor($txtNumSkSpell, $COLOR_MONEYGREEN)
		Else
			GUICtrlSetBkColor($txtNumLSpell, $COLOR_RED)
			GUICtrlSetBkColor($txtNumHSpell, $COLOR_RED)
			GUICtrlSetBkColor($txtNumRSpell, $COLOR_RED)
			GUICtrlSetBkColor($txtNumFSpell, $COLOR_RED)
			GUICtrlSetBkColor($txtNumCSpell, $COLOR_RED)
			GUICtrlSetBkColor($txtNumJSpell, $COLOR_RED)
			GUICtrlSetBkColor($txtNumPSpell, $COLOR_RED)
			GUICtrlSetBkColor($txtNumESpell, $COLOR_RED)
			GUICtrlSetBkColor($txtNumHaSpell, $COLOR_RED)
			GUICtrlSetBkColor($txtNumSkSpell, $COLOR_RED)
		EndIf
	;EndIf

	Local $TotalTotalTimeSpell = 0
	$TotalTotalTimeSpell = (Eval("LSpell" & "Comp") * 360) + _
			(Eval("HSpell" & "Comp") * 360) + _
			(Eval("RSpell" & "Comp") * 360) + _
			(Eval("JSpell" & "Comp") * 360) + _
			(Eval("FSpell" & "Comp") * 360) + _
			(Eval("CSpell" & "Comp") * 360) + _
			(Eval("PSpell" & "Comp") * 180) + _
			(Eval("HaSpell" & "Comp") * 180) + _
			(Eval("ESpell" & "Comp") * 180) + _
			(Eval("SkSpell" & "Comp") * 180)
	$TotalTotalTimeSpell = CalculTimeTo($TotalTotalTimeSpell)
	GUICtrlSetData($lblTotalCountSpell, $TotalTotalTimeSpell)

	CalCostSpell()

EndFunc   ;==>lblTotalCountSpell2

Func lblTotalCountSpell()
	Local $bWasRedraw = SetRedrawBotWindow(False)
	_GUI_Value_STATE("HIDE", $groupListSpells)
	$iTownHallLevel = Int($iTownHallLevel)
	If $iTownHallLevel > 4 Or $iTownHallLevel = 0 Then
		If $itxtLevLSpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupLightning)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnLightning)
		EndIf
	Else
		GUICtrlSetData($txtNumLSpell, 0)
		GUICtrlSetData($txtNumRSpell, 0)
		GUICtrlSetData($txtNumHSpell, 0)
		GUICtrlSetData($txtNumJSpell, 0)
		GUICtrlSetData($txtNumFSpell, 0)
		GUICtrlSetData($txtNumCSpell, 0)
		GUICtrlSetData($txtNumPSpell, 0)
		GUICtrlSetData($txtNumESpell, 0)
		GUICtrlSetData($txtNumHaSpell, 0)
		GUICtrlSetData($txtNumSkSpell, 0)
		GUICtrlSetData($txtTotalCountSpell, 0)
		GUICtrlSetData($txtLevLSpell, 0)
		GUICtrlSetData($txtLevRSpell, 0)
		GUICtrlSetData($txtLevHSpell, 0)
		GUICtrlSetData($txtLevJSpell, 0)
		GUICtrlSetData($txtLevFSpell, 0)
		GUICtrlSetData($txtLevCSpell, 0)
		GUICtrlSetData($txtLevPSpell, 0)
		GUICtrlSetData($txtLevESpell, 0)
		GUICtrlSetData($txtLevHaSpell, 0)
		GUICtrlSetData($txtLevSkSpell, 0)
	EndIf
	If $iTownHallLevel > 5 Or $iTownHallLevel = 0 Then
		If $itxtLevHSpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupHeal)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnHeal)
		EndIf
	Else
		GUICtrlSetData($txtNumRSpell, 0)
		GUICtrlSetData($txtNumJSpell, 0)
		GUICtrlSetData($txtNumFSpell, 0)
		GUICtrlSetData($txtNumCSpell, 0)
		GUICtrlSetData($txtNumPSpell, 0)
		GUICtrlSetData($txtNumESpell, 0)
		GUICtrlSetData($txtNumHaSpell, 0)
		GUICtrlSetData($txtNumSkSpell, 0)
		GUICtrlSetData($txtLevRSpell, 0)
		GUICtrlSetData($txtLevJSpell, 0)
		GUICtrlSetData($txtLevFSpell, 0)
		GUICtrlSetData($txtLevCSpell, 0)
		GUICtrlSetData($txtLevPSpell, 0)
		GUICtrlSetData($txtLevESpell, 0)
		GUICtrlSetData($txtLevHaSpell, 0)
		GUICtrlSetData($txtLevSkSpell, 0)
	EndIf
	If $iTownHallLevel > 6 Or $iTownHallLevel = 0 Then
		If $itxtLevRSpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupRage)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnRage)
		EndIf
	Else
		GUICtrlSetData($txtNumJSpell, 0)
		GUICtrlSetData($txtNumFSpell, 0)
		GUICtrlSetData($txtNumCSpell, 0)
		GUICtrlSetData($txtNumPSpell, 0)
		GUICtrlSetData($txtNumESpell, 0)
		GUICtrlSetData($txtNumHaSpell, 0)
		GUICtrlSetData($txtNumSkSpell, 0)
		GUICtrlSetData($txtLevJSpell, 0)
		GUICtrlSetData($txtLevFSpell, 0)
		GUICtrlSetData($txtLevCSpell, 0)
		GUICtrlSetData($txtLevPSpell, 0)
		GUICtrlSetData($txtLevESpell, 0)
		GUICtrlSetData($txtLevHaSpell, 0)
		GUICtrlSetData($txtLevSkSpell, 0)
	EndIf
	If $iTownHallLevel > 7 Or $iTownHallLevel = 0 Then
		If $itxtLevPSpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupPoison)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnPoison)
		EndIf
		If $itxtLevESpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupEarthquake)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnEarthquake)
		EndIf
	Else
		GUICtrlSetData($txtNumJSpell, 0)
		GUICtrlSetData($txtNumFSpell, 0)
		GUICtrlSetData($txtNumCSpell, 0)
		GUICtrlSetData($txtNumHaSpell, 0)
		GUICtrlSetData($txtNumSkSpell, 0)
		GUICtrlSetData($txtLevJSpell, 0)
		GUICtrlSetData($txtLevFSpell, 0)
		GUICtrlSetData($txtLevCSpell, 0)
		GUICtrlSetData($txtLevHaSpell, 0)
		GUICtrlSetData($txtLevSkSpell, 0)
	EndIf
	If $iTownHallLevel > 8 Or $iTownHallLevel = 0 Then
		If $itxtLevJSpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupJumpSpell)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnJumpSpell)
		EndIf
		If $itxtLevFSpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupFreeze)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnFreeze)
		EndIf
		If $itxtLevHaSpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupHaste)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnHaste)
		EndIf
		If $itxtLevSkSpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupSkeleton)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnSkeleton)
		EndIf
	Else
		GUICtrlSetData($txtNumCSpell, 0)
		GUICtrlSetData($txtLevCSpell, 0)
	EndIf
	If $iTownHallLevel > 9 Or $iTownHallLevel = 0 Then
		If $itxtLevCSpell > 0 Then
			_GUI_Value_STATE("SHOW", $groupClone)
		Else
			_GUI_Value_STATE("SHOW", $groupIcnClone)
		EndIf
	EndIf
;~ 	Local $TotalTotalTimeSpell = 0
;~ 	$TotalTotalTimeSpell += Eval("LSpell" & "Comp") * 360
;~ 	$TotalTotalTimeSpell += Eval("HSpell" & "Comp") * 360
;~ 	$TotalTotalTimeSpell += Eval("RSpell" & "Comp") * 360
;~ 	$TotalTotalTimeSpell += Eval("JSpell" & "Comp") * 360
;~ 	$TotalTotalTimeSpell += Eval("FSpell" & "Comp") * 360
;~ 	$TotalTotalTimeSpell += Eval("CSpell" & "Comp") * 360
;~ 	$TotalTotalTimeSpell += Eval("PSpell" & "Comp") * 180
;~ 	$TotalTotalTimeSpell += Eval("ESpell" & "Comp") * 180
;~ 	$TotalTotalTimeSpell += Eval("HaSpell" & "Comp") * 180
;~ 	$TotalTotalTimeSpell += Eval("SkSpell" & "Comp") * 180

;~ 	$TotalTotalTimeSpell = CalculTimeTo($TotalTotalTimeSpell)
;~ 	GUICtrlSetData($lblTotalCountSpell, $TotalTotalTimeSpell)

;~ 	CalCostSpell()
	SetRedrawBotWindow($bWasRedraw)
EndFunc   ;==>lblTotalCountSpell

Func chkBoostBarracksHoursE1()
	If GUICtrlRead($chkBoostBarracksHoursE1) = $GUI_CHECKED And GUICtrlRead($chkBoostBarracksHours0) = $GUI_CHECKED Then
		For $i = $chkBoostBarracksHours0 To $chkBoostBarracksHours11
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkBoostBarracksHours0 To $chkBoostBarracksHours11
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkBoostBarracksHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE1

Func chkBoostBarracksHoursE2()
	If GUICtrlRead($chkBoostBarracksHoursE2) = $GUI_CHECKED And GUICtrlRead($chkBoostBarracksHours12) = $GUI_CHECKED Then
		For $i = $chkBoostBarracksHours12 To $chkBoostBarracksHours23
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkBoostBarracksHours12 To $chkBoostBarracksHours23
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkBoostBarracksHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE2

Func chkCloseWaitEnable()
	If GUICtrlRead($chkCloseWaitEnable) = $GUI_CHECKED Then
		$ichkCloseWaitEnable = 1
		_GUI_Value_STATE("ENABLE", $groupCloseWaitTrain)
		_GUI_Value_STATE("ENABLE", $lblCloseWaitingTroops & "#" & $cmbMinimumTimeClose & "#" & $lblSymbolWaiting & "#" & $lblWaitingInMinutes)
	Else
		$ichkCloseWaitEnable = 0
		_GUI_Value_STATE("DISABLE", $groupCloseWaitTrain)
		_GUI_Value_STATE("DISABLE", $lblCloseWaitingTroops & "#" & $cmbMinimumTimeClose & "#" & $lblSymbolWaiting & "#" & $lblWaitingInMinutes)
	EndIf
	If GUICtrlRead($btnCloseWaitStopRandom) = $GUI_CHECKED Then
		GUICtrlSetState($btnCloseWaitStop, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		If GUICtrlRead($chkCloseWaitEnable) = $GUI_CHECKED Then GUICtrlSetState($btnCloseWaitStop, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkCloseWaitEnable

Func chkCloseWaitTrain()
	If GUICtrlRead($chkCloseWaitTrain) = $GUI_CHECKED Then
		$ichkCloseWaitTrain = 1
	Else
		$ichkCloseWaitTrain = 0
	EndIf
EndFunc   ;==>chkCloseWaitTrain

Func btnCloseWaitStop()
	If GUICtrlRead($btnCloseWaitStop) = $GUI_CHECKED Then
		$ibtnCloseWaitStop = 1
	Else
		$ibtnCloseWaitStop = 0
	EndIf
EndFunc   ;==>btnCloseWaitStop

Func btnCloseWaitStopRandom()
	If GUICtrlRead($btnCloseWaitStopRandom) = $GUI_CHECKED Then
		$ibtnCloseWaitStopRandom = 1
		$ibtnCloseWaitStop = 0
		GUICtrlSetState($btnCloseWaitStop, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		$ibtnCloseWaitStopRandom = 0
		If GUICtrlRead($chkCloseWaitEnable) = $GUI_CHECKED Then GUICtrlSetState($btnCloseWaitStop, $GUI_ENABLE)
	EndIf
EndFunc   ;==>btnCloseWaitStopRandom

Func btnCloseWaitRandom()
	If GUICtrlRead($btnCloseWaitExact) = $GUI_CHECKED Then
		$ibtnCloseWaitExact = 1
		$ibtnCloseWaitRandom = 0
		GUICtrlSetState($cmbCloseWaitRdmPercent, $GUI_DISABLE)
	ElseIf GUICtrlRead($btnCloseWaitRandom) = $GUI_CHECKED Then
		$ibtnCloseWaitExact = 0
		$ibtnCloseWaitRandom = 1
		If GUICtrlRead($chkCloseWaitEnable) = $GUI_CHECKED Then GUICtrlSetState($cmbCloseWaitRdmPercent, $GUI_ENABLE)
	Else
		$ibtnCloseWaitExact = 0
		$ibtnCloseWaitRandom = 0
		GUICtrlSetState($cmbCloseWaitRdmPercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnCloseWaitRandom

Func sldTrainITDelay()
	$isldTrainITDelay = GUICtrlRead($sldTrainITDelay)
	GUICtrlSetData($lbltxtTrainITDelayTime, $isldTrainITDelay & " ms")
EndFunc   ;==>sldTrainITDelay

Func chkTroopOrder2()
	;GUI OnEvent functions cannot have parameters, so below call is used for the default parameter
	chkTroopOrder()
EndFunc   ;==>chkTroopOrder2

Func chkTroopOrder($bNoiseMode = True)
	If GUICtrlRead($chkTroopOrder) = $GUI_CHECKED Then
		$ichkTroopOrder = 1
		GUICtrlSetState($btnTroopOrderSet, $GUI_ENABLE)
		For $i = 0 To UBound($aTroopOrderList) - 2
			GUICtrlSetState($cmbTroopOrder[$i], $GUI_ENABLE)
		Next
		If IsUseCustomTroopOrder() = True Then GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnRedLight)
	Else
		$ichkTroopOrder = 0
		GUICtrlSetState($btnTroopOrderSet, $GUI_DISABLE) ; disable button
		For $i = 0 To UBound($aTroopOrderList) - 2
			GUICtrlSetState($cmbTroopOrder[$i], $GUI_DISABLE) ; disable combo boxes
		Next
		SetDefaultTroopGroup($bNoiseMode) ; Reset troopgroup values to default
		If $bNoiseMode Or $debugsetlogTrain = 1 Then
			Local $sNewTrainList = ""
			For $i = 0 To UBound($DefaultTroopGroup) - 1
				$sNewTrainList &= $TroopName[$i] & ", "
			Next
			$sNewTrainList = StringLeft($sNewTrainList, StringLen($sNewTrainList) - 2)
			Setlog("Current train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	EndIf
EndFunc   ;==>chkTroopOrder
#CS
Func chkDarkTroopOrder2()
	;GUI OnEvent functions cannot have parameters, so below call is used for the default parameter
	chkDarkTroopOrder()
EndFunc   ;==>chkDarkTroopOrder2

Func chkDarkTroopOrder($bNoiseMode = True)
	If GUICtrlRead($chkDarkTroopOrder) = $GUI_CHECKED Then
		$ichkDarkTroopOrder = 1
		GUICtrlSetState($btnDarkTroopOrderSet, $GUI_ENABLE)
		For $i = 0 To UBound($aDarkTroopOrderList) - 2
			GUICtrlSetState($cmbDarkTroopOrder[$i], $GUI_ENABLE)
		Next
		If IsUseCustomDarkTroopOrder() = True Then GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnRedLight)
	Else
		$ichkDarkTroopOrder = 0
		GUICtrlSetState($btnDarkTroopOrderSet, $GUI_DISABLE) ; disable button
		For $i = 0 To UBound($aDarkTroopOrderList) - 2
			GUICtrlSetState($cmbDarkTroopOrder[$i], $GUI_DISABLE) ; disable combo boxes
		Next
		SetDefaultTroopGroupDark($bNoiseMode) ; Reset troopgroup values to default
		If $bNoiseMode Or $debugsetlogTrain = 1 Then
			Local $sNewTrainList = ""
			For $i = 0 To UBound($DefaultTroopGroupDark) - 1
				$sNewTrainList &= $TroopDarkName[$i] & ", "
			Next
			$sNewTrainList = StringLeft($sNewTrainList, StringLen($sNewTrainList) - 2)
			Setlog("Current train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	EndIf
EndFunc   ;==>chkDarkTroopOrder
 #CE
Func GUITrainOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1 ; record control ID for $ImgTroopOrder[$z] based on control of combobox that called this function
	Local $iTroopIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1 ; find zero based index number of troop selected in combo box, add one for enum of proper icon

	GUICtrlSetImage($iCtrlIdImage, $pIconLib, $aTroopOrderIcon[$iTroopIndex]) ; set proper troop icon

	For $i = 0 To UBound($aTroopOrderList) - 2 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $cmbTroopOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$i]) Then
			GUICtrlSetImage($ImgTroopOrder[$i], $pIconLib, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($cmbTroopOrder[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next
	If $bDuplicate = True Then
		GUICtrlSetState($BtnTroopOrderSet, $GUI_DISABLE) ; enable button to apply new order
		Return
	Else
		GUICtrlSetState($BtnTroopOrderSet, $GUI_ENABLE) ; enable button to apply new order
		GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnRedLight) ; set status indicator to show need to apply new order
	EndIf
EndFunc   ;==>GUITrainOrder
#CS
Func GUITrainDarkOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1 ; record control ID for $ImgTroopOrder[$z] based on control of combobox that called this function
	Local $iTroopIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1 ; find zero based index number of troop selected in combo box, add one for enum of proper icon

	GUICtrlSetImage($iCtrlIdImage, $pIconLib, $aDarkTroopOrderIcon[$iTroopIndex]) ; set proper troop icon

	For $i = 0 To UBound($aDarkTroopOrderList) - 2 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $cmbDarkTroopOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$i]) Then
			GUICtrlSetImage($ImgDarkTroopOrder[$i], $pIconLib, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($cmbDarkTroopOrder[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next
	If $bDuplicate = True Then
		GUICtrlSetState($BtnDarkTroopOrderSet, $GUI_DISABLE) ; enable button to apply new order
		Return
	Else
		GUICtrlSetState($BtnDarkTroopOrderSet, $GUI_ENABLE) ; enable button to apply new order
		GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnRedLight) ; set status indicator to show need to apply new order
	EndIf
EndFunc   ;==>GUITrainDarkOrder
 #CE
Func BtnTroopOrderSet()
	SetRedrawBotWindow(False)
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewTrainList = ""

	; check for duplicate combobox index and flag with read color
	For $i = 0 To UBound($aTroopOrderList) - 2
		For $j = 0 To UBound($aTroopOrderList) - 2
			If $i = $j Then ContinueLoop ; skip if index are same
			If _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$i]) = _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$j]) Then
				_GUICtrlComboBox_SetCurSel($cmbTroopOrder[$j], -1)
				GUICtrlSetImage($ImgTroopOrder[$j], $pIconLib, $eIcnOptions)
				$bReady = False
			Else
				GUICtrlSetColor($cmbTroopOrder[$j], $COLOR_BLACK)
			EndIf
			$icmbTroopOrder[$i] = _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$i]) ; update combo array variable with new value
		Next
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
			GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnRedLight)
		Else
			Setlog("Troop training order changed successfully!", $COLOR_GREEN)
			For $i = 0 To UBound($DefaultTroopGroup) - 1
				$sNewTrainList &= $TroopName[$i] & ", "
			Next
			Setlog("Troop train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	Else
		Setlog("Must use all troops and No duplicate troop names!", $COLOR_RED)
		GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnRedLight)
	EndIf
	GUICtrlSetState(BtnTroopOrderSet, $GUI_DISABLE)
	SetRedrawBotWindow(True)
EndFunc   ;==>BtnTroopOrderSet
#CS
Func BtnDarkTroopOrderSet()
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewTrainList = ""

	; check for duplicate combobox index and flag with read color
	For $i = 0 To UBound($aDarkTroopOrderList) - 2
		For $j = 0 To UBound($aDarkTroopOrderList) - 2
			If $i = $j Then ContinueLoop ; skip if index are same
			If _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$i]) = _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$j]) Then
				_GUICtrlComboBox_SetCurSel($cmbDarkTroopOrder[$j], -1)
				GUICtrlSetImage($ImgDarkTroopOrder[$j], $pIconLib, $eIcnOptions)
				$bReady = False
			Else
				GUICtrlSetColor($cmbDarkTroopOrder[$j], $COLOR_BLACK)
			EndIf
			$icmbDarkTroopOrder[$i] = _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$i]) ; update combo array variable with new value
		Next
	Next
	If $bReady Then
		ChangeDarkTroopTrainOrder() ; code function to record new training order
		If @error Then
			Switch @error
				Case 1
					Setlog("Code problem, can not continue till fixed!", $COLOR_RED)
				Case 2
					Setlog("Bad Combobox selections, please fix!", $COLOR_RED)
				Case 3
					Setlog("Unable to Change Dark Troop Train Order due bad change count!", $COLOR_RED)
				Case Else
					Setlog("Monkey ate bad banana, something wrong with ChangeDarkTroopTrainOrder() code!", $COLOR_RED)
			EndSwitch
			GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnRedLight)
		Else
			Setlog("Troop training order changed successfully!", $COLOR_GREEN)
			For $i = 0 To UBound($DefaultTroopGroupDark) - 1
				$sNewTrainList &= $TroopDarkName[$i] & ", "
			Next
			Setlog("Troop train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	Else
		Setlog("Must use all dark troops and No duplicate troop names!", $COLOR_RED)
		GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnRedLight)
	EndIf
	GUICtrlSetState($BtnDarkTroopOrderSet, $GUI_DISABLE)
EndFunc   ;==>BtnDarkTroopOrderSet
 #CE
Func ChangeTroopTrainOrder()

	If $debugsetlog = 1 Or $debugsetlogTrain = 1 Then Setlog("Begin Func ChangeTroopTrainOrder()", $COLOR_DEBUG) ;Debug

	; reference for original troopgroup list
	;$TroopGroup[10][3] = [["Arch", 1, 1], ["Giant", 2, 5], ["Wall", 4, 2], ["Barb", 0, 1], ["Gobl", 3, 1], ["Heal", 7, 14], ["Pekk", 9, 25], ["Ball", 5, 5], ["Wiza", 6, 4], ["Drag", 8, 20]]

	Local $sComboText = ""
	Local $NewTroopGroup[19][6]
	Local $iUpdateCount = 0

	If UBound($aTroopOrderList) - 1 <> UBound($TroopGroup) Then ; safety check in case troops are added
		If $debugsetlogTrain = 1 Then Setlog("UBound($aTroopOrderList) - 1: " & UBound($aTroopOrderList) - 1 & " = " & UBound($TroopGroup) & "UBound($TroopGroup)", $COLOR_DEBUG) ;Debug
		Setlog("Monkey ate bad banana, fix $aTroopOrderList & $TroopGroup arrays!", $COLOR_RED)
		SetError(1, 0, False)
		Return
	EndIf

	If IsUseCustomTroopOrder() = False Then ; check if no custom troop values saved yet.
		SetError(2, 0, False)
		Return
	EndIf

	For $i = 0 To UBound($aTroopOrderList) - 2 ; Look for match of combobox text to troopgroup and create new train order
		$sComboText = StringLeft(StringStripWS(GUICtrlRead($cmbTroopOrder[$i]), $STR_STRIPALL), 5)
		For $j = 0 To UBound($DefaultTroopGroup) - 1
			;Setlog("$i=" & $i & ", ComboSel=" & _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$i]) & ", $DefaultTroopGroup[" & $j & "][0]: " & $DefaultTroopGroup[$j][0] & " = " & $sComboText& " :$sComboText" , $COLOR_DEBUG) ;Debug
			If StringInStr($sComboText, $j > 11 ? StringLeft($DefaultTroopGroup[$j][0], 3) : $DefaultTroopGroup[$j][0], $STR_NOCASESENSEBASIC) = 0 Then ContinueLoop
			$iUpdateCount += 1 ; keep count of troops updated to ensure success
			;Setlog("$iUpdateCount: " & $iUpdateCount , $COLOR_DEBUG) ;Debug  ; debug
			For $k = 0 To UBound($DefaultTroopGroup, 2) - 1 ; if true then assign next $i array element(s) in list to match in troopgroup
				$NewTroopGroup[$i][$k] = $DefaultTroopGroup[$j][$k]
			Next ; ; $NewTroopGroup[$i][$k] loop
			ExitLoop
		Next ; $DefaultTroopGroup[$j][x] loop
	Next ; $cmbTroopOrder[$i] loop

	If $iUpdateCount = UBound($DefaultTroopGroup, 1) Then ; safety check that all troops properly assigned to new array.
		For $j = 0 To UBound($DefaultTroopGroup) - 1
			For $k = 0 To UBound($DefaultTroopGroup, 2) - 1
				$TroopGroup[$j][$k] = $NewTroopGroup[$j][$k]
			Next
			If $debugsetlogTrain = 1 Then Setlog("$TroopGroup[" & $j & "]= " & $TroopGroup[$j][0] & ":" & $TroopGroup[$j][1] & ":" & $TroopGroup[$j][2], $COLOR_ORANGE)
		Next
		For $i = 0 To UBound($TroopGroup, 1) - 1
			$TroopName[$i] = $TroopGroup[$i][0]
			$TroopNamePosition[$i] = $TroopGroup[$i][1]
			$TroopHeight[$i] = $TroopGroup[$i][2]
			$TroopTimes[$i] = $TroopGroup[$i][3]
			$TroopDons[$i] = $TroopGroup[$i][4]
			$TroopType[$i] = $TroopGroup[$i][5]
		Next
		GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnGreenLight)
	Else
		Setlog($iUpdateCount & "|" & UBound($DefaultTroopGroup, 1) & " - Error - Bad troop assignment in ChangeTroopTrainOrder()", $COLOR_RED)
		SetError(3, 0, False)
		Return
	EndIf

	Return True

EndFunc   ;==>ChangeTroopTrainOrder
#CS
Func ChangeDarkTroopTrainOrder()

	If $debugsetlog = 1 Or $debugsetlogTrain = 1 Then Setlog("Begin Func ChangeDarkTroopTrainOrder()", $COLOR_DEBUG) ;Debug

	Local $sComboText = ""
	Local $NewTroopGroup[7][3]
	Local $iUpdateCount = 0

	If UBound($aDarkTroopOrderList) - 1 <> UBound($TroopGroupDark) Then ; safety check in case troops are added
		If $debugsetlogTrain = 1 Then Setlog("UBound($aDarkTroopOrderList) - 1: " & UBound($aDarkTroopOrderList) - 1 & " = " & UBound($TroopGroupDark) & "UBound($TroopGroupDark)", $COLOR_DEBUG) ;Debug
		Setlog("Monkey ate bad banana, fix $aDarkTroopOrderList & $TroopGroupDark arrays!", $COLOR_RED)
		SetError(1, 0, False)
		Return
	EndIf

	If IsUseCustomDarkTroopOrder() = False Then ; check if no custom troop values saved yet.
		SetError(2, 0, False)
		Return
	EndIf

	For $i = 0 To UBound($aDarkTroopOrderList) - 2 ; Look for match of combobox text to troopgroup and create new train order
		$sComboText = StringLeft(StringStripWS(GUICtrlRead($cmbDarkTroopOrder[$i]), $STR_STRIPALL), 5)
		For $j = 0 To UBound($DefaultTroopGroupDark) - 1
			;Setlog("$i=" & $i & ", ComboSel=" & _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$i]) & ", $DefaultTroopGroupDark[" & $j & "][0]: " & StringLeft($DefaultTroopGroupDark[$j][0], 3) & " = " & $sComboText& " :$sComboText" , $COLOR_DEBUG) ;Debug
			If StringInStr($sComboText, StringLeft($DefaultTroopGroupDark[$j][0], 3), $STR_NOCASESENSEBASIC) = 0 Then ContinueLoop
			$iUpdateCount += 1 ; keep count of troops updated to ensure success
			;Setlog("$iUpdateCount: " & $iUpdateCount , $COLOR_DEBUG) ;Debug  ; debug
			For $k = 0 To UBound($DefaultTroopGroupDark, 2) - 1 ; if true then assign next $i array element(s) in list to match in troopgroup
				$NewTroopGroup[$i][$k] = $DefaultTroopGroupDark[$j][$k]
			Next ; ; $NewTroopGroupDark[$i][$k] loop
			ExitLoop
		Next ; $DefaultTroopGroupDark[$j][x] loop
	Next ; $cmbDarkTroopOrder[$i] loop

	If $iUpdateCount = UBound($DefaultTroopGroupDark, 1) Then ; safety check that all troops properly assigned to new array.
		For $j = 0 To UBound($DefaultTroopGroupDark) - 1
			For $k = 0 To UBound($DefaultTroopGroupDark, 2) - 1
				$TroopGroupDark[$j][$k] = $NewTroopGroup[$j][$k]
			Next
			If $debugsetlogTrain = 1 Then Setlog("$TroopGroupDark[" & $j & "]= " & $TroopGroupDark[$j][0] & ":" & $TroopGroupDark[$j][1] & ":" & $TroopGroupDark[$j][2], $COLOR_ORANGE)
		Next
		For $i = 0 To UBound($TroopGroupDark, 1) - 1
			$TroopDarkName[$i] = $TroopGroupDark[$i][0]
			$TroopDarkNamePosition[$i] = $TroopGroupDark[$i][1]
			$TroopDarkHeight[$i] = $TroopGroupDark[$i][2]
			$TroopDarkTimes[$i] = $TroopGroupDark[$i][3]
		Next
		GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnGreenLight)
	Else
		Setlog("Error - Bad troop assignment in ChangeDarkTroopTrainOrder()", $COLOR_RED)
		SetError(3, 0, False)
		Return
	EndIf

	Return True

EndFunc   ;==>ChangeDarkTroopTrainOrder
 #CE
Func SetDefaultTroopGroup($bNoiseMode = True)
	;
	; $TroopGroup[10][3] = [["Arch", 1, 1], ["Giant", 2, 5], ["Wall", 4, 2], ["Barb", 0, 1], ["Gobl", 3, 1], ["Heal", 7, 14], ["Pekk", 9, 25], ["Ball", 5, 5], ["Wiza", 6, 4], ["Drag", 8, 20]]
	;
	_ArraySortEx($DefaultTroopGroup, 0, 0, 3, 1, 2, 0)
	For $i = 0 To UBound($DefaultTroopGroup, 1) - 1
		For $j = 0 To UBound($DefaultTroopGroup, 2) - 1
			$TroopGroup[$i][$j] = $DefaultTroopGroup[$i][$j]
		Next
	Next
	For $i = 0 To UBound($DefaultTroopGroup, 1) - 1
		$TroopName[$i] = $TroopGroup[$i][0]
		$TroopNamePosition[$i] = $TroopGroup[$i][1]
		$TroopHeight[$i] = $TroopGroup[$i][2]
		$TroopTimes[$i] = $TroopGroup[$i][3]
		$TroopDons[$i] = $TroopGroup[$i][4]
		$TroopType[$i] = $TroopGroup[$i][5]
	Next
#CS
	For $i = 0 To UBound($DefaultTroopGroupElixir, 1) - 1
		$TroopElixirName[$i] = $DefaultTroopGroupElixir[$i][0]
		$TroopElixirNamePosition[$i] = $DefaultTroopGroupElixir[$i][1]
		$TroopElixirHeight[$i] = $DefaultTroopGroupElixir[$i][2]
		$TroopElixirTimes[$i] = $DefaultTroopGroupElixir[$i][3]
	Next
 #CE
	If $bNoiseMode Or $debugsetlogTrain = 1 Then Setlog("Default troop training order set", $COLOR_GREEN)
EndFunc   ;==>SetDefaultTroopGroup
#CS
Func SetDefaultTroopGroupDark($bNoiseMode = True)
	;
	; $DefaultTroopGroupDark[7][3] = [["Mini", 0, 2], ["Hogs", 1, 5], ["Valk", 2, 8], ["Gole", 3, 30], ["Witc", 4, 12], ["Lava", 5, 30], ["Bowl", 6, 6]]
	;
	For $i = 0 To UBound($DefaultTroopGroupDark, 1) - 1
		For $j = 0 To UBound($DefaultTroopGroupDark, 2) - 1
			$TroopGroupDark[$i][$j] = $DefaultTroopGroupDark[$i][$j]
		Next
	Next
	For $i = 0 To UBound($DefaultTroopGroupDark, 1) - 1
		$TroopDarkName[$i] = $TroopGroupDark[$i][0]
		$TroopDarkNamePosition[$i] = $TroopGroupDark[$i][1]
		$TroopDarkHeight[$i] = $TroopGroupDark[$i][2]
		$TroopDarkTimes[$i] = $TroopGroupDark[$i][3]
	Next
	If $bNoiseMode Or $debugsetlogTrain = 1 Then Setlog("Default dark troop training order set", $COLOR_GREEN)
EndFunc   ;==>SetDefaultTroopGroupDark
 #CE
Func IsUseCustomTroopOrder()
	For $i = 0 To UBound($aTroopOrderList) - 2 ; Check if custom train order has been used to select log message
		If $icmbTroopOrder[$i] = -1 Then
			If $debugsetlogTrain = 1 Then Setlog("Custom train order not used...", $COLOR_DEBUG) ;Debug
			Return False
		EndIf
	Next
	If $debugsetlogTrain = 1 Then Setlog("Custom train order used...", $COLOR_DEBUG) ;Debug
	Return True
EndFunc   ;==>IsUseCustomTroopOrder
#CS
Func IsUseCustomDarkTroopOrder()
	For $i = 0 To UBound($aDarkTroopOrderList) - 2 ; Check if custom train order has been used to select log message
		If $icmbDarkTroopOrder[$i] = -1 Then
			If $debugsetlogTrain = 1 Then Setlog("Custom dark train order not used...", $COLOR_DEBUG) ;Debug
			Return False
		EndIf
	Next
	If $debugsetlogTrain = 1 Then Setlog("Custom dark train order used...", $COLOR_DEBUG) ;Debug
	Return True
EndFunc   ;==>IsUseCustomDarkTroopOrder
 #CE

; ============================================================================
; ================================= SmartZap =================================
; ============================================================================
Func chkSmartLightSpell()
	If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED Then
		GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_ENABLE)
		GUICtrlSetState($txtMinDark, $GUI_ENABLE)
		GUICtrlSetState($chkNoobZap, $GUI_ENABLE)
		GUICtrlSetState($lblLSpell, $GUI_SHOW)
		If GUICtrlRead($chkNoobZap) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkEarthQuakeZap, $GUI_ENABLE)
		Else
			GUICtrlSetState($chkEarthQuakeZap, $GUI_UNCHECKED)
			GUICtrlSetState($chkEarthQuakeZap, $GUI_DISABLE)
			GUICtrlSetState($lblEQZap, $GUI_HIDE)
		EndIf
		$ichkSmartZap = 1
	Else
		GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_DISABLE)
		GUICtrlSetState($txtMinDark, $GUI_DISABLE)
		GUICtrlSetState($chkNoobZap, $GUI_DISABLE)
		GUICtrlSetState($chkEarthQuakeZap, $GUI_DISABLE)
		GUICtrlSetState($lblLSpell, $GUI_HIDE)
		$ichkSmartZap = 0
	EndIf
EndFunc   ;==>chkSmartLightSpell

Func chkNoobZap()
	If GUICtrlRead($chkNoobZap) = $GUI_CHECKED Then
		GUICtrlSetState($txtExpectedDE, $GUI_ENABLE)
		GUICtrlSetState($chkEarthQuakeZap, $GUI_UNCHECKED)
		GUICtrlSetState($chkEarthQuakeZap, $GUI_DISABLE)
		GUICtrlSetState($lblEQZap, $GUI_HIDE)
		$ichkNoobZap = 1
	Else
		GUICtrlSetState($txtExpectedDE, $GUI_DISABLE)
		GUICtrlSetState($chkEarthQuakeZap, $GUI_ENABLE)
		$ichkNoobZap = 0
	EndIf
EndFunc   ;==>chkNoobZap

Func chkEarthQuakeZap()
	If GUICtrlRead($chkEarthQuakeZap) = $GUI_CHECKED Then
		GUICtrlSetState($lblEQZap, $GUI_SHOW)
		$ichkEarthQuakeZap = 1
	Else
		GUICtrlSetState($lblEQZap, $GUI_HIDE)
		$ichkEarthQuakeZap = 0
	EndIf
EndFunc   ;==>chkEarthQuakeZap

Func chkSmartZapDB()
    If GUICtrlRead($chkSmartZapDB) = $GUI_CHECKED Then
        $ichkSmartZapDB = 1
    Else
        $ichkSmartZapDB = 0
    EndIf
EndFunc   ;==>chkSmartZapDB

Func chkSmartZapSaveHeroes()
    If GUICtrlRead($chkSmartZapSaveHeroes) = $GUI_CHECKED Then
        $ichkSmartZapSaveHeroes = 1
    Else
        $ichkSmartZapSaveHeroes = 0
    EndIf
EndFunc   ;==>chkSmartZapSaveHeroes

Func txtMinDark()
	$itxtMinDE = GUICtrlRead($txtMinDark)
EndFunc   ;==>txtMinDark

Func txtExpectedDE()
	$itxtExpectedDE = GUICtrlRead($txtExpectedDE)
EndFunc   ;==>TxtExpectedDE
; ============================================================================
; ================================= SmartZap =================================
; ============================================================================

Func LevUpDown($SelTroopSpell, $NoChangeLev = True)
	Local $MaxLev = UBound(Eval("Lev" & $SelTroopSpell & "Cost"), 1)
	Local $LevColor = $COLOR_WHITE
	Local $TempLev
	If $NoChangeLev Then
		If _IsPressed("10") Or _IsPressed("02") Then
			$TempLev = Eval("itxtLev" & $SelTroopSpell) - 1
		Else
			$TempLev = Eval("itxtLev" & $SelTroopSpell) + 1
		EndIf
	Else
		$TempLev = Eval("itxtLev" & $SelTroopSpell)
	EndIf
	If $TempLev > $MaxLev - 1 Or $TempLev = 0 Then
		$TempLev = 0
		GUICtrlSetData(Eval("txtNum" & $SelTroopSpell), 0)
		Assign($SelTroopSpell & "Comp", 0)
		If IsGUICtrlHidden(Eval("txtNum" & $SelTroopSpell)) = False Then GUICtrlSetState(Eval("txtNum" & $SelTroopSpell), $GUI_HIDE)
		Call("lblTotalCount" & $SelTroopSpell)
	ElseIf $TempLev < 0 Then
		$TempLev = $MaxLev - 1
		If IsGUICtrlHidden(Eval("txtNum" & $SelTroopSpell)) Then GUICtrlSetState(Eval("txtNum" & $SelTroopSpell), $GUI_SHOW)
	ElseIf $TempLev > 0 And $TempLev <= $MaxLev And IsGUICtrlHidden(Eval("txtNum" & $SelTroopSpell)) Then
		GUICtrlSetState(Eval("txtNum" & $SelTroopSpell), $GUI_SHOW)
	EndIf
	Assign("itxtLev" & $SelTroopSpell, $TempLev)
	If $TempLev = $MaxLev - 1 Then $LevColor = $COLOR_YELLOW
	GUICtrlSetData(Eval("txtLev" & $SelTroopSpell), $TempLev)
	If GUICtrlGetBkColor(Eval("txtLev" & $SelTroopSpell)) <> $LevColor Then GUICtrlSetBkColor(Eval("txtLev" & $SelTroopSpell), $LevColor)
EndFunc   ;==>LevUpDown

Func rightclick()
	If Not $iGUIEnabled Or $RunState = True Then Return
	$irghtclck = GUIGetCursorInfo($frmBot)
	Switch $irghtclck[4]
		;Troops
		Case $icnBarb
			LevUpDown("Barb")
			lblTotalCount2()
		Case $icnArch
			LevUpDown("Arch")
			lblTotalCount2()
		Case $icnGiant
			LevUpDown("Giant")
			lblTotalCount2()
		Case $icnGobl
			LevUpDown("Gobl")
			lblTotalCount2()
		Case $icnWall
			LevUpDown("Wall")
			lblTotalCount2()
		Case $icnWiza
			LevUpDown("Wiza")
			lblTotalCount2()
		Case $icnBall
			LevUpDown("Ball")
			lblTotalCount2()
		Case $icnHeal
			LevUpDown("Heal")
			lblTotalCount2()
		Case $icnDrag
			LevUpDown("Drag")
			lblTotalCount2()
		Case $icnPekk
			LevUpDown("Pekk")
			lblTotalCount2()
		Case $icnBabyD
			LevUpDown("BabyD")
			lblTotalCount2()
		Case $icnMine
			LevUpDown("Mine")
			lblTotalCount2()
		Case $icnMini
			LevUpDown("Mini")
			lblTotalCount2()
		Case $icnHogs
			LevUpDown("Hogs")
			lblTotalCount2()
		Case $icnValk
			LevUpDown("Valk")
			lblTotalCount2()
		Case $icnGole
			LevUpDown("Gole")
			lblTotalCount2()
		Case $icnWitc
			LevUpDown("Witc")
			lblTotalCount2()
		Case $icnLava
			LevUpDown("Lava")
			lblTotalCount2()
		Case $icnBowl
			LevUpDown("Bowl")
			lblTotalCount2()
			;Spell
		Case $lblLSpellIcon
			LevUpDown("LSpell")
			lblTotalCountSpell2()
		Case $lblHSpellIcon
			LevUpDown("HSpell")
			lblTotalCountSpell2()
		Case $lblRSpellIcon
			LevUpDown("RSpell")
			lblTotalCountSpell2()
		Case $lblJSpellIcon
			LevUpDown("JSpell")
			lblTotalCountSpell2()
		Case $lblFSpellIcon
			LevUpDown("FSpell")
			lblTotalCountSpell2()
		Case $lblCSpellIcon
			LevUpDown("CSpell")
			lblTotalCountSpell2()
		Case $lblPSpellIcon
			LevUpDown("PSpell")
			lblTotalCountSpell2()
		Case $lblESpellIcon
			LevUpDown("ESpell")
			lblTotalCountSpell2()
		Case $lblHaSpellIcon
			LevUpDown("HaSpell")
			lblTotalCountSpell2()
		Case $lblSeSpellIcon
			LevUpDown("SkSpell")
			lblTotalCountSpell2()
	EndSwitch
EndFunc   ;==>rightclick

Func LevBarb()
	While _IsPressed(01)
		LevUpDown("Barb")
		lblTotalCount2()
		Sleep($iDelayLvUP)
	WEnd
	If $iGUIEnabled = 0 Then
		LevUpDown("Barb")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevBarb

Func LevArch()
	While _IsPressed(01)
		LevUpDown("Arch")
		lblTotalCount2()
		Sleep($iDelayLvUP)
	WEnd
	If $iGUIEnabled = 0 Then
		LevUpDown("Arch")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevArch

Func LevGiant()
	While _IsPressed(01)
		LevUpDown("Giant")
		lblTotalCount2()
		Sleep($iDelayLvUP)
	WEnd
	If $iGUIEnabled = 0 Then
		LevUpDown("Giant")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevGiant

Func LevGobl()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Gobl")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Gobl")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevGobl

Func LevWall()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Wall")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Wall")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevWall

Func LevWiza()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Wiza")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Wiza")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevWiza

Func LevBall()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Ball")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Ball")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevBall

Func LevHeal()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Heal")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Heal")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevHeal

Func LevDrag()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Drag")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Drag")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevDrag

Func LevPekk()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Pekk")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Pekk")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevPekk

Func LevBabyD()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("BabyD")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("BabyD")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevBabyD

Func LevMine()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Mine")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Mine")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevMine

Func LevMini()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Mini")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Mini")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevMini

Func LevHogs()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Hogs")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Hogs")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevHogs

Func LevValk()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Valk")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Valk")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevValk

Func LevGole()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Gole")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Gole")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevGole

Func LevWitc()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Witc")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Witc")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevWitc

Func LevLava()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Lava")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Lava")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevLava

Func LevBowl()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("Bowl")
			lblTotalCount2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("Bowl")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevBowl

Func LevLSpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("LSpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("LSpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevLSpell

Func LevHSpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("HSpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("HSpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevHSpell

Func LevRSpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("RSpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("RSpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevRSpell

Func LevJSpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("JSpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("JSpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevJSpell

Func LevFSpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("FSpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("FSpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevFSpell

Func LevCSpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("CSpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("CSpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevCSpell

Func LevPSpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("PSpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("PSpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevPSpell

Func LevESpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("ESpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("ESpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevESpell

Func LevHaSpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("HaSpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("HaSpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevHaSpell

Func LevSkSpell()
	If $iGUIEnabled = 1 Then
		While _IsPressed(01)
			LevUpDown("SkSpell")
			lblTotalCountSpell2()
			Sleep($iDelayLvUP)
		WEnd
	Else
		LevUpDown("SkSpell")
		lblTotalCount2()
	EndIf
EndFunc   ;==>LevSkSpell

Func CalCostCamp()
	$ElixirCostCamp = 0
	$DarkCostCamp = 0
	For $i = 0 To (UBound($TroopName) - 1)
		If $TroopType[$i] = "e" Then
			$ElixirCostCamp += Eval($TroopName[$i] & "Comp") * Execute("$Lev" & $TroopName[$i] & "Cost[" & Eval("itxtLev" & $TroopName[$i]) & "]")
		ElseIf $TroopType[$i] = "d" Then
			$DarkCostCamp += Eval($TroopName[$i] & "Comp") * Execute("$Lev" & $TroopName[$i] & "Cost[" & Eval("itxtLev" & $TroopName[$i]) & "]")
		EndIF
	Next
	$rlblElixirCostCamp = _NumberFormat($ElixirCostCamp, True)
	$rlblDarkCostCamp = _NumberFormat($DarkCostCamp, True)
	If GUICtrlRead($lblElixirCostCamp) <> $rlblElixirCostCamp Then GUICtrlSetData($lblElixirCostCamp, $rlblElixirCostCamp)
	If GUICtrlRead($lblDarkCostCamp) <> $rlblDarkCostCamp Then GUICtrlSetData($lblDarkCostCamp, $rlblDarkCostCamp)
EndFunc   ;==>CalCostCamp

Func CalCostSpell()
	$ElixirCostSpell = 0
	$DarkCostSpell = 0
	For $i = 0 To (UBound($SpellName) - 1 - 4) ; - 4 is for Dark Spells Count, Will loop only for Elixir Spells
		$ElixirCostSpell += Eval($SpellName[$i] & "Comp") * Execute("$Lev" & $SpellName[$i] & "Cost[" & Eval("itxtLev" & $SpellName[$i]) & "]")
	Next
	For $i = (UBound($SpellName) - 4) To (UBound($SpellName) - 1) ; - 4 is for Dark Spells Count, Will loop only for Dark Spell
		$DarkCostSpell += Eval($SpellName[$i] & "Comp") * Execute("$Lev" & $SpellName[$i] & "Cost[" & Eval("itxtLev" & $SpellName[$i]) & "]")
	Next
	GUICtrlSetData($lblElixirCostSpell, _NumberFormat($ElixirCostSpell, True))
	GUICtrlSetData($lblDarkCostSpell, _NumberFormat($DarkCostSpell, True))
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
	For $T = 0 To UBound($TroopName) - 1
		Assign($TroopName[$T] & "Comp", 0)
		GUICtrlSetData(Eval("txtNum" & $TroopName[$T]), 0)
	Next
	For $S = 0 To (UBound($SpellName) - 1)
		Assign($SpellName[$S] & "Comp", 0)
		GUICtrlSetData(Eval("txtNum" & $SpellName[$S]), Eval($SpellName[$S] & "Comp"))
	Next
	GUICtrlSetData($lblTotalCountCamp, " 0s")
	GUICtrlSetData($lblTotalCountSpell, " 0s")
	GUICtrlSetData($lblElixirCostCamp, "0")
	GUICtrlSetData($lblDarkCostCamp, "0")
	GUICtrlSetData($lblElixirCostSpell, "0")
	GUICtrlSetData($lblDarkCostSpell, "0")
	GUICtrlSetData($lblCountTotal, 0)
EndFunc   ;==>Removecamp

Func AssignNumberTroopSpell($SelTroopSpell)
	Assign($SelTroopSpell & "Comp", GUICtrlRead(Eval("txtNum" & $SelTroopSpell)))
EndFunc   ;==>AssignNumberTroopSpell

Func lblTotalCountBarb()
	AssignNumberTroopSpell("Barb")
	lblTotalCount()
EndFunc   ;==>lblTotalCountBarb

Func lblTotalCountArch()
	AssignNumberTroopSpell("Arch")
	lblTotalCount()
EndFunc   ;==>lblTotalCountArch

Func lblTotalCountGiant()
	AssignNumberTroopSpell("Giant")
	lblTotalCount()
EndFunc   ;==>lblTotalCountGiant

Func lblTotalCountGobl()
	AssignNumberTroopSpell("Gobl")
	lblTotalCount()
EndFunc   ;==>lblTotalCountGobl

Func lblTotalCountWall()
	AssignNumberTroopSpell("Wall")
	lblTotalCount()
EndFunc   ;==>lblTotalCountWall

Func lblTotalCountWiza()
	AssignNumberTroopSpell("Wiza")
	lblTotalCount()
EndFunc   ;==>lblTotalCountWiza

Func lblTotalCountBall()
	AssignNumberTroopSpell("Ball")
	lblTotalCount()
EndFunc   ;==>lblTotalCountBall

Func lblTotalCountHeal()
	AssignNumberTroopSpell("Heal")
	lblTotalCount()
EndFunc   ;==>lblTotalCountHeal

Func lblTotalCountDrag()
	AssignNumberTroopSpell("Drag")
	lblTotalCount()
EndFunc   ;==>lblTotalCountDrag

Func lblTotalCountPekk()
	AssignNumberTroopSpell("Pekk")
	lblTotalCount()
EndFunc   ;==>lblTotalCountPekk

Func lblTotalCountBabyD()
	AssignNumberTroopSpell("BabyD")
	lblTotalCount()
EndFunc   ;==>lblTotalCountBabyD

Func lblTotalCountMine()
	AssignNumberTroopSpell("Mine")
	lblTotalCount()
EndFunc   ;==>lblTotalCountMine

Func lblTotalCountMini()
	AssignNumberTroopSpell("Mini")
	lblTotalCount()
EndFunc   ;==>lblTotalCountMini

Func lblTotalCountHogs()
	AssignNumberTroopSpell("Hogs")
	lblTotalCount()
EndFunc   ;==>lblTotalCountHogs

Func lblTotalCountValk()
	AssignNumberTroopSpell("Valk")
	lblTotalCount()
EndFunc   ;==>lblTotalCountValk

Func lblTotalCountGole()
	AssignNumberTroopSpell("Gole")
	lblTotalCount()
EndFunc   ;==>lblTotalCountGole

Func lblTotalCountWitc()
	AssignNumberTroopSpell("Witc")
	lblTotalCount()
EndFunc   ;==>lblTotalCountWitc

Func lblTotalCountLava()
	AssignNumberTroopSpell("Lava")
	lblTotalCount()
EndFunc   ;==>lblTotalCountLava

Func lblTotalCountBowl()
	AssignNumberTroopSpell("Bowl")
	lblTotalCount()
EndFunc   ;==>lblTotalCountBowl

Func lblTotalCountLSpell()
	AssignNumberTroopSpell("LSpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountLSpell

Func lblTotalCountHSpell()
	AssignNumberTroopSpell("HSpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountHSpell

Func lblTotalCountRSpell()
	AssignNumberTroopSpell("RSpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountRSpell

Func lblTotalCountJSpell()
	AssignNumberTroopSpell("JSpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountJSpell

Func lblTotalCountFSpell()
	AssignNumberTroopSpell("FSpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountFSpell

Func lblTotalCountCSpell()
	AssignNumberTroopSpell("CSpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountCSpell

Func lblTotalCountPSpell()
	AssignNumberTroopSpell("PSpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountPSpell

Func lblTotalCountESpell()
	AssignNumberTroopSpell("ESpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountESpell

Func lblTotalCountHaSpell()
	AssignNumberTroopSpell("HaSpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountHaSpell

Func lblTotalCountSkSpell()
	AssignNumberTroopSpell("SkSpell")
	lblTotalCountSpell2()
EndFunc   ;==>lblTotalCountSkSpell

Func chkAddDelayIdlePhaseEnable()
    If GUICtrlRead($chkAddDelayIdlePhaseEnable) = $GUI_CHECKED Then
        $iAddIdleTimeEnable = 1
        For $i = $lbltxtAddDelayIdlePhaseBetween to $lbltxtAddDelayIdlePhaseSec
            GUICtrlSetState($i, $GUI_ENABLE)
        Next
    Else
        $iAddIdleTimeEnable = 0
        For $i = $lbltxtAddDelayIdlePhaseBetween to $lbltxtAddDelayIdlePhaseSec
            GUICtrlSetState($i, $GUI_DISABLE)
        Next
    EndIf
EndFunc   ;==>chkAddDelayIdlePhaseEnable
