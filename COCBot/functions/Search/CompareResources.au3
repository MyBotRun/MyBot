; #FUNCTION# ====================================================================================================================
; Name ..........: CompareResources
; Description ...: Compaires Resources while searching for a village to attack
; Syntax ........: CompareResources()
; Parameters ....:
; Return values .: True if compaired resources match the search conditions, False if not
; Author ........: (2014)
; Modified ......: AtoZ, Hervidero (2015), kaganus (June 2015, August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: VillageSearch, GetResources
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CompareResources($pMode) ;Compares resources and returns true if conditions meet, otherwise returns false
	If $g_bSearchReductionEnable Then
		If ($iChkEnableAfter[$pMode] = 0 And $SearchCount <> 0 And Mod($SearchCount, $g_iSearchReductionCount) = 0) Or ($iChkEnableAfter[$pMode] = 1 And $SearchCount - $g_aiSearchSearchesMin[$pMode] > 0 And Mod($SearchCount - $g_aiSearchSearchesMin[$pMode], $g_iSearchReductionCount) = 0) Then
			If $iAimGold[$pMode] - $g_iSearchReductionGold >= 0 Then $iAimGold[$pMode] -= $g_iSearchReductionGold
			If $iAimElixir[$pMode] - $g_iSearchReductionElixir >= 0 Then $iAimElixir[$pMode] -= $g_iSearchReductionElixir
			If $iAimDark[$pMode] - $g_iSearchReductionDark >= 0 Then $iAimDark[$pMode] -= $g_iSearchReductionDark
			If $iAimTrophy[$pMode] - $g_iSearchReductionTrophy >= 0 Then $iAimTrophy[$pMode] -= $g_iSearchReductionTrophy
			If $iAimGoldPlusElixir[$pMode] - $g_iSearchReductionGoldPlusElixir >= 0 Then $iAimGoldPlusElixir[$pMode] -= $g_iSearchReductionGoldPlusElixir

			Local $txtTrophies = "", $txtTownhall = ""
			if $g_abFilterMeetTrophyEnable[$pMode] Then $txtTrophies =  " [T]:" & StringFormat("%2s", $iAimTrophy[$pMode])
			If $g_abFilterMeetTH[$pMode] Then $txtTownhall = " [TH]:" & StringFormat("%2s", $iMaxTH[$pMode]) ;$g_aiFilterMeetTHMin
			If $g_abFilterMeetTHOutsideEnable[$pMode] Then $txtTownhall &= ", Out"
			If $g_aiFilterMeetGE[$pMode] = 2 Then
				SetLog("Aim:           [G+E]:" & StringFormat("%7s", $iAimGoldPlusElixir[$pMode]) & " [D]:" & StringFormat("%5s", $iAimDark[$pMode]) &  $txtTrophies & $txtTownhall & " for: " & $g_asModeText[$pMode], $COLOR_SUCCESS, "Lucida Console", 7.5)
			Else
				SetLog("Aim: [G]:" & StringFormat("%7s", $iAimGold[$pMode]) & " [E]:" & StringFormat("%7s", $iAimElixir[$pMode]) & " [D]:" & StringFormat("%5s", $iAimDark[$pMode]) & $txtTrophies & $txtTownhall &  " for: " & $g_asModeText[$pMode], $COLOR_SUCCESS, "Lucida Console", 7.5)
			EndIf
		EndIf
	EndIf

	Local $G = (Number($searchGold) >= Number($iAimGold[$pMode])), $E = (Number($searchElixir) >= Number($iAimElixir[$pMode])), $D = (Number($searchDark) >= Number($iAimDark[$pMode])), $T = (Number($searchTrophy) >= Number($iAimTrophy[$pMode])), $GPE = ((Number($searchGold) + Number($searchElixir)) >= Number($iAimGoldPlusElixir[$pMode]))







	If $g_abFilterMeetOneConditionEnable[$pMode] Then
		;		If $iChkWeakBase[$pMode] = 1 Then
		;			If $bIsWeakBase Then Return True
		;		EndIf

		If $g_aiFilterMeetGE[$pMode] = 0 Then
			If $G = True And $E = True Then Return True
		EndIf

		If $g_abFilterMeetDEEnable[$pMode] Then
			If $D = True Then Return True
		EndIf

		If $g_abFilterMeetTrophyEnable[$pMode] Then
			If $T = True Then Return True
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 1 Then
			If $G = True Or $E = True Then Return True
		EndIf



		If $g_aiFilterMeetGE[$pMode] = 2 Then
			If $GPE = True Then Return True
		EndIf

		Return False
	Else
		;		If $iChkWeakBase[$pMode] = 1 Then
		;			If Not $bIsWeakBase Then Return False
		;		EndIf

		If $g_aiFilterMeetGE[$pMode] = 0 Then
			If $G = False Or $E = False Then Return False
		EndIf

		If $g_abFilterMeetDEEnable[$pMode] Then
			If $D = False Then Return False
		EndIf

		If $g_abFilterMeetTrophyEnable[$pMode] Then
			If $T = False Then Return False
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 1 Then
			If $G = False And $E = False Then Return False
		EndIf



		If $g_aiFilterMeetGE[$pMode] = 2 Then
			If $GPE = False Then Return False
			;SetLog("[G + E]:" & StringFormat("%7s", $searchGold + $searchElixir), $COLOR_SUCCESS, "Lucida Console", 7.5)
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
	If $THL > -1 And $THL <= $g_iAtkTBMaxTHLevel And $searchTH <> "-" Then $SearchTHLResult = 1
	If $g_abFilterMeetOneConditionEnable[$pMode] Then
		If $g_abFilterMeetTH[$pMode] Then
			If $THL <> -1 And $THL <= $g_aiFilterMeetTHMin[$pMode] Then Return True
		EndIf

		If $g_abFilterMeetTHOutsideEnable[$pMode] Then
			If $THLO = 1 Then Return True
		EndIf
		Return False
	Else
		If $g_abFilterMeetTH[$pMode] Then
			If $THL = -1 Or $THL > $g_aiFilterMeetTHMin[$pMode] Then Return False
		EndIf

		If $g_abFilterMeetTHOutsideEnable[$pMode] Then
			If $THLO <> 1 Then Return False
		EndIf

	EndIf
	Return True
EndFunc