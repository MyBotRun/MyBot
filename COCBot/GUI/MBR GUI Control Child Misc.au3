; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Misc
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......:
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
				MsgBox($MB_ICONWARNING, GetTranslated(637, 11, "Profile Already Exists"), $newProfileName & " " & GetTranslated(637, 12, "already exists.") & @CRLF & GetTranslated(637, 13, "Please choose another name for your profile"))
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
			Local $msgboxAnswer = MsgBox($MB_ICONWARNING + $MB_OKCANCEL, GetTranslated(7, 111, "Delete Profile"), GetTranslated(7, 112, "Are you sure you really want to delete the profile?") & @CRLF & GetTranslated(7, 113, "This action can not be undone."))
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
				MsgBox($MB_ICONWARNING, GetTranslated(7, 108, "Profile Already Exists"), $newProfileName & " " & GetTranslated(7, 109, "already exists.") & @CRLF & GetTranslated(7, 110, "Please choose another name for your profile"))
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
Func cmbBotCond()
	If _GUICtrlComboBox_GetCurSel($cmbBotCond) = 15 Then
		If _GUICtrlComboBox_GetCurSel($cmbHoursStop) = 0 Then _GUICtrlComboBox_SetCurSel($cmbHoursStop, 1)
		GUICtrlSetState($cmbHoursStop, $GUI_ENABLE)
	Else
		_GUICtrlComboBox_SetCurSel($cmbHoursStop, 0)
		GUICtrlSetState($cmbHoursStop, $GUI_DISABLE)
	EndIf
EndFunc   ;==>cmbBotCond

Func chkBotStop()
	If GUICtrlRead($chkBotStop) = $GUI_CHECKED Then
		GUICtrlSetState($cmbBotCommand, $GUI_ENABLE)
		GUICtrlSetState($cmbBotCond, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbBotCommand, $GUI_DISABLE)
		GUICtrlSetState($cmbBotCond, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBotStop
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
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	Local $stext = @CRLF & GetTranslated(640, 72, "If you locating your TH because you upgraded,") & @CRLF & _
			GetTranslated(640, 73, "then you must restart bot!!!") & @CRLF & @CRLF & _
			GetTranslated(640, 74, "Click OK to restart bot, ") & @CRLF & @CRLF & GetTranslated(640, 65, "Or Click Cancel to exit") & @CRLF
	Local $MsgBox = _ExtMsgBox(0, GetTranslated(640, 75, "Exit|Cancel"), GetTranslated(640, 76, "Close Bot Please!"), $stext, 120, $frmBot)
	If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_PURPLE)
	If $MsgBox = 1 Then
		Local $stext = @CRLF & GetTranslated(640, 77, "Are you 100% sure you want to restart bot ?") & @CRLF & @CRLF & _
				GetTranslated(640, 78, "Click OK to close bot and then restart the bot (manually)") & @CRLF & @CRLF & GetTranslated(640, 65, "Or Click Cancel to exit") & @CRLF
		Local $MsgBox = _ExtMsgBox(0, GetTranslated(640, 75, -1), GetTranslated(640, 76, -1), $stext, 120, $frmBot)
		If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_PURPLE)
		If $MsgBox = 1 Then
			Local $BotProcess = WinGetProcess($frmBot)
			If $DebugSetlog = 1 Then Setlog("$BotProcess= " & $BotProcess, $COLOR_PURPLE)
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -PID " & $BotProcess, "", Default, @SW_HIDE)
			Setlog("Error closing bot, please use manual method!", $COLOR_RED)
		EndIf
	EndIf
	$RunState = False
EndFunc   ;==>btnLocateTownHall



Func btnResetBuilding()
	$RunState = True
	While 1
		If _Sleep(500) Then Return ; add small delay before display message window
		If FileExists($building) Then ; Check for building.ini file first
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
			Local $stext = @CRLF & GetTranslated(640, 63, "Click OK to Delete and Reset all Building info,") & @CRLF & @CRLF & _
					GetTranslated(640, 64, "NOTE =>> Bot will exit and need to be restarted when complete") & @CRLF & @CRLF & GetTranslated(640, 65, "Or Click Cancel to exit") & @CRLF
			Local $MsgBox = _ExtMsgBox(0, GetTranslated(640, 66, "Delete And Exit|Cancel"), GetTranslated(640, 67, "Delete Building Infomation ?"), $stext, 120, $frmBot)
			If $DebugSetlog = 1 Then Setlog("$MsgBox= " & $MsgBox, $COLOR_PURPLE)
			If $MsgBox = 1 Then
				Local $stext = @CRLF & GetTranslated(640, 68, "Are you 100% sure you want to delete Building information ?") & @CRLF & @CRLF & _
						GetTranslated(640, 69, "Click OK to Delete and then restart the bot (manually)") & @CRLF & @CRLF & GetTranslated(640, 65, "Or Click Cancel to exit") & @CRLF
				Local $MsgBox = _ExtMsgBox(0, GetTranslated(640, 66, "Delete And Exit|Cancel"), GetTranslated(640, 67, "Delete Building Infomation ?"), $stext, 120, $frmBot)
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

Func btnLab()
	$RunState = True
	While 1
		ZoomOut()
		LocateLab()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLab

Func chkTrophyAtkDead()
	If GUICtrlRead($chkTrophyAtkDead) = $GUI_CHECKED Then
		$ichkTrophyAtkDead = 1
		GUICtrlSetState($txtDTArmyMin, $GUI_ENABLE)
		GUICtrlSetState($lblDTArmyMin, $GUI_ENABLE)
		GUICtrlSetState($lblDTArmypercent, $GUI_ENABLE)
	Else
		$ichkTrophyAtkDead = 0
		GUICtrlSetState($txtDTArmyMin, $GUI_DISABLE)
		GUICtrlSetState($lblDTArmyMin, $GUI_DISABLE)
		GUICtrlSetState($lblDTArmypercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyAtkDead

Func chkTrophyRange()
	If GUICtrlRead($chkTrophyRange) = $GUI_CHECKED Then
		GUICtrlSetState($txtdropTrophy, $GUI_ENABLE)
		GUICtrlSetState($txtMaxTrophy, $GUI_ENABLE)
		GUICtrlSetState($chkTrophyHeroes, $GUI_ENABLE)
		GUICtrlSetState($chkTrophyAtkDead, $GUI_ENABLE)
		chkTrophyAtkDead()
	Else
		GUICtrlSetState($txtdropTrophy, $GUI_DISABLE)
		GUICtrlSetState($txtMaxTrophy, $GUI_DISABLE)
		GUICtrlSetState($chkTrophyHeroes, $GUI_DISABLE)
		GUICtrlSetState($chkTrophyAtkDead, $GUI_DISABLE)
		GUICtrlSetState($txtDTArmyMin, $GUI_DISABLE)
		GUICtrlSetState($lblDTArmyMin, $GUI_DISABLE)
		GUICtrlSetState($lblDTArmypercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyRange
