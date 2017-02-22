
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroopCount
; Description ...: Reads current quanitites/type of troops from Training - Army Overview window, updates $CurXXXX and $aDTtroopsToBeUsed values
; Syntax ........: getArmyTroopCount()
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func getArmyTroopCount($bOpenArmyWindow = False, $bCloseArmyWindow = False, $test = false)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getArmyTroopCount:", $COLOR_DEBUG1)

	If $test = false  Then
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
	Else
		Setlog("test")
	EndIf


	Local $FullTemp = ""
	Local $TroopQ = 0
	Local $TroopTypeT = ""

	_CaptureRegion2(120, 165 + $g_iMidOffsetY, 740, 220 + $g_iMidOffsetY)
	If $g_iDebugSetlog = 1 Then SetLog("$hHBitmap2 made", $COLOR_DEBUG)
	If _Sleep($iDelaycheckArmyCamp5) Then Return
	If $g_iDebugSetlogTrain = 1 Then SetLog("Calling MBRfunctions.dll/searchIdentifyTroopTrained ", $COLOR_DEBUG)

	$FullTemp = DllCall($g_hLibFunctions, "str", "searchIdentifyTroopTrained", "ptr", $hHBitmap2)
	If _Sleep($iDelaycheckArmyCamp6) Then Return ; 10ms improve pause button response
	If $g_iDebugSetlogTrain = 1 Then
		If IsArray($FullTemp) Then
			SetLog("Dll return $FullTemp :" & $FullTemp[0], $COLOR_DEBUG)
		Else
			SetLog("Dll return $FullTemp : ERROR" & $FullTemp, $COLOR_DEBUG)
		EndIf
	EndIf

	If IsArray($FullTemp) Then
		$TroopTypeT = StringSplit($FullTemp[0], "|")
	EndIf

	If $g_iDebugSetlogTrain = 1 Then
		If IsArray($TroopTypeT) Then
			SetLog("$Trooptype split # : " & $TroopTypeT[0], $COLOR_DEBUG)
		Else
			SetLog("$Trooptype split # : ERROR " & $TroopTypeT, $COLOR_DEBUG)
		EndIf
	EndIf
	If $g_iDebugSetlogTrain = 1 Then SetLog("Start the Loop", $COLOR_DEBUG)

	For $i = 0 To UBound($g_asTroopName) - 1 ; Reset the variables
		$g_aiSlotInArmy[$i] = -1
	Next

	For $i = 0 To UBound($aDTtroopsToBeUsed, 1) - 1 ; Reset the variables
		$aDTtroopsToBeUsed[$i][1] = 0
	Next

	If IsArray($TroopTypeT) And $TroopTypeT[1] <> "" Then

		For $i = 1 To $TroopTypeT[0]

			$TroopQ = "0"
			If _sleep($iDelaycheckArmyCamp1) Then Return
			Local $Troops = StringSplit($TroopTypeT[$i], "#", $STR_NOCOUNT)
			If $g_iDebugSetlogTrain = 1 Then SetLog("$TroopTypeT[$i] split : " & $i, $COLOR_DEBUG)

			If IsArray($Troops) And $Troops[0] <> "" Then

				If $Troops[0] = $eBarb Then
					$TroopQ = $Troops[2]
					$aDTtroopsToBeUsed[0][1] = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eBarb) Then
						$CurBarb = -($TroopQ)
						$g_aiSlotInArmy[$eTroopBarbarian] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eArch Then
					$TroopQ = $Troops[2]
					$aDTtroopsToBeUsed[1][1] = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eArch) Then
						$CurArch = -($TroopQ)
						$g_aiSlotInArmy[$eTroopArcher] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eGiant Then
					$TroopQ = $Troops[2]
					$aDTtroopsToBeUsed[2][1] = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eGiant) Then
						$CurGiant = -($TroopQ)
						$g_aiSlotInArmy[$eTroopGiant] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eGobl Then
					$TroopQ = $Troops[2]
					$aDTtroopsToBeUsed[4][1] = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eGobl) Then
						$CurGobl = -($TroopQ)
						$g_aiSlotInArmy[$eTroopGoblin] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eWall Then
					$TroopQ = $Troops[2]
					$aDTtroopsToBeUsed[3][1] = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eWall) Then
						$CurWall = -($TroopQ)
						$g_aiSlotInArmy[$eTroopWallBreaker] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eBall Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eBall) Then
						$CurBall = -($TroopQ)
						$g_aiSlotInArmy[$eTroopBalloon] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eHeal Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eHeal) Then
						$CurHeal = -($TroopQ)
						$g_aiSlotInArmy[$eTroopHealer] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eWiza Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eWiza) Then
						$CurWiza = -($TroopQ)
						$g_aiSlotInArmy[$eTroopWizard] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eDrag Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eDrag) Then
						$CurDrag = -($TroopQ)
						$g_aiSlotInArmy[$eTroopDragon] = $i - 1
					EndIf

				ElseIf $Troops[0] = $ePekk Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($ePekk) Then
						$CurPekk = -($TroopQ)
						$g_aiSlotInArmy[$eTroopPekka] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eBabyD Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eBabyD) Then
						$CurBabyD = -($TroopQ)
						$g_aiSlotInArmy[$eTroopBabyDragon] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eMine Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eMine) Then
						$CurMine = -($TroopQ)
						$g_aiSlotInArmy[$eTroopMiner] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eMini Then
					$TroopQ = $Troops[2]
					$aDTtroopsToBeUsed[5][1] = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eMini) Then
						$CurMini = -($TroopQ)
						$g_aiSlotInArmy[$eTroopMinion] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eHogs Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eHogs) Then
						$CurHogs = -($TroopQ)
						$g_aiSlotInArmy[$eTroopHogRider] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eValk Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eValk) Then
						$CurValk = -($TroopQ)
						$g_aiSlotInArmy[$eTroopValkyrie] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eGole Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eGole) Then
						$CurGole = -($TroopQ)
						$g_aiSlotInArmy[$eTroopGolem] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eWitc Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eWitc) Then
						$CurWitc = -($TroopQ)
						$g_aiSlotInArmy[$eTroopWitch] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eLava Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eLava) Then
						$CurLava = -($TroopQ)
						$g_aiSlotInArmy[$eTroopLavaHound] = $i - 1
					EndIf

				ElseIf $Troops[0] = $eBowl Then
					$TroopQ = $Troops[2]
					If $g_bFirstStart Or $fullArmy Or IsTroopToDonateOnly($eBowl) Then
						$CurBowl = -($TroopQ)
						$g_aiSlotInArmy[$eTroopBowler] = $i - 1
					EndIf

				EndIf
				Local $Plural = 0
				If $TroopQ > 1 then $Plural = 1
				If $TroopQ <> 0 Then SetLog(" - No. of " & NameOfTroop($Troops[0], $Plural) & ": " & $TroopQ)

			EndIf
		Next

	EndIf

	If Not $fullArmy And $g_bFirstStart Then
		$ArmyComp = $CurCamp
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmyTroopCount
