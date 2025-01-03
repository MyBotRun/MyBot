; #FUNCTION# ====================================================================================================================
; Name ..........: BoostKing & BoostQueen
; Description ...:
; Syntax ........: BoostKing() & BoostQueen()
; Parameters ....:
; Return values .: None
; Author ........: ProMac 2015
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BoostKing()
	; Verifying existent Variables to run this routine
	If AllowBoosting("Barbarian King", $g_iCmbBoostBarbarianKing) = False Then Return

	SetLog("Boost Barbarian King...", $COLOR_INFO)
	If $g_aiHeroHallPos[0] = "" Or $g_aiHeroHallPos[0] = -1 Then
		LocateHeroHall()
		SaveConfig()
		If _Sleep($DELAYBOOSTHEROES4) Then Return
	EndIf

	If BoostStructure("Barbarian King", "King", $g_aiHeroHallPos, $g_iCmbBoostBarbarianKing, $g_hCmbBoostBarbarianKing) Then $g_aiHeroBoost[$eHeroBarbarianKing] = _NowCalc()
	$g_aiTimeTrain[2] = 0 ; reset Heroes remaining time

	If _Sleep($DELAYBOOSTBARRACKS3) Then Return
	checkMainScreen(False) ; Check for errors during function
EndFunc   ;==>BoostKing


Func BoostQueen()
	; Verifying existent Variables to run this routine
	If AllowBoosting("Archer Queen", $g_iCmbBoostArcherQueen) = False Then Return

	SetLog("Boost Archer Queen...", $COLOR_INFO)
	If $g_aiHeroHallPos[0] = "" Or $g_aiHeroHallPos[0] = -1 Then
		LocateHeroHall()
		SaveConfig()
		If _Sleep($DELAYBOOSTHEROES4) Then Return
	EndIf

	If BoostStructure("Archer Queen", "Queen", $g_aiHeroHallPos, $g_iCmbBoostArcherQueen, $g_hCmbBoostArcherQueen) Then $g_aiHeroBoost[$eHeroArcherQueen] = _NowCalc()
	$g_aiTimeTrain[2] = 0 ; reset Heroes remaining time

	If _Sleep($DELAYBOOSTBARRACKS3) Then Return
	checkMainScreen(False) ; Check for errors during function
EndFunc   ;==>BoostQueen

Func BoostPrince()
	; Verifying existent Variables to run this routine
	If AllowBoosting("Archer Prince", $g_iCmbBoostMinionPrince) = False Then Return

	SetLog("Boost Minion Prince...", $COLOR_INFO)
	If $g_aiHeroHallPos[0] = "" Or $g_aiHeroHallPos[0] = -1 Then
		LocateHeroHall()
		SaveConfig()
		If _Sleep($DELAYBOOSTHEROES4) Then Return
	EndIf

	If BoostStructure("Minion Prince", "Prince", $g_aiHeroHallPos, $g_iCmbBoostMinionPrince, $g_hCmbBoostMinionPrince) Then $g_aiHeroBoost[$eHeroMinionPrince] = _NowCalc()
	$g_aiTimeTrain[2] = 0 ; reset Heroes remaining time

	If _Sleep($DELAYBOOSTBARRACKS3) Then Return
	checkMainScreen(False) ; Check for errors during function
EndFunc   ;==>BoostPrince

Func BoostWarden()
	; Verifying existent Variables to run this routine
	If AllowBoosting("Grand Warden", $g_iCmbBoostWarden) = False Then Return

	SetLog("Boost Grand Warden...", $COLOR_INFO)
	If $g_aiHeroHallPos[0] = "" Or $g_aiHeroHallPos[0] = -1 Then
		LocateheroHall()
		SaveConfig()
		If _Sleep($DELAYBOOSTHEROES4) Then Return
	EndIf

	If BoostStructure("Grand Warden", "Warden", $g_aiHeroHallPos, $g_iCmbBoostWarden, $g_hCmbBoostWarden) Then $g_aiHeroBoost[$eHeroGrandWarden] = _NowCalc()
	$g_aiTimeTrain[2] = 0 ; reset Heroes remaining time

	If _Sleep($DELAYBOOSTBARRACKS3) Then Return
	checkMainScreen(False) ; Check for errors during function
EndFunc   ;==>BoostWarden

Func BoostChampion()
	; Verifying existent Variables to run this routine
	If AllowBoosting("Royal Champion", $g_iCmbBoostChampion) = False Then Return

	SetLog("Boost Royal Champion...", $COLOR_INFO)
	If $g_aiHeroHallPos[0] = "" Or $g_aiHeroHallPos[0] = -1 Then
		LocateHeroHall()
		SaveConfig()
		If _Sleep($DELAYBOOSTHEROES4) Then Return
	EndIf

	If BoostStructure("Royal Champion", "Champion", $g_aiHeroHallPos, $g_iCmbBoostChampion, $g_hCmbBoostChampion) Then $g_aiHeroBoost[$eHeroRoyalChampion] = _NowCalc()
	$g_aiTimeTrain[2] = 0 ; reset Heroes remaining time

	If _Sleep($DELAYBOOSTBARRACKS3) Then Return
	checkMainScreen(False) ; Check for errors during function
EndFunc   ;==>BoostChampion
