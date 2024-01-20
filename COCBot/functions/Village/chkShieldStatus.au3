
; #FUNCTION# ====================================================================================================================
; Name ..........: chkShieldStatus
; Description ...: Reads Shield & Personal Break time to update global values for user management of Personal Break
; Syntax ........: chkShieldStatus([$bForceChkShield = False)
; Parameters ....: $bForceChkShield     - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: MonkeyHunter (2016-02)
; Modified ......: Moebius14 (2023-07)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func chkShieldStatus($bChkShield = True)

	; skip shield data collection if wait for shield, or close while training not enabled, or window is not on main base
	Local $bHaltModeWithShield = $g_bChkBotStop And $g_iCmbBotCond >= 19 And $g_iCmbBotCond <= 21
	If Not $bHaltModeWithShield And Not $g_bCloseWhileTrainingEnable Or Not (IsMainPage()) Then Return

	Local $Result

	If $bChkShield Or $g_asShieldStatus[0] = "" Or $g_asShieldStatus[1] = "" Or $g_asShieldStatus[2] = "" Then ; almost always get shield information

		$Result = getShieldInfo() ; get expire time of shield

		If @error Then SetLog("chkShieldStatus Shield OCR error= " & @error & "Extended= " & @extended, $COLOR_ERROR)
		If _Sleep($DELAYRESPOND) Then Return

		If IsArray($Result) Then
			Local $iShieldExp = _DateDiff('n', $Result[2], _NowCalc())
			If Abs($iShieldExp) > 0 Then
				Local $sFormattedDiff = _Date_Difference(_NowCalc(), $Result[2], 4)
				SetLog("Shield expires in: " & $sFormattedDiff)
			Else
				SetLog("Shield has expired")
			EndIf

			$g_asShieldStatus = $Result ; update ShieldStatus global values

			If $bHaltModeWithShield Then ; is Halt mode enabled and With Shield selected?
				If $g_asShieldStatus[0] = "shield" Then ; verify shield
					SetLog("Shield found, Halt Attack Now!", $COLOR_INFO)
					$g_bWaitShield = True
					$g_bIsClientSyncError = False ; cancel OOS restart to enable BotCommand to process Halt mode
					$g_bIsSearchLimit = False ; reset search limit flag to enable BotCommand to process Halt mode
				Else
					$g_bWaitShield = False
					If $g_bMeetCondStop = True Then
						SetLog("Shield expired, resume attacking", $COLOR_INFO)
						$g_bTrainEnabled = True
						$g_bDonationEnabled = True
						$g_bMeetCondStop = False
					Else
						SetDebugLog("Halt With Shield: Shield not found...", $COLOR_DEBUG)
					EndIf
				EndIf
			EndIf
		Else
			SetDebugLog("Bad getShieldInfo() return value: " & $Result, $COLOR_ERROR)
			If _Sleep($DELAYRESPOND) Then Return

			For $i = 0 To UBound($g_asShieldStatus) - 1 ; clear global shieldstatus if no shield data returned
				$g_asShieldStatus[$i] = ""
			Next

		EndIf
	EndIf

	If checkObstacles() Then checkMainScreen(False) ; Check for screen errors

EndFunc   ;==>chkShieldStatus

; Returns formatted difference between two dates
; $iGrain from 0 To 5, to control level of detail that is returned
Func _Date_Difference($sStartDate, Const $sEndDate, Const $iGrain)
	Local $aUnit[6] = ["Y", "M", "D", "h", "n", "s"]
	Local $aType[6] = ["year", "month", "day", "hour", "minute", "second"]
	Local $sReturn = "", $iUnit

	For $i = 0 To $iGrain
		$iUnit = _DateDiff($aUnit[$i], $sStartDate, $sEndDate)
		If $iUnit <> 0 Then
			$sReturn &= $iUnit & " " & $aType[$i] & ($iUnit > 1 ? "s" : "") & " "
		EndIf
		$sStartDate = _DateAdd($aUnit[$i], Int($iUnit), $sStartDate)
	Next

	Return $sReturn
EndFunc   ;==>_Date_Difference