Func GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)
	Local $iAmount

	Switch $slotNumber
		Case 0 To 1
			$SlotComp = 0
		Case 2 To 5
			$SlotComp = 1
		Case Else
			$SlotComp = 2
	EndSwitch

	If $atkTroops[11][0] = -1 Then ;And _ColorCheck(_GetPixelColor(10, 575, True), Hex(0x040A06, 6), 20) Then ; check color to verify if exists > 12 slots
		Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72)
	Else
		Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72) - 30
	EndIf
EndFunc   ;==>GetXPosOfArmySlot
