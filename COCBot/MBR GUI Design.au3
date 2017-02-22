; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#cs
The MBR GUI is a nested tabbed design.  This file is called from MyBot.run.au3 to begin the build.  Other files are called as follows:

MBR GUI Design.au3; CreateMainGUI()
   MBR GUI Design Bottom.au3; CreateBottomPanel()

   MBR GUI Design Log.au3; CreateLogTab()

   MBR GUI Design Village.au3; CreateVillageTab()
	  MBR GUI Design Child Village - Misc.au3; CreateVillageMisc()
	  MBR GUI Design Child Village - Donate.au3; CreateVillageDonate()
	  MBR GUI Design Child Village - Upgrade.au3; CreateVillageUpgrade()
	  MBR GUI Design Child Village - Achievements.au3; CreateVillageAchievements()
	  MBR GUI Design Child Village - Notify.au3; CreateVillageNotify()

   MBR GUI Design Attack.au3; CreateAttackTab()
	  MBR GUI Design Child Attack - Troops.au3; CreateAttackTroops()
	  MBR GUI Design Child Attack - Search.au3; CreateAttackSearch()
		 MBR GUI Design Child Attack - Deadbase.au3; CreateAttackSearchDeadBase()
			MBR GUI Design Child Attack - Deadbase Attack Standard.au3; CreateAttackSearchDeadBaseStandard()
			MBR GUI Design Child Attack - Deadbase Attack Scripted.au3; CreateAttackSearchDeadBaseScripted()
			MBR GUI Design Child Attack - Deadbase Attack Milking.au3; CreateAttackSearchDeadBaseMilking()
			MBR GUI Design Child Attack - Deadbase-Search.au3; CreateAttackSearchDeadBaseSearch()
			MBR GUI Design Child Attack - Deadbase-Attack.au3; CreateAttackSearchDeadBaseAttack()
			MBR GUI Design Child Attack - Deadbase-EndBattle.au3; CreateAttackSearchDeadBaseEndBattle()
			MBR GUI Design Child Attack - Deadbase-Collectors.au3; CreateAttackSearchDeadBaseCollectors()
		 MBR GUI Design Child Attack - Activebase.au3; CreateAttackSearchActiveBase()
			MBR GUI Design Child Attack - Activebase Attack Standard.au3; CreateAttackSearchActiveBaseStandard()
			MBR GUI Design Child Attack - Activebase Attack Scripted.au3; CreateAttackSearchActiveBaseScripted()
			MBR GUI Design Child Attack - Activebase-Search.au3; CreateAttackSearchActiveBaseSearch()
			MBR GUI Design Child Attack - Activebase-Attack.au3; CreateAttackSearchActiveBaseAttack()
			MBR GUI Design Child Attack - Activebase-EndBattle.au3; CreateAttackSearchActiveBaseEndBattle()
		 MBR GUI Design Child Attack - THSnipe.au3; CreateAttackSearchTHSnipe()
			MBR GUI Design Child Attack - THSnipe-Search.au3; CreateAttackSearchTHSnipeSearch()
			MBR GUI Design Child Attack - THSnipe-Attack.au3; CreateAttackSearchTHSnipeAttack()
			MBR GUI Design Child Attack - THSnipe-EndBattle.au3; CreateAttackSearchTHSnipeEndBattle()
		 MBR GUI Design Child Attack - Bully.au3; CreateAttackSearchBully()
		 MBR GUI Design Child Attack - Options.au3; CreateAttackSearchOptions()
			MBR GUI Design Child Attack - Options-Search.au3; CreateAttackSearchOptionsSearch()
			MBR GUI Design Child Attack - Options-Attack.au3; CreateAttackSearchOptionsAttack()
			MBR GUI Design Child Attack - NewSmartZap.au3; CreateAttackNewSmartZap()
			MBR GUI Design Child Attack - Options-EndBattle.au3;CreateAttackSearchOptionsEndBattle()
			MBR GUI Design Child Attack - Options-TrophySettings.au3; CreateAttackSearchOptionsTrophySettings()
	  MBR GUI Design Child Attack - Strategies.au3; CreateAttackStrategies()

   MBR GUI Design Bot.au3; CreateBotTab()
	  MBR GUI Design Child Bot - Options.au3; CreateBotOptions()
	  MBR GUI Design Child Bot - Android.au3; CreateBotAndroid()
	  MBR GUI Design Child Bot - Debug.au3; CreateBotDebug()
	  MBR GUI Design Child Bot - Profiles.au3; CreateBotProfiles()
	  MBR GUI Design Child Bot - Stats.au3; CreateBotStats()
#ce

#include-once

#include "Functions\Other\AppUserModelId.au3"
#include "Functions\GUI\_GUICtrlSetTip.au3"
#include "functions\GUI\_GUICtrlCreatePic.au3"
#include "functions\GUI\GUI_State.au3"

Global Const $TCM_SETITEM = 0x1306
Global Const $_GUI_MAIN_WIDTH = 470
Global Const $_GUI_MAIN_HEIGHT = 690
Global Const $_GUI_MAIN_TOP = 5
Global Const $_GUI_BOTTOM_HEIGHT = 135
Global Const $_GUI_CHILD_LEFT = 10
Global Const $_GUI_CHILD_TOP = 110 + $_GUI_MAIN_TOP
Global Const $g_bBtnColor = False; True

Global $hImageList = 0
Global $g_hFrmBotEx = 0, $g_hFrmBotBottom = 0, $g_hFrmBotEmbeddedShield = 0, $g_hFrmBotEmbeddedShieldInput = 0, $g_hFrmBotEmbeddedGraphics = 0
Global $g_hFrmBot_MAIN_PIC = 0, $g_hFrmBot_URL_PIC = 0
Global $g_hTabMain = 0, $g_hTabLog = 0, $g_hTabVillage = 0, $g_hTabAttack = 0, $g_hTabBot = 0, $g_hTabAbout = 0
Global $g_hStatusBar = 0
Global $g_hTiShow = 0, $g_hTiHide = 0, $g_hTiDonate = 0, $g_hTiAbout = 0, $g_hTiExit = 0
Global $g_aFrmBotPosInit[7] = [0, 0, 0, 0, 0, 0, 0]
Global $g_hFirstControlToHide = 0, $g_hLastControlToHide = 0, $g_aiControlPrevState[1]
Global $g_bFrmBotMinimized = False ; prevents bot flickering

#include "GUI\MBR GUI Design Bottom.au3"
#include "GUI\MBR GUI Design Log.au3"
#include "GUI\MBR GUI Design Village.au3"
#include "GUI\MBR GUI Design Attack.au3"
#include "GUI\MBR GUI Design Bot.au3"
#include "GUI\MBR GUI Design About.au3"

Func CreateMainGUI()

   ;~ ------------------------------------------------------
   ;~ Main GUI
   ;~ ------------------------------------------------------
   SplashStep(GetTranslated(500, 23, "Loading Main GUI..."))
   $g_hFrmBot = GUICreate($g_sBotTitle, $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT + $_GUI_MAIN_TOP, $frmBotPosX, $frmBotPosY, _
						  BitOr($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS))

   ; group multiple bot windows using _WindowAppId
   _WindowAppId($g_hFrmBot, "MyBot.run")
   GUISetIcon($g_sLibIconPath, $eIcnGUI)
   TraySetIcon($g_sLibIconPath, $eIcnGUI)
   TraySetToolTip($g_sBotTitle)

   ; Need $g_hFrmBotEx for embedding Android
   $g_hFrmBotEx = GUICreate("", $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, 0, 0, _
						    BitOR($WS_CHILD, $WS_TABSTOP), $WS_EX_TOPMOST, $g_hFrmBot)
   GUICtrlCreateLabel("", 0, 0, $_GUI_MAIN_WIDTH, 5)
   GUICtrlSetBkColor(-1, $COLOR_WHITE)
   $g_hFrmBot_MAIN_PIC = _GUICtrlCreatePic($g_sLogoPath, 0, $_GUI_MAIN_TOP, $_GUI_MAIN_WIDTH, 67)
   $g_hFrmBot_URL_PIC = _GUICtrlCreatePic($g_sLogoUrlPath, 0, $_GUI_MAIN_TOP + 67, $_GUI_MAIN_WIDTH, 13)
   GUICtrlSetCursor(-1, 0)

   $hToolTip = _GUIToolTip_Create($g_hFrmBot) ; tool tips for URL links etc
   _GUIToolTip_SetMaxTipWidth($hToolTip, $_GUI_MAIN_WIDTH) ; support multiple lines

   GUISwitch($g_hFrmBot)
   $g_hFrmBotEmbeddedShieldInput = GUICtrlCreateInput("", 0, 0, -1, -1, $WS_TABSTOP)
   ;$g_hFrmBotEmbeddedShieldInput = GUICtrlCreateLabel("", 0, 0, 0, 0, $WS_TABSTOP)
   ;$g_hFrmBotEmbeddedShieldInput = GUICtrlCreateDummy()
   GUICtrlSetState($g_hFrmBotEmbeddedShieldInput, $GUI_HIDE)

   $g_hFrmBotBottom = GUICreate("", $_GUI_MAIN_WIDTH, $_GUI_BOTTOM_HEIGHT, 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, _
							    BitOR($WS_CHILD, $WS_TABSTOP), $WS_EX_TOPMOST, $g_hFrmBot)

   ;~ ------------------------------------------------------
   ;~ Header Menu
   ;~ ------------------------------------------------------
   GUISwitch($g_hFrmBot)
   ;$idMENU_DONATE = GUICtrlCreateMenu("&" & GetTranslated(601,18,"Paypal Donate?"))
   ;_GUICtrlMenu_SetItemType(_GUICtrlMenu_GetMenu($g_hFrmBot), 0, $MFT_RIGHTJUSTIFY) ; move to right
   ;$idMENU_DONATE_SUPPORT = GUICtrlCreateMenuItem(GetTranslated(601,19,"Support the development"), $idMENU_DONATE)
   ;GUICtrlSetOnEvent(-1, "")

   ;~ ------------------------------------------------------
   ;~ GUI Bottom Panel
   ;~ ------------------------------------------------------
   SplashStep(GetTranslated(500, 24, "Loading GUI Bottom..."))
   GUISwitch($g_hFrmBotBottom)
   CreateBottomPanel()

   ;~ ------------------------------------------------------
   ;~ GUI Child Tab Files
   ;~ ------------------------------------------------------
   GUISwitch($g_hFrmBotEx)

   ; This dummy is used in btnStart and btnStop to disable/enable all labels, text, buttons etc. on all tabs.
   $g_hFirstControlToHide = GUICtrlCreateDummy()

   SplashStep(GetTranslated(500, 25, "Loading Log tab..."))
   CreateLogTab()

   SplashStep(GetTranslated(500, 26, "Loading Village tab..."))
   CreateVillageTab()

   SplashStep(GetTranslated(500, 27, "Loading Attack tab..."))
   CreateAttackTab()

   SplashStep(GetTranslated(500, 28, "Loading Bot tab..."))
   CreateBotTab()

   SplashStep(GetTranslated(500, 29, "Loading About Us tab..."))
   CreateAboutTab()

   SplashStep(GetTranslated(500, 30, "Initializing GUI..."))

   ;~ ------------------------------------------------------
   ;~ GUI Main Tab Control
   ;~ ------------------------------------------------------
   GUISwitch($g_hFrmBotEx)
   $g_hTabMain = GUICtrlCreateTab(5, 85 + $_GUI_MAIN_TOP, $_GUI_MAIN_WIDTH - 9, $_GUI_MAIN_HEIGHT - 225); , $TCS_MULTILINE)
   $g_hTabLog = GUICtrlCreateTabItem(GetTranslated(600,1, "Log"))
   $g_hTabVillage = GUICtrlCreateTabItem(GetTranslated(600,2, "Village"))
   $g_hTabAttack = GUICtrlCreateTabItem(GetTranslated(600,3,"Attack Plan"))
   $g_hTabBot = GUICtrlCreateTabItem(GetTranslated(600,4,"Bot"))
   $g_hTabAbout = GUICtrlCreateTabItem(GetTranslated(600, 5, "About Us"))
   GUICtrlCreateTabItem("")
   GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

   ;~ -------------------------------------------------------------
   ;~ GUI init
   ;~ -------------------------------------------------------------
   ; Bind Icon images to all Tabs in all GUI windows (main and children)
   Bind_ImageList($g_hTabMain)

   Bind_ImageList($g_hGUI_VILLAGE_TAB)
	  Bind_ImageList($g_hGUI_DONATE_TAB)
	  Bind_ImageList($g_hGUI_UPGRADE_TAB)
	  Bind_ImageList($g_hGUI_NOTIFY_TAB)

   Bind_ImageList($g_hGUI_ATTACK_TAB)
	  Bind_ImageList($g_hGUI_TRAINARMY_TAB)
	  Bind_ImageList($g_hGUI_SEARCH_TAB)
		 Bind_ImageList($g_hGUI_DEADBASE_TAB)
		 Bind_ImageList($g_hGUI_ACTIVEBASE_TAB)
		 Bind_ImageList($g_hGUI_THSNIPE_TAB)
		 Bind_ImageList($g_hGUI_ATTACKOPTION_TAB)
	  Bind_ImageList($g_hGUI_STRATEGIES_TAB)

   Bind_ImageList($g_hGUI_BOT_TAB)

   Bind_ImageList($g_hGUI_STATS_TAB)

   ; Show Tab LOG
   GUICtrlSetState($g_hGUI_LOG, $GUI_SHOW)

   ; Create log window
   cmbLog()

   ; Bottom status bar
   $g_hStatusBar = _GUICtrlStatusBar_Create($g_hFrmBotBottom)
   _GUICtrlStatusBar_SetSimple($g_hStatusBar)
   _GUICtrlStatusBar_SetText($g_hStatusBar, "Status : Idle")
   $g_hTiShow = TrayCreateItem(GetTranslated(500,31,"Show bot"))
   TrayItemSetOnEvent($g_hTiShow, "tiShow")
   $g_hTiHide = TrayCreateItem(GetTranslated(500,32, "Hide when minimized"))
   TrayItemSetOnEvent($g_hTiHide, "tiHide")
   TrayCreateItem("")
   $g_hTiDonate = TrayCreateItem(GetTranslated(500,33, "Support Development"))
   TrayItemSetOnEvent($g_hTiDonate, "tiDonate")
   $g_hTiAbout = TrayCreateItem(GetTranslated(500,34, "About"))
   TrayItemSetOnEvent($g_hTiAbout, "tiAbout")
   TrayCreateItem("")
   $g_hTiExit = TrayCreateItem(GetTranslated(500,35, "Exit"))
   TrayItemSetOnEvent($g_hTiExit, "tiExit")


   If $g_hLibFunctions <> -1 Then
	   ;enable buttons start and search mode only if MRBfunctions.dll loaded, prevent click of buttons before dll loaded in memory
	   GUICtrlSetState($g_hBtnStart, $GUI_ENABLE)
	   ; enable search only button when TH level variable has valid level, to avoid posts from users not pressing start first
	   If $iTownHallLevel > 2 Then
		   GUICtrlSetState($g_hBtnSearchMode, $GUI_ENABLE)
	   EndIf
   EndIf

   ;~ -------------------------------------------------------------
   SetDebugLog("$g_hFrmBot=" & $g_hFrmBot, Default, True)
   SetDebugLog("$g_hFrmBotEx=" & $g_hFrmBotEx, Default, True)
   SetDebugLog("$g_hFrmBotBottom=" & $g_hFrmBotBottom, Default, True)
   SetDebugLog("$g_hFrmBotEmbeddedShield=" & $g_hFrmBotEmbeddedShield, Default, True)
   SetDebugLog("$g_hFrmBotEmbeddedShieldInput=" & $g_hFrmBotEmbeddedShieldInput, Default, True)
   SetDebugLog("$g_hFrmBotEmbeddedGraphics=" & $g_hFrmBotEmbeddedGraphics, Default, True)

EndFunc

Func ShowMainGUI()
   If Not $g_bNoFocusTampering Then
	   ; normal
	   GUISetState(@SW_SHOW, $g_hFrmBot)
   Else
	   GUISetState(@SW_SHOW, $g_hFrmBot)
	   ;GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBot)
	   ;Local $lCurExStyle = _WinAPI_GetWindowLong($g_hFrmBot, $GWL_EXSTYLE)
	   ;_WinAPI_SetWindowLong($HWnd, $GWL_EXSTYLE, BitOR($lCurExStyle, $WS_EX_TOPMOST))
	   ;_WinAPI_SetWindowLong($HWnd, $GWL_EXSTYLE, $lCurExStyle)
   EndIf

   GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotEx)
   GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotBottom)
   GUISwitch($g_hFrmBotEx)
   $g_bFrmBotMinimized = False

   Local $p = WinGetPos($g_hFrmBot)
   $g_aFrmBotPosInit[0] = $p[0]
   $g_aFrmBotPosInit[1] = $p[1]
   $g_aFrmBotPosInit[2] = $p[2]
   $g_aFrmBotPosInit[3] = $p[3]
   $g_aFrmBotPosInit[4] = _WinAPI_GetClientWidth($g_hFrmBot)
   $g_aFrmBotPosInit[5] = _WinAPI_GetClientHeight($g_hFrmBot)
   $g_aFrmBotPosInit[6] = ControlGetPos($g_hFrmBot, "", $g_hFrmBotEx)[3]
EndFunc
