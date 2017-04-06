; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Trophy Settings" tab under the "Options" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hChkTrophyRange = 0, $g_hTxtDropTrophy = 0, $g_hTxtMaxTrophy = 0, $g_hChkTrophyHeroes = 0, $g_hCmbTrophyHeroesPriority = 0, _
	   $g_hChkTrophyAtkDead = 0, $g_hTxtDropTrophyArmyMin = 0
Global $g_hPicMinTrophies[$eLeagueCount] = [0,0,0,0,0,0,0,0,0], $g_hLblMinTrophies = 0
Global $g_hPicMaxTrophies[$eLeagueCount] = [0,0,0,0,0,0,0,0,0], $g_hLblMaxTrophies = 0

Global $g_hLblTrophyHeroesPriority = 0, $g_hLblDropTrophyArmyMin = 0, $g_hLblDropTrophyArmyPercent = 0

Func CreateAttackSearchOptionsTrophySettings()
   Local $sTxtTip = ""
   Local $x = 25, $y = 45

	GUICtrlCreateGroup(GetTranslated(609,1, "Trophy Settings"), $x - 20, $y - 20, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
		$x += 25
		$y += 25
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 15, $y, 64, 64, $BS_ICON)

		$x += 50
		$g_hChkTrophyRange = GUICtrlCreateCheckbox(GetTranslated(609,2, "Trophy range") & ":",$x + 20, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkTrophyRange")
		$g_hTxtDropTrophy = GUICtrlCreateInput("5000", $x + 110, $y, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 4)
			_GUICtrlSetTip(-1, GetTranslated(609,3, "MIN: The Bot will drop trophies until below this value."))
			GuiCtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "TxtDropTrophy")

			$g_hPicMinTrophies[$eLeagueUnranked] = GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_SHOW)
			$g_hPicMinTrophies[$eLeagueBronze] = GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMinTrophies[$eLeagueSilver] = GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMinTrophies[$eLeagueGold] = GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMinTrophies[$eLeagueCrystal] = GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMinTrophies[$eLeagueMaster] = GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMinTrophies[$eLeagueChampion] = GUICtrlCreateIcon($g_sLibIconPath, $eChampion, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMinTrophies[$eLeagueTitan] = GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMinTrophies[$eLeagueLegend] = GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hLblMinTrophies = GUICtrlCreateLabel("", $x + 133, $y - 15, 17, 17, $SS_CENTER)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)

		GUICtrlCreateLabel(GetTranslated(603,13, "-"), $x + 148, $y + 4, -1, -1)
		$g_hTxtMaxTrophy = GUICtrlCreateInput("5000", $x + 155, $y, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 4)
			_GUICtrlSetTip(-1, GetTranslated(609,4, "MAX: The Bot will drop trophies if your trophy count is greater than this value."))
			GuiCtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "TxtMaxTrophy")

			$g_hPicMaxTrophies[$eLeagueUnranked] = GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_SHOW)
			$g_hPicMaxTrophies[$eLeagueBronze] = GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMaxTrophies[$eLeagueSilver] = GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMaxTrophies[$eLeagueGold] = GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMaxTrophies[$eLeagueCrystal] = GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMaxTrophies[$eLeagueMaster] = GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMaxTrophies[$eLeagueChampion] = GUICtrlCreateIcon($g_sLibIconPath, $eChampion, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMaxTrophies[$eLeagueTitan] = GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$g_hPicMaxTrophies[$eLeagueLegend] = GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hLblMaxTrophies = GUICtrlCreateLabel("", $x + 178, $y - 15, 17, 17, $SS_CENTER)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)

		$y += 24
		$x += 20
		$g_hChkTrophyHeroes = GUICtrlCreateCheckbox(GetTranslated(609,5, "Use Heroes To Drop Trophies"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(609,6, "Use Heroes to drop Trophies if Heroes are available."))
			GuiCtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkTrophyHeroes")

		$y += 25
	    $g_hLblTrophyHeroesPriority = GUICtrlCreateLabel(GetTranslated(609,11, "Priority Hero to Use") & ":", $x + 16 , $y , 110, -1)
		$g_hCmbTrophyHeroesPriority = GUICtrlCreateCombo("", $x + 125, $y - 4 , 170, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(609,12, "Set the order on which Hero the Bot drops first when available."))
			Local $txtPriorityConnector = ">"
			Local $txtPriorityDefault =   GetTranslated(603, 34, -1) & $txtPriorityConnector & GetTranslated(603, 33, -1) & $txtPriorityConnector & GetTranslated(603, 35, -1) ; default value Queen, King, G.Warden
			Local $txtPriorityList = "" & _
			GetTranslated(603, 34, -1) & $txtPriorityConnector & GetTranslated(603, 33, -1) & $txtPriorityConnector & GetTranslated(603, 35, -1) & "|" & _
			GetTranslated(603, 34, -1) & $txtPriorityConnector & GetTranslated(603, 35, -1) & $txtPriorityConnector & GetTranslated(603, 33, -1) & "|" & _
			GetTranslated(603, 33, -1) & $txtPriorityConnector & GetTranslated(603, 34, -1) & $txtPriorityConnector & GetTranslated(603, 35, -1) & "|" & _
			GetTranslated(603, 33, -1) & $txtPriorityConnector & GetTranslated(603, 35, -1) & $txtPriorityConnector & GetTranslated(603, 34, -1) & "|" & _
			GetTranslated(603, 35, -1) & $txtPriorityConnector & GetTranslated(603, 33, -1) & $txtPriorityConnector & GetTranslated(603, 34, -1) & "|" & _
			GetTranslated(603, 35, -1) & $txtPriorityConnector & GetTranslated(603, 34, -1) & $txtPriorityConnector & GetTranslated(603, 33, -1) & "|" & _
			""
			If $g_iDebugSetlog = 1 Then Setlog($txtPriorityDefault)
			If $g_iDebugSetlog = 1 Then Setlog($txtPriorityList)
			GUICtrlSetData(-1, $txtPriorityList , $txtPriorityDefault)
 			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 20
		$g_hChkTrophyAtkDead = GUICtrlCreateCheckbox(GetTranslated(609,7, "Attack Dead Bases During Drop"), $x  , $y +2, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(609,8, "Attack a Deadbase found on the first search while dropping Trophies."))
			GUICtrlSetOnEvent(-1, "chkTrophyAtkDead")
			GuiCtrlSetState(-1,$GUI_DISABLE)

		$y += 24
		;$x += 10
		$g_hLblDropTrophyArmyMin = GUICtrlCreateLabel(GetTranslated(609,9, "Wait until Army Camp are at least") & " " & ChrW(8805), $x + 16 , $y + 6, 200, -1, $SS_LEFT)
		$sTxtTip = GetTranslated(609,10, "Enter the percent of full army required for dead base attack before starting trophy drop.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtDropTrophyArmyMin = GUICtrlCreateInput("70", $x + 215, $y +2, 27, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState (-1, $GUI_DISABLE)
		$g_hLblDropTrophyArmyPercent = GUICtrlCreateLabel(GetTranslated(603,12, "%"), $x + 245, $y +6, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
 EndFunc
