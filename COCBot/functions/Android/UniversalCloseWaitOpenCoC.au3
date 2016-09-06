; #FUNCTION# ====================================================================================================================
; Name ..........: UniversalCloseWaitOpenCoC
; Description ...: Closes game app with back button to notify servers of exit, waits to reopen game
;					  :
; Syntax ........: PoliteCloseOpenCoc($iWaitTime, $sSource, $StopEmulator)
; Parameters ....: $iWaitTime           - an integer value of milliseconds wait time betwen close and open game
; 					  : $sSource             - Not optional string value with name of calling function to display for error logs
; 					  : $StopEmulator		 	 - Boolean flag or string "random", true will stop/close emulator after closing CoC app, "random" will let code pick close status, "idle" will let app time out
; 					  : $bFullRestart			 - Optional boolean flag when not closing emulator to force full restart in WaitnOpenCoc
; Return values .: None
; Author ........: MonkeyHunter (04-2016)
; Modified ......: Cosote (06-2016), MonkeyHunter (07-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func UniversalCloseWaitOpenCoC($iWaitTime = 0, $sSource = "RudeUnknownProgrammer_", $StopEmulator = False, $bFullRestart = False)

	If $debugsetlog = 1 Then Setlog("Begin UniversalCloseWaitOpenCoC:", $COLOR_PURPLE)

	Local $sWaitTime = ""
	Local $iMin, $iSec, $iHour, $iWaitSec, $StopAndroidFlag

	If $iWaitTime > 0 Then
		; create readable wait time message for user/log
		$iWaitSec = Round($iWaitTime / 1000)
		$iHour = Floor(Floor($iWaitSec / 60) / 60)
		$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
		$iSec = Floor(Mod($iWaitSec, 60))
		If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
		If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		If $iSec > 0 Then $sWaitTime &= $iSec & " seconds "
	EndIf
	Local $msg = ""
	Select ; error check input parameter and set $StopAndroidFlag
		Case StringInStr($StopEmulator, "rand", $STR_NOCASESENSEBASIC)
			$StopAndroidFlag = Random(0, 2, 1) ; Determine random close emulator flag value
			Switch $StopAndroidFlag
				Case 0
					$msg = " =Time out"
				Case 1
					$msg = " =Close CoC"
				Case 2
					$msg = " =Close Android"
				Case Else
					$msg = "One Bad Monkey Error!"
			EndSwitch
			Setlog("Random close option= " & $StopAndroidFlag & $msg, $COLOR_GREEN)
		Case StringInStr($StopEmulator, "idle", $STR_NOCASESENSEBASIC)
			$StopAndroidFlag = 0
		Case $StopEmulator = 0 Or $StopEmulator = "0" Or $StopEmulator = False
			$StopAndroidFlag = 1
		Case $StopEmulator = 1 Or $StopEmulator = "1" Or $StopEmulator = True
			$StopAndroidFlag = 2
		Case Else
			$StopAndroidFlag = 1
			SetLog("Code Monkey provided bad stop emulator flag value", $COLOR_RED)
	EndSelect
	If $debugsetlog = 1 Then Setlog("Stop Android flag : Input flag " & $StopAndroidFlag & " : " & $StopEmulator, $COLOR_PURPLE)
	If _Sleep($iDelayRespond) Then Return False

	Switch $StopAndroidFlag
		Case 0 ; Do nothing while waiting, Let app time out
			If $iWaitTime > 0 Then
				SetLog("Going idle for " & $sWaitTime & "before starting CoC", $COLOR_GREEN)
				If _SleepStatus($iWaitTime) Then Return False
			Else
				If _SleepStatus($iDelayWaitnOpenCoC10000) Then Return False ; if waittime = 0 then only wait 10 seconds before restart
			EndIf
			If _Sleep($iDelayRespond) Then Return False
			OpenCoC()
		Case 1 ; close CoC app only
			PoliteCloseCoC($sSource)
			If _Sleep(3000) Then Return False ; Wait 3 sec.
			If $iWaitTime > 0 Then
				If $iWaitTime > 30000 Then
					AndroidShieldForceDown(True)
					EnableGuiControls() ; enable bot controls is more than 30 seconds wait time
					SetLog("Enabled bot controls due to long wait time", $COLOR_GREEN)
				EndIf
				WaitnOpenCoC($iWaitTime, $bFullRestart)
				AndroidShieldForceDown(False)
				If $RunState = False Then Return False
			Else
				WaitnOpenCoC($iDelayWaitnOpenCoC10000, $bFullRestart) ; if waittime = 0 then only wait 10 seconds before restart
			EndIf
			If _Sleep($iDelayRespond) Then Return False
			If $iWaitTime > 30000 Then
				; ensure possible changes are populated
				SaveConfig()
				readConfig()
				applyConfig()
				DisableGuiControls()
			EndIf
		Case 2 ; Close emulator
			PoliteCloseCoC($sSource)
			If _Sleep(3000) Then Return False ; Wait 3 sec.
			CloseAndroid()
			If $iWaitTime > 0 Then
				SetLog("Waiting " & $sWaitTime & "before starting CoC", $COLOR_GREEN)
				If $iWaitTime > 30000 Then
					EnableGuiControls() ; enable bot controls is more than 30 seconds wait time
					SetLog("Enabled bot controls due to long wait time", $COLOR_GREEN)
				EndIf
				If _SleepStatus($iWaitTime) Then Return False ; Wait for set requested
				If $iWaitTime > 30000 Then
					; ensure possible changes are populated
					SaveConfig()
					readConfig()
					applyConfig()
					DisableGuiControls()
				EndIf
			Else
				If _SleepStatus($iDelayWaitnOpenCoC10000) Then Return False
			EndIf
			StartAndroidCoC()
		Case Else
			SetLog("Code Monkey is drinking banana liqueur again!", $COLOR_RED)
	EndSwitch

EndFunc   ;==>UniversalCloseWaitOpenCoC
