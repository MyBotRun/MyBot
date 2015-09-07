Func NameOfTroop($kind, $plurial = 0)
	Switch $kind
		Case $eBarb
			Return "Barbarians"
		Case $eArch
			Return "Archers"
		Case $eGobl
			Return "Goblins"
		Case $eGiant
			Return "Giants"
		Case $eWall
			Return "Wall Breakers"
		Case $eWiza
			Return "Wizards"
		Case $eBall
			Return "Balloons"
	    Case $eHeal
			Return "Healers"
	    Case $eDrag
			Return "Dragons"
	    Case $ePekk
			Return "Pekkas"
		Case $eMini
			Return "Minions"
		Case $eHogs
			Return "Hog Riders"
		Case $eValk
			Return "Valkyries"
		Case $eWitc
			Return "Witches"
		Case $eGole
			Return "Golems"
		Case $eLava
			Return "Lava Hounds"
		Case $eKing
			Return "King"
		Case $eQueen
			Return "Queen"
		Case $eCastle
			Return "Clan Castle"
		Case $eLSpell
			Return "Lightning Spells"
		Case $eHSpell
			Return "Heal Spells"
		Case $eRSpell
			Return "Rage Spells"
	    Case $eJSpell
			Return "Jump Spells"
		Case $eFSpell
			Return "Freeze Spells"
		Case $ePSpell
			Return "Poison Spells"
		Case $eESpell
			Return "Earthquake Spells"
		Case $eHaSpell
			Return "Haste Spells"
		Case Else
			Return ""
	EndSwitch
EndFunc   ;==>NameOfTroop
