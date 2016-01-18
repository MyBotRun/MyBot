; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkRequest()
	If GUICtrlRead($chkRequest) = $GUI_CHECKED Then
		$ichkRequest = 1
		GUICtrlSetState($txtRequest, $GUI_ENABLE)
	Else
		$ichkRequest = 0
		GUICtrlSetState($txtRequest, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkRequest

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


;;; Custom Combination Donate by ChiefM3
Func btnDonateCustom()
	If GUICtrlGetState($grpCustom) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($grpCustom, $txtBlacklistCustom)
	EndIf
EndFunc   ;==>btnDonateCustom

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

;;; Custom Combination Donate by ChiefM3
Func chkDonateAllCustom()
	If GUICtrlRead($chkDonateAllCustom) = $GUI_CHECKED Then
		_DonateAllControls(16, True)
	Else
		_DonateAllControls(16, False)
	EndIf
EndFunc   ;==>chkDonateAllCustom

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

;;; Custom Combination Donate by ChiefM3
Func chkDonateCustom()
	If GUICtrlRead($chkDonateCustom) = $GUI_CHECKED Then
		_DonateControls(16)
	Else
		GUICtrlSetBkColor($lblBtnCustom, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc   ;==>chkDonateCustom

Func cmbDonateCustom()
	Local $combo1 = _GUICtrlComboBox_GetCurSel($cmbDonateCustom1)
	Local $combo2 = _GUICtrlComboBox_GetCurSel($cmbDonateCustom2)
	Local $combo3 = _GUICtrlComboBox_GetCurSel($cmbDonateCustom3)
	GUICtrlSetImage($picDonateCustom1, $pIconLib, $aDonIcons[$combo1])
	GUICtrlSetImage($picDonateCustom2, $pIconLib, $aDonIcons[$combo2])
	GUICtrlSetImage($picDonateCustom3, $pIconLib, $aDonIcons[$combo3])
EndFunc   ;==>cmbDonateCustom
