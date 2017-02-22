
; #FUNCTION# ====================================================================================================================
; Name ..........: SearchTownHallLoc
; Description ...:
; Syntax ........: SearchTownHallLoc()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #5
; Modified ......: Sardo 2016-02
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
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
			If $ArmyCapacity < 100 Then
				$addtiles = $g_iAtkTSAddTilesWhileTrain
			Else
				$addtiles = $g_iAtkTSAddTilesFullTroops
			EndIf
		Case $LB
			$addtiles = $g_iTHSnipeBeforeTiles[$LB]
		Case $DB
			If $duringMilkingAttack = 1 Then
				$addtiles = $g_iMilkFarmTHMaxTilesFromBorder
			Else
				$addtiles = $g_iTHSnipeBeforeTiles[$DB]
			EndIf
	EndSwitch


	; New Tile px on 44x44 map size : X = 16px and Y = 12px

	;setlog("th add tiles = " & $addtiles)
	If $searchTH <> "-" Then
		If isInsideDiamondXY($THx, $THy) = False Then Return False

		For $i = 0 To 22

			If $Thx < 114 + $i * 16 + Ceiling(($addtiles - 2) / 2 * 16) And $THy < 359 - $i * 12 + Ceiling(($addtiles - 2) / 2 * 12) Then
				$THi = $i
				$THside = 0  	; TopLeft
				Return True
			EndIf
			If $Thx < 117 + $i * 16 + Ceiling(($addtiles - 2) / 2 * 16) And $THy > 268 + $i * 12 - Floor(($addtiles - 2) / 2 * 12) Then
				$THi = $i
				$THside = 1 	; BottomLeft
				Return True
			EndIf
			If $Thx > 743 - $i * 16 - Floor(($addtiles - 2) / 2 * 16) And $THy < 358 - $i * 12 + Ceiling(($addtiles - 2) / 2 * 12) Then
				$THi = $i
				$THside = 2		; TopRight
				Return True
			EndIf
			If $Thx > 742 - $i * 16 - Floor(($addtiles - 2) / 2 * 16) And $THy > 268 + $i * 12 - Floor(($addtiles - 2) / 2 * 12) Then
				$THi = $i
				$THside = 3		; BottomRight
				Return True
			EndIf
		Next
	EndIf
	Return False
EndFunc   ;==>SearchTownHallLoc

