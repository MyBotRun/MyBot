; #FUNCTION# ====================================================================================================================
; Name ..........:AmountOfResourcesInStructure.au3
; Description ...:Checks if a structure contains more resources than the level set in GUI
; Syntax ........:AmountOfResourcesInStructure($type, $coordinate, $level)
; Parameters ....:$type("elixir", "mine", or "drill"), $coordinate(array), $level(integer)
; Return values .:True or False
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func AmountOfResourcesInStructure($type, $coordinate, $level)
	Switch $type
		Case "elixir"
			If $level <= 8 And $level >= 0 Then
				Local $temp = Int($g_aiMilkFarmElixirParam[$level])
				If $temp > 0 Then
					If $g_iMilkAttackType = 0 Then
						;detect amount of resource in structure and check with settings
						Local $capacity = DetectAmountOfResourceInStructure($type, $coordinate, $level, $temp)
						If $capacity >= $temp Then
							If $g_bDebugSetlog Then SetDebugLog("elixir " & $type & " " & $coordinate & " " & $level & " " & $capacity, $COLOR_DEBUG)
							Return True
						Else
							If $g_bDebugSetlog Then SetDebugLog("Discard, capacity of structure under settings:  liv " & $level & " cap " & $temp & " detected " & $capacity, $COLOR_DEBUG)
						EndIf
					Else
						;do not run check of amount of elixir in structure but accept (low cpu)
						If $g_bDebugSetlog Then SetDebugLog("elixir " & $type & " " & $coordinate & " " & $level & " PASSED LOW CPU SETTINGS", $COLOR_DEBUG)
						Return True
					EndIf
				Else
					If $g_bDebugSetlog Then SetDebugLog("Discard, level settings discard this structure (requested min. " & Int($g_aiMilkFarmElixirParam[$level]) & ")", $COLOR_DEBUG)
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("Discard, out of bounds", $COLOR_DEBUG)
			EndIf
			Return False
		Case "mine"
			If $level <= 8 And $level >= 0 Then
				If $level >= $g_iMilkFarmMineParam Then
					Return True
				Else
					If $g_bDebugSetlog Then SetDebugLog("Discard, level settings discard this structure (level=" & $level & ",filter=" & $g_iMilkFarmMineParam & ")", $COLOR_DEBUG)
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("Discard, out of bounds", $COLOR_DEBUG)
			EndIf
			Return False
		Case "drill"
			If $level <= 6 And $level >= 1 Then
				If $level >= $g_iMilkFarmDrillParam Then
					Return True
				Else
					If $g_bDebugSetlog Then SetDebugLog("Discard, level settings discard this structure (level=" & $level & ",filter=" & $g_iMilkFarmDrillParam & ")", $COLOR_DEBUG)
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("Discard, out of bounds", $COLOR_DEBUG)
			EndIf
			Return False
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>AmountOfResourcesInStructure
