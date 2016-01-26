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

Func PushBulletRemoteControl()
	If $pEnabled And $pRemote Then _RemoteControl()
EndFunc   ;==>PushBulletRemoteControl

Func PushBulletDeleteOldPushes()
	If $pEnabled = 1 And $ichkDeleteOldPushes = 1 Then _DeleteOldPushes() ; check every 30 min if must to delete old pushbullet messages, increase delay time for anti ban pushbullet
EndFunc   ;==>PushBulletDeleteOldPushes

Func chkPBenabled()
	If GUICtrlRead($chkPBenabled) = $GUI_CHECKED Then
		$pEnabled = 1
		GUICtrlSetState($chkPBRemote, $GUI_ENABLE)
		GUICtrlSetState($PushBTokenValue, $GUI_ENABLE)
		GUICtrlSetState($OrigPushB, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBVMFound, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBLastRaid, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBWallUpgrade, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBLastRaidTxt, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBOOS, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBVBreak, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBVillage, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBLastAttack, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBOtherDevice, $GUI_ENABLE)
		GUICtrlSetState($chkDeleteAllPushes, $GUI_ENABLE)
		GUICtrlSetState($chkDeleteOldPushes, $GUI_ENABLE)
		GUICtrlSetState($btnDeletePBmessages, $GUI_ENABLE)
		GUICtrlSetState($chkAlertPBCampFull, $GUI_ENABLE)

		If $ichkDeleteOldPushes = 1 Then
			GUICtrlSetState($cmbHoursPushBullet, $GUI_ENABLE)
		EndIf
	Else
		$pEnabled = 0
		GUICtrlSetState($chkPBRemote, $GUI_DISABLE)
		GUICtrlSetState($PushBTokenValue, $GUI_DISABLE)
		GUICtrlSetState($OrigPushB, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBVMFound, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBLastRaid, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBWallUpgrade, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBLastRaidTxt, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBOOS, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBVBreak, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBVillage, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBLastAttack, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBOtherDevice, $GUI_DISABLE)
		GUICtrlSetState($chkDeleteAllPushes, $GUI_DISABLE)
		GUICtrlSetState($chkDeleteOldPushes, $GUI_DISABLE)
		GUICtrlSetState($btnDeletePBmessages, $GUI_DISABLE)
		GUICtrlSetState($chkAlertPBCampFull, $GUI_DISABLE)

		GUICtrlSetState($cmbHoursPushBullet, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkPBenabled

Func chkDeleteOldPushes()
	If GUICtrlRead($chkDeleteOldPushes) = $GUI_CHECKED Then
		$ichkDeleteOldPushes = 1
		If $pEnabled Then GUICtrlSetState($cmbHoursPushBullet, $GUI_ENABLE)
	Else
		$ichkDeleteOldPushes = 0
		GUICtrlSetState($cmbHoursPushBullet, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDeleteOldPushes

Func btnDeletePBMessages()
	$iDeleteAllPushesNow = True
EndFunc   ;==>btnDeletePBMessages

; Script by wewawe, renamed&disabled by Cosote 2016-01
Func _Restart_()
	Local $sCmdFile
	FileDelete(@TempDir & "restart.bat")
	$sCmdFile = 'tasklist /FI "IMAGENAME eq ' & @ScriptFullPath & '" | find /i "' & @ScriptFullPath & '"' & @CRLF _
			 & 'IF ERRORLEVEL 1 GOTO LAUNCHPROGRAM' & @CRLF _
			 & ' :LAUNCHPROGRAM ' & @CRLF _
			 & ' start "" "' & @ScriptFullPath & '" ' & @CRLF _
			 & 'call :deleteSelf&exit /b ' & @CRLF _
			 & ':deleteSelf ' & @CRLF _
			 & 'start /b "" cmd /c del "%~f0"&exit /b'
	FileWrite(@TempDir & "restart.bat", $sCmdFile)
	IniWrite($config, "general", "Restarted", 1)
	Run(@TempDir & "restart.bat", @TempDir, @SW_HIDE)
	CloseAndroid()
	BotClose()
 EndFunc   ;==>_Restart_

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
	   CloseAndroid()
	   SetLog("Restarting " & $sBotTitle)
	   ; Wait 1 Minute to get closed
	   _SleepStatus(60 * 1000)
    Else
	   SetLog("Cannot restart " & $sBotTitle, $COLOR_RED)
    EndIf

	Return SetError(2, 0, 0)
EndFunc   ;==>_Restart

