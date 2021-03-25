; #FUNCTION# ====================================================================================================================
; Name ..........: CompareResources
; Description ...: Compaires Resources while searching for a village to attack
; Syntax ........: CompareResources()
; Parameters ....:
; Return values .: True if compaired resources match the search conditions, False if not
; Author ........: (2014)
; Modified ......: AtoZ, Hervidero (2015), kaganus (June 2015, August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: VillageSearch, GetResources
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CompareResources($pMode) ;Compares resources and returns true if conditions meet, otherwise returns false
	If $g_bSearchReductionEnable Then
		If $g_iSearchCount <> 0 And Mod($g_iSearchCount, $g_iSearchReductionCount) = 0 Then
			If $g_iAimGold[$pMode] - $g_iSearchReductionGold >= 0 Then $g_iAimGold[$pMode] -= $g_iSearchReductionGold
			If $g_iAimElixir[$pMode] - $g_iSearchReductionElixir >= 0 Then $g_iAimElixir[$pMode] -= $g_iSearchReductionElixir
			If $g_iAimDark[$pMode] - $g_iSearchReductionDark >= 0 Then $g_iAimDark[$pMode] -= $g_iSearchReductionDark
			If $g_iAimTrophy[$pMode] - $g_iSearchReductionTrophy >= 0 Then $g_iAimTrophy[$pMode] -= $g_iSearchReductionTrophy
			If $g_iAimTrophyMax[$pMode] + $g_iSearchReductionTrophy < 99 Then $g_iAimTrophyMax[$pMode] += $g_iSearchReductionTrophy
			If $g_iAimGoldPlusElixir[$pMode] - $g_iSearchReductionGoldPlusElixir >= 0 Then $g_iAimGoldPlusElixir[$pMode] -= $g_iSearchReductionGoldPlusElixir

			Local $sTrophyText = "", $sTownhallText = ""
			If $g_abFilterMeetTrophyEnable[$pMode] Then $sTrophyText = " [T]:" & StringFormat("%2s", $g_iAimTrophy[$pMode]) & "-" & StringFormat("%2s", $g_iAimTrophyMax[$pMode])
			If $g_abFilterMeetTH[$pMode] Then $sTownhallText = " [TH]:" & StringFormat("%2s", $g_aiMaxTH[$pMode]) ;---
			If $g_abFilterMeetTHOutsideEnable[$pMode] Then $sTrophyText &= ", Out"
			If $g_aiFilterMeetGE[$pMode] = 2 Then
				SetLog("Aim:           [G+E]:" & StringFormat("%7s", $g_iAimGoldPlusElixir[$pMode]) & " [D]:" & StringFormat("%5s", $g_iAimDark[$pMode]) & $sTrophyText & $sTownhallText & " for: " & $g_asModeText[$pMode], $COLOR_SUCCESS, "Lucida Console", 7.5) ;---
			Else
				SetLog("Aim: [G]:" & StringFormat("%7s", $g_iAimGold[$pMode]) & " [E]:" & StringFormat("%7s", $g_iAimElixir[$pMode]) & " [D]:" & StringFormat("%5s", $g_iAimDark[$pMode]) & $sTrophyText & $sTownhallText & " for: " & $g_asModeText[$pMode], $COLOR_SUCCESS, "Lucida Console", 7.5) ;---
			EndIf
		EndIf
	EndIf

	Local $bGoldMet = (Number($g_iSearchGold) >= Number($g_iAimGold[$pMode])), $bElixirMet = (Number($g_iSearchElixir) >= Number($g_iAimElixir[$pMode]))
    Local $bDarkElixirMet = (Number($g_iSearchDark) >= Number($g_iAimDark[$pMode]))
    Local $bTrophiesMet = (Number($g_iSearchTrophy) >= Number($g_iAimTrophy[$pMode])) And (Number($g_iSearchTrophy) <= Number($g_iAimTrophyMax[$pMode]))
    Local $bGoldPlusElxirMet = ((Number($g_iSearchGold) + Number($g_iSearchElixir)) >= Number($g_iAimGoldPlusElixir[$pMode]))

	If $g_abFilterMeetOneConditionEnable[$pMode] Then
		If $g_aiFilterMeetGE[$pMode] = 0 Then
			If $bGoldMet And $bElixirMet Then Return True
		EndIf

		If $g_abFilterMeetDEEnable[$pMode] Then
			If $bDarkElixirMet Then Return True
		EndIf

		If $g_abFilterMeetTrophyEnable[$pMode] Then
			If $bTrophiesMet Then Return True
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 1 Then
			If $bGoldMet Or $bElixirMet Then Return True
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 2 Then
			If $bGoldPlusElxirMet Then Return True
		EndIf

		Return False
	Else
		If $g_aiFilterMeetGE[$pMode] = 0 Then
			If Not $bGoldMet Or Not $bElixirMet Then Return False
		EndIf

		If $g_abFilterMeetDEEnable[$pMode] Then
			If Not $bDarkElixirMet Then Return False
		EndIf

		If $g_abFilterMeetTrophyEnable[$pMode] Then
			If Not $bTrophiesMet Then Return False
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 1 Then
			If Not $bGoldMet And Not $bElixirMet Then Return False
		EndIf

		If $g_aiFilterMeetGE[$pMode] = 2 Then
			If Not $bGoldPlusElxirMet Then Return False
		EndIf
	EndIf

	Return True
EndFunc   ;==>CompareResources

Func CompareTH($pMode)
	Local $iTownhallLevel = -1, $iTownhallInOut = -1

	If $g_iSearchTH = 6 Then $g_iSearchTH = $g_asTHText[0]
	For $i = 1 To UBound($g_asTHText, 1) - 1
		If $g_iSearchTH = $g_asTHText[$i] Then $iTownhallLevel = $i
	Next

	Switch $g_sTHLoc
		Case "In"
			$iTownhallInOut = 0
		Case "Out"
			$iTownhallInOut = 1
	EndSwitch

	$g_iSearchTHLResult = 0

	If $iTownhallLevel > -1 And $iTownhallLevel <= $g_iAtkTBMaxTHLevel And $g_iSearchTH <> "-" Then $g_iSearchTHLResult = 1
	If $g_abFilterMeetOneConditionEnable[$pMode] Then
		If $g_abFilterMeetTH[$pMode] Then
			If $iTownhallLevel <> -1 And $iTownhallLevel <= $g_aiFilterMeetTHMin[$pMode] Then Return True
		EndIf

		If $g_abFilterMeetTHOutsideEnable[$pMode] Then
			If $iTownhallInOut = 1 Then Return True
		EndIf

		Return False
	Else
		If $g_abFilterMeetTH[$pMode] Then
			If $iTownhallLevel = -1 Or $iTownhallLevel > $g_aiFilterMeetTHMin[$pMode] Then Return False
		EndIf

		If $g_abFilterMeetTHOutsideEnable[$pMode] Then
			If $iTownhallInOut <> 1 Then Return False
		EndIf
	EndIf

	Return True
EndFunc   ;==>CompareTH
