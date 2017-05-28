; #FUNCTION# ====================================================================================================================
; Name ..........: TreasuryCollect
; Description ...:
; Syntax ........: TreasuryCollect()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (09-2016)
; Modified ......: Boju (02-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TreasuryCollect()
	If $g_iDebugSetlog = 1 Then SetLog("Begin CollectTreasury:", $COLOR_DEBUG1) ; function trace
	If $g_bRunState = False Then Return ; ensure bot is running

	ClickP($aAway, 1, 0, "#0441") ; clear open windows - Click Away before reading village data
	If _Sleep($DELAYRESPOND) Then Return

	Local $ImagesToUse[2]
	$ImagesToUse[0] = @ScriptDir & "\imgxml\Resources\Treasury\Treasury_0_90.xml"
	$ImagesToUse[1] = @ScriptDir & "\imgxml\Resources\Treasury\Collect_0_90.xml"
	Local $g_fToleranceImgLoc = 0.90
	Local $t = 0

	If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ;check for valid CC location
		SetLog("Need CC location for Treasury, Please Locate Clan Castle.", $COLOR_WARNING)
		LocateClanCastle()
		If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ; can not assume CC was located due msgbox timeout and unattended bo, must verify
			SetLog("Treasury skipped, bad Clan Castle location", $COLOR_ERROR)
			If _Sleep($DELAYRESPOND) Then Return
			Return
		EndIf
	EndIf
	ClickP($aAway, 1, 0, "#0440") ; Click away just in case user interupted process
	If _Sleep($DELAYCOLLECT3) Then Return
	BuildingClick($g_aiClanCastlePos[0], $g_aiClanCastlePos[1], "#0250") ; select CC
	; Click($g_aiClanCastlePos[0], $g_aiClanCastlePos[1], 1, 0, "#0433")   ; select CC
	If _Sleep($DELAYTREASURY2) Then Return

	;Find and Click Treasury Button To Open Treasury Window
	_CaptureRegion2(125, 610, 740, 715)
	Local $res = DllCallMyBot("SearchTile", "handle", $g_hHBitmap2, "str", $ImagesToUse[0], "float", $g_fToleranceImgLoc, "str", "FV", "int", 1)
	If @error Then _logErrorDLLCall($g_sLibImgLocPath, @error)
	If IsArray($res) Then
		If $g_iDebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
		If $res[0] = "0" Or $res[0] = "" Then
			If $g_iDebugSetlog = 1 Then SetLog("No Treasury Button Found", $COLOR_WARNING) ; failed to find Treasury Button
		ElseIf StringLeft($res[0], 2) = "-1" Then
			SetLog("DLL Error: " & $res[0], $COLOR_ERROR)
		Else
			Local $expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
			If UBound($expRet) > 1 Then
				Local $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
				If UBound($posPoint) > 1 Then
					Local $ButtonX = 125 + Int($posPoint[0])
					Local $ButtonY = 610 + Int($posPoint[1])
					If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
					If _Sleep($DELAYTREASURY1) Then Return
				EndIf
			EndIf
		EndIf
	EndIf ; end of treasury button find/click

	If _WaitForCheckPixel($aTreasuryWindow, $g_bCapturePixel, Default, "Wait treasury window:") = False Then
		Setlog("Treasury window not found!", $COLOR_ERROR)
		Return
	EndIf

	Local $ForceCollect = False
	Local $result = _PixelSearch(689, 237 + $g_iMidOffsetY, 691, 325 + $g_iMidOffsetY, Hex(0x50BD10, 6), 20) ; search for green pixels showing treasury bars are full
	If IsArray($result) Then
		SetLog("Found full Treasury, collecting loot...", $COLOR_SUCCESS)
		$ForceCollect = True
	Else
		SetLog("Treasury not full yet", $COLOR_INFO)
	EndIf

	; Treasury window open, user msg logged, time to collect loot!
	; check for collect treasury full GUI condition enabled and low resources
	If $ForceCollect Or ($g_bChkTreasuryCollect And ((Number($g_aiCurrentLoot[$eLootGold]) <= $g_iTxtTreasuryGold) Or (Number($g_aiCurrentLoot[$eLootElixir]) <= $g_iTxtTreasuryElixir) Or (Number($g_aiCurrentLoot[$eLootDarkElixir]) <= $g_iTxtTreasuryDark))) Then
		_CaptureRegion2(350, 450, 505, 521)
		Local $res = DllCallMyBot("SearchTile", "handle", $g_hHBitmap2, "str", $ImagesToUse[1], "float", $g_fToleranceImgLoc, "str", "FV", "int", 1)
		If @error Then _logErrorDLLCall($g_sLibImgLocPath, @error)
		If IsArray($res) Then
			If $g_iDebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
			If $res[0] = "0" Or $res[0] = "" Then
				If $g_iDebugSetlog = 1 Then SetLog("No Treasury Button Found", $COLOR_WARNING) ; failed to find Treasury Button
			ElseIf StringLeft($res[0], 2) = "-1" Then
				SetLog("DLL Error: " & $res[0], $COLOR_ERROR)
			Else
				Local $expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
				If UBound($expRet) > 1 Then
					Local $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
					If UBound($posPoint) > 1 Then
						Local $ButtonX = 350 + Int($posPoint[0])
						Local $ButtonY = 450 + Int($posPoint[1])
						Click($ButtonX, $ButtonY, 1, 0, "#0330")
						If _Sleep($DELAYTREASURY2) Then Return
						If ClickOkay("ConfirmCollectTreasury") = True Then ; Click Okay to confirm collect treasury loot
							SetLog("Loot Treasury Collected Successfully.", $COLOR_SUCCESS)
						Else
							SetLog("Error collecting Treasury", $COLOR_ERROR)
						EndIf
						ClickP($aAway, 1, 0, "#0438") ; Click away
						If _Sleep($DELAYTREASURY4) Then Return
					EndIf
				EndIf
			EndIf
		EndIf ; end of treasury button find/click
	Else
		ClickP($aAway, 1, 0, "#0438") ; Click away
		If _Sleep($DELAYTREASURY4) Then Return
	EndIf

	ClickP($aAway, 1, 0, "#0438") ; Click away
	If _Sleep($DELAYTREASURY4) Then Return
EndFunc   ;==>TreasuryCollect
