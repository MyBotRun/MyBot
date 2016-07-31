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

Local $x = 25, $y = 40
	$grpDBAttack = GUICtrlCreateGroup(GetTranslated(624,1,"Attack with"), $x - 20, $y - 15, 145, 223)
		$x -= 15
		$lblDBAlgorithm = GUICtrlCreateLabel(GetTranslated(624,2,"Attack Type") & ":", $x, $y, 135, 18, $SS_LEFT)
		$y += 15
		$cmbDBAlgorithm = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, "")
			GUICtrlSetData(-1, GetTranslated(624,3,"Standard Attack") & "|" & GetTranslated(624,4,"Scripted Attack") & "|" & GetTranslated(624,5,"Milking Attack"), GetTranslated(624,3,-1))
			GUICtrlSetOnEvent(-1, "cmbDBAlgorithm")
		$y += 25
		$lblDBSelectTroop=GUICtrlCreateLabel(GetTranslated(624,6,"Only drop these troops") & ":", $x, $y, 135, 18, $SS_LEFT)
		$y += 15
		$cmbDBSelectTroop=GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(624,7, "Use All Troops") &"|"&GetTranslated(624,8, "Use Troops in Barracks")&"|"&GetTranslated(624,9, "Barb Only")&"|" & GetTranslated(624,10, "Arch Only") &"|"&GetTranslated(624,11, "B+A")&"|"&GetTranslated(624,12, "B+Gob")&"|"&GetTranslated(624,13, "A+Gob")&"|"&GetTranslated(624,14, "B+A+Gi")&"|"&GetTranslated(624,15, "B+A+Gob+Gi")&"|"&GetTranslated(624,16, "B+A+Hog Rider")&"|"&GetTranslated(624,17, "B+A+Minion") , GetTranslated(624,7, -1))
			_GUICtrlSetTip(-1, GetTranslated(624,18,"Select the troops to use in attacks"))
		$y += 25
		$lblDBSelectSpecialTroop=GUICtrlCreateLabel(GetTranslated(624,19,"Special troops to use") & ":",$x, $y, 135, 18, $SS_LEFT)
		$y += 18
		$IMGchkDBKingAttack=GUICtrlCreateIcon($pIconLib, $eIcnKing, $x , $y, 24, 24)
			$txtTip = GetTranslated(624,20, "Use your King when Attacking...") & @CRLF & GetTranslated(624,41, "Enabled with TownHall 7 and higher")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBKingAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x += 46
		$IMGchkDBQueenAttack=GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,21, "Use your Queen when Attacking...")& @CRLF & GetTranslated(624,42, "Enabled with TownHall 9 and higher")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBQueenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
		$IMGchkDBWardenAttack=GUICtrlCreateIcon($pIconLib, $eIcnWarden, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,22, "Use your Warden when Attacking...") & @CRLF & GetTranslated(624,43, "Enabled with Townhall 11")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBWardenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
	    $y +=27
		$x -=92
			$IMGchkDBDropCC=GUICtrlCreateIcon($pIconLib, $eIcnCC, $x, $y, 24, 24)
			$txtTip =GetTranslated(624,23, "Drop your Clan Castle in battle if it contains troops.")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBDropCC = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x += 46
		$IMGchkDBLightSpell=GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,24, "Use your Light Spells when Attacking...")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBLightSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
		$IMGchkDBHealSpell=GUICtrlCreateIcon($pIconLib, $eIcnHealSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,25, "Use your Healing Spells when Attacking...")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBHealSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
	    $y +=27
		$x -=92
		$IMGchkDBRageSpell=GUICtrlCreateIcon($pIconLib, $eIcnRageSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(624,26, "Use your Rage Spells when Attacking...")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBRageSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
			$IMGchkDBJumpSpell=GUICtrlCreateIcon($pIconLib, $eIcnJumpSpell , $x, $y, 24, 24)
			$txtTip =GetTranslated(624,27, "Use your Jump Spells when Attacking...")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBJumpSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x += 46
		$IMGchkDBFreezeSpell=GUICtrlCreateIcon($pIconLib, $eIcnFreezeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(624,28, "Use your Freeze Spells when Attacking...")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBFreezeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
	    $y +=27
		$x -=92
		$IMGchkDBPoisonSpell=GUICtrlCreateIcon($pIconLib, $eIcnPoisonSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(624,29, "Use your Poison Spells when Attacking...")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBPoisonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
		$IMGchkDBEarthquakeSpell=GUICtrlCreateIcon($pIconLib, $eIcnEarthquakeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(624,30, "Use your Earthquake Spells when Attacking...")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBEarthquakeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
		$x +=46
			$IMGchkDBHasteSpell=GUICtrlCreateIcon($pIconLib, $eIcnHasteSpell, $x, $y, 24, 24)
			$txtTip =GetTranslated(624,31, "Use your Haste Spells when Attacking...")
			_GUICtrlSetTip(-1, $txtTip)
		$chkDBHasteSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 10, $y = 268
	$grpTSAttackBeforeDB = GUICtrlCreateGroup(GetTranslated(624,32, "TH Snipe"),  $x - 5, $y - 20, 145, 84,$SS_CENTER)
		$chkTHSnipeBeforeDBEnable = GUICtrlCreateCheckbox(GetTranslated(624,33, "Snipe TH External first") ,$x, $y - 5, -1, -1)
			$txtTip = GetTranslated(624,34, "If TH is external start with a TH Snipe")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTHSnipeBeforeDBEnable")
		$y +=16
		$lblTHSnipeBeforeDBTiles = GUICtrlCreateLabel(GetTranslated(624,35, "Add Tiles")& ":", $x, $y + 3, 70, -1, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$txtTHSnipeBeforeDBTiles = GUICtrlCreateInput("2", $x + 75, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(624,36, "Max numbers of tiles from border to consider TH as external")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
 		$picTHSnipeBeforeDBTiles = GUICtrlCreateIcon($pIconLib, $eIcnTiles, $x + 107, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$cmbTHSnipeBeforeDBScript = GUICtrlCreateCombo("",  $x, $y, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "")
            $txtTip = GetTranslated(624,37, "You can add/edit CSV settings in the CSV\THSnipe folder")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			;GUICtrlSetOnEvent(-1, "cmbAttackTHType")
LoadDBSnipeAttacks()
_GUICtrlComboBox_SetCurSel($cmbTHSnipeBeforeDBScript,_GUICtrlComboBox_FindStringExact($cmbTHSnipeBeforeDBScript, "Bam"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
