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
Func SplashStep($status)
   $iCurrentStep += 1
   If $ichkDisableSplash = 0 Then
    GUICtrlSetData($hSplashProgress, ($iCurrentStep / $iTotalSteps) * 100)
    GUICtrlSetData($lSplashStatus, $status)
   EndIf
EndFunc   ;==>SplashStep

Func UpdateSplashTitle($title)
    If $ichkDisableSplash = 0 Then
        GUICtrlSetData($lSplashTitle, $title)
    EndIf
EndFunc