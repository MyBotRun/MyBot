; #FUNCTION# ====================================================================================================================
; Name ..........: checkArmyCamp
; Description ...: Reads the size it the army camp, the number of troops trained, and Spells
; Syntax ........: checkArmyCamp()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #4,342
; Modified ......: Sardo 2015-08, KnowJack(Aug2015). ProMac ( 08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Global $SlotInArmyBarb = -1, $SlotInArmyArch = -1, $SlotInArmyGiant = -1, $SlotInArmyGobl = -1, $SlotInArmyWall = -1, $SlotInArmyBall = -1, $SlotInArmyWiza = -1, $SlotInArmyHeal = -1
Global $SlotInArmyMini = -1, $SlotInArmyHogs = -1, $SlotInArmyValk = -1, $SlotInArmyGole = -1, $SlotInArmyWitc = -1, $SlotInArmyLava = -1, $SlotInArmyDrag = -1, $SlotInArmyPekk = -1

Func checkArmyCamp()

	Local $aGetArmySize[3] = ["", "", ""]
	Local $aGetSFactorySize[3] = ["", "", ""]
	Local $sArmyInfo = ""
	Local $FullTemp = ""
	Local $sSpellsInfo = ""
	Local $TroopName = 0
	Local $TroopQ = 0
	Local $TroopTypeT = ""
	Local $sInputbox, $iCount, $iTried, $iHoldCamp
	Local $tmpTotalCamp = 0
	Local $tmpCurCamp = 0

	SetLog("Checking Army Camp...", $COLOR_BLUE)
	If _Sleep($iDelaycheckArmyCamp1) Then Return

	$iTried = 0 ; reset loop safety exit counter
	$sArmyInfo = getArmyCampCap(192, 144 + $midOffsetY) ; OCR read army trained and total
	If $debugSetlog = 1 Then Setlog("OCR $sArmyInfo = " & $sArmyInfo, $COLOR_PURPLE)

	While $iTried < 100 ; 30 - 40 sec

		$iTried += 1
		If _Sleep($iDelaycheckArmyCamp5) Then Return ; Wait 250ms before reading again
		$sArmyInfo = getArmyCampCap(192, 144 + $midOffsetY) ; OCR read army trained and total
		If $debugSetlog = 1 Then Setlog("OCR $sArmyInfo = " & $sArmyInfo, $COLOR_PURPLE)
		If StringInStr($sArmyInfo, "#", 0, 1) < 2 Then ContinueLoop ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid

		$aGetArmySize = StringSplit($sArmyInfo, "#") ; split the trained troop number from the total troop number
		If IsArray($aGetArmySize) Then
			If $aGetArmySize[0] > 1 Then ; check if the OCR was valid and returned both values
				If Number($aGetArmySize[2]) < 10 Or Mod(Number($aGetArmySize[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $debugSetlog = 1 Then Setlog(" OCR value is not valid camp size", $COLOR_PURPLE)
					ContinueLoop
				EndIf
				$tmpCurCamp = Number($aGetArmySize[1])
				If $debugSetlog = 1 Then Setlog("$tmpCurCamp = " & $tmpCurCamp, $COLOR_PURPLE)
				$tmpTotalCamp = Number($aGetArmySize[2])
				If $debugSetlog = 1 Then Setlog("$TotalCamp = " & $TotalCamp & ", Camp OCR = " & $aGetArmySize[2], $COLOR_PURPLE)
				If $iHoldCamp = $tmpTotalCamp Then ExitLoop ; check to make sure the OCR read value is same in 2 reads before exit
				$iHoldCamp = $tmpTotalCamp ; Store last OCR read value
			EndIf
		EndIf

	WEnd

	If $iTried <= 99 Then
		$CurCamp = $tmpCurCamp
		If $TotalCamp = 0 Then $TotalCamp = $tmpTotalCamp
		If $debugSetlog = 1 Then Setlog("$CurCamp = " & $CurCamp & ", $TotalCamp = " & $TotalCamp, $COLOR_PURPLE)
	Else
		Setlog("Army size read error, Troop numbers may not train correctly", $COLOR_RED) ; log if there is read error
		$CurCamp = 0
		CheckOverviewFullArmy()
	EndIf

	If $TotalCamp = 0 Or ($TotalCamp <> $tmpTotalCamp) Then ; if Total camp size is still not set or value not same as read use forced value
		If $ichkTotalCampForced = 0 Then ; check if forced camp size set in expert tab
			$sInputbox = InputBox("Question", "Enter your total Army Camp capacity", "200", "", Default, Default, Default, Default, 240, $frmbot)
			$TotalCamp = Number($sInputbox)
			$iValueTotalCampForced = $TotalCamp
			$ichkTotalCampForced = 1
			Setlog("Army Camp User input = " & $TotalCamp, $COLOR_RED) ; log if there is read error AND we ask the user to tell us.
		Else
			$TotalCamp = Number($iValueTotalCampForced)
		EndIf
	EndIf
	If _Sleep($iDelaycheckArmyCamp4) Then Return

	If $TotalCamp > 0 Then
		SetLog("Total Army Camp capacity: " & $CurCamp & "/" & $TotalCamp & " (" & Int($CurCamp / $TotalCamp * 100) & "%)")
	Else
		SetLog("Total Army Camp capacity: " & $CurCamp & "/" & $TotalCamp)
	EndIf

	If ($CurCamp >= ($TotalCamp * $fulltroop / 100)) And $CommandStop = -1 Then
		$fullArmy = True
	EndIf

	If ($CurCamp + 1) = $TotalCamp Then
		$fullArmy = True
	EndIf

	_WinAPI_DeleteObject($hBitmapFirst)
	Local $hBitmapFirst = _CaptureRegion2(120, 165 + $midOffsetY, 740, 220 + $midOffsetY)
	If $debugSetlog = 1 Then SetLog("$hBitmapFirst made", $COLOR_PURPLE)
	If _Sleep($iDelaycheckArmyCamp5) Then Return
	If $debugSetlog = 1 Then SetLog("Calling MBRfunctions.dll/searchIdentifyTroopTrained ", $COLOR_PURPLE)

	$FullTemp = DllCall($hFuncLib, "str", "searchIdentifyTroopTrained", "ptr", $hBitmapFirst)
	If $debugSetlog = 1 Then
		If IsArray($FullTemp) Then
			SetLog("Dll return $FullTemp :" & $FullTemp[0], $COLOR_PURPLE)
		Else
			SetLog("Dll return $FullTemp : ERROR" & $FullTemp, $COLOR_PURPLE)
		EndIf
	EndIf

	If IsArray($FullTemp) Then
		$TroopTypeT = StringSplit($FullTemp[0], "#")
	EndIf

	If $debugSetlog = 1 Then
		If IsArray($TroopTypeT) Then
			SetLog("$Trooptype split # : " & $TroopTypeT[0], $COLOR_PURPLE)
		Else
			SetLog("$Trooptype split # : ERROR " & $TroopTypeT, $COLOR_PURPLE)
		EndIf
	EndIf
	If $debugSetlog = 1 Then SetLog("Start the Loop", $COLOR_PURPLE)

	For $i = 0 To UBound($TroopName) - 1 ; Reset the variables
		Assign(("SlotInArmy" & $TroopName[$i]), -1)
	Next

	For $i = 0 To UBound($TroopDarkName) - 1 ; Reset the variables
		Assign(("SlotInArmy" & $TroopDarkName[$i]), -1)
	Next

	If IsArray($TroopTypeT) Then

		For $i = 1 To $TroopTypeT[0]

			$TroopName = "Unknown"
			$TroopQ = "0"
			If _sleep($iDelaycheckArmyCamp1) Then Return
			Local $Troops = StringSplit($TroopTypeT[$i], "|")
			If $debugSetlog = 1 Then SetLog("$TroopTypeT[$i] split : " & $i, $COLOR_PURPLE)

			If IsArray($Troops) Then

				If $Troops[1] = "Barbarian" Then
					$TroopQ = $Troops[3]
					$TroopName = "Barbarians"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eBarb) Then
						$CurBarb = -($TroopQ)
						$SlotInArmyBarb = $i - 1
					EndIf

				ElseIf $Troops[1] = "Archer" Then
					$TroopQ = $Troops[3]
					$TroopName = "Archers"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eArch) Then
						$CurArch = -($TroopQ)
						$SlotInArmyArch = $i - 1
					EndIf

				ElseIf $Troops[1] = "Giant" Then
					$TroopQ = $Troops[3]
					$TroopName = "Giants"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eGiant) Then
						$CurGiant = -($TroopQ)
						$SlotInArmyGiant = $i - 1
					EndIf

				ElseIf $Troops[1] = "Goblin" Then
					$TroopQ = $Troops[3]
					$TroopName = "Goblins"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eGobl) Then
						$CurGobl = -($TroopQ)
						$SlotInArmyGobl = $i - 1
					EndIf

				ElseIf $Troops[1] = "WallBreaker" Then
					$TroopQ = $Troops[3]
					$TroopName = "Wallbreakers"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eWall) Then
						$CurWall = -($TroopQ)
						$SlotInArmyWall = $i - 1
					EndIf

				ElseIf $Troops[1] = "Balloon" Then
					$TroopQ = $Troops[3]
					$TroopName = "Balloons"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eBall) Then
						$CurBall = -($TroopQ)
						$SlotInArmyBall = $i - 1
					EndIf

				ElseIf $Troops[1] = "Healer" Then
					$TroopQ = $Troops[3]
					$TroopName = "Healers"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eHeal) Then
						$CurHeal = -($TroopQ)
						$SlotInArmyHeal = $i - 1
					EndIf

				ElseIf $Troops[1] = "Wizard" Then
					$TroopQ = $Troops[3]
					$TroopName = "Wizards"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eWiza) Then
						$CurWiza = -($TroopQ)
						$SlotInArmyWiza = $i - 1
					EndIf

				ElseIf $Troops[1] = "Dragon" Then
					$TroopQ = $Troops[3]
					$TroopName = "Dragons"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eDrag) Then
						$CurDrag = -($TroopQ)
						$SlotInArmyDrag = $i - 1
					EndIf

				ElseIf $Troops[1] = "Pekka" Then
					$TroopQ = $Troops[3]
					$TroopName = "Pekkas"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($ePekk) Then
						$CurPekk = -($TroopQ)
						$SlotInArmyPekk = $i - 1
					EndIf

				ElseIf $Troops[1] = "Minion" Then
					$TroopQ = $Troops[3]
					$TroopName = "Minions"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eMini) Then
						$CurMini = -($TroopQ)
						$SlotInArmyMini = $i - 1
					EndIf

				ElseIf $Troops[1] = "HogRider" Then
					$TroopQ = $Troops[3]
					$TroopName = "Hog Riders"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eHogs) Then
						$CurHogs = -($TroopQ)
						$SlotInArmyHogs = $i - 1
					EndIf

				ElseIf $Troops[1] = "Valkyrie" Then
					$TroopQ = $Troops[3]
					$TroopName = "Valkyries"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eValk) Then
						$CurValk = -($TroopQ)
						$SlotInArmyValk = $i - 1
					EndIf

				ElseIf $Troops[1] = "Golem" Then
					$TroopQ = $Troops[3]
					$TroopName = "Golems"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eGole) Then
						$CurGole = -($TroopQ)
						$SlotInArmyGole = $i - 1
					EndIf

				ElseIf $Troops[1] = "Witch" Then
					$TroopQ = $Troops[3]
					$TroopName = "Witches"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eWitc) Then
						$CurWitc = -($TroopQ)
						$SlotInArmyWitc = $i - 1
					EndIf

				ElseIf $Troops[1] = "LavaHound" Then
					$TroopQ = $Troops[3]
					$TroopName = "Lava Hounds"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eLava) Then
						$CurLava = -($TroopQ)
						$SlotInArmyLava = $i - 1
					EndIf

				EndIf
				If $TroopQ <> 0 Then SetLog(" - No. of " & $TroopName & ": " & $TroopQ)

			EndIf

		Next

	EndIf

	If Not $fullArmy And $FirstStart Then
		$ArmyComp = $CurCamp
	EndIf

	; VERIFY EXISTEN HEROES
	$BarbarianKingAvailable = 0
	$ArcherQueenAvailable = 0
	$GrandWardenAvailable = 0

	If Not _ColorCheck(_GetPixelColor(428, 447 + $midOffsetY, True), Hex(0xd0cfc5, 6), 10) Then
		; Slot 1
		If _ColorCheck(_GetPixelColor(426, 447 + $midOffsetY, True), Hex(0xf6bc20, 6), 15) Then
			Setlog(" - Grand Warden available")
			$GrandWardenAvailable = 1
		EndIf
		If _ColorCheck(_GetPixelColor(426, 447 + $midOffsetY, True), Hex(0x812612, 6), 15) Then
			Setlog(" - Archer Queen available")
			$ArcherQueenAvailable = 1
		EndIf
		If _ColorCheck(_GetPixelColor(428, 447 + $midOffsetY, True), Hex(0x4e3d33, 6), 15) Then
			Setlog(" - Barbarian King available")
			$BarbarianKingAvailable = 1
		EndIf
		; Slot 2
		If _ColorCheck(_GetPixelColor(490, 447 + $midOffsetY, True), Hex(0xf2bb1f, 6), 15) Then
			Setlog(" - Grand Warden available")
			$GrandWardenAvailable = 1
		EndIf
		If _ColorCheck(_GetPixelColor(490, 447 + $midOffsetY, True), Hex(0xa81c08, 6), 15) Then
			Setlog(" - Archer Queen available")
			$ArcherQueenAvailable = 1
		EndIf
		; Slot 3
		If _ColorCheck(_GetPixelColor(558, 447 + $midOffsetY, True), Hex(0xfecc1d, 6), 15) Then
			Setlog(" - Grand Warden available")
			$GrandWardenAvailable = 1
		EndIf
	EndIf

	; VERIFY EXISTEN SPELLS AND CAPACITY
	If $iTotalCountSpell > 0 Then ; only use this code if the user had input spells to brew ... and assign the spells quantity
		$sSpellsInfo = getArmyCampCap(184, 391 + $midOffsetY) ; OCR read Spells and total capacity

		$iCount = 0 ; reset OCR loop counter
		While $sSpellsInfo = "" ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid
			$sSpellsInfo = getArmyCampCap(184, 391 + $midOffsetY) ; OCR read Spells and total capacity
			$iCount += 1
			If $iCount > 10 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
			If _Sleep($iDelaycheckArmyCamp5) Then Return ; Wait 250ms
		WEnd

		If $debugSetlog = 1 Then Setlog("$sSpellsInfo = " & $sSpellsInfo, $COLOR_PURPLE)
		$aGetSFactorySize = StringSplit($sSpellsInfo, "#") ; split the existen Spells from the total Spell factory capacity

		If IsArray($aGetSFactorySize) Then

			If $aGetSFactorySize[0] > 1 Then
				$TotalSFactory = Number($aGetSFactorySize[2])
				$CurSFactory = Number($aGetSFactorySize[1])
			Else
				Setlog("Spell Factory size read error.", $COLOR_RED) ; log if there is read error
				$CurSFactory = 0
				$TotalSFactory = $iTotalCountSpell
			EndIf
		Else
			Setlog("Spell Factory size read error.", $COLOR_RED) ; log if there is read error
			$CurSFactory = 0
			$TotalSFactory = $iTotalCountSpell
		EndIf

		SetLog("Total Spell(s) Capacity: " & $CurSFactory & "/" & $TotalSFactory)
		$CurLightningSpell = 0
		$CurHealSpell = 0
		$CurRageSpell = 0
		$CurJumpSpell = 0
		$CurFreezeSpell = 0
		$CurPoisonSpell = 0
		$CurHasteSpell = 0
		$CurEarthSpell = 0

		For $i = 0 To 4 ; 5 visible slots in ArmyoverView window
			If $debugSetlog = 1 Then Setlog(" Slot : " & $i + 1, $COLOR_PURPLE)
			Local $FullTemp = getOcrSpellDetection(125 + (62 * $i), 450 + $midOffsetY)
			If $debugSetlog = 1 Then Setlog(" getOcrSpellDetection: " & $FullTemp, $COLOR_PURPLE)
			Local $Result = getOcrSpellQuantity(146 + (62 * $i), 414 + $midOffsetY)
			Local $SpellQ = StringReplace($Result, "x", "")
			If $debugSetlog = 1 Then Setlog(" getOcrSpellQuantity: " & $SpellQ, $COLOR_PURPLE)
			If $FullTemp = "Lightning" Then
				$CurLightningSpell = $SpellQ
				Setlog(" - No. of LightningSpell: " & $SpellQ)
			EndIf
			If $FullTemp = "Heal" Then
				$CurHealSpell = $SpellQ
				Setlog(" - No. of HealSpell: " & $SpellQ)
			EndIf
			If $FullTemp = "Rage" Then
				$CurRageSpell = $SpellQ
				Setlog(" - No. of RageSpell: " & $SpellQ)
			EndIf
			If $FullTemp = "Jump" Then
				$CurJumpSpell = $SpellQ
				Setlog(" - No. of JumpSpell: " & $SpellQ)
			EndIf
			If $FullTemp = "Freeze" Then
				$CurFreezeSpell = $SpellQ
				Setlog(" - No. of FreezeSpell: " & $SpellQ)
			EndIf
			If $FullTemp = "Poison" Then
				$CurPoisonSpell = $SpellQ
				Setlog(" - No. of PoisonSpell: " & $SpellQ)
			EndIf
			If $FullTemp = "Haste" Then
				$CurHasteSpell = $SpellQ
				Setlog(" - No. of HasteSpell: " & $SpellQ)
			EndIf
			If $FullTemp = "Earth" Then
				$CurEarthSpell = $SpellQ
				Setlog(" - No. of EarthquakeSpell: " & $SpellQ)
			EndIf
			If $FullTemp = "" And $debugSetlog = 1 Then
				Setlog(" - was not detected anything in slot: " & $i + 1, $COLOR_PURPLE)
			EndIf
		Next
	EndIf

	;verify can make requestCC
	$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
	If $debugSetlog = 1 Then SETLOG("Can Request CC: " & $canRequestCC, $COLOR_PURPLE)


	;call BarracksStatus() to read barracks num
	If $FirstStart Then
		BarracksStatus(True)
	Else
		BarracksStatus(False)
	EndIf

	If Not $fullArmy Then DeleteExcessTroops()

;~ 	ClickP($aAway, 1, 0, "#0295") ;Click Away
	$FirstCampView = True

EndFunc   ;==>checkArmyCamp

Func IsTroopToDonateOnly($pTroopType)

	If $iCmbSearchMode = 0 Then
		$pMatchMode = $DB
		Local $tempArr = $troopsToBeUsed[$iCmbSelectTroop[$pMatchMode]]
		For $x = 0 To UBound($tempArr) - 1
			If $tempArr[$x] = $pTroopType Then
				Return False
			EndIf
		Next

	ElseIf $iCmbSearchMode = 1 Then
		$pMatchMode = $LB
		Local $tempArr = $troopsToBeUsed[$iCmbSelectTroop[$pMatchMode]]
		For $x = 0 To UBound($tempArr) - 1
			If $tempArr[$x] = $pTroopType Then
				Return False
			EndIf
		Next
	ElseIf $iCmbSearchMode = 2 Then
		$pMatchMode = $DB
		Local $tempArr = $troopsToBeUsed[$iCmbSelectTroop[$pMatchMode]]
		For $x = 0 To UBound($tempArr) - 1
			If $tempArr[$x] = $pTroopType Then
				Return False
			EndIf
		Next
		$pMatchMode = $LB
		Local $tempArr = $troopsToBeUsed[$iCmbSelectTroop[$pMatchMode]]
		For $x = 0 To UBound($tempArr) - 1
			If $tempArr[$x] = $pTroopType Then
				Return False
			EndIf
		Next
	EndIf

	Return True

EndFunc   ;==>IsTroopToDonateOnly

Func DeleteExcessTroops()

	Local $SlotTemp, $Delete
	Local $IsNecessaryDeleteTroop = 0
	Local $CorrectDonation

	; Prevent delete Troop from Army and waste Elixir just because of excess of train+donateCC variable
	For $i = 0 To UBound($TroopName) - 1
		$CorrectDonation = 0
		If IsTroopToDonateOnly(Eval("e" & $TroopName[$i])) Then
			If (Eval("Cur" & $TroopName[$i]) * -1) > Eval($TroopName[$i] & "Comp") Then ; Will Balance The Comp and Donate removing the excess to Donate Train
				$IsNecessaryDeleteTroop = 1 ; Flag to continue to the next loop
				Assign("Don" & $TroopName[$i], 0)
			EndIf
			If (Eval("Cur" & $TroopName[$i]) * -1) = Eval($TroopName[$i] & "Comp") Then ; Will Balance The Comp and Donate removing the excess to Donate Train
				Assign("Don" & $TroopName[$i], 0)
			EndIf
			If (Eval("Cur" & $TroopName[$i]) * -1) + Eval("Don" & $TroopName[$i]) >= Eval($TroopName[$i] & "Comp") Then ; Will Balance The Comp and Donate removing the excess to Donate Train
				$CorrectDonation = Eval("Cur" & $TroopName[$i]) + Eval($TroopName[$i] & "Comp")
				Assign("Don" & $TroopName[$i], $CorrectDonation)
			EndIf
		EndIf
	Next

	For $i = 0 To UBound($TroopDarkName) - 1
		If IsTroopToDonateOnly(Eval("e" & $TroopDarkName[$i])) Then
			$CorrectDonation = 0
			If (Eval("Cur" & $TroopDarkName[$i]) * -1) > Eval($TroopDarkName[$i] & "Comp") Then
				$IsNecessaryDeleteTroop = 1 ; Flag to continue to the next loop
				Assign("Don" & $TroopDarkName[$i], 0)
			EndIf
			If (Eval("Cur" & $TroopDarkName[$i]) * -1) = Eval($TroopDarkName[$i] & "Comp") Then ; Will Balance The Comp and Donate removing the excess to Donate Train
				Assign("Don" & $TroopDarkName[$i], 0)
			EndIf
			If (Eval("Cur" & $TroopDarkName[$i]) * -1) + Eval("Don" & $TroopDarkName[$i]) >= Eval($TroopDarkName[$i] & "Comp") Then ; Will Balance The Comp and Donate removing the excess to Donate Train
				$CorrectDonation = Eval("Cur" & $TroopDarkName[$i]) + Eval($TroopDarkName[$i] & "Comp")
				Assign("Don" & $TroopDarkName[$i], $CorrectDonation)
			EndIf
		EndIf
	Next

	If $IsNecessaryDeleteTroop = 0 Then Return

	If _ColorCheck(_GetPixelColor(670, 485 + $midOffsetY, True), Hex(0x60B010, 6), 5) Then
		Click(670, 485 + $midOffsetY) ;  Green button Edit Army
	EndIf

	SetLog("Troops in excess!...")
	If $debugSetlog = 1 Then SetLog("Start-Loop Regular Troops Only To Donate ")
	For $i = 0 To UBound($TroopName) - 1
		If IsTroopToDonateOnly(Eval("e" & $TroopName[$i])) Then ; Will delete ONLY the Excess quantity of troop for donations , the rest is to use in Attack
			If $debugSetlog = 1 Then SetLog("Troop :" & NameOfTroop(Eval("e" & $TroopName[$i])))
			If (Eval("Cur" & $TroopName[$i]) * -1) > Eval($TroopName[$i] & "Comp") Then ; verify if the exist excess of troops

				$Delete = (Eval("Cur" & $TroopName[$i]) * -1) - Eval($TroopName[$i] & "Comp") ; existent troops - troops selected in GUI
				If $debugSetlog = 1 Then SetLog("$Delete :" & $Delete)
				$SlotTemp = Eval("SlotInArmy" & $TroopName[$i])
				If $debugSetlog = 1 Then SetLog("$SlotTemp :" & $SlotTemp)

				If _Sleep(250) Then Return
				If _ColorCheck(_GetPixelColor(192 + (62 * $SlotTemp), 235 + $midOffsetY, True), Hex(0xD10400, 6), 10) Then ; Verify if existe the RED [-] button
					Click(192 + (62 * $SlotTemp), 235 + $midOffsetY, $Delete, 300)
					SetLog("~Deleted " & $Delete & " " & NameOfTroop(Eval("e" & $TroopName[$i])), $COLOR_RED)
					Assign("Cur" & $TroopName[$i], Eval("Cur" & $TroopName[$i]) + $Delete ) ; Remove From $CurTroop the deleted Troop quantity
				EndIf
			EndIf
		EndIf
	Next

	If $debugSetlog = 1 Then SetLog("Start-Loop Dark Troops Only To Donate ")
	For $i = 0 To UBound($TroopDarkName) - 1
		If IsTroopToDonateOnly(Eval("e" & $TroopDarkName[$i])) Then ; Will delete ONLY the Excess quantity of troop for donations , the rest is to use in Attack
			If $debugSetlog = 1 Then SetLog("Troop :" & NameOfTroop(Eval("e" & $TroopDarkName[$i])))
			If (Eval("Cur" & $TroopDarkName[$i]) * -1) > Eval($TroopDarkName[$i] & "Comp") Then ; verify if the exist excess of troops

				$Delete = (Eval("Cur" & $TroopDarkName[$i]) * -1) - Eval($TroopDarkName[$i] & "Comp") ; existent troops - troops selected in GUI
				If $debugSetlog = 1 Then SetLog("$Delete :" & $Delete)
				$SlotTemp = Eval("SlotInArmy" & $TroopDarkName[$i])
				If $debugSetlog = 1 Then SetLog("$SlotTemp :" & $SlotTemp)

				If _Sleep(250) Then Return
				If _ColorCheck(_GetPixelColor(192 + (62 * $SlotTemp), 235 + $midOffsetY, True), Hex(0xD10400, 6), 10) Then ; Verify if existe the RED [-] button
					Click(192 + (62 * $SlotTemp), 235 + $midOffsetY, $Delete, 300)
					SetLog("~Deleted " & $Delete & " " & NameOfTroop(Eval("e" & $TroopDarkName[$i])), $COLOR_RED)
					Assign("Cur" & $TroopDarkName[$i], Eval("Cur" & $TroopDarkName[$i]) + $Delete ) ; Remove From $CurTroop the deleted Troop quantity
				EndIf
			EndIf
		EndIf
	Next

	If _ColorCheck(_GetPixelColor(674, 436 + $midOffsetY, True), Hex(0x60B010, 6), 5) Then
		Click(674, 436 + $midOffsetY) ; click CONFIRM EDIT
	EndIf

	If WaitforPixel(505, 411 + $midOffsetY, 506, 412 + $midOffsetY, Hex(0x60B010, 6), 5, 10) Then
		Click(505, 411 + $midOffsetY) ; click in REMOVE TROOPS [OK]
	EndIf

EndFunc   ;==>DeleteExcessTroops
