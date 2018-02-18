
; #FUNCTION# ====================================================================================================================
; Name ..........: SearchTownHallLoc
; Description ...:
; Syntax ........: SearchTownHallLoc()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #5
; Modified ......: Sardo 2016-02
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SearchTownHallLoc()
	Local $addtiles = 0

	;how many distance tiles from border
	Switch $g_iMatchMode
		Case $TS
			If $g_iArmyCapacity < 100 Then
				$addtiles = $g_iAtkTSAddTilesWhileTrain
			Else
				$addtiles = $g_iAtkTSAddTilesFullTroops
			EndIf
		Case $LB
			$addtiles = $g_iTHSnipeBeforeTiles[$LB]
		Case $DB
			If $g_bDuringMilkingAttack = True Then
				$addtiles = $g_iMilkFarmTHMaxTilesFromBorder
			Else
				$addtiles = $g_iTHSnipeBeforeTiles[$DB]
			EndIf
	EndSwitch


	; New Tile px on 44x44 map size : X = 16px and Y = 12px

	;SetLog("th add tiles = " & $addtiles)
	If $g_iSearchTH <> "-" Then
		If isInsideDiamondXY($g_iTHx, $g_iTHy) = False Then Return False

		For $i = 0 To 22

			If $g_iTHx < 114 + $i * 16 + Ceiling(($addtiles - 2) / 2 * 16) And $g_iTHy < 359 - $i * 12 + Ceiling(($addtiles - 2) / 2 * 12) Then
				$g_iTHi = $i
				$g_iTHside = 0 ; TopLeft
				Return True
			EndIf
			If $g_iTHx < 117 + $i * 16 + Ceiling(($addtiles - 2) / 2 * 16) And $g_iTHy > 268 + $i * 12 - Floor(($addtiles - 2) / 2 * 12) Then
				$g_iTHi = $i
				$g_iTHside = 1 ; BottomLeft
				Return True
			EndIf
			If $g_iTHx > 743 - $i * 16 - Floor(($addtiles - 2) / 2 * 16) And $g_iTHy < 358 - $i * 12 + Ceiling(($addtiles - 2) / 2 * 12) Then
				$g_iTHi = $i
				$g_iTHside = 2 ; TopRight
				Return True
			EndIf
			If $g_iTHx > 742 - $i * 16 - Floor(($addtiles - 2) / 2 * 16) And $g_iTHy > 268 + $i * 12 - Floor(($addtiles - 2) / 2 * 12) Then
				$g_iTHi = $i
				$g_iTHside = 3 ; BottomRight
				Return True
			EndIf
		Next
	EndIf
	Return False
EndFunc   ;==>SearchTownHallLoc

