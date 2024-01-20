; #FUNCTION# ====================================================================================================================
; Name ..........: BotDetectFirstTime
; Description ...: This script detects your builings on the first run
; Author ........: HungLe (04/2015)
; Modified ......: Hervidero (05/2015), HungLe (05/2015), KnowJack(07/2015), Sardo (08/2015), CodeSlinger69 (01/2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func BotDetectFirstTime()
	If $g_bIsClientSyncError Then Return ; if restart after OOS, and User stop/start bot, skip this.

	ClickAway()
	If _Sleep($DELAYBOTDETECT1) Then Return

	SetLog("Detecting your Buildings", $COLOR_INFO)

   #cs
	If Not isInsideDiamond($g_aiTownHallPos) Then
		checkMainScreen()
		Collect(False)
		_CaptureRegion2()
		; USES OLD OPENCV DETECTION
		Local $PixelTHHere = GetLocationItem("getLocationTownHall")
		If UBound($PixelTHHere) > 0 Then
			Local $pixel = $PixelTHHere[0]
			$g_aiTownHallPos[0] = $pixel[0]
			$g_aiTownHallPos[1] = $pixel[1]
			SetDebugLog("DLLc# Townhall: (" & $g_aiTownHallPos[0] & "," & $g_aiTownHallPos[1] & ")", $COLOR_ERROR)
		EndIf
		If $g_aiTownHallPos[1] = "" Or $g_aiTownHallPos[1] = -1 Then
			imglocTHSearch(True, True) ; search th on myvillage
			$g_aiTownHallPos[0] = $g_iTHx
			$g_aiTownHallPos[1] = $g_iTHy
			SetDebugLog("OldDDL Townhall: (" & $g_aiTownHallPos[0] & "," & $g_aiTownHallPos[1] & ")", $COLOR_ERROR)
		EndIf
		SetLog("Townhall: (" & $g_aiTownHallPos[0] & "," & $g_aiTownHallPos[1] & ")", $COLOR_DEBUG)
	EndIf
   #ce

   If Not isInsideDiamond($g_aiTownHallPos) Then
	  checkMainScreen()
	  Collect(False)
	  imglocTHSearch(True, True, True) ; search th on myvillage
	  SetLog("Townhall: (" & $g_aiTownHallPos[0] & "," & $g_aiTownHallPos[1] & ")", $COLOR_DEBUG)
   EndIf

	If Number($g_iTownHallLevel) < 2 Then
		Local $aTownHallLevel = GetTownHallLevel(True) ; Get the Users TH level
		If IsArray($aTownHallLevel) Then $g_iTownHallLevel = 0 ; Check for error finding TH level, and reset to zero if yes
	EndIf

	If Number($g_iTownHallLevel) > 1 And Number($g_iTownHallLevel) < 6 Then
		SetLog("Warning: TownHall level below 6 NOT RECOMMENDED!", $COLOR_ERROR)
		SetLog("Proceed with caution as errors may occur.", $COLOR_ERROR)
	EndIf

	If $g_iTownHallLevel < 2 Or ($g_aiTownHallPos[1] = "" Or $g_aiTownHallPos[1] = -1) Then LocateTownHall(False, False)

	If _Sleep($DELAYBOTDETECT1) Then Return
	CheckImageType()
	If _Sleep($DELAYBOTDETECT1) Then Return

	If $g_bScreenshotHideName Then
		If _Sleep($DELAYBOTDETECT3) Then Return
		If $g_aiClanCastlePos[0] = -1 Then
			LocateClanCastle(False)
			SaveConfig()
		EndIf
	EndIf

	If _Sleep($DELAYBOTDETECT3) Then Return
	If $g_aiLaboratoryPos[0] = "" Or $g_aiLaboratoryPos[0] = -1 Then
		LocateLab(False)
		SaveConfig()
	EndIf

	If Number($g_iTownHallLevel) >= 14 Then
		If _Sleep($DELAYBOTDETECT3) Then Return
		If $g_aiPetHousePos[0] = "" Or $g_aiPetHousePos[0] = -1 Then
			LocatePetHouse(False)
			SaveConfig()
		EndIf
	EndIf

	If Number($g_iTownHallLevel) >= 8 Then
		If _Sleep($DELAYBOTDETECT3) Then Return
		If $g_aiBlacksmithPos[0] = "" Or $g_aiBlacksmithPos[0] = -1 Then
			LocateBlacksmith(False)
			SaveConfig()
		EndIf
	EndIf

	If Number($g_iTownHallLevel) >= 7 Then
		If $g_iCmbBoostBarbarianKing > 0 Or $g_bUpgradeKingEnable Then
			If _Sleep($DELAYBOTDETECT3) Then Return
			If $g_aiKingAltarPos[0] = -1 Then
				LocateKingAltar(False)
				SaveConfig()
			EndIf
		EndIf

		If Number($g_iTownHallLevel) >= 9 And ($g_iCmbBoostArcherQueen > 0 Or $g_bUpgradeQueenEnable) Then
			If _Sleep($DELAYBOTDETECT3) Then Return
			If $g_aiQueenAltarPos[0] = -1 Then
				LocateQueenAltar(False)
				SaveConfig()
			EndIf
		EndIf

		If Number($g_iTownHallLevel) >= 11 And ($g_iCmbBoostWarden > 0 Or $g_bUpgradeWardenEnable) Then
			If _Sleep($DELAYBOTDETECT3) Then Return
			If $g_aiWardenAltarPos[0] = -1 Then
				LocateWardenAltar(False)
				SaveConfig()
			EndIf
		EndIf

		If Number($g_iTownHallLevel) >= 13 And ($g_iCmbBoostChampion > 0 Or $g_bUpgradeChampionEnable) Then
			If _Sleep($DELAYBOTDETECT3) Then Return
			If $g_aiChampionAltarPos[0] = -1 Then
				LocateChampionAltar(False)
				SaveConfig()
			EndIf
		EndIf
	EndIf

	;Display Level TH in Stats
	GUICtrlSetData($g_hLblTHLevels, "")

	_GUI_Value_STATE("HIDE", $g_aGroupListTHLevels)
	SetDebugLog("Select TH Level:" & Number($g_iTownHallLevel), $COLOR_DEBUG)
	GUICtrlSetState($g_ahPicTHLevels[$g_iTownHallLevel], $GUI_SHOW)
	GUICtrlSetData($g_hLblTHLevels, $g_iTownHallLevel)
EndFunc   ;==>BotDetectFirstTime