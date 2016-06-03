
; #FUNCTION# ====================================================================================================================
; Name ..........: DropOnEdges
; Description ...:
; Syntax ........: DropOnEdges($troop, $nbSides, $number[, $slotsPerEdge = 0])
; Parameters ....: $troop               - a dll struct value.
;                  $nbSides             - a general number value.
;                  $number              - a general number value.
;                  $slotsPerEdge        - [optional] a string value. Default is 0.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func DropOnEdges($troop, $nbSides, $number, $slotsPerEdge = 0)
	If $nbSides = 0 Or $number = 1 Then
		OldDropTroop($troop, $Edges[0], $number);
		Return
	EndIf
	If $nbSides < 1 Then Return
	Local $nbTroopsLeft = $number
	If $nbSides = 4 Then
		For $i = 0 To $nbSides - 3
			KeepClicks()
			Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
			DropOnEdge($troop, $Edges[$i], $nbTroopsPerEdge, $slotsPerEdge, $Edges[$i + 2], $i)
			$nbTroopsLeft -= $nbTroopsPerEdge * 2
			ReleaseClicks()
		Next
		Return
	EndIf
	For $i = 0 To $nbSides - 1
		KeepClicks()
		If $nbSides = 1 Or ($nbSides = 3 And $i = 2) Then
			Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i))
			If $iMatchMode = $LB And $iChkDeploySettings[$LB] >= 4 Then ; Used for DE or TH side attack
				DropOnEdge($troop, $Edges[$BuildingEdge], $nbTroopsPerEdge, $slotsPerEdge)
			Else
				DropOnEdge($troop, $Edges[$i], $nbTroopsPerEdge, $slotsPerEdge)
			EndIf
			$nbTroopsLeft -= $nbTroopsPerEdge
		ElseIf ($nbSides = 2 And $i = 0) Or ($nbSides = 3 And $i <> 1) Then
			Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
			DropOnEdge($troop, $Edges[$i + 3], $nbTroopsPerEdge, $slotsPerEdge, $Edges[$i + 1])
			$nbTroopsLeft -= $nbTroopsPerEdge * 2
		EndIf
		ReleaseClicks()
	Next
EndFunc   ;==>DropOnEdges

