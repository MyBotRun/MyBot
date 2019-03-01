
; #FUNCTION# ====================================================================================================================
; Name ..........: ForumAuthentication
; Description ...: Verify that bot can authentication with forum
; Author ........: cosote (2019)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func ForumAuthentication()

	; load text so translation is upadted
	Local $sLogLogPleaseEnter = GetTranslatedFileIni("MBR Authentication", "LogPleaseEnter", "Please enter your Mybot.run Forum username and password")
	Local $sLogPasswordIsSave = GetTranslatedFileIni("MBR Authentication", "LogPasswordIsSave", "Your password is not saved anywhere and secure!")
	Local $sTitleUsername = GetTranslatedFileIni("MBR Authentication", "Username", "Username")
	Local $sTitlePassword = GetTranslatedFileIni("MBR Authentication", "Password", "Password")
	Local $sYouNeedToLogin = GetTranslatedFileIni("MBR Authentication", "YouNeedToLogin", "You need to login to MyBot.run Forum...")
	Local $sPleaseEnter = GetTranslatedFileIni("MBR Authentication", "PleaseEnter", "Please enter a username and password.")
	Local $sWelcome = GetTranslatedFileIni("MBR Authentication", "Welcome", "Welcome to MyBot.run!")
	Local $sLoginFailed = GetTranslatedFileIni("MBR Authentication", "LoginFailed", "Login failed, username or password was incorrect.")
	Local $sAuthenticationFailed1 = GetTranslatedFileIni("MBR Authentication", "AuthenticationFailed1", "Not authenticated with MyBot.run Forum, bot will not work!")
	Local $sAuthenticationFailed2 = GetTranslatedFileIni("MBR Authentication", "AuthenticationFailed2", "Please launch bot again and login to MyBot.run Forum!")
	Local $sLogin = GetTranslatedFileIni("MBR Authentication", "Login", "Login")
	Local $sExit = GetTranslatedFileIni("MBR Authentication", "Exit", "Exit")
	; used by MBRFunc.au3
	GetTranslatedFileIni("MBR Authentication", "BotIsAuthenticated", "MyBot.run is authenticated")
	GetTranslatedFileIni("MBR Authentication", "BotIsNotAuthenticated", "Error authenticating Mybot.run")

	If FileExists($g_sPrivateAuthenticationFile) = 0 Or Not CheckForumAuthentication() Then
		SetLog($sLogLogPleaseEnter, $COLOR_BLUE)
		SetLog($sLogPasswordIsSave, $COLOR_BLUE)

		Local $xyt = CreateSplashScreen("Form Login")
		Local $guiLogin = $g_hSplash
		Local $iW = $xyt[0]
		Local $iH = $xyt[1]
		Local $iT = $xyt[2]
		Local $iSpace = 20
		Local $iButtonTop = $iH - 20 - $iSpace
		GUICtrlCreateLabel($sTitleUsername, $iSpace, $iButtonTop - 22, 100, 20)
		Local $hUser = GUICtrlCreateInput("", $iSpace, $iButtonTop, 100, 20)
		GUICtrlSetLimit($hUser, 128, 1)
		GUICtrlCreateLabel($sTitlePassword, $iSpace + 100 + 5, $iButtonTop - 22, 100, 20)
		Local $hPass = GUICtrlCreateInput("", $iSpace + 100 + 5, $iButtonTop, 100, 20, BitOR($ES_PASSWORD, $GUI_SS_DEFAULT_INPUT))
		GUICtrlSetLimit($hPass, 128, 1)
		Local $iTextAddWidth = 30
		Local $hText = GUICtrlCreateLabel($sYouNeedToLogin, $iSpace + 100 + 5 + 100 + 5 - $iTextAddWidth, $iButtonTop - 22, $iW - $iSpace - ($iSpace + 100 + 5 + 100 + 5) + $iTextAddWidth, 20, $SS_RIGHT)
		Local $hLogin = GUICtrlCreateButton($sLogin, $iW - 50 - $iSpace, $iButtonTop, 50, 25, $BS_DEFPUSHBUTTON)
		Local $hExit = GUICtrlCreateButton($sExit, $iW - (50 + $iSpace + 50 + 5), $iButtonTop, 50, 25)

		ControlFocus($guiLogin, "", $hUser)

		Local $iOpt = Opt("GUIOnEventMode", 0)

		GUISetState(@SW_SHOW, $guiLogin)
		Local $bOk = False

		Local $hTimer = __TimerInit()
		While True
			Switch GUIGetMsg()
				Case $GUI_EVENT_CLOSE, $hExit
					ExitLoop
				Case $hLogin
					Local $sUser = GUICtrlRead($hUser)
					Local $sPass = GUICtrlRead($hPass)
					If $sUser = "" Or $sPass = "" Then
						GUICtrlSetData($hText, $sPleaseEnter)
					Else
						;SetDebugLog("ForumAuthentication: username=" & $sUser & ", password=" & $sPass) ; ONLY ENABLE WHEN YOU REALLY NEED TO VALIDATE YOUR INPUT
						Local $json = ForumLogin($sUser, $sPass)
						If StringInStr($json, '"access_token"') And CheckForumAuthentication() Then
							GUICtrlSetData($hText, $sWelcome)
							Sleep(1000)
							$bOk = True
							ExitLoop
						Else
							GUICtrlSetData($hText, $sLoginFailed)
						EndIf
					EndIf
				Case Else
					; move window
					_WinAPI_PostMessage($guiLogin, $WM_SYSCOMMAND, 0xF012, 0) ; SC_DRAGMOVE = 0xF012
			EndSwitch
			; exit after 15 Minutes, but: Bot will not run 100% stable!!!
			If __TimerDiff($hTimer) / 1000 > 15 * 60 Then
				SetLog($sAuthenticationFailed1, $COLOR_ERROR)
				SetLog($sAuthenticationFailed2, $COLOR_ERROR)
				$bOk = True
				ExitLoop
			EndIf
		WEnd

		GUIDelete($guiLogin)
		Opt("GUIOnEventMode", $iOpt)

		If Not $bOk Then BotClose()
	EndIf

	Return True
EndFunc   ;==>ForumAuthentication

