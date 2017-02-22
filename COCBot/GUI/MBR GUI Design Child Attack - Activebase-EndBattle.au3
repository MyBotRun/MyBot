; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "End Battle" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hChkStopAtkABNoLoot1 = 0, $g_hTxtStopAtkABNoLoot1 = 0, $g_hChkStopAtkABNoLoot2 = 0, $g_hTxtStopAtkABNoLoot2 = 0, _
	   $g_hTxtABMinGoldStopAtk2 = 0, $g_hTxtABMinElixirStopAtk2 = 0, $g_hTxtABMinDarkElixirStopAtk2 = 0, _
	   $g_hChkABEndNoResources = 0, $g_hChkABEndOneStar = 0, $g_hChkABEndTwoStars = 0, $g_hChkABEndPercentHigher = 0, $g_hTxtABPercentHigher = 0, $g_hChkABEndPercentChange = 0, $g_hTxtABPercentChange = 0
Global $g_hChkDESideEB = 0, $g_hTxtDELowEndMin = 0, $g_hChkDisableOtherEBO = 0, $g_hChkDEEndOneStar = 0, $g_hChkDEEndBk = 0, $g_hChkDEEndAq = 0

Global $g_hGrpABEndBattle = 0, $g_hLblABTimeStopAtka = 0, $g_hLblABTimeStopAtk = 0, $g_hLblABTimeStopAtk2a = 0, $g_hLblABTimeStopAtk2 = 0, _
	   $g_hLblABMinRerourcesAtk2 = 0, $g_hPicABMinGoldStopAtk2 = 0, $g_hPicABMinElixirStopAtk2 = 0, $g_hPicABMinDarkElixirStopAtk2 = 0
Global $g_hLblDELowEndMin = 0, $g_hLblDEEndAq = 0, $g_hLblABPercentHigher = 0, $g_hLblABPercentHigherSec = 0, $g_hLblABPercentChange = 0, $g_hLblABPercentChangeSec = 0

Func CreateAttackSearchActiveBaseEndBattle()
   Local $sTxtTip = ""
   Local $x = 10, $y = 45
	$g_hGrpABEndBattle = GUICtrlCreateGroup(GetTranslated(606,1, -1),  $x - 5, $y - 20, 155, 345)
	$y -=5
		$g_hChkStopAtkABNoLoot1 = GUICtrlCreateCheckbox(GetTranslated(606,2, -1) ,$x, $y, -1, -1)
			$sTxtTip = GetTranslated(606,3, -1) & @CRLF & GetTranslated(606,4, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkStopAtkABNoLoot1")
			GUICtrlSetState(-1, $GUI_CHECKED)

	$y +=20
		$g_hLblABTimeStopAtka = GUICtrlCreateLabel(GetTranslated(606,5, -1)& ":", $x + 16, $y + 3, -1, -1)
		$g_hTxtStopAtkABNoLoot1 = GUICtrlCreateInput("20", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
		$g_hLblABTimeStopAtk = GUICtrlCreateLabel(GetTranslated(603,6, -1), $x + 120, $y + 3, -1, -1)

   $y += 20
		$g_hChkStopAtkABNoLoot2 = GUICtrlCreateCheckbox(GetTranslated(606,2, -1) ,$x, $y, -1, -1)
			$sTxtTip = GetTranslated(606,3, -1) & @CRLF & GetTranslated(606,4, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkStopAtkABNoLoot2")
			GUICtrlSetState(-1, $GUI_UNCHECKED)

   $y += 20
		$g_hLblABTimeStopAtk2a = GUICtrlCreateLabel(GetTranslated(606,5, -1)& ":", $x + 16, $y + 3, -1, -1)
		$g_hTxtStopAtkABNoLoot2 = GUICtrlCreateInput("5", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblABTimeStopAtk2 = GUICtrlCreateLabel(GetTranslated(603,6, -1), $x + 120, $y + 3, -1, -1)

	$y += 21
		$g_hLblABMinRerourcesAtk2 = GUICtrlCreateLabel(GetTranslated(606,7, -1) & ":", $x + 16 , $y + 2, -1, -1)
			$sTxtTip = GetTranslated(606,8, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

   $y += 21
		$g_hTxtABMinGoldStopAtk2 = GUICtrlCreateInput("2000", $x + 65, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hPicABMinGoldStopAtk2 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 117, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

   $y += 21
		$g_hTxtABMinElixirStopAtk2 = GUICtrlCreateInput("2000", $x + 65, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hPicABMinElixirStopAtk2 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 117, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

   $y += 21
		$g_hTxtABMinDarkElixirStopAtk2 = GUICtrlCreateInput("50", $x + 65, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hPicABMinDarkElixirStopAtk2 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 117, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		$g_hChkABEndNoResources = GUICtrlCreateCheckbox(GetTranslated(606,9, -1), $x , $y , -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(606,10, -1))
			GUICtrlSetState(-1, $GUI_ENABLE)

	$y += 21
		$g_hChkABEndOneStar = GUICtrlCreateCheckbox(GetTranslated(606,11, -1) , $x, $y , -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(606,12, -1))
			GUICtrlSetState(-1, $GUI_ENABLE)

	$y += 21
		$g_hChkABEndTwoStars = GUICtrlCreateCheckbox(GetTranslated(606,13,-1) , $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(606,14, -1))
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 21
		$g_hChkABEndPercentHigher = GUICtrlCreateCheckbox(GetTranslated(606,30, "When Percentage is"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(606,31, "End Battle if Overall Damage Percentage is above"))
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y +=20
		$g_hLblABPercentHigher = GUICtrlCreateLabel(GetTranslated(606,32,"above") & ":", $x + 16 , $y + 2, -1, -1)
		$g_hTxtABPercentHigher = GUICtrlCreateInput("60", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(606,31, -1))
			GUICtrlSetLimit(-1, 2)
		$g_hLblABPercentHigherSec = GUICtrlCreateLabel("%", $x + 120, $y + 3, -1, -1)
	$y += 21
		$g_hChkABEndPercentChange = GUICtrlCreateCheckbox(GetTranslated(606,33,"When Percentage doesn't") , $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(606, 34,"End Battle when Percentage doesn't change in"))
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y +=20
		$g_hLblABPercentChange = GUICtrlCreateLabel(GetTranslated(606, 35,"change in")& ":", $x + 16, $y + 3, -1, -1)
		$g_hTxtABPercentChange = GUICtrlCreateInput("15", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(606,34, -1))
			GUICtrlSetLimit(-1, 2)
		$g_hLblABPercentChangeSec = GUICtrlCreateLabel(GetTranslated(603,6, -1), $x + 120, $y + 3, -1, -1)


		GUICtrlCreateGroup("", -99, -99, 1, 1)

   Local $x = 185, $y = 45
   GUICtrlCreateGroup(GetTranslated(606,15,"DE side End Battle options"), $x - 20, $y - 20, 259, 305)
		 GUICtrlCreateLabel(GetTranslated(606,16, "Attack Dark Elixir Side, End Battle Options") & ":", $x - 10, $y , -1, -1)
			 _GUICtrlSetTip(-1, GetTranslated(606,17, "Enabled by selecting DE side attack in ActiveBase Deploy - Attack On: options"))

		$y += 15
		$x -= 10
			$g_hChkDESideEB = GUICtrlCreateCheckbox(GetTranslated(606,18, "When below") & ":", $x , $y , -1, -1)
				$sTxtTip = GetTranslated(606,19, "Enables Special conditions for Dark Elixir side attack.") & @CRLF & GetTranslated(606,20, "If no additional filters are selected will end battle when below Total Dark Elixir Percent.")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "chkDESideEB")
			$g_hTxtDELowEndMin = GUICtrlCreateInput("25", $x + 92, $y , 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetLimit(-1, 2)
				GUICtrlSetState(-1, $GUI_DISABLE)
			$g_hLblDELowEndMin = GUICtrlCreateLabel("%", $x + 136 , $y + 2 , -1, -1)
			GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 147, $y, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 20
			$g_hChkDisableOtherEBO = GUICtrlCreateCheckbox(GetTranslated(606,21, "Disable Normal End Battle Options"), $x, $y, -1, -1)
				_GUICtrlSetTip(-1, GetTranslated(606,22, "Disable Normal End Battle Options when DE side attack is found."))
				GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 20
			$g_hChkDEEndOneStar = GUICtrlCreateCheckbox(GetTranslated(606,11, -1) & ":", $x, $y , -1, -1)
				$sTxtTip = GetTranslated(606,23, "Will End the Battle when below min DE and One Star is won.")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 135, $y + 2, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 20
			$g_hChkDEEndBk = GUICtrlCreateCheckbox(GetTranslated(606,24, "When"), $x, $y , -1, -1)
				$sTxtTip = GetTranslated(606,25, "Will End the Battle when below min DE and King is weak")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x + 50, $y + 2, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlCreateLabel(GetTranslated(606,26, "is weak"), $x + 70, $y + 4, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 20
			$g_hChkDEEndAq = GUICtrlCreateCheckbox(GetTranslated(606,24, -1), $x, $y , -1, -1)
				$sTxtTip = GetTranslated(606,27, "Will End the Battle when below min DE and Queen is weak")
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x + 50, $y + 2, 16, 16)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hLblDEEndAq = GUICtrlCreateLabel(GetTranslated(606,26, -1), $x + 70, $y + 4, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)

		GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc