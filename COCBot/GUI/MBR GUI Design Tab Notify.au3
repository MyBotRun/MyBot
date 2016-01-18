; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ Notify Tab
;~ -------------------------------------------------------------
$tabNotify = GUICtrlCreateTabItem(GetTranslated(9,1, "Notify"))
	Local $x = 30, $y = 150
	$grpPushBullet = GUICtrlCreateGroup(GetTranslated(9,2, "PushBullet Alert"), $x - 20, $y - 20, 450, 375)
	$picPushBullet = GUICtrlCreateIcon ($pIconLib, $eIcnPushBullet, $x, $y, 32, 32)
	$chkPBenabled = GUICtrlCreateCheckbox(GetTranslated(9,3, "Enable"), $x + 40, $y)
		GUICtrlSetOnEvent(-1, "chkPBenabled")
		GUICtrlSetTip(-1, GetTranslated(9,4, "Enable PushBullet notifications"))
	$y += 22
	$chkPBRemote = GUICtrlCreateCheckbox(GetTranslated(9,5, "Remote Control"), $x + 40, $y)
		GUICtrlSetTip(-1, GetTranslated(9,6, "Enables PushBullet Remote function"))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y = 150
	$chkDeleteAllPushes = GUICtrlCreateCheckbox(GetTranslated(9,7, "Delete Msg on Start"), $x + 160, $y)
		GUICtrlSetTip(-1, GetTranslated(9,8, "It will delete all previous push notification when you start bot"))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$btnDeletePBmessages = GUICtrlCreateButton(GetTranslated(9,9, "Delete all Msg now"), $x + 300, $y, 100, 20)
		GUICtrlSetTip(-1, GetTranslated(9,10, "Click here to delete all Pushbullet messages."))
		GUICtrlSetOnEvent(-1, "btnDeletePBMessages")
		IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 22
	$chkDeleteOldPushes = GUICtrlCreateCheckbox(GetTranslated(9,11, "Delete Msg older than"), $x + 160, $y)
		GUICtrlSetTip(-1, GetTranslated(9,12, "Delete all previous push notification older than specified hour"))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "chkDeleteOldPushes")
	$cmbHoursPushBullet = GUICtrlCreateCombo("", $x + 300, $y, 100, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetTip(-1, GetTranslated(9,13, "Set the interval for messages to be deleted."))
		$sTxtHours = GetTranslated(9,15, "Hours")
		GUICtrlSetData(-1, "1 " & GetTranslated(9,14, "Hour") &"|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & $sTxtHours & "|7 " & $sTxtHours & "|8 " &$sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & $sTxtHours & "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & $sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours, "-")
		GUICtrlSetState (-1, $GUI_DISABLE)
	$y += 30
	$lblPushBTokenValue = GUICtrlCreateLabel(GetTranslated(9,16, "Access Token") & ":", $x, $y, -1, -1, $SS_RIGHT)
	$PushBTokenValue = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
		GUICtrlSetTip(-1, GetTranslated(9,17, "You need a Token to use PushBullet notifications. Get a token from PushBullet.com"))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 25
	$lblOrigPush = GUICtrlCreateLabel(GetTranslated(9,18, "Profile/Village Name") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$txtTip = GetTranslated(9,19, "Your Profile/Village name - Set this on the Misc Tab under Profiles.")
		GUICtrlSetTip(-1, $txtTip)
	$OrigPushB = GUICtrlCreateLabel("", $x + 120, $y - 1, 280, 20, $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 25
	$lblNotifyWhen = GUICtrlCreateLabel(GetTranslated(9,20, "Send a PushBullet message for these options") & ":", $x, $y, -1, -1, $SS_RIGHT)
	$y += 15
	$chkAlertPBVMFound = GUICtrlCreateCheckbox(GetTranslated(9,21, "Match Found"), $x + 10, $y)
		GUICtrlSetTip(-1, GetTranslated(9,22, "Send the amount of available loot when bot finds a village to attack."))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBLastRaid = GUICtrlCreateCheckbox(GetTranslated(9,23, "Last raid as image"), $x + 100, $y)
		GUICtrlSetTip(-1, GetTranslated(9,24, "Send the last raid screenshot."))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBLastRaidTxt = GUICtrlCreateCheckbox(GetTranslated(9,25, "Last raid as Text"), $x + 210, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, GetTranslated(9,26, "Send the last raid results as text."))
	$chkAlertPBCampFull = GUICtrlCreateCheckbox(GetTranslated(9,27, "Army Camp Full"), $x + 315, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(9,28, "Sent an Alert when your Army Camp is full."))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 20
	$chkAlertPBWallUpgrade = GUICtrlCreateCheckbox(GetTranslated(9,29, "Wall upgrade"), $x + 10, $y, -1, -1)
		 GUICtrlSetTip(-1, GetTranslated(9,30, "Send info about wall upgrades."))
		 GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBOOS = GUICtrlCreateCheckbox(GetTranslated(9,31, "Error: Out Of Sync"), $x + 100, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(9,32, "Send an Alert when you get the Error: Client and Server out of sync"))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBVBreak = GUICtrlCreateCheckbox(GetTranslated(9,33, "Take a break"), $x + 210, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(9,34, "Send an Alert when you have been playing for too long and your villagers need to rest."))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 20
	$chkAlertPBVillage = GUICtrlCreateCheckbox(GetTranslated(9,35, "Village Report"), $x + 10, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(9,36, "Send a Village Report."))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBLastAttack = GUICtrlCreateCheckbox(GetTranslated(9,37, "Alert Last Attack"), $x + 100, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(9,38, "Send info about the Last Attack."))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBOtherDevice = GUICtrlCreateCheckbox(GetTranslated(9,39, "Another device connected"), $x + 210, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(9,40, "Sent an Alert when your village is connected to from another device."))
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y = 350
	$lblgrppushbullet = GUICtrlCreateGroup(GetTranslated(9,41, "PushBullet Remote Control Functions"), $x - 10, $y - 20, 430, 170)
		$lblPBdesc = GUICtrlCreateLabel(GetTranslated(9,42, "BOT HELP - send this help message") & @CRLF & GetTranslated(9,43, "BOT DELETE  - delete all your previous PushBullet messages") & @CRLF & _
			GetTranslated(9,44, "BOT <Village Name> RESTART - restart the bot named <Village Name> and BlueStacks") & @CRLF & GetTranslated(9,45, "BOT <Village Name> STOP - stop the bot named <Village Name>") & @CRLF & _
			GetTranslated(9,46, "BOT <Village Name> PAUSE - pause the bot named <Village Name>") & @CRLF & GetTranslated(9,47, "BOT <Village Name> RESUME   - resume the bot named <Village Name>") & @CRLF & _
			GetTranslated(9,48, "BOT <Village Name> STATS - send Village Statistics of <Village Name>") & @CRLF & GetTranslated(9,49, "BOT <Village Name> LOG - send the current log file of <Village Name>") & @CRLF & _
			GetTranslated(9,50, "BOT <Village Name> LASTRAID -  send the last raid loot screenshot of <Village Name>") & @CRLF & GetTranslated(9,51, "BOT <Village Name> LASTRAIDTXT - send the last raid loot values of <Village Name>") & @CRLF & _
			GetTranslated(9,52, "BOT <Village Name> SCREENSHOT - send a screenshot of <Village Name>"), $x, $y, -1, -1, $SS_LEFT)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
