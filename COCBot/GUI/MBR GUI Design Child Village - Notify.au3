; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Notify" tab under the "Village" tab
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
Global $g_hGUI_NOTIFY = 0, $g_hGUI_NOTIFY_TAB = 0, $g_hGUI_NOTIFY_TAB_ITEM2 = 0, $g_hGUI_NOTIFY_TAB_ITEM6 = 0

Global $g_hGrpNotify = 0
Global $g_hChkNotifyPBEnable = 0, $g_hTxtNotifyPBToken = 0, $g_hChkNotifyTGEnable = 0, $g_hTxtNotifyTGToken = 0
Global $g_hChkNotifyRemote = 0, $g_hTxtNotifyOrigin = 0
Global $g_hChkNotifyDeleteAllPBPushes = 0, $g_hBtnNotifyDeleteMessages = 0, $g_hChkNotifyDeleteOldPBPushes = 0, $g_hCmbNotifyPushHours = 0, _
	   $g_hChkNotifyAlertMatchFound = 0, $g_hChkNotifyAlertLastRaidIMG = 0, $g_hChkNotifyAlertLastRaidTXT = 0, $g_hChkNotifyAlertCampFull = 0, _
	   $g_hChkNotifyAlertUpgradeWall = 0, $g_hChkNotifyAlertOutOfSync = 0, $g_hChkNotifyAlertTakeBreak = 0, $g_hChkNotifyAlertBuilderIdle = 0, _
	   $g_hChkNotifyAlertVillageStats = 0, $g_hChkNotifyAlertLastAttack = 0, $g_hChkNotifyAlertAnotherDevice = 0, $g_hChkNotifyAlertMaintenance = 0, _
	   $g_hChkNotifyAlertBAN = 0, $g_hChkNotifyBOTUpdate = 0

Global $g_hChkNotifyOnlyHours = 0, $g_hChkNotifyOnlyWeekDays = 0, $g_hChkNotifyhours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], _
	   $g_hChkNotifyWeekdays[7] = [0,0,0,0,0,0,0]

GLobal $g_hLblNotifyhour = 0, $g_ahLblNotifyhoursE = 0, $g_hChkNotifyhoursE1 = 0, $g_hChkNotifyhoursE2 = 0, $g_hLblNotifyhoursAM = 0, $g_hLblNotifyhoursPM = 0
GLobal $g_hLblNotifyhours[12] = [0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hLblNotifyWeekdays[7] = [0,0,0,0,0,0,0], $g_ahLblNotifyWeekdaysE = 0, $g_ahChkNotifyWeekdaysE = 0

Func CreateVillageNotify()
   $g_hGUI_NOTIFY = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_NOTIFY)

   GUISwitch($g_hGUI_NOTIFY)
   $g_hGUI_NOTIFY_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
   $g_hGUI_NOTIFY_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,18,"PushBullet/Telegram"))
   CreatePushBulletTelegramSubTab()
   $g_hGUI_NOTIFY_TAB_ITEM6 = GUICtrlCreateTabItem(GetTranslated(619,51,"Notify Schedule"))
   CreateNotifyScheduleSubTab()
   GUICtrlCreateTabItem("")
EndFunc

Func CreatePushBulletTelegramSubTab()
   Local $sTxtTip = ""
   Local $x = 25, $y = 45
   $g_hGrpNotify = GUICtrlCreateGroup(GetTranslated(619,1, "PushBullet/Telegram Notify") & " " & $g_sNotifyVersion, $x - 20, $y - 20, 430, 320)

		$x -= 10
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnNotify, $x + 3, $y, 32, 32)
		$g_hChkNotifyPBEnable = GUICtrlCreateCheckbox(GetTranslated(619,2, "Enable PushBullet"), $x + 40, $y + 5)
			GUICtrlSetOnEvent(-1, "chkPBTGenabled")
			_GUICtrlSetTip(-1, GetTranslated(619,3, "Enable PushBullet notifications"))
		$g_hChkNotifyDeleteAllPBPushes = GUICtrlCreateCheckbox(GetTranslated(619,8, "Delete Msg on Start"), $x + 160, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,9, "It will delete all previous push notification when you start bot"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hBtnNotifyDeleteMessages = GUICtrlCreateButton(GetTranslated(619,10, "Delete all Msg now"), $x + 300, $y, 100, 20)
			_GUICtrlSetTip(-1, GetTranslated(619,11, "Click here to delete all PushBullet messages."))
			GUICtrlSetOnEvent(-1, "btnDeletePBMessages")
			If $g_bBtnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 22
		$g_hChkNotifyDeleteOldPBPushes = GUICtrlCreateCheckbox(GetTranslated(619,12, "Delete Msg older than"), $x + 160, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,13, "Delete all previous push notification older than specified hour"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkDeleteOldPBPushes")
		$g_hCmbNotifyPushHours = GUICtrlCreateCombo("", $x + 300, $y, 100, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(619,14, "Set the interval for messages to be deleted."))
			Local $sTxtHours = GetTranslated(603, 14, -1)
			GUICtrlSetData(-1, "1 " & GetTranslated(603, 15, -1) &"|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & _
									$sTxtHours & "|7 " & $sTxtHours & "|8 " &$sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & _
									$sTxtHours & "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & _
									$sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours )
			_GUICtrlComboBox_SetCurSel(-1,0)
			GUICtrlSetState (-1, $GUI_DISABLE)

		$y += 30
		GUICtrlCreateLabel(GetTranslated(619,16, "Token (PushBullet)") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$g_hTxtNotifyPBToken = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
			_GUICtrlSetTip(-1, GetTranslated(619,17, "You need a Token to use PushBullet notifications. Get a token from PushBullet.com"))
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 20
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnTelegram, $x + 3, $y, 32, 32)
		 $g_hChkNotifyTGEnable = GUICtrlCreateCheckbox(GetTranslated(619,4, "Enable Telegram"), $x + 40, $y + 5)
			GUICtrlSetOnEvent(-1, "chkPBTGenabled")
			_GUICtrlSetTip(-1, GetTranslated(619,5, "Enable Telegram notifications"))

		$y += 40
		GUICtrlCreateLabel(GetTranslated(619,18, "Token (Telegram)") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$g_hTxtNotifyTGToken = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
			_GUICtrlSetTip(-1, GetTranslated(619,19, "You need a Token to use Telegram notifications. Get a token from Telegram.com"))
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 30
		$g_hChkNotifyRemote = GUICtrlCreateCheckbox(GetTranslated(619,6, "Remote Control"), $x + 10, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,7, "Enables PushBullet Remote function"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslated(619,20, "Origin") & ":", $x + 120, $y + 3, -1, -1, $SS_RIGHT)
			$sTxtTip = GetTranslated(619,21, "Origin - Village name.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtNotifyOrigin = GUICtrlCreateInput("", $x + 170, $y, 230, 19)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 25
		GUICtrlCreateLabel(GetTranslated(619,22, "Send a PushBullet/Telegram message for these options") & ":", $x, $y, -1, -1, $SS_RIGHT)

		$y += 15
		$g_hChkNotifyAlertMatchFound = GUICtrlCreateCheckbox(GetTranslated(619,23, "Match Found"), $x + 10, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,24, "Send the amount of available loot when bot finds a village to attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLastRaidIMG = GUICtrlCreateCheckbox(GetTranslated(619,25, "Last raid as image"), $x + 100, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,26, "Send the last raid screenshot."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLastRaidTXT = GUICtrlCreateCheckbox(GetTranslated(619,27, "Last raid as Text"), $x + 210, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslated(619,28, "Send the last raid results as text."))
		$g_hChkNotifyAlertCampFull = GUICtrlCreateCheckbox(GetTranslated(619,29, "Army Camp Full"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,30, "Sent an Alert when your Army Camp is full."))
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 20
		$g_hChkNotifyAlertUpgradeWall = GUICtrlCreateCheckbox(GetTranslated(619,31, "Wall upgrade"), $x + 10, $y, -1, -1)
			 _GUICtrlSetTip(-1, GetTranslated(619,32, "Send info about wall upgrades."))
			 GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertOutOfSync = GUICtrlCreateCheckbox(GetTranslated(619,33, "Error: Out Of Sync"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,34, "Send an Alert when you get the Error: Client and Server out of sync"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertTakeBreak = GUICtrlCreateCheckbox(GetTranslated(619,35, "Take a break"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,36, "Send an Alert when you have been playing for too long and your villagers need to rest."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertBuilderIdle = GUICtrlCreateCheckbox(GetTranslated(619,37, "Builder Idle"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,38, "Send an Alert when at least one builder is idle."))
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 20
		$g_hChkNotifyAlertVillageStats = GUICtrlCreateCheckbox(GetTranslated(619,39, "Village Report"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,40, "Send a Village Report."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertLastAttack = GUICtrlCreateCheckbox(GetTranslated(619,41, "Alert Last Attack"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,42, "Send info about the Last Attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertAnotherDevice = GUICtrlCreateCheckbox(GetTranslated(619,43, "Another device"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,44, "Send an Alert when your village is connected to from another device."))
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 20
		$g_hChkNotifyAlertMaintenance = GUICtrlCreateCheckbox(GetTranslated(619,45, "Maintenance"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,46, "Send an Alert when CoC is under maintenance by SuperCell"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyAlertBAN = GUICtrlCreateCheckbox(GetTranslated(619,47, "BAN"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,48, "Send an Alert if your village was BANNED by SuperCell"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hChkNotifyBOTUpdate = GUICtrlCreateCheckbox(GetTranslated(619,49, "BOT Update"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,50, "Send an Alert when there is a new version of the bot."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslated(619,69,"Help ?"), $x + 200, $y + 60, 220, 24, $SS_RIGHT)
			GUICtrlSetOnEvent(-1, "NotifyHelp")
			GUICtrlSetCursor(-1, 0)
			GUICtrlSetFont(-1, 8.5, $FW_BOLD)
			_GUICtrlSetTip(-1, GetTranslated(619,70,"Click here to get Help about Notify Remote commands to PushBullet and Telegram"))
			GUICtrlSetColor(-1, $COLOR_NAVY)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
 EndFunc

Func CreateNotifyScheduleSubTab()
	Local $x = 25
	Local $y = 150 - 105
	Local $sTxtTip = ""

	GUICtrlCreateGroup(GetTranslated(619,51, "Notify Schedule"), $x - 20, $y - 20, 430, 334)
	$x += 10
	$y += 10
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnPBNotify, $x - 5, $y, 64, 64, $BS_ICON)
	$g_hChkNotifyOnlyHours = GUICtrlCreateCheckbox(GetTranslated(603,30, -1), $x+70, $y-6)
		GUICtrlSetOnEvent(-1, "chkNotifyHours")

	$x += 59
	$y += 85
	$g_hLblNotifyhour = GUICtrlCreateLabel(GetTranslated(603, 15, -1) & ":", $x , $y, -1, 15)
		$sTxtTip = GetTranslated(603, 30, -1)
		_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblNotifyhours[0] = GUICtrlCreateLabel(" 0", $x + 30, $y)
	$g_hLblNotifyhours[1] = GUICtrlCreateLabel(" 1", $x + 45, $y)
	$g_hLblNotifyhours[2] = GUICtrlCreateLabel(" 2", $x + 60, $y)
	$g_hLblNotifyhours[3] = GUICtrlCreateLabel(" 3", $x + 75, $y)
	$g_hLblNotifyhours[4] = GUICtrlCreateLabel(" 4", $x + 90, $y)
	$g_hLblNotifyhours[5] = GUICtrlCreateLabel(" 5", $x + 105, $y)
	$g_hLblNotifyhours[6] = GUICtrlCreateLabel(" 6", $x + 120, $y)
	$g_hLblNotifyhours[7] = GUICtrlCreateLabel(" 7", $x + 135, $y)
	$g_hLblNotifyhours[8] = GUICtrlCreateLabel(" 8", $x + 150, $y)
	$g_hLblNotifyhours[9] = GUICtrlCreateLabel(" 9", $x + 165, $y)
	$g_hLblNotifyhours[10] = GUICtrlCreateLabel("10", $x + 180, $y)
	$g_hLblNotifyhours[11] = GUICtrlCreateLabel("11", $x + 195, $y)
	$g_ahLblNotifyhoursE = GUICtrlCreateLabel("X", $x + 214, $y+1, 11, 11)

	$y += 15
	$g_hChkNotifyhours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
		_GUICtrlSetTip(-1, GetTranslated(603, 2, -1))
		GUICtrlSetOnEvent(-1, "chkNotifyhoursE1")
	$g_hLblNotifyhoursAM = GUICtrlCreateLabel(GetTranslated(603, 3, -1), $x + 10, $y)

	$y += 15
	$g_hChkNotifyhours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyhoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
		_GUICtrlSetTip(-1, GetTranslated(603, 2, -1))
		GUICtrlSetOnEvent(-1, "chkNotifyhoursE2")
	$g_hLblNotifyhoursPM = GUICtrlCreateLabel(GetTranslated(603, 4, -1), $x + 10, $y)

	$x = 35
	$y = 220
	$g_hChkNotifyOnlyWeekDays = GUICtrlCreateCheckbox(GetTranslated(603, 31, -1), $x + 70, $y - 6)
		GUICtrlSetOnEvent(-1, "chkNotifyWeekDays")
		GUICtrlSetState(-1, $GUI_DISABLE)

	$x += 59
	$y += 19
	GUICtrlCreateLabel(GetTranslated(603, 36, -1) & ":", $x, $y, -1, 15)
		_GUICtrlSetTip(-1, GetTranslated(603, 31, -1))
	$g_hLblNotifyWeekdays[0] = GUICtrlCreateLabel(GetTranslated(603, 16, -1), $x + 30, $y)
		_GUICtrlSetTip(-1, GetTranslated(603, 17, -1))
	$g_hLblNotifyWeekdays[1] = GUICtrlCreateLabel(GetTranslated(603, 18, -1), $x + 46, $y)
		_GUICtrlSetTip(-1, GetTranslated(603, 19, -1))
	$g_hLblNotifyWeekdays[2] = GUICtrlCreateLabel(GetTranslated(603, 20, -1), $x + 62, $y)
		_GUICtrlSetTip(-1, GetTranslated(603, 21, -1))
	$g_hLblNotifyWeekdays[3] = GUICtrlCreateLabel(GetTranslated(603, 22, -1), $x + 80, $y)
		_GUICtrlSetTip(-1, GetTranslated(603, 23, -1))
	$g_hLblNotifyWeekdays[4] = GUICtrlCreateLabel(GetTranslated(603, 24, -1), $x + 99, $y)
		_GUICtrlSetTip(-1, GetTranslated(603, 25, -1))
	$g_hLblNotifyWeekdays[5] = GUICtrlCreateLabel(GetTranslated(603, 26, -1), $x + 116, $y)
		_GUICtrlSetTip(-1, GetTranslated(603, 27, -1))
	$g_hLblNotifyWeekdays[6] = GUICtrlCreateLabel(GetTranslated(603, 28, -1), $x + 133, $y)
		_GUICtrlSetTip(-1, GetTranslated(603, 29, -1))
	$g_ahLblNotifyWeekdaysE = GUICtrlCreateLabel("X", $x + 155, $y+1, -1, 15)
		_GUICtrlSetTip(-1, GetTranslated(603, 2, -1))

	$y += 13
	$g_hChkNotifyWeekdays[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyWeekdays[1] = GUICtrlCreateCheckbox("", $x + 47, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyWeekdays[2] = GUICtrlCreateCheckbox("", $x + 64, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyWeekdays[3] = GUICtrlCreateCheckbox("", $x + 81, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyWeekdays[4] = GUICtrlCreateCheckbox("", $x + 99, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyWeekdays[5] = GUICtrlCreateCheckbox("", $x + 117, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_hChkNotifyWeekdays[6] = GUICtrlCreateCheckbox("", $x + 133, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$g_ahChkNotifyWeekdaysE = GUICtrlCreateCheckbox("", $x + 151, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetState(-1, $GUI_DISABLE)
		_GUICtrlSetTip(-1, GetTranslated(603, 2, -1))
		GUICtrlSetOnEvent(-1, "ChkNotifyWeekdaysE")
EndFunc
