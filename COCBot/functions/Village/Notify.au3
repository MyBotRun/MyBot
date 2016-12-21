; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This function will notify events and allow remote control of your bot on your mobile phone
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Full revamp of Notify by IceCube (2016-09)
; Modified ......: IceCube (2016-12) v1.5.1
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


#include <Array.au3>
#include <String.au3>

;GUI --------------------------------------------------------------------------------------------------
Func NotifyRemoteControl()
	If $NotifyRemoteEnable = 1 Then NotifyRemoteControlProc(0)
EndFunc   ;==>NotifyRemoteControl

Func NotifyReport()
	If $NotifyAlertVillageReport = 1 Then
		NotifylPushBulletMessage($NotifyOrigin & ":" & "\n" & " [" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldCurrent) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirCurrent) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($iDarkCurrent) & "  [" & GetTranslated(620,112, "T") & "]: " & _NumberFormat($iTrophyCurrent) & " [" & GetTranslated(620,105, "No. of Free Builders") & "]: " & _NumberFormat($iFreeBuilderCount))
	EndIf
	If $NotifyAlertLastAttack = 1 Then
		If Not ($iGoldLast = "" And $iElixirLast = "") Then NotifylPushBulletMessage($NotifyOrigin & " | Last Gain :" & "\n" & " [" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($iDarkLast) & "  [" & GetTranslated(620,112, "T") & "]: " & _NumberFormat($iTrophyLast))
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
		If ($NotifyPBEnabled = 0 Or $NotifyPBToken = "") And ($NotifyTGEnabled = 0 Or $NotifyTGToken = "") Then Return

		NotifyRemoteControl()

		If $PBRequestScreenshot = 1 Or $TGRequestScreenshot = 1 Then
			$NotifyForced = 1
			PushMsg("RequestScreenshot")
		EndIf
		If $PBRequestBuilderInfo = 1 Or $TGRequestBuilderInfo = 1 Then
			$NotifyForced = 1
			PushMsg("BuilderInfo")
		EndIf
		If $PBRequestShieldInfo = 1 Or $TGRequestShieldInfo = 1 Then
			$NotifyForced = 1
			PushMsg("ShieldInfo")
		EndIf
		PushMsg("BuilderIdle")
EndFunc   ;==>NotifyPendingActions
;MISC --------------------------------------------------------------------------------------------------


; PushBullet ---------------------------------
Func PushBulletRemoteControl()
	If ($NotifyPBEnabled = 1) And $NotifyRemoteEnable = 1 Then NotifyRemoteControlProc(1)
EndFunc   ;==>PushBulletRemoteControl

Func PushBulletDeleteOldPushes()
	If $NotifyPBEnabled = 1 And $NotifyDeletePushesOlderThan = 1 Then _DeleteOldPushes() ; check every 30 min if must delete old pushbullet messages, increase delay time for anti ban pushbullet
EndFunc   ;==>PushBulletDeleteOldPushes

Func NotifylPushBulletMessage($pMessage = "")
	If ($NotifyPBEnabled = 0 Or $NotifyPBToken = "") And ($NotifyTGEnabled = 0 Or $NotifyTGToken = "") Then Return

 	If $NotifyForced = 0 Then
		If $NotifyScheduleWeekDaysEnable = 1 Then
			If $NotifyScheduleWeekDays[@WDAY - 1] = 1 Then
				If $NotifyScheduleHoursEnable = 1 Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If $NotifyScheduleHours[$hour[0]] = 0 Then
						SetLog(GetTranslated(620,725,"Notify not planned for this hour! Notification skipped"), $COLOR_ORANGE)
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
			If $NotifyScheduleHoursEnable = 1 Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If $NotifyScheduleHours[$hour[0]] = 0 Then
					SetLog(GetTranslated(620,725,"Notify not planned for this hour! Notification skipped"), $COLOR_ORANGE)
					SetLog($pMessage, $COLOR_ORANGE)
					Return ; exit func if no planned
				EndIf
			EndIf
		EndIf
	EndIf

	;PushBullet ---------------------------------------------------------------------------------
	If $NotifyPBEnabled = 1 And $NotifyPBToken <> "" Then
		$NotifyForced = 0

		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		;$access_token = $NotifyPBToken
		$oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
		$oHTTP.SetCredentials($NotifyPBToken, "", 0)
		$oHTTP.Send()
		$Result = $oHTTP.ResponseText
		Local $device_iden = _StringBetween($Result, 'iden":"', '"')
		Local $device_name = _StringBetween($Result, 'nickname":"', '"')
		Local $device = ""
		Local $pDevice = 1
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		$oHTTP.SetCredentials($NotifyPBToken, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

	;Telegram ---------------------------------------------------------------------------------
	If $NotifyTGEnabled = 1 And $NotifyTGToken <> ""  Then

		 Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		 $oHTTP.Open("Get", "https://api.telegram.org/bot" & $NotifyTGToken & "/getupdates" , False)
		 $oHTTP.Send()
		 $Result = $oHTTP.ResponseText
		 Local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
		 $TGChatID = _Arraypop($chat_id)
		 $oHTTP.Open("Post", "https://api.telegram.org/bot" & $NotifyTGToken &"/sendmessage", False)
		 $oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")
	     Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		 Local $Time = @HOUR & '.' & @MIN
		 Local $TGPushMsg = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $TGChatID & '}}'
		 $oHTTP.Send($TGPushMsg)
	EndIf
	;Telegram ---------------------------------------------------------------------------------

EndFunc   ;==> NotifylPushBulletMessage

Func NotifyPushToPushBullet($pMessage)
	If ($NotifyPBEnabled = 0 Or $NotifyPBToken = "") And ($NotifyTGEnabled = 0 Or $NotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $NotifyPBEnabled = 1 And $NotifyPBToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		$access_token = $NotifyPBToken
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
	If $NotifyPBEnabled = 0 Or $NotifyPBToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("DELETE", "https://api.pushbullet.com/v2/pushes", False)
	$access_token = $NotifyPBToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
EndFunc   ;==> NotifyDeletePushBullet

Func NotifyDeleteMessageFromPushBullet($iden)
	If $NotifyPBEnabled = 0 Or $NotifyPBToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes/" & $iden, False)
	$access_token = $NotifyPBToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$iden = ""
EndFunc   ;==> NotifyDeleteMessageFromPushBullet

Func NotifyDeleteOldPushesFromPushBullet()
	If $NotifyPBEnabled = 0 Or $NotifyPBToken = "" Or $NotifyDeletePushesOlderThan = 0 Then Return
	;Local UTC time
	Local $tLocal = _Date_Time_GetLocalTime()
	Local $tSystem = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($tLocal))
	Local $timeUTC = _Date_Time_SystemTimeToDateTimeStr($tSystem, 1)
	Local $timestamplimit = 0
	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $timestamplimit, False)
	$access_token = $NotifyPBToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText
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
					If $hdif >= $NotifyDeletePushesOlderThanHours Then
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
		SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,734,"removed") & " " & $msgdeleted & " " & GetTranslated(620,735,"messages older than") & " " & $NotifyDeletePushesOlderThanHours & " h ", $COLOR_GREEN)
	EndIf
EndFunc   ;==> NotifyDeleteOldPushesFromPushBullet

Func NotifyPushFileToPushBullet($File, $Folder, $FileType, $body)
	If ($NotifyPBEnabled = 0 Or $NotifyPBToken = "") And ($NotifyTGEnabled = 0 Or $NotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $NotifyPBEnabled = 1 And $NotifyPBToken <> "" Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
			$access_token = $NotifyPBToken
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
			$oHTTP.Send($pPush)
			$Result = $oHTTP.ResponseText
			Local $upload_url = _StringBetween($Result, 'upload_url":"', '"')
			Local $awsaccesskeyid = _StringBetween($Result, 'awsaccesskeyid":"', '"')
			Local $acl = _StringBetween($Result, 'acl":"', '"')
			Local $key = _StringBetween($Result, 'key":"', '"')
			Local $signature = _StringBetween($Result, 'signature":"', '"')
			Local $policy = _StringBetween($Result, 'policy":"', '"')
			Local $file_url = _StringBetween($Result, 'file_url":"', '"')
			If IsArray($upload_url) And IsArray($awsaccesskeyid) And IsArray($acl) And IsArray($key) And IsArray($signature) And IsArray($policy) Then
				$Result = RunWait($pCurl & " -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)
				$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
				$oHTTP.SetCredentials($access_token, "", 0)
				$oHTTP.SetRequestHeader("Content-Type", "application/json")
				Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $file_url[0] & '", "body": "' & $body & '"}'
				$oHTTP.Send($pPush)
			Else
				SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,726,"Unable to send file") & " " & $File, $COLOR_RED)
				NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,170, "Unable to Upload File") & "\n" & GetTranslated(620,171, "Occured an error type") & " 1 " & GetTranslated(620,144, "uploading file to PushBullet server") & "...")
			EndIf
		Else
			SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,726,"Unable to send file") & " " & $File, $COLOR_RED)
			NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,170, "Unable to Upload File") & "\n" & GetTranslated(620,171, "Occured an error type") & " 2 " & GetTranslated(620,144, "uploading file to PushBullet server") & "...")
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

EndFunc   ;==> NotifyPushFileToPushBullet
; PushBullet ---------------------------------

; Telegram ---------------------------------
Func NotifyPushToTelegram($pMessage)
	If ($NotifyPBEnabled = 0 Or $NotifyPBToken = "") And ($NotifyTGEnabled = 0 Or $NotifyTGToken = "") Then Return

	;Telegram ---------------------------------------------------------------------------------
	If $NotifyTGEnabled = 1 And $NotifyTGToken <> ""  Then

	   Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	   $url = "https://api.telegram.org/bot"
	   $oHTTP.Open("Post",  $url & $NotifyTGToken & "/sendMessage", False)
	   $oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

	   Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
	   Local $Time = @HOUR & '.' & @MIN
	   Local $TGPushMsg = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $TGChatID & '}}'
	   $oHTTP.Send($TGPushMsg)
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==> NotifyPushToTelegram

Func NotifyPushFileToTelegram($File, $Folder, $FileType, $body)
	If ($NotifyPBEnabled = 0 Or $NotifyPBToken = "") And ($NotifyTGEnabled = 0 Or $NotifyTGToken = "") Then Return

	;Telegram ---------------------------------------------------------------------------------
	If $NotifyTGEnabled = 1 And $NotifyTGToken <> ""  Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then

			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $NotifyTGToken & "/sendPhoto"
			$Result = RunWait($pCurl & " -i -X POST " & $telegram_url & ' -F chat_id="' & $TGChatID &' " -F photo=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File  & '"', "", @SW_HIDE)
			$oHTTP.Open("Post", "https://api.telegram.org/bot" & $NotifyTGToken & "/sendPhoto", False)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP.Send($pPush)
		Else
			SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,726,"Unable to send file") & " " & $File, $COLOR_RED)
			NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,170,"Unable to Upload File") & "\n" & GetTranslated(620,146,"Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==> NotifyPushFileToTelegram

Func NotifyGetLastMessageFromTelegram()
    If $NotifyTGEnabled = 0 Or $NotifyTGToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Get", "https://api.telegram.org/bot" & $NotifyTGToken & "/getupdates" , False)
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText

	Local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
	$TGChatID = _Arraypop($chat_id)

	Local $uid = _StringBetween($Result, 'update_id":', '"message"')             ;take update id
	$TGLast_UID = StringTrimRight(_Arraypop($uid), 2)

	Local $findstr2 = StringRegExp(StringUpper($Result), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result, 'text":"' ,'"}}' )           ;take message
		Local $TGLastMessage = _Arraypop($rmessage)								 ;take last message
	EndIf


	$oHTTP.Open("Get", "https://api.telegram.org/bot" & $NotifyTGToken & "/getupdates?offset=" & $TGLast_UID  , False)
	$oHTTP.Send()
	$Result2 = $oHTTP.ResponseText

	Local $findstr2 = StringRegExp(StringUpper($Result2), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result2, 'text":"' ,'"}}' )           ;take message
		Local $TGLastMessage = _Arraypop($rmessage)		;take last message
		If $TGLastMessage = "" Then
			Local $rmessage = _StringBetween($Result2, 'text":"' ,'","entities"' )           ;take message
			Local $TGLastMessage = _Arraypop($rmessage)		;take last message
		EndIf

		return $TGLastMessage
	EndIf

EndFunc 	;==> NotifyGetLastMessageFromTelegram

Func NotifyActivateKeyboardOnTelegram($TGMsg)

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$url = "https://api.telegram.org/bot"
	$oHTTP.Open("Post",  $url & $NotifyTGToken & "/sendMessage", False)
	$oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

	Local $TGPushMsg = '{"text": "' & $TGMsg & '", "chat_id":' & $TGChatID &', "reply_markup": {"keyboard": [["' & _
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

	$TGLastRemote = $TGLast_UID

EndFunc   ;==> NotifyActivateKeyboardOnTelegram
; Telegram ---------------------------------


; Both ---------------------------------
Func NotifyRemoteControlProc($OnlyPB)
	If ($NotifyPBEnabled = 0 And $NotifyTGEnabled = 0) Or $NotifyRemoteEnable = 0 Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $OnlyPB = 0 And $NotifyPBEnabled = 1 And $NotifyPBToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		Local $pushbulletApiUrl
		If $pushLastModified = 0 Then
			$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&limit=1" ; if this is the first time looking for pushes, get the last one
		Else
			$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $pushLastModified ; get the one pushed after the last one received
		EndIf
		$oHTTP.Open("Get", $pushbulletApiUrl, False)
		$access_token = $NotifyPBToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		$oHTTP.Send()
		$Result = $oHTTP.ResponseText

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

					$NotifyForced = 1

					Switch $body[$x]
						Case GetTranslated(620,1, "BOT") & " " & GetTranslated(620,4, "HELP")
							Local $txtHelp = "PushBullet " & GetTranslated(620,2,"Help") & " " & GetTranslated(620,3, " - You can remotely control your bot sending COMMANDS from the following list:")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,4, -1) & GetTranslated(620,5, " - send this help message")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,7,"DELETE") & GetTranslated(620,8, " - delete all your previous PushBullet messages")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,9,"RESTART") & GetTranslated(620,10, " - restart the Emulator and bot named") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,11,"STOP") & GetTranslated(620,12, " - stop the bot named") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,13,"PAUSE") & GetTranslated(620,14, " - pause the bot named") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,15,"RESUME") & GetTranslated(620,16, " - resume the bot named") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,17,"STATS") & GetTranslated(620,18, " - send Village Statistics of") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,19,"LOG") & GetTranslated(620,20, " - send the current log file of") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,21,"LASTRAID") & GetTranslated(620,22, " - send the last raid loot screenshot of") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,23,"LASTRAIDTXT") & GetTranslated(620,24, " - send the last raid loot values of") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,25,"SCREENSHOT") & GetTranslated(620,26, " - send a screenshot of") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,27,"SCREENSHOTHD") & GetTranslated(620,28, " - send a screenshot in high resolution of") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,29,"BUILDER") & GetTranslated(620,30, " - send a screenshot of builder status of") & " <" & $NotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,31,"SHIELD") & GetTranslated(620,32, " - send a screenshot of shield status of") & " <" & $NotifyOrigin & ">"
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,33,"RESETSTATS") & GetTranslated(620,34, " - reset Village Statistics")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,35,"TROOPS") & GetTranslated(620,36, " - send Troops & Spells Stats")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,37,"HALTATTACKON") & GetTranslated(620,39, " - Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,40,"HALTATTACKOFF") & GetTranslated(620,42, " - Turn Off 'Halt Attack' in the 'Misc' Tab")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,43,"HIBERNATE") & GetTranslated(620,44, " - Hibernate host PC")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,46,"SHUTDOWN") & GetTranslated(620,48, " - Shut down host PC")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $NotifyOrigin & "> " & GetTranslated(620,50,"STANDBY") & GetTranslated(620,51, " - Standby host PC")
							$txtHelp &= '\n'
							$txtHelp &= '\n' & GetTranslated(620,98, "Examples:")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & $NotifyOrigin & " " & GetTranslated(620,17,"STATS")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,29,"BUILDER")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & $NotifyOrigin & " " & GetTranslated(620,27,"SCREENSHOTHD")
							NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,100, "Request for Help") & "\n" & $txtHelp)
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,702,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,703,"Help has been sent"), $COLOR_GREEN)
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & GetTranslated(620,7,"DELETE")
							NotifyDeletePushBullet()
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,704, "Your request has been received."), $COLOR_GREEN)
						Case GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & GetTranslated(620,9,"RESTART")
							NotifyDeleteMessageFromPushBullet($iden[$x])
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,705, "Your request has been received. Bot and Android Emulator restarting..."), $COLOR_GREEN)
							NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,165, "Request to Restart") & "...\n" & GetTranslated(620,132, "Your bot and Emulator are now restarting") & "...")
							SaveConfig()
							_Restart()
						Case GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & GetTranslated(620,11,"STOP")
							NotifyDeleteMessageFromPushBullet($iden[$x])
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,706, "Your request has been received. Bot is now stopped"), $COLOR_GREEN)
							If $Runstate = True Then
								NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,124, "Request to Stop") & "..." & "\n" & GetTranslated(620,133, "Your bot is now stopping") & "...")
								btnStop()
							Else
								NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,124, "Request to Stop") & "..." & "\n" & GetTranslated(620,134, "Your bot is currently stopped, no action was taken"))
							EndIf
						Case GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & GetTranslated(620,13,"PAUSE")
							If $TPaused = False And $Runstate = True Then
								If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
									SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,707, "Unable to pause during attack"), $COLOR_RED)
									NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,166, "Request to Pause") & "\n" & GetTranslated(620,164, "Unable to pause during attack, try again later."))
								ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
									ReturnHome(False, False)
									$Is_SearchLimit = True
									$Is_ClientSyncError = False
									UpdateStats()
									$Restart = True
									TogglePauseImpl("Push")
								Else
									TogglePauseImpl("Push")
								EndIf
							Else
								SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,708,"Your bot is currently paused, no action was taken"), $COLOR_GREEN)
								NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,166, "Request to Pause") & "\n" & GetTranslated(620,150, "Your bot is currently paused, no action was taken"))
							EndIf
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & GetTranslated(620,15,"RESUME")
							If $TPaused = True And $Runstate = True Then
								TogglePauseImpl("Push")
							Else
								SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,709,"Your bot is currently resumed, no action was taken"), $COLOR_GREEN)
								NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,167, "Request to Resume") & "\n" & GetTranslated(620,130, "Your bot is currently resumed, no action was taken"))
							EndIf
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & GetTranslated(620,17,"STATS")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,710,"Your request has been received. Statistics sent"), $COLOR_GREEN)
							NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,108, "Stats Village Report") & "\n" & GetTranslated(620,148, "At Start") & "\n[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldStart) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirStart) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($iDarkStart) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyStart & "\n\n" & GetTranslated(620,114, "Now (Current Resources)") &"\n[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldCurrent) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirCurrent) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($iDarkCurrent) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyCurrent & " [" & GetTranslated(620,121, "GEM") & "]: " & $iGemAmount & "\n \n [" & GetTranslated(620,105, "No. of Free Builders") & "]: " & $iFreeBuilderCount & "\n [" & GetTranslated(620,117, "No. of Wall Up") & "]: " & GetTranslated(620,109, "G") & ": " & $iNbrOfWallsUppedGold & "/ " & GetTranslated(620,110, "E") & ": " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(620,116, "Attacked") & ": " & $iAttackedCount & "\n" & GetTranslated(620,115, "Skipped") & ": " & $iSkippedVillageCount)
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & GetTranslated(620,19,"LOG")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,711,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,712,"Log is now sent"), $COLOR_GREEN)
							NotifyPushFileToPushBullet($sLogFName, GetTranslated(620,101, "logs"), "text/plain; charset=utf-8", $NotifyOrigin & " | " & GetTranslated(620,102, "Current Log") & " \n")
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & GetTranslated(620,21,"LASTRAID")
							If $AttackFile <> "" Then
								SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,713,"Push Last Raid Snapshot..."), $COLOR_GREEN)
								NotifyPushFileToPushBullet($AttackFile, GetTranslated(620,120, "Loots"), "image/jpeg", $NotifyOrigin & " | " & GetTranslated(620,118, "Last Raid") & " \n" & $AttackFile)
							Else
								NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,131, "There is no last raid screenshot") & ".")
								SetLog(GetTranslated(620,141,"There is no last raid screenshot."))
								SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,714,"Your request has been received. Last Raid txt sent"), $COLOR_GREEN)
								NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,119, "Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyLast)
							EndIf
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & GetTranslated(620,23,"LASTRAIDTXT")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,714,"Your request has been received. Last Raid txt sent"), $COLOR_GREEN)
							NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,119, "Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyLast)
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & GetTranslated(620,25,"SCREENSHOT")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,715,"ScreenShot request received"), $COLOR_GREEN)
							NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,147,"Chief, your request for Screenshot will be processed ASAP"))
							$PBRequestScreenshot = 1
							$NotifyForced = 0
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,27,"SCREENSHOTHD")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,716,"ScreenShot HD request received"), $COLOR_GREEN)
							NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,147,"Chief, your request for Screenshot will be processed ASAP"))
							$PBRequestScreenshot = 1
							$PBRequestScreenshotHD = 1
							$NotifyForced = 0
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,29,"BUILDER")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,717,"Builder Status request received"), $COLOR_GREEN)
							$PBRequestBuilderInfo = 1
							NotifyDeleteMessageFromPushBullet($iden[$x])
							NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,137,"Chief, your request for Builder Info will be processed ASAP"))
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,31,"SHIELD")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,718,"Shield Status request received"), $COLOR_GREEN)
							$PBRequestShieldInfo = 1
							$NotifyForced = 0
							NotifyDeleteMessageFromPushBullet($iden[$x])
							NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,139,"Chief, your request for Shield Info will be processed ASAP"))
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,33,"RESETSTATS")
							btnResetStats()
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,719,"Your request has been received. Statistics resetted"), $COLOR_GREEN)
							NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,135,"Statistics resetted."))
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,35,"TROOPS")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,720,"Your request has been received. Sending Troop/Spell Stats..."), $COLOR_GREEN)
							Local $txtTroopStats = " | " & GetTranslated(620,136,"Troops/Spells set to Train") & ":\n" & "Barbs:" & $BarbComp & " Arch:" & $ArchComp & " Gobl:" & $GoblComp
							$txtTroopStats &= "\n" & "Giant:" & $GiantComp & " WallB:" & $WallComp & " Wiza:" & $WizaComp
							$txtTroopStats &= "\n" & "Balloon:" & $BallComp & " Heal:" & $HealComp & " Dragon:" & $DragComp & " Pekka:" & $PekkComp
							$txtTroopStats &= "\n" & "Mini:" & $MiniComp & " Hogs:" & $HogsComp & " Valks:" & $ValkComp
							$txtTroopStats &= "\n" & "Golem:" & $GoleComp & " Witch:" & $WitcComp & " Lava:" & $LavaComp
							$txtTroopStats &= "\n" & "LSpell:" & $LSpellComp & " HeSpell:" & $HSpellComp & " RSpell:" & $RSpellComp & " JSpell:" & $JSpellComp
							$txtTroopStats &= "\n" & "FSpell:" & $FSpellComp & " PSpell:" & $PSpellComp & " ESpell:" & $ESpellComp & " HaSpell:" & $HaSpellComp & "\n"
							$txtTroopStats &= "\n" & GetTranslated(620,168,"Current Trained Troops & Spells") & ":"
							For $i = 0 to Ubound($NotifyTroopSpellStats)-1
								If $NotifyTroopSpellStats[$i][0] <> "" Then
									$txtTroopStats &= "\n" & $NotifyTroopSpellStats[$i][0] & ":" & $NotifyTroopSpellStats[$i][1]
								EndIf
							Next
							$txtTroopStats &= "\n\n" & GetTranslated(620,169,"Current Army Camp") & ": " & $CurCamp & "/" & $TotalCamp
							NotifyPushToPushBullet($NotifyOrigin & $txtTroopStats)
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,37,"HALTATTACKON")
							GUICtrlSetState($chkBotStop, $GUI_CHECKED)
							btnStop()
							$ichkBotStop = 1 ; set halt attack variable
							$icmbBotCond = 18; set stay online
							btnStart()
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,40,"HALTATTACKOFF")
							GUICtrlSetState($chkBotStop, $GUI_UNCHECKED)
							btnStop()
							btnStart()
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,43,"HIBERNATE")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,702,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,721,"Hibernate PC"), $COLOR_GREEN)
							NotifyPushToPushBullet(GetTranslated(620,45,"PC Hibernate sequence initiated"))
							Shutdown(64)
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,46,"SHUTDOWN")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,702,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,722,"Shutdown PC"), $COLOR_GREEN)
							NotifyPushToPushBullet(GetTranslated(620,49,"PC Shutdown sequence initiated"))
							Shutdown(5)
						Case GetTranslated(620,1, -1) & " " &  StringUpper($NotifyOrigin) & " " & GetTranslated(620,50,"STANDBY")
							SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,702,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,723,"Standby PC"), $COLOR_GREEN)
							NotifyPushToPushBullet(GetTranslated(620,52,"PC Standby sequence initiated"))
							Shutdown(32)
						Case Else
								Local $lenstr = StringLen(GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & "")
								Local $teststr = StringLeft($body[$x], $lenstr)
								If $teststr = (GetTranslated(620,1, -1) & " " & StringUpper($NotifyOrigin) & " " & "") Then
									SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,724,"received command syntax wrong, command ignored."), $COLOR_RED)
									NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,97, "Command not recognized") & "\n" & GetTranslated(620,99, "Please push BOT HELP to obtain a complete command list."))
									NotifyDeleteMessageFromPushBullet($iden[$x])
								EndIf
					EndSwitch
					$body[$x] = ""
					$iden[$x] = ""

					$NotifyForced = 0
				EndIf
			Next
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------


	;Telegram ---------------------------------------------------------------------------------
	If $NotifyTGEnabled = 1 And $NotifyTGToken <> ""  Then
		$TGLastMessage = NotifyGetLastMessageFromTelegram()
		Local $TGActionMSG = StringUpper(StringStripWS($TGLastMessage, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message
		If ($TGActionMSG = "/START" Or $TGActionMSG = "KEYB") And $TGLastRemote <> $TGLast_UID Then
			$TGLastRemote = $TGLast_UID
			NotifyActivateKeyboardOnTelegram($NotifyVersionMSG)
		Else
			If $TGLastRemote <> $TGLast_UID Then
				$TGLastRemote = $TGLast_UID
				Switch $TGActionMSG
					Case GetTranslated(620,4,"HELP"), '\U2753 ' & GetTranslated(620,4,"HELP")
						Local $txtHelp =  "Telegram " & GetTranslated(620,2,"Help") & " " & GetTranslated(620,3, " - You can remotely control your bot sending COMMANDS from the following list:")
						$txtHelp &= '\n' & GetTranslated(620,4, -1) & GetTranslated(620,5, " - send this help message")
						$txtHelp &= '\n' & GetTranslated(620,9,"RESTART") & GetTranslated(620,10, " - restart the Emulator and bot named") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,11,"STOP") & GetTranslated(620,12, " - stop the bot named") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,13,"PAUSE") & GetTranslated(620,14, " - pause the bot named") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,15,"RESUME") & GetTranslated(620,16, " - resume the bot named") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,17,"STATS") & GetTranslated(620,18, " - send Village Statistics of") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,19,"LOG") & GetTranslated(620,20, " - send the current log file of") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,21,"LASTRAID") & GetTranslated(620,22, " - send the last raid loot screenshot of") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,23,"LASTRAIDTXT") & GetTranslated(620,24, " - send the last raid loot values of") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,25,"SCREENSHOT") & GetTranslated(620,26, " - send a screenshot of") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,27,"SCREENSHOTHD") & GetTranslated(620,28, " - send a screenshot in high resolution of") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,29,"BUILDER") & GetTranslated(620,30, " - send a screenshot of builder status of") & " <" & $NotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslated(620,31,"SHIELD") & GetTranslated(620,32, " - send a screenshot of shield status of") & " <" & $NotifyOrigin & ">"
						$txtHelp &= "\n" & GetTranslated(620,33,"RESETSTATS") & GetTranslated(620,34, " - reset Village Statistics")
						$txtHelp &= "\n" & GetTranslated(620,35,"TROOPS") & GetTranslated(620,36, " - send Troops & Spells Stats")
						$txtHelp &= "\n" & GetTranslated(620,37,"HALTATTACKON") & GetTranslated(620,39, " - Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
						$txtHelp &= "\n" & GetTranslated(620,40,"HALTATTACKOFF") & GetTranslated(620,42, " - Turn Off 'Halt Attack' in the 'Misc' Tab")
						$txtHelp &= "\n" & GetTranslated(620,43,"HIBERNATE") & GetTranslated(620,44, " - Hibernate host PC")
						$txtHelp &= "\n" & GetTranslated(620,46,"SHUTDOWN") & GetTranslated(620,48, " - Shut down host PC")
						$txtHelp &= "\n" & GetTranslated(620,50,"STANDBY") & GetTranslated(620,51, " - Standby host PC")

						NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,100,"Request for Help") & "\n" & $txtHelp)
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,702,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,703,"Help has been sent"), $COLOR_GREEN)
					Case GetTranslated(620,9,"RESTART"), '\UD83D\UDD01 ' & GetTranslated(620,9,"RESTART")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,704, "Your request has been received."), $COLOR_GREEN)
						NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,165,"Request to Restart") & "...\n" & GetTranslated(620,143,"Your bot and Emulator are now restarting..."))
						SaveConfig()
						_Restart()
					Case GetTranslated(620,11,"STOP"), '\U25AA ' & GetTranslated(620,11,"Stop")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,706, "Your request has been received. Bot is now stopped"), $COLOR_GREEN)
						If $Runstate = True Then
							 NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,125,"Request to Stop...") & "\n" & GetTranslated(620,126,"Your bot is now stopping..."))
							 btnStop()
						Else
							NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,125,"Request to Stop...") & "\n" & GetTranslated(620,127,"Your bot is currently stopped, no action was taken"))
						EndIf
					Case GetTranslated(620,13,"PAUSE"), '\UD83D\UDD00 ' & GetTranslated(620,13,"PAUSE")
						If $TPaused = False And $Runstate = True Then
							If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
								SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,707, "Unable to pause during attack"), $COLOR_RED)
								NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,166,"Request to Pause") & "\n" & GetTranslated(620,138,"Unable to pause during attack, try again later."))
							ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
								ReturnHome(False, False)
								$Is_SearchLimit = True
								$Is_ClientSyncError = True
								;UpdateStats()
								$Restart = True
								TogglePauseImpl("Push")
								Return True
							Else
								TogglePauseImpl("Push")
							EndIf
						Else
							SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,708,"Your bot is currently paused, no action was taken"), $COLOR_GREEN)
							NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,166,"Request to Pause") & "\n" & GetTranslated(620,150,"Your bot is currently paused, no action was taken"))
						EndIf
					Case GetTranslated(620,15,"RESUME"), '\U25B6 ' & GetTranslated(620,15,"RESUME")
						If $TPaused = True And $Runstate = True Then
							TogglePauseImpl("Push")
						Else
							SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,709,"Your bot is currently resumed, no action was taken"), $COLOR_GREEN)
							NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,167,"Request to Resume") & "\n" & GetTranslated(620,151,"Your bot is currently resumed, no action was taken"))
						EndIf
					Case GetTranslated(620,17,"STATS"), '\UD83D\UDCC8 ' & GetTranslated(620,17,"STATS")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,710,"Your request has been received. Statistics sent"), $COLOR_GREEN)
						Local $GoldGainPerHour = "0 / h"
						Local $ElixirGainPerHour = "0 / h"
						Local $DarkGainPerHour = "0 / h"
						Local $TrophyGainPerHour = "0 / h"
						If $FirstAttack = 2 Then
							$GoldGainPerHour = _NumberFormat(Round($iGoldTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h"
							$ElixirGainPerHour = _NumberFormat(Round($iElixirTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h"
						EndIf
						If $iDarkStart <> "" Then
							$DarkGainPerHour = _NumberFormat(Round($iDarkTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h"
						EndIf
						$TrophyGainPerHour = _NumberFormat(Round($iTrophyTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h"
						Local $txtStats = " | " & GetTranslated(620,108,"Stats Village Report") & "\n" & GetTranslated(620,148,"At Start") & "\n[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldStart) & " [" & GetTranslated(620,110, "E") & "]: "
							  $txtStats &= _NumberFormat($iElixirStart) & " [D]: " & _NumberFormat($iDarkStart) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyStart
							  $txtStats &= "\n\n" & GetTranslated(620,114,"Now (Current Resources)") & "\n[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldCurrent) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirCurrent)
							  $txtStats &= " [D]: " & _NumberFormat($iDarkCurrent) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyCurrent & " [GEM]: " & $iGemAmount
							  $txtStats &= "\n\n" & GetTranslated(620,140,"Gain per Hour") & ":\n[" & GetTranslated(620,109, "G") & "]: " & $GoldGainPerHour & " [" & GetTranslated(620,110, "E") & "]: " & $ElixirGainPerHour
							  $txtStats &= "\n[D]: " & $DarkGainPerHour & " [" & GetTranslated(620,112, "T") & "]: " & $TrophyGainPerHour
							  $txtStats &= "\n\n" & GetTranslated(620,105,"No. of Free Builders") & ": " & $iFreeBuilderCount & "\n[" & GetTranslated(620,117,"No. of Wall Up") & "]: [" & GetTranslated(620,109, "G") & "]: "
							  $txtStats &= $iNbrOfWallsUppedGold & "/ [" & GetTranslated(620,110, "E") & "]: " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(620,116,"Attacked") & ": "
							  $txtStats &= $iAttackedCount & "\n" & GetTranslated(620,115,"Skipped") & ": " & $iSkippedVillageCount
						NotifyPushToTelegram($NotifyOrigin & $txtStats)
					Case GetTranslated(620,19,"LOG"), '\UD83D\UDCCB ' & GetTranslated(620,19,"LOG")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,711,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,712,"Log is now sent"), $COLOR_GREEN)
						NotifyPushFileToTelegram($sLogFName, "logs", "text\/plain; charset=utf-8", $NotifyOrigin & " | Current Log " & "\n")
					Case GetTranslated(620,21,"LASTRAID"), '\UD83C\UDF04 ' & GetTranslated(620,21,"LASTRAID")
						 If $LootFileName <> "" Then
							NotifyPushFileToTelegram($LootFileName, GetTranslated(620,120, "Loots"), "image/jpeg", $NotifyOrigin & " | " & GetTranslated(620,152,"Last Raid") & "\n" & $LootFileName)
							SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,713,"Push Last Raid Snapshot..."), $COLOR_GREEN)
						Else
							NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,141,"There is no last raid screenshot."))
							SetLog(GetTranslated(620,141,"There is no last raid screenshot."))
							SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,714,"Your request has been received. Last Raid txt sent"), $COLOR_GREEN)
							NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,142,"Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyLast)
						EndIf
					Case GetTranslated(620,23,"LASTRAIDTXT"), '\UD83D\UDCC4 ' & GetTranslated(620,23,"LASTRAIDTXT")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,714,"Your request has been received. Last Raid txt sent"), $COLOR_GREEN)
						NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,142,"Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyLast)
					Case GetTranslated(620,25,"SCREENSHOT")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,715,"ScreenShot request received"), $COLOR_GREEN)
						NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,147,"Chief, your request for Screenshot will be processed ASAP"))
						$TGRequestScreenshot = 1
					Case GetTranslated(620,27,"SCREENSHOTHD"), '\UD83D\UDCF7 ' & GetTranslated(620,25,"SCREENSHOT")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,716,"ScreenShot HD request received"), $COLOR_GREEN)
						NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,147,"Chief, your request for Screenshot will be processed ASAP"))
						$TGRequestScreenshot = 1
						$TGRequestScreenshotHD = 1
						$NotifyForced = 0
					Case GetTranslated(620,29,"BUILDER"), '\UD83D\UDD28 ' & GetTranslated(620,29,"BUILDER")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,717,"Builder Status request received"), $COLOR_GREEN)
						$TGRequestBuilderInfo = 1
						NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,137,"Chief, your request for Builder Info will be processed ASAP"))
					Case GetTranslated(620,31,"SHIELD"), '\UD83D\UDD30 ' & GetTranslated(620,31,"SHIELD")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,718,"Shield Status request received"), $COLOR_GREEN)
						$TGRequestShieldInfo = 1
						$NotifyForced = 0
						NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,139,"Chief, your request for Shield Info will be processed ASAP"))
					Case GetTranslated(620,33,"RESETSTATS")
						btnResetStats()
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,719,"Your request has been received. Statistics resetted"), $COLOR_GREEN)
						NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,135,"Statistics resetted."))
					Case GetTranslated(620,35,"TROOPS"), '\UD83D\UDCAA ' & GetTranslated(620,35,"TROOPS")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,720,"Your request has been received. Sending Troop/Spell Stats..."), $COLOR_GREEN)
						Local $txtTroopStats = " | " & GetTranslated(620,136,"Troops/Spells set to Train") & ":\n" & "Barbs:" & $BarbComp & " Arch:" & $ArchComp & " Gobl:" & $GoblComp
						$txtTroopStats &= "\n" & "Giant:" & $GiantComp & " WallB:" & $WallComp & " Wiza:" & $WizaComp
						$txtTroopStats &= "\n" & "Balloon:" & $BallComp & " Heal:" & $HealComp & " Dragon:" & $DragComp & " Pekka:" & $PekkComp
						$txtTroopStats &= "\n" & "Mini:" & $MiniComp & " Hogs:" & $HogsComp & " Valks:" & $ValkComp
						$txtTroopStats &= "\n" & "Golem:" & $GoleComp & " Witch:" & $WitcComp & " Lava:" & $LavaComp
						$txtTroopStats &= "\n" & "LSpell:" & $LSpellComp & " HeSpell:" & $HSpellComp & " RSpell:" & $RSpellComp & " JSpell:" & $JSpellComp
						$txtTroopStats &= "\n" & "FSpell:" & $FSpellComp & " PSpell:" & $PSpellComp & " ESpell:" & $ESpellComp & " HaSpell:" & $HaSpellComp & "\n"
						$txtTroopStats &= "\n" & GetTranslated(620,168,"Current Trained Troops & Spells") & ":"
						For $i = 0 to Ubound($NotifyTroopSpellStats)-1
							If $NotifyTroopSpellStats[$i][0] <> "" Then
								$txtTroopStats &= "\n" & $NotifyTroopSpellStats[$i][0] & ":" & $NotifyTroopSpellStats[$i][1]
							EndIf
						Next
						$txtTroopStats &= "\n\n" & GetTranslated(620,169,"Current Army Camp") & ": " & $CurCamp & "/" & $TotalCamp
						NotifyPushToTelegram($NotifyOrigin & $txtTroopStats)
					Case GetTranslated(620,37,"HALTATTACKON"), '\U274C ' & StringUpper(GetTranslated(620,38,"Attack Off"))
						GUICtrlSetState($chkBotStop, $GUI_CHECKED)
						btnStop()
						$ichkBotStop = 1 ; set halt attack variable
						$icmbBotCond = 18; set stay online
						btnStart()
					Case GetTranslated(620,40,"HALTATTACKOFF"), '\U2705 ' & StringUpper(GetTranslated(620,41,"Attack On"))
						GUICtrlSetState($chkBotStop, $GUI_UNCHECKED)
						btnStop()
						btnStart()
					Case GetTranslated(620,43,"HIBERNATE"), '\UD83D\UDCA4 ' & GetTranslated(620,43,"HIBERNATE")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,702,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,721,"Hibernate PC"), $COLOR_GREEN)
						NotifyPushToTelegram(GetTranslated(620,45,"PC Hibernate sequence initiated"))
						Shutdown(64)
					Case GetTranslated(620,46,"SHUTDOWN"), '\U26A1 ' & StringUpper(GetTranslated(620,47,"Shut down"))
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,702,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,722,"Shutdown PC"), $COLOR_GREEN)
						NotifyPushToTelegram(GetTranslated(620,49,"PC Shutdown sequence initiated"))
						Shutdown(5)
					Case GetTranslated(620,50,"STANDBY"), GetTranslated(620,50,"STANDBY")
						SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,702,"Your request has been received from ") & $NotifyOrigin & ". " & GetTranslated(620,723,"Standby PC"), $COLOR_GREEN)
						NotifyPushToTelegram(GetTranslated(620,52,"PC Standby sequence initiated"))
						Shutdown(32)
				EndSwitch
			EndIf
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------

EndFunc   ;==> NotifyRemoteControlProc

Func NotifyPushToBoth($pMessage)
	If ($NotifyPBEnabled = 0 Or $NotifyPBToken = "") And ($NotifyTGEnabled = 0 Or $NotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $NotifyPBEnabled = 1 And $NotifyPBToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		$access_token = $NotifyPBToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

	;Telegram ---------------------------------------------------------------------------------
	If $NotifyTGEnabled = 1 And $NotifyTGToken <> ""  Then

	   Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	   $url = "https://api.telegram.org/bot"
	   $oHTTP.Open("Post",  $url & $NotifyTGToken & "/sendMessage", False)
	   $oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

	   Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
	   Local $Time = @HOUR & '.' & @MIN
	   Local $TGPushMsg = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $TGChatID & '}}'
	   $oHTTP.Send($TGPushMsg)
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==> NotifyPushToBoth

Func NotifyPushMessageToBoth($Message, $Source = "")

 	If $NotifyForced = 0 And $Message <> "DeleteAllPBMessages" Then
		If $NotifyScheduleWeekDaysEnable = 1 Then
			If $NotifyScheduleWeekDays[@WDAY - 1] = 1 Then
				If $NotifyScheduleHoursEnable = 1 Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If $NotifyScheduleHours[$hour[0]] = 0 Then
						SetLog(GetTranslated(620,725,"Notify not planned for this hour! Notification skipped"), $COLOR_ORANGE)
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
			If $NotifyScheduleHoursEnable = 1 Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If $NotifyScheduleHours[$hour[0]] = 0 Then
					SetLog(GetTranslated(620,725,"Notify not planned for this hour! Notification skipped"), $COLOR_ORANGE)
					SetLog($Message, $COLOR_ORANGE)
					Return ; exit func if no planned
				EndIf
			EndIf
		EndIf
	EndIf

	$NotifyForced = 0

	Local $hBitmap_Scaled
	Switch $Message
		Case "Restarted"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1)  And $NotifyRemoteEnable = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,145, "Bot restarted"))
		Case "OutOfSync"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1)  And $NotifyAlertOutOfSync = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,172, "Restarted after Out of Sync Error") & "\n" & GetTranslated(620,149, "Attacking now") & "...")
		Case "LastRaid"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1)  And $NotifyAlerLastRaidTXT = 1 Then
				NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,119, "Last Raid txt") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620,112, "T") & "]: " & $iTrophyLast)
				If _Sleep($iDelayPushMsg1) Then Return
				If $NotifyPBEnabled = 1 Then SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,727,"Last Raid Text has been sent!"), $COLOR_GREEN)
				If $NotifyTGEnabled = 1 Then SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,727,"Last Raid Text has been sent!"), $COLOR_GREEN)
			EndIf
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1)  And $NotifyAlerLastRaidIMG = 1 Then
				
				;create a temporary file to send with pushbullet...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				If $ScreenshotLootInfo = 1 Then
					$AttackFile = $LootFileName
				Else
					_CaptureRegion()
					$AttackFile = "Notify_" & $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
					$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
					_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirLoots & $AttackFile)
					_GDIPlus_ImageDispose($hBitmap_Scaled)
				EndIf
				;push the file
				If $NotifyPBEnabled = 1 Then SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,728,"Last Raid screenshot has been sent!"), $COLOR_GREEN)
				If $NotifyTGEnabled = 1 Then SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,728,"Last Raid screenshot has been sent!"), $COLOR_GREEN)
				NotifyPushFileToBoth($AttackFile, GetTranslated(620,120, "Loots"), "image/jpeg", $NotifyOrigin & " | " & GetTranslated(620,118, "Last Raid") & "\n" & $AttackFile)
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg1) Then Return
				Local $iDelete = FileDelete($dirLoots & $AttackFile)
				If Not $iDelete Then
					If $NotifyPBEnabled = 1 Then SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,729,"An error occurred deleting temporary screenshot file."), $COLOR_RED)
					If $NotifyTGEnabled = 1 Then SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,729,"An error occurred deleting temporary screenshot file."), $COLOR_RED)
				EndIf	
			EndIf
		Case "FoundWalls"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertUpgradeWalls = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,173, "Found Wall level") & " " & $icmbWalls + 4 & "\n" & " " & GetTranslated(620,177, "Wall segment has been located") & "...\n" & GetTranslated(620,153, "Upgrading") & "...")
		Case "SkipWalls"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertUpgradeWalls = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,174, "Cannot find Wall level") & $icmbWalls + 4 & "\n" & GetTranslated(620,154, "Skip upgrade") & "...")
		Case "AnotherDevice3600"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertAnotherDevice = 1 Then NotifyPushToBoth($NotifyOrigin & " | 1. " & GetTranslated(620,175, "Another Device has connected") & "\n" & GetTranslated(620,176, "Another Device has connected, waiting") & " " & Floor(Floor($sTimeWakeUp / 60) / 60) & " " & GetTranslated(603,14, "Hours") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice60"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertAnotherDevice = 1 Then NotifyPushToBoth($NotifyOrigin & " | 2. " & GetTranslated(620,175, "Another Device has connected") & "\n" & GetTranslated(620,176, "Another Device has connected, waiting") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertAnotherDevice = 1 Then NotifyPushToBoth($NotifyOrigin & " | 3. " & GetTranslated(620,175, "Another Device has connected") & "\n" & GetTranslated(620,176, "Another Device has connected, waiting") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "TakeBreak"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertTakeBreak = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,106, "Chief, we need some rest!") & "\n" & GetTranslated(620,107, "Village must take a break.."))
		Case "Update"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertBOTUpdate = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,129, "Chief, there is a new version of the bot available"))
		Case "BuilderIdle"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertBulderIdle = 1 Then
				Local $iAvailBldr = $iFreeBuilderCount - $iSaveWallBldr
				if $iAvailBldr > 0 Then
					if $iReportIdleBuilder <> $iAvailBldr Then
						NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,122,"You have") & " " & $iAvailBldr & " " & GetTranslated(620,123,"builder(s) idle."))
						SetLog(GetTranslated(620,122,"You have") & " " & $iAvailBldr & " " & GetTranslated(620,123,"builder(s) idle."), $COLOR_GREEN)
						$iReportIdleBuilder = $iAvailBldr
					EndIf
				Else
					$iReportIdleBuilder = 0
				EndIf
			EndIf
		Case "CocError"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertOutOfSync = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,155, "CoC Has Stopped Error") & ".....")
		Case "Pause"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyRemoteEnable = 1 And $Source = "Push" Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,166, "Request to Pause") & "..." & "\n" & GetTranslated(620,156, "Your request has been received. Bot is now paused"))
		Case "Resume"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyRemoteEnable = 1 And $Source = "Push" Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,167, "Request to Resume") & "..." & "\n" & GetTranslated(620,157, "Your request has been received. Bot is now resumed"))
		Case "OoSResources"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertOutOfSync = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,178, "Disconnected after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,104, "skip(s)") & "\n" & GetTranslated(620,158, "Cannot locate Next button, Restarting Bot") & "...")
		Case "MatchFound"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertMatchFound = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & $sModeText[$iMatchMode] & " " & GetTranslated(620,103, "Match Found! after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,104, "skip(s)") & "\n" & "[" & GetTranslated(620,109, "G") & "]: " & _NumberFormat($searchGold) & "; [" & GetTranslated(620,110, "E") & "]: " & _NumberFormat($searchElixir) & "; [" & GetTranslated(620,111, "DE") & "]: " & _NumberFormat($searchDark) & "; [" & GetTranslated(620,112, "T") & "]: " & $searchTrophy)
		Case "UpgradeWithGold"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertUpgradeWalls = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,179, "Upgrade completed by using GOLD") & "\n" & GetTranslated(620,159, "Complete by using GOLD") & "...")
		Case "UpgradeWithElixir"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertUpgradeWalls = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,180, "Upgrade completed by using ELIXIR") & "\n" & GetTranslated(620,159, "Complete by using ELIXIR") & "...")
		Case "NoUpgradeWallButton"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertUpgradeWalls = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,160, "No Upgrade Gold Button") & "\n" & GetTranslated(620,160, "Cannot find gold upgrade button") & "...")
		Case "NoUpgradeElixirButton"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertUpgradeWalls = 1 Then NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,181, "No Upgrade Elixir Button") & "\n" & GetTranslated(620,161, "Cannot find elixir upgrade button") & "...")
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion()
			If $PBRequestScreenshotHD = 1 Or $TGRequestScreenshotHD = 1 Then
				$hBitmap_Scaled = $hBitmap
			Else
				$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
			EndIf
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirTemp & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			If $PBRequestScreenshot = 1 Or $TGRequestScreenshot = 1 Then
				If $PBRequestScreenshot = 1 And $NotifyPBEnabled = 1 Then 
					NotifyPushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $NotifyOrigin & " | " & GetTranslated(620,162, "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
					SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,730,"Screenshot sent!"), $COLOR_GREEN)
				EndIf
				If $TGRequestScreenshot = 1 And $NotifyTGEnabled = 1 Then 
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $NotifyOrigin & " | " & GetTranslated(620,162, "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
					SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,730,"Screenshot sent!"), $COLOR_GREEN)
				EndIf
			EndIf
			$PBRequestScreenshot = 0
			$PBRequestScreenshotHD = 0
			$TGRequestScreenshot = 0
			$TGRequestScreenshotHD = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not $iDelete Then
				If $NotifyPBEnabled = 1 Then SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,729,"An error occurred deleting temporary screenshot file."), $COLOR_RED)
				If $NotifyTGEnabled = 1 Then SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,729,"An error occurred deleting temporary screenshot file."), $COLOR_RED)
			EndIf
		Case "BuilderInfo"
			Click(0,0, 5)
			Click(274,8)
			_Sleep (500)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(224, 74, 446, 262)
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap, $dirTemp & $Screnshotfilename)
			If $PBRequestBuilderInfo = 1 Or $TGRequestBuilderInfo = 1 Then
				If $PBRequestBuilderInfo = 1 And $NotifyPBEnabled = 1 Then
					NotifyPushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $NotifyOrigin & " | " &  "Builder Information" & "\n" & $Screnshotfilename)
					SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,731,"Builder Information sent!"), $COLOR_GREEN)
				EndIf
				If $TGRequestBuilderInfo = 1 And $NotifyTGEnabled = 1 Then 
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $NotifyOrigin & " | " &  "Builder Information" & "\n" & $Screnshotfilename)
					SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,731,"Builder Information sent!"), $COLOR_GREEN)
				EndIf
			EndIf
			$PBRequestBuilderInfo = 0
			$TGRequestBuilderInfo = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not $iDelete Then
				If $NotifyPBEnabled = 1 Then SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,729,"An error occurred deleting temporary screenshot file."), $COLOR_RED)
				If $NotifyTGEnabled = 1 Then SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,729,"An error occurred deleting temporary screenshot file."), $COLOR_RED)
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
			_GDIPlus_ImageSaveToFile($hBitmap, $dirTemp & $Screnshotfilename)
			If $PBRequestShieldInfo = 1 Or $TGRequestShieldInfo = 1 Then
				If $PBRequestShieldInfo = 1 And $NotifyPBEnabled = 1 Then
					NotifyPushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $NotifyOrigin & " | " &  "Shield Information" & "\n" & $Screnshotfilename)
					SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,732,"Shield Information sent!"), $COLOR_GREEN)
				EndIf
				If $TGRequestShieldInfo = 1 And $NotifyTGEnabled = 1 Then 
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $NotifyOrigin & " | " &  "Shield Information" & "\n" & $Screnshotfilename)
					SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,732,"Shield Information sent!"), $COLOR_GREEN)
				EndIf
			EndIf
			$PBRequestShieldInfo = 0
			$TGRequestShieldInfo = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not $iDelete Then
				If $NotifyPBEnabled = 1 Then SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,729,"An error occurred deleting temporary screenshot file."), $COLOR_RED)
				If $NotifyTGEnabled = 1 Then SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,729,"An error occurred deleting temporary screenshot file."), $COLOR_RED)
			EndIf
			Click(0,0, 5)
		Case "DeleteAllPBMessages"
			NotifyDeletePushBullet()
			If $NotifyPBEnabled = 1 Then SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,733,"All messages deleted."), $COLOR_GREEN)
			If $NotifyTGEnabled = 1 Then SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,733,"All messages deleted."), $COLOR_GREEN)
			$NotifyDeleteAllPushesNow = False ; reset value
		Case "CampFull"
			If ($NotifyPBEnabled = 1 Or $NotifyTGEnabled = 1) And $NotifyAlertCampFull = 1 Then
				NotifyPushToBoth($NotifyOrigin & " | " & GetTranslated(620,128, "Your Army Camps are now Full"))
				If $NotifyPBEnabled = 1 Then SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,128, "Your Army Camps are now Full"), $COLOR_GREEN)
				If $NotifyTGEnabled = 1 Then SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,128, "Your Army Camps are now Full"), $COLOR_GREEN)
			EndIf
		Case "Misc"
			NotifyPushToBoth($Message)
	EndSwitch
EndFunc   ;==> NotifyPushMessageToBoth

Func NotifyPushFileToBoth($File, $Folder, $FileType, $body)
	If ($NotifyPBEnabled = 0 Or $NotifyPBToken = "") And ($NotifyTGEnabled = 0 Or $NotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $NotifyPBEnabled = 1 And $NotifyPBToken <> "" Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
			$access_token = $NotifyPBToken
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
			$oHTTP.Send($pPush)
			$Result = $oHTTP.ResponseText
			Local $upload_url = _StringBetween($Result, 'upload_url":"', '"')
			Local $awsaccesskeyid = _StringBetween($Result, 'awsaccesskeyid":"', '"')
			Local $acl = _StringBetween($Result, 'acl":"', '"')
			Local $key = _StringBetween($Result, 'key":"', '"')
			Local $signature = _StringBetween($Result, 'signature":"', '"')
			Local $policy = _StringBetween($Result, 'policy":"', '"')
			Local $file_url = _StringBetween($Result, 'file_url":"', '"')
			If IsArray($upload_url) And IsArray($awsaccesskeyid) And IsArray($acl) And IsArray($key) And IsArray($signature) And IsArray($policy) Then
				$Result = RunWait($pCurl & " -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)
				$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
				$oHTTP.SetCredentials($access_token, "", 0)
				$oHTTP.SetRequestHeader("Content-Type", "application/json")
				Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $file_url[0] & '", "body": "' & $body & '"}'
				$oHTTP.Send($pPush)
			Else
				SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,726,"Unable to send file") & " " & $File, $COLOR_RED)
				NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,170, "Unable to Upload File") & "\n" & GetTranslated(620,171, "Occured an error type") & " 1 " & GetTranslated(620,144, "uploading file to PushBullet server") & "...")
			EndIf
		Else
			SetLog(GetTranslated(620,700,"Notify PushBullet") & ": " & GetTranslated(620,726,"Unable to send file") & " " & $File, $COLOR_RED)
			NotifyPushToPushBullet($NotifyOrigin & " | " & GetTranslated(620,170, "Unable to Upload File") & "\n" & GetTranslated(620,171, "Occured an error type") & " 2 " & GetTranslated(620,144, "uploading file to PushBullet server") & "...")
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

	;Telegram ---------------------------------------------------------------------------------
	If $NotifyTGEnabled = 1 And $NotifyTGToken <> ""  Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then

			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $NotifyTGToken & "/sendPhoto"
			$Result = RunWait($pCurl & " -i -X POST " & $telegram_url & ' -F chat_id="' & $TGChatID &' " -F photo=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File  & '"', "", @SW_HIDE)
			$oHTTP.Open("Post", "https://api.telegram.org/bot" & $NotifyTGToken & "/sendPhoto", False)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP.Send($pPush)
		Else
			SetLog(GetTranslated(620,701,"Notify Telegram") & ": " & GetTranslated(620,726,"Unable to send file") & " " & $File, $COLOR_RED)
			NotifyPushToTelegram($NotifyOrigin & " | " & GetTranslated(620,170,"Unable to Upload File") & "\n" & GetTranslated(620,146,"Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==> NotifyPushFileToBoth
; Both ---------------------------------
