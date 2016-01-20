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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include <Array.au3>
#include <String.au3>

Func _RemoteControl()

    If $pEnabled = 0 Or $pRemote = 0 Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	Local $pushbulletApiUrl
	If $pushLastModified = 0 Then
		$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&limit=1" ; if this is the first time looking for pushes, get the last one
	Else
		$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $pushLastModified ; get the one pushed after the last one received
	EndIf
	$oHTTP.Open("Get", $pushbulletApiUrl, False)
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
					Case "BOT HELP"
						Local $txtHelp = "You can remotely control your bot sending commands following this syntax:"
						$txtHelp &= '\n' & "BOT HELP - send this help message"
						$txtHelp &= '\n' & "BOT DELETE  - delete all your previous Push message"
						$txtHelp &= '\n' & "BOT <Village Name> RESTART - restart the bot named <Village Name> and bluestacks"
						$txtHelp &= '\n' & "BOT <Village Name> STOP - stop the bot named <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> PAUSE - pause the bot named <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> RESUME   - resume the bot named <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> STATS - send Village Statistics of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> LOG - send the current log file of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> LASTRAID - send the last raid loot screenshot of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> LASTRAIDTXT - send the last raid loot values of <Village Name>"
						$txtHelp &= '\n' & "BOT <Village Name> SCREENSHOT - send a screenshot of <Village Name>"
						$txtHelp &= '\n'
						$txtHelp &= '\n' & "Examples:"
						$txtHelp &= '\n' & "Bot MyVillage Pause"
						$txtHelp &= '\n' & "Bot Delete "
						$txtHelp &= '\n' & "Bot MyVillage ScreenShot"
						_Push($iOrigPushB & " | Request for Help" & "\n" & $txtHelp)
						SetLog("Pushbullet: Your request has been received from ' " & $iOrigPushB & ". Help has been sent", $COLOR_GREEN)
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " PAUSE"
						If $TPaused = False And $Runstate = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Pushbullet: Your bot is currently paused, no action was taken", $COLOR_GREEN)
							_Push($iOrigPushB & " | Request to Pause" & "\n" & "Your bot is currently paused, no action was taken")
						EndIf
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " RESUME"
						If $TPaused = True And $Runstate = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Pushbullet: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
							_Push($iOrigPushB & " | Request to Resume" & "\n" & "Your bot is currently resumed, no action was taken")
						EndIf
						_DeleteMessage($iden[$x])
					Case "BOT DELETE"
						_DeletePush($PushToken)
						SetLog("Pushbullet: Your request has been received.", $COLOR_GREEN)
					Case "BOT " & StringUpper($iOrigPushB) & " LOG"
						SetLog("Pushbullet: Your request has been received from " & $iOrigPushB & ". Log is now sent", $COLOR_GREEN)
						_PushFile($sLogFName, "logs", "text/plain; charset=utf-8", $iOrigPushB & " | Current Log " & "\n")
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " LASTRAID"
						If $AttackFile <> "" Then
							_PushFile($AttackFile, "Loots", "image/jpeg", $iOrigPushB & " | Last Raid " & "\n" & $AttackFile)
						Else
							_Push($iOrigPushB & " | There is no last raid screenshot.")
						EndIf
						SetLog("Pushbullet: Push Last Raid Snapshot...", $COLOR_GREEN)
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " LASTRAIDTXT"
						SetLog("Pusbullet: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
						_Push($iOrigPushB & " | Last Raid txt" & "\n" & "[G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & " [T]: " & $iTrophyLast)
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " STATS"
						SetLog("Pushbullet: Your request has been received. Statistics sent", $COLOR_GREEN)
						_Push($iOrigPushB & " | Stats Village Report" & "\n" & "At Start\n[G]: " & _NumberFormat($iGoldStart) & " [E]: " & _NumberFormat($iElixirStart) & " [D]: " & _NumberFormat($iDarkStart) & " [T]: " & $iTrophyStart & "\n\nNow (Current Resources)\n[G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [D]: " & _NumberFormat($iDarkCurrent) & " [T]: " & $iTrophyCurrent & " [GEM]: " & $iGemAmount & "\n \n [No. of Free Builders]: " & $iFreeBuilderCount & "\n [No. of Wall Up]: G: " & $iNbrOfWallsUppedGold & "/ E: " & $iNbrOfWallsUppedElixir & "\n\nAttacked: " & GUICtrlRead($lblresultvillagesattacked) & "\nSkipped: " & $iSkippedVillageCount)
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " SCREENSHOT"
						SetLog("Pushbullet: ScreenShot request received", $COLOR_GREEN)
						$RequestScreenshot = 1
						_DeleteMessage($iden[$x])
					Case "BOT " & StringUpper($iOrigPushB) & " RESTART"
						_DeleteMessage($iden[$x])
						SetLog("Your request has been received. Bot and BS restarting...", $COLOR_GREEN)
						_Push($iOrigPushB & " | Request to Restart..." & "\n" & "Your bot and BS are now restarting...")
						SaveConfig()
						_Restart()
					Case "BOT " & StringUpper($iOrigPushB) & " STOP"
						_DeleteMessage($iden[$x])
						SetLog("Your request has been received. Bot is now stopped", $COLOR_GREEN)
						If $Runstate = True Then
							_Push($iOrigPushB & " | Request to Stop..." & "\n" & "Your bot is now stopping...")
							btnStop()
						Else
							_Push($iOrigPushB & " | Request to Stop..." & "\n" & "Your bot is currently stopped, no action was taken")
						EndIf
					Case Else
						Local $lenstr = StringLen("BOT " & StringUpper($iOrigPushB) & " ")
						Local $teststr = StringLeft($body[$x], $lenstr)
						If $teststr = ("BOT " & StringUpper($iOrigPushB) & " ") Then
							SetLog("Pushbullet: received command syntax wrong, command ignored.", $COLOR_RED)
							_Push($iOrigPushB & " | Command not recognized" & "\n" & "Please push BOT HELP to obtain a complete command list.")
							_DeleteMessage($iden[$x])
						EndIf
				EndSwitch

				$body[$x] = ""
				$iden[$x] = ""
			EndIf
		Next
	EndIf

EndFunc   ;==>_RemoteControl

Func _PushBullet($pMessage = "")

    If $pEnabled = 0 Or $PushToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText
	Local $device_iden = _StringBetween($Result, 'iden":"', '"')
	Local $device_name = _StringBetween($Result, 'nickname":"', '"')
	Local $device = ""
	Local $pDevice = 1
	$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN
	Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
	$oHTTP.Send($pPush)

EndFunc   ;==>_PushBullet

Func _Push($pMessage)

	If $pEnabled = 0 Or $PushToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN
	Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
	$oHTTP.Send($pPush)

EndFunc   ;==>_Push

Func _PushFile($File, $Folder, $FileType, $body)

    If $pEnabled = 0 Or $PushToken = "" Then Return

	If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$access_token = $PushToken
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
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
			_Push($iOrigPushB & " | Unable to Upload File" & "\n" & "Occured an error type 1 uploading file to PushBullet server...")
		EndIf
	Else
		SetLog("Pushbullet: Unable to send file " & $File, $COLOR_RED)
		_Push($iOrigPushB & " | Unable to Upload File" & "\n" & "Occured an error type 2 uploading file to PushBullet server...")
	EndIf

EndFunc   ;==>_PushFile

Func ReportPushBullet()

    If $pEnabled = 0 Then Return
	If $iAlertPBVillage = 1 Then
		_PushBullet($iOrigPushB & " | My Village:" & "\n" & " [G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [D]: " & _NumberFormat($iDarkCurrent) & "  [T]: " & _NumberFormat($iTrophyCurrent) & " [FB]: " & _NumberFormat($iFreeBuilderCount))
	EndIf

	If $iLastAttack = 1 Then
		If Not ($iGoldLast = "" And $iElixirLast = "") Then _PushBullet($iOrigPushB & " | Last Gain :" & "\n" & " [G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & "  [T]: " & _NumberFormat($iTrophyLast))
	EndIf
	If _Sleep($iDelayReportPushBullet1) Then Return
	checkMainScreen(False)

EndFunc   ;==>ReportPushBullet


Func _DeletePush($token)

    If $pEnabled = 0 Or $PushToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $token
	$oHTTP.Open("DELETE", "https://api.pushbullet.com/v2/pushes", False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()

EndFunc   ;==>_DeletePush

Func _DeleteMessage($iden)

    If $pEnabled = 0 Or $PushToken = "" Then Return
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes/" & $iden, False)
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$iden = ""

EndFunc   ;==>_DeleteMessage

Func PushMsg($Message, $Source = "")

    If $pEnabled = 0 Then Return
	Local $hBitmap_Scaled
	Switch $Message
		Case "Restarted"
			If $pEnabled = 1 And $pRemote = 1 Then _Push($iOrigPushB & " | Bot restarted")
		Case "OutOfSync"
			If $pEnabled = 1 And $pOOS = 1 Then _Push($iOrigPushB & " | Restarted after Out of Sync Error" & "\n" & "Attacking now...")
		Case "LastRaid"
			If $pEnabled = 1 And $iAlertPBLastRaidTxt = 1 Then
				_Push($iOrigPushB & " | Last Raid txt" & "\n" & "[G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & " [T]: " & $iTrophyLast)
				If _Sleep($iDelayPushMsg1) Then Return
				SetLog("Pushbullet: Last Raid Text has been sent!", $COLOR_GREEN)
			EndIf
			If $pEnabled = 1 And $pLastRaidImg = 1 Then
				_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT - 45)
				;create a temporary file to send with pushbullet...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				If $ScreenshotLootInfo = 1 Then
					$AttackFile = $Date & "__" & $Time & " G" & $iGoldLast & " E" & $iElixirLast & " DE" & $iDarkLast & " T" & $iTrophyLast & " S" & StringFormat("%3s", $SearchCount) & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				Else
					$AttackFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				EndIf
				$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
				_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirLoots & $AttackFile)
				_GDIPlus_ImageDispose($hBitmap_Scaled)
				;push the file
				SetLog("Pushbullet: Last Raid screenshot has been sent!", $COLOR_GREEN)
				_PushFile($AttackFile, "Loots", "image/jpeg", $iOrigPushB & " | Last Raid" & "\n" & $AttackFile)
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg1) Then Return
				Local $iDelete = FileDelete($dirLoots & $AttackFile)
				If Not ($iDelete) Then SetLog("Pushbullet: An error occurred deleting temporary screenshot file.", $COLOR_RED)
			EndIf
		Case "FoundWalls"
			If $pEnabled = 1 And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | Found Wall level " & $icmbWalls + 4 & "\n" & " Wall segment has been located...\nUpgrading ...")
		Case "SkypWalls"
			If $pEnabled = 1 And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | Cannot find Wall level " & $icmbWalls + 4 & "\n" & "Skip upgrade ...")
		Case "AnotherDevice3600"
			If $pEnabled = 1 And $pAnotherDevice = 1 Then _Push($iOrigPushB & " | 1. Another Device has connected" & "\n" & "Another Device has connected, waiting " & Floor(Floor($sTimeWakeUp / 60) / 60) & " hours " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " minutes " & Floor(Mod($sTimeWakeUp, 60)) & " seconds")
		Case "AnotherDevice60"
			If $pEnabled = 1 And $pAnotherDevice = 1 Then _Push($iOrigPushB & " | 2. Another Device has connected" & "\n" & "Another Device has connected, waiting " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " minutes " & Floor(Mod($sTimeWakeUp, 60)) & " seconds")
		Case "AnotherDevice"
			If $pEnabled = 1 And $pAnotherDevice = 1 Then _Push($iOrigPushB & " | 3. Another Device has connected" & "\n" & "Another Device has connected, waiting " & Floor(Mod($sTimeWakeUp, 60)) & " seconds")
		Case "TakeBreak"
			If $pEnabled = 1 And $pTakeAbreak = 1 Then _Push($iOrigPushB & " | Chief, we need some rest!" & "\n" & "Village must take a break..")
		Case "CocError"
			If $pEnabled = 1 And $pOOS = 1 Then _Push($iOrigPushB & " | CoC Has Stopped Error .....")
		Case "Pause"
			If $pEnabled = 1 And $pRemote = 1 And $Source = "Push" Then _Push($iOrigPushB & " | Request to Pause..." & "\n" & "Your request has been received. Bot is now paused")
		Case "Resume"
			If $pEnabled = 1 And $pRemote = 1 And $Source = "Push" Then _Push($iOrigPushB & " | Request to Resume..." & "\n" & "Your request has been received. Bot is now resumed")
		Case "OoSResources"
			If $pEnabled = 1 And $pOOS = 1 Then _Push($iOrigPushB & " | Disconnected after " & StringFormat("%3s", $SearchCount) & " skip(s)" & "\n" & "Cannot locate Next button, Restarting Bot...")
		Case "MatchFound"
			If $pEnabled = 1 And $pMatchFound = 1 Then _Push($iOrigPushB & " | " & $sModeText[$iMatchMode] & " Match Found! after " & StringFormat("%3s", $SearchCount) & " skip(s)" & "\n" & "[G]: " & _NumberFormat($searchGold) & "; [E]: " & _NumberFormat($searchElixir) & "; [D]: " & _NumberFormat($searchDark) & "; [T]: " & $searchTrophy)
		Case "UpgradeWithGold"
			If $pEnabled = 1 And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | Upgrade completed by using GOLD" & "\n" & "Complete by using GOLD ...")
		Case "UpgradeWithElixir"
			If $pEnabled = 1 And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | Upgrade completed by using ELIXIR" & "\n" & "Complete by using ELIXIR ...")
		Case "NoUpgradeWallButton"
			If $pEnabled = 1 And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | No Upgrade Gold Button" & "\n" & "Cannot find gold upgrade button ...")
		Case "NoUpgradeElixirButton"
			If $pEnabled = 1 And $pWallUpgrade = 1 Then _Push($iOrigPushB & " | No Upgrade Elixir Button" & "\n" & "Cannot find elixir upgrade button ...")
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT)
			$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirTemp & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			_PushFile($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushB & " | Screenshot of your village " & "\n" & $Screnshotfilename)
			SetLog("Pushbullet: Screenshot sent!", $COLOR_GREEN)
			$RequestScreenshot = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not ($iDelete) Then SetLog("Pushbullet: An error occurred deleting the temporary screenshot file.", $COLOR_RED)
		Case "DeleteAllPBMessages"
			_DeletePush(GUICtrlRead($PushBTokenValue))
			SetLog("PushBullet: All messages deleted.", $COLOR_GREEN)
			$iDeleteAllPushesNow = False ; reset value
		Case "CampFull"
			If $pEnabled = 1 And $ichkAlertPBCampFull = 1 Then
				If $ichkAlertPBCampFullTest = 0 Then
					_Push($iOrigPushB & " | Your Army Camps are now Full")
					$ichkAlertPBCampFullTest = 1
				EndIf
			EndIf
	EndSwitch

EndFunc   ;==>PushMsg


Func _DeleteOldPushes()

    If $pEnabled = 0 Or $PushToken = "" Or $ichkDeleteOldPushes = 0 Then Return
	;local UTC time
	Local $tLocal = _Date_Time_GetLocalTime()
	Local $tSystem = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($tLocal))
	Local $timeUTC = _Date_Time_SystemTimeToDateTimeStr($tSystem, 1)

	;local $timestamplimit = _DateDiff( 's',"1970/01/01 00:00:00", _DateAdd("h",-48,$timeUTC) ) ; limit to 48h read push, antiban purpose
	Local $timestamplimit = 0

	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$access_token = $PushToken
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $timestamplimit, False) ; limit to 48h read push, antiban purpose
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
						_DeleteMessage($iden[$x])
						;else
						;	setlog("Pushbullet, skypped message: (+" & $hdif & "h)" & $body[$x] )
					EndIf
				EndIf
				$body[$x] = ""
				$iden[$x] = ""
			Next
		EndIf
	EndIf
	If $msgdeleted > 0 Then
		setlog("Pushbullet: removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ", $COLOR_GREEN)
		;_Push($iOrigPushB & " | removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ")
	EndIf

EndFunc   ;==>_DeleteOldPushes


Func _GetDateFromUnix($nPosix)

    If $pEnabled = 0 Then Return

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
	;   Return $nDay & "/" & $nMon & "/" & $nYear & " " & $nHour & ":" & $nMin & ":" & $nSec
	Return $nYear & "-" & $nMon & "-" & $nDay & " " & $nHour & ":" & $nMin & ":" & StringFormat("%02i", $nSec)

EndFunc   ;==>_GetDateFromUnix