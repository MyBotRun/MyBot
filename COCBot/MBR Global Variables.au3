; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Global Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Everyone all the time  :)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; AutoIt includes
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Process.au3>
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
#include <GuiComboBoxEx.au3>
#include <GuiSlider.au3>
#include <GuiToolBar.au3>
#include <ProgressConstants.au3> ; Added for Splash
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WinAPIProc.au3>
#include <WinAPIRes.au3>
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
#include <GuiListView.au3>
#include <GUIToolTip.au3>
#include <Crypt.au3>

Global Const $g_sLogoPath = @ScriptDir & "\Images\Logo.png"
Global Const $g_sLogoUrlPath = @ScriptDir & "\Images\LogoURL.png"
Global Const $g_iGAME_WIDTH = 860
Global Const $g_iGAME_HEIGHT = 732
Global Const $g_iDEFAULT_HEIGHT = 780
Global Const $g_iDEFAULT_WIDTH = 860
Global Const $g_iMidOffsetY = Int(($g_iDEFAULT_HEIGHT - 720) / 2)
Global Const $g_iBottomOffsetY = $g_iDEFAULT_HEIGHT - 720

Global $g_iBotLaunchTime = 0 ; Keeps track of time (in millseconds) from bot launch to ready for use

; Since October 12th 2016 Update, Village cannot be entirely zoomed out, offset updated in func SearchZoomOut
Global $g_iVILLAGE_OFFSET[3] = [0, 0, 1]

#Region debugging
; <><><><><><><><><><><><><><><><><><>
; <><><><> debugging <><><><>
Global $g_aiSearchEnableDebugDeadBaseImage = 200 ; If $g_iDebugDeadBaseImage is 0 and more than searches reached, set $g_iDebugDeadBaseImage = 1, 0 = disabled
; Enabled saving of enemy villages when deadbase is active
Global $g_aZombie = ["" _ ; 0=Filename
	, 0 _  ; 1=Raided Elixir
	, 0 _  ; 2=Available Elixir
	, 0 _  ; 3=# of matched collectod
	, 0 _  ; 4=Search #
	, "" _ ; 5=timestamp
	, "" _ ; 6=redline
	, 30 _ ; 7=Delete screenshot when Elixir capture percentage was >= value (-1 for disable)
	, 300 _; 8=Save screenshot when skipped DeadBase and available Exlixir in k is >= value and no filled Elixir Storage found (-1 for disable)
	, 600 _; 9=Save screenshot when skipped DeadBase and available Exlixir in k is >= value (-1 for disable)
	, 150 _; 10=Save screenshot when DeadBase and available Exlixir in k is < value (-1 for disable)
]

Global $g_iDebugSearchArea = 0, $g_iDebugRedArea = 0, $g_iDebugWalls = 0, $g_iDebugVillageSearchImages = 0
Global $g_iDebugMultilanguage = 0
Global $g_iDebugGetLocation = 0 ;make a image of each structure detected with getlocation
Global $g_iDebugAndroidEmbedded = 0
Global $g_iDebugWindowMessages = 0 ; 0=off, 1=most Window Messages, 2=all Window Messages
Global $g_iDebugGDICount = 0 ; monitor bot GDI Handle count, 0 = Disabled, <> 0 = Enabled
Global $g_iDebugGDICountMax = 0 ; max value of GDI Handle count
Global $g_oDebugGDIHandles = ObjCreate("Scripting.Dictionary") ; stores GDI handles when $g_iDebugGDICount <> 0

; Milking
Global $g_iDebugResourcesOffset = 0 ;make images with offset to check correct adjust values
Global $g_iDebugMilkingIMGmake = 0
Global $g_iDebugContinueSearchElixir = 0 ; SLOW... if =1 search elixir check all images even if capacity < mincapacity and make debug image in temp folder if no match all images

; From Bot/Debug window
Global $g_iDebugClick = 0 ; Debug Bot Clicks and when docked, display current mouse position and RGB color
Global $g_iDebugSetlog = 0, $g_iDebugOcr = 0, $g_iDebugImageSave = 0, $g_iDebugBuildingPos = 0, $g_iDebugSetlogTrain = 0, $g_iDebugDisableZoomout = 0, $g_iDebugDisableVillageCentering = 0
Global $g_iDebugOCRdonate = 0 ; when 1 make OCR and simulate but do not donate
Global $g_iDebugAttackCSV = 0, $g_iDebugMakeIMGCSV = 0 ;attackcsv debug
Global $g_iDebugDeadBaseImage = 0 ; Enable collection of zombies (capture screenshot of detect DeadBase routine)

; <><><><> debugging <><><><>
; <><><><><><><><><><><><><><><><><><>
#EndRegion

Global Const $COLOR_ORANGE = 0xFF7700  ; Used for donate GUI buttons
Global Const $COLOR_ERROR = $COLOR_RED   ; Error messages
Global Const $COLOR_WARNING = $COLOR_MAROON ; Warning messages
Global Const $COLOR_INFO = $COLOR_BLUE ; Information or Status updates for user
Global Const $COLOR_SUCCESS = 0x006600   ; Dark Green, Action, method, or process completed successfully
Global Const $COLOR_SUCCESS1 = 0x009900  ; Med green, optional success message for users
Global Const $COLOR_DEBUG = $COLOR_PURPLE ; Purple, basic debug color
Global Const $COLOR_DEBUG1 = 0x7a00cc  ; Dark Purple, Debug for successful status checks
Global Const $COLOR_DEBUG2 = 0xaa80ff  ; lt Purple, secondary debug color
Global Const $COLOR_DEBUGS = $COLOR_MEDGRAY  ; Med Grey, debug color for less important but needed supporting data points in multiple messages
Global Const $COLOR_ACTION = 0xFF8000 ; Med Orange, debug color for individual actions, clicks, etc
Global Const $COLOR_ACTION1 = 0xcc80ff ; Light Purple, debug color for pixel/window checks

Global Const $g_bCapturePixel = True, $g_bNoCapturePixel = False

Global $g_bCriticalMessageProcessing = False
Global $g_hHBitmapTest = 0 ; Image used when testing image functions (_CaptureRegion will not take new screenshot when <> 0)
Global $hBitmap ; Image for pixel functions
Global $hHBitmap ; Handle Image for pixel functions
Global $hHBitmap2  ; handle to Device Context (DC) with graphics captured by _captureregion2()
Global $g_bOcrForceCaptureRegion = True ; When True take new $hHBitmap2 screenshot of OCR area otherwise create area from existing (fullscreen!) $hHBitmap2

;Global $sFile = @ScriptDir & "\Icons\logo.gif"

Global Const $g_b64Bit = StringInStr(@OSArch, "64") > 0
Global Const $g_sHKLM = "HKLM" & ($g_b64Bit ? "64" : "")
Global Const $g_sWow6432Node = ($g_b64Bit ? "\Wow6432Node" : "")
Global Const $g_sGoogle = "Google"

#Region Android.au3
; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
; <><><><><><>  Android.au3 (and related) globals <><><><><><>
Global $g_sAndroidGameDistributor = "Google" ; Default CoC Game Distributor, loaded from config.ini
Global $g_sAndroidGamePackage = "com.supercell.clashofclans" ; Default CoC Game Package, loaded from config.ini
Global $g_sAndroidGameClass = ".GameApp" ; Default CoC Game Class, loaded from config.ini
Global $g_sUserGameDistributor = "Google" ; User Added CoC Game Distributor, loaded from config.ini
Global $g_sUserGamePackage = "com.supercell.clashofclans" ; User Added CoC Game Package, loaded from config.ini
Global $g_sUserGameClass = ".GameApp" ; User Added CoC Game Class, loaded from config.ini

; embed
Global Const $g_bAndroidShieldPreWin8 = (_WinAPI_GetVersion() < 6.2) ; Layered Child Window only support for WIN_8 and later
Global $g_avAndroidShieldDelay[4] = [0, 0, Default, Default] ; Delay shield call: 0=TimerInit Handle, 1=Delay in ms., 2=AndroidShield action: True, False, Default
Global $g_bAndroidShieldForceDown = False ; Have shield down in Default mode even if it should be on e.g. in run state
Global $g_iAndroidShieldColor = $COLOR_WHITE
Global $g_iAndroidShieldTransparency = 48
Global $g_iAndroidActiveColor = $COLOR_BLACK
Global $g_iAndroidActiveTransparency = 1
Global $g_iAndroidInactiveColor = $COLOR_WHITE
Global $g_iAndroidInactiveTransparency = 24
Global $g_bAndroidShieldEnabled = True
Global $g_bAndroidEmbedEnabled = True
Global $g_bAndroidEmbedded = False
Global $g_aiAndroidEmbeddedCtrlTarget[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_avAndroidShieldStatus[5] = [Default, 0, 0, Default, Default] ; Current Android Shield status (0: True = Shield Up, False = Shield Down, Default only for init; 1: Color; 2: Transparency = 0-255; 3: Invisible Shield; 4: Detached Shield)

Global Const $g_bAndroidBackgroundLaunchEnabled = False ; Headless mode not finished yet (2016-07-13, cosote)
Global $g_bAndroidCheckTimeLagEnabled = True ; Checks every 60 Seconds or later in main loops (Bot Run, Idle and SearchVillage) is Android needs reboot due to time lag (see $g_iAndroidTimeLagThreshold)
Global $g_iAndroidAdbAutoTerminate = 0 ; Steady ADB shell instance is automatically closed after this number of executed commands, 0 = disabled (test for BS to fix frozen screen situation!)
Global $g_bAndroidAdbScreencapEnabled = True ; Use Android ADB to capture screenshots in RGBA raw format
Global $g_bAndroidAdbScreencapPngEnabled = False ; Use Android ADB to capture screenshots in PNG format, significantly slower than raw format (not final, captured screenshot resize too slow...)
Global $g_bAndroidAdbZoomoutEnabled = True ; Use Android ADB zoom-out script
Global $g_bAndroidAdbClickDragEnabled = True ; Use Android ADB click drag script
Global $g_bAndroidAdbInputEnabled = True ; Enable Android ADB send text (CC requests), swipe not used as click drag anymore
Global $g_iAndroidAdbInputWordsCharLimit = 0 ; Android ADB send text words (split by space) with this limit of specified characters per command (0 = disabled and entire text is sent at once)
Global $g_bAndroidAdbClickEnabled = False ; Enable Android ADB mouse click
Global $g_bAndroidAdbClicksEnabled = False ; (Experimental & Dangerous!) Enable Android KeepClicks() and ReleaseClicks() to fire collected clicks all at once, only available when also $g_bAndroidAdbClick = True
Global $g_iAndroidAdbClicksTroopDeploySize = 0 ; (Experimental & Dangerous!) Deploy more troops at once, 0 = deploy group, only available when also $g_bAndroidAdbClicksEnabled = True (currently only just in CSV Deploy)
Global $g_bAndroidAdbInstanceEnabled = True ; Enable Android steady ADB shell instance when available
Global $g_bAndroidSuspendedEnabled = False ; Enable Android Suspend & Resume during Search and Attack
Global $g_bNoFocusTampering = False ; If enabled, no ControlFocus or WinActivate is called, except when really required (like Zoom-Out for Droid4X, might break restart stability when Android Window not responding)
Global $g_iAndroidRecoverStrategy = 1 ; 0 = Stop ADB Daemon first then restart Android; 1 = Restart Android first then restart ADB Daemon

; Android Configutions
Global $__MEmu_Idx = 0 ; MEmu 2.2.1, 2.3.0, 2.3.1, 2.5.0, 2.6.1, 2.6.2, 2.6.5, 2.6.6, 2.7.0, 2.7.2, 2.8.0, default config with open Tool Bar at right and System Bar at bottom, adjusted in config
Global $__BS2_Idx = 1 ; BlueStacks 2.5.x, 2.4.x, 2.3.x, 2.2.x, 2.1.x, 2.0.x
Global $__BS_Idx = 2 ; BlueStacks 0.11.x, 0.10.x, 0.9.x, 0.8.x
Global $__KOPLAYER_Idx = 3 ; KOPLAYER 1.4.1049
Global $__LeapDroid_IDx = 4 ; LeapDroid 1.8.0, 1.7.0, 1.6.1, 1.5.0, 1.4.0, 1.3.1
Global $__iTools_Idx = 5 ; iTools AVM 2.0.6.8
Global $__Droid4X_Idx = 6 ; Droid4X 0.10.5 Beta, 0.10.4 Beta, 0.10.3 Beta, 0.10.2 Beta, 0.10.1 Beta, 0.10.0 Beta, 0.9.0 Beta, 0.8.7 Beta, 0.8.6 Beta
Global $__Nox_Idx = 7 ; Nox 3.7.5.1, 3.7.5, 3.7.3, 3.7.1, 3.7.0, 3.6.0, 3.5.1, 3.3.0, 3.1.0
; "BlueStacks2" $g_avAndroidAppConfig is also updated based on Registry settings in Func InitBlueStacks2() with these special variables
Global $__BlueStacks_SystemBar = 48
Global $__BlueStacks2Version_2_5_or_later = False ;Starting with this version bot is enabling ADB click and uses different zoomout
; "MEmu" $g_avAndroidAppConfig is also updated based on runtime config in Func UpdateMEmuWindowState() with these special variables
Global $__MEmu_Adjust_Width = 6
Global $__MEmu_ToolBar_Width = 45
Global $__MEmu_SystemBar = 36
Global $__MEmu_PhoneLayout = "0"
Global $__MEmu_Window[3][4] = _ ; Alternative window sizes (array must be ordered by version descending!)
[ _; Version|$g_iAndroidWindowWidth|$g_iAndroidWindowHeight|$__MEmu_ToolBar_Width
    ["2.6.2",$g_iDEFAULT_WIDTH + 48,$g_iDEFAULT_HEIGHT + 26,40], _
    ["2.5.0",$g_iDEFAULT_WIDTH + 51,$g_iDEFAULT_HEIGHT + 24,40], _
    ["2.2.1",$g_iDEFAULT_WIDTH + 51,$g_iDEFAULT_HEIGHT + 24,45] _
]
Global $__Droid4X_Window[3][3] = _ ; Alternative window sizes (array must be ordered by version descending!)
[ _; Version|$g_iAndroidWindowWidth|$g_iAndroidWindowHeight
    ["0.10.0",$g_iDEFAULT_WIDTH +  6,$g_iDEFAULT_HEIGHT + 53], _
    ["0.8.6" ,$g_iDEFAULT_WIDTH + 10,$g_iDEFAULT_HEIGHT + 50] _
]
;   0            |1                  |2                       |3                                 |4               |5                     |6                      |7                     |8                      |9             |10                  |11                       |12                    |13                                  |14
;   $g_sAndroidEmulator              |$Title                  |$g_sAppClassInstance              |$g_sAppPaneName |$g_iAndroidClientWidth|$g_iAndroidClientHeight|$g_iAndroidWindowWidth|$g_iAndroidWindowHeight|$ClientOffsetY|$g_sAndroidAdbDevice|$g_iAndroidSupportFeature|$g_sAndroidShellPrompt|$g_sAndroidMouseDevice              |$g_bAndroidEmbed/$g_iAndroidEmbedMode
;                |$g_sAndroidInstance|                        |                                  |                |                      |                       |                      |                       |              |                    |1 = Normal background mode                      |                                    |-1 = Not available
;                |                   |                        |                                  |                |                      |                       |                      |                       |              |                    |2 = ADB screencap mode   |                      |                                    | 0 = Normal docking
;                |                   |                        |                                  |                |                      |                       |                      |                       |              |                    |4 = ADB mouse click      |                      |                                    | 1 = Simulated docking
;                |                   |                        |                                  |                |                      |                       |                      |                       |              |                    |8 = ADB input text       |                      |                                    |
;                |                   |                        |                                  |                |                      |                       |                      |                       |              |                    |16 = ADB shell is steady                        |                                    |
Global $g_avAndroidAppConfig[8][15] = [ _ ;                   |                                  |                |                      |                       |                      |                       |              |                    |32 = ADB click drag      |                      |                                    |
   ["MEmu",       "MEmu",             "MEmu ",                 "[CLASS:subWin; INSTANCE:1]",       "",             $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 12,$g_iDEFAULT_WIDTH + 51,$g_iDEFAULT_HEIGHT + 24,0,             "127.0.0.1:21503",   0+2+4+8+16+32         ,   '# ',                  'Microvirt Virtual Input',           0], _
   ["BlueStacks2","",                 "BlueStacks ",           "[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window",  $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,0,             "127.0.0.1:5555",    1    +8+16+32         ,   '$ ',                  'BlueStacks Virtual Touch',          0], _
   ["BlueStacks", "",                 "BlueStacks App Player", "[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window",  $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,0,             "127.0.0.1:5555",    1    +8+16+32         ,   '$ ',                  'BlueStacks Virtual Touch',          0], _
   ["KOPLAYER",   "KOPLAYER",         "KOPLAYER",              "[CLASS:subWin; INSTANCE:1]",       "",             $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 64,$g_iDEFAULT_HEIGHT -  8,0,             "127.0.0.1:6555" ,   0+2+4+8+16+32         ,   '# ',                  'ttVM Virtual Input',                0], _
   ["LeapDroid",  "vm1",              "Leapd",                 "[CLASS:subWin; INSTANCE:1]",       "",             $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH     ,$g_iDEFAULT_HEIGHT - 48,0,             "emulator-5554",     1+    8+16+32         ,   '# ',                  'qwerty2',                           1], _
   ["iTools",     "iToolsVM",         "iTools ",               "[CLASS:subWin; INSTANCE:1]",       "",             $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH +  2,$g_iDEFAULT_HEIGHT - 13,0,             "127.0.0.1:54001",   1    +8+16+32         ,   '# ',                  'iTools Virtual PassThrough Input',  0], _
   ["Droid4X",    "droid4x",          "Droid4X ",              "[CLASS:subWin; INSTANCE:1]",       "",             $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 10,$g_iDEFAULT_HEIGHT + 50,0,             "127.0.0.1:26944",   0+2+4+8+16+32         ,   '# ',                  'droid4x Virtual Input',             0], _
   ["Nox",        "nox",              "No",                    "[CLASS:Qt5QWindowIcon;INSTANCE:4]","",             $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH +  4,$g_iDEFAULT_HEIGHT - 10,0,             "127.0.0.1:62001",   0+2+4+8+16+32         ,   '# ',                  '(nox Virtual Input|Android Input)',-1] _
]

; Startup detection
Global $g_bOnlyInstance = True
Global $g_bFoundRunningAndroid = False
Global $g_bFoundInstalledAndroid = False

Global Const $g_iOpenAndroidActiveMaxTry = 3 ; Try recursively 3 times to open Android
Global $g_iAndroidConfig = 0 ; Default selected Android Config of $g_avAndroidAppConfig array
Global $g_sAndroidVersion ; Identified version of Android Emulator
Global $g_sAndroidEmulator ; Emulator used (BS, BS2, Droid4X, MEmu or Nox)
Global $g_sAndroidInstance ; Clone or instance of emulator or "" if not supported
Global $Title ; Emulator Window Title
Global $g_bUpdateAndroidWindowTitle = False ; If Android has always same title (like LeapDroid) instance name will be added
Global $g_sAppClassInstance ; Control Class and instance of android rendering
Global $g_sAppPaneName ; Control name of android rendering TODO check is still required
Global $g_iAndroidClientWidth ; Expected width of android rendering control
Global $g_iAndroidClientHeight ; Expected height of android rendering control
Global $g_iAndroidWindowWidth ; Expected Width of android window
Global $g_iAndroidWindowHeight ; Expected height of android window
Global $g_sAndroidAdbPath ; Path to executable HD-Adb.exe or adb.exe
Global $g_sAndroidAdbDevice ; full device name ADB connects to
Global $g_iAndroidSupportFeature ; See $g_avAndroidAppConfig above!
Global $g_sAndroidShellPrompt ; empty string not available, '# ' for rooted and '$ ' for not rooted android
Global $g_sAndroidMouseDevice ; empty string not available, can be direct device '/dev/input/event2' or name by getevent -p
Global $g_bAndroidAdbScreencap ; Use Android ADB to capture screenshots in RGBA raw format
Global $g_bAndroidAdbClick ; Enable Android ADB mouse click
Global $g_bAndroidAdbInput ; Enable Android ADB send text (CC requests)
Global $g_bAndroidAdbInstance ; Enable Android steady ADB shell instance when available
Global $g_bAndroidAdbClickDrag ; Enable Android ADB Click Drag script
Global $g_bAndroidEmbed ; Enable Android Docking
Global $g_iAndroidEmbedMode ; Android Dock Mode: -1 = Not available, 0 = Normal docking, 1 = Simulated docking
Global $g_bAndroidBackgroundLaunch ; Enabled Android Background launch using Windows Scheduled Task
Global $g_bAndroidBackgroundLaunched ; True when Android was launched in headless mode without a window
Global $g_iAndroidControlClickWindow = 0 ; 0 = Click the Android Control, 1 = Click the Android Window
Global $g_iAndroidControlClickMode = 0 ; 0 = Use AutoIt ControlClick, 1 = Use _SendMessage

; Updated in UpdateAndroidConfig() and $g_sAndroidEmulator&Init() as well
Global $g_bInitAndroidActive = False

Global $g_sAndroidProgramPath = "" ; Program path and executable to launch android emulator
Global $g_avAndroidProgramFileVersionInfo = 0 ; Array of _WinAPI_VerQueryValue FileVersionInfo
Global $g_bAndroidHasSystemBar = False ; BS2 System Bar can be entirely disabled in Windows Registry
Global $g_iAndroidClientWidth_Configured = 0 ; Android configured Screen Width
Global $g_iAndroidClientHeight_Configured = 0 ; Android configured Screen Height
Global $g_iAndroidLaunchWaitSec = 240 ; Seconds to wait for launching Android Simulator

Global $g_iAndroidAdbPid = 0 ; Single instance of ADB used for screencap (and sendevent in future)
Global $g_sAndroidAdbPrompt = "mybot.run:" ; Single instance of ADB PS1 prompt
Global $g_sAndroidPicturesPath = ""; Android mounted path to pictures on host
Global $g_sAndroidPicturesHostPath = ""; Windows host path to mounted pictures in android
Global $g_bAndroidSharedFolderAvailable = True
Global Const $AndroidSecureFlags = 3 ; Bits 0 = disabled file renaming/folder less mode, 1 = Secure (SHA-1 filenames no folder), 2 = Delete files after use immediately
Global $g_sAndroidPicturesHostFolder = "" ; Subfolder for host and android, can be "", must end with "\" when used
Global $g_bAndroidPicturesPathAutoConfig = True ; Try to configure missing shared folder if missing
; Special ADB modes for screencap, mouse clicks and input text
Global $g_iAndroidAdbAutoTerminateCount = 0 ; Counter for $g_iAndroidAdbAutoTerminate to terminate ADB shell automatically after x executed commands
Global $g_aiAndroidAdbScreencapBuffer = DllStructCreate("byte[" & ($g_iDEFAULT_WIDTH * $g_iDEFAULT_HEIGHT * 4) & "]") ; Holds the android screencap BGRA buffer for caching
Global $g_hAndroidAdbScreencapBufferPngHandle = 0 ; Holds the android screencap PNG buffer for caching (handle to GDIPlus Bitmap/Image Object)
Global Const $g_iAndroidAdbScreencapWaitAdbTimeout = 10000 ; Timeout to wait for Adb screencap command
Global Const $g_iAndroidAdbScreencapWaitFileTimeout = 10000 ; Timeout to wait for file to be accessible for bot
Global $g_iAndroidAdbScreencapTimer = 0 ; Timer handle to use last captured screenshot to improve performance
Global $g_iAndroidAdbScreencapTimeoutMin = 200 ; Minimum Milliseconds the last screenshot is used; can be overridden via the ini file
Global $g_iAndroidAdbScreencapTimeoutMax = 1000 ; Maximum Milliseconds the last screenshot is used; can be overridden via the ini file
Global $g_iAndroidAdbScreencapTimeout = $g_iAndroidAdbScreencapTimeoutMax ; Milliseconds the last screenshot is used, dynamically calculated: $g_iAndroidAdbScreencapTimeoutMin < 3 x last capture duration < $g_iAndroidAdbScreencapTimeoutMax
Global $g_iAndroidAdbScreencapTimeoutDynamic = 3 ; Calculate dynamic timeout multiply of last duration; if 0 $g_iAndroidAdbScreencapTimeoutMax is used as fix timeout; can be overridden via the ini file
Global $g_iAndroidAdbScreencapWidth = 0 ; Width of last captured screenshot (always full size)
Global $g_iAndroidAdbScreencapHeight = 0 ; Height of last captured screenshot (always full size)
Global $g_iAndroidAdbClickGroup = 10 ; 1 Disables grouping clicks; > 1 number of clicks fired at once (e.g. when Click with $times > 1 used) (Experimental as some clicks might get lost!); can be overridden via the ini file
Global Const $g_iAndroidAdbClickGroupDelay = 50 ; Additional delay in Milliseconds after group of ADB clicks sent (sleep in Android is executed!)
Global $g_bAndroidAdbKeepClicksActive = False ; Track KeepClicks mode regardless of enabled or not (poor mans deploy troops detection)

Global $g_aiAndroidTimeLag[4] = [0,0,0,0] ; Timer varibales for time lag calculation
Global Const $g_iAndroidTimeLagThreshold = 5 ; Time lag Seconds per Minute when CoC gets restarted

Global Const $g_iAndroidRebootPageErrorCount = 5 ; Reboots Android automatically after so many IsPage errors (uses $AndroidPageError[0] and $g_iAndroidRebootPageErrorPerMinutes)
Global Const $g_iAndroidRebootPageErrorPerMinutes = 10 ; Reboot Android if $AndroidPageError[0] errors occurred in $g_iAndroidRebootPageErrorPerMinutes Minutes
Global $g_hProcShieldInput[5] = [0, 0, False, False, 0] ; Stores Android Shield variables and states

Global $g_bSkipFirstZoomout = False ; Zoomout sets to True, CoC start/Start/Resume/Return from battle to False

Global $g_bForceCapture = False ; Force android ADB screencap to run and not provide last screenshot if available

Global $HWnD = 0 ; Handle for Android window
Global $HWnDCtrl = 0 ; Handle for Android Screen Control

Global $g_bInitAndroid = True ; Used to cache android config, is set to False once initialized, new emulator window handle resets it to True

Global Const $g_iCoCReconnectingTimeout = 60000 ; When still (or again) CoC reconnecting animation then restart CoC (handled in checkObstacles)

; Special Android Emulator variables
Global $__BlueStacks_Version
Global $__BlueStacks_Path
Global $__Droid4X_Version
Global $__Droid4X_Path
Global $__MEmu_Path
Global $__LeapDroid_Path
Global $__Nox_Path
Global $__KOPLAYER_Path
Global $__iTools_Path

Global $__VBoxManage_Path ; Full path to executable VBoxManage.exe
Global $__VBoxVMinfo ; Virtualbox vminfo config details of android instance
Global $__VBoxGuestProperties ; Virtualbox guestproperties config details of android instance

; <><><><><><>  Android.au3 globals <><><><><><>
; <><><><><><><><><><><><><><><><><><><><><><><><>
#EndRegion

; set ImgLoc threads use
Global $g_iThreads = -1 ; Used by ImgLoc for parallism, -1 = use as many threads as processors, 1..x = use only specified number of threads

; Profile file/folder paths
Global Const $g_sProfilePath = @ScriptDir & "\Profiles"
Global Const $g_sProfilePresetPath = @ScriptDir & "\Strategies"
Global $g_sProfileCurrentName = "" ; Name of profile currently being used
Global $g_sProfileConfigPath = "" ; Path to the current config.ini being used in this profile
Global $g_sProfileWeakBasePath = "" ; Path to stats_chkweakbase.ini file for this profile
Global $g_sProfileBuildingPath = "" ; Paths to building.ini file for this profile
Global $g_sProfileLogsPath = "", $g_sProfileLootsPath = "", $g_sProfileTempPath = "", $g_sProfileTempDebugPath = "" ; Paths to log/image/temp folders for this profile
Global $g_sProfileDonateCapturePath = "", $g_sProfileDonateCaptureWhitelistPath = "", $g_sProfileDonateCaptureBlacklistPath = "" ; Paths to donate related folders for this profile
Global $g_sProfileSecondaryInputFileName = ""
Global $g_sProfileSecondaryOutputFileName = ""

; Logging
Global $g_hTxtLogTimer = TimerInit() ; Timer Handle of last log
Global Const $g_iTxtLogTimerTimeout = 500 ; Refresh log only every configured Milliseconds
Global $g_bMoveDivider = False
Global $g_bSilentSetLog = False ; No logs to Log Control when enabled
Global $g_sLogFileName = ""
Global $g_hLogFile = 0
Global $g_hAttackLogFile = 0

; Used in _Sleep.au3 to control various administrative tasks when idle
Global $hStruct_SleepMicro = DllStructCreate("int64 time;") ; holds the _SleepMilli sleep time in 100-nanoseconds
Global $pStruct_SleepMicro = DllStructGetPtr($hStruct_SleepMicro)
Global Const $g_iEmptyWorkingSetAndroid = 60000 ; Empty Android Workingset every Minute
Global Const $g_iEmptyWorkingSetBot = 60000 ; Empty Bot Workingset every Minute
Global Const $g_bMoveMouseOutBS = False ; If enabled moves mouse out of Android window when bot is running
Global $g_bDevMode = False ; set to true in mybot.run.au3 if EnableMBRDebug.txt is present in MBR root directory

; Startup
Global $g_bBotLaunchOption_Restart = False ; If true previous instance is closed when found by window title, see bot launch options below
Global $g_bBotLaunchOption_Autostart = False ; If true bot will automatically start
Global $g_asCmdLine[1] = [0] ; Clone of $CmdLine without options, please use instead of $CmdLine
Global Const $g_sWorkingDir = @WorkingDir ; Working Directory at bot launch

; Mutex Handles
Global $g_hMutex_BotTitle = 0
Global $g_hMutex_Profile = 0
Global $g_hMutex_MyBot = 0

; Arrays to hold stat information
Global $aWeakBaseStats

; Directories to libraries, executables, icons, and CSVs
Global Const $g_sLibPath = @ScriptDir & "\lib" ;lib directory contains dll's
Global Const $g_sLibImageSearchPath = $g_sLibPath & "\ImageSearchDLL.dll" ; ImageSearch library
Global Const $g_sLibImgLocPath = $g_sLibPath & "\MyBotRunImgLoc.dll" ; Last Image Library from @trlopes with all Legal Information need on LGPL
Global $g_hLibImgLoc ; handle to imgloc library
Global Const $g_sLibFunctionsPath = $g_sLibPath & "\MBRFunctions.dll" ; functions library
Global $g_hLibFunctions = -1 ; handle to functions library
Global $g_hLibNTDLL = -1 ; handle to ntdll.dll
Global $g_hLibUser32DLL = -1 ; handle to user32.dll
Global Const $g_sLibIconPath = $g_sLibPath & "\MBRBOT.dll" ; icon library
Global Const $g_sTHSnipeAttacksPath = @ScriptDir & "\CSV\THSnipe"
Global Const $g_sCSVAttacksPath = @ScriptDir & "\CSV\Attack"

; Improve GUI interactions by disabling bot window redraw
Global $g_iRedrawBotWindowMode = 2 ; 0 = disabled, 1 = Redraw always entire bot window, 2 = Redraw only required bot window area (or entire bot if control not specified)

; enumerated Icons 1-based index to IconLib
Global Enum $eIcnArcher = 1, $eIcnDonArcher, $eIcnBalloon, $eIcnDonBalloon, $eIcnBarbarian, $eIcnDonBarbarian, $eEmpty1, $eIcnBuilder, $eIcnCC, $eIcnGUI, _
			$eIcnDark, $eIcnDragon, $eIcnDonDragon, $eIcnDrill, $eIcnElixir, $eIcnCollector, $eIcnFreezeSpell, $eIcnGem, $eIcnGiant, $eIcnDonGiant, _
			$eIcnTrap, $eIcnGoblin, $eIcnDonGoblin, $eIcnGold, $eIcnGolem, $eIcnDonGolem, $eIcnHealer, $eIcnDonHealer, $eIcnHogRider, $eIcnDonHogRider, _
			$eIcnHealSpell, $eIcnInferno, $eIcnJumpSpell, $eIcnLavaHound, $eIcnDonLavaHound, $eIcnLightSpell, $eIcnMinion, $eIcnDonMinion, $eIcnPekka, $eIcnDonPekka, _
			$eEmpty2, $eIcnRageSpell, $eIcnTroops, $eIcnHourGlass, $eIcnTH1, $eIcnTH10, $eIcnTrophy, $eIcnValkyrie, $eIcnDonValkyrie, $eIcnWall, $eIcnWallBreaker, _
			$eIcnDonWallBreaker, $eIcnWitch, $eIcnDonWitch, $eIcnWizard, $eIcnDonWizard, $eIcnXbow, $eIcnBarrackBoost, $eIcnMine, $eIcnCamp, _
			$eIcnBarrack, $eIcnSpellFactory, $eIcnDonBlacklist, $eIcnSpellFactoryBoost, $eIcnMortar, $eIcnWizTower, $eIcnPayPal, $eIcnNotify, $eIcnGreenLight, $eIcnLaboratory, _
			$eIcnRedLight, $eIcnBlank, $eIcnYellowLight, $eIcnDonCustom, $eIcnTombstone, $eIcnSilverStar, $eIcnGoldStar, $eIcnDarkBarrack, $eIcnCollectorLocate, $eIcnDrillLocate, _
			$eIcnMineLocate, $eIcnBarrackLocate, $eIcnDarkBarrackLocate, $eIcnDarkSpellFactoryLocate, $eIcnDarkSpellFactory, $eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnPoisonSpell, $eIcnBldgTarget, $eIcnBldgX, _
			$eIcnRecycle, $eIcnHeroes, $eIcnBldgElixir, $eIcnBldgGold, $eIcnMagnifier, $eIcnWallElixir, $eIcnWallGold, $eIcnKing, $eIcnQueen, $eIcnDarkSpellBoost, _
			$eIcnQueenBoostLocate, $eIcnKingBoostLocate, $eIcnKingUpgr, $eIcnQueenUpgr, $eIcnWardenUpgr, $eIcnWarden, $eIcnWardenBoostLocate, $eIcnKingBoost, $eIcnQueenBoost, $eIcnWardenBoost, _
			$eEmpty3, $eIcnReload, $eIcnCopy, $eIcnAddcvs, $eIcnEdit, $eIcnTreeSnow, $eIcnSleepingQueen, $eIcnSleepingKing, $eIcnGoldElixir, $eIcnBowler, $eIcnDonBowler, _
			$eIcnCCDonate, $eIcnEagleArt, $eIcnGembox, $eIcnInferno4, $eIcnInfo, $eIcnMain, $eIcnTree, $eIcnProfile, $eIcnCCRequest, _
			$eIcnTelegram, $eIcnTiles, $eIcnXbow3, $eIcnBark, $eIcnDailyProgram, $eIcnLootCart, $eIcnSleepMode, $eIcnTH11, $eIcnTrainMode, $eIcnSleepingWarden, _
			$eIcnCloneSpell, $eIcnSkeletonSpell, $eIcnBabyDragon, $eIcnDonBabyDragon, $eIcnMiner, $eIcnDonMiner, $eIcnNoShield, $eIcnDonCustomB, $eIcnAirdefense, $eIcnDarkBarrackBoost, _
			$eIcnDarkElixirStorage, $eIcnSpellsCost , $eIcnTroopsCost , $eIcnResetButton, $eIcnNewSmartZap, $eIcnTrain, $eIcnAttack, $eIcnDelay, $eIcnReOrder, _
			$eIcn2Arrow, $eIcnArrowLeft, $eIcnArrowRight, $eIcnAndroid, $eHdV04, $eHdV05, $eHdV06, $eHdV07, $eHdV08, $eHdV09, $eHdV10, _
			$eHdV11, $eUnranked, $eBronze, $eSilver, $eGold, $eCrystal, $eMaster, $eChampion, $eTitan, $eLegend, _
			$eWall04, $eWall05, $eWall06, $eWall07, $eWall08, $eWall09, $eWall10, $eWall11, $eIcnPBNotify, $eIcnCCTroops, _
			$eIcnCCSpells, $eIcnSpellsGroup, $eBahasaIND, $eChinese_S, $eChinese_T, $eEnglish, $eFrench, $eGerman, $eItalian, $ePersian, _
			$eRussian, $eSpanish, $eTurkish, $eMissingLangIcon, $eWall12, $ePortuguese, $eIcnDonPoisonSpell, $eIcnDonEarthQuakeSpell, $eIcnDonHasteSpell, $eIcnDonSkeletonSpell, $eVietnamese, $eKorean

Global $eIcnDonBlank = $eIcnDonBlacklist
Global $eIcnOptions = $eIcnDonBlacklist
Global $eIcnAchievements = $eIcnMain
Global $eIcnStrategies = $eIcnBlank

; Controls bot startup and ongoing operation
Global Const $g_iCollectAtCount = 10 ; Run Collect() after this amount of times before actually collect
Global Enum $eBotNoAction, $eBotStart, $eBotStop, $eBotSearchMode, $eBotClose
Global $g_iBotAction = $eBotNoAction
Global $g_bRestart = False
Global $g_bRunState = False
Global $g_bBtnAttackNowPressed = False ; Set to true if any of the 3 attack now buttons are pressed
Global $g_iCommandStop = -1
Global $g_bMeetCondStop = False
Global $g_bRestarted = ($g_bBotLaunchOption_Autostart ? True : False)
Global $g_bFirstStart = True
Global $g_iFirstRun = 1
Global $g_iFirstAttack = 0
Global $g_hTimerSinceStarted = 0 ; Time since bot was started
Global $g_iTimePassed = 0 ; Time since bot started, either with "Start Bot" button, or auto-start
Global $g_bBotPaused = False
Global $g_bTogglePauseUpdateState = False ; If True, TooglePauseUpdateState() call required and called in _Sleep()
Global $g_bTogglePauseAllowed = True ; If False, pause will not immediately happen but on next call to _Sleep when $g_bTogglePauseAllowed = True again
Global $g_bWaitShield = False
Global $g_bGForcePBTUpdate = False
Global $g_bQuicklyFirstStart = true
Global $g_bQuickAttack = False
Global $g_iTimeBeforeTrain = 0

 ; -1 = don't use red line, 0 = ImgLoc raw red line routine (default), 1 = New ImgLoc based deployable red line routine, 2 = Original red line routine
Global Const $REDLINE_IMGLOC_RAW = 0
Global Const $REDLINE_IMGLOC = 1
Global Const $REDLINE_ORIGINAL = 2
Global Const $REDLINE_NONE = 3

; 0 = Use fixed village corner (default), 1 = Find fist red line point, 2 = Fixed village corner on full drop line, 3 = First red line point on full drop line
Global Const $DROPLINE_EDGE_FIXED = 0
Global Const $DROPLINE_EDGE_FIRST = 1
Global Const $DROPLINE_FULL_EDGE_FIXED = 2
Global Const $DROPLINE_FULL_EDGE_FIRST = 3
Global Const $DROPLINE_DROPPOINTS_ONLY = 4

#Region Standard Enums and Consts - Attacks, Troops, Spells, Leagues, Loot Types
;--------------------------------------------------------------------------
; Standard Enums and Consts - Attacks, Troops, Spells, Leagues, Loot Types
;--------------------------------------------------------------------------
; Complete list of all deployable/trainable objects
Global Enum $eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, _
	$eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eBowl, $eKing, $eQueen, $eWarden, $eCastle, _
	$eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell

; Attack types
Global Enum $DB, $LB, $TS, $MA, $TB, $DT ; DeadBase, ActiveBase, TownhallSnipe, Milking Attack, TownhallBully, DropTrophy
Global Const $g_iModeCount = 3
Global $g_iMatchMode = 0 ; 0 Dead / 1 Live / 2 TH Snipe / 3 Milking Attack / 4 TH Bully / 5 Drop Trophy
Global Const $g_asModeText[6] = ["Dead Base", "Live Base", "TH Snipe", "Milking Attack", "TH Bully", "Drop Trophy"]

; Troops
Global Enum $eTroopBarbarian, $eTroopArcher, $eTroopGiant, $eTroopGoblin, $eTroopWallBreaker, $eTroopBalloon, _
			$eTroopWizard, $eTroopHealer, $eTroopDragon, $eTroopPekka, $eTroopBabyDragon, $eTroopMiner, _
			$eTroopMinion, $eTroopHogRider, $eTroopValkyrie, $eTroopGolem, $eTroopWitch, _
			$eTroopLavaHound, $eTroopBowler, $eTroopCount
Global Const $g_asTroopNames[$eTroopCount] = [ _
   "Barbarian", "Archer", "Giant", "Goblin", "Wall Breaker", "Balloon", "Wizard", "Healer", "Dragon", "Pekka", "Baby Dragon", "Miner", _
   "Minion", "Hog Rider", "Valkyrie", "Golem", "Witch", "Lava Hound", "Bowler"]
Global Const $g_asTroopNamesPlural[$eTroopCount] = [ _
   "Barbarians", "Archers", "Giants", "Goblins", "Wall Breakers", "Balloons", "Wizards", "Healers", "Dragons", "Pekkas", "Baby Dragons", "Miners", _
   "Minions", "Hog Riders", "Valkyries", "Golems", "Witches", "Lava Hounds", "Bowlers"]
Global Const $g_asTroopShortNames[$eTroopCount] = [ _
   "Barb", "Arch", "Giant", "Gobl", "Wall", "Ball", "Wiza", "Heal", "Drag", "Pekk", "BabyD", "Mine", _
   "Mini", "Hogs", "Valk", "Gole", "Witc", "Lava", "Bowl"]
Global Const $g_aiTroopSpace[$eTroopCount] = [ _
   1, 1, 5, 1, 2, 5, 4, 14, 20, 25, 10, 5, _
   2, 5, 8, 30, 12, 30, 6 ]
Global Const $g_aiTroopTrainTime[$eTroopCount] = [ _
   20, 24, 120, 28, 60, 120, 120, 480, 720, 720, 360, 120, _
   36, 90, 180, 600, 360, 600, 120 ]
; Zero element contains number of levels, elements 1 thru n contain cost of that level troop
Global Const $g_aiTroopCostPerLevel[$eTroopCount][9] = [ _
   [7, 25, 40, 60, 100, 150, 200, 250], _ 				; Archer
   [7, 50, 80, 120, 200, 300, 400, 500], _ 				;Barbarian
   [8, 250, 750, 1250, 1750, 2250, 3000, 3500, 4000], _ ; Giant
   [7, 25, 40, 60, 80, 100, 150, 200], _ 				; Goblin
   [6, 1000, 1500, 2000, 2500, 3000, 3500], _ 			; WallBreaker
   [7, 2000, 2500, 3000, 3500, 4000, 4500, 5000], _ 	; Balloon
   [7, 1500, 2000, 2500, 3000, 3500, 4000, 4500], _ 	; Wizard
   [4, 5000, 6000, 8000, 10000], _						 ;Healer
   [6, 25000, 29000, 33000, 37000, 42000, 46000], _ 	; Dragon
   [5, 28000, 32000, 36000, 40000, 45000], _ 			; Pekka
   [5, 15000, 16000, 17000, 18000, 19000], _ 			; BabyDragon
   [4, 4200, 4800, 5400, 6000], _  						; Miner
   [7, 6, 7, 8, 9, 10, 11, 12], _ 						; Minion
   [7, 40, 45, 52, 58, 65, 90, 115], _					; HogRider
   [5, 70, 100, 130, 160, 190], _ 						;Valkyrie
   [6, 450, 525, 600, 675, 750, 825], _ 				; Golem
   [3, 250, 350, 450], _ 								; Witch
   [4, 390, 450, 510, 570], _  							;Lavahound
   [3, 130, 150, 170] ] 								; Bowler
Global Const $g_aiTroopDonateXP[$eTroopCount] = [1,1,5,1,2,5,4,14,20,25,10,5,2,5,8,30,12,30,6]

; Spells
Global Enum $eSpellLightning, $eSpellHeal, $eSpellRage, $eSpellJump, $eSpellFreeze, $eSpellClone, _
			$eSpellPoison, $eSpellEarthquake, $eSpellHaste, $eSpellSkeleton, $eSpellCount
Global Const $g_asSpellNames[$eSpellCount] = ["Lightning", "Heal", "Rage", "Jump", "Freeze", "Clone", "Poison", "Earthquake", "Haste", "Skeleton"]
Global Const $g_asSpellShortNames[$eSpellCount] = ["LSpell", "HSpell", "RSpell", "JSpell", "FSpell", "CSpell", "PSpell", "ESpell", "HaSpell", "SkSpell"]
Global Const $g_aiSpellSpace[$eSpellCount] = [ 2, 2, 2, 2, 2, 4, 1, 1, 1, 1 ]
Global Const $g_aiSpellTrainTime[$eSpellCount] = [ 360, 360, 360, 360, 360, 720, 180, 180, 180, 180 ]
; Zero element contains number of levels, elements 1 thru n contain cost of that level spell
Global Const $g_aiSpellCostPerLevel[$eSpellCount][8] = [ _
   [7, 15000, 16500, 18000, 20000, 22000, 24000, 26000], _ ;LightningSpell
   [6, 15000, 16500, 18000, 20000, 22000, 24000], _ 	   ;HealSpell
   [5, 23000, 25000, 27000, 30000, 33000], _     		   ;RageSpell
   [3, 23000, 27000, 31000], _        					   ;JumpSpell
   [5, 26000, 29000, 31000, 33000, 35000], _               ;FreezeSpell
   [4, 38000, 40000, 42000, 44000], _					   ;CloneSpell
   [5, 95, 110, 125, 140, 155], _         				   ;PoisonSpell
   [4, 125, 140, 160, 180], _    						   ;EarthquakeSpell
   [4, 80, 85, 60, 95], _								   ;HasteSpell
   [4, 110, 120, 130, 140] ]   							   ;SkeletonSpell
Global Const $g_aiSpellDonateXP[$eSpellCount] = [10, 10, 10, 10, 10, 0, 5, 5, 5, 5]

; Hero Bitmaped Values
Global Enum $eHeroNone=0, $eHeroKing=1, $eHeroQueen=2, $eHeroWarden=4

; Hero standard values
Global Enum $eHeroBarbarianKing, $eHeroArcherQueen, $eHeroGrandWarden, $eHeroCount
Global Const $g_asHeroNames[$eHeroCount] = ["Barbarian King", "Archer Queen", "Grand Warden"]
Global Const $g_asHeroShortNames[$eHeroCount] = ["King", "Queen", "Warden"]

; Leagues
Global Enum $eLeagueUnranked, $eLeagueBronze, $eLeagueSilver, $eLeagueGold, $eLeagueCrystal, $eLeagueMaster, $eLeagueChampion, $eLeagueTitan, $eLeagueLegend, $eLeagueCount

; Loot types
Global Enum $eLootGold, $eLootElixir, $eLootDarkElixir, $eLootTrophy, $eLootCount

;--------------------------------------------------------------------------
; END: Attacks, Troops, Spells, Leagues, Loot Types
;--------------------------------------------------------------------------

;--------------------------------------------------------------------------
; This function takes a troop,spell,hero, or castle name string, such as provided by MyBotRunImgLoc.dll, and returns the Enum integer troop/spell index,
; based on the "Global Enum $eBarb, $eArch ... $eHaSpell, $eSkSpell" declaration of the complete list of deployable/trainable objects.
; This is an alternative to using dynamic variable evaluation (i.e. the "Eval" keyword).
; The return value will be from $eBarb to $eSkSpell if a valid $sName is passed in.
; The return value will be -1 if an invalid $sname is passed in.
;--------------------------------------------------------------------------
Func TroopIndexLookup(Const $sName)
   ; is the name a elixir or dark elixir troop?
   For $i = 0 To UBound($g_asTroopShortNames) - 1
	  If $sName = $g_asTroopShortNames[$i] Then
		 Return $i
	  EndIf
   Next

   ; is the name a spell?
   For $i = 0 To UBound($g_asSpellShortNames) - 1
	  If $sName = $g_asSpellShortNames[$i] Then
		 Return $i + $eLSpell
	  EndIf
   Next

   ; is the name a hero?
   For $i = 0 To UBound($g_asHeroShortNames) - 1
	  If $sName = $g_asHeroShortNames[$i] Then
		 Return $i + $eKing
	  EndIf
   Next

   ; is the name "castle"?
   If $sName = "castle" Then Return $eCastle

   SetDebugLog("TroopIndexLookup() Error: Index for troop name '" & $sName & "' not found.")
   Return -1
EndFunc
;--------------------------------------------------------------------------
; END: TroopIndexLookup()
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
; This function takes a troop,spell,hero, or castle index, based on the "Global Enum $eBarb, $eArch ... $eHaSpell, $eSkSpell" declaration,
; and returns the full name.
;--------------------------------------------------------------------------
Func GetTroopName(Const $iIndex)
   If $iIndex >= $eBarb And $iIndex <= $eBowl Then
	  Return $g_asTroopNames[$iIndex]
   ElseIf $iIndex >= $eLSpell And $iIndex <= $eSkSpell Then
	  Return $g_asSpellNames[$iIndex - $eLSpell]
   ElseIf $iIndex >= $eKing And $iIndex <= $eWarden Then
	  Return $g_asHeroNames[$iIndex - $eKing]
   ElseIf $iIndex = $eCastle Then
	  Return "Clan Castle"
   EndIf
EndFunc
;--------------------------------------------------------------------------
; END: GetTroopName()
;--------------------------------------------------------------------------

#EndRegion

#Region GUI Variables
;--------------------------------------------------------------------------
; Variables to hold current GUI setting values
;--------------------------------------------------------------------------
; <><><><> Log window <><><><>
Global $g_iLogDividerY = 385
Global Const $g_iLogDividerHeight = 4
Global $g_iCmbLogDividerOption = 0

; <><><><> Bottom panel <><><><>
Global $g_bChkBackgroundMode ; Background mode enabled/disabled
Global $g_bMakeScreenshotNow = False ; Used to create Screenshot in _Sleep if Screenshot Button got pressed

; <><><><> Village / Misc <><><><>
Global $g_bChkBotStop = False, $g_iCmbBotCommand = 0, $g_iCmbBotCond = 0, $g_iCmbHoursStop = 0
Global $g_iTxtRestartGold = 10000
Global $g_iTxtRestartElixir = 25000
Global $g_iTxtRestartDark = 500
Global $g_bChkTrap = False, $g_bChkCollect = False, $g_bChkTombstones = False, $g_bChkCleanYard = False, $g_bChkGemsBox = False

; <><><><> Village / Donate - Request <><><><>
Global $g_bRequestTroopsEnable = False
Global $g_sRequestTroopsText = ""
Global $g_abRequestCCHours[24] = [False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False]

; <><><><> Village / Donate - Donate <><><><>
Global $g_bChkDonate  = True
Global Enum $eCustomA = $eTroopCount, $eCustomB = $eTroopCount+1
Global Const $g_iCustomDonateConfigs = 2
Global $g_abChkDonateTroop[$eTroopCount+$g_iCustomDonateConfigs] = [False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False]
Global $g_abChkDonateAllTroop[$eTroopCount+$g_iCustomDonateConfigs] = [False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False]
Global $g_asTxtDonateTroop[$eTroopCount+$g_iCustomDonateConfigs] = ["","","","","","","","","","","","","","","","","","","","",""] ; array of pipe-delimited list of strings to match to a request string
Global $g_asTxtBlacklistTroop[$eTroopCount+$g_iCustomDonateConfigs] = ["","","","","","","","","","","","","","","","","","","","",""] ; array of pipe-delimited list of strings to prevent a match to a request string

Global $g_abChkDonateSpell[$eSpellCount] = [False,False,False,False,False,False,False,False,False,False] ; element $eSpellClone (5) is unused
Global $g_abChkDonateAllSpell[$eSpellCount] = [False,False,False,False,False,False,False,False,False,False] ; element $eSpellClone (5) is unused
Global $g_asTxtDonateSpell[$eSpellCount] = ["","","","","","","","","",""] ; element $eSpellClone (5) is unused
Global $g_asTxtBlacklistSpell[$eSpellCount] = ["","","","","","","","","",""] ; element $eSpellClone (5) is unused

Global $g_aiDonateCustomTrpNumA[3][2] = [[0,0], [0,0], [0,0]], $g_aiDonateCustomTrpNumB[3][2] = [[0,0], [0,0], [0,0]]

Global $g_bChkExtraAlphabets = False ; extra alphabets
Global $g_bChkExtraChinese = False ; extra Chinese alphabets
Global $g_bChkExtraKorean = False ; extra Korean alphabets
Global $g_sTxtGeneralBlacklist = ""

; <><><><> Village / Donate - Schedule <><><><>
Global $g_bDonateHoursEnable = False
Global $g_abDonateHours[24] = [False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False]
Global $g_iCmbDonateFilter = 0 ; 0 no filter, 1 capture only images, 2 white list, 3 black list
Global $g_bDonateSkipNearFullEnable = 1
Global $g_iDonateSkipNearFullPercent = 90

; <><><><> Village / Upgrade <><><><>
; Lab
Global $g_bAutoLabUpgradeEnable = False, $g_iCmbLaboratory = 0
; Heroes
Global $g_bUpgradeKingEnable = False, $g_bUpgradeQueenEnable = False, $g_bUpgradeWardenEnable = False
;Buildings
Global Const $g_iUpgradeSlots = 14
Global $g_aiPicUpgradeStatus[$g_iUpgradeSlots] = [$eIcnTroops,$eIcnTroops,$eIcnTroops,$eIcnTroops,$eIcnTroops,$eIcnTroops,$eIcnTroops, _
												  $eIcnTroops,$eIcnTroops,$eIcnTroops,$eIcnTroops,$eIcnTroops,$eIcnTroops,$eIcnTroops]
Global $g_abBuildingUpgradeEnable[$g_iUpgradeSlots] = [False,False,False,False,False,False,False,False,False,False,False,False,False,False]
Global $g_avBuildingUpgrades[$g_iUpgradeSlots][8] ; Fill empty array [8] to store upgrade data
For $i = 0 To $g_iUpgradeSlots - 1
	$g_avBuildingUpgrades[$i][0] = -1  ; position x
	$g_avBuildingUpgrades[$i][1] = -1  ; position y
	$g_avBuildingUpgrades[$i][2] = -1  ; upgrade value
	$g_avBuildingUpgrades[$i][3] = ""  ; string loot type required
	$g_avBuildingUpgrades[$i][4] = ""  ; string Bldg Name
	$g_avBuildingUpgrades[$i][5] = ""  ; string Bldg level
	$g_avBuildingUpgrades[$i][6] = ""  ; string upgrade time
	$g_avBuildingUpgrades[$i][7] = ""  ; string upgrade end date/time (_datediff compatible)
Next
Global $g_iUpgradeMinGold = 100000, $g_iUpgradeMinElixir = 100000, $g_iUpgradeMinDark = 3000
Global $g_abUpgradeRepeatEnable[$g_iUpgradeSlots] = [False,False,False,False,False,False,False,False,False,False,False,False,False,False]
; Walls
Global $g_bAutoUpgradeWallsEnable = 0
Global $g_iUpgradeWallMinGold = 0, $g_iUpgradeWallMinElixir = 0
Global $g_iUpgradeWallLootType = 0, $g_bUpgradeWallSaveBuilder = False
Global $g_iCmbUpgradeWallsLevel = 6
Global $g_aiWallsCurrentCount[13] = [-1,-1,-1,-1,0,0,0,0,0,0,0,0,0] ; elements 0 to 3 are not referenced

; <><><><> Village / Achievements <><><><>
Global $g_iUnbrkMode = 0, $g_iUnbrkWait = 5
Global $g_iUnbrkMinGold = 50000, $g_iUnbrkMinElixir = 50000, $g_iUnbrkMaxGold = 600000, $g_iUnbrkMaxElixir = 600000, $g_iUnbrkMinDark = 5000, $g_iUnbrkMaxDark = 6000

; <><><><> Village / Notify <><><><>
;PushBullet
Global $g_bNotifyPBEnable = False, $g_sNotifyPBToken = ""
;Telegram
Global $g_bNotifyTGEnable = False, $g_sNotifyTGToken = ""
;Remote Control
Global $g_bNotifyRemoteEnable = False, $g_sNotifyOrigin = "", $g_bNotifyDeleteAllPushesOnStart = False, $g_bNotifyDeletePushesOlderThan = False, $g_iNotifyDeletePushesOlderThanHours = 4
;Alerts
Global $g_bNotifyAlertMatchFound = False, $g_bNotifyAlerLastRaidIMG = False, $g_bNotifyAlerLastRaidTXT = False, $g_bNotifyAlertCampFull = False, _
	   $g_bNotifyAlertUpgradeWalls = False, $g_bNotifyAlertOutOfSync = False, $g_bNotifyAlertTakeBreak = False, $g_bNotifyAlertBulderIdle = False, _
	   $g_bNotifyAlertVillageReport = False, $g_bNotifyAlertLastAttack = False, $g_bNotifyAlertAnotherDevice = False, $g_bNotifyAlertMaintenance = False, _
	   $g_bNotifyAlertBAN = False, $g_bNotifyAlertBOTUpdate = False
;Schedule
Global $g_bNotifyScheduleHoursEnable = False, $g_bNotifyScheduleWeekDaysEnable = False
Global $g_abNotifyScheduleHours[24] = [False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False]
Global $g_abNotifyScheduleWeekDays[7] = [False,False,False,False,False,False,False]

; <><><><> Attack Plan / Train Army / Troops/Spells <><><><>
Global $g_bQuickTrainEnable = False
Global $g_iQuickTrainArmyNum = 1
Global $g_aiArmyCompTroops[$eTroopCount] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_aiArmyCompSpells[$eSpellCount] = [0,0,0,0,0,0,0,0,0,0]
Global $g_aiTrainArmyTroopLevel[$eTroopCount] = [1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_aiTrainArmySpellLevel[$eSpellCount] = [0,0,0,0,0,0,0,0,0,0]
Global $g_iTrainArmyFullTroopPct = 100
Global $g_bTotalCampForced = False, $g_iTotalCampForcedValue = 200
Global $g_bForceBrewSpells = False
Global $g_iTotalSpellValue = 0

; <><><><> Attack Plan / Train Army / Boost <><><><>
Global $g_iCmbBoostBarracks = 0, $g_iCmbBoostSpellFactory = 0, $g_iCmbBoostBarbarianKing = 0, $g_iCmbBoostArcherQueen = 0, $g_iCmbBoostWarden = 0
Global $g_abBoostBarracksHours[24] = [True,True,True,True,True,True,True,True,True,True,True,True,True,True,True,True,True,True,True,True,True,True,True,True]

; <><><><> Attack Plan / Train Army / Train Order <><><><>
Global Const $g_aiTroopOrderIcon[21] = [ _
   $eIcnOptions, $eIcnBarbarian, $eIcnArcher, $eIcnGiant, $eIcnGoblin, $eIcnWallBreaker, $eIcnBalloon, _
   $eIcnWizard, $eIcnHealer, $eIcnDragon, $eIcnPekka, $eIcnBabyDragon, $eIcnMiner, $eIcnMinion, _
   $eIcnHogRider, $eIcnValkyrie, $eIcnGolem, $eIcnWitch, $eIcnLavaHound, $eIcnBowler]
Global $g_bCustomTrainOrderEnable = False, $g_aiCmbCustomTrainOrder[$eTroopCount] = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]

#cs
Global Const $g_aiTrainOrderDefault[] = [ _
   $eTroopArcher, $eTroopGiant, $eTroopWallBreaker, $eTroopBarbarian, $eTroopGoblin, $eTroopHealer, _
   $eTroopPekka, $eTroopBalloon, $eTroopWizard, $eTroopDragon, $eTroopBabyDragon, $eTroopMiner, _
   $eTroopMinion, $eTroopHogRider, $eTroopValkyrie, $eTroopGolem, $eTroopWitch, $eTroopLavaHound, _
   $eTroopBowler ]
#ce

Global $g_aiTrainOrder[$eTroopCount] = [ _
   $eTroopArcher, $eTroopGiant, $eTroopWallBreaker, $eTroopBarbarian, $eTroopGoblin, $eTroopHealer, _
   $eTroopPekka, $eTroopBalloon, $eTroopWizard, $eTroopDragon, $eTroopBabyDragon, $eTroopMiner, _
   $eTroopMinion, $eTroopHogRider, $eTroopValkyrie, $eTroopGolem, $eTroopWitch, $eTroopLavaHound, _
   $eTroopBowler ]

; <><><><> Attack Plan / Train Army / Options <><><><>
Global $g_bCloseWhileTrainingEnable = True, $g_bCloseWithoutShield = False, $g_bCloseEmulator = False, $g_bCloseRandom = False, $g_bCloseExactTime = False, _
	   $g_bCloseRandomTime = True, $g_iCloseRandomTimePercent = 10, $g_iCloseMinimumTime = 2
Global $g_iTrainClickDelay = 40
Global $g_bTrainAddRandomDelayEnable = False, $g_iTrainAddRandomDelayMin = 5, $g_iTrainAddRandomDelayMax = 60

; <><><><> Attack Plan / Search & Attack / {Common Across DeadBase, ActiveBase, TH Snipe, Bully} <><><><>
Global $g_abAttackTypeEnable[$g_iModeCount + 3] = [True, False, False, -1, False, -1]; $DB, $LB, $TS, $MA, $TB, $DT - $MA and $DT unused here
; Search - Start Search If
Global $g_abSearchSearchesEnable[$g_iModeCount] = [True,False,False], $g_aiSearchSearchesMin[$g_iModeCount] = [0,0,0], $g_aiSearchSearchesMax[$g_iModeCount] = [0,0,0]  ; Search count limit
Global $g_abSearchTropiesEnable[$g_iModeCount] = [False,False,False], $g_aiSearchTrophiesMin[$g_iModeCount] = [0,0,0], $g_aiSearchTrophiesMax[$g_iModeCount] = [0,0,0]  ; Trophy limit
Global $g_abSearchCampsEnable[$g_iModeCount] = [False,False,False], $g_aiSearchCampsPct[$g_iModeCount] = [0,0,0]  ; Camp limit
Global $g_aiSearchHeroWaitEnable[$g_iModeCount] = [0,0,0] ; Heroes wait status for attack; these are 3 bools (one for each hero) bitmapped onto an integer
Global $g_abSearchSpellsWaitEnable[$g_iModeCount] = [False,False,False]
Global $g_abSearchCastleSpellsWaitEnable[$g_iModeCount] = [False,False,False], $g_aiSearchCastleSpellsWaitRegular[$g_iModeCount] = [0,0,0], _
	   $g_aiSearchCastleSpellsWaitDark[$g_iModeCount] = [0,0,0]
Global $g_abSearchCastleTroopsWaitEnable[$g_iModeCount] = [False,False,False]
; Search - Filters
Global $g_aiFilterMeetGE[$g_iModeCount] = [0,0,0], $g_aiFilterMinGold[$g_iModeCount] = [0,0,0], $g_aiFilterMinElixir[$g_iModeCount] = [0,0,0], _
	   $g_aiFilterMinGoldPlusElixir[$g_iModeCount] = [0,0,0]
Global $g_abFilterMeetDEEnable[$g_iModeCount] = [False,False,False], $g_aiFilterMeetDEMin[$g_iModeCount] = [0,0,0]
Global $g_abFilterMeetTrophyEnable[$g_iModeCount] = [False,False,False], $g_aiFilterMeetTrophyMin[$g_iModeCount] = [0,0,0]
Global $g_abFilterMeetTH[$g_iModeCount] = [False,False,False], $g_aiFilterMeetTHMin[$g_iModeCount] = [0,0,0]
Global $g_abFilterMeetTHOutsideEnable[$g_iModeCount] = [False,False,False]
Global $g_abFilterMaxMortarEnable[$g_iModeCount] = [False,False,False], $g_abFilterMaxWizTowerEnable[$g_iModeCount] = [False,False,False], _
	   $g_abFilterMaxAirDefenseEnable[$g_iModeCount] = [False,False,False], $g_abFilterMaxXBowEnable[$g_iModeCount] = [False,False,False], _
	   $g_abFilterMaxInfernoEnable[$g_iModeCount] = [False,False,False], $g_abFilterMaxEagleEnable[$g_iModeCount] = [False,False,False]
Global $g_aiFilterMaxMortarLevel[$g_iModeCount] = [5,5,0], $g_aiFilterMaxWizTowerLevel[$g_iModeCount] = [4,4,0], $g_aiFilterMaxAirDefenseLevel[$g_iModeCount] = [0,0,0], _
	   $g_aiFilterMaxXBowLevel[$g_iModeCount] = [0,0,0], $g_aiFilterMaxInfernoLevel[$g_iModeCount] = [0,0,0], $g_aiFilterMaxEagleLevel[$g_iModeCount] = [0,0,0]
Global $g_abFilterMeetOneConditionEnable[$g_iModeCount] = [False,False,False]
; Attack
Global $g_aiAttackAlgorithm[$g_iModeCount] = [0,0,0], $g_aiAttackTroopSelection[$g_iModeCount+3] = [0,0,0,0,0,0], $g_aiAttackUseHeroes[$g_iModeCount] = [0,0,0], _
	   $g_abAttackDropCC[$g_iModeCount] = [0,0,0]
Global $g_abAttackUseLightSpell[$g_iModeCount] = [0,0,0], $g_abAttackUseHealSpell[$g_iModeCount] = [0,0,0], $g_abAttackUseRageSpell[$g_iModeCount] = [0,0,0], _
	   $g_abAttackUseJumpSpell[$g_iModeCount] = [0,0,0], $g_abAttackUseFreezeSpell[$g_iModeCount] = [0,0,0], $g_abAttackUseCloneSpell[$g_iModeCount] = [0,0,0], _
	   $g_abAttackUsePoisonSpell[$g_iModeCount] = [0,0,0], $g_abAttackUseEarthquakeSpell[$g_iModeCount] = [0,0,0], $g_abAttackUseHasteSpell[$g_iModeCount] = [0,0,0], _
	   $g_abAttackUseSkeletonSpell[$g_iModeCount] = [0,0,0]
Global $g_bTHSnipeBeforeEnable[$g_iModeCount] = [False,False,False], $g_iTHSnipeBeforeTiles[$g_iModeCount] = [0,0,0], $g_iTHSnipeBeforeScript[$g_iModeCount] = [0,0,0]
; Attack - Standard
Global $g_aiAttackStdDropOrder[$g_iModeCount+1] = [0,0,0,0], $g_aiAttackStdDropSides[$g_iModeCount+1] = [3,3,0,1], $g_aiAttackStdUnitDelay[$g_iModeCount+1] = [4,4,0,4], _
	   $g_aiAttackStdWaveDelay[$g_iModeCount+1] = [4,4,0,4], $g_abAttackStdRandomizeDelay[$g_iModeCount+1] = [True,True,False,True], _
	   $g_abAttackStdSmartAttack[$g_iModeCount+3] = [True,True,False,True,False,False], $g_aiAttackStdSmartDeploy[$g_iModeCount+3] = [0,0,0,0,0,0]
Global $g_abAttackStdSmartNearCollectors[$g_iModeCount+3][3] = [ [False,False,False], [False,False,False], [False,False,False], _
															     [False,False,False], [False,False,False], [False,False,False] ]
; Attack - Scripted
Global $g_aiAttackScrRedlineRoutine[$g_iModeCount+3] = [$REDLINE_IMGLOC_RAW, $REDLINE_IMGLOC_RAW, 0, 0, 0, 0]
Global $g_aiAttackScrDroplineEdge[$g_iModeCount+3] = [$DROPLINE_EDGE_FIRST, $DROPLINE_EDGE_FIRST, 0, 0, 0, 0]
Global $g_sAttackScrScriptName[$g_iModeCount] = ["Barch four fingers", "Barch four fingers", ""]

; End Battle
Global $g_abStopAtkNoLoot1Enable[$g_iModeCount] = [True,True,False], $g_aiStopAtkNoLoot1Time[$g_iModeCount] = [0,0,0], _
	   $g_abStopAtkNoLoot2Enable[$g_iModeCount] = [False,False,False], $g_aiStopAtkNoLoot2Time[$g_iModeCount] = [0,0,0]
Global $g_aiStopAtkNoLoot2MinGold[$g_iModeCount] = [0,0,0], $g_aiStopAtkNoLoot2MinElixir[$g_iModeCount] = [0,0,0], $g_aiStopAtkNoLoot2MinDark[$g_iModeCount] = [0,0,0]
Global $g_abStopAtkNoResources[$g_iModeCount] = [False,False,False], $g_abStopAtkOneStar[$g_iModeCount] = [False,False,False], $g_abStopAtkTwoStars[$g_iModeCount] = [False,False,False]
Global $g_abStopAtkPctHigherEnable[$g_iModeCount] = [False,False,False], $g_aiStopAtkPctHigherAmt[$g_iModeCount] = [0,0,0]
Global $g_abStopAtkPctNoChangeEnable[$g_iModeCount] = [False,False,False], $g_aiStopAtkPctNoChangeTime[$g_iModeCount] = [0,0,0]

; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Standard <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Scripted <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Milking <><><><>
Global $g_iMilkAttackType=1, $g_aiMilkFarmElixirParam[9] = [-1,-1,-1,-1,-1,-1,2,2,2]
Global $g_bMilkFarmLocateElixir = True, $g_bMilkFarmLocateMine = True, $g_bMilkFarmLocateDrill = True
Global $g_iMilkFarmMineParam = 5 ;values 0-8 (0=mines level 1-4  ; 1= mines level 5; ... ; 8=mines level 12)
Global $g_iMilkFarmDrillParam = 1 ;values 1-6 (1=drill level 1 ... 6=drill level 6)
Global $g_iMilkFarmResMaxTilesFromBorder = 0, $g_bMilkFarmAttackGoldMines = True, $g_bMilkFarmAttackElixirExtractors = True, $g_bMilkFarmAttackDarkDrills = True, _
	   $g_iMilkFarmLimitGold = 9995000, $g_iMilkFarmLimitElixir = 9995000, $g_iMilkFarmLimitDark = 200000
Global $g_iMilkFarmTroopForWaveMin = 4, $g_iMilkFarmTroopForWaveMax = 6, $g_iMilkFarmTroopMaxWaves = 3, $g_iMilkFarmDelayFromWavesMin = 3000, $g_iMilkFarmDelayFromWavesMax = 5000
Global $g_iMilkingAttackDropGoblinAlgorithm = 1 ; 0= drop each goblin in different point, 1= drop all goblins in a point
Global $g_iMilkingAttackStructureOrder = 1, $g_bMilkingAttackCheckStructureDestroyedBeforeAttack = False, $g_bMilkingAttackCheckStructureDestroyedAfterAttack = False
Global $g_bMilkAttackAfterTHSnipeEnable = False, $g_iMilkFarmTHMaxTilesFromBorder = 1, $g_sMilkFarmAlgorithmTh = "Queen&GobTakeTH", $g_bMilkFarmSnipeEvenIfNoExtractorsFound = False, _
	   $g_bMilkAttackAfterScriptedAtkEnable = False, $g_sMilkAttackCSVscript = "Barch four fingers"
Global $g_bMilkFarmForceToleranceEnable = False, $g_iMilkFarmForceToleranceNormal = 31, $g_iMilkFarmForceToleranceBoosted = 31, $g_iMilkFarmForceToleranceDestroyed = 31

; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
Global $g_abCollectorLevelEnabled[13] = [-1, -1, -1, -1, -1, -1, True, True, True, True, True, True, True] ; elements 0 thru 5 are never referenced
Global $g_aiCollectorLevelFill[13] = [-1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1] ; elements 0 thru 5 are never referenced
Global $g_bCollectorFilterDisable = False
Global $g_iCollectorMatchesMin = 3
Global $g_iCollectorToleranceOffset = 0

; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Standard <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Scripted <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
Global $g_bDESideEndEnable = False, $g_iDESideEndMin = 25, $g_bDESideDisableOther = False, $g_bDESideEndAQWeak = False, $g_bDESideEndBKWeak = False, $g_bDESideEndOneStar = False

; <><><><> Attack Plan / Search & Attack / TH Snipe / Search <><><><>
Global $g_iAtkTSAddTilesWhileTrain = 1, $g_iAtkTSAddTilesFullTroops = 0

; <><><><> Attack Plan / Search & Attack / TH Snipe / Attack <><><><>
Global $g_sAtkTSType = "Bam"

; <><><><> Attack Plan / Search & Attack / TH Snipe / End Battle <><><><>
Global $g_bEndTSCampsEnable = False, $g_iEndTSCampsPct = 0

; <><><><> Attack Plan / Search & Attack / Bully <><><><>
Global $g_iAtkTBEnableCount = 150, $g_iAtkTBMaxTHLevel = 0, $g_iAtkTBMode = 0

; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
Global $g_bSearchReductionEnable = False, $g_iSearchReductionCount = 20, $g_iSearchReductionGold = 2000, $g_iSearchReductionElixir = 2000, $g_iSearchReductionGoldPlusElixir = 4000, _
	   $g_iSearchReductionDark = 100, $g_iSearchReductionTrophy = 2
Global $g_iSearchDelayMin = 0, $g_iSearchDelayMax = 0
Global $g_bSearchAttackNowEnable = False, $g_iSearchAttackNowDelay = 0, $g_bSearchRestartEnable = False, $g_iSearchRestartLimit = 25, $g_bSearchAlertMe = True

; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
Global $iActivateKQCondition = 0, $iActivateWardenCondition = 0, $delayActivateKQ = 0, $delayActivateW = 0
Global $ichkAttackPlannerEnable = 0, $ichkAttackPlannerCloseCoC = 0, $ichkAttackPlannerCloseAll = 0, $ichkAttackPlannerRandom = 0, $icmbAttackPlannerRandom = 0, _
	   $ichkAttackPlannerDayLimit = 0, $icmbAttackPlannerDayMin = 12, $icmbAttackPlannerDayMax = 15
Global $iPlannedAttackWeekDays[7] = [1,1,1,1,1,1,1], $iPlannedattackHours[24] = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
Global $iPlannedDropCCHoursEnable = 0, $iChkUseCCBalanced = 0, $iCmbCCDonated = 0, $iCmbCCReceived = 0
Global $iPlannedDropCCHours[24] = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]

; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
Global $ichkSmartZap = 0, $ichkEarthQuakeZap = 0, $ichkNoobZap = 0, $ichkSmartZapDB = 1, $ichkSmartZapSaveHeroes = 1, _
	   $itxtMinDE = 350, $itxtExpectedDE = 320, $DebugSmartZap = 0

; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
Global $iShareAttack = 0, $iShareminGold = 300000, $iShareminElixir = 300000, $iSharemindark = 0, $sShareMessage = StringReplace("Nice|Good|Thanks|Wowwww", "|", @CRLF), _
	   $TakeLootSnapShot = True, $ScreenshotLootInfo = False, $iShareAttackNow = 0

; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
Global $iChkTrophyRange = 0, $itxtMaxTrophy = 1200, $itxtdropTrophy = 800, $iChkTrophyHeroes = 0, $iCmbTrophyHeroesPriority = 0, _
	   $iChkTrophyAtkDead = 0, $itxtDTArmyMin = 70

; <><><><> Attack Plan / Strategies <><><><>
; <<< nothing here >>>

; <><><><> Bot / Options <><><><>
Global $sLanguage = "English"
Global $ichkDisableSplash = 0 ; Splash screen disabled = 1
Global $ichkVersion = 1
Global $ichkDeleteLogs = 1, $iDeleteLogsDays = 2, $ichkDeleteTemp = 1, $iDeleteTempDays = 2, $ichkDeleteLoots = 1, $iDeleteLootsDays = 2
Global $ichkAutoStart, $ichkAutoStartDelay = 10
Global $ichklanguage = 1
Global $idisposewindows = 1, $icmbDisposeWindowsPos = 0, $iWAOffsetX = 10, $iWAOffsetY = 10
Global $iUpdatingWhenMinimized = 1 ; Alternative Minimize Window routine for bot that enables window updates when minimized
Global $iHideWhenMinimized = 0 ; Hide bot window in taskbar when minimized
Global $iUseRandomClick = 0
Global $iScreenshotType = 0, $ichkScreenshotHideName = 1
Global $sTimeWakeUp = 120
Global $ichkSinglePBTForced = 0, $iValueSinglePBTimeForced = 18, $iValuePBTimeForcedExit = 15
Global $iChkAutoResume = 0, $iAutoResumeTime = 5
Global $ichkFixClanCastle = 0

; <><><><> Bot / Android <><><><>
; <<< nothing here >>>

; <><><><> Bot / Debug <><><><>
; <<< nothing here >>>

; <><><><> Bot / Profiles <><><><>
; <<< nothing here >>>

; <><><><> Bot / Stats <><><><>
; <<< nothing here >>>

;--------------------------------------------------------------------------
; END: Variables to hold current GUI setting values
;--------------------------------------------------------------------------
#EndRegion

; Android & MBR window
Global $frmBotPosX = -1 ; Position X of the GUI
Global $frmBotPosY = -1 ; Position Y of the GUI
Global $AndroidPosX = -1 ; Position X of the Android Window (undocked)
Global $AndroidPosY = -1 ; Position Y of the Android Window (undocked)
Global $frmBotDockedPosX = -1 ; Position X of the docked GUI
Global $frmBotDockedPosY = -1 ; Position Y of the docked GUI
Global $frmBotAddH = 0; Additional Height of GUI (e.g. when Android docked)
Global $Hide = False ; If hidden or not
Global $g_aiBSpos[2] ; Inside Android window positions relative to the screen, [x,y]
Global $g_aiBSrpos[2] ; Inside Android window positions relative to the window, [x,y]
Global $GUIControl_Disabled = False

; Languages
Global Const $dirLanguages = @ScriptDir & "\Languages\"
Global Const $sDefaultLanguage = "English"
Global $aLanguage[1][1] ;undimmed language array

; Notify
Global Const $g_sNotifyVersion = "Revamp v1.5.1"
Global Const $g_iPBRemoteControlInterval = 60000 ; 60 secs
Global Const $g_iPBDeleteOldPushesInterval = 1800000 ; 30 mins
Global $g_bNotifyDeleteAllPushesNow = False
Global $LootFileName = ""

; Stats
Global $iFreeBuilderCount = 0, $iTotalBuilderCount = 0, $iGemAmount = 0 ; builder and gem amounts
Global $iTestFreeBuilderCount = -1 ; used for test cases, -1 = disabled
Global $g_iStatsStartedWith[$eLootCount] = [0,0,0,0]
Global $g_iStatsTotalGain[$eLootCount] = [0,0,0,0]
Global $g_iStatsLastAttack[$eLootCount] = [0,0,0,0]
Global $g_iStatsBonusLast[$eLootCount] = [0,0,0,0]
Global $iSkippedVillageCount, $iDroppedTrophyCount ; skipped village and dropped trophy counts
Global $iCostGoldWall, $iCostElixirWall, $iCostGoldBuilding, $iCostElixirBuilding, $iCostDElixirHero ; wall, building and hero upgrade costs
Global $iNbrOfWallsUppedGold, $iNbrOfWallsUppedElixir, $iNbrOfBuildingsUppedGold, $iNbrOfBuildingsUppedElixir, $iNbrOfHeroesUpped ; number of wall, building, hero upgrades with gold, elixir, delixir
Global $iSearchCost, $iTrainCostElixir, $iTrainCostDElixir ; search and train troops cost
Global $iNbrOfOoS ; number of Out of Sync occurred
Global $iNbrOfTHSnipeFails, $iNbrOfTHSnipeSuccess ; number of fails and success while TH Sniping
Global $iGoldFromMines, $iElixirFromCollectors, $iDElixirFromDrills ; number of resources gain by collecting mines, collectors, drills
Global $iAttackedVillageCount[$g_iModeCount + 3] ; number of attack villages for DB, LB, TB, TS
Global $iTotalGoldGain[$g_iModeCount + 3], $iTotalElixirGain[$g_iModeCount + 3], $iTotalDarkGain[$g_iModeCount + 3], $iTotalTrophyGain[$g_iModeCount + 3] ; total resource gains for DB, LB, TB, TS
Global $iNbrOfDetectedMines[$g_iModeCount + 3], $iNbrOfDetectedCollectors[$g_iModeCount + 3], $iNbrOfDetectedDrills[$g_iModeCount + 3] ; number of mines, collectors, drills detected for DB, LB, TB
Global $iAttackedCount = 0 ; convert to global from UpdateStats to enable daily attack limits
Global $SearchCount = 0 ;Number of searches
Global Const $max_train_skip = 40
Global $actual_train_skip = 0
Global $g_iSmartZapGain = 0, $g_iNumEQSpellsUsed = 0, $g_iNumLSpellsUsed = 0 ; smart zap

; My village
Global $iGoldCurrent = 0, $iElixirCurrent = 0, $iDarkCurrent = 0, $iTrophyCurrent = 0 ; current stats
Global $iTownHallLevel = 0 ; Level of user townhall
Global $TownHallPos[2] = [-1, -1] ;Position of TownHall
;Global $SFPos[2] = [-1, -1] ;Position of Spell Factory
;Global $DSFPos[2] = [-1, -1] ;Position of Dark Spell Factory
Global $KingAltarPos[2] = [-1, -1] ; position Kings Altar
Global $QueenAltarPos[2] = [-1, -1] ; position Queens Altar
Global $WardenAltarPos[2] = [-1, -1] ; position Grand Warden Altar
Global $aLabPos[2] = [-1, -1] ; Position of laboratory
Global $aCCPos[2] = [-1, -1] ; Position of clan castle
Global $iDetectedImageType = 0 ; Image theme; 0 = normal, 1 = snow
Global $iShouldRearm = True
Global $NotNeedAllTime[2] = [1, 1] ; ReArm, CheckTombs

; Army camps
Global $ArmyCapacity = 0 ; Calculated percentage of troops currently in camp / total camp space
Global $ArmyComp
Global $aCurTotalSpell[2]
Global $iTotalTrainSpaceSpell = 0
Global $CurSFactory = 0 ; Size of spell factory
Global $bFullArmySpells = False  ; true when $iTotalTrainSpaceSpell = $iTotalSpellSpace in getArmySpellCount
Global $CurCamp = 0, $TotalCamp = 0
Global Const $btnpos = [[114, 535 + $g_iMidOffsetY], [228, 535 + $g_iMidOffsetY], [288, 535 + $g_iMidOffsetY], [348, 535 + $g_iMidOffsetY], [409, 535 + $g_iMidOffsetY], _
						[494, 535 + $g_iMidOffsetY], [555, 535 + $g_iMidOffsetY], [637, 535 + $g_iMidOffsetY], [698, 535 + $g_iMidOffsetY]]

; Upgrading - Lab
Global $iLaboratoryElixirCost = 0
Global $iFirstTimeLab
Global $sLabUpgradeTime = ""

; Upgrading - Wall
Global $g_iWallCost = 0
Global Const $g_iaWallCost[8] = [30000, 75000, 200000, 500000, 1000000, 2000000, 3000000, 4000000]
Global $iNbrOfWallsUpped = 0

; Upgrading - Heroes
; Barbarian King/Queen Upgrade Costs = Dark Elixir in xxxK
Global Const $iMaxKingLevel = 45
Global Const $iMaxQueenLevel = 45
Global Const $iMaxWardenLevel = 20
Global Const $aKingUpgCost[45] = [10, 12.5, 15, 17.5, 20, 22.5, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 144, 148, 152, 156, 160, 164, 168, 172, 176, 180, 185, 188, 191, 194, 197]
Global Const $aQueenUpgCost[45] = [40, 22.5, 25, 27.5, 30, 32.5, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 129, 133, 137, 141, 145, 149, 153, 157, 161, 165, 169, 173, 177, 181, 185, 190, 192, 194, 196, 198]
; Grand Warden Upgrade Costs = Elixir in xx.xK
Global Const $aWardenUpgCost[20] = [6, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.4, 8.8, 9.1, 9.4, 9.6, 9.8, 10]

; Search
Global $bSearchMode = False
Global $Is_ClientSyncError = False ;If true means while searching Client Out Of Sync error occurred.
Global $searchGold = 0, $searchElixir = 0, $searchDark = 0, $searchTrophy = 0, $searchTH = 0 ;Resources of bases when searching
Global $SearchGold2 = 0, $SearchElixir2 = 0
Global $iMaxTH[$g_iModeCount] = [0,0,0]
Global $iAimGold[$g_iModeCount] = [0,0,0], $iAimElixir[$g_iModeCount] = [0,0,0], $iAimGoldPlusElixir[$g_iModeCount] = [0,0,0], $iAimDark[$g_iModeCount] = [0,0,0], _
	   $iAimTrophy[$g_iModeCount] = [0,0,0], $iAimTHtext[$g_iModeCount] = [0,0,0] ; Aiming Resource values
Global $THLocation = 0
Global $THx = 0, $THy = 0
Global Const $THText[6] = ["4-6", "7", "8", "9", "10", "11"]
Global $OutOfGold = 0 ; Flag for out of gold to search for attack
Global Const $aSearchCost[11] = [10, 50, 75, 110, 170, 250, 380, 580, 750, 900, 1000]
Global $Is_SearchLimit = False

; Compare resources
Global $iChkEnableAfter[$g_iModeCount]

; Town hall search
Global $THside = 0, $THi = 0
Global $SearchTHLResult = 0
Global $THLoc
Global $IMGLOCREDLINE ; hold redline data obtained from multisearch
Global $IMGLOCTHLEVEL

; Attack
Global $THusedKing = 0
Global $THusedQueen = 0
Global $THusedWarden = 0
Global Const $TopLeft[5][2] = [[83, 306], [174, 238], [240, 188], [303, 142], [390, 76]]
Global Const $TopRight[5][2] = [[466, 66], [556, 134], [622, 184], [684, 231], [775, 300]]
Global Const $BottomLeft[5][2] = [[81, 363], [174, 434], [235, 481], [299, 530], [390, 600]]
Global Const $BottomRight[5][2] = [[466, 590], [554, 523], [615, 477], [678, 430], [765, 364]]
Global Const $Edges[4] = [$BottomRight, $TopLeft, $BottomLeft, $TopRight]
Global $atkTroops[12][2] ;11 Slots of troops -  Name, Amount
Global $fullArmy ;Check for full army or not
Global Const $useAllTroops[33] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, $eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eBowl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell]
Global Const $useBarracks[26] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $useBarbs[15] = [$eBarb, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $useArchs[15] = [$eArch, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $useBarcher[16] = [$eBarb, $eArch, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $useBarbGob[16] = [$eBarb, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $useArchGob[16] = [$eArch, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $useBarcherGiant[17] = [$eBarb, $eArch, $eGiant, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $useBarcherGobGiant[18] = [$eBarb, $eArch, $eGiant, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $useBarcherHog[17] = [$eBarb, $eArch, $eHogs, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $useBarcherMinion[17] = [$eBarb, $eArch, $eMini, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $troopsToBeUsed[12] = [$useAllTroops, $useBarracks, $useBarbs, $useArchs, $useBarcher, $useBarbGob, $useArchGob, $useBarcherGiant, $useBarcherGobGiant, $useBarcherHog, $useBarcherMinion]

; >>> CS69 These are redfined as Globals inside a function in algorithm_barch.au3...not sure of the effect of that...
Global $King, $Queen, $Warden
; CS69 <<<

; >>> CS69 These are redfined as Locals inside a function in algorithm_barch.au3...which means the global values won't be used in that function
Global $CC, $Barb, $Arch
; CS69 <<<

; Attack - Heroes
Global $iHeroWaitAttackNoBit[$g_iModeCount][3] ; Heroes wait status for attack
Global $iHeroAvailable = $eHeroNone ; Hero ready status
Global $iHeroUpgrading[3] = [0, 0, 0] ; Upgrading Heroes
Global $iHeroUpgradingBit = $eHeroNone ; Upgrading Heroes
Global $bHaveAnyHero = -1	; -1 Means not set yet
Global $bFullArmyHero = False ; = BitAnd($g_aiSearchHeroWaitEnable[$g_iMatchMode], $iHeroAvailable )
Global $checkKPower = False ; Check for King activate power
Global $checkQPower = False ; Check for Queen activate power
Global $checkWPower = False ; Check for Warden activate power

; Attack - Troops
Global $g_aiSlotInArmy[$eTroopCount] = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
; Red area search
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

; Attack CSV
Global $PixelMine[0]
Global $PixelElixir[0]
Global $PixelDarkElixir[0]
Global $GoldStoragePos
Global $ElixirStoragePos
Global $darkelixirStoragePos
Global $EagleArtilleryPos[2]
Global $attackcsv_locate_mine = 0
Global $attackcsv_locate_elixir = 0
Global $attackcsv_locate_drill = 0
Global $attackcsv_locate_gold_storage = 0
Global $attackcsv_locate_elixir_storage = 0
Global $attackcsv_locate_dark_storage = 0
Global $attackcsv_locate_townhall = 0
Global $attackcsv_locate_Eagle = 0
Global $lastTroopPositionDropTroopFromINI = -1
Global $ichkUseAttackDBCSV = 0
Global $ichkUseAttackABCSV = 0

; Attack - Milking
Global $MilkFarmOffsetX = 56
Global $MilkFarmOffsetY = 41
Global $MilkFarmOffsetXStep = 35
Global $MilkFarmOffsetYStep = 26
; >>> CS69 the three $Destroyed arrays below are populated in LoadAmountOfResourceImages.au3, but not referenced elsewhere. Zombies?
Global $CapacityStructureElixir[9], $DestroyedMineIMG[9], $DestroyedElixirIMG[9], $DestroyedDarkIMG[9]
Global $duringMilkingAttack = 0
;adjust resource coordinates returned by dll ( [0] adjust coord for resource level 0-4, [1] adj. for level 5... [8] adjust coord. for level 12 )
;									0	   1      2     3     4       5     6      7      8
Global Const $MilkFarmOffsetMine[9] = ["1-1", "1-1", "0-2", "0-4", "1-2", "1-1", "3-5", "3-6", "3-5"]
Global Const $MilkFarmOffsetElixir[9] = ["1-11", "1-11", "1-9", "1-13", "0-11", "0-11", "0-13", "0-11", "0-14"]
Global Const $MilkFarmOffsetDark[7] = ["0-0", "1-4", "1-3", "0-5", "4-8", "0-4", "0-3"]
; type.level.xpos-y.pos.redarea1x-redarea1y.redarea2x,redarea2y,[...],redareanx,redareany|type.level.xpos,y.pos.redarea1x,redarea1y.redarea2x,redarea2y,[...],redareanx,redareany|....
;[0]type:gomine,elixir,ddrill
;[1]xpos and ypos
;[2]...[n] redarea points
Global $MilkFarmObjectivesSTR = ""
Global $milkingAttackOutside = 0

; Attack - Report
Global Const $League[22][4] = [ _
		["0", "Bronze III", "0", "B3"], ["1000", "Bronze II", "0", "B2"], ["1300", "Bronze I", "0", "B1"], _
		["2600", "Silver III", "0", "S3"], ["3700", "Silver II", "0", "S2"], ["4800", "Silver I", "0", "S1"], _
		["10000", "Gold III", "0", "G3"], ["13500", "Gold II", "0", "G2"], ["17000", "Gold I", "0", "G1"], _
		["40000", "Crystal III", "120", "c3"], ["55000", "Crystal II", "220", "c2"], ["70000", "Crystal I", "320", "c1"], _
		["110000", "Master III", "560", "M3"], ["135000", "Master II", "740", "M2"], ["160000", "Master I", "920", "M1"], _
		["200000", "Champion III", "1220", "C3"], ["225000", "Champion II", "1400", "C2"], ["250000", "Champion I", "1580", "C1"], _
		["280000", "Titan III", "1880", "T3"], ["300000", "Titan II", "2060", "T2"], ["320000", "Titan I", "2240", "T1"], _
		["340000", "Legend", "2400", "LE"]]

; Train
Global $bTrainEnabled = True
Global $OutOfElixir = 0 ; Flag for out of elixir to train troops
Global $aTimeTrain[3] = [0, 0, 0] ; [Troop remaining time], [Spells remaining time], [Hero remaining time - when possible]
Global Enum $ArmyTAB, $TrainTroopsTAB, $BrewSpellsTAB, $QuickTrainTAB
Global $checkSpells = False
Global Const $g_iQuickTrainButtonRetryDelay = 1000
; Array to hold Laboratory Troop information [LocX of upper left corner of image, LocY of upper left corner of image, PageLocation, Troop "name", Icon # in DLL file]
Global $aLabTroops[30][5]

Func TranslateTroopNames()
   Dim $aLabTroops[30][5] = [ _
	 [-1, -1, -1, GetTranslated(603,0, "None"), $eIcnBlank], _
	 [123, 320 + $g_iMidOffsetY, 0, GetTranslated(604,1, "Barbarians"), $eIcnBarbarian], _
	 [123, 427 + $g_iMidOffsetY, 0, GetTranslated(604,2, "Archers"), $eIcnArcher], _
	 [230, 320 + $g_iMidOffsetY, 0, GetTranslated(604,3, "Giants"), $eIcnGiant], _
	 [230, 427 + $g_iMidOffsetY, 0, GetTranslated(604,4, "Goblins"), $eIcnGoblin], _
	 [337, 320 + $g_iMidOffsetY, 0, GetTranslated(604,5, "Wall Breakers"), $eIcnWallBreaker], _
	 [337, 427 + $g_iMidOffsetY, 0, GetTranslated(604,7, "Balloons"), $eIcnBalloon], _
	 [443, 320 + $g_iMidOffsetY, 0, GetTranslated(604,8, "Wizards"), $eIcnWizard], _
	 [443, 427 + $g_iMidOffsetY, 0, GetTranslated(604,9, "Healers"), $eIcnHealer], _
	 [550, 320 + $g_iMidOffsetY, 0, GetTranslated(604,10, "Dragons"), $eIcnDragon], _
	 [550, 427 + $g_iMidOffsetY, 0, GetTranslated(604,11, "Pekkas"), $eIcnPekka], _
	 [657, 320 + $g_iMidOffsetY, 0, GetTranslated(604,20, "Baby Dragons"), $eIcnBabyDragon], _
	 [657, 427 + $g_iMidOffsetY, 0, GetTranslated(604,21, "Miners"), $eIcnMiner], _
	 [433, 320 + $g_iMidOffsetY, 1, GetTranslated(605,1, "Lightning Spell"), $eIcnLightSpell], _
	 [433, 427 + $g_iMidOffsetY, 1, GetTranslated(605,2, "Healing Spell"), $eIcnHealSpell], _
	 [540, 320 + $g_iMidOffsetY, 1, GetTranslated(605,3, "Rage Spell"), $eIcnRageSpell], _
	 [540, 427 + $g_iMidOffsetY, 1, GetTranslated(605,4, "Jump Spell"), $eIcnJumpSpell], _
	 [647, 320 + $g_iMidOffsetY, 1, GetTranslated(605,5, "Freeze Spell"), $eIcnFreezeSpell], _
	 [647, 427 + $g_iMidOffsetY, 1, GetTranslated(605,12, "Clone Spell"), $eIcnCloneSpell], _
	 [109, 320 + $g_iMidOffsetY, 2, GetTranslated(605,6, "Poison Spell"), $eIcnPoisonSpell], _
	 [109, 427 + $g_iMidOffsetY, 2, GetTranslated(605,7, "EarthQuake Spell"), $eIcnEarthQuakeSpell], _
	 [216, 320 + $g_iMidOffsetY, 2, GetTranslated(605,8, "Haste Spell"), $eIcnHasteSpell], _
	 [216, 427 + $g_iMidOffsetY, 2, GetTranslated(605,13, "Skeleton Spell"), $eIcnSkeletonSpell], _
	 [322, 320 + $g_iMidOffsetY, 2, GetTranslated(604,13, "Minions"), $eIcnMinion], _
	 [322, 427 + $g_iMidOffsetY, 2, GetTranslated(604,14, "Hog Riders"), $eIcnHogRider], _
	 [429, 320 + $g_iMidOffsetY, 2, GetTranslated(604,15, "Valkyries"), $eIcnValkyrie], _
	 [429, 427 + $g_iMidOffsetY, 2, GetTranslated(604,16, "Golems"), $eIcnGolem], _
	 [536, 320 + $g_iMidOffsetY, 2, GetTranslated(604,17, "Witches"), $eIcnWitch], _
	 [536, 427 + $g_iMidOffsetY, 2, GetTranslated(604,18, "Lava Hounds"), $eIcnLavaHound], _
	 [642, 320 + $g_iMidOffsetY, 2, GetTranslated(604,19, "Bowlers"), $eIcnBowler]]
EndFunc

; Donate
Global Const $g_aiDonateTroopPriority[$eTroopCount] = [ _
   $eTroopLavaHound, $eTroopGolem, $eTroopPekka, $eTroopDragon, $eTroopWitch, $eTroopHealer, $eTroopBabyDragon, _
   $eTroopValkyrie, $eTroopBowler, $eTroopMiner, $eTroopGiant, $eTroopBalloon, $eTroopHogRider, $eTroopWizard, _
   $eTroopWallBreaker, $eTroopMinion, $eTroopArcher, $eTroopBarbarian, $eTroopGoblin ]
Global Const $g_aiDonateSpellPriority[$eSpellCount] = [ _
   $eSpellLightning, $eSpellHeal, $eSpellRage, $eSpellJump, $eSpellFreeze, $eSpellPoison, $eSpellEarthquake, _
   $eSpellHaste, $eSpellSkeleton ]
Global $aDonIcons[20] = [$eIcnDonBarbarian, $eIcnDonArcher, $eIcnDonGiant, $eIcnDonGoblin, $eIcnDonWallBreaker, $eIcnDonBalloon, $eIcnDonWizard, $eIcnDonHealer, _
						 $eIcnDonDragon, $eIcnDonPekka, $eIcnDonBabyDragon, $eIcnDonMiner, $eIcnDonMinion, $eIcnDonHogRider, $eIcnDonValkyrie, $eIcnDonGolem, _
						 $eIcnDonWitch, $eIcnDonLavaHound, $eIcnDonBowler, $eIcnDonBlank]


Global $g_aiDonateStatsTroops[$eTroopCount][2] = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
Global $g_aiDonateStatsSpells[$eSpellCount][2] = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
Global $g_iTotalDonateStatsTroops = 0 , $g_iTotalDonateStatsTroopsXP = 0
Global $g_iTotalDonateStatsSpells = 0, $g_iTotalDonateStatsSpellsXP = 0

Global $bActiveDonate = -1	; -1 means not set yet
Global $g_aiDonateTroops[$eTroopCount] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], $g_aiDonateSpells[$eSpellCount] = [0,0,0,0,0,0,0,0,0,0]
Global $g_aiCurrentTroops[$eTroopCount] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], $g_aiCurrentSpells[$eSpellCount] = [0,0,0,0,0,0,0,0,0,0]
Global $bDonationEnabled = True
Global $TroopsDonated = 0
Global $TroopsReceived = 0

; Drop trophy
Global $bDisableDropTrophy = False ; this will be True if you tried to use Drop Throphy and did not have Tier 1 or 2 Troops to protect you expensive troops from being dropped.
Global $aDTtroopsToBeUsed[6][2] = [["Barb", 0], ["Arch", 0], ["Giant", 0], ["Wall", 0], ["Gobl", 0], ["Mini", 0]] ; DT available troops [type, qty]

; Obstacles
Global Const $break = @ScriptDir & "\imgxml\other\break*"
Global Const $device = @ScriptDir & "\imgxml\other\device*"
Global Const $CocStopped = @ScriptDir & "\imgxml\other\CocStopped*"
Global Const $CocReconnecting = @ScriptDir & "\imgxml\other\CocReconnecting*"
Global Const $AppRateNever = @ScriptDir & "\imgxml\other\RateNever*"
Global $MinorObstacle = False

; Check version
Global $lastversion = "" ;latest version from GIT
Global $lastmessage = "" ;message for last version
Global $oldversmessage = "" ;warning message for old bot

; TakeABreak - Personal Break Timer
Global $iTaBChkAttack = 0x01 ; code for PB warning when searching attack
Global $iTaBChkIdle = 0x02 ; code for PB warning when idle at base
Global $iTaBChkTime = 0x04 ; code for PB created by early log off feature
Global $bDisableBreakCheck = False
Global $sPBStartTime = "" ; date/time string for start of next Personal Break
Global $aShieldStatus = ["", "", ""] ; string shield type, string shield time, string date/time of Shield expire

; Building Side (DES/TH) Switch and DESide End Early
Global Enum $eSideBuildingDES, $eSideBuildingTH
Global $BuildingLoc, $BuildingLocX = 0, $BuildingLocY = 0
Global $dropQueen, $dropKing, $dropWarden
Global $BuildingEdge, $BuildingToLoc = ""
Global $DarkLow

;Snipe While Train
Global $iChkSnipeWhileTrain = 0
Global Const $itxtminArmyCapacityTHSnipe = 35

; Request CC troops/spells
Global $iCCRemainTime = 0  ; Time remaining until can request CC again
Global $canRequestCC = True

; DO NOT ENABLE ! ! ! Only for testing Android Error behavior ! ! !
Global $__TEST_ERROR_ADB_DEVICE_NOT_FOUND = False
Global $__TEST_ERROR = $__TEST_ERROR_ADB_DEVICE_NOT_FOUND
Global $__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY = 0
Global $__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY = 0
Global $__TEST_ERROR_SLOW_ADB_CLICK_DELAY = 0

; ImgLoc V3 , new image search library Aforge
; Similarity ( like tolerance ) 0,00 to 1,00
Global $ToleranceImgLoc = 0.95

; SmartZap
Global $g_iLSpellLevel = 1
Global $g_iESpellLevel = 1
Global Const $g_fDarkStealFactor = 0.75
Global Const $g_fDarkFillLevel = 0.70
; Array to hold Total HP of DE Drills at each level (1-6)
Global Const $g_aDrillLevelHP[6] = [800, 860, 920, 980, 1060, 1160]
; Array to hold Total Amount of DE available from Drill at each level (1-6)
Global Const $g_aDrillLevelTotal[6] = [160, 300, 540, 840, 1280, 1800]
; Array to hold Total Damage of Lightning Spell at each level (1-7)
Global Const $g_aLSpellDmg[7] = [300, 330, 360, 390, 450, 510, 570]
; Array to hold Total Damage of Earthquake Spell at each level (1-4)
Global Const $g_aEQSpellDmg[4] = [0.14, 0.17, 0.21, 0.25]
; Global Const $drillLevelHold[6] = [120, 225, 405, 630, 960, 1350] ; Total Amount of DE available from Drill at each level (1-6)
; Global Const $drillLevelSteal[6] = [59, 102, 172, 251, 343, 479] ; Amount of DE available to steal from Drills at each level (1-6)