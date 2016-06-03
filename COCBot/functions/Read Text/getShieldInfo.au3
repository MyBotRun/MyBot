
; #FUNCTION# ====================================================================================================================
; Name ..........: getShieldInfo
; Description ...: Determines if personal shield exists and returns type/time data
; Syntax ........: getShieldInfo()
; Parameters ....: none
; Return values .: Returns Array =  $aPBReturnResult
; ...............: [0]=String shield type, [1]=String Shield remaining format = "00:00:00", [2]=String Shield expire date/time
; ...............: Sets @error if buttons not found properly or problem with OCR of shield time, and sets @extended with string error message
; Author ........: MonkeyHunter (2016-01)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getShieldInfo()

	Local $sTimeResult = ""
	Local $aString[3]
	Local $iShieldSeconds
	Local $iDay = 0, $iHour = 0, $iMin = 0, $iSec = 0
	Local $aPBReturnResult[3] = ["", "", ""] ; reset return values
	; $aPBReturnResult[3] = [0] = string type of shield, [1] = string shield time remaining,  [2] = string Shield expire date/time used by _DateDiff()
	$aPBReturnResult[1] = StringFormat("%02s", ($iDay * 24) + $iHour) & ":" & StringFormat("%02s", $iMin) & ":" & StringFormat("%02s", $iSec)

	If IsMainPage() = False Then ; check for main page or do not try
		Setlog("unable to read shield information", $COLOR_RED)
		Return
	EndIf

	Select ; Check for shield type
		Case _CheckPixel($aNoShield, $bCapturePixel)
			$aPBReturnResult[0] = "none"
			If $debugSetlog = 1 Then Setlog("No shield active", $COLOR_PURPLE)
			Return $aPBReturnResult ; return with zero value
		Case _CheckPixel($aHaveShield, $bCapturePixel)
			$aPBReturnResult[0] = "shield" ; check for shield
			If $debugSetlog = 1 Then Setlog("Shield Active", $COLOR_PURPLE)
		Case _CheckPixel($aHavePerGuard, $bCapturePixel)
			$aPBReturnResult[0] = "guard" ; check for personal guard timer
			If $debugSetlog = 1 Then Setlog("Guard Active", $COLOR_PURPLE)
		Case Else
			Setlog("Sorry, Monkey needs more bananas to read shield type", $COLOR_RED) ; Check for pixel colors errors!
			SetError(1, "Bad shield pixel read")
			Return
	EndSelect

	$sTimeResult = getOcrGuardShield(484, 21) ; read Shield time
	If $debugSetlog = 1 Then Setlog("OCR Shield Time= " & $sTimeResult, $COLOR_PURPLE)
	If $sTimeResult = "" Then ; try a 2nd time after a short delay if slow PC and null read
		If _Sleep($iPersonalShield2) Then Return ; pause for slow PC
		$sTimeResult = getOcrGuardShield(484, 21) ; read Shield time
		If $debugSetlog = 1 Then Setlog("OCR2 Shield Time= " & $sTimeResult, $COLOR_PURPLE)
		If $sTimeResult = "" Then ; error if no read value
			$aPBReturnResult[1] = '00:00:00'
			Setlog("strange error, no shield value found?", $COLOR_RED)
			SetError(2, "Bad time value OCR")
			Return $aPBReturnResult ; return zero value
		EndIf
	EndIf

	If _Sleep($iPersonalShield3) Then Return ; improve pause/stop button response

	$aString = StringSplit($sTimeResult, " ") ; split hours/minutes or minutes/seconds
	Switch $aString[0]
		Case 1
			If StringInStr($aString[1], "s", $STR_NOCASESENSEBASIC) Then $iSec = Number($aString[1])
		Case 2
			Select
				Case StringInStr($aString[1], "d", $STR_NOCASESENSEBASIC)
					$iDay = Number($aString[1])
					If StringInStr($aString[2], "h", $STR_NOCASESENSEBASIC) Then
						$iHour = Number($aString[2])
					EndIf
				Case StringInStr($aString[1], "h", $STR_NOCASESENSEBASIC)
					$iHour = Number($aString[1])
					If StringInStr($aString[2], "m", $STR_NOCASESENSEBASIC) Then
						$iMin = Number($aString[2])
					EndIf
				Case StringInStr($aString[1], "m", $STR_NOCASESENSEBASIC)
					$iMin = Number($aString[1])
					If StringInStr($aString[2], "s", $STR_NOCASESENSEBASIC) Then
						$iSec = Number($aString[2])
					EndIf
				Case Else
					Setlog("strange error, unexpected shield value?", $COLOR_RED)
					SetError(3, "Error processing time string")
					Return $aPBReturnResult ; return zero value
			EndSelect
		Case Else
			Setlog("Error processing time string: " & $sTimeResult, $COLOR_RED)
			SetError(4, "Error processing time string")
			Return $aPBReturnResult ; return zero value
	EndSwitch

	$aPBReturnResult[1] = StringFormat("%02s", ($iDay * 24) + $iHour) & ":" & StringFormat("%02s", $iMin) & ":" & StringFormat("%02s", $iSec)
	If $debugSetlog = 1 Then Setlog("Shield Time String = " & $aPBReturnResult[1], $COLOR_PURPLE)

	$iShieldSeconds = ($iDay * 86400) + ($iHour * 3600) + ($iMin * 60) + $iSec ; add time into total seconds
	If $debugSetlog = 1 Then Setlog("Computed Shield Seconds = " & $iShieldSeconds, $COLOR_PURPLE)

	$aPBReturnResult[2] = _DateAdd('s', $iShieldSeconds, _NowCalc()) ; Find actual expire time from NOW.
	If @error Then Setlog("_DateAdd error= " & @error, $COLOR_RED)
	If $debugSetlog = 1 Then Setlog("Shield expires at: " & $aPBReturnResult[2], $COLOR_BLUE)

	Return $aPBReturnResult

EndFunc   ;==>getShieldInfo
