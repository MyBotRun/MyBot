
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmySpellCount
; Description ...: Obtains count of spells available from Training - Army Overview window
; Syntax ........: getArmySpellCount()
; Parameters ....:
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

	If $iTotalCountSpell > 0 or $test = True Then ; only use this code if the user had input spells to brew ... and assign the spells quantity

		$CurLightningSpell = 0 ; reset Global variables
		$CurHealSpell = 0
		$CurRageSpell = 0
		$CurJumpSpell = 0
		$CurFreezeSpell = 0
		$CurPoisonSpell = 0
		$CurHasteSpell = 0
		$CurEarthSpell = 0

		$CurTotalSpell = True

		For $i = 0 To 4 ; 5 visible slots in ArmyoverView window
			If $debugsetlogTrain = 1 Then Setlog(" Slot : " & $i + 1, $COLOR_PURPLE)
			Local $FullTemp = getOcrSpellDetection(125 + (62 * $i), 450 + $midOffsetY)
			If $debugsetlogTrain = 1 Then Setlog(" getOcrSpellDetection: " & $FullTemp, $COLOR_PURPLE)
			Local $Result = getOcrSpellQuantity(146 + (62 * $i), 414 + $midOffsetY)
			Local $SpellQ = StringReplace($Result, "x", "")
			If $debugsetlogTrain = 1 Then Setlog(" getOcrSpellQuantity: " & $SpellQ, $COLOR_PURPLE)
			If $FullTemp = "Lightning" Then
				$CurLightningSpell = $SpellQ
				Setlog(" - No. of Lightning Spells: " & $SpellQ)
			EndIf
			If $FullTemp = "Heal" Then
				$CurHealSpell = $SpellQ
				Setlog(" - No. of Heal Spells: " & $SpellQ)
			EndIf
			If $FullTemp = "Rage" Then
				$CurRageSpell = $SpellQ
				Setlog(" - No. of Rage Spells: " & $SpellQ)
			EndIf
			If $FullTemp = "Jump" Then
				$CurJumpSpell = $SpellQ
				Setlog(" - No. of Jump Spells: " & $SpellQ)
			EndIf
			If $FullTemp = "Freeze" Then
				$CurFreezeSpell = $SpellQ
				Setlog(" - No. of Freeze Spells: " & $SpellQ)
			EndIf
			If $FullTemp = "Poison" Then
				$CurPoisonSpell = $SpellQ
				Setlog(" - No. of Poison Spells: " & $SpellQ)
			EndIf
			If $FullTemp = "Haste" Then
				$CurHasteSpell = $SpellQ
				Setlog(" - No. of Haste Spells: " & $SpellQ)
			EndIf
			If $FullTemp = "Earth" Then
				$CurEarthSpell = $SpellQ
				Setlog(" - No. of Earthquake Spells: " & $SpellQ)
			EndIf
			If $FullTemp = "" And $debugsetlogTrain = 1 Then
				Setlog(" - was not detected anything in slot: " & $i + 1, $COLOR_PURPLE)
			EndIf
		Next
	EndIf

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
		   $CurPoisonSpell + _
		   $CurHasteSpell + _
		   $CurEarthSpell
EndFunc   ;==>GetCurTotalSpell
