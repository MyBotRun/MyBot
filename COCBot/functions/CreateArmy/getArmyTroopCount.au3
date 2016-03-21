
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroopCount
; Description ...: Reads current quanitites/type of troops from Training - Army Overview window, updates $CurXXXX and $aDTtroopsToBeUsed values
; Syntax ........: getArmyTroopCount()
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;

Global $SlotInArmyBarb = -1, $SlotInArmyArch = -1, $SlotInArmyGiant = -1, $SlotInArmyGobl = -1, $SlotInArmyWall = -1, $SlotInArmyBall = -1, $SlotInArmyWiza = -1, $SlotInArmyHeal = -1
Global $SlotInArmyMini = -1, $SlotInArmyHogs = -1, $SlotInArmyValk = -1, $SlotInArmyGole = -1, $SlotInArmyWitc = -1, $SlotInArmyLava = -1, $SlotInArmyDrag = -1, $SlotInArmyPekk = -1

Func getArmyTroopCount($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugSetlog = 1 Then SETLOG("Begin getArmyTroopCount:", $COLOR_PURPLE)

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


	Local $FullTemp = ""
	Local $TroopName = 0
	Local $TroopQ = 0
	Local $TroopTypeT = ""

	_CaptureRegion2(120, 165 + $midOffsetY, 740, 220 + $midOffsetY)
	If $debugSetlog = 1 Then SetLog("$hHBitmap2 made", $COLOR_PURPLE)
	If _Sleep($iDelaycheckArmyCamp5) Then Return
	If $debugSetlog = 1 Then SetLog("Calling MBRfunctions.dll/searchIdentifyTroopTrained ", $COLOR_PURPLE)

	$FullTemp = DllCall($hFuncLib, "str", "searchIdentifyTroopTrained", "ptr", $hHBitmap2)
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response
	If $debugSetlog = 1 Then
		If IsArray($FullTemp) Then
			SetLog("Dll return $FullTemp :" & $FullTemp[0], $COLOR_PURPLE)
		Else
			SetLog("Dll return $FullTemp : ERROR" & $FullTemp, $COLOR_PURPLE)
		EndIf
	EndIf

	If IsArray($FullTemp) Then
		$TroopTypeT = StringSplit($FullTemp[0], "|")
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

	For $i = 0 To UBound($aDTtroopsToBeUsed, 1) - 1 ; Reset the variables
		$aDTtroopsToBeUsed[$i][1] = 0
	Next

	If IsArray($TroopTypeT) And $TroopTypeT[1] <> "" Then

		For $i = 1 To $TroopTypeT[0]

			$TroopName = "Unknown"
			$TroopQ = "0"
			If _sleep($iDelaycheckArmyCamp1) Then Return
			Local $Troops = StringSplit($TroopTypeT[$i], "#", $STR_NOCOUNT)
			If $debugSetlog = 1 Then SetLog("$TroopTypeT[$i] split : " & $i, $COLOR_PURPLE)

			If IsArray($Troops) And $Troops[0] <> "" Then

				If $Troops[0] = $eBarb Then
					$TroopQ = $Troops[2]
					$TroopName = "Barbarians"
					$aDTtroopsToBeUsed[0][1] = $Troops[2]
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eBarb) Then
						$CurBarb = -($TroopQ)
						$SlotInArmyBarb = $i - 1
					EndIf

				ElseIf $Troops[0] = $eArch Then
					$TroopQ = $Troops[2]
					$TroopName = "Archers"
					$aDTtroopsToBeUsed[1][1] = $Troops[2]
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eArch) Then
						$CurArch = -($TroopQ)
						$SlotInArmyArch = $i - 1
					EndIf

				ElseIf $Troops[0] = $eGiant Then
					$TroopQ = $Troops[2]
					$TroopName = "Giants"
					$aDTtroopsToBeUsed[2][1] = $Troops[2]
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eGiant) Then
						$CurGiant = -($TroopQ)
						$SlotInArmyGiant = $i - 1
					EndIf

				ElseIf $Troops[0] = $eGobl Then
					$TroopQ = $Troops[2]
					$TroopName = "Goblins"
					$aDTtroopsToBeUsed[4][1] = $Troops[2]
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eGobl) Then
						$CurGobl = -($TroopQ)
						$SlotInArmyGobl = $i - 1
					EndIf

				ElseIf $Troops[0] = $eWall Then
					$TroopQ = $Troops[2]
					$TroopName = "Wallbreakers"
					$aDTtroopsToBeUsed[3][1] = $Troops[2]
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eWall) Then
						$CurWall = -($TroopQ)
						$SlotInArmyWall = $i - 1
					EndIf

				ElseIf $Troops[0] = $eBall Then
					$TroopQ = $Troops[2]
					$TroopName = "Balloons"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eBall) Then
						$CurBall = -($TroopQ)
						$SlotInArmyBall = $i - 1
					EndIf

				ElseIf $Troops[0] = $eHeal Then
					$TroopQ = $Troops[2]
					$TroopName = "Healers"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eHeal) Then
						$CurHeal = -($TroopQ)
						$SlotInArmyHeal = $i - 1
					EndIf

				ElseIf $Troops[0] = $eWiza Then
					$TroopQ = $Troops[2]
					$TroopName = "Wizards"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eWiza) Then
						$CurWiza = -($TroopQ)
						$SlotInArmyWiza = $i - 1
					EndIf

				ElseIf $Troops[0] = $eDrag Then
					$TroopQ = $Troops[2]
					$TroopName = "Dragons"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eDrag) Then
						$CurDrag = -($TroopQ)
						$SlotInArmyDrag = $i - 1
					EndIf

				ElseIf $Troops[0] = $ePekk Then
					$TroopQ = $Troops[2]
					$TroopName = "Pekkas"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($ePekk) Then
						$CurPekk = -($TroopQ)
						$SlotInArmyPekk = $i - 1
					EndIf

				ElseIf $Troops[0] = $eMini Then
					$TroopQ = $Troops[2]
					$TroopName = "Minions"
					$aDTtroopsToBeUsed[5][1] = $Troops[2]
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eMini) Then
						$CurMini = -($TroopQ)
						$SlotInArmyMini = $i - 1
					EndIf

				ElseIf $Troops[0] = $eHogs Then
					$TroopQ = $Troops[2]
					$TroopName = "Hog Riders"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eHogs) Then
						$CurHogs = -($TroopQ)
						$SlotInArmyHogs = $i - 1
					EndIf

				ElseIf $Troops[0] = $eValk Then
					$TroopQ = $Troops[2]
					$TroopName = "Valkyries"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eValk) Then
						$CurValk = -($TroopQ)
						$SlotInArmyValk = $i - 1
					EndIf

				ElseIf $Troops[0] = $eGole Then
					$TroopQ = $Troops[2]
					$TroopName = "Golems"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eGole) Then
						$CurGole = -($TroopQ)
						$SlotInArmyGole = $i - 1
					EndIf

				ElseIf $Troops[0] = $eWitc Then
					$TroopQ = $Troops[2]
					$TroopName = "Witches"
					If $FirstStart Or $fullArmy Or IsTroopToDonateOnly($eWitc) Then
						$CurWitc = -($TroopQ)
						$SlotInArmyWitc = $i - 1
					EndIf

				ElseIf $Troops[0] = $eLava Then
					$TroopQ = $Troops[2]
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

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmyTroopCount
