; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Train Army" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), Boju (11-2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_TRAINARMY = 0
Global $g_hGUI_TRAINARMY_TAB = 0, $g_hGUI_TRAINARMY_TAB_ITEM1 = 0, $g_hGUI_TRAINARMY_TAB_ITEM2 = 0, $g_hGUI_TRAINARMY_TAB_ITEM3 = 0, $g_hGUI_TRAINARMY_TAB_ITEM4 = 0

; Troops/Spells sub-tab
Global $g_hChkUseQuickTrain = 0, $g_hRdoArmy1 = 0, $g_hRdoArmy2 = 0, $g_hRdoArmy3 = 0
Global $g_ahTxtTrainArmyTroopCount[$eTroopCount] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahLblTrainArmyTroopLevel[$eTroopCount] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahTxtTrainArmySpellCount[$eSpellCount] = [0,0,0,0,0,0,0,0,0,0]
Global $g_ahLblTrainArmySpellLevel[$eSpellCount] = [0,0,0,0,0,0,0,0,0,0]
Global $g_hTxtFullTroop = 0, $g_hChkTotalCampForced = 0, $g_hTxtTotalCampForced = 0, $g_hChkForceBrewBeforeAttack = 0

Global $g_hGrpTrainTroops = 0, $g_hGrpCookSpell = 0
Global $g_ahPicTrainArmyTroop[$eTroopCount] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahPicTrainArmySpell[$eSpellCount] = [0,0,0,0,0,0,0,0,0,0]
Global $g_hLblTotalTimeCamp = 0, $g_hLblElixirCostCamp = 0, $g_hLblDarkCostCamp = 0, $g_hCalTotalTroops = 0, $g_hLblTotalProgress = 0, $g_hLblCountTotal = 0, _
	   $g_hTxtTotalCountSpell = 0, $g_hLblTotalTimeSpell = 0, $g_hLblElixirCostSpell = 0, $g_hLblDarkCostSpell = 0

; Boost sub-tab
Global $g_hCmbBoostBarracks = 0, $g_hCmbBoostSpellFactory = 0, $g_hCmbBoostBarbarianKing = 0, $g_hCmbBoostArcherQueen = 0, $g_hCmbBoostWarden = 0
Global $g_hChkBoostBarracksHours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], $g_hChkBoostBarracksHoursE1 = 0, $g_hChkBoostBarracksHoursE2 = 0

; Train Order sub-tab
Global Const $g_asTroopOrderList[] = [ "", _
   GetTranslated(604,1, "Barbarians"), GetTranslated(604,2, "Archers"), GetTranslated(604,3, "Giants"), GetTranslated(604,4, "Goblins"), _
   GetTranslated(604,5, "Wall Breakers"), GetTranslated(604,7, "Balloons"), GetTranslated(604,8, "Wizards"), GetTranslated(604,9, "Healers"), _
   GetTranslated(604,10, "Dragons"), GetTranslated(604,11, "Pekkas"), GetTranslated(604,20, "Baby Dragons"), GetTranslated(604,21, "Miners"), _
   GetTranslated(604,13, "Minions"), GetTranslated(604,14, "Hog Riders"), GetTranslated(604,15, "Valkyries"), GetTranslated(604,16, "Golems"), _
   GetTranslated(604,17, "Witches"), GetTranslated(604,18, "Lava Hounds"), GetTranslated(604, 19, "Bowlers") ]
Global $g_hChkCustomTrainOrderEnable = 0
Global $g_ahCmbTroopOrder[$eTroopCount] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahImgTroopOrder[$eTroopCount] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hBtnTroopOrderSet = 0, $g_ahImgTroopOrderSet = 0

; Options sub-tab
Global $g_hChkCloseWhileTraining = 0, $g_hChkCloseWithoutShield = 0, $g_hChkCloseEmulator = 0, $g_hChkRandomClose = 0, $g_hRdoCloseWaitExact = 0, $g_hRdoCloseWaitRandom = 0
Global $g_hCmbCloseWaitRdmPercent = 0, $g_hCmbMinimumTimeClose = 0, $g_hSldTrainITDelay = 0, $g_hChkTrainAddRandomDelayEnable = 0, $g_hTxtAddRandomDelayMin = 0, _
	   $g_hTxtAddRandomDelayMax = 0

Global $g_hLblCloseWaitRdmPercent = 0, $g_hLblCloseWaitingTroops = 0, $g_hLblSymbolWaiting = 0, $g_hLblWaitingInMinutes = 0, $g_hLblTrainITDelay = 0, $g_hLblTrainITDelayTime = 0, _
	   $g_hLblAddDelayIdlePhaseBetween = 0, $g_hLblAddDelayIdlePhaseSec = 0, $g_hPicCloseWaitTrain = 0, $g_hPicCloseWaitStop = 0, $g_hPicCloseWaitExact = 0

Func CreateAttackTroops()
   $g_hGUI_TRAINARMY = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_ATTACK)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_TRAINARMY)

   $g_hGUI_TRAINARMY_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))

   CreateTroopsSpellsSubTab()
   CreateBoostSubTab()
   CreateTrainOrderSubTab()
   CreateOptionsSubTab()

EndFunc


Func CreateTroopsSpellsSubTab()
   $g_hGUI_TRAINARMY_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600, 52, "Troops/Spells"))

   Local $sTxtSetPerc = GetTranslated(621, 26, "Enter the No. of")
   Local $sTxtSetPerc2 = GetTranslated(621, 27, " to make.")
   Local $sTxtSetPerc3 = GetTranslated(621, 28, "Enter the No. of")
   Local $sTxtSetSpell = GetTranslated(621, 29, "Spells to make.")

   Local $x = 0
   Local $y = 8
	   $g_hChkUseQuickTrain = GUICtrlCreateCheckbox(GetTranslated(621, 34, "Use Quick Train"), $x + 15, $y + 19, -1, 15)
	   GUICtrlSetState(-1, $GUI_UNCHECKED)
	   GUICtrlSetOnEvent(-1, "chkUseQTrain")
	   $g_hRdoArmy1 = GUICtrlCreateRadio(GetTranslated(621, 37, "Army 1"), $x + 120, $y + 20, 50, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hRdoArmy2 = GUICtrlCreateRadio(GetTranslated(621, 38, "Army 2"), $x + 180, $y + 20, 50, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   $g_hRdoArmy3 = GUICtrlCreateRadio(GetTranslated(621, 39, "Army 3"), $x + 240, $y + 20, 50, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(GetTranslated(621, 41, "Remove Army"), $x + 335, $y + 20, -1, 15, $SS_LEFT)
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x + 405, $y + 17, 24, 24)
	   GUICtrlSetOnEvent(-1, "Removecamp")

   $x = 10
   $y = 45
   $g_hGrpTrainTroops = GUICtrlCreateGroup(GetTranslated(1000, 1, "Train Troops"), $x, $y, 418, 195)

	  $x = 30
	  $y += 20
		  ; Barbarians
		  Local $sTroopName = GetTranslated(604,1, "Barbarians")
		  $g_ahPicTrainArmyTroop[$eTroopBarbarian] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarbarian, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, "Level") & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, "Mouse Left Click to Up level" & @CRLF & "Shift + Mouse Left Click to Down level"))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopBarbarian] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopBarbarian] = GUICtrlCreateInput("58", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 3)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Giants
		  Local $sTroopName = GetTranslated(604,3, "Giants")
		  $g_ahPicTrainArmyTroop[$eTroopGiant] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGiant, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopGiant] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopGiant] = GUICtrlCreateInput("4", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; WallBreakers
		  Local $sTroopName = GetTranslated(604,5, "Wall Breakers")
		  $g_ahPicTrainArmyTroop[$eTroopWallBreaker] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallBreaker, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopWallBreaker] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopWallBreaker] = GUICtrlCreateInput("4", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 3)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Wizards
		  Local $sTroopName = GetTranslated(604,8, "Wizards")
		  $g_ahPicTrainArmyTroop[$eTroopWizard] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizard, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopWizard] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopWizard] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Dragon
		  Local $sTroopName = GetTranslated(604,10, "Dragons")
		  $g_ahPicTrainArmyTroop[$eTroopDragon] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragon, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopDragon] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopDragon] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; BDragon
		  Local $sTroopName = GetTranslated(604,20, "Baby Dragons")
		  $g_ahPicTrainArmyTroop[$eTroopBabyDragon] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBabyDragon, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopBabyDragon] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopBabyDragon] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 45
		  ; Minions
		  Local $sTroopName = GetTranslated(604,13, "Minions")
		  $g_ahPicTrainArmyTroop[$eTroopMinion] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnMinion, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopMinion] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopMinion] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 3)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Valkyries
		  Local $sTroopName = GetTranslated(604,15, "Valkyries")
		  $g_ahPicTrainArmyTroop[$eTroopValkyrie] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnValkyrie, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopValkyrie] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopValkyrie] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Witches
		  Local $sTroopName = GetTranslated(604,17, "Witches")
		  $g_ahPicTrainArmyTroop[$eTroopWitch] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnWitch, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopWitch] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopWitch] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Bowlers
		  Local $sTroopName = GetTranslated(604, 19, "Bowlers")
		  $g_ahPicTrainArmyTroop[$eTroopBowler] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBowler, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopBowler] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopBowler] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  ; Next Row
	  $x = 30
	  $y += 60

		  ; Archers
		  Local $sTroopName = GetTranslated(604,2, "Archers")
		  $g_ahPicTrainArmyTroop[$eTroopArcher] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcher, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopArcher] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopArcher] = GUICtrlCreateInput("115", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 3)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Goblins
		  Local $sTroopName = GetTranslated(604,4, "Goblins")
		  $g_ahPicTrainArmyTroop[$eTroopGoblin] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoblin, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopGoblin] = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopGoblin] = GUICtrlCreateInput("19", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 3)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Balloons
		  Local $sTroopName = GetTranslated(604,7, "Balloons")
		  $g_ahPicTrainArmyTroop[$eTroopBalloon] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBalloon, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopBalloon] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopBalloon] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Healers
		  Local $sTroopName = GetTranslated(604,9, "Healers")
		  $g_ahPicTrainArmyTroop[$eTroopHealer] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealer, $x, $y - 5, 32, 32)
		  _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopHealer] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopHealer] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Pekkas
		  Local $sTroopName = GetTranslated(604,11, "Pekkas")
		  $g_ahPicTrainArmyTroop[$eTroopPekka] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnPekka, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopPekka] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopPekka] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Miners
		  Local $sTroopName = GetTranslated(604,21, "Miners")
		  $g_ahPicTrainArmyTroop[$eTroopMiner] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnMiner, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopMiner] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopMiner] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		  _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 45
		  ; Hogs
		  Local $sTroopName = GetTranslated(604,14, "Hog Riders")
		  $g_ahPicTrainArmyTroop[$eTroopHogRider] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHogRider, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopHogRider] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopHogRider] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Golems
		  Local $sTroopName = GetTranslated(604,16, "Golems")
		  $g_ahPicTrainArmyTroop[$eTroopGolem] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGolem, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopGolem] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopGolem] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x += 38
		  ; Lavas
		  Local $sTroopName = GetTranslated(604,18, "Lava Hounds")
		  $g_ahPicTrainArmyTroop[$eTroopLavaHound] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLavaHound, $x, $y - 5, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTroopName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainTroopLevelClick")
		  $g_ahLblTrainArmyTroopLevel[$eTroopLavaHound] = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmyTroopCount[$eTroopLavaHound] = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTroopName & " " & $sTxtSetPerc2)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainTroopCountEdit")

	  $x = 30
	  $y += 66
		  GUICtrlCreateIcon($g_sLibIconPath, $eIcnCamp, $x - 10, $y - 15, 24, 24)
		  GUICtrlCreateLabel(GetTranslated(621, 20, "'Full' Camps"), $x + 16, $y - 7, 55, 17)
		  GUICtrlCreateLabel(ChrW(8805), $x + 75, $y - 7, -1, 17)
		  $g_hTxtFullTroop = GUICtrlCreateInput("100", $x + 84, $y - 10, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 GUICtrlSetOnEvent(-1, "SetComboTroopComp")
			 _GUICtrlSetTip(-1, GetTranslated(621, 21, "Army camps are 'Full' when reaching this %, then start attack."))
			 GUICtrlSetLimit(-1, 3)
		  GUICtrlCreateLabel("%", $x + 115, $y - 7, -1, 17)

	  $x += 180
	  $Y -= 23
		  GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopsCost, $x - 33, $y + 10, 24, 24)
		  $g_hLblTotalTimeCamp = GUICtrlCreateLabel(" 0s", $x - 11, $y + 15, 70, 15, $SS_RIGHT)
			 GUICtrlSetBkColor(-1, $COLOR_GRAY)
			 GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			 GUICtrlSetColor(-1, $COLOR_WHITE)
		  $g_hLblElixirCostCamp = GUICtrlCreateLabel(" 0", $x + 65, $y + 15, 77, 15, $SS_RIGHT)
			 GUICtrlSetBkColor(-1, $COLOR_GRAY)
			 GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			 GUICtrlSetColor(-1, $COLOR_WHITE)
		  GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 63, $y + 14, 16, 16)
		  $g_hLblDarkCostCamp = GUICtrlCreateLabel(" 0", $x + 148, $y + 15, 62, 15, $SS_RIGHT)
			 GUICtrlSetBkColor(-1, $COLOR_GRAY)
			 GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			 GUICtrlSetColor(-1, $COLOR_WHITE)
		  GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 146, $y + 14, 16, 16)

	  $x -= 195
	  $Y += 35
		  $g_hChkTotalCampForced = GUICtrlCreateCheckbox(GetTranslated(636, 46, "Force Total Army Camp") & ":", $x + 3, $y, -1, -1)
			 GUICtrlSetState(-1, $GUI_CHECKED)
			 GUICtrlSetOnEvent(-1, "chkTotalCampForced")
			 _GUICtrlSetTip(-1, GetTranslated(636, 47, "If not detected set army camp values (instead ask)"))
		  $g_hTxtTotalCampForced = GUICtrlCreateInput("220", $x + 137, $y + 3, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 GUICtrlSetOnEvent(-1, "SetComboTroopComp")
			 GUICtrlSetLimit(-1, 3)

		  $g_hCalTotalTroops = GUICtrlCreateProgress($x, $y + 22, 407, 10)
		  $g_hLblTotalProgress = GUICtrlCreateLabel("", $x, $y + 22, 407, 10)
			 GUICtrlSetBkColor(-1, $COLOR_RED)
			 GUICtrlSetState(-1, BitOR($GUI_DISABLE, $GUI_HIDE))

	  $x += 38
		  GUICtrlCreateLabel(GetTranslated(621, 15, "Total"), $x + 295, $y + 7, -1, -1, $SS_RIGHT)
		  $g_hLblCountTotal = GUICtrlCreateLabel(0, $x + 330, $y + 5, 30, 15, $SS_CENTER)
			 _GUICtrlSetTip(-1, GetTranslated(621, 16, "The total Units of Troops should equal Total Army Camps."))
			 GUICtrlSetBkColor(-1, $COLOR_MONEYGREEN) ;lime, moneygreen
		  GUICtrlCreateLabel("x", $x + 364, $y + 7, -1, -1)

   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $x = 10
   $y = 240
   $g_hGrpCookSpell = GUICtrlCreateGroup(GetTranslated(1000, 2, "Brew Spells"), $x, $y, 418, 123)
	  $x += 20
	  $y += 17
		  GUICtrlCreateLabel(GetTranslated(622, 2, "Spell Capacity") & " :", $x - 15, $y, -1, -1, $SS_RIGHT)
		  $g_hTxtTotalCountSpell = GUICtrlCreateCombo("", $x + 80, $y - 3, 35, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			 _GUICtrlSetTip(-1, GetTranslated(622, 3, "Enter the No. of Spells Capacity. Set to ZERO if you don't want any Spells"))
			 ;GUICtrlSetBkColor(-1, $COLOR_MONEYGREEN) ;lime, moneygreen
			 GUICtrlSetData(-1, "0|2|4|6|7|8|9|10|11", "0")
			 GUICtrlSetOnEvent(-1, "TotalSpellCountClick")

	  $y += 13
		  Local $sSpellName = GetTranslated(605,1, "Lightning Spell")
		  $g_ahPicTrainArmySpell[$eSpellLightning] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellLightning] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellLightning] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $x += 38
		  Local $sSpellName = GetTranslated(605,2, "Healing Spell")
		  $g_ahPicTrainArmySpell[$eSpellHeal] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellHeal] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellHeal] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $x += 38
		  Local $sSpellName = GetTranslated(605,3, "Rage Spell")
		  $g_ahPicTrainArmySpell[$eSpellRage] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellRage] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellRage] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $x += 38
		  Local $sSpellName = GetTranslated(605,4, "Jump Spell")
		  $g_ahPicTrainArmySpell[$eSpellJump] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellJump] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellJump] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $x += 38
		  Local $sSpellName = GetTranslated(605,5, "Freeze Spell")
		  $g_ahPicTrainArmySpell[$eSpellFreeze] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellFreeze] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellFreeze] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $x += 38
		  Local $sSpellName = GetTranslated(605,12, "Clone Spell")
		  $g_ahPicTrainArmySpell[$eSpellClone] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellClone] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellClone] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $x += 45
		  Local $sSpellName = GetTranslated(605,6, "Poison Spell")
		  $g_ahPicTrainArmySpell[$eSpellPoison] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellPoison] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellPoison] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $x += 38
		  Local $sSpellName = GetTranslated(605,7, "EarthQuake Spell")
		  $g_ahPicTrainArmySpell[$eSpellEarthquake] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellEarthquake] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellEarthquake] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $x += 38
		  Local $sSpellName = GetTranslated(605,8, "Haste Spell")
		  $g_ahPicTrainArmySpell[$eSpellHaste] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellHaste] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellHaste] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $x += 38
		  Local $sSpellName = GetTranslated(605,13, "Skeleton Spell")
		  $g_ahPicTrainArmySpell[$eSpellSkeleton] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell, $x, $y + 10, 32, 32)
			 _GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sSpellName & ":" & @CRLF & GetTranslated(621,40, -1))
			 GUICtrlSetOnEvent(-1, "TrainSpellLevelClick")
		  $g_ahLblTrainArmySpellLevel[$eSpellSkeleton] = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
			 GUICtrlSetBkColor(-1, $COLOR_WHITE)
			 GUICtrlSetFont(-1, 7, 400)
		  $g_ahTxtTrainArmySpellCount[$eSpellSkeleton] = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			 _GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sSpellName & " " & $sTxtSetSpell)
			 GUICtrlSetState(-1, $GUI_HIDE)
			 GUICtrlSetLimit(-1, 2)
			 GUICtrlSetOnEvent(-1, "TrainSpellCountEdit")

	  $y += 56
	  $x = 17
		  $g_hChkForceBrewBeforeAttack = GUICtrlCreateCheckbox(GetTranslated(621, 42, "Force Brew Spells"), $x, $y + 12, -1, -1)
		  GUICtrlSetState(-1, $GUI_UNCHECKED)

	  $x = 210
		  GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellsCost, $x - 33, $y + 10, 24, 24)
		  $g_hLblTotalTimeSpell = GUICtrlCreateLabel(" 0s", $x - 11, $y + 15, 70, 15, $SS_RIGHT)
			 GUICtrlSetBkColor(-1, $COLOR_GRAY)
			 GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			 GUICtrlSetColor(-1, $COLOR_WHITE)
		  $g_hLblElixirCostSpell = GUICtrlCreateLabel(" 0", $x + 65, $y + 15, 77, 15, $SS_RIGHT)
			 GUICtrlSetBkColor(-1, $COLOR_GRAY)
			 GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			 GUICtrlSetColor(-1, $COLOR_WHITE)
		  GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 63, $y + 14, 16, 16)
		  $g_hLblDarkCostSpell = GUICtrlCreateLabel(" 0", $x + 148, $y + 15, 62, 15, $SS_RIGHT)
			 GUICtrlSetBkColor(-1, $COLOR_GRAY)
			 GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
			 GUICtrlSetColor(-1, $COLOR_WHITE)
		  GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 146, $y + 14, 16, 16)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func  CreateBoostSubTab()
   Local $sTextBoostLeft = GetTranslated(623, 1, "Boosts left")
   Local $sTxtTip = ""

   $g_hGUI_TRAINARMY_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600, 22, "Boost"))

   Local $x = 25, $y = 45
   GUICtrlCreateGroup(GetTranslated(623, 2, "Boost Barracks"), $x - 20, $y - 20, 430, 60)
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarrackBoost, $x - 10, $y + 5, 24, 24)
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkBarrackBoost, $x + 19, $y + 5, 24, 24)
	   GUICtrlCreateLabel(GetTranslated(623, 5, "Barracks") & " " & $sTextBoostLeft, $x + 20 + 29, $y + 4 + 7, -1, -1)
		  $sTxtTip = GetTranslated(623, 6, "Use this to boost your Barracks with GEMS! Use with caution!")
		  _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hCmbBoostBarracks = GUICtrlCreateCombo("", $x + 140 + 45, $y + 7, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		  GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
		  _GUICtrlSetTip(-1, $sTxtTip)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += 65
   GUICtrlCreateGroup(GetTranslated(623, 7, "Boost Spell Factories"), $x - 20, $y - 20, 430, 50)
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpellFactoryBoost, $x - 10, $y - 2, 24, 24)
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDarkSpellBoost, $x + 19, $y - 2, 24, 24)
	   GUICtrlCreateLabel(GetTranslated(623, 8, "Spell Factory") & " " & $sTextBoostLeft, $x + 20 + 29, $y + 4, -1, -1)
		  $sTxtTip = GetTranslated(623, 9, "Use this to boost your Spell Factory with GEMS! Use with caution!")
		  _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hCmbBoostSpellFactory = GUICtrlCreateCombo("", $x + 185, $y, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		  GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
		  _GUICtrlSetTip(-1, $sTxtTip)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += 55
   GUICtrlCreateGroup(GetTranslated(623, 12, "Boost Heroes"), $x - 20, $y - 20, 430, 95)
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnKingBoost, $x - 10, $y - 2, 24, 24)
	   GUICtrlCreateLabel(GetTranslated(623, 13, "Barbarian King") & " " & $sTextBoostLeft, $x + 20, $y + 4, -1, -1)
		  $sTxtTip = GetTranslated(623, 14, "Use this to boost your Barbarian King with GEMS! Use with caution!")
		  _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hCmbBoostBarbarianKing = GUICtrlCreateCombo("", $x + 185, $y, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		  GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
		  _GUICtrlSetTip(-1, $sTxtTip)
		  GUICtrlSetOnEvent(-1, "chkUpgradeKing")

   $y += 25
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueenBoost, $x - 10, $y - 2, 24, 24)
	   GUICtrlCreateLabel(GetTranslated(623, 15, "Archer Queen") & " " & $sTextBoostLeft, $x + 20, $y + 4, -1, -1)
		  $sTxtTip = GetTranslated(623, 16, "Use this to boost your Archer Queen with GEMS! Use with caution!")
		  _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hCmbBoostArcherQueen = GUICtrlCreateCombo("", $x + 185, $y, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		  GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
		  _GUICtrlSetTip(-1, $sTxtTip)
		  GUICtrlSetOnEvent(-1, "chkUpgradeQueen")

   $y += 25
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenBoost, $x - 10, $y - 2, 24, 24)
	   GUICtrlCreateLabel(GetTranslated(623, 17, "Grand Warden") & " " & $sTextBoostLeft, $x + 20, $y + 4, -1, -1)
		  $sTxtTip = GetTranslated(623, 18, "Use this to boost your Grand Warden with GEMS! Use with caution!")
		  _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hCmbBoostWarden = GUICtrlCreateCombo("", $x + 185, $y, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		  GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
		  _GUICtrlSetTip(-1, $sTxtTip)
		  GUICtrlSetOnEvent(-1, "chkUpgradeWarden")
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += 50
   GUICtrlCreateGroup(GetTranslated(623, 19, "Boost Schedule"), $x - 20, $y - 20, 430, 70)

	   GUICtrlCreateLabel(" 0", $x + 30, $y)
	   GUICtrlCreateLabel(" 1", $x + 45, $y)
	   GUICtrlCreateLabel(" 2", $x + 60, $y)
	   GUICtrlCreateLabel(" 3", $x + 75, $y)
	   GUICtrlCreateLabel(" 4", $x + 90, $y)
	   GUICtrlCreateLabel(" 5", $x + 105, $y)
	   GUICtrlCreateLabel(" 6", $x + 120, $y)
	   GUICtrlCreateLabel(" 7", $x + 135, $y)
	   GUICtrlCreateLabel(" 8", $x + 150, $y)
	   GUICtrlCreateLabel(" 9", $x + 165, $y)
	   GUICtrlCreateLabel("10", $x + 180, $y)
	   GUICtrlCreateLabel("11", $x + 195, $y)
	   GUICtrlCreateLabel("X", $x + 213, $y + 2, 11, 11)

   $y += 15
	   $g_hChkBoostBarracksHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		  GUICtrlSetState(-1, $GUI_UNCHECKED)
		  _GUICtrlSetTip(-1, GetTranslated(603, 2, "This button will clear or set the entire row of boxes"))
		  GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE1")
	   GUICtrlCreateLabel(GetTranslated(603, 3, "AM"), $x + 5, $y)

   $y += 15
	   $g_hChkBoostBarracksHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   $g_hChkBoostBarracksHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		  GUICtrlSetState(-1, $GUI_UNCHECKED)
		  _GUICtrlSetTip(-1, GetTranslated(603, 2, -1))
		  GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE2")
	   GUICtrlCreateLabel(GetTranslated(603, 4, "PM"), $x + 5, $y)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   GUICtrlCreateTabItem("")
EndFunc

Func CreateTrainOrderSubTab()
   $g_hGUI_TRAINARMY_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600, 54, "Train Order"))
   SetDefaultTroopGroup(False)

   Local $x = 25, $y = 45
   GUICtrlCreateGroup(GetTranslated(641, 25, "Training Order"), $x - 20, $y - 20, 271, 335)
	   $g_hChkCustomTrainOrderEnable = GUICtrlCreateCheckbox(GetTranslated(641, 26, "Custom Order"), $x - 5, $y, -1, -1)
	   GUICtrlSetState(-1, $GUI_UNCHECKED)
	   _GUICtrlSetTip(-1, GetTranslated(641, 27, "Enable to select a custom troop training order") & @CRLF & _
						  GetTranslated(641, 28, "Changing train order can be useful with CSV scripted attack armies!"))
	   GUICtrlSetOnEvent(-1, "chkTroopOrder2")

	  If UBound($g_asTroopOrderList) - 1 <> $eTroopCount Then ; safety check in case troops are added
		If $g_iDebugSetlogTrain = 1 Then Setlog("UBound($g_asTroopOrderList) - 1: " & UBound($g_asTroopOrderList) - 1 & " = " & "$eTroopCount: " & $eTroopCount, $COLOR_DEBUG) ;Debug
		Setlog("Monkey ate bad banana, fix $g_asTroopOrderList & $eTroopCount arrays!", $COLOR_RED)
	  EndIf

	  ; Create translated list of Troops for combo box
	  Local $sComboData = ""
	  For $j = 0 To UBound($g_asTroopOrderList) - 1
		  $sComboData &= $g_asTroopOrderList[$j] & "|"
	  Next

	  Local $txtTroopOrder = GetTranslated(641, 29, "Enter sequence order for training of troop #")

	  ; Create ComboBox(es) for selection of troop training order
	  $y += 23
	  For $z = 0 To $eTroopCount - 1
		  If $z < 12 Then
			  GUICtrlCreateLabel($z + 1 & ":", $x - 16, $y + 2, -1, 18)
			  $g_ahCmbTroopOrder[$z] = GUICtrlCreateCombo("", $x, $y, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				 GUICtrlSetOnEvent(-1, "GUITrainOrder")
				 GUICtrlSetData(-1, $sComboData, "")
				 _GUICtrlSetTip(-1, $txtTroopOrder & $z + 1)
				 GUICtrlSetState(-1, $GUI_DISABLE)
			  $g_ahImgTroopOrder[$z] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 96, $y + 1, 18, 18)
			  $y += 22 ; move down to next combobox location
		  Else
			  If $z = 12 Then
				  $x += 128
				  $y = 45 + 23
			  EndIf
			  GUICtrlCreateLabel($z + 1 & ":", $x - 13, $y + 2, -1, 18)
			  $g_ahCmbTroopOrder[$z] = GUICtrlCreateCombo("", $x + 4, $y, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				 GUICtrlSetOnEvent(-1, "GUITrainOrder")
				 GUICtrlSetData(-1, $sComboData, "")
				 _GUICtrlSetTip(-1, $txtTroopOrder & $z + 1)
				 GUICtrlSetState(-1, $GUI_DISABLE)
			  $g_ahImgTroopOrder[$z] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 100, $y + 1, 18, 18)
			  $y += 22 ; move down to next combobox location
		  EndIf
	  Next

	  $x = 25
	  $y = 45 + 291
		  ; Create push button to set training order once completed
		  $g_hBtnTroopOrderSet = GUICtrlCreateButton(GetTranslated(641, 30, "Apply New Order"), $x, $y, 222, 20)
			 GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
			 _GUICtrlSetTip(-1, GetTranslated(641, 31, "Push button when finished selecting custom troop training order") & @CRLF & _
								GetTranslated(641, 32, "Icon changes color based on status: Red= Not Set, Green = Order Set"))
			 GUICtrlSetOnEvent(-1, "btnTroopOrderSet")
		  $g_ahImgTroopOrderSet = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 226, $y + 2, 18, 18)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func CreateOptionsSubTab()
   $g_hGUI_TRAINARMY_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(641, 1, "Options"))

   Local $sTxtTip = ""
   Local $x = 25, $y = 45
   GUICtrlCreateGroup(GetTranslated(641, 2, "Training Idle Time"), $x - 20, $y - 20, 151, 266)
	   $g_hChkCloseWhileTraining = GUICtrlCreateCheckbox(GetTranslated(641, 3, "Close While Training"), $x - 12, $y, 140, -1)
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   _GUICtrlSetTip(-1, GetTranslated(641, 4, "Option will exit CoC game for time required to complete TROOP training when SHIELD IS ACTIVE") & @CRLF & _
						  GetTranslated(641, 5, "Close for Spell creation will be enabled when 'Wait for Spells' is selected on Search tabs") & @CRLF & _
						  GetTranslated(641, 6, "Close for Hero healing will be enabled when 'Wait for Heroes' is enabled on Search tabs"))
	   GUICtrlSetOnEvent(-1, "chkCloseWaitEnable")

   $y += 28
	   $g_hChkCloseWithoutShield = GUICtrlCreateCheckbox(GetTranslated(641, 7, "Without Shield"), $x + 18, $y + 1, 110, -1)
	   $sTxtTip = GetTranslated(641, 8, "Option will ALWAYS close CoC for idle training time and when NO SHIELD IS ACTIVE!") & @CRLF & _
				  GetTranslated(641, 9, "Note - You can be attacked and lose trophies when this option is enabled!")
	   GUICtrlSetState(-1, $GUI_UNCHECKED)
	   _GUICtrlSetTip(-1, $sTxtTip)
	   GUICtrlSetOnEvent(-1, "chkCloseWaitTrain")
	   $g_hPicCloseWaitTrain = GUICtrlCreateIcon($g_sLibIconPath, $eIcnNoShield, $x - 13, $y, 24, 24)
	   _GUICtrlSetTip(-1, $sTxtTip)

   $y += 28
	   $g_hChkCloseEmulator = GUICtrlCreateCheckbox(GetTranslated(641, 13, "Close Emulator"), $x + 18, $y + 1, 110, -1)
	   $sTxtTip = GetTranslated(641, 14, "Option will close Android Emulator completely when selected") & @CRLF & _
				  GetTranslated(641, 15, "Adding this option may increase offline time slightly due to variable times required for startup")
	   GUICtrlSetState(-1, $GUI_UNCHECKED)
	   _GUICtrlSetTip(-1, $sTxtTip)
	   GUICtrlSetOnEvent(-1, "btnCloseWaitStop")
	   $g_hPicCloseWaitStop = GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecycle, $x - 13, $y + 13, 24, 24)
	   _GUICtrlSetTip(-1, $sTxtTip)

   $y += 28
	   $g_hChkRandomClose = GUICtrlCreateCheckbox(GetTranslated(641, 10, "Random Close"), $x + 18, $y + 1, 110, -1)
	   GUICtrlSetState(-1, $GUI_UNCHECKED)
	   _GUICtrlSetTip(-1, GetTranslated(641, 11, "Option will Randomly choose between time out, close CoC, or Close emulator when selected") & @CRLF & _
						  GetTranslated(641, 15, "Adding this option may increase offline time slightly due to variable times required for startup"))
	   GUICtrlSetOnEvent(-1, "btnCloseWaitStopRandom")

   $y += 28
	   $g_hRdoCloseWaitExact = GUICtrlCreateRadio(GetTranslated(641, 16, "Exact Time"), $x + 18, $y + 1, 110, -1)
	   _GUICtrlSetTip(-1, GetTranslated(641, 17, "Select to wait exact time required for troops to complete training"))
	   GUICtrlSetState(-1, $GUI_UNCHECKED)
	   GUICtrlSetOnEvent(-1, "btnCloseWaitRandom")
	   $g_hPicCloseWaitExact = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 13, $y + 13, 24, 24)
	   _GUICtrlSetTip(-1, GetTranslated(641, 18, "Select how much time to wait when feature enables"))

   $y += 24
	   $g_hRdoCloseWaitRandom = GUICtrlCreateRadio(GetTranslated(641, 19, "Random Time"), $x + 18, $y + 1, 110, -1)
	   _GUICtrlSetTip(-1, GetTranslated(641, 20, "Select to ADD a random extra wait time like human who forgets to clash"))
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   GUICtrlSetOnEvent(-1, "btnCloseWaitRandom")

   $y += 28
	   $g_hCmbCloseWaitRdmPercent = GUICtrlCreateCombo("", $x + 36, $y, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	   $sTxtTip = GetTranslated(641, 21, "Enter maximum percentage of additional time to be used creating random wait times,") & @CRLF & _
			   GetTranslated(641, 22, "Bot will compute a random wait time between exact time needed, and") & @CRLF & _
			   GetTranslated(641, 23, "maximum random percent entered to appear more human like")
	   GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15", "10")
	   _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hLblCloseWaitRdmPercent = GUICtrlCreateLabel("%", $x + 84, $y + 3, -1, -1)
	   _GUICtrlSetTip(-1, $sTxtTip)

   $y += 28
	   $g_hLblCloseWaitingTroops = GUICtrlCreateLabel(GetTranslated(641, 41, "Minimum Time To Close") & ": ", $x - 12, $y, -1, -1)
	   GUICtrlSetState(-1, $GUI_UNCHECKED)
	   _GUICtrlSetTip(-1, GetTranslated(641, 42, "Will be close CoC If train time troops >= (Minimum time required to close)" & @CRLF & _
												 "Just stay in the main screen if train time troops < (Minimum time required to close)"))
	   GUICtrlSetOnEvent(-1, "chkCloseWaitEnable")

   $y += 22
	   $g_hLblSymbolWaiting = GUICtrlCreateLabel(">", $x + 26, $y + 3, -1, -1)
	   $sTxtTip = GetTranslated(641, 43, "Enter number Minimum time to close in minutes for close CoC which you want, Default Is (2)")
	   _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hCmbMinimumTimeClose = GUICtrlCreateCombo("", $x + 36, $y, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	   GUICtrlSetData(-1, "2|3|4|5|6|7|8|9|10", "2")
	   _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hLblWaitingInMinutes = GUICtrlCreateLabel(GetTranslated(603, 10, -1), $x + 84, $y + 3, -1, -1)
	   _GUICtrlSetTip(-1, $sTxtTip)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += 53
   GUICtrlCreateGroup(GetTranslated(636, 30, "Train Click Timing"), $x - 20, $y - 20, 151, 60)
	   $g_hLblTrainITDelay = GUICtrlCreateLabel(GetTranslated(636, 32, "delay"), $x - 10, $y, 37, 30)
		  $sTxtTip = GetTranslated(636, 33, "Increase the delay if your PC is slow or to create human like training click speed")
		  _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hLblTrainITDelayTime = GUICtrlCreateLabel("40 ms", $x - 10, $y + 15, 37, 30)
		 _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hSldTrainITDelay = GUICtrlCreateSlider($x + 30, $y, 90, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
		  _GUICtrlSetTip(-1, GetTranslated(636, 33, -1))
		  _GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
		  _GUICtrlSlider_SetTicFreq(-100, 100)
		  GUICtrlSetLimit(-1, 500, 1) ; change max/min value
		  GUICtrlSetData(-1, 40) ; default value
		  GUICtrlSetBkColor(-1, $COLOR_WHITE)
		  GUICtrlSetOnEvent(-1, "sldTrainITDelay")
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $x = 25 + 151 + 5
   $y = 45
   GUICtrlCreateGroup(GetTranslated(641,35, "Training Add Random Delay"), $x - 20, $y - 20, 173, 81)
   $y += 15
	   $g_hChkTrainAddRandomDelayEnable = GUICtrlCreateCheckbox(GetTranslated(641, 36, "Add Random Delay"),$x + 18, $y - 11, 130, -1)
	   $sTxtTip = GetTranslated(641, 37, "Add random delay between two calls of train army.")& @CRLF & _
				  GetTranslated(641, 38, "This option reduces the calls to the training window  humanizing the bot spacing calls each time with a causal interval chosen between the minimum and maximum values indicated below.")
	   GUICtrlSetState(-1, $GUI_CHECKED)
	   _GUICtrlSetTip(-1, $sTxtTip)
	   GUICtrlSetOnEvent(-1, "chkAddDelayIdlePhaseEnable")
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDelay, $x - 13, $y - 13, 24, 24)
	   _GUICtrlSetTip(-1, $sTxtTip)

   $x += 18
   $y += 18
	   $g_hLblAddDelayIdlePhaseBetween = GUICtrlCreateLabel(GetTranslated(641, 39, "Between"), $x-12, $y, 50, 30)
	   $g_hTxtAddRandomDelayMin = GUICtrlCreateInput($g_iTrainAddRandomDelayMin, $x + 32, $y-2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	   GUICtrlSetLimit(-1, 999)
	   GUICtrlCreateLabel(GetTranslated(641, 40, "And"), $x+61, $y, 20, 30)
	   $g_hTxtAddRandomDelayMax = GUICtrlCreateInput($g_iTrainAddRandomDelayMax, $x + 82, $y-2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	   GUICtrlSetLimit(-1, 999)
	   $g_hLblAddDelayIdlePhaseSec = GUICtrlCreateLabel(GetTranslated(603, 6, "sec."), $x+110, $y, 20, 30)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
