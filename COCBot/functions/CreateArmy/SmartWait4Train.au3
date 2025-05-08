; #FUNCTION# ====================================================================================================================
; Name ..........: SmartWait4Train
; Description ...: Will shutdown Android emulator & stop bot based on GUI configuration when waiting for troop training, spell cooking, or hero healing
; Syntax ........: SmartWait4Train()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (05-2016)
; Modified ......: MR.ViPER (10-2016), TheRevenor (10-2016), MR.ViPER (12-2016), CodeSlinger69 (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func SmartPause($iTestSeconds = Default)
	If Not $g_bRunState Then Return

	If Not $g_bCloseWhileTrainingEnable Then Return False ; Skip if not enabled

	Local $MinimumTimeClose = Random($g_iCloseMinimumTimeMin * 60, $g_iCloseMinimumTimeMax * 60, 1) ; Minimum time required to close
	If $g_bDebugSetLog Then SetDebugLog("$MinimumTimeClose = " & $MinimumTimeClose & "s", $COLOR_DEBUG)

	; Determine state of $StopEmulator flag
	Local $StopEmulator = False
	Local $bFullRestart = False
	Local $bSuspendComputer = False
	If $g_bCloseRandom Then $StopEmulator = "random"
	If $g_bCloseEmulator Then $StopEmulator = True
	If $g_bSuspendComputer Then $bSuspendComputer = True
	Local $iDelayToReCheck = 30 ; seconds

	If $g_aiAttackedCount - $g_aiAttackedCountPause >= $MaxConsecutiveAttacks Then
		$g_aiAttackedCountPause = $g_aiAttackedCount
		If $MaxConsecutiveAttacks = 1 Then
			SetLog("This account just had an attack.", $COLOR_ACTION)
		Else
			SetLog("This account just did " & $MaxConsecutiveAttacks & " attacks in a row.", $COLOR_ACTION)
		EndIf
		SetLog("Lets do a pause like an human !", $COLOR_INFO)
		SetLog("Smart Pause = " & StringFormat("%.2f", $MinimumTimeClose / 60) & " Minutes", $COLOR_INFO)
		UniversalCloseWaitOpenCoC($MinimumTimeClose * 1000, "PauseLikeHuman", $StopEmulator, $bFullRestart, $bSuspendComputer)
		$g_bRestart = True
		$MaxConsecutiveAttacks = Random($g_iAttackconsecutiveMin, $g_iAttackconsecutiveMax, 1)
		Return True
	EndIf

	If Not _DateIsValid($iBreakerLastTimeChecked) Then
		Local $RemainingAttacks = $MaxConsecutiveAttacks - ($g_aiAttackedCount - $g_aiAttackedCountPause)
		SetLog($RemainingAttacks & " attack" & ($RemainingAttacks > 1 ? "s" : "") & " remaining on this account before doing a break.", $COLOR_ACTION)
		$iBreakerLastTimeChecked = _NowCalc()
	Else
		Local $iLastCheck = _DateDiff('s', $iBreakerLastTimeChecked, _NowCalc()) ; elapse time from last check (seconds)
		If $iLastCheck > $iDelayToReCheck Then
			Local $RemainingAttacks = $MaxConsecutiveAttacks - ($g_aiAttackedCount - $g_aiAttackedCountPause)
			SetLog($RemainingAttacks & " attack" & ($RemainingAttacks > 1 ? "s" : "") & " remaining on this account before doing a break.", $COLOR_ACTION)
			$iBreakerLastTimeChecked = _NowCalc()
		EndIf
	EndIf

	Return False

EndFunc   ;==>SmartPause

