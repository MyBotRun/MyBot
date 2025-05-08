; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (06-2016), MR.ViPER (10-2016), Fliegerfaust (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False, $CheckWindow = True, $bSetLog = True)

	If $g_bDebugSetLogTrain Or $g_bDebugSetLog Then SetLog("Begin getArmyHeroCount:", $COLOR_DEBUG)

	If $CheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview(True, "getArmyHeroCount()") Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	Local $HeroSlotsInfos[5] = [$eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion]
	Local $b5SlotStatusAvail = BitAND($g_iHeroAvailable, $HeroSlotsInfos[$g_aiCmbCustomHeroOrder[4]])
	Local $b5SlotStatusUp = BitAND($g_iHeroUpgradingBit, $HeroSlotsInfos[$g_aiCmbCustomHeroOrder[4]])
	$g_iHeroAvailable = $eHeroNone ; Reset hero available data
	If $b5SlotStatusAvail Then $g_iHeroAvailable = BitOR($g_iHeroAvailable, $HeroSlotsInfos[$g_aiCmbCustomHeroOrder[4]])
	If $b5SlotStatusUp Then $g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $HeroSlotsInfos[$g_aiCmbCustomHeroOrder[4]])

	Local $iDebugArmyHeroCount = 0 ; local debug flag

	; Detection by OCR
	Local $sResult
	Local $sMessage = ""

	If Not HeroHallValuesCheck() Then
		SetLog("Please check Hero Hall Values Now !", $COLOR_ERROR)
		SetLog("MBR cannot run correctly without Hero Hall Values : LOCATE !", $COLOR_ERROR)
	EndIf

	For $i = 0 To $eHeroSlots - 1
		Switch $g_aiHeroHallPos[2]
			Case 1, 2
				If $i = 1 Then ExitLoop
			Case 3, 4
				If $i = 2 Then ExitLoop
			Case 5, 6
				If $i = 3 Then ExitLoop
			Case 7 To 11
				;Do nothing
			Case Else
				;Do nothing but should not happen
		EndSwitch
		$sResult = ArmyHeroStatus($i)
		If $sResult <> "" Then ; we found something, figure out what?
			Select
				Case StringInStr($sResult, "king", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Barbarian King Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
					; unset King upgrading
					$g_iHeroUpgrading[0] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
				Case StringInStr($sResult, "queen", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Archer Queen Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
					; unset Queen upgrading
					$g_iHeroUpgrading[1] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
				Case StringInStr($sResult, "prince", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Minion Prince Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
					; unset Queen upgrading
					$g_iHeroUpgrading[2] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
				Case StringInStr($sResult, "warden", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Grand Warden Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
					; unset Warden upgrading
					$g_iHeroUpgrading[3] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroQueen, $eHeroChampion))
				Case StringInStr($sResult, "champion", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Royal Champion Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
					; unset Champion upgrading
					$g_iHeroUpgrading[4] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroQueen, $eHeroWarden))
				Case StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC)
					If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then
						Switch $i
							Case 0
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
									Case Else
										$sMessage = "-Very Bad Monkey Needs"
								EndSwitch
							Case 1
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
									Case Else
										$sMessage = "-Very Bad Monkey Needs"
								EndSwitch
							Case 2
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
									Case Else
										$sMessage = "-Very Bad Monkey Needs"
								EndSwitch
							Case 3
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
									Case Else
										$sMessage = "-Very Bad Monkey Needs"
								EndSwitch
							Case 4
								Switch $g_aiCmbCustomHeroOrder[$i]
									Case 0
										$sMessage = "-Barbarian King"
										; unset King upgrading
										$g_iHeroUpgrading[0] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 1
										$sMessage = "-Archer Queen"
										; unset Queen upgrading
										$g_iHeroUpgrading[1] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
									Case 2
										$sMessage = "-Minion Prince"
										; unset Prince upgrading
										$g_iHeroUpgrading[2] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
									Case 3
										$sMessage = "-Grand Warden"
										; unset Warden upgrading
										$g_iHeroUpgrading[3] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
									Case 4
										$sMessage = "-Royal Champion"
										; unset Champion upgrading
										$g_iHeroUpgrading[4] = 0
										$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
									Case Else
										$sMessage = "-Very Bad Monkey Needs"
								EndSwitch
						EndSwitch
						SetLog("Hero slot#" & $i + 1 & $sMessage & " Healing", $COLOR_DEBUG)
					EndIf
				Case StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC)
					Switch $i
						Case 0
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
							EndSwitch
						Case 1
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
							EndSwitch
						Case 2
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
							EndSwitch
						Case 3
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
							EndSwitch
						Case 4
							Switch $g_aiCmbCustomHeroOrder[$i]
								Case 0
									$sMessage = "-Barbarian King"
									; set King upgrading
									$g_iHeroUpgrading[0] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
									; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then     ; check wait for hero status
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
										Else
											SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupKingSleeping)     ; Show king sleeping icon
									EndIf
								Case 1
									$sMessage = "-Archer Queen"
									; set Queen upgrading
									$g_iHeroUpgrading[1] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
										Else
											SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupQueenSleeping) ; Show Queen sleeping icon
									EndIf
								Case 2
									$sMessage = "-Minion Prince"
									; set Prince upgrading
									$g_iHeroUpgrading[2] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
										Else
											SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupPrinceSleeping) ; Show Prince sleeping icon
									EndIf
								Case 3
									$sMessage = "-Grand Warden"
									; set Warden upgrading
									$g_iHeroUpgrading[3] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
										Else
											SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
									EndIf
								Case 4
									$sMessage = "-Royal Champion"
									; set Champion upgrading
									$g_iHeroUpgrading[4] = 1
									$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
									; safety code
									If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
											($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
										If $g_iSearchNotWaitHeroesEnable Then
											$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
										Else
											SetLog("Warning: Royal Champion Upgrading & Wait enabled, Disable Wait for Royal Champion or may never attack!", $COLOR_ERROR)
										EndIf
										_GUI_Value_STATE("SHOW", $groupChampionSleeping) ; Show Champion sleeping icon
									EndIf
							EndSwitch
					EndSwitch
					If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & $sMessage & " Upgrade in Process", $COLOR_DEBUG)
				Case StringInStr($sResult, "none", $STR_NOCASESENSEBASIC)
					If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & " Empty, stop count", $COLOR_DEBUG)
					ExitLoop ; when we find empty slots, done looking for heroes
				Case Else
					If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " bad OCR string returned!", $COLOR_ERROR)
			EndSelect
		Else
			If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " status read problem!", $COLOR_ERROR)
		EndIf
	Next

	If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero Status  K|Q|P|W|C : " & BitAND($g_iHeroAvailable, $eHeroKing) & "|" & BitAND($g_iHeroAvailable, $eHeroQueen) & "|" & BitAND($g_iHeroAvailable, $eHeroPrince) & "|" & BitAND($g_iHeroAvailable, $eHeroWarden) & "|" & BitAND($g_iHeroAvailable, $eHeroChampion), $COLOR_DEBUG)
	If $g_bDebugSetLogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero Upgrade K|Q|P|W|C : " & BitAND($g_iHeroUpgradingBit, $eHeroKing) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroQueen) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroPrince) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroWarden) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroChampion), $COLOR_DEBUG)

	If $bCloseArmyWindow Then CloseWindow()

EndFunc   ;==>getArmyHeroCount

Func ArmyHeroStatus($i)
	If $g_bFirstStartForHiddenHero Then
		Switch $g_aiCmbCustomHeroOrder[4]
			Case 0
				GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
			Case 1
				GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
			Case 2
				GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
			Case 3
				GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
			Case 4
				GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		EndSwitch
	EndIf

	If Not HeroHallValuesCheck() Then
		SetLog("Please check Hero Hall Values Now !", $COLOR_ERROR)
		SetLog("MBR cannot run correctly without Hero Hall Values : LOCATE !", $COLOR_ERROR)
	EndIf

	Switch $g_aiHeroHallPos[2]
		Case 1, 2
			Local $aHeroesRect[$eHeroSlots][4] = [[175, 230 + $g_iMidOffsetY, 210, 255 + $g_iMidOffsetY], _
					[0, 0, 0, 0], _
					[0, 0, 0, 0], _
					[0, 0, 0, 0]]
		Case 3, 4
			Local $aHeroesRect[$eHeroSlots][4] = [[129, 230 + $g_iMidOffsetY, 154, 255 + $g_iMidOffsetY], _
					[235, 230 + $g_iMidOffsetY, 260, 255 + $g_iMidOffsetY], _
					[0, 0, 0, 0], _
					[0, 0, 0, 0]]
		Case 5, 6
			Local $aHeroesRect[$eHeroSlots][4] = [[105, 230 + $g_iMidOffsetY, 128, 255 + $g_iMidOffsetY], _
					[184, 230 + $g_iMidOffsetY, 206, 255 + $g_iMidOffsetY], _
					[263, 230 + $g_iMidOffsetY, 285, 255 + $g_iMidOffsetY], _
					[0, 0, 0, 0]]
		Case 7 To 11
			Local $aHeroesRect[$eHeroSlots][4] = [[105, 230 + $g_iMidOffsetY, 128, 255 + $g_iMidOffsetY], _
					[184, 230 + $g_iMidOffsetY, 206, 255 + $g_iMidOffsetY], _
					[263, 230 + $g_iMidOffsetY, 285, 255 + $g_iMidOffsetY], _
					[342, 230 + $g_iMidOffsetY, 365, 255 + $g_iMidOffsetY]]
		Case Else
			Local $aHeroesRect[$eHeroSlots][4] = [[105, 230 + $g_iMidOffsetY, 128, 255 + $g_iMidOffsetY], _
					[184, 230 + $g_iMidOffsetY, 206, 255 + $g_iMidOffsetY], _
					[263, 230 + $g_iMidOffsetY, 285, 255 + $g_iMidOffsetY], _
					[342, 230 + $g_iMidOffsetY, 365, 255 + $g_iMidOffsetY]]
	EndSwitch

	; Perform the search
	Local $aTempArray, $aTempArray2
	Local $sSearchDiamond = GetDiamondFromRect2($aHeroesRect[$i][0], $aHeroesRect[$i][1], $aHeroesRect[$i][2], $aHeroesRect[$i][3])
	Local $result = findMultiple($g_sImgArmyOverviewHeroes, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)
	If $result <> "" And IsArray($result) Then
		For $t = 0 To UBound($result, 1) - 1
			$aTempArray = $result[$t]
			If $g_aiCmbCustomHeroOrder[$i] = 0 Then
				Switch $aTempArray[0]
					Case "upgrade"     ; Red
						GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
				EndSwitch
			ElseIf $g_aiCmbCustomHeroOrder[$i] = 1 Then
				Switch $aTempArray[0]
					Case "upgrade"     ; Red
						GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
				EndSwitch
			ElseIf $g_aiCmbCustomHeroOrder[$i] = 2 Then
				Switch $aTempArray[0]
					Case "upgrade"     ; Red
						GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
				EndSwitch
			ElseIf $g_aiCmbCustomHeroOrder[$i] = 3 Then
				Switch $aTempArray[0]
					Case "upgrade"     ; Red
						GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
				EndSwitch
			ElseIf $g_aiCmbCustomHeroOrder[$i] = 4 Then
				Switch $aTempArray[0]
					Case "upgrade"     ; Red
						GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
				EndSwitch
			EndIf
			Return $aTempArray[0]
		Next
	Else
		If $g_aiCmbCustomHeroOrder[$i] = 0 Then
			GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
			Return "king"
		ElseIf $g_aiCmbCustomHeroOrder[$i] = 1 Then
			GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
			Return "queen"
		ElseIf $g_aiCmbCustomHeroOrder[$i] = 2 Then
			GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
			Return "prince"
		ElseIf $g_aiCmbCustomHeroOrder[$i] = 3 Then
			GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
			Return "warden"
		ElseIf $g_aiCmbCustomHeroOrder[$i] = 4 Then
			GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
			Return "champion"
		EndIf
	EndIf

	;return 'none' if there was a problem with the search ; or no Hero slot
	Switch $i
		Case $g_aiCmbCustomHeroOrder[$i] = 0
			GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
			Return "none"
		Case $g_aiCmbCustomHeroOrder[$i] = 1
			GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
			Return "none"
		Case $g_aiCmbCustomHeroOrder[$i] = 2
			GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
			Return "none"
		Case $g_aiCmbCustomHeroOrder[$i] = 3
			GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
			Return "none"
		Case $g_aiCmbCustomHeroOrder[$i] = 4
			GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
			Return "none"
	EndSwitch

EndFunc   ;==>ArmyHeroStatus

Func HiddenSlotstatus()

	If $g_iTownHallLevel < 7 Then
		SetDebugLog("Townhall Lvl " & $g_iTownHallLevel & " has no Hero Hall", $COLOR_DEBUG)
		Return
	EndIf
	If Not HeroHallValuesCheck() Then
		SetLog("Please check Hero Hall Values Now !", $COLOR_ERROR)
		SetLog("MBR cannot run correctly without Hero Hall Values : LOCATE !", $COLOR_ERROR)
	EndIf

	If $g_aiHeroHallPos[2] = 1 Then

		Switch $g_aiCmbCustomHeroOrder[4]
			Case 0
				GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
			Case 1
				GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
			Case 2
				GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
			Case 3
				GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
			Case 4
				GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		EndSwitch
		Return

	Else

		Local Static $iLastTimeCheckedHidden[8]
		If $g_bFirstStartForHiddenHero Then $iLastTimeCheckedHidden[$g_iCurAccount] = ""

		; Check if is a valid date
		If _DateIsValid($iLastTimeCheckedHidden[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('s', $iLastTimeCheckedHidden[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
			SetDebugLog("Hero Hall LastCheck: " & $iLastTimeCheckedHidden[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 1.5 to 2 hours [1.5*60 = 90 to 2*60 = 120]
			Local $iDelayToCheck = Random(90, 120, 1) * 60 ; Convert in seconds
			If $iLastCheck < $iDelayToCheck Then
				If _Sleep(1000) Then Return
				Return
			EndIf
		EndIf

		ClearScreen()
		If _Sleep(1500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

		SetLog("Checking " & $g_asHeroNames[$g_aiCmbCustomHeroOrder[4]] & " Status", $COLOR_INFO)

		BuildingClick($g_aiHeroHallPos[0], $g_aiHeroHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If StringInStr($sHeroHallInfo[1], "Hero") Then
			If $g_aiHeroHallPos[2] <> $sHeroHallInfo[2] Then
				$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
			EndIf
			Local $HeroHallButton = FindButton("HeroHallButton")
			If IsArray($HeroHallButton) And UBound($HeroHallButton) = 2 Then
				ClickP($HeroHallButton)
				If _Sleep(Random(1500, 2000, 1)) Then Return
			Else
				SetLog("Hero Hall Button not found", $COLOR_ERROR)
				ClearScreen()
				Switch $g_aiCmbCustomHeroOrder[4]
					Case 0
						GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					Case 1
						GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					Case 2
						GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
					Case 3
						GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					Case 4
						GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
				EndSwitch
			EndIf
		EndIf

		If Not QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 145 + $g_iMidOffsetY, 815, 175 + $g_iMidOffsetY) Then
			SetLog("Hero Hall Window Didn't Open", $COLOR_DEBUG1)
			CloseWindow2()
			If _Sleep(1000) Then Return
			ClearScreen()
			Switch $g_aiCmbCustomHeroOrder[4]
				Case 0
					GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
				Case 1
					GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
				Case 2
					GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
				Case 3
					GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
				Case 4
					GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
			EndSwitch
			Return
		EndIf

		$iLastTimeCheckedHidden[$g_iCurAccount] = _NowCalc()
		$g_bFirstStartForHiddenHero = 0

		Local $bInitalXcoord = 67
		Local $bDistanceSlot = 153
		Local $bXcoords[5] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4]

		Switch $g_aiCmbCustomHeroOrder[4]
			Case 0
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[0] + 20, 420 + $g_iMidOffsetY, $bXcoords[0] + 100, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
					$g_iHeroUpgrading[0] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
					SetLog($g_asHeroNames[0] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[0] & " is not available", $COLOR_DEBUG2)
				ElseIf IsArray(_PixelSearch($bXcoords[0] - 6, 438 + $g_iMidOffsetY, $bXcoords[0] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[0] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_iHeroUpgrading[0] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
						Else
							SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupKingSleeping)                     ; Show king sleeping icon
					EndIf
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[0], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Or _
						_ColorCheck(_GetPixelColor($bXcoords[0] + 42, 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[0] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
					$g_iHeroUpgrading[0] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
					SetLog($g_asHeroNames[0] & " is ready to fight", $COLOR_SUCCESS1)
				EndIf
				CloseWindow()
				Return
			Case 1
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[1] + 20, 420 + $g_iMidOffsetY, $bXcoords[1] + 10, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
					$g_iHeroUpgrading[1] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
					SetLog($g_asHeroNames[1] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[1] & " is not available", $COLOR_DEBUG2)
				ElseIf IsArray(_PixelSearch($bXcoords[1] - 6, 438 + $g_iMidOffsetY, $bXcoords[1] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[1] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_iHeroUpgrading[1] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
						Else
							SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupQueenSleeping)                     ; Show Queen sleeping icon
					EndIf
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[1], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Or _
						_ColorCheck(_GetPixelColor($bXcoords[1] + 42, 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[1] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
					$g_iHeroUpgrading[1] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
					SetLog($g_asHeroNames[1] & " is ready to fight", $COLOR_SUCCESS1)
				EndIf
				CloseWindow()
				Return
			Case 2
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[2] + 20, 420 + $g_iMidOffsetY, $bXcoords[2] + 100, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
					$g_iHeroUpgrading[2] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
					SetLog($g_asHeroNames[2] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[2] & " is not available", $COLOR_DEBUG2)
				ElseIf IsArray(_PixelSearch($bXcoords[2] - 6, 438 + $g_iMidOffsetY, $bXcoords[2] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[2] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_iHeroUpgrading[2] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
						Else
							SetLog("Warning: Prince Upgrading & Wait enabled, Disable Wait for Prince or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupPrinceSleeping)                     ; Show king sleeping icon
					EndIf
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[2], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Or _
						_ColorCheck(_GetPixelColor($bXcoords[2] + 42, 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[2] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
					$g_iHeroUpgrading[2] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroPrince)
					SetLog($g_asHeroNames[2] & " is ready to fight", $COLOR_SUCCESS1)
				EndIf
				CloseWindow()
				Return
			Case 3
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[3] + 20, 420 + $g_iMidOffsetY, $bXcoords[3] + 65, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
					$g_iHeroUpgrading[3] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
					SetLog($g_asHeroNames[3] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[3] & " is not available", $COLOR_DEBUG2)
				ElseIf IsArray(_PixelSearch($bXcoords[3] - 6, 438 + $g_iMidOffsetY, $bXcoords[3] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[3] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_iHeroUpgrading[3] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
						Else
							SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupWardenSleeping)                     ; Show king sleeping icon
					EndIf
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[3], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Or _
						_ColorCheck(_GetPixelColor($bXcoords[3] + 42, 425 + $g_iMidOffsetY, True), Hex(0xBEEA8C, 6), 20) Or _ColorCheck(_GetPixelColor($bXcoords[3] + 42, 425 + $g_iMidOffsetY, True), Hex(0xD2D2D2, 6), 15) Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
					$g_iHeroUpgrading[3] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
					SetLog($g_asHeroNames[3] & " is ready to fight", $COLOR_SUCCESS1)
				EndIf
				CloseWindow()
				Return
			Case 4
				Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[4] + 20, 420 + $g_iMidOffsetY, $bXcoords[4] + 100, 445 + $g_iMidOffsetY, True))
				If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
					$g_iHeroUpgrading[4] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
					SetLog($g_asHeroNames[4] & " is ready to fight", $COLOR_SUCCESS1)
					CloseWindow()
					Return
				EndIf
				If _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0x6D6D6D, 6), 15) Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
					GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[4] & " is not available", $COLOR_DEBUG2)
				ElseIf IsArray(_PixelSearch($bXcoords[4] - 6, 438 + $g_iMidOffsetY, $bXcoords[4] + 4, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
					SetLog($g_asHeroNames[4] & " is being upgraded", $COLOR_DEBUG)
					;Set Status Variable
					$g_iHeroUpgrading[4] = 1
					$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
					If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
							($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then                     ; check wait for hero status
						If $g_iSearchNotWaitHeroesEnable Then
							$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
						Else
							SetLog("Warning: Champion Upgrading & Wait enabled, Disable Wait for Champion or may never attack!", $COLOR_ERROR)
						EndIf
						_GUI_Value_STATE("SHOW", $groupChampionSleeping)                     ; Show king sleeping icon
					EndIf
				ElseIf _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[4], 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 15) Or _
						_ColorCheck(_GetPixelColor($bXcoords[4] + 42, 438 + $g_iMidOffsetY, True), Hex(0xADADAD, 6), 15) Or _ColorCheck(_GetPixelColor($bXcoords[4] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
					$g_iHeroUpgrading[4] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden))
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroChampion)
					SetLog($g_asHeroNames[4] & " is ready to fight", $COLOR_SUCCESS1)
				EndIf
				CloseWindow()
				Return
		EndSwitch

	EndIf
EndFunc   ;==>HiddenSlotstatus

Func LabGuiDisplay() ; called from main loop to get an early status for indictors in bot bottom

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	; Check if is a valid date and Calculated the number of minutes from remain time Lab and now
	If _DateIsValid($g_sLabUpgradeTime) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime)
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Lab LabUpgradeTime: " & $g_sLabUpgradeTime & ", Lab DateCalc: " & $iLabTime)
		SetDebugLog("Lab LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each from 2 to 5 hours [2*60 = 120 to 5*60 = 300] or when Lab research time finishes
		Local $iDelayToCheck = Random(120, 300, 1)
		If _DateIsValid($bLabAssistantUsedTime) Then
			Local $DiffLabAssistantUsedTime = _DateDiff('n', $bLabAssistantUsedTime, _NowCalc())
			If $DiffLabAssistantUsedTime > 60 Then ; One Hour after using Lab Assistant (Because I cant' find the formula !)
				$iDelayToCheck = 0 ; Check Right Now
				$bLabAssistantUsedTime = 0
			EndIf
		EndIf
		If $iLabTime > 0 And $iLastCheck <= $iDelayToCheck Then Return
	EndIf

	ClearScreen()

	If $g_iTownHallLevel < 3 Then
		SetDebugLog("TH reads as Lvl " & $g_iTownHallLevel & ", has no Lab.")
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;============================================
		Return
	EndIf

	SetLog("Checking Lab Status", $COLOR_INFO)

	;=================Section 2 Lab Gui

	; If $g_bAutoLabUpgradeEnable = True Then  ====>>>> TODO : or use this or make a checkbox on GUI
	; make sure lab is located, if not locate lab
	If $g_aiLaboratoryPos[0] <= 0 Or $g_aiLaboratoryPos[1] <= 0 Then
		SetLog("Laboratory Location is unknown!", $COLOR_ERROR)
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;============================================
		Return
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilder, 240, 0, 450, 60, True))) > 1 Then
		$GobBuilderPresent = True
		$GobBuilderOffsetRunning = 355
	Else
		$GobBuilderPresent = False
		$GobBuilderOffsetRunning = 0
	EndIf

	BuildingClickP($g_aiLaboratoryPos, "#0197") ;Click Laboratory
	If _Sleep(1500) Then Return ; Wait for window to open
	; Find Research Button

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	Local $aResearchButton = findButton("Research", Default, 1, True)
	If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("LabUpgrade") ; Debug Only
		ClickP($aResearchButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		If Not $GobBuilderPresent Then ; Just in case
			If UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilderLab, 510, 140 + $g_iMidOffsetY, 575, 195 + $g_iMidOffsetY, True))) > 1 Then
				$GobBuilderPresent = True
				$GobBuilderOffsetRunning = 355
			EndIf
		EndIf
	Else
		SetLog("Cannot find the Laboratory Research Button!", $COLOR_ERROR)
		ClearScreen()
		;===========Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;===========================================
		Return
	EndIf

	; check for upgrade in process - look for green in finish upgrade with gems button
	If _ColorCheck(_GetPixelColor(775 - $GobBuilderOffsetRunning, 135 + $g_iMidOffsetY, True), Hex(0xA1CA6B, 6), 20) Then ; Look for light green in upper right corner of lab window.
		SetLog("Laboratory is Running", $COLOR_INFO)
		;==========Hide Red  Show Green Hide Gray===
		GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGreen, $GUI_SHOW)
		;===========================================
		If _Sleep($DELAYLABORATORY2) Then Return
		If $GobBuilderPresent Then
			Local $sLabTimeOCR = getRemainTLaboratoryGob(210, 190 + $g_iMidOffsetY)
		Else
			Local $sLabTimeOCR = getRemainTLaboratory2(250, 210 + $g_iMidOffsetY)
		EndIf
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False) + 1
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
			$g_iLaboratoryElixirCost = 0
			$g_iLaboratoryDElixirCost = 0
			LabStatusGUIUpdate() ; Update GUI flag
		EndIf

		If _Sleep(500) Then Return
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		CloseWindow()
		Return True
	ElseIf _ColorCheck(_GetPixelColor(775 - $GobBuilderOffsetRunning, 170 + $g_iMidOffsetY, True), Hex(0x8089AF, 6), 20) Then ; Look for light purple in upper right corner of lab window.
		SetLog("Laboratory has Stopped", $COLOR_INFO)
		If $g_bNotifyTGEnable And $g_bNotifyAlertLaboratoryIdle Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_01", "Laboratory Idle") & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_02", "Laboratory has Stopped"))
		CloseWindow()
		;========Show Red  Hide Green  Hide Gray=====
		GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;============================================
		ClearScreen()
		$g_sLabUpgradeTime = ""
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		Return
	Else
		SetLog("Unable to determine Lab Status", $COLOR_INFO)
		;========Hide Red  Hide Green  Show Gray======
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;=============================================
		CloseWindow()
		$iLastTimeChecked[$g_iCurAccount] = ""
		Return
	EndIf

EndFunc   ;==>LabGuiDisplay

Func HideShields($bHide = False)
	Local Static $ShieldState[30]
	Local $counter
	If $bHide = True Then
		$counter = 0
		For $i = $g_hPicKingGray To $g_hLbLLabTime
			$ShieldState[$counter] = GUICtrlGetState($i)
			GUICtrlSetState($i, $GUI_HIDE)
			$counter += 1
		Next
	Else
		$counter = 0
		For $i = $g_hPicKingGray To $g_hLbLLabTime
			If $ShieldState[$counter] = 80 Then
				GUICtrlSetState($i, $GUI_SHOW)
			EndIf
			$counter += 1
		Next
	EndIf
EndFunc   ;==>HideShields

Func CheckHeroOrder()

	If $bCheckHeroOrder[$g_iCurAccount] Then Return

	If Not HeroHallValuesCheck() Then
		SetLog("Please check Hero Hall Values Now !", $COLOR_ERROR)
		SetLog("MBR cannot run correctly without Hero Hall Values : LOCATE !", $COLOR_ERROR)
	EndIf

	Switch $g_aiHeroHallPos[2]
		Case 1, 2
			Local $aHeroesRect[$eHeroSlots][4] = [[225, 150 + $g_iMidOffsetY, 300, 245 + $g_iMidOffsetY], _
					[0, 0, 0, 0], _
					[0, 0, 0, 0], _
					[0, 0, 0, 0]]
			Local $aHeroesClick[$eHeroSlots][4] = [[100, 260 + $g_iMidOffsetY, 170, 380 + $g_iMidOffsetY], _
					[0, 0, 0, 0], _
					[0, 0, 0, 0], _
					[0, 0, 0, 0]]
		Case 3, 4
			Local $aHeroesRect[$eHeroSlots][4] = [[181, 150 + $g_iMidOffsetY, 253, 245 + $g_iMidOffsetY], _
					[285, 150 + $g_iMidOffsetY, 358, 245 + $g_iMidOffsetY], _
					[0, 0, 0, 0], _
					[0, 0, 0, 0]]
			Local $aHeroesClick[$eHeroSlots][4] = [[90, 260 + $g_iMidOffsetY, 135, 380 + $g_iMidOffsetY], _
					[195, 260 + $g_iMidOffsetY, 235, 380 + $g_iMidOffsetY], _
					[0, 0, 0, 0], _
					[0, 0, 0, 0]]
		Case 5, 6
			Local $aHeroesRect[$eHeroSlots][4] = [[160, 150 + $g_iMidOffsetY, 230, 245 + $g_iMidOffsetY], _
					[238, 150 + $g_iMidOffsetY, 310, 245 + $g_iMidOffsetY], _
					[317, 150 + $g_iMidOffsetY, 390, 245 + $g_iMidOffsetY], _
					[0, 0, 0, 0]]
			Local $aHeroesClick[$eHeroSlots][4] = [[85, 260 + $g_iMidOffsetY, 105, 380 + $g_iMidOffsetY], _
					[165, 260 + $g_iMidOffsetY, 185, 380 + $g_iMidOffsetY], _
					[240, 260 + $g_iMidOffsetY, 260, 380 + $g_iMidOffsetY], _
					[0, 0, 0, 0]]
		Case 7 To 11
			Local $aHeroesRect[$eHeroSlots][4] = [[160, 150 + $g_iMidOffsetY, 230, 245 + $g_iMidOffsetY], _
					[238, 150 + $g_iMidOffsetY, 310, 245 + $g_iMidOffsetY], _
					[317, 150 + $g_iMidOffsetY, 390, 245 + $g_iMidOffsetY], _
					[396, 150 + $g_iMidOffsetY, 469, 245 + $g_iMidOffsetY]]
			Local $aHeroesClick[$eHeroSlots][4] = [[80, 260 + $g_iMidOffsetY, 110, 380 + $g_iMidOffsetY], _
					[160, 260 + $g_iMidOffsetY, 190, 380 + $g_iMidOffsetY], _
					[240, 260 + $g_iMidOffsetY, 270, 380 + $g_iMidOffsetY], _
					[320, 260 + $g_iMidOffsetY, 350, 380 + $g_iMidOffsetY]]
		Case Else
			Local $aHeroesRect[$eHeroSlots][4] = [[160, 150 + $g_iMidOffsetY, 230, 245 + $g_iMidOffsetY], _
					[238, 150 + $g_iMidOffsetY, 310, 245 + $g_iMidOffsetY], _
					[317, 150 + $g_iMidOffsetY, 390, 245 + $g_iMidOffsetY], _
					[396, 150 + $g_iMidOffsetY, 469, 245 + $g_iMidOffsetY]]
			Local $aHeroesClick[$eHeroSlots][4] = [[80, 260 + $g_iMidOffsetY, 110, 380 + $g_iMidOffsetY], _
					[160, 260 + $g_iMidOffsetY, 190, 380 + $g_iMidOffsetY], _
					[240, 260 + $g_iMidOffsetY, 270, 380 + $g_iMidOffsetY], _
					[320, 260 + $g_iMidOffsetY, 350, 380 + $g_iMidOffsetY]]
	EndSwitch

	Local $aTempArray

	For $i = 0 To $eHeroSlots - 1 ; Reset
		$g_aiCmbCustomHeroOrder[$i] = -1
	Next

	For $i = 0 To $eHeroSlots - 1
		Switch $g_aiHeroHallPos[2]
			Case 1, 2
				If $i = 1 Then ExitLoop
			Case 3, 4
				If $i = 2 Then ExitLoop
			Case 5, 6
				If $i = 3 Then ExitLoop
			Case 7 To 11
				;Do nothing
			Case Else
				;Do nothing but should not happen
		EndSwitch
		; Perform the search
		Local $HeroClickOpen[2] = [Random($aHeroesClick[$i][0], $aHeroesClick[$i][2], 1), Random($aHeroesClick[$i][1], $aHeroesClick[$i][3], 1)]
		ClickP($HeroClickOpen, 1, 120)
		SetDebugLog("Click : " & $i & " : " & $HeroClickOpen[0] & "," & $HeroClickOpen[1])
		If _Sleep(Random(500, 2000, 1)) Then Return
		Local $sSearchDiamond = GetDiamondFromRect2($aHeroesRect[$i][0], $aHeroesRect[$i][1], $aHeroesRect[$i][2], $aHeroesRect[$i][3])
		Local $result = findMultiple($g_sImgArmyOverviewHeroes, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)
		If $result <> "" And IsArray($result) Then
			For $t = 0 To UBound($result, 1) - 1
				$aTempArray = $result[$t]
				If StringInStr($aTempArray[0], "upgrade", $STR_NOCASESENSEBASIC) Then ContinueLoop
				Switch $aTempArray[0]
					Case "king"
						$g_aiCmbCustomHeroOrder[$i] = 0
					Case "queen"
						$g_aiCmbCustomHeroOrder[$i] = 1
					Case "prince"
						$g_aiCmbCustomHeroOrder[$i] = 2
					Case "warden"
						$g_aiCmbCustomHeroOrder[$i] = 3
					Case "champion"
						$g_aiCmbCustomHeroOrder[$i] = 4
				EndSwitch
			Next
			Local $HeroClickClose[2] = [Random($aHeroesClick[$i][0], $aHeroesClick[$i][2], 1), Random($aHeroesClick[$i][1], $aHeroesClick[$i][3], 1)]
			ClickP($HeroClickClose, 1, 120)
			SetDebugLog("Click : " & $i & " : " & $HeroClickClose[0] & "," & $HeroClickClose[1])
			If _Sleep(250) Then Return
		EndIf
	Next

	If $g_aiHeroHallPos[2] > 6 Then
		Local $ForKing = 0, $ForQueen = 0, $ForPrince = 0, $ForWarden = 0, $ForChampion = 0
		For $i = 0 To $eHeroSlots - 1
			Switch $g_aiCmbCustomHeroOrder[$i]
				Case 0
					$ForKing += 1
				Case 1
					$ForQueen += 1
				Case 2
					$ForPrince += 1
				Case 3
					$ForWarden += 1
				Case 4
					$ForChampion += 1
			EndSwitch
		Next
		If $ForKing = 0 Then
			$g_aiCmbCustomHeroOrder[4] = 0
		ElseIf $ForQueen = 0 Then
			$g_aiCmbCustomHeroOrder[4] = 1
		ElseIf $ForPrince = 0 Then
			$g_aiCmbCustomHeroOrder[4] = 2
		ElseIf $ForWarden = 0 Then
			$g_aiCmbCustomHeroOrder[4] = 3
		ElseIf $ForChampion = 0 Then
			$g_aiCmbCustomHeroOrder[4] = 4
		EndIf
	Else
		Switch $g_aiHeroHallPos[2]
			Case 2
				If $g_aiCmbCustomHeroOrder[0] = 0 Then $g_aiCmbCustomHeroOrder[4] = 1
				If $g_aiCmbCustomHeroOrder[0] = 1 Then $g_aiCmbCustomHeroOrder[4] = 0
			Case 3, 4
				If $g_aiCmbCustomHeroOrder[0] = 0 And $g_aiCmbCustomHeroOrder[1] = 1 Then $g_aiCmbCustomHeroOrder[4] = 2
				If $g_aiCmbCustomHeroOrder[0] = 1 And $g_aiCmbCustomHeroOrder[1] = 0 Then $g_aiCmbCustomHeroOrder[4] = 2
				If $g_aiCmbCustomHeroOrder[0] = 1 And $g_aiCmbCustomHeroOrder[1] = 2 Then $g_aiCmbCustomHeroOrder[4] = 0
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 1 Then $g_aiCmbCustomHeroOrder[4] = 0
				If $g_aiCmbCustomHeroOrder[0] = 0 And $g_aiCmbCustomHeroOrder[1] = 2 Then $g_aiCmbCustomHeroOrder[4] = 1
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 0 Then $g_aiCmbCustomHeroOrder[4] = 1
			Case 5, 6
				If $g_aiCmbCustomHeroOrder[0] = 0 And $g_aiCmbCustomHeroOrder[1] = 1 And $g_aiCmbCustomHeroOrder[2] = 2 Then $g_aiCmbCustomHeroOrder[4] = 3
				If $g_aiCmbCustomHeroOrder[0] = 0 And $g_aiCmbCustomHeroOrder[1] = 2 And $g_aiCmbCustomHeroOrder[2] = 1 Then $g_aiCmbCustomHeroOrder[4] = 3
				If $g_aiCmbCustomHeroOrder[0] = 1 And $g_aiCmbCustomHeroOrder[1] = 2 And $g_aiCmbCustomHeroOrder[2] = 0 Then $g_aiCmbCustomHeroOrder[4] = 3
				If $g_aiCmbCustomHeroOrder[0] = 1 And $g_aiCmbCustomHeroOrder[1] = 0 And $g_aiCmbCustomHeroOrder[2] = 2 Then $g_aiCmbCustomHeroOrder[4] = 3
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 0 And $g_aiCmbCustomHeroOrder[2] = 1 Then $g_aiCmbCustomHeroOrder[4] = 3
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 1 And $g_aiCmbCustomHeroOrder[2] = 0 Then $g_aiCmbCustomHeroOrder[4] = 3
				If $g_aiCmbCustomHeroOrder[0] = 0 And $g_aiCmbCustomHeroOrder[1] = 1 And $g_aiCmbCustomHeroOrder[2] = 3 Then $g_aiCmbCustomHeroOrder[4] = 2
				If $g_aiCmbCustomHeroOrder[0] = 0 And $g_aiCmbCustomHeroOrder[1] = 3 And $g_aiCmbCustomHeroOrder[2] = 1 Then $g_aiCmbCustomHeroOrder[4] = 2
				If $g_aiCmbCustomHeroOrder[0] = 1 And $g_aiCmbCustomHeroOrder[1] = 0 And $g_aiCmbCustomHeroOrder[2] = 3 Then $g_aiCmbCustomHeroOrder[4] = 2
				If $g_aiCmbCustomHeroOrder[0] = 1 And $g_aiCmbCustomHeroOrder[1] = 3 And $g_aiCmbCustomHeroOrder[2] = 0 Then $g_aiCmbCustomHeroOrder[4] = 2
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 1 And $g_aiCmbCustomHeroOrder[2] = 3 Then $g_aiCmbCustomHeroOrder[4] = 2
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 3 And $g_aiCmbCustomHeroOrder[2] = 1 Then $g_aiCmbCustomHeroOrder[4] = 2
				If $g_aiCmbCustomHeroOrder[0] = 0 And $g_aiCmbCustomHeroOrder[1] = 2 And $g_aiCmbCustomHeroOrder[2] = 3 Then $g_aiCmbCustomHeroOrder[4] = 1
				If $g_aiCmbCustomHeroOrder[0] = 0 And $g_aiCmbCustomHeroOrder[1] = 3 And $g_aiCmbCustomHeroOrder[2] = 2 Then $g_aiCmbCustomHeroOrder[4] = 1
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 0 And $g_aiCmbCustomHeroOrder[2] = 3 Then $g_aiCmbCustomHeroOrder[4] = 1
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 3 And $g_aiCmbCustomHeroOrder[2] = 0 Then $g_aiCmbCustomHeroOrder[4] = 1
				If $g_aiCmbCustomHeroOrder[0] = 3 And $g_aiCmbCustomHeroOrder[1] = 0 And $g_aiCmbCustomHeroOrder[2] = 2 Then $g_aiCmbCustomHeroOrder[4] = 1
				If $g_aiCmbCustomHeroOrder[0] = 3 And $g_aiCmbCustomHeroOrder[1] = 2 And $g_aiCmbCustomHeroOrder[2] = 0 Then $g_aiCmbCustomHeroOrder[4] = 1
				If $g_aiCmbCustomHeroOrder[0] = 1 And $g_aiCmbCustomHeroOrder[1] = 2 And $g_aiCmbCustomHeroOrder[2] = 3 Then $g_aiCmbCustomHeroOrder[4] = 0
				If $g_aiCmbCustomHeroOrder[0] = 1 And $g_aiCmbCustomHeroOrder[1] = 3 And $g_aiCmbCustomHeroOrder[2] = 2 Then $g_aiCmbCustomHeroOrder[4] = 0
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 1 And $g_aiCmbCustomHeroOrder[2] = 3 Then $g_aiCmbCustomHeroOrder[4] = 0
				If $g_aiCmbCustomHeroOrder[0] = 2 And $g_aiCmbCustomHeroOrder[1] = 3 And $g_aiCmbCustomHeroOrder[2] = 1 Then $g_aiCmbCustomHeroOrder[4] = 0
				If $g_aiCmbCustomHeroOrder[0] = 3 And $g_aiCmbCustomHeroOrder[1] = 2 And $g_aiCmbCustomHeroOrder[2] = 1 Then $g_aiCmbCustomHeroOrder[4] = 0
				If $g_aiCmbCustomHeroOrder[0] = 3 And $g_aiCmbCustomHeroOrder[1] = 1 And $g_aiCmbCustomHeroOrder[2] = 2 Then $g_aiCmbCustomHeroOrder[4] = 0
		EndSwitch
	EndIf

	Local $aiUsedHero = $g_aiHeroSlotOrder
	Local $aTmpTrainOrder[0], $iStartShuffle = 0
	Local $HiddenBackup = $g_aiCmbCustomHeroOrder[4]

	For $i = 0 To UBound($g_aiCmbCustomHeroOrder) - 1
		Local $iValue = $g_aiCmbCustomHeroOrder[$i]
		If $iValue <> -1 Then
			_ArrayAdd($aTmpTrainOrder, $iValue)
			Local $iEmpty = _ArraySearch($aiUsedHero, $iValue)
			If $iEmpty > -1 Then $aiUsedHero[$iEmpty] = -1
		EndIf
	Next

	$iStartShuffle = UBound($aTmpTrainOrder)
	_ArraySort($aiUsedHero)

	For $i = 0 To UBound($aTmpTrainOrder) - 1
		If $aiUsedHero[$i] = -1 Then $aiUsedHero[$i] = $aTmpTrainOrder[$i]
	Next

	_ArrayShuffle($aiUsedHero, $iStartShuffle)

	$g_aiCmbCustomHeroOrder = $aiUsedHero

	If $g_aiHeroHallPos[2] < 7 Then
		If $g_aiCmbCustomHeroOrder[4] <> $HiddenBackup Then
			For $i = 0 To $eHeroSlots - 1
				If $g_aiCmbCustomHeroOrder[$i] = $HiddenBackup Then
					$g_aiCmbCustomHeroOrder[$i] = $g_aiCmbCustomHeroOrder[4]
					$g_aiCmbCustomHeroOrder[4] = $HiddenBackup
					ExitLoop
				EndIf
			Next
		EndIf
	EndIf

	Switch $g_aiCmbCustomHeroOrder[4]
		Case 0
			If $g_bFirstStartForHiddenHero Then
				GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
			Else
				If BitAND($g_iHeroUpgradingBit, $eHeroKing) = $eHeroKing Then
					GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
				Else
					If BitAND($g_iHeroAvailable, $eHeroKing) = $eHeroKing Then
						GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
					Else
						GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
					EndIf
				EndIf
			EndIf
		Case 1
			If $g_bFirstStartForHiddenHero Then
				GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
			Else
				If BitAND($g_iHeroUpgradingBit, $eHeroQueen) = $eHeroQueen Then
					GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
				Else
					If BitAND($g_iHeroAvailable, $eHeroQueen) = $eHeroQueen Then
						GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
					Else
						GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
					EndIf
				EndIf
			EndIf
		Case 2
			If $g_bFirstStartForHiddenHero Then
				GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
			Else
				If BitAND($g_iHeroUpgradingBit, $eHeroPrince) = $eHeroPrince Then
					GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
				Else
					If BitAND($g_iHeroAvailable, $eHeroPrince) = $eHeroPrince Then
						GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
					Else
						GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
					EndIf
				EndIf
			EndIf
		Case 3
			If $g_bFirstStartForHiddenHero Then
				GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
			Else
				If BitAND($g_iHeroUpgradingBit, $eHeroWarden) = $eHeroWarden Then
					GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
				Else
					If BitAND($g_iHeroAvailable, $eHeroWarden) = $eHeroWarden Then
						GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
					Else
						GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
					EndIf
				EndIf
			EndIf
		Case 4
			If $g_bFirstStartForHiddenHero Then
				GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
				GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
				GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
			Else
				If BitAND($g_iHeroUpgradingBit, $eHeroChampion) = $eHeroChampion Then
					GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
					GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
					GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
				Else
					If BitAND($g_iHeroAvailable, $eHeroChampion) = $eHeroChampion Then
						GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
					Else
						GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
						GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
						GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
					EndIf
				EndIf
			EndIf
	EndSwitch

	Local $HeroSlotsInfos[5] = ["King", "Queen", "Prince", "Warden", "Champion"]
	SetDebugLog("Hero Custom Order : " & $HeroSlotsInfos[$g_aiCmbCustomHeroOrder[0]] & "|" & $HeroSlotsInfos[$g_aiCmbCustomHeroOrder[1]] & "|" _
			 & $HeroSlotsInfos[$g_aiCmbCustomHeroOrder[2]] & "|" & $HeroSlotsInfos[$g_aiCmbCustomHeroOrder[3]] & "|" & $HeroSlotsInfos[$g_aiCmbCustomHeroOrder[4]])

	$bCheckHeroOrder[$g_iCurAccount] = True

EndFunc   ;==>CheckHeroOrder

Func HeroHallValuesCheck()
	If $g_iTownHallLevel > 6 Then
		If $g_aiHeroHallPos[1] = "" Or $g_aiHeroHallPos[1] = -1 Or $g_aiHeroHallPos[2] = -1 Then
			Local $BackToMain = False
			If IsMainGrayed() Then
				$BackToMain = True
				CloseWindow2()
			EndIf
			If ImgLocateHeroHall() Then
				SetLog("Hero Hall: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level : " & $g_aiHeroHallPos[2], $COLOR_DEBUG)
				ClearScreen()
				If $BackToMain Then OpenArmyOverview(True, "HeroHallValuesCheck()")
				Return True
			EndIf
			Return False
		EndIf
		Return True
	EndIf
EndFunc   ;==>HeroHallValuesCheck
