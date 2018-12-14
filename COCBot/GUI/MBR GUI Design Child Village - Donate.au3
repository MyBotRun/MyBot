; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Req. & Donate" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (07-2016), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DONATE = 0, $g_hGUI_DONATE_TAB = 0, $g_hGUI_DONATE_TAB_ITEM1 = 0, $g_hGUI_DONATE_TAB_ITEM2 = 0, $g_hGUI_DONATE_TAB_ITEM3 = 0

; Request
Global $g_hChkRequestTroopsEnable = 0, $g_hTxtRequestCC = 0, $g_ahChkRequestCCHours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkRequestCCHoursE1 = 0, $g_hChkRequestCCHoursE2 = 0
Global $g_hGrpRequestCC = 0, $g_hLblRequestCCHoursAM = 0, $g_hLblRequestCCHoursPM = 0
Global $g_hLblRequestCChour = 0, $g_ahLblRequestCChoursE = 0
Global $g_hLblRequestCChours[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblRequestType, $g_hChkRequestType_Troops, $g_hChkRequestType_Spells, $g_hChkRequestType_Siege
Global $g_hTxtRequestCountCCTroop, $g_hTxtRequestCountCCSpell, $g_hChkClanCastleSpell = 0
Global $g_ahCmbClanCastleTroop[3], $g_ahTxtClanCastleTroop[3]
Global $g_ahCmbClanCastleSpell[2], $g_ahTxtClanCastleSpell[2]

; Donate
Global $g_hChkExtraAlphabets = 0, $g_hChkExtraChinese = 0, $g_hChkExtraKorean = 0, $g_hChkExtraPersian = 0
Global $g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
Global $g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
Global $g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
Global $g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
Global $g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
Global $g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
Global $g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeMachineCount] = 		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

Global $g_ahChkDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0] ; element $eSpellClone (5) is unused
Global $g_ahChkDonateAllSpell[$eSpellCount] = [0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0] ; element $eSpellClone (5) is unused
Global $g_ahTxtDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0] ; element $eSpellClone (5) is unused
Global $g_ahTxtBlacklistSpell[$eSpellCount] = [0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0] ; element $eSpellClone (5) is unused
Global $g_ahGrpDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0] ; element $eSpellClone (5) is unused
Global $g_ahLblDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0] ; element $eSpellClone (5) is unused
Global $g_ahBtnDonateSpell[$eSpellCount] = [0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0] ; element $eSpellClone (5) is unused

Global $g_ahCmbDonateCustomA[3] = [0, 0, 0], $g_ahTxtDonateCustomA[3] = [0, 0, 0], $g_ahPicDonateCustomA[3] = [0, 0, 0]
Global $g_ahCmbDonateCustomB[3] = [0, 0, 0], $g_ahTxtDonateCustomB[3] = [0, 0, 0], $g_ahPicDonateCustomB[3] = [0, 0, 0]
Global $g_ahCmbDonateCustomC[3] = [0, 0, 0], $g_ahTxtDonateCustomC[3] = [0, 0, 0], $g_ahPicDonateCustomC[3] = [0, 0, 0]
Global $g_ahCmbDonateCustomD[3] = [0, 0, 0], $g_ahTxtDonateCustomD[3] = [0, 0, 0], $g_ahPicDonateCustomD[3] = [0, 0, 0]

Global $g_hLblDonateTroopTBD1 = 0, $g_hLblDonateTroopTBD2 = 0, $g_hLblDonateTroopTBD3 = 0, _
	   $g_hLblDonateTroopCustomC = 0, $g_hLblDonateTroopCustomD = 0, $g_hLblDonateTroopCustomF = 0, $g_hLblDonateTroopCustomG = 0, $g_hLblDonateTroopCustomH = 0, _
	   $g_hLblDonateTroopCustomI = 0, $g_hLblDonateTroopCustomJ = 0, $g_hLblDonateSpellTBD1 = 0

Global $g_hGrpDonateGeneralBlacklist = 0, $g_hTxtGeneralBlacklist = 0
Global $lblBtnCustomE = 0

Global $g_hChkDonateQueueTroopOnly = 0, $g_hChkDonateQueueSpellOnly = 0

; Schedule
Global $g_hChkDonateHoursEnable = 0, $g_ahChkDonateHours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hCmbFilterDonationsCC = 0, $g_hChkSkipDonateNearFullTroopsEnable = 0
Global $g_hLblDonateHours1 = 0, $g_hLblDonateHoursPM = 0
Global $g_hLblSkipDonateNearFullTroopsText = 0, $g_hTxtSkipDonateNearFullTroopsPercentage = 0, $g_hLblSkipDonateNearFullTroopsText1 = 0

Global $g_hGrpDonateCC = 0, $g_ahChkDonateHoursE1 = 0, $g_ahChkDonateHoursE2 = 0

Global $g_hGUI_RequestCC = 0, $g_hGUI_DONATECC = 0, $g_hGUI_ScheduleCC = 0
Global $g_hGrpDonate = 0, $g_hChkDonate = 1, $g_hLblDonateDisabled = 0, $g_hLblScheduleDisabled = 0

; Clan castle
Global $g_hChkUseCCBalanced = 0, $g_hCmbCCDonated = 0, $g_hCmbCCReceived = 0
GLobal $g_hLblDonateCChour = 0, $g_ahLblDonateCChoursE = 0
GLobal $g_hLblDonateCChours[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Func CreateVillageDonate()
	$g_hGUI_DONATE = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_DONATE)
	Local $x = 82
	$g_hChkDonate = GUICtrlCreateCheckbox("", $x + 131, 6, 13, 13)
		GUICtrlSetState(-1,$GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "Doncheck")
		CreateRequestSubTab()
		CreateDonateSubTab()
		CreateScheduleSubTab()
	GUISwitch($g_hGUI_DONATE)

	$g_hGUI_DONATE_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_DONATE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_01", "Request Troops"))
	$g_hGUI_DONATE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_02", "Donate Troops") & "    ")
	$g_hLblDonateDisabled = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_02_STab_02_STab_Info_01", "Note: Donate is disabled, tick the checkmark on the") & " " & GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_02", -1) & " " & GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_02", -1), 5, 30, $g_iSizeWGrpTab3, 374)
		GUICtrlSetState(-1, $GUI_HIDE)
	$g_hGUI_DONATE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_03", "Schedule Donations"))
	$g_hLblScheduleDisabled = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_02_STab_02_STab_Info_01", -1) & " " & GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_02_STab_02", -1) & " " & GetTranslatedFileIni("MBR Main GUI", "disabled_Tab_03_STab_02_STab_Info_02", -1), 5, 30, $g_iSizeWGrpTab3, 374)
		GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageDonate

#Region CreateRequestSubTab
Func CreateRequestSubTab()

	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	$g_hGUI_RequestCC = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, $xStart - 20, $yStart - 20, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DONATE)
	; GUISetBkColor($COLOR_WHITE)
	Local $xStart = 20, $yStart = 20
	Local $x = $xStart
	Local $y = $yStart
	$g_hGrpRequestCC = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "Group_01", "Clan Castle Troops"), $x - 20, $y - 20, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3)
	$y += 10
	$x += 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCCRequest, $x - 5, $y, 64, 64, $BS_ICON)
		$g_hChkRequestTroopsEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestTroopsEnable", "Request Troops / Spells"), $x + 40 + 30, $y - 6)
			GUICtrlSetOnEvent(-1, "chkRequestCCHours")
		$g_hTxtRequestCC = GUICtrlCreateInput(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "TxtRequestCC", "Anything please"), $x + 40 + 30, $y + 15, 214, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "TxtRequestCC_Info_01", "This text is used on your request for troops in the Clan chat."))

	; Request Type (Demen)
	$y += 25
		$g_hLblRequestType = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "LblRequestType", "When lacking "), $x + 70, $y + 23)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "LblRequestType_Info_01", "Not send request when all the checked items are full"))
		$g_hChkRequestType_Troops = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestType", "Troops"), $x + 140, $y + 20)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestType_Info_01", "Send request when CC Troop is not full"))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkRequestCountCC")
		$g_hChkRequestType_Spells = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestType_Spells", "Spells"), $x + 195, $y + 20)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkRequestType_Spells_Info_01", "Send request when CC Spell is not full"))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkRequestCountCC")
		$g_hChkRequestType_Siege = GUICtrlCreateCheckbox( GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC","ChkRequestType_Sieges", "Siege Machine"), $x + 250, $y + 20)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC","ChkRequestType_Sieges_Info_01", "Send request when CC Siege Machine is not received"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "lblIfLessThan", "If less than "), $x + 70, $y + 23)
		$g_hTxtRequestCountCCTroop = GUICtrlCreateInput("0", $x + 140, $y + 20, 25, 16, BitOR($SS_RIGHT, $ES_NUMBER))
			GUICtrlSetLimit(-1, 2)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "lblIfLessThan_Info_01", "Do not request when already received that many CC Troops") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "lblIfLessThan_Info_02", "Set to either ""0"" or ""40+"" when full CC Troop wanted"))
			If GUICtrlRead($g_hChkRequestType_Troops) = $GUI_CHECKED Then
				GUICtrlSetState(-1, $GUI_ENABLE)
			Else
				GUICtrlSetState(-1, $GUI_DISABLE)
			EndIf
		$g_hTxtRequestCountCCSpell = GUICtrlCreateInput("0", $x + 195, $y + 20, 25, 16, BitOR($SS_RIGHT, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "TxtRequestCountCCSpell_Info_01", "Do not request when already received that many CC Spells") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "TxtRequestCountCCSpell_Info_02", "Set to either ""0"" or ""2+"" when full CC Spell wanted"))
			If GUICtrlRead($g_hChkRequestType_Spells) = $GUI_CHECKED Then
				GUICtrlSetState(-1, $GUI_ENABLE)
			Else
				GUICtrlSetState(-1, $GUI_DISABLE)
			EndIf

	$y += 45
		Local $sCmbTroopList = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtListOfTroops", _ArrayToString($g_asTroopNames) & "|Any")
		For $i = 0 To 2
			$g_ahCmbClanCastleTroop[$i] = GUICtrlCreateCombo("", $x + 70, $y + $i * 25, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sCmbTroopList, "Any")
				GUICtrlSetOnEvent(-1, "CmbClanCastleTroop")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkWaitForClanCastleTroop_Info_01", "Pick a troop type allow to stay in your Clan Castle"))

			$g_ahTxtClanCastleTroop[$i] = GUICtrlCreateInput("0", $x + 140, $y + $i * 25, 25, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
				GUICtrlSetState(-1, $GUI_DISABLE)
				GUICtrlSetLimit(-1, 2)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkWaitForClanCastleTroop_Info_02", "Set the maximum quantity to stay.") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "TxtRequestCountCCSpell_Info_03", "Set to ""0"" or ""40+"" means unlimit"))
		Next

		Local $sCmbSpellList = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtListOfSpells", _ArrayToString($g_asSpellNames) & "|Any")
		For $i = 0 To 1
			$g_ahCmbClanCastleSpell[$i] = GUICtrlCreateCombo("", $x + 195, $y + $i * 25, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sCmbSpellList, "Any")
				GUICtrlSetOnEvent(-1, "CmbClanCastleSpell")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkWaitForClanCastleSpell_Info_01", "Pick a spell type allow to stay in your Clan Castle"))

			$g_ahTxtClanCastleSpell[$i] = GUICtrlCreateInput("0", $x + 265, $y + $i * 25, 25, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_RIGHT, $ES_NUMBER))
				GUICtrlSetState(-1, $GUI_DISABLE)
				GUICtrlSetLimit(-1, 1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "ChkWaitForClanCastleSpell_Info_02", "Set the maximum quantity to stay.") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Child Village - Donate-CC", "TxtRequestCountCCSpell_Info_03", "Set to ""0"" or ""2+"" means unlimit"))
		Next

	$x += 70
	$y += 90
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", "Only during these hours of each day"), $x, $y, 300, 20, $BS_MULTILINE)

	$y += 20
		$g_hLblRequestCChour = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", "Hour") & ":", $x, $y, -1, 15)
			Local $sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblRequestCChours[0] = GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[10] = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblRequestCChours[11] = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahLblRequestCChoursE = GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 15
		$g_ahChkRequestCCHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_hChkRequestCCHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", "This button will clear or set the entire row of boxes"))
			GUICtrlSetOnEvent(-1, "chkRequestCCHoursE1")
		$g_hLblRequestCCHoursAM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", "AM"), $x + 5, $y)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 15
		$g_ahChkRequestCCHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_hChkRequestCCHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkRequestCCHoursE2")
		$g_hLblRequestCCHoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", "PM"), $x + 5, $y)
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateRequestSubTab
#EndRegion

#Region CreateDonateSubTab
Func CreateDonateSubTab()
	Local $xStart = 25, $yStart = 45
	$g_hGUI_DONATECC = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, $xStart - 20, $yStart - 20, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DONATE)
	; GUISetBkColor($COLOR_WHITE)
	Local $xStart = 20, $yStart = 20
	;~ -------------------------------------------------------------
	;~ Language Variables used a lot
	;~ -------------------------------------------------------------

	Local $sTxtBlacklist1 = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklist1", "Blacklist")
	Local $sDonateTxtCustomA = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "DonateTxtCustom", "Custom Troops")
	Local $sDonateTxtCustomB = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "DonateTxtCustom", -1)
	Local $sDonateTxtCustomC = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "DonateTxtCustom", -1)
	Local $sDonateTxtCustomD = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "DonateTxtCustom", -1)

	Local $sTxtNothing = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtNothing", "Nothing")

	Local $sTxtDonate = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonate", "Donate")
	Local $sTxtDonateTip = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTip", "Check this to donate")
	Local $sTxtDonateAll = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateAll", "Donate to All")
	Local $sTxtDonateQueueTroop = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateQueueTroop", "Queued troop only")
	Local $sTxtDonateQueueSpell = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateQueueSpell", "Queued spell only")
	Local $sTxtIgnoreAll = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtIgnoreAll", "This will also ignore ALL keywords.")
	Local $sTxtKeywords = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtKeywords", "Keywords for donating")
	Local $sTxtKeywordsNo = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtKeywordsNo", "Do NOT donate to these keywords")
	Local $sTxtKeywordsNoTip = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtKeywordsNoTip", "Blacklist for donating")
	Local $sTxtDonateTipTroop = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTipTroop", "if keywords match the Chat Request.")
	Local $sTxtDonateTipAll = GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTipAll", "to ALL Chat Requests.")

	Local $sTxtBarbarians = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians")
	Local $sTxtArchers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers")
	Local $sTxtGiants = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants")
	Local $sTxtGoblins = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins")
	Local $sTxtWallBreakers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers")
	Local $sTxtBalloons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons")
	Local $sTxtWizards = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards")
	Local $sTxtHealers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers")
	Local $sTxtDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons")
	Local $sTxtPekkas = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas")
	Local $sTxtMinions = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions")
	Local $sTxtHogRiders = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders")
	Local $sTxtValkyries = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries")
	Local $sTxtGolems = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems")
	Local $sTxtWitches = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches")
	Local $SetLog = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds")
	Local $sTxtBowlers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers")
	Local $sTxtIceGolems = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceGolems", "Ice Golems")
	Local $sTxtBabyDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons")
	Local $sTxtMiners = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners")
	Local $sTxtElectroDragons = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroDragons", "Electro Dragons")

	Local $sTxtWallWreckers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallWreckers", "Wall Wreckers")
	Local $sTxtBattleBlimps = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBattleBlimps", "Battle Blimps")
	Local $sTxtStoneSlammers = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtStoneSlammers", "Stone Slammers")

	Local $sTxtLightningSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortLightningSpells", "Lightning")
	Local $sTxtHealSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHealSpells", "Heal")
	Local $sTxtRageSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortRageSpells", "Rage")
	Local $sTxtJumpSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortJumpSpells", "Jump")
	Local $sTxtFreezeSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortFreezeSpells", "Freeze")
	Local $sTxtPoisonSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortPoisonSpells", "Poison")
	Local $sTxtEarthquakeSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortEarthquakeSpells", "EarthQuake")
	Local $sTxtHasteSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortHasteSpells", "Haste")
	Local $sTxtSkeletonSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortSkeletonSpells", "Skeleton")
	Local $sTxtBatSpells = GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtShortBatSpells", "Bat")

	Local $x = $xStart
	Local $y = $yStart
	Local $Offx = 38
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "Group_01", "Donate Troops Selection Menu"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 185)
	$x = $xStart - 18
		$g_ahLblDonateTroop[$eTroopBarbarian] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopBarbarian] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBarbarian, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopArcher] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopArcher] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnArcher, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopGiant] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopGiant] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGiant, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopGoblin] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopGoblin] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoblin, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopWallBreaker] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopWallBreaker] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWallBreaker, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopBalloon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopBalloon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBalloon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")

	$x += $Offx
	$x += 4
	    $g_ahLblDonateTroop[$eTroopElectroDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopElectroDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnElectroDragon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopMinion] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopMinion] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnMinion, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopHogRider] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopHogRider] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHogRider, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopValkyrie] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopValkyrie] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnValkyrie, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopGolem] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopGolem] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGolem, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")

	$x = $xStart - 18
	$y += 40
		$g_ahLblDonateTroop[$eTroopWizard] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopWizard] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWizard, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopHealer] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopHealer] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHealer, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDragon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopPekka] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopPekka] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnPekka, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopBabyDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopBabyDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBabyDragon, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopMiner] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopMiner] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnMiner, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")

	$x += $Offx
	$x += 4
		$g_ahLblDonateTroop[$eTroopWitch] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopWitch] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWitch, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopLavaHound] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopLavaHound] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLavaHound, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopBowler] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopBowler] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBowler, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopIceGolem] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopIceGolem] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnIceGolem, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")		
    $x += $Offx
		; Button Not Active - future expansion?
		$lblBtnCustomE = GUICtrlCreateLabel("", $x + 2, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			GUICtrlSetState(-1, $GUI_DISABLE)
;~			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTroops, 0)
;~			GUICtrlSetOnEvent(-1, "btnDonateCustomE")

	;$x += $Offx
		;$g_hLblDonateTroopTBD3 = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			;GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			;GUICtrlSetState(-1, $GUI_DISABLE)
		;GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			;GUICtrlSetState(-1, $GUI_DISABLE)
;~			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTroops, 0)
;~			GUICtrlSetOnEvent(-1, "btnDonateTroop")

	$x = $xStart - 18
	$y += 40
		$g_ahLblDonateSpell[$eSpellLightning] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellLightning] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLightSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellHeal] = GUICtrlCreateLabel("", $x , $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellHeal] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHealSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellRage] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellRage] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnRageSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellJump] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellJump] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnJumpSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellFreeze] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellFreeze] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnFreezeSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	$x += $Offx
		; Button Not Active - future expansion?
		$lblBtnCustomE = GUICtrlCreateLabel("", $x + 2, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			GUICtrlSetState(-1, $GUI_DISABLE)
;~			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTroops, 0)
;~			GUICtrlSetOnEvent(-1, "btnDonateCustomE")

	$x += 4
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellPoison] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellPoison] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnPoisonSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellEarthquake] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellEarthquake] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnEarthQuakeSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellHaste] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellHaste] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHasteSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellSkeleton] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellSkeleton] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSkeletonSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")
	$x += $Offx
		$g_ahLblDonateSpell[$eSpellBat] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateSpell[$eSpellBat] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBatSpell, 1)
			GUICtrlSetOnEvent(-1, "btnDonateSpell")

	$x = $xStart - 18
	$y += 40
		;;; Custom Combination Donate #1 by ChiefM3, edit my MonkeyHunter
		$g_ahLblDonateTroop[$eCustomA] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eCustomA] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonCustom, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		;;; Custom Combination Donate #2 added by MonkeyHunter
		$g_ahLblDonateTroop[$eCustomB] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eCustomB] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonCustomB, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		;;; Custom Combination Donate #3 ~ Additional Custom Donate by NguyenAnhHD
		$g_ahLblDonateTroop[$eCustomC] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eCustomC] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonCustom, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")

	$x += $Offx
		;;; Custom Combination Donate #4 ~ ; Additional Custom Donate by NguyenAnhHD
		$g_ahLblDonateTroop[$eCustomD] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eCustomD] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonCustomB, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")		
	$x += $Offx
		; Button Not Active - future expansion?
		$g_hLblDonateTroopCustomH = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			GUICtrlSetState(-1, $GUI_DISABLE)
;~			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonCustomB, 1)
;~			GUICtrlSetOnEvent(-1, "btnDonateCustomH")
    $x += $Offx
		; Button Not Active - future expansion?
		$g_hLblDonateTroopCustomF = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			GUICtrlSetState(-1, $GUI_DISABLE)
;~			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTroops, 0)
;~			GUICtrlSetOnEvent(-1, "btnDonateCustomF")

	$x += 4
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWallW, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBattleB, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")
	$x += $Offx
		$g_ahLblDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahBtnDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnStoneS, 1)
			GUICtrlSetOnEvent(-1, "btnDonateTroop")

	$x += $Offx
		; Button Not Active - future expansion?
		$g_hLblDonateTroopCustomD = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetState(-1, $GUI_DISABLE)

		GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			GUICtrlSetState(-1, $GUI_DISABLE)
;~			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTroops, 0)
;~			GUICtrlSetOnEvent(-1, "btnDonateCustomD")
	$x += $Offx
		GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonBlacklist, 1)
			GUICtrlSetOnEvent(-1, "btnDonateBlacklist")

	Local $Offy = $yStart + 185
	$x = $xStart
	$y = $yStart + 185
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblExtraAlphabets", "Extra Alphabet Recognitions:"), $x - 15, $y + 153, -1, -1)
		$g_hChkExtraAlphabets = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraAlphabets", "Cyrillic"), $x + 127 , $y + 149, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraAlphabets_Info_01", "Check this to enable the Cyrillic Alphabet."))
		$g_hChkExtraChinese = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraChinese", "Chinese"), $x + 191, $y + 149, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraChinese_Info_01", "Check this to enable the Chinese Alphabet."))
		$g_hChkExtraKorean = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraKorean", "Korean"), $x + 265, $y + 149, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraKorean_Info_01", "Check this to enable the Korean Alphabet."))
		$g_hChkExtraPersian = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraPersian", "Persian"), $x + 340, $y + 149, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "ChkExtraPersian_Info_01", "Check this to enable the Persian Alphabet."))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hChkDonateQueueTroopOnly = GUICtrlCreateCheckbox($sTxtDonateQueueTroop, $x + 275, $y + 36, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateQueueTroopTip", "Only donate troops which are ready in 2nd army,\r\nor troops which are training in first slot of 2nd army.\r\nIf 2nd army is not prepared, donate whatever exists in 1st army."))
	$g_hChkDonateQueueSpellOnly = GUICtrlCreateCheckbox($sTxtDonateQueueSpell, $x + 275, $y + 36, -1, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateQueueSpellTip", "Only donate spells which are ready in 2nd army,\r\nor spells which are training in first slot of 2nd army.\r\n\If 2nd army is not prepared, donate whatever exists in 1st army."))
		GUICtrlSetState(-1, $GUI_HIDE)

	$g_ahGrpDonateTroop[$eTroopBarbarian] = GUICtrlCreateGroup($sTxtBarbarians, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBarbarian, $x + 215, $y, 64, 64, $BS_ICON)
		$g_ahChkDonateTroop[$eTroopBarbarian] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBarbarians, $x + 285, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBarbarians & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBarbarian] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBarbarians & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBarbarians & ":", $x - 5, $y + 5, -1, -1)
		$g_ahTxtDonateTroop[$eTroopBarbarian] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_01", "barbarians\r\nbarb")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBarbarians)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
		$g_ahTxtBlacklistTroop[$eTroopBarbarian] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_01", "no barbarians\r\nno barb\r\nbarbarians no\r\nbarb no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBarbarians)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopArcher] = GUICtrlCreateGroup($sTxtArchers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonArcher, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopArcher] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtArchers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtArchers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopArcher] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtArchers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtArchers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopArcher] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_02", "archers\r\narch")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtArchers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopArcher] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_02", "no archers\r\nno arch\r\narchers no\r\narch no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtArchers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopGiant] = GUICtrlCreateGroup($sTxtGiants, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonGiant, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopGiant] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtGiants, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGiants & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopGiant] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGiants & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtGiants & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopGiant] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_03", "giants\r\ngiant\r\nany\r\nreinforcement")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtGiants)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopGiant] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_03", "no giants\r\ngiants no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtGiants)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopGoblin] = GUICtrlCreateGroup($sTxtGoblins, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonGoblin, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopGoblin] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtGoblins, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGoblins & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopGoblin] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGoblins & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtGoblins & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopGoblin] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_04", "goblins\r\ngoblin")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtGoblins)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopGoblin] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_04", "no goblins\r\ngoblins no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtGoblins)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopWallBreaker] = GUICtrlCreateGroup($sTxtWallBreakers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWallBreaker, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopWallBreaker] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWallBreakers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallBreakers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopWallBreaker] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallBreakers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWallBreakers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopWallBreaker] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_05", "wall breakers\r\nbreaker")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWallBreakers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopWallBreaker] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_05", "no wall breakers\r\nwall breakers no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWallBreakers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopBalloon] = GUICtrlCreateGroup($sTxtBalloons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBalloon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopBalloon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBalloons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBalloons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBalloon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBalloons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBalloons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopBalloon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_06", "balloons\r\nballoon")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBalloons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopBalloon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_06", "no balloon\r\nballoons no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBalloons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopWizard] = GUICtrlCreateGroup($sTxtWizards, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWizard, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopWizard] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWizards, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWizards & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopWizard] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWizards & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWizards & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopWizard] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_07", "wizards\r\nwizard\r\nwiz")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWizards)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopWizard] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_07", "no wizards\r\nwizards no\r\nno wizard\r\nwizard no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWizards)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopHealer] = GUICtrlCreateGroup($sTxtHealers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHealer, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopHealer] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHealers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopHealer] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHealers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopHealer] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_08", "healer")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHealers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopHealer] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_08", "no healer\r\nhealer no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHealers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopDragon] = GUICtrlCreateGroup($sTxtDragons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtDragons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtDragons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_09", "dragon")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_09", "no dragon\r\ndragon no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopPekka] = GUICtrlCreateGroup($sTxtPekkas, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonPekka, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopPekka] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtPekkas, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPekkas & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopPekka] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPekkas & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtPekkas & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopPekka] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_10", "PEKKA\r\npekka")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtPekkas)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopPekka] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_10", "no PEKKA\r\npekka no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtPekkas)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopBabyDragon] = GUICtrlCreateGroup($sTxtBabyDragons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBabyDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopBabyDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBabyDragons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBabyDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBabyDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBabyDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBabyDragons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopBabyDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_11", "baby dragon\r\nbaby")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBabyDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopBabyDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_11", "no baby dragon\r\nbaby dragon no\r\nno baby\r\nbaby no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBabyDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopMiner] = GUICtrlCreateGroup($sTxtMiners, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMiner, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopMiner] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtMiners, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMiners & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopMiner] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMiners & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtMiners & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopMiner] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_12", "miner|mine")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtMiners)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopMiner] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_12", "no miner\r\nminer no\r\nno mine\r\nmine no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtMiners)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellLightning] = GUICtrlCreateGroup($sTxtLightningSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellLightning] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtLightningSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLightningSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellLightning] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLightningSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtLightningSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellLightning] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_13", "lightning")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtLightningSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellLightning] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_13", "no lightning\r\nlightning no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtLightningSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellHeal] = GUICtrlCreateGroup($sTxtHealSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellHeal] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHealSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellHeal] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		 GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHealSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellHeal] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_14", "heal")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHealSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellHeal] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_14", "no heal\r\nheal no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHealSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellRage] = GUICtrlCreateGroup($sTxtRageSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellRage] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtRageSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtRageSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellRage] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtRageSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtRageSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellRage] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_15", "rage")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtRageSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellRage] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_15", "no rage\r\nrage no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtRageSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellJump] = GUICtrlCreateGroup($sTxtJumpSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellJump] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtJumpSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtJumpSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellJump] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtJumpSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtJumpSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellJump] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_16", "jump")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtJumpSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellJump] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_16", "no jump\r\njump no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtJumpSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellFreeze] = GUICtrlCreateGroup($sTxtFreezeSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellFreeze] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtFreezeSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtFreezeSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellFreeze] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtFreezeSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtFreezeSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellFreeze] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_17", "freeze")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtFreezeSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellFreeze] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_17", "no freeze\r\nfreeze no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtFreezeSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopElectroDragon] = GUICtrlCreateGroup($sTxtElectroDragons, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElectroDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopElectroDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtElectroDragons, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtElectroDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopElectroDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtElectroDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtElectroDragons & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopElectroDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_31", "electro dragon\r\nelectrodrag\r\nedrag")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtElectroDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopElectroDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_31", "no electro dragon\r\nelectrodrag no\r\nedrag no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtElectroDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopMinion] = GUICtrlCreateGroup($sTxtMinions, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMinion, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopMinion] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtMinions, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMinions & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopMinion] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMinions & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtMinions & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopMinion] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_18", "minions\r\nminion")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtMinions)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopMinion] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_18", "no minions\r\nminions no\r\nno minion\r\nminion no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtMinions)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopHogRider] = GUICtrlCreateGroup($sTxtHogRiders, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHogRider, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopHogRider] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHogRiders, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHogRiders & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopHogRider] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " &  $sTxtHogRiders & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHogRiders & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopHogRider] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_19", "hogriders\r\nhogs\r\nhog")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHogRiders)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopHogRider] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_19", "no hogs\r\nhog no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHogRiders)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopValkyrie] = GUICtrlCreateGroup($sTxtValkyries, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonValkyrie, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopValkyrie] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtValkyries, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtValkyries & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopValkyrie] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtValkyries & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtValkyries & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopValkyrie] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_20", "valkyries\r\nvalkyrie\r\nvalk")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtValkyries)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopValkyrie] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_20", "no valkyries\r\nvalkyries no\r\nno valk\r\nvalk no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtValkyries)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopGolem] = GUICtrlCreateGroup($sTxtGolems, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonGolem, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopGolem] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtGolems, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGolems & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopGolem] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGolems & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtGolems & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopGolem] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_21", "golem")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtGolems)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopGolem] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_21", "no golem\r\ngolem no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtGolems)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopWitch] = GUICtrlCreateGroup($sTxtWitches, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWitch, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopWitch] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWitches, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWitches & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopWitch] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWitches & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWitches & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopWitch] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_22", "witches\r\nwitch")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWitches)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopWitch] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_22", "no witches\r\nwitch no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWitches)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopLavaHound] = GUICtrlCreateGroup($SetLog, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonLavaHound, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopLavaHound] = GUICtrlCreateCheckbox($sTxtDonate & " " & $SetLog, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $SetLog & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopLavaHound] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $SetLog & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $SetLog & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopLavaHound] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_23", "lavahound\r\nlava\r\nhound")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $SetLog)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopLavaHound] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_23", "no lavahound\r\nlava no\r\nhound no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $SetLog)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopBowler] = GUICtrlCreateGroup($sTxtBowlers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBowler, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopBowler] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBowlers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBowlers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBowler] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBowlers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBowlers & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopBowler] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_24", "bowler\r\nbowlers\r\nbowl")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBowlers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopBowler] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_24", "no bowler\r\nbowl no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBowlers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopIceGolem] = GUICtrlCreateGroup($sTxtIceGolems, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceGolem, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopIceGolem] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtIceGolems, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtIceGolems & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopIceGolem] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtIceGolems & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtIceGolems & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopIceGolem] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_35", "ice golem\r\nice golems")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtIceGolems)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopIceGolem] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_36", "no ice golem\r\nice golem no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtIceGolems)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	; SIEGE - $sTxtBattleBlimps
	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateGroup($sTxtWallWreckers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallW, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWallWreckers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallWreckers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		;$g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			;GUICtrlSetState(-1, $GUI_HIDE)
			;_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallWreckers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			;GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWallWreckers & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_32", "wall wreckers\r\nsieges\r\nwreckers")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWallWreckers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeWallWrecker] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_32", "no wreckers\r\nsiege no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWallWreckers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateGroup($sTxtBattleBlimps, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleB, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBattleBlimps, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBattleBlimps & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		;$g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			;GUICtrlSetState(-1, $GUI_HIDE)
			;_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBattleBlimps & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			;GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBattleBlimps & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_33", "battle blimps\r\nsieges\r\nblimps")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBattleBlimps)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeBattleBlimp] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_33", "no blimps\r\nsiege no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBattleBlimps)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateGroup($sTxtStoneSlammers, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnStoneS, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtStoneSlammers, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtStoneSlammers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		;$g_ahChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			;GUICtrlSetState(-1, $GUI_HIDE)
			;_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtStoneSlammers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			;GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtStoneSlammers & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_32", "stone slammers\r\nsieges\r\nslammers")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtStoneSlammers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs + $eSiegeStoneSlammer] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_35", "no slammers\r\nsiege no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtStoneSlammers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellPoison] = GUICtrlCreateGroup($sTxtPoisonSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonPoisonSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellPoison] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtPoisonSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPoisonSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellPoison] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPoisonSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtPoisonSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellPoison] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_25", "poison")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtPoisonSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellPoison] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_25", "no poison\r\npoison no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtPoisonSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellEarthquake] = GUICtrlCreateGroup($sTxtEarthQuakeSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonEarthQuakeSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellEarthquake] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtEarthQuakeSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtEarthQuakeSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellEarthquake] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtEarthQuakeSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtEarthQuakeSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellEarthquake] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_26", "earthquake\r\nquake")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtEarthQuakeSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellEarthquake] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_26", "no earthquake\r\nquake no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtEarthQuakeSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellHaste] = GUICtrlCreateGroup($sTxtHasteSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHasteSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellHaste] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHasteSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHasteSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellHaste] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHasteSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHasteSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellHaste] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_27", "haste")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHasteSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellHaste] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_27", "no haste\r\nhaste no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHasteSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellSkeleton] = GUICtrlCreateGroup($sTxtSkeletonSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonSkeletonSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellSkeleton] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSkeletonSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSkeletonSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellSkeleton] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSkeletonSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSkeletonSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellSkeleton] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_28", "skeleton|skel")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSkeletonSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellSkeleton] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_28", "no skeleton\r\nskeleton no\r\nno skel")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSkeletonSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellBat] = GUICtrlCreateGroup($sTxtBatSpells, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBatSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellBat] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBatSpells, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBatSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellBat] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBatSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBatSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellBat] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_34", "Bat")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBatSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellBat] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_34", "no bat\r\nbat no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBatSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	;;; Custom Combination Donate #1 by ChiefM3, edit by Hervidero
	$g_ahGrpDonateTroop[$eCustomA] = GUICtrlCreateGroup($sDonateTxtCustomA, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 2
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustom, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eCustomA] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomA, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomA & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eCustomA] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomA & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomA & ":", $x - 5, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eCustomA] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_29", "ground support\r\nground")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomA)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_01", "1st") & ":", $x, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomA[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWizard, $x + 25, $y, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomA[0] = GUICtrlCreateCombo("", $x + 60, $y, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtWizards)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomA")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomA[0] = GUICtrlCreateInput("2", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_02", "2nd") & ":", $x, $y + 29, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomA[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonArcher, $x + 25, $y + 25, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomA[1] = GUICtrlCreateCombo("", $x + 60, $y + 25, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtArchers)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomA")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomA[1] = GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_03", "3rd") & ":", $x, $y + 54, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomA[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBarbarian, $x + 25, $y + 50, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomA[2] = GUICtrlCreateCombo("", $x + 60, $y + 50, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtBarbarians)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomA")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomA[2] = GUICtrlCreateInput("1", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eCustomA] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_29", "no ground\r\nground no\r\nonly")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomA)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	;;; Custom Combination Donate #2 added by MonkeyHunter
	$g_ahGrpDonateTroop[$eCustomB] = GUICtrlCreateGroup($sDonateTxtCustomB, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 2
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustomB, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eCustomB] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomB, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomB & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eCustomB] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomB & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomB & ":", $x - 5, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eCustomB] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_30", "air support\r\nany air")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomB)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_01", -1) & ":", $x, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomB[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBabyDragon, $x + 25, $y, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomB[0] = GUICtrlCreateCombo("", $x + 60, $y, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtBabyDragons)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomB")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomB[0] = GUICtrlCreateInput("1", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_02", -1) & ":", $x, $y + 29, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomB[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBalloon, $x + 25, $y + 25, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomB[1] = GUICtrlCreateCombo("", $x + 60, $y + 25, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtBalloons)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomB")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomB[1] = GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_03", -1) & ":", $x, $y + 54, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomB[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMinion, $x + 25, $y + 50, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomB[2] = GUICtrlCreateCombo("", $x + 60, $y + 50, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtMinions)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomB")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomB[2] = GUICtrlCreateInput("5", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eCustomB] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_30", "no air\r\nair no\r\nonly\r\njust")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomB)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	;;; Additional Custom Donate #3 ~ Additional Custom Donate by NguyenAnhHD
	$g_ahGrpDonateTroop[$eCustomC] = GUICtrlCreateGroup($sDonateTxtCustomC, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 2
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustom, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eCustomC] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomC, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomC & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eCustomC] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomC & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomC & ":", $x - 5, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eCustomC] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_29", -1)))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomC)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_01", -1) & ":", $x, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomC[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWizard, $x + 25, $y, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomC[0] = GUICtrlCreateCombo("", $x + 60, $y, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtWizards)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomC")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomC[0] = GUICtrlCreateInput("1", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_02", -1) & ":", $x, $y + 29, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomC[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonArcher, $x + 25, $y + 25, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomC[1] = GUICtrlCreateCombo("", $x + 60, $y + 25, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtArchers)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomC")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomC[1] = GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_03", -1) & ":", $x, $y + 54, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomC[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBarbarian, $x + 25, $y + 50, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomC[2] = GUICtrlCreateCombo("", $x + 60, $y + 50, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtBarbarians)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomC")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomC[2] = GUICtrlCreateInput("5", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eCustomC] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_29", -1)))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomC)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	;;; Additional Custom Donate #4 ~ Additional Custom Donate by NguyenAnhHD
	$g_ahGrpDonateTroop[$eCustomD] = GUICtrlCreateGroup($sDonateTxtCustomD, $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 2
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustomB, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eCustomD] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomD, $x + 285, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomD & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eCustomD] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 20, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomD & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomD & ":", $x - 5, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eCustomD] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtDonateTroop_Item_30", -1)))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomD)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_01", -1) & ":", $x, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomD[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBabyDragon, $x + 25, $y, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomD[0] = GUICtrlCreateCombo("", $x + 60, $y, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtBabyDragons)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomD")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomD[0] = GUICtrlCreateInput("1", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_02", -1) & ":", $x, $y + 29, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomD[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBalloon, $x + 25, $y + 25, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomD[1] = GUICtrlCreateCombo("", $x + 60, $y + 25, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtBalloons)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomD")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomD[1] = GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblDonateCustom_03", -1) & ":", $x, $y + 54, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicDonateCustomD[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMinion, $x + 25, $y + 50, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahCmbDonateCustomD[2] = GUICtrlCreateCombo("", $x + 60, $y + 50, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtElectroDragons & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $SetLog & "|" & $sTxtBowlers & "|" & $sTxtIceGolems & "|" & $sTxtNothing, $sTxtMinions)
			GUICtrlSetOnEvent(-1, "cmbDonateCustomD")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateCustomD[2] = GUICtrlCreateInput("5", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_HIDE)

		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eCustomD] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtBlacklistTroop_Item_30", -1)))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomD)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_hGrpDonateGeneralBlacklist = GUICtrlCreateGroup( GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "Group_02", "General Blacklist"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBlacklist, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "LblGeneralBlacklist", "Do NOT donate to any of these keywords") & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hTxtGeneralBlacklist = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor(-1, 0x505050)
			GUICtrlSetColor(-1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtGeneralBlacklist_Item_01", "clan war\r\nwar\r\ncw")))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate", "TxtGeneralBlacklist_Info_01", "General Blacklist for donation requests"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateDonateSubTab
#EndRegion

#Region CreateScheduleSubTab
Func CreateScheduleSubTab()
	Local $xStart = 25, $yStart = 45
	$g_hGUI_ScheduleCC = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, $xStart - 20, $yStart - 20, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DONATE)
	; GUISetBkColor($COLOR_WHITE)
	Local $xStart = 20, $yStart = 20
	Local $x = $xStart
	Local $y = $yStart
	$g_hGrpDonateCC = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_01", "Donate Schedule"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 120)
	$y += 10
	$x += 10
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCCDonate, $x - 5, $y, 64, 60, $BS_ICON)

		$g_hChkDonateHoursEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1), $x + 40 + 30, $y - 6)
			GUICtrlSetOnEvent(-1, "chkDonateHours")

	$y += 20
	$x += 90
		$g_hLblDonateCChour = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", -1) & ":", $x, $y, -1, 15)
			Local $sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblDonateCChours[0] = GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[10] = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblDonateCChours[11] = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahLblDonateCChoursE = GUICtrlCreateLabel("X", $x + 213, $y + 2, 11, 11)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 15
		$g_ahChkDonateHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkDonateHoursE1")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", -1), $x + 5, $y)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 15
		$g_ahChkDonateHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkDonateHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkDonateHoursE2")
		$g_hLblDonateHoursPM = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", -1), $x + 5, $y)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 16
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 130
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_02", "Donation Clan Mates Filter"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 155)
	$y += 10
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblOption_donate_members", "Using this option you can choose to donate to all members of your team (No Filter), donate only to certain friends (White List) or give everyone except a few members of your team (Black List)"), $x , $y - 10, 380, 40, $BS_MULTILINE)
	$y += 35

		$g_hCmbFilterDonationsCC = GUICtrlCreateCombo("", $x, $y, 300, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_01", "No Filter, donate at all Clan Mates") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_02", "No Filter but collect Clan Mates Images") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_03", "Donate only at Clan Mates in White List") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_04", "Donate at all Except at Clan Mates in Black List"), GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbFilterDonationsCC_Item_01", -1))
			GUICtrlSetOnEvent(-1, "cmbABAlgorithm")

	$y += 35
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblImages_of_Clan_Mates", "Images of Clan Mates are captured and stored in main folder, move to appropriate folder (White or Black List)"), $x , $y - 10, 380, 30, $BS_MULTILINE)
	$y += 20

		GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "BtnOpen_Images_of_Clan_Mates", "Open Clan Mates Image Folder"), $x + 2, $y, 300, 20,-1)
;~			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonBarbarian, 1)
			GUICtrlSetOnEvent(-1, "btnFilterDonationsCC")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 60
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_03", "Skip donation near full troops"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 45)

		$g_hChkSkipDonateNearFullTroopsEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "ChkSkipDonateNearFullTroopsEnable", "Skip donation near full troops"), $x, $y - 4)
			GUICtrlSetState(-1, $GUI_CHECKED )
			GUICtrlSetOnEvent(-1, "chkskipDonateNearFulLTroopsEnable")

	$x += 180
		$g_hLblSkipDonateNearFullTroopsText = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblSkipDonateNearFullTroopsText", "if troops army camps are greater than"), $x, $y)
	$x += 110
		$g_hTxtSkipDonateNearFullTroopsPercentage = GUICtrlCreateInput("90", $x + 40 + 30, $y - 2, 20, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
			GUICtrlSetLimit(-1, 2)
	$x += 95
		$g_hLblSkipDonateNearFullTroopsText1 = GUICtrlCreateLabel("%", $x, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y += 25
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_04", "Balance Donate/Receive"), $x - 20, $y, $g_iSizeWGrpTab3, 40)
	$y += 12
		$g_hChkUseCCBalanced = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "Group_04", -1), $x, $y+2, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "ChkUseCCBalanced_Info_01", "Disable Clan Castle Usage or Donations if Ratio is not correct. Will Auto Continue when the Ratio is correct again"))
			GUICtrlSetOnEvent(-1, "chkBalanceDR")

	$x += 290
		$g_hCmbCCDonated = GUICtrlCreateCombo("", $x + 40, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbCCDonated_Info_01", "Donated ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")
		GUICtrlCreateLabel("/", $x + 73, $y + 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblCCDonated-Received_Info_01", "Wanted donated / received ratio") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "LblCCDonated-Received_Info_02", "1/1 means donated = received, 1/2 means donated = half the received etc."))
		$g_hCmbCCReceived = GUICtrlCreateCombo("", $x + 80, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Donate_Schedule", "CmbCCReceived_Info_01", "Received ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateScheduleSubTab
#EndRegion
