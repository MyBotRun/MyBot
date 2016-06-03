;~ -------------------------------------------------------------
;~ Language Variables used a lot
;~ -------------------------------------------------------------

Global $sTxtBarbarians = GetTranslated(604,1, "Barbarians")
Global $sTxtArchers = GetTranslated(604,2, "Archers")
Global $sTxtGiants = GetTranslated(604,3, "Giants")
Global $sTxtGoblins = GetTranslated(604,4, "Goblins")
Global $sTxtWallBreakers = GetTranslated(604,5, "Wall Breakers")
Global $sTxtBalloons = GetTranslated(604,7, "Balloons")
Global $sTxtWizards = GetTranslated(604,8, "Wizards")
Global $sTxtHealers = GetTranslated(604,9, "Healers")
Global $sTxtDragons = GetTranslated(604,10, "Dragons")
Global $sTxtPekkas = GetTranslated(604,11, "Pekkas")
Global $sTxtMinions = GetTranslated(604,13, "Minions")
Global $sTxtHogRiders = GetTranslated(604,14, "Hog Riders")
Global $sTxtValkyries = GetTranslated(604,15, "Valkyries")
Global $sTxtGolems = GetTranslated(604,16, "Golems")
Global $sTxtWitches = GetTranslated(604,17, "Witches")
Global $sTxtLavaHounds = GetTranslated(604,18, "Lava Hounds")
Global $sTxtBowlers = GetTranslated(604, 19, "Bowlers")
Global $sTxtBDragons = GetTranslated(604,20, "Baby Dragon")
Global $sTxtMiners = GetTranslated(604,21, "Miner")

Global $sTxtLiSpell = GetTranslated(605,1, "Lightning Spell")
Global $sTxtHeSpell = GetTranslated(605,2, "Healing Spell")
Global $sTxtRaSpell = GetTranslated(605,3, "Rage Spell")
Global $sTxtJuSPell = GetTranslated(605,4, "Jump Spell")
Global $sTxtFrSpell = GetTranslated(605,5, "Freeze Spell")
Global $sTxtPoSpell = GetTranslated(605,6, "Poison Spell")
Global $sTxtEaSpell = GetTranslated(605,7, "EarthQuake Spell")
Global $sTxtHaSpell = GetTranslated(605,8, "Haste Spell")
Global $sTxtPoisonSpells = GetTranslated(605,9, "Poison")
Global $sTxtEarthquakeSpells = GetTranslated(605,10, "EarthQuake")
Global $sTxtHasteSpells = GetTranslated(605,11, "Haste")
Global $sTxtClSpell = GetTranslated(605,12, "Clone Spell")
Global $sTxtSkSpell = GetTranslated(605,13, "Skeleton Spell")

; Array to hold Laboratory Troop information [LocX of upper left corner of image, LocY of upper left corner of image, PageLocation, Troop "name", Icon # in DLL file]
Global Const $aLabTroops[30][5] = [ _
		[-1, -1, -1, GetTranslated(603,0, "None"), $eIcnBlank], _
		[123, 320 + $midOffsetY, 0, $sTxtBarbarians, $eIcnBarbarian], _
		[123, 427 + $midOffsetY, 0, $sTxtArchers, $eIcnArcher], _
		[230, 320 + $midOffsetY, 0, $sTxtGiants, $eIcnGiant], _
		[230, 427 + $midOffsetY, 0, $sTxtGoblins, $eIcnGoblin], _
		[337, 320 + $midOffsetY, 0, $sTxtWallBreakers, $eIcnWallBreaker], _
		[337, 427 + $midOffsetY, 0, $sTxtBalloons, $eIcnBalloon], _
		[443, 320 + $midOffsetY, 0, $sTxtWizards, $eIcnWizard], _
		[443, 427 + $midOffsetY, 0, $sTxtHealers, $eIcnHealer], _
		[550, 320 + $midOffsetY, 0, $sTxtDragons, $eIcnDragon], _
		[550, 427 + $midOffsetY, 0, $sTxtPekkas, $eIcnPekka], _
		[657, 320 + $midOffsetY, 0, $sTxtBDragons, $eIcnTroops], _  ; Need Baby Dragon Icon
		[657, 427 + $midOffsetY, 0, $sTxtMiners, $eIcnTroops], _  	; Need Miner Icon
		[433, 320 + $midOffsetY, 1, $sTxtLiSpell, $eIcnLightSpell], _
		[433, 427 + $midOffsetY, 1, $sTxtHeSpell, $eIcnHealSpell], _
		[540, 320 + $midOffsetY, 1, $sTxtRaSpell, $eIcnRageSpell], _
		[540, 427 + $midOffsetY, 1, $sTxtJuSPell, $eIcnJumpSpell], _
		[647, 320 + $midOffsetY, 1, $sTxtFrSpell, $eIcnFreezeSpell], _
		[647, 427 + $midOffsetY, 1, $sTxtClSpell, $eIcnTroops], _  ; Need Clone Spell Icon
		[109, 320 + $midOffsetY, 2, $sTxtPoSpell, $eIcnPoisonSpell], _
		[109, 427 + $midOffsetY, 2, $sTxtEaSpell, $eIcnEarthQuakeSpell], _
		[216, 320 + $midOffsetY, 2, $sTxtHaSpell, $eIcnHasteSpell], _
		[216, 427 + $midOffsetY, 2, $sTxtSkSpell, $eIcnTroops], _  ; Need Skeleton Spell Icon
		[322, 320 + $midOffsetY, 2, $sTxtMinions, $eIcnMinion], _
		[322, 427 + $midOffsetY, 2, $sTxtHogRiders, $eIcnHogRider], _
		[429, 320 + $midOffsetY, 2, $sTxtValkyries, $eIcnValkyrie], _
		[429, 427 + $midOffsetY, 2, $sTxtGolems, $eIcnGolem], _
		[536, 320 + $midOffsetY, 2, $sTxtWitches, $eIcnWitch], _
		[536, 427 + $midOffsetY, 2, $sTxtLavaHounds, $eIcnLavaHound], _
		[642, 320 + $midOffsetY, 2, $sTxtBowlers, $eIcnBowler]]
