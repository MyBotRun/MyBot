; #FUNCTION# ====================================================================================================================
; Name ..........: Train
; Description ...: Train the troops (Fill the barracks), Uses the location of manually set Barracks to train specified troops
; Syntax ........: Train()
; Parameters ....:
; Return values .: None
; Author ........: Hungle
; Modified ......: ProMac(08-2016), Sardo(2015), KnowJack(Jul/Aug 2105), barracoda (July/Aug 2015), Sardo(2015-08, kaganus(Aug 2015) ,TheMaster 2015-10, Boju 2016-06
; Remarks .......:
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $LastBarrackTrainDonatedTroop = 1
Global $LastDarkBarrackTrainDonatedTroop = 1


Func Train()

	If $iAtkAlgorithm[$LB] = 2 Then
		Local $TempTroopGroup[12][3] = [["Gobl", 3, 1], ["Arch", 1, 1], ["Giant", 2, 5], ["Wall", 4, 2], ["Barb", 0, 1], ["Heal", 7, 14], ["Pekk", 9, 25], ["Ball", 5, 5], ["Wiza", 6, 4], ["Drag", 8, 20], ["BabyD", 10, 10], ["Mine", 11, 5]]
		$TroopGroup = $TempTroopGroup
		Local $tempTroopName[UBound($TroopGroup, 1)]
		$TroopName = $tempTroopName

		Local $TempTroopNamePosition[UBound($TroopGroup, 1)]
		$TroopNamePosition = $TempTroopNamePosition
		Local $TempTroopHeight[UBound($TroopGroup, 1)]
		$TroopHeight = $TempTroopHeight
		Local $TempTroopGroupDark[7][3] = [["Mini", 0, 2], ["Hogs", 1, 5], ["Valk", 2, 8], ["Gole", 3, 30], ["Witc", 4, 12], ["Lava", 5, 30], ["Bowl", 6, 6]]
		$TroopGroupDark = $TempTroopGroupDark
		Local $TempTroopDarkName[UBound($TroopGroupDark, 1)]
		$TroopDarkName = $TempTroopDarkName
		Local $TempTroopDarkNamePosition[UBound($TroopGroupDark, 1)]
		$TroopDarkNamePosition = $TempTroopDarkNamePosition
		Local $TempSpellGroup[3][3] = [["PSpell", 0, 1], ["ESpell", 1, 1], ["HaSpell", 2, 1]]
		$SpellGroup = $TempSpellGroup
		Local $TempSpellName[UBound($SpellGroup, 1)]
		$SpellName = $TempSpellName
		Local $TempSpellNamePosition[UBound($SpellGroup, 1)]
		$SpellNamePosition = $TempSpellNamePosition
		Local $TempSpellHeight[UBound($SpellGroup, 1)]
		$SpellHeight = $TempSpellHeight

		For $i = 0 To UBound($TroopGroup, 1) - 1
			$TroopName[$i] = $TroopGroup[$i][0]
			$TroopNamePosition[$i] = $TroopGroup[$i][1]
			$TroopHeight[$i] = $TroopGroup[$i][2]
		Next
		For $i = 0 To UBound($TroopGroupDark, 1) - 1
			$TroopDarkName[$i] = $TroopGroupDark[$i][0]
			$TroopDarkNamePosition[$i] = $TroopGroupDark[$i][1]
			$TroopDarkHeight[$i] = $TroopGroupDark[$i][2]
		Next
		For $i = 0 To UBound($SpellGroup, 1) - 1
			$SpellName[$i] = $SpellGroup[$i][0]
			$SpellNamePosition[$i] = $SpellGroup[$i][1]
			$SpellHeight[$i] = $SpellGroup[$i][2]
		Next

	EndIf


	Local $anotherTroops
	Local $tempCounter = 0
	Local $tempElixir = ""
	Local $tempDElixir = ""
	Local $tempElixirSpent = 0
	Local $tempDElixirSpent = 0
	Local $tmpNumber

	If $debugsetlogTrain = 1 Then SetLog("Func Train ", $COLOR_PURPLE)
	If $bTrainEnabled = False Then Return

	; Read Resource Values For army cost Stats
	VillageReport(True, True)
	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 5
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd
	$tempElixir = $iElixirCurrent
	$tempDElixir = $iDarkCurrent
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; in halt attack mode Make sure army reach 100% regardless of user Percentage of full army
	If ($CommandStop = 3 Or $CommandStop = 0) Then
		CheckOverviewFullArmy(True)
		If $fullarmy Then
			If $debugsetlogTrain = 1 Then SetLog("FullArmy & TotalTrained = skip training", $COLOR_PURPLE)
			Return
		EndIf
	EndIf

	; ###########################################  1st Stage : Prepare training & Variables & Values ##############################################

	; Reset variables $Cur+TroopName ( used to assign the quantity of troops to train )
	; Only reset if the FullArmy , Last attacks was a TH Snipes or First Start.
	; Global $Cur+TroopName = 0

	If $FirstStart Or $iMatchMode = $TS Then
		For $i = 0 To UBound($TroopName) - 1
			If $debugsetlogTrain = 1 Then SetLog("RESET AT 0 " & "Cur" & $TroopName[$i], $COLOR_PURPLE)
			Assign("Cur" & $TroopName[$i], 0)
		Next

		For $i = 0 To UBound($TroopDarkName) - 1
			If $debugsetlogTrain = 1 Then SetLog("RESET AT 0 " & "Cur" & $TroopDarkName[$i], $COLOR_PURPLE)
			Assign("Cur" & $TroopDarkName[$i], 0)
		Next
	EndIf

	For $i = 0 To UBound($TroopName) - 1
		Assign(("tooMany" & $TroopName[$i]), 0)
		Assign(("tooFew" & $TroopName[$i]), 0)
	Next

	For $i = 0 To UBound($TroopDarkName) - 1
		Assign(("tooMany" & $TroopDarkName[$i]), 0)
		Assign(("tooFew" & $TroopDarkName[$i]), 0)
	Next


	;If $FirstStart And $OptTrophyMode = 1 And $icmbTroopComp <> 8 Then

	If $FirstStart And $icmbTroopComp <> 8 Then
		$ArmyComp = $CurCamp
	EndIf

	; Is necessary Check Total Army Camp and existent troops inside of ArmyCamp
	; $icmbTroopComp - variable used to differentiate the Troops Composition selected in GUI
	; Inside of checkArmyCamp exists:
	; $CurCamp - quantity of troops existing in ArmyCamp  / $TotalCamp - your total troops capacity
	; BarracksStatus() - Verifying how many barracks / spells factory exists and if are available to use.
	; $numBarracksAvaiables returns to be used as the divisor to assign the amount of kind troops each barracks | $TroopName+EBarrack
	;

	SetLog("Training Troops & Spells", $COLOR_BLUE)
	If _Sleep($iDelayTrain1) Then Return
	ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
	If _Sleep($iDelayTrain4) Then Return

	;OPEN ARMY OVERVIEW WITH NEW BUTTON
	; WaitforPixel($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10)
	If WaitforPixel(28, 505 + $bottomOffsetY, 30, 507 + $bottomOffsetY, Hex(0xE4A438, 6), 5, 10) Then
		If $debugsetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
		If IsMainPage() Then
			If $iUseRandomClick = 0 Then
				Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
			Else
				ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
			EndIf
		EndIf
	EndIf

	;Wait for the armyoverview Window
	If WaitforPixel(762, 328 + $midOffsetY, 763, 329 + $midOffsetY, Hex(0xF18439, 6), 10, 10) Then
		If $debugsetlogTrain = 1 Then SetLog("Wait for ArmyOverView Window", $COLOR_GREEN)
		If IsTrainPage() Then checkArmyCamp()
	EndIf

	If _Sleep($iDelayRunBot6) Then Return ; wait for window to open
	If Not (IsTrainPage()) Then Return ; exit if I'm not in train page

	checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page

	; CHECK IF NEED TO MAKE TROOPS
	; Verify the Global variable $TroopName+Comp and return the GUI selected troops by user
	;
	If $isNormalBuild = "" Or $FirstStart Then
		For $i = 0 To UBound($TroopName) - 1
			If Eval($TroopName[$i] & "Comp") <> "0" Then
				$isNormalBuild = True
			EndIf
		Next
	EndIf
	If $isNormalBuild = "" Then
		$isNormalBuild = False
	EndIf
	If $debugsetlogTrain = 1 Then SetLog("Train: need to make normal troops: " & $isNormalBuild, $COLOR_PURPLE)

	; CHECK IF NEED TO MAKE DARK TROOPS
	; Verify the Global variable $TroopDarkName+Comp and return the GUI selected troops by user
	;
	If $isDarkBuild = "" Or $FirstStart Then
		For $i = 0 To UBound($TroopDarkName) - 1
			If Eval($TroopDarkName[$i] & "Comp") <> "0" Then
				$isDarkBuild = True
			EndIf
		Next
	EndIf
	If $isDarkBuild = "" Or $icmbDarkTroopComp = 2 Then
		$isDarkBuild = False
	EndIf
	If $debugsetlogTrain = 1 Then SetLog("Train: need to make dark troops: " & $isDarkBuild, $COLOR_PURPLE)

	; GO TO First NORMAL BARRACK
	; Find First barrack $i
	Local $Firstbarrack = 0, $i = 1
	While $Firstbarrack = 0 And $i <= 4
		If $Trainavailable[$i] = 1 Then $Firstbarrack = $i
		$i += 1
	WEnd

	If $Firstbarrack = 0 Then
		Setlog("No barrack avaiable, cannot start train")
		Return ;exit from train
	Else
		If $debugsetlogTrain = 1 Then Setlog("First BARRACK = " & $Firstbarrack, $COLOR_PURPLE)
		;GO TO First BARRACK
		Local $j = 0
		While Not _ColorCheck(_GetPixelColor($btnpos[0][0], $btnpos[0][1], True), Hex(0xE8E8E0, 6), 20)
			If $debugsetlogTrain = 1 Then Setlog("OverView TabColor=" & _GetPixelColor($btnpos[0][0], $btnpos[0][1], True), $COLOR_PURPLE)
			If _Sleep($iDelayTrain1) Then Return ; wait for Train Window to be ready.
			$j += 1
			If $j > 15 Then ExitLoop
		WEnd
		If $j > 15 Then
			SetLog("Training Overview Window didn't open", $COLOR_RED)
			Return
		EndIf
		If Not (IsTrainPage()) Then Return ;exit if no train page
		Click($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], 1, $iDelayTrain5, "#0336") ; Click on tab and go to last barrack
		Local $j = 0
		While Not _ColorCheck(_GetPixelColor($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], True), Hex(0xE8E8E0, 6), 20)
			If $debugsetlogTrain = 1 Then Setlog("First Barrack TabColor=" & _GetPixelColor($btnpos[$Firstbarrack][0], $btnpos[$Firstbarrack][1], True), $COLOR_PURPLE)
			If _Sleep($iDelayTrain1) Then Return
			$j += 1
			If $j > 15 Then ExitLoop
		WEnd
		If $j > 15 Then
			SetLog("some error occurred, cannot open barrack", $COLOR_RED)
		EndIf
	EndIf


	; PREPARE TROOPS IF FULL ARMY
	; Baracks status to false , after the first loop and train Selected Troops composition = True
	;
	If $debugsetlogTrain = 1 Then Setlog("Fullarmy = " & $fullarmy & " CurCamp = " & $CurCamp & " TotalCamp = " & $TotalCamp & " - result = " & ($fullarmy = True And $CurCamp = $TotalCamp), $COLOR_PURPLE)
	If $fullarmy = True Then
		$BarrackStatus[0] = False
		$BarrackStatus[1] = False
		$BarrackStatus[2] = False
		$BarrackStatus[3] = False
		$BarrackDarkStatus[0] = False
		$BarrackDarkStatus[1] = False
		SetLog("Your Army Camps are now Full", $COLOR_RED)
		If ($PushBulletEnabled = 1 And $ichkAlertPBCampFull = 1) Then PushMsg("CampFull")
	EndIf

	;If is fullArmy or FirstStart or we are using the Barracks modes is not necessary count the donations , the $Cur will add the correct troops to make
	;Reset the Donate variable to 0
	If $fullarmy = True Or $FirstStart = True Or $icmbTroopComp = 8 Then
		$LastBarrackTrainDonatedTroop = 1
		For $i = 0 To UBound($TroopName) - 1
			Assign("Don" & $TroopName[$i], 0)
		Next
	EndIf
	;If id fullArmy or FirstStart  is not necessary count the donations , the $Cur will add the correct troops to make
	;Barrack mode was removed from here because of the extra Dark Troops we can make in Barrack Mode
	If $fullarmy = True Or $FirstStart = True Then
		$LastDarkBarrackTrainDonatedTroop = 1
		For $i = 0 To UBound($TroopDarkName) - 1
			Assign("Don" & $TroopDarkName[$i], 0)
		Next
	EndIf

	; ########################################  2nd Stage : Calculating of Troops to Make ##############################################

	If $debugsetlogTrain = 1 Then SetLog("Total ArmyCamp :" & $TotalCamp, $COLOR_PURPLE)

	If $fullarmy = True Then
		SetLog("Calculating Troops before Training new Army.", $COLOR_BLUE)
		$anotherTroops = 0
		$TotalTrainedTroops = 0
		If $debugsetlogTrain = 1 Then SetLog("--------- Calculating Troops / FullArmy true ---------", $COLOR_PURPLE)

		; Balance Elixir troops but not archers ,barb and goblins
		For $i = 0 To UBound($TroopName) - 1
			If $TroopName[$i] <> "Barb" And $TroopName[$i] <> "Arch" And $TroopName[$i] <> "Gobl" And Number(Eval($TroopName[$i] & "Comp")) <> 0 Then
				If $debugsetlogTrain = 1 Then SetLog("GUI ASSIGN to $Cur" & $TroopName[$i] & ":" & Eval($TroopName[$i] & "Comp") & " Units", $COLOR_PURPLE)
				If $icmbTroopComp <> 8 And Eval("Cur" & $TroopName[$i]) * -1 >= Eval($TroopName[$i] & "Comp") * 2.0 Then ; 200% way too many
					SetLog("Way Too many " & $TroopName[$i] & ", Dont Train.")
					Assign(("Cur" & $TroopName[$i]), 0)
					$anotherTroops += Eval($TroopName[$i] & "Comp") * $TroopHeight[$i] ; When army full, add WayTooMany to $anotherTroops to prevent Arch/Barb/Gobl filling
				Else
					If $icmbTroopComp <> 8 And Eval("Cur" & $TroopName[$i]) * -1 > Eval($TroopName[$i] & "Comp") * 1.10 Then ; 110% too many
						SetLog("Too many " & $TroopName[$i] & ", train last.")
						Assign(("Cur" & $TroopName[$i]), 0)
						Assign(("tooMany" & $TroopName[$i]), 1)
						$anotherTroops += Eval($TroopName[$i] & "Comp") * $TroopHeight[$i] ; When army full, add Too Many to $anotherTroops to prevent Arch/Barb/Gobl filling
					ElseIf $icmbTroopComp <> 8 And (Eval("Cur" & $TroopName[$i]) * -1 < Eval($TroopName[$i] & "Comp") * .90) Then ; 90% too few
						SetLog("Too few " & $TroopName[$i] & ", train first.")
						Assign(("Cur" & $TroopName[$i]), 0)
						Assign(("tooFew" & $TroopName[$i]), 1)
						$anotherTroops += Eval($TroopName[$i] & "Comp") * $TroopHeight[$i] ; When army full, add WayTooMany to $anotherTroops to prevent Arch/Barb/Gobl filling
					Else
						;##########################################################
						If IsTroopToDonateOnly(Eval("e" & $TroopName[$i])) Then
							Assign(("Cur" & $TroopName[$i]), Eval("Cur" & $TroopName[$i]) + Eval($TroopName[$i] & "Comp"))
							$anotherTroops += (Eval("Cur" & $TroopName[$i]) + Eval($TroopName[$i] & "Comp")) * $TroopHeight[$i]
						Else
							Assign(("Cur" & $TroopName[$i]), Eval($TroopName[$i] & "Comp"))
							$anotherTroops += Eval($TroopName[$i] & "Comp") * $TroopHeight[$i]
						EndIf
						;#########################################################
					EndIf
					;###########################################################
					If Eval("Cur" & $TroopName[$i]) < 0 Then ; this is necessary to remove from $TotalCamp the existent Troops in the Camp ( not selected to deploy in attack )
						$anotherTroops += (Eval("Cur" & $TroopName[$i]) * -1) * $TroopHeight[$i]
					EndIf
					;###########################################################
					If $debugsetlogTrain = 1 And Eval($TroopName[$i] & "Comp") > 0 Then SetLog("-- AnotherTroops to train:" & $anotherTroops & " + " & Eval($TroopName[$i] & "Comp") & "*" & $TroopHeight[$i], $COLOR_PURPLE)
				EndIf
			EndIf
		Next

		If $anotherTroops > 0 Then
			If $debugsetlogTrain = 1 Then SetLog("~Total/Space occupied after assign Normal Troops to train:" & $anotherTroops & "/" & $TotalCamp, $COLOR_PURPLE)
		EndIf

		; Balance Dark elixir troops
		For $i = 0 To UBound($TroopDarkName) - 1
			If Number(Eval($TroopDarkName[$i] & "Comp")) <> 0 Then
				If $debugsetlogTrain = 1 Then SetLog("Need to train ASSIGN.... Cur" & $TroopDarkName[$i] & ":" & Eval($TroopDarkName[$i] & "Comp"), $COLOR_PURPLE)
				If $icmbTroopComp <> 8 And Eval("Cur" & $TroopDarkName[$i]) * -1 >= Eval($TroopDarkName[$i] & "Comp") * 2.0 Then ; 200% way too many
					SetLog("Way Too many " & $TroopDarkName[$i] & ", Dont Train.")
					Assign(("Cur" & $TroopDarkName[$i]), 0)
					$anotherTroops += Eval($TroopDarkName[$i] & "Comp") * $TroopDarkHeight[$i] ; When army full, add WayTooMany to $anotherTroops to prevent Arch/Barb/Gobl/Minion filling
				Else
					If $icmbTroopComp <> 8 And Eval("Cur" & $TroopDarkName[$i]) * -1 > Eval($TroopDarkName[$i] & "Comp") * 1.10 Then ; 110% too many
						SetLog("Too many " & $TroopDarkName[$i] & ", train last.")
						Assign(("Cur" & $TroopDarkName[$i]), 0)
						Assign(("tooMany" & $TroopDarkName[$i]), 1)
						$anotherTroops += Eval($TroopDarkName[$i] & "Comp") * $TroopDarkHeight[$i] ; When army full, add TooMany to $anotherTroops to prevent Arch/Barb/Gobl/Minion filling
					ElseIf $icmbTroopComp <> 8 And (Eval("Cur" & $TroopDarkName[$i]) * -1 < Eval($TroopDarkName[$i] & "Comp") * .90) Then ; 90% too few
						SetLog("Too few " & $TroopDarkName[$i] & ", train first.")
						Assign(("Cur" & $TroopDarkName[$i]), 0)
						Assign(("tooFew" & $TroopDarkName[$i]), 1)
						$anotherTroops += Eval($TroopDarkName[$i] & "Comp") * $TroopDarkHeight[$i] ; When army full, add Too few to $anotherTroops to prevent Arch/Barb/Gobl/Minion filling
					Else
						;###############################################################
						If IsTroopToDonateOnly(Eval("e" & $TroopDarkName[$i])) Then
							Assign(("Cur" & $TroopDarkName[$i]), Eval("Cur" & $TroopDarkName[$i]) + Eval($TroopDarkName[$i] & "Comp"))
							$anotherTroops += (Eval("Cur" & $TroopDarkName[$i]) + Eval($TroopDarkName[$i] & "Comp")) * $TroopDarkHeight[$i]
						Else
							Assign(("Cur" & $TroopDarkName[$i]), Eval($TroopDarkName[$i] & "Comp"))
							$anotherTroops += Eval($TroopDarkName[$i] & "Comp") * $TroopDarkHeight[$i]
						EndIf
						;#############################################################
					EndIf
					;#################################################################
					If Eval("Cur" & $TroopDarkName[$i]) < 0 Then ; this is necessary to remove from $TotalCamp the existent Troops in the Camp ( not selected to deploy in attack )
						$anotherTroops += (Eval("Cur" & $TroopDarkName[$i]) * -1) * $TroopDarkHeight[$i]
					EndIf
					;################################################################
					If $debugsetlogTrain = 1 And Number(Eval($TroopDarkName[$i] & "Comp")) <> 0 Then SetLog("-- AnotherTroops dark to train:" & $anotherTroops & " + " & Eval($TroopDarkName[$i] & "Comp") & "*" & $TroopDarkHeight[$i], $COLOR_PURPLE)
				EndIf
			EndIf
		Next

		If $anotherTroops > 0 Then
			If $debugsetlogTrain = 1 Then SetLog("~Total/Space occupied after assign Normal+Dark Troops to train:" & $anotherTroops & "/" & $TotalCamp, $COLOR_PURPLE)
		EndIf

		If $debugsetlogTrain = 1 Then SetLog("------- Calculating TOTAL of Units: Arch/Barbs/Gobl ------", $COLOR_PURPLE)

		; Balance Archers ,Barbs and goblins
		If $icmbTroopComp <> 8 Then

			For $i = 0 To UBound($TroopName) - 1
				If Number(Eval($TroopName[$i] & "Comp")) <> 0 Then
					If $TroopName[$i] = "Barb" Or $TroopName[$i] = "Arch" Or $TroopName[$i] = "Gobl" Then
						If Eval("Cur" & $TroopName[$i]) * -1 > ($TotalCamp - $anotherTroops) * Eval($TroopName[$i] & "Comp") / 100 * 1.1 Then ; 110% too many troops
							SetLog("Too many " & $TroopName[$i] & ", train last.")
							Assign("Cur" & $TroopName[$i], 0)
							Assign(("tooMany" & $TroopName[$i]), 1)
						ElseIf (Eval("Cur" & $TroopName[$i]) * -1 < ($TotalCamp - $anotherTroops) * Eval($TroopName[$i] & "Comp") / 100 * .90) Then ; 90% too few troops
							SetLog("Too few " & $TroopName[$i] & ", train first.")
							Assign("Cur" & $TroopName[$i], 0)
							Assign(("tooFew" & $TroopName[$i]), 1)
						Else
							Assign("Cur" & $TroopName[$i], Round(($TotalCamp - $anotherTroops) * Eval($TroopName[$i] & "Comp") / 100))
						EndIf
					EndIf
				EndIf
			Next
		Else
			$CurGobl = ($TotalCamp - $anotherTroops) * Eval("GoblComp") / 100
			$CurGobl = Round($CurGobl)
			$CurBarb = ($TotalCamp - $anotherTroops) * Eval("BarbComp") / 100
			$CurBarb = Round($CurBarb)
			$CurArch = ($TotalCamp - $anotherTroops) * Eval("ArchComp") / 100
			$CurArch = Round($CurArch)
		EndIf

		If $debugsetlogTrain = 1 Then SetLog("Need to train GOBL:" & $CurGobl & " /BARB: " & $CurBarb & " /ARCH: " & $CurArch & " /Total Space: " & $CurBarb + $CurArch + $CurGobl + $anotherTroops & "/" & $TotalCamp, $COLOR_PURPLE)
		If $debugsetlogTrain = 1 Then SetLog("--------- End Calculating Troops / FullArmy true ---------", $COLOR_PURPLE)

		;  The $Cur+TroopName will be the diference bewtween -($Cur+TroopName) returned from ChechArmycamp() and what was selected by user GUI
		;  $Cur+TroopName = Trained - needed  (-20+25 = 5)
		;  $anotherTroops = quantity unit troops x $TroopHeight
		;
	ElseIf ($ArmyComp = 0 And $icmbTroopComp <> 8) Or $FirstStart Then
		$anotherTroops = 0
		For $i = 0 To UBound($TroopName) - 1
			If $TroopName[$i] <> "Barb" And $TroopName[$i] <> "Arch" And $TroopName[$i] <> "Gobl" Then
				Assign(("Cur" & $TroopName[$i]), Eval("Cur" & $TroopName[$i]) + Eval($TroopName[$i] & "Comp"))
				If $debugsetlogTrain = 1 And Number($anotherTroops + Eval($TroopName[$i] & "Comp")) <> 0 Then SetLog("-- AnotherTroops to train:" & $anotherTroops & " + " & Eval($TroopName[$i] & "Comp") & "*" & $TroopHeight[$i], $COLOR_PURPLE)
				$anotherTroops += Eval($TroopName[$i] & "Comp") * $TroopHeight[$i]
				;#################################################################
				If Eval("Cur" & $TroopName[$i]) < 0 Then ; this is necessary to remove from $TotalCamp the existent Troops in the Camp ( not selected on $TroopComp )
					$anotherTroops += (Eval("Cur" & $TroopName[$i]) * -1) * $TroopHeight[$i]
				EndIf
				;################################################################
				If $debugsetlogTrain = 1 And Number(Eval($TroopName[$i] & "Comp")) <> 0 Then SetLog("Need to train " & $TroopName[$i] & ":" & Eval($TroopName[$i] & "Comp"), $COLOR_PURPLE)
			EndIf
		Next
		For $i = 0 To UBound($TroopDarkName) - 1
			Assign(("Cur" & $TroopDarkName[$i]), Eval("Cur" & $TroopDarkName[$i]) + Eval($TroopDarkName[$i] & "Comp"))
			If $debugsetlogTrain = 1 And Number($anotherTroops + Eval($TroopDarkName[$i] & "Comp")) <> 0 Then SetLog("-- AnotherTroops dark to train:" & $anotherTroops & " + " & Eval($TroopDarkName[$i] & "Comp") & "*" & $TroopDarkHeight[$i], $COLOR_PURPLE)
			$anotherTroops += Eval($TroopDarkName[$i] & "Comp") * $TroopDarkHeight[$i]
			;################################################################################
			If Eval("Cur" & $TroopDarkName[$i]) < 0 Then ; this is necessary to remove from $TotalCamp the existent Troops in the Camp ( not selected on $TroopComp )
				$anotherTroops += (Eval("Cur" & $TroopDarkName[$i]) * -1) * $TroopDarkHeight[$i]
			EndIf
			;################################################################################
			If $debugsetlogTrain = 1 And Number(Eval($TroopDarkName[$i] & "Comp")) <> 0 Then SetLog("Need to train " & $TroopDarkName[$i] & ":" & Eval($TroopDarkName[$i] & "Comp"), $COLOR_PURPLE)
		Next
		If $debugsetlogTrain = 1 Then SetLog("--------------AnotherTroops TOTAL to train:" & $anotherTroops, $COLOR_PURPLE)
		$CurGobl += ($TotalCamp - $anotherTroops) * Eval("GoblComp") / 100
		$CurGobl = Round($CurGobl)
		$CurBarb += ($TotalCamp - $anotherTroops) * Eval("BarbComp") / 100
		$CurBarb = Round($CurBarb)
		$CurArch += ($TotalCamp - $anotherTroops) * Eval("ArchComp") / 100
		$CurArch = Round($CurArch)
		If $debugsetlogTrain = 1 Then SetLog("Need to train (height) GOBL:" & $CurGobl & "% BARB: " & $CurBarb & "% ARCH: " & $CurArch & "% AND " & $anotherTroops & " other troops space", $COLOR_PURPLE)
	EndIf

	$TotalTrainedTroops += $anotherTroops + $CurGobl + $CurBarb + $CurArch ; Count of all troops required for training
	If $debugsetlogTrain = 1 Then SetLog("Total Troops to be Trained= " & $TotalTrainedTroops, $COLOR_PURPLE)

	;Local $GiantEBarrack ,$WallEBarrack ,$ArchEBarrack ,$BarbEBarrack ,$GoblinEBarrack,$HogEBarrack,$MinionEBarrack, $WizardEBarrack
	If $debugsetlogTrain = 1 Then SetLog("BARRACKNUM: " & $numBarracksAvaiables, $COLOR_PURPLE)
	If $numBarracksAvaiables <> 0 Then
		For $i = 0 To UBound($TroopName) - 1
			If $debugsetlogTrain = 1 And Number(Floor(Eval("Cur" & $TroopName[$i]) / $numBarracksAvaiables)) <> 0 Then SetLog($TroopName[$i] & "EBarrack" & ": " & Floor(Eval("Cur" & $TroopName[$i]) / $numBarracksAvaiables), $COLOR_PURPLE)
			Assign(($TroopName[$i] & "EBarrack"), Floor(Eval("Cur" & $TroopName[$i]) / $numBarracksAvaiables))
		Next
	Else
		For $i = 0 To UBound($TroopName) - 1
			If $debugsetlogTrain = 1 And Floor(Eval("Cur" & $TroopName[$i]) / 4) <> 0 Then SetLog($TroopName[$i] & "EBarrack" & ": " & Floor(Eval("Cur" & $TroopName[$i]) / 4), $COLOR_PURPLE)
			Assign(($TroopName[$i] & "EBarrack"), Floor(Eval("Cur" & $TroopName[$i]) / 4))
		Next
	EndIf
	If $debugsetlogTrain = 1 Then SetLog("DARKBARRACKNUM: " & $numDarkBarracksAvaiables, $COLOR_PURPLE)
	If $numDarkBarracksAvaiables <> 0 Then
		For $i = 0 To UBound($TroopDarkName) - 1
			If $debugsetlogTrain = 1 And Number(Floor(Eval("Cur" & $TroopDarkName[$i]) / $numBarracksAvaiables)) <> 0 Then SetLog($TroopDarkName[$i] & "EBarrack" & ": " & Floor(Eval("Cur" & $TroopDarkName[$i]) / $numBarracksAvaiables), $COLOR_PURPLE)
			Assign(($TroopDarkName[$i] & "EBarrack"), Floor(Eval("Cur" & $TroopDarkName[$i]) / $numDarkBarracksAvaiables))
		Next
	Else
		For $i = 0 To UBound($TroopDarkName) - 1
			If $debugsetlogTrain = 1 And Number(Floor(Eval("Cur" & $TroopDarkName[$i]) / 2)) <> 0 Then SetLog($TroopDarkName[$i] & "EBarrack" & ": " & Floor(Eval("Cur" & $TroopDarkName[$i]) / 2), $COLOR_PURPLE)
			Assign(($TroopDarkName[$i] & "EBarrack"), Floor(Eval("Cur" & $TroopDarkName[$i]) / 2))
		Next
	EndIf

	;RESET TROOPFIRST AND TROOPSECOND
	For $i = 0 To UBound($TroopName) - 1
		;If $debugsetlogTrain = 1 Then SetLog("troopFirst" & $TroopName[$i] & ": 0", $COLOR_PURPLE)
		Assign(("troopFirst" & $TroopName[$i]), 0)
		;If $debugsetlogTrain = 1 Then SetLog("troopSecond" & $TroopName[$i] & ": 0", $COLOR_PURPLE)
		Assign(("troopSecond" & $TroopName[$i]), 0)
	Next
	For $i = 0 To UBound($TroopDarkName) - 1
		;If $debugsetlogTrain = 1 Then SetLog("troopFirst" & $TroopDarkName[$i] & ": 0", $COLOR_PURPLE)
		Assign(("troopFirst" & $TroopDarkName[$i]), 0)
		;If $debugsetlogTrain = 1 Then SetLog("troopSecond" & $TroopDarkName[$i] & ": 0", $COLOR_PURPLE)
		Assign(("troopSecond" & $TroopDarkName[$i]), 0)
	Next

	If $debugsetlogTrain = 1 Then SetLog("---------END COMPUTE TROOPS TO MAKE--------------------", $COLOR_PURPLE)


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;############################################################# 3rd Stage: Training Troops ############################################################################
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	$brrNum = 0
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Train Barrack Mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	If $icmbTroopComp = 8 Then
		If $debugsetlogTrain = 1 Then
			Setlog("", $COLOR_PURPLE)
			SetLog("---------TRAIN BARRACK MODE------------------------", $COLOR_PURPLE)
		EndIf
		If _Sleep($iDelayTrain2) Then Return
		;USE BARRACK
		While isBarrack()
			$brrNum += 1
			_CaptureRegion()
			If $FirstStart Then
				If _Sleep($iDelayTrain2) Then Return
				$icount = 0
				If _ColorCheck(_GetPixelColor(187, 212, True), Hex(0xD30005, 6), 10) Then ; check if the existe more then 6 slots troops on train bar
					While Not _ColorCheck(_GetPixelColor(573, 212, True), Hex(0xD80001, 6), 10) ; while until appears the Red icon to delete troops
						;_PostMessage_ClickDrag(550, 240, 170, 240, "left", 1000)
						ClickDrag(550, 240, 170, 240, 1000)
						$icount += 1
						If _Sleep($iDelayTrain2) Then Return
						If $icount = 7 Then ExitLoop
					WEnd
				EndIf
				$icount = 0
				While Not _ColorCheck(_GetPixelColor(599, 202 + $midOffsetY, True), Hex(0xD0D0C0, 6), 20) ; while not disappears  green arrow
					If Not (IsTrainPage()) Then Return
					Click(568, 177 + $midOffsetY, 10, $isldTrainITDelay, "#0273") ; Remove Troops in training
					$icount += 1
					If $icount = 100 Then ExitLoop
				WEnd
				If $debugsetlogTrain = 1 And $icount = 100 Then SetLog("Train warning 6", $COLOR_PURPLE)
			EndIf
			If _Sleep($iDelayTrain2) Then Return
			If Not (IsTrainPage()) Then Return ; exit from train if no train page
			Switch $barrackTroop[$brrNum - 1]
				Case 0
					TrainClick(166, 320 + $midOffsetY, 85, $isldTrainITDelay, $FullBarb, $GemBarb, "#0274", $TrainBarbRND) ; Barbarian
				Case 1
					TrainClick(245, 320 + $midOffsetY, 85, $isldTrainITDelay, $FullArch, $GemArch, "#0275", $TrainArchRND) ; Archer
				Case 2
					TrainClick(370, 320 + $midOffsetY, 17, $isldTrainITDelay, $FullGiant, $GemGiant, "#0276", $TrainGiantRND) ; Giant
				Case 3
					TrainClick(482, 320 + $midOffsetY, 85, $isldTrainITDelay, $FullGobl, $GemGobl, "#0277", $TrainGoblRND) ; Goblin
				Case 4
					TrainClick(557, 320 + $midOffsetY, 42, $isldTrainITDelay, $FullWall, $GemWall, "#0278", $TrainWallRND) ; Wall Breaker
				Case 5
					TrainClick(682, 320 + $midOffsetY, 17, $isldTrainITDelay, $FullBall, $GemBall, "#0279", $TrainBallRND) ; Balloon
				Case 6
					TrainClick(173, 425 + $midOffsetY, 21, $isldTrainITDelay, $FullWiza, $GemWiza, "#0280", $TrainWizaRND) ; Wizard
				Case 7
					TrainClick(263, 425 + $midOffsetY, 6, $isldTrainITDelay, $FullHeal, $GemHeal, "#0281", $TrainHealRND) ; Healer
				Case 8
					TrainClick(383, 425 + $midOffsetY, 4, $isldTrainITDelay, $FullDrag, $GemDrag, "#0282", $TrainDragRND) ; Dragon
				Case 9
					TrainClick(474, 425 + $midOffsetY, 3, $isldTrainITDelay, $FullPekk, $GemPekk, "#0283", $TrainPekkRND) ; Pekka
				Case 10
					TrainClick(572, 425 + $midOffsetY, 8, $isldTrainITDelay, $FullBabyD, $GemBabyD, "#0342", $TrainBabyDRND) ; Baby Dragon
				Case 11
					TrainClick(675, 425 + $midOffsetY, 17, $isldTrainITDelay, $FullMine, $GemMine, "#0343", $TrainMineRND) ; Miner
			EndSwitch
			If $OutOfElixir = 1 Then
				Setlog("Not enough Elixir to train troops!", $COLOR_RED)
				Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_RED)
				$ichkBotStop = 1 ; set halt attack variable
				$icmbBotCond = 18 ; set stay online
				If CheckFullBarrack() Then $Restart = True ;If the army camp is full, use it to refill storages
				Return ; We are out of Elixir stop training.
			EndIf
			If _Sleep($iDelayTrain2) Then Return
			If Not (IsTrainPage()) Then Return
			If $brrNum >= $numBarracksAvaiables Then ExitLoop ; make sure no more infiniti loop
			_TrainMoveBtn(+1) ;click Next button
			If _Sleep($iDelayTrain3) Then Return

		WEnd
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Train Barrack Mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	Else
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Train Custom Army Mode For Elixir Troops ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		If $debugsetlogTrain = 1 Then SetLog("---------TRAIN NEW BARRACK MODE------------------------", $COLOR_PURPLE)

		If $FirstStart = True Then SetLog("Remove previous queued troops and start training")
		If $fullarmy = True Then SetLog("Build troops before attacking.")

		While isBarrack() And $isNormalBuild
			$brrNum += 1
			If $debugsetlogTrain = 1 Then SetLog("====== Checking available Barrack: " & $brrNum & " ======", $COLOR_PURPLE)
			If ($fullarmy = True) Or $FirstStart Then
				;CLICK REMOVE TROOPS
				If _Sleep($iDelayTrain2) Then Return
				$icount = 0
				If _ColorCheck(_GetPixelColor(187, 212, True), Hex(0xD30005, 6), 10) Then ; check if the existe more then 6 slots troops on train bar
					While Not _ColorCheck(_GetPixelColor(573, 212, True), Hex(0xD80001, 6), 10) ; while until appears the Red icon to delete troops
						;_PostMessage_ClickDrag(550, 240, 170, 240, "left", 1000)
						ClickDrag(550, 240, 170, 240, 1000)
						$icount += 1
						If _Sleep($iDelayTrain2) Then Return
						If $icount = 7 Then ExitLoop
					WEnd
				EndIf
				$icount = 0
				While Not _ColorCheck(_GetPixelColor(593, 200 + $midOffsetY, True), Hex(0xD0D0C0, 6), 20) ; while not disappears  green arrow
					If Not (IsTrainPage()) Then Return ;exit if no train page
					Click(568, 177 + $midOffsetY, 10, $isldTrainITDelay, "#0284") ; Remove Troops in training
					$icount += 1
					If $RunState = False Then Return
					If $icount = 100 Then ExitLoop
				WEnd
				If $debugsetlogTrain = 1 And $icount = 100 Then SetLog("Train warning 7", $COLOR_PURPLE)
			EndIf

			If _Sleep($iDelayTrain1) Then Return
			For $i = 0 To UBound($TroopName) - 1
				If Eval($TroopName[$i] & "Comp") <> "0" Then
					$heightTroop = 294 + $midOffsetY
					$positionTroop = $TroopNamePosition[$i]
					If $TroopNamePosition[$i] > 5 Then
						$heightTroop = 396 + $midOffsetY
						$positionTroop = $TroopNamePosition[$i] - 6
					EndIf
					$tmpNumber = Number(getBarracksTroopQuantity(126 + 102 * $positionTroop, $heightTroop))
					If $debugsetlogTrain = 1 And $tmpNumber <> 0 Then SetLog("ASSIGN TroopFirst." & $TroopName[$i] & ": " & $tmpNumber, $COLOR_PURPLE)
					Assign(("troopFirst" & $TroopName[$i]), $tmpNumber)
					If Eval("troopFirst" & $TroopName[$i]) = 0 Then
						If _Sleep($iDelayTrain1) Then Return
						If $debugsetlogTrain = 1 And $tmpNumber <> 0 Then SetLog("ASSIGN TroopFirst." & $TroopName[$i] & ": " & $tmpNumber, $COLOR_PURPLE)
						Assign(("troopFirst" & $TroopName[$i]), $tmpNumber)
					EndIf
				EndIf
				If $RunState = False Then Return
			Next

			;Too few troops, train first
			For $i = 0 To UBound($TroopName) - 1
				If Eval("tooFew" & $TroopName[$i]) = 1 Then
					If Not (IsTrainPage()) Then Return ;exit from train

					If $TroopName[$i] <> "Barb" And $TroopName[$i] <> "Arch" And $TroopName[$i] <> "Gobl" Then
						If Number(Eval($TroopName[$i] & "Comp")) >= 4 Then
							TrainIt(Eval("e" & $TroopName[$i]), Round(Eval($TroopName[$i] & "Comp") / $numBarracksAvaiables))
							$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
						ElseIf $brrNum <= Number(Eval($TroopName[$i] & "Comp")) Then
							TrainIt(Eval("e" & $TroopName[$i]), Ceiling(Eval($TroopName[$i] & "Comp") / $numBarracksAvaiables))
							$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
						EndIf
					Else
						TrainIt(Eval("e" & $TroopName[$i]), Round(($TotalCamp - $anotherTroops) * Eval($TroopName[$i] & "Comp") / 100 / $numBarracksAvaiables))
						$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
					EndIf
				EndIf
				If $RunState = False Then Return
			Next
			;Balanced troops train in normal order
			For $i = 0 To UBound($TroopName) - 1
				If Eval($TroopName[$i] & "Comp") <> 0 And Eval("Cur" & $TroopName[$i]) > 0 Then
					If Not (IsTrainPage()) Then Return ;exit from train

					If Eval($TroopName[$i] & "EBarrack") = 0 Then
						If $debugsetlogTrain = 1 Then SetLog("Call Func TrainIt for " & $TroopName[$i], $COLOR_PURPLE)
						TrainIt(Eval("e" & $TroopName[$i]), 1)
						$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
					ElseIf Eval($TroopName[$i] & "EBarrack") >= Eval("Cur" & $TroopName[$i]) Then
						If $debugsetlogTrain = 1 Then SetLog("Call Func TrainIt for " & $TroopName[$i], $COLOR_PURPLE)
						TrainIt(Eval("e" & $TroopName[$i]), Eval("Cur" & $TroopName[$i]))
						$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
					Else
						If $debugsetlogTrain = 1 Then SetLog("Call Func TrainIt for " & $TroopName[$i], $COLOR_PURPLE)
						TrainIt(Eval("e" & $TroopName[$i]), Eval($TroopName[$i] & "EBarrack"))
						$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
					EndIf
				EndIf
				If $RunState = False Then Return
			Next
			;Too Many troops, train Last
			For $i = 0 To UBound($TroopName) - 1 ; put troops at end of queue if there are too many
				If Eval("tooMany" & $TroopName[$i]) = 1 Then
					If Not (IsTrainPage()) Then Return ;exit from train

					If $TroopName[$i] <> "Barb" And $TroopName[$i] <> "Arch" And $TroopName[$i] <> "Gobl" Then
						If Number(Eval($TroopName[$i] & "Comp")) >= 4 Then
							TrainIt(Eval("e" & $TroopName[$i]), Round(Eval($TroopName[$i] & "Comp") / $numBarracksAvaiables))
							$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
						ElseIf $brrNum <= Number(Eval($TroopName[$i] & "Comp")) Then
							TrainIt(Eval("e" & $TroopName[$i]), Round(Eval($TroopName[$i] & "Comp") / $numBarracksAvaiables))
							$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
						EndIf
					Else
						TrainIt(Eval("e" & $TroopName[$i]), Round(($TotalCamp - $anotherTroops) * Eval($TroopName[$i] & "Comp") / 100 / $numBarracksAvaiables))
						$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
					EndIf
				EndIf
				If $RunState = False Then Return
			Next

			If _Sleep($iDelayTrain1) Then Return
			For $i = 0 To UBound($TroopName) - 1
				If Eval($TroopName[$i] & "Comp") <> "0" Then
					$heightTroop = 294 + $midOffsetY
					$positionTroop = $TroopNamePosition[$i]
					If $TroopNamePosition[$i] > 5 Then
						$heightTroop = 396 + $midOffsetY
						$positionTroop = $TroopNamePosition[$i] - 6
					EndIf
					$tmpNumber = Number(getBarracksTroopQuantity(126 + 102 * $positionTroop, $heightTroop))
					If $debugsetlogTrain = 1 And $tmpNumber <> 0 Then SetLog(("troopSecond" & $TroopName[$i] & ": " & $tmpNumber), $COLOR_PURPLE)
					Assign(("troopSecond" & $TroopName[$i]), $tmpNumber)
					If Eval("troopSecond" & $TroopName[$i]) = 0 Then
						If _Sleep($iDelayTrain1) Then Return
						If $debugsetlogTrain = 1 And $tmpNumber <> 0 Then SetLog("ASSIGN troopSecond" & $TroopName[$i] & ": " & $tmpNumber, $COLOR_PURPLE)
						Assign(("troopSecond" & $TroopName[$i]), $tmpNumber)
					EndIf
				EndIf
				If $RunState = False Then Return
			Next

			$troopNameCooking = ""
			For $i = 0 To UBound($TroopName) - 1
				If Eval("troopSecond" & $TroopName[$i]) > Eval("troopFirst" & $TroopName[$i]) And Eval($TroopName[$i] & "Comp") <> "0" Then
					$ArmyComp += (Eval("troopSecond" & $TroopName[$i]) - Eval("troopFirst" & $TroopName[$i])) * $TroopHeight[$i]
					If $debugsetlogTrain = 1 Then SetLog(("###Cur" & $TroopName[$i]) & " = " & Eval("Cur" & $TroopName[$i]) & " - (" & Eval("troopSecond" & $TroopName[$i]) & " - " & Eval("troopFirst" & $TroopName[$i]) & ")", $COLOR_PURPLE)
					Assign(("Cur" & $TroopName[$i]), Eval("Cur" & $TroopName[$i]) - (Eval("troopSecond" & $TroopName[$i]) - Eval("troopFirst" & $TroopName[$i])))
				EndIf
				If Eval("troopSecond" & $TroopName[$i]) > 0 Then
					$troopNameCooking = $troopNameCooking & $i & ";"
				EndIf
				If $RunState = False Then Return
			Next


			;;;;;;; Train archers to reach full army if trained troops not enough to reach full army or remaining capacity is lower than housing space of trained troop ;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			If $icmbTroopComp <> 8 And $fullarmy = False And $FirstStart = False Then

				;####################### Train the Donated Troops #########################
				If $LastBarrackTrainDonatedTroop = $brrNum Then
					For $i = 0 To UBound($TroopName) - 1
						If Eval("Don" & $TroopName[$i]) > 0 Then
							; train one $TroopName each barrack/each loop until the quantity is zero. Train it in Barrack 1|2|3|4|1|2 next 3|4|1|2|3|4
							TrainIt(Eval("e" & $TroopName[$i]), 1)
							Assign("Don" & $TroopName[$i], Eval("Don" & $TroopName[$i]) - 1)
							If $debugsetlogTrain = 1 Then Setlog("Train 1 " & NameOfTroop(Eval("e" & $TroopName[$i])) & " remain " & Eval("Don" & $TroopName[$i]) & " to train.")
							$LastBarrackTrainDonatedTroop = $brrNum + 1
							If $LastBarrackTrainDonatedTroop > $numBarracksAvaiables Then
								$LastBarrackTrainDonatedTroop = 1
							EndIf
						EndIf
						If $RunState = False Then Return
					Next
					If $debugsetlogTrain = 1 Then Setlog("$LastBarrackTrainDonatedTroop: " & $LastBarrackTrainDonatedTroop)
					If $debugsetlogTrain = 1 Then Setlog("Barrack: " & $brrNum)
				EndIf
				;###########################################################################

				; Checks if there is Troops being trained in this barrack
				If _ColorCheck(_GetPixelColor(599, 202 + $midOffsetY, True), Hex(0xa8d070, 6), 20) = False Then ;if no green arrow
					$BarrackStatus[$brrNum - 1] = False ; No troop is being trained in this barrack
				Else
					$BarrackStatus[$brrNum - 1] = True ; Troops are being trained in this barrack
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Available BARRACK " & $brrNum & " STATUS: " & $BarrackStatus[$brrNum - 1], $COLOR_PURPLE)

				; Checks if the barrack is full ( stopped )
				If CheckFullBarrack() Then
					$BarrackFull[$brrNum - 1] = True ; Barrack is full
				Else
					$BarrackFull[$brrNum - 1] = False ; Barrack isn't full
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Available BARRACK " & $brrNum & " Full: " & $BarrackFull[$brrNum - 1], $COLOR_PURPLE)

				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

				; If The remaining capacity is lower than the Housing Space of training troop and its not full army or first start then delete the training troop and train 20 archer
				; If no troops are being trained in all barracks and its not full army or first start then train 20 archer to reach full army
				If ($BarrackFull[0] = True Or $BarrackStatus[0] = False) And ($BarrackFull[1] = True Or $BarrackStatus[1] = False) And ($BarrackFull[2] = True Or $BarrackStatus[2] = False) And ($BarrackFull[3] = True Or $BarrackStatus[3] = False) Then
					If (Not $isDarkBuild) Or (($BarrackDarkFull[0] = True Or $BarrackDarkStatus[0] = False) And ($BarrackDarkFull[1] = True Or $BarrackDarkStatus[1] = False)) Then
						If _Sleep($iDelayTrain1) Then Return
						ClickP($aAway, 2, $iDelayTrain5, "#0501"); Click away twice with 250ms delay
						If WaitforPixel(28, 505 + $bottomOffsetY, 30, 507 + $bottomOffsetY, Hex(0xE4A438, 6), 5, 10) Then
							If $debugsetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
							If $iUseRandomClick = 0 Then
								Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#9998") ; Button Army Overview
							Else
								ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
							EndIf
						EndIf

						$icount = 0
						While IsTrainPage() = False
							If _Sleep($iDelayTrain1) Then Return
							$icount += 1
							If $icount = 20 Then ExitLoop
						WEnd
						If Not (IsTrainPage()) Then Return

						_CaptureRegion()
						_TrainMoveBtn(+1)
						If _Sleep($iDelayTrain2) Then Return
						$brrNum = 0
						While isBarrack()
							$brrNum += 1
							If _Sleep($iDelayTrain1) Then Return
							$icount = 0
							If _ColorCheck(_GetPixelColor(187, 212, True), Hex(0xD30005, 6), 10) Then ; check if the existe more then 6 slots troops on train bar
								While Not _ColorCheck(_GetPixelColor(573, 212, True), Hex(0xD80001, 6), 10) ; while until appears the Red icon to delete troops
									;_PostMessage_ClickDrag(550, 240, 170, 240, "left", 1000)
									ClickDrag(550, 240, 170, 240, 1000)
									$icount += 1
									If _Sleep($iDelayTrain1) Then Return
									If $icount = 7 Then ExitLoop
								WEnd
							EndIf
							$icount = 0
							While _ColorCheck(_GetPixelColor(599, 202 + $midOffsetY, True), Hex(0xa8d070, 6), 20) ; while green arrow is there, delete
								Click(568, 177 + $midOffsetY, 5, 0, "#0502") ; Remove Troops in training
								$icount += 1
								If $icount = 100 Then ExitLoop
								If $RunState = False Then Return
							WEnd

							If _Sleep($iDelayTrain1) Then Return
							If $debugsetlogTrain = 1 Then SetLog("Call Func TrainIt Arch", $COLOR_PURPLE)
							If Not (IsTrainPage()) Then Return ;exit from train
							TrainIt($eArch, 20)
							$BarrackFull[$brrNum - 1] = False
							$BarrackStatus[$brrNum - 1] = True
							If $brrNum >= $numBarracksAvaiables Then ExitLoop ; make sure no more infiniti loop
							_TrainMoveBtn(+1) ;click Next button
							If _Sleep($iDelayTrain3) Then Return
						WEnd
						If _Sleep($iDelayTrain4) Then Return
						ClickP($aAway, 2, $iDelayTrain5, "#0291"); Click away twice with 250ms delay
						If _Sleep($iDelayTrain4) Then Return
						Return
					EndIf
				EndIf

			EndIf
			;;;;;; End Training archers to Reach Full army ;;;;;;;;

			If Not (IsTrainPage()) Then Return
			If $brrNum >= $numBarracksAvaiables Then ExitLoop ; make sure no more infiniti loop
			_TrainMoveBtn(+1) ;click Next button
			If _Sleep($iDelayTrain2) Then Return
		WEnd
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Train Custom Army Mode For Elixir troops ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;; Training Dark Elixir Troops here ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	If $isDarkBuild Or $icmbDarkTroopComp = 0 Then
		$iBarrHere = 0
		$brrDarkNum = 0
		If $icmbDarkTroopComp = 0 Then
			If $debugsetlogTrain = 1 Then
				Setlog("", $COLOR_PURPLE)
				SetLog("---------TRAIN DARK BARRACK MODE------------------------", $COLOR_PURPLE)
			EndIf
			If _Sleep($iDelayTrain2) Then Return
			;USE BARRACK
			While isDarkBarrack() = False
				If Not (IsTrainPage()) Then Return
				_TrainMoveBtn(+1) ;click Next button
				$iBarrHere += 1
				If _Sleep($iDelayTrain3) Then Return
				If (isDarkBarrack() Or $iBarrHere = 8) Then ExitLoop
			WEnd
			While isDarkBarrack()
				$brrDarkNum += 1
				_CaptureRegion()
				If $FirstStart Then
					If _Sleep($iDelayTrain2) Then Return
					$icount = 0
					If _ColorCheck(_GetPixelColor(187, 212, True), Hex(0xD30005, 6), 10) Then ; check if the existe more then 6 slots troops on train bar
						While Not _ColorCheck(_GetPixelColor(573, 212, True), Hex(0xD80001, 6), 10) ; while until appears the Red icon to delete troops
							;_PostMessage_ClickDrag(550, 240, 170, 240, "left", 1000)
							ClickDrag(550, 240, 170, 240, 1000)
							$icount += 1
							If _Sleep($iDelayTrain2) Then Return
							If $icount = 7 Then ExitLoop
						WEnd
					EndIf

					$icount = 0
					While Not _ColorCheck(_GetPixelColor(599, 202 + $midOffsetY, True), Hex(0xD0D0C0, 6), 20) ; while not disappears  green arrow
						If Not (IsTrainPage()) Then Return
						Click(568, 177 + $midOffsetY, 10, 0, "#0273") ; Remove Troops in training
						$icount += 1
						If $icount = 100 Then ExitLoop
						If $RunState = False Then Return
					WEnd
					If $debugsetlogTrain = 1 And $icount = 100 Then SetLog("Train warning 6", $COLOR_PURPLE)
				EndIf
				If _Sleep($iDelayTrain2) Then ExitLoop
				If Not (IsTrainPage()) Then Return ; exit from train if no train page
				Switch $darkbarrackTroop[$brrDarkNum - 1]
					Case 0
						TrainClick(220, 320 + $midOffsetY, 50, 10, $FullMini, $GemMini, "#0274", $TrainMiniRND) ; Minion
					Case 1
						TrainClick(331, 320 + $midOffsetY, 20, 10, $FullHogs, $GemHogs, "#0275", $TrainHogsRND) ; Hog Rider
					Case 2
						TrainClick(432, 320 + $midOffsetY, 12, 10, $FullValk, $GemValk, "#0276", $TrainValkRND) ; Valkyrie
					Case 3
						TrainClick(546, 320 + $midOffsetY, 3, 10, $FullGole, $GemGole, "#0277", $TrainGoleRND) ; Golem
					Case 4
						TrainClick(647, 320 + $midOffsetY, 8, 10, $FullWitc, $GemWitc, "#0278", $TrainWitcRND) ; Witch
					Case 5
						TrainClick(220, 425 + $midOffsetY, 3, 10, $FullBall, $GemBall, "#0279", $TrainLavaRND) ; Lava Hound
					Case 6
						TrainClick(331, 425 + $midOffsetY, 16, 10, $FullBowl, $GemBowl, "#0341", $TrainBowlRND) ; Bowler
				EndSwitch
				If $OutOfElixir = 1 Then
					Setlog("Not enough Dark Elixir to train troops!", $COLOR_RED)
					Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_RED)
					$ichkBotStop = 1 ; set halt attack variable
					$icmbBotCond = 18 ; set stay online
					If CheckFullBarrack() Then $Restart = True ;If the army camp is full, use it to refill storages
					Return ; We are out of Elixir stop training.
				EndIf
				If _Sleep($iDelayTrain2) Then ExitLoop
				If Not (IsTrainPage()) Then Return
				If $brrDarkNum >= $numDarkBarracksAvaiables Then ExitLoop
				_TrainMoveBtn(+1) ;click Next button
				If _Sleep($iDelayTrain3) Then Return
			WEnd
		Else

			While isDarkBarrack() = False
				If Not (IsTrainPage()) Then Return
				_TrainMoveBtn(+1) ;click Next button
				$iBarrHere += 1
				If _Sleep($iDelayTrain3) Then Return
				If (isDarkBarrack() Or $iBarrHere = 8) Then ExitLoop
			WEnd
			While isDarkBarrack()
				$brrDarkNum += 1
				If $debugsetlogTrain = 1 Then SetLog("====== Checking available Dark Barrack: " & $brrDarkNum & " ======", $COLOR_PURPLE)
				If ($fullarmy = True) Or $FirstStart Then ; Delete Troops That is being trained
					$icount = 0
					If _ColorCheck(_GetPixelColor(187, 212, True), Hex(0xD30005, 6), 10) Then ; check if the existe more then 6 slots troops on train bar
						While Not _ColorCheck(_GetPixelColor(573, 212, True), Hex(0xD80001, 6), 10) ; while until appears the Red icon to delete troops
							;_PostMessage_ClickDrag(550, 240, 170, 240, "left", 1000)
							ClickDrag(550, 240, 170, 240, 1000)
							$icount += 1
							If _Sleep($iDelayTrain1) Then Return
							If $icount = 7 Then ExitLoop
						WEnd
					EndIf
					$icount = 0
					While Not _ColorCheck(_GetPixelColor(599, 202 + $midOffsetY, True), Hex(0xD0D0C0, 6), 20) ; while not disappears  green arrow
						If Not (IsTrainPage()) Then Return ;exit if no train page
						Click(568, 177 + $midOffsetY, 10, 0, "#0287") ; Remove Troops in training
						$icount += 1
						If $icount = 100 Then ExitLoop
						If $RunState = False Then Return
					WEnd
					If $debugsetlogTrain = 1 And $icount = 100 Then SetLog("Train warning 9", $COLOR_PURPLE)
				EndIf
				If _Sleep($iDelayTrain1) Then Return
				For $i = 0 To UBound($TroopDarkName) - 1
					If Eval($TroopDarkName[$i] & "Comp") <> "0" Then
						$heightTroop = 294 + $midOffsetY
						$positionTroop = $TroopDarkNamePosition[$i]
						If $TroopDarkNamePosition[$i] > 4 Then
							$heightTroop = 402 + $midOffsetY
							$positionTroop = $TroopDarkNamePosition[$i] - 5
						EndIf

						;read troops in windows troopsfirst
						$tmpNumber = Number(getBarracksTroopQuantity(174 + 107 * $positionTroop, $heightTroop)) ; read troop quantity
						If _Sleep($iDelayTrain1) Then Return
						If $debugsetlogTrain = 1 And $tmpNumber <> 0 Then SetLog("ASSIGN TroopFirst.." & $TroopDarkName[$i] & ": " & $tmpNumber, $COLOR_PURPLE)
						Assign(("troopFirst" & $TroopDarkName[$i]), $tmpNumber)
						If Eval("troopFirst" & $TroopDarkName[$i]) = 0 Then
							If _Sleep($iDelayTrain1) Then Return
							If $debugsetlogTrain = 1 And $tmpNumber <> 0 Then SetLog("ASSIGN TroopFirst..." & $TroopDarkName[$i] & ": " & $tmpNumber, $COLOR_PURPLE)
							Assign(("troopFirst" & $TroopDarkName[$i]), $tmpNumber)
						EndIf
					EndIf
					If $RunState = False Then Return
				Next
				;Too few troops, train first
				For $i = 0 To UBound($TroopDarkName) - 1
					If Eval("tooFew" & $TroopDarkName[$i]) = 1 Then
						If Number(Eval($TroopDarkName[$i] & "Comp")) > 2 Then
							TrainIt(Eval("e" & $TroopDarkName[$i]), Round(Eval($TroopDarkName[$i] & "Comp") / $numDarkBarracksAvaiables))
							$BarrackDarkStatus[$brrDarkNum - 1] = True ; Troops are being trained in this Dark barrack
						ElseIf $brrDarkNum <= Number(Eval($TroopDarkName[$i] & "Comp")) Then
							TrainIt(Eval("e" & $TroopDarkName[$i]), Ceiling(Eval($TroopDarkName[$i] & "Comp") / $numDarkBarracksAvaiables))
							$BarrackDarkStatus[$brrDarkNum - 1] = True ; Troops are being trained in this Dark barrack
						EndIf
					EndIf
					If $RunState = False Then Return
				Next
				;Balanced troops, train in normal order
				For $i = 0 To UBound($TroopDarkName) - 1
					If $debugsetlogTrain = 1 Then
						SetLog("** " & $TroopDarkName[$i] & " : " & "txtNum" & $TroopDarkName[$i] & " = " & Eval($TroopDarkName[$i] & "Comp") & "  Cur" & $TroopDarkName[$i] & " = " & Eval("Cur" & $TroopDarkName[$i]), $COLOR_PURPLE)
						SetLog("*** " & "txtNum" & $TroopDarkName[$i] & "=" & Eval($TroopDarkName[$i] & "Comp"), $COLOR_PURPLE)
						SetLog("*** " & "Cur" & $TroopDarkName[$i] & "=" & Eval("Cur" & $TroopDarkName[$i]), $COLOR_PURPLE)
						SetLog("*** " & $TroopDarkName[$i] & "EBarrack" & "=" & Eval("Cur" & $TroopDarkName[$i]), $COLOR_PURPLE)
					EndIf
					If Eval($TroopDarkName[$i] & "Comp") <> "0" And Eval("Cur" & $TroopDarkName[$i]) > 0 Then
						If Not (IsTrainPage()) Then Return ;exit from train
						If Eval($TroopDarkName[$i] & "EBarrack") = 0 Then
							If $debugsetlogTrain = 1 Then SetLog("Call Func TrainIt for " & $TroopDarkName[$i], $COLOR_PURPLE)
							TrainIt(Eval("e" & $TroopDarkName[$i]), 1)
							$BarrackDarkStatus[$brrDarkNum - 1] = True ; Troops are being trained in this Dark barrack
						ElseIf Eval($TroopDarkName[$i] & "EBarrack") >= Eval("Cur" & $TroopDarkName[$i]) Then
							If $debugsetlogTrain = 1 Then SetLog("Call Func TrainIt for " & $TroopDarkName[$i], $COLOR_PURPLE)
							TrainIt(Eval("e" & $TroopDarkName[$i]), Eval("Cur" & $TroopDarkName[$i]))
							$BarrackDarkStatus[$brrDarkNum - 1] = True ; Troops are being trained in this Dark barrack
						Else
							If $debugsetlogTrain = 1 Then SetLog("Call Func TrainIt for " & $TroopDarkName[$i], $COLOR_PURPLE)
							TrainIt(Eval("e" & $TroopDarkName[$i]), Eval($TroopDarkName[$i] & "EBarrack"))
							$BarrackDarkStatus[$brrDarkNum - 1] = True ; Troops are being trained in this Dark barrack
						EndIf
					EndIf
					If $RunState = False Then Return
				Next
				;Too Many troops, train Last
				For $i = 0 To UBound($TroopDarkName) - 1 ; put troops at end of queue if there are too many
					If Eval("tooMany" & $TroopDarkName[$i]) = 1 Then
						If Number(Eval($TroopDarkName[$i] & "Comp")) > 2 Then
							TrainIt(Eval("e" & $TroopDarkName[$i]), Round(Eval($TroopDarkName[$i] & "Comp") / $numDarkBarracksAvaiables))
							$BarrackDarkStatus[$brrDarkNum - 1] = True ; Troops are being trained in this Dark barrack
						ElseIf $brrDarkNum <= Number(Eval($TroopDarkName[$i] & "Comp")) Then
							TrainIt(Eval("e" & $TroopDarkName[$i]), Ceiling(Eval($TroopDarkName[$i] & "Comp") / $numDarkBarracksAvaiables))
							$BarrackDarkStatus[$brrDarkNum - 1] = True ; Troops are being trained in this Dark barrack
						EndIf
					EndIf
					If $RunState = False Then Return
				Next
				If _Sleep($iDelayTrain1) Then Return
				For $i = 0 To UBound($TroopDarkName) - 1
					If Eval($TroopDarkName[$i] & "Comp") <> "0" Then
						$heightTroop = 294 + $midOffsetY
						$positionTroop = $TroopDarkNamePosition[$i]
						If $TroopDarkNamePosition[$i] > 4 Then
							$heightTroop = 402 + $midOffsetY
							$positionTroop = $TroopDarkNamePosition[$i] - 5
						EndIf
						$tmpNumber = Number(getBarracksTroopQuantity(174 + 107 * $positionTroop, $heightTroop))
						If _Sleep($iDelayTrain1) Then Return
						If $debugsetlogTrain = 1 Then SetLog(">>>troopSecond" & $TroopDarkName[$i] & " = " & $tmpNumber, $COLOR_PURPLE)
						Assign(("troopSecond" & $TroopDarkName[$i]), $tmpNumber)
						If Eval("troopSecond" & $TroopDarkName[$i]) = 0 Then
							If _Sleep($iDelayTrain1) Then Return
							If $debugsetlogTrain = 1 Then SetLog(">>>troopSecond" & $TroopDarkName[$i] & " = " & $tmpNumber, $COLOR_PURPLE)
							Assign(("troopSecond" & $TroopDarkName[$i]), $tmpNumber)
						EndIf
					EndIf
					If $RunState = False Then Return
				Next
				For $i = 0 To UBound($TroopDarkName) - 1
					If Eval("troopSecond" & $TroopDarkName[$i]) > Eval("troopFirst" & $TroopDarkName[$i]) And Eval($TroopDarkName[$i] & "Comp") <> "0" Then
						$ArmyComp += (Eval("troopSecond" & $TroopDarkName[$i]) - Eval("troopFirst" & $TroopDarkName[$i])) * $TroopDarkHeight[$i]
						If $debugsetlogTrain = 1 Then SetLog("#Cur" & $TroopDarkName[$i] & " = " & Eval("Cur" & $TroopDarkName[$i]) & " - (" & Eval("troopSecond" & $TroopDarkName[$i]) & " - " & Eval("troopFirst" & $TroopDarkName[$i]) & ")", $COLOR_PURPLE)
						Assign(("Cur" & $TroopDarkName[$i]), Eval("Cur" & $TroopDarkName[$i]) - (Eval("troopSecond" & $TroopDarkName[$i]) - Eval("troopFirst" & $TroopDarkName[$i])))
						If $debugsetlogTrain = 1 Then
							SetLog("**** " & "txtNum" & $TroopDarkName[$i] & "=" & Eval($TroopDarkName[$i] & "Comp"), $COLOR_PURPLE)
							SetLog("**** " & "Cur" & $TroopDarkName[$i] & "=" & Eval("Cur" & $TroopDarkName[$i]), $COLOR_PURPLE)
							SetLog("**** " & $TroopDarkName[$i] & "EBarrack" & "=" & Eval("Cur" & $TroopDarkName[$i]), $COLOR_PURPLE)
						EndIf
					EndIf
				Next

				;;;;;;; Train Minions to reach full army if trained troops not enough to reach full army or remaining capacity is lower than housing space of trained troop ;;;;;;;
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				If $icmbTroopComp <> 8 And $fullarmy = False And $FirstStart = False Then

					;####################### Train the Donated Troops #########################
					If $LastDarkBarrackTrainDonatedTroop = $brrDarkNum Then
						For $i = 0 To UBound($TroopDarkName) - 1
							If Eval("Don" & $TroopDarkName[$i]) > 0 Then
								; train one $TroopDarkName each barrack/each loop until the quantity is zero. Train it in Barrack 1|2| next 1|2|
								TrainIt(Eval("e" & $TroopDarkName[$i]), 1)
								Assign("Don" & $TroopDarkName[$i], Eval("Don" & $TroopDarkName[$i]) - 1)
								If $debugsetlogTrain = 1 Then Setlog("Train 1 " & NameOfTroop(Eval("e" & $TroopDarkName[$i])) & " remain " & Eval("Don" & $TroopDarkName[$i]) & " to train.")
								$LastDarkBarrackTrainDonatedTroop = $brrDarkNum + 1
								If $LastDarkBarrackTrainDonatedTroop > $numDarkBarracksAvaiables Then
									$LastDarkBarrackTrainDonatedTroop = 1
								EndIf
							EndIf
						Next
						If $debugsetlogTrain = 1 Then Setlog("Dark Barrack: " & $brrDarkNum)
						If $debugsetlogTrain = 1 Then Setlog("$LastDarkBarrackTrainDonatedTroop: " & $LastDarkBarrackTrainDonatedTroop)
						If $RunState = False Then Return
					EndIf
					;#########################################################################

					; Checks if there is Troops being trained in this Dark barrack
					If _ColorCheck(_GetPixelColor(599, 202 + $midOffsetY, True), Hex(0xa8d070, 6), 20) = False Then ;if no green arrow
						$BarrackDarkStatus[$brrDarkNum - 1] = False ; No troop is being trained in this Dark barrack
					Else
						$BarrackDarkStatus[$brrDarkNum - 1] = True ; Troops are being trained in this Dark barrack
					EndIf
					If $debugsetlogTrain = 1 Then SetLog("Available Dark BARRACK " & $brrDarkNum & " STATUS: " & $BarrackDarkStatus[$brrDarkNum - 1], $COLOR_PURPLE)

					; Checks if the Dark barrack is full (stopped)
					If CheckFullBarrack() Then
						$BarrackDarkFull[$brrDarkNum - 1] = True ; Dark barrack is full
					Else
						$BarrackDarkFull[$brrDarkNum - 1] = False ; Dark barrack isn't full
					EndIf
					If $debugsetlogTrain = 1 Then SetLog("Available Dark BARRACK " & $brrDarkNum & " Full: " & $BarrackDarkFull[$brrDarkNum - 1], $COLOR_PURPLE)

					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

					;;;;;;;;;;;;; If The remaining capacity is lower then the Housing Space of training troop , delete the remaining training troop and train 10 Minions;;;;;;;;;;;
					;;;;;;;;;;;;; If no troops are being trained in all Dark barracks and its not full army or first start then train 10 Minions to reach full army;;;;;;;;;;;;;;;;
					If (Not $isNormalBuild) And (($BarrackDarkFull[0] = True Or $BarrackDarkStatus[0] = False) And ($BarrackDarkFull[1] = True Or $BarrackDarkStatus[1] = False)) Then
						Local $i = 0
						While isDarkBarrack()
							$i += 1
							If _Sleep($iDelayTrain1) Then Return
							$icount = 0
							If _ColorCheck(_GetPixelColor(187, 212, True), Hex(0xD30005, 6), 10) Then ; check if the existe more then 6 slots troops on train bar
								While Not _ColorCheck(_GetPixelColor(573, 212, True), Hex(0xD80001, 6), 10) ; while until appears the Red icon to delete troops
									;_PostMessage_ClickDrag(550, 240, 170, 240, "left", 1000)
									ClickDrag(550, 240, 170, 240, 1000)
									$icount += 1
									If _Sleep($iDelayTrain1) Then Return
									If $icount = 7 Then ExitLoop
								WEnd
							EndIf
							$icount = 0
							While _ColorCheck(_GetPixelColor(599, 202 + $midOffsetY, True), Hex(0xa8d070, 6), 20) ; While Green Arrow is there, delete
								Click(568, 177 + $midOffsetY, 5, 0, "#0288") ; Remove Troops in training
								$icount += 1
								If $icount = 100 Then ExitLoop
							WEnd
							If _Sleep($iDelayTrain1) Then Return
							If $debugsetlogTrain = 1 Then SetLog("Call Func TrainIt for Mini", $COLOR_PURPLE)
							If Not (IsTrainPage()) Then Return ;exit from train
							TrainIt($eMini, 10)
							$BarrackDarkFull[$brrDarkNum - 1] = False
							$BarrackDarkStatus[$brrDarkNum - 1] = True
							If $i >= 2 Then ExitLoop ; Make sure no more infiniti loop
							If $brrDarkNum = 1 Then
								_TrainMoveBtn(+1) ;click Next button
								$brrDarkNum = 2
							EndIf
							If $brrDarkNum = 2 Then
								_TrainMoveBtn(-1) ;Click prev button
								$brrDarkNum = 1
							EndIf
							If _Sleep($iDelayTrain2) Then Return
						WEnd
						If _Sleep($iDelayTrain4) Then Return
						ClickP($aAway, 2, $iDelayTrain5, "#0503"); Click away twice with 250ms delay
						If _Sleep($iDelayTrain4) Then Return
						Return
					EndIf
				EndIf
				;;;;;; End Training Minions to Reach Full army ;;;;;;;;
				If Not (IsTrainPage()) Then Return
				$icount = 0
				If $brrDarkNum >= $numDarkBarracksAvaiables Then ExitLoop ; make sure no more infiniti loop
				_TrainMoveBtn(+1) ;click Next button
				If _Sleep($iDelayTrain2) Then Return
			WEnd
		EndIf
	EndIf
	;;;;;;;;;;;; End Training Dark Troops ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	If $debugsetlogTrain = 1 Then SetLog("---=====================END TRAIN =======================================---", $COLOR_PURPLE)


	If _Sleep($iDelayTrain4) Then Return
	BrewSpells() ; Create Spells


	If _Sleep($iDelayTrain4) Then Return
	ClickP($aAway, 2, $iDelayTrain5, "#0504"); Click away twice with 250ms delay
	$FirstStart = False

	;;;;;; Protect Army cost stats from being missed up by DC and other errors ;;;;;;;
	If _Sleep($iDelayTrain4) Then Return
	VillageReport(True, True)

	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 30
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd

	If $tempElixir <> "" And $iElixirCurrent <> "" Then
		$tempElixirSpent = ($tempElixir - $iElixirCurrent)
		$iTrainCostElixir += $tempElixirSpent
		$iElixirTotal -= $tempElixirSpent
	EndIf

	If $tempDElixir <> "" And $iDarkCurrent <> "" Then
		$tempDElixirSpent = ($tempDElixir - $iDarkCurrent)
		$iTrainCostDElixir += $tempDElixirSpent
		$iDarkTotal -= $tempDElixirSpent
	EndIf

	UpdateStats()

EndFunc   ;==>Train