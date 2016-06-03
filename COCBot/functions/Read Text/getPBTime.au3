; #FUNCTION# ====================================================================================================================
; Name ..........: getPBTime
; Description ...: Opens PB Info window, reads PBT time, returns date/time that PBT starts
; Syntax ........: getPBTime()
; Parameters ....:
; Return values .: Returns string = $sPBTReturnResult; formatted to be usable by _DateDiff for comparison
; ...............:
; ...............: Sets @error if problem, and sets @extended with string error message
; Author ........: MonkeyHunter (2016-02)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: below function:
; ===============================================================================================================================
Func getPBTime()

	Local $sTimeResult = ""
	Local $aString[3]
	Local $bPBTStart = False
	Local $iPBTSeconds, $Result
	Local $iHour = 0, $iMin = 0, $iSec = 0
	Local $sPBTReturnResult = ""

	If IsMainPage() = False Then ; check for main page or do not try
		Setlog("Not on Main page to read PB information", $COLOR_RED)
		Return
	EndIf

	ClickP($aShieldInfoButton) ; click on PBT info icon
	If _Sleep($iPersonalShield3) Then Return

	Local $iCount = 0
	While _CheckPixel($aIsShieldInfo, $bCapturePixel) = False ; wait for open PB info window
		If _Sleep($iPersonalShield2) Then Return
		$Result = getAttackDisable(180, 156 + $midOffsetY) ; Try to grab Ocr for PBT warning message as it can randomly block pixel check
		If $debugSetlog = 1 Then Setlog("OCR PBT early warning= " & $Result, $COLOR_PURPLE)
		If (StringLen($Result) > 3) And StringRegExp($Result, "[a-w]", $STR_REGEXPMATCH) Then ; Check string for valid characters
			Setlog("Personal Break Warning found!", $COLOR_BLUE)
			$bPBTStart = True
			ExitLoop
		EndIf
		$iCount += 1
		If $iCount > 20 Then ; Wait ~10-12 seconds for window to open before error return
			Setlog("PBT information window failed to open", $COLOR_PURPLE)
			If $debugImageSave = 1 Then DebugImageSave("PBTInfo_", $bCapturePixel, "png", False)
			ClickP($aAway, 1, 0, "#9999") ; close window if opened
			If _Sleep($iPersonalShield2) Then Return ; wait for close
			Return
		EndIf
	WEnd

	If _CheckPixel($aIsShieldInfo, $bCapturePixel) Or $bPBTStart Then ; PB Info window open?

		$sTimeResult = getOcrPBTtime(555, 499 + $midOffsetY) ; read PBT time
		If $debugSetlog = 1 Then Setlog("OCR PBT Time= " & $sTimeResult, $COLOR_PURPLE)
		If $sTimeResult = "" Then ; try a 2nd time after a short delay if slow PC and null read
			If _Sleep($iPersonalShield2) Then Return ; pause for slow PC
			$sTimeResult = getOcrPBTtime(555, 499 + $midOffsetY) ; read PBT time
			If $debugSetlog = 1 Then Setlog("OCR2 PBT Time= " & $sTimeResult, $COLOR_PURPLE)
			If $sTimeResult = "" And $bPBTStart = False Then ; error if no read value
				Setlog("strange error, no PBT value found?", $COLOR_RED)
				SetError(1, "Bad OCR of PB time value ")
				ClickP($aAway, 1, 0, "#9999") ; close window
				If _Sleep($iPersonalShield2) Then Return ; wait for close
				Return
			EndIf
		EndIf

		If _Sleep($iDelayRespond) Then Return ; improve pause/stop button response

		$aString = StringSplit($sTimeResult, " ") ; split hours/minutes or minutes/seconds
		Switch $aString[0]
			Case 1 ; Only one field split from OCR
				Select
					Case StringInStr($aString[1], "s", $STR_NOCASESENSEBASIC)
						$iSec = Number($aString[1])
					Case StringInStr($aString[1], "m", $STR_NOCASESENSEBASIC)
						$iMin = Number($aString[2])
					Case StringInStr($aString[1], "h", $STR_NOCASESENSEBASIC)
						$iHour = Number($aString[1])
					Case Else
						Setlog("strange error, unexpected PBT value? |" & $aString[1], $COLOR_RED)
						SetError(2, "Error processing time string")
						ClickP($aAway, 1, 0, "#9999") ; close window
						If _Sleep($iPersonalShield2) Then Return ; wait for close
						Return
				EndSelect
			Case 2 ; 2 fields split from OCR
				Select
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
						Setlog("strange error, unexpected PBT value? |" & $aString[1] & "|" & $aString[2], $COLOR_RED)
						SetError(3, "Error processing time string")
						ClickP($aAway, 1, 0, "#9999") ; close window
						If _Sleep($iPersonalShield2) Then Return ; wait for close
						Return
				EndSelect
			Case Else ; Not likely condition, but just in case needed.
				If $bPBTStart = False Then
					Setlog("Error processing PBT time string: " & $sTimeResult, $COLOR_RED)
					SetError(4, "Error processing time string")
					ClickP($aAway, 1, 0, "#9999") ; close window
					If _Sleep($iPersonalShield2) Then Return ; wait for close
					Return
				Else
					Setlog("Error processing PBT time string: " & $sTimeResult, $COLOR_BLUE)
					Setlog("Continue due PB starting now", $COLOR_GREEN)
				EndIf
		EndSwitch

		$iPBTSeconds = ($iHour * 3600) + ($iMin * 60) + $iSec ; convert PB time into total seconds
		If $debugSetlog = 1 Then Setlog("Computed PBT Seconds = " & $iPBTSeconds, $COLOR_PURPLE)

		If $bPBTStart Then
			$sPBTReturnResult = _DateAdd('s', -10, _NowCalc()) ; Calc expire time -10 seconds from now.
		Else
			$sPBTReturnResult = _DateAdd('s', $iPBTSeconds, _NowCalc()) ; Calc actual expire time from now.
		EndIf
		If @error Then Setlog("_DateAdd error= " & @error, $COLOR_RED)
		If $debugSetlog = 1 Then Setlog("PBT starts: " & $sPBTReturnResult, $COLOR_PURPLE)
		If _Sleep($iPersonalShield1) Then Return

		ClickP($aAway, 1, 0, "#9999") ; close window
		If _Sleep($iPersonalShield2) Then Return ; wait for close

		Return $sPBTReturnResult
	Else
		If $debugSetlog = 1 Then SetLog("PB Info window failed to open for PB Time OCR", $COLOR_RED)
	EndIf

EndFunc   ;==>getPBTime
