; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Achievements" tab under the "Village" tab
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

Global $g_hChkUnbreakable = 0, $g_hTxtUnbreakable = 0, $g_hTxtUnBrkMinGold = 0, $g_hTxtUnBrkMaxGold = 0, $g_hTxtUnBrkMinElixir = 0, _
	   $g_hTxtUnBrkMaxElixir = 0, $g_hTxtUnBrkMinDark = 0, $g_hTxtUnBrkMaxDark = 0
Global $g_hLblUnbreakableHelp = 0, $g_hLblUnbreakableLink = 0

Func CreateVillageAchievements()
   Local $x = 25
   Local $y = 45
   GUICtrlCreateGroup(GetTranslated(618,1, "Defense Farming"), $x - 20, $y - 20, 440, 150)
	  $y +=10
	  $g_hChkUnbreakable = GUICtrlCreateCheckbox(GetTranslated(618,2, "Enable Unbreakable"), $x - 10, $y, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(618,3, "Enable farming Defense Wins for Unbreakable achievement.")) ;& @CRLF & "TIP: Set your trophy range on the Misc Tab to '600 - 800' for best results. WARNING: Doing so will DROP you Trophies!"
	  GUICtrlSetOnEvent(-1, "chkUnbreakable")

	  GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldStar, $x + 10, $y + 51, 32, 32)
	  GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldStar, $x + 42, $y + 36, 48, 48)
	  GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldStar, $x + 90, $y + 51, 32, 32)

	  $x = 150
	  GUICtrlCreateLabel(GetTranslated(618,4, "Wait Time") & ":", $x - 10, $y + 3, 86, -1, $SS_RIGHT)
	  $g_hTxtUnbreakable = GUICtrlCreateInput("5", $x + 80, $y, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslated(618,5, "Set the amount of time to stop CoC and wait for enemy attacks to gain defense wins. (1-99 minutes)"))
			GUICtrlSetLimit(-1, 2)
	  GUICtrlCreateLabel(GetTranslated(618,6, "Minutes"), $x + 113, $y+3, -1, -1)

	  $y += 28
	  GUICtrlCreateLabel(GetTranslated(618,7, "Farm Min."), $x + 25 , $y, -1, -1)
	  GUICtrlCreateLabel(GetTranslated(618,8, "Save Min."), $x + 115 , $y, -1, -1)

	  $y += 16
	  $g_hTxtUnBrkMinGold = GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		 GUICtrlSetState(-1, $GUI_DISABLE)
		 _GUICtrlSetTip(-1, GetTranslated(618,9, "Amount of Gold that stops Defense farming, switches to normal farming if below.") & @CRLF & GetTranslated(618,10, "Set this value to amount of Gold you need for searching or upgrades."))
		 GUICtrlSetLimit(-1, 7)
	  GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 80, $y + 2, 16, 16)
	  $g_hTxtUnBrkMaxGold = GUICtrlCreateInput("600000", $x + 110, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		 GUICtrlSetState(-1, $GUI_DISABLE)
		 _GUICtrlSetTip(-1, GetTranslated(618,11, "Amount of Gold in Storage Required to Enable Defense Farming.") & @CRLF & GetTranslated(618,12, "Input amount of Gold you need to attract enemy or for upgrades."))
		 GUICtrlSetLimit(-1, 7)
	  GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 170, $y + 2, 16, 16)

	  $y += 26
	  $g_hTxtUnBrkMinElixir = GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		 GUICtrlSetState(-1, $GUI_DISABLE)
		 _GUICtrlSetTip(-1, GetTranslated(618,13, "Amount of Elixir that stops Defense farming, switches to normal farming if below.") & @CRLF & GetTranslated(618,14, "Set this value to amount of Elixir you need for making troops or upgrades."))
		 GUICtrlSetLimit(-1, 7)
	  GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 80, $y, 16, 16)
	  $g_hTxtUnBrkMaxElixir = GUICtrlCreateInput("600000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		 GUICtrlSetState(-1, $GUI_DISABLE)
		 _GUICtrlSetTip(-1, GetTranslated(618,15, "Amount of Elixir in Storage Required to Enable Defense Farming.") & @CRLF & GetTranslated(618,16, "Input amount of Elixir you need to attract enemy or for upgrades."))
		 GUICtrlSetLimit(-1, 7)
	  GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 170, $y, 16, 16)

	  $y += 24
	  $g_hTxtUnBrkMinDark = GUICtrlCreateInput("5000", $x + 20, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		 GUICtrlSetState(-1, $GUI_DISABLE)
		 _GUICtrlSetTip(-1, GetTranslated(618,17, "Amount of Dark Elixir that stops Defense farming, switches to normal farming if below.") & @CRLF & GetTranslated(618,18, "Set this value to amount of Dark Elixir you need for making troops or upgrades."))
		 GUICtrlSetLimit(-1, 6)
	  GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 80, $y, 16, 16)
	  $g_hTxtUnBrkMaxDark = GUICtrlCreateInput("6000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		 GUICtrlSetState(-1, $GUI_DISABLE)
		 _GUICtrlSetTip(-1, GetTranslated(618,19, "Amount of Dark Elixir in Storage Required to Enable Defense Farming.") & @CRLF & GetTranslated(618,20, "Input amount of Dark Elixir you need to attract enemy or for upgrades."))
		 GUICtrlSetLimit(-1, 6)
	  GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 170, $y, 16, 16)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $x = 25
   $y = 200
   GUICtrlCreateGroup(GetTranslated(618,21,"How to use Unbreakable Mode"), $x - 20, $y - 20, 440, 200)
	  Local $txtHelp = GetTranslated(618,22,"Unbreakable mode will help you gain defense wins and the ""Unbreakable"" achievement.") & _
		 @CRLF & GetTranslated(618,23,"Set ""Wait Time"" to how long you want the bot to wait for defenses." ) & _
		 @CRLF & GetTranslated(618,24,"Farm Min is how many resources the bot must have before attacking." ) & _
		 @CRLF & GetTranslated(618,25,"Save Min is how many resources the bot must have before starting unbreakable mode." ) & _
		 @CRLF & GetTranslated(618,26,"Click the below link for more information:" )
	  $g_hLblUnbreakableHelp = GUICtrlCreateLabel($txtHelp, $x - 10, $y, 430, 125)
	  $g_hLblUnbreakableLink = GUICtrlCreateLabel(GetTranslated(618,27,"More Info"), $x - 10, $y + 100, 100,20)
		 _GUIToolTip_AddTool($hToolTip, 0, "https://mybot.run/forums/index.php?/topic/2964-guide-how-to-use-mybot-unbreakable-mode-updated/", GUICtrlGetHandle($g_hLblUnbreakableLink))
		 GUICtrlSetFont(-1, 8.5, $FW_BOLD, $GUI_FONTUNDER)
		 GUICtrlSetColor(-1, $COLOR_INFO)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
