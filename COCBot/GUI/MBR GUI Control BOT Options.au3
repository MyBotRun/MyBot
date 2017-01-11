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
	_GUICtrlComboBox_ResetContent($cmbLanguage)

	;set combo box
	_GUICtrlComboBoxEx_SetImageList($cmbLanguage, $hLangIcons)
	For $i = 0 to UBound($aLanguageFile) - 1
		If $aLanguageFile[$i][2] <> -1 Then
			_GUICtrlComboBoxEx_AddString($cmbLanguage, $aLanguageFile[$i][1], $aLanguageFile[$i][2], $aLanguageFile[$i][2])
		Else
			_GUICtrlComboBoxEx_AddString($cmbLanguage, $aLanguageFile[$i][1], $eMissingLangIcon, $eMissingLangIcon)
		EndIf
	Next
_GUICtrlComboBox_SetCurSel($cmbLanguage, _GUICtrlComboBox_FindStringExact($cmbLanguage, $aLanguageFile[_ArraySearch($aLanguageFile, $sLanguage)][1]))
EndFunc   ;==>LoadLanguagesComboBox

Func cmbLanguage()
	Local $aLanguage = _GUICtrlComboBox_GetListArray($cmbLanguage)
	Local $sLanguageIndex = _ArraySearch($aLanguageFile, $aLanguage[_GUICtrlComboBox_GetCurSel($cmbLanguage) + 1])

	$sLanguage = $aLanguageFile[$sLanguageIndex][0] ; the filename = 0, the display name = 1
	MsgBox("", "", GetTranslated(636, 71, "Restart Bot to load program with new language:") & " " & $aLanguageFile[$sLanguageIndex][1] & " (" & $sLanguage & ")")
EndFunc   ;==>cmbLanguage

Func chkUseRandomClick()
	If GUICtrlRead($chkUseRandomClick) = $GUI_CHECKED Then
		$iUseRandomClick = 1
	Else
		$iUseRandomClick = 0
	EndIf
EndFunc   ;==>chkUseRandomClick

;~ Func chkAddIdleTime()
;~ 	If GUICtrlRead($chkAddIdleTime) = $GUI_CHECKED Then
;~ 		$ichkAddIdleTime = 1
;~ 	Else
;~ 		$ichkAddIdleTime = 0
;~ 	EndIf
;~ EndFunc   ;==>chkAddIdleTime

Func chkUpdatingWhenMinimized()
	$iUpdatingWhenMinimized = (GUICtrlRead($chkUpdatingWhenMinimized) = $GUI_CHECKED ? 1 : 0)
EndFunc   ;==>chkUpdatingWhenMinimized

Func chkHideWhenMinimized()
	$iHideWhenMinimized = (GUICtrlRead($chkHideWhenMinimized) = $GUI_CHECKED ? 1 : 0)
	TrayItemSetState($tiHide, ($iHideWhenMinimized = 1 ? $TRAY_CHECKED : $TRAY_UNCHECKED))
EndFunc   ;==>chkHideWhenMinimized

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
			GUICtrlSetBkColor($txtSinglePBTimeForced, $COLOR_ERROR)
		Case 16
			GUICtrlSetBkColor($txtSinglePBTimeForced, $COLOR_YELLOW)
		Case 17 To 999
			GUICtrlSetBkColor($txtSinglePBTimeForced, $COLOR_MONEYGREEN)
	EndSwitch
	Switch Int(GUICtrlRead($txtPBTimeForcedExit))
		Case 0 To 11
			GUICtrlSetBkColor($txtPBTimeForcedExit, $COLOR_ERROR)
		Case 12 To 14
			GUICtrlSetBkColor($txtPBTimeForcedExit, $COLOR_YELLOW)
		Case 15 To 999
			GUICtrlSetBkColor($txtPBTimeForcedExit, $COLOR_MONEYGREEN)
	EndSwitch
EndFunc   ;==>txtSinglePBTimeForced

Func chkDebugClick()
	If GUICtrlRead($chkDebugClick) = $GUI_CHECKED Then
		$debugClick = 1
	Else
		$debugClick = 0
	EndIf
	SetDebugLog("DebugClick " & ($debugClick = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugClick

Func chkDebugSetlog()
	If GUICtrlRead($chkDebugSetlog) = $GUI_CHECKED Then
		$DebugSetlog = 1
	Else
		$DebugSetlog = 0
	EndIf
	SetDebugLog("DebugSetlog " & ($DebugSetlog = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugSetlog

Func chkDebugDisableZoomout()
	If GUICtrlRead($chkDebugDisableZoomout) = $GUI_CHECKED Then
		$debugDisableZoomout = 1
	Else
		$debugDisableZoomout = 0
	EndIf
	SetDebugLog("DebugDisableZoomout " & ($debugDisableZoomout = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugDisableZoomout

Func chkDebugDisableVillageCentering()
	If GUICtrlRead($chkDebugDisableVillageCentering) = $GUI_CHECKED Then
		$debugDisableVillageCentering = 1
	Else
		$debugDisableVillageCentering = 0
	EndIf
	SetDebugLog("DebugDisableVillageCentering " & ($debugDisableVillageCentering = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugDisableVillageCentering

Func chkDebugDeadbaseImage()
	If GUICtrlRead($chkDebugDeadbaseImage) = $GUI_CHECKED Then
		$debugDeadbaseImage = 1
	Else
		$debugDeadbaseImage = 0
	EndIf
	SetDebugLog("DebugDeadbaseImage " & ($debugDeadbaseImage = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugDeadbaseImage

Func chkDebugOcr()
	If GUICtrlRead($chkDebugOcr) = $GUI_CHECKED Then
		$debugOcr = 1
	Else
		$debugOcr = 0
	EndIf
	SetDebugLog("DebugOcr " & ($debugOcr = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugOcr

Func chkDebugImageSave()
	If GUICtrlRead($chkDebugImageSave) = $GUI_CHECKED Then
		$DebugImageSave = 1
	Else
		$DebugImageSave = 0
	EndIf
	SetDebugLog("DebugImageSave " & ($DebugImageSave = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugImageSave

Func chkDebugBuildingPos()
	If GUICtrlRead($chkdebugBuildingPos) = $GUI_CHECKED Then
		$debugBuildingPos = 1
	Else
		$debugBuildingPos = 0
	EndIf
	SetDebugLog("DebugBuildingPos " & ($debugBuildingPos = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugBuildingPos

Func chkDebugTrain()
	If GUICtrlRead($chkdebugTrain) = $GUI_CHECKED Then
		$debugsetlogTrain = 1
	Else
		$debugsetlogTrain = 0
	EndIf
	SetDebugLog("DebugTrain " & ($debugsetlogTrain = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkDebugTrain

Func chkdebugOCRDonate()
	If GUICtrlRead($chkdebugOCRDonate) = $GUI_CHECKED Then
		$debugOCRdonate = 1
	Else
		$debugOCRdonate = 0
	EndIf
	SetDebugLog("DebugOCRDonate " & ($debugOCRdonate = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkdebugOCRDonate

Func chkdebugAttackCSV()
	If GUICtrlRead($chkdebugAttackCSV) = $GUI_CHECKED Then
		$debugAttackCSV = 1
	Else
		$debugAttackCSV = 0
	EndIf
	SetDebugLog("DebugAttackCSV " & ($debugAttackCSV = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkdebugAttackCSV

Func chkmakeIMGCSV()
	If GUICtrlRead($chkmakeIMGCSV) = $GUI_CHECKED Then
		$makeIMGCSV = 1
	Else
		$makeIMGCSV = 0
	EndIf
	SetDebugLog("MakeIMGCSV " & ($makeIMGCSV = 1 ? "enabled" : "disabled"))
EndFunc   ;==>chkmakeIMGCSV

Func btnTestTrain()
	Local $currentOCR = $debugOcr
	Local $currentRunState = $RunState
	#cs
	_GUICtrlTab_ClickTab($tabMain, 0)
	$debugOcr = 1
	$RunState = True
	ForceCaptureRegion()
	DebugImageSave("train_")
	SetLog(_PadStringCenter(" Test Train begin (" & $sBotVersion & ")", 54, "="), $COLOR_INFO)
	getArmyTroopCount(False, False, True)
	getArmySpellCount(False, False, True)
	getArmyHeroCount(False, False)
	SetLog(_PadStringCenter(" Test Train end ", 54, "="), $COLOR_INFO)
	Run("Explorer.exe " & $LibDir & "\debug\ocr\")
	Run("Explorer.exe " & $dirTempDebug & "train_")
	#ce

	$RunState = True
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

	$debugOcr = $currentOCR
	$RunState = $currentRunState
EndFunc   ;==>btnTestTrain

Func btnTestDonateCC()
	Local $currentOCR = $debugOcr
	Local $currentRunState = $RunState
	Local $currentSetlog = $DebugSetlog
	_GUICtrlTab_ClickTab($tabMain, 0)
	$debugOcr = 1
	$RunState = True
	$DebugSetlog = 1
	ForceCaptureRegion()
	;DebugImageSave("donateCC_")

	SetLog(_PadStringCenter(" Test DonateCC begin (" & $sBotVersion & ")", 54, "="), $COLOR_INFO)
	$DonationWindowY = 0
	Local $aDonWinOffColors[2][3] = [[0xFFFFFF, 0, 2], [0xc7c5bc, 0, 209]]
	Local $aDonationWindow = _MultiPixelSearch(409, 0, 410, $DEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10)

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
	Run("Explorer.exe " & $LibDir & "\debug\ocr\")

	$debugOcr = $currentOCR
	$RunState = $currentRunState
	$DebugSetlog = $currentSetlog
EndFunc   ;==>btnTestDonateCC

Func btnTestRequestCC()
	Local $currentRunState = $RunState
	$RunState = True
	$canRequestCC = True
	SetLog(_PadStringCenter(" Test RequestCC begin (" & $sBotVersion & ")", 54, "="), $COLOR_INFO)
	RequestCC()
	SetLog(_PadStringCenter(" Test RequestCC end ", 54, "="), $COLOR_INFO)
	$RunState = $currentRunState
EndFunc   ;==>btnTestRequestCC

Func btnTestAttackBar()
	Local $currentOCR = $debugOcr
	Local $currentRunState = $RunState
	_GUICtrlTab_ClickTab($tabMain, 0)

	$debugOcr = 1
	$RunState = True
	ForceCaptureRegion()
	SetLog(_PadStringCenter(" Test Attack Bar begin (" & $sBotVersion & ")", 54, "="), $COLOR_INFO)

	$DonationWindowY = 0

	_CaptureRegion2(0, 571 + $bottomOffsetY, 859, 671 + $bottomOffsetY)
	Local $result = DllCall($hFuncLib, "str", "searchIdentifyTroop", "ptr", $hHBitmap2)
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
	_CaptureRegion(0, 630, $DEFAULT_WIDTH)
	Local $savefolder = $dirTempDebug
	$savefolder = $dirTempDebug & "Test_Attack_Bar\"
	DirCreate($savefolder)
	Local $debugfile
	$Date = @MDAY & "." & @MON & "." & @YEAR
	$Time = @HOUR & "." & @MIN & "." & @SEC
	$debugfile = "Test_Attack_Bar_" & $sBotVersion & "_" & $Date & "_" & $Time & ".png"
	_GDIPlus_ImageSaveToFile($hBitmap, $savefolder & $debugfile)
	;make snapshot end

	SetLog(_PadStringCenter(" Test Attack Bar end ", 54, "="), $COLOR_INFO)
	Run("Explorer.exe " & $savefolder)

	$debugOcr = $currentOCR
	$RunState = $currentRunState
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
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", $dirTemp, "Image (*.png)", $FD_FILEMUSTEXIST, "", $frmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $Android, $COLOR_INFO)
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
	Local $currentRunState = $RunState
	$RunState = True
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
		SetLog("$aNoCloudsAttack pixel check: " & _CheckPixel($aNoCloudsAttack, $bCapturePixel))
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

	$RunState = $currentRunState

EndFunc   ;==>btnTestImage

Func btnTestVillageSize()
	Local $hBMP = 0, $hHBMP = 0
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", $dirTemp, "Image (*.png)", $FD_FILEMUSTEXIST, "", $frmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $Android, $COLOR_INFO)
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

	Local $currentRunState = $RunState
	$RunState = True

	_CaptureRegion()

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

	If $hHBMP <> 0 Then
		_WinAPI_DeleteObject($hHBMP)
		TestCapture(0)
	EndIf

	$RunState = $currentRunState
EndFunc   ;==>btnTestVillageSize

#cs
Func btnTestDeadBase()
	Local $test = 0
	LoadTHImage()
	LoadElixirImage()
	LoadElixirImage75Percent()
	LoadElixirImage50Percent()
	Zoomout()
	If $debugBuildingPos = 0 Then
		$test = 1
		$debugBuildingPos = 1
	EndIf
	SETLOG("DEADBASE CHECK..................")
	$dbBase = checkDeadBase()
	SETLOG("TOWNHALL CHECK. imgloc.................")
	$searchTH = imgloccheckTownhallADV2()
	If $test = 1 Then $debugBuildingPos = 0
EndFunc   ;==>btnTestDeadBase
#ce

Func btnTestDeadBase()
	Local $hBMP = 0, $hHBMP = 0
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", $dirTemp, "Image (*.png)", $FD_FILEMUSTEXIST, "", $frmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $Android, $COLOR_INFO)
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

	Local $currentRunState = $RunState
	$RunState = True

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

	$RunState = $currentRunState
EndFunc   ;==>btnTestDeadbase

Func btnTestDeadBaseFolder()

	;Local $directory = FileOpenDialog("Select folder of CoC village screenshot to test for dead base", $dirTemp, "Image (*.png)", $FD_PATHMUSTEXIST, "", $frmBot)
	Local $directory = FileSelectFolder("Select folder of CoC village screenshot to test for dead base", "", $FSF_NEWDIALOG, @ScriptDir, $frmBot)
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
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", @ScriptDir & "\Zombies", "Image (*.png)", $FD_FILEMUSTEXIST, "", $frmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $Android, $COLOR_INFO)
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

	Local $currentRunState = $RunState
	Local $currentDebugAttackCSV = $debugAttackCSV
	Local $currentMakeIMGCSV = $makeIMGCSV
	$RunState = True
	$debugAttackCSV = 1
	$makeIMGCSV = 1

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

	$RunState = $currentRunState
	$debugAttackCSV = $currentDebugAttackCSV
	$makeIMGCSV = $currentMakeIMGCSV

EndFunc

Func btnTestFindButton()
	BeginImageTest()
	Local $result
	Local $sButton = GUICtrlRead($txtTestFindButton)
	SetLog("Testing findButton(""" & $sButton & """)", $COLOR_INFO)
	$result = findButton($sButton)
	$result = ((IsArray($result)) ? (_ArrayToString($result, ",")) : ($result))
	If @error Then $result = "Error " & @error & ", " & @extended & ", "
	SetLog("Result findButton(""" & $sButton & """) = " & $result, $COLOR_INFO)
	SetLog("Testing findButton(""" & $sButton & """) DONE" , $COLOR_INFO)
	EndImageTest()
EndFunc

Func btnTestCleanYard()
	Local $currentRunState = $RunState
	Local $iCurrFreeBuilderCount = $iFreeBuilderCount
	$iTestFreeBuilderCount = 5
	$RunState = True
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
	$RunState = $currentRunState
EndFunc

Func BeginImageTest($directory = $dirTemp)
	Local $hBMP = 0, $hHBMP = 0
	Local $sImageFile = FileOpenDialog("Select CoC screenshot to test, cancel to use live screenshot", $directory, "Image (*.png)", $FD_FILEMUSTEXIST, "", $frmBot)
	If @error <> 0 Then
		SetLog("Testing image cancelled, taking screenshot from " & $Android, $COLOR_INFO)
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
