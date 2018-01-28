; #FUNCTION# ====================================================================================================================
; Name ..........: getPBTime
; Description ...: Opens PB Info window, reads PBT time, returns date/time that PBT starts
; Syntax ........: getPBTime()
; Parameters ....:
; Return values .: Returns string = $sPBTReturnResult; formatted to be usable by _DateDiff for comparison
; ...............:
; ...............: Sets @error if problem, and sets @extended with string error message
; Author ........: MonkeyHunter (02-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
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
		SetLog("Not on Main page to read PB information", $COLOR_ERROR)
		Return
	EndIf

	ClickP($aShieldInfoButton) ; click on PBT info icon
	If _Sleep($DELAYPERSONALSHIELD3) Then Return

	Local $iCount = 0
	While _CheckPixel($aIsShieldInfo, $g_bCapturePixel) = False ; wait for open PB info window
		If _Sleep($DELAYPERSONALSHIELD2) Then Return
		$Result = getAttackDisable(180, 156 + $g_iMidOffsetY) ; Try to grab Ocr for PBT warning message as it can randomly block pixel check
		If $g_bDebugSetlog Then SetDebugLog("OCR PBT early warning= " & $Result, $COLOR_DEBUG)
		If (StringLen($Result) > 3) And StringRegExp($Result, "[a-w]", $STR_REGEXPMATCH) Then ; Check string for valid characters
			SetLog("Personal Break Warning found!", $COLOR_INFO)
			$bPBTStart = True
			ExitLoop
		EndIf
		$iCount += 1
		If $iCount > 20 Then ; Wait ~10-12 seconds for window to open before error return
			SetLog("PBT information window failed to open", $COLOR_DEBUG)
			If $g_bDebugImageSave Then DebugImageSave("PBTInfo_", $g_bCapturePixel, "png", False)
			ClickP($aAway, 1, 0, "#9999") ; close window if opened
			If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close
			Return
		EndIf
	WEnd

	If _CheckPixel($aIsShieldInfo, $g_bCapturePixel) Or $bPBTStart Then ; PB Info window open?

		$sTimeResult = getOcrPBTtime(555, 499 + $g_iMidOffsetY) ; read PBT time
		If $g_bDebugSetlog Then SetDebugLog("OCR PBT Time= " & $sTimeResult, $COLOR_DEBUG)
		If $sTimeResult = "" Then ; try a 2nd time after a short delay if slow PC and null read
			If _Sleep($DELAYPERSONALSHIELD2) Then Return ; pause for slow PC
			$sTimeResult = getOcrPBTtime(555, 499 + $g_iMidOffsetY) ; read PBT time
			If $g_bDebugSetlog Then SetDebugLog("OCR2 PBT Time= " & $sTimeResult, $COLOR_DEBUG)
			If $sTimeResult = "" And $bPBTStart = False Then ; error if no read value
				SetLog("strange error, no PBT value found?", $COLOR_ERROR)
				SetError(1, "Bad OCR of PB time value ")
				ClickP($aAway, 1, 0, "#9999") ; close window
				If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close
				Return
			EndIf
		EndIf

		If _Sleep($DELAYRESPOND) Then Return ; improve pause/stop button response

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
						SetLog("strange error, unexpected PBT value? |" & $aString[1], $COLOR_ERROR)
						SetError(2, "Error processing time string")
						ClickP($aAway, 1, 0, "#9999") ; close window
						If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close
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
						SetLog("strange error, unexpected PBT value? |" & $aString[1] & "|" & $aString[2], $COLOR_ERROR)
						SetError(3, "Error processing time string")
						ClickP($aAway, 1, 0, "#9999") ; close window
						If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close
						Return
				EndSelect
			Case Else ; Not likely condition, but just in case needed.
				If $bPBTStart = False Then
					SetLog("Error processing PBT time string: " & $sTimeResult, $COLOR_ERROR)
					SetError(4, "Error processing time string")
					ClickP($aAway, 1, 0, "#9999") ; close window
					If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close
					Return
				Else
					SetLog("Error processing PBT time string: " & $sTimeResult, $COLOR_INFO)
					SetLog("Continue due PB starting now", $COLOR_SUCCESS)
				EndIf
		EndSwitch

		$iPBTSeconds = ($iHour * 3600) + ($iMin * 60) + $iSec ; convert PB time into total seconds
		If $g_bDebugSetlog Then SetDebugLog("Computed PBT Seconds = " & $iPBTSeconds, $COLOR_DEBUG)

		If $bPBTStart Then
			$sPBTReturnResult = _DateAdd('s', -10, _NowCalc()) ; Calc expire time -10 seconds from now.
		Else
			$sPBTReturnResult = _DateAdd('s', $iPBTSeconds, _NowCalc()) ; Calc actual expire time from now.
		EndIf
		If @error Then SetLog("_DateAdd error= " & @error, $COLOR_ERROR)
		If $g_bDebugSetlog Then SetDebugLog("PBT starts: " & $sPBTReturnResult, $COLOR_DEBUG)
		If _Sleep($DELAYPERSONALSHIELD1) Then Return

		ClickP($aAway, 1, 0, "#9999") ; close window
		If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close

		Return $sPBTReturnResult
	Else
		If $g_bDebugSetlog Then SetDebugLog("PB Info window failed to open for PB Time OCR", $COLOR_ERROR)
	EndIf

EndFunc   ;==>getPBTime
