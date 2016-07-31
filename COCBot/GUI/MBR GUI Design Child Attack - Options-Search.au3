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

Global $txtSearchReduceCount, $txtSearchReduceGold,$txtSearchReduceElixir, $txtSearchReduceGoldPlusElixir,  $txtSearchReduceDark, $txtSearchReduceTrophy

Local $x = 25, $y = 45

	$grpSearchReduction = GUICtrlCreateGroup(GetTranslated(630,1, "Search Reduction"), $x - 20, $y - 20, 223, 165)
	$x -=13
		$chkSearchReduction = GUICtrlCreateCheckbox(GetTranslated(630,2, "Enable Search Reduction") , $x , $y-4, -1, -1)
			$txtTip = GetTranslated(630,3, "Check this if you want the search values to automatically be lowered after a certain amount of searches.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkSearchReduction")
		$y+=15
		$lblSearchReduceCount = GUICtrlCreateLabel(GetTranslated(630,4, "Reduce targets every"), $x , $y + 3, -1, -1)
 		$txtSearchReduceCount = GUICtrlCreateInput("20", $x +115, $y + 2, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
 			$txtTip = GetTranslated(630,5, "Enter the No. of searches to wait before each reduction occurs.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
	  $lblSearchReduceCount2 = GUICtrlCreateLabel(GetTranslated(603,5, "search(es)."), $x + 160 , $y + 3, -1, -1)
		$y += 21
		$lblSearchReduceGold = GUICtrlCreateLabel(GetTranslated(630,6,"- Reduce Gold"), $x, $y + 3, -1, 17)
			$txtTip = GetTranslated(630,7, "Lower value for Gold by this amount on each step.")
			_GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceGold = GUICtrlCreateInput("2000", $x + 115, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
		$picSearchReduceGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 160, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$lblSearchReduceElixir = GUICtrlCreateLabel(GetTranslated(630,8,"- Reduce Elixir"), $x, $y + 3, -1, 17)
			$txtTip = GetTranslated(630,9, "Lower value for Elixir by this amount on each step.")
			_GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceElixir = GUICtrlCreateInput("2000", $x + 115, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
		$picSearchReduceElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 160, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)

		$y +=21
		$lblSearchReduceGoldPlusElixir = GUICtrlCreateLabel(GetTranslated(630,10,"- Reduce Gold + Elixir"), $x, $y + 3, -1, 17)
			$txtTip = GetTranslated(630,11, "Lower total sum for G+E by this amount on each step.")
			_GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceGoldPlusElixir = GUICtrlCreateInput("4000", $x + 115, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
		$picSearchReduceGPEGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 160, $y + 1, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$lblSearchReduceGPE = GUICtrlCreateLabel("+", $x + 176, $y + 1, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$picSearchReduceGPEElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 182, $y + 1, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$lblSearchReduceDark = GUICtrlCreateLabel(GetTranslated(630,12,"- Reduce Dark Elixir"), $x, $y + 3, -1, 17)
			$txtTip = GetTranslated(630,13, "Lower value for Dark Elixir by this amount on each step.")
			_GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceDark = GUICtrlCreateInput("100", $x + 115, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
		$picSearchReduceDark = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 160, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$lblSearchReduceTrophy = GUICtrlCreateLabel(GetTranslated(630,14,"- Reduce Tropies"), $x, $y + 3, -1, 17)
			$txtTip = GetTranslated(630,15, "Lower value for Trophies by this amount on each step.")
			_GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceTrophy = GUICtrlCreateInput("2", $x + 115, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 1)
		$picSearchReduceTrophy = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 160, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 25
	$y = 212
	$grpVSDelay = GUICtrlCreateGroup(GetTranslated(636,75, "Village Search Delay"), $x - 20, $y - 20, 223, 72)
		$txtTip = GetTranslated(636,76, "Use this slider to change the time to wait between Next clicks when searching for a Village to Attack.") & @CRLF & GetTranslated(636,77, "This might compensate for Out of Sync errors on some PC's.") & @CRLF & GetTranslated(636,78, "NO GUARANTEES! This will not always have the same results!")
		$lblVSDelay0 = GUICtrlCreateLabel(GetTranslated(603,9, -1), $x-14, $y-2, 19, 15, $SS_RIGHT)
			_GUICtrlSetTip(-1, $txtTip)
		$lblVSDelay = GUICtrlCreateLabel("0", $x+7, $y-2, 12, 15, $SS_RIGHT)
			_GUICtrlSetTip(-1, $txtTip)
		$lbltxtVSDelay = GUICtrlCreateLabel(GetTranslated(603,8, "seconds"), $x + 23, $y-2, -1, -1)
		$sldVSDelay = GUICtrlCreateSlider($x + 70, $y - 4, 105, 25, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
			_GUICtrlSetTip(-1, $txtTip)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 12, 0) ; change max/min value
			GUICtrlSetData(-1, 1) ; default value
			GUICtrlSetOnEvent(-1, "sldVSDelay")
		$y += 25
		$lblMaxVSDelay0 = GUICtrlCreateLabel(GetTranslated(636,80, "Max"), $x-12, $y-2, 19, 15, $SS_RIGHT)
			$txtTip = GetTranslated(636,81, "Enable random village search delay value by setting") & @CRLF & GetTranslated(636,82, "bottom Max slide value higher than the top minimum slide")
			_GUICtrlSetTip(-1, $txtTip)
		$lblMaxVSDelay = GUICtrlCreateLabel("0", $x+7, $y-2, 12, 15, $SS_RIGHT)
			_GUICtrlSetTip(-1, $txtTip)
		$lbltxtMaxVSDelay = GUICtrlCreateLabel(GetTranslated(603,8, -1), $x + 23, $y-2, 45, -1)
		$sldMaxVSDelay = GUICtrlCreateSlider($x + 70, $y - 4, 125, 25, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
			_GUICtrlSetTip(-1, $txtTip)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 15, 0) ; change max/min value
			GUICtrlSetData(-1, 4) ; default value
			GUICtrlSetOnEvent(-1, "sldMaxVSDelay")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 253
	$y = 45
	$grpAtkOptions = GUICtrlCreateGroup(GetTranslated(630,16, "Search Options"), $x - 20, $y - 20, 189, 165)
	$x -= 5
	   $chkAttackNow = GUICtrlCreateCheckbox(GetTranslated(630,17, "Attack Now! option."), $x-5, $y -8, -1, -1)
			$txtTip = GetTranslated(630,18, "Check this if you want the option to have an 'Attack Now!' button next to") & @CRLF & GetTranslated(630,25, "the Start and Pause buttons to bypass the dead base or all base search values.") & @CRLF & GetTranslated(630,26, "The Attack Now! button will only appear when searching for villages to Attack.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkAttackNow")
		$lblAttackNow = GUICtrlCreateLabel(GetTranslated(630,19, "Add") & ":", $x +10 , $y + 16, 27, -1, $SS_RIGHT)
			$txtTip = GetTranslated(630,20, "Add this amount of reaction time to slow down the search.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$cmbAttackNowDelay = GUICtrlCreateCombo("", $x + 45, $y + 13, 35, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "0|1|2|3|4|5", "3") ; default value 3
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblAttackNowSec = GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 85, $y + 16, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 45
		$chkRestartSearchLimit = GUICtrlCreateCheckbox( GetTranslated(630,21, "Restart every") & ":", $x-5, $y-8, -1, -1)
			$txtTip = GetTranslated(630,22, "Return To Base after x searches and restart to search enemy villages.")
			Global $txtrestartsearchlimit, $chkbtnscheduler, $btnscheduler
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkRestartSearchLimit")
			$txtRestartSearchlimit = GUICtrlCreateInput("50", $x+15, $y + 15, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
;			GUICtrlSetState(-1, $GUI_DISABLE)  ; Only needed when unchecked at bot start
		$lblRestartSearchLimit = GUICtrlCreateLabel( GetTranslated(603,5, -1), $x + 47, $y + 17, -1, -1)
	$y += 45
		$chkAlertSearch = GUICtrlCreateCheckbox(GetTranslated(630,23, "Alert me when Village found"), $x-5, $y , -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(630,24, "Check this if you want an Audio alarm & a Balloon Tip when a Base to attack is found."))
			GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)


