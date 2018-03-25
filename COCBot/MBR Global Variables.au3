; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Global Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Everyone all the time  :)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; AutoIt includes
#include <APIErrorsConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <WinAPISys.au3>
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
#include <Timers.au3>

Global Const $g_sLogoPath = @ScriptDir & "\Images\Logo.png"
Global Const $g_sLogoUrlPath = @ScriptDir & "\Images\LogoURL.png"
Global Const $g_sLogoUrlSmallPath = @ScriptDir & "\Images\LogoURLsmall.png"
Global Const $g_iGAME_WIDTH = 860
Global Const $g_iGAME_HEIGHT = 732
Global Const $g_iDEFAULT_HEIGHT = 780
Global Const $g_iDEFAULT_WIDTH = 860
Global Const $g_iMidOffsetY = Int(($g_iDEFAULT_HEIGHT - 720) / 2)
Global Const $g_iBottomOffsetY = $g_iDEFAULT_HEIGHT - 720

Global $g_hBotLaunchTime = __TimerInit() ; Keeps track of time bot launched
Global $g_iBotLaunchTime = 0 ; Keeps track of time (in millseconds) from bot launch to ready for use

; Since October 12th 2016 Update, Village cannot be entirely zoomed out, offset updated in func SearchZoomOut
Global $g_iVILLAGE_OFFSET[3] = [0, 0, 1]

#Region debugging
#Tidy_Off
; <><><><><><><><><><><><><><><><><><>
; <><><><> debug flags <><><><>
; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
Global $g_bDebugSetlog = False ; Verbose log messages, or extra log messages most everywhere
Global $g_bDebugAndroid = False ; Debug Android
Global $g_bDebugClick = False ; Debug Bot Clicks and when docked, display current mouse position and RGB color
Global $g_bDebugFuncTime = False ; Log Function execution time (where implemented)
Global $g_bDebugFuncCall = False ; Log Function call hierarchy (where implemented)
Global $g_bDebugOcr = False ; Creates \Lib\Debug folder and collects OCR images of text capture plus creates OCR log file
Global $g_bDebugImageSave = False ; Save images at key points to allow review/verify emulator window status
Global $g_bDebugBuildingPos = False ; extra information about buildings detected while searching for base to attack
Global $g_bDebugSetlogTrain = False ; verbose log information during troop training
Global $g_iDebugWindowMessages = 0 ; 0=off, 1=most Window Messages, 2=all Window Messages
Global $g_bDebugAndroidEmbedded = False ; Extra Android messages when using dock mode
Global $g_bDebugGetLocation = False ;make a image of each structure detected with getlocation
Global $g_bDebugRedArea = False ; display red line data captured
Global $g_hDebugAlwaysSaveFullScreenTimer = 0 ; __TimerInit() to save every screen capture at full size for 5 Minutes
Global $g_bDebugSmartZap = False ; verbose logs for SmartZap users
Global $g_bDebugAttackCSV = False ; Verbose log output of actual attack script plus bot actions
Global $g_bDebugMakeIMGCSV = False ; Saves "clean" iamge and image with all drop points and detected buildings marked
Global $g_bDebugBetaVersion = StringInStr($g_sBotVersion, " b") > 0 ; not saved and only used for special beta releases

; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
; <><><><> ONLY Enable items below this line when debugging special errors listed!! <><><><>
; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

; <><><><> Capture image of every base during village search! <><><><>
Global $g_bDebugVillageSearchImages = False ; will fill drive with huge number of images, enable "Delete Temp Files" to reduce lag created with too many images in folder
; <><><><> Debug Dead Base search problems <><><><>
Global $g_bDebugDeadBaseImage = False ; Enable collection of zombie base images where loot is above search filter, no dead base detected
Global $g_aiSearchEnableDebugDeadBaseImage = 200 ; If $g_iDebugDeadBaseImage is 0 and more than these searches reached, set $g_iDebugDeadBaseImage = 1, 0 = disabled
; <><><><> Enable when debugging Milk attack errors! <><><><>
Global $g_bDebugResourcesOffset = False ;make images with offset to check correct adjust values
Global $g_bDebugMilkingIMGmake = False
Global $g_bDebugContinueSearchElixir = False ; SLOW... if =1 search elixir check all images even if capacity < mincapacity and make debug image in temp folder if no match all images
; <><><><> Enable this flag to test Donation code, but DOES NOT DONATE! <><><><>
Global $g_bDebugOCRdonate = False ; Creates OCR/image data and simulate, but do not donate
; <><><><> Only enable this when debugging Android zoom out issues! <><><><>
Global $g_bDebugDisableZoomout = False
Global $g_bDebugDisableVillageCentering = False
; <><><><> Only used to debug GDI memory leaks! <><><><>
Global $g_iDebugGDICount = 0 ; monitor bot GDI Handle count, 0 = Disabled, <> 0 = Enabled
; <><><><> Only used to debug language translations! <><><><>
Global $g_bDebugMultilanguage = False ; Debug translated GUI messages, displays section/# of translate for GUI elements instead of actual text
; <><><><> debugging use only variables <><><><>

; Enabled saving of enemy villages when deadbase is active
Global $g_aZombie = ["" _ ; 0=Filename
		, 0 _ ; 1=Raided Elixir
		, 0 _ ; 2=Available Elixir
		, 0 _ ; 3=# of matched collectod
		, 0 _ ; 4=Search #
		, "" _ ; 5=timestamp
		, "" _ ; 6=redline
		, 30 _ ; 7=Delete screenshot when Elixir capture percentage was >= value (-1 for disable)
		, 300 _ ; 8=Save screenshot when skipped DeadBase and available Exlixir in k is >= value and no filled Elixir Storage found (-1 for disable)
		, 600 _ ; 9=Save screenshot when skipped DeadBase and available Exlixir in k is >= value (-1 for disable)
		, 150 _ ; 10=Save screenshot when DeadBase and available Exlixir in k is < value (-1 for disable)
		]
Global $g_iDebugGDICountMax = 0 ; max value of GDI Handle count
Global $g_oDebugGDIHandles = ObjCreate("Scripting.Dictionary") ; stores GDI handles when $g_iDebugGDICount <> 0

; This will be the ObjEvent to handle with object errors
Global $g_oCOMErrorHandler = 0

; <><><><><><><><><><><><><><><><><><>
#Tidy_On
#EndRegion debugging

Global Const $COLOR_ORANGE = 0xFF7700 ; Used for donate GUI buttons
Global Const $COLOR_ERROR = $COLOR_RED ; Error messages
Global Const $COLOR_WARNING = $COLOR_MAROON ; Warning messages
Global Const $COLOR_INFO = $COLOR_BLUE ; Information or Status updates for user
Global Const $COLOR_SUCCESS = 0x006600 ; Dark Green, Action, method, or process completed successfully
Global Const $COLOR_SUCCESS1 = 0x009900 ; Med green, optional success message for users
Global Const $COLOR_DEBUG = $COLOR_PURPLE ; Purple, basic debug color
Global Const $COLOR_DEBUG1 = 0x7A00CC ; Dark Purple, Debug for successful status checks
Global Const $COLOR_DEBUG2 = 0xAA80FF ; lt Purple, secondary debug color
Global Const $COLOR_DEBUGS = $COLOR_MEDGRAY ; Med Grey, debug color for less important but needed supporting data points in multiple messages
Global Const $COLOR_ACTION = 0xFF8000 ; Med Orange, debug color for individual actions, clicks, etc
Global Const $COLOR_ACTION1 = 0xCC80FF ; Light Purple, debug color for pixel/window checks

Global Const $g_bCapturePixel = True, $g_bNoCapturePixel = False
Global $g_bWinMove2_Compatible = True ; If enabled, WinMove is used by WinMove2 for moving and resizing Windows that can fix resize problems on some systems
Global $g_sControlGetHandle2_Classname = ""

Global $g_bCriticalMessageProcessing = False
Global $g_hHBitmapTest = 0 ; Image used when testing image functions (_CaptureRegion will not take new screenshot when <> 0)
Global $g_hBitmap ; Image for pixel functions
Global $g_hHBitmap ; Handle Image for pixel functions
Global $g_hHBitmap2 ; handle to Device Context (DC) with graphics captured by _captureregion2()
Global $g_bOcrForceCaptureRegion = True ; When True take new $g_hHBitmap2 screenshot of OCR area otherwise create area from existing (fullscreen!) $g_hHBitmap2

Global $g_iGuiMode = 1 ; GUI Mode: 1 = normal, main form and all controls created, 2 = mini, main form only with buttons, 0 = GUI less, without any form
Global $g_bGuiControlsEnabled = True
Global $g_bGuiRemote = False ; GUI Remote flag
Global $g_iGuiPID = @AutoItPID
Global $g_iDpiAwarenessMode = 1 ; 0 = Disable new DPI Desktop handling, 1 = Enable and set DPI Awareness as needed

;Global $sFile = @ScriptDir & "\Icons\logo.gif"

Global Const $g_b64Bit = StringInStr(@OSArch, "64") > 0
Global Const $g_sHKLM = "HKLM" & ($g_b64Bit ? "64" : "")
Global Const $g_sWow6432Node = ($g_b64Bit ? "\Wow6432Node" : "")
Global Const $g_sGoogle = "Google"

#Region Android.au3
#Tidy_Off
; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
; <><><><><><>  Android.au3 (and related) globals <><><><><><>
Global $g_sAndroidGameDistributor = "Google" ; Default CoC Game Distributor, loaded from config.ini
Global $g_sAndroidGamePackage = "com.supercell.clashofclans" ; Default CoC Game Package, loaded from config.ini
Global $g_sAndroidGameClass = ".GameApp" ; Default CoC Game Class, loaded from config.ini
Global $g_sUserGameDistributor = "Google" ; User Added CoC Game Distributor, loaded from config.ini
Global $g_sUserGamePackage = "com.supercell.clashofclans" ; User Added CoC Game Package, loaded from config.ini
Global $g_sUserGameClass = ".GameApp" ; User Added CoC Game Class, loaded from config.ini

Global $g_hAndroidLaunchTime = 0 ; __TimerInit() when Android was last launched
Global $g_iAndroidRebootHours = 24 ; Default hours when Android gets automatically rebooted

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

Global $g_bPoliteCloseCoC = False ; True: PoliteCloseCoC() function will try to perform a polite close by going back and press exit button, False am force-stop to kill game
Global Const $g_bAndroidBackgroundLaunchEnabled = False ; Headless mode not finished yet (2016-07-13, cosote)
Global $g_bAndroidCheckTimeLagEnabled = True ; Checks every 60 Seconds or later in main loops (Bot Run, Idle and SearchVillage) is Android needs reboot due to time lag (see $g_iAndroidTimeLagThreshold)
Global $g_iAndroidAdbAutoTerminate = 0 ; Steady ADB shell instance is automatically closed after this number of executed commands, 0 = disabled (test for BS to fix frozen screen situation!)
Global $g_bAndroidAdbScreencapEnabled = True ; Use Android ADB to capture screenshots in RGBA raw format
Global $g_bAndroidAdbScreencapPngEnabled = False ; Use Android ADB to capture screenshots in PNG format, significantly slower than raw format (not final, captured screenshot resize too slow...)
Global $g_bAndroidAdbZoomoutEnabled = True ; Use Android ADB zoom-out script
Global $g_bAndroidAdbClickDragEnabled = True ; Use Android ADB click drag script or input swipe
Global $g_bAndroidAdbInputEnabled = True ; Enable Android ADB send text (CC requests), swipe not used as click drag anymore
Global $g_iAndroidAdbInputWordsCharLimit = 10 ; Android ADB send text words (split by space) with this limit of specified characters per command (0 = disabled and entire text is sent at once)
Global $g_bAndroidAdbClickEnabled = False ; Enable Android ADB mouse click
Global $g_bAndroidAdbClicksEnabled = False ; (Experimental & Dangerous!) Enable Android KeepClicks() and ReleaseClicks() to fire collected clicks all at once, only available when also $g_bAndroidAdbClick = True
Global $g_iAndroidAdbClicksTroopDeploySize = 0 ; (Experimental & Dangerous!) Deploy more troops at once, 0 = deploy group, only available when also $g_bAndroidAdbClicksEnabled = True (currently only just in CSV Deploy)
Global $g_bAndroidAdbInstanceEnabled = True ; Enable Android steady ADB shell instance when available
Global $g_bAndroidSuspendedEnabled = True ; Enable Android Suspend & Resume during Search and Attack
Global $g_iAndroidSuspendModeFlags = 1 ; Android Suspend & Resume mode bit flags: 0=Disabled, 1=Only during Search/Attack, 2=For every ImgLoc call, 4=Suspend entire Android (not advised!)
Global $g_bNoFocusTampering = False ; If enabled, no ControlFocus or WinActivate is called, except when really required (like Zoom-Out for Droid4X, might break restart stability when Android Window not responding)
Global $g_iAndroidRecoverStrategy = 1 ; 0 = Stop ADB Daemon first then restart Android; 1 = Restart Android first then restart ADB Daemon

; "BlueStacks2" $g_avAndroidAppConfig is also updated based on Registry settings in Func InitBlueStacks2() with these special variables
Global $__BlueStacks_SystemBar = 48
Global $__BlueStacks2Version_2_5_or_later = False ;Starting with this version bot is enabling ADB click and uses different zoomout
; "MEmu" $g_avAndroidAppConfig is also updated based on runtime config in Func UpdateMEmuWindowState() with these special variables
Global $__MEmu_Adjust_Width = 6
Global $__MEmu_ToolBar_Width = 45
Global $__MEmu_SystemBar = 36
Global $__MEmu_PhoneLayout = "2" ; 0: bottom Nav Bar (default till 2.6.1), 1: right Nav Bar, 2: hidden Nav Bar (default since 2.6.2), -1 disable Nav Bar compensation since MEmu 3 Nav Bar auto-hides
Global $__MEmu_Window[4][5] = _ ; Alternative window sizes (array must be ordered by version descending!)
        [ _ ; Version|$g_iAndroidWindowWidth|$g_iAndroidWindowHeight|$__MEmu_ToolBar_Width|$__MEmu_PhoneLayout
        ["3.0.8", $g_iDEFAULT_WIDTH + 40, $g_iDEFAULT_HEIGHT - 14, 36, "-1"], _
        ["2.6.2", $g_iDEFAULT_WIDTH + 48, $g_iDEFAULT_HEIGHT - 10, 40, "2"], _
        ["2.5.0", $g_iDEFAULT_WIDTH + 51, $g_iDEFAULT_HEIGHT - 12, 45, "0"], _
        ["2.2.1", $g_iDEFAULT_WIDTH + 51, $g_iDEFAULT_HEIGHT - 12, 45, "0"] _
        ]
Global $__Droid4X_Window[3][3] = _ ; Alternative window sizes (array must be ordered by version descending!)
		[ _ ; Version|$g_iAndroidWindowWidth|$g_iAndroidWindowHeight
		["0.10.0", $g_iDEFAULT_WIDTH + 6, $g_iDEFAULT_HEIGHT + 53], _
		["0.8.6", $g_iDEFAULT_WIDTH + 10, $g_iDEFAULT_HEIGHT + 50] _
		]
Global $__Nox_Config[1][2] = _ ; Alternative Nox Control ID (array must be ordered by version descending!)
		[ _ ; Version|$g_sAppClassInstance
		["3.3.0", "[CLASS:subWin; INSTANCE:1]|[TEXT:QWidgetClassWindow; CLASS:Qt5QWindowIcon]"] _ ; use multiple index as during undock it can change
		]

;   0             |1         |2                       |3                                 |4               |5                     |6                      |7                     |8                      |9             |10                  |11                           |12                    |13                                  |14                                   |15
;   $g_sAndroidEmulator      |$g_sAndroidTitle        |$g_sAppClassInstance              |$g_sAppPaneName |$g_iAndroidClientWidth|$g_iAndroidClientHeight|$g_iAndroidWindowWidth|$g_iAndroidWindowHeight|$ClientOffsetY|$g_sAndroidAdbDevice|$g_iAndroidSupportFeature    |$g_sAndroidShellPrompt|$g_sAndroidMouseDevice              |$g_bAndroidEmbed/$g_iAndroidEmbedMode|$g_iAndroidBackgroundModeDefault
;                 |$g_sAndroidInstance                |                                  |                |                      |                       |                      |                       |              |                    |1 = Normal background mode   |                      |                                    |-1 = Not available                   |1 = WinAPI Mode (requires DirectX)
;                 |          |                        |                                  |                |                      |                       |                      |                       |              |                    |2 = ADB screencap mode       |                      |                                    | 0 = Normal docking                  |2 = ADB screencap Mode (not supported in BS1 and LeapDroid!)
;                 |          |                        |                                  |                |                      |                       |                      |                       |              |                    |4 = ADB mouse click          |                      |                                    | 1 = Simulated docking               |
;                 |          |                        |                                  |                |                      |                       |                      |                       |              |                    |8 = ADB input text           |                      |                                    |                                     |
;                 |          |                        |                                  |                |                      |                       |                      |                       |              |                    |16 = ADB shell is steady     |                      |                                    |                                     |
;                 |          |                        |                                  |                |                      |                       |                      |                       |              |                    |32 = ADB click drag          |                      |                                    |                                     |
;                 |          |                        |                                  |                |                      |                       |                      |                       |              |                    |64 = Make DPI Aware (if avaliable)                  |                                    |                                     |
;                 |          |                        |                                  |                |                      |                       |                      |                       |              |                    |128 = ADB use input swipe and not script            |                                    |                                     |
Global $g_avAndroidAppConfig[8][16] = [ _ ;           |                                  |                |                      |                       |                      |                       |              |                    |256 = Update $g_sAppClassInstance with Window Handle|                                    |                                     |
	["Nox",        "nox",     "No",                   "[CLASS:subWin; INSTANCE:1]",       "",              $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 4, $g_iDEFAULT_HEIGHT - 10,0,             "127.0.0.1:62001",   1 + 2 + 4 + 8 + 16 + 32 + 256,'# ',                  '(nox Virtual Input|Android Input|Android_Input)', 0,                      2], _ ; Nox
	["MEmu",       "MEmu",    "MEmu ",                "[CLASS:subWin; INSTANCE:1]",       "",              $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 51,$g_iDEFAULT_HEIGHT - 12,0,             "127.0.0.1:21503",       2 + 4 + 8 + 16 + 32,      '# ',                  '(Microvirt Virtual Input|User Input)', 0,                                 2], _ ; MEmu
	["BlueStacks2","Android", "BlueStacks ",          "[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window",   $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,0,             "127.0.0.1:5555",    1 + 2     + 8 + 16 + 32 + 128,'$ ',                  'BlueStacks Virtual Touch',          0,                                    1], _ ; BlueStacks2
	["BlueStacks", "Android", "BlueStacks App Player","[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window",   $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,0,             "127.0.0.1:5555",    1         + 8 + 16 + 32 + 128,'$ ',                  'BlueStacks Virtual Touch',          0,                                    1], _ ; BlueStacks
	["iTools",     "iToolsVM","iTools ",              "[CLASS:subWin; INSTANCE:1]",       "",              $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 2, $g_iDEFAULT_HEIGHT - 13,0,             "127.0.0.1:54001",   1 + 2     + 8 + 16 + 32 + 64, '# ',                  'iTools Virtual PassThrough Input',  0,                                    1], _ ; iTools
	["KOPLAYER",   "KOPLAYER","KOPLAYER",             "[CLASS:subWin; INSTANCE:1]",       "",              $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 64,$g_iDEFAULT_HEIGHT - 8, 0,             "127.0.0.1:6555",    1 + 2 + 4 + 8 + 16 + 32,      '# ',                  'ttVM Virtual Input',                0,                                    2], _ ; KOPLAYER
	["Droid4X",    "droid4x", "Droid4X ",             "[CLASS:subWin; INSTANCE:1]",       "",              $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH + 10,$g_iDEFAULT_HEIGHT + 50,0,             "127.0.0.1:26944",       2 + 4 + 8 + 16 + 32,      '# ',                  'droid4x Virtual Input',             0,                                    2], _ ; Droid4X
	["LeapDroid",  "vm1",     "Leapd",                "[CLASS:subWin; INSTANCE:1]",       "",              $g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,$g_iDEFAULT_WIDTH,     $g_iDEFAULT_HEIGHT - 48,0,             "emulator-5554",     1         + 8 + 16 + 32,      '# ',                  'qwerty2',                           1,                                    1]  _ ; LeapDroid
]

; Android Configutions
Global $__MEmu_Idx = _ArraySearch($g_avAndroidAppConfig, "MEmu", 0, 0, 0, 0, 1, 0) ; MEmu 3.6.2.0, 3.5.0.2, 3.1.2.x, 2.9.6.1, 2.9.3, 2.9.1, 2.8.6, 2.8.5, 2.8.3, 2.8.2, 2.8.0, 2.7.2, 2.7.0, 2.6.6, 2.6.5, 2.6.2, 2.6.1, 2.5.0, 2.3.1, 2.3.0, 2.2.1
Global $__BS2_Idx = _ArraySearch($g_avAndroidAppConfig, "BlueStacks2", 0, 0, 0, 0, 1, 0) ; BlueStacks 3.50.63.2536, 3.7.x, 2.7.x, 2.6.x, 2.5.x, 2.4.x, 2.3.x, 2.2.x, 2.1.x, 2.0.x
Global $__BS_Idx = _ArraySearch($g_avAndroidAppConfig, "BlueStacks", 0, 0, 0, 0, 1, 0) ; BlueStacks 0.11.x, 0.10.x, 0.9.x, 0.8.x
Global $__KOPLAYER_Idx = _ArraySearch($g_avAndroidAppConfig, "KOPLAYER", 0, 0, 0, 0, 1, 0) ; KOPLAYER 1.4.1055, 1.4.1049
Global $__LeapDroid_Idx = _ArraySearch($g_avAndroidAppConfig, "LeapDroid", 0, 0, 0, 0, 1, 0) ; LeapDroid 1.8.0, 1.7.0, 1.6.1, 1.5.0, 1.4.0, 1.3.1
Global $__iTools_Idx = _ArraySearch($g_avAndroidAppConfig, "iTools", 0, 0, 0, 0, 1, 0) ; iTools AVM 2.0.8.9, 2.0.7.9, 2.0.6.8
Global $__Droid4X_Idx = _ArraySearch($g_avAndroidAppConfig, "Droid4X", 0, 0, 0, 0, 1, 0) ; Droid4X 0.10.6 Beta, Droid4X 0.10.5 Beta, 0.10.4 Beta, 0.10.3 Beta, 0.10.2 Beta, 0.10.1 Beta, 0.10.0 Beta, 0.9.0 Beta, 0.8.7 Beta, 0.8.6 Beta
Global $__Nox_Idx = _ArraySearch($g_avAndroidAppConfig, "Nox", 0, 0, 0, 0, 1, 0) ; Nox 6.0.0, 5.2.1.0, 5.1.0.0, 5.0.0.1, 5.0.0.0, 3.8.1.3, 3.8.0.x, 3.7.6.x, 3.7.5.1, 3.7.5, 3.7.3, 3.7.1, 3.7.0, 3.6.0, 3.5.1, 3.3.0, 3.1.0, 3.0.0

; Startup detection
Global $g_bOnlyInstance = True
Global $g_bFoundRunningAndroid = False
Global $g_bFoundInstalledAndroid = False

; Android Options and settings
Global Const $g_iOpenAndroidActiveMaxTry = 3 ; Try recursively 3 times to open Android
Global Const $g_iAndroidBackgroundModeDirectX = 1
Global Const $g_iAndroidBackgroundModeOpenGL = 2
Global $g_iAndroidBackgroundMode = 0 ; 0 = Default (using $g_iAndroidBackgroundModeDefault), 1 = WinAPI mode (faster, but requires Android DirectX), 2 = ADB screencap mode (slower, but alwasy works even if Monitor is off -> "True Brackground Mode")
Global $g_iAndroidBackgroundModeDefault = 1 ; Uses 1 or 2 of $g_iAndroidBackgroundMode
Global $g_iAndroidConfig = 0 ; Default selected Android Config of $g_avAndroidAppConfig array
Global $g_sAndroidVersion ; Identified version of Android Emulator (not Android Version, this is the version of the vendor!)
Global $g_sAndroidEmulator ; Emulator used (BS, BS2, Droid4X, MEmu or Nox)
Global $g_sAndroidInstance ; Clone or instance of emulator or "" if not supported
Global $g_sAndroidTitle ; Emulator Window Title
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
Global $g_iAndroidAdbSuCommand ; empty string is not available, used by BlueStacks to have root access
Global $g_bAndroidAdbScreencap ; Use Android ADB to capture screenshots in RGBA raw format
Global $g_bAndroidAdbClick ; Enable Android ADB mouse click
Global $g_bAndroidAdbInput ; Enable Android ADB send text (CC requests)
Global $g_bAndroidAdbInstance ; Enable Android steady ADB shell instance when available
Global $g_bAndroidAdbClickDrag ; Enable Android ADB Click Drag script or input swipe
Global $g_bAndroidAdbClickDragScript = True ; If $g_bAndroidAdbClickDrag = True it used either script (True) or input swipe (False) for click & drag
Global $g_bAndroidEmbed ; Enable Android Docking
Global $g_iAndroidEmbedMode ; Android Dock Mode: -1 = Not available, 0 = Normal docking, 1 = Simulated docking
Global $g_bAndroidBackgroundLaunch ; Enabled Android Background launch using Windows Scheduled Task
Global $g_bAndroidBackgroundLaunched ; True when Android was launched in headless mode without a window
Global $g_iAndroidControlClickDelay = 10 ; 10 is Default (Milliseconds)
Global $g_iAndroidControlClickDownDelay = 2 ; 2 is Default (Milliseconds)
Global $g_iAndroidControlClickWindow = 0 ; 0 = Click the Android Control, 1 = Click the Android Window
Global $g_iAndroidControlClickMode = 0 ; 0 = Use AutoIt ControlClick, 1 = Use _SendMessage
Global $g_bAndroidCloseWithBot = False ; Close Android when bot closes
Global $g_bAndroidInitialized = False

Global $g_iAndroidProcessAffinityMask = 0

; Android details
; Supported Android Versions, used for some ImgLoc functions and in GetAndroidCodeName()
Global Const $g_iAndroidJellyBean = 17
Global Const $g_iAndroidLollipop = 21
Global Const $g_iAndroidNougat = 24
Global $g_iAndroidVersionAPI = $g_iAndroidJellyBean ; getprop ro.build.version.sdk

; Updated in UpdateAndroidConfig() and $g_sAndroidEmulator&Init() as well
Global $g_bInitAndroidActive = False

Global $g_sAndroidPath = "" ; Program folder to launch android emulator
Global $g_sAndroidProgramPath = "" ; Program path and executable to launch android emulator
Global $b_sAndroidProgramWerFaultExcluded = True ; Register Android Executable to be excluded globally for WerFault (Windows Error Reporting Service)
Global $g_avAndroidProgramFileVersionInfo = 0 ; Array of _WinAPI_VerQueryValue FileVersionInfo
Global $g_bAndroidHasSystemBar = False ; BS2 System Bar can be entirely disabled in Windows Registry
Global $g_iAndroidClientWidth_Configured = 0 ; Android configured Screen Width
Global $g_iAndroidClientHeight_Configured = 0 ; Android configured Screen Height
Global $g_iAndroidLaunchWaitSec = 240 ; Seconds to wait for launching Android Simulator

Global $g_sAndroidPicturesPath = "" ; Android mounted path to pictures on host
Global $g_sAndroidPicturesHostPath = "" ; Windows host path to mounted pictures in android
Global $g_bAndroidSharedFolderAvailable = True
Global Const $g_iAndroidSecureFlags = 3 ; Bits 0 = disabled file renaming/folder less mode, 1 = Secure (SHA-1 filenames no folder), 2 = Delete files after use immediately
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

Global $g_aiAndroidTimeLag[6] = [0, 0, 0, 0, 0, 0] ; Timer varibales for time lag calculation
Global Const $g_iAndroidTimeLagThreshold = 5 ; Time lag Seconds per Minute when Android gets restarted
Global Const $g_iAndroidTimeLagRebootThreshold = 2 ; Reboot Andoid after # of time lag problems
Global Const $g_iAndroidTimeLagResetProblemCountMinutes = 5 ; Reset time lag problem count after specified Minutes

Global Const $g_iAndroidRebootPageErrorCount = 5 ; Reboots Android automatically after so many IsPage errors (uses $AndroidPageError[0] and $g_iAndroidRebootPageErrorPerMinutes)
Global Const $g_iAndroidRebootAdbCommandErrorCount = 10 ; Reboots Android automatically after so many ADB command erros
Global Const $g_iAndroidRebootPageErrorPerMinutes = 10 ; Reboot Android if $AndroidPageError[0] errors occurred in $g_iAndroidRebootPageErrorPerMinutes Minutes
Global $g_hProcShieldInput[5] = [0, 0, False, False, 0] ; Stores Android Shield variables and states

Global $g_bSkipFirstZoomout = False ; Zoomout sets to True, CoC start/Start/Resume/Return from battle to False

Global $g_bForceCapture = False ; Force android ADB screencap to run and not provide last screenshot if available

Global $g_hAndroidWindow = 0 ; Handle for Android window
Global $g_hAndroidWindowDpiAware = 0 ; Handle for Android window when bot set DPI Awareness
Global $g_hAndroidControl = 0 ; Handle for Android Screen Control

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
Global $__VBoxExtraData ; Virtualbox extra data details of android instance

; <><><><><><>  Android.au3 globals <><><><><><>
; <><><><><><><><><><><><><><><><><><><><><><><><>
#Tidy_On
#EndRegion Android.au3

; set ImgLoc threads use
Global $g_iGlobalActiveBotsAllowed = EnvGet("NUMBER_OF_PROCESSORS") ; Number of parallel running bots allowed
If IsNumber($g_iGlobalActiveBotsAllowed) = 0 Or $g_iGlobalActiveBotsAllowed < 1 Then $g_iGlobalActiveBotsAllowed = 2 ; ensure that multiple bots can run
Global $g_hMutextOrSemaphoreGlobalActiveBots = 0 ; Mutex or Semaphore handle to control parallel running bots
Global $g_iGlobalThreads = 0 ; Used by ImgLoc for parallism (shared by all bot instances), 0 = use as many threads as processors, 1..x = use only specified number of threads
Global $g_iThreads = 0 ; Used by ImgLoc for parallism (for this bot instance), 0 = use as many threads as processors, 1..x = use only specified number of threads

; Profile file/folder paths
Global $g_sProfilePath = @ScriptDir & "\Profiles"
Global $g_sPrivateProfilePath = @MyDocumentsDir & "\MyBot.run-Profiles" ; Used to save private & very sensitive profile information like shared_prefs (notification tokens will be saved in future here also)
Global Const $g_sProfilePresetPath = @ScriptDir & "\Strategies"
Global $g_sProfileCurrentName = "" ; Name of profile currently being used
Global $g_sProfileConfigPath = "" ; Path to the current config.ini being used in this profile
Global $g_sProfileBuildingStatsPath = "" ; Path to stats_chkweakbase.ini file for this profile
Global $g_sProfileBuildingPath = "" ; Paths to building.ini file for this profile
Global $g_sProfileLogsPath = "", $g_sProfileLootsPath = "", $g_sProfileTempPath = "", $g_sProfileTempDebugPath = "" ; Paths to log/image/temp folders for this profile
Global $g_sProfileDonateCapturePath = "", $g_sProfileDonateCaptureWhitelistPath = "", $g_sProfileDonateCaptureBlacklistPath = "" ; Paths to donate related folders for this profile
Global $g_sProfileSecondaryInputFileName = ""
Global $g_sProfileSecondaryOutputFileName = ""
Global $g_asProfiles[0] ; Array String of available profiles, initialized in func setupProfileComboBox()
Global $g_bReadConfigIsActive = False
Global $g_bSaveConfigIsActive = False
Global $g_bApplyConfigIsActive = False

; Logging
Global $g_hTxtLogTimer = __TimerInit() ; Timer Handle of last log
Global Const $g_iTxtLogTimerTimeout = 500 ; Refresh log only every configured Milliseconds
Global $g_bMoveDivider = False
Global $g_bSilentSetLog = False ; No logs to Log Control when enabled
Global $g_sLogFileName = ""
Global $g_hLogFile = 0
Global $g_hAttackLogFile = 0
Global $g_hSwitchLogFile = 0
Global $g_bFlushGuiLogActive = False ; when RichEdit Log control get updated, focus change occur and this flag is required to avoid focus change due to GUIControl_WM_ACTIVATEAPP events
Global $g_iLogCheckFreeSpaceMB = 100 ; If > 0, check every 10 Minutes when logging messages, that at least 100 MB are free on profile folder or bot stops

; Used in _Sleep.au3 to control various administrative tasks when idle
Global $g_hStruct_SleepMicro = DllStructCreate("int64 time;") ; holds the _SleepMilli sleep time in 100-nanoseconds
Global $g_pStruct_SleepMicro = DllStructGetPtr($g_hStruct_SleepMicro)
Global Const $g_iEmptyWorkingSetAndroid = 0 ; Empty Android Workingset specified Seconds, 0 for disable
Global Const $g_iEmptyWorkingSetBot = 300 ; Empty Bot Workingset specified Seconds, 0 for disable
Global Const $g_bMoveMouseOutBS = False ; If enabled moves mouse out of Android window when bot is running
Global $g_bDevMode = False ; set to true in mybot.run.au3 if EnableMBRDebug.txt is present in MBR root directory

; Startup
Global $g_bBotLaunchOption_HideAndroid = False ; Start bot and hide Android immediately
Global $g_bBotLaunchOption_Restart = False ; If true previous instance is closed when found by window title, see bot launch options below
Global $g_bBotLaunchOption_Autostart = False ; If true bot will automatically start
Global $g_bBotLaunchOption_NoWatchdog = False ; If true bot will not launch the watchdog process (that automatically restarts crashed bots)
Global $g_bBotLaunchOption_ForceDpiAware = False ; If true bot will run in DPI Aware 100% scaling when possible
Global $g_iBotLaunchOption_Dock = 0 ; If 1 bot will dock Android, 2 dock and slide/hide bot
Global $g_bBotLaunchOption_NoBotSlot = False ; If True, bot slot Mutex are not used in function LockBotSlot
Global $g_iBotLaunchOption_Console = False ; Console option used
Global $g_iBotLaunchOption_Help = False ; If specified, bot just shows command line options and exits
Global $g_asCmdLine[1] = [0] ; Clone of $CmdLine without options, please use instead of $CmdLine
Global Const $g_sWorkingDir = @WorkingDir ; Working Directory at bot launch

; Mutex Handles
Global $g_hMutex_BotTitle = 0
Global $g_ahMutex_Profile[0][2] ; 2-dimensional Array, 0=Profile Name, 1=Profile Mutex
Global $g_ahMutex_SwitchAccountsGroup = [0, 0] ; one row: 0=Switch Accounts Group No., 1=Mutex
Global $g_hMutex_MyBot = 0

; Detected Bot Instance thru watchdog registration
Global $g_BotInstanceCount = 0
Global $g_WatchOnlyClientPID = Default
Global $g_WatchDogLogStatusBar = False

; Arrays to hold stat information
Global $g_aiWeakBaseStats

; Directories to libraries, executables, icons, and CSVs
Global Const $g_sLibPath = @ScriptDir & "\lib" ;lib directory contains dll's
Global Const $g_sLibImageSearchPath = $g_sLibPath & "\ImageSearchDLL.dll" ; ImageSearch library
Global Const $g_sMBRLib = "MyBot.run.dll"
Global $g_bLibMyBotActive = False ; call to MyBot DLL is active
Global Const $g_sLibMyBotPath = $g_sLibPath & "\" & $g_sMBRLib ; main MBR library (containing also ImgLoc, formally MBRFunctions.dll)
Global $g_hLibMyBot = -1 ; handle to MyBot.run.dll library
Global $g_hLibNTDLL = DllOpen("ntdll.dll") ; handle to ntdll.dll, DllClose($g_hLibNTDLL) not required
Global $g_hLibUser32DLL = DllOpen("user32.dll") ; handle to user32.dll, DllClose($g_hLibUser32DLL) not required

Global Const $g_sLibIconPath = $g_sLibPath & "\MBRBOT.dll" ; icon library
Global Const $g_sTHSnipeAttacksPath = @ScriptDir & "\CSV\THSnipe"
Global Const $g_sCSVAttacksPath = @ScriptDir & "\CSV\Attack"
Global Const $g_sIcnMBisland = @ScriptDir & "\Images\bbico.png"
Global Const $g_sIcnBldGold = @ScriptDir & "\Images\gold.png"
Global Const $g_sIcnBldElixir = @ScriptDir & "\Images\elixir.png"
Global Const $g_sIcnBldTrophy = @ScriptDir & "\Images\trophy.png"

; Improve GUI interactions by disabling bot window redraw
Global $g_iRedrawBotWindowMode = 2 ; 0 = disabled, 1 = Redraw always entire bot window, 2 = Redraw only required bot window area (or entire bot if control not specified)

; enumerated Icons 1-based index to IconLib
Global Enum $eIcnArcher = 1, $eIcnDonArcher, $eIcnBalloon, $eIcnDonBalloon, $eIcnBarbarian, $eIcnDonBarbarian, $eBtnTest, $eIcnBuilder, $eIcnCC, $eIcnGUI, _
		$eIcnDark, $eIcnDragon, $eIcnDonDragon, $eIcnDrill, $eIcnElixir, $eIcnCollector, $eIcnFreezeSpell, $eIcnGem, $eIcnGiant, $eIcnDonGiant, _
		$eIcnTrap, $eIcnGoblin, $eIcnDonGoblin, $eIcnGold, $eIcnGolem, $eIcnDonGolem, $eIcnHealer, $eIcnDonHealer, $eIcnHogRider, $eIcnDonHogRider, _
		$eIcnHealSpell, $eIcnInferno, $eIcnJumpSpell, $eIcnLavaHound, $eIcnDonLavaHound, $eIcnLightSpell, $eIcnMinion, $eIcnDonMinion, $eIcnPekka, $eIcnDonPekka, _
		$eIcnTreasury, $eIcnRageSpell, $eIcnTroops, $eIcnHourGlass, $eIcnTH1, $eIcnTH10, $eIcnTrophy, $eIcnValkyrie, $eIcnDonValkyrie, $eIcnWall, $eIcnWallBreaker, _
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
		$eIcnDarkElixirStorage, $eIcnSpellsCost, $eIcnTroopsCost, $eIcnResetButton, $eIcnNewSmartZap, $eIcnTrain, $eIcnAttack, $eIcnDelay, $eIcnReOrder, _
		$eIcn2Arrow, $eIcnArrowLeft, $eIcnArrowRight, $eIcnAndroid, $eHdV04, $eHdV05, $eHdV06, $eHdV07, $eHdV08, $eHdV09, $eHdV10, _
		$eHdV11, $eUnranked, $eBronze, $eSilver, $eGold, $eCrystal, $eMaster, $eChampion, $eTitan, $eLegend, _
		$eWall04, $eWall05, $eWall06, $eWall07, $eWall08, $eWall09, $eWall10, $eWall11, $eIcnPBNotify, $eIcnCCTroops, _
		$eIcnCCSpells, $eIcnSpellsGroup, $eBahasaIND, $eChinese_S, $eChinese_T, $eEnglish, $eFrench, $eGerman, $eItalian, $ePersian, _
		$eRussian, $eSpanish, $eTurkish, $eMissingLangIcon, $eWall12, $ePortuguese, $eIcnDonPoisonSpell, $eIcnDonEarthQuakeSpell, $eIcnDonHasteSpell, $eIcnDonSkeletonSpell, $eVietnamese, $eKorean, $eAzerbaijani, _
		$eArabic, $eIcnBuilderHall, $eIcnClockTower, $eIcnElixirCollectorL5, $eIcnGemMine, $eIcnGoldMineL5

Global $eIcnDonBlank = $eIcnDonBlacklist
Global $eIcnOptions = $eIcnDonBlacklist
Global $eIcnAchievements = $eIcnMain
Global $eIcnStrategies = $eIcnBlank

; Controls bot startup and ongoing operation
Global Const $g_iCollectAtCount = 10 ; Run Collect() after this amount of times before actually collect
Global Enum $eBotNoAction, $eBotStart, $eBotStop, $eBotSearchMode, $eBotClose
Global $g_iBotAction = $eBotNoAction
Global $g_bBotMoveRequested = False ; should the bot be moved
Global $g_bBotShrinkExpandToggleRequested = False ; should the bot be slided
Global $g_bBotGuiModeToggleRequested = False ; GUI is changing
Global $g_bRestart = False
Global $g_bRunState = False
Global $g_bIdleState = False ; bot is in Idle() routine waiting for things to finish
Global $g_bBtnAttackNowPressed = False ; Set to true if any of the 3 attack now buttons are pressed
Global $g_iCommandStop = -1 ; -1 = None, 0 = Halt Attack, 3 = Set from 0 to 3 if army full and training is enabled
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
Global $g_bQuicklyFirstStart = True
Global $g_bQuickAttack = False
Global $g_sTimeBeforeTrain = ""
Global $g_hAttackTimer = 0 ; Timer for knowing when attack starts, in 30 Sec. attack automatically starts and lasts for 3 Minutes
Global $g_iAttackTimerOffset = Default ; Offset of timer to attack really started

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
#Tidy_Off
;--------------------------------------------------------------------------
; Standard Enums and Consts - Attacks, Troops, Spells, Leagues, Loot Types
;--------------------------------------------------------------------------
; Complete list of all deployable/trainable objects
Global Enum $eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, _
		$eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eBowl, $eKing, $eQueen, $eWarden, $eCastle, _
		$eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell, $eArmyCount

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
		1, 1, 5, 1, 2, 5, 4, 14, 20, 25, 10, 6, _
		2, 5, 8, 30, 12, 30, 6]
Global Const $g_aiTroopTrainTime[$eTroopCount] = [ _
		20, 24, 120, 28, 60, 120, 120, 480, 720, 720, 360, 120, _
		36, 90, 180, 600, 360, 600, 120]
; Zero element contains number of levels, elements 1 thru n contain cost of that level troop
Global Const $g_aiTroopCostPerLevel[$eTroopCount][9] = [ _
		[7, 25, 40, 60, 100, 150, 200, 250], _ 					; Barbarian
		[7, 50, 80, 120, 200, 300, 400, 500], _ 				; Archer
		[8, 250, 750, 1250, 1750, 2250, 3000, 3500, 4000], _ 	; Giant
		[7, 25, 40, 60, 80, 100, 150, 200], _ 				 	; Goblin
		[7, 1000, 1500, 2000, 2500, 3000, 3500, 4000], _ 		; WallBreaker
		[7, 2000, 2500, 3000, 3500, 4000, 4500, 5000], _ 	 	; Balloon
		[8, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000], _  ; Wizard
		[5, 5000, 6000, 8000, 10000, 15000], _					; Healer
		[6, 25000, 29000, 33000, 37000, 42000, 46000], _ 		; Dragon
		[7, 28000, 32000, 36000, 40000, 45000, 50000, 55000], _ ; Pekka
		[5, 15000, 16000, 17000, 18000, 19000], _ 			 	; BabyDragon
		[5, 4200, 4800, 5200, 5600, 6000], _  					; Miner
		[7, 6, 7, 8, 9, 10, 11, 12], _ 							; Minion
		[7, 40, 45, 52, 58, 65, 90, 115], _					 	; HogRider
		[6, 70, 100, 130, 160, 190, 220], _ 				 	; Valkyrie
		[7, 450, 525, 600, 675, 750, 825, 900], _ 				; Golem
		[3, 250, 350, 450], _ 								 	; Witch
		[4, 390, 450, 510, 570], _  							; Lavahound
		[3, 130, 150, 170]] 									; Bowler
Global Const $g_aiTroopDonateXP[$eTroopCount] = [1, 1, 5, 1, 2, 5, 4, 14, 20, 25, 10, 5, 2, 5, 8, 30, 12, 30, 6]

; Spells
Global Enum $eSpellLightning, $eSpellHeal, $eSpellRage, $eSpellJump, $eSpellFreeze, $eSpellClone, _
		$eSpellPoison, $eSpellEarthquake, $eSpellHaste, $eSpellSkeleton, $eSpellCount
Global Const $g_asSpellNames[$eSpellCount] = ["Lightning", "Heal", "Rage", "Jump", "Freeze", "Clone", "Poison", "Earthquake", "Haste", "Skeleton"]
Global Const $g_asSpellShortNames[$eSpellCount] = ["LSpell", "HSpell", "RSpell", "JSpell", "FSpell", "CSpell", "PSpell", "ESpell", "HaSpell", "SkSpell"]
Global Const $g_aiSpellSpace[$eSpellCount] = [2, 2, 2, 2, 2, 4, 1, 1, 1, 1]
Global Const $g_aiSpellTrainTime[$eSpellCount] = [360, 360, 360, 360, 360, 720, 180, 180, 180, 180]
; Zero element contains number of levels, elements 1 thru n contain cost of that level spell
Global Const $g_aiSpellCostPerLevel[$eSpellCount][8] = [ _
		[7, 15000, 16500, 18000, 20000, 22000, 24000, 26000], _  ;LightningSpell
		[7, 15000, 16500, 18000, 19000, 21000, 23000, 25000], _  ;HealSpell
		[5, 23000, 25000, 27000, 30000, 33000], _     			 ;RageSpell
		[3, 23000, 27000, 31000], _        						 ;JumpSpell
		[6, 23000, 26000, 29000, 31000, 33000, 35000], _ 		 ;FreezeSpell
		[5, 38000, 39000, 41000, 43000, 45000], _				 ;CloneSpell
		[5, 95, 110, 125, 140, 155], _         					 ;PoisonSpell
		[4, 125, 140, 160, 180], _    							 ;EarthquakeSpell
		[4, 80, 85, 90, 95], _									 ;HasteSpell
		[4, 110, 120, 130, 140]] 								 ;SkeletonSpell
Global Const $g_aiSpellDonateXP[$eSpellCount] = [10, 10, 10, 10, 10, 0, 5, 5, 5, 5]

; Hero Bitmaped Values
Global Enum $eHeroNone = 0, $eHeroKing = 1, $eHeroQueen = 2, $eHeroWarden = 4

; Hero standard values
Global Enum $eHeroBarbarianKing, $eHeroArcherQueen, $eHeroGrandWarden, $eHeroCount
Global Const $g_asHeroNames[$eHeroCount] = ["Barbarian King", "Archer Queen", "Grand Warden"]
Global Const $g_asHeroShortNames[$eHeroCount] = ["King", "Queen", "Warden"]
Global $g_aiHeroBoost[$eHeroCount] = ["1970/01/01 00:00:00", "1970/01/01 00:00:00", "1970/01/01 00:00:00"] ; Use Epoch as standard values :)

; Leagues
Global Enum $eLeagueUnranked, $eLeagueBronze, $eLeagueSilver, $eLeagueGold, $eLeagueCrystal, $eLeagueMaster, $eLeagueChampion, $eLeagueTitan, $eLeagueLegend, $eLeagueCount
Global Const $g_asLeagueDetails[22][5] = [ _
		["0", "Bronze III", "0", "B3", "400"], ["1000", "Bronze II", "0", "B2", "500"], ["1300", "Bronze I", "0", "B1", "600"], _
		["2600", "Silver III", "0", "S3", "800"], ["3700", "Silver II", "0", "S2", "1000"], ["4800", "Silver I", "0", "S1", "1200"], _
		["10000", "Gold III", "0", "G3", "1400"], ["13500", "Gold II", "0", "G2", "1600"], ["17000", "Gold I", "0", "G1", "1800"], _
		["40000", "Crystal III", "120", "c3", "2000"], ["55000", "Crystal II", "220", "c2", "2200"], ["70000", "Crystal I", "320", "c1", "2400"], _
		["110000", "Master III", "560", "M3", "2600"], ["135000", "Master II", "740", "M2", "2800"], ["160000", "Master I", "920", "M1", "3000"], _
		["200000", "Champion III", "1220", "C3", "3200"], ["225000", "Champion II", "1400", "C2", "3500"], ["250000", "Champion I", "1580", "C1", "3800"], _
		["280000", "Titan III", "1880", "T3", "4100"], ["300000", "Titan II", "2060", "T2", "4400"], ["320000", "Titan I", "2240", "T1", "4700"], _
		["340000", "Legend", "2400", "LE", "5000"]]

; Loot types
Global Enum $eLootGold, $eLootElixir, $eLootDarkElixir, $eLootTrophy, $eLootCount

;Loot types builder base
Global Enum $eLootGoldBB, $eLootElixirBB, $eLootTrophyBB, $eLootCountBB

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
Func TroopIndexLookup(Const $sName, Const $sSource = "")
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

	SetDebugLog("TroopIndexLookup() Error: Index for troop name '" & $sName & "' not found" & (($sSource) ? (" (" & $sSource & ").") : (".")))
	Return -1
EndFunc   ;==>TroopIndexLookup
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
EndFunc   ;==>GetTroopName
;--------------------------------------------------------------------------
; END: GetTroopName()
;--------------------------------------------------------------------------
#Tidy_On
#EndRegion Standard Enums and Consts - Attacks, Troops, Spells, Leagues, Loot Types

#Region GUI Variables
#Tidy_Off
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
Global $g_bChkTrap = True, $g_bChkCollect = True, $g_bChkTombstones = True, $g_bChkCleanYard = False, $g_bChkGemsBox = False
Global $g_bChkTreasuryCollect = False
Global $g_iTxtTreasuryGold = 0
Global $g_iTxtTreasuryElixir = 0
Global $g_iTxtTreasuryDark = 0

Global $g_bChkCollectBuilderBase = False, $g_bChkStartClockTowerBoost = False, $g_bChkCTBoostBlderBz = False

; <><><><> Village / Donate - Request <><><><>
Global $g_bRequestTroopsEnable = False
Global $g_sRequestTroopsText = ""
Global $g_abRequestCCHours[24] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]

; <><><><> Village / Donate - Donate <><><><>
Global $g_bChkDonate = True
Global Enum $eCustomA = $eTroopCount, $eCustomB = $eTroopCount + 1
Global Enum $eCustomC = $eTroopCount + 2, $eCustomD = $eTroopCount + 3
Global Const $g_iCustomDonateConfigs = 4
Global $g_abChkDonateTroop[$eTroopCount + $g_iCustomDonateConfigs] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_abChkDonateAllTroop[$eTroopCount + $g_iCustomDonateConfigs] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_asTxtDonateTroop[$eTroopCount + $g_iCustomDonateConfigs] = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""] ; array of pipe-delimited list of strings to match to a request string
Global $g_asTxtBlacklistTroop[$eTroopCount + $g_iCustomDonateConfigs] = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""] ; array of pipe-delimited list of strings to prevent a match to a request string

Global $g_abChkDonateSpell[$eSpellCount] = [False, False, False, False, False, False, False, False, False, False] ; element $eSpellClone (5) is unused
Global $g_abChkDonateAllSpell[$eSpellCount] = [False, False, False, False, False, False, False, False, False, False] ; element $eSpellClone (5) is unused
Global $g_asTxtDonateSpell[$eSpellCount] = ["", "", "", "", "", "", "", "", "", ""] ; element $eSpellClone (5) is unused
Global $g_asTxtBlacklistSpell[$eSpellCount] = ["", "", "", "", "", "", "", "", "", ""] ; element $eSpellClone (5) is unused

Global $g_aiDonateCustomTrpNumA[3][2] = [[0, 0], [0, 0], [0, 0]], $g_aiDonateCustomTrpNumB[3][2] = [[0, 0], [0, 0], [0, 0]]
Global $g_aiDonateCustomTrpNumC[3][2] = [[0, 0], [0, 0], [0, 0]], $g_aiDonateCustomTrpNumD[3][2] = [[0, 0], [0, 0], [0, 0]]

Global $g_bChkExtraAlphabets = False ; extra alphabets
Global $g_bChkExtraChinese = False ; extra Chinese alphabets
Global $g_bChkExtraKorean = False ; extra Korean alphabets
Global $g_bChkExtraPersian = False ; extra Persian alphabets
Global $g_sTxtGeneralBlacklist = ""

; <><><><> Village / Donate - Schedule <><><><>
Global $g_bDonateHoursEnable = False
Global $g_abDonateHours[24] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
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
Global $g_aiPicUpgradeStatus[$g_iUpgradeSlots] = [$eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, _
		$eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops, $eIcnTroops]
Global $g_abBuildingUpgradeEnable[$g_iUpgradeSlots] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_avBuildingUpgrades[$g_iUpgradeSlots][8] ; Fill empty array [8] to store upgrade data
For $i = 0 To $g_iUpgradeSlots - 1
	$g_avBuildingUpgrades[$i][0] = -1 ; position x
	$g_avBuildingUpgrades[$i][1] = -1 ; position y
	$g_avBuildingUpgrades[$i][2] = -1 ; upgrade value
	$g_avBuildingUpgrades[$i][3] = "" ; string loot type required
	$g_avBuildingUpgrades[$i][4] = "" ; string Bldg Name
	$g_avBuildingUpgrades[$i][5] = "" ; string Bldg level
	$g_avBuildingUpgrades[$i][6] = "" ; string upgrade time
	$g_avBuildingUpgrades[$i][7] = "" ; string upgrade end date/time (_datediff compatible)
Next
Global $g_iUpgradeMinGold = 100000, $g_iUpgradeMinElixir = 100000, $g_iUpgradeMinDark = 3000
Global $g_abUpgradeRepeatEnable[$g_iUpgradeSlots] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False]
; Walls
Global $g_bAutoUpgradeWallsEnable = 0
Global $g_iUpgradeWallMinGold = 0, $g_iUpgradeWallMinElixir = 0
Global $g_iUpgradeWallLootType = 0, $g_bUpgradeWallSaveBuilder = False
Global $g_iCmbUpgradeWallsLevel = 6
Global $g_aiWallsCurrentCount[13] = [-1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; elements 0 to 3 are not referenced
Global $g_aiLastGoodWallPos[2] = [-1, -1]

; Auto Upgrade
Global $g_iChkAutoUpgrade = 0
Global $g_iChkIgnoreTH = 0, $g_iChkIgnoreKing = 0, $g_iChkIgnoreQueen = 0, $g_iChkIgnoreWarden = 0, $g_iChkIgnoreCC = 0, $g_iChkIgnoreLab = 0
Global $g_iChkIgnoreBarrack = 0, $g_iChkIgnoreDBarrack = 0, $g_iChkIgnoreFactory = 0, $g_iChkIgnoreDFactory = 0
Global $g_iChkIgnoreGColl = 0, $g_iChkIgnoreEColl = 0, $g_iChkIgnoreDColl = 0
Global $g_iTxtSmartMinGold = 150000, $g_iTxtSmartMinElixir = 150000, $g_iTxtSmartMinDark = 1500
Global $g_iChkUpgradesToIgnore[13] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iChkResourcesToIgnore[3] = [0, 0, 0]
Global $g_iCurrentLineOffset = 0, $g_iNextLineOffset = 0
Global $g_aUpgradeNameLevel ; [Nb of elements in Array, Name, Level]
Global $g_aUpgradeResourceCostDuration[3] = ["", "", ""] ; Resource, Cost, Duration

Global $g_sBldgText, $g_sBldgLevel
Global $g_aUpgradeName[3] = ["", "", ""]
Global $g_iUpgradeCost
Global $g_sUpgradeResource = 0
Global $g_sUpgradeDuration

; Builder Base
Global $g_iChkBBSuggestedUpgrades = 0, $g_iChkBBSuggestedUpgradesIgnoreGold = 0, $g_iChkBBSuggestedUpgradesIgnoreElixir = 0, $g_iChkBBSuggestedUpgradesIgnoreHall = 0
Global $g_iChkPlacingNewBuildings = 0

Global $g_iQuickMISX = 0, $g_iQuickMISY = 0

; <><><><> Village / Achievements <><><><>
Global $g_iUnbrkMode = 0, $g_iUnbrkWait = 5
Global $g_iUnbrkMinGold = 50000, $g_iUnbrkMinElixir = 50000, $g_iUnbrkMaxGold = 600000, $g_iUnbrkMaxElixir = 600000, $g_iUnbrkMinDark = 5000, $g_iUnbrkMaxDark = 6000

; <><><><> Village / Notify <><><><>
Global Const $g_sCurlPath = $g_sLibPath & "\curl\curl.exe" ; Curl used on PushBullet
Global $g_bNotifyForced = False
Global $g_sTGChatID = ""
Global $g_bPBRequestScreenshot = False
Global $g_bPBRequestScreenshotHD = False
Global $g_bPBRequestBuilderInfo = False
Global $g_bPBRequestShieldInfo = False
Global $g_bTGRequestScreenshot = False
Global $g_bTGRequestScreenshotHD = False
Global $g_bTGRequestBuilderInfo = False
Global $g_bTGRequestShieldInfo = False
Global $g_iTGLastRemote = 0
Global $g_sTGLast_UID = ""
Global $g_sTGLastMessage = ""
Global $g_sAttackFile = ""

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
		$g_bNotifyAlertBAN = False, $g_bNotifyAlertBOTUpdate = False, $g_bNotifyAlertSmartWaitTime = False
;Schedule
Global $g_bNotifyScheduleHoursEnable = False, $g_bNotifyScheduleWeekDaysEnable = False
Global $g_abNotifyScheduleHours[24] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_abNotifyScheduleWeekDays[7] = [False, False, False, False, False, False, False]

; <><><><> Attack Plan / Train Army / Troops/Spells <><><><>
Global $g_bQuickTrainEnable = False
Global $g_bQuickTrainArmy[3] = [True, False, False]
Global $g_aiArmyCompTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiArmyCompSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiTrainArmyTroopLevel[$eTroopCount] = [1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiTrainArmySpellLevel[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iTrainArmyFullTroopPct = 100
Global $g_bTotalCampForced = False, $g_iTotalCampForcedValue = 200
Global $g_bForceBrewSpells = False
Global $g_iTotalSpellValue = 0

; <><><><> Attack Plan / Train Army / Boost <><><><>
Global $g_iCmbBoostBarracks = 0, $g_iCmbBoostSpellFactory = 0, $g_iCmbBoostBarbarianKing = 0, $g_iCmbBoostArcherQueen = 0, $g_iCmbBoostWarden = 0
Global $g_abBoostBarracksHours[24] = [True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True]

; <><><><> Attack Plan / Train Army / Train Order <><><><>
Global Const $g_aiTroopOrderIcon[21] = [ _
		$eIcnOptions, $eIcnBarbarian, $eIcnArcher, $eIcnGiant, $eIcnGoblin, $eIcnWallBreaker, $eIcnBalloon, _
		$eIcnWizard, $eIcnHealer, $eIcnDragon, $eIcnPekka, $eIcnBabyDragon, $eIcnMiner, $eIcnMinion, _
		$eIcnHogRider, $eIcnValkyrie, $eIcnGolem, $eIcnWitch, $eIcnLavaHound, $eIcnBowler]
Global $g_bCustomTrainOrderEnable = False, $g_aiCmbCustomTrainOrder[$eTroopCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

Global $g_aiTrainOrder[$eTroopCount] = [ _
		$eTroopArcher, $eTroopGiant, $eTroopWallBreaker, $eTroopBarbarian, $eTroopGoblin, $eTroopHealer, _
		$eTroopPekka, $eTroopBalloon, $eTroopWizard, $eTroopDragon, $eTroopBabyDragon, $eTroopMiner, _
		$eTroopMinion, $eTroopHogRider, $eTroopValkyrie, $eTroopGolem, $eTroopWitch, $eTroopLavaHound, _
		$eTroopBowler]

; Spells Brew Order
Global Const $g_aiSpellsOrderIcon[12] = [ _
		$eIcnOptions, $eIcnLightSpell, $eIcnHealSpell,$eIcnRageSpell, $eIcnJumpSpell, $eIcnFreezeSpell, $eIcnCloneSpell,  _
		$eIcnPoisonSpell, $eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnSkeletonSpell]

Global $g_bCustomBrewOrderEnable = False, $g_aiCmbCustomBrewOrder[$eSpellCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

Global $g_aiBrewOrder[$eSpellCount] = [ _
		$eSpellLightning, $eSpellHeal, $eSpellRage, $eSpellJump, $eSpellFreeze, $eSpellClone, _
		$eSpellPoison, $eSpellEarthquake, $eSpellHaste, $eSpellSkeleton]

; Drop Order Troops
Global Enum $eTroopBarbarianS, $eTroopArcherS, $eTroopGiantS, $eTroopGoblinS, $eTroopWallBreakerS, $eTroopBalloonS, _
		$eTroopWizardS, $eTroopHealerS, $eTroopDragonS, $eTroopPekkaS, $eTroopBabyDragonS, $eTroopMinerS, _
		$eTroopMinionS, $eTroopHogRiderS, $eTroopValkyrieS, $eTroopGolemS, $eTroopWitchS, _
		$eTroopLavaHoundS, $eTroopBowlerS, $eHeroeS, $eCCS, $eDropOrderCount
Global Const $g_asDropOrderNames[$eDropOrderCount] = [ _
		"Barbarians", "Archers", "Giants", "Goblins", "Wall Breakers", "Balloons", "Wizards", "Healers", "Dragons", "Pekkas", "Baby Dragons", "Miners", _
		"Minions", "Hog Riders", "Valkyries", "Golems", "Witches", "Lava Hounds", "Bowlers", _
		"Clan Castle", "Heroes"]

Global Const $g_aiDropOrderIcon[23] = [ _
		$eIcnOptions, $eIcnBarbarian, $eIcnArcher, $eIcnGiant, $eIcnGoblin, $eIcnWallBreaker, $eIcnBalloon, _
		$eIcnWizard, $eIcnHealer, $eIcnDragon, $eIcnPekka, $eIcnBabyDragon, $eIcnMiner, $eIcnMinion, _
		$eIcnHogRider, $eIcnValkyrie, $eIcnGolem, $eIcnWitch, $eIcnLavaHound, $eIcnBowler, $eIcnCC, $eIcnHeroes]
Global $g_bCustomDropOrderEnable = False, $g_aiCmbCustomDropOrder[$eDropOrderCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

Global $g_aiDropOrder[$eDropOrderCount] = [ _
		$eTroopBarbarianS, $eTroopArcherS, $eTroopGiantS, $eTroopGoblinS, $eTroopWallBreakerS, $eTroopBalloonS, _
		$eTroopWizardS, $eTroopHealerS, $eTroopDragonS, $eTroopPekkaS, $eTroopBabyDragonS, $eTroopMinerS, $eTroopMinionS, _
		$eTroopHogRiderS, $eTroopValkyrieS, $eTroopGolemS, $eTroopWitchS, $eTroopLavaHoundS, $eTroopBowlerS, _
		$eHeroeS, $eCCS]

; <><><><> Attack Plan / Train Army / Options <><><><>
Global $g_bCloseWhileTrainingEnable = True, $g_bCloseWithoutShield = False, $g_bCloseEmulator = False, $g_bSuspendComputer = False, $g_bCloseRandom = False, _
		$g_bCloseExactTime = False, $g_bCloseRandomTime = True, $g_iCloseRandomTimePercent = 10, $g_iCloseMinimumTime = 2
Global $g_iTrainClickDelay = 40
Global $g_bTrainAddRandomDelayEnable = False, $g_iTrainAddRandomDelayMin = 5, $g_iTrainAddRandomDelayMax = 60

; <><><><> Attack Plan / Search & Attack / {Common Across DeadBase, ActiveBase, TH Snipe, Bully} <><><><>
Global $g_abAttackTypeEnable[$g_iModeCount + 3] = [True, False, False, -1, False, -1] ; $DB, $LB, $TS, $MA, $TB, $DT - $MA and $DT unused here
; Search - Start Search If
Global $g_abSearchSearchesEnable[$g_iModeCount] = [True, False, False], $g_aiSearchSearchesMin[$g_iModeCount] = [0, 0, 0], $g_aiSearchSearchesMax[$g_iModeCount] = [0, 0, 0] ; Search count limit
Global $g_abSearchTropiesEnable[$g_iModeCount] = [False, False, False], $g_aiSearchTrophiesMin[$g_iModeCount] = [0, 0, 0], $g_aiSearchTrophiesMax[$g_iModeCount] = [0, 0, 0] ; Trophy limit
Global $g_abSearchCampsEnable[$g_iModeCount] = [False, False, False], $g_aiSearchCampsPct[$g_iModeCount] = [0, 0, 0] ; Camp limit
Global $g_aiSearchHeroWaitEnable[$g_iModeCount] = [0, 0, 0] ; Heroes wait status for attack; these are 3 bools (one for each hero) bitmapped onto an integer
Global $g_abSearchSpellsWaitEnable[$g_iModeCount] = [False, False, False]
Global $g_abSearchCastleSpellsWaitEnable[$g_iModeCount] = [False, False, False], $g_aiSearchCastleSpellsWaitRegular[$g_iModeCount] = [0, 0, 0], _
		$g_aiSearchCastleSpellsWaitDark[$g_iModeCount] = [0, 0, 0]
Global $g_abSearchCastleTroopsWaitEnable[$g_iModeCount] = [False, False, False]
Global $g_aiSearchNotWaitHeroesEnable[$g_iModeCount] = [0, 0, 0]
Global $g_iSearchNotWaitHeroesEnable = -1
; Search - Filters
Global $g_aiFilterMeetGE[$g_iModeCount] = [0, 0, 0], $g_aiFilterMinGold[$g_iModeCount] = [0, 0, 0], $g_aiFilterMinElixir[$g_iModeCount] = [0, 0, 0], _
		$g_aiFilterMinGoldPlusElixir[$g_iModeCount] = [0, 0, 0]
Global $g_abFilterMeetDEEnable[$g_iModeCount] = [False, False, False], $g_aiFilterMeetDEMin[$g_iModeCount] = [0, 0, 0]
Global $g_abFilterMeetTrophyEnable[$g_iModeCount] = [False, False, False], $g_aiFilterMeetTrophyMin[$g_iModeCount] = [0, 0, 0], $g_aiFilterMeetTrophyMax[$g_iModeCount] = [99, 99, 99]
Global $g_abFilterMeetTH[$g_iModeCount] = [False, False, False], $g_aiFilterMeetTHMin[$g_iModeCount] = [0, 0, 0]
Global $g_abFilterMeetTHOutsideEnable[$g_iModeCount] = [False, False, False]
Global $g_abFilterMaxMortarEnable[$g_iModeCount] = [False, False, False], $g_abFilterMaxWizTowerEnable[$g_iModeCount] = [False, False, False], _
		$g_abFilterMaxAirDefenseEnable[$g_iModeCount] = [False, False, False], $g_abFilterMaxXBowEnable[$g_iModeCount] = [False, False, False], _
		$g_abFilterMaxInfernoEnable[$g_iModeCount] = [False, False, False], $g_abFilterMaxEagleEnable[$g_iModeCount] = [False, False, False]
Global $g_aiFilterMaxMortarLevel[$g_iModeCount] = [5, 5, 0], $g_aiFilterMaxWizTowerLevel[$g_iModeCount] = [4, 4, 0], $g_aiFilterMaxAirDefenseLevel[$g_iModeCount] = [0, 0, 0], _
		$g_aiFilterMaxXBowLevel[$g_iModeCount] = [0, 0, 0], $g_aiFilterMaxInfernoLevel[$g_iModeCount] = [0, 0, 0], $g_aiFilterMaxEagleLevel[$g_iModeCount] = [0, 0, 0]
Global $g_abFilterMeetOneConditionEnable[$g_iModeCount] = [False, False, False]
; Attack
Global $g_iSlotsGiants = 1
Global $g_aiAttackAlgorithm[$g_iModeCount] = [0, 0, 0], $g_aiAttackTroopSelection[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0], $g_aiAttackUseHeroes[$g_iModeCount] = [0, 0, 0], _
		$g_abAttackDropCC[$g_iModeCount] = [0, 0, 0]
Global $g_abAttackUseLightSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseHealSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseRageSpell[$g_iModeCount] = [0, 0, 0], _
		$g_abAttackUseJumpSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseFreezeSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseCloneSpell[$g_iModeCount] = [0, 0, 0], _
		$g_abAttackUsePoisonSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseEarthquakeSpell[$g_iModeCount] = [0, 0, 0], $g_abAttackUseHasteSpell[$g_iModeCount] = [0, 0, 0], _
		$g_abAttackUseSkeletonSpell[$g_iModeCount] = [0, 0, 0]
Global $g_bTHSnipeBeforeEnable[$g_iModeCount] = [False, False, False], $g_iTHSnipeBeforeTiles[$g_iModeCount] = [0, 0, 0], $g_iTHSnipeBeforeScript[$g_iModeCount] = [0, 0, 0]
; Attack - Standard
Global $g_aiAttackStdDropOrder[$g_iModeCount + 1] = [0, 0, 0, 0], $g_aiAttackStdDropSides[$g_iModeCount + 1] = [3, 3, 0, 1], $g_aiAttackStdUnitDelay[$g_iModeCount + 1] = [4, 4, 0, 4], _
		$g_aiAttackStdWaveDelay[$g_iModeCount + 1] = [4, 4, 0, 4], $g_abAttackStdRandomizeDelay[$g_iModeCount + 1] = [True, True, False, True], _
		$g_abAttackStdSmartAttack[$g_iModeCount + 3] = [True, True, False, True, False, False], $g_aiAttackStdSmartDeploy[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0]
Global $g_abAttackStdSmartNearCollectors[$g_iModeCount + 3][3] = [[False, False, False], [False, False, False], [False, False, False], _
		[False, False, False], [False, False, False], [False, False, False]]
; Attack - Scripted
Global $g_aiAttackScrRedlineRoutine[$g_iModeCount + 3] = [$REDLINE_IMGLOC_RAW, $REDLINE_IMGLOC_RAW, 0, 0, 0, 0]
Global $g_aiAttackScrDroplineEdge[$g_iModeCount + 3] = [$DROPLINE_EDGE_FIRST, $DROPLINE_EDGE_FIRST, 0, 0, 0, 0]
Global $g_sAttackScrScriptName[$g_iModeCount] = ["Barch four fingers", "Barch four fingers", ""]

; End Battle
Global $g_abStopAtkNoLoot1Enable[$g_iModeCount] = [True, True, False], $g_aiStopAtkNoLoot1Time[$g_iModeCount] = [0, 0, 0], _
		$g_abStopAtkNoLoot2Enable[$g_iModeCount] = [False, False, False], $g_aiStopAtkNoLoot2Time[$g_iModeCount] = [0, 0, 0]
Global $g_aiStopAtkNoLoot2MinGold[$g_iModeCount] = [0, 0, 0], $g_aiStopAtkNoLoot2MinElixir[$g_iModeCount] = [0, 0, 0], $g_aiStopAtkNoLoot2MinDark[$g_iModeCount] = [0, 0, 0]
Global $g_abStopAtkNoResources[$g_iModeCount] = [False, False, False], $g_abStopAtkOneStar[$g_iModeCount] = [False, False, False], $g_abStopAtkTwoStars[$g_iModeCount] = [False, False, False]
Global $g_abStopAtkPctHigherEnable[$g_iModeCount] = [False, False, False], $g_aiStopAtkPctHigherAmt[$g_iModeCount] = [0, 0, 0]
Global $g_abStopAtkPctNoChangeEnable[$g_iModeCount] = [False, False, False], $g_aiStopAtkPctNoChangeTime[$g_iModeCount] = [0, 0, 0]

; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Standard <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Scripted <><><><>
; <<< nothing here - all in common Search & Attack grouping >>>

; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Milking <><><><>
Global $g_iMilkAttackType = 1, $g_aiMilkFarmElixirParam[9] = [-1, -1, -1, -1, -1, -1, 2, 2, 2]
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
Global $g_iActivateQueen = 0, $g_iActivateKing = 0, $g_iActivateWarden = 0
Global $g_iDelayActivateQueen = 9000, $g_iDelayActivateKing = 9000, $g_iDelayActivateWarden = 10000
Global $g_aHeroesTimerActivation[$eHeroCount] = [0, 0, 0] ; $eHeroBarbarianKing | $eHeroArcherQueen | $eHeroGrandWarden
Global $g_bAttackPlannerEnable = False, $g_bAttackPlannerCloseCoC = False, $g_bAttackPlannerCloseAll = False, $g_bAttackPlannerSuspendComputer = False, $g_bAttackPlannerRandomEnable = False, _
		$g_iAttackPlannerRandomTime = 0, $g_iAttackPlannerRandomTime = 0, $g_bAttackPlannerDayLimit = False, $g_iAttackPlannerDayMin = 12, $g_iAttackPlannerDayMax = 15
Global $g_abPlannedAttackWeekDays[7] = [True, True, True, True, True, True, True]
Global $g_abPlannedattackHours[24] = [True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True]
Global $g_bPlannedDropCCHoursEnable = False, $g_bUseCCBalanced = False, $g_iCCDonated = 0, $g_iCCReceived = 0
Global $g_abPlannedDropCCHours[24] = [True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True]

; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
Global $g_bSmartZapEnable = False, $g_bEarthQuakeZap = False, $g_bNoobZap = False, $g_bSmartZapDB = True, $g_bSmartZapSaveHeroes = True, _
		$g_bSmartZapFTW = False, $g_iSmartZapMinDE = 350, $g_iSmartZapExpectedDE = 320, $g_bDebugSmartZap = False

; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
Global $g_bShareAttackEnable = 0, $g_iShareMinGold = 300000, $g_iShareMinElixir = 300000, $g_iShareMinDark = 0, $g_sShareMessage = "Nice|Good|Thanks|Wowwww", _
		$g_bTakeLootSnapShot = True, $g_bScreenshotLootInfo = False, $g_bShareAttackEnableNow = False

; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
Global $g_bDropTrophyEnable = False, $g_iDropTrophyMax = 1200, $g_iDropTrophyMin = 800, $g_bDropTrophyUseHeroes = False, $g_iDropTrophyHeroesPriority = 0, _
		$g_bDropTrophyAtkDead = 0, $g_iDropTrophyArmyMinPct = 70

; <><><><> Attack Plan / Strategies <><><><>
; <<< nothing here >>>

; <><><><> Bot / Options <><><><>
Global $g_sLanguage = "English"
Global $g_bDisableSplash = False ; Splash screen disabled = 1
Global $g_bMyBotDance = False  ; Dancing MyBot splash screen
Global $g_bCheckVersion = True
Global $g_bDeleteLogs = True, $g_iDeleteLogsDays = 2, $g_bDeleteTemp = True, $g_iDeleteTempDays = 2, $g_bDeleteLoots = True, $g_iDeleteLootsDays = 2
Global $g_bAutoStart = False, $g_iAutoStartDelay = 10
Global $b_iAutoRestartDelay = 0 ; Automatically restart bot after so many Seconds, 0 = disabled
Global $g_bCheckGameLanguage = True
Global $g_bAutoUpdateGame = False
Global $g_bAutoAlignEnable = False, $g_iAutoAlignPosition = "EMBED", $g_iAutoAlignOffsetX = "", $g_iAutoAlignOffsetY = ""
Global $g_bUpdatingWhenMinimized = True ; Alternative Minimize Window routine for bot that enables window updates when minimized
Global $g_bHideWhenMinimized = False ; Hide bot window in taskbar when minimized
Global $g_bUseRandomClick = False
Global $g_bScreenshotPNGFormat = False, $g_bScreenshotHideName = True
Global $g_iAnotherDeviceWaitTime = 120
Global $g_bForceSinglePBLogoff = 0, $g_iSinglePBForcedLogoffTime = 18, $g_iSinglePBForcedEarlyExitTime = 15
Global $g_bAutoResumeEnable = 0, $g_iAutoResumeTime = 5
Global $g_bDisableNotifications = False
Global $g_bForceClanCastleDetection = 0

; <><><><> Bot / Android <><><><>
; <<< nothing here >>>

; <><><><> Bot / Debug <><><><>
; <<< nothing here >>>

; <><><><> Bot / Profiles <><><><>
Global $g_iCmbSwitchAcc = 0 ; Group switch accounts
Global $g_bChkGooglePlay = True, $g_bChkSuperCellID = False, $g_bChkSharedPrefs = False ; Accounts switch mode
Global $g_bChkSwitchAcc = False, $g_bChkSmartSwitch = False, $g_bDonateLikeCrazy = False, $g_iTotalAcc = -1, $g_iTrainTimeToSkip = 0
Global $g_bInitiateSwitchAcc = True, $g_bReMatchAcc = False, $g_bWaitForCCTroopSpell = False, $g_iNextAccount, $g_iCurAccount
Global $g_abAccountNo[8], $g_asProfileName[8], $g_abDonateOnly[8]
Global $g_aiAttackedCountSwitch[8], $g_iActiveSwitchCounter = 0, $g_iDonateSwitchCounter = 0
Global $g_aiRemainTrainTime[8], $g_aiTimerStart[8], $g_abPBActive[8]
Global $g_aiGoldTotalAcc[8], $g_aiElixirTotalAcc[8], $g_aiDarkTotalAcc[8], $g_aiTrophyLootAcc[8], $g_aiSkippedVillageCountAcc[8], $g_aiAttackedCountAcc[8] ; Total Gain
Global $g_aiGoldCurrentAcc[8], $g_aiElixirCurrentAcc[8], $g_aiDarkCurrentAcc[8], $g_aiTrophyCurrentAcc[8], $g_aiFreeBuilderCountAcc[8], $g_aiTotalBuilderCountAcc[8], $g_aiGemAmountAcc[8], $g_aiPersonalBreak[8] ; village report

; <><><><> Bot / Stats <><><><>
; <<< nothing here >>>

;--------------------------------------------------------------------------
; END: Variables to hold current GUI setting values
;--------------------------------------------------------------------------
#Tidy_On
#EndRegion GUI Variables

; Android & MBR window
Global Const $g_WIN_POS_DEFAULT = 0xFFFFFFF
Global $g_iFrmBotPosX = $g_WIN_POS_DEFAULT ; Position X of the GUI
Global $g_iFrmBotPosY = $g_WIN_POS_DEFAULT ; Position Y of the GUI
Global $g_iAndroidPosX = $g_WIN_POS_DEFAULT ; Position X of the Android Window (undocked)
Global $g_iAndroidPosY = $g_WIN_POS_DEFAULT ; Position Y of the Android Window (undocked)
Global $g_iFrmBotDockedPosX = $g_WIN_POS_DEFAULT ; Position X of the docked GUI
Global $g_iFrmBotDockedPosY = $g_WIN_POS_DEFAULT ; Position Y of the docked GUI
Global $g_iFrmBotAddH = 0 ; Additional Height of GUI (e.g. when Android docked)
Global $g_bIsHidden = False ; If hidden or not
Global $g_aiBSpos[2] ; Inside Android window positions relative to the screen, [x,y]
Global $g_aiBSrpos[2] ; Inside Android window positions relative to the window, [x,y]
Global $g_bGUIControlDisabled = False

; Languages
Global Const $g_sDirLanguages = @ScriptDir & "\Languages\"
Global Const $g_sDefaultLanguage = "English"

; Notify
Global Const $g_sNotifyVersion = "Revamp v1.5.8"
Global Const $g_iPBRemoteControlInterval = 60000 ; 60 secs
Global Const $g_iPBDeleteOldPushesInterval = 1800000 ; 30 mins
Global $g_bNotifyDeleteAllPushesNow = False
Global $g_sLootFileName = ""

; Stats
Global $g_iFreeBuilderCount = 0, $g_iTotalBuilderCount = 0, $g_iGemAmount = 0 ; builder and gem amounts
Global $g_iFreeBuilderCountBB = 0, $g_iTotalBuilderCountBB = 0
Global $g_iTestFreeBuilderCount = -1 ; used for test cases, -1 = disabled
Global $g_iStatsStartedWith[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsTotalGain[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsLastAttack[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsBonusLast[$eLootCount] = [0, 0, 0, 0]
Global $g_iSkippedVillageCount = 0, $g_iDroppedTrophyCount = 0 ; skipped village and dropped trophy counts
Global $g_iCostGoldWall = 0, $g_iCostElixirWall = 0, $g_iCostGoldBuilding = 0, $g_iCostElixirBuilding = 0, $g_iCostDElixirHero = 0 ; wall, building and hero upgrade costs
Global $g_iNbrOfWallsUpped = 0, $g_iNbrOfWallsUppedGold = 0, $g_iNbrOfWallsUppedElixir = 0
Global $g_iNbrOfBuildingsUppedGold = 0, $g_iNbrOfBuildingsUppedElixir = 0, $g_iNbrOfHeroesUpped = 0 ; number of wall, building, hero upgrades with gold, elixir, delixir
Global $g_iSearchCost = 0, $g_iTrainCostElixir = 0, $g_iTrainCostDElixir = 0 ; search and train troops cost
Global $g_iNbrOfOoS = 0 ; number of Out of Sync occurred
Global $g_iNbrOfTHSnipeFails = 0, $g_iNbrOfTHSnipeSuccess = 0 ; number of fails and success while TH Sniping
Global $g_iGoldFromMines = 0, $g_iElixirFromCollectors = 0, $g_iDElixirFromDrills = 0 ; number of resources gain by collecting mines, collectors, drills
Global $g_aiAttackedVillageCount[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0] ; number of attack villages for DB, LB, TB, TS
Global $g_aiTotalGoldGain[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0], $g_aiTotalElixirGain[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0], $g_aiTotalDarkGain[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0], _
		$g_aiTotalTrophyGain[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0] ; total resource gains for DB, LB, TB, TS
Global $g_aiNbrOfDetectedMines[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0], $g_aiNbrOfDetectedCollectors[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0], $g_aiNbrOfDetectedDrills[$g_iModeCount + 3] = [0, 0, 0, 0, 0, 0] ; number of mines, collectors, drills detected for DB, LB, TB
Global $g_aiAttackedCount = 0 ; convert to global from UpdateStats to enable daily attack limits
Global $g_iSearchCount = 0 ;Number of searches
Global Const $g_iMaxTrainSkip = 40
Global $g_iActualTrainSkip = 0
Global $g_iSmartZapGain = 0, $g_iNumEQSpellsUsed = 0, $g_iNumLSpellsUsed = 0 ; smart zap

Global $g_bMainWindowOk = False ; Updated in IsMainPage() when main page found or not

; My village
Global $g_aiCurrentLoot[$eLootCount] = [0, 0, 0, 0] ; current stats
Global $g_iTownHallLevel = 0 ; Level of user townhall
Global $g_aiTownHallPos[2] = [-1, -1] ;Position of TownHall
Global $g_aiKingAltarPos[2] = [-1, -1] ; position Kings Altar
Global $g_aiQueenAltarPos[2] = [-1, -1] ; position Queens Altar
Global $g_aiWardenAltarPos[2] = [-1, -1] ; position Grand Warden Altar
Global $g_aiLaboratoryPos[2] = [-1, -1] ; Position of laboratory
Global $g_aiClanCastlePos[2] = [-1, -1] ; Position of clan castle
Global $g_iDetectedImageType = 0 ; Image theme; 0 = normal, 1 = snow
Global $g_abNotNeedAllTime[2] = [True, True] ; ReArm, CheckTombs

;Builder Base
Global $g_aiCurrentLootBB[$eLootCountBB] = [0, 0, 0] ; current stats on builders base

; Army camps
Global $g_iArmyCapacity = 0 ; Calculated percentage of troops currently in camp / total camp space, expressed as an integer from 0 to 100
Global $g_iTotalTrainSpaceSpell = 0
Global $g_iCurrentSpells = 0 ; Current Spells
Global $g_iCurrentCCSpells = 0, $g_iTotalCCSpells = 0
Global $g_bFullArmySpells = False ; true when $g_iTotalTrainSpaceSpell = $iTotalSpellSpace in getArmySpellCount
Global $g_CurrentCampUtilization = 0, $g_iTotalCampSpace = 0

; Upgrading - Lab
Global $g_iLaboratoryElixirCost = 0
Global $g_iFirstTimeLab = 0
Global $g_sLabUpgradeTime = ""

; Upgrading - Wall
Global Const $g_aiWallCost[8] = [30000, 75000, 200000, 500000, 1000000, 2000000, 3000000, 4000000]
Global $g_iWallCost = 0

; Upgrading - Heroes
; Barbarian King/Queen Upgrade Costs = Dark Elixir in xxxK
Global Const $g_iMaxKingLevel = 50
Global Const $g_iMaxQueenLevel = 50
Global Const $g_iMaxWardenLevel = 20
Global Const $g_afKingUpgCost[50] = [10, 12.5, 15, 17.5, 20, 22.5, 25, 27.5, 30, 32.5, 35, 39, 43, 47, 51, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 129, 133, 137, 141, 145, 149, 153, 157, 161, 165, 170, 173, 176, 179, 182, 185, 188, 191, 194, 197]
Global Const $g_afQueenUpgCost[50] = [40, 22.5, 25, 27.5, 30, 32.5, 35, 39, 43, 47, 51, 55, 59, 63, 67, 71, 75, 80, 85, 90, 95, 100, 105, 110, 115, 119, 123, 127, 131, 135, 139, 143, 147, 151, 155, 159, 163, 167, 171, 175, 180, 182, 184, 186, 188, 190, 192, 194, 196, 198]
; Grand Warden Upgrade Costs = Elixir in xx.xK
Global $g_iWardenLevel = -1
Global Const $g_afWardenUpgCost[20] = [6, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.4, 8.8, 9.1, 9.4, 9.6, 9.8, 10]

; Special Bot activities active
Global $g_bVillageSearchActive = False ;True during Village Search
Global $g_bCloudsActive = False ;True when waiting for clouds
Global $g_bAttackActive = False ;True when attacking Village

; Search
Global Const $g_asTHText[6] = ["4-6", "7", "8", "9", "10", "11"]
Global Const $g_aiSearchCost[11] = [10, 50, 75, 110, 170, 250, 380, 580, 750, 900, 1000]
Global $g_bSearchMode = False
Global $g_bIsSearchLimit = False
Global $g_bIsClientSyncError = False ;If true means while searching Client Out Of Sync error occurred.
Global $g_iSearchGold = 0, $g_iSearchElixir = 0, $g_iSearchDark = 0, $g_iSearchTrophy = 0, $g_iSearchTH = 0 ;Resources of bases when searching
Global $g_aiMaxTH[$g_iModeCount] = [0, 0, 0]
Global $g_iAimGold[$g_iModeCount] = [0, 0, 0], $g_iAimElixir[$g_iModeCount] = [0, 0, 0], $g_iAimGoldPlusElixir[$g_iModeCount] = [0, 0, 0], $g_iAimDark[$g_iModeCount] = [0, 0, 0], _
		$g_iAimTrophy[$g_iModeCount] = [0, 0, 0], $g_iAimTrophyMax[$g_iModeCount] = [99, 99, 99] ; Aiming Resource values
Global $g_iTHx = 0, $g_iTHy = 0
Global $g_bOutOfGold = False ; Flag for out of gold to search for attack

; Town hall search
Global $g_iTHside = 0, $g_iTHi = 0
Global $g_iSearchTHLResult = 0
Global $g_sTHLoc = "In" ; "In" or "Out" are valid values
Global $g_sImglocRedline ; hold redline data obtained from multisearch
Global $g_iImglocTHLevel = 0
Global $g_aiTownHallDetails[4] = [-1, -1, -1, -1] ; [LocX, LocY, BldgLvl, Quantity]

; Attack
Global Const $g_aaiTopLeftDropPoints[5][2] = [[66, 299], [174, 210], [240, 169], [303, 127], [390, 55]]
Global Const $g_aaiTopRightDropPoints[5][2] = [[466, 60], [556, 120], [622, 170], [684, 220], [775, 285]]
Global Const $g_aaiBottomLeftDropPoints[5][2] = [[81, 390], [174, 475], [235, 521], [299, 570], [390, 610]]
Global Const $g_aaiBottomRightDropPoints[5][2] = [[466, 600], [554, 555], [615, 510], [678, 460], [765, 394]]
Global Const $g_aaiEdgeDropPoints[4] = [$g_aaiBottomRightDropPoints, $g_aaiTopLeftDropPoints, $g_aaiBottomLeftDropPoints, $g_aaiTopRightDropPoints]
Global Const $g_aiUseAllTroops[33] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, $eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eBowl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell]
Global Const $g_aiUseBarracks[26] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aiUseBarbs[15] = [$eBarb, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aiUseArchs[15] = [$eArch, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aiUseBarcher[16] = [$eBarb, $eArch, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aiUseBarbGob[16] = [$eBarb, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aiUseArchGob[16] = [$eArch, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aiUseBarcherGiant[17] = [$eBarb, $eArch, $eGiant, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aiUseBarcherGobGiant[18] = [$eBarb, $eArch, $eGiant, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aiUseBarcherHog[17] = [$eBarb, $eArch, $eHogs, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aiUseBarcherMinion[17] = [$eBarb, $eArch, $eMini, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]
Global Const $g_aaiTroopsToBeUsed[12] = [$g_aiUseAllTroops, $g_aiUseBarracks, $g_aiUseBarbs, $g_aiUseArchs, $g_aiUseBarcher, $g_aiUseBarbGob, $g_aiUseArchGob, $g_aiUseBarcherGiant, $g_aiUseBarcherGobGiant, _
		$g_aiUseBarcherHog, $g_aiUseBarcherMinion]
Global $g_bTHSnipeUsedKing = False
Global $g_bTHSnipeUsedQueen = False
Global $g_bTHSnipeUsedWarden = False
Global $g_avAttackTroops[12][2] ;11 Slots of troops -  Name, Amount
Global $g_bFullArmy = False ;Check for full army or not
Global $g_iKingSlot = -1, $g_iQueenSlot = -1, $g_iWardenSlot = -1, $g_iClanCastleSlot = -1

; Attack - Heroes
Global $g_iHeroWaitAttackNoBit[$g_iModeCount][3] ; Heroes wait status for attack
Global $g_iHeroAvailable = $eHeroNone ; Hero ready status; bitmapped
Global $g_iHeroUpgrading[3] = [0, 0, 0] ; Upgrading Heroes
Global $g_iHeroUpgradingBit = $eHeroNone ; Upgrading Heroes
Global $g_bHaveAnyHero = -1 ; -1 Means not set yet
Global $g_bCheckKingPower = False ; Check for King activate power
Global $g_bCheckQueenPower = False ; Check for Queen activate power
Global $g_bCheckWardenPower = False ; Check for Warden activate power
Global $g_bDropQueen, $g_bDropKing, $g_bDropWarden

; Attack - Troops
Global $g_aiSlotInArmy[$eTroopCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
; Red area search
Global $g_aiPixelTopLeft[0]
Global $g_aiPixelBottomLeft[0]
Global $g_aiPixelTopRight[0]
Global $g_aiPixelBottomRight[0]
Global $g_aiPixelTopLeftFurther[0]
Global $g_aiPixelBottomLeftFurther[0]
Global $g_aiPixelTopRightFurther[0]
Global $g_aiPixelBottomRightFurther[0]
Global $g_aiPixelMine[0]
Global $g_aiPixelElixir[0]
Global $g_aiPixelDarkElixir[0]
Global $g_aiPixelNearCollector[0]
Global $g_aiPixelRedArea[0]
Global $g_aiPixelRedAreaFurther[0]
Global Enum $eVectorLeftTop, $eVectorRightTop, $eVectorLeftBottom, $eVectorRightBottom
Global $g_bIsCCDropped = False
Global $g_bIsHeroesDropped = False
Global $g_aiDeployCCPosition[2] = [-1, -1]
Global $g_aiDeployHeroesPosition[2] = [-1, -1]

; Attack CSV
Global $g_aiCSVGoldStoragePos
Global $g_aiCSVElixirStoragePos
Global $g_aiCSVDarkElixirStoragePos
Global $g_aiCSVEagleArtilleryPos
Global $g_aiCSVInfernoPos
Global $g_aiCSVXBowPos
Global $g_aiCSVWizTowerPos
Global $g_aiCSVMortarPos
Global $g_aiCSVAirDefensePos
;Global $g_aiCSVGemBoxPos
Global $g_bCSVLocateMine = False
Global $g_bCSVLocateElixir = False
Global $g_bCSVLocateDrill = False
Global $g_bCSVLocateStorageGold = False
Global $g_bCSVLocateStorageElixir = False
Global $g_bCSVLocateStorageDarkElixir = False
Global $g_bCSVLocateStorageTownHall = False
Global $g_bCSVLocateEagle = False
Global $g_bCSVLocateInferno = False
Global $g_bCSVLocateXBow = False
Global $g_bCSVLocateWizTower = False
Global $g_bCSVLocateMortar = False
Global $g_bCSVLocateAirDefense = False
;Global $g_bCSVLocateGemBox = False
Global $g_iCSVLastTroopPositionDropTroopFromINI = -1
; Assigned/Evaluated Attack vector variables
Global $ATTACKVECTOR_A, $ATTACKVECTOR_B, $ATTACKVECTOR_C, $ATTACKVECTOR_D, $ATTACKVECTOR_E, $ATTACKVECTOR_F
Global $ATTACKVECTOR_G, $ATTACKVECTOR_H, $ATTACKVECTOR_I, $ATTACKVECTOR_J, $ATTACKVECTOR_K, $ATTACKVECTOR_L
Global $ATTACKVECTOR_M, $ATTACKVECTOR_N, $ATTACKVECTOR_O, $ATTACKVECTOR_P, $ATTACKVECTOR_Q, $ATTACKVECTOR_R
Global $ATTACKVECTOR_S, $ATTACKVECTOR_T, $ATTACKVECTOR_U, $ATTACKVECTOR_V, $ATTACKVECTOR_W, $ATTACKVECTOR_X
Global $ATTACKVECTOR_Y, $ATTACKVECTOR_Z

; Attack - Milking
Global Const $g_iMilkFarmOffsetX = 56
Global Const $g_iMilkFarmOffsetY = 41
Global Const $g_iMilkFarmOffsetXStep = 35
Global Const $g_iMilkFarmOffsetYStep = 26
Global $g_asCapacityStructureElixir[9], $g_asDestroyedMineIMG[9], $g_asDestroyedElixirIMG[9], $g_asDestroyedDarkIMG[9]
Global $g_bDuringMilkingAttack = False
;adjust resource coordinates returned by dll ( [0] adjust coord for resource level 0-4, [1] adj. for level 5... [8] adjust coord. for level 12 )
;									0	   1      2     3     4       5     6      7      8
Global Const $g_asMilkFarmOffsetMine[9] = ["1-1", "1-1", "0-2", "0-4", "1-2", "1-1", "3-5", "3-6", "3-5"]
Global Const $g_asMilkFarmOffsetElixir[9] = ["1-11", "1-11", "1-9", "1-13", "0-11", "0-11", "0-13", "0-11", "0-14"]
Global Const $g_asMilkFarmOffsetDark[7] = ["0-0", "1-4", "1-3", "0-5", "4-8", "0-4", "0-3"]
; type.level.xpos-y.pos.redarea1x-redarea1y.redarea2x,redarea2y,[...],redareanx,redareany|type.level.xpos,y.pos.redarea1x,redarea1y.redarea2x,redarea2y,[...],redareanx,redareany|....
;[0]type:gomine,elixir,ddrill
;[1]xpos and ypos
;[2]...[n] redarea points
Global $g_sMilkFarmObjectivesSTR = ""
Global $g_bMilkingAttackOutside = False

; Train
Global $g_bTrainEnabled = True
Global $g_bIsFullArmywithHeroesAndSpells = False
Global $g_bOutOfElixir = False ; Flag for out of elixir to train troops
Global $g_aiTimeTrain[3] = [0, 0, 0] ; [Troop remaining time], [Spells remaining time], [Hero remaining time - when possible]
Global Enum $ArmyTAB, $TrainTroopsTAB, $BrewSpellsTAB, $QuickTrainTAB
Global $g_bCheckSpells = False
Global $g_bCheckClanCastleTroops = False
; Array to hold Laboratory Troop information [LocX of upper left corner of image, LocY of upper left corner of image, PageLocation, Troop "name", Icon # in DLL file]
Global $g_avLabTroops[30][5]

Func TranslateTroopNames()
	Dim $g_avLabTroops[30][5] = [ _
			[-1, -1, -1, GetTranslatedFileIni("MBR Global GUI Design", "None", "None"), $eIcnBlank], _
			[123, 340 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarians", "Barbarians"), $eIcnBarbarian], _
			[123, 447 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArchers", "Archers"), $eIcnArcher], _
			[230, 340 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiants", "Giants"), $eIcnGiant], _
			[230, 447 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblins", "Goblins"), $eIcnGoblin], _
			[337, 340 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreakers", "Wall Breakers"), $eIcnWallBreaker], _
			[337, 447 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloons", "Balloons"), $eIcnBalloon], _
			[443, 340 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizards", "Wizards"), $eIcnWizard], _
			[443, 447 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealers", "Healers"), $eIcnHealer], _
			[550, 340 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragons", "Dragons"), $eIcnDragon], _
			[550, 447 + $g_iMidOffsetY, 0, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekkas", "Pekkas"), $eIcnPekka], _
			[319, 340 + $g_iMidOffsetY, 1, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragons", "Baby Dragons"), $eIcnBabyDragon], _
			[319, 447 + $g_iMidOffsetY, 1, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiners", "Miners"), $eIcnMiner], _
			[426, 340 + $g_iMidOffsetY, 1, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtLightningSpells", "Lightning Spell"), $eIcnLightSpell], _
			[426, 447 + $g_iMidOffsetY, 1, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHealingSpells", "Healing Spell"), $eIcnHealSpell], _
			[533, 340 + $g_iMidOffsetY, 1, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRageSpells", "Rage Spell"), $eIcnRageSpell], _
			[533, 447 + $g_iMidOffsetY, 1, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtJumpSpells", "Jump Spell"), $eIcnJumpSpell], _
			[640, 340 + $g_iMidOffsetY, 1, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtFreezeSpells", "Freeze Spell"), $eIcnFreezeSpell], _
			[640, 447 + $g_iMidOffsetY, 1, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtCloneSpells", "Clone Spell"), $eIcnCloneSpell], _
			[109, 340 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtPoisonSpells", "Poison Spell"), $eIcnPoisonSpell], _
			[109, 447 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtEarthQuakeSpells", "EarthQuake Spell"), $eIcnEarthQuakeSpell], _
			[216, 340 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHasteSpells", "Haste Spell"), $eIcnHasteSpell], _
			[216, 447 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtSkeletonSpells", "Skeleton Spell"), $eIcnSkeletonSpell], _
			[322, 340 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinions", "Minions"), $eIcnMinion], _
			[322, 447 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRiders", "Hog Riders"), $eIcnHogRider], _
			[429, 340 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyries", "Valkyries"), $eIcnValkyrie], _
			[429, 447 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolems", "Golems"), $eIcnGolem], _
			[536, 340 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitches", "Witches"), $eIcnWitch], _
			[536, 447 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHounds", "Lava Hounds"), $eIcnLavaHound], _
			[642, 340 + $g_iMidOffsetY, 2, GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowlers", "Bowlers"), $eIcnBowler]]
EndFunc   ;==>TranslateTroopNames

; Donate
Global Const $g_aiDonateTroopPriority[$eTroopCount] = [ _
		$eTroopLavaHound, $eTroopGolem, $eTroopPekka, $eTroopDragon, $eTroopWitch, $eTroopHealer, $eTroopBabyDragon, _
		$eTroopValkyrie, $eTroopBowler, $eTroopMiner, $eTroopGiant, $eTroopBalloon, $eTroopHogRider, $eTroopWizard, _
		$eTroopWallBreaker, $eTroopMinion, $eTroopArcher, $eTroopBarbarian, $eTroopGoblin]
Global Const $g_aiDonateSpellPriority[$eSpellCount] = [ _
		$eSpellLightning, $eSpellHeal, $eSpellRage, $eSpellJump, $eSpellFreeze, $eSpellPoison, $eSpellEarthquake, _
		$eSpellHaste, $eSpellSkeleton]
Global $g_aiDonateStatsTroops[$eTroopCount][2] = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
Global $g_aiDonateStatsSpells[$eSpellCount][2] = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
Global $g_iTotalDonateStatsTroops = 0, $g_iTotalDonateStatsTroopsXP = 0
Global $g_iTotalDonateStatsSpells = 0, $g_iTotalDonateStatsSpellsXP = 0
Global $g_iActiveDonate = -1 ; -1 means not set yet
Global $g_aiDonateTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], $g_aiDonateSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCurrentTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], $g_aiCurrentSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiCurrentCCTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], $g_aiCurrentCCSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_bDonationEnabled = True
Global $g_iTroopsDonated = 0
Global $g_iTroopsReceived = 0
Global $g_iDonationWindowY = 0

; Drop trophy
Global $g_bDisableDropTrophy = False ; this will be True if you tried to use Drop Throphy and did not have Tier 1 or 2 Troops to protect you expensive troops from being dropped.
Global $g_avDTtroopsToBeUsed[6][2] = [["Barb", 0], ["Arch", 0], ["Giant", 0], ["Wall", 0], ["Gobl", 0], ["Mini", 0]] ; DT available troops [type, qty]

; Obstacles
Global $g_bMinorObstacle = False
Global $g_bGfxError = False ; True when Android Gfx Errors detected that will initiate Android reboot

; TakeABreak - Personal Break Timer
Global Const $g_iTaBChkAttack = 0x01 ; code for PB warning when searching attack
Global Const $g_iTaBChkIdle = 0x02 ; code for PB warning when idle at base
Global Const $g_iTaBChkTime = 0x04 ; code for PB created by early log off feature
Global $g_bDisableBreakCheck = False
Global $g_sPBStartTime = "" ; date/time string for start of next Personal Break
Global $g_asShieldStatus = ["", "", ""] ; string shield type, string shield time, string date/time of Shield expire

; Building Side (DES/TH) Switch and DESide End Early
Global Enum $eSideBuildingDES, $eSideBuildingTH
Global $g_iBuildingEdge = 0, $g_iBuildingToLoc = ""
Global $g_iDarkLow = 0

; Request CC troops/spells
Global $g_iCCRemainTime = 0 ; Time remaining until can request CC again
Global $g_bCanRequestCC = True

; DO NOT ENABLE ! ! ! Only for testing Android Error behavior ! ! !
Global $__TEST_ERROR_ADB_DEVICE_NOT_FOUND = False
Global $__TEST_ERROR = $__TEST_ERROR_ADB_DEVICE_NOT_FOUND
Global $__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY = 0
Global $__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY = 0
Global $__TEST_ERROR_SLOW_ADB_CLICK_DELAY = 0

; ImgLoc V3 , new image search library Aforge
; Similarity ( like tolerance ) 0,00 to 1,00
Global $g_fToleranceImgLoc = 0.95

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

; Weak Base Defense Building Information
Global Enum $eWeakEagle = 1, $eWeakInferno, $eWeakXBow, $eWeakWizard, $eWeakMortar, $eWeakAirDefense
Global $g_aWeakDefenseNames = ["None", "Eagle Artillery", "Inferno Tower", "XBow", "Wizard Tower", "Mortar", "Air Defense"]

; Building variables used by CSV attacks
Global Enum $eBldgRedLine, $eBldgTownHall, $eBldgGoldM, $eBldgElixirC, $eBldgDrill, $eBldgGoldS, $eBldgElixirS, $eBldgDarkS, $eBldgEagle, $eBldgInferno, $eBldgXBow, $eBldgWizTower, $eBldgMortar, $eBldgAirDefense
Global $g_sBldgNames = ["Red Line", "Town Hall", "Gold Mine", "Elixir Collector", "Dark Elixir Drill", "Gold Storage", "Elixir Storage", "Dark Elixir Storage", "Eagle Artillery", "Inferno Tower", "XBow", "Wizard Tower", "Mortar", "Air Defense"]
Global Const $g_iMaxCapTroopTH[12] = [0, 20, 30, 70, 80, 135, 150, 200, 200, 220, 240, 260] ; element 0 is a dummy
Global Const $g_iMaxCapSpellTH[12] = [0, 0, 0, 0, 0, 2, 4, 6, 7, 9, 11, 11] ; element 0 is a dummy
Global $g_oBldgAttackInfo = ObjCreate("Scripting.Dictionary") ; stores building information of base being attacked
$g_oBldgAttackInfo.CompareMode = 1 ; use case in-sensitve compare for key values

; $g_oBldgAttackInfo Dictionay KEY naming reference guide:
; 	:Key strings will be building enum value (integer) & "_" & Property name from image detection DLL [Optional: & "K" + key index value]
;	:Properties planned to use are:
;  :  _FILENAME_KZ = string filename of image that was found (for each for specific key "Z" returned when more than one found)
;	:	_NAMEFOUND = String filename of image that was found, will be max level found if more than one building is located.
;	:	_MAXLVLFOUND = Maximum building level found by DLL
;  :  _LVLFOUND_KZ = Building level found by DLL (for each for specific key "Z" returned when more than one found)
;	:	_FILLLEVEL = Building fill level found by DLL
;	:	_COUNT = integer number of X,Y locations detected (for each building or redline total)
;	:	_COUNT_KZ = integer number of X,Y locations detected (for each for specific key "Z" returned when more than one found)
;	:	_LOCATION = Location/Position data array [R][[x,y]], where R can be as many locations as found, with X,Y integer location stored.
;  :  _OBJECTPOINTS = Location/Position data for all buildings (any level) in string format as returned by DLL
;  :  _OBJECTPOINTS_KZ = Location/Position data in string format as returned by DLL (for each for specific key "Z" returned when more than one found)
;	:	_NEARPOINTS = drop position string,  5 pixel outside red line as returned by DLL, with x,y integer location data for each point. (not used at this time)
;	:	_FARPOINTS = drop position string, 30 pixel outside red line as returned by DLL, with x,y integer location data for each point. (not used at this time)
;	:  _FINDTIME = time required by code to find building type
;
;	: examples:
;	::	$eBldgRedLine & "_LOCATION"  = redline data string,
;	::	$eBldgEagle & "_COUNT"  = number of eagle points returned
;	:: $eBldgEagle & "_LOCATION" = eagle x,y location
;	:: $eBldgEagle & "_NAMEFOUND"  = Will not exist if bldg is not found, or will contain filename of max level image found

Global $g_oBldgLevels = ObjCreate("Scripting.Dictionary")
; stores constant arrays with max level of each building type available per TH, using building enum as key to find data
; to find max level for any defense = $g_oBldgLevels.item(Building enum)[TownHall level -1]

Func _FilloBldgLevels()
	Local Const $aBldgCollector[11] = [2, 4, 6, 8, 10, 10, 11, 12, 12, 12, 12]
	$g_oBldgLevels.add($eBldgGoldM, $aBldgCollector)
	$g_oBldgLevels.add($eBldgElixirC, $aBldgCollector)
	Local Const $aBldgDrill[11] = [0, 0, 0, 0, 0, 0, 3, 3, 6, 6, 6]
	$g_oBldgLevels.add($eBldgDrill, $aBldgDrill)
	Local Const $aBldgStorage[11] = [1, 3, 6, 8, 9, 10, 11, 11, 11, 11, 12]
	$g_oBldgLevels.add($eBldgGoldS, $aBldgStorage)
	$g_oBldgLevels.add($eBldgElixirS, $aBldgStorage)
	Local Const $aBldgDarkStorage[11] = [0, 0, 0, 0, 0, 0, 2, 4, 6, 6, 6]
	$g_oBldgLevels.add($eBldgDarkS, $aBldgDarkStorage)
	Local Const $aBldgEagle[11] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2]
	$g_oBldgLevels.add($eBldgEagle, $aBldgEagle)
	Local Const $aBldgInferno[11] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 5]
	$g_oBldgLevels.add($eBldgInferno, $aBldgInferno)
	Local Const $aBldgMortar[11] = [0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 10]
	$g_oBldgLevels.add($eBldgMortar, $aBldgMortar)
	Local Const $aBldgWizTower[11] = [0, 0, 0, 0, 2, 3, 4, 6, 7, 9, 10]
	$g_oBldgLevels.add($eBldgWizTower, $aBldgWizTower)
	Local Const $aBldgXBow[11] = [0, 0, 0, 0, 0, 0, 0, 0, 3, 4, 5]
	$g_oBldgLevels.add($eBldgXBow, $aBldgXBow)
	Local Const $aBldgAirDefense[11] = [0, 0, 0, 2, 3, 4, 5, 6, 7, 8, 9]
	$g_oBldgLevels.add($eBldgAirDefense, $aBldgAirDefense)
EndFunc   ;==>_FilloBldgLevels
_FilloBldgLevels()

Global $g_oBldgMaxQty = ObjCreate("Scripting.Dictionary")
; Stores const arrays with maximum number of each building available at each TH level
; to find max number of bldgs for any defense = $g_oBldgMaxQty.item(Building enum)[TownHall level -1]

Func _FilloBldgMaxQty()
	Local Const $aBldgCollector[11] = [1, 2, 3, 4, 5, 6, 6, 6, 6, 7, 7]
	$g_oBldgMaxQty.add($eBldgGoldM, $aBldgCollector)
	$g_oBldgMaxQty.add($eBldgElixirC, $aBldgCollector)
	Local Const $aBldgDrill[11] = [0, 0, 0, 0, 0, 0, 1, 2, 2, 3, 3]
	$g_oBldgMaxQty.add($eBldgDrill, $aBldgDrill)
	Local Const $aBldgStorage[11] = [1, 1, 2, 2, 2, 2, 2, 3, 4, 4, 4]
	$g_oBldgMaxQty.add($eBldgGoldS, $aBldgStorage)
	$g_oBldgMaxQty.add($eBldgElixirS, $aBldgStorage)
	Local Const $aBldgDarkStorage[11] = [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1]
	$g_oBldgMaxQty.add($eBldgDarkS, $aBldgDarkStorage)
	Local Const $aBldgEagle[11] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
	$g_oBldgMaxQty.add($eBldgEagle, $aBldgEagle)
	Local Const $aBldgInferno[11] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2]
	$g_oBldgMaxQty.add($eBldgInferno, $aBldgInferno)
	Local Const $aBldgMortar[11] = [0, 0, 1, 1, 1, 2, 3, 4, 4, 4, 4]
	$g_oBldgMaxQty.add($eBldgMortar, $aBldgMortar)
	Local Const $aBldgWizTower[11] = [0, 0, 0, 0, 1, 2, 2, 3, 4, 4, 5]
	$g_oBldgMaxQty.add($eBldgWizTower, $aBldgWizTower)
	Local Const $aBldgXBow[11] = [0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 4]
	$g_oBldgMaxQty.add($eBldgXBow, $aBldgXBow)
	Local Const $aBldgAirDefense[11] = [0, 0, 0, 1, 1, 2, 3, 3, 4, 4, 4]
	$g_oBldgMaxQty.add($eBldgAirDefense, $aBldgAirDefense)
EndFunc   ;==>_FilloBldgMaxQty
_FilloBldgMaxQty()

Global $g_oBldgImages = ObjCreate("Scripting.Dictionary") ; stores strings with location of images used to find buildings during attacks
; Building image key string value = bldg type enum & "_" & $g_iDetectedImageType (no snow, with snow)
$g_oBldgImages.add($eBldgTownHall & "_" & "0", "imglocth-bundle")
$g_oBldgImages.add($eBldgTownHall & "_" & "1", "snow-imglocth-bundle")
$g_oBldgImages.add($eBldgGoldM & "_" & "0", @ScriptDir & "\imgxml\Storages\Mines")
$g_oBldgImages.add($eBldgGoldM & "_" & "1", @ScriptDir & "\imgxml\Storages\Mines_Snow")
$g_oBldgImages.add($eBldgElixirC & "_" & "0", @ScriptDir & "\imgxml\Storages\Collectors")
$g_oBldgImages.add($eBldgElixirC & "_" & "1", @ScriptDir & "\imgxml\Storages\CollectorsSnow")
$g_oBldgImages.add($eBldgDrill & "_" & "0", @ScriptDir & "\imgxml\Storages\Drills")
$g_oBldgImages.add($eBldgGoldS & "_" & "0", @ScriptDir & "\imgxml\Storages\Gold")
$g_oBldgImages.add($eBldgElixirS & "_" & "0", @ScriptDir & "\imgxml\Storages\Elixir")
$g_oBldgImages.add($eBldgEagle & "_" & "0", @ScriptDir & "\imgxml\Buildings\Eagle")
$g_oBldgImages.add($eBldgInferno & "_" & "0", @ScriptDir & "\imgxml\Buildings\Infernos")
$g_oBldgImages.add($eBldgXBow & "_" & "0", @ScriptDir & "\imgxml\Buildings\Xbow")
$g_oBldgImages.add($eBldgWizTower & "_" & "0", @ScriptDir & "\imgxml\Buildings\WTower")
$g_oBldgImages.add($eBldgWizTower & "_" & "1", @ScriptDir & "\imgxml\Buildings\WTowerSnow")
$g_oBldgImages.add($eBldgMortar & "_" & "0", @ScriptDir & "\imgxml\Buildings\Mortars")
$g_oBldgImages.add($eBldgAirDefense & "_" & "0", @ScriptDir & "\imgxml\Buildings\ADefense")
; EOF

; Clan Games v3
Global $g_bChkClanGamesAir = 0, $g_bChkClanGamesGround = 0, $g_bChkClanGamesMisc = 0
Global $g_bChkClanGamesEnabled = 0
Global $g_bChkClanGamesLoot = 0
Global $g_bChkClanGamesBattle = 0
Global $g_bChkClanGamesDestruction = 0
Global $g_bChkClanGamesAirTroop = 0
Global $g_bChkClanGamesGroundTroop = 0
Global $g_bChkClanGamesMiscellaneous = 0
Global $g_bChkClanGamesPurge = 0
Global $g_bChkClanGamesStopBeforeReachAndPurge = 0
Global $g_bChkClanGamesDebug = 0
Global $g_iPurgeJobCount[8] = [0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iPurgeMax = 5 ; [0] is unlimited , 1-10

Global $g_bChkCollectFreeMagicItems = True
