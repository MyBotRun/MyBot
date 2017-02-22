; #FUNCTION# ====================================================================================================================
; Name ..........: checkArmyCamp
; Description ...: Reads the size it the army camp, the number of troops trained, and Spells
; Syntax ........: checkArmyCamp()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #4,342
; Modified ......: Sardo 2015-08, KnowJack(Aug2015). ProMac ( 08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkArmyCamp($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bGetHeroesTime = False)

	If $g_iDebugSetlogTrain = 1 Then SETLOG("Begin checkArmyCamp:", $COLOR_DEBUG1)

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	GetArmyCapacity()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	;getArmyTroopCount() ; OLD METTHOD to detect troops on army over view window
	If ISArmyWindow(False, $ArmyTAB) then CheckExistentArmy("Troops") ; Imgloc Method
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmyTroopTime()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	Local $HeroesRegenTime
	getArmyHeroCount()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response
	If $bGetHeroesTime = True Then $HeroesRegenTime = getArmyHeroTime("all")
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmySpellCapacity()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	If ISArmyWindow(False, $ArmyTAB) then CheckExistentArmy("Spells") ; Imgloc Method
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmySpellTime()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	getArmyCCStatus()
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response

	If Not $fullArmy Then DeleteExcessTroops()

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

	If $g_iDebugSetlogTrain = 1 Then SETLOG("End checkArmyCamp: canRequestCC= " & $canRequestCC & ", fullArmy= " & $fullArmy, $COLOR_DEBUG)

	Return $HeroesRegenTime

EndFunc   ;==>checkArmyCamp

Func IsTroopToDonateOnly($pTroopType)

	If $g_abAttackTypeEnable[$DB] Then
		Local $tempArr = $troopsToBeUsed[$g_aiAttackTroopSelection[$DB]]
		For $x = 0 To UBound($tempArr) - 1
			If $tempArr[$x] = $pTroopType Then
				Return False
			EndIf
		Next
	EndIf
	If $g_abAttackTypeEnable[$LB] Then
		Local $tempArr = $troopsToBeUsed[$g_aiAttackTroopSelection[$LB]]
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
	For $i = 0 To $eTroopCount - 1
		$CorrectDonation = 0
		If IsTroopToDonateOnly($i) Then
			If ($g_aiCurrentTroops[$i] * -1) > $g_aiArmyCompTroops[$i] Then ; Will Balance The Comp and Donate removing the excess to Donate Train
				$IsNecessaryDeleteTroop = 1 ; Flag to continue to the next loop
				$g_aiDonateTroops[$i] = 0
			EndIf
			If ($g_aiCurrentTroops[$i] * -1) = $g_aiArmyCompTroops[$i] Then ; Will Balance The Comp and Donate removing the excess to Donate Train
				$g_aiDonateTroops[$i] = 0
			EndIf
			If ($g_aiCurrentTroops[$i] * -1) + $g_aiDonateTroops[$i] >= $g_aiArmyCompTroops[$i] Then ; Will Balance The Comp and Donate removing the excess to Donate Train
				$CorrectDonation = $g_aiCurrentTroops[$i] + $g_aiArmyCompTroops[$i]
				$g_aiDonateTroops[$i] = $CorrectDonation
			EndIf
		EndIf
	Next

	If $IsNecessaryDeleteTroop = 0 Then Return

	If _ColorCheck(_GetPixelColor(670, 485 + $g_iMidOffsetY, True), Hex(0x60B010, 6), 5) Then
		Click(670, 485 + $g_iMidOffsetY) ;  Green button Edit Army
	EndIf

	SetLog("Troops in excess!...")
	If $g_iDebugSetlogTrain = 1 Then SetLog("Start-Loop Regular Troops Only To Donate ")
	For $i = 0 To $eTroopCount - 1
		If IsTroopToDonateOnly($i) Then ; Will delete ONLY the Excess quantity of troop for donations , the rest is to use in Attack
			If $g_iDebugSetlogTrain = 1 Then SetLog("Troop :" & $g_asTroopNames[$i])
			If ($g_aiCurrentTroops[$i] * -1) > $g_aiArmyCompTroops[$i] Then ; verify if the exist excess of troops

				$Delete = ($g_aiCurrentTroops[$i] * -1) - $g_aiArmyCompTroops[$i] ; existent troops - troops selected in GUI
				If $g_iDebugSetlogTrain = 1 Then SetLog("$Delete :" & $Delete)
				$SlotTemp = $g_aiSlotInArmy[$i]
				If $g_iDebugSetlogTrain = 1 Then SetLog("$SlotTemp :" & $SlotTemp)

				If _Sleep(250) Then Return
				If _ColorCheck(_GetPixelColor(170 + (62 * $SlotTemp), 235 + $g_iMidOffsetY, True), Hex(0xD40003, 6), 10) Then ; Verify if existe the RED [-] button
					Click(170 + (62 * $SlotTemp), 235 + $g_iMidOffsetY, $Delete, 300)
					SetLog("~Deleted " & $Delete & " " & $g_asTroopNames[$i], $COLOR_ERROR)
					$g_aiCurrentTroops[$i] += $Delete ; Remove From $CurTroop the deleted Troop quantity
				EndIf
			EndIf
		EndIf
	Next

	If $g_iDebugSetlogTrain = 1 Then SetLog("Start-Loop Dark Troops Only To Donate ")

	If _ColorCheck(_GetPixelColor(674, 436 + $g_iMidOffsetY, True), Hex(0x60B010, 6), 5) Then
		Click(674, 436 + $g_iMidOffsetY) ; click CONFIRM EDIT
	EndIf

	If WaitforPixel(505, 411 + $g_iMidOffsetY, 506, 412 + $g_iMidOffsetY, Hex(0x60B010, 6), 5, 10) Then
		Click(505, 411 + $g_iMidOffsetY) ; click in REMOVE TROOPS [OK]
	EndIf

EndFunc   ;==>DeleteExcessTroops
