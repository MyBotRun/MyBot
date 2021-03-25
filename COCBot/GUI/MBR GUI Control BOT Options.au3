; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Bot Options
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run Team
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $aLanguageFile[1][2] ; undimmed language file array [FileName][DisplayName]
Global $hLangIcons = 0

Func LoadLanguagesComboBox()

	Local $hFileSearch = FileFindFirstFile($g_sDirLanguages & "*.ini")
	Local $sFilename, $sLangDisplayName = "", $iFileIndex = 0

	If $hLangIcons Then _GUIImageList_Destroy($hLangIcons)
	$hLangIcons = _GUIImageList_Create(16, 16, 5)

	While 1
		$sFilename = FileFindNextFile($hFileSearch)
		If @error Then ExitLoop ; exit when no more files are found
		ReDim $aLanguageFile[$iFileIndex + 1][3]
		$aLanguageFile[$iFileIndex][0] = StringLeft($sFilename, StringLen($sFilename) - 4)
		; All Language Icons are made by YummyGum and can be found here: https://www.iconfinder.com/iconsets/142-mini-country-flags-16x16px
		$aLanguageFile[$iFileIndex][2] = _GUIImageList_AddIcon($hLangIcons, @ScriptDir & "\lib\MBRBot.dll", Eval("e" & $aLanguageFile[$iFileIndex][0]) - 1)
		$sLangDisplayName = IniRead($g_sDirLanguages & $sFilename, "Language", "DisplayName", "Unknown")
		$aLanguageFile[$iFileIndex][1] = $sLangDisplayName
		If $sLangDisplayName = "Unknown" Then
			; create a new language section and write the filename as default displayname (also for new empty language files)
			IniWrite($g_sDirLanguages & $sFilename, "Language", "DisplayName", StringLeft($sFilename, StringLen($sFilename) - 4)) ; removing ".ini" from filename
			$sLangDisplayName = IniRead($g_sDirLanguages & $sFilename, "Language", "DisplayName", "Unknown")
			$aLanguageFile[$iFileIndex][1] = $sLangDisplayName
		EndIf

		$iFileIndex += 1
	WEnd
	FileClose($hFileSearch)

	;reset combo box
	_GUICtrlComboBox_ResetContent($g_hCmbGUILanguage)

	;set combo box
	_GUICtrlComboBoxEx_SetImageList($g_hCmbGUILanguage, $hLangIcons)
	For $i = 0 To UBound($aLanguageFile) - 1
		If $aLanguageFile[$i][2] <> -1 Then
			_GUICtrlComboBoxEx_AddString($g_hCmbGUILanguage, $aLanguageFile[$i][1], $aLanguageFile[$i][2], $aLanguageFile[$i][2])
		Else
			_GUICtrlComboBoxEx_AddString($g_hCmbGUILanguage, $aLanguageFile[$i][1], $eMissingLangIcon, $eMissingLangIcon)
		EndIf
	Next
	_GUICtrlComboBoxEx_SetCurSel($g_hCmbGUILanguage, _GUICtrlComboBoxEx_FindStringExact($g_hCmbGUILanguage, $aLanguageFile[_ArraySearch($aLanguageFile, $g_sLanguage)][1]))

EndFunc   ;==>LoadLanguagesComboBox

Func cmbLanguage()
	Local $aLanguage = _GUICtrlComboBox_GetListArray($g_hCmbGUILanguage)
	Local $g_sLanguageIndex = _ArraySearch($aLanguageFile, $aLanguage[_GUICtrlComboBox_GetCurSel($g_hCmbGUILanguage) + 1])

	$g_sLanguage = $aLanguageFile[$g_sLanguageIndex][0] ; the filename = 0, the display name = 1
	MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_cmbLanguage", "Restart Bot to load program with new language:") & " " & $aLanguageFile[$g_sLanguageIndex][1] & " (" & $g_sLanguage & ")")
	IniWriteS($g_sProfileConfigPath, "other", "language", $g_sLanguage) ; save language before restarting
	RestartBot(False, False)
EndFunc   ;==>cmbLanguage

Func chkBotCustomTitleBarClick()
	Local $bChecked = GUICtrlRead($g_hChkBotCustomTitleBarClick) = $GUI_CHECKED
	$g_iBotDesignFlags = BitOR(BitAND($g_iBotDesignFlags, BitNOT(1)), (($bChecked) ? 1 : 0))
	GUICtrlSetState($g_hChkBotAutoSlideClick, ($bChecked ? $GUI_ENABLE : $GUI_DISABLE))
EndFunc   ;==>chkBotCustomTitleBarClick

Func chkBotAutoSlideClick()
	Local $bChecked = GUICtrlRead($g_hChkBotAutoSlideClick) = $GUI_CHECKED
	$g_iBotDesignFlags = BitOR(BitAND($g_iBotDesignFlags, BitNOT(2)), (($bChecked) ? 2 : 0))
EndFunc   ;==>chkBotAutoSlideClick

Func chkDisableNotifications()
	$g_bDisableNotifications = (GUICtrlRead($g_hChkDisableNotifications) = $GUI_CHECKED)
EndFunc   ;==>chkDisableNotifications

Func chkUseRandomClick()
	$g_bUseRandomClick = (GUICtrlRead($g_hChkUseRandomClick) = $GUI_CHECKED)
EndFunc   ;==>chkUseRandomClick
#cs
	Func chkUpdatingWhenMinimized()
	$g_bUpdatingWhenMinimized = (GUICtrlRead($g_hChkUpdatingWhenMinimized) = $GUI_CHECKED)
	EndFunc   ;==>chkUpdatingWhenMinimized
#ce
Func chkHideWhenMinimized()
	$g_bHideWhenMinimized = (GUICtrlRead($g_hChkHideWhenMinimized) = $GUI_CHECKED)
	TrayItemSetState($g_hTiHide, ($g_bHideWhenMinimized = 1 ? $TRAY_CHECKED : $TRAY_UNCHECKED))
EndFunc   ;==>chkHideWhenMinimized

Func chkScreenshotType()
	$g_bScreenshotPNGFormat = (GUICtrlRead($g_hChkScreenshotType) = $GUI_CHECKED)
EndFunc   ;==>chkScreenshotType

Func chkScreenshotHideName()
	$g_bScreenshotHideName = (GUICtrlRead($g_hChkScreenshotHideName) = $GUI_CHECKED)
EndFunc   ;==>chkScreenshotHideName

Func chkDeleteLogs()
	GUICtrlSetState($g_hTxtDeleteLogsDays, GUICtrlRead($g_hChkDeleteLogs) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkDeleteLogs

Func chkDeleteTemp()
	GUICtrlSetState($g_hTxtDeleteTempDays, GUICtrlRead($g_hChkDeleteTemp) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkDeleteTemp

Func chkDeleteLoots()
	GUICtrlSetState($g_hTxtDeleteLootsDays, GUICtrlRead($g_hChkDeleteLoots) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkDeleteLoots

Func chkAutoStart()
	GUICtrlSetState($g_hTxtAutostartDelay, GUICtrlRead($g_hChkAutoStart) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkAutoStart

Func chkDisposeWindows()
	If GUICtrlRead($g_hChkAutoAlign) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbAlignmentOptions, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtAlignOffsetX, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtAlignOffsetY, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbAlignmentOptions, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtAlignOffsetX, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtAlignOffsetY, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDisposeWindows

Func chkSinglePBTForced()
	If GUICtrlRead($g_hChkSinglePBTForced) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtSinglePBTimeForced, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtPBTimeForcedExit, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtSinglePBTimeForced, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtPBTimeForcedExit, $GUI_DISABLE)
	EndIf
	txtSinglePBTimeForced()
EndFunc   ;==>chkSinglePBTForced

Func txtSinglePBTimeForced()
	Switch Int(GUICtrlRead($g_hTxtSinglePBTimeForced))
		Case 0 To 15
			GUICtrlSetBkColor($g_hTxtSinglePBTimeForced, $COLOR_ERROR)
		Case 16
			GUICtrlSetBkColor($g_hTxtSinglePBTimeForced, $COLOR_YELLOW)
		Case 17 To 999
			GUICtrlSetBkColor($g_hTxtSinglePBTimeForced, $COLOR_MONEYGREEN)
	EndSwitch
	Switch Int(GUICtrlRead($g_hTxtPBTimeForcedExit))
		Case 0 To 11
			GUICtrlSetBkColor($g_hTxtPBTimeForcedExit, $COLOR_ERROR)
		Case 12 To 14
			GUICtrlSetBkColor($g_hTxtPBTimeForcedExit, $COLOR_YELLOW)
		Case 15 To 999
			GUICtrlSetBkColor($g_hTxtPBTimeForcedExit, $COLOR_MONEYGREEN)
	EndSwitch
EndFunc   ;==>txtSinglePBTimeForced

Func chkAutoResume()
	GUICtrlSetState($g_hTxtAutoResumeTime, GUICtrlRead($g_hChkAutoResume) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkAutoResume

Func txtGlobalActiveBotsAllowed()
	Local $iValue = Int(GUICtrlRead($g_hTxtGlobalActiveBotsAllowed))
	If $iValue < 1 Then
		$iValue = 1 ; ensure that at least one bot can run
		GUICtrlSetData($g_hTxtGlobalActiveBotsAllowed, $iValue)
	EndIf
	If $g_iGlobalActiveBotsAllowed <> $iValue Then
		; value changed... for globally changed values, save immediately
		SetDebugLog("Maximum of " & $g_iGlobalActiveBotsAllowed & " bots running at same time changed to " & $iValue)
		$g_iGlobalActiveBotsAllowed = $iValue
		SaveProfileConfig(Default, True)
	EndIf
EndFunc   ;==>txtGlobalActiveBotsAllowed

Func txtGlobalThreads()
	Local $iValue = Int(GUICtrlRead($g_hTxtGlobalThreads))
	If $g_iGlobalThreads <> $iValue Then
		; value changed... for globally changed values, save immediately
		SetDebugLog("Threading: Using " & $g_iGlobalThreads & " threads shared across all bot instances changed to " & $iValue)
		$g_iGlobalThreads = $iValue
		SaveProfileConfig(Default, True)
	EndIf
EndFunc   ;==>txtGlobalThreads

Func txtThreads()
	Local $iValue = Int(GUICtrlRead($g_hTxtThreads))
	If $g_iThreads <> $iValue Then
		; value changed...
		SetDebugLog("Threading: Using " & $g_iThreads & " threads for parallelism changedd to " & $iValue)
		$g_iThreads = $iValue
		setMaxDegreeOfParallelism($g_iThreads)
	EndIf
EndFunc   ;==>txtThreads

; #SWITCHACC FUNCTION# ==============================================================================================================
Func chkSwitchAcc()
	If GUICtrlRead($g_hChkSwitchAcc) = $GUI_CHECKED And aquireSwitchAccountMutex($g_iCmbSwitchAcc, False, True) Then
		For $i = $g_hCmbTotalAccount To $g_ahChkDonate[7]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		GUICtrlSetState($g_hChkOnlySCIDAccounts, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkOnlySCIDAccounts, $GUI_DISABLE)
		OnlySCIDAccounts()
	Else
		releaseSwitchAccountMutex()
		For $i = $g_hCmbTotalAccount To $g_ahChkDonate[7]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetState($g_hChkOnlySCIDAccounts, $GUI_ENABLE)
		OnlySCIDAccounts()
	EndIf
EndFunc   ;==>chkSwitchAcc

Func cmbSwitchAcc()
	Return _cmbSwitchAcc()
EndFunc   ;==>cmbSwitchAcc

Func _cmbSwitchAcc($bReadSaveConfig = True)
	Static $s_bActive = False
	If $s_bActive Then Return
	$s_bActive = True
	Local $iCmbSwitchAcc = _GUICtrlComboBox_GetCurSel($g_hCmbSwitchAcc)
	Local $bAcquired = aquireSwitchAccountMutex($iCmbSwitchAcc, False, True)
	Local $bEnable = False
	If $iCmbSwitchAcc And $bAcquired Then
		$bEnable = True
	Else
		If $g_iCmbSwitchAcc And $iCmbSwitchAcc = 0 Then
			; No Switch Accounts selected, check if current profile was enabled and disable if so
			For $i = 0 To UBound($g_ahChkDonate) - 7
				If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED And GUICtrlRead($g_ahCmbProfile[$i]) = $g_sProfileCurrentName Then
					SetLog("Disabled Profile " & $g_sProfileCurrentName & " in Group " & $g_iCmbSwitchAcc)
					SetSwitchAccLog("Disabled Profile " & $g_sProfileCurrentName & " in Group " & $g_iCmbSwitchAcc)
					GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
					ExitLoop
				EndIf
			Next
		EndIf
		If $iCmbSwitchAcc And Not $bAcquired Then
			$iCmbSwitchAcc = $g_iCmbSwitchAcc
			_GUICtrlComboBox_SetCurSel($g_hCmbSwitchAcc, $iCmbSwitchAcc)
			$bAcquired = aquireSwitchAccountMutex($iCmbSwitchAcc, False, True)
			$bEnable = $bAcquired
		EndIf
	EndIf

	; load selected config
	If $bReadSaveConfig Then
		If $g_iCmbSwitchAcc Then
			; temp restore old selection for saving
			SetLog("Save Switch Accounts Group " & $g_iCmbSwitchAcc)
			SetSwitchAccLog("Save Group " & $g_iCmbSwitchAcc)
			_GUICtrlComboBox_SetCurSel($g_hCmbSwitchAcc, $g_iCmbSwitchAcc)
			SaveConfig_600_35_2()
			_GUICtrlComboBox_SetCurSel($g_hCmbSwitchAcc, $iCmbSwitchAcc)
		EndIf
		$g_iCmbSwitchAcc = $iCmbSwitchAcc
		If $g_iCmbSwitchAcc Then
			SetLog("Read Switch Accounts Group " & $g_iCmbSwitchAcc)
			SetSwitchAccLog("Read Group " & $g_iCmbSwitchAcc)
		EndIf
		ReadConfig_SwitchAccounts()
		ApplyConfig_600_35_2("Read")
	Else
		$g_iCmbSwitchAcc = $iCmbSwitchAcc
	EndIf

	If $bEnable And GUICtrlRead($g_hChkSwitchAcc) = $GUI_UNCHECKED Then
		$bEnable = False
	EndIf

	GUICtrlSetState($g_hChkSwitchAcc, (($bEnable Or ($iCmbSwitchAcc And $bAcquired)) ? $GUI_ENABLE : $GUI_DISABLE))
	For $i = $g_hCmbTotalAccount To $g_ahChkDonate[7]
		GUICtrlSetState($i, (($bEnable) ? $GUI_ENABLE : $GUI_DISABLE))
	Next
	cmbTotalAcc()
	$s_bActive = False
EndFunc   ;==>_cmbSwitchAcc

Func cmbTotalAcc()
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	For $i = 0 To 7
		If $iCmbTotalAcc >= 0 And $i <= $iCmbTotalAcc Then
			_GUI_Value_STATE("SHOW", $g_ahChkAccount[$i] & "#" & $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
		ElseIf $i > $iCmbTotalAcc Then
			GUICtrlSetState($g_ahChkAccount[$i], $GUI_UNCHECKED)
			_GUI_Value_STATE("HIDE", $g_ahChkAccount[$i] & "#" & $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
		EndIf
		chkAccount($i)
	Next
EndFunc   ;==>cmbTotalAcc

Func chkSmartSwitch()
	If GUICtrlRead($g_hChkSmartSwitch) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkDonateLikeCrazy, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkDonateLikeCrazy, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkDonateLikeCrazy, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkSmartSwitch

Func chkAccount($i)
	If GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
		SwitchAccountCheckProfileInUse($g_asProfileName[$i])
	Else
		;GUICtrlSetState($g_ahChkDonate[$i], $GUI_UNCHECKED)
		_GUI_Value_STATE("DISABLE", $g_ahCmbProfile[$i] & "#" & $g_ahChkDonate[$i])
	EndIf
EndFunc   ;==>chkAccount

Func chkAccountX()
	For $i = 0 To UBound($g_ahChkAccount) - 1
		If @GUI_CtrlId = $g_ahChkAccount[$i] Then
			Return chkAccount($i)
		EndIf
	Next
EndFunc   ;==>chkAccountX

Func cmbSwitchAccProfile($i)
	; check if switch with other
	Local $sOldProfile = $g_asProfileName[$i]
	Local $sNewProfile = GUICtrlRead($g_ahCmbProfile[$i])

	SwitchAccountCheckProfileInUse($sNewProfile)

	Local $sOthProfile
	If $sNewProfile Then
		For $j = 0 To UBound($g_ahCmbProfile) - 1
			If $j <> $i Then
				$sOthProfile = GUICtrlRead($g_ahCmbProfile[$j]) ; $g_asProfileName[$j]
				If $sOthProfile = $sNewProfile Then
					; switch
					;_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$i], _GUICtrlComboBox_FindStringExact($g_ahCmbProfile[$i], $g_asProfileName[$i]))
					;$g_asProfileName[$j] = ""
					; clear other
					;_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$j], 0)
					; set other
					$g_asProfileName[$j] = $sOldProfile
					_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$j], _GUICtrlComboBox_FindStringExact($g_ahCmbProfile[$j], $sOldProfile))
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf
	$g_asProfileName[$i] = $sNewProfile
EndFunc   ;==>cmbSwitchAccProfile

Func cmbSwitchAccProfileX()
	For $i = 0 To UBound($g_ahCmbProfile) - 1
		If @GUI_CtrlId = $g_ahCmbProfile[$i] Then
			Return cmbSwitchAccProfile($i)
		EndIf
	Next
EndFunc   ;==>cmbSwitchAccProfileX

; #DEBUG FUNCTION# ==============================================================================================================

Func chkDebugSetLog()
	$g_bDebugSetlog = (GUICtrlRead($g_hChkDebugSetlog) = $GUI_CHECKED) ;
	SetDebugLog("DebugSetlog " & ($g_bDebugSetlog ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugSetLog

Func chkDebugAndroid()
	$g_bDebugAndroid = (GUICtrlRead($g_hChkDebugAndroid) = $GUI_CHECKED)
	SetDebugLog("DebugAndroid " & ($g_bDebugAndroid ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugAndroid

Func chkDebugClick()
	$g_bDebugClick = (GUICtrlRead($g_hChkDebugClick) = $GUI_CHECKED)
	SetDebugLog("DebugClick " & ($g_bDebugClick ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugClick

Func chkDebugFunc()
	Local $bDebugFunc = (GUICtrlRead($g_hChkDebugFunc) = $GUI_CHECKED)
	$g_bDebugFuncTime = $bDebugFunc
	$g_bDebugFuncCall = $bDebugFunc
	SetDebugLog("DebugFunc " & ($bDebugFunc ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugFunc

Func chkDebugDisableZoomout()
	$g_bDebugDisableZoomout = (GUICtrlRead($g_hChkDebugDisableZoomout) = $GUI_CHECKED)
	SetDebugLog("DebugDisableZoomout " & ($g_bDebugDisableZoomout ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugDisableZoomout

Func chkDebugDisableVillageCentering()
	$g_bDebugDisableVillageCentering = (GUICtrlRead($g_hChkDebugDisableVillageCentering) = $GUI_CHECKED)
	SetDebugLog("DebugDisableVillageCentering " & ($g_bDebugDisableVillageCentering ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugDisableVillageCentering

Func chkDebugDeadbaseImage()
	$g_bDebugDeadBaseImage = (GUICtrlRead($g_hChkDebugDeadbaseImage) = $GUI_CHECKED)
	SetDebugLog("DebugDeadbaseImage " & ($g_bDebugDeadBaseImage ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugDeadbaseImage

Func chkDebugOcr()
	$g_bDebugOcr = (GUICtrlRead($g_hChkDebugOCR) = $GUI_CHECKED)
	SetDebugLog("DebugOcr " & ($g_bDebugOcr ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugOcr

Func chkDebugImageSave()
	$g_bDebugImageSave = (GUICtrlRead($g_hChkDebugImageSave) = $GUI_CHECKED)
	SetDebugLog("DebugImageSave " & ($g_bDebugImageSave ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugImageSave

Func chkDebugBuildingPos()
	$g_bDebugBuildingPos = (GUICtrlRead($g_hChkdebugBuildingPos) = $GUI_CHECKED)
	SetDebugLog("DebugBuildingPos " & ($g_bDebugBuildingPos ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugBuildingPos

Func chkDebugTrain()
	$g_bDebugSetlogTrain = (GUICtrlRead($g_hChkdebugTrain) = $GUI_CHECKED)
	SetDebugLog("DebugTrain " & ($g_bDebugSetlogTrain ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugTrain

Func chkdebugOCRDonate()
	$g_bDebugOCRdonate = (GUICtrlRead($g_hChkDebugOCRDonate) = $GUI_CHECKED)
	SetDebugLog("DebugOCRDonate " & ($g_bDebugOCRdonate ? "enabled" : "disabled"))
EndFunc   ;==>chkdebugOCRDonate

Func chkdebugAttackCSV()
	$g_bDebugAttackCSV = (GUICtrlRead($g_hChkdebugAttackCSV) = $GUI_CHECKED)
	SetDebugLog("DebugAttackCSV " & ($g_bDebugAttackCSV ? "enabled" : "disabled"))
EndFunc   ;==>chkdebugAttackCSV

Func chkmakeIMGCSV()
	$g_bDebugMakeIMGCSV = (GUICtrlRead($g_hChkMakeIMGCSV) = $GUI_CHECKED)
	SetDebugLog("MakeIMGCSV " & ($g_bDebugMakeIMGCSV ? "enabled" : "disabled"))
EndFunc   ;==>chkmakeIMGCSV

Func btnTestTrain()
	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	SetLog("Testing Train()", $COLOR_INFO)

	TrainSystem()

	SetLog("Testing Train DONE", $COLOR_INFO)

	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestTrain

Func btnTestDonateCC()
	Local $currentRunState = $g_bRunState
	Local $currentSetlog = $g_bDebugSetlog
	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	$g_bRunState = True

	SetLog(_PadStringCenter(" Test DonateCC begin (" & $g_sBotVersion & ")", 54, "="), $COLOR_INFO)
	PrepareDonateCC()
	$g_iCurrentSpells = 11
	$g_aiCurrentSiegeMachines[$eSiegeWallWrecker] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] = 1
	$g_aiCurrentSiegeMachines[$eSiegeStoneSlammer] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBarracks] = 1
	$g_aiCurrentSiegeMachines[$eSiegeLogLauncher] = 1
	DonateCC()
	SetLog(_PadStringCenter(" Test DonateCC end ", 54, "="), $COLOR_INFO)

	$g_bRunState = $currentRunState
	$g_bDebugSetlog = $currentSetlog
EndFunc   ;==>btnTestDonateCC

Func btnTestRequestCC()
	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	$g_bCanRequestCC = True
	SetLog(_PadStringCenter(" Test RequestCC begin (" & $g_sBotVersion & ")", 54, "="), $COLOR_INFO)
	RequestCC()
	SetLog(_PadStringCenter(" Test RequestCC end ", 54, "="), $COLOR_INFO)
	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestRequestCC

Func btnTestSendText()
	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	SetLog(_PadStringCenter(" Test SendText begin (" & $g_sBotVersion & ")", 54, "="), $COLOR_INFO)
	Local $s = InputBox("Send characters to Android", "Text to send (please open a input box in Android):", "some text ;-)", "")
	SendText($s)
	SetLog(_PadStringCenter(" Test SendText end ", 54, "="), $COLOR_INFO)
	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestSendText

Func btnTestAttackBar()
	Local $bCurrentOCR = $g_bDebugOcr, $bCurrentRunState = $g_bRunState, $bCurrentDebugImage = $g_bDebugImageSave

	_GUICtrlTab_ClickTab($g_hTabMain, 0)

	$g_bDebugOcr = True
    $g_bDebugImageSave = True
	$g_bRunState = True

	If MsgBox($MB_YESNO, "Screenshot or Live Image", "Do you want to use a Screenshot instead of a Live Image?") = $IDYES Then
	 Local $sImageFile = BeginImageTest() ; get image for testing
	 If $sImageFile = False Then $sImageFile = "Live Screenshot"
	EndIf


	SetLog(_PadStringCenter(" Begin AttackBar Detection", 54, "="), $COlOR_INFO)

	Local $avAttackBar = GetAttackBar(False, $DB, True)

	If IsArray($avAttackBar) And UBound($avAttackBar, 1) >= 1 Then
	SetLog("Found " & UBound($avAttackBar, 1) & " Slots", $COlOR_SUCCESS)
	For $i = 0 To UBound($avAttackBar, 1) - 1
		SetLog("- Slot " & $avAttackBar[$i][1] & ": " & $avAttackBar[$i][2] & " " & GetTroopName($avAttackBar[$i][0], $avAttackBar[$i][2]) & " (X: " & $avAttackBar[$i][3] & "|Y: " & $avAttackBar[$i][4] & "|OCR X: " & $avAttackBar[$i][5] & "|OCR Y: " & $avAttackBar[$i][6] & ")", $COLOR_SUCCESS)
	Next
	EndIf
	SetLog(_PadStringCenter(" End AttackBar Detection ", 54, "="), $COlOR_INFO)

	EndImageTest() ; clear test image handle

	$g_bDebugOcr = $bCurrentOCR
	$g_bDebugImageSave = $bCurrentDebugImage
	$g_bRunState = $bCurrentRunState
EndFunc   ;==>btnTestAttackBar


Func btnTestClickDrag()
	Local $sUserInputCoor = InputBox("Coordinators", "x1,y1,x2,y2", "650,469,290,469")
	Local $asCoor = StringSplit($sUserInputCoor, ",")

	If @error Or $asCoor[0] <> 4 Then
		SetLog("Please try again with the correct format...", $COLOR_ERROR)
		Return
	EndIf

	SetLog("Testing Click drag functionality...", $COLOR_INFO)

	SetLog("Drag from (" & $asCoor[1] & "," & $asCoor[2] & ") to (" & $asCoor[3] & "," & $asCoor[4] & ")", $COLOR_DEBUG)
	ClickDrag(Int($asCoor[1]), Int($asCoor[2]), Int($asCoor[3]), Int($asCoor[4]))

	SetLog("Sleep 3 seconds...", $COLOR_DEBUG)
	_Sleep(3000, True, False)

	SetLog("Save the image", $COLOR_DEBUG)
	SaveDebugImage("TestClickDrag", Default, Default, "_" & $asCoor[1] & "x." & $asCoor[2] & "y." & $asCoor[3] & "x." & $asCoor[4] & "y_")

	SetLog("Sleep 1 seconds", $COLOR_DEBUG)
	_Sleep(1000, True, False)

	SetLog("Drag back", $COLOR_DEBUG)
	ClickDrag(Int($asCoor[3]), Int($asCoor[4]), Int($asCoor[1]), Int($asCoor[2]))
EndFunc   ;==>btnTestClickDrag

Func btnTestImage()

	Local $sImageFile = BeginImageTest() ; get image for testing
	If $sImageFile = False Then $sImageFile = "Live Screenshot"

	Local $i
	Local $result
	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	Local $Message

	For $i = 0 To 0

		SetLog("Testing isProblemAffect...", $COLOR_SUCCESS)
		$result = isProblemAffect(False)
		SetLog("Testing isProblemAffect DONE, $Result=" & $result, $COLOR_SUCCESS)

		SetLog("Testing checkObstacles...", $COLOR_SUCCESS)
		$result = checkObstacles()
		SetLog("Testing checkObstacles DONE, $Result=" & $result, $COLOR_SUCCESS)

		SetLog("Testing waitMainScreen...", $COLOR_SUCCESS)
		$result = waitMainScreen()
		SetLog("Testing waitMainScreen DONE, $Result=" & $result, $COLOR_SUCCESS)

		SetLog("Testing waitMainScreenMini...", $COLOR_SUCCESS)
		$result = waitMainScreenMini()
		SetLog("Testing waitMainScreenMini DONE, $Result=" & $result, $COLOR_SUCCESS)

		SetLog("Testing WaitForClouds...", $COLOR_SUCCESS)
		SetLog("$aNoCloudsAttack pixel check: " & _CheckPixel($aNoCloudsAttack, $g_bCapturePixel))
		SetLog("Testing WaitForClouds DONE", $COLOR_SUCCESS)

	Next

	SetLog("Testing finished", $COLOR_INFO)

	EndImageTest() ; clear test image handle

	$g_bRunState = $currentRunState

EndFunc   ;==>btnTestImage

Func btnTestVillageSize()

	BeginImageTest()
	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	$g_bRestart = False

	_CaptureRegion()
	_CaptureRegion2Sync()

	Local $a[2][2] = [["stone", "tree"], ["2stone", "2tree"]]
	For $i = 0 To 1
		SetLog("Testing GetVillageSize(True, """ & $a[$i][0] & """, """ & $a[$i][1] & """)", $COLOR_INFO)
		Local $hTimer = __TimerInit()
		Local $village = GetVillageSize(True, $a[$i][0], $a[$i][1])
		Local $ms = __TimerDiff($hTimer)
		If $village = 0 Then
			SetLog("Village not found (" & Round($ms, 0) & " ms.)", $COLOR_WARNING)
		Else
			SetLog("Village found (" & Round($ms, 0) & " ms.)", $COLOR_WARNING)
			SetLog("Village size: " & $village[0])
			SetLog("Village zoom level: " & $village[1])
			SetLog("Village offset x: " & $village[2])
			SetLog("Village offset y: " & $village[3])
			SetLog("Village stone " & $village[6] & ": " & $village[4] & ", " & $village[5])
			SetLog("Village tree " & $village[9] & ": " & $village[7] & ", " & $village[8])
		EndIf
	Next
	EndImageTest()

	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestVillageSize

Func btnTestDeadBase()
	Local $hBMP = 0, $hHBMP = 0
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", $g_sProfileTempPath, "Image (*.png)", $FD_FILEMUSTEXIST, "", $g_hFrmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $g_sAndroidEmulator, $COLOR_INFO)
		_CaptureRegion()
		$hHBMP = $g_hHBitmap
		TestCapture($hHBMP)
	Else
		SetLog("Testing image " & $sImageFile, $COLOR_INFO)
		; load test image
		$hBMP = _GDIPlus_BitmapCreateFromFile($sImageFile)
		$hHBMP = _GDIPlus_BitmapCreateDIBFromBitmap($hBMP)
		_GDIPlus_BitmapDispose($hBMP)
		TestCapture($hHBMP)
		SetLog("Testing image hHBitmap = " & $hHBMP)
	EndIf

	Local $currentRunState = $g_bRunState
	$g_bRunState = True

	SearchZoomOut($aCenterEnemyVillageClickDrag, True, "btnTestDeadBase")
	ResetTHsearch()
	SetLog("Testing FindTownhall()", $COLOR_INFO)
	SetLog("FindTownhall() = " & FindTownhall(True), $COLOR_INFO)
	SetLog("$g_sImglocRedline = " & $g_sImglocRedline, $COLOR_INFO)

	SetLog("Testing checkDeadBase()", $COLOR_INFO)
	SetLog("Result checkDeadBase() = " & checkDeadBase(), $COLOR_INFO)
	SetLog("Testing checkDeadBase() DONE", $COLOR_INFO)

	If $hHBMP <> 0 Then
		_WinAPI_DeleteObject($hHBMP)
		TestCapture(0)
	EndIf

	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestDeadBase

Func btnTestDeadBaseFolder()

	;Local $directory = FileOpenDialog("Select folder of CoC village screenshot to test for dead base", $g_sProfileTempPath, "Image (*.png)", $FD_PATHMUSTEXIST, "", $g_hFrmBot)
	Local $directory = FileSelectFolder("Select folder of CoC village screenshot to test for dead base", "", $FSF_NEWDIALOG, @ScriptDir, $g_hFrmBot)
	If @error <> 0 Then
		SetLog("btnTestDeadBaseFolder cancelled", $COLOR_INFO)
	EndIf

	;checkDeadBaseFolder($directory, "checkDeadBaseNew()", "checkDeadBaseSuperNew()")
	Local $oldFill = 'checkDeadBaseSuperNew(False, "' & @ScriptDir & "\imgxml\deadbase\elix\fill\old\" & '")'
	Local $newFill = 'checkDeadBaseSuperNew(False, "' & @ScriptDir & "\imgxml\deadbase\elix\fill\new\" & '")'
	checkDeadBaseFolder($directory, $oldFill, $newFill)

EndFunc   ;==>btnTestDeadBaseFolder

Func btnTestAttackCSV()

	BeginImageTest() ; get image for testing

	Local $currentRunState = $g_bRunState
	Local $currentDebugAttackCSV = $g_bDebugAttackCSV
	Local $currentMakeIMGCSV = $g_bDebugMakeIMGCSV
	Local $currentiMatchMode = $g_iMatchMode
	Local $currentdebugsetlog = $g_bDebugSetlog
	Local $currentDebugBuildingPos = $g_bDebugBuildingPos

	$g_bRunState = True
	$g_bDebugAttackCSV = True
	$g_bDebugMakeIMGCSV = True
	$g_bDebugSetlog = True
	$g_bDebugBuildingPos = True

	$g_iMatchMode = $DB ; define which script to use

	; reset village measures
	setVillageOffset(0, 0, 1)
	ConvertInternalExternArea()
	;SearchZoomOut($aCenterEnemyVillageClickDrag, True, "btnTestAttackCSV")
	If CheckZoomOut("btnTestAttackCSV", True, False) = False Then
		SetLog("CheckZoomOut failed", $COLOR_INFO)
	EndIf
	ResetTHsearch()
	SetLog("Testing FindTownhall()", $COLOR_INFO)
	SetLog("FindTownhall() = " & FindTownhall(True), $COLOR_INFO)
	SetLog("$g_sImglocRedline = " & $g_sImglocRedline, $COLOR_INFO)

	SetLog("Testing PrepareAttack()", $COLOR_INFO)
	PrepareAttack($g_iMatchMode)

	SetLog("Testing Algorithm_AttackCSV()", $COLOR_INFO)
	Algorithm_AttackCSV(True, False) ; true for test attack mode, and false for get redlinearea
	SetLog("Testing Algorithm_AttackCSV() DONE", $COLOR_INFO)

	EndImageTest() ; clear test image handle

	$g_bRunState = $currentRunState
	$g_bDebugAttackCSV = $currentDebugAttackCSV
	$g_bDebugMakeIMGCSV = $currentMakeIMGCSV
	$g_iMatchMode = $currentiMatchMode
	$g_bDebugSetlog = $currentdebugsetlog
	$g_bDebugBuildingPos = $currentDebugBuildingPos

EndFunc   ;==>btnTestAttackCSV

Func btnTestGetLocationBuilding()

	Local $aResult, $iBdlgFindTime, $hTimer

	BeginImageTest() ; get image for testing

	; Store variables changed, set test values
	Local $currentRunState = $g_bRunState
	Local $currentDebugBuildingPos = $g_bDebugBuildingPos
	Local $currentdebugsetlog = $g_bDebugSetlog
	$g_bRunState = True
	$g_bDebugBuildingPos = True
	$g_bDebugSetlog = True

	; reset village measures
	setVillageOffset(0, 0, 1)
	ConvertInternalExternArea()
	;SearchZoomOut($aCenterEnemyVillageClickDrag, True, "btnTestAttackCSV")
	If CheckZoomOut("btnTestGetLocationBuilding", True, False) = False Then
		SetLog("CheckZoomOut failed", $COLOR_INFO)
	EndIf
	ResetTHsearch()
	SetLog("Testing FindTownhall()", $COLOR_INFO)
	SetLog("FindTownhall() = " & FindTownhall(True), $COLOR_INFO)
	;	SetLog("$g_sImglocRedline = " & $g_sImglocRedline, $COLOR_INFO)

	_LogObjList($g_oBldgAttackInfo) ; log dictionary contents

	SetLog("Testing GetLocationBuilding() with all buildings", $COLOR_INFO)

	For $b = $eBldgGoldS To $eBldgScatter
		If $b = $eBldgDarkS Then ContinueLoop ; skip dark elixir as images not available
		$aResult = GetLocationBuilding($b, $g_iSearchTH, False)
		If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$b], $COLOR_ERROR)
	Next

	_LogObjList($g_oBldgAttackInfo) ; log dictionary contents
	btnTestGetLocationBuildingImage() ; create image of locations
	;AttackCSVDEBUGIMAGE()

	Local $string, $iFindBldgTotalTestTime
	Local $iKeys = $g_oBldgAttackInfo.Keys
	For $string In $iKeys
		If StringInStr($string, "_FINDTIME", $STR_NOCASESENSEBASIC) > 0 Then $iFindBldgTotalTestTime += $g_oBldgAttackInfo.item($string)
	Next
	SetLog("GetLocationBuilding() Total Image search time= " & $iFindBldgTotalTestTime, $COLOR_SUCCESS)

	$g_oBldgAttackInfo.RemoveAll ; remove all data

	SetLog("Testing DONE", $COLOR_INFO)

	EndImageTest() ; clear test image handle

	; restore changed variables
	$g_bRunState = $currentRunState
	$g_bDebugBuildingPos = $currentDebugBuildingPos
	$g_bDebugSetlog = $currentdebugsetlog

EndFunc   ;==>btnTestGetLocationBuilding

Func btnTestGetLocationBuildingImage()

	Local $iTimer = __TimerInit()

	_CaptureRegion2()
	Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local $pixel

	; Open box of crayons :-)
	Local $hPenWhite = _GDIPlus_PenCreate(0xFFFFFFFF, 2)
	Local $hPenMagenta = _GDIPlus_PenCreate(0xFFFF00F6, 2)
	Local $hPenRed = _GDIPlus_PenCreate(0xFFFF0000, 2)
	Local $hPenNavyBlue = _GDIPlus_PenCreate(0xFF000066, 2)
	Local $hPenBlue = _GDIPlus_PenCreate(0xFF0000CC, 2)
	Local $hPenSteelBlue = _GDIPlus_PenCreate(0xFF0066CC, 2)
	Local $hPenLtBlue = _GDIPlus_PenCreate(0xFF0080FF, 2)
	Local $hPenPaleBlue = _GDIPlus_PenCreate(0xFF66B2FF, 2)
	Local $hPenCyan = _GDIPlus_PenCreate(0xFF00FFFF, 2)


	; - GOLD STORAGE
	If $g_oBldgAttackInfo.exists($eBldgGoldS & "_LOCATION") Then
		$g_aiCSVGoldStoragePos = $g_oBldgAttackInfo.item($eBldgGoldS & "_LOCATION")
		If IsArray($g_aiCSVGoldStoragePos) Then
			For $i = 0 To UBound($g_aiCSVGoldStoragePos) - 1
				$pixel = $g_aiCSVGoldStoragePos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 20, 20, $hPenMagenta)
			Next
		EndIf
	EndIf

	; - ELIXIR STORAGE
	If $g_oBldgAttackInfo.exists($eBldgElixirS & "_LOCATION") Then
		$g_aiCSVElixirStoragePos = $g_oBldgAttackInfo.item($eBldgElixirS & "_LOCATION")
		If IsArray($g_aiCSVElixirStoragePos) Then
			For $i = 0 To UBound($g_aiCSVElixirStoragePos) - 1
				$pixel = $g_aiCSVElixirStoragePos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 20, 20, $hPenWhite)
			Next
		EndIf
	EndIf

	; - DRAW TOWNHALL -------------------------------------------------------------------
	_GDIPlus_GraphicsDrawRect($hGraphic, $g_iTHx - 5, $g_iTHy - 10, 30, 30, $hPenRed)

	; - DRAW Eagle -------------------------------------------------------------------
	If $g_oBldgAttackInfo.exists($eBldgEagle & "_LOCATION") Then
		$g_aiCSVEagleArtilleryPos = $g_oBldgAttackInfo.item($eBldgEagle & "_LOCATION")
		If IsArray($g_aiCSVEagleArtilleryPos[0]) Then
			Local $sPixel = $g_aiCSVEagleArtilleryPos[0]
			_GDIPlus_GraphicsDrawRect($hGraphic, $sPixel[0] - 15, $sPixel[1] - 15, 30, 30, $hPenBlue)
		EndIf
	EndIf

	; - DRAW Inferno -------------------------------------------------------------------
	If $g_oBldgAttackInfo.exists($eBldgInferno & "_LOCATION") Then
		$g_aiCSVInfernoPos = $g_oBldgAttackInfo.item($eBldgInferno & "_LOCATION")
		If IsArray($g_aiCSVInfernoPos) Then
			For $i = 0 To UBound($g_aiCSVInfernoPos) - 1
				$pixel = $g_aiCSVInfernoPos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenNavyBlue)
			Next
		EndIf
	EndIf

	; - DRAW X-Bow -------------------------------------------------------------------
	If $g_oBldgAttackInfo.exists($eBldgXBow & "_LOCATION") Then
		$g_aiCSVXBowPos = $g_oBldgAttackInfo.item($eBldgXBow & "_LOCATION")
		If IsArray($g_aiCSVXBowPos) Then
			For $i = 0 To UBound($g_aiCSVXBowPos) - 1
				$pixel = $g_aiCSVXBowPos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 25, 25, 25, $hPenBlue)
			Next
		EndIf
	EndIf

	; - DRAW Scatter Shot -------------------------------------------------------------------
	If $g_oBldgAttackInfo.exists($eBldgScatter & "_LOCATION") Then
		$g_aiCSVScatterPos = $g_oBldgAttackInfo.item($eBldgScatter & "_LOCATION")
		If IsArray($g_aiCSVScatterPos) Then
			For $i = 0 To UBound($g_aiCSVScatterPos) - 1
				$pixel = $g_aiCSVScatterPos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 25, 25, 25, $hPenBlue)
			Next
		EndIf
	EndIf

	; - DRAW Wizard Towers -------------------------------------------------------------------
	If $g_oBldgAttackInfo.exists($eBldgWizTower & "_LOCATION") Then
		$g_aiCSVWizTowerPos = $g_oBldgAttackInfo.item($eBldgWizTower & "_LOCATION")
		If IsArray($g_aiCSVWizTowerPos) Then
			For $i = 0 To UBound($g_aiCSVWizTowerPos) - 1
				$pixel = $g_aiCSVWizTowerPos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 5, $pixel[1] - 15, 25, 25, $hPenSteelBlue)
			Next
		EndIf
	EndIf

	; - DRAW Mortars -------------------------------------------------------------------
	If $g_oBldgAttackInfo.exists($eBldgMortar & "_LOCATION") Then
		$g_aiCSVMortarPos = $g_oBldgAttackInfo.item($eBldgMortar & "_LOCATION")
		If IsArray($g_aiCSVMortarPos) Then
			For $i = 0 To UBound($g_aiCSVMortarPos) - 1
				$pixel = $g_aiCSVMortarPos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 25, 25, $hPenLtBlue)
			Next
		EndIf
	EndIf

	; - DRAW Air Defense -------------------------------------------------------------------
	If $g_oBldgAttackInfo.exists($eBldgAirDefense & "_LOCATION") Then
		$g_aiCSVAirDefensePos = $g_oBldgAttackInfo.item($eBldgAirDefense & "_LOCATION")
		If IsArray($g_aiCSVAirDefensePos) Then
			For $i = 0 To UBound($g_aiCSVAirDefensePos) - 1
				$pixel = $g_aiCSVAirDefensePos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 12, $pixel[1] - 10, 25, 25, $hPenPaleBlue)
			Next
		EndIf
	EndIf

	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $filename = $g_sProfileTempDebugPath & String("GetLocationBuilding_" & $Date & "_" & $Time) & ".jpg"
	_GDIPlus_ImageSaveToFile($EditedImage, $filename)
	SetLog("GetLocationBuilding image saved: " & $filename)


	; Clean up resources
	_GDIPlus_PenDispose($hPenWhite)
	_GDIPlus_PenDispose($hPenMagenta)
	_GDIPlus_PenDispose($hPenRed)
	_GDIPlus_PenDispose($hPenBlue)
	_GDIPlus_PenDispose($hPenNavyBlue)
	_GDIPlus_PenDispose($hPenSteelBlue)
	_GDIPlus_PenDispose($hPenLtBlue)
	_GDIPlus_PenDispose($hPenPaleBlue)
	_GDIPlus_PenDispose($hPenCyan)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($EditedImage)

	; open image
	If TestCapture() Then
		ShellExecute($filename)
	EndIf

	SetLog("GetLocationBuilding DEBUG IMAGE Create Required: " & Round((__TimerDiff($iTimer) * 0.001), 1) & "Seconds", $COLOR_DEBUG)

EndFunc   ;==>btnTestGetLocationBuildingImage

;~ Func btnTestFindButton()
;~ 	BeginImageTest()
;~ 	Local $result
;~ 	Local $sButton = GUICtrlRead($g_hTxtTestFindButton)
;~ 	SetLog("Testing findButton(""" & $sButton & """)", $COLOR_INFO)
;~ 	$result = findButton($sButton)
;~ 	$result = ((IsArray($result)) ? (_ArrayToString($result, ",")) : ($result))
;~ 	If @error Then $result = "Error " & @error & ", " & @extended & ", "
;~ 	SetLog("Result findButton(""" & $sButton & """) = " & $result, $COLOR_INFO)
;~ 	SetLog("Testing findButton(""" & $sButton & """) DONE", $COLOR_INFO)
;~ 	EndImageTest()
;~ EndFunc   ;==>btnTestFindButton

Func btnRunFunction()
	Local $currentRunState = $g_bRunState
	$g_bRunState = True

	Local $sFunc = GUICtrlRead($g_hTxtRunFunction)
	SetLog("Run Function : " & $sFunc, $COLOR_INFO)

	Local $saExecResult = Execute($sFunc)
	If $saExecResult = "" And @error <> 0 Then
		Setlog("Result : Error", $COLOR_ERROR)
	ElseIf IsArray($saExecResult) Then
		Setlog("Result (IsArray) : " & _ArrayToString($saExecResult, ","), $COLOR_INFO)
		_ArrayDisplay($saExecResult, "Debug Func. Result")
	Else
		Setlog("Result : " & $saExecResult, $COLOR_INFO)
	EndIf

	$g_bRunState = $currentRunState
EndFunc

Func btnTestCleanYard()
	Local $currentRunState = $g_bRunState
	Local $iCurrFreeBuilderCount = $g_iFreeBuilderCount
	$g_iTestFreeBuilderCount = 5
	$g_bRunState = True
	BeginImageTest()
	Local $result
	SetLog("Testing CleanYard", $COLOR_INFO)
	SearchZoomOut($aCenterEnemyVillageClickDrag, True, "btnTestCleanYard")
	$result = CleanYard()
	$result = ((IsArray($result)) ? (_ArrayToString($result, ",")) : ($result))
	If @error Then $result = "Error " & @error & ", " & @extended & ", "
	SetLog("Result CleanYard", $COLOR_INFO)
	SetLog("Testing CheckTombs", $COLOR_INFO)
	$result = CheckTombs()
	$result = ((IsArray($result)) ? (_ArrayToString($result, ",")) : ($result))
	If @error Then $result = "Error " & @error & ", " & @extended & ", "
	SetLog("Result CheckTombs", $COLOR_INFO)
	SetLog("Testing CleanYard DONE", $COLOR_INFO)
	EndImageTest()
	; restore original state
	$g_iTestFreeBuilderCount = -1
	$g_iFreeBuilderCount = $iCurrFreeBuilderCount
	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestCleanYard

Func BeginImageTest($directory = $g_sProfileTempPath)
	Local $hBMP = 0, $hHBMP = 0
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", $directory, "Image (*.png)", $FD_FILEMUSTEXIST, "", $g_hFrmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $g_sAndroidEmulator, $COLOR_INFO)
		;ZoomOut()
		_CaptureRegion()
		$hHBMP = $g_hHBitmap
		TestCapture($hHBMP)
		Return False
	EndIf
	SetLog("Testing image " & $sImageFile, $COLOR_INFO)
	; load test image
	$hBMP = _GDIPlus_BitmapCreateFromFile($sImageFile)
	$hHBMP = _GDIPlus_BitmapCreateDIBFromBitmap($hBMP)
	_GDIPlus_BitmapDispose($hBMP)
	TestCapture($hHBMP)
	SetLog("Testing image hHBitmap = " & $hHBMP)
	Return $sImageFile
EndFunc   ;==>BeginImageTest

Func EndImageTest()
	TestCapture(0)
EndFunc   ;==>EndImageTest

Func FixClanCastle($inputString)
	; if found  a space in results of attack bar slot detection, force insert of clan castle
	; work if the clan castle it is not placed in the last slot
	Local $OutputFinal = ""
	Local $aTroopDataList = StringSplit($inputString, "|")
	Local $aTemp[12][3]
	Local $counter = 0
	If $inputString <> "" Then
		For $i = 1 To $aTroopDataList[0]
			If $counter > 0 Then $OutputFinal &= "|"
			Local $troopData = StringSplit($aTroopDataList[$i], "#", $STR_NOCOUNT)
			If $troopData[0] = 17 Or $troopData[0] = 18 Or $troopData[0] = 19 Or $troopData[0] = 20 Then $troopData[2] = 1
			If $counter <> Number($troopData[1]) Then
				$OutputFinal &= $eCastle & "#" & $counter & "#" & "1" & "|"
				$counter = $troopData[1]
				SetLog("Clan castle Forced in slot " & $counter, $COLOR_INFO)
			EndIf
			$counter += 1
			$OutputFinal &= $troopData[0] & "#" & $troopData[1] & "#" & $troopData[2]
		Next
	EndIf
	Return $OutputFinal

EndFunc   ;==>FixClanCastle

Func btnTestOcrMemory()

	_CaptureRegion2(162, 200, 162 + 120, 200 + 27)

	For $i = 1 To 5000
		DllCallMyBot("ocr", "ptr", $g_hHBitmap2, "str", "coc-DonTroops", "int", $g_bDebugOcr ? 1 : 0)
		;getOcr($g_hHBitmap2, "coc-DonTroops")
		;getOcrAndCapture("coc-DonTroops", 162, 200, 120, 27, True)

	Next

EndFunc   ;==>btnTestOcrMemory

Func btnTestWeakBase()
	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	BeginImageTest()
	FindTownhall(True)
	If ($g_iSearchTH <> "-") Then
		IsWeakBase($g_iImglocTHLevel, $g_sImglocRedline, False)
	Else
		IsWeakBase($g_iMaxTHLevel, "", False)
	EndIf
	EndImageTest()
	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestWeakBase

Func btnTestClickAway()
	ClickAway()
EndFunc   ;==>btnTestClickAway

Func btnTestUpgradeWindow()
	Local $currentRunState = $g_bRunState
	Local $iCurrFreeBuilderCount = $g_iFreeBuilderCount
	$g_iTestFreeBuilderCount = 5
	$g_bRunState = True
	BeginImageTest()
	Local $result
	SetLog("Testing LocateUpgrade", $COLOR_INFO)
	;$result = UpgradeNormal(0, True)
	SetLog("Result = " & $result, $COLOR_INFO)
	EndImageTest()
	; restore original state
	$g_iTestFreeBuilderCount = -1
	$g_iFreeBuilderCount = $iCurrFreeBuilderCount
	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestUpgradeWindow

Func btnTestSmartWait()
    Local $currentRunState = $g_bRunState
    Local $bCloseWhileTrainingEnable = $g_bCloseWhileTrainingEnable

    $g_bRunState = True
    $g_bCloseWhileTrainingEnable = True

    SmartWait4Train(20)

    $g_bRunState = $currentRunState
    $g_bCloseWhileTrainingEnable = $bCloseWhileTrainingEnable
EndFunc   ;==>btnTestSmartWait

Func btnConsoleWindow()
	ConsoleWindow()
EndFunc   ;==>btnConsoleWindow

Func chkSQLite()
	$g_bUseStatistics = GUICtrlRead($g_hChkSqlite) = $GUI_CHECKED
EndFunc   ;==>chkSQLite

Func SQLiteExport()

	If Not $g_bUseStatistics Then
		Setlog("")
		Return
	EndIf
	Setlog("Exporting data from SQlite, please wait!", $COLOR_ACTION)
	ExportDataBase(False)
	Setlog("Export successfully completed.", $COLOR_SUCCESS)

EndFunc   ;==>SQLiteExport
