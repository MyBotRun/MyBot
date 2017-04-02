; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

; Attack with
Global $g_hCmbDBAlgorithm = 0, $g_hCmbDBSelectTroop = 0, $g_hChkDBKingAttack = 0, $g_hChkDBQueenAttack = 0, $g_hChkDBWardenAttack = 0, $g_hChkDBDropCC = 0
Global $g_hChkDBLightSpell = 0, $g_hChkDBHealSpell = 0, $g_hChkDBRageSpell = 0, $g_hChkDBJumpSpell = 0, $g_hChkDBFreezeSpell = 0, $g_hChkDBCloneSpell = 0, _
	   $g_hChkDBPoisonSpell = 0, $g_hChkDBEarthquakeSpell = 0, $g_hChkDBHasteSpell = 0, $g_hChkDBSkeletonSpell = 0

Global $g_hPicDBKingAttack = 0, $g_hPicDBQueenAttack = 0, $g_hPicDBWardenAttack = 0, $g_hPicDBDropCC = 0
Global $g_hPicDBLightSpell = 0, $g_hPicDBHealSpell = 0, $g_hPicDBRageSpell = 0, $g_hPicDBJumpSpell = 0, $g_hPicDBFreezeSpell = 0, $g_hPicDBCloneSpell = 0, _
	   $g_hPicDBPoisonSpell = 0, $g_hPicDBEarthquakeSpell = 0, $g_hPicDBHasteSpell = 0, $g_hPicDBSkeletonSpell = 0

; TH Snipe
Global $g_hChkTHSnipeBeforeDBEnable = 0, $g_hTxtTHSnipeBeforeDBTiles = 0, $g_hCmbTHSnipeBeforeDBScript = 0
Global $g_hLblTHSnipeBeforeDBTiles = 0

Func CreateAttackSearchDeadBaseAttack()
   Local $sTxtTip = ""
   Local $x = 25, $y = 40
	   GUICtrlCreateGroup(GetTranslated(624,1,"Attack with"), $x - 20, $y - 15, 145, 223)
		   $x -= 15
		   $y += 5
		   $g_hCmbDBAlgorithm = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   _GUICtrlSetTip(-1, "")
			   GUICtrlSetData(-1, GetTranslated(624,3,"Standard Attack") & "|" & GetTranslated(624,4,"Scripted Attack") & "|" & GetTranslated(624,5,"Milking Attack"), GetTranslated(624,3,-1))
			   GUICtrlSetOnEvent(-1, "cmbDBAlgorithm")
		   $y += 30
		   $g_hCmbDBSelectTroop = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, GetTranslated(624,7, "Use All Troops") &"|"&GetTranslated(624,8, "Use Troops in Barracks")&"|"&GetTranslated(624,9, "Barb Only")&"|" & GetTranslated(624,10, "Arch Only") &"|"&GetTranslated(624,11, "B+A")&"|"&GetTranslated(624,12, "B+Gob")&"|"&GetTranslated(624,13, "A+Gob")&"|"&GetTranslated(624,14, "B+A+Gi")&"|"&GetTranslated(624,15, "B+A+Gob+Gi")&"|"&GetTranslated(624,16, "B+A+Hog Rider")&"|"&GetTranslated(624,17, "B+A+Minion") , GetTranslated(624,7, -1))
			   _GUICtrlSetTip(-1, GetTranslated(624,18,"Select the troops to use in attacks"))
		   $y += 30
		   $g_hPicDBKingAttack = GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x , $y, 24, 24)
			   $sTxtTip = GetTranslated(624,20, "Use your King when Attacking...") & @CRLF & GetTranslated(624,41, "Enabled with TownHall 7 and higher")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBKingAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $x += 46
		   $g_hPicDBQueenAttack = GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,21, "Use your Queen when Attacking...")& @CRLF & GetTranslated(624,42, "Enabled with TownHall 9 and higher")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBQueenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $x +=46
		   $g_hPicDBWardenAttack = GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,22, "Use your Warden when Attacking...") & @CRLF & GetTranslated(624,43, "Enabled with Townhall 11")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBWardenAttack = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y +=27
		   $x -=92
		   $g_hPicDBDropCC = GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x, $y, 24, 24)
			   $sTxtTip =GetTranslated(624,23, "Drop your Clan Castle in battle if it contains troops.")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBDropCC = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $x += 46
		   $g_hPicDBLightSpell = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,24, "Use your Light Spells when Attacking...")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBLightSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $x +=46
		   $g_hPicDBHealSpell = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,25, "Use your Healing Spells when Attacking...")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBHealSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y +=27
		   $x -=92
		   $g_hPicDBRageSpell = GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,26, "Use your Rage Spells when Attacking...")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBRageSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $x +=46
		   $g_hPicDBJumpSpell = GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell , $x, $y, 24, 24)
			   $sTxtTip =GetTranslated(624,27, "Use your Jump Spells when Attacking...")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBJumpSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $x += 46
		   $g_hPicDBFreezeSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell , $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,28, "Use your Freeze Spells when Attacking...")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBFreezeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $y +=27
		   $x -=92
		   $g_hPicDBCloneSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell , $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,44, "Use your Clone Spells when Attacking...")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBCloneSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $x +=46
		   $g_hPicDBPoisonSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell , $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,29, "Use your Poison Spells when Attacking...")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBPoisonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $x +=46
		   $g_hPicDBEarthquakeSpell = GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell , $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,30, "Use your Earthquake Spells when Attacking...")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBEarthquakeSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y +=27
		   $x -=92
		   $g_hPicDBHasteSpell = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x, $y, 24, 24)
		   $sTxtTip =GetTranslated(624,31, "Use your Haste Spells when Attacking...")
		   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBHasteSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
		   _GUICtrlSetTip(-1, $sTxtTip)
		   $x +=46
		   $g_hPicDBSkeletonSpell=GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell , $x, $y, 24, 24)
			   $sTxtTip = GetTranslated(624,45, "Use your Skeletons Spells when Attacking...")
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hChkDBSkeletonSpell = GUICtrlCreateCheckbox("", $x + 27, $y, 17, 17)
			   _GUICtrlSetTip(-1, $sTxtTip)

	   GUICtrlCreateGroup("", -99, -99, 1, 1)

   Local $x = 10, $y = 268
	   GUICtrlCreateGroup(GetTranslated(624,32, "TH Snipe"),  $x - 5, $y - 20, 145, 84,$SS_CENTER)
		   $g_hChkTHSnipeBeforeDBEnable = GUICtrlCreateCheckbox(GetTranslated(624,33, "Snipe TH External first") ,$x, $y - 5, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(624,34, "If TH is external start with a TH Snipe"))
			   GUICtrlSetOnEvent(-1, "chkTHSnipeBeforeDBEnable")
		   $y +=16
		   $g_hLblTHSnipeBeforeDBTiles = GUICtrlCreateLabel(GetTranslated(624,35, "Add Tiles")& ":", $x, $y + 3, 70, -1, $SS_RIGHT)
		   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_hTxtTHSnipeBeforeDBTiles = GUICtrlCreateInput("2", $x + 75, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   $sTxtTip = GetTranslated(624,36, "Max numbers of tiles from border to consider TH as external")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetLimit(-1, 2)
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnTiles, $x + 107, $y + 1, 16, 16)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y += 21
		   $g_hCmbTHSnipeBeforeDBScript = GUICtrlCreateCombo("",  $x, $y, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, "")
			   _GUICtrlSetTip(-1, GetTranslated(624,37, "You can add/edit CSV settings in the CSV\THSnipe folder"))
			   GUICtrlSetState(-1, $GUI_DISABLE)
			   ;GUICtrlSetOnEvent(-1, "cmbAttackTHType")
   LoadDBSnipeAttacks()
   _GUICtrlComboBox_SetCurSel($g_hCmbTHSnipeBeforeDBScript,_GUICtrlComboBox_FindStringExact($g_hCmbTHSnipeBeforeDBScript, "Bam"))

   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
