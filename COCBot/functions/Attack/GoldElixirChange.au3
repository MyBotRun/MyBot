;==========================================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: GoldElixirChange
; Description....: Checks if the gold/elixir changes values within 20 seconds, Returns True if changed. Also
; 					    checks every 5 seconds if gold/elixir = "", meaning battle is over. If either condition is met, return
; 					    false
; Syntax ........: GoldElixirChange()
; Parameters ....:
; Return values .: None
; Author ........: Samota,
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Notes: If all troops are used, the battle will end when they are all dead, the timer runs out, or the
; base has been 3-starred. When the battle ends, it is detected within 5 seconds, otherwise it takes up
; to 20 seconds.

Func GoldElixirChange()
	Local $Gold1, $Gold2
	Local $GoldChange, $ElixirChange
	Local $Elixir1, $Elixir2
	SetLog("Checking if the battle has finished", $COLOR_BLUE)
	While 1
		$Gold1 = getGoldVillageSearch(48, 69)
		$Elixir1 = getElixirVillageSearch(48, 69 + 29)

		Local $iBegin = TimerInit(), $x = $sTimeStopAtk * 1000
		While TimerDiff($iBegin) < $x
			CheckHeroesHealth()
			If $checkKPower Or $checkQPower Then
				If _Sleep($iDelayGoldElixirChange1) Then Return
			Else
				If _Sleep($iDelayGoldElixirChange2) Then Return
			EndIf

			$Gold2 = getGoldVillageSearch(48, 69)

			If $Gold2 = "" Then
				If _Sleep($iDelayGoldElixirChange1) Then Return
				$Gold2 = getGoldVillageSearch(48, 69)
			EndIf
			$Elixir2 = getElixirVillageSearch(48, 69 + 29)


			If $Gold2 <> "" Or $Elixir2 <> "" Then
				$GoldChange = $Gold2
				$ElixirChange = $Elixir2
			EndIf

			If ($Gold2 = "" And $Elixir2 = "") Then
				If _Sleep($iDelayGoldElixirChange1) Then Return

				If getGoldVillageSearch(48, 69) = "" And getElixirVillageSearch(48, 69 + 29) = "" Then
					SetLog("Battle has finished", $COLOR_GREEN)
					ExitLoop
				EndIf


			EndIf
			;If (GUICtrlRead($cmbBoostBarracks) > 0) And ($boostsEnabled = 1) Then $x = $sTimeStopAtk*1000
		WEnd
		If ($Gold1 = $Gold2 And $Elixir1 = $Elixir2) Or ($Gold2 = "" And $Elixir2 = "") Then
			GUICtrlSetData($lblresultvillagesattacked, GUICtrlRead($lblresultvillagesattacked) + 1)
			GUICtrlSetData($lblResultAttackedHourNow, GUICtrlRead($lblResultAttackedHourNow) + 1)
			Return False
		Else
			SetLog("Gold & Elixir change detected, waiting...", $COLOR_GREEN)
			Return True
		EndIf
		ExitLoop
	WEnd
EndFunc   ;==>GoldElixirChange

Func GoldElixirChangeThSnipes($x)
	Local $Gold1, $Gold2
	Local $GoldChange, $ElixirChange
	Local $Elixir1, $Elixir2

	SetLog("Checking if the Gold6Elixir are changing...", $COLOR_BLUE)

	For $y = 0 to $x
		$Gold1 = getGoldVillageSearch(48, 69)
		$Elixir1 = getElixirVillageSearch(48, 69 + 29)

		Local $iBegin = TimerInit()

		While TimerDiff($iBegin) < 2000
			CheckHeroesHealth()
			If $checkKPower Or $checkQPower Then
				If _Sleep($iDelayGoldElixirChange1) Then Return
			Else
				If _Sleep($iDelayGoldElixirChange2) Then Return
			EndIf

			$Gold2 = getGoldVillageSearch(48, 69)

			If $Gold2 = "" Then
				If _Sleep($iDelayGoldElixirChange1) Then Return
				$Gold2 = getGoldVillageSearch(48, 69)
			EndIf
			$Elixir2 = getElixirVillageSearch(48, 69 + 29)


			If $Gold2 <> "" Or $Elixir2 <> "" Then
				$GoldChange = $Gold2
				$ElixirChange = $Elixir2
			EndIf

			If ($Gold2 = "" And $Elixir2 = "") Then
				If _Sleep($iDelayGoldElixirChange1) Then Return

				If getGoldVillageSearch(48, 69) = "" And getElixirVillageSearch(48, 69 + 29) = "" Then
					SetLog("Battle has finished", $COLOR_GREEN)
					ExitLoop
				EndIf
			EndIf

		WEnd
		If ($Gold1 = $Gold2 And $Elixir1 = $Elixir2) Or ($Gold2 = "" And $Elixir2 = "") Then
			ExitLoop
		Else
			SetLog("Gold & Elixir change detected, waiting...", $COLOR_GREEN)
			ContinueLoop
		EndIf
		$x +=1
		If Sleep(1000) then return
	Next
EndFunc   ;==>GoldElixirChange
