; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (06-2016), MR.ViPER (10-2016), Fliegerfaust (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False, $CheckWindow = True, $bSetLog = True)

	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Begin getArmyHeroCount:", $COLOR_DEBUG)

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

	$g_iHeroAvailable = $eHeroNone ; Reset hero available data
	Local $iDebugArmyHeroCount = 0 ; local debug flag

	; Detection by OCR
	Local $sResult
	Local Const $iHeroes = 3
	Local $sMessage = ""

	For $i = 0 To $iHeroes - 1
		$sResult = ArmyHeroStatus($i)
		If $sResult <> "" Then ; we found something, figure out what?
			Select
				Case StringInStr($sResult, "king", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Barbarian King Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
					; unset King upgrading
					$g_iHeroUpgrading[0] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOr($eHeroQueen,$eHeroWarden))
				Case StringInStr($sResult, "queen", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Archer Queen Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroQueen)
					; unset Queen upgrading
					$g_iHeroUpgrading[1] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOr($eHeroKing,$eHeroWarden))
				Case StringInStr($sResult, "warden", $STR_NOCASESENSEBASIC)
					If $bSetLog Then SetLog(" - Grand Warden Available", $COLOR_SUCCESS)
					$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
					; unset Warden upgrading
					$g_iHeroUpgrading[2] = 0
					$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOr($eHeroKing,$eHeroQueen))
				Case StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC)
					If $g_bDebugSetlogTrain Or $iDebugArmyHeroCount = 1 Then
						Switch $i
							Case 0
								$sMessage = "-Barbarian King"
								; unset King upgrading
								$g_iHeroUpgrading[0] = 0
								$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOr($eHeroQueen,$eHeroWarden))
							Case 1
								$sMessage = "-Archer Queen"
								; unset Queen upgrading
								$g_iHeroUpgrading[1] = 0
								$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOr($eHeroKing,$eHeroWarden))
							Case 2
								$sMessage = "-Grand Warden"
								; unset Warden upgrading
								$g_iHeroUpgrading[2] = 0
								$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOr($eHeroKing,$eHeroQueen))
							Case Else
								$sMessage = "-Very Bad Monkey Needs"
						EndSwitch
						SetLog("Hero slot#" & $i + 1 & $sMessage & " Healing", $COLOR_DEBUG)
					EndIf
				Case StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC)
					Switch $i
						Case 0
							$sMessage = "-Barbarian King"
							; set King upgrading
							$g_iHeroUpgrading[0] = 1
							$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
							; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
							If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
									($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then ; check wait for hero status
								If $g_iSearchNotWaitHeroesEnable Then
									$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroKing)
								Else
									SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_ERROR)
								EndIf
								_GUI_Value_STATE("SHOW", $groupKingSleeping) ; Show king sleeping icon
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
							$sMessage = "-Grand Warden"
							; set Warden upgrading
							$g_iHeroUpgrading[2] = 1
							$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
							; safety code
							If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
									($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
								If $g_iSearchNotWaitHeroesEnable Then
									$g_iHeroAvailable = BitOR($g_iHeroAvailable, $eHeroWarden)
								Else
									SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_ERROR)
								EndIf
								_GUI_Value_STATE("SHOW", $groupWardenSleeping) ; Show Warden sleeping icon
							EndIf
						Case Else
							$sMessage = "-Need to Feed Code Monkey some bananas"
					EndSwitch
					If $g_bDebugSetlogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & $sMessage & " Upgrade in Process", $COLOR_DEBUG)
				Case StringInStr($sResult, "none", $STR_NOCASESENSEBASIC)
					If $g_bDebugSetlogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & " Empty, stop count", $COLOR_DEBUG)
					ExitLoop ; when we find empty slots, done looking for heroes
				Case Else
					If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " bad OCR string returned!", $COLOR_ERROR)
			EndSelect
		Else
			If $bSetLog Then SetLog("Hero slot#" & $i + 1 & " status read problem!", $COLOR_ERROR)
		EndIf
	Next

	If $g_bDebugSetlogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero Status  K|Q|W : " & BitAND($g_iHeroAvailable, $eHeroKing) & "|" & BitAND($g_iHeroAvailable, $eHeroQueen) & "|" & BitAND($g_iHeroAvailable, $eHeroWarden), $COLOR_DEBUG)
	If $g_bDebugSetlogTrain Or $iDebugArmyHeroCount = 1 Then SetLog("Hero Upgrade K|Q|W : " & BitAND($g_iHeroUpgradingBit, $eHeroKing) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroQueen) & "|" & BitAND($g_iHeroUpgradingBit, $eHeroWarden), $COLOR_DEBUG)

	If $bCloseArmyWindow Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmyHeroCount

Func ArmyHeroStatus($i)
	Local $sImageDir = "trainwindow-HeroStatus-bundle", $sResult = ""
	Local Const $aHeroesRect[3][4] = [[655, 340, 680, 370], [730, 340, 755, 370], [805, 340, 830, 370]]

	; Perform the search
	_CaptureRegion2($aHeroesRect[$i][0], $aHeroesRect[$i][1], $aHeroesRect[$i][2], $aHeroesRect[$i][3])
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $sImageDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)
	If $res[0] <> "" Then
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)
		If StringInStr($aKeys[0], "xml", $STR_NOCASESENSEBASIC) Then
			Local $aResult = StringSplit($aKeys[0], "_", $STR_NOCOUNT)
			$sResult = $aResult[0]
			;setlog("$i , $sResult :"& $i  & ", " & $sResult )

			Select
				Case $i = "King" Or $i = 0 Or $i = $eKing
					Switch $sResult
						Case "heal" ; Blue
							GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingBlue, $GUI_SHOW)
						Case "upgrade" ; Red
							GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
						Case "king" ; Green
							GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
					EndSwitch

				Case $i = "Queen" Or $i = 1 Or $i = $eQueen
					Switch $sResult
						Case "heal" ; Blue
							GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenBlue, $GUI_SHOW)
						Case "upgrade" ; Red
							GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
						Case "queen" ; Green
							GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
					EndSwitch

				Case $i = "Warden" Or $i = 2 Or $i = $eWarden
					Switch $sResult
						Case "heal" ; Blue
							GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenBlue, $GUI_SHOW)
						Case "upgrade" ; Red
							GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
						Case "warden" ; Green
							GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
							GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
					EndSwitch
			EndSelect
			Return $sResult
		EndIf
	EndIf

	;return 'none' if there was a problem with the search ; or no Hero slot
	Switch $i
		Case 0
			GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
			Return "none"
		Case 1
			GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
			Return "none"
		Case 2
			GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
			Return "none"
	EndSwitch

EndFunc   ;==>ArmyHeroStatus

Func LabGuiDisplay() ; called from main loop to get an early status for indictors in bot bottom

	Local Static $iLastTimeChecked[8] = [0, 0, 0, 0, 0, 0, 0, 0]

		; Check if is a valid date and Calculated the number of minutes from remain time Lab and now
	If _DateIsValid($g_sLabUpgradeTime) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime)
		Local $iLastCheck =_DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Lab LabUpgradeTime: " & $g_sLabUpgradeTime & ", Lab DateCalc: " & $iLabTime)
		SetDebugLog("Lab LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each 6 hours [6*60 = 360] or when Lab research time finishes
		If $iLabTime > 0 And $iLastCheck <= 360 Then Return
	EndIf

	;CLOSE ARMY WINDOW
	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(1500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

	Setlog("Checking Lab Status", $COLOR_INFO)

	;=================Section 2 Lab Gui

	; If $g_bAutoLabUpgradeEnable = True Then  ====>>>> TODO : or use this or make a checkbox on GUI
	; make sure lab is located, if not locate lab
	If $g_aiLaboratoryPos[0] <= 0 Or $g_aiLaboratoryPos[1] <= 0 Then
		SetLog("Laboratory Location not found!", $COLOR_ERROR)
		LocateLab() ; Lab location unknown, so find it.
		If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
			SetLog("Problem locating Laboratory, train laboratory position before proceeding", $COLOR_ERROR)
			;============Hide Red  Hide Green  Show Gray==
			GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
			;============================================
			Return
		EndIf
	EndIf
	BuildingClickP($g_aiLaboratoryPos, "#0197") ;Click Laboratory
	If _Sleep(1500) Then Return ; Wait for window to open
	; Find Research Button

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	Local $aResearchButton = findButton("Research", Default, 1, True)
	If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
		If $g_bDebugImageSave Then DebugImageSave("StarLabUpgrade") ; Debug Only
		ClickP($aResearchButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
	Else
		SetLog("Cannot find the Laboratory Research Button!", $COLOR_ERROR)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
		;===========Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		;===========================================
		Return
	EndIf

	; check for upgrade in process - look for green in finish upgrade with gems button
	If _ColorCheck(_GetPixelColor(730, 200, True), Hex(0xA2CB6C, 6), 20) Then ; Look for light green in upper right corner of lab window.
		SetLog("Laboratory is Running. ", $COLOR_INFO)
		;==========Hide Red  Show Green Hide Gray===
		GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGreen, $GUI_SHOW)
		;===========================================
		If _Sleep($DELAYLABORATORY2) Then Return
		Local $sLabTimeOCR = getRemainTLaboratory(270, 257)
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False)
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
		EndIf
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		Return True
	ElseIf _ColorCheck(_GetPixelColor(730, 200, True), Hex(0x8088B0, 6), 20) Then ; Look for light purple in upper right corner of lab window.
		SetLog("Laboratory has Stopped", $COLOR_INFO)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		;========Show Red  Hide Green  Hide Gray=====
		GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;============================================
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		$g_sLabUpgradeTime = ""
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		Return
	Else
		SetLog("Unable to determine Lab Status", $COLOR_INFO)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
		;========Hide Red  Hide Green  Show Gray======
		GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLLabTime, "")
		;=============================================
		Return
	EndIf

EndFunc   ;==>LabGuiDisplay

Func HideShields($bHide = False)
	Local Static $ShieldState[20]
	Local $counter
	If $bHide = True Then
		$counter = 0
		For $i = $g_hlblKing to $g_hLbLLabTime
			$ShieldState[$counter] = GUICtrlGetState($i)
			GUICtrlSetState($i, $GUI_HIDE)
			$counter += 1
		Next
	Else
		$counter = 0
		For $i = $g_hlblKing to $g_hLbLLabTime
			If $ShieldState[$counter] = 80 Then
				GUICtrlSetState($i, $GUI_SHOW )
			EndIf
			$counter += 1
		Next
	EndIf
EndFunc
