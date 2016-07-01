; #FUNCTION# ====================================================================================================================
; Name ..........: BotDetectFirstTime
; Description ...: This script detects your builings on the first run
; Author ........: HungLe (april-2015)
; Modified ......: Hervidero (april-2015),(may-2015), HungLe (may-2015), KnowJack(July 2015), Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BotDetectFirstTime()

	Local $collx, $colly, $Result, $i = 0 , $t =0

	If $Is_ClientSyncError = True Then Return ; if restart after OOS, and User stop/start bot, skip this.

	ClickP($aAway, 1, 0, "#0166") ; Click away
	If _Sleep($iDelayBotDetectFirstTime1) Then Return

	SetLog("Detecting your Buildings..", $COLOR_BLUE)

	If (isInsideDiamond($TownHallPos) = False) Then
		If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) And _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
			Zoomout()
			Collect()
		EndIf
		_CaptureRegion2()
		Local $PixelTHHere = GetLocationItem("getLocationTownHall")
		If UBound($PixelTHHere) > 0 Then
			$pixel = $PixelTHHere[0]
			$TownHallPos[0] = $pixel[0]
			$TownHallPos[1] = $pixel[1]
			If $debugSetlog = 1 Then SetLog("DLLc# Townhall: (" & $TownHallPos[0] & "," & $TownHallPos[1] & ")", $COLOR_RED)
		EndIf
		If $TownHallPos[1] = "" Or $TownHallPos[1] = -1 Then
			checkTownhallADV2()
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

	;If _Sleep($iDelayBotDetectFirstTime1) Then Return
	;ClanLevel()
	If _Sleep($iDelayBotDetectFirstTime1) Then Return
	CheckImageType()
	If _Sleep($iDelayBotDetectFirstTime1) Then Return

	If $icmbQuantBoostBarracks > 0 Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		For $i = 0 To $icmbQuantBoostBarracks - 1 ; verify if all barracks haves a valid position
			If $barrackPos[$i][0] = "" Or $barrackPos[$i][0] = -1 Then ;  Boost individual barracks with "button Boost 10 gems"
				; Setlog("loop: "& $i+1 )
				For $x = 0 To 3
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

	If GUICtrlRead($chkScreenshotHideName) = $GUI_CHECKED Or $ichkScreenshotHideName = 1 Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $aCCPos[0] = -1 Then
			LocateClanCastle()
			SaveConfig()
		EndIf
	EndIf

	If $ichkLab = 1 Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $aLabPos[0] = "" Or $aLabPos[0] = -1 Then
			LocateLab()
			SaveConfig()
		EndIf
	EndIf

	If (GUICtrlRead($cmbBoostBarbarianKing) > 0) Or $ichkUpgradeKing = 1 Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $KingAltarPos[0] = -1 Then
			LocateKingAltar()
			SaveConfig()
		EndIf
	EndIf

	If (GUICtrlRead($cmbBoostArcherQueen) > 0) Or $ichkUpgradeQueen = 1 Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $QueenAltarPos[0] = -1 Then
			LocateQueenAltar()
			SaveConfig()
		EndIf
	EndIf

	If Number($iTownHallLevel) > 10 And ((GUICtrlRead($cmbBoostWarden) > 0) Or $ichkUpgradeWarden = 1) Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $WardenAltarPos[0] = -1 Then
			LocateWardenAltar()
			SaveConfig()
		EndIf
	EndIf

	;Boju Display TH Level in Stats

	_GUI_Value_STATE("HIDE",$groupListTHLevels)
		If $debugsetlog = 1 Then Setlog("Select TH Level:" & Number($iTownHallLevel), $COLOR_PURPLE)
		Switch Number($iTownHallLevel)
			Case 4
				GUICtrlSetState($THLevels04,$GUI_SHOW)
			Case 5
				GUICtrlSetState($THLevels05,$GUI_SHOW)
			Case 6
				GUICtrlSetState($THLevels06,$GUI_SHOW)
			Case 7
				GUICtrlSetState($THLevels07,$GUI_SHOW)
			Case 8
				GUICtrlSetState($THLevels08,$GUI_SHOW)
			Case 9
				GUICtrlSetState($THLevels09,$GUI_SHOW)
			Case 10
				GUICtrlSetState($THLevels10,$GUI_SHOW)
			Case 11
				GUICtrlSetState($THLevels11,$GUI_SHOW)
		EndSwitch
	GUICtrlSetState(Eval("$THLevels" + Number($iTownHallLevel)),$GUI_SHOW)
	;-->Display TH Level in Stats

#comments-start  removed due replacement by imgloc collect
	If $iChkCollect = 1 And $listResourceLocation = "" Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		While 1 ; Clear the collectors using old image find to reduce collector image finding errors
			If _Sleep($iDelayBotDetectFirstTime3) Or $RunState = False Then ExitLoop
			_CaptureRegion()
			If _ImageSearch(@ScriptDir & "\images\collect.png", 1, $collx, $colly, 20) Then
				If isInsideDiamondXY($collx, $colly) Then
					If IsMainPage() Then Click($collx, $colly, 1, 0, "#0330") ;Click collector
					If _Sleep($iDelayBotDetectFirstTime3) Then Return
				EndIf
				ClickP($aAway, 1, 0, "#0329") ;Click Away
			Else
				ExitLoop
			EndIf
			If $i >= 20 Then ExitLoop
			$i += 1
		WEnd
		SetLog("Verifying your Mines/Collectors/Drills ...wait ...")


		_CaptureRegion2()
		$t =0
		$PixelMineHere = GetLocationMine()
		For $i = 0 To UBound($PixelMineHere) - 1
			If isInsideDiamond($PixelMineHere[$i]) Then
				$pixel = $PixelMineHere[$i]
				$listResourceLocation = $listResourceLocation & $pixel[0] & ";" & $pixel[1] & "|"
				If $debugSetlog = 1 Then SetLog("- Gold Mine " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
				$t +=1
			EndIf
		Next
		If $t > 0 Then
			SetLog("Total No. of Gold Mines: " & $t)
		EndIf

		$t =0
		If _Sleep($iDelayBotDetectFirstTime1) Then Return
		$PixelElixirHere = GetLocationElixir()
		For $i = 0 To UBound($PixelElixirHere) - 1
			If isInsideDiamond($PixelElixirHere[$i]) Then
				$pixel = $PixelElixirHere[$i]
				$listResourceLocation = $listResourceLocation & $pixel[0] & ";" & $pixel[1] & "|"
				If $debugSetlog = 1 Then SetLog("- Elixir Collector " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
				$t +=1
			EndIf
		Next
		If $t > 0 Then
			SetLog("Total No. of Elixir Collectors: " & $t)
		EndIf

		$t =0
		If _Sleep($iDelayBotDetectFirstTime1) Then Return
		$PixelDarkElixirHere = GetLocationDarkElixir()
		For $i = 0 To UBound($PixelDarkElixirHere) - 1
			If isInsideDiamond($PixelDarkElixirHere[$i]) Then
				$pixel = $PixelDarkElixirHere[$i]
				$listResourceLocation = $listResourceLocation & $pixel[0] & ";" & $pixel[1] & "|"
				If $debugSetlog = 1 Then SetLog("- Dark Ellxir Drill " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
				$t +=1
			EndIf
		Next
		If $t > 0 Then
			SetLog("Total No. of Dark Elixir Drills: " & $t)
		EndIf
		$t =0
	EndIf
#comments-end

EndFunc   ;==>BotDetectFirstTime
