
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......: MonkeyHunter (06-2016), MR.ViPER (16-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getArmyTHeroCount:", $COLOR_DEBUG) ;Debug

	If $bOpenArmyWindow = False And ISArmyWindow() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If OpenArmyWindow() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	;If $iTownHallLevel < 7 then return
	If $bHaveAnyHero = -1 Then
		; The variable to see if the village have any hero is not set yet
		; check if the village have any hero
		Local $rImgSearch = Not (StringInStr(FindImageInPlace("HaveAnyHero", @ScriptDir & "\imgxml\trainwindow\HeroSlots\NoHero_1_95.xml", "620,400,675,430", True), ","))
		If $g_iDebugSetlog = 1 Then SetLog("Setting $bHaveAnyHero Value To: " & $rImgSearch, $COLOR_DEBUG)
		If $rImgSearch = True Then
			$bHaveAnyHero = 1
		Else
			$bHaveAnyHero = 0
			Return	; There're no heroes to check, Return
		EndIf
	ElseIf $bHaveAnyHero = 0 Then
		If $g_iDebugSetlog = 1 Then SetLog("$bHaveAnyHero = 0", $COLOR_DEBUG)
		Return	; There're no heroes to check, Return
	EndIf

	$iHeroAvailable = $eHeroNone ; Reset hero available data
	$bFullArmyHero = False
	Local $debugArmyHeroCount = 0 ; local debug flag

	; Detection by OCR
	Local $sResult
	Local Const $HeroSlots[3][2] = [[464, 446], [526, 446], [588, 446]] ; Location of hero status check tile
	Local $sMessage = ""
	Local $tmpUpgradingHeroes[3] = [ $eHeroNone, $eHeroNone, $eHeroNone ]
	$iHeroUpgrading[0] = 0
	$iHeroUpgrading[1] = 0
	$iHeroUpgrading[2] = 0

	For $index = 0 To UBound($HeroSlots) - 1
		$sResult = ArmyHeroStatus($index) ; OCR slot for information
		If $sResult <> "" Then ; we found something, figure out what?
			Select
				Case StringInStr($sResult, "king", $STR_NOCASESENSEBASIC)
					Setlog(" - Barbarian King available", $COLOR_GREEN)
					$iHeroAvailable = BitOR($iHeroAvailable, $eHeroKing)
				Case StringInStr($sResult, "queen", $STR_NOCASESENSEBASIC)
					Setlog(" - Archer Queen available", $COLOR_GREEN)
					$iHeroAvailable = BitOR($iHeroAvailable, $eHeroQueen)
				Case StringInStr($sResult, "warden", $STR_NOCASESENSEBASIC)
					Setlog(" - Grand Warden available", $COLOR_GREEN)
					$iHeroAvailable = BitOR($iHeroAvailable, $eHeroWarden)
				Case StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC)
					If $g_iDebugSetlogTrain = 1 Or $debugArmyHeroCount = 1 Then
						Switch $index
							Case 0
								$sMessage = "-Barbarian King"
							Case 1
								$sMessage = "-Archer Queen"
							Case 2
								$sMessage = "-Grand Warden"
							Case Else
								$sMessage = "-Very Bad Monkey Needs"
						EndSwitch
						SetLog("Hero slot#" & $index + 1 & $sMessage & " Healing", $COLOR_DEBUG) ;Debug
					EndIf
					Local $HealTime = number(getArmyHeroTime(19 + $index)) ; 19 = $eKing
					If @error Then
						Setlog("getArmyHeroTime return error, on getArmyHeroCount!", $COLOR_ERROR)
					EndIf
					If $HealTime <> "" then
						If $index = 0 then Setlog(" - Barbarian King will recover in " & Min2Time($HealTime), $COLOR_ACTION)
						If $index = 1 then Setlog(" - Archer Queen will recover in " & Min2Time($HealTime) , $COLOR_ACTION)
						If $index = 2 then Setlog(" - Grand Warden will recover in " & Min2Time($HealTime), $COLOR_ACTION)
					Else
						Setlog("slot " & $index + 1 &  " getArmyHeroTime error!")
						if Not ISArmyWindow() then return
					EndIf
				Case StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC)
					Switch $index
						Case 0
							$sMessage = "-Barbarian King"
							$tmpUpgradingHeroes[$index] = $eHeroKing
							; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
							If BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing Or BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing Then  ; check wait for hero status
								;$g_aiSearchHeroWaitEnable[$DB] = BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroQueen, $eHeroWarden) ; remove wait for king value with mask
								;$g_aiSearchHeroWaitEnable[$LB] = BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroQueen, $eHeroWarden)
								;GUICtrlSetState($chkDBKingWait, $GUI_UNCHECKED)  ; uncheck GUI box to show user wait for king not possible
								;GUICtrlSetState($chkABKingWait, $GUI_UNCHECKED)
								_GUI_Value_STATE("SHOW", $groupKingSleeping)  ; Show king sleeping icon
								;SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_RED)
							EndIf
						Case 1
							$sMessage = "-Archer Queen"
							$tmpUpgradingHeroes[$index] = $eHeroQueen
							; safety code
							If BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen Or BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen Then
								;$g_aiSearchHeroWaitEnable[$DB] = BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroKing, $eHeroWarden)
								;$g_aiSearchHeroWaitEnable[$LB] = BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroKing, $eHeroWarden)
								;GUICtrlSetState($chkDBQueenWait, $GUI_UNCHECKED)
								;GUICtrlSetState($chkABQueenWait, $GUI_UNCHECKED)
								_GUI_Value_STATE("SHOW", $groupQueenSleeping)
								;SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_RED)
							EndIf
						Case 2
							$sMessage = "-Grand Warden"
							$tmpUpgradingHeroes[$index] = $eHeroWarden
							; safety code
							If BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden Or BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden Then
								;$g_aiSearchHeroWaitEnable[$DB] = BitAND($g_aiSearchHeroWaitEnable[$DB], $eHeroKing, $eHeroQueen)
								;$g_aiSearchHeroWaitEnable[$LB] = BitAND($g_aiSearchHeroWaitEnable[$LB], $eHeroKing, $eHeroQueen)
								;GUICtrlSetState($chkDBWardenWait, $GUI_UNCHECKED)
								;GUICtrlSetState($chkABWardenWait, $GUI_UNCHECKED)
								_GUI_Value_STATE("SHOW", $groupWardenSleeping)
								;SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_RED)
							EndIf
						Case Else
							$sMessage = "-Need to Get Monkey"
					EndSwitch
					$iHeroUpgrading[$index] = 1
					If $g_iDebugSetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("Hero slot#" & $index + 1 & $sMessage & " Upgrade in Process", $COLOR_DEBUG) ;Debug
				Case StringInStr($sResult, "none", $STR_NOCASESENSEBASIC)
					If $g_iDebugSetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("Hero slot#" & $index + 1 & " Empty, stop count", $COLOR_DEBUG) ;Debug
					ExitLoop ; when we find empty slots, done looking for heroes
				Case Else
					SetLog("Hero slot#" & $i + 1 & " bad OCR string returned!", $COLOR_RED)
			EndSelect
		Else
			SetLog("Hero slot#" & $index + 1 & " status read problem!", $COLOR_RED)
		EndIf
	Next
	$iHeroUpgradingBit = BitOR($tmpUpgradingHeroes[0], $tmpUpgradingHeroes[1], $tmpUpgradingHeroes[2])

	If $g_abAttackTypeEnable[$DB] = False then $g_aiSearchHeroWaitEnable[$DB] = $eHeroNone
	If $g_abAttackTypeEnable[$LB] = False then $g_aiSearchHeroWaitEnable[$LB] = $eHeroNone

	If (($g_abAttackTypeEnable[$DB] and $g_aiSearchHeroWaitEnable[$DB]<= $iHeroAvailable) Or ($g_abAttackTypeEnable[$LB] and $g_aiSearchHeroWaitEnable[$LB]<= $iHeroAvailable)) Or _
			($g_aiSearchHeroWaitEnable[$DB] = $eHeroNone And $g_aiSearchHeroWaitEnable[$LB] = $eHeroNone) Then
		$bFullArmyHero = True
		If $g_iDebugSetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("$bFullArmyHero= " & $bFullArmyHero, $COLOR_DEBUG) ;Debug
	EndIf

	If $g_iDebugSetlogTrain = 1 Or $debugArmyHeroCount = 1 Then
		Setlog("====== DEBUG HEROES ======" )
		Setlog("$g_aiSearchHeroWaitEnable[$DB]: " & $g_aiSearchHeroWaitEnable[$DB])
		Setlog("$g_aiSearchHeroWaitEnable[$LB]: " & $g_aiSearchHeroWaitEnable[$LB])
		Setlog("$iHeroAvailable: " & $iHeroAvailable)
		Setlog("$bFullArmyHero: " & $bFullArmyHero)
		SetLog("Hero Status K|Q|W : " & BitAND($iHeroAvailable, $eHeroKing) & "|" & BitAND($iHeroAvailable, $eHeroQueen) & "|" & BitAND($iHeroAvailable, $eHeroWarden), $COLOR_DEBUG) ;Debug
		Setlog("====== ########### ======" )
	EndIF

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmyHeroCount

Func Min2Time($nr_min)
	Local $nr_sec = $nr_min * 60
	Local $sec2time_hour = Int($nr_sec / 3600)
	Local $sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
	Local $sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
	Return StringFormat('%02d:%02d:%02d', $sec2time_hour, $sec2time_min, $sec2time_sec)
EndFunc   ;==>Sec2Time
