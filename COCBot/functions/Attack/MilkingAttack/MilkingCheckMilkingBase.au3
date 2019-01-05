; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingCheckMilkingBase.au3
; Description ...:Check if the base match milking values
; Syntax ........:CheckMilkingBase()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func CheckMilkingBase($matchDB, $dbBase)
	Local $MilkingExtractorsMatch = 0
	$g_sMilkFarmObjectivesSTR = ""
	$g_bMilkingAttackOutside = False
	If $matchDB And $g_aiAttackAlgorithm[$DB] = 2 Then ;MilkingAttack
		If (($g_iMilkAttackType = 1 And $dbBase) Or ($g_iMilkAttackType = 0)) Then ;if milking attack enabled high cpu(attacktype=0) or lowcpu and match $dbase Collectors...
			Local $TimeCheckMilkingAttack = __TimerInit()
			If $g_bDebugSetlog Then SetDebugLog("Check Milking...", $COLOR_DEBUG)
			MilkingDetectRedArea()
			$MilkingExtractorsMatch = MilkingDetectElixirExtractors()
			If $MilkingExtractorsMatch > 0 Then
				$MilkingExtractorsMatch += MilkingDetectMineExtractors() + MilkingDetectDarkExtractors()
			EndIf

			If StringLen($g_sMilkFarmObjectivesSTR) > 0 Then
				If $g_iMilkAttackType = 1 Then
					If $g_bDebugSetlog Then SetDebugLog("Milking match LOW CPU SETTINGS", $COLOR_DEBUG)
					If $g_bDebugSetlog Then SetDebugLog("objectives: " & $g_sMilkFarmObjectivesSTR, $COLOR_DEBUG)
				Else
					If $g_bDebugSetlog Then SetDebugLog("Milking match HIGH CPU SETTINGS", $COLOR_DEBUG)
					If $g_bDebugSetlog Then SetDebugLog("objectives: " & $g_sMilkFarmObjectivesSTR, $COLOR_DEBUG)
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("Milking no match", $COLOR_DEBUG)
				If $g_bMilkAttackAfterTHSnipeEnable And $g_bMilkFarmSnipeEvenIfNoExtractorsFound Then
					If $g_bDebugSetlog Then SetDebugLog("Milking no match but Snipe even if no structures detected... check...", $COLOR_DEBUG)
					If $g_iSearchTH = "-" Then FindTownHall(True)
					If $g_iSearchTH <> "-" Then
						$g_bMilkingAttackOutside = True
						If SearchTownHallLoc() Then ;check if townhall position it is outside
							If $g_bDebugSetlog Then SetDebugLog("Milking Attack TH outside match!", $COLOR_DEBUG)
							$g_bMilkingAttackOutside = True
						Else
							If $g_bDebugSetlog Then SetDebugLog("TH it is not outside, skip attack")
						EndIf
						$g_bMilkingAttackOutside = False
					Else
						If $g_bDebugSetlog Then SetDebugLog("Cannot detect Townhall, skip THsnipe")
					EndIf
				EndIf
			EndIf

			Local $TimeCheckMilkingAttackSeconds = Round(__TimerDiff($TimeCheckMilkingAttack) / 1000, 2)
			If $TimeCheckMilkingAttackSeconds >= 23 Then
				SetLog("Computing Time Milking Attack too HIGH", $COLOR_ERROR)
				SetLog("Your computer it is too slow to use this algorithm :(", $COLOR_ERROR)
				SetLog("Please change algorithm", $COLOR_ERROR)
			Else
				SetLog("Computing Time Milking Attack : " & $TimeCheckMilkingAttackSeconds & " seconds", $COLOR_INFO)
			EndIf
		EndIf
	EndIf

EndFunc   ;==>CheckMilkingBase


