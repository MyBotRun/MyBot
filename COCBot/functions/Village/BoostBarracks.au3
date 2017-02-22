; #FUNCTION# ====================================================================================================================
; Name ..........: BoostBarracks.au3
; Description ...:
; Syntax ........: BoostBarracks(), BoostSpellFactory()
; Parameters ....:
; Return values .: None
; Author ........: MR.ViPER
; Modified ......: MR.ViPER (9-9-2016), MR.ViPER (17-10-2016) Oct Update
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $DebugBarrackBoost = 0

Func BoostBarracks()
	If $bTrainEnabled = False Then Return
	If $g_iCmbBoostBarracks = 0 Then Return
	If $g_iCmbBoostBarracks >= 1 Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $g_abBoostBarracksHours[$hour[0]] = False Then
			SetLog("Boost Barracks are not Planned, Skipped..", $COLOR_BLUE)
			Return ; exit func if no planned Boost Barracks checkmarks
		EndIf
	EndIf

	If OpenArmyWindow() = True Then
		Local $CheckArmyWindow = ISArmyWindow()
		OpenTrainTabNumber(1, "BoostBarracks")
		If _Sleep(400) Then Return

		Local $ClickResult = ClickOnBoostArmyWindow()
		If $ClickResult = True Then
			Local $GemResult = IsGemWindowOpen(True)
			If $GemResult = True Then
				If $g_iCmbBoostBarracks >= 1 Then $g_iCmbBoostBarracks -= 1
				Setlog(" Total remain cycles to boost Barracks:" & $g_iCmbBoostBarracks, $COLOR_GREEN)
				GUICtrlSetData($g_hCmbBoostBarracks, $g_iCmbBoostBarracks)
			EndIf
		EndIf

		ClickP($aAway, 1, 0, "#0161")
		PureClickP($aAway, 1, 0, "#0140")
	EndIf
	_Sleep($iDelayBoostBarracks5 + 1000)
	checkMainScreen(False) ; Check for errors during function
	Return True
EndFunc   ;==>BoostBarracks

Func BoostSpellFactory()
	If $bTrainEnabled = False Then Return
	If $g_iCmbBoostSpellFactory >= 1 Then
		SetLog("Boosting Spell Factory...", $COLOR_BLUE)

		If OpenArmyWindow() = True Then
			Local $CheckArmyWindow = ISArmyWindow()
			OpenTrainTabNumber(2, "BoostSpellFactory")
			If _Sleep(400) Then Return

			Local $ClickResult = ClickOnBoostArmyWindow()
			If $ClickResult = True Then
				Local $GemResult = IsGemWindowOpen(True)
				If $GemResult = True Then
					If $g_iCmbBoostSpellFactory >= 1 Then $g_iCmbBoostSpellFactory -= 1
					Setlog(" Total remain cycles to boost Spells:" & $g_iCmbBoostSpellFactory, $COLOR_GREEN)
					GUICtrlSetData($g_hCmbBoostSpellFactory, $g_iCmbBoostSpellFactory)
				EndIf
			EndIf

			ClickP($aAway, 1, 0, "#0161")
			PureClickP($aAway, 1, 0, "#0140")
		EndIf
		_Sleep($iDelayBoostBarracks5 + 1000)
		checkMainScreen(False) ; Check for errors during function
		Return True
	EndIf
EndFunc   ;==>BoostSpellFactory

Func ClickOnBoostArmyWindow()
	If $DebugBarrackBoost = 1 Then SetLog("Func ClickOnBoostArmyWindow()", $COLOR_DEBUG) ;Debug
	_Sleep($iDelayBoostBarracks2)
	Local $ClockColor = _GetPixelColor(780, 312 + $g_iMidOffsetY, True)
	Local $ResColCheck = _ColorCheck($ClockColor, Hex(0x65AF20, 6), 40)
	If $ResColCheck = True Then
		SetLog("Boost Button is Available, Clicking On...", $COLOR_BLUE)
		Click(770, 325)
		_Sleep($iDelayBoostBarracks2)
		Return True
	Else
		If _ColorCheck(_GetPixelColor(718, 285 + $g_iMidOffsetY, True), Hex(0xEEF470, 6), 40) Then
			SetLog("Already Boosted! Skipping...", $COLOR_GREEN)
		Else
			SetLog("Cannot Verify Boost Button! Skipping...", $COLOR_ORANGE)
		EndIf
		Return False
	EndIf
EndFunc   ;==>ClickOnBoostArmyWindow

Func IsGemWindowOpen($AcceptGem = False)
	If $DebugBarrackBoost = 1 Then SetLog("Func IsGemWindowOpen(" & $AcceptGem & ")", $COLOR_DEBUG) ;Debug
	_Sleep($iDelayisGemOpen1)
	If _ColorCheck(_GetPixelColor(590, 235 + $g_iMidOffsetY, True), Hex(0xD80408, 6), 20) Then
		If _ColorCheck(_GetPixelColor(375, 383 + $g_iMidOffsetY, True), Hex(0x222322, 6), 20) Then
			If $g_iDebugSetlog = 1 Or $DebugBarrackBoost = 1 Then Setlog("DETECTED, GEM Window Is OPEN", $COLOR_DEBUG) ;Debug
			If $AcceptGem = True Then
				Click(435, 445)
				_Sleep($iDelayBoostBarracks2)
				SetLog('Boost was Successful.', $COLOR_GREEN)
			Else
				PureClickP($aAway, 1, 0, "#0140") ; click away to close gem window
			EndIf
			_Sleep($iDelayBoostSpellFactory3)
			ClickP($aAway, 1, 0, "#0161")
			If $DebugBarrackBoost = 1 Then SetLog("Func IsGemWindowOpen(" & $AcceptGem & ") = TRUE", $COLOR_GREEN)
			Return True
		EndIf
	EndIf
	If $DebugBarrackBoost = 1 Then SetLog("Func IsGemWindowOpen(" & $AcceptGem & ") = FALSE", $COLOR_GREEN)
	Return False
EndFunc   ;==>IsGemWindowOpen
