
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmySpellCount
; Description ...: Obtains count of spells available from Training - Army Overview window
; Syntax ........: getArmySpellCount()
; Parameters ....:
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......: MonkeyHunter (06-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmySpellCount($bOpenArmyWindow = False, $bCloseArmyWindow = False, $test = False)

	If $debugsetlogTrain = 1 Then SETLOG("Begin getArmySpellCount:", $COLOR_PURPLE)

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

	Local $iTotalSpellSpace = 0, $iMissingSpellEvent = 0, $iMissingSpellCount = 0
	Local $SpellQ, $Result, $FullTemp

	If $iTotalCountSpell > 0 Or $test = True Then ; only use this code if the user had input spells to brew ... and assign the spells quantity

		$CurLightningSpell = 0 ; reset Global variables
		$CurHealSpell = 0
		$CurRageSpell = 0
		$CurJumpSpell = 0
		$CurFreezeSpell = 0
		$CurCloneSpell = 0
		$CurPoisonSpell = 0
		$CurHasteSpell = 0
		$CurEarthSpell = 0
		$CurSkeletonSpell = 0
		$CurTotalSpell = True

		For $i = 0 To 4 ; 5 visible slots in ArmyOverView window
			If $debugsetlogTrain = 1 Then Setlog(" Slot : " & $i + 1, $COLOR_PURPLE)
			$FullTemp = getOcrSpellDetection(125 + (62 * $i), 450 + $midOffsetY)
			If $debugsetlogTrain = 1 Then Setlog(" getOcrSpellDetection: " & $FullTemp, $COLOR_PURPLE)
			If _Sleep($iDelayRespond) Then Return
			$Result = getOcrSpellQuantity(146 + (62 * $i), 414 + $midOffsetY)
			If $Result <> "" Then
				$SpellQ = Int(StringReplace($Result, "x", ""))
			Else
				$SpellQ = 0
			EndIf
			If $debugsetlogTrain = 1 Then Setlog(" getOcrSpellQuantity: " & $Result & ":" & $SpellQ, $COLOR_PURPLE)
			If _Sleep($iDelayRespond) Then Return
			Select
				Case $FullTemp = "Lightning"
					$CurLightningSpell = $SpellQ
					Setlog(" - No. of Lightning Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Heal"
					$CurHealSpell = $SpellQ
					Setlog(" - No. of Heal Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Rage"
					$CurRageSpell = $SpellQ
					Setlog(" - No. of Rage Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Jump"
					$CurJumpSpell = $SpellQ
					Setlog(" - No. of Jump Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Freeze"
					$CurFreezeSpell = $SpellQ
					Setlog(" - No. of Freeze Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Clone"
					$CurCloneSpell = $SpellQ
					Setlog(" - No. of Clone Spells: " & $SpellQ)
					$iTotalSpellSpace += (4 * $SpellQ)
				Case $FullTemp = "Poison"
					$CurPoisonSpell = $SpellQ
					Setlog(" - No. of Poison Spells: " & $SpellQ)
					$iTotalSpellSpace += $SpellQ
				Case $FullTemp = "Haste"
					$CurHasteSpell = $SpellQ
					Setlog(" - No. of Haste Spells: " & $SpellQ)
					$iTotalSpellSpace += $SpellQ
				Case $FullTemp = "Earth"
					$CurEarthSpell = $SpellQ
					Setlog(" - No. of Earthquake Spells: " & $SpellQ)
					$iTotalSpellSpace += $SpellQ
				Case $FullTemp = "Skeleton"
					$CurSkeletonSpell = $SpellQ
					Setlog(" - No. of Skeleton Spells: " & $SpellQ)
					$iTotalSpellSpace += $SpellQ
				Case $FullTemp = "" And $SpellQ > 0 ; prevent no search condition due problem with spell type detection
					Setlog(" warning: detected spell count but not type of spell " & $i + 1, $COLOR_MAROON)
					$iMissingSpellCount += $SpellQ
					$iMissingSpellEvent += 1
				Case $FullTemp = ""
					; Do nothing when empty slot
					If $debugsetlogTrain = 1 Then Setlog(" - detected nothing in slot: " & $i + 1, $COLOR_PURPLE)
				Case Else
					; Can only see this message when getOcrSpellDetection returns invalid spell type or something is broken
					Setlog(" - Code Monkey banana distracted, detection error slot: " & $i + 1, $COLOR_RED)
			EndSelect
		Next
	EndIf

	If $iMissingSpellEvent = 1 Then ; Check for single detection error, try to recover to avoid not attacking
		; add missing spell count times calculated spell space to TotalSpellSpace for "wait for spells" flag
		$iTotalSpellSpace += $iMissingSpellCount * Int(($CurSFactory - $iTotalSpellSpace) / $iMissingSpellCount)
	EndIf

	$bFullArmySpells = $iTotalSpellSpace >= $iTotalTrainSpaceSpell
	If $debugsetlogTrain = 1 Then SETLOG("$bFullArmySpells: " & $bFullArmySpells & ", $iTotalSpellSpace:$iTotalTrainSpaceSpell " & $iTotalSpellSpace & "|" & $iTotalTrainSpaceSpell, $COLOR_PURPLE)

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmySpellCount

; #FUNCTION# ====================================================================================================================
; Name ..........: GetCurTotalSpell
; Description ...: Returns total count of spells available after call to getArmySpellCount()
; Return values .: Total current spell count or -1 when not yet read
; ===============================================================================================================================
Func GetCurTotalSpell()
	If $CurTotalSpell = False And $iTotalCountSpell > 0 Then Return -1
	Return $CurLightningSpell + _
			$CurHealSpell + _
			$CurRageSpell + _
			$CurJumpSpell + _
			$CurFreezeSpell + _
			$CurCloneSpell + _
			$CurPoisonSpell + _
			$CurHasteSpell + _
			$CurSkeletonSpell + _
			$CurEarthSpell
EndFunc   ;==>GetCurTotalSpell
