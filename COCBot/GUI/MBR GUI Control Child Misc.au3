; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Misc
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
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
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_HIDE)
		Case $g_hBtnConfirmAddProfile
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($g_hTxtVillageName), '[/:*?"<>|]', '_')
			If FileExists($g_sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_01", "Profile Already Exists"), GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_02", "%s already exists.\r\nPlease choose another name for your profile.", $newProfileName))
				Return
			EndIf

			saveConfig() ; save current config so we don't miss anything recently changed
			readConfig() ; read it back in to reset all of the .ini file global variables

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
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_SHOW)

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
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_SHOW)
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
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_HIDE)
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
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_SHOW)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch
EndFunc   ;==>btnRenameConfirm

Func btnPullSharedPrefs()
	PullSharedPrefs()
EndFunc   ;==>btnPullSharedPrefs

Func btnPushSharedPrefs()
	PushSharedPrefs()
EndFunc   ;==>btnPushSharedPrefs

Func BtnSaveprofile()
	Setlog("Saving your setting...", $COLOR_INFO)
	SaveConfig()
	readConfig()
	applyConfig()
	Setlog("Done!", $COLOR_SUCCESS)
EndFunc   ;==>BtnSaveprofile

Func OnlySCIDAccounts()
	; $g_hChkOnlySCIDAccounts
	If GUICtrlRead($g_hChkOnlySCIDAccounts) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbWhatSCIDAccount2Use, $GUI_ENABLE)
		WhatSCIDAccount2Use()
		$g_bOnlySCIDAccounts = True
	Else
		GUICtrlSetState($g_hCmbWhatSCIDAccount2Use, $GUI_DISABLE)
		$g_bOnlySCIDAccounts = False
	EndIf
EndFunc   ;==>OnlySCIDAccounts

Func WhatSCIDAccount2Use()
	; $g_hCmbWhatSCIDAccount2Use
	$g_iWhatSCIDAccount2Use = _GUICtrlComboBox_GetCurSel($g_hCmbWhatSCIDAccount2Use)
EndFunc   ;==>WhatSCIDAccount2Use

Func cmbBotCond()
	Local $iCond = _GUICtrlComboBox_GetCurSel($g_hCmbBotCond)
	If $iCond = 15 Then
		If _GUICtrlComboBox_GetCurSel($g_hCmbHoursStop) = 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbHoursStop, 1)
		GUICtrlSetState($g_hCmbHoursStop, $GUI_ENABLE)
	Else
		_GUICtrlComboBox_SetCurSel($g_hCmbHoursStop, 0)
		GUICtrlSetState($g_hCmbHoursStop, $GUI_DISABLE)
	EndIf
	If $iCond = 22 Then
		GUICtrlSetState($g_hCmbHoursStop, $GUI_HIDE)
		For $i = $g_ahTxtResumeAttackLoot[$eLootTrophy] To $g_ahTxtResumeAttackLoot[$eLootDarkElixir]
			GUICtrlSetState($i, $GUI_HIDE)
		Next
		_GUI_Value_STATE("SHOW", $g_hCmbTimeStop & "#" & $g_hCmbResumeTime)
		_GUI_Value_STATE("ENABLE", $g_hCmbTimeStop & "#" & $g_hCmbResumeTime)
	Else
		_GUI_Value_STATE("HIDE", $g_hCmbTimeStop & "#" & $g_hCmbResumeTime)
		GUICtrlSetState($g_hCmbHoursStop, $GUI_SHOW)
		For $i = $g_ahTxtResumeAttackLoot[$eLootTrophy] To $g_ahTxtResumeAttackLoot[$eLootDarkElixir]
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	EndIf

	For $i = $g_LblResumeAttack To $g_ahTxtResumeAttackLoot[$eLootDarkElixir]
		GUICtrlSetState($i, $GUI_DISABLE)
	Next
	If _GUICtrlComboBox_GetCurSel($g_hCmbBotCommand) <> 0 Then Return
	If $iCond <= 14 Or $iCond = 22 Then GUICtrlSetState($g_LblResumeAttack, $GUI_ENABLE)
	If $iCond <= 14 Then GUICtrlSetState($g_hChkCollectStarBonus, $GUI_ENABLE)
	If $iCond <= 6 Or $iCond = 8 Or $iCond = 10 Or $iCond = 14 Then GUICtrlSetState($g_ahTxtResumeAttackLoot[$eLootGold], $GUI_ENABLE)
	If $iCond <= 5 Or $iCond = 7 Or $iCond = 9 Or $iCond = 11 Or $iCond = 14 Then GUICtrlSetState($g_ahTxtResumeAttackLoot[$eLootElixir], $GUI_ENABLE)
	If $iCond = 13 Or $iCond = 14 Then GUICtrlSetState($g_ahTxtResumeAttackLoot[$eLootDarkElixir], $GUI_ENABLE)
	If $iCond <= 3 Or ($iCond >= 6 And $iCond <= 9) Or $iCond = 12 Then GUICtrlSetState($g_ahTxtResumeAttackLoot[$eLootTrophy], $GUI_ENABLE)
	If $iCond = 22 Then GUICtrlSetState($g_hCmbResumeTime, $GUI_ENABLE)
EndFunc   ;==>cmbBotCond

Func chkBotStop()
	If GUICtrlRead($g_hChkBotStop) = $GUI_CHECKED Then
		For $i = $g_hCmbBotCommand To $g_hCmbBotCond
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		cmbBotCond()
		GUICtrlSetState($g_hChkForceAttackOnClanGamesWhenHalt, $GUI_ENABLE)
	Else
		For $i = $g_hCmbBotCommand To $g_ahTxtResumeAttackLoot[$eLootDarkElixir]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetState($g_hChkForceAttackOnClanGamesWhenHalt, $GUI_DISABLE)
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

Func btnLocateChampionAltar()
	LocateChampionAltar()
EndFunc   ;==>btnLocateChampionAltar

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

Func btnResetDistributor()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	While 1
		If _Sleep(500) Then Return ; add small delay before display message window
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		Local $stext = @CRLF & GetTranslatedFileIni("MBR Popups", "Reset_Distributor_info", "Click Continue to Reset and Select Game Distributor,") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Bot_will_exit", "NOTE =>> Bot will exit and need to be restarted when complete") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Cancel_to_exit", "Or Click Cancel to exit") & @CRLF
		Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Continue_Cancel", "Continue|Cancel"), GetTranslatedFileIni("MBR Popups", "Game_Distributor_Info", "Game Distributor Selection"), $stext, 120)
		If $g_bDebugSetlog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
		If $MsgBox = 1 Then
			Local $stext = @CRLF & GetTranslatedFileIni("MBR Popups", "Choice_Game_Distributor_Info", "Choose Game Distributor Now") & @CRLF
			Local $MsgBox = _ExtMsgBox(0, "Google|Amazon", GetTranslatedFileIni("MBR Popups", "Game_Distributor_Info", -1), $stext, 120)
			If $g_bDebugSetlog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
			If $MsgBox = 1 Then
				$g_sAndroidGameDistributor = "Google"
				$g_sAndroidGamePackage = "com.supercell.clashofclans"
				$g_sAndroidGameClass = "com.supercell.titan.GameApp"
				$g_sUserGameDistributor = "Google"
				$g_sUserGamePackage = "com.supercell.clashofclans"
				$g_sUserGameClass = "com.supercell.titan.GameApp"
			ElseIf $MsgBox = 2 Then
				$g_sAndroidGameDistributor = "Amazon"
				$g_sAndroidGamePackage = "com.supercell.clashofclans.amazon"
				$g_sAndroidGameClass = "com.supercell.titan.amazon.GameAppAmazon"
				$g_sUserGameDistributor = "Amazon"
				$g_sUserGamePackage = "com.supercell.clashofclans.amazon"
				$g_sUserGameClass = "com.supercell.titan.amazon.GameAppAmazon"
			EndIf
			Local $stext = @CRLF & GetTranslatedFileIni("MBR Popups", "Sure_Game_Distributor_Info", "Are you 100% sure of Game Distributor ?") & @CRLF & @CRLF & _
					GetTranslatedFileIni("MBR Popups", "Reset_then_restart_bot", "Click Confirm to Reset and then restart the bot (manually)") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Cancel_to_exit", -1) & @CRLF
			Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Confirm_Cancel", "Confirm|Cancel"), GetTranslatedFileIni("MBR Popups", "Reset_Game_Distributor_Info", -1), $stext, 120)
			If $g_bDebugSetlog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
			If $MsgBox = 1 Then
				SaveConfig()
				BotClose(False)
			EndIf
		EndIf
		ExitLoop
	WEnd
	$g_bRunState = $wasRunState
	AndroidShield("btnResetDistributor") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnResetDistributor

Func btnLab()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateLab()
	$g_bRunState = $wasRunState
	AndroidShield("btnLab") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLab

Func btnPet()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocatePetHouse()
	$g_bRunState = $wasRunState
	AndroidShield("btnPet") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnPet

Func btnBsmith()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateBlacksmith()
	$g_bRunState = $wasRunState
	AndroidShield("btnBsmith") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnBsmith

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
		GUICtrlSetState($g_hChkCollectCartFirst, $GUI_ENABLE)
		GUICtrlSetState($g_hChkTreasuryCollect, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtCollectGold, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtCollectElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtCollectDark, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkCollectCartFirst, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkCollectCartFirst, $GUI_DISABLE)
		GUICtrlSetState($g_hChkTreasuryCollect, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkTreasuryCollect, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtCollectGold, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtCollectElixir, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtCollectDark, $GUI_DISABLE)
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

Func ChkFreeMagicItems()
	If $g_iTownHallLevel >= 8 Then ; Must be Th8 or more to use the Trader
		GUICtrlSetState($g_hChkFreeMagicItems, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkFreeMagicItems, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ChkFreeMagicItems


Func chkStartClockTowerBoost()
	If GUICtrlRead($g_hChkStartClockTowerBoost) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkCTBoostBlderBz, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkCTBoostBlderBz, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkStartClockTowerBoost

Func chkEnableBBAttack()
	If GUICtrlRead($g_hChkEnableBBAttack) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkBBTrophyRange, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbBBAttackCount, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBHaltOnGoldFull, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBHaltOnElixirFull, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBWaitForMachine, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnBBDropOrder, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbBBSameTroopDelay, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbBBNextTroopDelay, $GUI_ENABLE)
		GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $GUI_ENABLE)
		cmbBBAttackCount()
		chkBBTrophyRange()
	Else
		GUICtrlSetState($g_hChkBBTrophyRange, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbBBAttackCount, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBHaltOnGoldFull, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBHaltOnElixirFull, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtBBTrophyLowerLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtBBTrophyUpperLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hChkBBWaitForMachine, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnBBDropOrder, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbBBSameTroopDelay, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbBBNextTroopDelay, $GUI_DISABLE)
		GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkEnableBBAttack

Func cmbBBNextTroopDelay()
	$g_iBBNextTroopDelay = $g_iBBNextTroopDelayDefault + ((_GUICtrlComboBox_GetCurSel($g_hCmbBBNextTroopDelay) + 1) - 5) * $g_iBBNextTroopDelayIncrement ; +- n*increment
	SetDebugLog("Next Troop Delay: " & $g_iBBNextTroopDelay)
	SetDebugLog((_GUICtrlComboBox_GetCurSel($g_hCmbBBNextTroopDelay) + 1) - 5)
EndFunc   ;==>cmbBBNextTroopDelay

Func cmbBBSameTroopDelay()
	$g_iBBSameTroopDelay = $g_iBBSameTroopDelayDefault + ((_GUICtrlComboBox_GetCurSel($g_hCmbBBSameTroopDelay) + 1) - 5) * $g_iBBSameTroopDelayIncrement ; +- n*increment
	SetDebugLog("Same Troop Delay: " & $g_iBBSameTroopDelay)
	SetDebugLog((_GUICtrlComboBox_GetCurSel($g_hCmbBBSameTroopDelay) + 1) - 5)
EndFunc   ;==>cmbBBSameTroopDelay

Func chkBBTrophyRange()
	If GUICtrlRead($g_hChkBBTrophyRange) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtBBTrophyLowerLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtBBTrophyUpperLimit, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtBBTrophyLowerLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtBBTrophyUpperLimit, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBBTrophyRange

Func btnBBDropOrder()
	GUICtrlSetState($g_hBtnBBDropOrder, $GUI_DISABLE)
	GUICtrlSetState($g_hChkEnableBBAttack, $GUI_DISABLE)
	GUISetState(@SW_SHOW, $g_hGUI_BBDropOrder)
EndFunc   ;==>btnBBDropOrder

Func chkBBDropOrder()
	If GUICtrlRead($g_hChkBBCustomDropOrderEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hBtnBBDropOrderSet, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnBBRemoveDropOrder, $GUI_ENABLE)
		For $i = 0 To $g_iBBTroopCount - 1
			GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_ENABLE)
		Next
	Else
		GUICtrlSetState($g_hBtnBBDropOrderSet, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnBBRemoveDropOrder, $GUI_DISABLE)
		For $i = 0 To $g_iBBTroopCount - 1
			GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_DISABLE)
		Next
		GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_RED)
		$g_bBBDropOrderSet = False
	EndIf
EndFunc   ;==>chkBBDropOrder

Func GUIBBDropOrder()
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iDropIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId)

	For $i = 0 To $g_iBBTroopCount - 1
		If $iGUI_CtrlId = $g_ahCmbBBDropOrder[$i] Then ContinueLoop
		If $iDropIndex = _GUICtrlComboBox_GetCurSel($g_ahCmbBBDropOrder[$i]) Then
			_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], -1)
			GUISetState()
		EndIf
	Next
EndFunc   ;==>GUIBBDropOrder

Func BtnBBDropOrderSet()
	$g_sBBDropOrder = ""
	; loop through reading and disabling all combo boxes
	For $i = 0 To $g_iBBTroopCount - 1
		GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_DISABLE)
		If GUICtrlRead($g_ahCmbBBDropOrder[$i]) = "" Then ; if not picked assign from default list in order
			Local $asDefaultOrderSplit = StringSplit($g_sBBDropOrderDefault, "|")
			Local $bFound = False, $bSet = False
			Local $j = 0
			While $j < $g_iBBTroopCount And Not $bSet ; loop through troops
				Local $k = 0
				While $k < $g_iBBTroopCount And Not $bFound ; loop through handles
					If $g_ahCmbBBDropOrder[$i] <> $g_ahCmbBBDropOrder[$k] Then
						SetDebugLog("Word: " & $asDefaultOrderSplit[$j + 1] & " " & " Word in slot: " & GUICtrlRead($g_ahCmbBBDropOrder[$k]))
						If $asDefaultOrderSplit[$j + 1] = GUICtrlRead($g_ahCmbBBDropOrder[$k]) Then $bFound = True
					EndIf
					$k += 1
				WEnd
				If Not $bFound Then
					_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], $j)
					$bSet = True
				Else
					$j += 1
					$bFound = False
				EndIf
			WEnd
		EndIf
		$g_sBBDropOrder &= (GUICtrlRead($g_ahCmbBBDropOrder[$i]) & "|")
		SetDebugLog("DropOrder: " & $g_sBBDropOrder)
	Next
	$g_sBBDropOrder = StringTrimRight($g_sBBDropOrder, 1) ; Remove last '|'
	GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_GREEN)
	$g_bBBDropOrderSet = True
EndFunc   ;==>BtnBBDropOrderSet

Func BtnBBRemoveDropOrder()
	For $i = 0 To $g_iBBTroopCount - 1
		_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], -1)
		GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_ENABLE)
	Next
	GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_RED)
	$g_bBBDropOrderSet = False
EndFunc   ;==>BtnBBRemoveDropOrder

Func CloseCustomBBDropOrder()
	GUISetState(@SW_HIDE, $g_hGUI_BBDropOrder)
	GUICtrlSetState($g_hBtnBBDropOrder, $GUI_ENABLE)
	GUICtrlSetState($g_hChkEnableBBAttack, $GUI_ENABLE)
EndFunc   ;==>CloseCustomBBDropOrder

Func chkUpgradeDoubleCannon()

	If GUICtrlRead($g_hChkDoubleCannonUpgrade) = $GUI_CHECKED Then
		_GUICtrlTab_ClickTab($g_hTabMain, 0)

		SetLog("Please wait ......", $COLOR_OLIVE)
		SetLog("Checking for valid Coordinates of Double Cannon ......", $COLOR_OLIVE)

		$g_bDoubleCannonUpgrade = True
		LocateDoubleCannon()
	Else
		$g_bDoubleCannonUpgrade = False
	EndIf

	Return
EndFunc   ;==>chkUpgradeDoubleCannon

Func DeleteDoubleCannonCoord()
	SetLog("Deleting Coordinates of Double Cannon.", $COLOR_OLIVE)
	$g_aiDoubleCannonPos[0] = -1
	$g_aiDoubleCannonPos[1] = -1
	$g_aiDoubleCannonPos[2] = -1
	IniWrite($g_sProfileBuildingPath, "other", "DoubleCannonPosX", $g_aiDoubleCannonPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "DoubleCannonPosY", $g_aiDoubleCannonPos[1])
	IniWrite($g_sProfileBuildingPath, "other", "DoubleCannonPosV", $g_aiDoubleCannonPos[2])
	$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
	GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)
EndFunc   ;==>DeleteDoubleCannonCoord

Func chkUpgradeArcherTower()

	If GUICtrlRead($g_hChkArcherTowerUpgrade) = $GUI_CHECKED Then
		_GUICtrlTab_ClickTab($g_hTabMain, 0)

		SetLog("Please wait ......", $COLOR_OLIVE)
		SetLog("Checking for valid Coordinates of Archer Tower ......", $COLOR_OLIVE)

		$g_bArcherTowerUpgrade = True
		LocateArcherTower()
	Else
		$g_bArcherTowerUpgrade = False
	EndIf

	Return
EndFunc   ;==>chkUpgradeArcherTower

Func DeleteArcherTowerCoord()
	SetLog("Deleting Coordinates of Archer Tower.", $COLOR_OLIVE)
	$g_aiArcherTowerPos[0] = -1
	$g_aiArcherTowerPos[1] = -1
	$g_aiArcherTowerPos[2] = -1
	IniWrite($g_sProfileBuildingPath, "other", "ArcherTowerPosX", $g_aiArcherTowerPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "ArcherTowerPosY", $g_aiArcherTowerPos[1])
	IniWrite($g_sProfileBuildingPath, "other", "ArcherTowerPosV", $g_aiArcherTowerPos[2])
	$g_bArcherTowerUpgrade = False ; turn Off the Archer Tower upgrade
	GUICtrlSetState($g_hChkArcherTowerUpgrade, $GUI_UNCHECKED)
EndFunc   ;==>DeleteArcherTowerCoord

Func chkUpgradeMultiMortar()

	If GUICtrlRead($g_hChkMultiMortarUpgrade) = $GUI_CHECKED Then
		_GUICtrlTab_ClickTab($g_hTabMain, 0)

		SetLog("Please wait ......", $COLOR_OLIVE)
		SetLog("Checking for valid Coordinates of Multi Mortar ......", $COLOR_OLIVE)

		$g_bMultiMortarUpgrade = True
		LocateMultiMortar()
	Else
		$g_bMultiMortarUpgrade = False
	EndIf

	Return
EndFunc   ;==>chkUpgradeMultiMortar

Func DeleteMultiMortarCoord()
	SetLog("Deleting Coordinates of Multi Mortar.", $COLOR_OLIVE)
	$g_aiMultiMortarPos[0] = -1
	$g_aiMultiMortarPos[1] = -1
	$g_aiMultiMortarPos[2] = -1
	IniWrite($g_sProfileBuildingPath, "other", "MultiMortarPosX", $g_aiMultiMortarPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "MultiMortarPosY", $g_aiMultiMortarPos[1])
	IniWrite($g_sProfileBuildingPath, "other", "MultiMortarPosV", $g_aiMultiMortarPos[2])
	$g_bMultiMortarUpgrade = False ; turn Off the Multi Mortar upgrade
	GUICtrlSetState($g_hChkMultiMortarUpgrade, $GUI_UNCHECKED)
EndFunc   ;==>DeleteMultiMortarCoord

Func chkUpgradeAnyDef()

	If GUICtrlRead($g_hChkAnyDefUpgrade) = $GUI_CHECKED Then
		_GUICtrlTab_ClickTab($g_hTabMain, 0)

		SetLog("Please wait ......", $COLOR_OLIVE)
		SetLog("Checking for valid Coordinates of Defensive Building ......", $COLOR_OLIVE)

		$g_bAnyDefUpgrade = True
		LocateAnyDef()
	Else
		$g_bAnyDefUpgrade = False
	EndIf

	Return
EndFunc   ;==>chkUpgradeAnyDef

Func DeleteCannonCoord()
	SetLog("Deleting Coordinates of Cannon.", $COLOR_OLIVE)
	$g_aiAnyDefPos[0] = -1
	$g_aiAnyDefPos[1] = -1
	$g_aiAnyDefPos[2] = -1
	IniWrite($g_sProfileBuildingPath, "other", "AnyDefPosX", $g_aiAnyDefPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "AnyDefPosY", $g_aiAnyDefPos[1])
	IniWrite($g_sProfileBuildingPath, "other", "AnyDefPosV", $g_aiAnyDefPos[2])
	$g_bAnyDefUpgrade = False ; turn Off the Cannon upgrade
	GUICtrlSetState($g_hChkAnyDefUpgrade, $GUI_UNCHECKED)
EndFunc   ;==>DeleteCannonCoord

Func cmbBBAttackCount()
	$g_iBBAttackCount = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttackCount)
	SetDebugLog("BB Attack Count: " & $g_iBBAttackCount, $COLOR_DEBUG)
	If _GUICtrlComboBox_GetCurSel($g_hCmbBBAttackCount) = 0 Then
		SetDebugLog("Enabling Check Loot Available", $COLOR_DEBUG)
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_CHECKED)
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_ENABLE)
	EndIf
EndFunc   ;==>cmbBBAttackCount

Func chkActivateClangames()
	If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_CHECKED Then
		GUICtrlSetState($g_hBtnCGSettingsOpen, $GUI_ENABLE)
		For $i = $g_hChkClanGamesAllTimes To $g_hChkClanGamesNoOneDay
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		GUICtrlSetState($g_hChkClanGamesCollectRewards, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnCGRewardsSettingsOpen, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnCGSettingsOpen, $GUI_DISABLE)
		For $i = $g_hChkClanGamesAllTimes To $g_hChkClanGamesNoOneDay
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetState($g_hChkClanGamesCollectRewards, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkActivateClangames

Func ChkClanGamesAllTimes()
	If GUICtrlRead($g_hChkClanGamesAllTimes) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkClanGamesNoOneDay, $GUI_UNCHECKED)
		If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_UNCHECKED Then
			For $i = $g_hChkClanGamesAllTimes To $g_hChkClanGamesNoOneDay
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		Else
			For $i = $g_hChkClanGamesAllTimes To $g_hChkClanGamesNoOneDay
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
		EndIf
	Else
		If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_CHECKED Then
			GUICtrlSetState($g_hChkClanGamesNoOneDay, $GUI_UNCHECKED)
		Else
			For $i = $g_hChkClanGamesAllTimes To $g_hChkClanGamesNoOneDay
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		EndIf
	EndIf
EndFunc   ;==>ChkClanGamesAllTimes

Func ChkClanGamesNoOneDay()
	If GUICtrlRead($g_hChkClanGamesNoOneDay) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkClanGamesAllTimes, $GUI_UNCHECKED)
		If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_UNCHECKED Then
			For $i = $g_hChkClanGamesAllTimes To $g_hChkClanGamesNoOneDay
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		Else
			For $i = $g_hChkClanGamesAllTimes To $g_hChkClanGamesNoOneDay
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
		EndIf
	Else
		If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_CHECKED Then
			GUICtrlSetState($g_hChkClanGamesAllTimes, $GUI_UNCHECKED)
		Else
			For $i = $g_hChkClanGamesAllTimes To $g_hChkClanGamesNoOneDay
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		EndIf
	EndIf
EndFunc   ;==>ChkClanGamesNoOneDay

Func chkClanGamesBB()
	If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_CHECKED And _
			GUICtrlRead($g_hChkForceBBAttackOnClanGames) = $GUI_CHECKED Then
		$g_bChkForceBBAttackOnClanGames = True
	Else
		$g_bChkForceBBAttackOnClanGames = False
	EndIf
EndFunc   ;==>chkClanGamesBB

Func ChkClanGamesPurgeAny()
	If GUICtrlRead($g_hChkClanGamesPurgeAny) = $GUI_CHECKED Then
		$g_bChkClanGamesPurgeAny = True
	Else
		$g_bChkClanGamesPurgeAny = False
	EndIf
EndFunc   ;==>ChkClanGamesPurgeAny

Func btnCGSettings()
	GUISetState(@SW_SHOW, $g_hGUI_CGSettings)
EndFunc   ;==>btnCGSettings

Func CloseCGSettings()
	GUISetState(@SW_HIDE, $g_hGUI_CGSettings)
EndFunc   ;==>CloseCGSettings

Func btnCGRewardsSettings()
	GUISetState(@SW_SHOW, $g_hGUI_CGRewardsSettings)
EndFunc   ;==>btnCGRewardsSettings

Func CloseCGRewardsSettings()
	GUISetState(@SW_HIDE, $g_hGUI_CGRewardsSettings)
EndFunc   ;==>CloseCGRewardsSettings

Func CGLootTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGMainLoot), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Loot
		For $i = 0 To UBound($g_ahCGMainLootItem) - 1
			GUICtrlSetState($g_ahCGMainLootItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGMainLoot), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Loot
		For $i = 0 To UBound($g_ahCGMainLootItem) - 1
			GUICtrlSetState($g_ahCGMainLootItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Main Village Loot Challenges")
EndFunc   ;==>CGLootTVRoot

Func CGLootTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$LootChallenges")
	For $i = 0 To UBound($g_ahCGMainLootItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGMainLootItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGLootTVItem

Func CGMainBattleTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGMainBattle), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Battle
		For $i = 0 To UBound($g_ahCGMainBattleItem) - 1
			GUICtrlSetState($g_ahCGMainBattleItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGMainBattle), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Battle
		For $i = 0 To UBound($g_ahCGMainBattleItem) - 1
			GUICtrlSetState($g_ahCGMainBattleItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Main Village Battle Challenges")
EndFunc   ;==>CGMainBattleTVRoot

Func CGMainBattleTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$BattleChallenges")
	For $i = 0 To UBound($g_ahCGMainBattleItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGMainBattleItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGMainBattleTVItem

Func CGMainDestructionTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGMainDestruction), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage DestructionChallenges
		For $i = 0 To UBound($g_ahCGMainDestructionItem) - 1
			GUICtrlSetState($g_ahCGMainDestructionItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGMainDestruction), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage DestructionChallenges
		For $i = 0 To UBound($g_ahCGMainDestructionItem) - 1
			GUICtrlSetState($g_ahCGMainDestructionItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Main Village Destruction Challenges")
EndFunc   ;==>CGMainDestructionTVRoot

Func CGMainDestructionTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$DestructionChallenges")
	For $i = 0 To UBound($g_ahCGMainDestructionItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGMainDestructionItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGMainDestructionTVItem

Func CGMainAirTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGMainAir), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Air Troops Challenges
		For $i = 0 To UBound($g_ahCGMainAirItem) - 1
			GUICtrlSetState($g_ahCGMainAirItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGMainAir), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Air Troops Challenges
		For $i = 0 To UBound($g_ahCGMainAirItem) - 1
			GUICtrlSetState($g_ahCGMainAirItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Main Village Air Troops Challenges")
EndFunc   ;==>CGMainAirTVRoot

Func CGMainAirTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$AirTroopChallenges")
	For $i = 0 To UBound($g_ahCGMainAirItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGMainAirItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGMainAirTVItem

Func CGMainGroundTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGMainGround), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Ground Troops Challenges
		For $i = 0 To UBound($g_ahCGMainGroundItem) - 1
			GUICtrlSetState($g_ahCGMainGroundItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGMainGround), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Ground Troops Challenges
		For $i = 0 To UBound($g_ahCGMainGroundItem) - 1
			GUICtrlSetState($g_ahCGMainGroundItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Main Village Ground Troops Challenges")
EndFunc   ;==>CGMainGroundTVRoot

Func CGMainGroundTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$GroundTroopChallenges")
	For $i = 0 To UBound($g_ahCGMainGroundItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGMainGroundItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGMainGroundTVItem

Func CGMainMiscTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGMainMisc), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Miscellaneous Challenges
		For $i = 0 To UBound($g_ahCGMainMiscItem) - 1
			GUICtrlSetState($g_ahCGMainMiscItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGMainMisc), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Miscellaneous Challenges
		For $i = 0 To UBound($g_ahCGMainMiscItem) - 1
			GUICtrlSetState($g_ahCGMainMiscItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Main Village Miscellaneous Challenges")
EndFunc   ;==>CGMainMiscTVRoot

Func CGMainMiscTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$MiscChallenges")
	For $i = 0 To UBound($g_ahCGMainMiscItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGMainMiscItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGMainMiscTVItem

Func CGMainSpellTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGMainSpell), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Spell Challenges
		For $i = 0 To UBound($g_ahCGMainSpellItem) - 1
			GUICtrlSetState($g_ahCGMainSpellItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGMainSpell), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames MainVillage Spell Challenges
		For $i = 0 To UBound($g_ahCGMainSpellItem) - 1
			GUICtrlSetState($g_ahCGMainSpellItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Main Village Spell Challenges")
EndFunc   ;==>CGMainSpellTVRoot

Func CGMainSpellTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$SpellChallenges")
	For $i = 0 To UBound($g_ahCGMainSpellItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGMainSpellItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGMainSpellTVItem

Func CGBBBattleTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGBBBattle), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames Builder Base Battle Challenges
		For $i = 0 To UBound($g_ahCGBBBattleItem) - 1
			GUICtrlSetState($g_ahCGBBBattleItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGBBBattle), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames Builder Base Battle Challenges
		For $i = 0 To UBound($g_ahCGBBBattleItem) - 1
			GUICtrlSetState($g_ahCGBBBattleItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Builder Base Battle Challenges")
EndFunc   ;==>CGBBBattleTVRoot

Func CGBBBattleTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$BBBattleChallenges")
	For $i = 0 To UBound($g_ahCGBBBattleItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGBBBattleItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGBBBattleTVItem

Func CGBBDestructionTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGBBDestruction), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames Builder Base Destruction Challenges
		For $i = 0 To UBound($g_ahCGBBDestructionItem) - 1
			GUICtrlSetState($g_ahCGBBDestructionItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGBBDestruction), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames Builder Base Destruction Challenges
		For $i = 0 To UBound($g_ahCGBBDestructionItem) - 1
			GUICtrlSetState($g_ahCGBBDestructionItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Builder Base Destruction Challenges")
EndFunc   ;==>CGBBDestructionTVRoot

Func CGBBDestructionTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$BBDestructionChallenges")
	For $i = 0 To UBound($g_ahCGBBDestructionItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGBBDestructionItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGBBDestructionTVItem

Func CGBBTroopsTVRoot()
	If BitAND(GUICtrlRead($g_hChkCGBBTroops), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames Builder Base Troops Challenges
		For $i = 0 To UBound($g_ahCGBBTroopsItem) - 1
			GUICtrlSetState($g_ahCGBBTroopsItem[$i], $GUI_CHECKED)
		Next
	EndIf
	If Not BitAND(GUICtrlRead($g_hChkCGBBTroops), $GUI_CHECKED) And GUICtrlRead($g_hChkCGRootEnabledAll) = $GUI_CHECKED Then ;root Clangames Builder Base Troops Challenges
		For $i = 0 To UBound($g_ahCGBBTroopsItem) - 1
			GUICtrlSetState($g_ahCGBBTroopsItem[$i], $GUI_UNCHECKED)
		Next
	EndIf
	GUICtrlSetData($g_hLabelClangamesDesc, "Enable/Disable Builder Base Troops Challenges")
EndFunc   ;==>CGBBTroopsTVRoot

Func CGBBTroopsTVItem()
	Local $tmpChallenges = ClanGamesChallenges("$BBTroopsChallenges")
	For $i = 0 To UBound($g_ahCGBBTroopsItem) - 1
		If GUICtrlRead($g_hClanGamesTV) = $g_ahCGBBTroopsItem[$i] Then
			GUICtrlSetData($g_hLabelClangamesDesc, $tmpChallenges[$i][4] & @CRLF & "Required TH Level : " & $tmpChallenges[$i][2] _
					 & @CRLF & "Difficulty : " & $tmpChallenges[$i][3])
			ExitLoop
		Else
			GUICtrlSetData($g_hLabelClangamesDesc, "")
		EndIf
	Next
EndFunc   ;==>CGBBTroopsTVItem

Func chkSortClanGames()
	If GUICtrlRead($g_hChkClanGamesSort) = $GUI_CHECKED Then
		$g_bSortClanGames = True
		GUICtrlSetState($g_hCmbClanGamesSort, $GUI_ENABLE)
	Else
		$g_bSortClanGames = False
		GUICtrlSetState($g_hCmbClanGamesSort, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkSortClanGames

Func ChkEnableForgeGold()
	If GUICtrlRead($g_hChkEnableForgeGold) = $GUI_CHECKED Then
		$g_bChkEnableForgeGold = True
		For $i = $g_hLbacmdGoldSaveMin To $g_acmdGoldSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeGold = False
		For $i = $g_hLbacmdGoldSaveMin To $g_acmdGoldSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeGold

Func ChkEnableForgeElix()
	If GUICtrlRead($g_hChkEnableForgeElix) = $GUI_CHECKED Then
		$g_bChkEnableForgeElix = True
		For $i = $g_hLbacmdElixSaveMin To $g_acmdElixSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeElix = False
		For $i = $g_hLbacmdElixSaveMin To $g_acmdElixSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeElix

Func ChkEnableForgeDE()
	If GUICtrlRead($g_hChkEnableForgeDE) = $GUI_CHECKED Then
		$g_bChkEnableForgeDE = True
		For $i = $g_hLbacmdDarkSaveMin To $g_acmdDarkSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeDE = False
		For $i = $g_hLbacmdDarkSaveMin To $g_acmdDarkSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeDE

Func ChkEnableForgeBBGold()
	If GUICtrlRead($g_hChkEnableForgeBBGold) = $GUI_CHECKED Then
		$g_bChkEnableForgeBBGold = True
		For $i = $g_hLbacmdBBGoldSaveMin To $g_acmdBBGoldSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeBBGold = False
		For $i = $g_hLbacmdBBGoldSaveMin To $g_acmdBBGoldSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeBBGold

Func ChkEnableForgeBBElix()
	If GUICtrlRead($g_hChkEnableForgeBBElix) = $GUI_CHECKED Then
		$g_bChkEnableForgeBBElix = True
		For $i = $g_hLbacmdBBElixSaveMin To $g_acmdBBElixSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableForgeBBElix = False
		For $i = $g_hLbacmdBBElixSaveMin To $g_acmdBBElixSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeBBElix

Func EnableAutoUpgradeCC()
	If GUICtrlRead($g_hChkEnableAutoUpgradeCC) = $GUI_CHECKED Then
		$g_bChkEnableAutoUpgradeCC = True
		For $i = $g_hChkAutoUpgradeCCPriorArmy To $g_hChkAutoUpgradeCCWallIgnore
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkEnableAutoUpgradeCC = False
		For $i = $g_hChkAutoUpgradeCCPriorArmy To $g_hChkAutoUpgradeCCWallIgnore
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>EnableAutoUpgradeCC

Func CmbForgeBuilder()
	$g_iCmbForgeBuilder = Int(_GUICtrlComboBox_GetCurSel($g_hCmbForgeBuilder))
	GUICtrlSetData($g_hLbCmbForgeBuilder, $g_iCmbForgeBuilder > 0 ? GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builders for Forge") : _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builder for Forge"))
EndFunc   ;==>CmbForgeBuilder
