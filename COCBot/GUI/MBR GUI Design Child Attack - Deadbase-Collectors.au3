; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Collectors" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkDBDisableCollectorsFilter = 0
Global $g_ahChkDBCollectorLevel[14] = [-1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0] ; elements 0 thru 5 are never referenced
Global $g_ahCmbDBCollectorLevel[14] = [-1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0] ; elements 0 thru 5 are never referenced
Global $g_hCmbMinCollectorMatches = 0, $g_hSldCollectorTolerance = 0, $g_hLblCollectorWarning = 0

Func CreateAttackSearchDeadBaseCollectors()
	Local $x = 10, $y = 45
	Local $s_TxtTip1 = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel_Info_01", "If this box is checked, then the bot will look")
	Local $g_hTxtFull = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel_Info_02", "Full")
	Local $sTxtTip = ""

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "Group_01", "Collectors"), $x - 5, $y - 20, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel", "Choose which collectors to search for while looking for a dead base. Also, choose how full they must be."), $x, $y, 250, 28)
		$g_hChkDBDisableCollectorsFilter = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDisableCollectorsFilter", "Disable Collector Filter"), $x + 250, $y + 60, 150, 18)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDisableCollectorsFilter_Info_01", "Disable Collector Filter CHANGES DeadBase into another ActiveBase search"))

	$y += 15
	For $i = 6 To 13
		$y += 25
			$g_ahChkDBCollectorLevel[$i] = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
				$sTxtTip = $s_TxtTip1 & @CRLF & GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkCollectorLevel" & $i & "_Info_01", "for level " & $i & " elixir collectors during dead base detection.")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState(-1, ($i = 6 ? GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE)) : $GUI_CHECKED))
				GUICtrlSetOnEvent(-1, "chkDBCollector")
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel" & $i, "Lvl " & $i & ". Must be >"), $x + 40, $y + 3, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_ahCmbDBCollectorLevel[$i] = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorLevel" & $i & "_Info_01", "Select how full a level " & $i & ' collector needs to be for it to be marked "dead"'))
				GUICtrlSetData(-1, "50%|100%", "50%")
				GUICtrlSetOnEvent(-1, "cmbDBCollector")
			GUICtrlCreateLabel($g_hTxtFull, $x + 205, $y + 3)
	Next

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblMinCollectorMatches", "Collectors required"), $x, $y + 3, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "CmbMinCollectorMatches_Info_01", 'Select how many collectors are needed to consider village "dead"')
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hCmbMinCollectorMatches = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6", "3")
			GUICtrlSetOnEvent(-1, "cmbMinCollectorMatches")

	$y += 25
		GUICtrlCreateLabel("-15" & _PadStringCenter(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorTolerance", "Tolerance"), 66, " ") & "15", $x, $y)
		;If $g_bDevMode = False Then
			GUICtrlSetState(-1, $GUI_HIDE)
		;EndIf

	$y += 15
		$g_hSldCollectorTolerance = GUICtrlCreateSlider($x, $y, 250, 20, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_01", "Use this slider to adjust the tolerance of ALL images.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_02", "If you want to adjust individual images, you must edit the files.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_03", "WARNING: Do not change this setting unless you know what you are doing. Set it to 0 if you're not sure."))
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 15, -15) ; change max/min value
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

EndFunc   ;==>CreateAttackSearchDeadBaseCollectors
