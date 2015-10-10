
; #FUNCTION# ====================================================================================================================
; Name ..........: WaitnOpenCoC
; Description ...: Waits for specified time before restarting Coc
; Syntax ........: WaitnOpenCoC($iWaitTime)
; Parameters ....: $iWaitTime           - Time to wait in milliseconds.
;					  ; $bFullRestart			 - Optional boolean flag if function needs to clean up mis windows after opening CoC
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func WaitnOpenCoC($iWaitTime, $bFullRestart = False)

	SetLog("Waiting " & $iWaitTime / 1000 & " seconds before starting CoC", $COLOR_GREEN)
	If _SleepStatus($iWaitTime) Then Return False ; Wait for server to see log off

	$HWnD = WinGetHandle($Title)
	If _Sleep($iDelayWaitnOpenCoC500) Then Return
	WinActivate($HWnD) ; ensure bot has window focus
	If _Sleep($iDelayWaitnOpenCoC500) Then Return
	PureClick(126, 700, 2, 500, "#0126") ; click on BS home button twice to clear error and go home.
	If _Sleep($iDelayWaitnOpenCoC500) Then Return
	Local $RunApp = StringReplace(_WinAPI_GetProcessFileName(WinGetProcess($Title)), "Frontend", "RunApp")
	Run($RunApp & " Android com.supercell.clashofclans com.supercell.clashofclans.GameApp")
	If $debugSetlog = 1 Then setlog("CoC Restarted, Waiting for completion", $COLOR_PURPLE)
	If _SleepStatus($iDelayWaitnOpenCoC25000) Then Return ; Wait 25 seconds for CoC restart

	If $bFullRestart = True Then
		checkMainScreen() ; Use checkMainScreen to restart CoC, and waitMainScreen to handle Take A Break wait, or other errors.
		If _Sleep($iDelayWaitnOpenCoC1000) Then Return
	EndIf

EndFunc   ;==>WaitnOpenCoC
