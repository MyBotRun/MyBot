; #FUNCTION# ====================================================================================================================
; Name ..........: getPBTInfo
; Description ...: Determines if Shield/Guard exists, reads PBT time, computes time till PBT starts, and returns results in array
; Syntax ........: getPBTInfo()
; Parameters ....:
; Return values .: Returns Array =  $aPBTReturnResult
; ...............: [0]=String shield type, [1]=String PBT time format = "00:00:00", [2]=String date/time till PBT start
; ...............: Sets @error if buttons not found properly or problem with OCR of PBT time, and sets @extended with string error message
; Author ........: MonkeyHunter (2016-02)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: below function:
; ===============================================================================================================================
Func getPBTInfo()

	Local $sTimeResult = ""
	Local $aString[3]
	Local $bPBTStart = False
	Local $iPBTSeconds, $Result
	Local $iHour = 0, $iMin = 0, $iSec = 0
	Local $aPBTReturnResult[3] = ["", "", ""] ; reset return values
	; $aPBTReturnResult[3] = [0] = string type of shield, [1] = string PBT time remaining,  [2] = string PBT start date/time used by _DateDiff()

	$aPBTReturnResult[1] = StringFormat("%02s", $iHour) & ":" & StringFormat("%02s", $iMin) & ":" & StringFormat("%02s", $iSec)

	If IsMainPage() = False Then ; check for main page or do not try
		Setlog("Not on Main page to read PBT information", $COLOR_RED)
		Return
	EndIf

	Select ; Check for Shield type
		Case _CheckPixel($aNoShield, $bCapturePixel)
			$aPBTReturnResult[0] = "none"
			If $debugSetlog = 1 Then Setlog("No shield active", $COLOR_PURPLE)
		Case _CheckPixel($aHaveShield, $bCapturePixel)
			$aPBTReturnResult[0] = "shield" ; check for shield
			If $debugSetlog = 1 Then Setlog("Shield Active", $COLOR_PURPLE)
		Case _CheckPixel($aHavePerGuard, $bCapturePixel)
			$aPBTReturnResult[0] = "guard" ; check for personal guard timer
			If $debugSetlog = 1 Then Setlog("Guard Active", $COLOR_PURPLE)
		Case Else
			Setlog("Sorry, Monkey needs more bananas to read shield type", $COLOR_RED) ; Check for pixel colors errors!
			If $debugImageSave = 1 Then DebugImageSave("ShieldInfo_", $bCapturePixel, "png", False)
			SetError(1, "Bad shield type pixel read")
			Return
	EndSelect

	PureClickP($aShieldInfoButton) ; click on PBT info icon
	If _Sleep($iPersonalShield3) Then Return

	Local $iCount = 0
	While _CheckPixel($aIsShieldInfo, $bCapturePixel) = False ; check for open shield info window
		If _Sleep($iPersonalShield2) Then Return
		$Result = getAttackDisable(180, 156 + $midOffsetY) ; Try to grab Ocr for PBT warning message as it can randomly block pixel check
		If $debugSetlog = 1 Then Setlog("OCR PBT warning= " & $Result, $COLOR_PURPLE)
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

	If _CheckPixel($aIsShieldInfo, $bCapturePixel) Or $bPBTStart Then

		$sTimeResult = getOcrPBTtime(555, 499 + $midOffsetY) ; read PBT time
		If $debugSetlog = 1 Then Setlog("OCR PBT Time= " & $sTimeResult, $COLOR_PURPLE)
		If $sTimeResult = "" Then ; try a 2nd time after a short delay if slow PC and null read
			If _Sleep($iPersonalShield2) Then Return ; pause for slow PC
			$sTimeResult = getOcrPBTtime(555, 499 + $midOffsetY) ; read PBT time
			If $debugSetlog = 1 Then Setlog("OCR2 PBT Time= " & $sTimeResult, $COLOR_PURPLE)
			If $sTimeResult = "" Then ; error if no read value
				Setlog("strange error, no PBT value found?", $COLOR_RED)
				SetError(2, "Bad time value OCR read")
				ClickP($aAway, 1, 0, "#9999") ; close window
				If _Sleep($iPersonalShield2) Then Return ; wait for close
				Return $aPBTReturnResult ; return zero value
			EndIf
		EndIf

		If _Sleep($iPersonalShield3) Then Return ; improve pause/stop button response

		$aString = StringSplit($sTimeResult, " ") ; split hours/minutes or minutes/seconds
		Switch $aString[0]
			Case 1
				If StringInStr($aString[1], "s", $STR_NOCASESENSEBASIC) Then $iSec = Number($aString[1])
			Case 2
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
						Setlog("strange error, unexpected PBT value?", $COLOR_RED)
						SetError(3, "Error processing time string")
						ClickP($aAway, 1, 0, "#9999") ; close window
						If _Sleep($iPersonalShield2) Then Return ; wait for close
						Return $aPBTReturnResult ; return zero value
				EndSelect
			Case Else
				Setlog("Error processing PBT time string: " & $sTimeResult, $COLOR_RED)
				SetError(4, "Error processing time string")
				ClickP($aAway, 1, 0, "#9999") ; close window
				If _Sleep($iPersonalShield2) Then Return ; wait for close
				Return $aPBTReturnResult ; return zero value
		EndSwitch

		$aPBTReturnResult[1] = StringFormat("%02s", $iHour) & ":" & StringFormat("%02s", $iMin) & ":" & StringFormat("%02s", $iSec)
		If $debugSetlog = 1 Then Setlog("PBT Time String = " & $aPBTReturnResult[1], $COLOR_PURPLE)

		$iPBTSeconds = ($iHour * 3600) + ($iMin * 60) + $iSec ; add time into total seconds
		If $debugSetlog = 1 Then Setlog("Computed PBT Seconds = " & $iPBTSeconds, $COLOR_PURPLE)

		If $bPBTStart Then
			$aPBTReturnResult[2] = _DateAdd('s', -10, _NowCalc()) ; Calc time -10 seconds before now.
		Else
			$aPBTReturnResult[2] = _DateAdd('s', $iPBTSeconds, _NowCalc()) ; Calc actual expire time from now.
		EndIf
		If @error Then Setlog("_DateAdd error= " & @error, $COLOR_RED)
		If $debugSetlog = 1 Then Setlog("PBT starts: " & $aPBTReturnResult[2], $COLOR_BLUE)
		If _Sleep($iPersonalShield1) Then Return

		ClickP($aAway, 1, 0, "#9999") ; close window
		If _Sleep($iPersonalShield2) Then Return ; wait for close

		Return $aPBTReturnResult
	Else
		If $debugSetlog = 1 Then SetLog("PBT Info window failed to open for PBT OCR", $COLOR_RED)
	EndIf

EndFunc   ;==>getPBTInfo
