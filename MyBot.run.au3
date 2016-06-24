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
#include <Process.au3>

#pragma compile(Icon, "Images\MyBot.ico")
#pragma compile(FileDescription, Clash of Clans Bot - A Free Clash of Clans bot - https://mybot.run)
#pragma compile(ProductName, My Bot)

#pragma compile(ProductVersion, 6.1)
#pragma compile(FileVersion, 6.1)
#pragma compile(LegalCopyright, © https://mybot.run)
#pragma compile(Out, MyBot.run.exe)  ; Required

;~ Boost launch time by increasing process priority (will be restored again when finished launching)
Local $iBotProcessPriority = _ProcessGetPriority(@AutoItPID)
ProcessSetPriority(@AutoItPID, $PROCESS_ABOVENORMAL)

Global $iBotLaunchTime = 0
Local $hBotLaunchTime = TimerInit()

If @AutoItX64 = 1 Then
	MsgBox(0, "", "Don't Run/Compile the Script as (x64)! Try to Run/Compile the Script as (x86) to get the bot to work." & @CRLF & _
			"If this message still appears, try to re-install AutoIt.")
	Exit
EndIf

If Not FileExists(@ScriptDir & "\License.txt") Then
	$license = InetGet("http://www.gnu.org/licenses/gpl-3.0.txt", @ScriptDir & "\License.txt")
EndIf

;~ ProcessSetPriority(@AutoItPID, $PROCESS_ABOVENORMAL)
#include "COCBot\MBR Global Variables.au3"
#include "COCBot\functions\Config\ScreenCoordinates.au3"

$sBotVersion = "v6.1.3" ;~ Don't add more here, but below. Version can't be longer than vX.y.z because it it also use on Checkversion()
$sBotTitle = "My Bot " & $sBotVersion & " " ;~ Don't use any non file name supported characters like \ / : * ? " < > |

Opt("WinTitleMatchMode", 3) ; Window Title exact match mode
#include "COCBot\functions\Android\Android.au3"

;multilanguage
#include "COCBot\functions\Other\Multilanguage.au3"
DetectLanguage()

If $aCmdLine[0] < 2 Then
	DetectRunningAndroid()
	If Not $FoundRunningAndroid Then DetectInstalledAndroid()
EndIf
; Update Bot title
$sBotTitle = $sBotTitle & "(" & ($AndroidInstance <> "" ? $AndroidInstance : $Android) & ")" ;Do not change this. If you do, multiple instances will not work.

If $bBotLaunchOption_Restart = True Then
   If CloseRunningBot($sBotTitle) = True Then
	  ; wait for Mutexes to get disposed
	  ;Sleep(1000) ; slow systems
   EndIf
EndIF

Local $cmdLineHelp = "By using the commandline (or a shortcut) you can start multiple Bots:" & @CRLF & _
					 "     MyBot.run.exe [ProfileName] [EmulatorName] [InstanceName]" & @CRLF & @CRLF & _
					 "With the first command line parameter, specify the Profilename (you can create profiles on the Misc tab, if a " & _
					 "profilename contains a {space}, then enclose the profilename in double quotes). " & _
					 "With the second, specify the name of the Emulator and with the third, an Android Instance (not for BlueStacks). " & @CRLF & _
					 "Supported Emulators are MEmu, Droid4X, Nox, BlueStacks2 and BlueStacks." & @CRLF & @CRLF & _
					 "Examples:" & @CRLF & _
					 "     MyBot.run.exe MyVillage BlueStacks2" & @CRLF & _
					 '     MyBot.run.exe "My Second Village" MEmu MEmu_1'

$hMutex_BotTitle = _Singleton($sBotTitle, 1)
If $hMutex_BotTitle = 0 Then
	MsgBox($MB_OK + $MB_ICONINFORMATION, $sBotTitle, "My Bot for " & $Android & ($AndroidInstance <> "" ? " (instance " & $AndroidInstance & ")" : "") & " is already running." & @CRLF & @CRLF & $cmdLineHelp)
	Exit
EndIf

$hMutex_Profile = _Singleton(StringReplace($sProfilePath & "\" & $sCurrProfile, "\", "-"), 1)
If $hMutex_Profile = 0 Then
   _WinAPI_CloseHandle($hMutex_BotTitle)
	MsgBox($MB_OK + $MB_ICONINFORMATION, $sBotTitle, "My Bot with Profile " & $sCurrProfile & " is already running in " & $sProfilePath & "\" & $sCurrProfile & "." & @CRLF & @CRLF & $cmdLineHelp)
	Exit
EndIf

$hMutex_MyBot = _Singleton("MyBot.run", 1)
$OnlyInstance = $hMutex_MyBot <> 0 ; And False
SetDebugLog("My Bot is " & ($OnlyInstance ? "" : "not ") & "the only running instance")

#include "COCBot\MBR Global Variables Troops.au3"
#include "COCBot\MBR GUI Design.au3"
#include "COCBot\MBR GUI Control.au3"
#include "COCBot\MBR Functions.au3"

CheckPrerequisites() ; check for VC2010, .NET software and MyBot Files and Folders

;DirCreate($sTemplates)
DirCreate($sPreset)
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



;~ readCollectorConfig();initialize collector fullness variables before loading images

LoadTHImage() ; Load TH images
LoadElixirImage() ; Load Elixir images
LoadElixirImage75Percent(); Load Elixir images full at 75%
LoadElixirImage50Percent(); Load Elixir images full at 50%
LoadAmountOfResourcesImages()

;~ InitializeVariables();initialize variables used in extra windows
CheckVersion() ; check latest version on mybot.run site

;~ Remember time in Milliseconds bot launched
$iBotLaunchTime = TimerDiff($hBotLaunchTime)
SetDebugLog("MyBot.run launch time " & Round($iBotLaunchTime) & " ms.")

;~ Restore process priority
ProcessSetPriority(@AutoItPID, $iBotProcessPriority)

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

BotClose()

Func runBot() ;Bot that runs everything in order
	$TotalTrainedTroops = 0
	Local $Quickattack = False
	While 1
		$Restart = False
		$fullArmy = False
		$CommandStop = -1
		If _Sleep($iDelayRunBot1) Then Return
		checkMainScreen()
		If $Restart = True Then ContinueLoop
		chkShieldStatus()
		If $Restart = True Then ContinueLoop

		If $quicklyfirststart = true Then
			$quicklyfirststart = False
		Else
			$Quickattack = QuickAttack()
		EndIf

	    If checkAndroidTimeLag() = True Then ContinueLoop
		If $Is_ClientSyncError = False And $Is_SearchLimit = False and ($Quickattack = False ) Then
	    	If BotCommand() Then btnStop()
			If _Sleep($iDelayRunBot2) Then Return
			checkMainScreen(False)
			If $Restart = True Then ContinueLoop
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
			Local $Random1[3] = ['Collect', 'CheckTombs', 'ReArm']
			While 1
				If $RunState = False Then Return
				If $Restart = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
				If UBound($Random1) > 1 Then
					$Index = Random(0, UBound($Random1), 1)
					If $Index > UBound($Random1) - 1 Then $Index = UBound($Random1) - 1
					_RunFunction($Random1[$Index])
					_ArrayDelete($Random1, $Index)
				Else
					_RunFunction($Random1[0])
					ExitLoop
				EndIf
			    If $Restart = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
			WEnd
			If $RunState = False Then Return
			If $Restart = True Then ContinueLoop
			If GotoAttack() Then
			   Local $Random1[10] = ['ReplayShare', 'ReportNotify', 'DonateCC,Train', 'BoostBarracks', 'BoostSpellFactory', 'BoostDarkSpellFactory', 'BoostKing', 'BoostQueen', 'BoostWarden', 'RequestCC']
			   While 1
				   If $RunState = False Then Return
				   If $Restart = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
				   If UBound($Random1) > 1 Then
					   $Index = Random(0, UBound($Random1), 1)
					   If $Index > UBound($Random1) - 1 Then $Index = UBound($Random1) - 1
					   _RunFunction($Random1[$Index])
					   _ArrayDelete($Random1, $Index)
				   Else
					   _RunFunction($Random1[0])
					   ExitLoop
				   EndIf
				   If checkAndroidTimeLag() = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
			   WEnd
			   If $RunState = False Then Return
			   If $Restart = True Then ContinueLoop
			   If $iUnbreakableMode >= 1 Then
				 If Unbreakable() = True Then ContinueLoop
			   EndIf
			   Local $Random1[3] = ['Laboratory', 'UpgradeHeroes', 'UpgradeBuilding']
			   While 1
				   If $RunState = False Then Return
				   If $Restart = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
				   If UBound($Random1) > 1 Then
					   $Index = Random(0, UBound($Random1), 1)
					   If $Index > UBound($Random1) - 1 Then $Index = UBound($Random1) - 1
					   _RunFunction($Random1[$Index])
					   _ArrayDelete($Random1, $Index)
				   Else
					   _RunFunction($Random1[0])
					   ExitLoop
				   EndIf
				   If checkAndroidTimeLag() = True Then ContinueLoop 2 ; must be level 2 due to loop-in-loop
			   WEnd
			   If $RunState = False Then Return
			   If $Restart = True Then ContinueLoop
			   $iNbrOfWallsUpped = 0
			   UpgradeWall()
			   If _Sleep($iDelayRunBot3) Then Return
			   If $Restart = True Then ContinueLoop
			   Idle()
			   ;$fullArmy1 = $fullArmy
			   If _Sleep($iDelayRunBot3) Then Return
			   If $Restart = True Then ContinueLoop
			   SaveStatChkTownHall()
			   SaveStatChkDeadBase()
			   If $CommandStop <> 0 And $CommandStop <> 3 Then
				  AttackMain()
				  If $OutOfGold = 1 Then
					 Setlog("Switching to Halt Attack, Stay Online/Collect mode ...", $COLOR_RED)
					 $ichkBotStop = 1 ; set halt attack variable
					 $icmbBotCond = 18 ; set stay online/collect only mode
					 $FirstStart = True ; reset First time flag to ensure army balancing when returns to training
					 ContinueLoop
				  EndIf
				  If _Sleep($iDelayRunBot1) Then Return
				  If $Restart = True Then ContinueLoop
			   EndIf
			Else
			   SetLog("Attacking Not Planned, Skipped.., So Waiting", $COLOR_RED)
			   If _SleepStatus($iDelayWaitAttack) Then Return False
			EndIf
	    Else ;When error occours directly goes to attack
			If $Quickattack Then
				Setlog("Quick Restart... ",$color_blue)
			Else
				If $Is_SearchLimit = True Then
					SetLog("Restarted due search limit", $COLOR_BLUE)
				Else
					SetLog("Restarted after Out of Sync Error: Attack Now", $COLOR_BLUE)
				EndIf
			EndIf
			If _Sleep($iDelayRunBot3) Then Return
			;  OCR read current Village Trophies when OOS restart maybe due PB or else DropTrophy skips one attack cycle after OOS
			$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
			If $debugsetlog = 1 Then SetLog("Runbot Trophy Count: " & $iTrophyCurrent, $COLOR_PURPLE)
			AttackMain()
			If $OutOfGold = 1 Then
				Setlog("Switching to Halt Attack, Stay Online/Collect mode ...", $COLOR_RED)
				$ichkBotStop = 1 ; set halt attack variable
				$icmbBotCond = 18 ; set stay online/collect only mode
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
	While $fullArmy = False Or $bFullArmyHero = False
		checkAndroidTimeLag()

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
			If _Sleep($iDelayIdle1) Then Return
			getArmyHeroCount(True, True)
			If Not ($fullArmy) And $bTrainEnabled = True Then
				SetLog("Army Camp and Barracks are not full, Training Continues...", $COLOR_ORANGE)
				$CommandStop = 0
			EndIf
		EndIf
		ReplayShare($iShareAttackNow)
		If _Sleep($iDelayIdle1) Then Return
		CleanYard()
		If $Restart = True Then ExitLoop
		If $iCollectCounter > $COLLECTATCOUNT Then ; This is prevent from collecting all the time which isn't needed anyway
 			Local $Random1[2] = ['Collect', 'DonateCC']
			While 1
				If $RunState = False Then Return
				If $Restart = True Then ExitLoop
				If UBound($Random1) > 1 Then
					$Index = Random(0, UBound($Random1), 1)
					If $Index > UBound($Random1) - 1 Then $Index = UBound($Random1) - 1
					_RunFunction($Random1[$Index])
					_ArrayDelete($Random1, $Index)
				Else
					_RunFunction($Random1[0])
					ExitLoop
				EndIf
			WEnd
			If $RunState = False Then Return
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

		If $CurCamp >=  $TotalCamp * $iEnableAfterArmyCamps[$DB]/100 and $iEnableSearchCamps[$DB]  = 1 Then Exitloop
		If $CurCamp >=  $TotalCamp * $iEnableAfterArmyCamps[$LB]/100 and $iEnableSearchCamps[$LB]  = 1 Then Exitloop
		If $CurCamp >=  $TotalCamp * $iEnableAfterArmyCamps[$TS]/100 and $iEnableSearchCamps[$TS]  = 1 Then Exitloop

		SetLog("Time Idle: " & StringFormat("%02i", Floor(Floor($TimeIdle / 60) / 60)) & ":" & StringFormat("%02i", Floor(Mod(Floor($TimeIdle / 60), 60))) & ":" & StringFormat("%02i", Floor(Mod($TimeIdle, 60))))

		If $OutOfGold = 1 Or $OutOfElixir = 1 Then Return  ; Halt mode due low resources, only 1 idle loop
		If $iChkSnipeWhileTrain = 1 Then SnipeWhileTrain()  ;snipe while train
	WEnd
EndFunc   ;==>Idle

Func AttackMain() ;Main control for attack functions
	;LoadAmountOfResourcesImages() ; for debug
	If GotoAttack() Then
		If (IsSearchModeActive($DB) And checkCollectors(True, False)) or IsSearchModeActive($LB) or IsSearchModeActive($TS) Then
			If $iChkUseCCBalanced = 1 or $iChkUseCCBalancedCSV = 1 Then ;launch profilereport() only if option balance D/R it's activated
				ProfileReport()
				If _Sleep($iDelayAttackMain1) Then Return
				checkMainScreen(False)
				If $Restart = True Then Return
			EndIf
			If $iChkTrophyRange = 1 and Number($iTrophyCurrent) > Number($iTxtMaxTrophy) Then ;If current trophy above max trophy, try drop first
				DropTrophy()
				$Is_ClientSyncError = False ; reset OOS flag to prevent looping.
				If _Sleep($iDelayAttackMain1) Then Return
				Return ; return to runbot, refill armycamps
			EndIf
			If $debugsetlog = 1 Then
				SetLog(_PadStringCenter(" Hero status check" & BitAND($iHeroAttack[$DB], $iHeroWait[$DB], $iHeroAvailable) & "|" & $iHeroWait[$DB] & "|" & $iHeroAvailable, 54, "="), $COLOR_PURPLE)
				SetLog(_PadStringCenter(" Hero status check" & BitAND($iHeroAttack[$LB], $iHeroWait[$LB], $iHeroAvailable) & "|" & $iHeroWait[$LB] & "|" & $iHeroAvailable, 54, "="), $COLOR_PURPLE)
				;Setlog("BullyMode: " & $OptBullyMode & ", Bully Hero: " & BitAND($iHeroAttack[$iTHBullyAttackMode], $iHeroWait[$iTHBullyAttackMode], $iHeroAvailable) & "|" & $iHeroWait[$iTHBullyAttackMode] & "|" & $iHeroAvailable, $COLOR_PURPLE)
			EndIf
				PrepareSearch()
				If $OutOfGold = 1 Then Return ; Check flag for enough gold to search
				If $Restart = True Then Return
			VillageSearch()
				If $OutOfGold = 1 Then Return ; Check flag for enough gold to search
				If $Restart = True Then Return
			PrepareAttack($iMatchMode)
				If $Restart = True Then Return
			Attack()
				If $Restart = True Then Return
			ReturnHome($TakeLootSnapShot)
				If _Sleep($iDelayAttackMain2) Then Return
			Return True
		Else
			Setlog("No one of search condition match: (wait troops and/or heroes according to search settings)", $COLOR_BLUE)
			Setlog(" - wait troops and/or heroes according to search settings", $COLOR_BLUE)
		EndIf
	Else
		SetLog("Attacking Not Planned, Skipped..", $COLOR_RED)
	EndIf
EndFunc   ;==>AttackMain

Func Attack() ;Selects which algorithm
	SetLog(" ====== Start Attack ====== ", $COLOR_GREEN)
	If  ($iMatchMode = $DB and $iAtkAlgorithm[$DB] = 1) or ($iMatchMode = $LB and  $iAtkAlgorithm[$LB] = 1) Then
		If $debugsetlog=1 Then Setlog("start scripted attack",$COLOR_RED)
		Algorithm_AttackCSV()
	Elseif $iMatchMode= $DB and  $iAtkAlgorithm[$DB] = 2 Then
		If $debugsetlog=1 Then Setlog("start milking attack",$COLOR_RED)
		Alogrithm_MilkingAttack()
	Else
		If $debugsetlog=1 Then Setlog("start standard attack",$COLOR_RED)
		algorithm_AllTroops()
	EndIf
EndFunc   ;==>Attack


Func QuickAttack()
   Local   $quicklymilking=0
   Local   $quicklythsnipe=0
   If ( $iAtkAlgorithm[$DB] = 2  and IsSearchModeActive($DB) ) or (IsSearchModeActive($TS) ) Then
	  getArmyCapacity(true,true)
	  VillageReport()
   EndIf
   $iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
   If ($iChkTrophyRange = 1 and Number($iTrophyCurrent) > Number($iTxtMaxTrophy) )  then
	  If $debugsetlog=1 Then Setlog("No quickly re-attack, need to drop tropies",$COLOR_PURPLE )
	  return False ;need to drop tropies
   EndIf
   If $iAtkAlgorithm[$DB] = 2  and IsSearchModeActive($DB) Then
	  If Int($CurCamp) >=  $TotalCamp * $iEnableAfterArmyCamps[$DB]/100 and $iEnableSearchCamps[$DB]  = 1   Then
		 If $debugsetlog=1 Then Setlog("Milking: Quickly re-attack " &  Int($CurCamp) & " >= " & $TotalCamp & " * " & $iEnableAfterArmyCamps[$DB] & "/100 " & "= " &   $TotalCamp * $iEnableAfterArmyCamps[$DB]/100 ,$COLOR_PURPLE )
		 return true ;milking attack OK!
	  Else
		 If $debugsetlog=1 Then Setlog("Milking: No Quickly re-attack:  cur. "  & Int($CurCamp) & "  need " & $TotalCamp * $iEnableAfterArmyCamps[$DB]/100 & " firststart = " &  ($quicklyfirststart)  ,$COLOR_PURPLE)
		 return false ;milking attack no restart.. no enough army
	  EndIf
   EndIf
   If IsSearchModeActive($TS) Then
	  If Int($CurCamp) >=  $TotalCamp * $iEnableAfterArmyCamps[$TS]/100 and $iEnableSearchCamps[$TS]  = 1  Then
		 If $debugsetlog=1 Then Setlog("THSnipe: Quickly re-attack " &  Int($CurCamp) & " >= " & $TotalCamp & " * " & $iEnableAfterArmyCamps[$TS] & "/100 " & "= " &   $TotalCamp * $iEnableAfterArmyCamps[$TS]/100 ,$COLOR_PURPLE )
		 return True ;ts snipe attack OK!
	  Else
		 If $debugsetlog=1 Then Setlog("THSnipe: No Quickly re-attack:  cur. "  & Int($CurCamp) & "  need " & $TotalCamp * $iEnableAfterArmyCamps[$TS]/100 & " firststart = " &  ($quicklyfirststart)  ,$COLOR_PURPLE)
		 return False ;ts snipe no restart... no enough army
	  EndIF
   EndIf

EndFunc

Func GotoAttack()

	 If $iPlannedAttackWeekDays[@WDAY - 1] = 1 Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		$hourLoot = $hour[0]
		If $iPlannedattackHours[$hourLoot] = 1 Then
			Return True
		Else
			Return False
		EndIf
	 Else
		SetLog("Attack not Planned to: " & _DateDayOfWeek(@WDAY), $COLOR_ORANGE)
		Return False
	 EndIf

EndFunc   ;==>GotoAttack

Func _RunFunction($action)
	SetDebugLog("_RunFunction: " & $action & " BEGIN")
	Switch $action
		Case "Collect"
			Collect()
			_Sleep($iDelayRunBot1)
		Case "CheckTombs"
			CheckTombs()
			_Sleep($iDelayRunBot3)
		Case "ReArm"
			ReArm()
			_Sleep($iDelayRunBot3)
		Case "ReplayShare"
			ReplayShare($iShareAttackNow)
			_Sleep($iDelayRunBot3)
		Case "ReportNotify"
			ReportNotify()
			_Sleep($iDelayRunBot3)
		Case "DonateCC"
			DonateCC()
			If _Sleep($iDelayRunBot1) = False Then checkMainScreen(False)
		Case "DonateCC,Train"
			DonateCC()
			If _Sleep($iDelayRunBot1) = False Then checkMainScreen(False)
			Train()
			_Sleep($iDelayRunBot1)
		Case "BoostBarracks"
			BoostBarracks()
		Case "BoostSpellFactory"
			BoostSpellFactory()
		Case "BoostDarkSpellFactory"
			BoostDarkSpellFactory()
		Case "BoostKing"
			BoostKing()
		Case "BoostQueen"
			BoostQueen()
		Case "BoostWarden"
			BoostWarden()
		Case "RequestCC"
			RequestCC()
			If _Sleep($iDelayRunBot1) = False Then checkMainScreen(False)
		Case "Laboratory"
			Laboratory()
			If _Sleep($iDelayRunBot3) = False Then checkMainScreen(False)
		Case "UpgradeHeroes"
			UpgradeHeroes()
			_Sleep($iDelayRunBot3)
		Case "UpgradeBuilding"
			UpgradeBuilding()
			_Sleep($iDelayRunBot3)
		Case ""
			SetDebugLog("Function call doesn't support empty string, please review array size", $COLOR_RED)
		Case Else
			SetLog("Unknown function call: " & $action, $COLOR_RED)
	EndSwitch
	SetDebugLog("_RunFunction: " & $action & " END")
EndFunc   ;==>_RunFunction
