; #FUNCTION# ====================================================================================================================
; Name ..........: isDarkElixirFull
; Description ...: Checks if your Gold Storages are maxed out
; Syntax ........: isDarkElixirFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #57 (send more bananas please!)
; Modified ......: MonkeyHunter (2015-12)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isDarkElixirFull()

	If Not _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then Return ; check if the village have a Dark Elixir Storage

	Local $aDarkElixirFull = _FullResPixelSearch($aIsDarkElixirFull[0], $aIsDarkElixirFull[0] + 4, $aIsDarkElixirFull[1], 1, Hex(0x0D0D0D, 6), $aIsDarkElixirFull[2], $aIsDarkElixirFull[3])
	If IsArray($aDarkElixirFull) Then
		If _ColorCheck(_GetPixelColor($aDarkElixirFull[0] + 1, $aIsDarkElixirFull[1], $g_bCapturePixel), Hex($aIsDarkElixirFull[2], 6), $aIsDarkElixirFull[3]) Then
			SetLog("Dark Elixir Storage is full!", $COLOR_SUCCESS)
			$g_abFullStorage[$eLootDarkElixir] = True
		EndIf
	ElseIf $g_abFullStorage[$eLootDarkElixir] Then
		If Number($g_aiCurrentLoot[$eLootDarkElixir]) >= Number($g_aiResumeAttackLoot[$eLootDarkElixir]) Then
			SetLog("Dark Elixir Storages is relatively full: " & $g_aiCurrentLoot[$eLootDarkElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootDarkElixir] = True
		Else
			SetLog("Switching back to normal when Dark Elixir drops below " & $g_aiResumeAttackLoot[$eLootDarkElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootDarkElixir] = False
		EndIf
	EndIf
	Return $g_abFullStorage[$eLootDarkElixir]
EndFunc   ;==>isDarkElixirFull
