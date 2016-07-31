; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Local $x = 25, $y = 45
	$grpTSActivate = GUICtrlCreateGroup(GetTranslated(625,0, -1), $x - 20, $y - 20, 190, 305)
		$x -= 15
		$chkTSActivateSearches = GUICtrlCreateCheckbox(GetTranslated(625,1, -1), $x, $y, 68, 18)
			$txtTip = GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,69, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkTSActivateSearches")
		$txtTSSearchesMin = GUICtrlCreateInput("1", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,2, -1) & @CRLF & @CRLF & GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,69, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$lblTSSearches = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
		$txtTSSearchesMax = GUICtrlCreateInput("9999", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)) ;ChrW(8734)
			$txtTip = GetTranslated(625,3, -1) & @CRLF & @CRLF & GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,69,-1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picTSSearches = GUICtrlCreateIcon($pIconLib, $eIcnMagnifier, $x + 163, $y + 1, 16, 16)
	$y +=21
		$chkTSActivateTropies = GUICtrlCreateCheckbox(GetTranslated(625,4, -1), $x, $y, 68, 18)
			$txtTip = GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTSActivateTropies")
		$txtTSTropiesMin = GUICtrlCreateInput("0", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1,$GUI_DISABLE)
			$txtTip = GetTranslated(625,5, -1) & @CRLF & @CRLF & GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$lblTSTropies = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
			GUICtrlSetState(-1,$GUI_DISABLE)
		$txtTSTropiesMax = GUICtrlCreateInput("6000", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1,$GUI_DISABLE)
			$txtTip = GetTranslated(625,6, -1) & @CRLF & @CRLF & GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picTSTrophies = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 163, $y + 1, 16, 16)
	$y +=21
		$chkTSActivateCamps = GUICtrlCreateCheckbox(GetTranslated(625,7, -1), $x, $y, 110, 18)
			$txtTip = GetTranslated(625,8, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTSActivateCamps")
		$lblTSArmyCamps = GUICtrlCreateLabel(ChrW(8805), $x + 113 - 1, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_DISABLE)
		$txtTSArmyCamps = GUICtrlCreateInput("50", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetLimit(-1, 6)
		$txtTSArmyCampsPerc = GUICtrlCreateLabel("%", $x + 163 + 3, $y + 4, -1, -1)
			GUICtrlSetState(-1,$GUI_DISABLE)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 220, $y = 45
	$grpTSFilter = GUICtrlCreateGroup(GetTranslated(625,14, -1), $x - 20, $y - 20, 225, 305)
		$x -= 15
		$cmbTSMeetGE = GUICtrlCreateCombo("", $x , $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(625,15, -1) & @CRLF & GetTranslated(625,16, -1) & @CRLF & GetTranslated(625,17, -1) & @CRLF & GetTranslated(625,18, -1)
			GUICtrlSetData(-1, GetTranslated(625,19, -1) &"|" & GetTranslated(625,20, -1) & "|" & GetTranslated(625,21, -1), GetTranslated(625,22, -1))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbTSGoldElixir")
		$txtTSMinGold = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,23, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picTSMinGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$txtTSMinElixir = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,24, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picTSMinElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y -= 11
		$txtTSMinGoldPlusElixir = GUICtrlCreateInput("160000", $x + 85, $y, 50, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,25, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState (-1, $GUI_HIDE)
 		$picTSMinGPEGold = GUICtrlCreateIcon($pIconLib, $eIcnGoldElixir, $x + 137, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $txtTip)
 			GUICtrlSetState (-1, $GUI_HIDE)
		$y += 34
		$chkTSMeetDE = GUICtrlCreateCheckbox(GetTranslated(625,26, -1), $x, $y, -1, -1)
			$txtTip = GetTranslated(625,27, -1)
			GUICtrlSetOnEvent(-1, "chkTSMeetDE")
			_GUICtrlSetTip(-1, $txtTip)
		$txtTSMinDarkElixir = GUICtrlCreateInput("600", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,28, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, True)
		$picTSMinDarkElixir = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 24
;~ 		$chkSkipTrapped = GUICtrlCreateCheckbox(GetTranslated(2,58, "Skip Trapped"), $x , $y, -1, -1)
;~ 			$txtTip = GetTranslated(2,60, "Skip Trapped Townhall")
;~ 			_GUICtrlSetTip(-1, $txtTip)
;~		$btnConfigureSkipTrapped = GUICtrlCreateButton(GetTranslated(2,61, "..."), $x+84, $y, 30,20)
;~	 	    GUICtrlSetOnEvent(-1, "OpenGUISkipTrappedTH")
		$y +=35
		$lblAddTiles = GUICtrlCreateLabel(GetTranslated(625,42, "TownHall, Distance From") , $x , $y + 4, -1, -1, $SS_LEFT)
		$y += 16
		$lblAddTiles2 = GUICtrlCreateLabel(GetTranslated(625,43, "Border, Add Tiles") & ":" , $x+5 , $y + 4, -1, -1, $SS_LEFT)
		$y += 21
		$lblSWTTiles = GUICtrlCreateLabel("- " & GetTranslated(625,44, "While Train"), $x, $y + 4, 100, -1, $SS_LEFT)
			$txtTip = GetTranslated(625,45, "Add number of tiles from Base Edges")
			_GUICtrlSetTip(-1, $txtTip)
		$txtSWTTiles = GUICtrlCreateInput("2", $x + 85, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 1)
 		$picSWTiles = GUICtrlCreateIcon($pIconLib, $eIcnTiles, $x + 137, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $txtTip)
		$y += 24
		$lblTHadd = GUICtrlCreateLabel("- " & GetTranslated(625,46, "Full Troops"), $x, $y + 4, -1, 17, $SS_LEFT)
		    $txtTip = GetTranslated(625,47, "Enter how many 'Grass' 1x1 tiles the TH may be from the Base edges to be seen as a TH Outside.") & @CRLF & GetTranslated(625,48, "Ex: (0) tiles; TH must be exactly at the edge. (4) tiles: TH may be 4 tiles farther from edges and closer to the center of the village.") & @CRLF & GetTranslated(625,49, "If the TH is farther away then the No. of tiles set, the base will be skipped.")
			_GUICtrlSetTip(-1, $txtTip)
		$txtTHaddtiles = GUICtrlCreateInput("2", $x + 85, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 1)
 		$picTHaddtiles = GUICtrlCreateIcon($pIconLib, $eIcnTiles, $x + 137, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
