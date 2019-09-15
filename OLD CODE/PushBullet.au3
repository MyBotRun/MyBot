; #FUNCTION# ====================================================================================================================
; Name ..........: PushBullet Code
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; <><><> Globals <><><>

Global $g_bPBRequestScreenshot = False
Global $g_bPBRequestScreenshotHD = False
Global $g_bPBRequestBuilderInfo = False
Global $g_bPBRequestShieldInfo = False

;PushBullet
Global $g_bNotifyPBEnable = False, $g_sNotifyPBToken = ""
Global Const $g_iPBDeleteOldPushesInterval = 1800000 ; 30 mins
Global $g_bNotifyDeleteAllPushesNow = False

; ApplyConfig.au3

Func ApplyConfig_600_18($TypeReadSave)
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkNotifyPBEnable, $g_bNotifyPBEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtNotifyPBToken, $g_sNotifyPBToken)
			GUICtrlSetState($g_hChkNotifyDeleteAllPBPushes, $g_bNotifyDeleteAllPushesOnStart ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyDeleteOldPBPushes, $g_bNotifyDeletePushesOlderThan ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbNotifyPushHours, $g_iNotifyDeletePushesOlderThanHours)
			chkDeleteOldPBPushes()
		Case "Save"
			; PushBullet / Telegram
			$g_bNotifyPBEnable = (GUICtrlRead($g_hChkNotifyPBEnable) = $GUI_CHECKED)
			$g_sNotifyPBToken = GUICtrlRead($g_hTxtNotifyPBToken)
			$g_bNotifyDeleteAllPushesOnStart = (GUICtrlRead($g_hChkNotifyDeleteAllPBPushes) = $GUI_CHECKED)
			$g_bNotifyDeletePushesOlderThan = (GUICtrlRead($g_hChkNotifyDeleteOldPBPushes) = $GUI_CHECKED)
			$g_iNotifyDeletePushesOlderThanHours = _GUICtrlComboBox_GetCurSel($g_hCmbNotifyPushHours)
	EndSwitch
EndFunc   ;==>ApplyConfig_600_18

; ReadConfig.au3

Func ReadConfig_600_18()
	;PushBullet/Telegram
	IniReadS($g_bNotifyPBEnable, $g_sProfileConfigPath, "notify", "PBEnabled", False, "Bool")
	IniReadS($g_sNotifyPBToken, $g_sProfileConfigPath, "notify", "PBToken", "")
	IniReadS($g_bNotifyDeleteAllPushesOnStart, $g_sProfileConfigPath, "notify", "DeleteAllPBPushes", False, "Bool")
	IniReadS($g_bNotifyDeletePushesOlderThan, $g_sProfileConfigPath, "notify", "DeleteOldPBPushes", False, "Bool")
EndFunc   ;==>ReadConfig_600_18

; SaveConfig.au3

Func SaveConfig_600_18()
	; PushBullet / Telegram
	_Ini_Add("notify", "PBEnabled", $g_bNotifyPBEnable ? 1 : 0)
	_Ini_Add("notify", "PBToken", $g_sNotifyPBToken)
	_Ini_Add("notify", "DeleteAllPBPushes", $g_bNotifyDeleteAllPushesOnStart ? 1 : 0)
	_Ini_Add("notify", "DeleteOldPBPushes", $g_bNotifyDeletePushesOlderThan ? 1 : 0)
EndFunc   ;==>SaveConfig_600_18


; Control Child Village.su3

Func chkDeleteOldPBPushes()
	If GUICtrlRead($g_hChkNotifyDeleteOldPBPushes) = $GUI_CHECKED Then
		$g_bNotifyDeletePushesOlderThan = True
		If $g_bNotifyPBEnable Then GUICtrlSetState($g_hCmbNotifyPushHours, $GUI_ENABLE)
	Else
		$g_bNotifyDeletePushesOlderThan = False
		GUICtrlSetState($g_hCmbNotifyPushHours, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDeleteOldPBPushes

Func btnDeletePBMessages()
	$g_bNotifyDeleteAllPushesNow = True
EndFunc   ;==>btnDeletePBMessages


; Design Child Village.su3

Func CreatePushBulletTelegramSubTab()
	$x -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnNotify, $x + 3, $y, 32, 32)
	$g_hChkNotifyPBEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyPBEnable", "Enable PushBullet"), $x + 40, $y + 5)
	GUICtrlSetOnEvent(-1, "chkPBTGenabled")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyPBEnable_Info_01", "Enable PushBullet notifications"))
	$g_hChkNotifyDeleteAllPBPushes = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyDeleteAllPBPushes", "Delete Msg on Start"), $x + 160, $y)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyDeleteAllPBPushes_Info_01", "It will delete all previous push notification when you start bot"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hBtnNotifyDeleteMessages = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "BtnNotifyDeleteMessages", "Delete all Msg now"), $x + 300, $y, 100, 20)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "BtnNotifyDeleteMessages_Info_01", "Click here to delete all PushBullet messages."))
	GUICtrlSetOnEvent(-1, "btnDeletePBMessages")
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x5CAD85)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 22
	$g_hChkNotifyDeleteOldPBPushes = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyDeleteOldPBPushes", "Delete Msg older than"), $x + 160, $y)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "ChkNotifyDeleteOldPBPushes_Info_01", "Delete all previous push notification older than specified hour"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "chkDeleteOldPBPushes")
	$g_hCmbNotifyPushHours = GUICtrlCreateCombo("", $x + 300, $y, 100, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "CmbNotifyPushHours_Info_01", "Set the interval for messages to be deleted."))
	Local $sTxtHours = GetTranslatedFileIni("MBR Global GUI Design", "Hours", -1)
	GUICtrlSetData(-1, "1 " & GetTranslatedFileIni("MBR Global GUI Design", "Hour", -1) & "|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & _
			$sTxtHours & "|7 " & $sTxtHours & "|8 " & $sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & _
			$sTxtHours & "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & _
			$sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours)
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 30
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyPBToken", "Token (PushBullet)") & ":", $x, $y, -1, -1, $SS_RIGHT)
	$g_hTxtNotifyPBToken = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Notify", "LblNotifyPBToken_Info_01", "You need a Token to use PushBullet notifications. Get a token from PushBullet.com"))
	GUICtrlSetState(-1, $GUI_DISABLE)

;~ 	;$y += 20
EndFunc   ;==>CreatePushBulletTelegramSubTab

; Notify.su3

Func _DeletePush()
	If $g_bDebugSetlog Then SetDebugLog("Notify | _DeletePush()")
	NotifyDeletePushBullet()
	SetLog("Delete all previous PushBullet messages...", $COLOR_INFO)
EndFunc   ;==>_DeletePush

Func _DeleteOldPushes()
	If $g_bDebugSetlog Then SetDebugLog("Notify | _DeleteOldPushes()")
	NotifyDeleteOldPushesFromPushBullet()
EndFunc   ;==>_DeleteOldPushes

; PushBullet ---------------------------------
Func PushBulletRemoteControl()
	If $g_bDebugSetlog Then SetDebugLog("Notify | PushBulletRemoteControl()")
	If ($g_bNotifyPBEnable = True) And $g_bNotifyRemoteEnable = True Then NotifyRemoteControlProc()
EndFunc   ;==>PushBulletRemoteControl

Func PushBulletDeleteOldPushes()
	If $g_bDebugSetlog Then SetDebugLog("Notify | PushBulletDeleteOldPushes()")
	If $g_bNotifyPBEnable = True And $g_bNotifyDeletePushesOlderThan = True Then _DeleteOldPushes() ; check every 30 min if must delete old pushbullet messages, increase delay time for anti ban pushbullet
EndFunc   ;==>PushBulletDeleteOldPushes

Func NotifylPushBulletMessage($pMessage = "")
;~ 		;PushBullet ---------------------------------------------------------------------------------
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
;~ 	;PushBullet ---------------------------------------------------------------------------------
EndFunc   ;==>NotifylPushBulletMessage

Func NotifyPushToPushBullet($pMessage)
	If $g_bDebugSetlog Then SetDebugLog("Notify | NotifyPushToPushBullet($pMessage): " & $pMessage)
	If Not $g_bNotifyTGEnable Or $g_sNotifyTGToken = "" Then Return

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
;~ ; PushBullet ---------------------------------

Func NotifyRemoteControlProc()
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
EndFunc   ;==>NotifyRemoteControlProc

Func NotifyPushToBoth($pMessage)
;~ 	;~ 	;PushBullet ---------------------------------------------------------------------------------
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
EndFunc

Func NotifyPushFileToBoth($File, $Folder, $FileType, $body)
;~ 	;~ 	;PushBullet ---------------------------------------------------------------------------------
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
EndFunc
