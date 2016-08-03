; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Global Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Everyone all the time  :)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include <Math.au3> ; Added for Weak Base
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3> ; Added for Profiles
#include <GuiImageList.au3> ; Added for Profiles
#include <GuiStatusBar.au3>
#include <GUIEdit.au3>
#include <GUIComboBox.au3>
#include <GuiSlider.au3>
#include <GuiToolBar.au3>
#include <ProgressConstants.au3> ; Added for Splash
#include <StaticConstants.au3>
#include <TabConstants.au3>
;#include <WindowsConstants.au3> ; included on MBR Bot.au3
#include <WinAPIProc.au3>
#include <ScreenCapture.au3>
#include <Array.au3>
#include <Date.au3>
#include <Misc.au3>
#include <File.au3>
#include <TrayConstants.au3>
#include <GUIMenu.au3>
#include <ColorConstants.au3>
#include <GDIPlus.au3>
#include <GuiRichEdit.au3>
#include <INet.au3>
#include <GuiTab.au3>
#include <String.au3>
#include <IE.au3>
#include <Process.au3>
#include <GuiListView.au3>
#include <GUIToolTip.au3>

Global Const $GAME_WIDTH = 860
Global Const $GAME_HEIGHT = 732
Global Const $DEFAULT_HEIGHT = 780
Global Const $DEFAULT_WIDTH = 860
Global Const $midOffsetY = Int(($DEFAULT_HEIGHT - 720) / 2)
Global Const $bottomOffsetY = $DEFAULT_HEIGHT - 720
Global $bMonitorHeight800orBelow = False
Global $ichkDisableSplash = 0 ; Splash screen disabled = 1

;debugging
Global $debugSearchArea = 0, $debugOcr = 0, $debugRedArea = 0, $debugSetlog = 0, $debugDeadBaseImage = 0, $debugImageSave = 0, $debugWalls = 0, $debugBuildingPos = 0, $debugVillageSearchImages = 0
Global $debugAttackCSV = 0, $makeIMGCSV = 0 ;attackcsv debug
Global $debugMultilanguage = 0
Global $debugsetlogTrain = 0
Global $debugGetLocation = 0 ;make a image of each structure detected with getlocation
Global $debugOCRdonate = 0 ; when 1 make OCR and simulate but do not donate
Global $debugAndroidEmbedded = 1
Global $debugWindowMessages = 0

Global Const $COLOR_ORANGE = 0xFF7700
Global Const $bCapturePixel = True, $bNoCapturePixel = False

Global $Compiled
If @Compiled Then
	$Compiled = @ScriptName & " Executable"
Else
	$Compiled = @ScriptName & " Script"
EndIf

Global $hBitmap ; Image for pixel functions
Global $hHBitmap ; Handle Image for pixel functions
;Global $hBitmap2  ; Handle to bitmap object with image captured by _captureregion2()  Bitmap object not used when use _captureregion2()
Global $hHBitmap2  ; handle to Device Context (DC) with graphics captured by _captureregion2()

;Global $sFile = @ScriptDir & "\Icons\logo.gif"

Global Const $64Bit = StringInStr(@OSArch, "64") > 0
Global Const $HKLM = "HKLM" & ($64Bit ? "64" : "")
Global Const $Wow6432Node = ($64Bit ? "\Wow6432Node" : "")

Global $AndroidGamePackage = "com.supercell.clashofclans"
Global $AndroidGameClass = ".GameApp"
Global $AndroidEmbedEnabled = True
Global $AndroidEmbedded = False
Global $AndroidEmbeddedCtrlTarget[9]
Global $AndroidEmbeddedRedraw = False
Global $AndroidShieldEnabled = True
Global $AndroidShieldPreWin8 = StringRegExp(@OSVersion, "WIN_VISTA|WIN_7|WIN_2008") = 1 ; Layered Child Window only support for WIN_8 and later
Global $AndroidShieldStatus[3] = [Default, 0, 0] ; Current Android Shield status (0: True = Shield Up, False = Shield Down, Default only for init; 1: Color; 2: Transparency = 0-255)
Global $AndroidShieldDelay[4] = [0, 0, Default, Default] ; Delay shield call: 0=TimerInit Handle, 1=Delay in ms., 2=AndroidShield action: True, False, Default
Global $AndroidShieldForceDown = False ; Have shield down in Default mode even if it should be on e.g. in run state
Global $AndroidShieldColor = $COLOR_WHITE
Global $AndroidShieldTransparency = 48
Global $AndroidActiveColor = $COLOR_BLACK
Global $AndroidActiveTransparency = 1
Global $AndroidInactiveColor = $COLOR_WHITE
Global $AndroidInactiveTransparency = 24
Global $AndroidBackgroundLaunchEnabled = False ; Headless mode not finished yet (2016-07-13, cosote)
Global $AndroidCheckTimeLagEnabled = True ; Checks every 60 Seconds or later in main loops (Bot Run, Idle and SearchVillage) is Android needs reboot due to time lag (see $AndroidTimeLagThreshold)
Global $AndroidAdbAutoTerminate = 0 ; Steady ADB shell instance is automatically closed after this number of executed commands, 0 = disabled (test for BS to fix frozen screen situation!)
Global $AndroidAdbScreencapEnabled = True ; Use Android ADB to capture screenshots in RGBA raw format
Global $AndroidAdbScreencapPngEnabled = False ; Use Android ADB to capture screenshots in PNG format, significantly slower than raw format (not final, captured screenshot resize too slow...)
Global $AndroidAdbZoomoutEnabled = True ; Use Android ADB zoom-out script
Global $AndroidAdbClickDragEnabled = True ; Use Android ADB click drag script
Global $AndroidAdbInputEnabled = True ; Enable Android ADB send text (CC requests), swipe not used as click drag anymore
Global $AndroidAdbInputWordsCharLimit = 0 ; Android ADB send text words (split by space) with this limit of specified characters per command (0 = disabled and entire text is sent at once)
Global $AndroidAdbClickEnabled = False ; Enable Android ADB mouse click
Global $AndroidAdbClicksEnabled = False ; (Experimental & Dangerous!) Enable Android KeepClicks() and ReleaseClicks() to fire collected clicks all at once, only available when also $AndroidAdbClick = True
Global $AndroidAdbClicksTroopDeploySize = 0 ; (Experimental & Dangerous!) Deploy more troops at once, 0 = deploy group, only available when also $AndroidAdbClicksEnabled = True (currently only just in CSV Deploy)
Global $AndroidAdbInstanceEnabled = True ; Enable Android steady ADB shell instance when available
Global $AndroidSuspendedEnabled = False ; Enable Android Suspend & Resume during Search and Attack
Global $NoFocusTampering = False ; If enabled, no ControlFocus or WinActivate is called, except when really required (like Zoom-Out for Droid4X, might break restart stability when Android Window not responding)

; Android Configutions
Global $__MEmu_Idx = 0 ; MEmu 2.2.1, 2.3.0, 2.3.1, 2.5.0, 2.6.1, 2.6.2, 2.6.5, 2.6.6, default config with open Tool Bar at right and System Bar at bottom, adjusted in config
Global $__Droid4X_Idx = 1 ; Droid4X 0.8.6 Beta, 0.8.7 Beta, 0.9.0 Beta, 0.10.0 Beta, 0.11.1 Beta
Global $__Nox_Idx = 2 ; Nox 3.1.0.0, 3.3.0.0, 3.5.1.0
Global $__BS2_Idx = 3 ; BlueStacks 2.x
Global $__BS_Idx = 4 ; BlueStacks 0.9.x, 0.10.x, 0.11.x
; "BlueStacks2" $AndroidAppConfig is also updated based on Registry settings in Func InitBlueStacks2() with these special variables
Global $__BlueStacks_SystemBar = 48
; "MEmu" $AndroidAppConfig is also updated based on runtime config in Func UpdateMEmuWindowState() with these special variables
Global $__MEmu_Adjust_Width = 6
Global $__MEmu_ToolBar_Width = 45
Global $__MEmu_SystemBar = 36
Global $__MEmu_PhoneLayout = "0"
Global $__MEmu_Window[3][4] = _ ; Alternative window sizes (array must be ordered by version descending!)
[ _; Version|$AndroidWindowWidth|$AndroidWindowHeight|$__MEmu_ToolBar_Width
    ["2.6.2",$DEFAULT_WIDTH + 48,$DEFAULT_HEIGHT + 26,40], _
    ["2.5.0",$DEFAULT_WIDTH + 51,$DEFAULT_HEIGHT + 24,40], _
    ["2.2.1",$DEFAULT_WIDTH + 51,$DEFAULT_HEIGHT + 24,45] _
]
Global $__Droid4X_Window[3][3] = _ ; Alternative window sizes (array must be ordered by version descending!)
[ _; Version|$AndroidWindowWidth|$AndroidWindowHeight
    ["0.10.0",$DEFAULT_WIDTH +  6,$DEFAULT_HEIGHT + 53], _
    ["0.8.6" ,$DEFAULT_WIDTH + 10,$DEFAULT_HEIGHT + 50] _
]
;   0            |1               |2                       |3                                 |4            |5                  |6                   |7                  |8                   |9             |10               |11                    |12                 |13
;   $Android     |$AndroidInstance|$Title                  |$AppClassInstance                 |$AppPaneName |$AndroidClientWidth|$AndroidClientHeight|$AndroidWindowWidth|$AndroidWindowHeight|$ClientOffsetY|$AndroidAdbDevice|$AndroidSupportFeature|$AndroidShellPrompt|$AndroidMouseDevice
;                |                |                        |                                  |             |                   |                    |                   |                    |              |                 |1 = Normal background mode                |
;                |                |                        |                                  |             |                   |                    |                   |                    |              |                 |2 = ADB screencap mode|                   |
;                |                |                        |                                  |             |                   |                    |                   |                    |              |                 |4 = ADB mouse click   |                   |
;                |                |                        |                                  |             |                   |                    |                   |                    |              |                 |8 = ADB input text    |                   |
;                |                |                        |                                  |             |                   |                    |                   |                    |              |                 |16 = ADB shell is steady                  |
;                |                |                        |                                  |             |                   |                    |                   |                    |              |                 |32 = ADB click drag   |                   |
Global $AndroidAppConfig[5][14] = [ _ ;                    |                                  |             |                   |                    |                   |                    |              |                 |64 = Dock mode support|                   |
   ["MEmu",       "MEmu",          "MEmu 2.",              "[CLASS:subWin; INSTANCE:1]",       "",           $DEFAULT_WIDTH,     $DEFAULT_HEIGHT - 12,$DEFAULT_WIDTH + 51,$DEFAULT_HEIGHT + 24,0,             "127.0.0.1:21503",0+2+4+8+16+32+64      ,'# ',               'Microvirt Virtual Input'], _
   ["Droid4X",    "droid4x",       "Droid4X 0.",           "[CLASS:subWin; INSTANCE:1]",       "",           $DEFAULT_WIDTH,     $DEFAULT_HEIGHT - 48,$DEFAULT_WIDTH + 10,$DEFAULT_HEIGHT + 50,0,             "127.0.0.1:26944",0+2+4+8+16+32+64      ,'# ',               'droid4x Virtual Input'], _
   ["Nox",        "nox",           "No",                   "[CLASS:Qt5QWindowIcon;INSTANCE:4]","",           $DEFAULT_WIDTH,     $DEFAULT_HEIGHT - 48,$DEFAULT_WIDTH +  4,$DEFAULT_HEIGHT - 10,0,             "127.0.0.1:62001",0+2+4+8+16+32         ,'# ',               'nox Virtual Input'], _
   ["BlueStacks2","",              "BlueStacks ",          "[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window",$DEFAULT_WIDTH,     $DEFAULT_HEIGHT - 48,$DEFAULT_WIDTH,     $DEFAULT_HEIGHT - 48,0,             "emulator-5554",  1    +8+16   +64      ,'$ ',               'BlueStacks Virtual Touch'], _
   ["BlueStacks", "",              "BlueStacks App Player","[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window",$DEFAULT_WIDTH,     $DEFAULT_HEIGHT - 48,$DEFAULT_WIDTH,     $DEFAULT_HEIGHT - 48,0,             "emulator-5554",  1    +8+16   +64      ,'$ ',               'BlueStacks Virtual Touch'] _
]
Global $OnlyInstance = True
Global $FoundRunningAndroid = False
Global $FoundInstalledAndroid = False
Global $OpenAndroidActive = 0 ; Recursive count of OpenAndroid() call to launch Android
Global $OpenAndroidActiveMaxTry = 3 ; Try recursively 3 times to open Android

Global $AndroidConfig = 0 ; Default selected Android Config of $AndroidAppConfig array
Global $AndroidVersion ; Identified version of Android Emulator

Global $Android ; Emulator used (BS, BS2, Droid4X, MEmu or Nox)
Global $AndroidInstance ; Clone or instance of emulator or "" if not supported
Global $Title ; Emulator Window Title
Global $AppClassInstance ; Control Class and instance of android rendering
Global $AppPaneName ; Control name of android rendering TODO check is still required
Global $AndroidClientWidth ; Expected width of android rendering control
Global $AndroidClientHeight ; Expected height of android rendering control
Global $AndroidWindowWidth ; Expected Width of android window
Global $AndroidWindowHeight ; Expected height of android window
Global $ClientOffsetY ; not used/required anymore
Global $AndroidAdbPath ; Path to executable HD-Adb.exe or adb.exe
Global $AndroidAdbDevice ; full device name ADB connects to
Global $AndroidSupportFeature ; 0 = Not available, 1 = Available, 2 = Available using ADB (experimental!)
Global $AndroidShellPrompt ; empty string not available, '# ' for rooted and '$ ' for not rooted android
Global $AndroidMouseDevice ; empty string not available, can be direct device '/dev/input/event2' or name by getevent -p
Global $AndroidAdbScreencap ; Use Android ADB to capture screenshots in RGBA raw format
Global $AndroidAdbClick ; Enable Android ADB mouse click
Global $AndroidAdbInput ; Enable Android ADB send text (CC requests)
Global $AndroidAdbInstance ; Enable Android steady ADB shell instance when available
Global $AndroidAdbClickDrag ; Enable Android ADB Click Drag script
Global $AndroidEmbed ; Enable Android Dock Mode
Global $AndroidBackgroundLaunch ; Enabled Android Background launch using Windows Scheduled Task
Global $AndroidBackgroundLaunched ; True when Android was launched in headless mode without a window

Func AndroidAdbClickSupported()
	Return BitAND($AndroidSupportFeature, 4) = 4
EndFunc
; Updated in UpdateAndroidConfig() and $Android&Init() as well
Global $InitAndroidActive = False
Func InitAndroidConfig($bRestart = False)
	If $bRestart = False Then
	   $Android = $AndroidAppConfig[$AndroidConfig][0]
	   $AndroidInstance = $AndroidAppConfig[$AndroidConfig][1]
	   $Title = $AndroidAppConfig[$AndroidConfig][2]
	EndIf
	$AppClassInstance = $AndroidAppConfig[$AndroidConfig][3] ; Control Class and instance of android rendering
	$AppPaneName = $AndroidAppConfig[$AndroidConfig][4] ; Control name of android rendering TODO check is still required
	$AndroidClientWidth = $AndroidAppConfig[$AndroidConfig][5] ; Expected width of android rendering control
	$AndroidClientHeight = $AndroidAppConfig[$AndroidConfig][6] ; Expected height of android rendering control
	$AndroidWindowWidth = $AndroidAppConfig[$AndroidConfig][7] ; Expected Width of android window
	$AndroidWindowHeight = $AndroidAppConfig[$AndroidConfig][8] ; Expected height of android window
	$ClientOffsetY = $AndroidAppConfig[$AndroidConfig][9] ; not used/required anymore
	$AndroidAdbPath = "" ; Path to executable HD-Adb.exe or adb.exe
	$AndroidAdbDevice = $AndroidAppConfig[$AndroidConfig][10] ; full device name ADB connects to
	$AndroidSupportFeature = $AndroidAppConfig[$AndroidConfig][11] ; 0 = Not available, 1 = Available, 2 = Available using ADB (experimental!)
	$AndroidShellPrompt = $AndroidAppConfig[$AndroidConfig][12] ; empty string not available, '# ' for rooted and '$ ' for not rooted android
	$AndroidMouseDevice = $AndroidAppConfig[$AndroidConfig][13] ; empty string not available, can be direct device '/dev/input/event2' or name by getevent -p
	$AndroidAdbScreencap = $AndroidAdbScreencapEnabled = True And BitAND($AndroidSupportFeature, 2) = 2 ; Use Android ADB to capture screenshots in RGBA raw format
	$AndroidAdbClick = $AndroidAdbClickEnabled = True And AndroidAdbClickSupported() ; Enable Android ADB mouse click
	$AndroidAdbInput = $AndroidAdbInputEnabled = True And BitAND($AndroidSupportFeature, 8) = 8 ; Enable Android ADB send text (CC requests)
	$AndroidAdbInstance = $AndroidAdbInstanceEnabled = True And BitAND($AndroidSupportFeature, 16) = 16 ; Enable Android steady ADB shell instance when available
	$AndroidAdbClickDrag = $AndroidAdbClickDragEnabled = True And BitAND($AndroidSupportFeature, 32) = 32 ; Enable Android ADB Click Drag script
	$AndroidEmbed = $AndroidEmbedEnabled = True And BitAND($AndroidSupportFeature, 64) = 64 ; Enable Android Dock Mode
	$AndroidBackgroundLaunch = $AndroidBackgroundLaunchEnabled = True And True ; Enabled Android Background launch using Windows Scheduled Task
	$AndroidBackgroundLaunched = False ; True when Android was launched in headless mode without a window
	; screencap might have disabled backgroundmode
	If $AndroidAdbScreencap And IsDeclared("chkBackground") Then
		chkBackground()
	EndIf
EndFunc
InitAndroidConfig() ; also called at end of file for supporting loaded config.ini

Global $AndroidProgramPath = "" ; Program path and executable to launch android emulator
Global $AndroidHasSystemBar = False ; BS2 System Bar can be entirely disabled in Windows Registry
Global $AndroidClientWidth_Configured = 0 ; Android configured Screen Width
Global $AndroidClientHeight_Configured = 0 ; Android configured Screen Height
Global $AndroidLaunchWaitSec = 240 ; Seconds to wait for launching Android Simulator

Global $AndroidAdbPid = 0 ; Single instance of ADB used for screencap (and sendevent in future)
Global $AndroidAdbPrompt = "mybot.run:" ; Single instance of ADB PS1 prompt
Global $AndroidPicturesPath = ""; Android mounted path to pictures on host
Global $AndroidPicturesHostPath = ""; Windows host path to mounted pictures in android
Global $AndroidPicturesHostFolder = "mybot.run\" ; Subfolder for host and android, can be "", must end with "\" when used
Global $AndroidPicturesPathAutoConfig = True ; Try to configure missing shared folder if missing
; Special ADB modes for screencap, mouse clicks and input text
Global $AndroidAdbAutoTerminateCount = 0 ; Counter for $AndroidAdbAutoTerminate to terminate ADB shell automatically after x executed commands
Global $AndroidAdbScreencapBuffer = DllStructCreate("byte[" & ($DEFAULT_WIDTH * $DEFAULT_HEIGHT * 4) & "]") ; Holds the android screencap BGRA buffer for caching
Global $AndroidAdbScreencapBufferPngHandle = 0 ; Holds the android screencap PNG buffer for caching (handle to GDIPlus Bitmap/Image Object)
Global $AndroidAdbScreencapWaitAdbTimeout = 10000 ; Timeout to wait for Adb screencap command
Global $AndroidAdbScreencapWaitFileTimeout = 10000 ; Timeout to wait for file to be accessible for bot
Global $AndroidAdbScreencapTimer = 0 ; Timer handle to use last captured screenshot to improve performance
Global $AndroidAdbScreencapTimeoutMin = 200 ; Minimum Milliseconds the last screenshot is used
Global $AndroidAdbScreencapTimeoutMax = 1000 ; Maximum Milliseconds the last screenshot is used
Global $AndroidAdbScreencapTimeout = $AndroidAdbScreencapTimeoutMax ; Milliseconds the last screenshot is used, dynamically calculated: $AndroidAdbScreencapTimeoutMin < 3 x last capture duration < $AndroidAdbScreencapTimeoutMax
Global $AndroidAdbScreencapTimeoutDynamic = 3 ; Calculate dynamic timeout multiply of last duration; if 0 $AndroidAdbScreencapTimeoutMax is used as fix timeout
Global $AndroidAdbScreencapWidth = 0 ; Width of last captured screenshot (always full size)
Global $AndroidAdbScreencapHeight = 0 ; Height of last captured screenshot (always full size)
Global $AndroidAdbClickGroup = 10 ; 1 Disables grouping clicks; > 1 number of clicks fired at once (e.g. when Click with $times > 1 used) (Experimental as some clicks might get lost!)
Global $AndroidAdbClickGroupDelay = 50 ; Additional delay in Milliseconds after group of ADB clicks sent (sleep in Android is executed!)
Global $AndroidAdbKeepClicksActive = False ; Track KeepClicks mode regardless of enabled or not (poor mans deploy troops detection)
Global $AndroidAdbClicks[1] = [-1] ; Stores clicks after KeepClicks() called, fired and emptied with ReleaseClicks()
Global $AndroidAdbStatsTotal[2][2] = [ _
   [0,0], _ ; Total of screencap duration, 0 is count, 1 is sum of durations
   [0,0] _  ; Total of click duration, 0 is count, 1 is sum of durations
]
Global $AndroidAdbStatsLast[2][12] ; Last 10 durations, 0 is sum of durations, 1 is index to oldest, 2-11 last 10 durations
       $AndroidAdbStatsLast[0][0] = 0 ; screencap sum of durations
	   $AndroidAdbStatsLast[0][1] = -1 ; screencap index to oldest
       $AndroidAdbStatsLast[1][0] = 0 ; click sum of durations
	   $AndroidAdbStatsLast[1][1] = -1 ; click index to oldest
Global $AndroidTimeLag[4] ; Timer varibales for time lag calculation
Func InitAndroidTimeLag()
	   $AndroidTimeLag[0] = 0 ; Time lag in Secodns determined
	   $AndroidTimeLag[1] = 0 ; UTC time of Android in Seconds
	   $AndroidTimeLag[2] = 0 ; AutoIt TimerHandle
	   $AndroidTimeLag[3] = 0 ; Suspended time of Android in Milliseconds
EndFunc
InitAndroidTimeLag()
Global $AndroidTimeLagThreshold = 5 ; Time lag Seconds per Minute when CoC gets restarted
Global $ForceCapture = False ; Force android ADB screencap to run and not provide last screenshot if available
Global $ScreenshotTime = 0; Last duration in Milliseconds it took to get screenshot

Global $WinGetAndroidHandleActive = False ; Prevent recursion in WinGetAndroidHandle()
Global $HWnD = 0 ; Handle for Android window
Global $AndroidSvcPid = 0 ; Android Backend Process
Global $AndroidSuspended = False ; Android window is suspended flag
Global $AndroidQueueReboot = False ; Reboot Android as soon as possible
Global $AndroidSuspendedTimer = 0; Android Suspended Timer
Global $InitAndroid = True ; Used to cache android config, is set to False once initialized, new emulator window handle resets it to True
Global $FrmBotMinimized = False ; prevents bot flickering

Global $iVillageName
Global $sProfilePath = @ScriptDir & "\Profiles"
;Global $sTemplates = @ScriptDir & "\Templates"
Global $sPreset = @ScriptDir & "\Strategies"
Global $aTxtLogInitText[0][6] = [[]]

Global $iMoveMouseOutBS = 0 ; If enabled moves mouse out of Android window when bot is running
Global $SilentSetLog = False ; No logs to Log Control when enabled
Global $DevMode = 0
If FileExists(@ScriptDir & "\EnableMBRDebug.txt") Then $DevMode = 1

; Special Android Emulator variables
Global $__BlueStacks_Version
Global $__BlueStacks_Path
Global $__Droid4X_Version
Global $__Droid4X_Path
Global $__MEmu_Path
Global $__Nox_Path

Global $__VBoxManage_Path ; Full path to executable VBoxManage.exe
Global $__VBoxVMinfo ; Virtualbox vminfo config details of android instance
Global $__VBoxGuestProperties ; Virtualbox guestproperties config details of android instance

Global $bBotLaunchOption_Restart = False ; If true previous instance is closed when found by window title, see bot launch options below
Global $aCmdLine[1] = [0] ; Clone of $CmdLine without options, please use instead of $CmdLine
Global $WorkingDir = @WorkingDir ; Working Directory at bot launch

; Mutex Handles
Global $hMutex_BotTitle = 0
Global $hMutex_Profile = 0
Global $hMutex_MyBot = 0

; Handle Command Line Launch Options and fill $aCmdLine
If $CmdLine[0] > 0 Then
	Local $i
	For $i = 1 To $CmdLine[0]
		Switch $CmdLine[$i]
			; terminate bot if it exists (by window title!)
			Case "/restart", "/r", "-restart", "-r"
				$bBotLaunchOption_Restart = True
			Case Else
				$aCmdLine[0] += 1
				ReDim $aCmdLine[$aCmdLine[0] + 1]
				$aCmdLine[$aCmdLine[0]] = $CmdLine[$i]
		EndSwitch
	Next
EndIf

Global $sCurrProfile

; Handle Command Line Parameters
If $aCmdLine[0] > 0 Then
	$sCurrProfile = StringRegExpReplace($aCmdLine[1], '[/:*?"<>|]', '_')
ElseIf FileExists($sProfilePath & "\profile.ini") Then
	$sCurrProfile = StringRegExpReplace(IniRead($sProfilePath & "\profile.ini", "general", "defaultprofile", ""), '[/:*?"<>|]', '_')
	If $sCurrProfile = "" Or Not FileExists($sProfilePath & "\" & $sCurrProfile) Then $sCurrProfile = "<No Profiles>"
Else
	$sCurrProfile = "<No Profiles>"
EndIf

; Arrays to hold stat information
Global $aWeakBaseStats

Func SetupProfileFolder()
	Global $config = $sProfilePath & "\" & $sCurrProfile & "\config.ini"
	Global $InputConfigFile = $sProfilePath & "\" & $sCurrProfile & "\InputConfig.ini"
	Global $statChkWeakBase = $sProfilePath & "\" & $sCurrProfile & "\stats_chkweakbase.INI"
	Global $statChkTownHall = $sProfilePath & "\" & $sCurrProfile & "\stats_chktownhall.INI"
	Global $statChkDeadBase = $sProfilePath & "\" & $sCurrProfile & "\stats_chkelixir.INI"
	Global $statChkDeadBase75percent = $sProfilePath & "\" & $sCurrProfile & "\stats_chkelixir75percent.INI"
	Global $statChkDeadBase50percent = $sProfilePath & "\" & $sCurrProfile & "\stats_chkelixir50percent.INI"
	Global $building = $sProfilePath & "\" & $sCurrProfile & "\building.ini"
	Global $dirLogs = $sProfilePath & "\" & $sCurrProfile & "\Logs\"
	Global $dirLoots = $sProfilePath & "\" & $sCurrProfile & "\Loots\"
	Global $dirTemp = $sProfilePath & "\" & $sCurrProfile & "\Temp\"
	Global $dirTempDebug = $sProfilePath & "\" & $sCurrProfile & "\Temp\Debug\"
EndFunc   ;==>SetupProfileFolder
SetupProfileFolder()

Global $LibDir = @ScriptDir & "\lib" ;lib directory contains dll's
Global $pCurl = $LibDir & "\curl\curl.exe" ; Curl used on PushBullet
Global $AdbScriptsDir = $LibDir & "\adb.scripts" ; ADD script and event files folder
Global $pImageLib = $LibDir & "\ImageSearchDLL.dll" ; ImageSearch library
Global $pImgLib = $LibDir & "\ImgLoc.dll" ; Last Image Library from @trlopes with all Legal Information need on LGPL
Global $pFuncLib = $LibDir & "\MBRFunctions.dll" ; functions library
Global $hFuncLib ; handle to functions library
Global $hImgLib ; handle to imgloc library
Global $pIconLib = $LibDir & "\MBRBOT.dll" ; icon library
Global Const $dirTHSnipesAttacks = @ScriptDir & "\CSV\THSnipe"
Global Const $dirAttacksCSV = @ScriptDir & "\CSV\Attack"

; Improve GUI interations by disabling bot window redraw
Global $RedrawBotWindowMode = 2 ; 0 = disabled, 1 = Redraw always entire bot window, 2 = Redraw only required bot window area (or entire bot if control not specified)
Global $bRedrawBotWindow[3] = [True, False, False] ; [0] = window redraw enabled, [1] = window redraw required, [2] = window redraw requird by some controls, see CheckRedrawControls()

; enumerated Icons 1-based index to IconLib
Global Enum $eIcnArcher = 1, $eIcnDonArcher, $eIcnBalloon, $eIcnDonBalloon, $eIcnBarbarian, $eIcnDonBarbarian, $eIcnKingAbility, $eIcnBuilder, $eIcnCC, $eIcnGUI, $eIcnDark, $eIcnDragon, $eIcnDonDragon, $eIcnDrill, $eIcnElixir, $eIcnCollector, $eIcnFreezeSpell, $eIcnGem, $eIcnGiant, $eIcnDonGiant, _
		$eIcnTrap, $eIcnGoblin, $eIcnDonGoblin, $eIcnGold, $eIcnGolem, $eIcnDonGolem, $eIcnHealer, $eIcnDonHealer, $eIcnHogRider, $eIcnDonHogRider, $eIcnHealSpell, $eIcnInferno, $eIcnJumpSpell, $eIcnLavaHound, $eIcnDonLavaHound, $eIcnLightSpell, $eIcnMinion, $eIcnDonMinion, $eIcnPekka, $eIcnDonPekka, _
		$eIcnQueenAbility, $eIcnRageSpell, $eIcnTroops, $eIcnHourGlass, $eIcnTH1, $eIcnTH10, $eIcnTrophy, $eIcnValkyrie, $eIcnDonValkyrie, $eIcnWall, $eIcnWallBreaker, $eIcnDonWallBreaker, $eIcnWitch, $eIcnDonWitch, $eIcnWizard, $eIcnDonWizard, $eIcnXbow, $eIcnBarrackBoost, $eIcnMine, $eIcnCamp, _
		$eIcnBarrack, $eIcnSpellFactory, $eIcnDonBlacklist, $eIcnSpellFactoryBoost, $eIcnMortar, $eIcnWizTower, $eIcnPayPal, $eIcnPushBullet, $eIcnGreenLight, $eIcnLaboratory, $eIcnRedLight, $eIcnBlank, $eIcnYellowLight, $eIcnDonCustom, $eIcnTombstone, $eIcnSilverStar, $eIcnGoldStar, $eIcnDarkBarrack, _
		$eIcnCollectorLocate, $eIcnDrillLocate, $eIcnMineLocate, $eIcnBarrackLocate, $eIcnDarkBarrackLocate, $eIcnDarkSpellFactoryLocate, $eIcnDarkSpellFactory, $eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnPoisonSpell, $eIcnBldgTarget, $eIcnBldgX, $eIcnRecycle, $eIcnHeroes, _
		$eIcnBldgElixir, $eIcnBldgGold, $eIcnMagnifier, $eIcnWallElixir, $eIcnWallGold, $eIcnQueen, $eIcnKing, $eIcnDarkSpellBoost, $eIcnQueenBoostLocate, $eIcnKingBoostLocate, $eIcnKingUpgr, $eIcnQueenUpgr, $eIcnWardenAbility, $eIcnWarden, $eIcnWardenBoostLocate, $eIcnKingBoost, _
		$eIcnQueenBoost, $eIcnWardenBoost, $eIcnWardenUpgr, $eIcnReload, $eIcnCopy, $eIcnAddcvs, $eIcnEdit, $eIcnTreeSnow, $eIcnSleepingQueen, $eIcnSleepingKing, $eIcnGoldElixir, $eIcnBowler, $eIcnDonBowler, $eIcnCCDonate, $eIcnEagleArt, $eIcnGembox, $eIcnInferno4, $eIcnInfo, $eIcnMain, _
		$eIcnTree, $eIcnProfile, $eIcnCCRequest, $eIcnTelegram, $eIcnTiles, $eIcnXbow3, $eIcnBark, $eIcnDailyProgram, $eIcnLootCart, $eIcnSleepMode, $eIcnTH11, $eIcnTrainMode, $eIcnSleepingWarden, $eIcnCloneSpell, $eIcnSkeletonSpell, $eIcnBabyDragon, $eIcnDonBabyDragon, $eIcnMiner, $eIcnDonMiner, _
		$eIcnNoShield, $eIcnDonCustomB

Global $eIcnDonBlank = $eIcnDonBlacklist
Global $eIcnOptions = $eIcnDonBlacklist
Global $eIcnAchievements = $eIcnMain
Global $eIcnStrategies = $eIcnBlank

Global $sLogPath ; `Will create a new log file every time the start button is pressed
Global $sAttackLogPath ; `Will create a new log file every time the start button is pressed
Global $hLogFileHandle
Global $hAttackLogFileHandle
Global $iCmbLog = 0
Global $Restart = False
Global $RunState = False
Global $TakeLootSnapShot = True
Global $ScreenshotLootInfo = False
Global $AlertSearch = True
Global $iChkAttackNow, $iAttackNowDelay, $bBtnAttackNowPressed = False
Global $PushBulletToken = ""
Global $TelegramToken = ""

Global $iGUIMasterWidth = 470
Global $iGUIMasterHeight = 650
Global $iGUIChildTop = 65

Global $hAttackCountDown = 0 ; Timer Handle for 30 Seconds Attack countdown

Global Enum $DB, $LB, $TS, $MA, $TB, $DT ; DeadBase, LiveBase, TownhallSnipe, Milking Attack, TownhallBully, DropTrophy
Global $iModeCount = 3
Global $iMatchMode ; 0 Dead / 1 Live / 2 TH Snipe / 3 Milking Attack / 4 TH Bully / 5 Drop Trophy
Global $sModeText[6]
$sModeText[$DB] = "Dead Base"
$sModeText[$LB] = "Live Base"
$sModeText[$TS] = "TH Snipe"
$sModeText[$TB] = "TH Bully"
$sModeText[$DT] = "Drop Trophy"
$sModeText[$MA] = "Milking Attack"


Global $iAtkAlgorithm[$iModeCount]

;PushBullet---------------------------------------------------------------
Global $PBRemoteControlInterval = 60000 ; 60 secs
Global $PBDeleteOldPushesInterval = 1800000 ; 30 mins
Global $iOrigPushBullet
Global $iLastAttackPB
Global $iAlertPBVillage
Global $PushBulletEnabled
Global $pRemote
Global $pMatchFound
Global $pLastRaidImg
Global $iAlertPBLastRaidTxt
Global $pWallUpgrade
Global $pOOS
Global $pTakeAbreak
Global $pAnotherDevice
Global $iDeleteAllPBPushes = 0
Global $iDeleteAllPBPushesNow = False
Global $ichkDeleteOldPBPushes
Global $icmbHoursPushBullet
Global $chkDeleteAllPBPushes
Global $ichkAlertPBCampFull
Global $ichkAlertPBCampFullTest = 0

Global $sLogFName
Global $sAttackLogFName
Global $AttackFile
Global $RequestScreenshot = 0

Global $Result
Global $MessageId
Global $MessageId2
Global $lastuid
Global $Result2
Global $lastremote = 0

Global $tPush
Global $tPush2


Global $cmbTroopComp ;For Event change on ComboBox Troop Compositions
Global $iCollectCounter = 0 ; Collect counter, when reaches $COLLECTATCOUNT, it will collect
Global $COLLECTATCOUNT = 10 ; Run Collect() after this amount of times before actually collect

;---------------------------------------------------------------------------------------------------
Global $BSpos[2] ; Inside Android window positions relative to the screen, [x,y]
Global $BSrpos[2] ; Inside Android window positions relative to the window, [x,y]
;---------------------------------------------------------------------------------------------------
;Stats
Global $iFreeBuilderCount, $iTotalBuilderCount, $iGemAmount ; builder and gem amounts
Global $iGoldStart, $iElixirStart, $iDarkStart, $iTrophyStart ; stats at the start
Global $iGoldTotal, $iElixirTotal, $iDarkTotal, $iTrophyTotal ; total stats
Global $iGoldCurrent, $iElixirCurrent, $iDarkCurrent, $iTrophyCurrent ; current stats
Global $iGoldLast, $iElixirLast, $iDarkLast, $iTrophyLast ; loot and trophy gain from last raid
Global $iGoldLastBonus, $iElixirLastBonus, $iDarkLastBonus ; bonus loot from last raid
Global $iBonusLast = 0 ; last attack Bonus percentage
Global $iskipped
Global $iSkippedVillageCount, $iDroppedTrophyCount ; skipped village and dropped trophy counts
Global $iCostGoldWall, $iCostElixirWall, $iCostGoldBuilding, $iCostElixirBuilding, $iCostDElixirHero ; wall, building and hero upgrade costs
Global $iNbrOfWallsUppedGold, $iNbrOfWallsUppedElixir, $iNbrOfBuildingsUppedGold, $iNbrOfBuildingsUppedElixir, $iNbrOfHeroesUpped ; number of wall, building, hero upgrades with gold, elixir, delixir
Global $iSearchCost, $iTrainCostElixir, $iTrainCostDElixir ; search and train troops cost
Global $iNbrOfOoS ; number of Out of Sync occurred
Global $iNbrOfTHSnipeFails, $iNbrOfTHSnipeSuccess ; number of fails and success while TH Sniping
Global $iGoldFromMines, $iElixirFromCollectors, $iDElixirFromDrills ; number of resources gain by collecting mines, collectors, drills
Global $iAttackedVillageCount[$iModeCount + 3] ; number of attack villages for DB, LB, TB, TS
Global $iTotalGoldGain[$iModeCount + 3], $iTotalElixirGain[$iModeCount + 3], $iTotalDarkGain[$iModeCount + 3], $iTotalTrophyGain[$iModeCount + 3] ; total resource gains for DB, LB, TB, TS
Global $iNbrOfDetectedMines[$iModeCount + 3], $iNbrOfDetectedCollectors[$iModeCount + 3], $iNbrOfDetectedDrills[$iModeCount + 3] ; number of mines, collectors, drills detected for DB, LB, TB
Global $lblAttacked[$iModeCount + 3], $lblTotalGoldGain[$iModeCount + 3], $lblTotalElixirGain[$iModeCount + 3], $lblTotalDElixirGain[$iModeCount + 3], $lblTotalTrophyGain[$iModeCount + 3]
Global $lblNbrOfDetectedMines[$iModeCount + 3], $lblNbrOfDetectedCollectors[$iModeCount + 3], $lblNbrOfDetectedDrills[$iModeCount + 3]
Global $ArmyCapacity = 0
Global $iLaboratoryElixirCost
Global $iAttackedCount = 0 ; convert to global from UpdateStats to enable daily attack limits
;Global $costspell

;Search Settings
Global $bSearchMode = False
Global $Is_ClientSyncError = False ;If true means while searching Client Out Of Sync error occurred.
Global $searchGold, $searchElixir, $searchDark, $searchTrophy, $searchTH ;Resources of bases when searching
Global $SearchGold2 = 0, $SearchElixir2 = 0, $iStuck = 0, $iNext = 0
Global $iMinGold[$iModeCount], $iMinElixir[$iModeCount], $iMinGoldPlusElixir[$iModeCount], $iMinDark[$iModeCount], $iMinTrophy[$iModeCount], $iMaxTH[$iModeCount], $iEnableAfterCount[$iModeCount], $iEnableBeforeCount[$iModeCount]
Global $ChkMaxMortar[$iModeCount], $ChkMaxWizTower[$iModeCount], $ChkMaxXBow[$iModeCount], $ChkMaxInferno[$iModeCount], $ChkMaxEagle[$iModeCount]
Global $iChkMaxMortar[$iModeCount], $iChkMaxWizTower[$iModeCount], $iChkMaxXBow[$iModeCount], $iChkMaxInferno[$iModeCount], $iChkMaxEagle[$iModeCount]
Global $CmbWeakMortar[$iModeCount], $CmbWeakWizTower[$iModeCount], $CmbWeakXBow[$iModeCount], $CmbWeakInferno[$iModeCount], $cmbWeakEagle[$iModeCount]
Global $iCmbWeakMortar[$iModeCount], $iCmbWeakWizTower[$iModeCount], $iCmbWeakXBow[$iModeCount], $iCmbWeakInferno[$iModeCount], $iCmbWeakEagle[$iModeCount]
Global $iEnableAfterTropies[$iModeCount], $iEnableBeforeTropies[$iModeCount], $iEnableAfterArmyCamps[$iModeCount] ; Search conditions
Global $iAimGold[$iModeCount], $iAimElixir[$iModeCount], $iAimGoldPlusElixir[$iModeCount], $iAimDark[$iModeCount], $iAimTrophy[$iModeCount], $iAimTHtext[$iModeCount] ; Aiming Resource values
Global $iEnableSearchSearches[$iModeCount], $iEnableSearchTropies[$iModeCount], $iEnableSearchCamps[$iModeCount]
Global $iDBcheck = 1
Global $iABcheck = 0
Global $iTScheck = 0
$iEnableSearchSearches[$DB] = 1
$iCmbWeakMortar[$DB] = 5
$iCmbWeakMortar[$LB] = 5
$iCmbWeakWizTower[$DB] = 4
$iCmbWeakWizTower[$LB] = 4
Global $iChkSearchReduction = 0
Global $ReduceCount = 20, $ReduceGold = 2000, $ReduceElixir = 2000, $ReduceGoldPlusElixir = 4000, $ReduceDark = 100, $ReduceTrophy = 2 ; Reducing values
;Global $chkConditions[7], $ichkMeetOne ;Conditions (meet gold...)
;Global $icmbTH
Global $iChkEnableAfter[$iModeCount], $iCmbMeetGE[$iModeCount], $iChkMeetDE[$iModeCount], $iChkMeetTrophy[$iModeCount], $iChkMeetTH[$iModeCount], $iChkMeetTHO[$iModeCount], $iChkMeetOne[$iModeCount], $iCmbTH[$iModeCount]
Global $chkDBMeetTHO, $chkABMeetTHO
Global $THLocation
Global $THx = 0, $THy = 0
Global $DESLoc
Global $DESLocx = 0
Global $DESLocy = 0
Global $THText[6] ; Text of each Townhall level
$THText[0] = "4-6"
$THText[1] = "7"
$THText[2] = "8"
$THText[3] = "9"
$THText[4] = "10"
$THText[5] = "11"

Global $THImages0, $THImages1, $THImages2, $THImages3, $THImages4, $THImages5
Global $THImagesStat0, $THImagesStat1, $THImagesStat2, $THImagesStat3, $THImagesStat4, $THImagesStat5

Global $maxElixirLevel = 6
Global $ElixirImages0, $ElixirImages1, $ElixirImages2, $ElixirImages3, $ElixirImages4, $ElixirImages5, $ElixirImages6
Global $ElixirImagesStat0, $ElixirImagesStat1, $ElixirImagesStat2, $ElixirImagesStat3, $ElixirImagesStat4, $ElixirImagesStat5, $ElixirImagesStat6
Global $ElixirImages0_75percent, $ElixirImages1_75percent, $ElixirImages2_75percent, $ElixirImages3_75percent, $ElixirImages4_75percent, $ElixirImages5_75percent, $ElixirImages6_75percent
Global $ElixirImagesStat0_75percent, $ElixirImagesStat1_75percent, $ElixirImagesStat2_75percent, $ElixirImagesStat3_75percent, $ElixirImagesStat4_75percent, $ElixirImagesStat5_75percent, $ElixirImagesStat6_75percent
Global $ElixirImages0_50percent, $ElixirImages1_50percent, $ElixirImages2_50percent, $ElixirImages3_50percent, $ElixirImages4_50percent, $ElixirImages5_50percent, $ElixirImages6_50percent
Global $ElixirImagesStat0_50percent, $ElixirImagesStat1_50percent, $ElixirImagesStat2_50percent, $ElixirImagesStat3_50percent, $ElixirImagesStat4_50percent, $ElixirImagesStat5_50percent, $ElixirImagesStat6_50percent

Global $SearchCount = 0 ;Number of searches

Global $THaddtiles, $THside, $THi
Global $SearchTHLResult = 0
Global $BullySearchCount = 0
Global $OptBullyMode = 0

Global $ATBullyMode = 150
Global $YourTH
Global $iTHBullyAttackMode
;~ Global $icmbAttackTHType
Global $scmbAttackTHType = "Bam"
Global $txtAttackTHType
Global $iNbOfSpots
Global $iAtEachSpot
Global $Sleep
Global $waveNb
Global $DelayInSec
Global $Log
Global $CheckHeroes
Global $KingSlotTH
Global $QueenSlotTH
; Attack TH snipe
Global $icmbDeployBtmTHType
Global $ichkUseKingTH = 0
Global $ichkUseQueenTH = 0
Global $ichkUseWardenTH = 0
Global $ichkUseClastleTH = 0
Global $ichkUseClastleTH = 0
Global $ichkUseLSpellsTH = 0
Global $ichkUseRSpellsTH = 0
Global $ichkUseHSpellsTH = 0
Global $THusedKing = 0
Global $THusedQueen = 0
Global $THusedWarden = 0


Global $TrainSpecial = 1 ;0=Only trains after atk. Setting is automatic
Global $cBarbarian = 0, $cArcher = 0, $cGoblin = 0, $cGiant = 0, $cWallbreaker = 0, $cWizard = 0, $cBalloon = 0, $cDragon = 0, $cPekka = 0, $cBabyDragon = 0, $cMiner = 0, $cMinion = 0, $cHogs = 0, $cValkyrie = 0, $cGolem = 0, $cWitch = 0, $cLavaHound = 0, $cBowl = 0
;Troop types
Global Enum $eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, _
	$eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eBowl, $eKing, $eQueen, $eWarden, $eCastle, _
	$eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell
;wall
Global $WallCost = 0
Global $WallCosts[7] = [30000, 75000, 200000, 500000, 1000000, 3000000, 4000000]
Global $WallX = 0, $WallY = 0
Global $Wall[8]
Global $iMaxNbWall = 4

;Attack Settings
; Old coordinates
#cs
	Global $TopLeft[5][2] = [[79, 281], [170, 205], [234, 162], [296, 115], [368, 66]]
	Global $TopRight[5][2] = [[480, 63], [540, 104], [589, 146], [655, 190], [779, 278]]
	Global $BottomLeft[5][2] = [[79, 342], [142, 389], [210, 446], [276, 492], [339, 539]]
	Global $BottomRight[5][2] = [[523, 537], [595, 484], [654, 440], [715, 393], [779, 344]]
#ce
; New coordinates by Cru34
Global $TopLeft[5][2] = [[83, 306], [174, 238], [240, 188], [303, 142], [390, 76]]
Global $TopRight[5][2] = [[466, 66], [556, 134], [622, 184], [684, 231], [775, 300]]
Global $BottomLeft[5][2] = [[81, 363], [174, 434], [235, 481], [299, 530], [390, 600]]
Global $BottomRight[5][2] = [[466, 590], [554, 523], [615, 477], [678, 430], [765, 364]]
Global $eThing[1] = [101]
Global $Edges[4] = [$BottomRight, $TopLeft, $BottomLeft, $TopRight]

Global $atkTroops[12][2] ;11 Slots of troops -  Name, Amount

Global $fullArmy ;Check for full army or not
Global $bFullSpell

Global $iChkDeploySettings[$iModeCount+1] ;Method of deploy found in attack settings
$iChkDeploySettings[$DB] = 3 ;4 sides
$iChkDeploySettings[$LB] = 3 ;4 sides
$iChkDeploySettings[$MA] = 1 ;1 sides
Global $iChkRedArea[$iModeCount+3], $iCmbSmartDeploy[$iModeCount+3], $iChkSmartAttack[$iModeCount+3][3], $iCmbSelectTroop[$iModeCount+3]
$iChkRedArea[$DB] = 1
$iChkRedArea[$LB] = 1
$iChkRedArea[$MA] = 1

Global $troopsToBeUsed[12]
Global $useAllTroops[33] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, $eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eBowl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useBarracks[26] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $useBarbs[15] = [$eBarb, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $useArchs[15] = [$eArch, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $useBarcher[16] = [$eBarb, $eArch, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $useBarbGob[16] = [$eBarb, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $useArchGob[16] = [$eArch, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $useBarcherGiant[17] = [$eBarb, $eArch, $eGiant, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $useBarcherGobGiant[18] = [$eBarb, $eArch, $eGiant, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $useBarcherHog[17] = [$eBarb, $eArch, $eHogs, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $useBarcherMinion[17] = [$eBarb, $eArch, $eMini, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global $usegoblin[1] = [$eGobl]
$troopsToBeUsed[0] = $useAllTroops
$troopsToBeUsed[1] = $useBarracks
$troopsToBeUsed[2] = $useBarbs
$troopsToBeUsed[3] = $useArchs
$troopsToBeUsed[4] = $useBarcher
$troopsToBeUsed[5] = $useBarbGob
$troopsToBeUsed[6] = $useArchGob
$troopsToBeUsed[7] = $useBarcherGiant
$troopsToBeUsed[8] = $useBarcherGobGiant
$troopsToBeUsed[9] = $useBarcherHog
$troopsToBeUsed[10] = $useBarcherMinion
Global $KingAttack[$iModeCount] ;King attack settings
Global $QueenAttack[$iModeCount] ;Queen attack settings
Global $WardenAttack[$iModeCount] ;Grand Garden attack settings

; Hero attack & wait
Global Const $HERO_NOHERO = 0x00
Global Const $HERO_KING = 0x01
Global Const $HERO_QUEEN = 0x02
Global Const $HERO_WARDEN = 0x04
Global $iHeroAttack[$iModeCount] ; Hero enabled for attack
Global $iHeroWait[$iModeCount] ; Heroes wait status for attack
Global $iHeroAvailable = $HERO_NOHERO ; Hero ready status
Global $bFullArmyHero = False ; = BitAnd($iHeroWait[$iMatchMode], $iHeroAvailable )

Global $KingAttackCSV[$iModeCount] ;King attack settings
Global $QueenAttackCSV[$iModeCount] ;Queen attack settings
Global $WardenAttackCSV[$iModeCount] ;Grand Garden attack settings

Global $ichkLightSpell[$iModeCount]
Global $ichkHealSpell[$iModeCount]
Global $ichkRageSpell[$iModeCount]
Global $ichkJumpSpell[$iModeCount]
Global $ichkFreezeSpell[$iModeCount]
Global $ichkPoisonSpell[$iModeCount]
Global $ichkEarthquakeSpell[$iModeCount]
Global $ichkHasteSpell[$iModeCount]


Global $A[4] = [112, 111, 116, 97]

Global $checkKPower = False ; Check for King activate power
Global $checkQPower = False ; Check for Queen activate power
Global $checkWPower = False ; Check for Warden activate power
Global $iActivateKQCondition
Global $iActivateWardenCondition
Global $delayActivateKQ ; = 9000 ;Delay before activating KQ
Global $delayActivateW ; Delay before activating Grand Warden Ability

Global $iActivateKQConditionCSV
Global $iActivateWardenConditionCSV
Global $delayActivateKQCSV ; = 9000 ;Delay before activating KQ


Global $iDropCC[$iModeCount] ; Use Clan Castle settings
Global $iChkUseCCBalanced ; Use Clan Castle Balanced settings
Global $iCmbCCDonated, $iCmbCCReceived ; Use Clan Castle Balanced ratio settings

Global $iDropCCCSV[$iModeCount] ; Use Clan Castle settings
Global $iChkUseCCBalancedCSV ; Use Clan Castle Balanced settings
Global $iCmbCCDonatedCSV, $iCmbCCReceivedCSV ; Use Clan Castle Balanced ratio settings

Global $THLoc

Global $King, $Queen, $CC, $Barb, $Arch, $LSpell, $LSpellQ, $Warden
Global $LeftTHx, $RightTHx, $BottomTHy, $TopTHy
Global $AtkTroopTH
Global $GetTHLoc
Global $iUnbreakableMode = 0
Global $iUnbreakableWait = 5
Global $iUnBrkMinGold = 50000
Global $iUnBrkMinElixir = 50000
Global $iUnBrkMaxGold = 600000
Global $iUnBrkMaxElixir = 600000
Global $iUnBrkMinDark = 5000
Global $iUnBrkMaxDark = 6000
Global $OutOfGold = 0 ; Flag for out of gold to search for attack
Global $OutOfElixir = 0 ; Flag for out of elixir to train troops

;Zoom/scroll variables for TH snipe, bottom corner
Global $zoomedin = False, $zCount = 0, $sCount = 0

;Boosts Settings
Global $remainingBoosts = 0 ;  remaining boost to active during session
Global $boostsEnabled = 1 ; is this function enabled
Global $icmbQuantBoostBarracks
Global $icmbBoostBarracks = 0
Global $icmbBoostSpellFactory = 0
Global $icmbBoostDarkSpellFactory = 0
Global $icmbBoostBarbarianKing = 0
Global $icmbBoostArcherQueen = 0
Global $icmbBoostWarden = 0

; TownHall Settings
Global $TownHallPos[2] = [-1, -1] ;Position of TownHall
Global $iTownHallLevel = 0 ; Level of user townhall
Global $Y[4] = [46, 116, 120, 116]

;Mics Setting
Global $SFPos[2] = [-1, -1] ;Position of Spell Factory
Global $DSFPos[2] = [-1, -1] ;Position of Dark Spell Factory
Global $KingAltarPos[2] = [-1, -1] ; position Kings Altar
Global $QueenAltarPos[2] = [-1, -1] ; position Queens Altar
Global $WardenAltarPos[2] = [-1, -1] ; position Grand Warden Altar

;Donate Settings
Global $aCCPos[2] = [-1, -1] ;Position of clan castle
Global $LastDonateBtn1 = -1, $LastDonateBtn2 = -1
Global $DonatePixel
Global $iClanLevel
Global $LastBarrackTrainDonatedTroop = 1
Global $LastDarkBarrackTrainDonatedTroop = 1

Global $sTxtRequest = ""
Global $ichkDonateAllBarbarians, $ichkDonateBarbarians, $sTxtDonateBarbarians, $sTxtBlacklistBarbarians, $aDonBarbarians, $aBlkBarbarians
Global $ichkDonateAllArchers, $ichkDonateArchers, $sTxtDonateArchers, $sTxtBlacklistArchers, $aDonArchers, $aBlkArchers
Global $ichkDonateAllGiants, $ichkDonateGiants, $sTxtDonateGiants, $sTxtBlacklistGiants, $aDonGiants, $aBlkGiants
Global $ichkDonateAllGoblins, $ichkDonateGoblins, $sTxtDonateGoblins, $sTxtBlacklistGoblins, $aDonGoblins, $aBlkGoblins
Global $ichkDonateAllWallBreakers, $ichkDonateWallBreakers, $sTxtDonateWallBreakers, $sTxtBlacklistWallBreakers, $aDonWallBreakers, $aBlkWallBreakers
Global $ichkDonateAllBalloons, $ichkDonateBalloons, $sTxtDonateBalloons, $sTxtBlacklistBalloons, $aDonBalloons, $aBlkBalloons
Global $ichkDonateAllWizards, $ichkDonateWizards, $sTxtDonateWizards, $sTxtBlacklistWizards, $aDonWizards, $aBlkWizards
Global $ichkDonateAllHealers, $ichkDonateHealers, $sTxtDonateHealers, $sTxtBlacklistHealers, $aDonHealers, $aBlkHealers
Global $ichkDonateAllDragons, $ichkDonateDragons, $sTxtDonateDragons, $sTxtBlacklistDragons, $aDonDragons, $aBlkDragons
Global $ichkDonateAllPekkas, $ichkDonatePekkas, $sTxtDonatePekkas, $sTxtBlacklistPekkas, $aDonPekkas, $aBlkPekkas
Global $ichkDonateAllBabyDragons, $ichkDonateBabyDragons, $sTxtDonateBabyDragons, $sTxtBlacklistBabyDragons, $aDonBabyDragons, $aBlkBabyDragons
Global $ichkDonateAllMiners, $ichkDonateMiners, $sTxtDonateMiners, $sTxtBlacklistMiners, $aDonMiners, $aBlkMiners
Global $ichkDonateAllMinions, $ichkDonateMinions, $sTxtDonateMinions, $sTxtBlacklistMinions, $aDonMinions, $aBlkMinions
Global $ichkDonateAllHogRiders, $ichkDonateHogRiders, $sTxtDonateHogRiders, $sTxtBlacklistHogRiders, $aDonHogRiders, $aBlkHogRiders
Global $ichkDonateAllValkyries, $ichkDonateValkyries, $sTxtDonateValkyries, $sTxtBlacklistValkyries, $aDonValkyries, $aBlkValkyries
Global $ichkDonateAllGolems, $ichkDonateGolems, $sTxtDonateGolems, $sTxtBlacklistGolems, $aDonGolems, $aBlkGolems
Global $ichkDonateAllWitches, $ichkDonateWitches, $sTxtDonateWitches, $sTxtBlacklistWitches, $aDonWitches, $aBlkWitches
Global $ichkDonateAllLavaHounds, $ichkDonateLavaHounds, $sTxtDonateLavaHounds, $sTxtBlacklistLavaHounds, $aDonLavaHounds, $aBlkLavaHounds
Global $ichkDonateAllBowlers, $ichkDonateBowlers, $sTxtDonateBowlers, $sTxtBlacklistBowlers, $aDonBowlers, $aBlkBowlers
Global $ichkDonateAllPoisonSpells, $ichkDonatePoisonSpells, $sTxtDonatePoisonSpells, $sTxtBlacklistPoisonSpells, $aDonPoisonSpells, $aBlkPoisonSpells
Global $ichkDonateAllEarthQuakeSpells, $ichkDonateEarthQuakeSpells, $sTxtDonateEarthQuakeSpells, $sTxtBlacklistEarthQuakeSpells, $aDonEarthQuakeSpells, $aBlkEarthQuakeSpells
Global $ichkDonateAllHasteSpells, $ichkDonateHasteSpells, $sTxtDonateHasteSpells, $sTxtBlacklistHasteSpells, $aDonHasteSpells, $aBlkHasteSpells
Global $ichkDonateAllSkeletonSpells, $ichkDonateSkeletonSpells, $sTxtDonateSkeletonSpells, $sTxtBlacklistSkeletonSpells, $aDonSkeletonSpells, $aBlkSkeletonSpells
;;; Custom Combination Donate by ChiefM3, converted to ground support by MonkeyHunter
Global $ichkDonateAllCustomA, $ichkDonateCustomA, $sTxtDonateCustomA,$sTxtBlacklistCustomA, $aDonCustomA, $aBlkCustomA, $varDonateCustomA[3][2]
; 2nd custom troop combo added for air support
Global $ichkDonateAllCustomB, $ichkDonateCustomB, $sTxtDonateCustomB, $sTxtBlacklistCustomB, $aDonCustomB, $aBlkCustomB, $varDonateCustomB[3][2]

Global $sTxtBlacklist, $aBlacklist
Global $B[6] = [116, 111, 98, 111, 116, 46]
Global $F[8] = [112, 58, 47, 47, 119, 119, 119, 46]
Global $ichkExtraAlphabets = 0 ; extra alphabets

Global $DonBarb = 0, $DonArch = 0, $DonGiant = 0, $DonGobl = 0, $DonWall = 0, $DonBall = 0, $DonWiza = 0, $DonHeal = 0
Global $DonMini = 0, $DonHogs = 0, $DonValk = 0, $DonGole = 0, $DonWitc = 0, $DonLava = 0, $DonBowl = 0, $DonDrag = 0, $DonPekk = 0, $DonBabyD = 0, $DonMine = 0

;Troop Settings
Global $icmbTroopComp ;Troop Composition
Global $icmbDarkTroopComp = 1
Global $icmbTroopCap ;Troop Capacity
Global $BarbComp = 30, $ArchComp = 60, $GoblComp = 10, $GiantComp = 4, $WallComp = 4, $WizaComp = 0, $MiniComp = 0, $HogsComp = 0
Global $DragComp = 0, $BallComp = 0, $PekkComp = 0, $HealComp = 0, $ValkComp = 0, $GoleComp = 0, $WitcComp = 0, $LavaComp = 0, $BowlComp = 0
Global $BabyDComp = 0, $MineComp = 0
Global $CurBarb = 0, $CurArch = 0, $CurGiant = 0, $CurGobl = 0, $CurWall = 0, $CurBall = 0, $CurWiza = 0, $CurHeal = 0
Global $CurMini = 0, $CurHogs = 0, $CurValk = 0, $CurGole = 0, $CurWitc = 0, $CurLava = 0, $CurBowl = 0, $CurDrag = 0, $CurPekk = 0, $CurBabyD = 0, $CurMine = 0
Global $T[1] = [97]
Global $ArmyComp

;Spell Settings
Global $DonPois = 0, $DonEart = 0, $DonHast = 0, $DonSkel
Global $iLightningSpellComp = 0, $iHealSpellComp = 0, $iRageSpellComp = 0, $iJumpSpellComp = 0, $iFreezeSpellComp = 0,$iCloneSpellComp = 0, $iPoisonSpellComp = 0, $iEarthSpellComp = 0, $iHasteSpellComp = 0, $iSkeletonSpellComp = 0
Global $CurTotalSpell = False ; True when spell count haa been read
Global $CurLightningSpell = 0, $CurHealSpell = 0, $CurRageSpell = 0, $CurJumpSpell = 0, $CurFreezeSpell = 0, $CurCloneSpell = 0, $CurPoisonSpell = 0, $CurHasteSpell = 0, $CurEarthSpell = 0, $CurSkeletonSpell = 0
Global $iTotalCountSpell = 0
Global $iTotalTrainSpaceSpell = 0
Global $TotalSFactory = 0
Global $CurSFactory = 0

;Wait For Spells
Global $iEnableSpellsWait[$iModeCount]
Global $bFullArmySpells = False  ; true when $iTotalTrainSpaceSpell = $iTotalSpellSpace in getArmySpellCount

Global $barrackPos[4][2] ;Positions of each barracks

Global $barrackTroop[5] ;Barrack troop set
Global $darkBarrackTroop[2]
Global $ArmyPos[2] = [-1, -1]

;Other Settings
Global $ichkWalls
Global $icmbWalls = 6
Global $iUseStorage

Global $itxtWallMinGold = 250000
Global $itxtWallMinElixir = 250000
Global $iVSDelay = 0
Global $iMaxVSDelay = 0
Global $isldTrainITDelay = 40
Global $ichkTrap, $iChkCollect, $ichkTombstones, $ichkCleanYard, $ichkTrapAfter
;Boju Only clear GemBox
Global $ichkGemsBox
;Only clear GemBox
Global $iCmbUnitDelay[$iModeCount+1], $iCmbWaveDelay[$iModeCount+1], $iChkRandomspeedatk[$iModeCount+1], $icmbStandardAlgorithm[$iModeCount+1]
$iCmbUnitDelay[$DB] = 4
$iCmbWaveDelay[$DB] = 4
$iCmbUnitDelay[$LB] = 4
$iCmbWaveDelay[$LB] = 4
$iCmbUnitDelay[$MA] = 4
$iCmbWaveDelay[$MA] = 4
$iChkRandomspeedatk[$DB] = 1
$iChkRandomspeedatk[$LB] = 1
$iChkRandomspeedatk[$MA] = 1

Global $iTimeTroops = 0
Global $iTimeGiant = 120
Global $iTimeWall = 120
Global $iTimeArch = 25
Global $iTimeGoblin = 30
Global $iTimeBarba = 20
Global $iTimeWizard = 480
Global $iChkTrophyHeroes, $iChkTrophyAtkDead, $itxtDTArmyMin = 70

Global $Walltolerance[7] = [35, 35, 45, 35, 45, 40, 35]

;General Settings
Global $frmBotPosX = -1 ; Position X of the GUI
Global $frmBotPosY = -1 ; Position Y of the GUI
Global $AndroidPosX = -1 ; Position X of the Android Window (undocked)
Global $AndroidPosY = -1 ; Position Y of the Android Window (undocked)
Global $frmBotDockedPosX = -1 ; Position X of the docked GUI
Global $frmBotDockedPosY = -1 ; Position Y of the docked GUI
Global $iUpdatingWhenMinimized = 1 ; Alternative Minimize Window routine for bot that enables window updates when minimized
Global $chkUpdatingWhenMinimized
Global $iHideWhenMinimized = 0 ; Hide bot window in taskbar when minimized
Global $chkHideWhenMinimized
Global $frmBotAddH = 0; Additional Height of GUI (e.g. when Android docked)
Global $Hide = False ; If hidden or not
Global $iDividerY = 243
Global $iDividerHeight = 4

Global $ichkBotStop, $icmbBotCommand, $icmbBotCond, $icmbHoursStop
Global $C[6] = [98, 117, 103, 115, 51, 46]
Global $CommandStop = -1
Global $MeetCondStop = False
Global $bTrainEnabled = True
Global $bDonationEnabled = True
Global $UseTimeStop = -1
Global $TimeToStop = -1

Global $iChkTrophyRange = 0
Global $itxtMaxTrophy = 1200 ; Max trophy before drop trophy
Global $itxtdropTrophy = 800; trophy floor to drop to
Global $bDisableDropTrophy = False ; this will be True if you tried to use Drop Throphy and did not have Tier 1 or 2 Troops to protect you expensive troops from being dropped.
Global $aDTtroopsToBeUsed[6][2] = [["Barb", 0], ["Arch", 0], ["Giant", 0], ["Wall", 0], ["Gobl", 0], ["Mini", 0]] ; DT available troops [type, qty]
Global $ichkAutoStart ; AutoStart mode enabled disabled
Global $ichkAutoStartDelay
Global $restarted
Global $ichkBackground ; Background mode enabled disabled
Global $collectorPos[17][2] ;Positions of each collectors
Global $D[4] = [99, 111, 109, 47]

Global $break = @ScriptDir & "\images\break.bmp"
Global $device = @ScriptDir & "\images\device.bmp"
Global $CocStopped = @ScriptDir & "\images\CocStopped.bmp"
Global $imgDivider = @ScriptDir & "\images\divider.bmp"
Global $iDividerY = 385
Global $G[3] = [104, 116, 116]
Global $resArmy = 0
Global $FirstRun = 1
Global $FirstAttack = 0
Global $CurTrophy = 0
Global $brrNum
Global $sTimer, $iTimePassed, $hour, $min, $sec, $sTimeWakeUp = 120
Global $fulltroop = 100
Global $CurCamp, $TotalCamp = 0
Global $NoLeague
Global $FirstStart = True
Global $TPaused, $BlockInputPause = 0

; Halt/Restart Mode values
Global $itxtRestartGold = 10000
Global $itxtRestartElixir = 25000
Global $itxtRestartDark = 500

;Create troop training variables
Global $DefaultTroopGroup[12][3] = [["Arch", 1, 1], ["Giant", 2, 5], ["Wall", 4, 2], ["Barb", 0, 1], ["Gobl", 3, 1], ["Heal", 7, 14], ["Pekk", 9, 25], ["Ball", 5, 5], ["Wiza", 6, 4], ["Drag", 8, 20], ["BabyD", 10, 10],["Mine", 11, 5]]
Global $TroopGroup[12][3]  ; Actual training order values determined dynamically based on GUI.
Global $TroopName[UBound($TroopGroup, 1)]
Global $TroopNamePosition[UBound($TroopGroup, 1)]
Global $TroopHeight[UBound($TroopGroup, 1)]
SetDefaultTroopGroup(False)

; Create custom train order GUI variables
Global $chkTroopOrder, $ichkTroopOrder, $btnTroopOrderSet
Global $aTroopOrderIcon[13] = [$eIcnOptions, $eIcnBarbarian, $eIcnArcher, $eIcnGiant, $eIcnGoblin, $eIcnWallBreaker, $eIcnBalloon, $eIcnWizard, $eIcnHealer, $eIcnDragon, $eIcnPekka, $eIcnBabyDragon, $eIcnMiner]
Global $cmbTroopOrder[UBound($aTroopOrderIcon)], $icmbTroopOrder[UBound($aTroopOrderIcon)], $lblTroopOrder[UBound($aTroopOrderIcon)], $ImgTroopOrder[UBound($aTroopOrderIcon)]
Global $chkDarkTroopOrder, $ichkDarkTroopOrder, $btnDarkTroopOrderSet
Global $aDarkTroopOrderIcon[8] = [$eIcnOptions, $eIcnMinion, $eIcnHogRider, $eIcnValkyrie, $eIcnGolem, $eIcnWitch, $eIcnLavaHound, $eIcnBowler]
Global $cmbDarkTroopOrder[UBound($aDarkTroopOrderIcon)], $icmbDarkTroopOrder[UBound($aDarkTroopOrderIcon)], $lblDarkTroopOrder[UBound($aDarkTroopOrderIcon)], $ImgDarkTroopOrder[UBound($aDarkTroopOrderIcon)]

;Create dark troop training variables
Global $DefaultTroopGroupDark[7][3] = [["Mini", 0, 2], ["Hogs", 1, 5], ["Valk", 2, 8], ["Gole", 3, 30], ["Witc", 4, 12], ["Lava", 5, 30], ["Bowl", 6, 6]]
Global $TroopGroupDark[7][3]
Global $TroopDarkName[UBound($TroopGroupDark, 1)]
Global $TroopDarkNamePosition[UBound($TroopGroupDark, 1)]
Global $TroopDarkHeight[UBound($TroopGroupDark, 1)]
SetDefaultTroopGroupDark(False)

Global $SpellGroup[4][3] = [["PSpell", 0, 1], ["ESpell", 1, 1], ["HaSpell", 2, 1], ["SkSpell", 3, 1]]
Global $SpellName[UBound($SpellGroup, 1)]
Global $SpellNamePosition[UBound($SpellGroup, 1)]
Global $SpellHeight[UBound($SpellGroup, 1)]
Global $BarrackStatus[4] = [False, False, False, False]
Global $BarrackFull[4] = [False, False, False, False]
Global $BarrackDarkStatus[2] = [False, False]
Global $BarrackDarkFull[2] = [False, False]
Global $listResourceLocation = ""
Global $isNormalBuild = ""
Global $isDarkBuild = ""
Global $TotalTrainedTroops = 0
For $i = 0 To UBound($SpellGroup, 1) - 1
	$SpellName[$i] = $SpellGroup[$i][0]
	$SpellNamePosition[$i] = $SpellGroup[$i][1]
	$SpellHeight[$i] = $SpellGroup[$i][2]
Next

;New var to search red area
Global $PixelTopLeft[0]
Global $PixelBottomLeft[0]
Global $PixelTopRight[0]
Global $PixelBottomRight[0]

Global $PixelTopLeftFurther[0]
Global $PixelBottomLeftFurther[0]
Global $PixelTopRightFurther[0]
Global $PixelBottomRightFurther[0]

Global $PixelMine[0]
Global $PixelElixir[0]
Global $PixelDarkElixir[0]
Global $PixelNearCollector[0]

Global $PixelRedArea[0]
Global $PixelRedAreaFurther[0]

Global Enum $eVectorLeftTop, $eVectorRightTop, $eVectorLeftBottom, $eVectorRightBottom

Global $isCCDropped = False
Global $isHeroesDropped = False
Global $DeployCCPosition[2] = [-1, -1]
Global $DeployHeroesPosition[2] = [-1, -1]


;Debug CLick
Global $debugClick = 0


Global $DESTOLoc = ""

Global $dropAllOnSide = 1

; Info Profile
Global $AttacksWon = 0
Global $DefensesWon = 0
Global $TroopsDonated = 0
Global $TroopsReceived = 0

Global $LootFileName = ""

; End Battle
Global $sTimeStopAtk[$iModeCount]
Global $sTimeStopAtk2[$iModeCount]
Global $ichkTimeStopAtk[$iModeCount]
Global $ichkTimeStopAtk2[$iModeCount]
Global $ichkEndNoResources[$iModeCount]
Global $ichkTimeStopAtk[$iModeCount]
Global $ichkTimeStopAtk2[$iModeCount]
Global $stxtMinGoldStopAtk2[$iModeCount]
Global $stxtMinElixirStopAtk2[$iModeCount]
Global $stxtMinDarkElixirStopAtk2[$iModeCount]
Global $ichkEndOneStar[$iModeCount]
Global $ichkEndTwoStars[$iModeCount]

;ImprovedUpgradeBuildingHero
Global $iUpgradeSlots = 12
Global $aUpgrades[$iUpgradeSlots][8]

;Fill empty array [8] to store upgrade data
For $i = 0 To $iUpgradeSlots - 1
	$aUpgrades[$i][0] = -1  ; position x
	$aUpgrades[$i][1] = -1  ; position y
	$aUpgrades[$i][2] = -1  ; upgrade value
	$aUpgrades[$i][3] = ""  ; string loot type required
	$aUpgrades[$i][4] = ""  ; string Bldg Name
	$aUpgrades[$i][5] = ""  ; string Bldg level
	$aUpgrades[$i][6] = ""  ; string upgrade time
	$aUpgrades[$i][7] = ""  ; string upgrade end date/time (_datediff compatible)
Next

Global $picUpgradeStatus[$iUpgradeSlots], $ipicUpgradeStatus[$iUpgradeSlots] ;Add indexable array variables for accessing the Upgrades GUI
Global $picUpgradeType[$iUpgradeSlots], $txtUpgradeX[$iUpgradeSlots], $txtUpgradeY[$iUpgradeSlots], $chkbxUpgrade[$iUpgradeSlots]
Global $txtUpgradeValue[$iUpgradeSlots], $chkUpgrdeRepeat[$iUpgradeSlots], $ichkUpgrdeRepeat[$iUpgradeSlots],$txtUpgradeLevel[$iUpgradeSlots]
Global $itxtUpgradeLevel[$iUpgradeSlots], $ichkbxUpgrade[$iUpgradeSlots ], $txtUpgradeName[$iUpgradeSlots ],$txtUpgradeTime[$iUpgradeSlots]
Global $txtUpgradeEndTime[$iUpgradeSlots]
Global $itxtUpgrMinGold, $itxtUpgrMinElixir, $txtUpgrMinDark, $itxtUpgrMinDark

$itxtUpgrMinGold = 250000
$itxtUpgrMinElixir = 250000
$itxtUpgrMinDark = 3000

Global $chkSaveWallBldr, $iSaveWallBldr
Global $pushLastModified = 0

;UpgradeTroops
Global $aLabPos[2] = [-1, -1]
Global $iChkLab, $iCmbLaboratory, $iFirstTimeLab
Global $sLabUpgradeTime = ""

Global Const $aSearchCost[11] = _
		[10, _
		50, _
		75, _
		110, _
		170, _
		250, _
		380, _
		580, _
		750, _
		900, _
		1000]

;deletefiles
Global $ichkDeleteLogs = 1
Global $iDeleteLogsDays = 2
Global $ichkDeleteTemp = 1
Global $iDeleteTempDays = 2
Global $ichkDeleteLoots = 1
Global $iDeleteLootsDays = 2

;dispose windows
Global $idisposewindows
Global $icmbDisposeWindowsPos

Global $iWAOffsetX = 0
Global $iWAOffsetY = 0

;Planned hours
Global $iPlannedDonateHours[24]
Global $iPlannedRequestCCHours[24]
Global $iPlannedDropCCHours[24]
Global $iPlannedDonateHoursEnable
Global $iPlannedRequestCCHoursEnable
Global $iPlannedDropCCHoursEnable
;Global $iPlannedBoostBarracksEnable
Global $iPlannedBoostBarracksHours[24]
For $i = 0 To 23
	$iPlannedBoostBarracksHours[$i] = 1
Next

Global $ichkbtnScheduler
Global $iPlannedattackHours[24]
For $i = 0 To 23
	$iPlannedattackHours[$i] = 1
Next
Global $iPlannedAttackWeekDays[7]
For $i = 0 To 6
	$iPlannedAttackWeekDays[$i] = 1
Next
Global $hourLoot
Global $fullArmy1 = False

; Share attack
Global $iShareAttack = 0
Global $iShareminGold = 300000
Global $iShareminElixir = 300000
Global $iSharemindark = 0
Global $sShareMessage = StringReplace("Nice|Good|Thanks|Wowwww", "|", @CRLF)
Global $iShareMessageEnable = 0
Global $iShareMessageSearch = 0
Global $iShareAttackNow = 0

Global $dLastShareDateApp = _Date_Time_GetLocalTime()
Global $dLastShareDate = _DateAdd("n", -60, _Date_Time_SystemTimeToDateTimeStr($dLastShareDateApp, 1))

Global $iUseRandomClick = 0
Global $iScreenshotType = 0
Global $ichkScreenshotHideName = 1

Global $ichkTotalCampForced = 0
Global $iValueTotalCampForced = 200
Global $ichkSinglePBTForced = 0
Global $iValueSinglePBTimeForced = 18
Global $iValuePBTimeForcedExit = 15
Global $bWaitShield = False
Global $bGForcePBTUpdate = False

Global $iMakeScreenshotNow = False


Global $lastversion = "" ;latest version from GIT
Global $lastmessage = "" ;message for last version
Global $ichkVersion = 1
Global $oldversmessage = "" ;warning message for old bot

;BarracksStatus
Global $numBarracks = 0
Global $numBarracksAvaiables = 0
Global $numDarkBarracks = 0
Global $numDarkBarracksAvaiables = 0
Global $numFactorySpell = 0
Global $numFactorySpellAvaiables = 0
Global $numFactoryDarkSpell = 0

Global $numFactoryDarkSpellAvaiables = 0

;position of barakcs
Global $btnpos = [[114, 535 + $midOffsetY], [228, 535 + $midOffsetY], [288, 535 + $midOffsetY], [348, 535 + $midOffsetY], [409, 535 + $midOffsetY], [494, 535 + $midOffsetY], [555, 535 + $midOffsetY], [637, 535 + $midOffsetY], [698, 535 + $midOffsetY]]
;barracks and spells avaiables
Global $Trainavailable = [1, 0, 0, 0, 0, 0, 0, 0, 0]

; Attack Report
Global $BonusLeagueG, $BonusLeagueE, $BonusLeagueD, $LeagueShort
Global $League[22][4] = [ _
		["0", "Bronze III", "0", "B3"], ["1000", "Bronze II", "0", "B2"], ["1300", "Bronze I", "0", "B1"], _
		["2600", "Silver III", "0", "S3"], ["3700", "Silver II", "0", "S2"], ["4800", "Silver I", "0", "S1"], _
		["10000", "Gold III", "0", "G3"], ["13500", "Gold II", "0", "G2"], ["17000", "Gold I", "0", "G1"], _
		["40000", "Crystal III", "120", "c3"], ["55000", "Crystal II", "220", "c2"], ["70000", "Crystal I", "320", "c1"], _
		["110000", "Master III", "560", "M3"], ["135000", "Master II", "740", "M2"], ["160000", "Master I", "920", "M1"], _
		["200000", "Champion III", "1220", "C3"], ["225000", "Champion II", "1400", "C2"], ["250000", "Champion I", "1580", "C1"], _
		["280000", "Titan III", "1880", "T3"], ["300000", "Titan II", "2060", "T2"], ["320000", "Titan I", "2240", "T1"], _
		["340000", "Legend", "2400", "LE"]]

; TakeABreak - Personal Break
Global $iTaBChkAttack = 0x01 ; code for PB warning when searching attack
Global $iTaBChkIdle = 0x02 ; code for PB warning when idle at base
Global $iTaBChkTime = 0x04 ; code for PB created by early log off feature
Global $bDisableBreakCheck = False
Global $sPBStartTime = "" ; date/time string for start of next Personal Break
Global $aShieldStatus = ["", "", ""] ; string shield type, string shield time, string date/time of Shield expire
;Global $aShieldStatus[3] = ["","",""] ; string shield type, string shield time, string date/time of Shield expire

;Building Side (DES/TH) Switch and DESide End Early
Global Enum $eSideBuildingDES, $eSideBuildingTH
Global $BuildingLoc, $BuildingLocX = 0, $BuildingLocY = 0
Global $dropQueen, $dropKing, $dropWarden
Global $BuildingEdge, $BuildingToLoc = ""
Global $saveiChkTimeStopAtk[$iModeCount], $saveiChkTimeStopAtk2[$iModeCount], $saveichkEndOneStar[$iModeCount], $saveichkEndTwoStars[$iModeCount]
Global $DarkLow
Global $DESideEB, $DELowEndMin = 25, $DisableOtherEBO
Global $DEEndAq, $DEEndBk, $DEEndOneStar
Global $SpellDP[2] = [0, 0]; Spell drop point for DE attack

;Attack SCV
Global $PixelMine[0]
Global $PixelElixir[0]
Global $PixelDarkElixir[0]
Global $PixelNearCollectorTopLeft[0]
Global $PixelNearCollectorBottomLeft[0]
Global $PixelNearCollectorTopRight[0]
Global $PixelNearCollectorBottomRight[0]
Global $GoldStoragePos
Global $ElixirStoragePos
Global $darkelixirStoragePos


;Snipe While Train
Global $isSnipeWhileTrain = False
Global $SnipeChangedSettings = False
Global $tempSnipeWhileTrain[8] = [0, 0, 0, 0, 0, 0, 0, 0]
Global $iChkSnipeWhileTrain = 0
Global $itxtSearchlimit = 15
Global $itxtminArmyCapacityTHSnipe = 35
Global $itxtSWTtiles = 1

Global $iChkRestartSearchLimit = 1
Global $iRestartSearchlimit = 25
Global $Is_SearchLimit = False

Global $canRequestCC = True


; Heroes upgrade
Global $ichkUpgradeKing = 0
Global $ichkUpgradeQueen = 0
Global $ichkUpgradeWarden = 0

; Barbarian King/Queen Upgrade Costs = Dark Elixir in xxxK
Global $aKingUpgCost[40] = [10, 12.5, 15, 17.5, 20, 22.5, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190]
Global $aQueenUpgCost[40] = [40, 22.5, 25, 27.5, 30, 32.5, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190, 195, 200]
; Grand Warden Upgrade Costs = Elixir in xx.xK
Global $aWardenUpgCost[20] = [6, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.4, 8.8, 9.1, 9.4, 9.6, 9.8, 10]

; OpenCloseCoc
Global $MinorObstacle = False

;Languages
Global Const $dirLanguages = @ScriptDir & "\Languages\"
Global $sLanguage = "English"
Global $aLanguageFile[1][2]; undimmed language file array [FileName][DisplayName]
Global Const $sDefaultLanguage = "English"
Global $aLanguage[1][1] ;undimmed language array

;images
Global $iDetectedImageType = 0

Global $iDeadBase75percent = 1
Global $iDeadBase75percentStartLevel = 4

;attackCSV
Global $scmbDBScriptName = "Barch four fingers"
Global $scmbABScriptName = "Barch four fingers"
Global $ichkUseAttackDBCSV = 0
Global $ichkUseAttackABCSV = 0
Global $attackcsv_locate_mine = 0
Global $attackcsv_locate_elixir = 0
Global $attackcsv_locate_drill = 0
Global $attackcsv_locate_gold_storage = 0
Global $attackcsv_locate_elixir_storage = 0
Global $attackcsv_locate_dark_storage = 0
Global $attackcsv_locate_townhall = 0

;Milking Attack
Global $debugresourcesoffset = 0 ;make images with offset to check correct adjust values
Global $continuesearchelixirdebug = 0 ; SLOW... if =1 search elixir check all images even if capacity < mincapacity and make debug image in temp folder if no match all images
Global $MilkingAttackDropGoblinAlgorithm = 1 ; 0= drop each goblin in different point, 1= drop all goblins in a point
Global $MilkingAttackCheckStructureDestroyedAfterAttack = 0
Global $MilkingAttackCheckStructureDestroyedBeforeAttack = 0
Global $MilkFarmLocateMine = 1
Global $MilkFarmLocateElixir = 1
Global $MilkFarmLocateDrill = 1
Global $MilkFarmElixirParam = StringSplit("-1|-1|-1|-1|-1|-1|2|2|2", "|", 2)
Global $MilkFarmMineParam = 5 ;values 0-8 (0=mines level 1-4  ; 1= mines level 5; ... ; 8=mines level 12)
Global $MilkFarmDrillParam = 1 ;values 1-6 (1=drill level 1 ... 6=drill level 6)
Global $MilkFarmAttackElixirExtractors = 1
Global $MilkFarmAttackGoldMines = 1
Global $MilkFarmAttackDarkDrills = 1
Global $MilkFarmLimitGold = 9995000
Global $MilkFarmLimitElixir = 9995000
Global $MilkFarmLimitDark = 200000
Global $MilkFarmResMaxTilesFromBorder = 0
Global $MilkFarmTroopForWaveMin = 4
Global $MilkFarmTroopForWaveMax = 6
Global $MilkFarmTroopMaxWaves = 3
Global $MilkFarmDelayFromWavesMin = 3000
Global $MilkFarmDelayFromWavesMax = 5000
Global $MilkFarmTHMaxTilesFromBorder = 1
Global $MilkFarmAlgorithmTh = "Queen&GobTakeTH"
Global $MilkFarmSnipeEvenIfNoExtractorsFound = 0
Global $MilkFarmOffsetX = 56
Global $MilkFarmOffsetY = 41
Global $MilkFarmOffsetXStep = 35
Global $MilkFarmOffsetYStep = 26
Global $CapacityStructureElixir0, $CapacityStructureElixir1, $CapacityStructureElixir2, $CapacityStructureElixir3, $CapacityStructureElixir4, $CapacityStructureElixir5, $CapacityStructureElixir6, $CapacityStructureElixir7, $CapacityStructureElixir8
Global $DestroyedMineIMG0, $DestroyedMineIMG1, $DestroyedMineIMG2, $DestroyedMineIMG3, $DestroyedMineIMG4, $DestroyedMineIMG5, $DestroyedMineIMG6, $DestroyedMineIMG7, $DestroyedMineIMG8
Global $DestroyedElixirIMG0, $DestroyedElixirIMG1, $DestroyedElixirIMG2, $DestroyedElixirIMG3, $DestroyedElixirIMG4, $DestroyedElixirIMG5, $DestroyedElixirIMG6, $DestroyedElixirIMG7, $DestroyedElixirIMG8
Global $DestroyedDarkIMG0, $DestroyedDarkIMG1, $DestroyedDarkIMG2, $DestroyedDarkIMG3, $DestroyedDarkIMG4, $DestroyedDarkIMG5, $DestroyedDarkIMG6, $DestroyedDarkIMG7, $DestroyedDarkIMG8
Global $MilkFarmForcetolerance = 0
Global $MilkFarmForcetolerancenormal = 31
Global $MilkFarmForcetoleranceboosted = 31
Global $MilkFarmForcetolerancedestroyed = 31
Global $MilkAttackType=1
Global $MilkQuicklyRestart= 150

Global $duringMilkingAttack = 0
Global $MilkingAttackStructureOrder = 1


Global $MilkAttackAfterTHSnipe = 0
Global $MilkAttackAfterScriptedAtk = 0
Global $debugMilkingIMGmake = 0
Global $MilkAttackCSVscript = "Barch four fingers"

;adjust resource coordinates returned by dll ( [0] adjust coord for resource level 0-4, [1] adj. for level 5... [8] adjust coord. for level 12 )
;									0	   1      2     3     4       5     6      7      8
Global $MilkFarmOffsetMine[9] = ["1-1", "1-1", "0-2", "0-4", "1-2", "1-1", "3-5", "3-6", "3-5"]
Global $MilkFarmOffsetElixir[9] = ["1-11", "1-11", "1-9", "1-13", "0-11", "0-11", "0-13", "0-11", "0-14"]
Global $MilkFarmOffsetDark[7] = ["0-0", "1-4", "1-3", "0-5", "4-8", "0-4", "0-3"]



;GUI STYLE
Global $iGUIStyle = 1
Global $color1 = 0xd0dfd7
Global $color2 = 0xb8cec4
Global $color3 = 0x9bbbb0
Global $color4 = 0x7ba296
Global $color0 = 0x707070


; type.level.xpos-y.pos.redarea1x-redarea1y.redarea2x,redarea2y,[...],redareanx,redareany|type.level.xpos,y.pos.redarea1x,redarea1y.redarea2x,redarea2y,[...],redareanx,redareany|....
;[0]type:gomine,elixir,ddrill
;[1]xpos and ypos
;[2]...[n] redarea points
Global $MilkFarmObjectivesSTR = ""
Global $milkingAttackOutside = 0

;collector GUI
Global $hCollectorGUI = 0

Global $iDeadBase75percent = 1
Global $iDeadBase75percentStartLevel = 4


;GUI variables
Global $hMilkGUI
Global $hSearchReductionGUI
Global $hTHBullyGUI
Global $hWeakBaseGUI
Global $hAlgorithmAllTroopsConfigGUI
Global $hAlgorithmAttackCSVConfigGUI
Global $hUnbreakableGUI
Global $hNotifyGUI
Global $hUpgradeGUI
Global $hUpgradeWallGUI
Global $hDonateGUI
Global $hHaltAndResumeGUI
Global $hBotOptionsGUI
Global $hGUI_BotDebug
Global $hLocateManuallyGUI
Global $hBoostBarracksGUI
Global $hAttHSchedGUI
Global $hExtra1GUI
Global $hExtra2GUI
Global $hShareReplayGUI
Global $hSkipTrappedTHGUI
Global $hTrophiesGUI
Global $hEndbattleABGUI
Global $hEndbattleDBGUI
Global $hEndbattleTSGUI
Global $hPresetGUI

Global $gui3open = 0
Global $guiSearchReductionopen = 0
Global $guiTHBullyOpen = 0
Global $guiWeakBaseOpen = 0
Global $guiAlgorithmAllTroopsConfigOpen = 0
Global $guiAlgorithmAttackCSVConfigOpen = 0
Global $guiUnbreakableOpen = 0
Global $guiNotifyOpen = 0
Global $guiUpgradeOpen = 0
Global $guiUpgradeWallOpen = 0
Global $guiDonateOpen = 0
Global $guiHaltAndResumeOpen = 0
Global $guiBotOptionsOpen = 0
Global $guiLocateManuallyOpen = 0
Global $guiBoostBarracksOpen = 0
Global $guiAttHSchedOpen = 0
Global $guiExtra1Open = 0
Global $guiExtra2Open = 0
Global $guiReplayShareOpen = 0
Global $guiSkipTrappedTHOpen = 0
Global $guiTrophiesOpen = 0
Global $guiEndBattleABOpen = 0
Global $guiEndBattleDBOpen = 0
Global $guiEndBattleTSOpen = 0
Global $guiPresetOpen = 0

; Debug Output of launch parameter
SetDebugLog("@AutoItExe: " & @AutoItExe)
SetDebugLog("@ScriptFullPath: " & @ScriptFullPath)
SetDebugLog("@WorkingDir: " & @WorkingDir)
SetDebugLog("@AutoItPID: " & @AutoItPID)
SetDebugLog("@OSArch: " & @OSArch)
SetDebugLog("@OSVersion: " & @OSVersion)
SetDebugLog("@OSBuild: " & @OSBuild)
SetDebugLog("@OSServicePack: " & @OSServicePack)
SetDebugLog("Primary Display: " & @DesktopWidth & " x " & @DesktopHeight & " - " & @DesktopDepth & "bit")

; DO NOT ENABLE ! ! ! Only for testing Error behavior ! ! !
Global $__TEST_ERROR_ADB_DEVICE_NOT_FOUND = False
Global $__TEST_ERROR = $__TEST_ERROR_ADB_DEVICE_NOT_FOUND
Global $__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY = 0
Global $__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY = 0
Global $__TEST_ERROR_SLOW_ADB_CLICK_DELAY = 0

; Variables to ImgLoc V3 , new image search library Aforge
; Is in Diamond
Global $DefaultCocDiamond = "430,70|787,335|430,605|67,333" ; DEFAULT No Grass just the village field
Global $ExtendedCocDiamond = "430,25|840,335|430,645|15,333" ; With Grass
; Reducing the Search Area (x,y,w,h)
Global $DefaultCocSearchArea = "70|70|720|540" ; Deafault
Global $ExtendedCocSearchArea = "15|25|825|625" ; Extended
; Similarity ( like tolerance ) 0,00 to 1,00
Global $ToleranceImgLoc = 0.95

Global $SecondaryInputFile = ""
Global $SecondaryOutputFile = ""

Global $quicklyfirststart = true
Global $configLoaded = false


Global $chkMakeIMGCSV


;TH Snipe Before Attack
Global $THSnipeBeforeDBEnable = 0 , $THSnipeBeforeLBEnable = 0
Global $THSnipeBeforeDBTiles = 0 , $THSnipeBeforeLBTiles = 0
Global $THSnipeBeforeDBScript = 0 , $THSnipeBeforeLBScript = 0

; Close game while train
Global $ichkCloseWaitTrain = 0, $ichkCloseWaitSpell, $ichkCloseWaitHero, $ibtnCloseWaitStop = 0, $ibtnCloseWaitStopRandom, $ibtnCloseWaitExact, $ibtnCloseWaitRandom, $icmbCloseWaitRdmPercent, $ichkCloseWaitEnable = 1
Global $aTimeTrain[3] = [0, 0, 0] ; [Troop remaining time], [Spells remaining time], [Hero remaining time - when possible]
Global $iCCRemainTime = 0  ; Time remaining until can request CC again

;Walls
Global $iNbrOfWallsUpped = 0
Global $itxtWall04ST=0, $itxtWall05ST=0, $itxtWall06ST=0, $itxtWall07ST=0, $itxtWall08ST=0, $itxtWall09ST=0, $itxtWall10ST=0, $itxtWall11ST=0

;Collectors
Global $chkLvl6Enabled = 1
Global $chkLvl7Enabled = 1
Global $chkLvl8Enabled = 1
Global $chkLvl9Enabled = 1
Global $chkLvl10Enabled = 1
Global $chkLvl11Enabled = 1
Global $chkLvl12Enabled = 1
Global $cmbLvl6Fill
Global $cmbLvl7Fill
Global $cmbLvl8Fill
Global $cmbLvl9Fill
Global $cmbLvl10Fill
Global $cmbLvl11Fill
Global $cmbLvl12Fill
Global $toleranceOffset


;Apply to switch Attack Standard after THSnipe End ==>
Global $ichkTSActivateCamps2, $iEnableAfterArmyCamps2
;==> Apply to switch Attack Standard after THSnipe End

Global $iShouldRearm = True

;=== No variables below ! ================================================

; early load of config
If FileExists($config) Or FileExists($building) Then
	readConfig()
EndIf
