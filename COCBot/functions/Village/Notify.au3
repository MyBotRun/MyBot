; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This function will notify events and allow remote control of your bot on your mobile phone
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Full revamp of Notify by IceCube (2016-09)
; Modified ......: IceCube (2016-12) v1.5.1, CodeSLinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global Const $g_sCurlPath = $g_sLibPath & "\curl\curl.exe" ; Curl used on PushBullet
Global $g_bNotifyForced = False
Global $g_sTGChatID = ""
Global $g_bPBRequestScreenshot = False
Global $g_bPBRequestScreenshotHD = False
Global $g_bPBRequestBuilderInfo = False
Global $g_bPBRequestShieldInfo = False
Global $g_bTGRequestScreenshot = False
Global $g_bTGRequestScreenshotHD = False
Global $g_bTGRequestBuilderInfo = False
Global $g_bTGRequestShieldInfo = False
Global $g_iTGLastRemote = 0
Global $g_sTGLast_UID = ""
Global $g_sTGLastMessage = ""
Global $g_sAttackFile = ""

;GUI --------------------------------------------------------------------------------------------------
Func NotifyRemoteControl()
	If $g_bNotifyRemoteEnable = True Then NotifyRemoteControlProc(0)
EndFunc   ;==>NotifyRemoteControl

Func NotifyReport()
	If $g_bNotifyAlertVillageReport = True Then
		NotifylPushBulletMessage($g_sNotifyOrigin & ":" & "\n" & " [" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldCurrent) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirCurrent) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($iDarkCurrent) & "  [" & GetTranslated(620,112, "T") & "]: " & _NumberFormat($iTrophyCurrent) & " [" & GetTranslated(620,105, "No. of Free Builders") & "]: " & _NumberFormat($iFreeBuilderCount))
	EndIf
	If $g_bNotifyAlertLastAttack = True Then
		If Not ($g_iStatsLastAttack[$eLootGold] = "" And $g_iStatsLastAttack[$eLootElixir] = "") Then NotifylPushBulletMessage($g_sNotifyOrigin & " | Last Gain :" & "\n" & " [" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & "  [" & GetTranslated(620,112, "T") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootTrophy]))
	EndIf
	If _Sleep($iDelayReportPushBullet1) Then Return
	checkMainScreen(False)
EndFunc   ;==>NotifyReport

Func _DeletePush()
		NotifyDeletePushBullet()
		SetLog("Delete all previous PushBullet messages...", $COLOR_BLUE)
EndFunc   ;==>_DeletePush

Func PushMsg($Message, $Source = "")
		NotifyPushMessageToBoth($Message, $Source)
EndFunc   ;==>PushMsg

Func _DeleteOldPushes()
		NotifyDeleteOldPushesFromPushBullet()
EndFunc   ;==>_DeleteOldPushes
;GUI --------------------------------------------------------------------------------------------------

;MISC --------------------------------------------------------------------------------------------------
Func _GetDateFromUnix($nPosix)
	Local $nYear = 1970, $nMon = 1, $nDay = 1, $nHour = 00, $nMin = 00, $nSec = 00, $aNumDays = StringSplit("31,28,31,30,31,30,31,31,30,31,30,31", ",")
	While 1
		If (Mod($nYear + 1, 400) = 0) Or (Mod($nYear + 1, 4) = 0 And Mod($nYear + 1, 100) <> 0) Then; is leap year
			If $nPosix < 31536000 + 86400 Then ExitLoop
			$nPosix -= 31536000 + 86400
			$nYear += 1
		Else
			If $nPosix < 31536000 Then ExitLoop
			$nPosix -= 31536000
			$nYear += 1
		EndIf
	WEnd
	While $nPosix > 86400
		$nPosix -= 86400
		$nDay += 1
	WEnd
	While $nPosix > 3600
		$nPosix -= 3600
		$nHour += 1
	WEnd
	While $nPosix > 60
		$nPosix -= 60
		$nMin += 1
	WEnd
	$nSec = $nPosix
	For $i = 1 To 12
		If $nDay < $aNumDays[$i] Then ExitLoop
		$nDay -= $aNumDays[$i]
		$nMon += 1
	Next
	Return $nYear & "-" & $nMon & "-" & $nDay & " " & $nHour & ":" & $nMin & ":" & StringFormat("%02i", $nSec)
EndFunc   ;==>_GetDateFromUnix

;Execute Notify Pending Actions
Func NotifyPendingActions()
		If ($g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "") And ($g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "") Then Return

		NotifyRemoteControl()

		If $g_bPBRequestScreenshot = True Or $g_bTGRequestScreenshot = True Then
			$g_bNotifyForced = True
			PushMsg("RequestScreenshot")
		EndIf
		If $g_bPBRequestBuilderInfo = True Or $g_bTGRequestBuilderInfo = True Then
			$g_bNotifyForced = True
			PushMsg("BuilderInfo")
		EndIf
		If $g_bPBRequestShieldInfo = True Or $g_bTGRequestShieldInfo = True Then
			$g_bNotifyForced = True
			PushMsg("ShieldInfo")
		EndIf
		PushMsg("BuilderIdle")
EndFunc   ;==>NotifyPendingActions
;MISC --------------------------------------------------------------------------------------------------


; PushBullet ---------------------------------
Func PushBulletRemoteControl()
	If ($g_bNotifyPBEnable = True) And $g_bNotifyRemoteEnable = True Then NotifyRemoteControlProc(1)
EndFunc   ;==>PushBulletRemoteControl

Func PushBulletDeleteOldPushes()
	If $g_bNotifyPBEnable = True And $g_bNotifyDeletePushesOlderThan = True Then _DeleteOldPushes() ; check every 30 min if must delete old pushbullet messages, increase delay time for anti ban pushbullet
EndFunc   ;==>PushBulletDeleteOldPushes

Func NotifylPushBulletMessage($pMessage = "")
    If ($g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "") And ($g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "") Then Return

 	If $g_bNotifyForced = False Then
		If $g_bNotifyScheduleWeekDaysEnable = True Then
			If $g_abNotifyScheduleWeekDays[@WDAY - 1] = True Then
				If $g_bNotifyScheduleHoursEnable = True Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If $g_abNotifyScheduleHours[$hour[0]] = False Then
						SetLog("Notify not planned for this hour! Notification skipped", $COLOR_ORANGE)
						SetLog($pMessage, $COLOR_ORANGE)
						Return ; exit func if no planned
					EndIf
				EndIf
			Else
				;SetLog("Notify not planned to: " & _DateDayOfWeek(@WDAY), $COLOR_ORANGE)
				;SetLog($pMessage, $COLOR_ORANGE)
				Return ; exit func if not planned
			EndIf
		Else
			If $g_bNotifyScheduleHoursEnable = True Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If $g_abNotifyScheduleHours[$hour[0]] = False Then
					SetLog("Notify not planned for this hour! Notification skipped", $COLOR_ORANGE)
					SetLog($pMessage, $COLOR_ORANGE)
					Return ; exit func if no planned
				EndIf
			EndIf
		EndIf
	EndIf

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable = True And $g_sNotifyPBToken <> "" Then
		$g_bNotifyForced = False

		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		;$access_token = $g_sNotifyPBToken
		$oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
		$oHTTP.SetCredentials($g_sNotifyPBToken, "", 0)
		$oHTTP.Send()
		Local $Result = $oHTTP.ResponseText
		Local $device_iden = _StringBetween($Result, 'iden":"', '"')
		Local $device_name = _StringBetween($Result, 'nickname":"', '"')
		Local $device = ""
		Local $pDevice = 1
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		$oHTTP.SetCredentials($g_sNotifyPBToken, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable = True And $g_sNotifyTGToken <> ""  Then

		 Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		 $oHTTP.Open("Get", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/getupdates" , False)
		 $oHTTP.Send()
		 Local $Result = $oHTTP.ResponseText
		 Local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
		 $g_sTGChatID = _Arraypop($chat_id)
		 $oHTTP.Open("Post", "https://api.telegram.org/bot" & $g_sNotifyTGToken &"/sendmessage", False)
		 $oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")
	     Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		 Local $Time = @HOUR & '.' & @MIN
		 Local $TGPushMsg = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $g_sTGChatID & '}}'
		 $oHTTP.Send($TGPushMsg)
	EndIf
	;Telegram ---------------------------------------------------------------------------------

EndFunc   ;==> NotifylPushBulletMessage

Func NotifyPushToPushBullet($pMessage)
	If ($g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "") And ($g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable = True And $g_sNotifyPBToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		Local $access_token = $g_sNotifyPBToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf
	;PushBullet ---------------------------------------------------------------------------------
EndFunc   ;==> NotifyPushToPushBullet

Func NotifyDeletePushBullet()
	If $g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("DELETE", "https://api.pushbullet.com/v2/pushes", False)
	Local $access_token = $g_sNotifyPBToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
EndFunc   ;==> NotifyDeletePushBullet

Func NotifyDeleteMessageFromPushBullet($iden)
	If $g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes/" & $iden, False)
	Local $access_token = $g_sNotifyPBToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$iden = ""
EndFunc   ;==> NotifyDeleteMessageFromPushBullet

Func NotifyDeleteOldPushesFromPushBullet()
	If $g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "" Or $g_bNotifyDeletePushesOlderThan = False Then Return
	;Local UTC time
	Local $tLocal = _Date_Time_GetLocalTime()
	Local $tSystem = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($tLocal))
	Local $timeUTC = _Date_Time_SystemTimeToDateTimeStr($tSystem, 1)
	Local $timestamplimit = 0
	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $timestamplimit, False)
	Local $access_token = $g_sNotifyPBToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	Local $Result = $oHTTP.ResponseText
	Local $findstr = StringRegExp($Result, ',"created":')
	Local $msgdeleted = 0
	If $findstr = 1 Then
		Local $body = _StringBetween($Result, '"body":"', '"', "", False)
		Local $iden = _StringBetween($Result, '"iden":"', '"', "", False)
		Local $created = _StringBetween($Result, '"created":', ',', "", False)
		If IsArray($body) And IsArray($iden) And IsArray($created) Then
			For $x = 0 To UBound($created) - 1
				If $iden <> "" And $created <> "" Then
					Local $hdif = _DateDiff('h', _GetDateFromUnix($created[$x]), $timeUTC)
					If $hdif >= $g_iNotifyDeletePushesOlderThanHours Then
						$msgdeleted += 1
						NotifyDeleteMessageFromPushBullet($iden[$x])
					EndIf
				EndIf
				$body[$x] = ""
				$iden[$x] = ""
			Next
		EndIf
	EndIf
	If $msgdeleted > 0 Then
		SetLog("Notify PushBullet: removed " & $msgdeleted & " messages older than " & $g_iNotifyDeletePushesOlderThanHours & " h ", $COLOR_GREEN)
	EndIf
EndFunc   ;==> NotifyDeleteOldPushesFromPushBullet

Func NotifyPushFileToPushBullet($File, $Folder, $FileType, $body)
	If ($g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "") And ($g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable = True And $g_sNotifyPBToken <> "" Then
		If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then
			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
			Local $access_token = $g_sNotifyPBToken
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
			$oHTTP.Send($pPush)
			Local $Result = $oHTTP.ResponseText
			Local $upload_url = _StringBetween($Result, 'upload_url":"', '"')
			Local $awsaccesskeyid = _StringBetween($Result, 'awsaccesskeyid":"', '"')
			Local $acl = _StringBetween($Result, 'acl":"', '"')
			Local $key = _StringBetween($Result, 'key":"', '"')
			Local $signature = _StringBetween($Result, 'signature":"', '"')
			Local $policy = _StringBetween($Result, 'policy":"', '"')
			Local $file_url = _StringBetween($Result, 'file_url":"', '"')
			If IsArray($upload_url) And IsArray($awsaccesskeyid) And IsArray($acl) And IsArray($key) And IsArray($signature) And IsArray($policy) Then
				$Result = RunWait($g_sCurlPath & " -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & $g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)
				$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
				$oHTTP.SetCredentials($access_token, "", 0)
				$oHTTP.SetRequestHeader("Content-Type", "application/json")
				Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $file_url[0] & '", "body": "' & $body & '"}'
				$oHTTP.Send($pPush)
			Else
				SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_RED)
				NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,170, "Unable to Upload File") & "\n" & GetTranslated(620,171, "Occured an error type") & " 1 " & GetTranslated(620,144, "uploading file to PushBullet server") & "...")
			EndIf
		Else
			SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_RED)
			NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,170, "Unable to Upload File") & "\n" & GetTranslated(620,171, "Occured an error type") & " 2 " & GetTranslated(620,144, "uploading file to PushBullet server") & "...")
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

EndFunc   ;==> NotifyPushFileToPushBullet
; PushBullet ---------------------------------

; Telegram ---------------------------------
Func NotifyPushToTelegram($pMessage)
	If ($g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "") And ($g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "") Then Return

	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable = True And $g_sNotifyTGToken <> ""  Then

	   Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	   Local $url = "https://api.telegram.org/bot"
	   $oHTTP.Open("Post",  $url & $g_sNotifyTGToken & "/sendMessage", False)
	   $oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

	   Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
	   Local $Time = @HOUR & '.' & @MIN
	   Local $TGPushMsg = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $g_sTGChatID & '}}'
	   $oHTTP.Send($TGPushMsg)
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==> NotifyPushToTelegram

Func NotifyPushFileToTelegram($File, $Folder, $FileType, $body)
	If ($g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "") And ($g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "") Then Return

	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable = True And $g_sNotifyTGToken <> ""  Then
		If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then

			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/sendPhoto"
			Local $Result = RunWait($g_sCurlPath & " -i -X POST " & $telegram_url & ' -F chat_id="' & $g_sTGChatID &' " -F photo=@"' & $g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File  & '"', "", @SW_HIDE)
			$oHTTP.Open("Post", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/sendPhoto", False)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP.Send($pPush)
		Else
			SetLog("Notify Telegram: Unable to send file " & $File, $COLOR_RED)
			NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,170,"Unable to Upload File") & "\n" & GetTranslated(620,146,"Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==> NotifyPushFileToTelegram

Func NotifyGetLastMessageFromTelegram()
    If $g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Get", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/getupdates" , False)
	$oHTTP.Send()
	Local $Result = $oHTTP.ResponseText

	Local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
	$g_sTGChatID = _Arraypop($chat_id)

	Local $uid = _StringBetween($Result, 'update_id":', '"message"')             ;take update id
	$g_sTGLast_UID = StringTrimRight(_Arraypop($uid), 2)

	Local $findstr2 = StringRegExp(StringUpper($Result), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result, 'text":"' ,'"}}' )           ;take message
		Local $g_sTGLastMessage = _Arraypop($rmessage)								 ;take last message
	EndIf


	$oHTTP.Open("Get", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/getupdates?offset=" & $g_sTGLast_UID  , False)
	$oHTTP.Send()
	Local $Result2 = $oHTTP.ResponseText

	Local $findstr2 = StringRegExp(StringUpper($Result2), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result2, 'text":"' ,'"}}' )           ;take message
		Local $g_sTGLastMessage = _Arraypop($rmessage)		;take last message
		If $g_sTGLastMessage = "" Then
			Local $rmessage = _StringBetween($Result2, 'text":"' ,'","entities"' )           ;take message
			Local $g_sTGLastMessage = _Arraypop($rmessage)		;take last message
		EndIf

		return $g_sTGLastMessage
	EndIf

EndFunc 	;==> NotifyGetLastMessageFromTelegram

Func NotifyActivateKeyboardOnTelegram($TGMsg)

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	Local $url = "https://api.telegram.org/bot"
	$oHTTP.Open("Post",  $url & $g_sNotifyTGToken & "/sendMessage", False)
	$oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

	Local $TGPushMsg = '{"text": "' & $TGMsg & '", "chat_id":' & $g_sTGChatID &', "reply_markup": {"keyboard": [["' & _
	'\ud83d\udcf7 ' & GetTranslated(620,801,"Screenshot") & '","' & _
	'\ud83d\udd28 ' & GetTranslated(620,802,"Builder") & '","' & _
	'\ud83d\udd30 ' & GetTranslated(620,803,"Shield") & '"],["' & _
	'\ud83d\udcc8 ' & GetTranslated(620,804,"Stats") & '","' & _
	'\ud83d\udcaa ' & GetTranslated(620,805,"Troops") & '","' & _
	'\u2753 ' & GetTranslated(620,806,"Help") & '"],["' & _
	'\u25aa ' & GetTranslated(620,807,"Stop") & '","' & _
	'\ud83d\udd00 ' & GetTranslated(620,808,"Pause") & '","' & _
	'\u25b6 ' & GetTranslated(620,809,"Resume") & '","' & _
	'\ud83d\udd01 ' & GetTranslated(620,810,"Restart") & '"],["' & _
	'\ud83d\udccb ' & GetTranslated(620,811,"Log") & '","' & _
	'\ud83c\udf04 ' & GetTranslated(620,812,"Lastraid") & '","' & _
	'\ud83d\udcc4 ' & GetTranslated(620,813,"LastRaidTxt") & '"],["' & _
	'\u2705 ' & GetTranslated(620,814,"Attack On") & '","' & _
	'\u274C ' & GetTranslated(620,815,"Attack Off") & '"],["' & _
	'\ud83d\udca4 ' & GetTranslated(620,816,"Hibernate") & '","' & _
	'\u26a1 ' & GetTranslated(620,817,"Shut down") & '","' & _
	'\ud83d\udd06 ' & GetTranslated(620,818,"Standby") & '"]],"one_time_keyboard": false,"resize_keyboard":true}}'
	$oHTTP.Send($TGPushMsg)

	$g_iTGLastRemote = $g_sTGLast_UID

EndFunc   ;==> NotifyActivateKeyboardOnTelegram
; Telegram ---------------------------------


; Both ---------------------------------
Func NotifyRemoteControlProc($OnlyPB)
    Static $pushLastModified = 0

	If ($g_bNotifyPBEnable = False And $g_bNotifyTGEnable = False) Or $g_bNotifyRemoteEnable = False Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $OnlyPB = 0 And $g_bNotifyPBEnable = True And $g_sNotifyPBToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		Local $pushbulletApiUrl
		If $pushLastModified = 0 Then
			$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&limit=1" ; if this is the first time looking for pushes, get the last one
		Else
			$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $pushLastModified ; get the one pushed after the last one received
		EndIf
		$oHTTP.Open("Get", $pushbulletApiUrl, False)
		Local $access_token = $g_sNotifyPBToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		$oHTTP.Send()
		Local $Result = $oHTTP.ResponseText

		Local $modified = _StringBetween($Result, '"modified":', ',', "", False)
		If UBound($modified) > 0 Then
			$pushLastModified = Number($modified[0]) ; modified date of the newest push that we received
			$pushLastModified -= 120 ; back 120 seconds to avoid loss of messages
		EndIf

		Local $findstr = StringRegExp(StringUpper($Result), '"BODY":"BOT')
		If $findstr = 1 Then
			Local $body = _StringBetween($Result, '"body":"', '"', "", False)
			Local $iden = _StringBetween($Result, '"iden":"', '"', "", False)
			For $x = UBound($body) - 1 To 0 Step -1
				If $body <> "" Or $iden <> "" Then
					$body[$x] = StringUpper(StringStripWS($body[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES))
					$iden[$x] = StringStripWS($iden[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)

					$g_bNotifyForced = True

					Switch $body[$x]
						Case GetTranslated(620,1, "BOT") & " " & GetTranslated(620,4, "HELP")
							Local $txtHelp = "PushBullet " & GetTranslated(620,2,"Help") & " " & GetTranslated(620,3, " - You can remotely control your bot sending COMMANDS from the following list:")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,4, -1) & GetTranslated(620,5, " - send this help message")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,7,"DELETE") & GetTranslated(620,8, " - delete all your previous PushBullet messages")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,9,"RESTART") & GetTranslated(620,10, " - restart the Emulator and bot named") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,11,"STOP") & GetTranslated(620,12, " - stop the bot named") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,13,"PAUSE") & GetTranslated(620,14, " - pause the bot named") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,15,"RESUME") & GetTranslated(620,16, " - resume the bot named") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,17,"STATS") & GetTranslated(620,18, " - send Village Statistics of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,19,"LOG") & GetTranslated(620,20, " - send the current log file of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,21,"LASTRAID") & GetTranslated(620,22, " - send the last raid loot screenshot of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,23,"LASTRAIDTXT") & GetTranslated(620,24, " - send the last raid loot values of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,25,"SCREENSHOT") & GetTranslated(620,26, " - send a screenshot of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,27,"SCREENSHOTHD") & GetTranslated(620,28, " - send a screenshot in high resolution of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,29,"BUILDER") & GetTranslated(620,30, " - send a screenshot of builder status of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,31,"SHIELD") & GetTranslated(620,32, " - send a screenshot of shield status of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,33,"RESETSTATS") & GetTranslated(620,34, " - reset Village Statistics")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,35,"TROOPS") & GetTranslated(620,36, " - send Troops & Spells Stats")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,37,"HALTATTACKON") & GetTranslated(620,39, " - Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,40,"HALTATTACKOFF") & GetTranslated(620,42, " - Turn Off 'Halt Attack' in the 'Misc' Tab")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,43,"HIBERNATE") & GetTranslated(620,44, " - Hibernate host PC")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,46,"SHUTDOWN") & GetTranslated(620,48, " - Shut down host PC")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslated(620,50,"STANDBY") & GetTranslated(620,51, " - Standby host PC")
							$txtHelp &= '\n'
							$txtHelp &= '\n' & GetTranslated(620,98, "Examples:")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & $g_sNotifyOrigin & " " & GetTranslated(620,17,"STATS")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,29,"BUILDER")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & $g_sNotifyOrigin & " " & GetTranslated(620,27,"SCREENSHOTHD")
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,100, "Request for Help") & "\n" & $txtHelp)
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Help has been sent", $COLOR_GREEN)
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & GetTranslated(620,7,"DELETE")
							NotifyDeletePushBullet()
							SetLog("Notify PushBullet: Your request has been received.", $COLOR_GREEN)
						Case GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,9,"RESTART")
							NotifyDeleteMessageFromPushBullet($iden[$x])
							SetLog("Notify PushBullet: Your request has been received. Bot and Android Emulator restarting...", $COLOR_GREEN)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,165, "Request to Restart") & "...\n" & GetTranslated(620,132, "Your bot and Emulator are now restarting") & "...")
							SaveConfig()
							RestartBot()
						Case GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,11,"STOP")
							NotifyDeleteMessageFromPushBullet($iden[$x])
							SetLog("Notify PushBullet: Your request has been received. Bot is now stopped", $COLOR_GREEN)
							If $g_bRunState = True Then
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,124, "Request to Stop") & "..." & "\n" & GetTranslated(620,133, "Your bot is now stopping") & "...")
								btnStop()
							Else
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,124, "Request to Stop") & "..." & "\n" & GetTranslated(620,134, "Your bot is currently stopped, no action was taken"))
							EndIf
						Case GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,13,"PAUSE")
							If $g_bBotPaused = False And $g_bRunState = True Then
								If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
									SetLog("Notify PushBullet: Unable to pause during attack", $COLOR_RED)
									NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,166, "Request to Pause") & "\n" & GetTranslated(620,164, "Unable to pause during attack, try again later."))
								ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
									ReturnHome(False, False)
									$Is_SearchLimit = True
									$Is_ClientSyncError = False
									UpdateStats()
									$g_bRestart = True
									TogglePauseImpl("Push")
								Else
									TogglePauseImpl("Push")
								EndIf
							Else
								SetLog("Notify PushBullet: Your bot is currently paused, no action was taken", $COLOR_GREEN)
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,166, "Request to Pause") & "\n" & GetTranslated(620,150, "Your bot is currently paused, no action was taken"))
							EndIf
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,15,"RESUME")
							If $g_bBotPaused = True And $g_bRunState = True Then
								TogglePauseImpl("Push")
							Else
								SetLog("Notify PushBullet: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,167, "Request to Resume") & "\n" & GetTranslated(620,130, "Your bot is currently resumed, no action was taken"))
							EndIf
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,17,"STATS")
							SetLog("Notify PushBullet: Your request has been received. Statistics sent", $COLOR_GREEN)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,108, "Stats Village Report") & "\n" & GetTranslated(620,148, "At Start") & "\n[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($g_iStatsStartedWith[$eLootGold]) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($g_iStatsStartedWith[$eLootElixir]) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($g_iStatsStartedWith[$eLootDarkElixir]) & " [" & GetTranslated(620,112, "T") & "]: " & $g_iStatsStartedWith[$eLootTrophy] & "\n\n" & GetTranslated(620,114, "Now (Current Resources)") &"\n[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldCurrent) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirCurrent) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($iDarkCurrent) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyCurrent & " [" & GetTranslated(620,121, "GEM") & "]: " & $iGemAmount & "\n \n [" & GetTranslated(620,105, "No. of Free Builders") & "]: " & $iFreeBuilderCount & "\n [" & GetTranslated(620,117, "No. of Wall Up") & "]: " & GetTranslated(620,109, "G") & ": " & $iNbrOfWallsUppedGold & "/ " & GetTranslated(620,110, "E") & ": " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(620,116, "Attacked") & ": " & $iAttackedCount & "\n" & GetTranslated(620,115, "Skipped") & ": " & $iSkippedVillageCount)
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,19,"LOG")
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Log is now sent", $COLOR_GREEN)
							NotifyPushFileToPushBullet($g_sLogFileName, GetTranslated(620,101, "logs"), "text/plain; charset=utf-8", $g_sNotifyOrigin & " | " & GetTranslated(620,102, "Current Log") & " \n")
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,21,"LASTRAID")
							If $g_sAttackFile <> "" Then
								SetLog("Notify PushBullet: Push Last Raid Snapshot...", $COLOR_GREEN)
								NotifyPushFileToPushBullet($g_sAttackFile, GetTranslated(620,120, "Loots"), "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslated(620,118, "Last Raid") & " \n" & $g_sAttackFile)
							Else
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,131, "There is no last raid screenshot") & ".")
								SetLog("There is no last raid screenshot.")
								SetLog("Notify PushBullet: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,119, "Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslated(620,112, "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
							EndIf
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,23,"LASTRAIDTXT")
							SetLog("Notify PushBullet: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,119, "Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslated(620,112, "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,25,"SCREENSHOT")
							SetLog("Notify PushBullet: ScreenShot request received", $COLOR_GREEN)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,147,"Chief, your request for Screenshot will be processed ASAP"))
							$g_bPBRequestScreenshot = True
							$g_bNotifyForced = False
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,27,"SCREENSHOTHD")
							SetLog("Notify PushBullet: ScreenShot HD request received", $COLOR_GREEN)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,147,"Chief, your request for Screenshot will be processed ASAP"))
							$g_bPBRequestScreenshot = True
							$g_bPBRequestScreenshotHD = True
							$g_bNotifyForced = False
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,29,"BUILDER")
							SetLog("Notify PushBullet: Builder Status request received", $COLOR_GREEN)
							$g_bPBRequestBuilderInfo = True
							NotifyDeleteMessageFromPushBullet($iden[$x])
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,137,"Chief, your request for Builder Info will be processed ASAP"))
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,31,"SHIELD")
							SetLog("Notify PushBullet: Shield Status request received", $COLOR_GREEN)
							$g_bPBRequestShieldInfo = True
							$g_bNotifyForced = False
							NotifyDeleteMessageFromPushBullet($iden[$x])
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,139,"Chief, your request for Shield Info will be processed ASAP"))
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,33,"RESETSTATS")
							btnResetStats()
							SetLog("Notify PushBullet: Your request has been received. Statistics resetted", $COLOR_GREEN)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,135,"Statistics resetted."))
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,35,"TROOPS")
							SetLog("Notify PushBullet: Your request has been received. Sending Troop/Spell Stats...", $COLOR_GREEN)
							Local $txtTroopStats = " | " & GetTranslated(620,136,"Troops/Spells set to Train") & ":\n" & _
							  "Barbs:" & $g_aiArmyCompTroops[$eTroopBarbarian] & " Arch:" & $g_aiArmyCompTroops[$eTroopArcher] & " Gobl:" & $g_aiArmyCompTroops[$eTroopGoblin] & "\n" & _
							  "Giant:" & $g_aiArmyCompTroops[$eTroopGiant] & " WallB:" & $g_aiArmyCompTroops[$eTroopWallBreaker] & " Wiza:" & $g_aiArmyCompTroops[$eTroopWizard] & "\n" & _
							  "Balloon:" & $g_aiArmyCompTroops[$eTroopBalloon] & " Heal:" & $g_aiArmyCompTroops[$eTroopHealer] & " Dragon:" & $g_aiArmyCompTroops[$eTroopDragon] & " Pekka:" & $g_aiArmyCompTroops[$eTroopPekka] & "\n" & _
							  "Mini:" & $g_aiArmyCompTroops[$eTroopMinion] & " Hogs:" & $g_aiArmyCompTroops[$eTroopHogRider] & " Valks:" & $g_aiArmyCompTroops[$eTroopValkyrie] & "\n" & _
							  "Golem:" & $g_aiArmyCompTroops[$eTroopGolem] & " Witch:" & $g_aiArmyCompTroops[$eTroopWitch] & " Lava:" & $g_aiArmyCompTroops[$eTroopLavaHound] & "\n" & _
							  "LSpell:" & $g_aiArmyCompSpells[$eSpellLightning] & " HeSpell:" & $g_aiArmyCompSpells[$eSpellHeal] & " RSpell:" & $g_aiArmyCompSpells[$eSpellRage] & " JSpell:" & $g_aiArmyCompSpells[$eSpellJump] & "\n" & _
							  "FSpell:" & $g_aiArmyCompSpells[$eSpellFreeze] & " PSpell:" & $g_aiArmyCompSpells[$eSpellPoison] & " ESpell:" & $g_aiArmyCompSpells[$eSpellEarthquake] & " HaSpell:" & $g_aiArmyCompSpells[$eSpellHaste] & "\n"
							$txtTroopStats &= "\n" & GetTranslated(620,168,"Current Trained Troops & Spells") & ":"
							$txtTroopStats &= "\n\n" & GetTranslated(620,169,"Current Army Camp") & ": " & $CurCamp & "/" & $TotalCamp
							NotifyPushToPushBullet($g_sNotifyOrigin & $txtTroopStats)
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,37,"HALTATTACKON")
							GUICtrlSetState($g_hChkBotStop, $GUI_CHECKED)
							btnStop()
							$g_bChkBotStop = True ; set halt attack variable
							$g_iCmbBotCond = 18; set stay online
							btnStart()
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,40,"HALTATTACKOFF")
							GUICtrlSetState($g_hChkBotStop, $GUI_UNCHECKED)
							btnStop()
							btnStart()
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,43,"HIBERNATE")
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Hibernate PC", $COLOR_GREEN)
							NotifyPushToPushBullet(GetTranslated(620,45,"PC Hibernate sequence initiated"))
							Shutdown(64)
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,46,"SHUTDOWN")
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Shutdown PC", $COLOR_GREEN)
							NotifyPushToPushBullet(GetTranslated(620,49,"PC Shutdown sequence initiated"))
							Shutdown(5)
						Case GetTranslated(620,1, -1) & " " &  StringUpper($g_sNotifyOrigin) & " " & GetTranslated(620,50,"STANDBY")
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Standby PC", $COLOR_GREEN)
							NotifyPushToPushBullet(GetTranslated(620,52,"PC Standby sequence initiated"))
							Shutdown(32)
						Case Else
								Local $lenstr = StringLen(GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & "")
								Local $teststr = StringLeft($body[$x], $lenstr)
								If $teststr = (GetTranslated(620,1, -1) & " " & StringUpper($g_sNotifyOrigin) & " " & "") Then
									SetLog("Notify PushBullet: received command syntax wrong, command ignored.", $COLOR_RED)
									NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,97, "Command not recognized") & "\n" & GetTranslated(620,99, "Please push BOT HELP to obtain a complete command list."))
									NotifyDeleteMessageFromPushBullet($iden[$x])
								EndIf
					EndSwitch
					$body[$x] = ""
					$iden[$x] = ""

					$g_bNotifyForced = False
				EndIf
			Next
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------


	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable = True And $g_sNotifyTGToken <> ""  Then
		$g_sTGLastMessage = NotifyGetLastMessageFromTelegram()
		Local $TGActionMSG = StringUpper(StringStripWS($g_sTGLastMessage, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message
		If ($TGActionMSG = "/START" Or $TGActionMSG = "KEYB") And $g_iTGLastRemote <> $g_sTGLast_UID Then
			$g_iTGLastRemote = $g_sTGLast_UID
			NotifyActivateKeyboardOnTelegram($g_sBotTitle & " | Notify " & $g_sNotifyVersion)
		Else
			If $g_iTGLastRemote <> $g_sTGLast_UID Then
				$g_iTGLastRemote = $g_sTGLast_UID
				Switch $TGActionMSG
					Case GetTranslated(620,4,"HELP"), '\U2753 ' & GetTranslated(620,4,"HELP")
						Local $txtHelp =  "Telegram " & GetTranslated(620,2,"Help") & " " & GetTranslated(620,3, " - You can remotely control your bot sending COMMANDS from the following list:")
						$txtHelp &= '\n' & GetTranslated(620,4, -1) & GetTranslated(620,5, " - send this help message")
						$txtHelp &= '\n' & GetTranslated(620,9,"RESTART") & GetTranslated(620,10, " - restart the Emulator and bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,11,"STOP") & GetTranslated(620,12, " - stop the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,13,"PAUSE") & GetTranslated(620,14, " - pause the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,15,"RESUME") & GetTranslated(620,16, " - resume the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,17,"STATS") & GetTranslated(620,18, " - send Village Statistics of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,19,"LOG") & GetTranslated(620,20, " - send the current log file of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,21,"LASTRAID") & GetTranslated(620,22, " - send the last raid loot screenshot of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,23,"LASTRAIDTXT") & GetTranslated(620,24, " - send the last raid loot values of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,25,"SCREENSHOT") & GetTranslated(620,26, " - send a screenshot of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,27,"SCREENSHOTHD") & GetTranslated(620,28, " - send a screenshot in high resolution of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,29,"BUILDER") & GetTranslated(620,30, " - send a screenshot of builder status of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,31,"SHIELD") & GetTranslated(620,32, " - send a screenshot of shield status of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= "\n" & GetTranslated(620,33,"RESETSTATS") & GetTranslated(620,34, " - reset Village Statistics")
						$txtHelp &= "\n" & GetTranslated(620,35,"TROOPS") & GetTranslated(620,36, " - send Troops & Spells Stats")
						$txtHelp &= "\n" & GetTranslated(620,37,"HALTATTACKON") & GetTranslated(620,39, " - Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
						$txtHelp &= "\n" & GetTranslated(620,40,"HALTATTACKOFF") & GetTranslated(620,42, " - Turn Off 'Halt Attack' in the 'Misc' Tab")
						$txtHelp &= "\n" & GetTranslated(620,43,"HIBERNATE") & GetTranslated(620,44, " - Hibernate host PC")
						$txtHelp &= "\n" & GetTranslated(620,46,"SHUTDOWN") & GetTranslated(620,48, " - Shut down host PC")
						$txtHelp &= "\n" & GetTranslated(620,50,"STANDBY") & GetTranslated(620,51, " - Standby host PC")

						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,100,"Request for Help") & "\n" & $txtHelp)
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Help has been sent", $COLOR_GREEN)
					Case GetTranslated(620,9,"RESTART"), '\UD83D\UDD01 ' & GetTranslated(620,9,"RESTART")
						SetLog("Notify Telegram: Your request has been received.", $COLOR_GREEN)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,165,"Request to Restart") & "...\n" & GetTranslated(620,143,"Your bot and Emulator are now restarting..."))
						SaveConfig()
						RestartBot()
					Case GetTranslated(620,11,"STOP"), '\U25AA ' & GetTranslated(620,11,"Stop")
						SetLog("Notify Telegram: Your request has been received. Bot is now stopped", $COLOR_GREEN)
						If $g_bRunState = True Then
							 NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,125,"Request to Stop...") & "\n" & GetTranslated(620,126,"Your bot is now stopping..."))
							 btnStop()
						Else
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,125,"Request to Stop...") & "\n" & GetTranslated(620,127,"Your bot is currently stopped, no action was taken"))
						EndIf
					Case GetTranslated(620,13,"PAUSE"), '\UD83D\UDD00 ' & GetTranslated(620,13,"PAUSE")
						If $g_bBotPaused = False And $g_bRunState = True Then
							If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
								SetLog("Notify Telegram: Unable to pause during attack", $COLOR_RED)
								NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,166,"Request to Pause") & "\n" & GetTranslated(620,138,"Unable to pause during attack, try again later."))
							ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
								ReturnHome(False, False)
								$Is_SearchLimit = True
								$Is_ClientSyncError = True
								;UpdateStats()
								$g_bRestart = True
								TogglePauseImpl("Push")
								Return True
							Else
								TogglePauseImpl("Push")
							EndIf
						Else
							SetLog("Notify Telegram: Your bot is currently paused, no action was taken", $COLOR_GREEN)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,166,"Request to Pause") & "\n" & GetTranslated(620,150,"Your bot is currently paused, no action was taken"))
						EndIf
					Case GetTranslated(620,15,"RESUME"), '\U25B6 ' & GetTranslated(620,15,"RESUME")
						If $g_bBotPaused = True And $g_bRunState = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Notify Telegram: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,167,"Request to Resume") & "\n" & GetTranslated(620,151,"Your bot is currently resumed, no action was taken"))
						EndIf
					Case GetTranslated(620,17,"STATS"), '\UD83D\UDCC8 ' & GetTranslated(620,17,"STATS")
						SetLog("Notify Telegram: Your request has been received. Statistics sent", $COLOR_GREEN)
						Local $GoldGainPerHour = "0 / h"
						Local $ElixirGainPerHour = "0 / h"
						Local $DarkGainPerHour = "0 / h"
						Local $TrophyGainPerHour = "0 / h"
						If $g_iFirstAttack = 2 Then
							$GoldGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootGold] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h"
							$ElixirGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h"
						EndIf
						If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
							$DarkGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootDarkElixir] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h"
						EndIf
						$TrophyGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootTrophy] / (Int(TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h"
						Local $txtStats = " | " & GetTranslated(620,108,"Stats Village Report") & "\n" & GetTranslated(620,148,"At Start") & "\n[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($g_iStatsStartedWith[$eLootGold]) & " [" & GetTranslated(620,110, "E") & "]: "
							  $txtStats &= _NumberFormat($g_iStatsStartedWith[$eLootElixir]) & " [D]: " & _NumberFormat($g_iStatsStartedWith[$eLootDarkElixir]) & " [" & GetTranslated(620,112, "T") & "]: " & $g_iStatsStartedWith[$eLootTrophy]
							  $txtStats &= "\n\n" & GetTranslated(620,114,"Now (Current Resources)") & "\n[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldCurrent) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirCurrent)
							  $txtStats &= " [D]: " & _NumberFormat($iDarkCurrent) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyCurrent & " [GEM]: " & $iGemAmount
							  $txtStats &= "\n\n" & GetTranslated(620,140,"Gain per Hour") & ":\n[" & GetTranslated(620,109, "G") & "]: " & $GoldGainPerHour & " [" & GetTranslated(620,110, "E") & "]: " & $ElixirGainPerHour
							  $txtStats &= "\n[D]: " & $DarkGainPerHour & " [" & GetTranslated(620,112, "T") & "]: " & $TrophyGainPerHour
							  $txtStats &= "\n\n" & GetTranslated(620,105,"No. of Free Builders") & ": " & $iFreeBuilderCount & "\n[" & GetTranslated(620,117,"No. of Wall Up") & "]: [" & GetTranslated(620,109, "G") & "]: "
							  $txtStats &= $iNbrOfWallsUppedGold & "/ [" & GetTranslated(620,110, "E") & "]: " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(620,116,"Attacked") & ": "
							  $txtStats &= $iAttackedCount & "\n" & GetTranslated(620,115,"Skipped") & ": " & $iSkippedVillageCount
						NotifyPushToTelegram($g_sNotifyOrigin & $txtStats)
					Case GetTranslated(620,19,"LOG"), '\UD83D\UDCCB ' & GetTranslated(620,19,"LOG")
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Log is now sent", $COLOR_GREEN)
						NotifyPushFileToTelegram($g_sLogFileName, "logs", "text\/plain; charset=utf-8", $g_sNotifyOrigin & " | Current Log " & "\n")
					Case GetTranslated(620,21,"LASTRAID"), '\UD83C\UDF04 ' & GetTranslated(620,21,"LASTRAID")
						 If $LootFileName <> "" Then
							NotifyPushFileToTelegram($LootFileName, GetTranslated(620,120, "Loots"), "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslated(620,152,"Last Raid") & "\n" & $LootFileName)
							SetLog("Notify Telegram: Push Last Raid Snapshot...", $COLOR_GREEN)
						Else
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,141,"There is no last raid screenshot."))
							SetLog("There is no last raid screenshot.")
							SetLog("Notify Telegram: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,142,"Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [D]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslated(620,112, "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
						EndIf
					Case GetTranslated(620,23,"LASTRAIDTXT"), '\UD83D\UDCC4 ' & GetTranslated(620,23,"LASTRAIDTXT")
						SetLog("Notify Telegram: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,142,"Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [D]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslated(620,112, "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
					Case GetTranslated(620,25,"SCREENSHOT")
						SetLog("Notify Telegram: ScreenShot request received", $COLOR_GREEN)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,147,"Chief, your request for Screenshot will be processed ASAP"))
						$g_bTGRequestScreenshot = True
					Case GetTranslated(620,27,"SCREENSHOTHD"), '\UD83D\UDCF7 ' & GetTranslated(620,25,"SCREENSHOT")
						SetLog("Notify Telegram: ScreenShot HD request received", $COLOR_GREEN)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,147,"Chief, your request for Screenshot will be processed ASAP"))
						$g_bTGRequestScreenshot = True
						$g_bTGRequestScreenshotHD = True
						$g_bNotifyForced = False
					Case GetTranslated(620,29,"BUILDER"), '\UD83D\UDD28 ' & GetTranslated(620,29,"BUILDER")
						SetLog("Notify Telegram: Builder Status request received", $COLOR_GREEN)
						$g_bTGRequestBuilderInfo = True
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,137,"Chief, your request for Builder Info will be processed ASAP"))
					Case GetTranslated(620,31,"SHIELD"), '\UD83D\UDD30 ' & GetTranslated(620,31,"SHIELD")
						SetLog("Notify Telegram: Shield Status request received", $COLOR_GREEN)
						$g_bTGRequestShieldInfo = True
						$g_bNotifyForced = False
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,139,"Chief, your request for Shield Info will be processed ASAP"))
					Case GetTranslated(620,33,"RESETSTATS")
						btnResetStats()
						SetLog("Notify Telegram: Your request has been received. Statistics resetted", $COLOR_GREEN)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,135,"Statistics resetted."))
					Case GetTranslated(620,35,"TROOPS"), '\UD83D\UDCAA ' & GetTranslated(620,35,"TROOPS")
						SetLog("Notify Telegram: Your request has been received. Sending Troop/Spell Stats...", $COLOR_GREEN)
						Local $txtTroopStats = " | " & GetTranslated(620,136,"Troops/Spells set to Train") & ":\n" & _
						   "Barbs:" & $g_aiArmyCompTroops[$eTroopBarbarian] & " Arch:" & $g_aiArmyCompTroops[$eTroopArcher] & " Gobl:" & $g_aiArmyCompTroops[$eTroopGoblin] & "\n" & _
						   "Giant:" & $g_aiArmyCompTroops[$eTroopGiant] & " WallB:" & $g_aiArmyCompTroops[$eTroopWallBreaker] & " Wiza:" & $g_aiArmyCompTroops[$eTroopWizard] & "\n" & _
						   "Balloon:" & $g_aiArmyCompTroops[$eTroopBalloon] & " Heal:" & $g_aiArmyCompTroops[$eTroopHealer] & " Dragon:" & $g_aiArmyCompTroops[$eTroopDragon] & " Pekka:" & $g_aiArmyCompTroops[$eTroopPekka] & "\n" & _
						   "Mini:" & $g_aiArmyCompTroops[$eTroopMinion] & " Hogs:" & $g_aiArmyCompTroops[$eTroopHogRider] & " Valks:" & $g_aiArmyCompTroops[$eTroopValkyrie] & "\n" & _
						   "Golem:" & $g_aiArmyCompTroops[$eTroopGolem] & " Witch:" & $g_aiArmyCompTroops[$eTroopWitch] & " Lava:" & $g_aiArmyCompTroops[$eTroopLavaHound] & "\n" & _
						   "LSpell:" & $g_aiArmyCompSpells[$eSpellLightning] & " HeSpell:" & $g_aiArmyCompSpells[$eSpellHeal] & " RSpell:" & $g_aiArmyCompSpells[$eSpellRage] & " JSpell:" & $g_aiArmyCompSpells[$eSpellJump] & "\n" & _
						   "FSpell:" & $g_aiArmyCompSpells[$eSpellFreeze] & " PSpell:" & $g_aiArmyCompSpells[$eSpellPoison] & " ESpell:" & $g_aiArmyCompSpells[$eSpellEarthquake] & " HaSpell:" & $g_aiArmyCompSpells[$eSpellHaste] & "\n"
						$txtTroopStats &= "\n" & GetTranslated(620,168,"Current Trained Troops & Spells") & ":"
						$txtTroopStats &= "\n\n" & GetTranslated(620,169,"Current Army Camp") & ": " & $CurCamp & "/" & $TotalCamp
						NotifyPushToTelegram($g_sNotifyOrigin & $txtTroopStats)
					Case GetTranslated(620,37,"HALTATTACKON"), '\U274C ' & StringUpper(GetTranslated(620,38,"Attack Off"))
						GUICtrlSetState($g_hChkBotStop, $GUI_CHECKED)
						btnStop()
						$g_bChkBotStop = True ; set halt attack variable
						$g_iCmbBotCond = 18; set stay online
						btnStart()
					Case GetTranslated(620,40,"HALTATTACKOFF"), '\U2705 ' & StringUpper(GetTranslated(620,41,"Attack On"))
						GUICtrlSetState($g_hChkBotStop, $GUI_UNCHECKED)
						btnStop()
						btnStart()
					Case GetTranslated(620,43,"HIBERNATE"), '\UD83D\UDCA4 ' & GetTranslated(620,43,"HIBERNATE")
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Hibernate PC", $COLOR_GREEN)
						NotifyPushToTelegram(GetTranslated(620,45,"PC Hibernate sequence initiated"))
						Shutdown(64)
					Case GetTranslated(620,46,"SHUTDOWN"), '\U26A1 ' & StringUpper(GetTranslated(620,47,"Shut down"))
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Shutdown PC", $COLOR_GREEN)
						NotifyPushToTelegram(GetTranslated(620,49,"PC Shutdown sequence initiated"))
						Shutdown(5)
					Case GetTranslated(620,50,"STANDBY"), GetTranslated(620,50,"STANDBY")
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Standby PC", $COLOR_GREEN)
						NotifyPushToTelegram(GetTranslated(620,52,"PC Standby sequence initiated"))
						Shutdown(32)
				EndSwitch
			EndIf
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------

EndFunc   ;==> NotifyRemoteControlProc

Func NotifyPushToBoth($pMessage)
	If ($g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "") And ($g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable = True And $g_sNotifyPBToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		Local $access_token = $g_sNotifyPBToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf
	;PushBullet ---------------------------------------------------------------------------------
	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable = True And $g_sNotifyTGToken <> ""  Then
	   Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	   Local $url = "https://api.telegram.org/bot"
	   $oHTTP.Open("Post",  $url & $g_sNotifyTGToken & "/sendMessage", False)
	   $oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

	   Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
	   Local $Time = @HOUR & '.' & @MIN
	   Local $TGPushMsg = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $g_sTGChatID & '}}'
	   $oHTTP.Send($TGPushMsg)
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==> NotifyPushToBoth

Func NotifyPushMessageToBoth($Message, $Source = "")
    Static $iReportIdleBuilder = 0

 	If $g_bNotifyForced = False And $Message <> "DeleteAllPBMessages" Then
		If $g_bNotifyScheduleWeekDaysEnable = True Then
			If $g_abNotifyScheduleWeekDays[@WDAY - 1] = True Then
				If $g_bNotifyScheduleHoursEnable = True Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If $g_abNotifyScheduleHours[$hour[0]] = False Then
						SetLog("Notify not planned for this hour! Notification skipped", $COLOR_ORANGE)
						SetLog($Message, $COLOR_ORANGE)
						Return ; exit func if no planned
					EndIf
				EndIf
			Else
				;SetLog("Notify not planned to: " & _DateDayOfWeek(@WDAY), $COLOR_ORANGE)
				;SetLog($Message, $COLOR_ORANGE)
				Return ; exit func if not planned
			EndIf
		Else
			If $g_bNotifyScheduleHoursEnable = True Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If $g_abNotifyScheduleHours[$hour[0]] = False Then
					SetLog("Notify not planned for this hour! Notification skipped", $COLOR_ORANGE)
					SetLog($Message, $COLOR_ORANGE)
					Return ; exit func if no planned
				EndIf
			EndIf
		EndIf
	EndIf

	$g_bNotifyForced = False

	Local $hBitmap_Scaled
	Switch $Message
		Case "Restarted"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True)  And $g_bNotifyRemoteEnable = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,145, "Bot restarted"))
		Case "OutOfSync"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True)  And $g_bNotifyAlertOutOfSync = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,172, "Restarted after Out of Sync Error") & "\n" & GetTranslated(620,149, "Attacking now") & "...")
		Case "LastRaid"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True)  And $g_bNotifyAlerLastRaidTXT = True Then
				NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,119, "Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslated(620,112, "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
				If _Sleep($iDelayPushMsg1) Then Return
				If $g_bNotifyPBEnable = True Then SetLog("Notify PushBullet: Last Raid Text has been sent!", $COLOR_GREEN)
				If $g_bNotifyTGEnable = True Then SetLog("Notify Telegram: Last Raid Text has been sent!", $COLOR_GREEN)
			EndIf
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True)  And $g_bNotifyAlerLastRaidIMG = True Then

				;create a temporary file to send with pushbullet...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				If $ScreenshotLootInfo = 1 Then
					$g_sAttackFile = $LootFileName
				Else
					_CaptureRegion()
					$g_sAttackFile = "Notify_" & $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
					$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
					_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $g_sProfileLootsPath & $g_sAttackFile)
					_GDIPlus_ImageDispose($hBitmap_Scaled)
				EndIf
				;push the file
				If $g_bNotifyPBEnable = True Then SetLog("Notify PushBullet: Last Raid screenshot has been sent!", $COLOR_GREEN)
				If $g_bNotifyTGEnable = True Then SetLog("Notify Telegram: Last Raid screenshot has been sent!", $COLOR_GREEN)
				NotifyPushFileToBoth($g_sAttackFile, "Loots", "image/jpeg", $g_sNotifyOrigin & " | " & "Last Raid" & "\n" & $g_sAttackFile)
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg1) Then Return
				Local $iDelete = FileDelete($g_sProfileLootsPath & $g_sAttackFile)
				If Not $iDelete Then
					If $g_bNotifyPBEnable = True Then SetLog("Notify PushBullet: An error occurred deleting temporary screenshot file.", $COLOR_RED)
					If $g_bNotifyTGEnable = True Then SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_RED)
				EndIf
			EndIf
		Case "FoundWalls"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertUpgradeWalls = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,173, "Found Wall level") & " " & $g_iCmbUpgradeWallsLevel + 4 & "\n" & " " & GetTranslated(620,177, "Wall segment has been located") & "...\n" & GetTranslated(620,153, "Upgrading") & "...")
		Case "SkipWalls"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertUpgradeWalls = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,174, "Cannot find Wall level") & $g_iCmbUpgradeWallsLevel + 4 & "\n" & GetTranslated(620,154, "Skip upgrade") & "...")
		Case "AnotherDevice3600"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertAnotherDevice = True Then NotifyPushToBoth($g_sNotifyOrigin & " | 1. " & GetTranslated(620,175, "Another Device has connected") & "\n" & GetTranslated(620,176, "Another Device has connected, waiting") & " " & Floor(Floor($sTimeWakeUp / 60) / 60) & " " & GetTranslated(603,14, "Hours") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice60"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertAnotherDevice = True Then NotifyPushToBoth($g_sNotifyOrigin & " | 2. " & GetTranslated(620,175, "Another Device has connected") & "\n" & GetTranslated(620,176, "Another Device has connected, waiting") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertAnotherDevice = True Then NotifyPushToBoth($g_sNotifyOrigin & " | 3. " & GetTranslated(620,175, "Another Device has connected") & "\n" & GetTranslated(620,176, "Another Device has connected, waiting") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "TakeBreak"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertTakeBreak = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,106, "Chief, we need some rest!") & "\n" & GetTranslated(620,107, "Village must take a break.."))
		Case "Update"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertBOTUpdate = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,129, "Chief, there is a new version of the bot available"))
		Case "BuilderIdle"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertBulderIdle = True Then
				Local $iAvailBldr = $iFreeBuilderCount - ($g_bUpgradeWallSaveBuilder ? 1 : 0)
				If $iAvailBldr > 0 Then
					If $iReportIdleBuilder <> $iAvailBldr Then
						NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,122,"You have") & " " & $iAvailBldr & " " & GetTranslated(620,123,"builder(s) idle."))
						SetLog("You have " & $iAvailBldr & " builder(s) idle.", $COLOR_GREEN)
						$iReportIdleBuilder = $iAvailBldr
					EndIf
				Else
					$iReportIdleBuilder = 0
				EndIf
			EndIf
		Case "CocError"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertOutOfSync = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,155, "CoC Has Stopped Error") & ".....")
		Case "Pause"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyRemoteEnable = True And $Source = "Push" Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,166, "Request to Pause") & "..." & "\n" & GetTranslated(620,156, "Your request has been received. Bot is now paused"))
		Case "Resume"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyRemoteEnable = True And $Source = "Push" Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,167, "Request to Resume") & "..." & "\n" & GetTranslated(620,157, "Your request has been received. Bot is now resumed"))
		Case "OoSResources"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertOutOfSync = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,178, "Disconnected after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,104, "skip(s)") & "\n" & GetTranslated(620,158, "Cannot locate Next button, Restarting Bot") & "...")
		Case "MatchFound"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertMatchFound = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & $g_asModeText[$g_iMatchMode] & " " & GetTranslated(620,103, "Match Found! after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,104, "skip(s)") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($searchGold) & "; [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($searchElixir) & "; [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($searchDark) & "; [" & GetTranslated(620,112, "T") & "]: " & $searchTrophy)
		Case "UpgradeWithGold"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertUpgradeWalls = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,179, "Upgrade completed by using GOLD") & "\n" & GetTranslated(620,159, "Complete by using GOLD") & "...")
		Case "UpgradeWithElixir"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertUpgradeWalls = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,180, "Upgrade completed by using ELIXIR") & "\n" & GetTranslated(620,159, "Complete by using ELIXIR") & "...")
		Case "NoUpgradeWallButton"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertUpgradeWalls = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,160, "No Upgrade Gold Button") & "\n" & GetTranslated(620,160, "Cannot find gold upgrade button") & "...")
		Case "NoUpgradeElixirButton"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertUpgradeWalls = True Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,181, "No Upgrade Elixir Button") & "\n" & GetTranslated(620,161, "Cannot find elixir upgrade button") & "...")
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion()
			If $g_bPBRequestScreenshotHD = True Or $g_bTGRequestScreenshotHD = True Then
				$hBitmap_Scaled = $hBitmap
			Else
				$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
			EndIf
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $g_sProfileTempPath & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			If $g_bPBRequestScreenshot = True Or $g_bTGRequestScreenshot = True Then
				If $g_bPBRequestScreenshot = True And $g_bNotifyPBEnable = True Then
					NotifyPushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslated(620,162, "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
					SetLog("Notify PushBullet: Screenshot sent!", $COLOR_GREEN)
				EndIf
				If $g_bTGRequestScreenshot = True And $g_bNotifyTGEnable = True Then
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslated(620,162, "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
					SetLog("Notify Telegram: Screenshot sent!", $COLOR_GREEN)
				EndIf
			EndIf
			$g_bPBRequestScreenshot = False
			$g_bPBRequestScreenshotHD = False
			$g_bTGRequestScreenshot = False
			$g_bTGRequestScreenshotHD = False
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($g_sProfileTempPath & $Screnshotfilename)
			If Not $iDelete Then
				If $g_bNotifyPBEnable = True Then SetLog("Notify PushBullet: An error occurred deleting temporary screenshot file.", $COLOR_RED)
				If $g_bNotifyTGEnable = True Then SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_RED)
			EndIf
		Case "BuilderInfo"
			Click(0,0, 5)
			Click(274,8)
			_Sleep (500)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(224, 74, 446, 262)
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap, $g_sProfileTempPath & $Screnshotfilename)
			If $g_bPBRequestBuilderInfo = True Or $g_bTGRequestBuilderInfo = True Then
				If $g_bPBRequestBuilderInfo = True And $g_bNotifyPBEnable = True Then
					NotifyPushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " &  "Builder Information" & "\n" & $Screnshotfilename)
					SetLog("Notify PushBullet: Builder Information sent!", $COLOR_GREEN)
				EndIf
				If $g_bTGRequestBuilderInfo = True And $g_bNotifyTGEnable = True Then
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " &  "Builder Information" & "\n" & $Screnshotfilename)
					SetLog("Notify Telegram: Builder Information sent!", $COLOR_GREEN)
				EndIf
			EndIf
			$g_bPBRequestBuilderInfo = False
			$g_bTGRequestBuilderInfo = False
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($g_sProfileTempPath & $Screnshotfilename)
			If Not $iDelete Then
				If $g_bNotifyPBEnable = True Then SetLog("Notify PushBullet: An error occurred deleting temporary screenshot file.", $COLOR_RED)
				If $g_bNotifyTGEnable = True Then SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_RED)
			EndIf
			Click(0,0, 5)
		Case "ShieldInfo"
			Click(0,0, 5)
			Click(435,8)
			_Sleep (500)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(200, 165, 660, 568)
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap, $g_sProfileTempPath & $Screnshotfilename)
			If $g_bPBRequestShieldInfo = True Or $g_bTGRequestShieldInfo = True Then
				If $g_bPBRequestShieldInfo = True And $g_bNotifyPBEnable = True Then
					NotifyPushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " &  "Shield Information" & "\n" & $Screnshotfilename)
					SetLog("Notify PushBullet: Shield Information sent!", $COLOR_GREEN)
				EndIf
				If $g_bTGRequestShieldInfo = True And $g_bNotifyTGEnable = True Then
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " &  "Shield Information" & "\n" & $Screnshotfilename)
					SetLog("Notify Telegram: Shield Information sent!", $COLOR_GREEN)
				EndIf
			EndIf
			$g_bPBRequestShieldInfo = False
			$g_bTGRequestShieldInfo = False
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($g_sProfileTempPath & $Screnshotfilename)
			If Not $iDelete Then
				If $g_bNotifyPBEnable = True Then SetLog("Notify PushBullet: An error occurred deleting temporary screenshot file.", $COLOR_RED)
				If $g_bNotifyTGEnable = True Then SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_RED)
			EndIf
			Click(0,0, 5)
		Case "DeleteAllPBMessages"
			NotifyDeletePushBullet()
			If $g_bNotifyPBEnable = True Then SetLog("Notify PushBullet: All messages deleted.", $COLOR_GREEN)
			If $g_bNotifyTGEnable = True Then SetLog("Notify Telegram: All messages deleted.", $COLOR_GREEN)
			$g_bNotifyDeleteAllPushesNow = False ; reset value
		Case "CampFull"
			If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertCampFull = True Then
				NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslated(620,128, "Your Army Camps are now Full"))
				If $g_bNotifyPBEnable = True Then SetLog("Notify PushBullet: Your Army Camps are now Full", $COLOR_GREEN)
				If $g_bNotifyTGEnable = True Then SetLog("Notify Telegram: Your Army Camps are now Full", $COLOR_GREEN)
			EndIf
		Case "Misc"
			NotifyPushToBoth($Message)
	EndSwitch
EndFunc   ;==> NotifyPushMessageToBoth

Func NotifyPushFileToBoth($File, $Folder, $FileType, $body)
	If ($g_bNotifyPBEnable = False Or $g_sNotifyPBToken = "") And ($g_bNotifyTGEnable = False Or $g_sNotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable = True And $g_sNotifyPBToken <> "" Then
		If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then
			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
			Local $access_token = $g_sNotifyPBToken
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
			$oHTTP.Send($pPush)
			Local $Result = $oHTTP.ResponseText
			Local $upload_url = _StringBetween($Result, 'upload_url":"', '"')
			Local $awsaccesskeyid = _StringBetween($Result, 'awsaccesskeyid":"', '"')
			Local $acl = _StringBetween($Result, 'acl":"', '"')
			Local $key = _StringBetween($Result, 'key":"', '"')
			Local $signature = _StringBetween($Result, 'signature":"', '"')
			Local $policy = _StringBetween($Result, 'policy":"', '"')
			Local $file_url = _StringBetween($Result, 'file_url":"', '"')
			If IsArray($upload_url) And IsArray($awsaccesskeyid) And IsArray($acl) And IsArray($key) And IsArray($signature) And IsArray($policy) Then
				$Result = RunWait($g_sCurlPath & " -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & $g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)
				$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
				$oHTTP.SetCredentials($access_token, "", 0)
				$oHTTP.SetRequestHeader("Content-Type", "application/json")
				Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $file_url[0] & '", "body": "' & $body & '"}'
				$oHTTP.Send($pPush)
			Else
				SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,726,"Unable to send file") & " " & $File, $COLOR_RED)
				NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,170, "Unable to Upload File") & "\n" & GetTranslated(620,171, "Occured an error type") & " 1 " & GetTranslated(620,144, "uploading file to PushBullet server") & "...")
			EndIf
		Else
			SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_RED)
			NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslated(620,170, "Unable to Upload File") & "\n" & GetTranslated(620,171, "Occured an error type") & " 2 " & GetTranslated(620,144, "uploading file to PushBullet server") & "...")
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable = True And $g_sNotifyTGToken <> ""  Then
		If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then

			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/sendPhoto"
			Local $Result = RunWait($g_sCurlPath & " -i -X POST " & $telegram_url & ' -F chat_id="' & $g_sTGChatID &' " -F photo=@"' & $g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File  & '"', "", @SW_HIDE)
			$oHTTP.Open("Post", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/sendPhoto", False)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP.Send($pPush)
		Else
			SetLog("Notify Telegram: Unable to send file " & $File, $COLOR_RED)
			NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslated(620,170,"Unable to Upload File") & "\n" & GetTranslated(620,146,"Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==> NotifyPushFileToBoth
; Both ---------------------------------
