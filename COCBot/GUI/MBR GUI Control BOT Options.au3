; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Bot Options
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run Team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func LoadLanguagesComboBox()

	Local $hFileSearch = FileFindFirstFile($dirLanguages & "*.ini")
	Local $sFilename, $sOutput = "", $sLangDisplayName = "", $iFileIndex = 0

	While 1
		$sFilename = FileFindNextFile($hFileSearch)
		If @error Then ExitLoop ; exit when no more files are found

		ReDim $aLanguageFile[$iFileIndex + 1][2]
		$aLanguageFile[$iFileIndex][0] = StringLeft($sFilename, StringLen($sFilename) - 4)
		$sLangDisplayName = IniRead($dirLanguages & $sFilename, "Language", "DisplayName", "Unknown")
		$aLanguageFile[$iFileIndex][1] = $sLangDisplayName
		If $sLangDisplayName = "Unknown" Then
			; create a new language section and write the filename as default displayname (also for new empty language files)
			IniWrite($dirLanguages & $sFilename, "Language", "DisplayName", StringLeft($sFilename, StringLen($sFilename) - 4)) ; removing ".ini" from filename
			$sLangDisplayName = IniRead($dirLanguages & $sFilename, "Language", "DisplayName", "Unknown")
			$aLanguageFile[$iFileIndex][1] = $sLangDisplayName
		EndIf

		$sOutput = $sOutput & $sLangDisplayName & "|"
		$iFileIndex += 1
	WEnd
	FileClose($hFileSearch)

	;remove last |
	$sOutput = StringLeft($sOutput, StringLen($sOutput) - 1)

	;reset combo box
	_GUICtrlComboBox_ResetContent($cmbLanguage)

	;set combo box
	GUICtrlSetData($cmbLanguage, $sOutput)

EndFunc   ;==>LoadLanguagesComboBox

Func cmbLanguage()
	Local $aLanguage = _GUICtrlComboBox_GetListArray($cmbLanguage)
	Local $sLanguageIndex = _ArraySearch($aLanguageFile, $aLanguage[_GUICtrlComboBox_GetCurSel($cmbLanguage) + 1])

	$sLanguage = $aLanguageFile[$sLanguageIndex][0] ; the filename = 0, the display name = 1
	MsgBox("", "", GetTranslated(636, 71, "Restart Bot to load program with new language:") & " " & $aLanguageFile[$sLanguageIndex][1] & " (" & $sLanguage & ")")
EndFunc   ;==>cmbLanguage

Func chkScreenshotType()
	If GUICtrlRead($chkScreenshotType) = $GUI_CHECKED Then
		$iScreenshotType = 1
	Else
		$iScreenshotType = 0
	EndIf
EndFunc   ;==>chkScreenshotType

Func chkScreenshotHideName()
	If GUICtrlRead($chkScreenshotHideName) = $GUI_CHECKED Then
		$ichkScreenshotHideName = 1
	Else
		$ichkScreenshotHideName = 0
	EndIf
EndFunc   ;==>chkScreenshotHideName

Func chkDeleteLogs()
	If GUICtrlRead($chkDeleteLogs) = $GUI_CHECKED Then
		GUICtrlSetState($txtDeleteLogsDays, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtDeleteLogsDays, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDeleteLogs

Func chkDeleteTemp()
	If GUICtrlRead($chkDeleteTemp) = $GUI_CHECKED Then
		GUICtrlSetState($txtDeleteTempDays, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtDeleteTempDays, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDeleteTemp

Func chkDeleteLoots()
	If GUICtrlRead($chkDeleteLoots) = $GUI_CHECKED Then
		GUICtrlSetState($txtDeleteLootsDays, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtDeleteLootsDays, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDeleteLoots

Func chkAutoStart()
	If GUICtrlRead($chkAutoStart) = $GUI_CHECKED Then
		GUICtrlSetState($txtAutostartDelay, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtAutostartDelay, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAutoStart

Func chkDisposeWindows()
	If GUICtrlRead($chkDisposeWindows) = $GUI_CHECKED Then
		GUICtrlSetState($cmbDisposeWindowsCond, $GUI_ENABLE)
		GUICtrlSetState($txtWAOffsetx, $GUI_ENABLE)
		GUICtrlSetState($txtWAOffsety, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbDisposeWindowsCond, $GUI_DISABLE)
		GUICtrlSetState($txtWAOffsetx, $GUI_DISABLE)
		GUICtrlSetState($txtWAOffsety, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDisposeWindows


Func chkTotalCampForced()
	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED Then
		GUICtrlSetState($txtTotalCampForced, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtTotalCampForced, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTotalCampForced

Func chkSinglePBTForced()
	If GUICtrlRead($chkSinglePBTForced) = $GUI_CHECKED Then
		GUICtrlSetState($txtSinglePBTimeForced, $GUI_ENABLE)
		GUICtrlSetState($txtPBTimeForcedExit, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtSinglePBTimeForced, $GUI_DISABLE)
		GUICtrlSetState($txtPBTimeForcedExit, $GUI_DISABLE)
	EndIf
	txtSinglePBTimeForced()
EndFunc   ;==>chkSinglePBTForced

Func txtSinglePBTimeForced()
	Switch Int(GUICtrlRead($txtSinglePBTimeForced))
		Case 0 To 15
			GUICtrlSetBkColor($txtSinglePBTimeForced, $COLOR_RED)
		Case 16
			GUICtrlSetBkColor($txtSinglePBTimeForced, $COLOR_YELLOW)
		Case 17 To 999
			GUICtrlSetBkColor($txtSinglePBTimeForced, $COLOR_MONEYGREEN)
	EndSwitch
	Switch Int(GUICtrlRead($txtPBTimeForcedExit))
		Case 0 To 11
			GUICtrlSetBkColor($txtPBTimeForcedExit, $COLOR_RED)
		Case 12 To 14
			GUICtrlSetBkColor($txtPBTimeForcedExit, $COLOR_YELLOW)
		Case 15 To 999
			GUICtrlSetBkColor($txtPBTimeForcedExit, $COLOR_MONEYGREEN)
	EndSwitch
EndFunc   ;==>txtSinglePBTimeForced

Func chkDebugSetlog()
	If GUICtrlRead($chkDebugSetlog) = $GUI_CHECKED Then
		$DebugSetlog = 1
	Else
		$DebugSetlog = 0
	EndIf
EndFunc   ;==>chkDebugSetlog

Func chkDebugOcr()
	If GUICtrlRead($chkDebugOcr) = $GUI_CHECKED Then
		$debugOcr = 1
	Else
		$debugOcr = 0
	EndIf
EndFunc   ;==>chkDebugOcr

Func chkDebugImageSave()
	If GUICtrlRead($chkDebugImageSave) = $GUI_CHECKED Then
		$DebugImageSave = 1
	Else
		$DebugImageSave = 0
	EndIf
EndFunc   ;==>chkDebugImageSave

Func chkdebugBuildingPos()
	If GUICtrlRead($chkdebugBuildingPos) = $GUI_CHECKED Then
		$debugBuildingPos = 1
	Else
		$debugBuildingPos = 0
	EndIf
EndFunc   ;==>chkdebugBuildingPos

Func chkdebugTrain()
	If GUICtrlRead($chkdebugTrain) = $GUI_CHECKED Then
		$debugsetlogTrain = 1
	Else
		$debugsetlogTrain = 0
	EndIf
EndFunc   ;==>chkdebugTrain

Func sldMaxVSDelay()
	$iMaxVSDelay = GUICtrlRead($sldMaxVSDelay)
	GUICtrlSetData($lblMaxVSDelay, $iMaxVSDelay)
	If $iMaxVSDelay < $iVSDelay Then
		GUICtrlSetData($lblVSDelay, $iMaxVSDelay)
		GUICtrlSetData($sldVSDelay, $iMaxVSDelay)
		$iVSDelay = $iMaxVSDelay
	EndIf
	If $iVSDelay = 1 Then
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(603,7, "second"))
	Else
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(603,8, "seconds"))
	EndIf
	If $iMaxVSDelay = 1 Then
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(603,7, "second"))
	Else
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(603,8, "seconds"))
	EndIf
EndFunc   ;==>sldMaxVSDelay

Func sldVSDelay()
	$iVSDelay = GUICtrlRead($sldVSDelay)
	GUICtrlSetData($lblVSDelay, $iVSDelay)
	If $iVSDelay > $iMaxVSDelay Then
		GUICtrlSetData($lblMaxVSDelay, $iVSDelay)
		GUICtrlSetData($sldMaxVSDelay, $iVSDelay)
		$iMaxVSDelay = $iVSDelay
	EndIf
	If $iVSDelay = 1 Then
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(603,7, "second"))
	Else
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(603,8, "seconds"))
	EndIf
	If $iMaxVSDelay = 1 Then
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(603,7, "second"))
	Else
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(603,8, "seconds"))
	EndIf
EndFunc   ;==>sldVSDelay


Func sldTrainITDelay()
	$isldTrainITDelay = GUICtrlRead($sldTrainITDelay)
	GUICtrlSetData($lbltxtTrainITDelay, GetTranslated(636, 32, "delay") & " " & $isldTrainITDelay & " ms.")
EndFunc   ;==>sldTrainITDelay

#cs
	Func cmbGUIstyle()
	MsgBox("", "", GetTranslated(636, 71, "Restart Bot to load new GUI style"))
	EndFunc   ;==>cmbGUIstyle
#ce


Func btnTestTrain()
		Local $currentOCR = $debugOcr
		Local $currentRunState = $RunState
		$debugOcr = 1
		$RunState = 1
 		ForceCaptureRegion()
		DebugImageSave("train_")
		getArmyTroopCount(false,false,true)
		getArmySpellCount(false,false,true)
		getArmyHeroCount(false,false)
		$debugOcr = $currentOCR
		$RunState = $currentRunState
EndFunc



Func btnTestDonateCC()
		Local $currentOCR = $debugOcr
		Local $currentRunState = $RunState
		$debugOcr = 1
		$RunState = 1
 		ForceCaptureRegion()
		DebugImageSave("donateCC_")
		$DonationWindowY = 0

		Local $aDonWinOffColors[2][3] = [[0xFFFFFF, 0, 2], [0xc7c5bc, 0, 209]]
		Local $aDonationWindow = _MultiPixelSearch(409, 0, 410, $DEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10)

		If IsArray($aDonationWindow) Then
			$DonationWindowY = $aDonationWindow[1]
			If _Sleep(250) Then Return
			If $debugSetlog = 1 Then Setlog("$DonationWindowY: " & $DonationWindowY, $COLOR_PURPLE)
		Else
			SetLog("Could not find the Donate Window :(", $COLOR_RED)
			Return False
		EndIf
		DetectSlotTroop($eLava)
		DetectSlotTroop($eHaSpell)
		getArmyTroopCount(false,false,true)
		getArmySpellCount(false,false,true)
		getArmyHeroCount(false,false)
		$debugOcr = $currentOCR
		$RunState = $currentRunState

EndFunc

