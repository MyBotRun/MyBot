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
		If $matchDB And $iAtkAlgorithm[$DB] = 2 Then ;MilkingAttack
			If ( ( $MilkAttackType=1 and $dbBase )  or ( $MilkAttackType= 0 ) )  then  ;if milking attack enabled high cpu(attacktype=0) or lowcpu and match $dbase Collectors...
				  Local $TimeCheckMilkingAttack = TimerInit()
				  If $debugsetlog = 1 Then Setlog("Check Milking...", $color_purple)
				  MilkingDetectRedArea()
				  $MilkingExtractorsMatch = MilkingDetectElixirExtractors()
				  If $MilkingExtractorsMatch > 0 Then
					  $MilkingExtractorsMatch += MilkingDetectMineExtractors() + MilkingDetectDarkExtractors()
				  EndIf

				  If StringLen($MilkFarmObjectivesSTR) > 0 Then
					  If $MilkAttackType = 1 Then
						  If $debugsetlog = 1 Then Setlog("Milking match LOW CPU SETTINGS", $color_purple)
						  If $debugsetlog = 1 Then Setlog("objectives: " & $MilkFarmObjectivesSTR , $color_purple)
					  Else
						  If $debugsetlog = 1 Then Setlog("Milking match HIGH CPU SETTINGS", $color_purple)
						  If $debugsetlog = 1 Then Setlog("objectives: " & $MilkFarmObjectivesSTR , $color_purple)
					  EndIf
				  Else
					  If $debugsetlog = 1 Then Setlog("Milking no match", $color_purple)
					  If $MilkAttackAfterTHSnipe = 1 and $chkSnipeIfNoElixir = 1 Then
						  If $debugsetlog = 1 Then Setlog("Milking no match but Snipe even if no structures detected... check...",$COLOR_PURPLE)
						  If $searchTH = "-" Then	FindTownHall(True)
						  If $searchTH <>"-" Then
							  $milkingAttackOutside = 1
							  If SearchTownHallLoc() Then  ;check if townhall position it is outside
								  If $debugsetlog = 1 Then Setlog("Milking Attack TH outside match!",$color_purple)
								  $milkingAttackOutside = 1
							  Else
								  If $debugsetlog = 1 Then Setlog("TH it is not outside, skip attack")
							  EndIf
							  $milkingAttackOutside = 0
						  Else
							  If $debugsetlog = 1 Then Setlog("Cannot detect Townhall, skip THsnipe")
						  EndIf
					  EndIf
				  EndIf

				  Local $TimeCheckMilkingAttackSeconds = Round(TimerDiff($TimeCheckMilkingAttack) / 1000, 2)
				  If $TimeCheckMilkingAttackSeconds >= 23 Then
					  Setlog("Computing Time Milking Attack too HIGH", $color_red)
					  Setlog("Your computer it is too slow to use this algorithm :(", $color_red)
					  Setlog("Please change algorithm", $color_red)
				  Else
					  Setlog("Computing Time Milking Attack : " & $TimeCheckMilkingAttackSeconds & " seconds", $color_blue)
				   EndIf
			EndIf
		EndIf

EndFunc   ;==>CheckMilkingBase


