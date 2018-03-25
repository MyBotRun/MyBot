; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Misc
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func cmbProfile()
	If LoadProfile() Then
		Return True
	EndIf
	; restore combo to current profile
	_GUICtrlComboBox_SelectString($g_hCmbProfile, $g_sProfileCurrentName)
	Return False
EndFunc   ;==>cmbProfile

Func LoadProfile($bSaveCurrentProfile = True)
	If $bSaveCurrentProfile Then
		saveConfig()
	EndIf

	; Setup the profile in case it doesn't exist.
	If setupProfile() Then
		readConfig()
		applyConfig()
		saveConfig()
		SetLog("Profile " & $g_sProfileCurrentName & " loaded from " & $g_sProfileConfigPath, $COLOR_SUCCESS)
		Return True
	EndIf
	Return False
EndFunc   ;==>LoadProfile

Func btnAddConfirm()
	Switch @GUI_CtrlId
		Case $g_hBtnAddProfile
			GUICtrlSetState($g_hCmbProfile, $GUI_HIDE)
			GUICtrlSetState($g_hTxtVillageName, $GUI_SHOW)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_HIDE)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_HIDE)
		Case $g_hBtnConfirmAddProfile
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($g_hTxtVillageName), '[/:*?"<>|]', '_')
			If FileExists($g_sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_01", "Profile Already Exists"), GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_02", "%s already exists.\r\nPlease choose another name for your profile.", $newProfileName))
				Return
			EndIf

			saveConfig() ; save current config so we don't miss anything recently changed

			$g_sProfileCurrentName = $newProfileName
			; Setup the profile if it doesn't exist.
			createProfile()
			setupProfileComboBox()
			selectProfile()
			GUICtrlSetState($g_hTxtVillageName, $GUI_HIDE)
			GUICtrlSetState($g_hCmbProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_HIDE)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_SHOW)

			If GUICtrlGetState($g_hBtnDeleteProfile) <> $GUI_ENABLE Then GUICtrlSetState($g_hBtnDeleteProfile, $GUI_ENABLE)
			If GUICtrlGetState($g_hBtnRenameProfile) <> $GUI_ENABLE Then GUICtrlSetState($g_hBtnRenameProfile, $GUI_ENABLE)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch
EndFunc   ;==>btnAddConfirm

Func btnDeleteCancel()
	Switch @GUI_CtrlId
		Case $g_hBtnDeleteProfile
			Local $msgboxAnswer = MsgBox($MB_ICONWARNING + $MB_OKCANCEL, GetTranslatedFileIni("MBR Popups", "Delete_Profile_01", "Delete Profile"), GetTranslatedFileIni("MBR Popups", "Delete_Profile_02", "Are you sure you really want to delete the profile?\r\nThis action can not be undone."))
			If $msgboxAnswer = $IDOK Then
				; Confirmed profile deletion so delete it.
				If deleteProfile() Then
					; reset inputtext
					GUICtrlSetData($g_hTxtVillageName, GetTranslatedFileIni("MBR Popups", "MyVillage", "MyVillage"))
					If _GUICtrlComboBox_GetCount($g_hCmbProfile) > 1 Then
						; select existing profile
						setupProfileComboBox()
						selectProfile()
					Else
						; create new default profile
						createProfile(True)
					EndIf
				EndIf
			EndIf
		Case $g_hBtnCancelProfileChange
			GUICtrlSetState($g_hTxtVillageName, $GUI_HIDE)
			GUICtrlSetState($g_hCmbProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_HIDE)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_SHOW)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch

	If GUICtrlRead($g_hCmbProfile) = "<No Profiles>" Then
		GUICtrlSetState($g_hBtnDeleteProfile, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnRenameProfile, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnDeleteCancel

Func btnRenameConfirm()
	Switch @GUI_CtrlId
		Case $g_hBtnRenameProfile
			Local $sProfile = GUICtrlRead($g_hCmbProfile)
			If aquireProfileMutex($sProfile, False, True) = 0 Then
				Return
			EndIf
			GUICtrlSetData($g_hTxtVillageName, $sProfile)
			GUICtrlSetState($g_hCmbProfile, $GUI_HIDE)
			GUICtrlSetState($g_hTxtVillageName, $GUI_SHOW)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_SHOW)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_HIDE)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_HIDE)
		Case $g_hBtnConfirmRenameProfile
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($g_hTxtVillageName), '[/:*?"<>|]', '_')
			If FileExists($g_sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_01", "Profile Already Exists"), $newProfileName & " " & GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_03", "already exists.") & @CRLF & GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_04", "Please choose another name for your profile"))
				Return
			EndIf

			$g_sProfileCurrentName = $newProfileName
			; Rename the profile.
			renameProfile()
			setupProfileComboBox()
			selectProfile()

			GUICtrlSetState($g_hTxtVillageName, $GUI_HIDE)
			GUICtrlSetState($g_hCmbProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_HIDE)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_SHOW)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch
EndFunc   ;==>btnRenameConfirm

Func btnPullSharedPrefs()
	PullSharedPrefs()
EndFunc

Func btnPushSharedPrefs()
	PushSharedPrefs()
EndFunc

Func cmbBotCond()
	If _GUICtrlComboBox_GetCurSel($g_hCmbBotCond) = 15 Then
		If _GUICtrlComboBox_GetCurSel($g_hCmbHoursStop) = 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbHoursStop, 1)
		GUICtrlSetState($g_hCmbHoursStop, $GUI_ENABLE)
	Else
		_GUICtrlComboBox_SetCurSel($g_hCmbHoursStop, 0)
		GUICtrlSetState($g_hCmbHoursStop, $GUI_DISABLE)
	EndIf
EndFunc   ;==>cmbBotCond

Func chkBotStop()
	If GUICtrlRead($g_hChkBotStop) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbBotCommand, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbBotCond, $GUI_ENABLE)
		_GUI_Value_STATE("ENABLE", $g_hTxtRestartGold & "#" & $g_hTxtRestartElixir & "#" & $g_hTxtRestartDark)
	Else
		GUICtrlSetState($g_hCmbBotCommand, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbBotCond, $GUI_DISABLE)
		_GUI_Value_STATE("DISABLE", $g_hTxtRestartGold & "#" & $g_hTxtRestartElixir & "#" & $g_hTxtRestartDark)
	EndIf
EndFunc   ;==>chkBotStop

;~ Func btnLocateBarracks()
;~ 	Local $wasRunState = $g_bRunState
;~ 	$g_bRunState = True
;~ 	ZoomOut()
;~ 	;LocateOneBarrack()
;~ 	$g_bRunState = $wasRunState
;~ 	AndroidShield("btnLocateBarracks") ; Update shield status due to manual $g_bRunState
;~ EndFunc   ;==>btnLocateBarracks

;~ Func btnLocateArmyCamp()
;~ 	Local $wasRunState = $g_bRunState
;~ 	$g_bRunState = True
;~ 	ZoomOut()
;~ 	;LocateBarrack(True)
;~ 	$g_bRunState = $wasRunState
;~ 	AndroidShield("btnLocateArmyCamp") ; Update shield status due to manual $g_bRunState
;~ EndFunc   ;==>btnLocateArmyCamp

Func btnLocateClanCastle()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateClanCastle()
	$g_bRunState = $wasRunState
	AndroidShield("btnLocateClanCastle") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLocateClanCastle

;~ Func btnLocateSpellfactory()
;~ 	Local $wasRunState = $g_bRunState
;~ 	$g_bRunState = True
;~ 	ZoomOut()
;~ 	LocateSpellFactory()
;~ 	$g_bRunState = $wasRunState
;~ 	AndroidShield("btnLocateSpellfactory") ; Update shield status due to manual $g_bRunState
;~ EndFunc   ;==>btnLocateSpellfactory

;~ Func btnLocateDarkSpellfactory()
;~ 	Local $wasRunState = $g_bRunState
;~ 	$g_bRunState = True
;~ 	ZoomOut()
;~ 	LocateDarkSpellFactory()
;~ 	$g_bRunState = $wasRunState
;~ 	AndroidShield("btnLocateDarkSpellfactory") ; Update shield status due to manual $g_bRunState
;~ EndFunc   ;==>btnLocateDarkSpellfactory

Func btnLocateKingAltar()
	LocateKingAltar()
EndFunc   ;==>btnLocateKingAltar


Func btnLocateQueenAltar()
	LocateQueenAltar()
EndFunc   ;==>btnLocateQueenAltar

Func btnLocateWardenAltar()
	LocateWardenAltar()
EndFunc   ;==>btnLocateWardenAltar

Func btnLocateTownHall()
	Local $wasRunState = $g_bRunState
	Local $g_iOldTownHallLevel = $g_iTownHallLevel
	$g_bRunState = True
	ZoomOut()
	LocateTownHall()
	If Not $g_iOldTownHallLevel = $g_iTownHallLevel Then
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		Local $stext = @CRLF & GetTranslatedFileIni("MBR Popups", "Locating_your_TH", "If you locating your TH because you upgraded,") & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Must_restart_bot", "then you must restart bot!!!") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "OK_to_restart_bot", "Click OK to restart bot,") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Cancel_to_exit", "Or Click Cancel to exit") & @CRLF
		Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Close_Bot", "Close Bot Please!"), $stext, 120)
		If $g_bDebugSetlog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
		If $MsgBox = 1 Then
			#cs
				Local $stext = @CRLF & GetTranslatedFileIni("MBR Popups", "Sure_Close Bot", "Are you 100% sure you want to restart bot ?") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Restart_bot", "Click OK to close bot and then restart the bot (manually)") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Cancel_to_exit", -1) & @CRLF
				Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", -1), GetTranslatedFileIni("MBR Popups", "Close_Bot", -1), $stext, 120)
				If $g_bDebugSetlog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
				If $MsgBox = 1 Then BotClose(False)
			#ce
			RestartBot(False, $wasRunState)
		EndIf
	EndIf
	$g_bRunState = $wasRunState
	AndroidShield("btnLocateTownHall") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLocateTownHall



Func btnResetBuilding()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	While 1
		If _Sleep(500) Then Return ; add small delay before display message window
		If FileExists($g_sProfileBuildingPath) Then ; Check for building.ini file first
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
			Local $stext = @CRLF & GetTranslatedFileIni("MBR Popups", "Delete_and_Reset_Building_info", "Click OK to Delete and Reset all Building info,") & @CRLF & @CRLF & _
					GetTranslatedFileIni("MBR Popups", "Bot_will_exit", "NOTE =>> Bot will exit and need to be restarted when complete") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Cancel_to_exit", "Or Click Cancel to exit") & @CRLF
			Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Delete_Building_Info", "Delete Building Infomation ?"), $stext, 120)
			If $g_bDebugSetlog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
			If $MsgBox = 1 Then
				Local $stext = @CRLF & GetTranslatedFileIni("MBR Popups", "Sure_Delete_Building_Info", "Are you 100% sure you want to delete Building information ?") & @CRLF & @CRLF & _
						GetTranslatedFileIni("MBR Popups", "Delete_then_restart_bot", "Click OK to Delete and then restart the bot (manually)") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Cancel_to_exit", -1) & @CRLF
				Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", -1), GetTranslatedFileIni("MBR Popups", "Delete_Building_Info", -1), $stext, 120)
				If $g_bDebugSetlog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
				If $MsgBox = 1 Then
					Local $Result = FileDelete($g_sProfileBuildingPath)
					If $Result = 0 Then
						SetLog("Unable to remove building.ini file, please use manual method", $COLOR_ERROR)
					Else
						BotClose(False)
					EndIf
				EndIf
			EndIf
		Else
			SetLog("Building.ini file does not exist", $COLOR_INFO)
		EndIf
		ExitLoop
	WEnd
	$g_bRunState = $wasRunState
	AndroidShield("btnResetBuilding") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnResetBuilding

Func btnLab()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateLab()
	$g_bRunState = $wasRunState
	AndroidShield("btnLab") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLab

Func chkTrophyAtkDead()
	If GUICtrlRead($g_hChkTrophyAtkDead) = $GUI_CHECKED Then
		$g_bDropTrophyAtkDead = True
		GUICtrlSetState($g_hTxtDropTrophyArmyMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyPercent, $GUI_ENABLE)
	Else
		$g_bDropTrophyAtkDead = False
		GUICtrlSetState($g_hTxtDropTrophyArmyMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyPercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyAtkDead

Func chkTrophyRange()
	If GUICtrlRead($g_hChkTrophyRange) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtDropTrophy, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtMaxTrophy, $GUI_ENABLE)
		GUICtrlSetState($g_hChkTrophyHeroes, $GUI_ENABLE)
		GUICtrlSetState($g_hChkTrophyAtkDead, $GUI_ENABLE)
		chkTrophyAtkDead()
		chkTrophyHeroes()
	Else
		GUICtrlSetState($g_hTxtDropTrophy, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtMaxTrophy, $GUI_DISABLE)
		GUICtrlSetState($g_hChkTrophyHeroes, $GUI_DISABLE)
		GUICtrlSetState($g_hChkTrophyAtkDead, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDropTrophyArmyMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyPercent, $GUI_DISABLE)
		GUICtrlSetState($g_hLblTrophyHeroesPriority, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbTrophyHeroesPriority, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyRange

Func TxtDropTrophy()
	If Number(GUICtrlRead($g_hTxtDropTrophy)) > Number(GUICtrlRead($g_hTxtMaxTrophy)) Then
		GUICtrlSetData($g_hTxtMaxTrophy, GUICtrlRead($g_hTxtDropTrophy))
		TxtMaxTrophy()
	EndIf
	_GUI_Value_STATE("HIDE", $g_aGroupListPicMinTrophy)
	If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[21][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueLegend], $GUI_SHOW)
		GUICtrlSetData($g_hLblMinTrophies, "")
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[18][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueTitan], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[20][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[19][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[18][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[15][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueChampion], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[17][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[16][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[15][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[12][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueMaster], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[14][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[13][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[12][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[9][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueCrystal], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[11][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[10][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[9][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[6][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueGold], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[8][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[7][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[6][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[3][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueSilver], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[5][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[4][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[3][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[0][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueBronze], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[2][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[1][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[0][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	Else
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueUnranked], $GUI_SHOW)
		GUICtrlSetData($g_hLblMinTrophies, "")
	EndIf
EndFunc   ;==>TxtDropTrophy

Func TxtMaxTrophy()
	If Number(GUICtrlRead($g_hTxtDropTrophy)) > Number(GUICtrlRead($g_hTxtMaxTrophy)) Then
		GUICtrlSetData($g_hTxtMaxTrophy, GUICtrlRead($g_hTxtDropTrophy))
	EndIf
	_GUI_Value_STATE("HIDE", $g_aGroupListPicMaxTrophy)
	If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[21][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueLegend], $GUI_SHOW)
		GUICtrlSetData($g_hLblMaxTrophies, "")
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[18][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueTitan], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[20][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[19][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[18][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[15][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueChampion], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[17][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[16][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[15][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[12][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueMaster], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[14][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[13][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[12][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[9][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueCrystal], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[11][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[10][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[9][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[6][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueGold], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[8][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[7][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[6][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[3][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueSilver], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[5][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[4][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[3][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[0][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueBronze], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[2][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[1][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[0][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	Else
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueUnranked], $GUI_SHOW)
		GUICtrlSetData($g_hLblMaxTrophies, "")
	EndIf
EndFunc   ;==>TxtMaxTrophy

Func chkTrophyHeroes()
	If GUICtrlRead($g_hChkTrophyHeroes) = $GUI_CHECKED Then
		GUICtrlSetState($g_hLblTrophyHeroesPriority, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbTrophyHeroesPriority, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hLblTrophyHeroesPriority, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbTrophyHeroesPriority, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyHeroes

Func ChkCollect()
	If GUICtrlRead($g_hChkCollect) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkTreasuryCollect, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkTreasuryCollect, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkTreasuryCollect, $GUI_DISABLE)
	EndIf
	ChkTreasuryCollect()
EndFunc   ;==>ChkCollect

Func ChkTreasuryCollect()
	If GUICtrlRead($g_hChkTreasuryCollect) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtTreasuryGold, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtTreasuryElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtTreasuryDark, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtTreasuryGold, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtTreasuryElixir, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtTreasuryDark, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ChkTreasuryCollect

Func chkStartClockTowerBoost()
	If GUICtrlRead($g_hChkStartClockTowerBoost) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkCTBoostBlderBz, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkCTBoostBlderBz, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkStartClockTowerBoost



Func chkActivateClangames()
	If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkClanGamesAir, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesGround, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesMisc, $GUI_ENABLE)

		;V3
		GUICtrlSetState($g_hChkClanGamesLoot, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesBattle, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesDestruction, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesAirTroop, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesGroundTroop, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesMiscellaneous, $GUI_ENABLE)

		GUICtrlSetState($g_hChkClanGamesPurge, $GUI_ENABLE)
		If GUICtrlRead($g_hChkClanGamesPurge) = $GUI_CHECKED then GUICtrlSetState($g_hcmbPurgeLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesStopBeforeReachAndPurge, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesDebug, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkClanGamesAir, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesGround, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesMisc, $GUI_DISABLE)

		;V3
		GUICtrlSetState($g_hChkClanGamesLoot, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesBattle, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesDestruction, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesAirTroop, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesGroundTroop, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesMiscellaneous, $GUI_DISABLE)
		GUICtrlSetState($g_hcmbPurgeLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesStopBeforeReachAndPurge, $GUI_DISABLE)

		GUICtrlSetState($g_hChkClanGamesPurge, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesDebug, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkActivateClangames

Func chkPurgeLimits()
	If GUICtrlRead($g_hChkClanGamesPurge) = $GUI_CHECKED AND _
	   GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_CHECKED Then
		GUICtrlSetState($g_hcmbPurgeLimit, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hcmbPurgeLimit, $GUI_DISABLE)
	EndIf
EndFunc
