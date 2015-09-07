; #FUNCTION# ====================================================================================================================
; Name ..........: CGB GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ Notify Tab
;~ -------------------------------------------------------------
$tabNotify = GUICtrlCreateTabItem("Notify")
	Local $x = 30, $y = 150
	$grpPushBullet = GUICtrlCreateGroup("PushBullet Alert", $x - 20, $y - 20, 450, 375)
	$picPushBullet = GUICtrlCreateIcon ($pIconLib, $eIcnPushBullet, $x, $y, 32, 32)
	$chkPBenabled = GUICtrlCreateCheckbox("Enable", $x + 40, $y)
		GUICtrlSetOnEvent(-1, "chkPBenabled")
		GUICtrlSetTip(-1, "Enable PushBullet notifications")
	$y += 22
	$chkPBRemote = GUICtrlCreateCheckbox("Remote Control", $x + 40, $y)
		GUICtrlSetTip(-1, "Enables PushBullet Remote function")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y = 150
	$chkDeleteAllPushes = GUICtrlCreateCheckbox("Delete Msg on Start", $x + 160, $y)
		GUICtrlSetTip(-1, "It will delete all previous push notification when you start bot")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$btnDeletePBmessages = GUICtrlCreateButton("Delete all Msg now", $x + 300, $y, 100, 20)
		GUICtrlSetTip(-1, "Click here to delete all Pushbullet messages.")
		GUICtrlSetOnEvent(-1, "btnDeletePBMessages")
		IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 22
	$chkDeleteOldPushes = GUICtrlCreateCheckbox("Delete Msg older than", $x + 160, $y)
		GUICtrlSetTip(-1, "Delete all previous push notification older than specified hour")
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "chkDeleteOldPushes")
	$cmbHoursPushBullet = GUICtrlCreateCombo("", $x + 300, $y, 100, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetTip(-1, "Set the interval for messages to be deleted.")
		GUICtrlSetData(-1, "1 Hour|2 Hours|3 Hours|4 Hours|5 Hours|6 Hours|7 Hours|8 Hours|9 Hours|10 Hours|11 Hours|12 Hours|13 Hours|14 Hours|15 Hours|16 Hours|17 Hours|18 Hours|19 Hours|20 Hours|21 Hours|22 Hours|23 Hours|24 Hours", "-")
		GUICtrlSetState (-1, $GUI_DISABLE)
	$y += 30
	$lblPushBTokenValue = GUICtrlCreateLabel("Access Token:", $x, $y, -1, -1, $SS_RIGHT)
	$PushBTokenValue = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
		GUICtrlSetTip(-1, "You need a Token to use PushBullet notifications. Get a token from PushBullet.com")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 25
	$lblOrigPush = GUICtrlCreateLabel("Profile/Village Name:", $x, $y, -1, -1, $SS_RIGHT)
		$txtTip = "Your Profile/Village name - Set this on the Misc Tab under Profiles."
		GUICtrlSetTip(-1, $txtTip)
	$OrigPushB = GUICtrlCreateLabel("", $x + 120, $y - 1, 280, 20, $SS_SUNKEN)
		GUICtrlSetBkColor(-1, 0xF0F0F0)
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 25
	$lblNotifyWhen = GUICtrlCreateLabel("Send a PushBullet message for these options:", $x, $y, -1, -1, $SS_RIGHT)
	$y += 15
	$chkAlertPBVMFound = GUICtrlCreateCheckbox("Match Found", $x + 10, $y)
		GUICtrlSetTip(-1, "Send the amount of available loot when bot finds a village to attack.")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBLastRaid = GUICtrlCreateCheckbox("Last raid as image", $x + 100, $y)
		GUICtrlSetTip(-1, "Send the last raid screenshot.")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBLastRaidTxt = GUICtrlCreateCheckbox("Last raid as Text", $x + 210, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Send the last raid results as text.")
	$chkAlertPBCampFull = GUICtrlCreateCheckbox("Army Camp Full", $x + 315, $y, -1, -1)
		GUICtrlSetTip(-1, "Sent an Alert when your Army Camp is full.")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 20
	$chkAlertPBWallUpgrade = GUICtrlCreateCheckbox("Wall upgrade", $x + 10, $y, -1, -1)
		 GUICtrlSetTip(-1, "Send info about wall upgrades.")
		 GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBOOS = GUICtrlCreateCheckbox("Error: Out Of Sync", $x + 100, $y, -1, -1)
		GUICtrlSetTip(-1, "Send an Alert when you get the Error: Client and Server out of sync")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBVBreak = GUICtrlCreateCheckbox("Take a break", $x + 210, $y, -1, -1)
		GUICtrlSetTip(-1, "Send an Alert when you have been playing for too long and your villagers need to rest.")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 20
	$chkAlertPBVillage = GUICtrlCreateCheckbox("Village Report", $x + 10, $y, -1, -1)
		GUICtrlSetTip(-1, "Send a Village Report.")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBLastAttack = GUICtrlCreateCheckbox("Alert Last Attack", $x + 100, $y, -1, -1)
		GUICtrlSetTip(-1, "Send info about the Last Attack.")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkAlertPBOtherDevice = GUICtrlCreateCheckbox("Another device connected", $x + 210, $y, -1, -1)
		GUICtrlSetTip(-1, "Sent an Alert when your village is connected to from another device.")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y = 350
	$lblgrppushbullet = GUICtrlCreateGroup("PushBullet Remote Control Functions", $x - 10, $y - 20, 430, 170)
		$lblPBdesc = GUICtrlCreateLabel("BOT HELP - send this help message" & @CRLF & "BOT DELETE  - delete all your previous PushBullet messages" & @CRLF & _
			"BOT <Village Name> RESTART - restart the bot named <Village Name> and BlueStacks" & @CRLF & "BOT <Village Name> STOP - stop the bot named <Village Name>" & @CRLF & _
			"BOT <Village Name> PAUSE - pause the bot named <Village Name>" & @CRLF & "BOT <Village Name> RESUME   - resume the bot named <Village Name>" & @CRLF & _
			"BOT <Village Name> STATS - send Village Statistics of <Village Name>" & @CRLF & "BOT <Village Name> LOG - send the current log file of <Village Name>" & @CRLF & _
			"BOT <Village Name> LASTRAID -  send the last raid loot screenshot of <Village Name>" & @CRLF & "BOT <Village Name> LASTRAIDTXT - send the last raid loot values of <Village Name>" & @CRLF & _
			"BOT <Village Name> SCREENSHOT - send a screenshot of <Village Name>", $x, $y, -1, -1, $SS_LEFT)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
