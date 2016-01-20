; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: paspiz85 (201)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ Messaging Tab
;~ -------------------------------------------------------------
$tabMessaging = GUICtrlCreateTabItem(GetTranslated(16,1, "Messaging"))
	Local $x = 30, $y = 150
	$grpGlobalChat = GUICtrlCreateGroup(GetTranslated(16,2, "Global chat messages"), $x - 20, $y - 20, 450, 180)
		$chkGlobalChatEnable = GUICtrlCreateCheckbox(GetTranslated(16,3, "Enable messages in Global chat"), $x - 5, $y - 5, -1, -1)
			GUICtrlSetOnEvent(-1, "chkGlobalChatEnable")
		$txtGlobalChatMessages = GUICtrlCreateEdit("", $x - 5, $y + 20, 420, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetData(-1, StringFormat(GetTranslated(16,4, "hello\r\nhi")))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 190
	$grpClanChat = GUICtrlCreateGroup(GetTranslated(16,5, "Clan chat messages"), $x - 20, $y - 20, 450, 180)
		$chkClanChatEnable = GUICtrlCreateCheckbox(GetTranslated(16,6, "Enable messages in Global chat"), $x - 5, $y - 5, -1, -1)
			GUICtrlSetOnEvent(-1, "chkClanChatEnable")
		$txtClanChatMessages = GUICtrlCreateEdit("", $x - 5, $y + 20, 420, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetData(-1, StringFormat(GetTranslated(16,7, "hello\r\nhi")))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
