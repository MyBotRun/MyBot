
; #FUNCTION# ====================================================================================================================
; Name ..........: IsTrainPage & IsAttackPage & IsMainPage & IsMainChatOpenPage & IsClanInfoPage & IsLaunchAttackPage &
;                  IsEndBattlePage & IsReturnHomeBattlePage
; Description ...: Verify if you are in the correct window...
; Author ........: Sardo (2015)
; Modified ......: ProMac 2015, MonkeyHunter (2015-12)
; Remarks .......: This file is part of MyBot Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================


Func IsTrainPage()
	Local $i = 0

	While $i < 30
		;If $DebugSetlog = 1 Then SetLog( "TrainPage:(" & _GetPixelColor(717, 120, True) & ",Expected:E0070A)(" & _GetPixelColor(762, 328, True) & ",Expected:F18439)", $COLOR_ORANGE)
		If _ColorCheck(_GetPixelColor(717, 120 + $midOffsetY, True), Hex(0xE0070A, 6), 10) And _ColorCheck(_GetPixelColor(762, 328 + $midOffsetY, True), Hex(0xF18439, 6), 10) Then ExitLoop
		If _Sleep($iDelayIsTrainPage1) Then ExitLoop
		$i += 1
	WEnd

	If $i <= 28 Then
		If $DebugSetlog = 1 Or $DebugClick = 1 Then Setlog("**Train Window OK**", $COLOR_ORANGE)
		Return True
	Else
		SetLog("Cannot find train Window.", $COLOR_RED)   ; in case of $i = 29 in while loop
		;Return False
		if $debugImageSave= 1 Then DebugImageSave("IsTrainPage_")
		Return True
	EndIf

EndFunc   ;==>IsTrainPage

Func IsAttackPage()
	Local $result

	$result = _ColorCheck(_GetPixelColor($aIsAttackPage[0], $aIsAttackPage[1], True), Hex($aIsAttackPage[2], 6), $aIsAttackPage[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Attack Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Attack Window FAIL**", $COLOR_ORANGE)
		;Return False
		if $debugImageSave= 1 Then DebugImageSave("IsAttackPage_")
		Return True
	EndIf

EndFunc   ;==>IsAttackPage

Func IsAttackWhileShieldPage()
	Local $result

	$result = _CheckPixel($aIsAttackShield, $bCapturePixel)

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Attack Shield Window Open**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Attack Shield Window not open**", $COLOR_ORANGE)
		if $debugImageSave = 1 Then
			DebugImageSave("IsAttackWhileShieldPage_")
			Return True
		EndIf
		Return False
	EndIf

EndFunc   ;==>IsAttackWhileShieldPage

Func IsMainPage()
	Local $result

	$result = _CheckPixel($aIsMain, $bCapturePixel)

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Main Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Main Window FAIL**", $COLOR_ORANGE)
		;Return False
		if $debugImageSave= 1 Then DebugImageSave("IsMainPage_")
		Return True

	EndIf

EndFunc   ;==>IsMainPage

Func IsMainChatOpenPage() ;main page open chat
	Local $result

	$result = _ColorCheck(_GetPixelColor($aChatTab[0], $aChatTab[1], True), Hex($aChatTab[2], 6), $aChatTab[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Chat Open Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Chat Open Window FAIL** " & $aChatTab[0] &"," & $aChatTab[1] & " " & _GetPixelColor($aChatTab[0], $aChatTab[1], True), $COLOR_ORANGE)
		;Return False
		if $debugImageSave= 1 Then DebugImageSave("IsMainChatOpenPage_")
		Return True
	EndIf

EndFunc   ;==>IsMainChatOpenPage


Func IsClanInfoPage()
	Local $result

	$result = _ColorCheck(_GetPixelColor($aPerkBtn[0], $aPerkBtn[1], True), Hex($aPerkBtn[2], 6), $aPerkBtn[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Clan Info Window OK**", $COLOR_ORANGE)
		Return True
	Else
		$result = _ColorCheck(_GetPixelColor(214, 106, True), Hex(0xFFFFFF, 6), 1) and  _ColorCheck(_GetPixelColor(815, 58, True), Hex(0xD80402, 6), 5) ; if are not in a clan
		If $result Then
			If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Clan Info Window OK**", $COLOR_ORANGE)
			SetLog("Join a Clan to donate and receive troops!", $COLOR_ORANGE)
			Return True
		Else
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Clan Info Window FAIL**", $COLOR_ORANGE)
		;Return False
		if $debugImageSave= 1 Then DebugImageSave("IsClanInfoPage_")
		Return True
		EndIf
	EndIf

EndFunc   ;==>IsClanInfoPage


Func IsLaunchAttackPage()
	Local $result

	$result = _ColorCheck(_GetPixelColor($aFindMatchButton[0], $aFindMatchButton[1], True), Hex($aFindMatchButton[2], 6), $aFindMatchButton[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Launch Attack Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Launch Attack Window FAIL**", $COLOR_ORANGE)
		;Return False
		if $debugImageSave= 1 Then DebugImageSave("IsLaunchAttackPage_")
		Return True
	EndIf

EndFunc   ;==>IsLaunchAttackPage

Func IsEndBattlePage()
	Local $result

	$result = _ColorCheck(_GetPixelColor($aConfirmSurrender[0], $aConfirmSurrender[1], True), Hex($aConfirmSurrender[2], 6), $aConfirmSurrender[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**End Battle Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**End Battle Window FAIL**", $COLOR_ORANGE)
		;Return False
		if $debugImageSave= 1 Then DebugImageSave("IsEndBattlePage_")
		Return True
	EndIf

EndFunc   ;==>IsEndBattlePage

Func IsReturnHomeBattlePage($useReturnValue = False, $makeDebugImageScreenshot = True)
	; $makeDebugImageScreenshot = false
	;    used to check, at end of algorithm_allTroops, if battle already end and then can bypass test
	;    for goldelixirchange and activate heroes

	Local $result

	$result = _ColorCheck(_GetPixelColor($aReturnHomeButton[0], $aReturnHomeButton[1], True), Hex($aReturnHomeButton[2], 6), $aReturnHomeButton[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 then SetLog("**Return Home Battle Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If ( $DebugSetlog = 1 Or $DebugClick = 1 ) and ($makeDebugImageScreenshot = True) then SetLog("**Return Home Battle Window FAIL**", $COLOR_ORANGE)
		if $debugImageSave= 1 and $makeDebugImageScreenshot = True Then DebugImageSave("IsReturnHomeBattlePage_")
		If $useReturnValue = True Then
		 Return False
	    Else
		 Return True
	    EndIf
	EndIf

EndFunc   ;==>IsReturnHomeBattlePage
