
; #FUNCTION# ====================================================================================================================
; Name ..........: BoostBarracks
; Description ...:
; Syntax ........: BoostBarracks()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #11
; Modified ......: ProMac ( 2015 ), Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BoostBarracks()
	Local $icmbQuantBoostBarracks = GUICtrlRead($cmbQuantBoostBarracks)
	Local $icmbBoostBarracks = GUICtrlRead($cmbBoostBarracks)
	If $bTrainEnabled = False Then Return
	If $icmbQuantBoostBarracks = 0 Or $icmbBoostBarracks = 0 Then Return

	If $iPlannedBoostBarracksEnable = 1 Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $iPlannedBoostBarracksHours[$hour[0]] = 0 Then
			SetLog("Boost Barracks are not Planned, Skipped..", $COLOR_GREEN)
			Return ; exit func if no planned Boost Barracks checkmarks
		EndIf
	EndIf

	SetLog("Boost Barracks started, checking available Barracks.", $COLOR_BLUE)
	If _Sleep($iDelaycheckArmyCamp1) Then Return

	If $icmbQuantBoostBarracks > $numBarracksAvaiables Then
		SetLog(" Hey Chief! I can not Boost more than: " & $numBarracksAvaiables & " Barracks .... ")
		Return
	EndIf


	If $icmbQuantBoostBarracks = $numBarracksAvaiables Then ;  Boost All barracks with "button Boost All" 40 gems"
		If $barrackPos[0][0] = "" Then
			LocateBarrack()
			SaveConfig()
			If _Sleep($iDelayBoostBarracks2) Then Return
		EndIf
		While 1
			SetLog("Boosting All Barracks", $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0157")
			If _Sleep($iDelayBoostBarracks1) Then ExitLoop
			Click($barrackPos[0][0], $barrackPos[0][1], 1, 0, "#0158")
			If _Sleep($iDelayBoostBarracks1) Then ExitLoop
			_CaptureRegion()
			Local $Boost = _PixelSearch(410, 603 + $bottomOffsetY, 493, 621 + $bottomOffsetY, Hex(0xfffd70, 6), 10)
			If IsArray($Boost) Then
				If $DebugSetlog = 1 Then Setlog("Boost Button X|Y = " & $Boost[0] & "|" & $Boost[1] & ", color = " & _GetPixelColor($Boost[0], $Boost[1]), $COLOR_PURPLE)
				Click($Boost[0], $Boost[1], 1, 0, "#0159")
				If _Sleep($iDelayBoostBarracks1) Then Return
				If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
					Click(420, 375 + $midOffsetY, 1, 0, "#0160")
					If _Sleep($iDelayBoostBarracks2) Then Return
					If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
						_GUICtrlComboBox_SetCurSel($cmbBoostBarracks, 0)
						SetLog("Not enough gems", $COLOR_RED)
					Else
						_GUICtrlComboBox_SetCurSel($cmbBoostBarracks, ($icmbBoostBarracks - 1))
						SetLog('Boost completed. Remaining :' & $icmbBoostBarracks, $COLOR_GREEN)
					EndIf
				Else
					SetLog("Barracks are already Boosted", $COLOR_RED)
				EndIf
				If _Sleep($iDelayBoostBarracks3) Then ExitLoop
				ClickP($aAway, 1, 0, "#0161")
			Else
				SetLog("Barracks Boost Button not found", $COLOR_RED)
				If _Sleep($iDelayBoostBarracks1) Then Return
			EndIf

			ExitLoop
		WEnd

	Else
		If $barrackPos[$icmbQuantBoostBarracks - 1][0] = "" Then ;  Boost individual barracks with "button Boost 10 gems"
			LocateBarrack2()
			SaveConfig()
			If _Sleep($iDelayBoostBarracks2) Then Return
		EndIf
		For $i = 0 To ($icmbQuantBoostBarracks - 1)
			SetLog("Boosting Barracks nº: " & $i + 1, $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0157")
			If _Sleep($iDelayBoostBarracks1) Then ExitLoop
			Click($barrackPos[$i][0], $barrackPos[$i][1], 1, 0, "#0158")
			If _Sleep($iDelayBoostBarracks1) Then ExitLoop
			_CaptureRegion()
			Local $Boost = _PixelSearch(355, 608 + $bottomOffsetY, 362, 610 + $bottomOffsetY, Hex(0xA0A386, 6), 10) ;Check Boost
			If IsArray($Boost) Then
				If $DebugSetlog = 1 Then Setlog("Boost Button X|Y = " & $Boost[0] & "|" & $Boost[1] & ", color = " & _GetPixelColor($Boost[0], $Boost[1]), $COLOR_PURPLE)
				Click($Boost[0], $Boost[1], 1, 0, "#0159")
				If _Sleep($iDelayBoostBarracks1) Then Return
				If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then ;Confirm Message
					Click(420, 375 + $midOffsetY, 1, 0, "#0160")
					If _Sleep($iDelayBoostBarracks2) Then Return
					If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then ;Not enough Gem
						_GUICtrlComboBox_SetCurSel($cmbBoostBarracks, 0)
						SetLog("Not enough gems", $COLOR_RED)
					EndIf
					If Not $i = ($icmbQuantBoostBarracks - 1) Then
						SetLog("Boost " & $i + 1 & " Barrack(s) completed. Remaining :" & ($icmbQuantBoostBarracks - 1) - $i & " Barracks to Boost.", $COLOR_GREEN)
					Else
						_GUICtrlComboBox_SetCurSel($cmbBoostBarracks, ($icmbBoostBarracks - 1))
						SetLog("Boost " & $i + 1 & " Barrack(s) completed. Remaining :" & ($icmbQuantBoostBarracks - 1) - $i & " Barracks to Boost.", $COLOR_GREEN)
						SetLog("Remaining :" & $icmbBoostBarracks - 1 & " times ", $COLOR_GREEN)
					EndIf
				Else
					SetLog("Barrack nº: " & $i + 1 & " is already Boosted.", $COLOR_RED)
				EndIf
				If _Sleep($iDelayBoostBarracks3) Then ExitLoop
				ClickP($aAway, 1, 0, "#0161")
			Else
				SetLog("Barrack nº: " & $i & " Boost Button not found.", $COLOR_RED)
				If _Sleep($iDelayBoostBarracks1) Then Return
			EndIf
		Next
	EndIf

	If _Sleep($iDelayBoostBarracks3) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>BoostBarracks


Func BoostSpellFactory()
	If $bTrainEnabled = False Then Return

	If (GUICtrlRead($cmbBoostSpellFactory) > 0) And ($boostsEnabled = 1) Then
		SetLog("Boost Spell Factory...", $COLOR_BLUE)
		If $SFPos[0] = -1 Then
			LocateSpellFactory()
			SaveConfig()
			If _Sleep($iDelayBoostSpellFactory2) Then Return
		Else
			Click($SFPos[0], $SFPos[1], 1, 0, "#0162")
			If _Sleep($iDelayBoostSpellFactory4) Then Return
			_CaptureRegion()
			$Boost = _PixelSearch(382, 603 + $bottomOffsetY, 440, 621 + $bottomOffsetY, Hex(0xfffd70, 6), 10)
			If IsArray($Boost) Then
				If $DebugSetlog = 1 Then Setlog("Boost Button X|Y = " & $Boost[0] & "|" & $Boost[1] & ", color = " & _GetPixelColor($Boost[0], $Boost[1]), $COLOR_PURPLE)
				Click($Boost[0], $Boost[1], 1, 0, "#0163")
				If _Sleep($iDelayBoostSpellFactory1) Then Return
				If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
					Click(420, 375 + $midOffsetY, 1, 0, "#0164")
					If _Sleep($iDelayBoostSpellFactory2) Then Return
					If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
						_GUICtrlComboBox_SetCurSel($cmbBoostSpellFactory, 0)
						SetLog("Not enough gems", $COLOR_RED)
					Else
						_GUICtrlComboBox_SetCurSel($cmbBoostSpellFactory, (GUICtrlRead($cmbBoostSpellFactory) - 1))
						SetLog('Boost completed. Remaining :' & (GUICtrlRead($cmbBoostSpellFactory)), $COLOR_GREEN)
					EndIf
				Else
					SetLog("Spell Factory is already Boosted", $COLOR_RED)
				EndIf
				If _Sleep($iDelayBoostSpellFactory3) Then Return
				ClickP($aAway, 1, 0, "#0165")
			Else
				SetLog("Spell Factory Boost Button not found", $COLOR_RED)
				If _Sleep($iDelayBoostSpellFactory1) Then Return
			EndIf
		EndIf
	EndIf
	If _Sleep($iDelayBoostSpellFactory3) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>BoostSpellFactory

Func BoostDarkSpellFactory()
	If $bTrainEnabled = False Then Return

	If (GUICtrlRead($cmbBoostDarkSpellFactory) > 0) And ($boostsEnabled = 1) Then
		SetLog("Boost Dark Spell Factory...", $COLOR_BLUE)
		If $DSFPos[0] = -1 Then
			LocateDarkSpellFactory()
			SaveConfig()
			If _Sleep($iDelayBoostSpellFactory2) Then Return
		Else
			Click($DSFPos[0], $DSFPos[1], 1, 0, "#0162")
			If _Sleep($iDelayBoostSpellFactory4) Then Return
			_CaptureRegion()
			$Boost = _PixelSearch(382, 603 + $bottomOffsetY, 440, 621 + $bottomOffsetY, Hex(0xfffd70, 6), 10)
			If IsArray($Boost) Then
				If $DebugSetlog = 1 Then Setlog("Boost Button X|Y = " & $Boost[0] & "|" & $Boost[1] & ", color = " & _GetPixelColor($Boost[0], $Boost[1]), $COLOR_PURPLE)
				Click($Boost[0], $Boost[1], 1, 0, "#0163")
				If _Sleep($iDelayBoostSpellFactory1) Then Return
				If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
					Click(420, 375 + $midOffsetY, 1, 0, "#0164")
					If _Sleep($iDelayBoostSpellFactory2) Then Return
					If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
						_GUICtrlComboBox_SetCurSel($cmbBoostDarkSpellFactory, 0)
						SetLog("Not enough gems", $COLOR_RED)
					Else
						_GUICtrlComboBox_SetCurSel($cmbBoostDarkSpellFactory, (GUICtrlRead($cmbBoostDarkSpellFactory) - 1))
						SetLog('Boost completed. Remaining :' & (GUICtrlRead($cmbBoostDarkSpellFactory)), $COLOR_GREEN)
					EndIf
				Else
					SetLog("Dark Spell Factory is already Boosted", $COLOR_RED)
				EndIf
				If _Sleep($iDelayBoostSpellFactory3) Then Return
				ClickP($aAway, 1, 0, "#0165")
			Else
				SetLog("Dark Spell Factory Boost Button not found", $COLOR_RED)
				If _Sleep($iDelayBoostSpellFactory1) Then Return
			EndIf
		EndIf
	EndIf
	If _Sleep($iDelayBoostSpellFactory3) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>BoostDarkSpellFactory

