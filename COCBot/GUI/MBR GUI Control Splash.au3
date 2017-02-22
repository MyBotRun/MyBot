; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Splash
; Description ...: This file contains utility functions to update the Splash Screen.
; Syntax ........: #include , Global
; Parameters ....:
; Return values .: None
; Author ........: mikemikemikecoc (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: SplashStep("Loading GUI...") Show the splash status
; ===============================================================================================================================
#include-once

Func SplashStep($status, $bIncreaseStep = True)
	If $bIncreaseStep = True Then $g_iSplashCurrentStep += 1

    SetDebugLog("SplashStep " & $g_iSplashCurrentStep & " of " & $g_iSplashTotalSteps & ": " & $status & "(" & Round(TimerDiff($g_hSplashTimer)/1000, 2) & " sec)")

	If $ichkDisableSplash = 1 Then Return
	GUICtrlSetData($g_hSplashProgress, ($g_iSplashCurrentStep / $g_iSplashTotalSteps) * 100)
	GUICtrlSetData($g_lSplashStatus, $status)
EndFunc   ;==>SplashStep

Func UpdateSplashTitle($title)
	SetDebugLog("UpdateSplashTitle: " & $title)
	If $ichkDisableSplash = 1 Then Return
	GUICtrlSetData($g_lSplashTitle, $title)
EndFunc   ;==>UpdateSplashTitle


Func DestroySplashScreen()
   If IsHWnd($g_hSplash) Then GUIDelete($g_hSplash)
EndFunc
