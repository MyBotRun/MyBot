; #FUNCTION# ====================================================================================================================
; Name ..........:AmountOfResourcesInStructure.au3
; Description ...:Checks if a structure contains more resources than the level set in GUI
; Syntax ........:AmountOfResourcesInStructure($type, $coordinate, $level)
; Parameters ....:$type("elixir", "mine", or "drill"), $coordinate(array), $level(integer)
; Return values .:True or False
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func AmountOfResourcesInStructure($type, $coordinate, $level)
	Switch $type
		Case "elixir"
			If $level <= 8 And $level >= 0 Then
				Local $temp = Int($MilkFarmElixirParam[$level])
				If $temp > 0 Then
					If $MilkAttackType = 0 Then
						;detect amount of resource in structure and check with settings
						Local $capacity = DetectAmountOfResourceInStructure($type, $coordinate, $level, $temp)
						If $capacity >= $temp Then
							If $debugsetlog=1 Then Setlog("elixir " & $type & " " & $coordinate & " " & $level & " " & $capacity ,$color_purple)
							Return True
						Else
							If $debugsetlog = 1 Then Setlog("Discard, capacity of structure under settings:  liv " & $level & " cap " & $temp  & " detected "& $capacity, $color_purple)
						EndIf
					Else
						;do not run check of amount of elixir in structure but accept (low cpu)
						If $debugsetlog=1 Then Setlog("elixir " & $type & " " & $coordinate & " " & $level & " PASSED LOW CPU SETTINGS" ,$color_purple)
						Return True
					EndIf
				Else
					If $debugsetlog = 1 Then Setlog("Discard, level settings discard this structure (requested min. " & Int($MilkFarmElixirParam[$level]) & ")", $color_purple)
				EndIf
			Else
				If $debugsetlog = 1 Then Setlog("Discard, out of bounds", $color_purple)
			EndIf
			Return False
		Case "mine"
			If $level <= 8 And $level >= 0 Then
				If $level >= $MilkFarmMineParam Then
					Return True
				Else
					If $debugsetlog = 1 Then Setlog("Discard, level settings discard this structure (level=" & $level & ",filter=" & $MilkFarmMineParam & ")", $color_purple)
				EndIf
			Else
				If $debugsetlog = 1 Then Setlog("Discard, out of bounds", $color_purple)
			EndIf
			Return False
		Case "drill"
			If $level <= 6 And $level >= 1 Then
				If $level >= $MilkFarmDrillParam Then
					Return True
				Else
					If $debugsetlog = 1 Then Setlog("Discard, level settings discard this structure (level=" & $level & ",filter=" & $MilkFarmDrillParam & ")", $color_purple)
				EndIf
			Else
				If $debugsetlog = 1 Then Setlog("Discard, out of bounds", $color_purple)
			EndIf
			Return False
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>AmountOfResourcesInStructure
