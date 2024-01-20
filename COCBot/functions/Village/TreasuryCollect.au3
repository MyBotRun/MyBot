; #FUNCTION# ====================================================================================================================
; Name ..........: TreasuryCollect
; Description ...:
; Syntax ........: TreasuryCollect()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (09-2016)
; Modified ......: Boju (02-2017), Fliegerfaust(11-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TreasuryCollect()
	SetDebugLog("Begin CollectTreasury:", $COLOR_DEBUG1) ; function trace
	If Not $g_bRunState Then Return ; ensure bot is running

	ClickAway()
	If _Sleep($DELAYRESPOND) Then Return

	If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ;check for valid CC location
		SetLog("Need Clan Castle location for the Treasury, Please locate your Clan Castle.", $COLOR_WARNING)
		LocateClanCastle()
		If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ; can not assume CC was located due msgbox timeout and unattended bo, must verify
			SetLog("Treasury skipped, bad Clan Castle location", $COLOR_ERROR)
			If _Sleep($DELAYRESPOND) Then Return
			Return
		EndIf
	EndIf
	ClickAway()
	If _Sleep($DELAYCOLLECT3) Then Return
	BuildingClick($g_aiClanCastlePos[0], $g_aiClanCastlePos[1], "#0250") ; select CC
	; Click($g_aiClanCastlePos[0], $g_aiClanCastlePos[1], 1, 0, "#0433")   ; select CC
	If _Sleep($DELAYTREASURY2) Then Return

	Local $aTreasuryButton = findButton("Treasury", Default, 1, True)
	If IsArray($aTreasuryButton) And UBound($aTreasuryButton, 1) = 2 Then
		If IsMainPage() Then ClickP($aTreasuryButton, 1, 0, "#0330")
		If _Sleep($DELAYTREASURY1) Then Return
	Else
		SetLog("Cannot find the Treasury Button", $COLOR_ERROR)
	EndIf

	If _CheckPixel($aReceivedTroopsTreasury, True) Then ; Found the "You have received" Message on Screen, wait till its gone.
		SetDebugLog("Detected Clan Castle Message Blocking Treasury Window. Waiting until it's gone", $COLOR_INFO)
		_CaptureRegion2()
		While _CheckPixel($aReceivedTroopsTreasury, True)
			If _Sleep($DELAYTRAIN1) Then Return
		WEnd
	EndIf

	If Not _WaitForCheckPixel($aTreasuryWindow, $g_bCapturePixel, Default, "Wait treasury window:") Then
		SetLog("Treasury window not found!", $COLOR_ERROR)
		Return
	EndIf

	Local $bForceCollect = False
	Local $aResult = _PixelSearch(695, 195 + $g_iMidOffsetY, 700, 320 + $g_iMidOffsetY, Hex(0x50BD10, 6), 20) ; search for green pixels showing treasury bars are full
	If IsArray($aResult) Then
		SetLog("Found full Treasury, collecting loot...", $COLOR_SUCCESS)
		$bForceCollect = True
	Else
		SetLog("Treasury not full yet", $COLOR_INFO)
	EndIf

	; Treasury window open, user msg logged, time to collect loot!
	; check for collect treasury full GUI condition enabled and low resources
	If $bForceCollect Or ($g_bChkTreasuryCollect And ((Number($g_aiCurrentLoot[$eLootGold]) <= $g_iTxtTreasuryGold) Or (Number($g_aiCurrentLoot[$eLootElixir]) <= $g_iTxtTreasuryElixir) Or (Number($g_aiCurrentLoot[$eLootDarkElixir]) <= $g_iTxtTreasuryDark))) Then
		Local $aCollectButton = findButton("Collect", Default, 1, True)
		If IsArray($aCollectButton) And UBound($aCollectButton, 1) = 2 Then
			ClickP($aCollectButton, 1, 0, "#0330")
			If _Sleep($DELAYTREASURY2) Then Return
			If ClickOkay("ConfirmCollectTreasury") Then ; Click Okay to confirm collect treasury loot
				SetLog("Treasury collected successfully.", $COLOR_SUCCESS)
			Else
				SetLog("Cannot Click Okay Button on Treasury Collect screen", $COLOR_ERROR)
			EndIf
		Else
			SetDebugLog("Error in TreasuryCollect(): Cannot find the Collect Button", $COLOR_ERROR)
		EndIf
	Else
		ClickAway()
		If _Sleep($DELAYTREASURY4) Then Return
	EndIf

	ClickAway()
	If _Sleep($DELAYTREASURY4) Then Return
EndFunc   ;==>TreasuryCollect
