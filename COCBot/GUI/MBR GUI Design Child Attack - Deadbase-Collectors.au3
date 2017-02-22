; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Collectors" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkDBDisableCollectorsFilter = 0
Global $g_ahChkDBCollectorLevel[13] = [-1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0] ; elements 0 thru 5 are never referenced
Global $g_ahCmbDBCollectorLevel[13] = [-1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0] ; elements 0 thru 5 are never referenced
Global $g_hCmbMinCollectorMatches = 0, $g_hSldCollectorTolerance = 0, $g_hLblCollectorWarning = 0

Func CreateAttackSearchDeadBaseCollectors()
   Local $x = 10, $y = 45
   Local $s_TxtTip1 = GetTranslated(626,15, "If this box is checked, then the bot will look")
   Local $g_hTxtFull = GetTranslated(626,30, "Full")
   Local $sTxtTip = ""

   GUICtrlCreateGroup(GetTranslated(626,1,"Collectors"), $x - 5, $y - 20, 420, 305)
		GUICtrlCreateLabel(GetTranslated(626,2, "Choose which collectors to search for while looking for a dead base. Also, choose how full they must be."), $x, $y, 250, 28)
		$g_hChkDBDisableCollectorsFilter = GUICtrlCreateCheckbox(GetTranslated(626,32,"Disable Collector Filter"), $x+250, $y+60, 150, 18)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslated(626,33, "Excluding Collector Filter the bot consider DeadBase as ActiveBase"))

		$y+=40
		$g_ahChkDBCollectorLevel[6] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslated(626,16, "for level 6 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(626,3, "Lvl 6. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahCmbDBCollectorLevel[6] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(626,23,'Select how full a level 6 collector needs to be for it to be marked "dead"'))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	    $y+= 25
		$g_ahChkDBCollectorLevel[7] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslated(626,17, "for level 7 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(626,4, "Lvl 7. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[7] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(626,24,'Select how full a level 7 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	    $y+= 25
		$g_ahChkDBCollectorLevel[8] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslated(626,18,"for level 8 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(626,5, "Lvl 8. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[8] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(626,25,'Select how full a level 8 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	    $y+= 25
		$g_ahChkDBCollectorLevel[9] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslated(626,19,"for level 9 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(626,6, "Lvl 9. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[9] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(626,26,'Select how full a level 9 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	    $y+= 25
		$g_ahChkDBCollectorLevel[10] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslated(626,20,"for level 10 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(626,7, "Lvl 10. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[10] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(626,27,'Select how full a level 10 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	    $y+= 25
		$g_ahChkDBCollectorLevel[11] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslated(626,21,"for level 11 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(626,8, "Lvl 11. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[11] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(626,28,'Select how full a level 11 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	    $y+= 25
		$g_ahChkDBCollectorLevel[12] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslated(626,22,"for level 12 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBCollector")
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(626,9, "Lvl 12. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahCmbDBCollectorLevel[12] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(626,29,'Select how full a level 12 collector needs to be for it to be marked "dead"'))
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbDBCollector")
		GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)

	    $y+= 25
		GUICtrlCreateLabel(GetTranslated(626,34, "Collectors required"), $x, $y + 3, -1, -1)
			$sTxtTip = GetTranslated(626,35,'Select how many collectors are needed to consider village "dead"')
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hCmbMinCollectorMatches = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6", "3")
			GUICtrlSetOnEvent(-1, "cmbMinCollectorMatches")

	    $y += 25
		GUICtrlCreateLabel("-15" & _PadStringCenter(GetTranslated(626,11, "Tolerance"), 66, " ") & "15", $x, $y)
		;If $g_bDevMode = False Then
			GUICtrlSetState(-1, $GUI_HIDE)
		;EndIf

	    $y += 15
		$g_hSldCollectorTolerance = GUICtrlCreateSlider($x, $y, 250, 20, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			_GUICtrlSetTip(-1, GetTranslated(626,12, "Use this slider to adjust the tolerance of ALL images.") & @CRLF & _
						       GetTranslated(626,13, "If you want to adjust individual images, you must edit the files.") & @CRLF & _
							   GetTranslated(626,31,"WARNING: Do not change this setting unless you know what you are doing. Set it to 0 if you're not sure."))
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1,1)
			GUICtrlSetLimit(-1, 15,-15) ; change max/min value
			GUICtrlSetData(-1, 0) ; default value
			GUICtrlSetOnEvent(-1, "sldCollectorTolerance")
		;If $g_bDevMode = False Then
			GUICtrlSetState(-1, $GUI_HIDE)
		;EndIf

	    $y += 25
		$g_hLblCollectorWarning = GUICtrlCreateLabel("Warning: no collecters are selected. The bot will never find a dead base.", $x, $y, 255, 30)
			GUICtrlSetFont(-1, 10, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_ERROR)
			GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
 EndFunc
