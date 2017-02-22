; #FUNCTION# ====================================================================================================================
; Name ..........: BotDetectFirstTime
; Description ...: This script detects your builings on the first run
; Author ........: HungLe (april-2015)
; Modified ......: Hervidero (april-2015),(may-2015), HungLe (may-2015), KnowJack(July 2015), Sardo 2015-08, CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func BotDetectFirstTime()

	Local $collx, $colly, $Result, $i = 0 , $t =0

	If $Is_ClientSyncError = True Then Return ; if restart after OOS, and User stop/start bot, skip this.

	ClickP($aAway, 1, 0, "#0166") ; Click away
	If _Sleep($iDelayBotDetectFirstTime1) Then Return

	SetLog("Detecting your Buildings..", $COLOR_INFO)

	If (isInsideDiamond($TownHallPos) = False) Then
		If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) And _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
			Zoomout()
			Collect()
		EndIf
		_CaptureRegion2()
		Local $PixelTHHere = GetLocationItem("getLocationTownHall")
		If UBound($PixelTHHere) > 0 Then
			Local $pixel = $PixelTHHere[0]
			$TownHallPos[0] = $pixel[0]
			$TownHallPos[1] = $pixel[1]
			If $g_iDebugSetlog = 1 Then SetLog("DLLc# Townhall: (" & $TownHallPos[0] & "," & $TownHallPos[1] & ")", $COLOR_ERROR)
		EndIf
		If $TownHallPos[1] = "" Or $TownHallPos[1] = -1 Then
			imglocTHSearch(true,true); search th on myvillage
			$TownHallPos[0] = $THx
			$TownHallPos[1] = $THy
			If $g_iDebugSetlog = 1 Then SetLog("OldDDL Townhall: (" & $TownHallPos[0] & "," & $TownHallPos[1] & ")", $COLOR_ERROR)
		EndIf
		SetLog("Townhall: (" & $TownHallPos[0] & "," & $TownHallPos[1] & ")", $COLOR_DEBUG)
	EndIf

	If Number($iTownHallLevel) < 2 Then
		$Result = GetTownHallLevel(True) ; Get the Users TH level
		If IsArray($Result) Then $iTownHallLevel = 0 ; Check for error finding TH level, and reset to zero if yes
	EndIf
	If Number($iTownHallLevel) > 1 And Number($iTownHallLevel) < 6 Then
		Setlog("Warning: TownHall level below 6 NOT RECOMMENDED!", $COLOR_ERROR)
		Setlog("Proceed with caution as errors may occur.", $COLOR_ERROR)
	EndIf

	;If _Sleep($iDelayBotDetectFirstTime1) Then Return
	;ClanLevel()
	If _Sleep($iDelayBotDetectFirstTime1) Then Return
	CheckImageType()
	If _Sleep($iDelayBotDetectFirstTime1) Then Return

	If GUICtrlRead($g_hChkScreenshotHideName) = $GUI_CHECKED Or $ichkScreenshotHideName = 1 Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $aCCPos[0] = -1 Then
			LocateClanCastle()
			SaveConfig()
		EndIf
	EndIf

	If $g_bAutoLabUpgradeEnable = True Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $aLabPos[0] = "" Or $aLabPos[0] = -1 Then
			LocateLab()
			SaveConfig()
		EndIf
	EndIf

	If (GUICtrlRead($g_hCmbBoostBarbarianKing) > 0) Or $g_bUpgradeKingEnable = True Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $KingAltarPos[0] = -1 Then
			LocateKingAltar()
			SaveConfig()
		EndIf
	EndIf

	If (GUICtrlRead($g_hCmbBoostArcherQueen) > 0) Or $g_bUpgradeQueenEnable = True Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $QueenAltarPos[0] = -1 Then
			LocateQueenAltar()
			SaveConfig()
		EndIf
	EndIf

	If Number($iTownHallLevel) > 10 And ((GUICtrlRead($g_hCmbBoostWarden) > 0) Or $g_bUpgradeWardenEnable = True) Then
		If _Sleep($iDelayBotDetectFirstTime3) Then Return
		If $WardenAltarPos[0] = -1 Then
			LocateWardenAltar()
			SaveConfig()
		EndIf
	EndIf

	;Display Level TH in Stats
	GUICtrlSetData($g_hLblTHLevels, "")

	;Boju Display TH Level in Stats
	_GUI_Value_STATE("HIDE", $groupListTHLevels)
	If $g_iDebugSetlog = 1 Then Setlog("Select TH Level:" & Number($iTownHallLevel), $COLOR_DEBUG)
	GUICtrlSetState($g_ahPicTHLevels[$iTownHallLevel], $GUI_SHOW)
	GUICtrlSetData($g_hLblTHLevels, $iTownHallLevel)

EndFunc   ;==>BotDetectFirstTime
