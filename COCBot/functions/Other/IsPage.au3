
; #FUNCTION# ====================================================================================================================
; Name ..........: IsTrainPage & IsAttackPage & IsMainPage & IsMainChatOpenPage & IsClanInfoPage & IsLaunchAttackPage &
;                  IsEndBattlePage & IsReturnHomeBattlePage
; Description ...: Verify if you are in the correct window...
; Author ........: Sardo (2015)
; Modified ......: ProMac 2015, MonkeyHunter (2015-12)
; Remarks .......: This file is part of MyBot Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================


Func IsTrainPage($writelogs = True)
	Local $i = 0

	While $i < 30
		;If $DebugSetlog = 1 Then SetLog( "TrainPage:(" & _GetPixelColor($aIsTrainPgChk1, $bCapturePixel) & ",Expected:E0070A)(" & _GetPixelColor($aIsTrainPgChk2, $bCapturePixel) & ",Expected:F18439)", $COLOR_ORANGE)
		If _CheckPixel($aIsTrainPgChk1, $bCapturePixel) And _CheckPixel($aIsTrainPgChk2, $bCapturePixel) Then ExitLoop
		If _Sleep($iDelayIsTrainPage1) Then ExitLoop
		$i += 1
	WEnd

	If $i <= 28 Then
		If ($DebugSetlog = 1 Or $DebugClick = 1) And $writelogs = True Then Setlog("**Train Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $writelogs = True Then SetLog("Cannot find train Window.", $COLOR_RED) ; in case of $i = 29 in while loop
		If $debugImageSave = 1 Then DebugImageSave("IsTrainPage_")
		Return False
	EndIf

EndFunc   ;==>IsTrainPage

Func IsAttackPage()
	Local $result
	Local $colorRead = _GetPixelColor($aIsAttackPage[0], $aIsAttackPage[1], True)
	$result = _ColorCheck($colorRead, Hex($aIsAttackPage[2], 6), $aIsAttackPage[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Attack Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 Then
			SetLog("**Attack Window FAIL**", $COLOR_ORANGE)
			SetLog("expected in (" & $aIsAttackPage[0] & "," & $aIsAttackPage[1] & ")  = " & Hex($aIsAttackPage[2], 6) & " - Found " & $colorRead, $COLOR_ORANGE)
		EndIf
		If $debugImageSave = 1 Then DebugImageSave("IsAttackPage_")
		Return False
	EndIf

EndFunc   ;==>IsAttackPage

Func IsAttackWhileShieldPage($makeDebugImageSave = True)
	Local $result

	$result = _CheckPixel($aIsAttackShield, $bCapturePixel)

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Attack Shield Window Open**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Attack Shield Window not open**", $COLOR_ORANGE)
		If $debugImageSave = 1 And $makeDebugImageSave = True Then DebugImageSave("IsAttackWhileShieldPage_")
		Return False
	EndIf

EndFunc   ;==>IsAttackWhileShieldPage

Func IsMainPage()
	Local $result

	$result = _CheckPixel($aIsMain, $bCapturePixel)

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Main Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Main Window FAIL**", $COLOR_ORANGE)
		If $debugImageSave = 1 Then DebugImageSave("IsMainPage_")
		Return False

	EndIf

EndFunc   ;==>IsMainPage

Func IsMainChatOpenPage() ;main page open chat
	Local $result

	$result = _ColorCheck(_GetPixelColor($aChatTab[0], $aChatTab[1], True), Hex($aChatTab[2], 6), $aChatTab[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Chat Open Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Chat Open Window FAIL** " & $aChatTab[0] & "," & $aChatTab[1] & " " & _GetPixelColor($aChatTab[0], $aChatTab[1], True), $COLOR_ORANGE)
		If $debugImageSave = 1 Then DebugImageSave("IsMainChatOpenPage_")
		Return False
	EndIf

EndFunc   ;==>IsMainChatOpenPage


Func IsClanInfoPage()
	Local $result

	$result = _ColorCheck(_GetPixelColor($aPerkBtn[0], $aPerkBtn[1], True), Hex($aPerkBtn[2], 6), $aPerkBtn[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Clan Info Window OK**", $COLOR_ORANGE)
		Return True
	Else
		$result = _ColorCheck(_GetPixelColor(214, 106, True), Hex(0xFFFFFF, 6), 1) And _ColorCheck(_GetPixelColor(815, 58, True), Hex(0xD80402, 6), 5) ; if are not in a clan
		If $result Then
			If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Clan Info Window OK**", $COLOR_ORANGE)
			SetLog("Join a Clan to donate and receive troops!", $COLOR_ORANGE)
			Return True
		Else
			If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Clan Info Window FAIL**", $COLOR_ORANGE)
			If $debugImageSave = 1 Then DebugImageSave("IsClanInfoPage_")
			Return False
		EndIf
	EndIf

EndFunc   ;==>IsClanInfoPage


Func IsLaunchAttackPage()
	Local $result
	Local $colorReadnoshield = _GetPixelColor($aFindMatchButton[0], $aFindMatchButton[1], True)
	Local $colorReadwithshield = _GetPixelColor($aFindMatchButton2[0], $aFindMatchButton2[1], True)
	$resultnoshield = _ColorCheck($colorReadnoshield, Hex($aFindMatchButton[2], 6), $aFindMatchButton[3])
	$resultwithshield = _ColorCheck($colorReadwithshield, Hex($aFindMatchButton2[2], 6), $aFindMatchButton2[3])

	If $resultnoshield Or $resultwithshield Then
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Launch Attack Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 Then
			SetLog("**Launch Attack Window FAIL**", $COLOR_ORANGE)
			SetLog("expected in (" & $aFindMatchButton[0] & "," & $aFindMatchButton[1] & ")  = " & Hex($aFindMatchButton[2], 6) & " or " & Hex($aFindMatchButton2[2], 6) & " - Found " & $colorReadnoshield & " or " & $colorReadwithshield, $COLOR_ORANGE)
		EndIf

		If $debugImageSave = 1 Then DebugImageSave("IsLaunchAttackPage_")
		Return False
	EndIf

EndFunc   ;==>IsLaunchAttackPage

Func IsEndBattlePage($writelog = True)
	Local $result

	$result = _ColorCheck(_GetPixelColor($aConfirmSurrender[0], $aConfirmSurrender[1], True), Hex($aConfirmSurrender[2], 6), $aConfirmSurrender[3])

	If $result Then
		If ($DebugSetlog = 1 Or $DebugClick = 1) And $writelog = True Then SetLog("**End Battle Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If ($DebugSetlog = 1 Or $DebugClick = 1) And $writelog = True Then SetLog("**End Battle Window FAIL**", $COLOR_ORANGE)
		If $debugImageSave = 1 And $writelog = True Then DebugImageSave("IsEndBattlePage_")
		Return False
	EndIf

EndFunc   ;==>IsEndBattlePage

Func IsReturnHomeBattlePage($useReturnValue = False, $makeDebugImageScreenshot = True)
	; $makeDebugImageScreenshot = false
	;    used to check, at end of algorithm_allTroops, if battle already end and then can bypass test
	;    for goldelixirchange and activate heroes

	Local $result

	$result = _ColorCheck(_GetPixelColor($aReturnHomeButton[0], $aReturnHomeButton[1], True), Hex($aReturnHomeButton[2], 6), $aReturnHomeButton[3])

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Return Home Battle Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If ($DebugSetlog = 1 Or $DebugClick = 1) And ($makeDebugImageScreenshot = True) Then SetLog("**Return Home Battle Window FAIL**", $COLOR_ORANGE)
		If $debugImageSave = 1 And $makeDebugImageScreenshot = True Then DebugImageSave("IsReturnHomeBattlePage_")
		If $useReturnValue = True Then
			Return False
		Else
			Return True
		EndIf
	EndIf

EndFunc   ;==>IsReturnHomeBattlePage

Func IsPostDefenseSummaryPage()
	;check for loot lost summary screen after base defense when log on and base is being attacked.
	Local $result
	Local $GoldSpot = _GetPixelColor(330, 201 + $midOffsetY, $bCapturePixel) ; Gold Emblem
	Local $ElixirSpot = _GetPixelColor(334, 233 + $midOffsetY, $bCapturePixel) ; Elixir Emblem
	; If $DebugSetlog = 1 then SetLog("$GoldSpot= " & $GoldSpot & "|0xF6E851=Y, $ElixirSpot= " & $ElixirSpot & "|0xE835E8=Y", $COLOR_PURPLE)

	$result = _ColorCheck($GoldSpot, Hex(0xF6E851, 6), 20) And _ColorCheck($ElixirSpot, Hex(0xE835E8, 6), 20)

	If $result Then
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Post Defense Page visible**", $COLOR_ORANGE)
		Return True
	Else
		If $DebugSetlog = 1 Or $DebugClick = 1 Then SetLog("**Post Defense Page not visible**", $COLOR_ORANGE)
		If $debugImageSave = 1 Then
			DebugImageSave("IsPostDefenseSummaryPage_")
		EndIf
		Return False
	EndIf

EndFunc   ;==>IsPostDefenseSummaryPage
