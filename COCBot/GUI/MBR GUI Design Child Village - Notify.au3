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

$hGUI_NOTIFY = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_VILLAGE)
;GUISetBkColor($COLOR_WHITE, $hGUI_NOTIFY)

$hGUI_NOTIFY_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
;$hGUI_NOTIFY_TAB_ITEM1 = GUICtrlCreateTabItem("How")
;	Local $x = 25, $y = 45
;GUICtrlCreateTabItem("")

$hGUI_NOTIFY_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,18,"PushBullet"))
	Global $grpPushBullet, $chkPBenabled,$chkPBRemote,$chkDeleteAllPBPushes,$btnDeletePBmessages,$chkDeleteOldPBPushes,$cmbHoursPushBullet
	Global $PushBulletTokenValue, $OrigPushBullet, $chkAlertPBVMFound, $chkAlertPBLastRaid, $chkAlertPBLastRaidTxt, $chkAlertPBCampFull
	Global $chkAlertPBWallUpgrade, $chkAlertPBOOS, $chkAlertPBVBreak, $chkAlertPBVillage, $chkAlertPBLastAttack
	Global $chkAlertPBOtherDevice

	Local $x = 25, $y = 45
		$grpPushBullet = GUICtrlCreateGroup(GetTranslated(619,2, "PushBullet Alert"), $x - 20, $y - 20, 430, 334)
		$x -= 10
		$picPushBullet = GUICtrlCreateIcon ($pIconLib, $eIcnPushBullet, $x + 3, $y, 32, 32)
		$chkPBenabled = GUICtrlCreateCheckbox(GetTranslated(619,3, "Enable"), $x + 40, $y)
			GUICtrlSetOnEvent(-1, "chkPBenabled")
			_GUICtrlSetTip(-1, GetTranslated(619,4, "Enable PushBullet notifications"))
		$y += 22
		$chkPBRemote = GUICtrlCreateCheckbox(GetTranslated(619,5, "Remote Control"), $x + 40, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,6, "Enables PushBullet Remote function"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y = 45
		$chkDeleteAllPBPushes = GUICtrlCreateCheckbox(GetTranslated(619,7, "Delete Msg on Start"), $x + 160, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,8, "It will delete all previous push notification when you start bot"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$btnDeletePBmessages = GUICtrlCreateButton(GetTranslated(619,9, "Delete all Msg now"), $x + 300, $y, 100, 20)
			_GUICtrlSetTip(-1, GetTranslated(619,10, "Click here to delete all Pushbullet messages."))
			GUICtrlSetOnEvent(-1, "btnDeletePBMessages")
			IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 22
		$chkDeleteOldPBPushes = GUICtrlCreateCheckbox(GetTranslated(619,11, "Delete Msg older than"), $x + 160, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,12, "Delete all previous push notification older than specified hour"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkDeleteOldPBPushes")
		$cmbHoursPushBullet = GUICtrlCreateCombo("", $x + 300, $y, 100, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(619,13, "Set the interval for messages to be deleted."))
			$sTxtHours = GetTranslated(603,14, "Hours")
			GUICtrlSetData(-1, "1 " & GetTranslated(603,15, "Hour") &"|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & $sTxtHours & "|7 " & $sTxtHours & "|8 " &$sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & $sTxtHours & "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & $sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours )
			_GUICtrlComboBox_SetCurSel(-1,0)
			GUICtrlSetState (-1, $GUI_DISABLE)
		$y += 30
		$lblPushBulletTokenValue = GUICtrlCreateLabel(GetTranslated(619,14, "Access Token") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$PushBulletTokenValue = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
			_GUICtrlSetTip(-1, GetTranslated(619,15, "You need a Token to use PushBullet notifications. Get a token from PushBullet.com"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 25
		$lblOrigPushBullet = GUICtrlCreateLabel(GetTranslated(619,16, "Origin") & ":", $x, $y, -1, -1, $SS_RIGHT)
			$txtTip = GetTranslated(619,17, "Origin - Village name.")
			_GUICtrlSetTip(-1, $txtTip)
		$OrigPushBullet = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 25
		$lblNotifyPBWhen = GUICtrlCreateLabel(GetTranslated(619,18, "Send a PushBullet message for these options") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$y += 15
		$chkAlertPBVMFound = GUICtrlCreateCheckbox(GetTranslated(619,19, "Match Found"), $x + 10, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,20, "Send the amount of available loot when bot finds a village to attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBLastRaid = GUICtrlCreateCheckbox(GetTranslated(619,21, "Last raid as image"), $x + 100, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,22, "Send the last raid screenshot."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBLastRaidTxt = GUICtrlCreateCheckbox(GetTranslated(619,23, "Last raid as Text"), $x + 210, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslated(619,24, "Send the last raid results as text."))
		$chkAlertPBCampFull = GUICtrlCreateCheckbox(GetTranslated(619,25, "Army Camp Full"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,26, "Sent an Alert when your Army Camp is full."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 20
		$chkAlertPBWallUpgrade = GUICtrlCreateCheckbox(GetTranslated(619,27, "Wall upgrade"), $x + 10, $y, -1, -1)
			 _GUICtrlSetTip(-1, GetTranslated(619,28, "Send info about wall upgrades."))
			 GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBOOS = GUICtrlCreateCheckbox(GetTranslated(619,29, "Error: Out Of Sync"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,30, "Send an Alert when you get the Error: Client and Server out of sync"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBVBreak = GUICtrlCreateCheckbox(GetTranslated(619,31, "Take a break"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,32, "Send an Alert when you have been playing for too long and your villagers need to rest."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 20
		$chkAlertPBVillage = GUICtrlCreateCheckbox(GetTranslated(619,33, "Village Report"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,34, "Send a Village Report."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBLastAttack = GUICtrlCreateCheckbox(GetTranslated(619,35, "Alert Last Attack"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,36, "Send info about the Last Attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBOtherDevice = GUICtrlCreateCheckbox(GetTranslated(619,37, "Another device connected"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,38, "Send an Alert when your village is connected to from another device."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
$hGUI_NOTIFY_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600,19,"Instructions"))
	Local $x = 25, $y = 45
		$lblgrppushbullet = GUICtrlCreateGroup(GetTranslated(620,0, "Remote Control Functions"), $x - 20, $y - 20, 430, 334)
			$x -= 10
			$lblPBdesc = GUICtrlCreateLabel(GetTranslated(620,1, "BOT") & " " & GetTranslated(620,14,"HELP") & GetTranslated(620,2, " - send this help message") & @CRLF & _
				GetTranslated(620,1, -1) & " " & GetTranslated(620,15,"DELETE") & GetTranslated(620,3, " - delete all your previous messages") & @CRLF & _
				GetTranslated(620,1, -1) & " <" & GetTranslated(619,16, -1) & "> " & GetTranslated(620,16,"RESTART") & GetTranslated(620,4, " - restart the bot named <Village Name> and Android Emulator") & @CRLF & _
				GetTranslated(620,1, -1) & " <" & GetTranslated(619,16, -1) & "> " & GetTranslated(620,17,"STOP") & GetTranslated(620,5, " - stop the bot named <Village Name>") & @CRLF & _
				GetTranslated(620,1, -1) & " <" & GetTranslated(619,16, -1) & "> " & GetTranslated(620,18,"PAUSE") & GetTranslated(620,6, " - pause the bot named <Village Name>") & @CRLF & _
				GetTranslated(620,1, -1) & " <" & GetTranslated(619,16, -1) & "> " & GetTranslated(620,19,"RESUME") & GetTranslated(620,7, " - resume the bot named <Village Name>") & @CRLF & _
				GetTranslated(620,1, -1) & " <" & GetTranslated(619,16, -1) & "> " & GetTranslated(620,20,"STATS") & GetTranslated(620,8, " - send Village Statistics of <Village Name>") & @CRLF & _
				GetTranslated(620,1, -1) & " <" & GetTranslated(619,16, -1) & "> " & GetTranslated(620,21,"LOG") & GetTranslated(620,9, " - send the current log file of <Village Name>") & @CRLF & _
				GetTranslated(620,1, -1) & " <" & GetTranslated(619,16, -1) & "> " & GetTranslated(620,22,"LASTRAID") & GetTranslated(620,10, " - send the last raid loot screenshot of <Village Name>") & @CRLF & _
				GetTranslated(620,1, -1) & " <" & GetTranslated(619,16, -1) & "> " & GetTranslated(620,23,"LASTRAIDTXT") & GetTranslated(620,11, " - send the last raid loot values of <Village Name>") & @CRLF & _
				GetTranslated(620,1, -1) & " <" & GetTranslated(619,16, -1) & "> " & GetTranslated(620,24,"SCREENSHOT") & GetTranslated(620,12, " - send a screenshot of <Village Name>"), $x, $y - 5, -1, -1, $SS_LEFT)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")


;GUISetState()
