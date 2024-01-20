; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Standard Attack" tab under the "Attack" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DEADBASE_ATTACK_STANDARD = 0
Global $g_hCmbStandardDropOrderDB = 0, $g_hCmbStandardDropSidesDB = 0, $g_hChkSmartAttackRedAreaDB = 0, $g_hCmbSmartDeployDB = 0, _
	   $g_hChkAttackNearGoldMineDB = 0, $g_hChkAttackNearElixirCollectorDB = 0, $g_hChkAttackNearDarkElixirDrillDB = 0

Global $g_hLblSmartDeployDB = 0, $g_hPicAttackNearDarkElixirDrillDB = 0
Global $g_hBtnCustomDropOrderDB = 0

Func CreateAttackSearchDeadBaseStandard()

	$g_hGUI_DEADBASE_ATTACK_STANDARD = _GUICreate("", $_GUI_MAIN_WIDTH - 195, $g_iSizeHGrpTab4, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DEADBASE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_DEADBASE_ATTACK_STANDARD)

	Local $sTxtTip = ""
	Local $x = 25, $y = 20
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Group_01", "Deploy"), $x - 20, $y - 20, 270, $g_iSizeHGrpTab4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Label_01", "Troop Drop Order"), $x, $y, 143, 18, $SS_LEFT)

		$y += 15
			$g_hCmbStandardDropOrderDB = GUICtrlCreateCombo("", $x, $y, 150, Default, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Item_01", "Default(All Troops)") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Item_02", "Barch/BAM/BAG") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Item_03", "GiBarch"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Item_01", -1))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Info_01", "Select a preset troop drop order.") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Info_02", "Each option deploys troops in a different order and in different waves") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropOrder_Info_03", "Only the troops selected in the ""Only drop these troops"" option will be dropped"))

		$y += 25
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "Label_02", "Attack on") & ":", $x, $y + 5, -1, -1)
			$g_hCmbStandardDropSidesDB = GUICtrlCreateCombo("", $x + 55, $y, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_01", "Attack on a single side, penetrates through base") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_02", "Attack on two sides, penetrates through base") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_03", "Attack on three sides, gets outer and some inside of base") & @CRLF & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Info_04", "Select the No. of sides to attack on."))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_01", "one side") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_02", "two sides") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_03", "three sides") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_04", "all sides equally"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbStandardDropSides_Item_04", -1))


		$y +=22
			$g_hChkSmartAttackRedAreaDB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkSmartAttackRedArea", "Use Smart Attack: Near Red Line."), $x, $y, -1, -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkSmartAttackRedArea_Info_01", "Use Smart Attack to detect the outer 'Red Line' of the village to attack. And drop your troops close to it."))
				GUICtrlSetState(-1, $GUI_CHECKED)
				GUICtrlSetOnEvent(-1, "chkSmartAttackRedAreaDB")

		$y += 22
			$g_hLblSmartDeployDB = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "LblSmartDeploy", "Drop Type") & ":", $x, $y + 5, -1, -1)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "LblSmartDeploy_Info_01", "Select the Deploy Mode for the waves of Troops.") & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "LblSmartDeploy_Info_02", "Type 1: Drop a single wave of troops on each side then switch troops, OR") & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "LblSmartDeploy_Info_03", "Type 2: Drop a full wave of all troops (e.g. giants, barbs and archers) on each side then switch sides.")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hCmbSmartDeployDB = GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbSmartDeploy_Info_01", "Sides, then Troops") & "|" & _
								   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbSmartDeploy_Info_02", "Troops, then Sides"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "CmbSmartDeploy_Info_01", -1))
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 26
			$g_hChkAttackNearGoldMineDB = GUICtrlCreateCheckbox("", $x + 20, $y, 17, 17)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkAttackNearGoldMine_Info_01", "Drop troops near Gold Mines")
				_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 40 , $y - 3 , 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 75
			$g_hChkAttackNearElixirCollectorDB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkAttackNearElixirCollector_Info_01", "Drop troops near Elixir Collectors")
				_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20 , $y - 3 , 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)

		$x += 55
			$g_hChkAttackNearDarkElixirDrillDB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Standard", "ChkAttackNearDarkElixirDrill_Info_01", "Drop troops near Dark Elixir Drills")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hPicAttackNearDarkElixirDrillDB = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 20 , $y - 3, 24, 24)
				_GUICtrlSetTip(-1, $sTxtTip)

		$y += 40
		$x = 98
			$g_hBtnCustomDropOrderDB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnCustomDropOrder", "Drop Order"), $x, $y, 85, 25)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnCustomDropOrder_Info_01", "Select Custom Troops Dropping Order"))
				GUICtrlSetOnEvent(-1, "CustomDropOrder")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchDeadBaseStandard
