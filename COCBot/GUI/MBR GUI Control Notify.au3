;#FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Notify
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



Func chkPBTGenabled()
	If GUICtrlRead($chkNotifyPBEnabled) = $GUI_CHECKED Then
		$NotifyPBEnabled = 1
		GUICtrlSetState($txbNotifyPBToken, $GUI_ENABLE)
		GUICtrlSetState($btnNotifyDeleteMessages, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyDeleteAllPBPushes, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyDeleteOldPBPushes, $GUI_ENABLE)
		GUICtrlSetState($btnNotifyDeleteMessages, $GUI_ENABLE)
		If $NotifyDeletePushesOlderThan = 1 Then
			GUICtrlSetState($cmbNotifyPushHours, $GUI_ENABLE)
		Else
			GUICtrlSetState($cmbNotifyPushHours, $GUI_DISABLE)
		EndIf
	Else
		$NotifyPBEnabled = 0
		GUICtrlSetState($chkTGenabled, $GUI_ENABLE)
		GUICtrlSetState($txbNotifyPBToken, $GUI_DISABLE)
		GUICtrlSetState($btnNotifyDeleteMessages, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyDeleteAllPBPushes, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyDeleteOldPBPushes, $GUI_ENABLE)
		GUICtrlSetState($btnNotifyDeleteMessages, $GUI_ENABLE)
		GUICtrlSetState($cmbNotifyPushHours, $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkTGenabled) = $GUI_CHECKED Then
		$NotifyTGEnabled = 1
		GUICtrlSetState($txbNotifyTGToken, $GUI_ENABLE)
	Else
		$NotifyTGEnabled = 0
		GUICtrlSetState($txbNotifyTGToken, $GUI_DISABLE)
	EndIf

	If $NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1 Then
		GUICtrlSetState($chkNotifyRemote, $GUI_ENABLE)
		GUICtrlSetState($txbNotifyOrigin, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertMatchFound, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertLastRaidIMG, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertUpgradeWall, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertLastRaidTXT, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertOutOfSync, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertTakeBreak, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertVillageStats, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertLastAttack, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertAnotherDevice, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertCampFull, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertBuilderIdle, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertMaintenance, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyAlertBAN, $GUI_ENABLE)
		GUICtrlSetState($chkNotifyBOTUpdate, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkNotifyRemote, $GUI_DISABLE)
		GUICtrlSetState($txbNotifyOrigin, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertMatchFound, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertLastRaidIMG, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertUpgradeWall, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertLastRaidTXT, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertOutOfSync, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertTakeBreak, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertVillageStats, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertLastAttack, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertAnotherDevice, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertCampFull, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertBuilderIdle, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertMaintenance, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyAlertBAN, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyBOTUpdate, $GUI_DISABLE)
		GUICtrlSetState($cmbNotifyPushHours, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyDeleteAllPBPushes, $GUI_DISABLE)
		GUICtrlSetState($chkNotifyDeleteOldPBPushes, $GUI_DISABLE)
		GUICtrlSetState($btnNotifyDeleteMessages, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkPBTGenabled

Func chkDeleteOldPBPushes()
	If GUICtrlRead($chkNotifyDeleteOldPBPushes) = $GUI_CHECKED Then
		$NotifyDeletePushesOlderThan = 1
		If $NotifyPBEnabled Then GUICtrlSetState($cmbNotifyPushHours, $GUI_ENABLE)
	Else
		$NotifyDeletePushesOlderThan = 0
		GUICtrlSetState($cmbNotifyPushHours, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDeleteOldPBPushes

Func btnDeletePBMessages()
	$NotifyDeleteAllPushesNow = True
EndFunc   ;==>btnDeletePBMessages

Func NotifyHelp()
	If FileExists(@ScriptDir & "\Help\NotifyHelp_" & $sLanguage & ".mht") Then
		ShellExecute(@ScriptDir & "\Help\NotifyHelp_" & $sLanguage & ".mht")
	ElseIf FileExists(@ScriptDir & "\Help\NotifyHelp_English.mht") Then
		ShellExecute(@ScriptDir & "\Help\NotifyHelp_English.mht")
	EndIf
EndFunc	;==>NotifyHelp


; Restart Bot
Func _Restart()
	SetDebugLog("Restart " & $sBotTitle)
	Local $sCmdLine = ProcessGetCommandLine(@AutoItPID)
	If @error <> 0 Then
		SetLog("Cannot prepare to restart " & $sBotTitle & ", error code " & @error, $COLOR_RED)
		Return SetError(1, 0, 0)
	EndIf
	IniWrite($config, "general", "Restarted", 1)

	; add restart option (if not already there)
	If StringRight($sCmdLine, 9) <> " /Restart" Then
		$sCmdLine &= " /Restart"
	EndIf

	; Restart My Bot
	Local $pid = Run("cmd.exe /c start """" " & $sCmdLine, $WorkingDir, @SW_HIDE) ; cmd.exe only used to support launched like "..\AutoIt3\autoit3.exe" from console
	If @error = 0 Then
		CloseAndroid("_Restart")
		SetLog("Restarting " & $sBotTitle)
		; Wait 1 Minute to get closed
		_SleepStatus(60 * 1000)
	Else
		SetLog("Cannot restart " & $sBotTitle, $COLOR_RED)
	EndIf

	Return SetError(2, 0, 0)
EndFunc   ;==>_Restart

Func chkNotifyHours()
	If GUICtrlRead($chkNotifyHours) = $GUI_CHECKED Then
		For $i = $lbNotifyHours1 To $lbNotifyHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		GUICtrlSetState($chkNotifyWeekDays, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkNotifyWeekDays, $GUI_UNCHECKED)
		For $i = $lbNotifyHours1 To $lbNotifyHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetState($chkNotifyWeekDays, $GUI_UNCHECKED)
		GUICtrlSetState($chkNotifyWeekDays, $GUI_DISABLE)
		chkNotifyWeekDays()
	EndIf
EndFunc   ;==>chkNotifyHours

Func chkNotifyhoursE1()
	If GUICtrlRead($chkNotifyhoursE1) = $GUI_CHECKED And GUICtrlRead($chkNotifyhours0) = $GUI_CHECKED Then
		For $i = $chkNotifyhours0 To $chkNotifyhours11
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkNotifyhours0 To $chkNotifyhours11
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkNotifyhoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkNotifyhoursE1

Func chkNotifyhoursE2()
	If GUICtrlRead($chkNotifyhoursE2) = $GUI_CHECKED And GUICtrlRead($chkNotifyhours12) = $GUI_CHECKED Then
		For $i = $chkNotifyhours12 To $chkNotifyhours23
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkNotifyhours12 To $chkNotifyhours23
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkNotifyhoursE2, $GUI_UNCHECKED)
EndFunc		;==>chkNotifyhoursE2

Func chkNotifyWeekDays()

	If GUICtrlRead($chkNotifyWeekDays) = $GUI_CHECKED Then
		For $i = $chkNotifyWeekdays0 To $chkNotifyWeekdays6
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		For $i = $lbNotifyWeekdays0 To $lbNotifyWeekdays6
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $chkNotifyWeekdays0 To $chkNotifyWeekdays6
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = $lbNotifyWeekdays0 To $lbNotifyWeekdays6
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

EndFunc	;==>chkNotifyWeekDays


