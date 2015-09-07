; Read the quantity for a given troop
Func ReadTroopQuantity($Troop)
	Local $iAmount
	$iAmount = getTroopCountSmall(GetXPosOfArmySlot($Troop, 40), 582)
	If $iAmount = "" Then
		$iAmount = getTroopCountBig(GetXPosOfArmySlot($Troop, 40), 577)
	EndIf
	Return Number($iAmount)
EndFunc   ;==>ReadTroopQuantity
