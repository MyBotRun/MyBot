; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

$hGUI_VILLAGE = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $frmBot)
;GUISetBkColor($COLOR_WHITE, $hGUI_VILLAGE)

;creating subchilds first!
;#include "MBR GUI Design Child Village - Misc.au3"
#include "MBR GUI Design Child Village - Donate.au3"
#include "MBR GUI Design Child Village - Upgrade.au3"
#include "MBR GUI Design Child Village - Notify.au3"

GUISwitch($hGUI_VILLAGE)

;~ -------------------------------------------------------------
;~ Waiting Full Army Camps
;~ -------------------------------------------------------------

; village tab
;============
$hGUI_VILLAGE_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
$hGUI_VILLAGE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,6,"Misc"))
#include "MBR GUI Design Child Village - Misc.au3"
GUICtrlCreateTabItem("")

$hGUI_VILLAGE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,7,"Req. && Donate"))
GUICtrlCreateTabItem("")
$hGUI_VILLAGE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,8,"Upgrade"))
GUICtrlCreateTabItem("")

$hGUI_VILLAGE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600,9,"Achievements"))

Global $txtUnbreakable, $txtUnBrkMinGold,$txtUnBrkMaxGold,$txtUnBrkMinElixir, $txtUnBrkMaxElixir,$txtUnBrkMinDark, $txtUnBrkMaxDark ,$chkUnbreakable

   $x = 25
   $y = 45
	$grpDefenseFarming = GUICtrlCreateGroup(GetTranslated(618,1, "Defense Farming"), $x - 20, $y - 20, 440, 150)
		$y +=10
			$chkUnbreakable = GUICtrlCreateCheckbox(GetTranslated(618,2, "Enable Unbreakable"), $x - 10, $y, -1, -1)
			$TxtTip = GetTranslated(618,3, "Enable farming Defense Wins for Unbreakable achievement.") ;& @CRLF & "TIP: Set your trophy range on the Misc Tab to '600 - 800' for best results. WARNING: Doing so will DROP you Trophies!"
			GUICtrlSetTip(-1, $TxtTip)
			GUICtrlSetOnEvent(-1, "chkUnbreakable")
	$picUnbreakable1 = GUICtrlCreateIcon($pIconLib, $eIcnGoldStar, $x + 10, $y + 51, 32, 32)
	$picUnbreakable2 = GUICtrlCreateIcon($pIconLib, $eIcnGoldStar, $x + 42, $y + 36, 48, 48)
	$picUnbreakable3 = GUICtrlCreateIcon($pIconLib, $eIcnGoldStar, $x + 90, $y + 51, 32, 32)
	$x = 150
		$lblUnbreakable1 = GUICtrlCreateLabel(GetTranslated(618,4, "Wait Time") & ":", $x - 10, $y + 3, 86, -1, $SS_RIGHT)
		$txtUnbreakable = GUICtrlCreateInput("5", $x + 80, $y, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$TxtTip = GetTranslated(618,5, "Set the amount of time to stop CoC and wait for enemy attacks to gain defense wins. (1-99 minutes)")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
		$lblUnbreakable2 = GUICtrlCreateLabel(GetTranslated(618,6, "Minutes"), $x + 113, $y+3, -1, -1)
		$y += 28
		$lblUnBreakableFarm = GUICtrlCreateLabel(GetTranslated(618,7, "Farm Min."), $x + 25 , $y, -1, -1)
		$lblUnBreakableSave = GUICtrlCreateLabel(GetTranslated(618,8, "Save Min."), $x + 115 , $y, -1, -1)
		$y += 16
		$txtUnBrkMinGold = GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetTip(-1, GetTranslated(618,9, "Amount of Gold that stops Defense farming, switches to normal farming if below.") & @CRLF & GetTranslated(618,10, "Set this value to amount of Gold you need for searching or upgrades."))
			GUICtrlSetLimit(-1, 7)
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 80, $y + 2, 16, 16)
		$txtUnBrkMaxGold = GUICtrlCreateInput("600000", $x + 110, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetTip(-1, GetTranslated(618,11, "Amount of Gold in Storage Required to Enable Defense Farming.") & @CRLF & GetTranslated(618,12, "Input amount of Gold you need to attract enemy or for upgrades."))
			GUICtrlSetLimit(-1, 7)
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 170, $y + 2, 16, 16)
		$y += 26
		$txtUnBrkMinElixir = GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetTip(-1, GetTranslated(618,13, "Amount of Elixir that stops Defense farming, switches to normal farming if below.") & @CRLF & GetTranslated(618,14, "Set this value to amount of Elixir you need for making troops or upgrades."))
			GUICtrlSetLimit(-1, 7)
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 80, $y, 16, 16)
		$txtUnBrkMaxElixir = GUICtrlCreateInput("600000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetTip(-1, GetTranslated(618,15, "Amount of Elixir in Storage Required to Enable Defense Farming.") & @CRLF & GetTranslated(618,16, "Input amount of Elixir you need to attract enemy or for upgrades."))
			GUICtrlSetLimit(-1, 7)
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 170, $y, 16, 16)
		$y += 24
		$txtUnBrkMinDark = GUICtrlCreateInput("5000", $x + 20, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetTip(-1, GetTranslated(618,17, "Amount of Dark Elixir that stops Defense farming, switches to normal farming if below.") & @CRLF & GetTranslated(618,18, "Set this value to amount of Dark Elixir you need for making troops or upgrades."))
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 80, $y, 16, 16)
		$txtUnBrkMaxDark = GUICtrlCreateInput("6000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetTip(-1, GetTranslated(618,19, "Amount of Dark Elixir in Storage Required to Enable Defense Farming.") & @CRLF & GetTranslated(618,20, "Input amount of Dark Elixir you need to attract enemy or for upgrades."))
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 170, $y, 16, 16)
    GUICtrlCreateGroup("", -99, -99, 1, 1)

$x = 25
$y = 200
	$grpUnbreakableHelp = GUICtrlCreateGroup(GetTranslated(618,21,"How to use Unbreakable Mode"), $x - 20, $y - 20, 440, 200)
	$txtHelp = GetTranslated(618,22,"Unbreakable mode will help you gain defense wins and the ""Unbreakable"" achievement.") & _
		@CRLF & GetTranslated(618,23,"Set ""Wait Time"" to how long you want the bot to wait for defenses." ) & _
		@CRLF & GetTranslated(618,24,"Farm Min is how many resources the bot must have before attacking." ) & _
		@CRLF & GetTranslated(618,25,"Save Min is how many resources the bot must have before starting unbreakable mode." ) & _
		@CRLF & GetTranslated(618,26,"Click the below link for more information:" )
	$lblUnbreakableHelp = GUICtrlCreateLabel($txtHelp, $x - 10, $y, 430, 125)
	$lblUnbreakableLink = GUICtrlCreateLabel(GetTranslated(618,27,"More Info"), $x - 10, $y + 100, 100,20)
		_GUIToolTip_AddTool($hToolTip, 0, "https://mybot.run/forums/index.php?/topic/2964-guide-how-to-use-mybot-unbreakable-mode-updated/", GUICtrlGetHandle($lblUnbreakableLink))
		GUICtrlSetFont(-1, 8.5, $FW_BOLD, $GUI_FONTUNDER)
		GUICtrlSetColor(-1, $COLOR_BLUE)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

$hGUI_VILLAGE_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslated(600,10,"Notify"))
GUICtrlCreateTabItem("")

;GUISetState()



