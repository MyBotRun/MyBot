; #FUNCTION# ====================================================================================================================
; Name ..........: isElixirFull
; Description ...: Checks if your Elixir Storages are maxed out
; Syntax ........: isElixirFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #34 (yes, the good looking one!)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isElixirFull()
	Local $aElixirFull = _FullResPixelSearch($aIsElixirFull[0], $aIsElixirFull[0] + 4, $aIsElixirFull[1], 1, Hex(0x0D0D0D, 6), $aIsElixirFull[2], $aIsElixirFull[3])
	If IsArray($aElixirFull) Then
		SetLog("Elixir Storages are full!", $COLOR_SUCCESS)
		$g_abFullStorage[$eLootElixir] = True
	ElseIf $g_abFullStorage[$eLootElixir] Then
		If Number($g_aiCurrentLoot[$eLootElixir]) >= Number($g_aiResumeAttackLoot[$eLootElixir]) Then
			SetLog("Elixir Storages is relatively full: " & $g_aiCurrentLoot[$eLootElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootElixir] = True
		Else
			SetLog("Switching back to normal when Elixir drops below " & $g_aiResumeAttackLoot[$eLootElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootElixir] = False
		EndIf
	EndIf
	Return $g_abFullStorage[$eLootElixir]
EndFunc   ;==>isElixirFull
