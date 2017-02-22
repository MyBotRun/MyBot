; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Search" tab under the "TH Snipe" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

; Start search if
Global $g_hChkTSActivateSearches = 0, $g_hTxtTSSearchesMin = 0, $g_hTxtTSSearchesMax = 0, $g_hChkTSActivateTropies = 0, $g_hTxtTSTropiesMin = 0, _
	   $g_hTxtTSTropiesMax = 0, $g_hChkTSActivateCamps = 0, $g_hTxtTSArmyCamps = 0
Global $g_hLblTSSearches = 0, $g_hLblTSTropies = 0, $g_hLblTSArmyCamps = 0

; Filter
Global $g_hCmbTSMeetGE = 0, $g_hTxtTSMinGold = 0, $g_hTxtTSMinElixir = 0, $g_hTxtTSMinGoldPlusElixir = 0
Global $g_hChkTSMeetDE = 0, $g_hTxtTSMinDarkElixir = 0
Global $g_hTxtSWTTiles = 0, $g_hTxtTHaddTiles = 0
Global $g_hGrpTSFilter = 0, $g_hPicTSMinGold = 0, $g_hPicTSMinElixir = 0, $g_hPicTSMinGPEGold = 0, $g_hPicTSMinDarkElixir = 0
Global $g_hLblAddTiles = 0, $g_hLblAddTiles2 = 0, $g_hLblSWTTiles = 0, $g_hLblTHadd = 0

Func CreateAttackSearchTHSnipeSearch()
   Local $sTxtTip = ""
   Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslated(625,0, -1), $x - 20, $y - 20, 190, 305)
		$x -= 15
		$g_hChkTSActivateSearches = GUICtrlCreateCheckbox(GetTranslated(603,5, -1), $x, $y, 68, 18)
			_GUICtrlSetTip(-1, GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,69, -1))
			GUICtrlSetState(-1,$GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkTSActivateSearches")
		$g_hTxtTSSearchesMin = GUICtrlCreateInput("1", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(625,2, -1) & @CRLF & @CRLF & _
							   GetTranslated(625,68, -1) & @CRLF & _
							   GetTranslated(625,69, -1))
			GUICtrlSetLimit(-1, 6)
		$g_hLblTSSearches = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
		$g_hTxtTSSearchesMax = GUICtrlCreateInput("9999", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)) ;ChrW(8734)
			_GUICtrlSetTip(-1, GetTranslated(625,3, -1) & @CRLF & @CRLF & _
						       GetTranslated(625,68, -1) & @CRLF & _
							   GetTranslated(625,69,-1))
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMagnifier, $x + 163, $y + 1, 16, 16)

	$y +=21
		$g_hChkTSActivateTropies = GUICtrlCreateCheckbox(GetTranslated(625,4, -1), $x, $y, 68, 18)
			_GUICtrlSetTip(-1, GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1))
			GUICtrlSetOnEvent(-1, "chkTSActivateTropies")
		$g_hTxtTSTropiesMin = GUICtrlCreateInput("0", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1,$GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslated(625,5, -1) & @CRLF & @CRLF & _
							   GetTranslated(625,68, -1) & @CRLF & _
							   GetTranslated(625,70,-1))
			GUICtrlSetLimit(-1, 6)
		$g_hLblTSTropies = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
			GUICtrlSetState(-1,$GUI_DISABLE)
		$g_hTxtTSTropiesMax = GUICtrlCreateInput("6000", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1,$GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslated(625,6, -1) & @CRLF & @CRLF & _
							  GetTranslated(625,68, -1) & @CRLF & _
							  GetTranslated(625,70,-1))
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 163, $y + 1, 16, 16)

	$y +=21
		$g_hChkTSActivateCamps = GUICtrlCreateCheckbox(GetTranslated(625,7, -1), $x, $y, 110, 18)
			$sTxtTip = GetTranslated(625,8, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkTSActivateCamps")
		$g_hLblTSArmyCamps = GUICtrlCreateLabel(ChrW(8805), $x + 113 - 1, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_DISABLE)
		$g_hTxtTSArmyCamps = GUICtrlCreateInput("50", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateLabel("%", $x + 163 + 3, $y + 4, -1, -1)
			GUICtrlSetState(-1,$GUI_DISABLE)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)

    Local $x = 220, $y = 45
	$g_hGrpTSFilter = GUICtrlCreateGroup(GetTranslated(625,14, -1), $x - 20, $y - 20, 225, 305)
		$x -= 15
		$g_hCmbTSMeetGE = GUICtrlCreateCombo("", $x , $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslated(625,15, -1) & @CRLF & GetTranslated(625,16, -1) & @CRLF & GetTranslated(625,17, -1) & @CRLF & GetTranslated(625,18, -1)
			GUICtrlSetData(-1, GetTranslated(625,19, -1) &"|" & GetTranslated(625,20, -1) & "|" & GetTranslated(625,21, -1), GetTranslated(625,19, -1))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "cmbTSGoldElixir")
		$g_hTxtTSMinGold = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(625,23, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 6)
		$g_hPicTSMinGold = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 21
		$g_hTxtTSMinElixir = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(625,24, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 6)
		$g_hPicTSMinElixir = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y -= 11
		$g_hTxtTSMinGoldPlusElixir = GUICtrlCreateInput("160000", $x + 85, $y, 50, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(625,25, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState (-1, $GUI_HIDE)
 		$g_hPicTSMinGPEGold = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldElixir, $x + 137, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $sTxtTip)
 			GUICtrlSetState (-1, $GUI_HIDE)

		$y += 34
		$g_hChkTSMeetDE = GUICtrlCreateCheckbox(GetTranslated(625,26, -1), $x, $y, -1, -1)
			$sTxtTip = GetTranslated(625,27, -1)
			GUICtrlSetOnEvent(-1, "chkTSMeetDE")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtTSMinDarkElixir = GUICtrlCreateInput("600", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(625,28, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, True)
		$g_hPicTSMinDarkElixir = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 24
;~ 		$chkSkipTrapped = GUICtrlCreateCheckbox(GetTranslated(2,58, "Skip Trapped"), $x , $y, -1, -1)
;~ 			$sTxtTip = GetTranslated(2,60, "Skip Trapped Townhall")
;~ 			_GUICtrlSetTip(-1, $sTxtTip)
;~		$btnConfigureSkipTrapped = GUICtrlCreateButton(GetTranslated(2,61, "..."), $x+84, $y, 30,20)
;~	 	    GUICtrlSetOnEvent(-1, "OpenGUISkipTrappedTH")

		$y +=35
		$g_hLblAddTiles = GUICtrlCreateLabel(GetTranslated(625,42, "TownHall, Distance From") , $x , $y + 4, -1, -1, $SS_LEFT)

		$y += 16
		$g_hLblAddTiles2 = GUICtrlCreateLabel(GetTranslated(625,43, "Border, Add Tiles") & ":" , $x+5 , $y + 4, -1, -1, $SS_LEFT)

		$y += 21
		$g_hLblSWTTiles = GUICtrlCreateLabel("- " & GetTranslated(625,44, "While Train"), $x, $y + 4, 100, -1, $SS_LEFT)
			$sTxtTip = GetTranslated(625,45, "Add number of tiles from Base Edges")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtSWTTiles = GUICtrlCreateInput("2", $x + 85, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 1)
 		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTiles, $x + 137, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 24
		$g_hLblTHadd = GUICtrlCreateLabel("- " & GetTranslated(625,46, "Full Troops"), $x, $y + 4, -1, 17, $SS_LEFT)
		    $sTxtTip = GetTranslated(625,47, "Enter how many 'Grass' 1x1 tiles the TH may be from the Base edges to be seen as a TH Outside.") & @CRLF & GetTranslated(625,48, "Ex: (0) tiles; TH must be exactly at the edge. (4) tiles: TH may be 4 tiles farther from edges and closer to the center of the village.") & @CRLF & GetTranslated(625,49, "If the TH is farther away then the No. of tiles set, the base will be skipped.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtTHaddTiles = GUICtrlCreateInput("2", $x + 85, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 1)
 		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTiles, $x + 137, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
 EndFunc

