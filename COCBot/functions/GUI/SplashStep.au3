; #FUNCTION# ====================================================================================================================
; Name ..........: SplashStep
; Description ...: This file contains utility functions to update the Splash Screen.
; Syntax ........: #include , Global
; Parameters ....:
; Return values .: None
; Author ........: mikemikemikecoc (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: SplashStep("Loading GUI...") Show the splash status
; ===============================================================================================================================
Func SplashStep($status, $bIncreaseStep = True)
	If $bIncreaseStep = True Then $iCurrentStep += 1
	SetDebugLog("SplashStep " & $iCurrentStep & " of " & $iTotalSteps & ": " & $status)
	If $ichkDisableSplash = 1 Then Return
	GUICtrlSetData($hSplashProgress, ($iCurrentStep / $iTotalSteps) * 100)
	GUICtrlSetData($lSplashStatus, $status)
EndFunc   ;==>SplashStep

Func UpdateSplashTitle($title)
	SetDebugLog("UpdateSplashTitle: " & $title)
	If $ichkDisableSplash = 1 Then Return
	GUICtrlSetData($lSplashTitle, $title)
EndFunc   ;==>UpdateSplashTitle
