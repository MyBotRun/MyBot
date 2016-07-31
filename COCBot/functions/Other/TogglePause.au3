
; #FUNCTION# ====================================================================================================================
; Name ..........: TogglePause
; Description ...:
; Syntax ........: TogglePause()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;If $OnlyInstance Then HotKeySet("{PAUSE}", "TogglePause")

Func TogglePause()
	TogglePauseImpl("Button")
EndFunc   ;==>TogglePause

Func TogglePauseImpl($Source)
	ResumeAndroid()
	SetRedrawBotWindow(True)
	Local $BlockInputPausePrev
	$TPaused = Not $TPaused
	If $TPaused And $Runstate = True Then
		AndroidShield("TogglePauseImpl paused", False)
		TrayTip($sBotTitle, "", 1)
		TrayTip($sBotTitle, "was Paused!", 1, $TIP_ICONEXCLAMATION)
		Setlog("Bot was Paused!", $COLOR_RED)
		If Not $bSearchMode Then
			$iTimePassed += Int(TimerDiff($sTimer))
			AdlibUnRegister("SetTime")
		EndIf
		PushMsg("Pause", $Source)
		;If $BlockInputPause > 0 Then $BlockInputPausePrev = $BlockInputPause
		;If $BlockInputPause > 0 Then _BlockInputEx(0, "", "", $HWnD)
		GUICtrlSetState($btnPause, $GUI_HIDE)
		GUICtrlSetState($btnResume, $GUI_SHOW)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_ENABLE)
	ElseIf $TPaused = False And $Runstate = True Then
		AndroidShield("TogglePauseImpl resumed")
		TrayTip($sBotTitle, "", 1)
		TrayTip($sBotTitle, "was Resumed.", 1, $TIP_ICONASTERISK)
		Setlog("Bot was Resumed.", $COLOR_GREEN)
		If Not $bSearchMode Then
			$sTimer = TimerInit()
			AdlibRegister("SetTime", 1000)
		EndIf
		PushMsg("Resume", $Source)
		;If $BlockInputPausePrev > 0 Then _BlockInputEx($BlockInputPausePrev, "", "", $HWnD)
		;If $BlockInputPausePrev > 0 Then $BlockInputPausePrev = 0
		GUICtrlSetState($btnPause, $GUI_SHOW)
		GUICtrlSetState($btnResume, $GUI_HIDE)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_DISABLE)
		;ZoomOut()
	EndIf
	Local $counter = 0
	While $TPaused ; Actual Pause loop
		If _Sleep($iDelayTogglePause1) Then ExitLoop
		$counter = $counter + 1
		If $PushBulletEnabled = 1 And $pRemote = 1 And $counter = 200 Then
			_RemoteControl()
			$counter = 0
		EndIf
	WEnd
	; everything below this WEnd is executed when unpaused!
	;ZoomOut() ; moved to resume
	If _Sleep($iDelayTogglePause2) Then Return
EndFunc   ;==>TogglePauseImpl
