; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Splash
; Description ...: This file contains utility functions to update the Splash Screen.
; Syntax ........: #include , Global
; Parameters ....:
; Return values .: None
; Author ........: mikemikemikecoc (2016)
; Modified ......: CodeSlinger69 (2017), MonkeyHunter (05-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: SplashStep("Loading GUI...") Show the splash status
; ===============================================================================================================================
#include-once

Func SplashStep($status, $bIncreaseStep = True)
	If $bIncreaseStep = True Then $g_iSplashCurrentStep += 1

	SetDebugLog("SplashStep " & $g_iSplashCurrentStep & " of " & $g_iSplashTotalSteps & ": " & $status & "(" & Round(__TimerDiff($g_hSplashTimer) / 1000, 2) & " sec)")

	If $g_bDisableSplash Then Return

	GUICtrlSetData($g_hSplashProgress, ($g_iSplashCurrentStep / $g_iSplashTotalSteps) * 100)
	GUICtrlSetData($g_lSplashStatus, $status)

	If $g_bMyBotDance Then ; can robot dance? Yes, like a drunk Code Monkey
		Static $aSplashInfo, $iStartX, $iStartY, $iStep, $iStepIndex = 0
		If $iStepIndex = 0 Then
			$aSplashInfo = WinGetPos($g_hSplash) ; grab current position and size information
			If @error Then SetLog("SplashStep " & $g_iSplashCurrentStep & " Failed to find GUI Window!", $COLOR_ERROR)
			; $aSplashInfo[0] = X position, [1] = Y position, [2] = Width, [3] = Height
			$iStartY = Int(@DesktopHeight - 50 - $aSplashInfo[3]) ; compute starting Y position just above bottom of display
			$iStartX = Int((@DesktopWidth / 2) - ($aSplashInfo[2] / 2)) ; compute starting X position in middle of display
			$iStep = Int($iStartY / ($g_iSplashTotalSteps - 1))
			;SetDebugLog("SplashStep " & $g_iSplashCurrentStep & " X:Y= " & $aSplashInfo[0] & ":" & $aSplashInfo[1] & ", W:H= " & $aSplashInfo[2] & ":" & $aSplashInfo[3], $COLOR_DEBUG)
			;SetDebugLog("$iStartX= " & $iStartX & ", $iStartY= " & $iStartY & ", $iStep= " & $iStep, $COLOR_DEBUG)
		EndIf
		; bottom to top with little shuffle added
		Local $aSplashLoc[10][2] = [[-100, 0], [100, $iStep], [-100, $iStep * 2], [100, $iStep * 3], [-100, $iStep * 4], [100, $iStep * 5], [-100, $iStep * 6], [100, $iStep * 7], [-100, $iStep * 8], [0, $iStep * 9]]

		;SetDebugLog("SplashStep " & $g_iSplashCurrentStep & " Location: " & $iStartX - $aSplashLoc[$iStepIndex][0] & ":" & $iStartY - $aSplashLoc[$iStepIndex][1] & ", $iStepIndex= " & $iStepIndex, $COLOR_DEBUG)
		WinMove($g_hSplash, "", $iStartX - $aSplashLoc[$iStepIndex][0], $iStartY - $aSplashLoc[$iStepIndex][1], Default, Default, 8)
		$iStepIndex += 1
		If $iStepIndex > 9 Then $iStepIndex = 0 ; reset to zero when at top
	EndIf

EndFunc   ;==>SplashStep

Func UpdateSplashTitle($title)
	SetDebugLog("UpdateSplashTitle: " & $title)
	If $g_bDisableSplash Then Return
	GUICtrlSetData($g_lSplashTitle, $title)
EndFunc   ;==>UpdateSplashTitle

Func DestroySplashScreen()
	If IsHWnd($g_hSplash) Then GUIDelete($g_hSplash)
	; allow now other bots to launch
	ReleaseMutex($g_hSplashMutex)
	$g_hSplashMutex = 0
EndFunc   ;==>DestroySplashScreen

Func MoveSplashScreen()
	_WinAPI_PostMessage($g_hSplash, $WM_SYSCOMMAND, 0xF012, 0) ; SC_DRAGMOVE = 0xF012
EndFunc   ;==>MoveSplashScreen
