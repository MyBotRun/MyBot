; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingCheckMilkingBase.au3
; Description ...:Check if the base match milking values
; Syntax ........:CheckMilkingBase()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func CheckMilkingBase($matchDB, $dbBase)
	    Local $MilkingExtractorsMatch = 0
		$MilkFarmObjectivesSTR = ""
		$milkingAttackOutside = 0
		If $matchDB And $g_aiAttackAlgorithm[$DB] = 2 Then ;MilkingAttack
			If ( ( $g_iMilkAttackType=1 and $dbBase )  or ( $g_iMilkAttackType= 0 ) )  then  ;if milking attack enabled high cpu(attacktype=0) or lowcpu and match $dbase Collectors...
				  Local $TimeCheckMilkingAttack = TimerInit()
				  If $g_iDebugSetlog = 1 Then Setlog("Check Milking...", $COLOR_DEBUG)
				  MilkingDetectRedArea()
				  $MilkingExtractorsMatch = MilkingDetectElixirExtractors()
				  If $MilkingExtractorsMatch > 0 Then
					  $MilkingExtractorsMatch += MilkingDetectMineExtractors() + MilkingDetectDarkExtractors()
				  EndIf

				  If StringLen($MilkFarmObjectivesSTR) > 0 Then
					  If $g_iMilkAttackType = 1 Then
						  If $g_iDebugSetlog = 1 Then Setlog("Milking match LOW CPU SETTINGS", $COLOR_DEBUG)
						  If $g_iDebugSetlog = 1 Then Setlog("objectives: " & $MilkFarmObjectivesSTR , $COLOR_DEBUG)
					  Else
						  If $g_iDebugSetlog = 1 Then Setlog("Milking match HIGH CPU SETTINGS", $COLOR_DEBUG)
						  If $g_iDebugSetlog = 1 Then Setlog("objectives: " & $MilkFarmObjectivesSTR , $COLOR_DEBUG)
					  EndIf
				  Else
					  If $g_iDebugSetlog = 1 Then Setlog("Milking no match", $COLOR_DEBUG)
					  If $g_bMilkAttackAfterTHSnipeEnable and $g_bMilkFarmSnipeEvenIfNoExtractorsFound Then
						  If $g_iDebugSetlog = 1 Then Setlog("Milking no match but Snipe even if no structures detected... check...",$COLOR_DEBUG)
						  If $searchTH = "-" Then FindTownHall(True)
						  If $searchTH <>"-" Then
							  $milkingAttackOutside = 1
							  If SearchTownHallLoc() Then  ;check if townhall position it is outside
								  If $g_iDebugSetlog = 1 Then Setlog("Milking Attack TH outside match!",$COLOR_DEBUG)
								  $milkingAttackOutside = 1
							  Else
								  If $g_iDebugSetlog = 1 Then Setlog("TH it is not outside, skip attack")
							  EndIf
							  $milkingAttackOutside = 0
						  Else
							  If $g_iDebugSetlog = 1 Then Setlog("Cannot detect Townhall, skip THsnipe")
						  EndIf
					  EndIf
				  EndIf

				  Local $TimeCheckMilkingAttackSeconds = Round(TimerDiff($TimeCheckMilkingAttack) / 1000, 2)
				  If $TimeCheckMilkingAttackSeconds >= 23 Then
					  Setlog("Computing Time Milking Attack too HIGH", $COLOR_ERROR)
					  Setlog("Your computer it is too slow to use this algorithm :(", $COLOR_ERROR)
					  Setlog("Please change algorithm", $COLOR_ERROR)
				  Else
					  Setlog("Computing Time Milking Attack : " & $TimeCheckMilkingAttackSeconds & " seconds", $COLOR_INFO)
				   EndIf
			EndIf
		EndIf

EndFunc   ;==>CheckMilkingBase


