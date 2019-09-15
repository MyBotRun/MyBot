#include-once

#include "DateTimeConstants.au3"
#include "Memory.au3"
#include "Security.au3"
#include "StructureConstants.au3"
#include "WinAPI.au3"
#include "WinAPILocale.au3"

; #INDEX# =======================================================================================================================
; Title .........: Date
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Date/Time management.
;                  There are five time formats: System, File, Local, MS-DOS and Windows.  Time related functions return  time  in
;                  one of these formats.  You can also use the time functions  to  convert  between  time  formats  for  ease  of
;                  comparison and display
; Author(s) .....: JdeB, jlandes, exodius, PaulIA, Tuape, SlimShady, GaryFrost, /dev/null, Marc
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;
; _DateLastWeekdayNum
; _DateLastMonthNum
; _DateLastMonthYear
; _DateNextWeekdayNum
; _DateNextMonthNum
; _DateNextMonthYear
; _Date_JulianDayNo
; _JulianToDate
; _WeekNumber
; _DaysInMonth
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _DateAdd
; _DateDayOfWeek
; _DateDaysInMonth
; _DateDiff
; _DateIsLeapYear
; _DateIsValid
; _DateTimeFormat
; _DateTimeSplit
; _DateToDayOfWeek
; _DateToDayOfWeekISO
; _DateToDayValue
; _DateToMonth
; _DayValueToDate
; _Now
; _NowCalc
; _NowCalcDate
; _NowDate
; _NowTime
; _SetDate
; _SetTime
; _TicksToTime
; _TimeToTicks
; _WeekNumberISO
; _Date_Time_CompareFileTime
; _Date_Time_DOSDateTimeToFileTime
; _Date_Time_DOSDateToArray
; _Date_Time_DOSDateTimeToArray
; _Date_Time_DOSDateTimeToStr
; _Date_Time_DOSDateToStr
; _Date_Time_DOSTimeToArray
; _Date_Time_DOSTimeToStr
; _Date_Time_EncodeFileTime
; _Date_Time_EncodeSystemTime
; _Date_Time_FileTimeToArray
; _Date_Time_FileTimeToStr
; _Date_Time_FileTimeToDOSDateTime
; _Date_Time_FileTimeToLocalFileTime
; _Date_Time_FileTimeToSystemTime
; _Date_Time_GetFileTime
; _Date_Time_GetLocalTime
; _Date_Time_GetSystemTime
; _Date_Time_GetSystemTimeAdjustment
; _Date_Time_GetSystemTimeAsFileTime
; _Date_Time_GetSystemTimes
; _Date_Time_GetTickCount
; _Date_Time_GetTimeZoneInformation
; _Date_Time_LocalFileTimeToFileTime
; _Date_Time_SetFileTime
; _Date_Time_SetLocalTime
; _Date_Time_SetSystemTime
; _Date_Time_SetSystemTimeAdjustment
; _Date_Time_SetTimeZoneInformation
; _Date_Time_SystemTimeToArray
; _Date_Time_SystemTimeToDateStr
; _Date_Time_SystemTimeToDateTimeStr
; _Date_Time_SystemTimeToFileTime
; _Date_Time_SystemTimeToTimeStr
; _Date_Time_SystemTimeToTzSpecificLocalTime
; _Date_Time_TzSpecificLocalTimeToSystemTime
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __DateIsMonth
; __DateIsYear
; __Date_Time_CloneSystemTime
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande
; Modified.......:
; ===============================================================================================================================
Func _DateAdd($sType, $iNumber, $sDate)
	Local $asTimePart[4]
	Local $asDatePart[4]
	Local $iJulianDate
	; Verify that $sType is Valid
	$sType = StringLeft($sType, 1)
	If StringInStr("D,M,Y,w,h,n,s", $sType) = 0 Or $sType = "" Then
		Return SetError(1, 0, 0)
	EndIf
	; Verify that Value to Add  is Valid
	If Not StringIsInt($iNumber) Then
		Return SetError(2, 0, 0)
	EndIf
	; Verify If InputDate is valid
	If Not _DateIsValid($sDate) Then
		Return SetError(3, 0, 0)
	EndIf
	; split the date and time into arrays
	_DateTimeSplit($sDate, $asDatePart, $asTimePart)

	; ====================================================
	; adding days then get the julian date
	; add the number of day
	; and convert back to Gregorian
	If $sType = "d" Or $sType = "w" Then
		If $sType = "w" Then $iNumber = $iNumber * 7
		$iJulianDate = _DateToDayValue($asDatePart[1], $asDatePart[2], $asDatePart[3]) + $iNumber
		_DayValueToDate($iJulianDate, $asDatePart[1], $asDatePart[2], $asDatePart[3])
	EndIf
	; ====================================================
	; adding Months
	If $sType = "m" Then
		$asDatePart[2] = $asDatePart[2] + $iNumber
		; pos number of months
		While $asDatePart[2] > 12
			$asDatePart[2] = $asDatePart[2] - 12
			$asDatePart[1] = $asDatePart[1] + 1
		WEnd
		; Neg number of months
		While $asDatePart[2] < 1
			$asDatePart[2] = $asDatePart[2] + 12
			$asDatePart[1] = $asDatePart[1] - 1
		WEnd
	EndIf
	; ====================================================
	; adding Years
	If $sType = "y" Then
		$asDatePart[1] = $asDatePart[1] + $iNumber
	EndIf
	; ====================================================
	; adding Time value
	If $sType = "h" Or $sType = "n" Or $sType = "s" Then
		Local $iTimeVal = _TimeToTicks($asTimePart[1], $asTimePart[2], $asTimePart[3]) / 1000
		If $sType = "h" Then $iTimeVal = $iTimeVal + $iNumber * 3600
		If $sType = "n" Then $iTimeVal = $iTimeVal + $iNumber * 60
		If $sType = "s" Then $iTimeVal = $iTimeVal + $iNumber
		; calculated days to add
		Local $iDay2Add = Int($iTimeVal / (24 * 60 * 60))
		$iTimeVal = $iTimeVal - $iDay2Add * 24 * 60 * 60
		If $iTimeVal < 0 Then
			$iDay2Add = $iDay2Add - 1
			$iTimeVal = $iTimeVal + 24 * 60 * 60
		EndIf
		$iJulianDate = _DateToDayValue($asDatePart[1], $asDatePart[2], $asDatePart[3]) + $iDay2Add
		; calculate the julian back to date
		_DayValueToDate($iJulianDate, $asDatePart[1], $asDatePart[2], $asDatePart[3])
		; caluculate the new time
		_TicksToTime($iTimeVal * 1000, $asTimePart[1], $asTimePart[2], $asTimePart[3])
	EndIf
	; ====================================================
	; check if the Input day is Greater then the new month last day.
	; if so then change it to the last possible day in the month
	Local $iNumDays = _DaysInMonth($asDatePart[1])
	;
	If $iNumDays[$asDatePart[2]] < $asDatePart[3] Then $asDatePart[3] = $iNumDays[$asDatePart[2]]
	; ========================
	; Format the return date
	$sDate = $asDatePart[1] & '/' & StringRight("0" & $asDatePart[2], 2) & '/' & StringRight("0" & $asDatePart[3], 2)
	; add the time when specified in the input
	If $asTimePart[0] > 0 Then
		If $asTimePart[0] > 2 Then
			$sDate = $sDate & " " & StringRight("0" & $asTimePart[1], 2) & ':' & StringRight("0" & $asTimePart[2], 2) & ':' & StringRight("0" & $asTimePart[3], 2)
		Else
			$sDate = $sDate & " " & StringRight("0" & $asTimePart[1], 2) & ':' & StringRight("0" & $asTimePart[2], 2)
		EndIf
	EndIf
	;
	Return $sDate
EndFunc   ;==>_DateAdd

; #FUNCTION# ====================================================================================================================
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......: trancexx
; ===============================================================================================================================
Func _DateDayOfWeek($iDayNum, $iFormat = Default)
	Local Const $MONDAY_IS_NO1 = 128 ; Undocumented - If someone passes $iFormat with 128, Monday will be regarded as the first day of the week and not Sunday.
	If $iFormat = Default Then $iFormat = 0
	$iDayNum = Int($iDayNum)
	If $iDayNum < 1 Or $iDayNum > 7 Then Return SetError(1, 0, "")
	Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tSYSTEMTIME, "Year", BitAND($iFormat, $MONDAY_IS_NO1) ? 2007 : 2006) ; 2006 = Sunday 1st Jan or 2007 = Monday 1st Jan.
	DllStructSetData($tSYSTEMTIME, "Month", 1)
	DllStructSetData($tSYSTEMTIME, "Day", $iDayNum)
	Return _WinAPI_GetDateFormat(BitAND($iFormat, $DMW_LOCALE_LONGNAME) ? $LOCALE_USER_DEFAULT : $LOCALE_INVARIANT, $tSYSTEMTIME, 0, BitAND($iFormat, $DMW_SHORTNAME) ? "ddd" : "dddd")
EndFunc   ;==>_DateDayOfWeek

; #FUNCTION# ====================================================================================================================
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; ===============================================================================================================================
Func _DateDaysInMonth($iYear, $iMonthNum)
	$iMonthNum = Int($iMonthNum)
	$iYear = Int($iYear)
	Return __DateIsMonth($iMonthNum) And __DateIsYear($iYear) ? _DaysInMonth($iYear)[$iMonthNum] : SetError(1, 0, 0)
EndFunc   ;==>_DateDaysInMonth

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande
; Modified.......:
; ===============================================================================================================================
Func _DateDiff($sType, $sStartDate, $sEndDate)
	; Verify that $sType is Valid
	$sType = StringLeft($sType, 1)
	If StringInStr("d,m,y,w,h,n,s", $sType) = 0 Or $sType = "" Then
		Return SetError(1, 0, 0)
	EndIf
	; Verify If StartDate is valid
	If Not _DateIsValid($sStartDate) Then
		Return SetError(2, 0, 0)
	EndIf
	; Verify If EndDate is valid
	If Not _DateIsValid($sEndDate) Then
		Return SetError(3, 0, 0)
	EndIf
	Local $asStartDatePart[4], $asStartTimePart[4], $asEndDatePart[4], $asEndTimePart[4]
	; split the StartDate and Time into arrays
	_DateTimeSplit($sStartDate, $asStartDatePart, $asStartTimePart)
	; split the End  Date and time into arrays
	_DateTimeSplit($sEndDate, $asEndDatePart, $asEndTimePart)
	; ====================================================
	; Get the differens in days between the 2 dates
	Local $aDaysDiff = _DateToDayValue($asEndDatePart[1], $asEndDatePart[2], $asEndDatePart[3]) - _DateToDayValue($asStartDatePart[1], $asStartDatePart[2], $asStartDatePart[3])
	; ====================================================
	Local $iTimeDiff, $iYearDiff, $iStartTimeInSecs, $iEndTimeInSecs
	; Get the differens in Seconds between the 2 times when specified
	If $asStartTimePart[0] > 1 And $asEndTimePart[0] > 1 Then
		$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
		$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
		$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
		If $iTimeDiff < 0 Then
			$aDaysDiff = $aDaysDiff - 1
			$iTimeDiff = $iTimeDiff + 24 * 60 * 60
		EndIf
	Else
		$iTimeDiff = 0
	EndIf
	Select
		Case $sType = "d"
			Return $aDaysDiff
		Case $sType = "m"
			$iYearDiff = $asEndDatePart[1] - $asStartDatePart[1]
			Local $iMonthDiff = $asEndDatePart[2] - $asStartDatePart[2] + $iYearDiff * 12
			If $asEndDatePart[3] < $asStartDatePart[3] Then $iMonthDiff = $iMonthDiff - 1
			$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
			$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
			$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
			If $asEndDatePart[3] = $asStartDatePart[3] And $iTimeDiff < 0 Then $iMonthDiff = $iMonthDiff - 1
			Return $iMonthDiff
		Case $sType = "y"
			$iYearDiff = $asEndDatePart[1] - $asStartDatePart[1]
			If $asEndDatePart[2] < $asStartDatePart[2] Then $iYearDiff = $iYearDiff - 1
			If $asEndDatePart[2] = $asStartDatePart[2] And $asEndDatePart[3] < $asStartDatePart[3] Then $iYearDiff = $iYearDiff - 1
			$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
			$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
			$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
			If $asEndDatePart[2] = $asStartDatePart[2] And $asEndDatePart[3] = $asStartDatePart[3] And $iTimeDiff < 0 Then $iYearDiff = $iYearDiff - 1
			Return $iYearDiff
		Case $sType = "w"
			Return Int($aDaysDiff / 7)
		Case $sType = "h"
			Return $aDaysDiff * 24 + Int($iTimeDiff / 3600)
		Case $sType = "n"
			Return $aDaysDiff * 24 * 60 + Int($iTimeDiff / 60)
		Case $sType = "s"
			Return $aDaysDiff * 24 * 60 * 60 + $iTimeDiff
	EndSelect
EndFunc   ;==>_DateDiff

; #FUNCTION# ====================================================================================================================
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; ===============================================================================================================================
Func _DateIsLeapYear($iYear)
	If StringIsInt($iYear) Then
		Select
			Case Mod($iYear, 4) = 0 And Mod($iYear, 100) <> 0
				Return 1
			Case Mod($iYear, 400) = 0
				Return 1
			Case Else
				Return 0
		EndSelect
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_DateIsLeapYear

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __DateIsMonth
; Description ...: Checks a given number to see if it is a valid month.
; Syntax.........: __DateIsMonth ( $iNumber )
; Parameters ....: $iNumber - Month number to check.
; Return values .: Success - Returns 1 if month is valid.
;                  Failure - Returns 0
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __DateIsMonth($iNumber)
	$iNumber = Int($iNumber)
	Return $iNumber >= 1 And $iNumber <= 12
EndFunc   ;==>__DateIsMonth

; #FUNCTION# ====================================================================================================================
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; ===============================================================================================================================
Func _DateIsValid($sDate)
	Local $asDatePart[4], $asTimePart[4]

	#cs
		A regular expression to verify the date and time string.
		$bIsDate = Not StringRegExp($sDate, '[^\d.\-/:]')
		$bIsDate = StringRegExp($sDate, '(?x)^\d{4}(?:[.\-/]\d{2}){2}   (?:     (?:T|\h)\d{2}:\d{2}     (?::\d{2})?     )?$') > 0
	#ce

	_DateTimeSplit($sDate, $asDatePart, $asTimePart)

	; verify valid input date values
	If Not StringIsInt($asDatePart[1]) Then Return 0
	If Not StringIsInt($asDatePart[2]) Then Return 0
	If Not StringIsInt($asDatePart[3]) Then Return 0

	; Make sure the Date parts contains numeric
	$asDatePart[1] = Int($asDatePart[1])
	$asDatePart[2] = Int($asDatePart[2])
	$asDatePart[3] = Int($asDatePart[3])

	; check if all contain valid values
	Local $iNumDays = _DaysInMonth($asDatePart[1])
	If $asDatePart[1] < 1000 Or $asDatePart[1] > 2999 Then Return 0
	If $asDatePart[2] < 1 Or $asDatePart[2] > 12 Then Return 0
	If $asDatePart[3] < 1 Or $asDatePart[3] > $iNumDays[$asDatePart[2]] Then Return 0

	; check Time portion
	If $asTimePart[0] < 1 Then Return 1 ; No time specified so date must be correct
	If $asTimePart[0] < 2 Then Return 0 ; need at least HH:MM when something is specified
	If $asTimePart[0] = 2 Then $asTimePart[3] = "00" ; init SS when only HH:MM is specified

	; Make sure the Time parts contains numeric
	If Not StringIsInt($asTimePart[1]) Then Return 0
	If Not StringIsInt($asTimePart[2]) Then Return 0
	If Not StringIsInt($asTimePart[3]) Then Return 0

	; check if all contain valid values
	$asTimePart[1] = Int($asTimePart[1])
	$asTimePart[2] = Int($asTimePart[2])
	$asTimePart[3] = Int($asTimePart[3])

	If $asTimePart[1] < 0 Or $asTimePart[1] > 23 Then Return 0
	If $asTimePart[2] < 0 Or $asTimePart[2] > 59 Then Return 0
	If $asTimePart[3] < 0 Or $asTimePart[3] > 59 Then Return 0

	; we got here so date/time must be good
	Return 1
EndFunc   ;==>_DateIsValid

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __DateIsYear
; Description ...: Checks a given number to see if it is a valid year.
; Syntax.........: __DateIsYear ( $iNumber )
; Parameters ....: $iNumber - Year number to check.
; Return values .: Success - Returns 1 if year is valid.
;                  Failure - Returns 0
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __DateIsYear($iNumber)
	Return StringLen($iNumber) = 4
EndFunc   ;==>__DateIsYear

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _DateLastWeekdayNum
; Description ...: Returns previous weekday number, based on the specified day of the week.
; Syntax.........: _DateLastWeekdayNum ( $iWeekdayNum )
; Parameters ....: $iWeekdayNum - Weekday number
; Return values .: Success - Previous weekday number
;                  Failure - Returns 0 and sets @error = 1
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _DateLastWeekdayNum($iWeekdayNum)
	Select
		Case Not StringIsInt($iWeekdayNum)
			Return SetError(1, 0, 0)
		Case $iWeekdayNum < 1 Or $iWeekdayNum > 7
			Return SetError(2, 0, 0)
		Case Else
			Local $iLastWeekdayNum
			If $iWeekdayNum = 1 Then
				$iLastWeekdayNum = 7
			Else
				$iLastWeekdayNum = $iWeekdayNum - 1
			EndIf

			Return $iLastWeekdayNum
	EndSelect
EndFunc   ;==>_DateLastWeekdayNum

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _DateLastMonthNum
; Description ...: Returns previous month number, based on the specified month.
; Syntax.........: _DateLastMonthNum ( $iMonthNum )
; Parameters ....: $iMonthNum - Month number
; Return values .: Success - Previous month number
;                  Failure - Returns 0 and sets @error = 1
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _DateLastMonthNum($iMonthNum)
	Select
		Case Not StringIsInt($iMonthNum)
			Return SetError(1, 0, 0)
		Case Not __DateIsMonth($iMonthNum)
			Return SetError(2, 0, 0)
		Case Else
			Local $iLastMonthNum
			If $iMonthNum = 1 Then
				$iLastMonthNum = 12
			Else
				$iLastMonthNum = $iMonthNum - 1
			EndIf

			$iLastMonthNum = StringFormat("%02d", $iLastMonthNum)
			Return $iLastMonthNum
	EndSelect
EndFunc   ;==>_DateLastMonthNum

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _DateLastMonthYear
; Description ...: Returns previous month's year, based on the specified month and year.
; Syntax.........: _DateLastMonthYear ( $iMonthNum, $iYear )
; Parameters ....: $iMonthNum - Month number
;                  $iYear     - Year
; Return values .: Success - Previous month's year
;                  Failure - Returns 0 and sets @error = 1
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _DateLastMonthYear($iMonthNum, $iYear)
	Select
		Case Not StringIsInt($iMonthNum) Or Not StringIsInt($iYear)
			Return SetError(1, 0, 0)
		Case Not __DateIsMonth($iMonthNum)
			Return SetError(2, 0, 0)
		Case Else
			Local $iLastYear
			If $iMonthNum = 1 Then
				$iLastYear = $iYear - 1
			Else
				$iLastYear = $iYear
			EndIf

			$iLastYear = StringFormat("%04d", $iLastYear)
			Return $iLastYear
	EndSelect
EndFunc   ;==>_DateLastMonthYear

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _DateNextWeekdayNum
; Description ...: Returns next weekday number, based on the specified day of the week.
; Syntax.........: _DateNextWeekdayNum ( $iWeekdayNum )
; Parameters ....: $iWeekdayNum - Weekday number
; Return values .: Success - Next weekday number
;                  Failure - 0 and sets @error = 1
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _DateNextWeekdayNum($iWeekdayNum)
	Select
		Case Not StringIsInt($iWeekdayNum)
			Return SetError(1, 0, 0)
		Case $iWeekdayNum < 1 Or $iWeekdayNum > 7
			Return SetError(2, 0, 0)
		Case Else
			Local $iNextWeekdayNum
			If $iWeekdayNum = 7 Then
				$iNextWeekdayNum = 1
			Else
				$iNextWeekdayNum = $iWeekdayNum + 1
			EndIf

			Return $iNextWeekdayNum
	EndSelect
EndFunc   ;==>_DateNextWeekdayNum

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _DateNextMonthNum
; Description ...: Returns next month number, based on the specified month.
; Syntax.........: _DateNextMonthNum ( $iMonthNum )
; Parameters ....: $iMonthNum - Month number
; Return values .: Success - Next month number
;                  Failure - 0 and sets @error = 1
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _DateNextMonthNum($iMonthNum)
	Select
		Case Not StringIsInt($iMonthNum)
			Return SetError(1, 0, 0)
		Case Not __DateIsMonth($iMonthNum)
			Return SetError(2, 0, 0)
		Case Else
			Local $iNextMonthNum
			If $iMonthNum = 12 Then
				$iNextMonthNum = 1
			Else
				$iNextMonthNum = $iMonthNum + 1
			EndIf

			$iNextMonthNum = StringFormat("%02d", $iNextMonthNum)
			Return $iNextMonthNum
	EndSelect
EndFunc   ;==>_DateNextMonthNum

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _DateNextMonthYear
; Description ...: Returns next month's year, based on the specified month and year.
; Syntax.........: _DateNextMonthYear ( $iMonthNum, $iYear )
; Parameters ....: $iMonthNum - Month number
;                  $iYear     - Year
; Return values .: Success - Next month's year
;                  Failure - 0 and sets @error = 1
; Author ........: Jeremy Landes <jlandes at landeserve dot com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _DateNextMonthYear($iMonthNum, $iYear)
	Select
		Case Not StringIsInt($iMonthNum) Or Not StringIsInt($iYear)
			Return SetError(1, 0, 0)
		Case Not __DateIsMonth($iMonthNum)
			Return SetError(2, 0, 0)
		Case Else
			Local $iNextYear
			If $iMonthNum = 12 Then
				$iNextYear = $iYear + 1
			Else
				$iNextYear = $iYear
			EndIf

			$iNextYear = StringFormat("%04d", $iNextYear)
			Return $iNextYear
	EndSelect
EndFunc   ;==>_DateNextMonthYear

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......:
; ===============================================================================================================================
Func _DateTimeFormat($sDate, $sType)
	Local $asDatePart[4], $asTimePart[4]
	Local $sTempDate = "", $sTempTime = ""
	Local $sAM, $sPM, $sTempString = ""
	; Verify If InputDate is valid
	If Not _DateIsValid($sDate) Then
		Return SetError(1, 0, "")
	EndIf
	; input validation
	If $sType < 0 Or $sType > 5 Or Not IsInt($sType) Then
		Return SetError(2, 0, "")
	EndIf
	; split the date and time into arrays
	_DateTimeSplit($sDate, $asDatePart, $asTimePart)

	Switch $sType
		Case 0
			$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_SSHORTDATE) ; Get short date format.
			If Not @error And Not ($sTempString = '') Then
				$sTempDate = $sTempString
			Else
				$sTempDate = "M/d/yyyy"
			EndIf
			If $asTimePart[0] > 1 Then
				$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_STIMEFORMAT) ; Get short time format.
				If Not @error And Not ($sTempString = '') Then
					$sTempTime = $sTempString
				Else
					$sTempTime = "h:mm:ss tt"
				EndIf
			EndIf
		Case 1
			$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_SLONGDATE) ; Get long date format.
			If Not @error And Not ($sTempString = '') Then
				$sTempDate = $sTempString
			Else
				$sTempDate = "dddd, MMMM dd, yyyy"
			EndIf
		Case 2
			$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_SSHORTDATE) ; Get short date format.
			If Not @error And Not ($sTempString = '') Then
				$sTempDate = $sTempString
			Else
				$sTempDate = "M/d/yyyy"
			EndIf
		Case 3
			If $asTimePart[0] > 1 Then
				$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_STIMEFORMAT) ; Get short time format.
				If Not @error And Not ($sTempString = '') Then
					$sTempTime = $sTempString
				Else
					$sTempTime = "h:mm:ss tt"
				EndIf
			EndIf
		Case 4
			If $asTimePart[0] > 1 Then
				$sTempTime = "hh:mm"
			EndIf
		Case 5
			If $asTimePart[0] > 1 Then
				$sTempTime = "hh:mm:ss"
			EndIf
	EndSwitch
	; Format DATE
	If $sTempDate <> "" Then
		$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_SDATE) ; Get short date format.
		If Not @error And Not ($sTempString = '') Then
			$sTempDate = StringReplace($sTempDate, "/", $sTempString)
		EndIf
		Local $iWday = _DateToDayOfWeek($asDatePart[1], $asDatePart[2], $asDatePart[3])
		$asDatePart[3] = StringRight("0" & $asDatePart[3], 2) ; make sure the length is 2
		$asDatePart[2] = StringRight("0" & $asDatePart[2], 2) ; make sure the length is 2
		$sTempDate = StringReplace($sTempDate, "d", "@")
		$sTempDate = StringReplace($sTempDate, "m", "#")
		$sTempDate = StringReplace($sTempDate, "y", "&")
		$sTempDate = StringReplace($sTempDate, "@@@@", _DateDayOfWeek($iWday, 0))
		$sTempDate = StringReplace($sTempDate, "@@@", _DateDayOfWeek($iWday, 1))
		$sTempDate = StringReplace($sTempDate, "@@", $asDatePart[3])
		$sTempDate = StringReplace($sTempDate, "@", StringReplace(StringLeft($asDatePart[3], 1), "0", "") & StringRight($asDatePart[3], 1))
		$sTempDate = StringReplace($sTempDate, "####", _DateToMonth($asDatePart[2], 0))
		$sTempDate = StringReplace($sTempDate, "###", _DateToMonth($asDatePart[2], 1))
		$sTempDate = StringReplace($sTempDate, "##", $asDatePart[2])
		$sTempDate = StringReplace($sTempDate, "#", StringReplace(StringLeft($asDatePart[2], 1), "0", "") & StringRight($asDatePart[2], 1))
		$sTempDate = StringReplace($sTempDate, "&&&&", $asDatePart[1])
		$sTempDate = StringReplace($sTempDate, "&&", StringRight($asDatePart[1], 2))
	EndIf
	; Format TIME
	If $sTempTime <> "" Then
		$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_S1159) ; AM designator.
		If Not @error And Not ($sTempString = '') Then
			$sAM = $sTempString
		Else
			$sAM = "AM"
		EndIf
		$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_S2359) ; PM designator.
		If Not @error And Not ($sTempString = '') Then
			$sPM = $sTempString
		Else
			$sPM = "PM"
		EndIf
		$sTempString = _WinAPI_GetLocaleInfo($LOCALE_USER_DEFAULT, $LOCALE_STIME) ; Time seperator.
		If Not @error And Not ($sTempString = '') Then
			$sTempTime = StringReplace($sTempTime, ":", $sTempString)
		EndIf
		If StringInStr($sTempTime, "tt") Then
			If $asTimePart[1] < 12 Then
				$sTempTime = StringReplace($sTempTime, "tt", $sAM)
				If $asTimePart[1] = 0 Then $asTimePart[1] = 12
			Else
				$sTempTime = StringReplace($sTempTime, "tt", $sPM)
				If $asTimePart[1] > 12 Then $asTimePart[1] = $asTimePart[1] - 12
			EndIf
		EndIf
		$asTimePart[1] = StringRight("0" & $asTimePart[1], 2) ; make sure the length is 2
		$asTimePart[2] = StringRight("0" & $asTimePart[2], 2) ; make sure the length is 2
		$asTimePart[3] = StringRight("0" & $asTimePart[3], 2) ; make sure the length is 2
		$sTempTime = StringReplace($sTempTime, "hh", StringFormat("%02d", $asTimePart[1]))
		$sTempTime = StringReplace($sTempTime, "h", StringReplace(StringLeft($asTimePart[1], 1), "0", "") & StringRight($asTimePart[1], 1))
		$sTempTime = StringReplace($sTempTime, "mm", StringFormat("%02d", $asTimePart[2]))
		$sTempTime = StringReplace($sTempTime, "ss", StringFormat("%02d", $asTimePart[3]))
		$sTempDate = StringStripWS($sTempDate & " " & $sTempTime, $STR_STRIPLEADING + $STR_STRIPTRAILING)
	EndIf
	Return $sTempDate
EndFunc   ;==>_DateTimeFormat

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......:
; ===============================================================================================================================
Func _DateTimeSplit($sDate, ByRef $aDatePart, ByRef $iTimePart)
	; split the Date and Time portion
	Local $sDateTime = StringSplit($sDate, " T")
	; split the date portion
	If $sDateTime[0] > 0 Then $aDatePart = StringSplit($sDateTime[1], "/-.")
	; split the Time portion
	If $sDateTime[0] > 1 Then
		$iTimePart = StringSplit($sDateTime[2], ":")
		If UBound($iTimePart) < 4 Then ReDim $iTimePart[4]
	Else
		Dim $iTimePart[4]
	EndIf
	; Ensure the arrays contain 4 values
	If UBound($aDatePart) < 4 Then ReDim $aDatePart[4]
	; update the array to contain numbers not strings
	For $x = 1 To 3
		If StringIsInt($aDatePart[$x]) Then
			$aDatePart[$x] = Int($aDatePart[$x])
		Else
			$aDatePart[$x] = -1
		EndIf
		If StringIsInt($iTimePart[$x]) Then
			$iTimePart[$x] = Int($iTimePart[$x])
		Else
			$iTimePart[$x] = 0
		EndIf
	Next
	Return 1
EndFunc   ;==>_DateTimeSplit

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......:
; ===============================================================================================================================
Func _DateToDayOfWeek($iYear, $iMonth, $iDay)
	; Verify If InputDate is valid
	If Not _DateIsValid($iYear & "/" & $iMonth & "/" & $iDay) Then
		Return SetError(1, 0, "")
	EndIf
	Local $i_FactorA = Int((14 - $iMonth) / 12)
	Local $i_FactorY = $iYear - $i_FactorA
	Local $i_FactorM = $iMonth + (12 * $i_FactorA) - 2
	Local $i_FactorD = Mod($iDay + $i_FactorY + Int($i_FactorY / 4) - Int($i_FactorY / 100) + Int($i_FactorY / 400) + Int((31 * $i_FactorM) / 12), 7)
	Return $i_FactorD + 1
EndFunc   ;==>_DateToDayOfWeek

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......:
; ===============================================================================================================================
Func _DateToDayOfWeekISO($iYear, $iMonth, $iDay)
	Local $iDow = _DateToDayOfWeek($iYear, $iMonth, $iDay)
	If @error Then
		Return SetError(1, 0, "")
	EndIf
	If $iDow >= 2 Then Return $iDow - 1
	Return 7
EndFunc   ;==>_DateToDayOfWeekISO

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande / Jeremy Landes
; Modified.......:
; ===============================================================================================================================
Func _DateToDayValue($iYear, $iMonth, $iDay)
	; Verify If InputDate is valid
	If Not _DateIsValid(StringFormat("%04d/%02d/%02d", $iYear, $iMonth, $iDay)) Then
		Return SetError(1, 0, "")
	EndIf
	If $iMonth < 3 Then
		$iMonth = $iMonth + 12
		$iYear = $iYear - 1
	EndIf
	Local $i_FactorA = Int($iYear / 100)
	Local $i_FactorB = Int($i_FactorA / 4)
	Local $i_FactorC = 2 - $i_FactorA + $i_FactorB
	Local $i_FactorE = Int(1461 * ($iYear + 4716) / 4)
	Local $i_FactorF = Int(153 * ($iMonth + 1) / 5)
	Local $iJulianDate = $i_FactorC + $iDay + $i_FactorE + $i_FactorF - 1524.5
	Return $iJulianDate
EndFunc   ;==>_DateToDayValue

; #FUNCTION# ====================================================================================================================
; Author ........: Jason Brand <exodius at gmail dot com>
; Modified.......: guinness
; ===============================================================================================================================
Func _DateToMonth($iMonNum, $iFormat = Default)
	If $iFormat = Default Then $iFormat = 0
	$iMonNum = Int($iMonNum)
	If Not __DateIsMonth($iMonNum) Then Return SetError(1, 0, "")
	Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tSYSTEMTIME, "Year", @YEAR)
	DllStructSetData($tSYSTEMTIME, "Month", $iMonNum)
	DllStructSetData($tSYSTEMTIME, "Day", 1)
	Return _WinAPI_GetDateFormat(BitAND($iFormat, $DMW_LOCALE_LONGNAME) ? $LOCALE_USER_DEFAULT : $LOCALE_INVARIANT, $tSYSTEMTIME, 0, BitAND($iFormat, $DMW_SHORTNAME) ? "MMM" : "MMMM")
EndFunc   ;==>_DateToMonth

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande
; Modified.......:
; ===============================================================================================================================
Func _DayValueToDate($iJulianDate, ByRef $iYear, ByRef $iMonth, ByRef $iDay)
	; check for valid input date
	If $iJulianDate < 0 Or Not IsNumber($iJulianDate) Then
		Return SetError(1, 0, 0)
	EndIf
	; calculte the date
	Local $i_FactorZ = Int($iJulianDate + 0.5)
	Local $i_FactorW = Int(($i_FactorZ - 1867216.25) / 36524.25)
	Local $i_FactorX = Int($i_FactorW / 4)
	Local $i_FactorA = $i_FactorZ + 1 + $i_FactorW - $i_FactorX
	Local $i_FactorB = $i_FactorA + 1524
	Local $i_FactorC = Int(($i_FactorB - 122.1) / 365.25)
	Local $i_FactorD = Int(365.25 * $i_FactorC)
	Local $i_FactorE = Int(($i_FactorB - $i_FactorD) / 30.6001)
	Local $i_FactorF = Int(30.6001 * $i_FactorE)
	$iDay = $i_FactorB - $i_FactorD - $i_FactorF
	; (must get number less than or equal to 12)
	If $i_FactorE - 1 < 13 Then
		$iMonth = $i_FactorE - 1
	Else
		$iMonth = $i_FactorE - 13
	EndIf
	If $iMonth < 3 Then
		$iYear = $i_FactorC - 4715 ; (if Month is January or February)
	Else
		$iYear = $i_FactorC - 4716 ;(otherwise)
	EndIf
	$iYear = StringFormat("%04d", $iYear)
	$iMonth = StringFormat("%02d", $iMonth)
	$iDay = StringFormat("%02d", $iDay)
	Return $iYear & "/" & $iMonth & "/" & $iDay
EndFunc   ;==>_DayValueToDate

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _Date_JulianDayNo
; Description ...: Returns the the julian date in format YYDDD
; Syntax.........: _Date_JulianDayNo ( $iYear, $iMonth, $iDay )
; Parameters ....: $iJulianDate - Julian date number
;                  $iYear       - Year in format YYYY
;                  $iMonth      - Month in format MM
;                  $iDay        - Day of the month format DD
; Return values .: Success - Returns the date calculated
;                  Failure - 0 and Set @error to:
;                  |0 - No error.
;                  |1 - Invalid Input number of days
; Author ........: Jeremy Landes / Jos van der Zande
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Date_JulianDayNo($iYear, $iMonth, $iDay)
	; Verify If InputDate is valid
	Local $sFullDate = StringFormat("%04d/%02d/%02d", $iYear, $iMonth, $iDay)
	If Not _DateIsValid($sFullDate) Then
		Return SetError(1, 0, "")
	EndIf
	; Build JDay value
	Local $iJDay = 0
	Local $aiDaysInMonth = _DaysInMonth($iYear)
	For $iCntr = 1 To $iMonth - 1
		$iJDay = $iJDay + $aiDaysInMonth[$iCntr]
	Next
	$iJDay = ($iYear * 1000) + ($iJDay + $iDay)
	Return $iJDay
EndFunc   ;==>_Date_JulianDayNo

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _JulianToDate
; Description ...: Returns the the julian date in format YYDDD
; Syntax.........: _JulianToDate ($iJDay [, $sSep = "/"] )
; Parameters ....: $iJDate  - Julian date number
;                  $sSep    - Seperator character
; Return values .: Success - Returns the Date in format YYYY/MM/DD
;                  Failure - 0 and Set @error to:
;                  |0 - No error.
;                  |1 - Invalid Julian
; Author ........: Jeremy Landes / Jos van der Zande
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _JulianToDate($iJDay, $sSep = "/")
	; Verify If InputDate is valid
	Local $iYear = Int($iJDay / 1000)
	Local $iDays = Mod($iJDay, 1000)
	Local $iMaxDays = 365
	If _DateIsLeapYear($iYear) Then $iMaxDays = 366
	If $iDays > $iMaxDays Then
		Return SetError(1, 0, "")
	EndIf
	; Convert to regular date
	Local $aiDaysInMonth = _DaysInMonth($iYear)
	Local $iMonth = 1
	While $iDays > $aiDaysInMonth[$iMonth]
		$iDays = $iDays - $aiDaysInMonth[$iMonth]
		$iMonth = $iMonth + 1
	WEnd
	Return StringFormat("%04d%s%02d%s%02d", $iYear, $sSep, $iMonth, $sSep, $iDays)
EndFunc   ;==>_JulianToDate

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande
; Modified.......:
; ===============================================================================================================================
Func _Now()
	Return _DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, 0)
EndFunc   ;==>_Now

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande
; Modified.......:
; ===============================================================================================================================
Func _NowCalc()
	Return @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
EndFunc   ;==>_NowCalc

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande
; Modified.......:
; ===============================================================================================================================
Func _NowCalcDate()
	Return @YEAR & "/" & @MON & "/" & @MDAY
EndFunc   ;==>_NowCalcDate

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande
; Modified.......:
; ===============================================================================================================================
Func _NowDate()
	Return _DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY, 0)
EndFunc   ;==>_NowDate

; #FUNCTION# ====================================================================================================================
; Author ........: Jos van der Zande
; Modified.......:
; ===============================================================================================================================
Func _NowTime($sType = 3)
	If $sType < 3 Or $sType > 5 Then $sType = 3
	Return _DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, $sType)
EndFunc   ;==>_NowTime

; #FUNCTION# ====================================================================================================================
; Author ........: /dev/null
; Modified.......:
; ===============================================================================================================================
Func _SetDate($iDay, $iMonth = 0, $iYear = 0)
	;============================================================================
	;== Some error checking
	;============================================================================
	If $iYear = 0 Then $iYear = @YEAR
	If $iMonth = 0 Then $iMonth = @MON
	If Not _DateIsValid($iYear & "/" & $iMonth & "/" & $iDay) Then Return 1

	Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)

	;============================================================================
	;== Get the local system time to fill up the SYSTEMTIME structure
	;============================================================================
	DllCall("kernel32.dll", "none", "GetLocalTime", "struct*", $tSYSTEMTIME)
	If @error Then Return SetError(@error, @extended, 0)

	;============================================================================
	;== Change the necessary values
	;============================================================================
	DllStructSetData($tSYSTEMTIME, "Day", $iDay)
	If $iMonth > 0 Then DllStructSetData($tSYSTEMTIME, "Month", $iMonth)
	If $iYear > 0 Then DllStructSetData($tSYSTEMTIME, "Year", $iYear)

	;============================================================================
	;== Set the new date
	;============================================================================
	Local $iReturn = _Date_Time_SetLocalTime($tSYSTEMTIME)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return Int($iReturn)
EndFunc   ;==>_SetDate

; #FUNCTION# ====================================================================================================================
; Author ........: /dev/null
; Modified.......:
; ===============================================================================================================================
Func _SetTime($iHour, $iMinute, $iSecond = 0, $iMSeconds = 0)
	;============================================================================
	;== Some error checking
	;============================================================================
	If $iHour < 0 Or $iHour > 23 Then Return 1
	If $iMinute < 0 Or $iMinute > 59 Then Return 1
	If $iSecond < 0 Or $iSecond > 59 Then Return 1
	If $iMSeconds < 0 Or $iMSeconds > 999 Then Return 1

	Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)

	;============================================================================
	;== Get the local system time to fill up the SYSTEMTIME structure
	;============================================================================
	DllCall("kernel32.dll", "none", "GetLocalTime", "struct*", $tSYSTEMTIME)
	If @error Then Return SetError(@error, @extended, 0)

	;============================================================================
	;== Change the necessary values
	;============================================================================
	DllStructSetData($tSYSTEMTIME, "Hour", $iHour)
	DllStructSetData($tSYSTEMTIME, "Minute", $iMinute)
	If $iSecond > 0 Then DllStructSetData($tSYSTEMTIME, "Seconds", $iSecond)
	If $iMSeconds > 0 Then DllStructSetData($tSYSTEMTIME, "MSeconds", $iMSeconds)

	;============================================================================
	;== Set the new time
	;============================================================================
	Local $iReturn = _Date_Time_SetLocalTime($tSYSTEMTIME)
	If @error Then Return SetError(@error + 10, @extended, 0)

	Return Int($iReturn)
EndFunc   ;==>_SetTime

; #FUNCTION# ====================================================================================================================
; Author ........: Marc <mrd at gmx de>
; Modified.......:
; ===============================================================================================================================
Func _TicksToTime($iTicks, ByRef $iHours, ByRef $iMins, ByRef $iSecs)
	If Number($iTicks) > 0 Then
		$iTicks = Int($iTicks / 1000)
		$iHours = Int($iTicks / 3600)
		$iTicks = Mod($iTicks, 3600)
		$iMins = Int($iTicks / 60)
		$iSecs = Mod($iTicks, 60)
		; If $iHours = 0 then $iHours = 24
		Return 1
	ElseIf Number($iTicks) = 0 Then
		$iHours = 0
		$iTicks = 0
		$iMins = 0
		$iSecs = 0
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_TicksToTime

; #FUNCTION# ====================================================================================================================
; Author ........: Marc <mrd at gmx de>
; Modified.......: SlimShady: added the default time and made parameters optional
; ===============================================================================================================================
Func _TimeToTicks($iHours = @HOUR, $iMins = @MIN, $iSecs = @SEC)
	If StringIsInt($iHours) And StringIsInt($iMins) And StringIsInt($iSecs) Then
		Local $iTicks = 1000 * ((3600 * $iHours) + (60 * $iMins) + $iSecs)
		Return $iTicks
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_TimeToTicks

; #FUNCTION# ====================================================================================================================
; Author ........: Tuape
; Modified.......: JdeB: modified to UDF standards & Doc., Change calculation logic.
; ===============================================================================================================================
Func _WeekNumberISO($iYear = @YEAR, $iMonth = @MON, $iDay = @MDAY)
	; Check for erroneous input in $Day, $Month & $Year
	If $iDay > 31 Or $iDay < 1 Then
		Return SetError(1, 0, -1)
	ElseIf Not __DateIsMonth($iMonth) Then
		Return SetError(2, 0, -1)
	ElseIf $iYear < 1 Or $iYear > 2999 Then
		Return SetError(3, 0, -1)
	EndIf

	Local $iDow = _DateToDayOfWeekISO($iYear, $iMonth, $iDay) - 1;
	Local $iDow0101 = _DateToDayOfWeekISO($iYear, 1, 1) - 1;

	If ($iMonth = 1 And 3 < $iDow0101 And $iDow0101 < 7 - ($iDay - 1)) Then
		;days before week 1 of the current year have the same week number as
		;the last day of the last week of the previous year
		$iDow = $iDow0101 - 1;
		$iDow0101 = _DateToDayOfWeekISO($iYear - 1, 1, 1) - 1;
		$iMonth = 12
		$iDay = 31
		$iYear = $iYear - 1
	ElseIf ($iMonth = 12 And 30 - ($iDay - 1) < _DateToDayOfWeekISO($iYear + 1, 1, 1) - 1 And _DateToDayOfWeekISO($iYear + 1, 1, 1) - 1 < 4) Then
		; days after the last week of the current year have the same week number as
		; the first day of the next year, (i.e. 1)
		Return 1;
	EndIf

	Return Int((_DateToDayOfWeekISO($iYear, 1, 1) - 1 < 4) + 4 * ($iMonth - 1) + (2 * ($iMonth - 1) + ($iDay - 1) + $iDow0101 - $iDow + 6) * 36 / 256)
EndFunc   ;==>_WeekNumberISO

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _WeekNumber
; Description ...: Find out the week number of current date OR date given in parameters
; Syntax.........: _WeekNumber ( [$iYear = @YEAR [, $iMonth = @MON [, $iDay = @MDAY [, $iWeekStart = 1]]]] )
; Parameters ....: $iYear      - Year value (default = current year)
;                  $iMonth    - Month value (default = current month)
;                  $iDay       - Day value (default = current day)
;                  $iWeekStart - Week starts from Sunday (1, default) or Monday (2)
; Return values .: Success - Returns week number of given date
;                  Failure - -1  and sets @error to:
;                  | 1 - On faulty parameters
;                  |99 - On non-acceptable weekstart and uses default (Sunday) as starting day
; Author ........: JdeB
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _WeekNumber($iYear = @YEAR, $iMonth = @MON, $iDay = @MDAY, $iWeekStart = 1)
	; Check for erroneous input in $Day, $Month & $Year
	If $iDay > 31 Or $iDay < 1 Then
		Return SetError(1, 0, -1)
	ElseIf Not __DateIsMonth($iMonth) Then
		Return SetError(3, 0, -1)
	ElseIf $iYear < 1 Or $iYear > 2999 Then
		Return SetError(4, 0, -1)
	ElseIf $iWeekStart < 1 Or $iWeekStart > 2 Then
		Return SetError(2, 0, -1)
	EndIf
	;
	Local $iStartWeek1, $iEndWeek1
	;$iDow = _DateToDayOfWeekISO($iYear, $iMonth, $iDay);
	Local $iDow0101 = _DateToDayOfWeekISO($iYear, 1, 1);
	Local $iDate = $iYear & '/' & $iMonth & '/' & $iDay
	;Calculate the Start and End date of Week 1 this year
	If $iWeekStart = 1 Then
		If $iDow0101 = 6 Then
			$iStartWeek1 = 0
		Else
			$iStartWeek1 = -1 * $iDow0101 - 1
		EndIf
		$iEndWeek1 = $iStartWeek1 + 6
	Else
		$iStartWeek1 = $iDow0101 * -1
		$iEndWeek1 = $iStartWeek1 + 6
	EndIf

	Local $iStartWeek1ny
	;$iStartWeek1Date = _DateAdd('d',$iStartWeek1,$iYear & '/01/01')
	Local $iEndWeek1Date = _DateAdd('d', $iEndWeek1, $iYear & '/01/01')
	;Calculate the Start and End date of Week 1 this Next year
	Local $iDow0101ny = _DateToDayOfWeekISO($iYear + 1, 1, 1);
	;  1 = start on Sunday / 2 = start on Monday
	If $iWeekStart = 1 Then
		If $iDow0101ny = 6 Then
			$iStartWeek1ny = 0
		Else
			$iStartWeek1ny = -1 * $iDow0101ny - 1
		EndIf
		;$IEndWeek1ny = $iStartWeek1ny + 6
	Else
		$iStartWeek1ny = $iDow0101ny * -1
		;$IEndWeek1ny = $iStartWeek1ny + 6
	EndIf
	Local $iStartWeek1Dateny = _DateAdd('d', $iStartWeek1ny, $iYear + 1 & '/01/01')
	;$iEndWeek1Dateny = _DateAdd('d',$IEndWeek1ny,$iYear+1 & '/01/01')
	;number of days after end week 1
	Local $iCurrDateDiff = _DateDiff('d', $iEndWeek1Date, $iDate) - 1
	;number of days before next week 1 start
	Local $iCurrDateDiffny = _DateDiff('d', $iStartWeek1Dateny, $iDate)
	;
	; Check for end of year
	If $iCurrDateDiff >= 0 And $iCurrDateDiffny < 0 Then Return 2 + Int($iCurrDateDiff / 7)
	; > week 1
	If $iCurrDateDiff < 0 Or $iCurrDateDiffny >= 0 Then Return 1
EndFunc   ;==>_WeekNumber

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _DaysInMonth
; Description ...: returns an Array that contains the numbers of days per month
; Syntax.........: _DaysInMonth ( $iYear )
; Parameters ....: $iYear      - Year value
; Return values .: Success - Array that contains the numbers of days per month
;                  Failure - none
; Author ........: Jos van der Zande / Jeremy Landes
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _DaysInMonth($iYear)
	Local $aDays = [12, 31, (_DateIsLeapYear($iYear) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	Return $aDays
EndFunc   ;==>_DaysInMonth

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Date_Time_CloneSystemTime
; Description ...: Clones a tagSYSTEMTIME structure
; Syntax.........: __Date_Time_CloneSystemTime ( $pSystemTime )
; Parameters ....: $pSystemTime - Pointer to a tagSYSTEMTIME structure
; Return values .: Success      - tagSYSTEMTIME structure containing the cloned system time
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function is used internally by Auto3Lib
; Related .......: $tagSYSTEMTIME
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Date_Time_CloneSystemTime($pSystemTime)
	Local $tSystemTime1 = DllStructCreate($tagSYSTEMTIME, $pSystemTime)
	Local $tSystemTime2 = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tSystemTime2, "Month", DllStructGetData($tSystemTime1, "Month"))
	DllStructSetData($tSystemTime2, "Day", DllStructGetData($tSystemTime1, "Day"))
	DllStructSetData($tSystemTime2, "Year", DllStructGetData($tSystemTime1, "Year"))
	DllStructSetData($tSystemTime2, "Hour", DllStructGetData($tSystemTime1, "Hour"))
	DllStructSetData($tSystemTime2, "Minute", DllStructGetData($tSystemTime1, "Minute"))
	DllStructSetData($tSystemTime2, "Second", DllStructGetData($tSystemTime1, "Second"))
	DllStructSetData($tSystemTime2, "MSeconds", DllStructGetData($tSystemTime1, "MSeconds"))
	DllStructSetData($tSystemTime2, "DOW", DllStructGetData($tSystemTime1, "DOW"))
	Return $tSystemTime2
EndFunc   ;==>__Date_Time_CloneSystemTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _Date_Time_CompareFileTime($tFileTime1, $tFileTime2)
	Local $aResult = DllCall("kernel32.dll", "long", "CompareFileTime", "struct*", $tFileTime1, "struct*", $tFileTime2)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_Date_Time_CompareFileTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_DOSDateTimeToFileTime($iFatDate, $iFatTime)
	Local $tTime = DllStructCreate($tagFILETIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "DosDateTimeToFileTime", "word", $iFatDate, "word", $iFatTime, "struct*", $tTime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tTime)
EndFunc   ;==>_Date_Time_DOSDateTimeToFileTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_DOSDateToArray($iDosDate)
	Local $aDate[3]

	$aDate[0] = BitAND($iDosDate, 0x1F)
	$aDate[1] = BitAND(BitShift($iDosDate, 5), 0x0F)
	$aDate[2] = BitAND(BitShift($iDosDate, 9), 0x3F) + 1980
	Return $aDate
EndFunc   ;==>_Date_Time_DOSDateToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_DOSDateTimeToArray($iDosDate, $iDosTime)
	Local $aDate[6]

	$aDate[0] = BitAND($iDosDate, 0x1F)
	$aDate[1] = BitAND(BitShift($iDosDate, 5), 0x0F)
	$aDate[2] = BitAND(BitShift($iDosDate, 9), 0x3F) + 1980
	$aDate[5] = BitAND($iDosTime, 0x1F) * 2
	$aDate[4] = BitAND(BitShift($iDosTime, 5), 0x3F)
	$aDate[3] = BitAND(BitShift($iDosTime, 11), 0x1F)
	Return $aDate
EndFunc   ;==>_Date_Time_DOSDateTimeToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_DOSDateTimeToStr($iDosDate, $iDosTime)
	Local $aDate = _Date_Time_DOSDateTimeToArray($iDosDate, $iDosTime)
	Return StringFormat("%02d/%02d/%04d %02d:%02d:%02d", $aDate[0], $aDate[1], $aDate[2], $aDate[3], $aDate[4], $aDate[5])
EndFunc   ;==>_Date_Time_DOSDateTimeToStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_DOSDateToStr($iDosDate)
	Local $aDate = _Date_Time_DOSDateToArray($iDosDate)
	Return StringFormat("%02d/%02d/%04d", $aDate[0], $aDate[1], $aDate[2])
EndFunc   ;==>_Date_Time_DOSDateToStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_DOSTimeToArray($iDosTime)
	Local $aTime[3]

	$aTime[2] = BitAND($iDosTime, 0x1F) * 2
	$aTime[1] = BitAND(BitShift($iDosTime, 5), 0x3F)
	$aTime[0] = BitAND(BitShift($iDosTime, 11), 0x1F)
	Return $aTime
EndFunc   ;==>_Date_Time_DOSTimeToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_DOSTimeToStr($iDosTime)
	Local $aTime = _Date_Time_DOSTimeToArray($iDosTime)
	Return StringFormat("%02d:%02d:%02d", $aTime[0], $aTime[1], $aTime[2])
EndFunc   ;==>_Date_Time_DOSTimeToStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_EncodeFileTime($iMonth, $iDay, $iYear, $iHour = 0, $iMinute = 0, $iSecond = 0, $iMSeconds = 0)
	Local $tSYSTEMTIME = _Date_Time_EncodeSystemTime($iMonth, $iDay, $iYear, $iHour, $iMinute, $iSecond, $iMSeconds)
	Return _Date_Time_SystemTimeToFileTime($tSYSTEMTIME)
EndFunc   ;==>_Date_Time_EncodeFileTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_EncodeSystemTime($iMonth, $iDay, $iYear, $iHour = 0, $iMinute = 0, $iSecond = 0, $iMSeconds = 0)
	Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($tSYSTEMTIME, "Month", $iMonth)
	DllStructSetData($tSYSTEMTIME, "Day", $iDay)
	DllStructSetData($tSYSTEMTIME, "Year", $iYear)
	DllStructSetData($tSYSTEMTIME, "Hour", $iHour)
	DllStructSetData($tSYSTEMTIME, "Minute", $iMinute)
	DllStructSetData($tSYSTEMTIME, "Second", $iSecond)
	DllStructSetData($tSYSTEMTIME, "MSeconds", $iMSeconds)
	Return $tSYSTEMTIME
EndFunc   ;==>_Date_Time_EncodeSystemTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_FileTimeToArray(ByRef $tFileTime)
	If ((DllStructGetData($tFileTime, 1) + DllStructGetData($tFileTime, 2)) = 0) Then Return SetError(10, 0, 0)
	Local $tSYSTEMTIME = _Date_Time_FileTimeToSystemTime($tFileTime)
	If @error Then Return SetError(@error, @extended, 0)

	Return _Date_Time_SystemTimeToArray($tSYSTEMTIME)
EndFunc   ;==>_Date_Time_FileTimeToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_FileTimeToStr(ByRef $tFileTime, $iFmt = 0)
	Local $aDate = _Date_Time_FileTimeToArray($tFileTime)
	If @error Then Return SetError(@error, @extended, "")

	If $iFmt Then
		Return StringFormat("%04d/%02d/%02d %02d:%02d:%02d", $aDate[2], $aDate[0], $aDate[1], $aDate[3], $aDate[4], $aDate[5])
	Else
		Return StringFormat("%02d/%02d/%04d %02d:%02d:%02d", $aDate[0], $aDate[1], $aDate[2], $aDate[3], $aDate[4], $aDate[5])
	EndIf
EndFunc   ;==>_Date_Time_FileTimeToStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _Date_Time_FileTimeToDOSDateTime($tFileTime)
	Local $aDate[2]

	Local $aResult = DllCall("kernel32.dll", "bool", "FileTimeToDosDateTime", "struct*", $tFileTime, "word*", 0, "word*", 0)
	If @error Then Return SetError(@error, @extended, $aDate)
	$aDate[0] = $aResult[2]
	$aDate[1] = $aResult[3]
	Return SetExtended($aResult[0], $aDate)
EndFunc   ;==>_Date_Time_FileTimeToDOSDateTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_FileTimeToLocalFileTime($tFileTime)
	Local $tLocal = DllStructCreate($tagFILETIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "FileTimeToLocalFileTime", "struct*", $tFileTime, "struct*", $tLocal)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tLocal)
EndFunc   ;==>_Date_Time_FileTimeToLocalFileTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_FileTimeToSystemTime($tFileTime)
	Local $tSystTime = DllStructCreate($tagSYSTEMTIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "FileTimeToSystemTime", "struct*", $tFileTime, "struct*", $tSystTime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tSystTime)
EndFunc   ;==>_Date_Time_FileTimeToSystemTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_GetFileTime($hFile)
	Local $aDate[3]

	$aDate[0] = DllStructCreate($tagFILETIME)
	$aDate[1] = DllStructCreate($tagFILETIME)
	$aDate[2] = DllStructCreate($tagFILETIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetFileTime", "handle", $hFile, "struct*", $aDate[0], "struct*", $aDate[1], "struct*", $aDate[2])
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aDate)
EndFunc   ;==>_Date_Time_GetFileTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_GetLocalTime()
	Local $tSystTime = DllStructCreate($tagSYSTEMTIME)
	DllCall("kernel32.dll", "none", "GetLocalTime", "struct*", $tSystTime)
	If @error Then Return SetError(@error, @extended, 0)
	Return $tSystTime
EndFunc   ;==>_Date_Time_GetLocalTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_GetSystemTime()
	Local $tSystTime = DllStructCreate($tagSYSTEMTIME)
	DllCall("kernel32.dll", "none", "GetSystemTime", "struct*", $tSystTime)
	If @error Then Return SetError(@error, @extended, 0)
	Return $tSystTime
EndFunc   ;==>_Date_Time_GetSystemTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_GetSystemTimeAdjustment()
	Local $aInfo[3]

	Local $aResult = DllCall("kernel32.dll", "bool", "GetSystemTimeAdjustment", "dword*", 0, "dword*", 0, "bool*", 0)
	If @error Then Return SetError(@error, @extended, 0)

	$aInfo[0] = $aResult[1]
	$aInfo[1] = $aResult[2]
	$aInfo[2] = $aResult[3] <> 0
	Return SetExtended($aResult[0], $aInfo)
EndFunc   ;==>_Date_Time_GetSystemTimeAdjustment

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_GetSystemTimeAsFileTime()
	Local $tFileTime = DllStructCreate($tagFILETIME)
	DllCall("kernel32.dll", "none", "GetSystemTimeAsFileTime", "struct*", $tFileTime)
	If @error Then Return SetError(@error, @extended, 0)
	Return $tFileTime
EndFunc   ;==>_Date_Time_GetSystemTimeAsFileTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_GetSystemTimes()
	Local $aInfo[3]
	$aInfo[0] = DllStructCreate($tagFILETIME)
	$aInfo[1] = DllStructCreate($tagFILETIME)
	$aInfo[2] = DllStructCreate($tagFILETIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetSystemTimes", "struct*", $aInfo[0], "struct*", $aInfo[1], "struct*", $aInfo[2])
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aInfo)
EndFunc   ;==>_Date_Time_GetSystemTimes

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_GetTickCount()
	Local $aResult = DllCall("kernel32.dll", "dword", "GetTickCount")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_Date_Time_GetTickCount

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _Date_Time_GetTimeZoneInformation()
	Local $tTimeZone = DllStructCreate($tagTIME_ZONE_INFORMATION)
	Local $aResult = DllCall("kernel32.dll", "dword", "GetTimeZoneInformation", "struct*", $tTimeZone)
	If @error Or $aResult[0] = -1 Then Return SetError(@error, @extended, 0)

	Local $aInfo[8]
	$aInfo[0] = $aResult[0]
	$aInfo[1] = DllStructGetData($tTimeZone, "Bias")
	$aInfo[2] = _WinAPI_WideCharToMultiByte(DllStructGetPtr($tTimeZone, "StdName"))
	$aInfo[3] = __Date_Time_CloneSystemTime(DllStructGetPtr($tTimeZone, "StdDate"))
	$aInfo[4] = DllStructGetData($tTimeZone, "StdBias")
	$aInfo[5] = _WinAPI_WideCharToMultiByte(DllStructGetPtr($tTimeZone, "DayName"))
	$aInfo[6] = __Date_Time_CloneSystemTime(DllStructGetPtr($tTimeZone, "DayDate"))
	$aInfo[7] = DllStructGetData($tTimeZone, "DayBias")
	Return $aInfo
EndFunc   ;==>_Date_Time_GetTimeZoneInformation

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _Date_Time_LocalFileTimeToFileTime($tLocalTime)
	Local $tFileTime = DllStructCreate($tagFILETIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "LocalFileTimeToFileTime", "struct*", $tLocalTime, "struct*", $tFileTime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tFileTime)
EndFunc   ;==>_Date_Time_LocalFileTimeToFileTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _Date_Time_SetFileTime($hFile, $tCreateTime, $tLastAccess, $tLastWrite)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetFileTime", "handle", $hFile, "struct*", $tCreateTime, "struct*", $tLastAccess, "struct*", $tLastWrite)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_Date_Time_SetFileTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_SetLocalTime($tSYSTEMTIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetLocalTime", "struct*", $tSYSTEMTIME)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, False)

	; The system uses UTC internally.  When you call SetLocalTime, the system uses the current time zone information to perform the
	; conversion, incuding the daylight saving time setting.  The system uses the daylight saving time setting of the current time,
	; not the new time you are setting.  This is a "feature" according to Microsoft.  In order to get around this, we have to  call
	; the function twice. The first call sets the internal time zone and the second call sets the actual time.
	$aResult = DllCall("kernel32.dll", "bool", "SetLocalTime", "struct*", $tSYSTEMTIME)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_Date_Time_SetLocalTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _Date_Time_SetSystemTime($tSYSTEMTIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetSystemTime", "struct*", $tSYSTEMTIME)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_Date_Time_SetSystemTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _Date_Time_SetSystemTimeAdjustment($iAdjustment, $bDisabled)
	; Enable system time privileged mode
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then Return SetError(@error + 10, @extended, False)
	_Security__SetPrivilege($hToken, "SeSystemtimePrivilege", True)
	Local $iError = @error
	Local $iLastError = @extended
	Local $bRet = False
	If Not @error Then
		; Set system time
		Local $aResult = DllCall("kernel32.dll", "bool", "SetSystemTimeAdjustment", "dword", $iAdjustment, "bool", $bDisabled)
		If @error Then
			$iError = @error
			$iLastError = @extended
		ElseIf $aResult[0] Then
			$bRet = True
		Else
			$iError = 20
			$iLastError = _WinAPI_GetLastError()
		EndIf

		; Disable system time privileged mode
		_Security__SetPrivilege($hToken, "SeSystemtimePrivilege", False)
		If Not $iError And @error Then $iError = 22

	EndIf
	_WinAPI_CloseHandle($hToken)

	Return SetError($iError, $iLastError, $bRet)
EndFunc   ;==>_Date_Time_SetSystemTimeAdjustment

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost (gafrost)
; ===============================================================================================================================
Func _Date_Time_SetTimeZoneInformation($iBias, $sStdName, $tStdDate, $iStdBias, $sDayName, $tDayDate, $iDayBias)
	Local $tStdName = _WinAPI_MultiByteToWideChar($sStdName)
	Local $tDayName = _WinAPI_MultiByteToWideChar($sDayName)
	Local $tZoneInfo = DllStructCreate($tagTIME_ZONE_INFORMATION)
	DllStructSetData($tZoneInfo, "Bias", $iBias)
	DllStructSetData($tZoneInfo, "StdName", DllStructGetData($tStdName, 1))
	_MemMoveMemory($tStdDate, DllStructGetPtr($tZoneInfo, "StdDate"), DllStructGetSize($tStdDate))
	DllStructSetData($tZoneInfo, "StdBias", $iStdBias)
	DllStructSetData($tZoneInfo, "DayName", DllStructGetData($tDayName, 1))
	_MemMoveMemory($tDayDate, DllStructGetPtr($tZoneInfo, "DayDate"), DllStructGetSize($tDayDate))
	DllStructSetData($tZoneInfo, "DayBias", $iDayBias)

	; Enable system time privileged mode
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then Return SetError(@error + 10, @extended, False)
	_Security__SetPrivilege($hToken, "SeSystemtimePrivilege", True)
	Local $iError = @error
	Local $iLastError = @extended
	Local $bRet = False
	If Not @error Then
		; Set time zone information
		Local $aResult = DllCall("kernel32.dll", "bool", "SetTimeZoneInformation", "struct*", $tZoneInfo)
		If @error Then
			$iError = @error
			$iLastError = @extended
		ElseIf $aResult[0] Then
			$iLastError = 0
			$bRet = True
		Else
			$iError = 20
			$iLastError = _WinAPI_GetLastError()
		EndIf

		; Disable system time privileged mode
		_Security__SetPrivilege($hToken, "SeSystemtimePrivilege", False)
		If Not $iError And @error Then $iError = 22
	EndIf
	_WinAPI_CloseHandle($hToken)

	Return SetError($iError, $iLastError, $bRet)
EndFunc   ;==>_Date_Time_SetTimeZoneInformation

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_SystemTimeToArray(ByRef $tSYSTEMTIME)
	Local $aInfo[8]
	$aInfo[0] = DllStructGetData($tSYSTEMTIME, "Month")
	$aInfo[1] = DllStructGetData($tSYSTEMTIME, "Day")
	$aInfo[2] = DllStructGetData($tSYSTEMTIME, "Year")
	$aInfo[3] = DllStructGetData($tSYSTEMTIME, "Hour")
	$aInfo[4] = DllStructGetData($tSYSTEMTIME, "Minute")
	$aInfo[5] = DllStructGetData($tSYSTEMTIME, "Second")
	$aInfo[6] = DllStructGetData($tSYSTEMTIME, "MSeconds")
	$aInfo[7] = DllStructGetData($tSYSTEMTIME, "DOW")
	Return $aInfo
EndFunc   ;==>_Date_Time_SystemTimeToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_SystemTimeToDateStr(ByRef $tSYSTEMTIME, $iFmt = 0)
	Local $aInfo = _Date_Time_SystemTimeToArray($tSYSTEMTIME)
	If @error Then Return SetError(@error, @extended, "")

	If $iFmt Then
		Return StringFormat("%04d/%02d/%02d", $aInfo[2], $aInfo[0], $aInfo[1])
	Else
		Return StringFormat("%02d/%02d/%04d", $aInfo[0], $aInfo[1], $aInfo[2])
	EndIf
EndFunc   ;==>_Date_Time_SystemTimeToDateStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_SystemTimeToDateTimeStr(ByRef $tSYSTEMTIME, $iFmt = 0)
	Local $aInfo = _Date_Time_SystemTimeToArray($tSYSTEMTIME)
	If @error Then Return SetError(@error, @extended, "")

	If $iFmt Then
		Return StringFormat("%04d/%02d/%02d %02d:%02d:%02d", $aInfo[2], $aInfo[0], $aInfo[1], $aInfo[3], $aInfo[4], $aInfo[5])
	Else
		Return StringFormat("%02d/%02d/%04d %02d:%02d:%02d", $aInfo[0], $aInfo[1], $aInfo[2], $aInfo[3], $aInfo[4], $aInfo[5])
	EndIf
EndFunc   ;==>_Date_Time_SystemTimeToDateTimeStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_SystemTimeToFileTime($tSYSTEMTIME)
	Local $tFileTime = DllStructCreate($tagFILETIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "SystemTimeToFileTime", "struct*", $tSYSTEMTIME, "struct*", $tFileTime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tFileTime)
EndFunc   ;==>_Date_Time_SystemTimeToFileTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; ===============================================================================================================================
Func _Date_Time_SystemTimeToTimeStr(ByRef $tSYSTEMTIME)
	Local $aInfo = _Date_Time_SystemTimeToArray($tSYSTEMTIME)
	Return StringFormat("%02d:%02d:%02d", $aInfo[3], $aInfo[4], $aInfo[5])
EndFunc   ;==>_Date_Time_SystemTimeToTimeStr

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _Date_Time_SystemTimeToTzSpecificLocalTime($tUTC, $tTimeZone = 0)
	Local $tLocalTime = DllStructCreate($tagSYSTEMTIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "SystemTimeToTzSpecificLocalTime", "struct*", $tTimeZone, "struct*", $tUTC, "struct*", $tLocalTime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tLocalTime)
EndFunc   ;==>_Date_Time_SystemTimeToTzSpecificLocalTime

; #FUNCTION# ====================================================================================================================
; Author ........: Paul Campbell (PaulIA)
; Modified.......: jpm
; ===============================================================================================================================
Func _Date_Time_TzSpecificLocalTimeToSystemTime($tLocalTime, $tTimeZone = 0)
	Local $tUTC = DllStructCreate($tagSYSTEMTIME)
	Local $aResult = DllCall("kernel32.dll", "bool", "TzSpecificLocalTimeToSystemTime", "struct*", $tTimeZone, "struct*", $tLocalTime, "struct*", $tUTC)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tUTC)
EndFunc   ;==>_Date_Time_TzSpecificLocalTimeToSystemTime
