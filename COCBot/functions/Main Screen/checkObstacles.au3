
; #FUNCTION# ====================================================================================================================
; Name ..........: checkObstacles
; Description ...: Checks whether something is blocking the pixel for mainscreen and tries to unblock
; Syntax ........: checkObstacles()
; Parameters ....:
; Return values .: Returns True when there is something blocking
; Author ........: Hungle (2014)
; Modified ......: KnowJack (2015) Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func checkObstacles() ;Checks if something is in the way for mainscreen
	Local $x, $y
	_CaptureRegion()
	;FIXME don't hard code coordinates
	If _ImageSearchArea($device, 0, 237, 321+30, 293, 346+30, $x, $y, 80) Then ;jp
		If $sTimeWakeUp > 3600 Then
			SetLog("Another Device has connected, waiting " & Floor(Floor($sTimeWakeUp / 60) / 60) & " hours " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " minutes " & Floor(Mod($sTimeWakeUp, 60)) & " seconds", $COLOR_RED)
			PushMsg("AnotherDevice3600")
		ElseIf $sTimeWakeUp > 60 Then
			SetLog("Another Device has connected, waiting " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " minutes " & Floor(Mod($sTimeWakeUp, 60)) & " seconds", $COLOR_RED)
			PushMsg("AnotherDevice60")
		Else
			SetLog("Another Device has connected, waiting " & Floor(Mod($sTimeWakeUp, 60)) & " seconds", $COLOR_RED)
			PushMsg("AnotherDevice")
		EndIf
		If _SleepStatus($sTimeWakeUp * 1000) Then Return ; 2 Minutes
		PureClickP($aReloadButton, 1, 0, "#0127");Check for "Another device" message
		If _Sleep(2000) Then Return
		Return True
	EndIf
	;TODO add other breaks (personal break, etc.
	If _ImageSearch($fnBreak, 0, $x, $y, 80) Then
		SetLog("Village must take a break, wait ...", $COLOR_RED)
		PushMsg("TakeBreak")
		If _SleepStatus($iDelaycheckObstacles4) Then Return ; 2 Minutes
		If _ImageSearch($fnReload, 0, $x, $y, 80) Then
			if $debugSetlog = 1 Then SetLog("Found reload at "&$x&"x"&$y, $COLOR_PURPLE);
			PureClick($x, $y, 1, 0, "#0128")
		Else
			PureClickP($aReloadButton, 1, 0, "#0128")
		EndIf
		Return True
	EndIf
	If _ImageSearch($fnBreakEnding, 0, $x, $y, 80) Then
		SetLog("Personal break ending, wait ...", $COLOR_RED)
		;PushMsg("BreakEnding")
		If _SleepStatus($iDelaycheckObstacles4) Then Return ; 2 Minutes
		If _ImageSearch($fnReload, 0, $x, $y, 80) Then
			PureClick($x, $y, 1, 0, "#0128")
		Else
			if $debugSetlog = 1 Then SetLog("Found reload at "&$x&"x"&$y, $COLOR_PURPLE);
			PureClickP($aReloadButton, 1, 0, "#0128")
		EndIf
		Return True
	EndIf
	;FIXME don't hard code coordinates
	If _ImageSearchArea($CocStopped, 0, 250, 328+30, 618, 402+30, $x, $y, 70) Then ;jp
		SetLog("CoC Has Stopped Error .....", $COLOR_RED)
		$iNbrOfOoS += 1
		UpdateStats()
		PushMsg("CoCError")
		If _Sleep($iDelaycheckObstacles1) Then Return
		PureClick(250 + $x, 328 + $y, 1, 0, "#0129");Check for "CoC has stopped error, looking for OK message" on screen
		If _Sleep($iDelaycheckObstacles2) Then Return
		PureClick(126, 700, 1, $iDelaycheckObstacles5, "#0130")
		Local $RunApp = StringReplace(_WinAPI_GetProcessFileName(WinGetProcess($Title)), "Frontend", "RunApp")
		Run($RunApp & " Android com.supercell.clashofclans com.supercell.clashofclans.GameApp")
		If _Sleep(10000) Then Return ; Give it some time to restart
		Return True
	EndIf
	$Message = _PixelSearch($aIsInactive[0], $aIsInactive[1], $aIsInactive[0] + 1, $aIsInactive[1] + 30, Hex($aIsInactive[2], 6), $aIsInactive[3])
	If IsArray($Message) Then
		PureClickP($aReloadButton, 1, 0, "#0131");Check for out of sync or inactivity
		If _Sleep($iDelaycheckObstacles3) Then Return
		Return True
	EndIf
	_CaptureRegion()
	;FIXME don't hard code coordinates
	If _ColorCheck(_GetPixelColor(235, 209+30), Hex(0x9E3826, 6), 20) Then ;jp
		PureClick(429, 493, 1, 0, "#0132");See if village was attacked, clicks Okay
		Return True
	EndIf
	If _CheckPixel($aIsMainGrayed, $bNoCapturePixel) Then
		PureClickP($aAway, 1, 0, "#0133") ;Click away If things are open
		Return True
	EndIf
	;FIXME don't hard code coordinates
	If _ColorCheck(_GetPixelColor(819, 55), Hex(0xD80400, 6), 20) Then
		PureClick(819, 55, 1, 0, "#0134") ;Clicks X
		Return True
	EndIf
	If _CheckPixel($aCancelFight, $bNoCapturePixel) Or _CheckPixel($aCancelFight2, $bNoCapturePixel) Then
		PureClickP($aCancelFight, 1, 0, "#0135") ;Clicks X
		Return True
	EndIf
	If _CheckPixel($aChatTab, $bNoCapturePixel) Then
		PureClickP($aChatTab, 1, 0, "#0136") ;Clicks chat tab
		If _Sleep($iDelaycheckObstacles1) Then Return
		Return True
	EndIf
	If _CheckPixel($aEndFightSceneBtn, $bNoCapturePixel) Then
		PureClickP($aEndFightSceneBtn, 1, 0, "#0137") ;If in that victory or defeat scene
		Return True
	EndIf
	If _CheckPixel($aSurrenderButton, $bNoCapturePixel) Then
		ReturnHome(False, False) ;If End battle is available
		Return True
	EndIf
	;FIXME don't hard code coordinates
	$Message = _PixelSearch(19, 565+60, 104, 580+60, Hex(0xD9DDCF, 6), 10) ;jp
	If IsArray($Message) Then
		PureClick(67, 602, 1, 0, "#0138");Check if Return Home button available
		If _Sleep($iDelaycheckObstacles2) Then Return
		Return True
	EndIf

	Return False
EndFunc   ;==>checkObstacles
