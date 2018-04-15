
; #FUNCTION# ====================================================================================================================
; Name ..........: IsTrainPage & IsAttackPage & IsMainPage & IsMainChatOpenPage & IsClanInfoPage & IsLaunchAttackPage &
;                  IsEndBattlePage & IsReturnHomeBattlePage
; Description ...: Verify if you are in the correct window...
; Author ........: Sardo (2015)
; Modified ......: ProMac (2015), MonkeyHunter (12-2015)
; Remarks .......: This file is part of MyBot Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func IsPageLoop($aCheckPixel, $iLoop = 30, $bCapturePixel = $g_bCapturePixel)
	$bCapturePixel = $bCapturePixel Or $iLoop > 1
	Local $IsPage = False
	Local $i = 0

	While $i < $iLoop
		ForceCaptureRegion()
		If _CheckPixel($aCheckPixel, $bCapturePixel) Then
			$IsPage = True
			ExitLoop
		EndIf
		If _Sleep($DELAYISTRAINPAGE2) Then ExitLoop ; 1s Delay
		$i += 1
	WEnd

	Return $IsPage
EndFunc   ;==>IsPageLoop

Func IsTrainPage($bSetLog = True, $iLoop = 30)

	If IsPageLoop($aIsTrainPgChk1, $iLoop) Then
		If ($g_bDebugSetlog Or $g_bDebugClick) And $bSetLog Then SetLog("**Army Window OK**", $COLOR_ACTION)
		Return True
	EndIf

	If $bSetLog Then SetLog("Cannot find Army Window...", $COLOR_ERROR) ; in case of $i = 29 in while loop
	If $g_bDebugImageSave Then DebugImageSave("IsTrainPage")
	If $iLoop > 1 Then AndroidPageError("IsTrainPage")
	Return False
EndFunc   ;==>IsTrainPage

Func IsAttackPage($bCapturePixel = $g_bCapturePixel)

	If IsPageLoop($aIsAttackPage, 1, $bCapturePixel) Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Attack Window OK**", $COLOR_ACTION)
		Return True
	EndIf

	If $g_bDebugSetlog Or $g_bDebugClick Then
		Local $colorRead = _GetPixelColor($aIsAttackPage[0], $aIsAttackPage[1], $bCapturePixel)
		SetLog("**Attack Window FAIL**", $COLOR_ACTION)
		SetLog("expected in (" & $aIsAttackPage[0] & "," & $aIsAttackPage[1] & ")  = " & Hex($aIsAttackPage[2], 6) & " - Found " & $colorRead, $COLOR_ACTION)
	EndIf
	If $g_bDebugImageSave Then DebugImageSave("IsAttackPage")
	Return False

EndFunc   ;==>IsAttackPage

Func IsAttackWhileShieldPage($bSaveDebugImage = True)

	If IsPageLoop($aIsAttackShield, 1) Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Attack Shield Window Open**", $COLOR_ACTION)
		Return True
	EndIf

	If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Attack Shield Window not open**", $COLOR_ACTION)
	If $g_bDebugImageSave And $bSaveDebugImage Then DebugImageSave("IsAttackWhileShieldPage_")
	Return False

EndFunc   ;==>IsAttackWhileShieldPage

Func IsMainPage($iLoop = 30)

	If IsPageLoop($aIsMain, $iLoop) Then
		$g_bMainWindowOk = True
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Main Window OK**", $COLOR_ACTION)
		Return True
	EndIf

	$g_bMainWindowOk = False
	If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Main Window FAIL**", $COLOR_ACTION)
	If $g_bDebugImageSave Then DebugImageSave("IsMainPage")
	If $iLoop > 1 Then AndroidPageError("IsMainPage")
	Return False

EndFunc   ;==>IsMainPage

Func IsMainPageBuilderBase($iLoop = 30)

	If IsPageLoop($aIsOnBuilderBase, $iLoop) Then
		$g_bMainWindowOk = True
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Main Window Builder Base OK**", $COLOR_ACTION)
		Return True
	EndIf

	$g_bMainWindowOk = False
	If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Main Window Builder Base FAIL**", $COLOR_ACTION)
	If $g_bDebugImageSave Then DebugImageSave("IsMainPageBuilderBase")
	If $iLoop > 1 Then AndroidPageError("IsMainPageBase")
	Return False

EndFunc   ;==>IsMainPage

Func IsMainChatOpenPage() ;main page open chat

	If IsPageLoop($aChatTab, 1) Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Chat Open Window OK**", $COLOR_ACTION)
		Return True
	EndIf

	If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Chat Open Window FAIL** " & $aChatTab[0] & "," & $aChatTab[1] & " " & _GetPixelColor($aChatTab[0], $aChatTab[1], True), $COLOR_ACTION)
	If $g_bDebugImageSave Then DebugImageSave("IsMainChatOpenPage")
	Return False

EndFunc   ;==>IsMainChatOpenPage

Func IsClanInfoPage()

	If IsPageLoop($aPerkBtn, 1) Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Clan Info Window OK**", $COLOR_ACTION)
		Return True
	EndIf

	Local $result = _ColorCheck(_GetPixelColor(214, 106, True), Hex(0xFFFFFF, 6), 1) And _ColorCheck(_GetPixelColor(815, 58, True), Hex(0xD80402, 6), 5) ; if are not in a clan
	If $result Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Clan Info Window OK**", $COLOR_ACTION)
		SetLog("Join a Clan to donate and receive troops!", $COLOR_ACTION)
		Return True
	Else
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Clan Info Window FAIL**", $COLOR_ACTION)
		If $g_bDebugImageSave Then DebugImageSave("IsClanInfoPage")
		Return False
	EndIf

EndFunc   ;==>IsClanInfoPage

Func IsLaunchAttackPage()

	Local $resultnoshield = IsPageLoop($aFindMatchButton, 1)
	Local $resultwithshield = IsPageLoop($aFindMatchButton2, 1)

	If $resultnoshield Or $resultwithshield Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Launch Attack Window OK**", $COLOR_ACTION)
		Return True
	EndIf

	If $g_bDebugSetlog Or $g_bDebugClick Then
		Local $colorReadnoshield = _GetPixelColor($aFindMatchButton[0], $aFindMatchButton[1], True)
		Local $colorReadwithshield = _GetPixelColor($aFindMatchButton2[0], $aFindMatchButton2[1], True)
		SetLog("**Launch Attack Window FAIL**", $COLOR_ACTION)
		SetLog("expected in (" & $aFindMatchButton[0] & "," & $aFindMatchButton[1] & ")  = " & Hex($aFindMatchButton[2], 6) & " or " & Hex($aFindMatchButton2[2], 6) & " - Found " & $colorReadnoshield & " or " & $colorReadwithshield, $COLOR_ACTION)
	EndIf

	If $g_bDebugImageSave Then DebugImageSave("IsLaunchAttackPage")
	Return False

EndFunc   ;==>IsLaunchAttackPage

Func IsEndBattlePage($bWriteLog = True)

	If IsPageLoop($aConfirmSurrender, 1) Then
		If ($g_bDebugSetlog Or $g_bDebugClick) And $bWriteLog Then SetLog("**End Battle Window OK**", $COLOR_ACTION)
		Return True
	Else
		If ($g_bDebugSetlog Or $g_bDebugClick) And $bWriteLog Then
			Local $colorRead = _GetPixelColor($aConfirmSurrender[0], $aConfirmSurrender[1], True)
			SetLog("**End Battle Window FAIL**", $COLOR_ACTION)
			SetLog("expected in (" & $aConfirmSurrender[0] & "," & $aConfirmSurrender[1] & ")  = " & Hex($aConfirmSurrender[2], 6) & " - Found " & $colorRead, $COLOR_ACTION)
		EndIf
		If $g_bDebugImageSave And $bWriteLog Then DebugImageSave("IsEndBattlePage")
		Return False
	EndIf

EndFunc   ;==>IsEndBattlePage

Func IsReturnHomeBattlePage($useReturnValue = False, $makeDebugImageScreenshot = True)
	; $makeDebugImageScreenshot = false
	;    used to check, at end of algorithm_allTroops, if battle already end and then can bypass test
	;    for goldelixirchange and activate heroes

	If IsPageLoop($aReturnHomeButton, 1) Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Return Home Battle Window OK**", $COLOR_ACTION)
		Return True
	EndIf

	If ($g_bDebugSetlog Or $g_bDebugClick) And ($makeDebugImageScreenshot = True) Then SetLog("**Return Home Battle Window FAIL**", $COLOR_ACTION)
	If $g_bDebugImageSave And $makeDebugImageScreenshot Then DebugImageSave("IsReturnHomeBattlePage")
	If $useReturnValue Then
		Return False
	Else
		Return True
	EndIf

EndFunc   ;==>IsReturnHomeBattlePage

Func IsPostDefenseSummaryPage($bCapture = True)
	;check for loot lost summary screen after base defense when log on and base is being attacked.
	Local $result
	Local $GoldSpot = _GetPixelColor(330, 201 + $g_iMidOffsetY, $bCapture) ; Gold Emblem
	Local $ElixirSpot = _GetPixelColor(334, 233 + $g_iMidOffsetY, $bCapture) ; Elixir Emblem

	$result = _ColorCheck($GoldSpot, Hex(0xF6E851, 6), 20) And _ColorCheck($ElixirSpot, Hex(0xE835E8, 6), 20)

	If $result Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Post Defense Page visible**", $COLOR_ACTION)
		Return True
	Else
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("**Post Defense Page not visible**", $COLOR_ACTION)
		If $g_bDebugImageSave Then DebugImageSave("IsPostDefenseSummaryPage")
		Return False
	EndIf

EndFunc   ;==>IsPostDefenseSummaryPage
