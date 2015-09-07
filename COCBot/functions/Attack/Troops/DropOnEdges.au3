
Func DropOnEdges($troop, $nbSides, $number, $slotsPerEdge = 0)
	If $nbSides = 0 Or $number = 1 Then
		OldDropTroop($troop, $Edges[0], $number);
		Return
	EndIf
	If $nbSides < 1 Then Return
	Local $nbTroopsLeft = $number
	If $nbSides = 4 Then
		For $i = 0 To $nbSides - 3
			Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
			DropOnEdge($troop, $Edges[$i], $nbTroopsPerEdge, $slotsPerEdge, $Edges[$i + 2], $i)
			$nbTroopsLeft -= $nbTroopsPerEdge * 2
		Next
		Return
	EndIf
	For $i = 0 To $nbSides - 1
		If $nbSides = 1 Or ($nbSides = 3 And $i = 2) Then
			Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i))
			DropOnEdge($troop, $Edges[$i], $nbTroopsPerEdge, $slotsPerEdge)
			$nbTroopsLeft -= $nbTroopsPerEdge
		ElseIf ($nbSides = 2 And $i = 0) Or ($nbSides = 3 And $i <> 1) Then
			Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
			DropOnEdge($troop, $Edges[$i + 3], $nbTroopsPerEdge, $slotsPerEdge, $Edges[$i + 1])
			$nbTroopsLeft -= $nbTroopsPerEdge * 2
		EndIf
	Next
EndFunc   ;==>DropOnEdges

