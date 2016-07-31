; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Donate
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: MonkeyHunter (07-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func btnDonateBarbarians()
	If GUICtrlGetState($grpBarbarians) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpBarbarians, $txtBlacklistBarbarians) ;Hide/Show controls on Donate tab
	EndIf
EndFunc   ;==>btnDonateBarbarians

Func btnDonateArchers()
	If GUICtrlGetState($grpArchers) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpArchers, $txtBlacklistArchers)
	EndIf
EndFunc   ;==>btnDonateArchers

Func btnDonateGiants()
	If GUICtrlGetState($grpGiants) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpGiants, $txtBlacklistGiants)
	EndIf
EndFunc   ;==>btnDonateGiants

Func btnDonateGoblins()
	If GUICtrlGetState($grpGoblins) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpGoblins, $txtBlacklistGoblins)
	EndIf
EndFunc   ;==>btnDonateGoblins

Func btnDonateWallBreakers()
	If GUICtrlGetState($grpWallBreakers) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpWallBreakers, $txtBlacklistWallBreakers)
	EndIf
EndFunc   ;==>btnDonateWallBreakers

Func btnDonateBalloons()
	If GUICtrlGetState($grpBalloons) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpBalloons, $txtBlacklistBalloons)
	EndIf
EndFunc   ;==>btnDonateBalloons

Func btnDonateWizards()
	If GUICtrlGetState($grpWizards) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpWizards, $txtBlacklistWizards)
	EndIf
EndFunc   ;==>btnDonateWizards

Func btnDonateHealers()
	If GUICtrlGetState($grpHealers) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpHealers, $txtBlacklistHealers)
	EndIf
EndFunc   ;==>btnDonateHealers

Func btnDonateDragons()
	If GUICtrlGetState($grpDragons) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpDragons, $txtBlacklistDragons)
	EndIf
EndFunc   ;==>btnDonateDragons

Func btnDonatePekkas()
	If GUICtrlGetState($grpPekkas) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpPekkas, $txtBlacklistPekkas)
	EndIf
EndFunc   ;==>btnDonatePekkas

Func btnDonateBabyDragons()
	If GUICtrlGetState($grpBabyDragons) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpBabyDragons, $txtBlacklistBabyDragons)
	EndIf
EndFunc   ;==>btnDonateBabyDragons

Func btnDonateMiners()
	If GUICtrlGetState($grpMiners) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpMiners, $txtBlacklistMiners)
	EndIf
EndFunc   ;==>btnDonateMiners

Func btnDonateMinions()
	If GUICtrlGetState($grpMinions) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpMinions, $txtBlacklistMinions)
	EndIf
EndFunc   ;==>btnDonateMinions

Func btnDonateHogRiders()
	If GUICtrlGetState($grpHogRiders) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpHogRiders, $txtBlacklistHogRiders)
	EndIf
EndFunc   ;==>btnDonateHogRiders

Func btnDonateValkyries()
	If GUICtrlGetState($grpValkyries) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpValkyries, $txtBlacklistValkyries)
	EndIf
EndFunc   ;==>btnDonateValkyries

Func btnDonateGolems()
	If GUICtrlGetState($grpGolems) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpGolems, $txtBlacklistGolems)
	EndIf
EndFunc   ;==>btnDonateGolems

Func btnDonateWitches()
	If GUICtrlGetState($grpWitches) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpWitches, $txtBlacklistWitches)
	EndIf
EndFunc   ;==>btnDonateWitches

Func btnDonateLavaHounds()
	If GUICtrlGetState($grpLavaHounds) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpLavaHounds, $txtBlacklistLavaHounds)
	EndIf
EndFunc   ;==>btnDonateLavaHounds

Func btnDonateBowlers()
	If GUICtrlGetState($grpBowlers) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpBowlers, $txtBlacklistBowlers)
	EndIf
EndFunc   ;==>btnDonateBowlers

Func btnDonatePoisonSpells()
	If GUICtrlGetState($grpPoisonSpells) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpPoisonSpells, $txtBlacklistPoisonSpells)
	EndIf
EndFunc   ;==>btnDonatePoisonSpells

Func btnDonateEarthQuakeSpells()
	If GUICtrlGetState($grpEarthQuakeSpells) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpEarthQuakeSpells, $txtBlacklistEarthQuakeSpells)
	EndIf
EndFunc   ;==>btnDonateEarthQuakeSpells

Func btnDonateHasteSpells()
	If GUICtrlGetState($grpHasteSpells) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpHasteSpells, $txtBlacklistHasteSpells)
	EndIf
EndFunc   ;==>btnDonateHasteSpells

Func btnDonateSkeletonSpells()
	If GUICtrlGetState($grpSkeletonSpells) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpSkeletonSpells, $txtBlacklistSkeletonSpells)
	EndIf
EndFunc   ;==>btnDonateSkeletonSpells


;;; Custom Combination Donate by ChiefM3
Func btnDonateCustomA()
	If GUICtrlGetState($grpCustomA) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpCustomA, $txtBlacklistCustomA)
	EndIf
EndFunc   ;==>btnDonateCustom

Func btnDonateCustomB()
	If GUICtrlGetState($grpCustomB) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpCustomB, $txtBlacklistCustomB)
	EndIf
EndFunc   ;==>btnDonateCustomB

Func btnDonateBlacklist()
	If GUICtrlGetState($grpBlacklist) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpBlacklist, $txtBlacklist)
	EndIf
EndFunc   ;==>btnDonateBlacklist

Func chkDonateAllBarbarians()
	If GUICtrlRead($chkDonateAllBarbarians) = $GUI_CHECKED Then
		_DonateAllControls($eBarb, True)
	Else
		_DonateAllControls($eBarb, False)
	EndIf
EndFunc   ;==>chkDonateAllBarbarians

Func chkDonateAllArchers()
	If GUICtrlRead($chkDonateAllArchers) = $GUI_CHECKED Then
		_DonateAllControls($eArch, True)
	Else
		_DonateAllControls($eArch, False)
	EndIf
EndFunc   ;==>chkDonateAllArchers

Func chkDonateAllGiants()
	If GUICtrlRead($chkDonateAllGiants) = $GUI_CHECKED Then
		_DonateAllControls($eGiant, True)
	Else
		_DonateAllControls($eGiant, False)
	EndIf
EndFunc   ;==>chkDonateAllGiants

Func chkDonateAllGoblins()
	If GUICtrlRead($chkDonateAllGoblins) = $GUI_CHECKED Then
		_DonateAllControls($eGobl, True)
	Else
		_DonateAllControls($eGobl, False)
	EndIf
EndFunc   ;==>chkDonateAllGoblins

Func chkDonateAllWallBreakers()
	If GUICtrlRead($chkDonateAllWallBreakers) = $GUI_CHECKED Then
		_DonateAllControls($eWall, True)
	Else
		_DonateAllControls($eWall, False)
	EndIf
EndFunc   ;==>chkDonateAllWallBreakers

Func chkDonateAllBalloons()
	If GUICtrlRead($chkDonateAllBalloons) = $GUI_CHECKED Then
		_DonateAllControls($eBall, True)
	Else
		_DonateAllControls($eBall, False)
	EndIf
EndFunc   ;==>chkDonateAllBalloons

Func chkDonateAllWizards()
	If GUICtrlRead($chkDonateAllWizards) = $GUI_CHECKED Then
		_DonateAllControls($eWiza, True)
	Else
		_DonateAllControls($eWiza, False)
	EndIf
EndFunc   ;==>chkDonateAllWizards

Func chkDonateAllHealers()
	If GUICtrlRead($chkDonateAllHealers) = $GUI_CHECKED Then
		_DonateAllControls($eHeal, True)
	Else
		_DonateAllControls($eHeal, False)
	EndIf
EndFunc   ;==>chkDonateAllHealers

Func chkDonateAllDragons()
	If GUICtrlRead($chkDonateAllDragons) = $GUI_CHECKED Then
		_DonateAllControls($eDrag, True)
	Else
		_DonateAllControls($eDrag, False)
	EndIf
EndFunc   ;==>chkDonateAllDragons

Func chkDonateAllPekkas()
	If GUICtrlRead($chkDonateAllPekkas) = $GUI_CHECKED Then
		_DonateAllControls($ePekk, True)
	Else
		_DonateAllControls($ePekk, False)
	EndIf
EndFunc   ;==>chkDonateAllPekkas

Func chkDonateAllBabyDragons()
	If GUICtrlRead($chkDonateAllBabyDragons) = $GUI_CHECKED Then
		_DonateAllControls($eBabyD, True)
	Else
		_DonateAllControls($eBabyD, False)
	EndIf
EndFunc   ;==>chkDonateAllBabyDragons

Func chkDonateAllMiners()
	If GUICtrlRead($chkDonateAllMiners) = $GUI_CHECKED Then
		_DonateAllControls($eMine, True)
	Else
		_DonateAllControls($eMine, False)
	EndIf
EndFunc   ;==>chkDonateAllMiners

Func chkDonateAllMinions()
	If GUICtrlRead($chkDonateAllMinions) = $GUI_CHECKED Then
		_DonateAllControls($eMini, True)
	Else
		_DonateAllControls($eMini, False)
	EndIf
EndFunc   ;==>chkDonateAllMinions

Func chkDonateAllHogRiders()
	If GUICtrlRead($chkDonateAllHogRiders) = $GUI_CHECKED Then
		_DonateAllControls($eHogs, True)
	Else
		_DonateAllControls($eHogs, False)
	EndIf
EndFunc   ;==>chkDonateAllHogRiders

Func chkDonateAllValkyries()
	If GUICtrlRead($chkDonateAllValkyries) = $GUI_CHECKED Then
		_DonateAllControls($eValk, True)
	Else
		_DonateAllControls($eValk, False)
	EndIf
EndFunc   ;==>chkDonateAllValkyries

Func chkDonateAllGolems()
	If GUICtrlRead($chkDonateAllGolems) = $GUI_CHECKED Then
		_DonateAllControls($eGole, True)
	Else
		_DonateAllControls($eGole, False)
	EndIf
EndFunc   ;==>chkDonateAllGolems

Func chkDonateAllWitches()
	If GUICtrlRead($chkDonateAllWitches) = $GUI_CHECKED Then
		_DonateAllControls($eWitc, True)
	Else
		_DonateAllControls($eWitc, False)
	EndIf
EndFunc   ;==>chkDonateAllWitches

Func chkDonateAllLavaHounds()
	If GUICtrlRead($chkDonateAllLavaHounds) = $GUI_CHECKED Then
		_DonateAllControls($eLava, True)
	Else
		_DonateAllControls($eLava, False)
	EndIf
EndFunc   ;==>chkDonateAllLavaHounds

Func chkDonateAllBowlers()
	If GUICtrlRead($chkDonateAllBowlers) = $GUI_CHECKED Then
		_DonateAllControls($eBowl, True)
	Else
		_DonateAllControls($eBowl, False)
	EndIf
EndFunc   ;==>chkDonateAllBowlers

Func chkDonateAllPoisonSpells()
	If GUICtrlRead($chkDonateAllPoisonSpells) = $GUI_CHECKED Then
		_DonateAllControlsSpell(0, True)
	Else
		_DonateAllControlsSpell(0, False)
	EndIf
EndFunc   ;==>chkDonateAllPoisonSpells

Func chkDonateAllEarthQuakeSpells()
	If GUICtrlRead($chkDonateAllEarthQuakeSpells) = $GUI_CHECKED Then
		_DonateAllControlsSpell(1, True)
	Else
		_DonateAllControlsSpell(1, False)
	EndIf
EndFunc   ;==>chkDonateAllEarthQuakeSpells

Func chkDonateAllHasteSpells()
	If GUICtrlRead($chkDonateAllHasteSpells) = $GUI_CHECKED Then
		_DonateAllControlsSpell(2, True)
	Else
		_DonateAllControlsSpell(2, False)
	EndIf
EndFunc   ;==>chkDonateAllHasteSpells

Func chkDonateAllSkeletonSpells()
	If GUICtrlRead($chkDonateAllSkeletonSpells) = $GUI_CHECKED Then
		_DonateAllControlsSpell(3, True)
	Else
		_DonateAllControlsSpell(3, False)
	EndIf
EndFunc   ;==>chkDonateAllSkeletonSpells

;;; Custom Combination Donate by ChiefM3
Func chkDonateAllCustomA()
	If GUICtrlRead($chkDonateAllCustomA) = $GUI_CHECKED Then
		_DonateAllControls(19, True)
	Else
		_DonateAllControls(19, False)
	EndIf
EndFunc   ;==>chkDonateAllCustomA

Func chkDonateAllCustomB()
	If GUICtrlRead($chkDonateAllCustomB) = $GUI_CHECKED Then
		_DonateAllControls(20, True)
	Else
		_DonateAllControls(20, False)
	EndIf
EndFunc   ;==>chkDonateAllCustomB

Func chkDonateBarbarians()
	If GUICtrlRead($chkDonateBarbarians) = $GUI_CHECKED Then
		_DonateControls($eBarb)
	Else
		GUICtrlSetBkColor($lblBtnBarbarians, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateBarbarians

Func chkDonateArchers()
	If GUICtrlRead($chkDonateArchers) = $GUI_CHECKED Then
		_DonateControls($eArch)
	Else
		GUICtrlSetBkColor($lblBtnArchers, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateArchers

Func chkDonateGiants()
	If GUICtrlRead($chkDonateGiants) = $GUI_CHECKED Then
		_DonateControls($eGiant)
	Else
		GUICtrlSetBkColor($lblBtnGiants, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateGiants

Func chkDonateGoblins()
	If GUICtrlRead($chkDonateGoblins) = $GUI_CHECKED Then
		_DonateControls($eGobl)
	Else
		GUICtrlSetBkColor($lblBtnGoblins, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateGoblins

Func chkDonateWallBreakers()
	If GUICtrlRead($chkDonateWallBreakers) = $GUI_CHECKED Then
		_DonateControls($eWall)
	Else
		GUICtrlSetBkColor($lblBtnWallBreakers, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateWallBreakers

Func chkDonateBalloons()
	If GUICtrlRead($chkDonateBalloons) = $GUI_CHECKED Then
		_DonateControls($eBall)
	Else
		GUICtrlSetBkColor($lblBtnBalloons, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateBalloons

Func chkDonateWizards()
	If GUICtrlRead($chkDonateWizards) = $GUI_CHECKED Then
		_DonateControls($eWiza)
	Else
		GUICtrlSetBkColor($lblBtnWizards, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateWizards

Func chkDonateHealers()
	If GUICtrlRead($chkDonateHealers) = $GUI_CHECKED Then
		_DonateControls($eHeal)
	Else
		GUICtrlSetBkColor($lblBtnHealers, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateHealers

Func chkDonateDragons()
	If GUICtrlRead($chkDonateDragons) = $GUI_CHECKED Then
		_DonateControls($eDrag)
	Else
		GUICtrlSetBkColor($lblBtnDragons, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateDragons

Func chkDonatePekkas()
	If GUICtrlRead($chkDonatePekkas) = $GUI_CHECKED Then
		_DonateControls($ePekk)
	Else
		GUICtrlSetBkColor($lblBtnPekkas, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonatePekkas

Func chkDonateBabyDragons()
	If GUICtrlRead($chkDonateBabyDragons) = $GUI_CHECKED Then
		_DonateControls($eBabyD)
	Else
		GUICtrlSetBkColor($lblBtnBabyDragons, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateBabyDragons

Func chkDonateMiners()
	If GUICtrlRead($chkDonateMiners) = $GUI_CHECKED Then
		_DonateControls($eMine)
	Else
		GUICtrlSetBkColor($lblBtnMiners, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateMiners

Func chkDonateMinions()
	If GUICtrlRead($chkDonateMinions) = $GUI_CHECKED Then
		_DonateControls($eMini)
	Else
		GUICtrlSetBkColor($lblBtnMinions, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateMinions

Func chkDonateHogRiders()
	If GUICtrlRead($chkDonateHogRiders) = $GUI_CHECKED Then
		_DonateControls($eHogs)
	Else
		GUICtrlSetBkColor($lblBtnHogRiders, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateHogRiders

Func chkDonateValkyries()
	If GUICtrlRead($chkDonateValkyries) = $GUI_CHECKED Then
		_DonateControls($eValk)
	Else
		GUICtrlSetBkColor($lblBtnValkyries, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateValkyries

Func chkDonateGolems()
	If GUICtrlRead($chkDonateGolems) = $GUI_CHECKED Then
		_DonateControls($eGole)
	Else
		GUICtrlSetBkColor($lblBtnGolems, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateGolems

Func chkDonateWitches()
	If GUICtrlRead($chkDonateWitches) = $GUI_CHECKED Then
		_DonateControls($eWitc)
	Else
		GUICtrlSetBkColor($lblBtnWitches, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateWitches

Func chkDonateLavaHounds()
	If GUICtrlRead($chkDonateLavaHounds) = $GUI_CHECKED Then
		_DonateControls($eLava)
	Else
		GUICtrlSetBkColor($lblBtnLavaHounds, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateLavaHounds

Func chkDonateBowlers()
	If GUICtrlRead($chkDonateBowlers) = $GUI_CHECKED Then
		_DonateControls($eBowl)
	Else
		GUICtrlSetBkColor($lblBtnBowlers, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateBowlers

Func chkDonatePoisonSpells()
	If GUICtrlRead($chkDonatePoisonSpells) = $GUI_CHECKED Then
		_DonateControlsSpell(0)
	Else
		GUICtrlSetBkColor($lblBtnPoisonSpells, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonatePoisonSpells

Func chkDonateEarthQuakeSpells()
	If GUICtrlRead($chkDonateEarthQuakeSpells) = $GUI_CHECKED Then
		_DonateControlsSpell(1)
	Else
		GUICtrlSetBkColor($lblBtnEarthQuakeSpells, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateEarthQuakeSpells

Func chkDonateHasteSpells()
	If GUICtrlRead($chkDonateHasteSpells) = $GUI_CHECKED Then
		_DonateControlsSpell(2)
	Else
		GUICtrlSetBkColor($lblBtnHasteSpells, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateHasteSpells

Func chkDonateSkeletonSpells()
	If GUICtrlRead($chkDonateSkeletonSpells) = $GUI_CHECKED Then
		_DonateControlsSpell(3)
	Else
		GUICtrlSetBkColor($lblBtnSkeletonSpells, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateSkeletonSpells

;;; CustomA Combination Donate by ChiefM3
Func chkDonateCustomA()
	If GUICtrlRead($chkDonateCustomA) = $GUI_CHECKED Then
		_DonateControls(19)
	Else
		GUICtrlSetBkColor($lblBtnCustomA, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateCustomA

Func chkDonateCustomB()
	If GUICtrlRead($chkDonateCustomB) = $GUI_CHECKED Then
		_DonateControls(20)
	Else
		GUICtrlSetBkColor($lblBtnCustomB, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateCustomB

Func cmbDonateCustomA()
	Local $aDonIcons[20] = [$eIcnDonBarbarian, $eIcnDonArcher, $eIcnDonGiant, $eIcnDonGoblin, $eIcnDonWallBreaker, $eIcnDonBalloon, $eIcnDonWizard, $eIcnDonHealer, $eIcnDonDragon, $eIcnDonPekka, $eIcnDonBabyDragon, $eIcnDonMiner, $eIcnDonMinion, $eIcnDonHogRider, $eIcnDonValkyrie, $eIcnDonGolem, $eIcnDonWitch, $eIcnDonLavaHound, $eIcnDonBowler, $eIcnDonBlank]
	Local $combo1 = _GUICtrlComboBox_GetCurSel($cmbDonateCustomA1)
	Local $combo2 = _GUICtrlComboBox_GetCurSel($cmbDonateCustomA2)
	Local $combo3 = _GUICtrlComboBox_GetCurSel($cmbDonateCustomA3)
	GUICtrlSetImage($picDonateCustomA1, $pIconLib, $aDonIcons[$combo1])
	GUICtrlSetImage($picDonateCustomA2, $pIconLib, $aDonIcons[$combo2])
	GUICtrlSetImage($picDonateCustomA3, $pIconLib, $aDonIcons[$combo3])
EndFunc   ;==>cmbDonateCustomA

Func cmbDonateCustomB()
	Local $aDonIcons[20] = [$eIcnDonBarbarian, $eIcnDonArcher, $eIcnDonGiant, $eIcnDonGoblin, $eIcnDonWallBreaker, $eIcnDonBalloon, $eIcnDonWizard, $eIcnDonHealer, $eIcnDonDragon, $eIcnDonPekka, $eIcnDonBabyDragon, $eIcnDonMiner, $eIcnDonMinion, $eIcnDonHogRider, $eIcnDonValkyrie, $eIcnDonGolem, $eIcnDonWitch, $eIcnDonLavaHound, $eIcnDonBowler, $eIcnDonBlank]
	Local $combo1 = _GUICtrlComboBox_GetCurSel($cmbDonateCustomB1)
	Local $combo2 = _GUICtrlComboBox_GetCurSel($cmbDonateCustomB2)
	Local $combo3 = _GUICtrlComboBox_GetCurSel($cmbDonateCustomB3)
	GUICtrlSetImage($picDonateCustomB1, $pIconLib, $aDonIcons[$combo1])
	GUICtrlSetImage($picDonateCustomB2, $pIconLib, $aDonIcons[$combo2])
	GUICtrlSetImage($picDonateCustomB3, $pIconLib, $aDonIcons[$combo3])
EndFunc   ;==>cmbDonateCustomB

Func _DonateBtn($FirstControl, $LastControl)
	; Hide Controls
	If $LastDonateBtn1 = -1 Then
		For $i = $grpBarbarians To $txtBlacklistBarbarians ; 1st time use: Hide Barbarian controls
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	Else
		For $i = $LastDonateBtn1 To $LastDonateBtn2 ; Hide last used controls on Donate Tab
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf

	$LastDonateBtn1 = $FirstControl
	$LastDonateBtn2 = $LastControl

	;Show Controls
	For $i = $FirstControl To $LastControl ; Show these controls on Donate Tab
		GUICtrlSetState($i, $GUI_SHOW)
	Next
EndFunc   ;==>_DonateBtn

Func _DonateControls($TroopType)
	Local $bWasRedraw = SetRedrawBotWindow(False)

	For $i = 0 To UBound($aLblBtnControls) - 1
		If $i = $TroopType Then
			GUICtrlSetBkColor($aLblBtnControls[$i], $COLOR_GREEN)
		Else
			If GUICtrlGetBkColor($aLblBtnControls[$i]) = $COLOR_NAVY Then GUICtrlSetBkColor($aLblBtnControls[$i], $GUI_BKCOLOR_TRANSPARENT)
		EndIf
	Next

	For $i = 0 To UBound($aChkDonateAllControls) - 1
		GUICtrlSetState($aChkDonateAllControls[$i], $GUI_UNCHECKED)
	Next

	For $i = 0 To UBound($aTxtDonateControls) - 1
		If BitAND(GUICtrlGetState($aTxtDonateControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtDonateControls[$i], $GUI_ENABLE)
	Next

	For $i = 0 To UBound($aTxtBlacklistControls) - 1
		If BitAND(GUICtrlGetState($aTxtBlacklistControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtBlacklistControls[$i], $GUI_ENABLE)
	Next
	SetRedrawBotWindowControls($bWasRedraw, $hGUI_DONATE_TAB) ; cannot use tab item here
EndFunc   ;==>_DonateControls

Func _DonateControlsSpell($TroopType)
	For $i = 0 To UBound($aLblBtnControlsSpell) - 1
		If $i = $TroopType Then
			GUICtrlSetBkColor($aLblBtnControlsSpell[$i], $COLOR_GREEN)
		Else
			If GUICtrlGetBkColor($aLblBtnControlsSpell[$i]) = $COLOR_NAVY Then GUICtrlSetBkColor($aLblBtnControlsSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
		EndIf
	Next

	For $i = 0 To UBound($aChkDonateAllControlsSpell) - 1
		GUICtrlSetState($aChkDonateAllControlsSpell[$i], $GUI_UNCHECKED)
	Next

	For $i = 0 To UBound($aTxtDonateControlsSpell) - 1
		If BitAND(GUICtrlGetState($aTxtDonateControlsSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtDonateControlsSpell[$i], $GUI_ENABLE)
	Next

	For $i = 0 To UBound($aTxtBlacklistControlsSpell) - 1
		If BitAND(GUICtrlGetState($aTxtBlacklistControlsSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtBlacklistControlsSpell[$i], $GUI_ENABLE)
	Next
EndFunc   ;==>_DonateControlsSpell
