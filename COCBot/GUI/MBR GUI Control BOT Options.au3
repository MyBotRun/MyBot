; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Bot Options
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run Team
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $aLanguageFile[1][2]; undimmed language file array [FileName][DisplayName]
Global $hLangIcons = 0

Func LoadLanguagesComboBox()

	Local $hFileSearch = FileFindFirstFile($dirLanguages & "*.ini")
	Local $sFilename, $sLangDisplayName = "", $iFileIndex = 0

	If $hLangIcons Then _GUIImageList_Destroy($hLangIcons)
	$hLangIcons = _GUIImageList_Create(16, 16, 5)

	While 1
		$sFilename = FileFindNextFile($hFileSearch)
		If @error Then ExitLoop ; exit when no more files are found
		ReDim $aLanguageFile[$iFileIndex + 1][3]
		$aLanguageFile[$iFileIndex][0] = StringLeft($sFilename, StringLen($sFilename) - 4)
		; All Language Icons are made by YummyGum and can be found here: https://www.iconfinder.com/iconsets/142-mini-country-flags-16x16px
		$aLanguageFile[$iFileIndex][2] = _GUIImageList_AddIcon($hLangIcons, @ScriptDir & "\lib\MBRBot.dll", Eval("e" & $aLanguageFile[$iFileIndex][0]) - 1 )
		$sLangDisplayName = IniRead($dirLanguages & $sFilename, "Language", "DisplayName", "Unknown")
		$aLanguageFile[$iFileIndex][1] = $sLangDisplayName
		If $sLangDisplayName = "Unknown" Then
			; create a new language section and write the filename as default displayname (also for new empty language files)
			IniWrite($dirLanguages & $sFilename, "Language", "DisplayName", StringLeft($sFilename, StringLen($sFilename) - 4)) ; removing ".ini" from filename
			$sLangDisplayName = IniRead($dirLanguages & $sFilename, "Language", "DisplayName", "Unknown")
			$aLanguageFile[$iFileIndex][1] = $sLangDisplayName
		EndIf

		$iFileIndex += 1
	WEnd
	FileClose($hFileSearch)

	;reset combo box
	_GUICtrlComboBox_ResetContent($g_hCmbGUILanguage)

	;set combo box
	_GUICtrlComboBoxEx_SetImageList($g_hCmbGUILanguage, $hLangIcons)
	For $i = 0 to UBound($aLanguageFile) - 1
		If $aLanguageFile[$i][2] <> -1 Then
			_GUICtrlComboBoxEx_AddString($g_hCmbGUILanguage, $aLanguageFile[$i][1], $aLanguageFile[$i][2], $aLanguageFile[$i][2])
		Else
			_GUICtrlComboBoxEx_AddString($g_hCmbGUILanguage, $aLanguageFile[$i][1], $eMissingLangIcon, $eMissingLangIcon)
		EndIf
	Next
	_GUICtrlComboBoxEx_SetCurSel($g_hCmbGUILanguage, _GUICtrlComboBoxEx_FindStringExact($g_hCmbGUILanguage, $aLanguageFile[_ArraySearch($aLanguageFile, $sLanguage)][1]))

EndFunc   ;==>LoadLanguagesComboBox

Func cmbLanguage()
	Local $aLanguage = _GUICtrlComboBox_GetListArray($g_hCmbGUILanguage)
	Local $sLanguageIndex = _ArraySearch($aLanguageFile, $aLanguage[_GUICtrlComboBox_GetCurSel($g_hCmbGUILanguage) + 1])

	$sLanguage = $aLanguageFile[$sLanguageIndex][0] ; the filename = 0, the display name = 1
	MsgBox("", "", GetTranslated(636, 71, "Restart Bot to load program with new language:") & " " & $aLanguageFile[$sLanguageIndex][1] & " (" & $sLanguage & ")")
	IniWriteS($g_sProfileConfigPath, "other", "language", $sLanguage) ; save language before restarting
	ShellExecute(@ScriptFullPath,$g_sProfileCurrentName & " " & $g_sAndroidEmulator & " " & $g_sAndroidInstance & " /r")
EndFunc   ;==>cmbLanguage

Func chkUseRandomClick()
	$iUseRandomClick = (GUICtrlRead($g_hChkUseRandomClick) = $GUI_CHECKED ? 1 : 0)
EndFunc   ;==>chkUseRandomClick

Func chkUpdatingWhenMinimized()
	$iUpdatingWhenMinimized = (GUICtrlRead($g_hChkUpdatingWhenMinimized) = $GUI_CHECKED ? 1 : 0)
EndFunc   ;==>chkUpdatingWhenMinimized

Func chkHideWhenMinimized()
	$iHideWhenMinimized = (GUICtrlRead($g_hChkHideWhenMinimized) = $GUI_CHECKED ? 1 : 0)
	TrayItemSetState($g_hTiHide, ($iHideWhenMinimized = 1 ? $TRAY_CHECKED : $TRAY_UNCHECKED))
EndFunc   ;==>chkHideWhenMinimized

Func chkScreenshotType()
	$iScreenshotType = (GUICtrlRead($g_hChkScreenshotType) = $GUI_CHECKED ? 1 : 0)
EndFunc   ;==>chkScreenshotType

Func chkScreenshotHideName()
	$ichkScreenshotHideName = (GUICtrlRead($g_hChkScreenshotHideName) = $GUI_CHECKED ? 1 : 0)
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
	$iChkAutoResume = (GUICtrlRead($g_hChkAutoResume) = $GUI_CHECKED ? 1 : 0)
EndFunc

Func chkDebugClick()
	$g_iDebugClick = (GUICtrlRead($g_hChkDebugClick) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugClick " & ($g_iDebugClick = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugClick

Func chkDebugSetlog()
	$g_iDebugSetlog = (GUICtrlRead($g_hChkDebugSetlog) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugSetlog " & ($g_iDebugSetlog = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugSetlog

Func chkDebugDisableZoomout()
	$g_iDebugDisableZoomout = (GUICtrlRead($g_hChkDebugDisableZoomout) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugDisableZoomout " & ($g_iDebugDisableZoomout = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugDisableZoomout

Func chkDebugDisableVillageCentering()
	$g_iDebugDisableVillageCentering = (GUICtrlRead($g_hChkDebugDisableVillageCentering) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugDisableVillageCentering " & ($g_iDebugDisableVillageCentering = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugDisableVillageCentering

Func chkDebugDeadbaseImage()
	$g_iDebugDeadBaseImage = (GUICtrlRead($g_hChkDebugDeadbaseImage) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugDeadbaseImage " & ($g_iDebugDeadBaseImage = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugDeadbaseImage

Func chkDebugOcr()
	$g_iDebugOcr = (GUICtrlRead($g_hChkDebugOCR) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugOcr " & ($g_iDebugOcr = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugOcr

Func chkDebugImageSave()
	$g_iDebugImageSave = (GUICtrlRead($g_hChkDebugImageSave) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugImageSave " & ($g_iDebugImageSave = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugImageSave

Func chkDebugBuildingPos()
	$g_iDebugBuildingPos = (GUICtrlRead($g_hChkdebugBuildingPos) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugBuildingPos " & ($g_iDebugBuildingPos = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugBuildingPos

Func chkDebugTrain()
	$g_iDebugSetlogTrain = (GUICtrlRead($g_hChkdebugTrain) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugTrain " & ($g_iDebugSetlogTrain = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugTrain

Func chkdebugOCRDonate()
	$g_iDebugOCRdonate = (GUICtrlRead($g_hChkDebugOCRDonate) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugOCRDonate " & ($g_iDebugOCRdonate = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkdebugOCRDonate

Func chkdebugAttackCSV()
	$g_iDebugAttackCSV = (GUICtrlRead($g_hChkdebugAttackCSV) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("DebugAttackCSV " & ($g_iDebugAttackCSV = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkdebugAttackCSV

Func chkmakeIMGCSV()
	$g_iDebugMakeIMGCSV = (GUICtrlRead($g_hChkMakeIMGCSV) = $GUI_CHECKED ? 1 : 0)
	SetDebugLog("MakeIMGCSV " & ($g_iDebugMakeIMGCSV = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkmakeIMGCSV

Func btnTestTrain()
	Local $currentOCR = $g_iDebugOcr
	Local $currentRunState = $g_bRunState
	#cs
	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	$g_iDebugOcr = 1
	$g_bRunState = True
	ForceCaptureRegion()
	DebugImageSave("train_")
	SetLog(_PadStringCenter(" Test Train begin (" & $g_sBotVersion & ")", 54, "="), $COLOR_INFO)
	getArmyTroopCount(False, False, True)
	getArmyHeroCount(False, False)
	SetLog(_PadStringCenter(" Test Train end ", 54, "="), $COLOR_INFO)
	Run("Explorer.exe " & $g_sLibPath & "\debug\ocr\")
	Run("Explorer.exe " & $g_sProfileTempDebugPath & "train_")
	#ce

	$g_bRunState = True
	BeginImageTest()

	Local $result
	SetLog("Testing checkArmyCamp()", $COLOR_INFO)
	$result = checkArmyCamp()
	If @error Then $result = "Error " & @error & ", " & @extended & ", " & ((IsArray($result)) ? (_ArrayToString($result, ",")) : ($result))
	SetLog("Result checkArmyCamp() = " & $result, $COLOR_INFO)

	SetLog("Testing getArmyHeroTime()", $COLOR_INFO)
	$result = getArmyHeroTime()
	If @error Then $result = "Error " & @error & ", " & @extended & ", " & ((IsArray($result)) ? (_ArrayToString($result, ",")) : ($result))
	SetLog("Result getArmyHeroTime() = " & $result, $COLOR_INFO)
	SetLog("Testing Train DONE" , $COLOR_INFO)

	EndImageTest()

	$g_iDebugOcr = $currentOCR
	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestTrain

Func btnTestDonateCC()
	Local $currentOCR = $g_iDebugOcr
	Local $currentRunState = $g_bRunState
	Local $currentSetlog = $g_iDebugSetlog
	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	$g_iDebugOcr = 1
	$g_bRunState = True
	$g_iDebugSetlog = 1
	ForceCaptureRegion()
	DebugImageSave("donateCC_")

	SetLog(_PadStringCenter(" Test DonateCC begin (" & $g_sBotVersion & ")", 54, "="), $COLOR_INFO)
	Local $DonationWindowY = 0
	Local $aDonWinOffColors[2][3] = [[0xFFFFFF, 0, 2], [0xc7c5bc, 0, 209]]
	Local $aDonationWindow = _MultiPixelSearch(409, 0, 410, $g_iDEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10)

	If IsArray($aDonationWindow) Then
		$DonationWindowY = $aDonationWindow[1]
		_Sleep(250)
		Setlog("$DonationWindowY: " & $DonationWindowY, $COLOR_DEBUG)
	Else
		SetLog("Could not find the Donate Window :(", $COLOR_ERROR)
		Return False
	EndIf
	Setlog("Detecting Troops...")
	DetectSlotTroop($eBowl)
	Setlog("Detecting Spells...")
	DetectSlotTroop($eSkSpell)
	SetLog(_PadStringCenter(" Test DonateCC end ", 54, "="), $COLOR_INFO)
	ShellExecute($g_sProfileTempDebugPath & "donateCC_")

	$g_iDebugOcr = $currentOCR
	$g_bRunState = $currentRunState
	$g_iDebugSetlog = $currentSetlog
EndFunc   ;==>btnTestDonateCC

Func btnTestRequestCC()
	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	$canRequestCC = True
	SetLog(_PadStringCenter(" Test RequestCC begin (" & $g_sBotVersion & ")", 54, "="), $COLOR_INFO)
	RequestCC()
	SetLog(_PadStringCenter(" Test RequestCC end ", 54, "="), $COLOR_INFO)
	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestRequestCC

Func btnTestAttackBar()
	Local $currentOCR = $g_iDebugOcr
	Local $currentRunState = $g_bRunState
	_GUICtrlTab_ClickTab($g_hTabMain, 0)

	$g_iDebugOcr = 1
	$g_bRunState = True
	ForceCaptureRegion()
	SetLog(_PadStringCenter(" Test Attack Bar begin (" & $g_sBotVersion & ")", 54, "="), $COLOR_INFO)

	_CaptureRegion2(0, 571 + $g_iBottomOffsetY, 859, 671 + $g_iBottomOffsetY)
	Local $result = DllCall($g_hLibFunctions, "str", "searchIdentifyTroop", "ptr", $hHBitmap2)
	Setlog("DLL Troopsbar list: " & $result[0], $COLOR_DEBUG)
	If $ichkFixClanCastle = 1 Then $result[0] = FixClanCastle($result[0])
	Local $aTroopDataList = StringSplit($result[0], "|")
	Local $aTemp[12][3]
	If $result[0] <> "" Then
		For $i = 1 To $aTroopDataList[0]
			Local $troopData = StringSplit($aTroopDataList[$i], "#", $STR_NOCOUNT)
;~ 				$aTemp[Number($troopData[1])][0] = $troopData[0]
;~ 				$aTemp[Number($troopData[1])][1] = Number($troopData[2])
;~ 				Setlog("-" & NameOfTroop( $aTemp[$i][0]) & " pos  " & $aTemp[$i][0] & " qty " & $aTemp[$i][2])
			If $troopData[0] = 17 Or $troopData[0] = 18 Or $troopData[0] = 19 Or $troopData[0] = 20 Then $troopData[2] = 1
			Setlog("position: " & $troopData[1] & " | troop code: " & $troopData[0] & " troop name:" & NameOfTroop($troopData[0]) & " | qty: " & $troopData[2])
		Next
	EndIf

	;make snapshot start
	_CaptureRegion(0, 630, $g_iDEFAULT_WIDTH)
	Local $savefolder = $g_sProfileTempDebugPath
	$savefolder = $g_sProfileTempDebugPath & "Test_Attack_Bar\"
	DirCreate($savefolder)
	Local $debugfile
	Local $Date = @MDAY & "." & @MON & "." & @YEAR
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	$debugfile = "Test_Attack_Bar_" & $g_sBotVersion & "_" & $Date & "_" & $Time & ".png"
	_GDIPlus_ImageSaveToFile($hBitmap, $savefolder & $debugfile)
	;make snapshot end

	SetLog(_PadStringCenter(" Test Attack Bar end ", 54, "="), $COLOR_INFO)
	ShellExecute($savefolder)

	$g_iDebugOcr = $currentOCR
	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestAttackBar


Func btnTestClickDrag()

	Local $i

	SetLog("Testing Click drag functionality...", $COLOR_INFO)
	For $i = 0 To 4
		SetLog("Click x1/y1=100/600 and drag to x2/y2=150/600", $COLOR_INFO)
		ClickDrag(100, 600, 150, 600)
	Next
	SetDebugLog("Waiting 3 Seconds...")
	_SleepStatus(3000, True, True, False)
	For $i = 0 To 4
		SetLog("Click x1/y1=150/600 and drag to x2/y2=100/600", $COLOR_INFO)
		ClickDrag(150, 600, 100, 600)
	Next

EndFunc   ;==>btnTestClickDrag

Func btnTestImage()

	Local $hBMP = 0, $hHBMP = 0
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", $g_sProfileTempPath, "Image (*.png)", $FD_FILEMUSTEXIST, "", $g_hFrmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $g_sAndroidEmulator, $COLOR_INFO)
		_CaptureRegion()
		$hHBMP = $hHBitmap
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

	Local $i
	Local $result
	Local $currentRunState = $g_bRunState
	$g_bRunState = True
	Local $Message

	For $i = 0 To 0

		SetLog("Testing image #" & $i & " " & $sImageFile, $COLOR_INFO)

		_CaptureRegion()

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

		SetLog("Testing checkAttackDisable...", $COLOR_SUCCESS)
		SetLog("Testing checkAttackDisable($iTaBChkAttack)...", $COLOR_SUCCESS)
		SetLog("checkAttackDisable($iTaBChkAttack) = " & checkAttackDisable($iTaBChkAttack))
		SetLog("Testing checkAttackDisable($iTaBChkIdle)...", $COLOR_SUCCESS)
		SetLog("checkAttackDisable($iTaBChkIdle) = " & checkAttackDisable($iTaBChkIdle))
		SetLog("Testing checkAttackDisable($iTaBChkTime)...", $COLOR_SUCCESS)
		SetLog("checkAttackDisable($iTaBChkTime) = " & checkAttackDisable($iTaBChkTime))
		SetLog("Testing checkAttackDisable DONE", $COLOR_SUCCESS)
	Next

	SetLog("Testing finished", $COLOR_INFO)

	_WinAPI_DeleteObject($hHBMP)
	TestCapture(0)

	$g_bRunState = $currentRunState

EndFunc   ;==>btnTestImage

Func btnTestVillageSize()

	BeginImageTest()
	Local $currentRunState = $g_bRunState
	$g_bRunState = True

	_CaptureRegion()
	_CaptureRegion2Sync()

	SetLog("Testing GetVillageSize()", $COLOR_INFO)
	Local $hTimer = TimerInit()
	Local $village = GetVillageSize()
	Local $ms = TimerDiff($hTimer)
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

	EndImageTest()

	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestVillageSize

Func btnTestDeadBase()
	Local $hBMP = 0, $hHBMP = 0
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", $g_sProfileTempPath, "Image (*.png)", $FD_FILEMUSTEXIST, "", $g_hFrmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $g_sAndroidEmulator, $COLOR_INFO)
		_CaptureRegion()
		$hHBMP = $hHBitmap
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
	SetLog("$IMGLOCREDLINE = " & $IMGLOCREDLINE, $COLOR_INFO)

	SetLog("Testing checkDeadBase()", $COLOR_INFO)
	SetLog("Result checkDeadBase() = " & checkDeadBase(), $COLOR_INFO)
	SetLog("Testing checkDeadBase() DONE", $COLOR_INFO)

	If $hHBMP <> 0 Then
		_WinAPI_DeleteObject($hHBMP)
		TestCapture(0)
	EndIf

	$g_bRunState = $currentRunState
EndFunc   ;==>btnTestDeadbase

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

EndFunc   ;==>btnTestDeadBase

Func btnTestAttackCSV()

	Local $hBMP = 0, $hHBMP = 0
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", @ScriptDir & "\Zombies", "Image (*.png)", $FD_FILEMUSTEXIST, "", $g_hFrmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $g_sAndroidEmulator, $COLOR_INFO)
		_CaptureRegion()
		$hHBMP = $hHBitmap
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
	Local $currentDebugAttackCSV = $g_iDebugAttackCSV
	Local $currentMakeIMGCSV = $g_iDebugMakeIMGCSV
	$g_bRunState = True
	$g_iDebugAttackCSV = 1
	$g_iDebugMakeIMGCSV = 1

	SearchZoomOut($aCenterEnemyVillageClickDrag, True, "btnTestAttackCSV")
	ResetTHsearch()
	SetLog("Testing FindTownhall()", $COLOR_INFO)
	SetLog("FindTownhall() = " & FindTownhall(True), $COLOR_INFO)
	SetLog("$IMGLOCREDLINE = " & $IMGLOCREDLINE, $COLOR_INFO)

	SetLog("Testing Algorithm_AttackCSV()", $COLOR_INFO)
	Algorithm_AttackCSV()
	SetLog("Testing Algorithm_AttackCSV() DONE", $COLOR_INFO)

	If $hHBMP <> 0 Then
		_WinAPI_DeleteObject($hHBMP)
		TestCapture(0)
	EndIf

	$g_bRunState = $currentRunState
	$g_iDebugAttackCSV = $currentDebugAttackCSV
	$g_iDebugMakeIMGCSV = $currentMakeIMGCSV

EndFunc

Func btnTestFindButton()
	BeginImageTest()
	Local $result
	Local $sButton = GUICtrlRead($g_hTxtTestFindButton)
	SetLog("Testing findButton(""" & $sButton & """)", $COLOR_INFO)
	$result = findButton($sButton)
	$result = ((IsArray($result)) ? (_ArrayToString($result, ",")) : ($result))
	If @error Then $result = "Error " & @error & ", " & @extended & ", "
	SetLog("Result findButton(""" & $sButton & """) = " & $result, $COLOR_INFO)
	SetLog("Testing findButton(""" & $sButton & """) DONE" , $COLOR_INFO)
	EndImageTest()
EndFunc

Func btnTestCleanYard()
	Local $currentRunState = $g_bRunState
	Local $iCurrFreeBuilderCount = $iFreeBuilderCount
	$iTestFreeBuilderCount = 5
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
	SetLog("Testing CleanYard DONE" , $COLOR_INFO)
	EndImageTest()
	; restore original state
	$iTestFreeBuilderCount = -1
	$iFreeBuilderCount = $iCurrFreeBuilderCount
	$g_bRunState = $currentRunState
EndFunc

Func BeginImageTest($directory = $g_sProfileTempPath)
	Local $hBMP = 0, $hHBMP = 0
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", $directory, "Image (*.png)", $FD_FILEMUSTEXIST, "", $g_hFrmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $g_sAndroidEmulator, $COLOR_INFO)
		ZoomOut()
		_CaptureRegion()
		$hHBMP = $hHBitmap
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
	Return True
EndFunc

Func EndImageTest()
	TestCapture(0)
EndFunc

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
				Setlog("Clan castle Forced in slot " & $counter, $COLOR_INFO)
			EndIf
			$counter += 1
			$OutputFinal &= $troopData[0] & "#" & $troopData[1] & "#" & $troopData[2]
		Next
	EndIf
	Return $OutputFinal

EndFunc   ;==>FixClanCastle
