; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func cmbProfile()
	saveConfig()

	FileClose($hLogFileHandle)
	FileClose($hAttackLogFileHandle)

	; Setup the profile in case it doesn't exist.
	setupProfile()

	readConfig()
	applyConfig()
	saveConfig()

	SetLog(_PadStringCenter("Profile " & $sCurrProfile & " loaded from " & $config, 50, "="), $COLOR_GREEN)
EndFunc   ;==>cmbProfile

#cs No longer Needed
Func txtVillageName()
	$iVillageName = GUICtrlRead($txtVillageName)
	If $iVillageName = "" Then $iVillageName = "MyVillage"
	GUICtrlSetData($grpVillage, GetTranslated(13, 21, "Village") & ": " & $iVillageName)
	GUICtrlSetData($OrigPushB, $iVillageName)
	GUICtrlSetData($txtVillageName, $iVillageName)
EndFunc   ;==>txtVillageName
#ce

Func btnAddConfirm()
	Switch @GUI_CtrlId
		Case $btnAdd
			GUICtrlSetState($cmbProfile, $GUI_HIDE)
			GUICtrlSetState($txtVillageName, $GUI_SHOW)
			GUICtrlSetState($btnAdd, $GUI_HIDE)
			GUICtrlSetState($btnConfirmAdd, $GUI_SHOW)
			GUICtrlSetState($btnDelete, $GUI_HIDE)
			GUICtrlSetState($btnCancel, $GUI_SHOW)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_HIDE)
		Case $btnConfirmAdd
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($txtVillageName), '[/:*?"<>|]', '_')
			If FileExists($sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslated(7,108, "Profile Already Exists"), $newProfileName & " " & GetTranslated(7,109, "already exists.") & @CRLF & GetTranslated(7,110, "Please choose another name for your profile"))
				Return
			EndIf

			$sCurrProfile = $newProfileName
			; Setup the profile if it doesn't exist.
			createProfile()
			setupProfileComboBox()
			selectProfile()
			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetState($btnAdd, $GUI_SHOW)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_SHOW)
			GUICtrlSetState($btnCancel, $GUI_HIDE)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_SHOW)

			If GUICtrlGetState($btnDelete) <> $GUI_ENABLE Then GUICtrlSetState($btnDelete, $GUI_ENABLE)
			If GUICtrlGetState($btnRename) <> $GUI_ENABLE Then GUICtrlSetState($btnRename, $GUI_ENABLE)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_RED)
	EndSwitch
EndFunc   ;==>btnAddConfirm

Func btnDeleteCancel()
	Switch @GUI_CtrlId
		Case $btnDelete
			Local $msgboxAnswer = MsgBox($MB_ICONWARNING + $MB_OKCANCEL, GetTranslated(7,111, "Delete Profile"), GetTranslated(7,112, "Are you sure you really want to delete the profile?") & @CRLF & GetTranslated(7,113, "This action can not be undone."))
			If $msgboxAnswer = $IDOK Then
				; Confirmed profile deletion so delete it.
				deleteProfile()
				setupProfileComboBox()
				selectProfile()
			EndIf
		Case $btnCancel
			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnAdd, $GUI_SHOW)
			GUICtrlSetState($btnCancel, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_SHOW)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_SHOW)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_RED)
	EndSwitch

	If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
		GUICtrlSetState($btnDelete, $GUI_DISABLE)
		GUICtrlSetState($btnRename, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnDeleteCancel

Func btnRenameConfirm()
	Switch @GUI_CtrlId
		Case $btnRename
			GUICtrlSetData($txtVillageName, GUICtrlRead($cmbProfile))
			GUICtrlSetState($cmbProfile, $GUI_HIDE)
			GUICtrlSetState($txtVillageName, $GUI_SHOW)
			GUICtrlSetState($btnAdd, $GUI_HIDE)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_HIDE)
			GUICtrlSetState($btnCancel, $GUI_SHOW)
			GUICtrlSetState($btnRename, $GUI_HIDE)
			GUICtrlSetState($btnConfirmRename, $GUI_SHOW)
		Case $btnConfirmRename
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($txtVillageName), '[/:*?"<>|]', '_')
			If FileExists($sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslated(7,108, "Profile Already Exists"), $newProfileName & " " & GetTranslated(7,109, "already exists.") & @CRLF & GetTranslated(7,110, "Please choose another name for your profile"))
				Return
			EndIf

			$sCurrProfile = $newProfileName
			; Rename the profile.
			renameProfile()
			setupProfileComboBox()
			selectProfile()

			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnAdd, $GUI_SHOW)
			GUICtrlSetState($btnCancel, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_SHOW)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_SHOW)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_RED)
	EndSwitch
EndFunc   ;==>btnRenameConfirm

Func btnLocateBarracks()
	$RunState = True
	While 1
		ZoomOut()
		LocateBarrack()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateBarracks

Func btnLocateArmyCamp()
	$RunState = True
	While 1
		ZoomOut()
		LocateBarrack(True)
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateArmyCamp

Func btnLocateClanCastle()
	$RunState = True
	While 1
		ZoomOut()
		LocateClanCastle()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateClanCastle

Func btnLocateSpellfactory()
	$RunState = True
	While 1
		ZoomOut()
		LocateSpellFactory()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateSpellfactory

Func btnLocateDarkSpellfactory()
	$RunState = True
	While 1
		ZoomOut()
		LocateDarkSpellFactory()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateDarkSpellfactory

Func btnLocateKingAltar()
	$RunState = True
	While 1
		ZoomOut()
		LocateKingAltar()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateKingAltar


Func btnLocateQueenAltar()
	$RunState = True
	While 1
		ZoomOut()
		LocateQueenAltar()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateQueenAltar

Func btnLocateWardenAltar()
	$RunState = True
	While 1
		ZoomOut()
		LocateWardenAltar()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateWardenAltar

Func btnLocateTownHall()
	$RunState = True
	While 1
		ZoomOut()
		LocateTownHall()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateTownHall

Func chkBotStop()
	If GUICtrlRead($chkBotStop) = $GUI_CHECKED Then
		GUICtrlSetState($cmbBotCommand, $GUI_ENABLE)
		GUICtrlSetState($cmbBotCond, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbBotCommand, $GUI_DISABLE)
		GUICtrlSetState($cmbBotCond, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBotStop

Func cmbBotCond()
	If _GUICtrlComboBox_GetCurSel($cmbBotCond) = 15 Then
		If _GUICtrlComboBox_GetCurSel($cmbHoursStop) = 0 Then _GUICtrlComboBox_SetCurSel($cmbHoursStop, 1)
		GUICtrlSetState($cmbHoursStop, $GUI_ENABLE)
	Else
		_GUICtrlComboBox_SetCurSel($cmbHoursStop, 0)
		GUICtrlSetState($cmbHoursStop, $GUI_DISABLE)
	EndIf
EndFunc   ;==>cmbBotCond

Func chkTrap()
	If GUICtrlRead($chkTrap) = $GUI_CHECKED Then
		$ichkTrap = 1
		;GUICtrlSetState($btnLocateTownHall, $GUI_SHOW)
	Else
		$ichkTrap = 0
		;GUICtrlSetState($btnLocateTownHall, $GUI_HIDE)
	EndIf
EndFunc   ;==>chkTrap

Func chkTrophyAtkDead()
	If GUICtrlRead($chkTrophyAtkDead) = $GUI_CHECKED Then
		$ichkTrophyAtkDead = 1
		GUICtrlSetState($txtDTArmyMin, $GUI_ENABLE)
	Else
		$ichkTrophyAtkDead = 0
		GUICtrlSetState($txtDTArmyMin, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyAtkDead


Func sldVSDelay()
	$iVSDelay = GUICtrlRead($sldVSDelay)
	GUICtrlSetData($lblVSDelay, $iVSDelay)
	If $iVSDelay > $iMaxVSDelay Then
		GUICtrlSetData($lblMaxVSDelay, $iVSDelay)
		GUICtrlSetData($sldMaxVSDelay, $iVSDelay)
		$iMaxVSDelay = $iVSDelay
	EndIf
	If $iVSDelay = 1 Then
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(7, 99, "second"))
	Else
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(7, 63, "seconds"))
	EndIf
	If $iMaxVSDelay = 1 Then
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(7, 99, "second"))
	Else
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(7, 63, "seconds"))
	EndIf
EndFunc   ;==>sldVSDelay

Func sldMaxVSDelay()
	$iMaxVSDelay = GUICtrlRead($sldMaxVSDelay)
	GUICtrlSetData($lblMaxVSDelay, $iMaxVSDelay)
	If $iMaxVSDelay < $iVSDelay Then
		GUICtrlSetData($lblVSDelay, $iMaxVSDelay)
		GUICtrlSetData($sldVSDelay, $iMaxVSDelay)
		$iVSDelay = $iMaxVSDelay
	EndIf
	If $iVSDelay = 1 Then
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(7, 99, "second"))
	Else
		GUICtrlSetData($lbltxtVSDelay, GetTranslated(7, 63, "seconds"))
	EndIf
	If $iMaxVSDelay = 1 Then
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(7, 99, "second"))
	Else
		GUICtrlSetData($lbltxtMaxVSDelay, GetTranslated(7, 63, "seconds"))
	EndIf
EndFunc   ;==>sldMaxVSDelay


Func btnLab()
	$RunState = True
	While 1
		ZoomOut()
		LocateLab()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLab

Func btnResetBuilding()
	$RunState = True
	While 1
		If _Sleep(500) Then Return ; add small delay before display message window
		If FileExists($building) Then ; Check for building.ini file first
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
			Local $stext = @CRLF & "Click OK to Delete and Reset all Building info," & @CRLF & @CRLF & _
					"NOTE =>> Bot will exit and need to be restarted when complete" & @CRLF & @CRLF & "Or Click Cancel to exit" & @CRLF
			Local $MsgBox = _ExtMsgBox(0, "Ok To Delete & Exit|Cancel and Return", "Delete Building Infomation?", $stext, 120, $frmBot)
			If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_PURPLE)
			If $MsgBox = 1 Then
				Local $stext = @CRLF & "Are you 100% sure you want to delete Building information?" & @CRLF & @CRLF & _
						"Click OK to Delete and then restart the bot (manually)" & @CRLF & @CRLF & "Or Click Cancel to exit" & @CRLF
				Local $MsgBox = _ExtMsgBox(0, "Ok To Delete & Exit|Cancel and Return", "Really Delete Building Infomation?", $stext, 120, $frmBot)
				If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_PURPLE)
				If $MsgBox = 1 Then
					Local $Result = FileDelete($building)
					If $Result = 0 Then
						Setlog("Unable to remove building.ini file, please use manual method", $COLOR_RED)
					Else
						; File Deleted close the bot with taskkill so it does not save a new one
						Local $BotProcess = WinGetProcess($frmBot)
						If $DebugSetlog = 1 Then Setlog("$BotProcess= " & $BotProcess, $COLOR_PURPLE)
						ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -PID " & $BotProcess, "", Default, @SW_HIDE)
						Setlog("Error removing building.ini, please use manual method", $COLOR_RED)
					EndIf
				EndIf
			EndIf
		Else
			Setlog("Building.ini file does not exist", $COLOR_BLUE)
		EndIf
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnResetBuilding

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
	MsgBox("", "", "Restart Bot to load program with new language: " & $aLanguageFile[$sLanguageIndex][1] & " (" & $sLanguage & ")")
EndFunc   ;==>cmbLanguage
