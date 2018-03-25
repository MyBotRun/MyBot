; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This function will notify events and allow remote control of your bot on your mobile phone
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Full revamp of Notify by IceCube (2016-09)
; Modified ......: IceCube (2016-12) v1.5.1, CodeSLinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;GUI --------------------------------------------------------------------------------------------------
Func NotifyRemoteControl()
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyRemoteControl()")
	If $g_bNotifyRemoteEnable = True Then NotifyRemoteControlProc()
EndFunc   ;==>NotifyRemoteControl

Func NotifyReport()
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyReport()")
	If $g_bNotifyAlertVillageReport = True Then
		NotifylPushBulletMessage($g_sNotifyOrigin & ":" & "\n" & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & "  [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootTrophy]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Free-Builders_Info_01", "No. of Free Builders") & "]: " & _NumberFormat($g_iFreeBuilderCount))
	EndIf
	If $g_bNotifyAlertLastAttack = True Then
		If Not ($g_iStatsLastAttack[$eLootGold] = "" And $g_iStatsLastAttack[$eLootElixir] = "") Then NotifylPushBulletMessage($g_sNotifyOrigin & " | Last Gain :" & "\n" & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & "  [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootTrophy]))
	EndIf
	If _Sleep($DELAYNOTIFY1) Then Return
	checkMainScreen(False)
EndFunc   ;==>NotifyReport

Func _DeletePush()
	If $g_bDebugSetlog Then SetDebugLog("Notify | _DeletePush()")
	NotifyDeletePushBullet()
	SetLog("Delete all previous PushBullet messages...", $COLOR_INFO)
EndFunc   ;==>_DeletePush

Func PushMsg($Message, $Source = "")
	If $g_bDebugSetlog Then SetDebugLog("Notify | PushMsg()")
	NotifyPushMessageToBoth($Message, $Source)
EndFunc   ;==>PushMsg

Func _DeleteOldPushes()
	If $g_bDebugSetlog Then SetDebugLog("Notify | _DeleteOldPushes()")
	NotifyDeleteOldPushesFromPushBullet()
EndFunc   ;==>_DeleteOldPushes
;GUI --------------------------------------------------------------------------------------------------

;MISC --------------------------------------------------------------------------------------------------
Func _GetDateFromUnix($nPosix)
	If $g_bDebugSetlog Then SetDebugLog("Notify | _GetDateFromUnix($nPosix): " & $nPosix)
	Local $nYear = 1970, $nMon = 1, $nDay = 1, $nHour = 00, $nMin = 00, $nSec = 00, $aNumDays = StringSplit("31,28,31,30,31,30,31,31,30,31,30,31", ",")
	While 1
		If (Mod($nYear + 1, 400) = 0) Or (Mod($nYear + 1, 4) = 0 And Mod($nYear + 1, 100) <> 0) Then ; is leap year
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
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyPendingActions()")
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

;~ ; PushBullet ---------------------------------
;~ Func PushBulletRemoteControl()
;~ 	If $g_bDebugSetlog then SetDebugLog("Notify | PushBulletRemoteControl()")
;~ 	If ($g_bNotifyPBEnable = True) And $g_bNotifyRemoteEnable = True Then NotifyRemoteControlProc()
;~ EndFunc   ;==>PushBulletRemoteControl

Func PushBulletDeleteOldPushes()
	If $g_bDebugSetlog Then SetDebugLog("Notify | PushBulletDeleteOldPushes()")
	If $g_bNotifyPBEnable = True And $g_bNotifyDeletePushesOlderThan = True Then _DeleteOldPushes() ; check every 30 min if must delete old pushbullet messages, increase delay time for anti ban pushbullet
EndFunc   ;==>PushBulletDeleteOldPushes

Func NotifylPushBulletMessage($pMessage = "")
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifylPushBulletMessage($pMessage): " & $pMessage)
	If (Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "") And (Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "") Then Return

	If Not $g_bNotifyForced Then
		If $g_bNotifyScheduleWeekDaysEnable Then
			If $g_abNotifyScheduleWeekDays[@WDAY - 1] Then
				If $g_bNotifyScheduleHoursEnable Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If Not $g_abNotifyScheduleHours[$hour[0]] Then
						SetLog("Notify not planned for this hour! Notification skipped", $COLOR_ORANGE)
						SetLog($pMessage, $COLOR_WARNING)
						Return ; exit func if no planned
					EndIf
				EndIf
			Else
				;SetLog("Notify not planned to: " & _DateDayOfWeek(@WDAY), $COLOR_ORANGE)
				;SetLog($pMessage, $COLOR_ORANGE)
				Return ; exit func if not planned
			EndIf
		Else
			If $g_bNotifyScheduleHoursEnable Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If Not $g_abNotifyScheduleHours[$hour[0]] Then
					SetLog("Notify not planned for this hour! Notification skipped", $COLOR_ORANGE)
					SetLog($pMessage, $COLOR_WARNING)
					Return ; exit func if no planned
				EndIf
			EndIf
		EndIf
	EndIf

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable And $g_sNotifyPBToken <> "" Then
		$g_bNotifyForced = False

		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		If @error Then
			SetLog("PushBullet Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
			Return
		EndIf

		$oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
		$oHTTP.SetCredentials($g_sNotifyPBToken, "", 0)
		$oHTTP.Send()
		$oHTTP.WaitForResponse
		Local $Result = $oHTTP.ResponseText
		If $oHTTP.Status <> 200 Then
			SetLog("PushBullet status is: " & $oHTTP.Status, $COLOR_ERROR)
			Return
		EndIf
		Local $g_sAnotherDevice_iden = _StringBetween($Result, 'iden":"', '"')
		Local $g_sAnotherDevice_name = _StringBetween($Result, 'nickname":"', '"')
		Local $g_sAnotherDevice = ""
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
	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then

		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		If @error Then
			SetLog("Telegram Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
			Return
		EndIf
		$oHTTP.Open("Get", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/getupdates", False)
		$oHTTP.Send()
		$oHTTP.WaitForResponse
		Local $Result = $oHTTP.ResponseText
		If $oHTTP.Status <> 200 Then
			SetLog("Telegram status is: " & $oHTTP.Status, $COLOR_ERROR)
			Return
		EndIf
		Local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
		$g_sTGChatID = _ArrayPop($chat_id)
		$oHTTP.Open("Post", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/sendmessage", False)
		$oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")
		Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		Local $Time = @HOUR & '.' & @MIN
		Local $TGPushMsg = '{"text":"' & $pMessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $g_sTGChatID & '}}'
		$oHTTP.Send($TGPushMsg)
		$oHTTP.WaitForResponse
	EndIf
	;Telegram ---------------------------------------------------------------------------------

EndFunc   ;==>NotifylPushBulletMessage

Func NotifyPushToPushBullet($pMessage)
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyPushToPushBullet($pMessage): " & $pMessage)
	If (Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "") And (Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable And $g_sNotifyPBToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		If @error Then
			SetLog("PushBullet Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
			Return
		EndIf
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		Local $access_token = $g_sNotifyPBToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
		$oHTTP.WaitForResponse
	EndIf
	;PushBullet ---------------------------------------------------------------------------------
EndFunc   ;==>NotifyPushToPushBullet

Func NotifyDeletePushBullet()
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyDeletePushBullet()")
	If Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	If @error Then
		SetLog("PushBullet Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
		Return
	EndIf
	$oHTTP.Open("DELETE", "https://api.pushbullet.com/v2/pushes", False)
	Local $access_token = $g_sNotifyPBToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$oHTTP.WaitForResponse
EndFunc   ;==>NotifyDeletePushBullet

Func NotifyDeleteMessageFromPushBullet($iden)
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyDeleteMessageFromPushBullet($iden): " & $iden)
	If Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	If @error Then
		SetLog("PushBullet Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
		Return
	EndIf
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes/" & $iden, False)
	Local $access_token = $g_sNotifyPBToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$oHTTP.WaitForResponse
	$iden = ""
EndFunc   ;==>NotifyDeleteMessageFromPushBullet

Func NotifyDeleteOldPushesFromPushBullet()
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyDeleteOldPushesFromPushBullet()")
	If Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "" Or Not $g_bNotifyDeletePushesOlderThan Then Return
	;Local UTC time
	Local $tLocal = _Date_Time_GetLocalTime()
	Local $tSystem = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($tLocal))
	Local $timeUTC = _Date_Time_SystemTimeToDateTimeStr($tSystem, 1)
	Local $timestamplimit = 0
	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	If @error Then
		SetLog("PushBullet Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
		Return
	EndIf
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $timestamplimit, False)
	Local $access_token = $g_sNotifyPBToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$oHTTP.WaitForResponse
	Local $Result = $oHTTP.ResponseText
	If $oHTTP.Status <> 200 Then
		SetLog("PushBullet status is: " & $oHTTP.Status, $COLOR_ERROR)
		Return
	EndIf
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
		SetLog("Notify PushBullet: removed " & $msgdeleted & " messages older than " & $g_iNotifyDeletePushesOlderThanHours & " h ", $COLOR_SUCCESS)
	EndIf
EndFunc   ;==>NotifyDeleteOldPushesFromPushBullet

Func NotifyPushFileToPushBullet($File, $Folder, $FileType, $body)
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyPushFileToPushBullet($File, $Folder, $FileType, $body): " & $File & "," & $Folder & "," & $FileType & "," & $body)
	If (Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "") And (Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable = True And $g_sNotifyPBToken <> "" Then
		If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then
			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			If @error Then
				SetLog("PushBullet Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
				Return
			EndIf
			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
			Local $access_token = $g_sNotifyPBToken
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
			$oHTTP.Send($pPush)
			$oHTTP.WaitForResponse
			Local $Result = $oHTTP.ResponseText
			If $oHTTP.Status <> 200 Then
				SetLog("PushBullet status is: " & $oHTTP.Status, $COLOR_ERROR)
				Return
			EndIf
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
				SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_ERROR)
				NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_03", "Unable to Upload File") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_04", "Occured an error type") & " 1 " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_01", "uploading file to PushBullet server") & "...")
			EndIf
		Else
			SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_ERROR)
			NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_03", "Unable to Upload File") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_04", "Occured an error type") & " 2 " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_01", "uploading file to PushBullet server") & "...")
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

EndFunc   ;==>NotifyPushFileToPushBullet
; PushBullet ---------------------------------

; Telegram ---------------------------------
Func NotifyPushToTelegram($pMessage)

	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyPushToTelegram($pMessage): " & $pMessage)

	If (Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "") And (Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "") Then Return

	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then

		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		If @error Then
			SetLog("Telegram Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
			Return
		EndIf
		Local $url = "https://api.telegram.org/bot"
		$oHTTP.Open("Post", $url & $g_sNotifyTGToken & "/sendMessage", False)
		$oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

		Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		Local $Time = @HOUR & '.' & @MIN
		Local $TGPushMsg = '{"text":"' & $pMessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $g_sTGChatID & '}}'
		$oHTTP.Send($TGPushMsg)
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==>NotifyPushToTelegram

Func NotifyPushFileToTelegram($File, $Folder, $FileType, $body)

	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyPushFileToTelegram($File, $Folder, $FileType, $body): " & $File & "," & $Folder & "," & $FileType & "," & $body)

	If (Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "") And (Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "") Then Return

	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then
		If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then
			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			If @error Then
				SetLog("Telegram Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
				Return
			EndIf
			Local $sCmd = "/sendPhoto"
			Local $sCmd1 = "photo"
			If $FileType = "text\/plain; charset=utf-8" Then
				$sCmd = "/sendDocument"
				$sCmd1 = "document"
			EndIf
			Local $telegram_url = "https://api.telegram.org/bot" & $g_sNotifyTGToken & $sCmd
			Local $Result = RunWait($g_sCurlPath & " -i -X POST " & $telegram_url & ' -F chat_id="' & $g_sTGChatID & '" -F ' & $sCmd1 & '=@"' & $g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)
			$oHTTP.Open("Post", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/sendMessage", False)
			$oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")
			Local $pPush = '{"text":"' & $body & '", "chat_id":' & $g_sTGChatID & '}}'
			$oHTTP.Send($pPush)
			$oHTTP.WaitForResponse
			If $g_bDebugSetlog Then SetDebugLog("$oHTTP.ResponseText: " & $oHTTP.ResponseText)
		Else
			SetLog("Notify Telegram: Unable to send file " & $File, $COLOR_ERROR)
			NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_03", "Unable to Upload File") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_02", "Occured an error type 2 uploading file to Telegram server..."))
		EndIf

	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==>NotifyPushFileToTelegram

Func NotifyGetLastMessageFromTelegram()
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyGetLastMessageFromTelegram()")

	Local $TGLastMessage = ""
	If Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	If @error Then
		SetLog("Telegram Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
		Return
	EndIf

	$oHTTP.Open("Get", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/getupdates", False)
	$oHTTP.Send()
	$oHTTP.WaitForResponse
	Local $Result = $oHTTP.ResponseText
	If $oHTTP.Status <> 200 Then
		SetLog("Telegram status is: " & $oHTTP.Status, $COLOR_ERROR)
		Return
	EndIf

	Local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
	$g_sTGChatID = _ArrayPop($chat_id)
	If $g_bDebugSetlog Then SetDebugLog("Telegram $g_sTGChatID:" & $g_sTGChatID)

	Local $uid = _StringBetween($Result, 'update_id":', '"message"') ;take update id
	$g_sTGLast_UID = StringTrimRight(_ArrayPop($uid), 2)

	Local $findstr2 = StringRegExp(StringUpper($Result), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result, 'text":"', '"}}') ;take message
		$TGLastMessage = _ArrayPop($rmessage) ;take last message
		If $g_bDebugSetlog Then SetDebugLog("Telegram $TGLastMessage:" & $TGLastMessage)
	EndIf

	;If $g_bFirstStart then $g_iTGLastRemote = $g_sTGLast_UID

	If $g_bDebugSetlog Then SetDebugLog("Telegram $g_sTGLast_UID:" & $g_sTGLast_UID)

	$oHTTP.Open("Get", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/getupdates?offset=" & $g_sTGLast_UID, False)
	$oHTTP.Send()
	$oHTTP.WaitForResponse
	Local $Result2 = $oHTTP.ResponseText
	If $oHTTP.Status <> 200 Then
		SetLog("Telegram status is: " & $oHTTP.Status, $COLOR_ERROR)
		Return
	EndIf
	Local $findstr2 = StringRegExp(StringUpper($Result2), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result2, 'text":"', '"}}') ;take message
		$TGLastMessage = _ArrayPop($rmessage) ;take last message
		If $TGLastMessage = "" Then
			Local $rmessage = _StringBetween($Result2, 'text":"', '","entities"') ;take message
			$TGLastMessage = _ArrayPop($rmessage) ;take last message
		EndIf
		If $g_bDebugSetlog Then SetDebugLog("Telegram - $TGLastMessage:" & $TGLastMessage)
		Return $TGLastMessage
	EndIf

EndFunc   ;==>NotifyGetLastMessageFromTelegram

Func _IsInternet() ; Checking the connection of the card to the Internet
	Local $Ret = DllCall('wininet.dll', 'int', 'InternetGetConnectedState', 'dword*', 0x20, 'dword', 0)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Local $Error = _WinAPI_GetLastError()
	Return SetError((Not ($Error = 0)), $Error, $Ret[0])
EndFunc   ;==>_IsInternet

Func NotifyGetLastMessageFromTelegramBtnStart()
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyGetLastMessageFromTelegramBtnStart()")

	Local $TGLastMessage = ""
	If Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "" Then Return

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	If @error Then
		SetLog("Telegram Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
		Return
	EndIf

	$oHTTP.Open("Get", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/getupdates", False)
	Execute('$oHTTP.Send()')
	$oHTTP.WaitForResponse
	Local $Result = Execute('$oHTTP.ResponseText')
	Local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
	$g_sTGChatID = _ArrayPop($chat_id)
	If $g_bDebugSetlog Then SetDebugLog("Telegram $g_sTGChatID:" & $g_sTGChatID)

	Local $uid = _StringBetween($Result, 'update_id":', '"message"') ;take update id
	$g_sTGLast_UID = StringTrimRight(_ArrayPop($uid), 2)

	Local $findstr2 = StringRegExp(StringUpper($Result), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result, 'text":"', '"}}') ;take message
		$TGLastMessage = _ArrayPop($rmessage) ;take last message
		If $g_bDebugSetlog Then SetDebugLog("Telegram $TGLastMessage:" & $TGLastMessage)
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("Telegram $g_sTGLast_UID:" & $g_sTGLast_UID)

	$oHTTP.Open("Get", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/getupdates?offset=" & $g_sTGLast_UID, False)
	Execute('$oHTTP.Send()')
	$oHTTP.WaitForResponse
	Local $Result2 = Execute('$oHTTP.ResponseText')

	If _IsInternet() < 1 Then
		SetLog("Telegram: Check your internet connection! No Connection..", $COLOR_ERROR)
		Return
	EndIf

	Local $findstr2 = StringRegExp(StringUpper($Result2), '"TEXT":"')
	If $findstr2 = 1 Then
		Local $rmessage = _StringBetween($Result2, 'text":"', '"}}') ;take message
		$TGLastMessage = _ArrayPop($rmessage) ;take last message
		If $TGLastMessage = "" Then
			Local $rmessage = _StringBetween($Result2, 'text":"', '","entities"') ;take message
			$TGLastMessage = _ArrayPop($rmessage) ;take last message
		EndIf
		If $g_bDebugSetlog Then SetDebugLog("Telegram - $TGLastMessage:" & $TGLastMessage)
		Return $TGLastMessage
	EndIf

EndFunc   ;==>NotifyGetLastMessageFromTelegramBtnStart

Func NotifyActivateKeyboardOnTelegram($TGMsg)
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyActivateKeyboardOnTelegram($TGMsg): " & $TGMsg)

	Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	If @error Then
		SetLog("Telegram Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
		Return
	EndIf
	Local $url = "https://api.telegram.org/bot"
	$oHTTP.Open("Post", $url & $g_sNotifyTGToken & "/sendMessage", False)
	$oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

	Local $TGPushMsg = '{"text": "' & $TGMsg & '", "chat_id":' & $g_sTGChatID & ', "reply_markup": {"keyboard": [["' & _
			'\ud83d\udcf7 ' & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT") & '","' & _
			'\ud83d\udd28 ' & GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER") & '","' & _
			'\ud83d\udd30 ' & GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD") & '"],["' & _
			'\ud83d\udcc8 ' & GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS") & '","' & _
			'\ud83d\udcaa ' & GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS") & '","' & _
			'\u2753 ' & GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP") & '"],["' & _
			'\u25aa ' & GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP") & '","' & _
			'\u25b6 ' & GetTranslatedFileIni("MBR Func_Notify", "START", "START") & '","' & _
			'\ud83d\udd00 ' & GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE") & '","' & _
			'\u25b6 ' & GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME") & '","' & _
			'\ud83d\udd01 ' & GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART") & '"],["' & _
			'\ud83d\udccb ' & GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG") & '","' & _
			'\ud83c\udf04 ' & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID") & '","' & _
			'\ud83d\udcc4 ' & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT") & '"],["' & _
			'\u2705 ' & GetTranslatedFileIni("MBR Func_Notify", "ATTACK ON_Info_01", "ATTACK ON") & '","' & _
			'\u274C ' & GetTranslatedFileIni("MBR Func_Notify", "ATTACK OFF", "ATTACK OFF") & '"],["' & _
			'\ud83d\udca4 ' & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE") & '","' & _
			'\u26a1 ' & GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN") & '","' & _
			'\ud83d\udd06 ' & GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY") & '"]],"one_time_keyboard": false,"resize_keyboard":true}}'
	$oHTTP.Send($TGPushMsg)

	$g_iTGLastRemote = $g_sTGLast_UID

EndFunc   ;==>NotifyActivateKeyboardOnTelegram

Func NotifyRemoteControlProcBtnStart()
	Local $bWasSilent = SetDebugLogSilent()
	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then
		$g_sTGLastMessage = NotifyGetLastMessageFromTelegramBtnStart()
		Local $TGActionMSG = StringUpper(StringStripWS($g_sTGLastMessage, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message
		If $g_bDebugSetlog Then SetDebugLog("Telegram | NotifyRemoteControlProcBtnStart $TGActionMSG : " & $TGActionMSG)
		If $g_bDebugSetlog Then SetDebugLog("Telegram | NotifyRemoteControlProcBtnStart $g_iTGLastRemote : " & $g_iTGLastRemote)
		If $g_bDebugSetlog Then SetDebugLog("Telegram | NotifyRemoteControlProcBtnStart $g_sTGLast_UID : " & $g_sTGLast_UID)
		If $g_iTGLastRemote <> $g_sTGLast_UID Then
			$g_iTGLastRemote = $g_sTGLast_UID

			Switch $TGActionMSG
				Case GetTranslatedFileIni("MBR Func_Notify", "START", "START"), '\u25b6 ' & GetTranslatedFileIni("MBR Func_Notify", "START", "START")
					btnStart()
					NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_01", "Request to Start...") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_02", "Your bot is now started..."))
			EndSwitch
		EndIf
	EndIf
	SetDebugLogSilent($bWasSilent)
EndFunc   ;==>NotifyRemoteControlProcBtnStart
; Telegram ---------------------------------


; Both ---------------------------------
Func NotifyRemoteControlProc()
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyRemoteControlProc()")
	Static $pushLastModified = 0

	If (Not $g_bNotifyPBEnable And Not $g_bNotifyTGEnable) Or Not $g_bNotifyRemoteEnable Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable And $g_sNotifyPBToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		If @error Then
			SetLog("Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
			Return
		EndIf
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
		$oHTTP.WaitForResponse
		Local $Result = $oHTTP.ResponseText
		If $oHTTP.Status <> 200 Then
			SetLog("PushBullet status is: " & $oHTTP.Status, $COLOR_ERROR)
			Return
		EndIf

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
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", "BOT") & " " & GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP")
							Local $txtHelp = "PushBullet " & GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP") & " " & GetTranslatedFileIni("MBR Func_Notify", "Bot_Info_01", "- You can remotely control your bot sending COMMANDS from the following list:")
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & GetTranslatedFileIni("MBR Func_Notify", "HELP", -1) & " " & GetTranslatedFileIni("MBR Func_Notify", "HELP_Info_01", "- send this help message")
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & GetTranslatedFileIni("MBR Func_Notify", "DELETE", "DELETE") & " " & GetTranslatedFileIni("MBR Func_Notify", "DELETE_Info_01", "- delete all your previous PushBullet messages")
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART") & " " & GetTranslatedFileIni("MBR Func_Notify", "RESTART_Info_01", "- restart the Emulator and bot named") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP") & " " & GetTranslatedFileIni("MBR Func_Notify", "STOP_Info_01", "- stop the bot named") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE") & " " & GetTranslatedFileIni("MBR Func_Notify", "PAUSE_Info_01", "- pause the bot named") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME") & " " & GetTranslatedFileIni("MBR Func_Notify", "RESUME_Info_01", "- resume the bot named") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS") & " " & GetTranslatedFileIni("MBR Func_Notify", "STATS_Info_01", "- send Village Statistics of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG") & " " & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_01", "- send the current log file of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID") & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID_Info_01", "- send the last raid loot screenshot of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT") & " " & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT_Info_01", "- send the last raid loot values of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT") & " " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_01", "- send a screenshot of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD", "SCREENSHOTHD") & " " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD_Info_01", "- send a screenshot in high resolution of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER") & " " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER_Info_01", "- send a screenshot of builder status of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD") & " " & GetTranslatedFileIni("MBR Func_Notify", "SHIELD_Info_01", "- send a screenshot of shield status of") & " <" & $g_sNotifyOrigin & ">"
							$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS", "RESETSTATS") & " " & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS_Info_01", "- reset Village Statistics")
							$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS") & " " & GetTranslatedFileIni("MBR Func_Notify", "TROOPS_Info_01", "- send Troops & Spells Stats")
							$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKON", "HALTATTACKON") & " " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK OFF_Info_01", "- Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
							$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKOFF", "HALTATTACKOFF") & " " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK ON_Info_01", "- Turn Off 'Halt Attack' in the 'Misc' Tab")
							$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE") & " " & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE_Info_01", "- Hibernate host PC")
							$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN") & " " & GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN_Info_01", "- Shut down host PC")
							$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " <" & $g_sNotifyOrigin & "> " & GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY") & " " & GetTranslatedFileIni("MBR Func_Notify", "STANDBY_Info_01", "- Standby host PC")
							$txtHelp &= '\n'
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Examples", "Examples:")
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & $g_sNotifyOrigin & " " & GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS")
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER")
							$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & $g_sNotifyOrigin & " " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD", "SCREENSHOTHD")
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-For-Help_Info_02", "Request for Help") & "\n" & $txtHelp)
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Help has been sent", $COLOR_SUCCESS)
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & GetTranslatedFileIni("MBR Func_Notify", "DELETE", "DELETE")
							NotifyDeletePushBullet()
							SetLog("Notify PushBullet: Your request has been received.", $COLOR_SUCCESS)
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART")
							NotifyDeleteMessageFromPushBullet($iden[$x])
							SetLog("Notify PushBullet: Your request has been received. Bot and Android Emulator restarting...", $COLOR_SUCCESS)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_16", "Request to Restart") & "...\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_05", "Your bot and Emulator are now restarting") & "...")
							SaveConfig()
							RestartBot()
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP")
							NotifyDeleteMessageFromPushBullet($iden[$x])
							SetLog("Notify PushBullet: Your request has been received. Bot is now stopped", $COLOR_SUCCESS)
							If $g_bRunState = True Then
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_01", "Request to Stop") & "..." & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_06", "Your bot is now stopping") & "...")
								btnStop()
							Else
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_01", "Request to Stop") & "..." & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_07", "Your bot is currently stopped, no action was taken"))
							EndIf
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE")
							If $g_bBotPaused = False And $g_bRunState = True Then
								If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
									SetLog("Notify PushBullet: Unable to pause during attack", $COLOR_RED)
									NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_17", "Request to Pause") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_15", "Unable to pause during attack, try again later."))
								ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
									ReturnHome(False, False)
									$g_bIsSearchLimit = True
									$g_bIsClientSyncError = False
									UpdateStats()
									$g_bRestart = True
									TogglePauseImpl("Push")
								Else
									TogglePauseImpl("Push")
								EndIf
							Else
								SetLog("Notify PushBullet: Your bot is currently paused, no action was taken", $COLOR_SUCCESS)
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_17", "Request to Pause") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_11", "Your bot is currently paused, no action was taken"))
							EndIf
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME")
							If $g_bBotPaused = True And $g_bRunState = True Then
								TogglePauseImpl("Push")
							Else
								SetLog("Notify PushBullet: Your bot is currently resumed, no action was taken", $COLOR_SUCCESS)
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_18", "Request to Resume") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Resumed_Info_01", "Your bot is currently resumed, no action was taken"))
							EndIf
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS")
							SetLog("Notify PushBullet: Your request has been received. Statistics sent", $COLOR_SUCCESS)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_02", "Stats Village Report") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_05", "At Start") & "\n[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsStartedWith[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsStartedWith[$eLootElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_iStatsStartedWith[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsStartedWith[$eLootTrophy] & "\n\n" & GetTranslatedFileIni("MBR Func_Notify", "Stats-Now_Info_01", "Now (Current Resources)") & "\n[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_aiCurrentLoot[$eLootTrophy] & " [" & GetTranslatedFileIni("MBR Func_Notify", "GEM_Info_01", "GEM") & "]: " & $g_iGemAmount & "\n \n [" & GetTranslatedFileIni("MBR Func_Notify", "Free-Builders_Info_01", "No. of Free Builders") & "]: " & $g_iFreeBuilderCount & "\n [" & GetTranslatedFileIni("MBR Func_Notify", "Wall-Up_Info_01", "No. of Wall Up") & "]: " & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & ": " & $g_iNbrOfWallsUppedGold & "/ " & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & ": " & $g_iNbrOfWallsUppedElixir & "\n\n" & GetTranslatedFileIni("MBR Func_Notify", "Attack_Info_01", "Attacked") & ": " & $g_aiAttackedCount & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Skip_Info_02", "Skipped") & ": " & $g_iSkippedVillageCount)
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG")
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Log is now sent", $COLOR_SUCCESS)
							NotifyPushFileToPushBullet($g_sLogFileName, GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_02", "logs"), "text/plain; charset=utf-8", $g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_03", "Current Log") & " \n")
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID")
							If $g_sAttackFile <> "" Then
								SetLog("Notify PushBullet: Push Last Raid Snapshot...", $COLOR_SUCCESS)
								NotifyPushFileToPushBullet($g_sAttackFile, GetTranslatedFileIni("MBR Func_Notify", "Loots_Info_01", "Loots"), "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_01", "Last Raid") & " \n" & $g_sAttackFile)
							Else
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_02", "There is no last raid screenshot") & ".")
								SetLog("There is no last raid screenshot.")
								SetLog("Notify PushBullet: Your request has been received. Last Raid txt sent", $COLOR_SUCCESS)
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_02", "Last Raid txt") & "\n" & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
							EndIf
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT")
							SetLog("Notify PushBullet: Your request has been received. Last Raid txt sent", $COLOR_SUCCESS)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_02", "Last Raid txt") & "\n" & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT")
							SetLog("Notify PushBullet: ScreenShot request received", $COLOR_SUCCESS)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_03", "Chief, your request for Screenshot will be processed ASAP"))
							$g_bPBRequestScreenshot = True
							$g_bNotifyForced = False
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD", "SCREENSHOTHD")
							SetLog("Notify PushBullet: ScreenShot HD request received", $COLOR_SUCCESS)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_03", "Chief, your request for Screenshot will be processed ASAP"))
							$g_bPBRequestScreenshot = True
							$g_bPBRequestScreenshotHD = True
							$g_bNotifyForced = False
							NotifyDeleteMessageFromPushBullet($iden[$x])
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER")
							SetLog("Notify PushBullet: Builder Status request received", $COLOR_SUCCESS)
							$g_bPBRequestBuilderInfo = True
							NotifyDeleteMessageFromPushBullet($iden[$x])
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER_Info_04", "Chief, your request for Builder Info will be processed ASAP"))
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD")
							SetLog("Notify PushBullet: Shield Status request received", $COLOR_SUCCESS)
							$g_bPBRequestShieldInfo = True
							$g_bNotifyForced = False
							NotifyDeleteMessageFromPushBullet($iden[$x])
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SHIELD_Info_02", "Chief, your request for Shield Info will be processed ASAP"))
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS", "RESETSTATS")
							btnResetStats()
							SetLog("Notify PushBullet: Your request has been received. Statistics resetted", $COLOR_SUCCESS)
							NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS_Info_02", "Statistics resetted."))
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS")
							SetLog("Notify PushBullet: Your request has been received. Sending Troop/Spell Stats...", $COLOR_SUCCESS)
							Local $txtTroopStats = " | " & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_01", "Troops/Spells set to Train") & ":\n" & _
									"Barbs:" & $g_aiArmyCompTroops[$eTroopBarbarian] & " Arch:" & $g_aiArmyCompTroops[$eTroopArcher] & " Gobl:" & $g_aiArmyCompTroops[$eTroopGoblin] & "\n" & _
									"Giant:" & $g_aiArmyCompTroops[$eTroopGiant] & " WallB:" & $g_aiArmyCompTroops[$eTroopWallBreaker] & " Wiza:" & $g_aiArmyCompTroops[$eTroopWizard] & "\n" & _
									"Balloon:" & $g_aiArmyCompTroops[$eTroopBalloon] & " Heal:" & $g_aiArmyCompTroops[$eTroopHealer] & " Dragon:" & $g_aiArmyCompTroops[$eTroopDragon] & " Pekka:" & $g_aiArmyCompTroops[$eTroopPekka] & "\n" & _
									"Mini:" & $g_aiArmyCompTroops[$eTroopMinion] & " Hogs:" & $g_aiArmyCompTroops[$eTroopHogRider] & " Valks:" & $g_aiArmyCompTroops[$eTroopValkyrie] & "\n" & _
									"Golem:" & $g_aiArmyCompTroops[$eTroopGolem] & " Witch:" & $g_aiArmyCompTroops[$eTroopWitch] & " Lava:" & $g_aiArmyCompTroops[$eTroopLavaHound] & "\n" & _
									"LSpell:" & $g_aiArmyCompSpells[$eSpellLightning] & " HeSpell:" & $g_aiArmyCompSpells[$eSpellHeal] & " RSpell:" & $g_aiArmyCompSpells[$eSpellRage] & " JSpell:" & $g_aiArmyCompSpells[$eSpellJump] & "\n" & _
									"FSpell:" & $g_aiArmyCompSpells[$eSpellFreeze] & " PSpell:" & $g_aiArmyCompSpells[$eSpellPoison] & " ESpell:" & $g_aiArmyCompSpells[$eSpellEarthquake] & " HaSpell:" & $g_aiArmyCompSpells[$eSpellHaste] & "\n"
							$txtTroopStats &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_02", "Current Trained Troops & Spells") & ":"
							$txtTroopStats &= "\n\n" & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_03", "Current Army Camp") & ": " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace
							NotifyPushToPushBullet($g_sNotifyOrigin & $txtTroopStats)
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKON", "HALTATTACKON")
							GUICtrlSetState($g_hChkBotStop, $GUI_CHECKED)
							btnStop()
							$g_bChkBotStop = True ; set halt attack variable
							$g_iCmbBotCond = 18 ; set stay online
							btnStart()
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKOFF", "HALTATTACKOFF")
							GUICtrlSetState($g_hChkBotStop, $GUI_UNCHECKED)
							btnStop()
							btnStart()
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE")
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Hibernate PC", $COLOR_SUCCESS)
							NotifyPushToPushBullet(GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE_Info_02", "PC Hibernate sequence initiated"))
							Shutdown(64)
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN")
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Shutdown PC", $COLOR_SUCCESS)
							NotifyPushToPushBullet(GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN_Info_02", "PC Shutdown sequence initiated"))
							Shutdown(5)
						Case GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY")
							SetLog("Notify PushBullet: Your request has been received from " & $g_sNotifyOrigin & ". Standby PC", $COLOR_SUCCESS)
							NotifyPushToPushBullet(GetTranslatedFileIni("MBR Func_Notify", "STANDBY_Info_02", "PC Standby sequence initiated"))
							Shutdown(32)
						Case Else
							Local $lenstr = StringLen(GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & "")
							Local $teststr = StringLeft($body[$x], $lenstr)
							If $teststr = (GetTranslatedFileIni("MBR Func_Notify", "Bot", -1) & " " & StringUpper($g_sNotifyOrigin) & " " & "") Then
								SetLog("Notify PushBullet: received command syntax wrong, command ignored.", $COLOR_ERROR)
								NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Command-Not-Recognized", "Command not recognized") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-For-Help_Info_01", "Please push BOT HELP to obtain a complete command list."))
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
	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" And $g_bRunState Then
		$g_sTGLastMessage = NotifyGetLastMessageFromTelegram()
		Local $TGActionMSG = StringUpper(StringStripWS($g_sTGLastMessage, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message
		If $g_bDebugSetlog Then SetDebugLog("Telegram | NotifyRemoteControlProc $TGActionMSG : " & $TGActionMSG)
		If $g_bDebugSetlog Then SetDebugLog("Telegram | NotifyRemoteControlProc $g_iTGLastRemote : " & $g_iTGLastRemote)
		If $g_bDebugSetlog Then SetDebugLog("Telegram | NotifyRemoteControlProc $g_sTGLast_UID : " & $g_sTGLast_UID)
		If ($TGActionMSG = "/START" Or $TGActionMSG = "KEYB") And $g_iTGLastRemote <> $g_sTGLast_UID Then
			$g_iTGLastRemote = $g_sTGLast_UID
			NotifyActivateKeyboardOnTelegram($g_sBotTitle & " | Notify " & $g_sNotifyVersion)
		Else
			If $g_iTGLastRemote <> $g_sTGLast_UID Then
				$g_iTGLastRemote = $g_sTGLast_UID
				Switch $TGActionMSG
					Case GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP"), '\U2753 ' & GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP")
						Local $txtHelp = "Telegram " & GetTranslatedFileIni("MBR Func_Notify", "HELP", "HELP") & " " & GetTranslatedFileIni("MBR Func_Notify", "Bot_Info_01", "- You can remotely control your bot sending COMMANDS from the following list:")
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "HELP", -1) & " " & GetTranslatedFileIni("MBR Func_Notify", "HELP_Info_01", "- send this help message")
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART") & " " & GetTranslatedFileIni("MBR Func_Notify", "RESTART_Info_01", "- restart the Emulator and bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "START", "START") & " " & GetTranslatedFileIni("MBR Func_Notify", "START_Info_01", "- start the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP") & " " & GetTranslatedFileIni("MBR Func_Notify", "STOP_Info_01", "- stop the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE") & " " & GetTranslatedFileIni("MBR Func_Notify", "PAUSE_Info_01", "- pause the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME") & " " & GetTranslatedFileIni("MBR Func_Notify", "RESUME_Info_01", "- resume the bot named") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS") & " " & GetTranslatedFileIni("MBR Func_Notify", "STATS_Info_01", "- send Village Statistics of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG") & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_01", "- send the current log file of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID") & " " & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID_Info_01", "- send the last raid loot screenshot of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT") & " " & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT_Info_01", "- send the last raid loot values of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT") & " " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_01", "- send a screenshot of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD", "SCREENSHOTHD") & " " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD_Info_01", "- send a screenshot in high resolution of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER") & " " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER_Info_01", "- send a screenshot of builder status of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= '\n' & GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD") & " " & GetTranslatedFileIni("MBR Func_Notify", "SHIELD_Info_01", "- send a screenshot of shield status of") & " <" & $g_sNotifyOrigin & ">"
						$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS", "RESETSTATS") & " " & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS_Info_01", "- reset Village Statistics")
						$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS") & " " & GetTranslatedFileIni("MBR Func_Notify", "TROOPS_Info_01", "- send Troops & Spells Stats")
						$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKON", "HALTATTACKON") & " " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK OFF_Info_01", "- Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
						$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKOFF", "HALTATTACKOFF") & " " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK ON_Info_01", "- Turn Off 'Halt Attack' in the 'Misc' Tab")
						$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE") & " " & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE_Info_01", "- Hibernate host PC")
						$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN") & " " & GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN_Info_01", "- Shut down host PC")
						$txtHelp &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY") & " " & GetTranslatedFileIni("MBR Func_Notify", "STANDBY_Info_01", "- Standby host PC")

						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-For-Help_Info_02", "Request for Help") & "\n" & $txtHelp)
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Help has been sent", $COLOR_SUCCESS)
					Case GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART"), '\UD83D\UDD01 ' & GetTranslatedFileIni("MBR Func_Notify", "RESTART", "RESTART")
						SetLog("Notify Telegram: Your request has been received.", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_16", "Request to Restart") & "...\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_09", "Your bot and Emulator are now restarting..."))
						SaveConfig()
						RestartBot()
					Case GetTranslatedFileIni("MBR Func_Notify", "START", "START"), '\u25b6 ' & GetTranslatedFileIni("MBR Func_Notify", "START", "START")
						If $g_bRunState = True Then
							SetLog("Notify Telegram" & ": " & "Your bot is currently started, no action was taken", $COLOR_SUCCESS)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_01", "Request to Start...") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Start_Info_03", "Your bot is currently started, no action was taken"))
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP"), '\U25AA ' & GetTranslatedFileIni("MBR Func_Notify", "STOP", "STOP")
						SetLog("Notify Telegram: Your request has been received. Bot is now stopped", $COLOR_SUCCESS)
						If $g_bRunState = True Then
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_02", "Request to Stop...") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_03", "Your bot is now stopping..."))
							btnStop()
						Else
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_02", "Request to Stop...") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_04", "Your bot is currently stopped, no action was taken"))
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE"), '\UD83D\UDD00 ' & GetTranslatedFileIni("MBR Func_Notify", "PAUSE", "PAUSE")
						If $g_bBotPaused = False And $g_bRunState = True Then
							If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
								SetLog("Notify Telegram: Unable to pause during attack", $COLOR_ERROR)
								NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_17", "Request to Pause") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_08", "Unable to pause during attack, try again later."))
							ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
								ReturnHome(False, False)
								$g_bIsSearchLimit = True
								$g_bIsClientSyncError = True
								;UpdateStats()
								$g_bRestart = True
								TogglePauseImpl("Push")
								Return True
							Else
								TogglePauseImpl("Push")
							EndIf
						Else
							SetLog("Notify Telegram: Your bot is currently paused, no action was taken", $COLOR_SUCCESS)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_17", "Request to Pause") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_11", "Your bot is currently paused, no action was taken"))
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME"), '\U25B6 ' & GetTranslatedFileIni("MBR Func_Notify", "RESUME", "RESUME")
						If $g_bBotPaused = True And $g_bRunState = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Notify Telegram: Your bot is currently resumed, no action was taken", $COLOR_SUCCESS)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_18", "Request to Resume") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_12", "Your bot is currently resumed, no action was taken"))
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS"), '\UD83D\UDCC8 ' & GetTranslatedFileIni("MBR Func_Notify", "STATS", "STATS")
						SetLog("Notify Telegram: Your request has been received. Statistics sent", $COLOR_SUCCESS)
						Local $GoldGainPerHour = "0 / h"
						Local $ElixirGainPerHour = "0 / h"
						Local $DarkGainPerHour = "0 / h"
						Local $TrophyGainPerHour = "0 / h"
						If $g_iFirstAttack = 2 Then
							$GoldGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h"
							$ElixirGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "K / h"
						EndIf
						If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
							$DarkGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h"
						EndIf
						$TrophyGainPerHour = _NumberFormat(Round($g_iStatsTotalGain[$eLootTrophy] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h"
						Local $txtStats = " | " & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_02", "Stats Village Report") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_05", "At Start") & "\n[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsStartedWith[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: "
						$txtStats &= _NumberFormat($g_iStatsStartedWith[$eLootElixir]) & " [D]: " & _NumberFormat($g_iStatsStartedWith[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsStartedWith[$eLootTrophy]
						$txtStats &= "\n\n" & GetTranslatedFileIni("MBR Func_Notify", "Stats-Now_Info_01", "Now (Current Resources)") & "\n[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir])
						$txtStats &= " [D]: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_aiCurrentLoot[$eLootTrophy] & " [GEM]: " & $g_iGemAmount
						$txtStats &= "\n\n" & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_04", "Gain per Hour") & ":\n[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & $GoldGainPerHour & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & $ElixirGainPerHour
						$txtStats &= "\n[D]: " & $DarkGainPerHour & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $TrophyGainPerHour
						$txtStats &= "\n\n" & GetTranslatedFileIni("MBR Func_Notify", "Free-Builders_Info_01", "No. of Free Builders") & ": " & $g_iFreeBuilderCount & "\n[" & GetTranslatedFileIni("MBR Func_Notify", "Wall-Up_Info_01", "No. of Wall Up") & "]: [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: "
						$txtStats &= $g_iNbrOfWallsUppedGold & "/ [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & $g_iNbrOfWallsUppedElixir & "\n\n" & GetTranslatedFileIni("MBR Func_Notify", "Attack_Info_01", "Attacked") & ": "
						$txtStats &= $g_aiAttackedCount & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Skip_Info_02", "Skipped") & ": " & $g_iSkippedVillageCount
						$txtStats &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_07", "Run Time") & ": " & GUICtrlRead($g_hLblResultRuntime)
						$txtStats &= "\n\n" & "Clan Games:"
						$txtStats &= "\n" & "[T]: " & GUICtrlRead($g_hLblRemainTime) & " [S]: " & GUICtrlRead($g_hLblYourScore)
						$txtStats &= "\n" & " "
						NotifyPushToTelegram($g_sNotifyOrigin & $txtStats)
					Case GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG"), '\UD83D\UDCCB ' & GetTranslatedFileIni("MBR Func_Notify", "LOG", "LOG")
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Log is now sent", $COLOR_SUCCESS)
						NotifyPushFileToTelegram($g_sLogFileName, "Logs", "text\/plain; charset=utf-8", $g_sNotifyOrigin & " | Current Log " & "\n")
					Case GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID"), '\UD83C\UDF04 ' & GetTranslatedFileIni("MBR Func_Notify", "LASTRAID", "LASTRAID")
						If $g_sLootFileName <> "" Then
							NotifyPushFileToTelegram($g_sLootFileName, "Loots", "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_05", "Last Raid") & "\n" & $g_sLootFileName)
							SetLog("Notify Telegram: Push Last Raid Snapshot...", $COLOR_SUCCESS)
						Else
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_03", "There is no last raid screenshot."))
							SetLog("There is no last raid screenshot.")
							SetLog("Notify Telegram: Your request has been received. Last Raid txt sent", $COLOR_SUCCESS)
							NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_04", "Last Raid txt") & "\n" & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [D]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
						EndIf
					Case GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT"), '\UD83D\UDCC4 ' & GetTranslatedFileIni("MBR Func_Notify", "LASTRAIDTXT", "LASTRAIDTXT")
						SetLog("Notify Telegram: Your request has been received. Last Raid txt sent", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_04", "Last Raid txt") & "\n" & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [D]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
					Case GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT")
						SetLog("Notify Telegram: ScreenShot request received", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_03", "Chief, your request for Screenshot will be processed ASAP"))
						$g_bTGRequestScreenshot = True
					Case GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOTHD", "SCREENSHOTHD"), '\UD83D\UDCF7 ' & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT", "SCREENSHOT")
						SetLog("Notify Telegram: ScreenShot HD request received", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_03", "Chief, your request for Screenshot will be processed ASAP"))
						$g_bTGRequestScreenshot = True
						$g_bTGRequestScreenshotHD = True
						$g_bNotifyForced = False
					Case GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER"), '\UD83D\UDD28 ' & GetTranslatedFileIni("MBR Func_Notify", "BUILDER", "BUILDER")
						SetLog("Notify Telegram: Builder Status request received", $COLOR_SUCCESS)
						$g_bTGRequestBuilderInfo = True
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER_Info_04", "Chief, your request for Builder Info will be processed ASAP"))
					Case GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD"), '\UD83D\UDD30 ' & GetTranslatedFileIni("MBR Func_Notify", "SHIELD", "SHIELD")
						SetLog("Notify Telegram: Shield Status request received", $COLOR_SUCCESS)
						$g_bTGRequestShieldInfo = True
						$g_bNotifyForced = False
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SHIELD_Info_02", "Chief, your request for Shield Info will be processed ASAP"))
					Case GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS", "RESETSTATS")
						btnResetStats()
						SetLog("Notify Telegram: Your request has been received. Statistics resetted", $COLOR_SUCCESS)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "RESETSTATS_Info_02", "Statistics resetted."))
					Case GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS"), '\UD83D\UDCAA ' & GetTranslatedFileIni("MBR Func_Notify", "TROOPS", "TROOPS")
						SetLog("Notify Telegram: Your request has been received. Sending Troop/Spell Stats...", $COLOR_SUCCESS)
						; $g_aiCurrentTroops[$eTroopCount] is the current troops quantities
						Local $txtTroopStats = " | " & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_01", "Troops/Spells Train Status") & ":\n" & _
								"Barbs:" & $g_aiCurrentTroops[$eTroopBarbarian] & " of " & $g_aiArmyCompTroops[$eTroopBarbarian] & " | Arch:" & $g_aiCurrentTroops[$eTroopArcher] & " of " & $g_aiArmyCompTroops[$eTroopArcher] & " | Gobl:" & $g_aiCurrentTroops[$eTroopGoblin] & " of " & $g_aiArmyCompTroops[$eTroopGoblin] & "\n" & _
								"Giant:" & $g_aiCurrentTroops[$eTroopGiant] & " of " & $g_aiArmyCompTroops[$eTroopGiant] & " | WallB:" & $g_aiCurrentTroops[$eTroopWallBreaker] & " of " & $g_aiArmyCompTroops[$eTroopWallBreaker] & " | Wiza:" & $g_aiCurrentTroops[$eTroopWizard] & " of " & $g_aiArmyCompTroops[$eTroopWizard] & "\n" & _
								"Balloon:" & $g_aiCurrentTroops[$eTroopBalloon] & " of " & $g_aiArmyCompTroops[$eTroopBalloon] & " | Heal:" & $g_aiCurrentTroops[$eTroopHealer] & " of " & $g_aiArmyCompTroops[$eTroopHealer] & " | Dragon:" & $g_aiCurrentTroops[$eTroopDragon] & " of " & $g_aiArmyCompTroops[$eTroopDragon] & " | Pekka:" & $g_aiCurrentTroops[$eTroopPekka] & " of " & $g_aiArmyCompTroops[$eTroopPekka] & "\n" & _
								"Mini:" & $g_aiCurrentTroops[$eTroopMinion] & " of " & $g_aiArmyCompTroops[$eTroopMinion] & " | Hogs:" & $g_aiCurrentTroops[$eTroopHogRider] & " of " & $g_aiArmyCompTroops[$eTroopHogRider] & " | Valks:" & $g_aiCurrentTroops[$eTroopValkyrie] & " of " & $g_aiArmyCompTroops[$eTroopValkyrie] & "\n" & _
								"Golem:" & $g_aiCurrentTroops[$eTroopGolem] & " of " & $g_aiArmyCompTroops[$eTroopGolem] & " | Witch:" & $g_aiCurrentTroops[$eTroopWitch] & " of " & $g_aiArmyCompTroops[$eTroopWitch] & " | Lava:" & $g_aiCurrentTroops[$eTroopLavaHound] & " of " & $g_aiArmyCompTroops[$eTroopLavaHound] & "\n" & _
								"LSpell:" & $g_aiCurrentSpells[$eSpellLightning] & " of " & $g_aiArmyCompSpells[$eSpellLightning] & " | HeSpell:" & $g_aiCurrentSpells[$eSpellHeal] & " of " & $g_aiArmyCompSpells[$eSpellHeal] & " | RSpell:" & $g_aiCurrentSpells[$eSpellRage] & " of " & $g_aiArmyCompSpells[$eSpellRage] & " | JSpell:" & $g_aiCurrentSpells[$eSpellJump] & " of " & $g_aiArmyCompSpells[$eSpellJump] & "\n" & _
								"FSpell:" & $g_aiCurrentSpells[$eSpellFreeze] & " of " & $g_aiArmyCompSpells[$eSpellFreeze] & " | PSpell:" & $g_aiCurrentSpells[$eSpellPoison] & " of " & $g_aiArmyCompSpells[$eSpellPoison] & " | ESpell:" & $g_aiCurrentSpells[$eSpellEarthquake] & " of " & $g_aiArmyCompSpells[$eSpellEarthquake] & " | HaSpell:" & $g_aiCurrentSpells[$eSpellHaste] & " of " & $g_aiArmyCompSpells[$eSpellHaste] & "\n"
						$txtTroopStats &= "\n" & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_05", "Current Capacities") & ":"
						$txtTroopStats &= "\n" & " " & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_06", "- Army Camp") & ": " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace
						$txtTroopStats &= "\n" & " " & GetTranslatedFileIni("MBR Func_Notify", "Train_Info_04", "- Spells") & ": " & $g_iCurrentSpells & "/" & $g_iTotalTrainSpaceSpell
						NotifyPushToTelegram($g_sNotifyOrigin & $txtTroopStats)
					Case GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKON", "HALTATTACKON"), '\U274C ' & StringUpper(GetTranslatedFileIni("MBR Func_Notify", "ATTACK OFF", "ATTACK OFF"))
						GUICtrlSetState($g_hChkBotStop, $GUI_CHECKED)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK ON_Info_02", "Set Halt Attack ON."))
						btnStop()
						$g_bChkBotStop = True ; set halt attack variable
						$g_iCmbBotCond = 18 ; set stay online
						btnStart()
					Case GetTranslatedFileIni("MBR Func_Notify", "HALTATTACKOFF", "HALTATTACKOFF"), '\U2705 ' & StringUpper(GetTranslatedFileIni("MBR Func_Notify", "ATTACK ON_Info_01", "ATTACK ON"))
						GUICtrlSetState($g_hChkBotStop, $GUI_UNCHECKED)
						NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "ATTACK OFF_Info_02", "Set Halt Attack OFF."))
						btnStop()
						btnStart()
					Case GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE"), '\UD83D\UDCA4 ' & GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE", "HIBERNATE")
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Hibernate PC", $COLOR_SUCCESS)
						NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "HIBERNATE_Info_02", "PC Hibernate sequence initiated"))
						Shutdown(64)
					Case GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN"), '\U26A1 ' & StringUpper(GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN", "SHUTDOWN"))
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Shutdown PC", $COLOR_SUCCESS)
						NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "SHUTDOWN_Info_02", "PC Shutdown sequence initiated"))
						Shutdown(5)
					Case GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY"), GetTranslatedFileIni("MBR Func_Notify", "STANDBY", "STANDBY")
						SetLog("Notify Telegram: Your request has been received from " & $g_sNotifyOrigin & ". Standby PC", $COLOR_SUCCESS)
						NotifyPushToTelegram(GetTranslatedFileIni("MBR Func_Notify", "STANDBY_Info_02", "PC Standby sequence initiated"))
						Shutdown(32)
				EndSwitch
			EndIf
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------

EndFunc   ;==>NotifyRemoteControlProc

Func NotifyPushToBoth($pMessage)
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyPushToBoth($pMessage): " & $pMessage)
	If (Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "") And (Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable And $g_sNotifyPBToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		If @error Then
			SetLog("PushBullet Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
			Return
		EndIf
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		Local $access_token = $g_sNotifyPBToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
		$oHTTP.WaitForResponse
	EndIf
	;PushBullet ---------------------------------------------------------------------------------
	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then
		Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		If @error Then
			SetLog("Telegram Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
			Return
		EndIf
		Local $url = "https://api.telegram.org/bot"
		$oHTTP.Open("Post", $url & $g_sNotifyTGToken & "/sendMessage", False)
		$oHTTP.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

		Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		Local $Time = @HOUR & '.' & @MIN
		Local $TGPushMsg = '{"text":"' & $pMessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $g_sTGChatID & '}}'
		$oHTTP.Send($TGPushMsg)
		$oHTTP.WaitForResponse
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==>NotifyPushToBoth

Func NotifyPushMessageToBoth($Message, $Source = "")

	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyPushMessageToBoth($Message, $Source = ""): " & $Message & "," & $Source)
	Static $iReportIdleBuilder = 0

	If Not $g_bNotifyForced And $Message <> "DeleteAllPBMessages" Then
		If $g_bNotifyScheduleWeekDaysEnable Then
			If $g_abNotifyScheduleWeekDays[@WDAY - 1] Then
				If $g_bNotifyScheduleHoursEnable Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If Not $g_abNotifyScheduleHours[$hour[0]] Then
						SetLog("Notify not planned for this hour! Notification skipped", $COLOR_WARNING)
						SetLog($Message, $COLOR_ORANGE)
						Return ; exit func if no planned
					EndIf
				EndIf
			Else
				Return ; exit func if not planned
			EndIf
		Else
			If $g_bNotifyScheduleHoursEnable Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If Not $g_abNotifyScheduleHours[$hour[0]] Then
					SetLog("Notify not planned for this hour! Notification skipped", $COLOR_WARNING)
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
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyRemoteEnable Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_10", "Bot restarted"))
		Case "OutOfSync"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertOutOfSync Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_05", "Restarted after Out of Sync Error") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_06", "Attacking now") & "...")
		Case "LastRaid"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlerLastRaidTXT Then
				NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Last-Raid_Info_02", "Last Raid txt") & "\n" & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iStatsLastAttack[$eLootTrophy])
				If _Sleep($DELAYPUSHMSG1) Then Return
				If $g_bNotifyPBEnable = True Then SetLog("Notify PushBullet: Last Raid Text has been sent!", $COLOR_SUCCESS)
				If $g_bNotifyTGEnable = True Then SetLog("Notify Telegram: Last Raid Text has been sent!", $COLOR_SUCCESS)
			EndIf
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlerLastRaidIMG Then

				;create a temporary file to send with pushbullet...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				If $g_bScreenshotLootInfo Then
					$g_sAttackFile = $g_sLootFileName
				Else
					_CaptureRegion()
					$g_sAttackFile = "Notify_" & $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
					$hBitmap_Scaled = _GDIPlus_ImageResize($g_hBitmap, _GDIPlus_ImageGetWidth($g_hBitmap) / 2, _GDIPlus_ImageGetHeight($g_hBitmap) / 2) ;resize image
					_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $g_sProfileLootsPath & $g_sAttackFile)
					_GDIPlus_ImageDispose($hBitmap_Scaled)
				EndIf
				;push the file
				If $g_bNotifyPBEnable Then SetLog("Notify PushBullet: Last Raid screenshot has been sent!", $COLOR_SUCCESS)
				If $g_bNotifyTGEnable Then SetLog("Notify Telegram: Last Raid screenshot has been sent!", $COLOR_SUCCESS)
				NotifyPushFileToBoth($g_sAttackFile, "Loots", "image/jpeg", $g_sNotifyOrigin & " | " & "Last Raid" & "\n" & $g_sAttackFile)
				;wait a second and then delete the file
				If _Sleep($DELAYPUSHMSG1) Then Return
				Local $iDelete = FileDelete($g_sProfileLootsPath & $g_sAttackFile)
				If Not $iDelete Then
					If $g_bNotifyPBEnable Then SetLog("Notify PushBullet: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
					If $g_bNotifyTGEnable Then SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
				EndIf
			EndIf
		Case "FoundWalls"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertUpgradeWalls Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Wall-Up_Info_02", "Found Wall level") & " " & $g_iCmbUpgradeWallsLevel + 4 & "\n" & " " & GetTranslatedFileIni("MBR Func_Notify", "Wall-Up_Info_04", "Wall segment has been located") & "...\n" & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_01", "Upgrading") & "...")
		Case "SkipWalls"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertUpgradeWalls Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Wall-Up_Info_03", "Cannot find Wall level") & $g_iCmbUpgradeWallsLevel + 4 & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_02", "Skip upgrade") & "...")
		Case "AnotherDevice3600"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertAnotherDevice Then NotifyPushToBoth($g_sNotifyOrigin & " | 1. " & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_01", "Another Device has connected") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_02", "Another Device has connected, waiting") & " " & Floor(Floor($g_iAnotherDeviceWaitTime / 60) / 60) & " " & GetTranslatedFileIni("MBR Global GUI Design", "Hours", -1) & " " & Floor(Mod(Floor($g_iAnotherDeviceWaitTime / 60), 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "Min", -1) & " " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "seconds", -1))
		Case "AnotherDevice60"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertAnotherDevice Then NotifyPushToBoth($g_sNotifyOrigin & " | 2. " & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_01", "Another Device has connected") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_02", "Another Device has connected, waiting") & " " & Floor(Mod(Floor($g_iAnotherDeviceWaitTime / 60), 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "Min", -1) & " " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "seconds", -1))
		Case "AnotherDevice"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertAnotherDevice Then NotifyPushToBoth($g_sNotifyOrigin & " | 3. " & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_01", "Another Device has connected") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Another-Device_Info_02", "Another Device has connected, waiting") & " " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " " & GetTranslatedFileIni("MBR Global GUI Design", "seconds", -1))
		Case "TakeBreak"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertTakeBreak Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Need-Rest_Info_01", "Chief, we need some rest!") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Take-Break_Info_01", "Village must take a break.."))
		Case "Update"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertBOTUpdate Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "New-Version_Info_01", "Chief, there is a new version of the bot available"))
		Case "BuilderIdle"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertBulderIdle Then
				Local $iAvailBldr = $g_iFreeBuilderCount - ($g_bUpgradeWallSaveBuilder ? 1 : 0)
				If $iAvailBldr > 0 Then
					If $iReportIdleBuilder <> $iAvailBldr Then
						NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Stats_Info_03", "You have") & " " & $iAvailBldr & " " & GetTranslatedFileIni("MBR Func_Notify", "BUILDER_Info_03", "builder(s) idle."))
						SetLog("You have " & $iAvailBldr & " builder(s) idle.", $COLOR_SUCCESS)
						$iReportIdleBuilder = $iAvailBldr
					EndIf
				Else
					$iReportIdleBuilder = 0
				EndIf
			EndIf
		Case "CocError"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertOutOfSync Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_04", "CoC Has Stopped Error") & ".....")
		Case "Pause"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyRemoteEnable And $Source = "Push" Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_17", "Request to Pause") & "..." & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_13", "Your request has been received. Bot is now paused"))
		Case "Resume"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyRemoteEnable And $Source = "Push" Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_18", "Request to Resume") & "..." & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Request-Stop_Info_14", "Your request has been received. Bot is now resumed"))
		Case "OoSResources"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertOutOfSync Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "LOG_Info_06", "Disconnected after") & " " & StringFormat("%3s", $g_iSearchCount) & " " & GetTranslatedFileIni("MBR Func_Notify", "Skip_Info_01", "skip(s)") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Attack_Info_02", "Cannot locate Next button, Restarting Bot") & "...")
		Case "MatchFound"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertMatchFound Then NotifyPushToBoth($g_sNotifyOrigin & " | " & $g_asModeText[$g_iMatchMode] & " " & GetTranslatedFileIni("MBR Func_Notify", "Match-Found_Info_01", "Match Found! after") & " " & StringFormat("%3s", $g_iSearchCount) & " " & GetTranslatedFileIni("MBR Func_Notify", "Skip_Info_01", "skip(s)") & "\n" & "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_iSearchGold) & "; [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_iSearchElixir) & "; [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_iSearchDark) & "; [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & $g_iSearchTrophy)
		Case "UpgradeWithGold"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertUpgradeWalls Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_07", "Upgrade completed by using GOLD") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_03", "Complete by using GOLD") & "...")
		Case "UpgradeWithElixir"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertUpgradeWalls Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_08", "Upgrade completed by using ELIXIR") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_04", "Complete by using ELIXIR") & "...")
		Case "NoUpgradeWallButton"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertUpgradeWalls Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_05", "No Upgrade Gold Button") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_10", "Cannot find gold upgrade button") & "...")
		Case "NoUpgradeElixirButton"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertUpgradeWalls Then NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_09", "No Upgrade Elixir Button") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Upgrading_Info_06", "Cannot find elixir upgrade button") & "...")
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion()
			If $g_bPBRequestScreenshotHD Or $g_bTGRequestScreenshotHD Then
				$hBitmap_Scaled = $g_hBitmap
			Else
				$hBitmap_Scaled = _GDIPlus_ImageResize($g_hBitmap, _GDIPlus_ImageGetWidth($g_hBitmap) / 2, _GDIPlus_ImageGetHeight($g_hBitmap) / 2) ;resize image
			EndIf
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $g_sProfileTempPath & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			If $g_bPBRequestScreenshot Or $g_bTGRequestScreenshot Then
				If $g_bPBRequestScreenshot And $g_bNotifyPBEnable Then
					NotifyPushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_04", "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
					SetLog("Notify PushBullet: Screenshot sent!", $COLOR_SUCCESS)
				EndIf
				If $g_bTGRequestScreenshot And $g_bNotifyTGEnable Then
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "SCREENSHOT_Info_04", "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
					SetLog("Notify Telegram: Screenshot sent!", $COLOR_SUCCESS)
				EndIf
			EndIf
			$g_bPBRequestScreenshot = False
			$g_bPBRequestScreenshotHD = False
			$g_bTGRequestScreenshot = False
			$g_bTGRequestScreenshotHD = False
			;wait a second and then delete the file
			If _Sleep($DELAYPUSHMSG2) Then Return
			Local $iDelete = FileDelete($g_sProfileTempPath & $Screnshotfilename)
			If Not $iDelete Then
				If $g_bNotifyPBEnable Then SetLog("Notify PushBullet: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
				If $g_bNotifyTGEnable Then SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
			EndIf
		Case "BuilderInfo"
			Click(0, 0, 5)
			Click(274, 8)
			_Sleep(500)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(224, 74, 446, 262)
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($g_hBitmap, $g_sProfileTempPath & $Screnshotfilename)
			If $g_bPBRequestBuilderInfo Or $g_bTGRequestBuilderInfo Then
				If $g_bPBRequestBuilderInfo And $g_bNotifyPBEnable Then
					NotifyPushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & "Builder Information" & "\n" & $Screnshotfilename)
					SetLog("Notify PushBullet: Builder Information sent!", $COLOR_GREEN)
				EndIf
				If $g_bTGRequestBuilderInfo And $g_bNotifyTGEnable Then
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & "Builder Information" & "\n" & $Screnshotfilename)
					SetLog("Notify Telegram: Builder Information sent!", $COLOR_GREEN)
				EndIf
			EndIf
			$g_bPBRequestBuilderInfo = False
			$g_bTGRequestBuilderInfo = False
			;wait a second and then delete the file
			If _Sleep($DELAYPUSHMSG2) Then Return
			Local $iDelete = FileDelete($g_sProfileTempPath & $Screnshotfilename)
			If Not $iDelete Then
				If $g_bNotifyPBEnable Then SetLog("Notify PushBullet: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
				If $g_bNotifyTGEnable Then SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
			EndIf
			Click(0, 0, 5)
		Case "ShieldInfo"
			Click(0, 0, 5)
			Click(435, 8)
			_Sleep(500)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(200, 165, 660, 568)
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($g_hBitmap, $g_sProfileTempPath & $Screnshotfilename)
			If $g_bPBRequestShieldInfo Or $g_bTGRequestShieldInfo Then
				If $g_bPBRequestShieldInfo And $g_bNotifyPBEnable Then
					NotifyPushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & "Shield Information" & "\n" & $Screnshotfilename)
					SetLog("Notify PushBullet: Shield Information sent!", $COLOR_SUCCESS)
				EndIf
				If $g_bTGRequestShieldInfo And $g_bNotifyTGEnable Then
					NotifyPushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $g_sNotifyOrigin & " | " & "Shield Information" & "\n" & $Screnshotfilename)
					SetLog("Notify Telegram: Shield Information sent!", $COLOR_SUCCESS)
				EndIf
			EndIf
			$g_bPBRequestShieldInfo = False
			$g_bTGRequestShieldInfo = False
			;wait a second and then delete the file
			If _Sleep($DELAYPUSHMSG2) Then Return
			Local $iDelete = FileDelete($g_sProfileTempPath & $Screnshotfilename)
			If Not $iDelete Then
				If $g_bNotifyPBEnable Then SetLog("Notify PushBullet: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
				If $g_bNotifyTGEnable Then SetLog("Notify Telegram: An error occurred deleting temporary screenshot file.", $COLOR_ERROR)
			EndIf
			Click(0, 0, 5)
		Case "DeleteAllPBMessages"
			NotifyDeletePushBullet()
			If $g_bNotifyPBEnable Then SetLog("Notify PushBullet: All messages deleted.", $COLOR_SUCCESS)
			If $g_bNotifyTGEnable Then SetLog("Notify Telegram: All messages deleted.", $COLOR_SUCCESS)
			$g_bNotifyDeleteAllPushesNow = False ; reset value
		Case "CampFull"
			If ($g_bNotifyPBEnable Or $g_bNotifyTGEnable) And $g_bNotifyAlertCampFull Then
				NotifyPushToBoth($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Camps-Full_Info_01", "Your Army Camps are now Full"))
				If $g_bNotifyPBEnable Then SetLog("Notify PushBullet: Your Army Camps are now Full", $COLOR_SUCCESS)
				If $g_bNotifyTGEnable Then SetLog("Notify Telegram: Your Army Camps are now Full", $COLOR_SUCCESS)
			EndIf
		Case "Misc"
			NotifyPushToBoth($Message)
	EndSwitch
EndFunc   ;==>NotifyPushMessageToBoth

Func NotifyPushFileToBoth($File, $Folder, $FileType, $body)

	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyPushFileToBoth($File, $Folder, $FileType, $body): " & $File & "," & $Folder & "," & $FileType & "," & $body)

	If (Not $g_bNotifyPBEnable Or $g_sNotifyPBToken = "") And (Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $g_bNotifyPBEnable And $g_sNotifyPBToken <> "" Then
		If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then
			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			If @error Then
				SetLog("PushBullet Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
				Return
			EndIf
			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
			Local $access_token = $g_sNotifyPBToken
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
			$oHTTP.Send($pPush)
			$oHTTP.WaitForResponse
			Local $Result = $oHTTP.ResponseText
			If $oHTTP.Status <> 200 Then
				SetLog("PushBullet status is: " & $oHTTP.Status, $COLOR_ERROR)
				Return
			EndIf
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
				$oHTTP.WaitForResponse
			Else
				SetLog(GetTranslatedFileIni("MBR Func_Notify", "Notify_001", "Notify PushBullet") & ": " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_05", "Unable to send file") & " " & $File, $COLOR_ERROR)
				NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_03", "Unable to Upload File") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_04", "Occured an error type") & " 1 " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_01", "uploading file to PushBullet server") & "...")
			EndIf
		Else
			SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_ERROR)
			NotifyPushToPushBullet($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_03", "Unable to Upload File") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_04", "Occured an error type") & " 2 " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_01", "uploading file to PushBullet server") & "...")
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

	;Telegram ---------------------------------------------------------------------------------
	If $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then
		If FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File) Then

			Local $oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			If @error Then
				SetLog("Telegram Obj Error code: " & Hex(@error, 8), $COLOR_ERROR)
				Return
			EndIf
			Local $telegram_url = "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/sendPhoto"
			Local $Result = RunWait($g_sCurlPath & " -i -X POST " & $telegram_url & ' -F chat_id="' & $g_sTGChatID & ' " -F photo=@"' & $g_sProfilePath & "\" & $g_sProfileCurrentName & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)
			$oHTTP.Open("Post", "https://api.telegram.org/bot" & $g_sNotifyTGToken & "/sendPhoto", False)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP.Send($pPush)
			$oHTTP.WaitForResponse
		Else
			SetLog("Notify Telegram: Unable to send file " & $File, $COLOR_ERROR)
			NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_03", "Unable to Upload File") & "\n" & GetTranslatedFileIni("MBR Func_Notify", "Uploading-File_Info_02", "Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==>NotifyPushFileToBoth
; Both ---------------------------------

; User's COM error function. Will be called if COM error occurs
; This is a custom error handler
Func __ErrFunc($oError)
	SetLog("COM Error intercepted !" & @CRLF & _
			"Scriptline is: " & $oError.scriptline & @CRLF & _
			"Number is: " & Hex($oError.number, 8) & @CRLF & _
			"Returncode is: " & Hex($oError.retcode, 8) & @CRLF & _
			"WinDescription is: " & $oError.windescription & @CRLF & _
			"Description is: " & $oError.description, $COLOR_RED)
EndFunc   ;==>__ErrFunc

Func __ObjEventIni()
	$g_oCOMErrorHandler = ObjEvent("AutoIt.Error", "__ErrFunc")
EndFunc   ;==>__ObjEventIni

Func __ObjEventEnds()
	$g_oCOMErrorHandler = 0
EndFunc   ;==>__ObjEventEnds
