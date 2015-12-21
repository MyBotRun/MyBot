
Func SelectDropTroop($Troop)
	if IsAttackPage() Then Click(GetXPosOfArmySlot($Troop, 68), 595 + $bottomOffsetY,1,0,"#0111") ;860x780
EndFunc   ;==>SelectDropTroop
