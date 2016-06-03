
; #FUNCTION# ====================================================================================================================
; Name ..........: CloseCoC
; Description ...: Kill then restart CoC
; Syntax ........: CloseCoC($ReOpenCoC = False)
; Parameters ....:
; Return values .: None
; Author ........: The Master (2015)
; Modified ......: cosote (Dec 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CloseCoC($ReOpenCoC = False)
	ResumeAndroid()
	If Not $RunState Then Return

	Local $Adb = ""
	If $ReOpenCoC Then
		SetLog("Please wait for CoC restart......", $COLOR_RED) ; Let user know we need time...
	Else
		SetLog("Closing CoC......", $COLOR_RED) ; Let user know what we do...
	EndIf
	WinGetAndroidHandle()
	AndroidHomeButton()
	If Not $RunState Then Return
	SendAdbCommand("shell am force-stop " & $AndroidGamePackage)
	If Not $RunState Then Return
	If $ReOpenCoC Then
		OpenCoC()
		$Restart = True
	EndIf

EndFunc   ;==>CloseCoC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; #FUNCTION# ====================================================================================================================
; Name ..........: OpenCoC
; Description ...: Open Clash of clans
; Syntax ........: OpenCoC()
; Parameters ....:
; Return values .: None
; Author ........: The Master (2015)
; Modified ......: cosote (Dec 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenCoC()
	ResumeAndroid()
	If Not $RunState Then Return

	Local $RunApp = "", $iCount = 0
	WinGetAndroidHandle()
	AndroidHomeButton()
	If _Sleep(250) Then Return
	SendAdbCommand("shell am start -n " & $AndroidGamePackage & "/" & $AndroidGameClass)
	If Not $RunState Then Return
	While _CheckPixel($aIsMain, True) = False ; Wait for MainScreen
		$iCount += 1
		If _Sleep(100) Then Return
		If checkObstacles() Then $iCount += 1
		If $iCount > 250 Then ExitLoop
	WEnd

EndFunc   ;==>OpenCoC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; #FUNCTION# ====================================================================================================================
; Name ..........: WaitnOpenCoC
; Description ...: Waits for specified time before restarting Coc
; Syntax ........: WaitnOpenCoC($iWaitTime)
; Parameters ....: $iWaitTime           - Time to wait in milliseconds.
;					  ; $bFullRestart			 - Optional boolean flag if function needs to clean up mis windows after opening CoC
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......: TheMaster (2015), cosote (Dec 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func WaitnOpenCoC($iWaitTime, $bFullRestart = False)
	ResumeAndroid()
	If Not $RunState Then Return

	Local $RunApp = ""
	Local $sWaitTime = ""
	Local $iMin, $iSec, $iHour, $iWaitSec
	WinGetAndroidHandle()
	AndroidHomeButton()
	$iWaitSec = Round($iWaitTime / 1000)
	$iHour = Floor(Floor($iWaitSec / 60) / 60)
	$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
	$iSec = Floor(Mod($iWaitSec, 60))
	If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
	If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
	If $iSec > 0 Then $sWaitTime &= $iSec & " seconds "
	SetLog("Waiting " & $sWaitTime & "before starting CoC", $COLOR_GREEN)
	If _SleepStatus($iWaitTime) Then Return False ; Wait for server to see log off

	SendAdbCommand("shell am start -n " & $AndroidGamePackage & "/" & $AndroidGameClass)
	If Not $RunState Then Return

	If $debugSetlog = 1 Then setlog("CoC Restarted, Waiting for completion", $COLOR_PURPLE)

	If $bFullRestart = True Then
		checkMainScreen() ; Use checkMainScreen to restart CoC, and waitMainScreen to handle Take A Break wait, or other errors.
		$Restart = True
	Else
		waitMainScreen()
	EndIf

EndFunc   ;==>WaitnOpenCoC
