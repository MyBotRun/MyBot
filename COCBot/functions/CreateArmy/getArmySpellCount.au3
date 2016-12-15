
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

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SETLOG("Begin getArmySpellCount:", $COLOR_DEBUG1)

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

		$CurLSpell = 0 ; reset Global variables
		$CurHSpell = 0
		$CurRSpell = 0
		$CurJSpell = 0
		$CurFSpell = 0
		$CurCSpell = 0
		$CurPSpell = 0
		$CurHSpell = 0
		$CurESpell = 0
		$CurSkSpell = 0
		$CurTotalSpell = True

		For $i = 0 To 4 ; 5 visible slots in ArmyOverView window
			If $debugsetlogTrain = 1 Then Setlog(" Slot : " & $i + 1, $COLOR_DEBUG)
			$FullTemp = getOcrSpellDetection(125 + (62 * $i), 450 + $midOffsetY)
			If $debugsetlogTrain = 1 Then Setlog(" getOcrSpellDetection: " & $FullTemp, $COLOR_DEBUG)
			If _Sleep($iDelayRespond) Then Return
			$Result = getOcrSpellQuantity(146 + (62 * $i), 414 + $midOffsetY)
			If $Result <> "" Then
				$SpellQ = Int(StringReplace($Result, "x", ""))
			Else
				$SpellQ = 0
			EndIf
			If $debugsetlogTrain = 1 Then Setlog(" getOcrSpellQuantity: " & $Result & ":" & $SpellQ, $COLOR_DEBUG)
			If _Sleep($iDelayRespond) Then Return
			Select
				Case $FullTemp = "Lightning"
					$CurLSpell = $SpellQ
					Setlog(" - No. of Lightning Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Heal"
					$CurHSpell = $SpellQ
					Setlog(" - No. of Heal Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Rage"
					$CurRSpell = $SpellQ
					Setlog(" - No. of Rage Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Jump"
					$CurJSpell = $SpellQ
					Setlog(" - No. of Jump Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Freeze"
					$CurFSpell = $SpellQ
					Setlog(" - No. of Freeze Spells: " & $SpellQ)
					$iTotalSpellSpace += (2 * $SpellQ)
				Case $FullTemp = "Clone"
					$CurCSpell = $SpellQ
					Setlog(" - No. of Clone Spells: " & $SpellQ)
					$iTotalSpellSpace += (4 * $SpellQ)
				Case $FullTemp = "Poison"
					$CurPSpell = $SpellQ
					Setlog(" - No. of Poison Spells: " & $SpellQ)
					$iTotalSpellSpace += $SpellQ
				Case $FullTemp = "Haste"
					$CurHSpell = $SpellQ
					Setlog(" - No. of Haste Spells: " & $SpellQ)
					$iTotalSpellSpace += $SpellQ
				Case $FullTemp = "Earth"
					$CurESpell = $SpellQ
					Setlog(" - No. of Earthquake Spells: " & $SpellQ)
					$iTotalSpellSpace += $SpellQ
				Case $FullTemp = "Skeleton"
					$CurSkSpell = $SpellQ
					Setlog(" - No. of Skeleton Spells: " & $SpellQ)
					$iTotalSpellSpace += $SpellQ
				Case $FullTemp = "" And $SpellQ > 0 ; prevent no search condition due problem with spell type detection
					Setlog(" warning: detected spell count but not type of spell " & $i + 1, $COLOR_WARNING)
					$iMissingSpellCount += $SpellQ
					$iMissingSpellEvent += 1
				Case $FullTemp = ""
					; Do nothing when empty slot
					If $debugsetlogTrain = 1 Then Setlog(" - detected nothing in slot: " & $i + 1, $COLOR_DEBUG)
				Case Else
					; Can only see this message when getOcrSpellDetection returns invalid spell type or something is broken
					Setlog(" - Code Monkey banana distracted, detection error slot: " & $i + 1, $COLOR_ERROR)
			EndSelect
		Next
	EndIf

	If $iMissingSpellEvent = 1 Then ; Check for single detection error, try to recover to avoid not attacking
		; add missing spell count times calculated spell space to TotalSpellSpace for "wait for spells" flag
		$iTotalSpellSpace += $iMissingSpellCount * Int(($CurSFactory - $iTotalSpellSpace) / $iMissingSpellCount)
	EndIf

	$bFullArmySpells = $iTotalSpellSpace >= $iTotalTrainSpaceSpell
	If $debugsetlogTrain = 1 Then SETLOG("$bFullArmySpells: " & $bFullArmySpells & ", $iTotalSpellSpace:$iTotalTrainSpaceSpell " & $iTotalSpellSpace & "|" & $iTotalTrainSpaceSpell, $COLOR_DEBUG)

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
	Return $CurLSpell + _
			$CurHSpell + _
			$CurRSpell + _
			$CurJSpell + _
			$CurFSpell + _
			$CurCSpell + _
			$CurPSpell + _
			$CurHSpell + _
			$CurSkSpell + _
			$CurESpell
EndFunc   ;==>GetCurTotalSpell

; #FUNCTION# ====================================================================================================================
; Name ..........: GetCurTotalDarkSpell
; Description ...: Returns total count of dark spells available after call to getArmySpellCount()
; Return values .: Total current spell count or -1 when not yet read
; ===============================================================================================================================
Func GetCurTotalDarkSpell()
	If $CurTotalSpell = False And $iTotalCountSpell > 0 Then Return -1
	Return $CurPSpell + _
			$CurHSpell + _
			$CurSkSpell + _
			$CurESpell
EndFunc   ;==>GetCurTotalDarkSpell
