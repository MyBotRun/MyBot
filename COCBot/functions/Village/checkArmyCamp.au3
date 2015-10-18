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
	$sArmyInfo = getArmyCampCap(212, 144) ; OCR read army trained and total
	If $debugSetlog = 1 Then Setlog("OCR $sArmyInfo = " & $sArmyInfo, $COLOR_PURPLE)

	While $iTried < 100 ; 30 - 40 sec

		$iTried += 1
		If _Sleep($iDelaycheckArmyCamp5) Then Return ; Wait 250ms before reading again
		$sArmyInfo = getArmyCampCap(212, 144) ; OCR read army trained and total
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

	SetLog("Total Army Camp capacity: " & $CurCamp & "/" & $TotalCamp)

	If ($CurCamp >= ($TotalCamp * $fulltroop / 100)) And $CommandStop = -1 Then
		$fullArmy = True
	EndIf

	If ($CurCamp + 1) = $TotalCamp Then
		$fullArmy = True
	EndIf

	_WinAPI_DeleteObject($hBitmapFirst)
	Local $hBitmapFirst = _CaptureRegion2(140, 165, 705, 220)
	If $debugSetlog = 1 Then SetLog("$hBitmapFirst made", $COLOR_PURPLE)
	If _Sleep($iDelaycheckArmyCamp5) Then Return
	If $debugSetlog = 1 Then SetLog("Calling MBRfunctions.dll/searchIdentifyTroopTrained ", $COLOR_PURPLE)

	$FullTemp = DllCall($LibDir & "\MBRfunctions.dll", "str", "searchIdentifyTroopTrained", "ptr", $hBitmapFirst)
	If $debugSetlog = 1 Then SetLog("Dll return $FullTemp :" & $FullTemp[0], $COLOR_PURPLE)

	If IsArray($FullTemp) Then
		$TroopTypeT = StringSplit($FullTemp[0], "#")
	EndIf

	If $debugSetlog = 1 Then SetLog("$Trooptype split # : " & $TroopTypeT[0], $COLOR_PURPLE)
	If $debugSetlog = 1 Then SetLog("Start the Loop", $COLOR_PURPLE)

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
					If $FirstStart Or $fullArmy Then $CurBarb = -($TroopQ)

				ElseIf $Troops[1] = "Archer" Then
					$TroopQ = $Troops[3]
					$TroopName = "Archers"
					If $FirstStart Or $fullArmy Then $CurArch = -($TroopQ)

				ElseIf $Troops[1] = "Giant" Then
					$TroopQ = $Troops[3]
					$TroopName = "Giants"
					If $FirstStart Or $fullArmy Then $CurGiant = -($TroopQ)

				ElseIf $Troops[1] = "Goblin" Then
					$TroopQ = $Troops[3]
					$TroopName = "Goblins"
					If $FirstStart Or $fullArmy Then $CurGobl = -($TroopQ)

				ElseIf $Troops[1] = "WallBreaker" Then
					$TroopQ = $Troops[3]
					$TroopName = "Wallbreakers"
					If $FirstStart Or $fullArmy Then $CurWall = -($TroopQ)

				ElseIf $Troops[1] = "Balloon" Then
					$TroopQ = $Troops[3]
					$TroopName = "Balloons"
					If $FirstStart Or $fullArmy Then $CurBall = -($TroopQ)

				ElseIf $Troops[1] = "Healer" Then
					$TroopQ = $Troops[3]
					$TroopName = "Healers"
					If $FirstStart Or $fullArmy Then $CurHeal = -($TroopQ)

				ElseIf $Troops[1] = "Wizard" Then
					$TroopQ = $Troops[3]
					$TroopName = "Wizards"
					If $FirstStart Or $fullArmy Then $CurWiza = -($TroopQ)

				ElseIf $Troops[1] = "Dragon" Then
					$TroopQ = $Troops[3]
					$TroopName = "Dragons"
					If $FirstStart Or $fullArmy Then $CurDrag = -($TroopQ)

				ElseIf $Troops[1] = "Pekka" Then
					$TroopQ = $Troops[3]
					$TroopName = "Pekkas"
					If $FirstStart Or $fullArmy Then $CurPekk = -($TroopQ)

				ElseIf $Troops[1] = "Minion" Then
					$TroopQ = $Troops[3]
					$TroopName = "Minions"
					If $FirstStart Or $fullArmy Then $CurMini = -($TroopQ)

				ElseIf $Troops[1] = "HogRider" Then
					$TroopQ = $Troops[3]
					$TroopName = "Hog Riders"
					If $FirstStart Or $fullArmy Then $CurHogs = -($TroopQ)

				ElseIf $Troops[1] = "Valkyrie" Then
					$TroopQ = $Troops[3]
					$TroopName = "Valkyries"
					If $FirstStart Or $fullArmy Then $CurValk = -($TroopQ)

				ElseIf $Troops[1] = "Golem" Then
					$TroopQ = $Troops[3]
					$TroopName = "Golems"
					If $FirstStart Or $fullArmy Then $CurGole = -($TroopQ)

				ElseIf $Troops[1] = "Witch" Then
					$TroopQ = $Troops[3]
					$TroopName = "Witches"
					If $FirstStart Or $fullArmy Then $CurWitc = -($TroopQ)

				ElseIf $Troops[1] = "LavaHound" Then
					$TroopQ = $Troops[3]
					$TroopName = "Lava Hounds"
					If $FirstStart Or $fullArmy Then $CurLava = -($TroopQ)

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

	If Not _ColorCheck(_GetPixelColor(485, 475, True), Hex(0xD3D3CA, 6), 10) Then
		; Slot 1
		If _ColorCheck(_GetPixelColor(485, 475, True), Hex(0x808650, 6), 20) Then
			Setlog(" - Archer Queen available")
			$ArcherQueenAvailable = 1
		EndIf
		If _ColorCheck(_GetPixelColor(485, 475, True), Hex(0x503838, 6), 20) Then
			Setlog(" - Barbarian King available")
			$BarbarianKingAvailable = 1
		EndIf
		; Slot 2
		If _ColorCheck(_GetPixelColor(547, 475, True), Hex(0x808650, 6), 20) Then
			Setlog(" - Archer Queen available")
			$ArcherQueenAvailable = 1
		EndIf
		If _ColorCheck(_GetPixelColor(547, 475, True), Hex(0x503838, 6), 20) Then
			Setlog(" - Barbarian King available")
			$BarbarianKingAvailable = 1
		EndIf
	EndIf

	; VERIFY EXISTEN SPELLS AND CAPACITY
	If $iTotalCountSpell > 0 Then ; only use this code if the user had input spells to brew ... and assign the spells quantity
		$sSpellsInfo = getArmyCampCap(204, 391) ; OCR read Spells and total capacity

		$iCount = 0 ; reset OCR loop counter
		While $sSpellsInfo = "" ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid
			$sSpellsInfo = getArmyCampCap(204, 391) ; OCR read Spells and total capacity
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
			If $debugSetlog = 1 Then Setlog(" Slot : " & $i + 1)
			Local $FullTemp = getOcrSpellDetection(144 + (62 * $i), 455)
			If $debugSetlog = 1 Then Setlog(" getOcrSpellDetection: " & $FullTemp)
			Local $Result = getOcrSpellQuantity(164 + (62 * $i), 414)
			Local $SpellQ = StringReplace($Result, "x", "")
			If $debugSetlog = 1 Then Setlog(" getOcrSpellQuantity: " & $SpellQ)
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
				Setlog(" - was not detected anything in slot: " & $i + 1)
			EndIf
		Next
	EndIf

	;call BarracksStatus() to read barracks num
	If $FirstStart Then
		BarracksStatus(True)
	Else
		BarracksStatus(False)
	EndIf

;~ 	ClickP($aAway, 1, 0, "#0295") ;Click Away
	$FirstCampView = True

EndFunc   ;==>checkArmyCamp
