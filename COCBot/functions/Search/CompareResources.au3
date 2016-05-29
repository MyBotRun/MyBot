; #FUNCTION# ====================================================================================================================
; Name ..........: CompareResources
; Description ...: Compaires Resources while searching for a village to attack
; Syntax ........: CompareResources()
; Parameters ....:
; Return values .: True if compaired resources match the search conditions, False if not
; Author ........: (2014)
; Modified ......: AtoZ, Hervidero (2015), kaganus (June 2015, August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: VillageSearch, GetResources
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CompareResources($pMode) ;Compares resources and returns true if conditions meet, otherwise returns false
	If $iChkSearchReduction = 1 Then
		If ($iChkEnableAfter[$pMode] = 0 And $SearchCount <> 0 And Mod($SearchCount, $ReduceCount) = 0) Or ($iChkEnableAfter[$pMode] = 1 And $SearchCount - $iEnableAfterCount[$pMode] > 0 And Mod($SearchCount - $iEnableAfterCount[$pMode], $ReduceCount) = 0) Then
			If $iAimGold[$pMode] - $ReduceGold >= 0 Then $iAimGold[$pMode] -= $ReduceGold
			If $iAimElixir[$pMode] - $ReduceElixir >= 0 Then $iAimElixir[$pMode] -= $ReduceElixir
			If $iAimDark[$pMode] - $ReduceDark >= 0 Then $iAimDark[$pMode] -= $ReduceDark
			If $iAimTrophy[$pMode] - $ReduceTrophy >= 0 Then $iAimTrophy[$pMode] -= $ReduceTrophy
			If $iAimGoldPlusElixir[$pMode] - $ReduceGoldPlusElixir >= 0 Then $iAimGoldPlusElixir[$pMode] -= $ReduceGoldPlusElixir

			If $iCmbMeetGE[$pMode] = 2 Then
				SetLog("Aim:           [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$pMode]) & " [D]:" & StringFormat("%5s", $iAimDark[$pMode]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$pMode]) & $iAimTHtext[$pMode] & " for: " & $sModeText[$pMode], $COLOR_GREEN, "Lucida Console", 7.5)
			Else
				SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$pMode]) & " [E]:" & StringFormat("%7s", $iAimElixir[$pMode]) & " [D]:" & StringFormat("%5s", $iAimDark[$pMode]) & " [T]:" & StringFormat("%2s", $iAimTrophy[$pMode]) & $iAimTHtext[$pMode] & " for: " & $sModeText[$pMode], $COLOR_GREEN, "Lucida Console", 7.5)
			EndIf
		EndIf
	EndIf

	Local $G = (Number($searchGold) >= Number($iAimGold[$pMode])), $E = (Number($searchElixir) >= Number($iAimElixir[$pMode])), $D = (Number($searchDark) >= Number($iAimDark[$pMode])), $T = (Number($searchTrophy) >= Number($iAimTrophy[$pMode])), $GPE = ((Number($searchGold) + Number($searchElixir)) >= Number($iAimGoldPlusElixir[$pMode]))







	If $iChkMeetOne[$pMode] = 1 Then
		;		If $iChkWeakBase[$pMode] = 1 Then
		;			If $bIsWeakBase Then Return True
		;		EndIf

		If $iCmbMeetGE[$pMode] = 0 Then
			If $G = True And $E = True Then Return True
		EndIf

		If $iChkMeetDE[$pMode] = 1 Then
			If $D = True Then Return True
		EndIf

		If $iChkMeetTrophy[$pMode] = 1 Then
			If $T = True Then Return True
		EndIf

		If $iCmbMeetGE[$pMode] = 1 Then
			If $G = True Or $E = True Then Return True
		EndIf



		If $iCmbMeetGE[$pMode] = 2 Then
			If $GPE = True Then Return True
		EndIf

		Return False
	Else
		;		If $iChkWeakBase[$pMode] = 1 Then
		;			If Not $bIsWeakBase Then Return False
		;		EndIf

		If $iCmbMeetGE[$pMode] = 0 Then
			If $G = False Or $E = False Then Return False
		EndIf

		If $iChkMeetDE[$pMode] = 1 Then
			If $D = False Then Return False
		EndIf

		If $iChkMeetTrophy[$pMode] = 1 Then
			If $T = False Then Return False
		EndIf

		If $iCmbMeetGE[$pMode] = 1 Then
			If $G = False And $E = False Then Return False
		EndIf



		If $iCmbMeetGE[$pMode] = 2 Then
			If $GPE = False Then Return False
			;SetLog("[G + E]:" & StringFormat("%7s", $searchGold + $searchElixir), $COLOR_GREEN, "Lucida Console", 7.5)
		EndIf
	EndIf

	Return True
EndFunc   ;==>CompareResources

Func CompareTH($pMode)
	Local $THL = -1, $THLO = -1

	For $i = 0 To 5 ;add th11
		If $searchTH = $THText[$i] Then $THL = $i
	Next

	Switch $THLoc
		Case "In"
			$THLO = 0
		Case "Out"
			$THLO = 1
	EndSwitch
	$SearchTHLResult = 0
	If $THL > -1 And $THL <= $YourTH And $searchTH <> "-" Then $SearchTHLResult = 1
	If $iChkMeetOne[$pMode] = 1 Then
		If $iChkMeetTH[$pMode] = 1 Then
			If $THL <> -1 And $THL <= $iCmbTH[$pMode] Then Return True
		EndIf

		If $iChkMeetTHO[$pMode] = 1 Then
			If $THLO = 1 Then Return True
		EndIf
		Return False
	Else
		If $iChkMeetTH[$pMode] = 1 Then
			If $THL = -1 Or $THL > $iCmbTH[$pMode] Then Return False
		EndIf

		If $iChkMeetTHO[$pMode] = 1 Then
			If $THLO <> 1 Then Return False
		EndIf

	EndIf
	Return True
EndFunc