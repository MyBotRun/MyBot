; #FUNCTION# ====================================================================================================================
; Name ..........: PushBullet
; Description ...: This function will report to your mobile phone your values and last attack
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Antidote (2015-03)
; Modified ......: Sardo and Didipe (2015-05) rewrite code
;				   kgns (2015-06) $pushLastModified addition
;				   Sardo (2015-06) compliant with new pushbullet syntax (removed title)
;				   Boju(2016-05)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include <Array.au3>
#include <String.au3>

Func _RemoteControlPushBullet()
	If $PushBulletEnabled = 0 Or $pRemote = 0 Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	Local $pushbulletApiUrl
	If $pushLastModified = 0 Then
		$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&limit=1" ; if this is the first time looking for pushes, get the last one
	Else
		$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $pushLastModified ; get the one pushed after the last one received
	EndIf
	$oHTTP.Open("Get", $pushbulletApiUrl, False)
	$access_token = $PushBulletToken
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

				Switch $body[$x]
					Case GetTranslated(620,1, "BOT") & " " & GetTranslated(620,14, "HELP")
						Local $txtHelp = GetTranslated(620,13, "You can remotely control your bot sending commands following this syntax:")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,14, -1) & GetTranslated(620,2, " - send this help message")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,15,"DELETE") & GetTranslated(620,3, " - delete all your previous PushBullet messages")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,16,"RESTART") & GetTranslated(620,4, " - restart the bot named <Village Name> and Android Emulator")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,17,"STOP") & GetTranslated(620,5, " - stop the bot named <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,18,"PAUSE") & GetTranslated(620,6, " - pause the bot named <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,19,"RESUME") & GetTranslated(620,7, " - resume the bot named <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,20,"STATS") & GetTranslated(620,8, " - send Village Statistics of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,21,"LOG") & GetTranslated(620,9, " - send the current log file of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,22,"LASTRAID") & GetTranslated(620,10, " - send the last raid loot screenshot of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,23,"LASTRAIDTXT") & GetTranslated(620,11, " - send the last raid loot values of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,24,"SCREENSHOT") & GetTranslated(620,12, " - send a screenshot of <Village Name>")
						$txtHelp &= '\n'
						$txtHelp &= '\n' & GetTranslated(620,25, "Examples:")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & $iOrigPushBullet & " " & GetTranslated(620,18,"PAUSE")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,15,"DELETE")
						$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & $iOrigPushBullet & " " & GetTranslated(620,24,"SCREENSHOT")
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,26, "Request for Help") & "\n" & $txtHelp)
						SetLog("Pushbullet: Your request has been received from ' " & $iOrigPushBullet & ". Help has been sent", $COLOR_GREEN)
						_DeleteMessageOfPushBullet($iden[$x])
					Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,18, -1) ;"PAUSE"
						If $TPaused = False And $Runstate = True Then
							If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
								SetLog("PushBullet: Unable to pause during attack", $COLOR_RED)
								_PushBullet($iOrigPushBullet & " | " & GetTranslated(620,86, "Request to Pause") & "\n" & GetTranslated(620,87, "Unable to pause during attack, try again later."))
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
							SetLog("Pushbullet: Your bot is currently paused, no action was taken", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,86, "Request to Pause") & "\n" & GetTranslated(620,88, "Your bot is currently paused, no action was taken"))
						EndIf
						_DeleteMessageOfPushBullet($iden[$x])
					Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,19, -1) ;"RESUME"
						If $TPaused = True And $Runstate = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Pushbullet: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,27, "Request to Resume") & "\n" & GetTranslated(620,28, "Your bot is currently resumed, no action was taken"))
						EndIf
						_DeleteMessageOfPushBullet($iden[$x])
					Case GetTranslated(620,1, -1) & " " & GetTranslated(620,15, -1) ;"DELETE"
						_DeletePushOfPushBullet()
						SetLog("Pushbullet: Your request has been received.", $COLOR_GREEN)
					Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,21, -1) ;"LOG"
						SetLog("Pushbullet: Your request has been received from " & $iOrigPushBullet & ". Log is now sent", $COLOR_GREEN)
						_PushFileToPushBullet($sLogFName, GetTranslated(620,29, "logs"), "text/plain; charset=utf-8", $iOrigPushBullet & " | " & GetTranslated(620,30, "Current Log") & " \n")
						_DeleteMessageOfPushBullet($iden[$x])
					Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,22, -1) ;"LASTRAID"
						If $AttackFile <> "" Then
							_PushFileToPushBullet($AttackFile, GetTranslated(620,31, "Loots"), "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,32, "Last Raid") & " \n" & $AttackFile)
						Else
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,33, "There is no last raid screenshot") & ".")
						EndIf
						SetLog("Pushbullet: Push Last Raid Snapshot...", $COLOR_GREEN)
						_DeleteMessageOfPushBullet($iden[$x])
					Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(20,23, -1) ;"LASTRAIDTXT"
						SetLog("Pusbullet: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,34, "Last Raid txt") & "\n" & "[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620,38, "T") & "]: " & $iTrophyLast)
						_DeleteMessageOfPushBullet($iden[$x])
					Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,20, -1) ;"STATS"
						SetLog("Pushbullet: Your request has been received. Statistics sent", $COLOR_GREEN)
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,39, "Stats Village Report") & "\n" & GetTranslated(620,91, "At Start") & "\n[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($iGoldStart) & " [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($iElixirStart) & " [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($iDarkStart) & " [" & GetTranslated(620,38, "T") & "]: " & $iTrophyStart & "\n\n" & GetTranslated(620,40, "Now (Current Resources)") &"\n[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($iGoldCurrent) & " [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($iElixirCurrent) & " [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($iDarkCurrent) & " [" & GetTranslated(620,38, "T") & "]: " & $iTrophyCurrent & " [" & GetTranslated(620,41, "GEM") & "]: " & $iGemAmount & "\n \n [" & GetTranslated(620,42, "No. of Free Builders") & "]: " & $iFreeBuilderCount & "\n " & GetTranslated(620,43, "[No. of Wall Up]") & ": " & GetTranslated(620,35, "G") & ": " & $iNbrOfWallsUppedGold & "/ " & GetTranslated(620,36, "E") & ": " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(620,44, "Attacked") & ": " & GUICtrlRead($lblresultvillagesattacked) & "\n" & GetTranslated(620,45, "Skipped") & ": " & $iSkippedVillageCount)
						_DeleteMessageOfPushBullet($iden[$x])
					Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,24, -1) ;"SCREENSHOT"
						SetLog("Pushbullet: ScreenShot request received", $COLOR_GREEN)
						$RequestScreenshot = 1
						_DeleteMessageOfPushBullet($iden[$x])
					Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,16, -1) ;"RESTART"
						_DeleteMessageOfPushBullet($iden[$x])
						SetLog("Your request has been received. Bot and Android Emulator restarting...", $COLOR_GREEN)
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,46, "Request to Restart") & "..." & "\n" & GetTranslated(620,47, "Your bot and Android Emulator are now restarting") & "...")
						SaveConfig()
						_Restart()
					Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,17, -1) ;"STOP"
						_DeleteMessageOfPushBullet($iden[$x])
						SetLog("Your request has been received. Bot is now stopped", $COLOR_GREEN)
						If $Runstate = True Then
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,48, "Request to Stop") & "..." & "\n" & GetTranslated(620,49, "Your bot is now stopping") & "...")
							btnStop()
						Else
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,48, "Request to Stop") & "..." & "\n" & GetTranslated(620,50, "Your bot is currently stopped, no action was taken"))
						EndIf
					Case Else ;
						Local $lenstr = StringLen(GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & "")
						Local $teststr = StringLeft($body[$x], $lenstr)
						If $teststr = (GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & "") Then
							SetLog("Pushbullet: received command syntax wrong, command ignored.", $COLOR_RED)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,51, "Command not recognized") & "\n" & GetTranslated(620,52, "Please push BOT HELP to obtain a complete command list."))
							_DeleteMessageOfPushBullet($iden[$x])
						EndIf
				EndSwitch
				$body[$x] = ""
				$iden[$x] = ""
			EndIf
		Next
	EndIf
EndFunc   ;==>_RemoteControl

Func _PushBullet($pMessage = "")
	If $PushBulletEnabled = 0 Or $PushBulletToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	;$access_token = $PushBulletToken
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
	$oHTTP.SetCredentials($PushBulletToken, "", 0)
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText
	Local $device_iden = _StringBetween($Result, 'iden":"', '"')
	Local $device_name = _StringBetween($Result, 'nickname":"', '"')
	Local $device = ""
	Local $pDevice = 1
	$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($PushBulletToken, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN
	Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
	$oHTTP.Send($pPush)
EndFunc   ;==>_PushBullet

Func _PushToPushBullet($pMessage)
	If $PushBulletEnabled = 0 Or $PushBulletToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
	$access_token = $PushBulletToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN
	Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
	$oHTTP.Send($pPush)
EndFunc   ;==>_Push

Func _PushFileToPushBullet($File, $Folder, $FileType, $body)
	If $PushBulletEnabled = 0 Or $PushBulletToken = "" Then Return
	If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
		$access_token = $PushBulletToken
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
			SetLog("Pusbullet: Unable to send file " & $File, $COLOR_RED)
			_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,53, "Unable to Upload File") & "\n" & GetTranslated(620,54, "Occured an error type") & " 1 " & GetTranslated(620,55, "uploading file to PushBullet server") & "...")
		EndIf
	Else
		SetLog("Pushbullet: Unable to send file " & $File, $COLOR_RED)
		_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,53, "Unable to Upload File") & "\n" & GetTranslated(620,54, "Occured an error type") & " 2 " & GetTranslated(620,55, "uploading file to PushBullet server") & "...")
	EndIf
EndFunc   ;==>_PushFile

Func _DeletePushOfPushBullet()
	If $PushBulletEnabled = 0 Or $PushBulletToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("DELETE", "https://api.pushbullet.com/v2/pushes", False)
	$access_token = $PushBulletToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
EndFunc   ;==>_DeletePush

Func _DeleteMessageOfPushBullet($iden)
	If $PushBulletEnabled = 0 Or $PushBulletToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes/" & $iden, False)
	$access_token = $PushBulletToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$iden = ""
EndFunc   ;==>_DeleteMessage

Func PushMsgToPushBullet($Message, $Source = "")
	Local $hBitmap_Scaled
	Switch $Message
		Case "Restarted"
			If $PushBulletEnabled = 1 And $pRemote = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,56, "Bot restarted"))
		Case "OutOfSync"
			If $PushBulletEnabled = 1 And $pOOS = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,57, "Restarted after Out of Sync Error") & "\n" & GetTranslated(620,58, "Attacking now") & "...")
		Case "LastRaid"
			If $PushBulletEnabled = 1 And $iAlertPBLastRaidTxt = 1 Then
				_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,34, "Last Raid txt") & "\n" & "[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620,38, "T") & "]: " & $iTrophyLast)
				If _Sleep($iDelayPushMsg1) Then Return
				SetLog("Pushbullet: Last Raid Text has been sent!", $COLOR_GREEN)
			EndIf
			If $PushBulletEnabled = 1 And $pLastRaidImg = 1 Then
				_CaptureRegion()
				;create a temporary file to send with pushbullet...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				If $ScreenshotLootInfo = 1 Then
					$AttackFile = $Date & "__" & $Time & " " & GetTranslated(620,35, "G") & $iGoldLast & " " & GetTranslated(620,36, "E") & $iElixirLast & " " & GetTranslated(620,37, "D") & $iDarkLast & " " & GetTranslated(620,38, "T") & $iTrophyLast & " " & GetTranslated(620,59, "S") & StringFormat("%3s", $SearchCount) & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				Else
					$AttackFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				EndIf
				$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
				_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirLoots & $AttackFile)
				_GDIPlus_ImageDispose($hBitmap_Scaled)
				;push the file
				SetLog("Pushbullet: Last Raid screenshot has been sent!", $COLOR_GREEN)
				_PushFileToPushBullet($AttackFile, GetTranslated(620,31, "Loots"), "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,32, "Last Raid") & "\n" & $AttackFile)
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg1) Then Return
				Local $iDelete = FileDelete($dirLoots & $AttackFile)
				If Not ($iDelete) Then SetLog("Pushbullet: An error occurred deleting temporary screenshot file.", $COLOR_RED)
			EndIf
		Case "FoundWalls"
			If $PushBulletEnabled = 1 And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,60, "Found Wall level") & " " & $icmbWalls + 4 & "\n" & " " & GetTranslated(620,61, "Wall segment has been located") & "...\n" & GetTranslated(620,62, "Upgrading") & "...")
		Case "SkypWalls"
			If $PushBulletEnabled = 1 And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,63, "Cannot find Wall level") & $icmbWalls + 4 & "\n" & GetTranslated(620,64, "Skip upgrade") & "...")
		Case "AnotherDevice3600"
			If $PushBulletEnabled = 1 And $pAnotherDevice = 1 Then _PushToPushBullet($iOrigPushBullet & " | 1. " & GetTranslated(620,65, "Another Device has connected") & "\n" & GetTranslated(620,66, "Another Device has connected, waiting") & " " & Floor(Floor($sTimeWakeUp / 60) / 60) & " " & GetTranslated(603,14, "Hours") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice60"
			If $PushBulletEnabled = 1 And $pAnotherDevice = 1 Then _PushToPushBullet($iOrigPushBullet & " | 2. " & GetTranslated(620,65, "Another Device has connected") & "\n" & GetTranslated(620,66, "Another Device has connected, waiting") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice"
			If $PushBulletEnabled = 1 And $pAnotherDevice = 1 Then _PushToPushBullet($iOrigPushBullet & " | 3. " & GetTranslated(620,65, "Another Device has connected") & "\n" & GetTranslated(620,66, "Another Device has connected, waiting") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "TakeBreak"
			If $PushBulletEnabled = 1 And $pTakeAbreak = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,67, "Chief, we need some rest!") & "\n" & GetTranslated(620,68, "Village must take a break.."))
		Case "CocError"
			If $PushBulletEnabled = 1 And $pOOS = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,69, "CoC Has Stopped Error") & ".....")
		Case "Pause"
			If $PushBulletEnabled = 1 And $pRemote = 1 And $Source = "Push" Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,70, "Request to Pause") & "..." & "\n" & GetTranslated(620,71, "Your request has been received. Bot is now paused"))
		Case "Resume"
			If $PushBulletEnabled = 1 And $pRemote = 1 And $Source = "Push" Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,72, "Request to Resume") & "..." & "\n" & GetTranslated(620,73, "Your request has been received. Bot is now resumed"))
		Case "OoSResources"
			If $PushBulletEnabled = 1 And $pOOS = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,74, "Disconnected after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,75, "skip(s)") & "\n" & GetTranslated(620,76, "Cannot locate Next button, Restarting Bot") & "...")
		Case "MatchFound"
			If $PushBulletEnabled = 1 And $pMatchFound = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & $sModeText[$iMatchMode] & " " & GetTranslated(620,89, "Match Found! after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,75, "skip(s)") & "\n" & "[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($searchGold) & "; [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($searchElixir) & "; [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($searchDark) & "; [" & GetTranslated(620,38, "T") & "]: " & $searchTrophy)
		Case "UpgradeWithGold"
			If $PushBulletEnabled = 1 And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,77, "Upgrade completed by using GOLD") & "\n" & GetTranslated(620,78, "Complete by using GOLD") & "...")
		Case "UpgradeWithElixir"
			If $PushBulletEnabled = 1 And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,79, "Upgrade completed by using ELIXIR") & "\n" & GetTranslated(620,80, "Complete by using ELIXIR") & "...")
		Case "NoUpgradeWallButton"
			If $PushBulletEnabled = 1 And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,81, "No Upgrade Gold Button") & "\n" & GetTranslated(620,81, "Cannot find gold upgrade button") & "...")
		Case "NoUpgradeElixirButton"
			If $PushBulletEnabled = 1 And $pWallUpgrade = 1 Then _PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,82, "No Upgrade Elixir Button") & "\n" & GetTranslated(620,83, "Cannot find elixir upgrade button") & "...")
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion()
			$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirTemp & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			_PushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,84, "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
			SetLog("Pushbullet: Screenshot sent!", $COLOR_GREEN)
			$RequestScreenshot = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not ($iDelete) Then SetLog("Pushbullet: An error occurred deleting the temporary screenshot file.", $COLOR_RED)
		Case "DeleteAllPBMessages"
			_DeletePushOfPushBullet()
			SetLog("PushBullet: All messages deleted.", $COLOR_GREEN)
			$iDeleteAllPBPushesNow = False ; reset value
		Case "CampFull"
			If $PushBulletEnabled = 1 And $ichkAlertPBCampFull = 1 Then
				If $ichkAlertPBCampFullTest = 0 Then
					_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,85, "Your Army Camps are now Full"))
					$ichkAlertPBCampFullTest = 1
				EndIf
			EndIf
	EndSwitch
EndFunc   ;==>PushMsgToPushBullet

Func _DeleteOldPushesOfPushBullet()
	If $PushBulletEnabled = 0 Or $PushBulletToken = "" Or $ichkDeleteOldPBPushes = 0 Then Return
	;local UTC time
	Local $tLocal = _Date_Time_GetLocalTime()
	Local $tSystem = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($tLocal))
	Local $timeUTC = _Date_Time_SystemTimeToDateTimeStr($tSystem, 1)
	Local $timestamplimit = 0
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $timestamplimit, False) ; limit to 48h read push, antiban purpose
	$access_token = $PushBulletToken
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
					If $hdif >= $icmbHoursPushBullet Then
						;	setlog("Pushbullet, deleted message: (+" & $hdif & "h)" & $body[$x] )
						$msgdeleted += 1
						_DeleteMessageOfPushBullet($iden[$x])
						;else
						;	setlog("Pushbullet, skipped message: (+" & $hdif & "h)" & $body[$x] )
					EndIf
				EndIf
				$body[$x] = ""
				$iden[$x] = ""
			Next
		EndIf
	EndIf
	If $msgdeleted > 0 Then
		setlog("Pushbullet: removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ", $COLOR_GREEN)
		;_PushToPushBullet($iOrigPushBullet & " | removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ")
	EndIf
EndFunc   ;==>_DeleteOldPushes
