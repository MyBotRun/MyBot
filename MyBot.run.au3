; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot
; Description ...: This file contens the Sequence that runs all MBR Bot
; Author ........:  (2014)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#RequireAdmin
#AutoIt3Wrapper_UseX64=7n
#include <WindowsConstants.au3>
#include <WinAPI.au3>

#pragma compile(Icon, "Images\MyBot.ico")
#pragma compile(FileDescription, Clash of Clans Bot - A Free Clash of Clans bot - https://mybot.run)
#pragma compile(ProductName, My Bot)

#pragma compile(ProductVersion, 5.1)
#pragma compile(FileVersion, 5.1.4)
#pragma compile(LegalCopyright, © https://mybot.run)
#pragma compile(Out, MyBot.run.exe)  ; Required

If @AutoItX64 = 1 Then
	MsgBox(0, "", "Don't Run/Compile the Script as (x64)! try to Run/Compile the Script as (x86) to get the bot to work." & @CRLF & _
			"If this message still appears, try to re-install AutoIt.")
	Exit
EndIf

If Not FileExists(@ScriptDir & "\License.txt") Then
	$license = InetGet("http://www.gnu.org/licenses/gpl-3.0.txt", @ScriptDir & "\License.txt")
	InetClose($license)
EndIf

;~ ProcessSetPriority(@AutoItPID, $PROCESS_ABOVENORMAL)
#include "COCBot\MBR Global Variables.au3"

$sBotVersion = "v5.1.4" ;~ Don't add more here, but below. Version can't be longer than vX.y.z because it it also use on Checkversion()
$sBotTitle = "My Bot " & $sBotVersion & " "

Opt("WinTitleMatchMode", 3) ; Window Title exact match mode
#include "COCBot\functions\Main Screen\Android.au3"

If $aCmdLine[0] < 2 Then
	DetectRunningAndroid()
	If Not $FoundRunningAndroid Then DetectInstalledAndroid()
EndIf
; Update Bot title
$sBotTitle = $sBotTitle & "(" & ($AndroidInstance <> "" ? $AndroidInstance : $Android) & ")"

If $bBotLaunchOption_Restart = True Then
   If CloseRunningBot($sBotTitle) = True Then
	  ; wait for Mutexes to get disposed
	  ;Sleep(1000) ; slow systems
   EndIf
EndIF

Local $cmdLineHelp = "With the first command line parameter, specify the Profile(01-06). " & _
					 "With the second, specify the name of the Emulator and with the third, an Android Instance (only for Droid4x & MEmu). " & _
					 "Supported Emulators are BlueStacks, BlueStacks2, Droid4X and MEmu. " & _
					 @CRLF&"Example: this command will start the bot with BlueStacks2 and profile 01: "&@CRLF &"MyBot.run.exe BlueStacks2 01"

$hMutex_BotTitle = _Singleton($sBotTitle, 1)
If $hMutex_BotTitle = 0 Then
	MsgBox(0, $sBotTitle, "My Bot for " & $Android & ($AndroidInstance <> "" ? " (instance " & $AndroidInstance & ")" : "") & " is already running." & @CRLF & @CRLF & $cmdLineHelp)
	Exit
EndIf

$hMutex_Profile = _Singleton(StringReplace($sProfilePath & "\" & $sCurrProfile, "\", "-"), 1)
If $hMutex_Profile = 0 Then
   _WinAPI_CloseHandle($hMutex_BotTitle)
	MsgBox(0, $sBotTitle, "My Bot with Profile " & $sCurrProfile & " is already running in " & $sProfilePath & "\" & $sCurrProfile & "." & @CRLF & @CRLF & $cmdLineHelp)
	Exit
EndIf

$hMutex_MyBot = _Singleton("MyBot.run", 1)
$OnlyInstance = $hMutex_MyBot <> 0 ; And False
SetDebugLog("My Bot is " & ($OnlyInstance ? "" : "not ") & "the only running instance")

;multilanguage
#include "COCBot\functions\Other\Multilanguage.au3"
DetectLanguage()

#include "COCBot\MBR GUI Design.au3"
#include "COCBot\MBR GUI Control.au3"
#include "COCBot\MBR Functions.au3"

CheckPrerequisites() ; check for VC2010, .NET software and MyBot Files and Folders

DirCreate($sTemplates)
DirCreate($sProfilePath & "\" & $sCurrProfile)
DirCreate($dirLogs)
DirCreate($dirLoots)
DirCreate($dirTemp)
DirCreate($dirTempDebug)
FileMove(@ScriptDir & "\*.ini", $sProfilePath & "\" & $sCurrProfile, $FC_OVERWRITE + $FC_CREATEPATH)
DirCopy(@ScriptDir & "\Logs", $sProfilePath & "\" & $sCurrProfile & "\Logs", $FC_OVERWRITE + $FC_CREATEPATH)
DirCopy(@ScriptDir & "\Loots", $sProfilePath & "\" & $sCurrProfile & "\Loots", $FC_OVERWRITE + $FC_CREATEPATH)
DirCopy(@ScriptDir & "\Temp", $sProfilePath & "\" & $sCurrProfile & "\Temp", $FC_OVERWRITE + $FC_CREATEPATH)
DirRemove(@ScriptDir & "\Logs", 1)
DirRemove(@ScriptDir & "\Loots", 1)
DirRemove(@ScriptDir & "\Temp", 1)

If $ichkDeleteLogs = 1 Then DeleteFiles($dirLogs, "*.*", $iDeleteLogsDays, 0)
If $ichkDeleteLoots = 1 Then DeleteFiles($dirLoots, "*.*", $iDeleteLootsDays, 0)
If $ichkDeleteTemp = 1 Then DeleteFiles($dirTemp, "*.*", $iDeleteTempDays, 0)
If $ichkDeleteTemp = 1 Then DeleteFiles($dirTempDebug, "*.*", $iDeleteTempDays, 0)
FileChangeDir($LibDir)

;MBRfunctions.dll & debugger
MBRFunc(True) ; start MBRFunctions dll
debugMBRFunctions($debugSearchArea, $debugRedArea, $debugOcr) ; set debug levels

If $FoundRunningAndroid Then
	SetLog("Found running " & $Android & " " & $AndroidVersion, $COLOR_GREEN)
EndIf
If $FoundInstalledAndroid Then
	SetLog("Found installed " & $Android & " " & $AndroidVersion, $COLOR_GREEN)
EndIf
SetLog("Android Emulator Configuration: " & $Android & ($AndroidInstance <> "" ? " (instance " & $AndroidInstance & ")" : ""), $COLOR_GREEN)

AdlibRegister("PushBulletRemoteControl", $PBRemoteControlInterval)
AdlibRegister("PushBulletDeleteOldPushes", $PBDeleteOldPushesInterval)


CheckDisplay() ; verify display size and DPI (Dots Per Inch) setting

CheckVersion() ; check latest version on mybot.run site

;AutoStart Bot if request
AutoStart()

While 1
	Switch TrayGetMsg()
		Case $tiAbout
			MsgBox(64 + $MB_APPLMODAL + $MB_TOPMOST, $sBotTitle, "Clash of Clans Bot" & @CRLF & @CRLF & _
					"Version: " & $sBotVersion & @CRLF & _
					"Released under the GNU GPLv3 license.", 0, $frmBot)
		Case $tiExit
			ExitLoop
	EndSwitch
WEnd

Func runBot() ;Bot that runs everything in order
	$TotalTrainedTroops = 0
	While 1
		$Restart = False
		$fullArmy = False
		$CommandStop = -1
		If _Sleep($iDelayRunBot1) Then Return
		checkMainScreen()
		If $Restart = True Then ContinueLoop
		If $Is_ClientSyncError = False And $Is_SearchLimit = False Then
			If BotCommand() Then btnStop()
			If _Sleep($iDelayRunBot2) Then Return
			checkMainScreen(False)
			If $Restart = True Then ContinueLoop
			;If $iChkUseCCBalanced = 1 then
			;    ProfileReport()
			;    If _Sleep($iDelayRunBot2) Then Return
			;    checkMainScreen(False)
			;    If $Restart = True Then ContinueLoop
			;EndIf
			If $RequestScreenshot = 1 Then PushMsg("RequestScreenshot")
			If _Sleep($iDelayRunBot3) Then Return
			VillageReport()
			If $OutOfGold = 1 And (Number($iGoldCurrent) >= Number($itxtRestartGold)) Then ; check if enough gold to begin searching again
				$OutOfGold = 0 ; reset out of gold flag
				Setlog("Switching back to normal after no gold to search ...", $COLOR_RED)
				$ichkBotStop = 0 ; reset halt attack variable
				$icmbBotCond = _GUICtrlComboBox_GetCurSel($cmbBotCond) ; Restore User GUI halt condition after modification for out of gold
				$bTrainEnabled = True
				$bDonationEnabled = True
				ContinueLoop ; Restart bot loop to reset $CommandStop
			EndIf
			If $OutOfElixir = 1 And (Number($iElixirCurrent) >= Number($itxtRestartElixir)) And (Number($iDarkCurrent) >= Number($itxtRestartDark)) Then ; check if enough elixir to begin searching again
				$OutOfElixir = 0 ; reset out of gold flag
				Setlog("Switching back to normal setting after no elixir to train ...", $COLOR_RED)
				$ichkBotStop = 0 ; reset halt attack variable
				$icmbBotCond = _GUICtrlComboBox_GetCurSel($cmbBotCond) ; Restore User GUI halt condition after modification for out of elixir
				$bTrainEnabled = True
				$bDonationEnabled = True
				ContinueLoop ; Restart bot loop to reset $CommandStop
			EndIf
			If _Sleep($iDelayRunBot5) Then Return
				checkMainScreen(False)
				If $Restart = True Then ContinueLoop
			Collect()
				If _Sleep($iDelayRunBot1) Then Return
				If $Restart = True Then ContinueLoop
			CheckTombs()
				If _Sleep($iDelayRunBot3) Then Return
				If $Restart = True Then ContinueLoop
			ReArm()
				If _Sleep($iDelayRunBot3) Then Return
				If $Restart = True Then ContinueLoop
			ReplayShare($iShareAttackNow)
				If _Sleep($iDelayRunBot3) Then Return
				If $Restart = True Then ContinueLoop
			ReportPushBullet()
				If _Sleep($iDelayRunBot3) Then Return
				If $Restart = True Then ContinueLoop
			DonateCC()
				If _Sleep($iDelayRunBot1) Then Return
				checkMainScreen(False) ; required here due to many possible exits
				If $Restart = True Then ContinueLoop
			Train()
				If _Sleep($iDelayRunBot1) Then Return
				checkMainScreen(False)
				If $Restart = True Then ContinueLoop
			BoostBarracks()
				If $Restart = True Then ContinueLoop
			BoostSpellFactory()
				If $Restart = True Then ContinueLoop
			BoostDarkSpellFactory()
				If $Restart = True Then ContinueLoop
			BoostKing()
				If $Restart = True Then ContinueLoop
			BoostQueen()
				If $Restart = True Then ContinueLoop
			BoostWarden()
				If $Restart = True Then ContinueLoop
			RequestCC()
				If _Sleep($iDelayRunBot1) Then Return
				checkMainScreen(False) ; required here due to many possible exits
				If $Restart = True Then ContinueLoop
			If $iUnbreakableMode >= 1 Then
				If Unbreakable() = True Then ContinueLoop
			EndIf
			Laboratory()
				If _Sleep($iDelayRunBot3) Then Return
				checkMainScreen(False) ; required here due to many possible exits
				If $Restart = True Then ContinueLoop
			UpgradeHeroes()
				If _Sleep($iDelayRunBot3) Then Return
				If $Restart = True Then ContinueLoop
			UpgradeBuilding()
				If _Sleep($iDelayRunBot3) Then Return
				If $Restart = True Then ContinueLoop
			UpgradeWall()
				If _Sleep($iDelayRunBot3) Then Return
				If $Restart = True Then ContinueLoop
			Idle()
				If _Sleep($iDelayRunBot3) Then Return
				If $Restart = True Then ContinueLoop
			SaveStatChkTownHall()
			SaveStatChkDeadBase()
			If $CommandStop <> 0 And $CommandStop <> 3 Then
				AttackMain()
				If $OutOfGold = 1 Then
					Setlog("Switching to Halt Attack, Stay Online/Collect mode ...", $COLOR_RED)
					$ichkBotStop = 1 ; set halt attack variable
					$icmbBotCond = 16 ; set stay online/collect only mode
					$FirstStart = True ; reset First time flag to ensure army balancing when returns to training
					ContinueLoop
				EndIf
				If _Sleep($iDelayRunBot1) Then Return
				If $Restart = True Then ContinueLoop
			EndIf

		Else ;When error occours directly goes to attack
			If $Is_SearchLimit = True Then
				SetLog("Restarted due search limit", $COLOR_BLUE)
			Else
				SetLog("Restarted after Out of Sync Error: Attack Now", $COLOR_BLUE)
			EndIf
			If _Sleep($iDelayRunBot3) Then Return
			;  OCR read current Village Trophies when OOS restart maybe due PB or else DropTrophy skips one attack cycle after OOS
			$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
			If $debugsetlog = 1 Then SetLog("Runbot Trophy Count: " & $iTrophyCurrent, $COLOR_PURPLE)
			AttackMain()
			If $OutOfGold = 1 Then
				Setlog("Switching to Halt Attack, Stay Online/Collect mode ...", $COLOR_RED)
				$ichkBotStop = 1 ; set halt attack variable
				$icmbBotCond = 16 ; set stay online/collect only mode
				$FirstStart = True ; reset First time flag to ensure army balancing when returns to training
				$Is_ClientSyncError = False ; reset fast restart flag to stop OOS mode and start collecting resources
				ContinueLoop
			EndIf
			If _Sleep($iDelayRunBot5) Then Return
			If $Restart = True Then ContinueLoop
		EndIf
	WEnd
EndFunc   ;==>runBot

Func Idle() ;Sequence that runs until Full Army
	Local $TimeIdle = 0 ;In Seconds
	;If $debugsetlog = 1 Then SetLog("Func Idle ", $COLOR_PURPLE)
	While $fullArmy = False
		If $RequestScreenshot = 1 Then PushMsg("RequestScreenshot")
		If _Sleep($iDelayIdle1) Then Return
		If $CommandStop = -1 Then SetLog("====== Waiting for full army ======", $COLOR_GREEN)
		Local $hTimer = TimerInit()
		Local $iReHere = 0
		While $iReHere < 7
			$iReHere += 1
			DonateCC(True)
			If _Sleep($iDelayIdle2) Then ExitLoop
			If $Restart = True Then ExitLoop
		WEnd
		If _Sleep($iDelayIdle1) Then ExitLoop
		checkMainScreen(False) ; required here due to many possible exits
		If ($CommandStop = 3 Or $CommandStop = 0) Then
			CheckOverviewFullArmy(True)
			If Not ($fullArmy) And $bTrainEnabled = True Then
				SetLog("Army Camp and Barracks are not full, Training Continues...", $COLOR_ORANGE)
				$CommandStop = 0
			EndIf
		EndIf
		ReplayShare($iShareAttackNow)
		If _Sleep($iDelayIdle1) Then Return
		If $Restart = True Then ExitLoop
		If $iCollectCounter > $COLLECTATCOUNT Then ; This is prevent from collecting all the time which isn't needed anyway
			Collect()
			If _Sleep($iDelayIdle1) Then Return
 			DonateCC()
 			If $Restart = True Then ExitLoop
			If _Sleep($iDelayIdle1) Or $RunState = False Then ExitLoop
			$iCollectCounter = 0
		EndIf
		$iCollectCounter = $iCollectCounter + 1
		If $CommandStop = -1 Then
			Train()
				If $Restart = True Then ExitLoop
				If _Sleep($iDelayIdle1) Then ExitLoop
				checkMainScreen(False)
		EndIf
		If _Sleep($iDelayIdle1) Then Return
		If $CommandStop = 0 And $bTrainEnabled = True Then
			If Not ($fullArmy) Then
				Train()
					If $Restart = True Then ExitLoop
					If _Sleep($iDelayIdle1) Then ExitLoop
					checkMainScreen(False)
			EndIf
			If $fullArmy Then
				SetLog("Army Camp and Barracks are full, stop Training...", $COLOR_ORANGE)
				$CommandStop = 3
			EndIf
		EndIf
		If _Sleep($iDelayIdle1) Then Return
		If $CommandStop = -1 Then
			DropTrophy()
				If $Restart = True Then ExitLoop
				If $fullArmy Then ExitLoop
				If _Sleep($iDelayIdle1) Then ExitLoop
				checkMainScreen(False)
		EndIf
		If _Sleep($iDelayIdle1) Then Return
		If $Restart = True Then ExitLoop
		$TimeIdle += Round(TimerDiff($hTimer) / 1000, 2) ;In Seconds

		If $canRequestCC = True Then RequestCC()

		SetLog("Time Idle: " & StringFormat("%02i", Floor(Floor($TimeIdle / 60) / 60)) & ":" & StringFormat("%02i", Floor(Mod(Floor($TimeIdle / 60), 60))) & ":" & StringFormat("%02i", Floor(Mod($TimeIdle, 60))))
		If $OutOfGold = 1 Or $OutOfElixir = 1 Then Return  ; Halt mode due low resources, only 1 idle loop
		If $iChkSnipeWhileTrain = 1 Then SnipeWhileTrain()  ;snipe while train
	WEnd
EndFunc   ;==>Idle

Func AttackMain() ;Main control for attack functions
	If $iChkUseCCBalanced = 1 Then ;launch profilereport() only if option balance D/R it's activated
		ProfileReport()
		If _Sleep($iDelayAttackMain1) Then Return
		checkMainScreen(False)
		If $Restart = True Then Return
	EndIf
	If Number($iTrophyCurrent) > Number($iTxtMaxTrophy) Then ;If current trophy above max trophy, try drop first
		DropTrophy()
		$Is_ClientSyncError = False ; reset OOS flag to prevent looping.
		If _Sleep($iDelayAttackMain1) Then Return
		Return ; return to runbot, refill armycamps
	EndIf
	PrepareSearch()
		If $OutOfGold = 1 Then Return ; Check flag for enough gold to search
		If $Restart = True Then Return
	VillageSearch()
		If $OutOfGold = 1 Then Return ; Check flag for enough gold to search
		If $Restart = True Then Return
	PrepareAttack($iMatchMode)
		If $Restart = True Then Return
	;checkDarkElix()
	;DEAttack()
	;	If $Restart = True Then Return
	Attack()
		If $Restart = True Then Return
	ReturnHome($TakeLootSnapShot)
		If _Sleep($iDelayAttackMain2) Then Return
	Return True
EndFunc   ;==>AttackMain

Func Attack() ;Selects which algorithm
	SetLog(" ====== Start Attack ====== ", $COLOR_GREEN)
	If  ($iMatchMode = $DB and $ichkUseAttackDBCSV = 1) or ($iMatchMode = $LB and $ichkUseAttackABCSV = 1) Then
		Algorithm_AttackCSV()
	Else
		algorithm_AllTroops()
	EndIf
EndFunc   ;==>Attack


