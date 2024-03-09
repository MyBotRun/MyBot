; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_ATTACK = 0
Global $g_hGUI_ATTACK_TAB = 0, $g_hGUI_ATTACK_TAB_ITEM1 = 0, $g_hGUI_ATTACK_TAB_ITEM2 = 0, $g_hGUI_ATTACK_TAB_ITEM3 = 0
Global $g_hGUI_DropOrder = 0

#include "MBR GUI Design Child Attack - Troops.au3"
#include "MBR GUI Design Child Attack - Search.au3"
#include "MBR GUI Design Child Attack - Strategies.au3"

Func LoadTranslatedDropOrderList()
	Global $g_asDropOrderList = ["", _
			"Barbarians", "Super Barbarians", "Archers", "Super Archers", "Giants", "Super Giants", "Goblins", "Sneaky Goblins", _
			"Wall Breakers", "Super Wall Breakers", "Balloons", "Rocket Balloons", "Wizards", "Super Wizards", "Healers", _
			"Dragons", "Super Dragons", "Pekkas", "Baby Dragons", "Inferno Dragons", "Miners", "Super Miners", "Electro Dragons", "Yetis", "Dragon Riders", _
			"Electro Titans", "Root Riders", "Minions", "Super Minions", "Hog Riders", "Super Hog Riders", "Valkyries", "Super Valkyries", "Golems", _
			"Witchs", "Super Witchs", "Lava Hounds", "Ice Hounds", "Bowlers", "Super Bowlers", "Ice Golems", "Headhunters", "Apprentice Wardens", _
			"Clan Castle", "Heroes"]
EndFunc   ;==>LoadTranslatedDropOrderList

Global $g_hChkCustomDropOrderEnable = 0
Global $g_ahCmbDropOrder[$eDropOrderCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahImgDropOrder[$eDropOrderCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hBtnDropOrderSet = 0, $g_ahImgDropOrderSet = 0
Global $g_hBtnRemoveDropOrder = 0

Func CreateAttackTab()
	$g_hGUI_ATTACK = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_ATTACK)

	CreateAttackTroops()
	CreateAttackSearch()
	CreateAttackStrategies()

	GUISwitch($g_hGUI_ATTACK)
	$g_hGUI_ATTACK_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_ATTACK_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01", "Train Army"))
	$g_hGUI_ATTACK_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02", "Search && Attack"))
	$g_hGUI_ATTACK_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_03", "Strategies"))

	; needed to init the window now, like if it's a tab
	CreateDropOrderGUI()

	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackTab

Func CreateDropOrderGUI()

	$g_hGUI_DropOrder = _GUICreate(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "GUI_DropOrder", "Attack Custom Dropping Order"), 525, 520, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)
	SetDefaultDropOrderGroup(False)
	LoadTranslatedDropOrderList()

	Local $x = 25, $y = 25
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_03", "Custom Dropping Order"), $x - 20, $y - 20, 511, 397)
	$x += 10
	$y += 20

	$g_hChkCustomDropOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkCustomDropOrderEnable", "Enable Custom Dropping Order"), $x - 13, $y - 22, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkCustomDropOrderEnable_Info_01", "Enable to select a custom troops dropping order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkCustomDropOrderEnable_Info_02", "Will not have effect on CSV Scripted Attack! It's only for Standard Attack.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkCustomDropOrderEnable_Info_03", "For Live and Dead Bases"))
	GUICtrlSetOnEvent(-1, "chkDropOrder")

	; Create translated list of Troops for combo box
	Local $sComboData = ""
	For $j = 0 To UBound($g_asDropOrderList) - 1
		$sComboData &= $g_asDropOrderList[$j] & "|"
	Next

	Local $g_hTxtDropOrder = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "TxtDropOrder", "Enter sequence order for drop of troop #")

	$x += 50
	$y += 20
	For $p = 0 To UBound($g_ahCmbDropOrder) - 1
		If $p < 6 Then
			GUICtrlCreateLabel($p + 1 & ":", $x - 19, $y + 3, -1, 25)
			$g_ahCmbDropOrder[$p] = GUICtrlCreateCombo("", $x, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIDropOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $g_hTxtDropOrder & $p + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgDropOrder[$p] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 123, $y - 2, 24, 24)
			$y += 35     ; move down to next combobox location
		ElseIf $p > 5 And $p < 12 Then
			If $p = 6 Then
				$x += 171
				$y = 64
			EndIf
			GUICtrlCreateLabel($p + 1 & ":", $x - 5, $y + 4, -1, 25)
			$g_ahCmbDropOrder[$p] = GUICtrlCreateCombo("", $x + 20, $y, 110, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIDropOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $g_hTxtDropOrder & $p + 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$g_ahImgDropOrder[$p] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 133, $y - 2, 24, 24)
			$y += 35     ; move down to next combobox location
		Else
			$g_ahCmbDropOrder[$p] = GUICtrlCreateCombo("", $x + 20, $y, 110, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIDropOrder")
			GUICtrlSetData(-1, $sComboData, "")
			GUICtrlSetState(-1, $GUI_HIDE)
		EndIf
	Next

	$x = 125
	$y = 310
	; Create push button to set training order once completed
	$g_hBtnDropOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnDropOrderSet", "Apply New Order"), $x, $y, 100, 25)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_ENABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnDropOrderSet_Info_01", "Push button when finished selecting custom troops dropping order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnDropOrderSet_Info_02", "When not all troop slots are filled, will use random troop order in empty slots!"))
	GUICtrlSetOnEvent(-1, "BtnDropOrderSet")
	$g_ahImgDropOrderSet = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 104, $y + 4, 18, 18)

	$x += 150
	$g_hBtnRemoveDropOrder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnRemoveDropOrder", "Empty Drop List"), $x, $y, 118, 25)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnRemoveDropOrder_Info_01", "Push button to remove all troops from list and start over"))
	GUICtrlSetOnEvent(-1, "BtnRemoveDropOrder")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 35
	; Create a button control.
	Local $g_hBtnClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnClose", "Close"), $x + 33, $y, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCustomDropOrder")

EndFunc   ;==>CreateDropOrderGUI
