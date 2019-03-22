
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

Global Enum $g_eForumAuthenticationWaiting, $g_eForumAuthenticationLogin, $g_eForumAuthenticationExit
Global $g_hGuiForumAuthentication = 0
Global $g_hForumAuthenticationState = $g_eForumAuthenticationWaiting, $g_hForumAuthenticationLogin, $g_hForumAuthenticationExit, $g_hForumAuthenticationUser, $g_hForumAuthenticationPass

Func ForumAuthentication()

	; load text so translation is upadted
	Local $sLogLogPleaseEnter = GetTranslatedFileIni("MBR Authentication", "LogPleaseEnter", "Please enter your Mybot.run Forum username and password")
	Local $sLogPasswordIsSave = GetTranslatedFileIni("MBR Authentication", "LogPasswordIsSave", "Password is only used once to authenticate and nowhere saved!")
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

	Local $bNotAuthenticated = ($g_hGuiForumAuthentication <> 0)

	; check if migration is required
	Local $sOldFile = @MyDocumentsDir & "\MyBot.run-Profiles\.mybot.run.authentication"
	If FileExists($g_sPrivateAuthenticationFile) = 0 And FileExists($sOldFile) = 1 Then FileMove($sOldFile, $g_sPrivateAuthenticationFile)

	If FileExists($g_sPrivateAuthenticationFile) = 0 Or Not CheckForumAuthentication() Then

		If $bNotAuthenticated Then

			; Bot will not run 100% stable!!!
			SetLog($sAuthenticationFailed1, $COLOR_ERROR)
			SetLog($sAuthenticationFailed2, $COLOR_ERROR)
			_Sleep(5000)
			Return False

		Else

			SetLog($sLogLogPleaseEnter, $COLOR_BLUE)
			SetLog($sLogPasswordIsSave, $COLOR_BLUE)

			Local $xyt = CreateSplashScreen("Form Login")
			Local $guiLogin = $g_hSplash
			$g_hGuiForumAuthentication = $guiLogin
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
			$g_hForumAuthenticationLogin = GUICtrlCreateButton($sLogin, $iW - 50 - $iSpace, $iButtonTop, 50, 25, $BS_DEFPUSHBUTTON)
			GUICtrlSetOnEvent(-1, "ForumAuthenticationLogin")
			$g_hForumAuthenticationExit = GUICtrlCreateButton($sExit, $iW - (50 + $iSpace + 50 + 5), $iButtonTop, 50, 25)
			GUICtrlSetOnEvent(-1, "ForumAuthenticationExit")
			ControlFocus($guiLogin, "", $hUser)

			GUISetState(@SW_SHOW, $guiLogin)
			Local $bOk = False

			Local $hTimer = __TimerInit()
			While True
				Switch $g_hForumAuthenticationState
					Case $g_eForumAuthenticationLogin
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
					Case $g_eForumAuthenticationExit
						ExitLoop
				EndSwitch
				; exit after 15 Minutes, but: Bot will not run 100% stable!!!
				If __TimerDiff($hTimer) / 1000 > 15 * 60 Then
					SetLog($sAuthenticationFailed1, $COLOR_ERROR)
					SetLog($sAuthenticationFailed2, $COLOR_ERROR)
					$bOk = True
					ExitLoop
				EndIf
				$g_hForumAuthenticationState = $g_eForumAuthenticationWaiting ; reset state
				Sleep(100)
			WEnd

			GUIDelete($guiLogin)
			$g_hGuiForumAuthentication = 0

			If Not $bOk Then BotClose()

		EndIf
	EndIf

	Return True
EndFunc   ;==>ForumAuthentication

Func ForumAuthenticationLogin()
	$g_hForumAuthenticationState = $g_eForumAuthenticationLogin
EndFunc   ;==>ForumAuthenticationLogin

Func ForumAuthenticationExit()
	$g_hForumAuthenticationState = $g_eForumAuthenticationExit
EndFunc   ;==>ForumAuthenticationexit
