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

Func cmbDBGoldElixir()
	If _GUICtrlComboBox_GetCurSel($cmbDBMeetGE) < 2 Then
		GUICtrlSetState($txtDBMinGold, $GUI_SHOW)
		GUICtrlSetState($picDBMinGold, $GUI_SHOW)
		GUICtrlSetState($txtDBMinElixir, $GUI_SHOW)
		GUICtrlSetState($picDBMinElixir, $GUI_SHOW)
		GUICtrlSetState($txtDBMinGoldPlusElixir, $GUI_HIDE)
		GUICtrlSetState($picDBMinGPEGold, $GUI_HIDE)
	Else
		GUICtrlSetState($txtDBMinGold, $GUI_HIDE)
		GUICtrlSetState($picDBMinGold, $GUI_HIDE)
		GUICtrlSetState($txtDBMinElixir, $GUI_HIDE)
		GUICtrlSetState($picDBMinElixir, $GUI_HIDE)
		GUICtrlSetState($txtDBMinGoldPlusElixir, $GUI_SHOW)
		GUICtrlSetState($picDBMinGPEGold, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbDBGoldElixir

Func chkDBMeetDE()
	If GUICtrlRead($chkDBMeetDE) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtDBMinDarkElixir, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtDBMinDarkElixir, True)
	EndIf
EndFunc   ;==>chkDBMeetDE

Func chkDBMeetTrophy()
	If GUICtrlRead($chkDBMeetTrophy) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtDBMinTrophy, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtDBMinTrophy, True)
	EndIf
EndFunc   ;==>chkDBMeetTrophy

Func chkDBMeetTH()
	If GUICtrlRead($chkDBMeetTH) = $GUI_CHECKED Then
		GUICtrlSetState($cmbDBTH, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbDBTH, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDBMeetTH

Func chkDBWeakBase()
	If GUICtrlRead($chkMaxMortar[$DB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakMortar[$DB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakMortar[$DB], $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkMaxWizTower[$DB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakWizTower[$DB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakWizTower[$DB], $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkMaxXBow[$DB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakXBow[$DB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakXBow[$DB], $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkMaxInferno[$DB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakInferno[$DB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakInferno[$DB], $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkMaxEagle[$DB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakEagle[$DB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakEagle[$DB], $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDBWeakBase

Func cmbABGoldElixir()
	If _GUICtrlComboBox_GetCurSel($cmbABMeetGE) < 2 Then
		GUICtrlSetState($txtABMinGold, $GUI_SHOW)
		GUICtrlSetState($picABMinGold, $GUI_SHOW)
		GUICtrlSetState($txtABMinElixir, $GUI_SHOW)
		GUICtrlSetState($picABMinElixir, $GUI_SHOW)
		GUICtrlSetState($txtABMinGoldPlusElixir, $GUI_HIDE)
		GUICtrlSetState($picABMinGPEGold, $GUI_HIDE)
	Else
		GUICtrlSetState($txtABMinGold, $GUI_HIDE)
		GUICtrlSetState($picABMinGold, $GUI_HIDE)
		GUICtrlSetState($txtABMinElixir, $GUI_HIDE)
		GUICtrlSetState($picABMinElixir, $GUI_HIDE)
		GUICtrlSetState($txtABMinGoldPlusElixir, $GUI_SHOW)
		GUICtrlSetState($picABMinGPEGold, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbABGoldElixir

Func chkABMeetDE()
	If GUICtrlRead($chkABMeetDE) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtABMinDarkElixir, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtABMinDarkElixir, True)
	EndIf
EndFunc   ;==>chkABMeetDE

Func chkABMeetTrophy()
	If GUICtrlRead($chkABMeetTrophy) = $GUI_CHECKED Then
		_GUICtrlEdit_SetReadOnly($txtABMinTrophy, False)
	Else
		_GUICtrlEdit_SetReadOnly($txtABMinTrophy, True)
	EndIf
EndFunc   ;==>chkABMeetTrophy

Func chkABMeetTH()
	If GUICtrlRead($chkABMeetTH) = $GUI_CHECKED Then
		GUICtrlSetState($cmbABTH, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbABTH, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkABMeetTH

Func chkABWeakBase()
	If GUICtrlRead($chkMaxMortar[$LB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakMortar[$LB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakMortar[$LB], $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkMaxWizTower[$LB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakWizTower[$LB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakWizTower[$LB], $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkMaxXBow[$LB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakXBow[$LB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakXBow[$LB], $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkMaxInferno[$LB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakInferno[$LB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakInferno[$LB], $GUI_DISABLE)
	EndIf

	If GUICtrlRead($chkMaxEagle[$LB]) = $GUI_CHECKED Then
		GUICtrlSetState($cmbWeakEagle[$LB], $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbWeakEagle[$LB], $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkABWeakBase

Func chkRestartSearchLimit()
	If GUICtrlRead($ChkRestartSearchLimit) = $GUI_CHECKED Then
		GUICtrlSetState($txtRestartSearchlimit, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtRestartSearchlimit, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkRestartSearchLimit


Func btnConfigureCollectors()
;~ 	OpenGUI2()
EndFunc   ;==>btnConfigureCollectors

Func btnConfigureReduction()
;~ 	OpenGUISearchReduction()
EndFunc   ;==>btnConfigureReduction

Func btnConfigureTHBully()
;~ 	OpenGUITHBully()
EndFunc   ;==>btnConfigureTHBully

Func btnConfigureDBWeakBase()
;~ 	OpenGUIWeakbase($DB)
EndFunc   ;==>btnConfigureDBWeakBase

Func btnConfigureABWeakBase()
;~ 	OpenGUIWeakbase($LB)
EndFunc   ;==>btnConfigureABWeakBase

Func chkDBActivateSearches()
	If GUICtrlRead($chkDBActivateSearches) = $GUI_CHECKED Then
		GUICtrlSetState($txtDBSearchesMin, $GUI_ENABLE)
		GUICtrlSetState($lblDBSearches, $GUI_ENABLE)
		GUICtrlSetState($txtDBSearchesMax, $GUI_ENABLE)
		;DBPanel($GUI_SHOW)
		;_GUI_Value_STATE("SHOW", $groupSearchDB)
		;cmbDBGoldElixir()
		;_GUI_Value_STATE("SHOW", $groupHerosDB)
	Else
		GUICtrlSetState($txtDBSearchesMin, $GUI_DISABLE)
		GUICtrlSetState($lblDBSearches, $GUI_DISABLE)
		GUICtrlSetState($txtDBSearchesMax, $GUI_DISABLE)
		;DBPanel($GUI_HIDE)
		;_GUI_Value_STATE("HIDE", $groupSearchDB)
		;_GUI_Value_STATE("HIDE", $groupHerosDB)
	EndIf
	;EnableSearchPanels($DB)
	dbCheckall()
EndFunc   ;==>chkDBActivateSearches

Func chkDBActivateTropies()
	If GUICtrlRead($chkDBActivateTropies) = $GUI_CHECKED Then
		GUICtrlSetState($txtDBTropiesMin, $GUI_ENABLE)
		GUICtrlSetState($lblDBTropies, $GUI_ENABLE)
		GUICtrlSetState($txtDBTropiesMax, $GUI_ENABLE)
		;_GUI_Value_STATE("SHOW", $groupSearchDB)
		;cmbDBGoldElixir()
		;_GUI_Value_STATE("SHOW", $groupHerosDB)
	Else
		GUICtrlSetState($txtDBTropiesMin, $GUI_DISABLE)
		GUICtrlSetState($lblDBTropies, $GUI_DISABLE)
		GUICtrlSetState($txtDBTropiesMax, $GUI_DISABLE)
		;_GUI_Value_STATE("HIDE", $groupSearchDB)
		;_GUI_Value_STATE("HIDE", $groupHerosDB)
	EndIf
	;EnableSearchPanels($DB)
	dbCheckall()
EndFunc   ;==>chkDBActivateTropies

Func chkDBActivateCamps()
	If GUICtrlRead($chkDBActivateCamps) = $GUI_CHECKED Then
		GUICtrlSetState($lblDBArmyCamps, $GUI_ENABLE)
		GUICtrlSetState($txtDBArmyCamps, $GUI_ENABLE)
		;_GUI_Value_STATE("SHOW", $groupSearchDB)
		;cmbDBGoldElixir()
		;_GUI_Value_STATE("SHOW", $groupHerosDB)
	Else
		GUICtrlSetState($lblDBArmyCamps, $GUI_DISABLE)
		GUICtrlSetState($txtDBArmyCamps, $GUI_DISABLE)
		;_GUI_Value_STATE("HIDE", $groupSearchDB)
		;_GUI_Value_STATE("HIDE", $groupHerosDB)
	EndIf
	;EnableSearchPanels($DB)
	dbCheckall()
EndFunc   ;==>chkDBActivateCamps

#cs
Func DBPanel($Style_GUI)
	GUICtrlSetState($grpDBFilter, $Style_GUI)
	GUICtrlSetState($cmbDBMeetGE, $Style_GUI)
	GUICtrlSetState($txtDBMinGold, $Style_GUI)
	GUICtrlSetState($picDBMinGold, $Style_GUI)
	GUICtrlSetState($txtDBMinElixir, $Style_GUI)
	GUICtrlSetState($picDBMinElixir, $Style_GUI)
	GUICtrlSetState($txtDBMinGoldPlusElixir, $Style_GUI)
	GUICtrlSetState($picDBMinGPEGold, $Style_GUI)
	GUICtrlSetState($chkDBMeetDE, $Style_GUI)
	GUICtrlSetState($txtDBMinDarkElixir, $Style_GUI)
	GUICtrlSetState($picDBMinDarkElixir, $Style_GUI)
	GUICtrlSetState($chkDBMeetTrophy, $Style_GUI)
	GUICtrlSetState($txtDBMinTrophy, $Style_GUI)
	GUICtrlSetState($picDBMinTrophies, $Style_GUI)
	GUICtrlSetState($chkDBMeetTH, $Style_GUI)
	GUICtrlSetState($cmbDBTH, $Style_GUI)
	GUICtrlSetState($picDBMaxTH10, $Style_GUI)
	GUICtrlSetState($chkDBMeetTHO, $Style_GUI)
	GUICtrlSetState($chkDBWeakBase, $Style_GUI)
	GUICtrlSetState($chkDBMeetOne, $Style_GUI)
	GUICtrlSetState($cmbDBWeakMortar, $Style_GUI)
	GUICtrlSetState($picDBWeakMortar, $Style_GUI)
	GUICtrlSetState($cmbDBWeakWizTower, $Style_GUI)
	GUICtrlSetState($picDBWeakWizTower, $Style_GUI)

EndFunc   ;==>
#ce

Func EnableSearchPanels($mode)
	;_GUI_Value_STATE("HIDE", $groupAttackDBSpell&"#"&$groupIMGAttackDBSpell&"#"&$groupAttackABSpell&"#"&$groupIMGAttackABSpell)
	Switch $mode
		Case $DB
			If GUICtrlRead($chkDBActivateSearches) = $GUI_CHECKED Or GUICtrlRead($chkDBActivateTropies) = $GUI_CHECKED Or GUICtrlRead($chkDBActivateCamps) = $GUI_CHECKED Or GUICtrlRead($chkDBKingWait) = $GUI_CHECKED Or GUICtrlRead($chkDBQueenWait) = $GUI_CHECKED Or GUICtrlRead($chkDBWardenWait) = $GUI_CHECKED Or GUICtrlRead($chkDBSpellsWait) = $GUI_CHECKED Then
				_GUI_Value_STATE("SHOW", $groupHerosDB)
				;search
				_GUI_Value_STATE("SHOW", $groupSearchDB)
				;spells
				_GUI_Value_STATE("SHOW", $groupSpellsDB)

				cmbDBGoldElixir()
				;attack
				;_GUI_Value_STATE("SHOW", $groupAttackDB)
				;_GUI_Value_STATE("SHOW", $groupIMGAttackDB)
				;end battle
				;_GUI_Value_STATE("SHOW", $groupEndBattkeDB)
				;cmbDBAlgorithm()
			Else
				_GUI_Value_STATE("HIDE", $groupHerosDB)
				;search
				_GUI_Value_STATE("HIDE", $groupSearchDB)
				;attack

				;Spells
				_GUI_Value_STATE("HIDE", $groupSpellsDB)

				;_GUI_Value_STATE("HIDE", $groupAttackDB)
				;_GUI_Value_STATE("HIDE", $groupIMGAttackDB)
				;end battle
				;_GUI_Value_STATE("HIDE", $groupEndBattkeDB)
			EndIf
		Case $LB
			If GUICtrlRead($chkABActivateSearches) = $GUI_CHECKED Or GUICtrlRead($chkABActivateTropies) = $GUI_CHECKED Or GUICtrlRead($chkABActivateCamps) = $GUI_CHECKED Or GUICtrlRead($chkABKingWait) = $GUI_CHECKED Or GUICtrlRead($chkABQueenWait) = $GUI_CHECKED Or GUICtrlRead($chkABWardenWait) = $GUI_CHECKED Or GUICtrlRead($chkABSpellsWait) = $GUI_CHECKED Then
				_GUI_Value_STATE("SHOW", $groupHerosAB)
				;search
				_GUI_Value_STATE("SHOW", $groupSearchAB)
				;Spells
				_GUI_Value_STATE("SHOW", $groupSpellsAB)

				cmbABGoldElixir()
				;attack
				;_GUI_Value_STATE("SHOW", $groupAttackAB)
				;_GUI_Value_STATE("SHOW", $groupIMGAttackAB)
				;end battle
				;_GUI_Value_STATE("SHOW", $groupEndBattkeAB)
				;cmbABAlgorithm()
			Else
				_GUI_Value_STATE("HIDE", $groupHerosAB)
				;search
				_GUI_Value_STATE("HIDE", $groupSearchAB)
				;attack

				;Spells
				_GUI_Value_STATE("HIDE", $groupSpellsAB)

				;_GUI_Value_STATE("HIDE", $groupAttackAB)
				;_GUI_Value_STATE("HIDE", $groupIMGAttackAB)
				;end battle
				;_GUI_Value_STATE("HIDE", $groupEndBattkeAB)
			EndIf
		Case $TS
			If GUICtrlRead($chkTSActivateSearches) = $GUI_CHECKED Or GUICtrlRead($chkTSActivateTropies) = $GUI_CHECKED Or GUICtrlRead($chkTSActivateCamps) = $GUI_CHECKED Then
				;search
				_GUI_Value_STATE("SHOW", $groupSearchTS)
				cmbTSGoldElixir()
				;attack
				;_GUI_Value_STATE("SHOW", $groupAttackTS)
				;_GUI_Value_STATE("SHOW", $groupIMGAttackTS)
				;_GUI_Value_STATE("SHOW", $groupAttackTSSpell)
				;_GUI_Value_STATE("SHOW", $groupIMGAttackTSSpell)
				;end battle
				;_GUI_Value_STATE("SHOW", $groupEndBattkeTS)
			Else
				;search
				_GUI_Value_STATE("HIDE", $groupSearchTS)
				;attack
				;_GUI_Value_STATE("HIDE", $groupAttackTS)
				;_GUI_Value_STATE("HIDE", $groupIMGAttackTS)
				;_GUI_Value_STATE("HIDE", $groupAttackTSSpell)
				;_GUI_Value_STATE("HIDE", $groupIMGAttackTSSpell)
				;end battle
				;_GUI_Value_STATE("HIDE", $groupEndBattkeTS)
			EndIf
	EndSwitch
	;tabAttack()
EndFunc   ;==>EnableSearchPanels




Func chkABActivateSearches()
	If GUICtrlRead($chkABActivateSearches) = $GUI_CHECKED Then
		GUICtrlSetState($txtABSearchesMin, $GUI_ENABLE)
		GUICtrlSetState($lblABSearches, $GUI_ENABLE)
		GUICtrlSetState($txtABSearchesMax, $GUI_ENABLE)
		;_GUI_Value_STATE("SHOW", $groupSearchAB)
		;cmbABGoldElixir()
		;_GUI_Value_STATE("SHOW", $groupHerosAB)
	Else
		GUICtrlSetState($txtABSearchesMin, $GUI_DISABLE)
		GUICtrlSetState($lblABSearches, $GUI_DISABLE)
		GUICtrlSetState($txtABSearchesMax, $GUI_DISABLE)
		;_GUI_Value_STATE("HIDE", $groupSearchAB)
		;_GUI_Value_STATE("HIDE", $groupHerosAB)
	EndIf
	;EnableSearchPanels($LB)
	abCheckall()
EndFunc   ;==>chkABActivateSearches

Func chkABActivateTropies()
	If GUICtrlRead($chkABActivateTropies) = $GUI_CHECKED Then
		GUICtrlSetState($txtABTropiesMin, $GUI_ENABLE)
		GUICtrlSetState($lblABTropies, $GUI_ENABLE)
		GUICtrlSetState($txtABTropiesMax, $GUI_ENABLE)
		;_GUI_Value_STATE("SHOW", $groupSearchAB)
		;cmbABGoldElixir()
		;_GUI_Value_STATE("SHOW", $groupHerosAB)
	Else
		GUICtrlSetState($txtABTropiesMin, $GUI_DISABLE)
		GUICtrlSetState($lblABTropies, $GUI_DISABLE)
		GUICtrlSetState($txtABTropiesMax, $GUI_DISABLE)
		;_GUI_Value_STATE("HIDE", $groupSearchAB)
		;_GUI_Value_STATE("HIDE", $groupHerosAB)
	EndIf
	;EnableSearchPanels($LB)
	abCheckall()
EndFunc   ;==>chkABActivateTropies

Func chkABActivateCamps()
	If GUICtrlRead($chkABActivateCamps) = $GUI_CHECKED Then
		GUICtrlSetState($lblABArmyCamps, $GUI_ENABLE)
		GUICtrlSetState($txtABArmyCamps, $GUI_ENABLE)
		;_GUI_Value_STATE("SHOW", $groupSearchAB)
		;cmbABGoldElixir()
		;_GUI_Value_STATE("SHOW", $groupHerosAB)
	Else
		GUICtrlSetState($lblABArmyCamps, $GUI_DISABLE)
		GUICtrlSetState($txtABArmyCamps, $GUI_DISABLE)
		;_GUI_Value_STATE("HIDE", $groupSearchAB)
		;_GUI_Value_STATE("HIDE", $groupHerosAB)
	EndIf
	;EnableSearchPanels($LB)
	abCheckall()
EndFunc   ;==>chkABActivateCamps

Func chkTSActivateSearches()
	If GUICtrlRead($chkTSActivateSearches) = $GUI_CHECKED Then
		GUICtrlSetState($txtTSSearchesMin, $GUI_ENABLE)
		GUICtrlSetState($lblTSSearches, $GUI_ENABLE)
		GUICtrlSetState($txtTSSearchesMax, $GUI_ENABLE)
		;_GUI_Value_STATE("SHOW", $groupSearchTS)
		;cmbTSGoldElixir()
	Else
		GUICtrlSetState($txtTSSearchesMin, $GUI_DISABLE)
		GUICtrlSetState($lblTSSearches, $GUI_DISABLE)
		GUICtrlSetState($txtTSSearchesMax, $GUI_DISABLE)
		;_GUI_Value_STATE("HIDE", $groupSearchTS)
	EndIf
	;EnableSearchPanels($TS)
	tsCheckall()
EndFunc   ;==>chkTSActivateSearches

Func chkTSActivateTropies()
	If GUICtrlRead($chkTSActivateTropies) = $GUI_CHECKED Then
		GUICtrlSetState($txtTSTropiesMin, $GUI_ENABLE)
		GUICtrlSetState($lblTSTropies, $GUI_ENABLE)
		GUICtrlSetState($txtTSTropiesMax, $GUI_ENABLE)
		;_GUI_Value_STATE("SHOW", $groupSearchTS)
		;cmbTSGoldElixir()
	Else
		GUICtrlSetState($txtTSTropiesMin, $GUI_DISABLE)
		GUICtrlSetState($lblTSTropies, $GUI_DISABLE)
		GUICtrlSetState($txtTSTropiesMax, $GUI_DISABLE)
		;_GUI_Value_STATE("HIDE", $groupSearchTS)
	EndIf
	;EnableSearchPanels($TS)
	tsCheckAll()
EndFunc   ;==>chkTSActivateTropies

Func chkTSActivateCamps()
	If GUICtrlRead($chkTSActivateCamps) = $GUI_CHECKED Then
		GUICtrlSetState($lblTSArmyCamps, $GUI_ENABLE)
		GUICtrlSetState($txtTSArmyCamps, $GUI_ENABLE)
		;_GUI_Value_STATE("SHOW", $groupSearchTS)
		;cmbTSGoldElixir()
	Else
		GUICtrlSetState($lblTSArmyCamps, $GUI_DISABLE)
		GUICtrlSetState($txtTSArmyCamps, $GUI_DISABLE)
		;_GUI_Value_STATE("HIDE", $groupSearchTS)
	EndIf
	;EnableSearchPanels($TS)
	tsCheckAll()
EndFunc   ;==>chkTSActivateCamps

Func chkDBKingWait()
	If $iTownHallLevel > 6 Or $iTownHallLevel = 0 Then ; Must be TH7 or above to have King
		If GUICtrlRead($chkDBKingWait) = $GUI_CHECKED Then
			If $ichkUpgradeKing = 0 Then
				GUICtrlSetState($chkDBKingAttack, $GUI_CHECKED)
			Else
				GUICtrlSetState($chkDBKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		Else
			If $ichkUpgradeKing = 0 Then
				GUICtrlSetState($chkDBKingWait, $GUI_ENABLE)
			Else
				GUICtrlSetState($chkDBKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		EndIf
	Else
		GUICtrlSetState($chkDBKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($chkDBKingAttack, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkDBKingWait

Func chkDBQueenWait()
	If $iTownHallLevel > 8 Or $iTownHallLevel = 0 Then ; Must be TH9 or above to have Queen
		If GUICtrlRead($chkDBQueenWait) = $GUI_CHECKED Then
			If $ichkUpgradeQueen = 0 Then
				GUICtrlSetState($chkDBQueenAttack, $GUI_CHECKED)
			Else
				GUICtrlSetState($chkDBQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		Else
			If $ichkUpgradeQueen = 0 Then
				GUICtrlSetState($chkDBQueenWait, $GUI_ENABLE)
			Else
				GUICtrlSetState($chkDBQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		EndIf
	Else
		GUICtrlSetState($chkDBQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($chkDBQueenAttack, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkDBQueenWait

Func chkDBWardenWait()
	If $iTownHallLevel > 10 Or $iTownHallLevel = 0 Then ; Must be TH11 to have warden
		If GUICtrlRead($chkDBWardenWait) = $GUI_CHECKED Then
			If $ichkUpgradeWarden = 0 Then
				GUICtrlSetState($chkDBWardenAttack, $GUI_CHECKED)
				GUICtrlSetState($IMGchkDBWardenWait, $GUI_ENABLE)
			Else
				GUICtrlSetState($chkDBWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		Else
			If $ichkUpgradeWarden = 0 Then
				GUICtrlSetState($chkDBWardenWait, $GUI_ENABLE)
			Else
				GUICtrlSetState($chkDBWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		EndIf
	Else
		GUICtrlSetState($chkDBWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($chkDBWardenAttack, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkDBWardenWait

Func chkABKingWait()
	If $iTownHallLevel > 6 Or $iTownHallLevel = 0 Then ; Must be TH7 or above to have King
		If GUICtrlRead($chkABKingWait) = $GUI_CHECKED Then
			If $ichkUpgradeKing = 0 Then
				GUICtrlSetState($chkABKingAttack, $GUI_CHECKED)
			Else
				GUICtrlSetState($chkABKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		Else
			If $ichkUpgradeKing = 0 Then
				GUICtrlSetState($chkABKingWait, $GUI_ENABLE)
			Else
				GUICtrlSetState($chkABKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		EndIf
	Else
		GUICtrlSetState($chkABKingWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($chkABKingAttack, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkABKingWait

Func chkABQueenWait()
	If $iTownHallLevel > 8 Or $iTownHallLevel = 0 Then ; Must be TH9 or above to have Queen
		If GUICtrlRead($chkABQueenWait) = $GUI_CHECKED Then
			If $ichkUpgradeQueen = 0 Then
				GUICtrlSetState($chkABQueenAttack, $GUI_CHECKED)
			Else
				GUICtrlSetState($chkABQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		Else
			If $ichkUpgradeQueen = 0 Then
				GUICtrlSetState($chkABQueenWait, $GUI_ENABLE)
			Else
				GUICtrlSetState($chkABQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		EndIf
	Else
		GUICtrlSetState($chkABQueenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($chkABQueenAttack, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkABQueenWait

Func chkABWardenWait()
	If $iTownHallLevel > 10 Or $iTownHallLevel = 0 Then ; Must be TH11 to have warden
		If GUICtrlRead($chkABWardenWait) = $GUI_CHECKED Then
			If $ichkUpgradeWarden = 0 Then
				GUICtrlSetState($chkABWardenAttack, $GUI_CHECKED)
			Else
				GUICtrlSetState($chkABWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		Else
			If $ichkUpgradeWarden = 0 Then
				GUICtrlSetState($chkABWardenWait, $GUI_ENABLE)
			Else
				GUICtrlSetState($chkABWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
			EndIf
		EndIf
	Else
		GUICtrlSetState($chkABWardenWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($chkABWardenAttack, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkABWardenWait

Func chkDBSpellsWait()
	If $iTownHallLevel > 4 Or $iTownHallLevel = 0 Then ; Must be TH5+ to have spells
		For $i = $IMGchkDBLightSpellWait To $IMGchkDBHasteSpellWait
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		If GUICtrlRead($chkDBSpellsWait) = $GUI_CHECKED Then
			$iEnableSpellsWait[$DB] = 1
			chkSpellWaitError()
			If @error Then
				GUICtrlSetState($chkDBSpellsWait, $GUI_UNCHECKED)
				$iEnableSpellsWait[$DB] = 0
				Setlog("Wait for Spells disabled due training count error", $COLOR_RED)
			EndIf
		Else
			$iEnableSpellsWait[$DB] = 0
		EndIf
	Else
		GUICtrlSetState($chkDBSpellsWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		For $i = $IMGchkDBLightSpellWait To $IMGchkDBHasteSpellWait
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc

Func chkABSpellsWait()
	If $iTownHallLevel > 4 Or $iTownHallLevel = 0 Then ; Must be TH5+ to have spells
		For $i = $IMGchkABLightSpellWait To $IMGchkABHasteSpellWait
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		If GUICtrlRead($chkABSpellsWait) = $GUI_CHECKED Then
			$iEnableSpellsWait[$LB] = 1
			chkSpellWaitError()
			If @error Then
				GUICtrlSetState($chkABSpellsWait, $GUI_UNCHECKED)
				$iEnableSpellsWait[$LB] = 0
				Setlog("Wait for Spells disabled due training count error", $COLOR_RED)
			EndIf
		Else
			$iEnableSpellsWait[$LB] = 0
		EndIf
	Else
		GUICtrlSetState($chkABSpellsWait, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		For $i = $IMGchkABLightSpellWait To $IMGchkABHasteSpellWait
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc

Func chkSpellWaitError()

	Local Static $bHaveBeenWarned = False
	Local $bErrorCondition = False
	Local $sErrorText, $sText, $MsgBox1, $MsgBox2, $MsgBox3

	; Check if spell total GUI is larger than spell count trained for wait for spells to work properly!
	If $iTotalTrainSpaceSpell > GUICtrlRead($txtTotalCountSpell) Then  ; we have an error!
		$sErrorText = GetTranslated(625,110, "Total number of trained spells exceeds total set in GUI!") & @CRLF & _
			GetTranslated(625,111, "Reduce number of trained spells,") & @CRLF & _
			GetTranslated(625,112, "OR ELSE BOT WILL NEVER ATTACK!!") & @CRLF
		$bErrorCondition = True
	Else
		Return
	EndIf

	If $bHaveBeenWarned = True And $bErrorCondition = True Then
		SetError(1)
		Return
	ElseIf $bErrorCondition = False Then
		Return
	EndIf

	Local $iCount = 0
	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0xE00000, 0xFFFF00, 12, "Comic Sans MS", 480)
		$sText = $sErrorText & @CRLF & GetTranslated(625,113,"Click YES to close this warning message") & @CRLF
		$MsgBox1 = _ExtMsgBox(48, GetTranslated(625,114,"YES, I Understand Warning|No"), GetTranslated(625,115,"Wait for Spells Warning!"), $sText, 30, $frmBot)
		Switch $MsgBox1
			Case 1
				$bHaveBeenWarned = True
				ExitLoop
			Case Else
				_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0xFFFF00 , 0xE00000, 12, "Comic Sans MS", 480)
				$stext = GetTranslated(625,116,"Sorry, must understand warning and click Yes!") & @CRLF
				$MsgBox2 = _ExtMsgBox(16, GetTranslated(625,117,"OK"), GetTranslated(625,118,"User Input Error"), $stext, 15, $frmBot)
				If $iCount = 1 And $MsgBox1 = 9 And $MsgBox2 = 9 Then ExitLoop  ; If time out on both error messages happens twice then exit loop to avoid stuck
		EndSwitch
		$iCount += 1
		If $iCount > 2 Then  ; You want to be crazy?  OK, then start the madness
			$sText = GetTranslated(625,119,"CONGRATULATIONS!!") & @CRLF & GetTranslated(625,120,"You found the secret message in Bot!") & @CRLF & _
				GetTranslated(625,121,"Can you find the randomly selected button to close this message?") & @CRLF & _
				GetTranslated(625,122, "HaHaHaHa...") & @CRLF & @CRLF & @CRLF
			$sFunnyText = $sText
			$iCount = 1
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 480)
			While 1
				$MsgBox3 = _ExtMsgBox(128, "1|2|3|4|5|6|7", GetTranslated(625,123,"You are a WINNER!!"), $sFunnyText, 900, $frmBot)
				If @error Then Setlog("_ExtMsgBox error: " & @error, $COLOR_RED)
				If $iCount > 7 And Int($MsgBox3) = Random(1,8,1) Then
					ExitLoop
				Else
					If $iCount <= 7 Then
						$iControl = $iCount
					Else
						$iControl = $MsgBox3
					EndIf
					Switch $iControl
						Case 1
							_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x61FF00, 0x020028, 12, "Arial", 480)
							$sFunnyText = $sText & GetTranslated(625,124,"Sorry not that button!") & @CRLF
						Case 2
							_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0xDC00FF, 0x011E00, 12, "Comic Sans MS", 480)
							$sFunnyText = $sText & GetTranslated(625,125,"Donate £5000 to MyBot.run while you wait 15 minutes for this to time out?") & @CRLF
						Case 3
							_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x000000, 0xFFFFFF, 12, "Tahoma", 480)
							$sFunnyText = $sText & GetTranslated(625,126,"Having trouble finding the exit button?") & @CRLF
						Case 4
							_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x4800FF, 0xD800FF, 12, "Comic Sans MS", 480)
							$sFunnyText = $sText & GetTranslated(625,127,"This is fun, can we keep going all day?") & @CRLF
						Case 5
							_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Times New Roman", 480)
							$sFunnyText = $sText & GetTranslated(625,128,"Try four more times, you have to get lucky sooner or later!") & @CRLF
						Case 6
							_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x00FFED, 0x010051, 12, "Comic Sans MS", 480)
							$sFunnyText = $sText & GetTranslated(625,129,"Do you have a Banana? This code monkey is Hungry!") & @CRLF
						Case 7
							_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0xFF6600, 0x013000, 12, "Lucida Console", 480)
							$sFunnyText = $sText & GetTranslated(625,130,"Maybe try hitting same button till you and Mr. Random pick same?") & @CRLF
						Case 0
							_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x000000, 0xFFFFFF, 12, "Tahoma", 480)
							$sFunnyText = $sText & GetTranslated(625,131,"Sorry, can not 'escape' from this!") & @CRLF
						Case Else
							_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 480)
							$sFunnyText = $sText & GetTranslated(625,132,"Program error! Programmers can ruin a good joke.") & @CRLF
							ExitLoop 2
					EndSwitch
					$iCount += 1
				EndIf
			WEnd
		EndIf
	WEnd
	If $bErrorCondition = True Then
		SetError(1)
		Return
	EndIf
EndFunc

