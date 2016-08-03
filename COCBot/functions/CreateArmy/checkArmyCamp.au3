; #FUNCTION# ====================================================================================================================
; Name ..........: checkArmyCamp
; Description ...: Reads the size it the army camp, the number of troops trained, and Spells
; Syntax ........: checkArmyCamp()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #4,342
; Modified ......: Sardo 2015-08, KnowJack(Aug2015). ProMac ( 08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkArmyCamp()

	If $debugsetlogTrain = 1 Then SETLOG("Begin checkArmyCamp:", $COLOR_PURPLE)

	GetArmyCapacity()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmyTroopCount()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmyTroopTime()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmyHeroCount()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmySpellCapacity()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmySpellCount()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmySpellTime()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmyCCStatus()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	;call BarracksStatus() to read barracks num
	If $FirstStart Then
		BarracksStatus(True)
	Else
		BarracksStatus(False)
	EndIf

	If Not $fullArmy Then DeleteExcessTroops()

	$FirstCampView = True

	If $debugsetlogTrain = 1 Then SETLOG("End checkArmyCamp: canRequestCC= " & $canRequestCC & ", fullArmy= " & $fullArmy, $COLOR_PURPLE)

EndFunc   ;==>checkArmyCamp

Func IsTroopToDonateOnly($pTroopType)

	If $iDBcheck = 1 Then
		$pMatchMode = $DB
		Local $tempArr = $troopsToBeUsed[$iCmbSelectTroop[$pMatchMode]]
		For $x = 0 To UBound($tempArr) - 1
			If $tempArr[$x] = $pTroopType Then
				Return False
			EndIf
		Next
	EndIf
	If $iABcheck = 1 Then
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
	If $debugsetlogTrain = 1 Then SetLog("Start-Loop Regular Troops Only To Donate ")
	For $i = 0 To UBound($TroopName) - 1
		If IsTroopToDonateOnly(Eval("e" & $TroopName[$i])) Then ; Will delete ONLY the Excess quantity of troop for donations , the rest is to use in Attack
			If $debugsetlogTrain = 1 Then SetLog("Troop :" & NameOfTroop(Eval("e" & $TroopName[$i])))
			If (Eval("Cur" & $TroopName[$i]) * -1) > Eval($TroopName[$i] & "Comp") Then ; verify if the exist excess of troops

				$Delete = (Eval("Cur" & $TroopName[$i]) * -1) - Eval($TroopName[$i] & "Comp") ; existent troops - troops selected in GUI
				If $debugsetlogTrain = 1 Then SetLog("$Delete :" & $Delete)
				$SlotTemp = Eval("SlotInArmy" & $TroopName[$i])
				If $debugsetlogTrain = 1 Then SetLog("$SlotTemp :" & $SlotTemp)

				If _Sleep(250) Then Return
				If _ColorCheck(_GetPixelColor(170 + (62 * $SlotTemp), 235 + $midOffsetY, True), Hex(0xD40003, 6), 10) Then ; Verify if existe the RED [-] button
					Click(170 + (62 * $SlotTemp), 235 + $midOffsetY, $Delete, 300)
					SetLog("~Deleted " & $Delete & " " & NameOfTroop(Eval("e" & $TroopName[$i])), $COLOR_RED)
					Assign("Cur" & $TroopName[$i], Eval("Cur" & $TroopName[$i]) + $Delete) ; Remove From $CurTroop the deleted Troop quantity
				EndIf
			EndIf
		EndIf
	Next

	If $debugsetlogTrain = 1 Then SetLog("Start-Loop Dark Troops Only To Donate ")
	For $i = 0 To UBound($TroopDarkName) - 1
		If IsTroopToDonateOnly(Eval("e" & $TroopDarkName[$i])) Then ; Will delete ONLY the Excess quantity of troop for donations , the rest is to use in Attack
			If $debugsetlogTrain = 1 Then SetLog("Troop :" & NameOfTroop(Eval("e" & $TroopDarkName[$i])))
			If (Eval("Cur" & $TroopDarkName[$i]) * -1) > Eval($TroopDarkName[$i] & "Comp") Then ; verify if the exist excess of troops

				$Delete = (Eval("Cur" & $TroopDarkName[$i]) * -1) - Eval($TroopDarkName[$i] & "Comp") ; existent troops - troops selected in GUI
				If $debugsetlogTrain = 1 Then SetLog("$Delete :" & $Delete)
				$SlotTemp = Eval("SlotInArmy" & $TroopDarkName[$i])
				If $debugsetlogTrain = 1 Then SetLog("$SlotTemp :" & $SlotTemp)

				If _Sleep(250) Then Return
				If _ColorCheck(_GetPixelColor(170 + (62 * $SlotTemp), 235 + $midOffsetY, True), Hex(0xD40003, 6), 10) Then ; Verify if existe the RED [-] button
					Click(170 + (62 * $SlotTemp), 235 + $midOffsetY, $Delete, 300)
					SetLog("~Deleted " & $Delete & " " & NameOfTroop(Eval("e" & $TroopDarkName[$i])), $COLOR_RED)
					Assign("Cur" & $TroopDarkName[$i], Eval("Cur" & $TroopDarkName[$i]) + $Delete) ; Remove From $CurTroop the deleted Troop quantity
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
