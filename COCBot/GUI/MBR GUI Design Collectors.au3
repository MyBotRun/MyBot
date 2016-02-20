; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Collectors
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: zengzeng
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $chkLvl6, $chkLvl7, $chkLvl8, $chkLvl9, $chkLvl10, $chkLvl11, $chkLvl12
Global $cmbLvl6, $cmbLvl7, $cmbLvl8, $cmbLvl9, $cmbLvl10, $cmbLvl11, $cmbLvl12
Global $sldCollectorTolerance

Func GUI2()
	$hCollectorGUI = GUICreate(GetTranslated(15,1, "Choose Collectors"), 305, 300, 85, 60, -1, $WS_EX_MDICHILD, $frmbot)
	GUISetIcon($pIconLib, $eIcnGUI)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseGUI2") ; Run this function when the secondary GUI [X] is clicked
	GUICtrlCreateLabel(GetTranslated(15,2, "Choose which collectors to search for while looking for a dead base. Also, choose how full they must be."), 5, 5, 290, 28)
	$x = 5
	$y = 45
	Local $txtTip1 = GetTranslated(15,15, "If this box is checked, then the bot will look")
	Local $txtFull = GetTranslated(15,30, "Full")
	$chkLvl6 = GUICtrlCreateCheckbox(GetTranslated(15,3, "Enable Elixir Collectors Lvl 6. Must be >"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(15,16,"for level 6 elixir collectors during dead base detection.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkLvl6")
	$y+= 25
	$chkLvl7 = GUICtrlCreateCheckbox(GetTranslated(15,4, "Enable Elixir Collectors Lvl 7. Must be >"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(15,17,"for level 7 elixir collectors during dead base detection.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkLvl7")
	$y+= 25
	$chkLvl8 = GUICtrlCreateCheckbox(GetTranslated(15,5, "Enable Elixir Collectors Lvl 8. Must be >"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(15,18,"for level 8 elixir collectors during dead base detection.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkLvl8")
	$y+= 25
	$chkLvl9 = GUICtrlCreateCheckbox(GetTranslated(15,6, "Enable Elixir Collectors Lvl 9. Must be >"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(15,19,"for level 9 elixir collectors during dead base detection.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkLvl9")
	$y+= 25
	$chkLvl10 = GUICtrlCreateCheckbox(GetTranslated(15,7, "Enable Elixir Collectors Lvl 10. Must be >"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(15,20,"for level 10 elixir collectors during dead base detection.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkLvl10")
	$y+= 25
	$chkLvl11 = GUICtrlCreateCheckbox(GetTranslated(15,8, "Enable Elixir Collectors Lvl 11. Must be >"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(15,21,"for level 11 elixir collectors during dead base detection.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkLvl11")
	$y+= 25
	$chkLvl12 = GUICtrlCreateCheckbox(GetTranslated(15,9, "Enable Elixir Collectors Lvl 12. Must be >"), $x, $y)
		$txtTip = $txtTip1&@CRLF&GetTranslated(15,22,"for level 12 elixir collectors during dead base detection.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkLvl12")

	$x = 214
	$y = 45
	$cmbLvl6 = GUICtrlCreateCombo("", $x, $y, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(15,23,'Select how full a level 6 collector needs to be for it to be marked "dead"')
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, "50% " & GetTranslated(15,10, "(N/A)")& "|75%|90%+")
		GUICtrlSetOnEvent(-1, "cmbLvl6")
		GuiCtrlCreateLabel($txtFull, 286,$y+3)
	$y+= 25
	$cmbLvl7 = GUICtrlCreateCombo("", $x, $y, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(15,24,'Select how full a level 7 collector needs to be for it to be marked "dead"')
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, "50% " & GetTranslated(15,10,-1) & "|75%|90%+")
		GUICtrlSetOnEvent(-1, "cmbLvl7")
		GuiCtrlCreateLabel($txtFull, 286,$y+3)
	$y+= 25
	$cmbLvl8 = GUICtrlCreateCombo("", $x, $y, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(15,25,'Select how full a level 8 collector needs to be for it to be marked "dead"')
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, "50% " & GetTranslated(15,10,-1) & "|75%|90%+")
		GUICtrlSetOnEvent(-1, "cmbLvl8")
		GuiCtrlCreateLabel($txtFull, 286,$y+3)
	$y+= 25
	$cmbLvl9 = GUICtrlCreateCombo("", $x, $y, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(15,26,'Select how full a level 9 collector needs to be for it to be marked "dead"')
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, "50% " & GetTranslated(15,10,-1) & "|75%|90%+")
		GUICtrlSetOnEvent(-1, "cmbLvl9")
		GuiCtrlCreateLabel($txtFull, 286,$y+3)
	$y+= 25
	$cmbLvl10 = GUICtrlCreateCombo("", $x, $y, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(15,27,'Select how full a level 10 collector needs to be for it to be marked "dead"')
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, "50% " & GetTranslated(15,10,-1) & "|75%|90%+")
		GUICtrlSetOnEvent(-1, "cmbLvl10")
		GuiCtrlCreateLabel($txtFull, 286,$y+3)
	$y+= 25
	$cmbLvl11 = GUICtrlCreateCombo("", $x, $y, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(15,28,'Select how full a level 11 collector needs to be for it to be marked "dead"')
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, "50% " & GetTranslated(15,10,-1) & "|75%|90%+")
		GUICtrlSetOnEvent(-1, "cmbLvl11")
		GuiCtrlCreateLabel($txtFull, 286,$y+3)
	$y+= 25
	$cmbLvl12 = GUICtrlCreateCombo("", $x, $y, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(15,29,'Select how full a level 12 collector needs to be for it to be marked "dead"')
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, "50% " & GetTranslated(15,10,-1) & "|75%|90%+")
		GUICtrlSetOnEvent(-1, "cmbLvl12")
		GuiCtrlCreateLabel($txtFull, 286,$y+3)
	$y+= 50

	$lblTolerance = GUICtrlCreateLabel("-15" & _PadStringCenter(GetTranslated(15,11, "Tolerance"), 80, " ") & "15", 5, $y - 15)
	$sldCollectorTolerance = GUICtrlCreateSlider(5, $y, 290, 20, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
	$txtTip = GetTranslated(15,12, "Use this slider to adjust the tolerance of ALL images.") &@CRLF& GetTranslated(15,13, "If you want to adjust individual images, you must edit the files.")&@CRLF&GetTranslated(15,31,"WARNING: Do not change this setting unless you know what you are doing. Set it to 0 if you're not sure.")
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetTip(-1, $txtTip)
		_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
		_GUICtrlSlider_SetTicFreq(-1,1)
		GUICtrlSetLimit(-1, 15,-15) ; change max/min value
		GUICtrlSetData(-1, 0) ; default value
		GUICtrlSetOnEvent(-1, "sldCollectorTolerance")

	$y+=30
	$btnSaveExit = GUICtrlCreateButton(GetTranslated(15,14, "Save And Close"), 5, $y, 290, 20)
	GUICtrlSetOnEvent(-1, "CloseGUI2")

EndFunc
