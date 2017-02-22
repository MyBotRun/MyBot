
; #FUNCTION# ====================================================================================================================
; Name ..........: chkShieldStatus
; Description ...: Reads Shield & Personal Break time to update global values for user management of Personal Break
; Syntax ........: chkShieldStatus([$bForceChkShield = False[, $bForceChkPBT = False]])
; Parameters ....: $bForceChkShield     - [optional] a boolean value. Default is False.
; ...............; $bForceChkPBT        - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: MonkeyHunter (2016-02)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func chkShieldStatus($bChkShield = True, $bForceChkPBT = False)

	; skip shield data collection if force single PB, wait for shield, or close while training not enabled, or window is not on main base
	If ($ichkSinglePBTForced = 0 And ($g_bChkBotStop = True And $g_iCmbBotCond >= 19) = False) And $g_bCloseWhileTrainingEnable = False Or Not (IsMainPage()) Then Return

	Local $Result, $iTimeTillPBTstartSec, $ichkTime = 0, $ichkSTime = 0, $ichkPBTime = 0

	If $bChkShield Or $aShieldStatus[0] = "" Or $aShieldStatus[1] = "" Or $aShieldStatus[2] = "" Or $sPBStartTime = "" Or $g_bGForcePBTUpdate = True Then ; almost always get shield information

		$Result = getShieldInfo() ; get expire time of shield

		If @error Then Setlog("chkShieldStatus Shield OCR error= " & @error & "Extended= " & @extended, $COLOR_ERROR)
		If _Sleep($iDelayRespond) Then Return

		If IsArray($Result) Then
		    Local $iShieldExp = _DateDiff('n', $Result[2], _NowCalc())
			If Abs($iShieldExp) > 0 Then
			   Local $sFormattedDiff = _Date_Difference(_NowCalc(), $Result[2], 4)
			   Setlog("Shield expires in: " & $sFormattedDiff)
			Else
			   Setlog("Shield has expired")
			EndIf

			If _DateIsValid($aShieldStatus[2]) Then ; if existing global shield time is valid
				$ichkTime = Abs(Int(_DateDiff('s', $aShieldStatus[2], $Result[2]))) ; compare old and new time
				If $ichkTime > 60 Then ; test if more than 60 seconds different in case of attack while shield has reduced time
					$bForceChkPBT = True ; update PB time
					If $g_iDebugSetlog = 1 Then Setlog("Shield time changed: " & $ichkTime & " Sec, Force PBT OCR: " & $bForceChkPBT, $COLOR_WARNING)
				EndIf
			EndIf

			$aShieldStatus = $Result ; update ShieldStatus global values

			If $g_bChkBotStop = True And $g_iCmbBotCond >= 19 Then ; is Halt mode enabled and With Shield selected?
				If $aShieldStatus[0] = "shield" Then ; verify shield
					Setlog("Shield found, Halt Attack Now!", $COLOR_INFO)
					$g_bWaitShield = True
					$Is_ClientSyncError = False ; cancel OOS restart to enable BotCommand to process Halt mode
					$Is_SearchLimit = False ; reset search limit flag to enable BotCommand to process Halt mode
				Else
					$g_bWaitShield = False
					If $g_bMeetCondStop = True Then
						Setlog("Shield expired, resume attacking", $COLOR_INFO)
						$bTrainEnabled = True
						$bDonationEnabled = True
						$g_bMeetCondStop = False
					Else
						If $g_iDebugSetlog = 1 Then Setlog("Halt With Shield: Shield not found...", $COLOR_DEBUG)
					EndIf
				EndIf
			EndIf
		Else
			If $g_iDebugSetlog = 1 Then Setlog("Bad getShieldInfo() return value: " & $Result, $COLOR_ERROR)
			If _Sleep($iDelayRespond) Then Return

			For $i = 0 To UBound($aShieldStatus) - 1 ; clear global shieldstatus if no shield data returned
				$aShieldStatus[$i] = ""
			Next

		EndIf
	EndIf

	If $ichkSinglePBTForced = 0 Then Return ; return if force single PB feature not enabled.

	If _DateIsValid($sPBStartTime) Then
		$ichkPBTime = Int(_DateDiff('s', $sPBStartTime, _NowCalc())) ; compare existing shield date/time to now.
		If $ichkPBTime >= 295 Then
			$bForceChkPBT = True ; test if PBT date/time in more than 5 minutes past, force update
			If $g_iDebugSetlog = 1 Then Setlog("Found old PB time= " & $ichkPBTime & " Seconds, Force update:" & $bForceChkPBT, $COLOR_WARNING)
		EndIf
	EndIf

	If $bForceChkPBT Or $g_bGForcePBTUpdate Or $sPBStartTime = "" Then

		$g_bGForcePBTUpdate = False  ; Reset global flag to force PB update

		$Result = getPBTime() ; Get time in future that PBT starts

		If @error Then Setlog("chkShieldStatus getPBTime OCR error= " & @error & ", Extended= " & @extended, $COLOR_ERROR)
		;If $g_iDebugSetlog = 1 Then Setlog("getPBTime() returned: " & $Result, $COLOR_DEBUG)
		If _Sleep($iDelayRespond) Then Return

		If _DateIsValid($Result) Then
			Local $iTimeTillPBTstartMin = Int(_DateDiff('n', $Result, _NowCalc())) ; time in minutes

			If Abs($iTimeTillPBTstartMin) > 0 Then
			   Local $sFormattedDiff = _Date_Difference(_DateAdd("n",-1,_NowCalc()), $Result, 4)
			   Setlog("Personal Break starts in: " & $sFormattedDiff)
			EndIf

			If $iTimeTillPBTstartMin < -(Int($iValuePBTimeForcedExit)) Then
				$sPBStartTime = _DateAdd('n', -(Int($iValuePBTimeForcedExit)), $Result) ; subtract GUI time setting from PB start time to set early forced break time
			ElseIf $iTimeTillPBTstartMin < 0 Then ; Might have missed it if less 15 min, but try anyway
				$sPBStartTime = $Result
			Else
				$sPBStartTime = "" ; clear value, can not log off ealy.
			EndIf
			If $g_iDebugSetlog = 1 Then Setlog("Early Log Off time=" & $sPBStartTime & ", In " & _DateDiff('n', $sPBStartTime, _NowCalc()) & " Minutes", $COLOR_DEBUG)
		Else
			Setlog("Bad getPBTtime() return value: " & $Result, $COLOR_ERROR)
			$sPBStartTime = "" ; reset to force update next pass
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
        $sStartDate = _DateAdd($aUnit[$i], $iUnit, $sStartDate)
    Next

    Return $sReturn
EndFunc