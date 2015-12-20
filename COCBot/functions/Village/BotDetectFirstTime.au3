; #FUNCTION# ====================================================================================================================
; Name ..........: BotDetectFirstTime
; Description ...: This script detects your builings on the first run
; Author ........: HungLe (april-2015)
; Modified ......: Hervidero (april-2015),(may-2015), HungLe (may-2015), KnowJack(July 2015), Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BotDetectFirstTime()

	Local $collx, $colly, $Result, $i = 0

	If $Is_ClientSyncError = True Then Return ; if restart after OOS, and User stop/start bot, skip this.

	ClickP($aAway, 1, 0, "#0166") ; Click away
	If _Sleep($iDelayBotDetectFirstTime1) Then Return

	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2()

	SetLog("Detecting your Buildings..", $COLOR_BLUE)

	If (isInsideDiamond($TownHallPos) = False) Then
		If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) And _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
			Zoomout()
			Collect()
		EndIf
		Local $PixelTHHere = GetLocationItem("getLocationTownHall")
		If UBound($PixelTHHere) > 0 Then
			$pixel = $PixelTHHere[0]
			$TownHallPos[0] = $pixel[0]
			$TownHallPos[1] = $pixel[1]
			If $debugSetlog = 1 Then SetLog("DLLc# Townhall: (" & $TownHallPos[0] & "," & $TownHallPos[1] & ")", $COLOR_RED)
		EndIf
		If $TownHallPos[1] = "" Then
			checkTownhallADV()
			$TownHallPos[0] = $THx
			$TownHallPos[1] = $THy
			If $debugSetlog = 1 Then SetLog("OldDDL Townhall: (" & $TownHallPos[0] & "," & $TownHallPos[1] & ")", $COLOR_RED)
		EndIf
		SetLog("Townhall: (" & $TownHallPos[0] & "," & $TownHallPos[1] & ")", $COLOR_PURPLE)
	EndIf

	If Number($iTownHallLevel) < 2 Then
		$Result = GetTownHallLevel(True) ; Get the Users TH level
		If IsArray($Result) Then $iTownHallLevel = 0 ; Check for error finding TH level, and reset to zero if yes
	EndIf
	If Number($iTownHallLevel) > 1 And Number($iTownHallLevel) < 6 Then
		Setlog("Warning: TownHall level below 6 NOT RECOMMENDED!", $COLOR_RED)
		Setlog("Proceed with caution as errors may occur.", $COLOR_RED)
	EndIf

	If _Sleep($iDelayBotDetectFirstTime1) Then Return

	Setlog("Finding your Clan Level, wait..")
	ClanLevel()
	If _Sleep($iDelayBotDetectFirstTime1) Then Return

	If GUICtrlRead($cmbQuantBoostBarracks) > 0 Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		For $i = 0 To GUICtrlRead($cmbQuantBoostBarracks) - 1 ; verify if all barracks haves a valid position
			If $barrackPos[$i][0] = "" or $barrackPos[$i][0] = -1 Then ;  Boost individual barracks with "button Boost 10 gems"
				; Setlog("loop: "& $i+1 )
				For $x = 0 to 3
					$barrackPos[$x][0] = -1
					$barrackPos[$x][1] = -1
				Next
				LocateBarrack2()
				SaveConfig()
				ExitLoop
			EndIf
		Next
	EndIf

	If (GUICtrlRead($cmbBoostDarkSpellFactory) > 0) Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $DSFPos[0] = -1 Then
			LocateDarkSpellFactory()
			SaveConfig()
		EndIf
	EndIf

	If (GUICtrlRead($cmbBoostSpellFactory) > 0) Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $SFPos[0] = -1 Then
			LocateSpellFactory()
			SaveConfig()
		EndIf
	EndIf

	If (GUICtrlRead($cmbBoostBarbarianKing) > 0) Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $KingAltarPos[0] = -1 Then
			LocateKingAltar()
			SaveConfig()
		EndIf
	EndIf

	If (GUICtrlRead($cmbBoostArcherQueen) > 0) Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $QueenAltarPos[0] = -1 Then
			LocateQueenAltar()
			SaveConfig()
		EndIf
	EndIf

	If $iChkCollect = 1 And $listResourceLocation = "" Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		While 1 ; Clear the collectors using old image find to reduce collector image finding errors
			If _Sleep($iDelayBotDetectFirstTime3) Or $RunState = False Then ExitLoop
			_CaptureRegion(0, 0, 780)
			If _ImageSearch(@ScriptDir & "\images\collect.png", 1, $collx, $colly, 20) Then
				Click($collx, $colly, 1, 0, "#0330") ;Click collector
				If _Sleep($iDelayBotDetectFirstTime3) Then Return
				ClickP($aAway, 1, 0, "#0329") ;Click Away
			ElseIf $i >= 20 Then
				ExitLoop
			EndIf
			$i += 1
		WEnd
		SetLog("Verifying your Mines/Extractors/Drills ...wait ...")
		$PixelMineHere = GetLocationItem("getLocationMineExtractor")
		If UBound($PixelMineHere) > 0 Then
			SetLog("Total No. of Gold Mines: " & UBound($PixelMineHere))
		EndIf
		For $i = 0 To UBound($PixelMineHere) - 1
			$pixel = $PixelMineHere[$i]
			$listResourceLocation = $listResourceLocation & $pixel[0] & ";" & $pixel[1] & "|"
			If $debugSetlog = 1 Then SetLog("- Gold Mine " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
		Next
		If _Sleep($iDelayBotDetectFirstTime1) Then Return
		$PixelElixirHere = GetLocationItem("getLocationElixirExtractor")
		If UBound($PixelElixirHere) > 0 Then
			SetLog("Total No. of Elixir Collectors: " & UBound($PixelElixirHere))
		EndIf
		For $i = 0 To UBound($PixelElixirHere) - 1
			$pixel = $PixelElixirHere[$i]
			$listResourceLocation = $listResourceLocation & $pixel[0] & ";" & $pixel[1] & "|"
			If $debugSetlog = 1 Then SetLog("- Elixir Collector " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
		Next
		If _Sleep($iDelayBotDetectFirstTime1) Then Return
		$PixelDarkElixirHere = GetLocationItem("getLocationDarkElixirExtractor")
		If UBound($PixelDarkElixirHere) > 0 Then
			SetLog("Total No. of Dark Elixir Drills: " & UBound($PixelDarkElixirHere))
		EndIf
		For $i = 0 To UBound($PixelDarkElixirHere) - 1
			$pixel = $PixelDarkElixirHere[$i]
			$listResourceLocation = $listResourceLocation & $pixel[0] & ";" & $pixel[1] & "|"
			If $debugSetlog = 1 Then SetLog("- Dark Ellxir Drill " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
		Next
	EndIf

EndFunc   ;==>BotDetectFirstTime
