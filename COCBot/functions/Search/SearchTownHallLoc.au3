
; #FUNCTION# ====================================================================================================================
; Name ..........: SearchTownHallLoc
; Description ...:
; Syntax ........: SearchTownHallLoc()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #5
; Modified ......: Sardo 2016-02
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SearchTownHallLoc()
	Local $addtiles = 0

	;how many distance tiles from border
	Switch $iMatchMode
		Case $TS
			If $ArmyCapacity < 100 Then
				$addtiles = $itxtSWTtiles
			Else
				$addtiles = $THaddtiles
			EndIf
		Case $LB
			$addtiles = $THSnipeBeforeLBTiles
		Case $DB
			If $duringMilkingAttack = 1 Then
				$addtiles = $MilkFarmTHMaxTilesFromBorder
			Else
				$addtiles = $THSnipeBeforeDBTiles
			EndIf
	EndSwitch


	;setlog("th add tiles = " & $addtiles)
	If $searchTH <> "-" Then
		If isInsideDiamondXY($THx, $THy) = False Then Return False

		For $i = 0 To 20

			If $Thx < 114 + $i * 19 + Ceiling(($addtiles - 2) / 2 * 19) And $THy < 359 - $i * 14 + Ceiling(($addtiles - 2) / 2 * 14) Then
				$THi = $i
				$THside = 0
				Return True
			EndIf
			If $Thx < 117 + $i * 19 + Ceiling(($addtiles - 2) / 2 * 19) And $THy > 268 + $i * 14 - Floor(($addtiles - 2) / 2 * 14) Then
				$THi = $i
				$THside = 1
				Return True
			EndIf
			If $Thx > 743 - $i * 19 - Floor(($addtiles - 2) / 2 * 19) And $THy < 358 - $i * 14 + Ceiling(($addtiles - 2) / 2 * 14) Then
				$THi = $i
				$THside = 2
				Return True
			EndIf
			If $Thx > 742 - $i * 19 - Floor(($addtiles - 2) / 2 * 19) And $THy > 268 + $i * 14 - Floor(($addtiles - 2) / 2 * 14) Then
				$THi = $i
				$THside = 3
				Return True
			EndIf
		Next
	EndIf
	Return False
EndFunc   ;==>SearchTownHallLoc

