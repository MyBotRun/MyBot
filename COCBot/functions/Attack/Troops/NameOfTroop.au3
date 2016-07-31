; #FUNCTION# ====================================================================================================================
; Name ..........: NameOfTroop
; Description ...: Returns the string value of the troopname in singular or plural form
; Syntax ........: NameOfTroop($iKind[, $iPlural = 0])
; Parameters ....: $iKind      - an integer value, enumerated value of the troops, like $eBarb = 0, $eArch = 1 etc.
;                  $iPlural    - [optional] a integer value to indicate the $sTroopname returned must be in plural form. Default is 0.
; Return values .: $sTroopname
; Author ........: Unknown (2015)
; Modified ......: ZengZeng (2016-01), Hervidero (2016-01)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func NameOfTroop($iKind, $iPlural = 0)
	Local $sTroopname
	Switch $iKind
		Case $eBarb
			$sTroopname = "Barbarian"
		Case $eArch
			$sTroopname = "Archer"
		Case $eGobl
			$sTroopname = "Goblin"
		Case $eGiant
			$sTroopname = "Giant"
		Case $eWall
			$sTroopname = "Wall Breaker"
		Case $eWiza
			$sTroopname = "Wizard"
		Case $eBall
			$sTroopname = "Balloon"
		Case $eHeal
			$sTroopname = "Healer"
		Case $eDrag
			$sTroopname = "Dragon"
		Case $ePekk
			$sTroopname = "Pekka"
		Case $eBabyD
			$sTroopname = "Baby Dragon"
		Case $eMine
			$sTroopname = "Miner"
		Case $eMini
			$sTroopname = "Minion"
		Case $eHogs
			$sTroopname = "Hog Rider"
		Case $eValk
			$sTroopname = "Valkyrie"
		Case $eWitc
			$sTroopname = "Witch"
		Case $eGole
			$sTroopname = "Golem"
		Case $eLava
			$sTroopname = "Lava Hound"
		Case $eBowl
			$sTroopname = "Bowler"
		Case $eKing
			$sTroopname = "King"
			$iPlural = 0 ; safety reset, $sTroopname of $eKing cannot be plural
		Case $eQueen
			$sTroopname = "Queen"
			$iPlural = 0 ; safety reset
		Case $eWarden
			$sTroopname = "Grand Warden"
			$iPlural = 0 ; safety reset
		Case $eCastle
			$sTroopname = "Clan Castle"
			$iPlural = 0 ; safety reset
		Case $eLSpell
			$sTroopname = "Lightning Spell"
		Case $eHSpell
			$sTroopname = "Heal Spell"
		Case $eRSpell
			$sTroopname = "Rage Spell"
		Case $eJSpell
			$sTroopname = "Jump Spell"
		Case $eFSpell
			$sTroopname = "Freeze Spell"
		Case $eCSpell
			$sTroopname = "Clone Spell"
		Case $ePSpell
			$sTroopname = "Poison Spell"
		Case $eESpell
			$sTroopname = "Earthquake Spell"
		Case $eHaSpell
			$sTroopname = "Haste Spell"
		Case $eSkSpell
			$sTroopname = "Skeleton Spell"
		Case Else
			Return "" ; error or unknown case
	EndSwitch
	If $iPlural = 1 And $iKind = $eWitc Then $sTroopname &= "e" ; adding the "e" for "witches"
	If $iPlural = 1 Then $sTroopname &= "s" ; if troop is not $eKing, $eQueen, $eCastle, $eWarden add the plural "s"
	Return $sTroopname
EndFunc   ;==>NameOfTroop
