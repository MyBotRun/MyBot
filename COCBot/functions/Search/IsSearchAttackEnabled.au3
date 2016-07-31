; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchAttackEnabled
; Description ...: Determines if user has selected to not attack.  Uses GUI schedule, random time, or daily attack limit options to stop attacking
; Syntax ........: IsSearchAttackEnabled()
; Parameters ....:
; Return values .: True = attacking is enabled, False = if attacking is disabled
;					 .; Will return error code if problem determining random no attack time.
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func IsSearchAttackEnabled()

	If $debugsetlog = 1 Then Setlog("Begin IsSearchAttackScheduled:", $COLOR_PURPLE)

	If $ichkAttackPlannerEnable = 0 Then Return True ; return true if attack planner is not enabled

	Local $sStartTime = "", $sEndTime = ""
	Local $aNoAttackTimes[2] = [$sStartTime, $sEndTime] ; array to hold start/end time for when attacking is disabled.
	Local $iWaitTime = 0

	Local $bCloseGame = $ichkAttackPlannerCloseCoC = 1 Or $ichkAttackPlannerCloseAll = 1 ; flag summary for closing game from GUI values
	If $debugsetlog = 1 Then Setlog("$bCloseGame:" & $bCloseGame, $COLOR_PURPLE)

	If $ichkAttackPlannerDayLimit = 1 And _OverAttackLimit() Then  ; check daily attack limit before checking schedule
		Setlog("Daily attack limit reached, skip attacks till new day starts!", $COLOR_BLUE)
		If _Sleep($iDelayRespond) Then Return True
		If $bCloseGame Then
			$iWaitTime = _getTimeRemainTimeToday() ; get seconds left in day till Midnight
			UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $ichkAttackPlannerCloseAll, True) ; Close and Wait for attacking to start
			$Restart = True
			Return
		Else
			Return False
		EndIf
	EndIf

	If $ichkAttackPlannerRandom = 1 Then ; random attack start/stop selected
		$aNoAttackTimes = _getDailyRandomStartEnd($icmbAttackPlannerRandom) ; determine hours to start/end attack today
		If @error Then ; log extended error message and return false to keep attacking if something strange happens
			Setlog(@extended, $COLOR_RED)
			Return True
		EndIf
		If _IsTimeInRange($aNoAttackTimes[0], $aNoAttackTimes[1]) Then ; returns true if time now is between start/end time
			Setlog("Attack schedule random skip time found....", $COLOR_BLUE)
			If _Sleep($iDelayRespond) Then Return True
			If $bCloseGame Then
				$iWaitTime = _DateDiff("s", $aNoAttackTimes[1], _NowCalc()) ; find time to stop attacking in seconds
				If @error Then
					_logErrorDateDiff(@error)
					SetError(1, "Can not find NoAttack wait time", True)
					Return True
				EndIf
				UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $ichkAttackPlannerCloseAll, True) ; Close and Wait for attacking to start
				$Restart = True
				Return
			Else
				Return False ; random time to stop attack found let bot idle
			EndIf
		Else
			Return True
		EndIf
	Else ; if not random stop attack time, use attack planner times set in GUI
		If IsPlannedTimeNow() = False Then
			Setlog("Attack schedule planned skip time found...", $COLOR_BLUE)
			If _Sleep($iDelayRespond) Then Return True
			If $bCloseGame Then
				; determine how long to close CoC or emulator if selected
				If $iPlannedAttackWeekDays[@WDAY - 1] = 0 Then
					$iWaitTime = _getTimeRemainTimeToday() ; get number of seconds remaining till Midnight today
					For $i = @WDAY To 6
						If $iPlannedAttackWeekDays[$i] = 0 Then $iWaitTime += 86400 ; add 1 day of seconds to wait time
						If $iPlannedAttackWeekDays[$i] = 1 Then ExitLoop ; stop adding days when find attack planner enabled
						If $debugsetlog = 1 Then Setlog("Subtotal wait time= " & $iWaitTime & " Seconds", $COLOR_PURPLE)
					Next
				EndIf
				If $iWaitTime = 0 Then ; if days are not set then compute wait time from hours
					If $iPlannedAttackWeekDays[@WDAY - 1] = 1 And $iPlannedattackHours[@HOUR] = 0 Then
						$iWaitTime += (59 - @MIN) * 60 ; compute seconds left this hour
						For $i = @HOUR + 1 To 23
							If $iPlannedattackHours[$i] = 0 Then $iWaitTime += 3600 ; add 1 hour of seconds to wait time
							If $iPlannedattackHours[$i] = 1 Then ExitLoop ; stop adding hours when find attack planner enabled
							If $debugsetlog = 1 Then Setlog("Subtotal wait time= " & $iWaitTime & " Seconds", $COLOR_PURPLE)
						Next
					EndIf
				EndIf
				If $debugsetlog = 1 Then Setlog("Stop attack wait time= " & $iWaitTime & " Seconds", $COLOR_PURPLE)
				; close emulator as directed
				UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $ichkAttackPlannerCloseAll, True) ; Close and Wait for attacking to start
				$Restart = True
				Return
			Else
				Return False ; if not planned to close anything, then stop attack
			EndIf
		EndIf
	EndIf
	Return True
EndFunc   ;==>IsSearchAttackEnabled

Func _getTimeRemainTimeToday()
	; calculates number of seconds left till midnight today
	Local $iTimeRemain = _DateDiff("s", _NowCalc(), _NowCalcDate() & " 23:59:59")
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not determine time remaining today", 0)
		Return
	EndIf
	If $debugsetlog = 1 Then Setlog("getTimeRemainToday= " & $iTimeRemain & " Seconds", $COLOR_PURPLE)
	Return $iTimeRemain
EndFunc   ;==>_getTimeRemainTimeToday

Func _IsTimeAfter($sCompareTime, $sCurrentTime = _NowCalc())
	; Check to see if the amount of seconds remaining is less than 0
	Local $bResult = _DateDiff("s", $sCurrentTime, $sCompareTime) < 0
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not check if time is after", False)
		Return
	EndIf
	If $debugsetlog = 1 Then Setlog("IsTimeAfter: " & $bResult, $COLOR_PURPLE)
	Return $bResult
EndFunc   ;==>_IsTimeAfter

Func _IsTimeBefore($sCompareTime, $sCurrentTime = _NowCalc())
	; Check to see if the amount of seconds remaining is greater than 0
	Local $bResult = _DateDiff("s", $sCurrentTime, $sCompareTime) > 0
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not check if time is before", False)
		Return
	EndIf
	If $debugsetlog = 1 Then Setlog("IsTimeBefore: " & $bResult, $COLOR_PURPLE)
	Return $bResult
EndFunc   ;==>_IsTimeBefore

Func _IsTimeInRange($sStartTime, $sEndTime)
	Local $sCurrentTime = _NowCalc()
	; Calculate if time until start time is less than 0 And time until end time is greater than 0
	Local $bResult = _IsTimeAfter($sStartTime, $sCurrentTime) And _IsTimeBefore($sEndTime, $sCurrentTime)
	If $debugsetlog = 1 Then Setlog("IsTimeInRange: " & $bResult, $COLOR_PURPLE)
	Return $bResult ; Returns true if current time is within the range
EndFunc   ;==>_IsTimeInRange

Func _getDailyRandomStartEnd($iDuration = 4)
	Local $iStartHour, $iEndHour
	Local Static $iNowDay = @YDAY ; record numeric value for today
	If Not ($iDuration >= 0 And $iDuration <= 24) Then ; check input duration value
		SetError(1, "Invalid duration for _getDailyRandomStartEnd")
		Return
	EndIf
	; find 1st day random starting time
	Local $sStartTime = _DateAdd("h", Int(_getDailyRandom() * (23 - @HOUR)), _NowCalc()) ; find initial random time during rest of day
	If @error Then
		_logErrorDateDiff(@error)
		SetError(2, "Can not create initial random start time")
		Return
	EndIf
	; find 1st day random end time
	Local $sEndTime = _DateAdd("h", Int($iDuration), $sStartTime) ; add duration to start time
	If @error Then
		_logErrorDateDiff(@error)
		SetError(3, "Can not create initial random end time")
		Return
	EndIf
	Local Static $aNoAttackTimes[2] = [$sStartTime, $sEndTime] ; create return array with default values

	If $iNowDay <> @YDAY Then ; if 1 day or more has passed since last time, compute new random start/stop times
		$iStartHour = _getDailyRandom() * 24
		If $iStartHour <= @HOUR Then $iStartHour = @HOUR + 1.166 ; check if random start is before now, if yes add 70 minutes
		$iEndHour = $iStartHour + $iDuration
		If $debugsetlog = 1 Then Setlog("StartHour: " & $iStartHour & "EndHour: " & $iEndHour, $COLOR_PURPLE)
		$aNoAttackTimes[0] = _DateAdd("h", $iStartHour, _NowCalc()) ; create proper date/time string with start time
		If @error Then
			_logErrorDateDiff(@error)
			SetError(4, "Can not create random start time")
			Return
		EndIf
		$aNoAttackTimes[1] = _DateAdd("h", $iEndHour, _NowCalc()) ; create proper date/time string with end time
		If @error Then
			_logErrorDateDiff(@error)
			SetError(5, "Can not create random end time")
			Return
		EndIf
	EndIf
	If $debugsetlog = 1 Then Setlog("NoAttackStart: " & $aNoAttackTimes[0] & "NoAttackEnd: " & $aNoAttackTimes[1], $COLOR_PURPLE)
	Return $aNoAttackTimes ; return array with start/end time
EndFunc   ;==>_getDailyRandomStartEnd

Func _getDailyRandom()
	Local Static $iDailyRandomValue = Random(0.001, 1, 4) ; establish initial random value
	Local Static $iNowDay = @YDAY ; record numeric value for today
	If $iNowDay <> @YDAY Then ; if 1 day or more has passed since last time, update daily random value
		$iDailyRandomValue = Round(Random(0.001, 1), 4) ; set random value
		$iNowDay = @YDAY ; set new year day value
		If $debugsetlog = 1 Then Setlog("New day = new random value!", $COLOR_PURPLE)
	EndIf
	If $debugsetlog = 1 Then Setlog("DailyRandomValue=" & StringFormat("%0.5f", $iDailyRandomValue), $COLOR_PURPLE)
	Return $iDailyRandomValue
EndFunc   ;==>_getDailyRandom

Func IsPlannedTimeNow()
	Local $hour, $hourloot
	If $iPlannedAttackWeekDays[@WDAY - 1] = 1 Then
		$hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		$hourloot = $hour[0]
		If $iPlannedattackHours[$hourloot] = 1 Then
			If $debugsetlog = 1 Then SetLog("Attack plan enabled for now..", $COLOR_PURPLE)
			Return True
		Else
			SetLog("Attack plan enabled today, but not this hour", $COLOR_BLUE)
			If _Sleep($iDelayRespond) Then Return False
			Return False
		EndIf
	Else
		SetLog("Attack plan not enabled today", $COLOR_BLUE)
		If _Sleep($iDelayRespond) Then Return False
		Return False
	EndIf
EndFunc   ;==>IsPlannedTimeNow

Func _OverAttackLimit()
	Local Static $iAttackCountToday = 0 ; Store daily count locally
	Local Static $iTotalAttackCount = $iAttackedCount ; Store previous total count locally
	Local Static $iNowDay = @YDAY ; record numeric value for today
	If $iNowDay <> @YDAY Then ; if 1 day or more has passed since last time, update daily attack limit
		$iAttackCountToday = 0 ; reset daily count
		$iNowDay = @YDAY ; set new year day value
		$iTotalAttackCount = $iAttackedCount ; total count updated to Stats updated count since bot start
	Else
		$iAttackCountToday = $iAttackedCount - $iTotalAttackCount ; subtract old total attack count from current attack count to update Today count
	EndIf
	If $debugsetlog = 1 Then Setlog("AttackCountToday: " & $iAttackCountToday & ", AttackedCount: " & $iAttackedCount & "TotalAttackCount: " & $iTotalAttackCount, $COLOR_PURPLE)
	; Need to get attack limits from GUI variables and use randomization
	Local $iRandomAttackCountToday = Ceiling(Int($icmbAttackPlannerDayMin) + (_getDailyRandom() * (Int($icmbAttackPlannerDayMax) - Int($icmbAttackPlannerDayMin))))
	If $iRandomAttackCountToday > Int($icmbAttackPlannerDayMax) Then $iRandomAttackCountToday = Int($icmbAttackPlannerDayMax)
	If $debugsetlog = 1 Then Setlog("RandomAttackCountToday: " & $iRandomAttackCountToday, $COLOR_PURPLE)
	If $iAttackCountToday > $iRandomAttackCountToday Then Return True
	Return False
EndFunc   ;==>_OverAttackLimit
