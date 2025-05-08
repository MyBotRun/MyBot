; #FUNCTION# ====================================================================================================================
; Name ..........: HelperHut.au3
; Description ...: This file controls Helper Hut and Assignments
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Moebius14 (11/2024)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func HelperHut()

	Select
		Case $g_bChkAppBuilder = 0 And $g_bChkLabAssistant = 0
			Return
		Case $g_bChkAppBuilder > 0 And $g_bChkLabAssistant = 0
			AppBuilder()
		Case $g_bChkAppBuilder = 0 And $g_bChkLabAssistant > 0
			LabAssistant()
		Case $g_bChkAppBuilder > 0 And $g_bChkLabAssistant > 0
			_HelperHutBoth()
	EndSelect

EndFunc   ;==>HelperHut

Func AppBuilder()

	If $g_iTownHallLevel < 10 Then
		Return
	EndIf

	If Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[8]
	Local Static $bUnderTime[8]
	If $g_bFirstStart Then
		$iLastTimeChecked[$g_iCurAccount] = ""
		$bUnderTime[$g_iCurAccount] = False
	EndIf

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec, $iDay

	If _DateIsValid($g_sAvailableAppBuilder) Then
		$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffAppBuilder > 0 Then

			$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			If $bUnderTime[$g_iCurAccount] = True Then
				SetLog("Current Updgrade Time Too Small", $COLOR_DEBUG1)
				SetLog("Next Check in " & $sWaitTime, $COLOR_ACTION)
			Else
				SetLog("Builder's Apprentice Unavailable", $COLOR_DEBUG1)
				SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)
			EndIf
			Return
		EndIf
	Else
		If Not _DateIsValid($g_sAvailableAppBuilder) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
			SetDebugLog("Builder's App LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
			Local $iDelayToCheck = Random(120, 240, 1)
			If $iLastCheck <= $iDelayToCheck Then Return
		EndIf
	EndIf

	Local $bLocateHelperHut = False
	BuildingClick($g_aiHelperHutPos[0], $g_aiHelperHutPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return

	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)

	If Not StringInStr($BuildingInfo[1], "Helper", $STR_NOCASESENSEBASIC) Then $bLocateHelperHut = True
	If $bLocateHelperHut Then
		SetLog("Helper Hut not Found", $COLOR_DEBUG1)
		SetLog("New Try...", $COLOR_DEBUG1)
		ClearScreen()
		If _Sleep(Random(1000, 1500, 1)) Then Return
		BuildingClick($g_aiHelperHutPos[0], $g_aiHelperHutPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If Not StringInStr($BuildingInfo[1], "Helper", $STR_NOCASESENSEBASIC) Then
			SetLog("Helper Hut not Found", $COLOR_DEBUG1)
			ClearScreen()
			Return
		EndIf
	EndIf

	Local $BuildersApp = FindButton("BuildersApp")
	If IsArray($BuildersApp) And UBound($BuildersApp) = 2 Then
		Click($BuildersApp[0], 545 + $g_iBottomOffsetY)
		If _Sleep(Random(1500, 2000, 1)) Then Return
	Else
		ClearScreen()
		Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	If Not QuickMIS("BC1", $g_sImgGeneralCloseButton, 770, 100, 845, 130 + $g_iMidOffsetY) Then
		SetLog("Builder's Apprentice Window Didn't Open", $COLOR_DEBUG1)
		CloseWindow2()
		If _Sleep(Random(1500, 2000, 1)) Then Return
		ClearScreen()
		Return
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	WaitForClanMessage("BuildersApprenticeMid")
	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 730, 520 + $g_iMidOffsetY, 815, 560 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Builder's Apprentice is Locked", $COLOR_ERROR)
		CloseWindow()
		Return
	EndIf

	Local $bXMultiplier = Number(getOcrAndCapture("coc-uptime", 663, 176 + $g_iMidOffsetY, 37, 17, True))
	If $bXMultiplier = "" Or $bXMultiplier < 1 Or $bXMultiplier > 8 Then $bXMultiplier = 1 ; In Case
	SetLog("Builder's Apprentice is Level " & $bXMultiplier, $COLOR_INFO)

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniBuilderApp", $g_sImgMiniBuilderAppHead, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY, True)) ; Recurrence
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniBuilderApp", $g_sImgMiniBuilderAppHead, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY, True)) ; Recurrence
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	If $g_bChkAppBuilder = 2 Then MoveToBottom()

	WaitForClanMessage("BuildersApprenticeMid")

	Local $GreenAssignButtons = QuickMIS("CNX", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY)
	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then
		If $g_bChkAppBuilder = 1 Then
			_ArraySort($GreenAssignButtons, 0, 0, 0, 2)
		Else
			_ArraySort($GreenAssignButtons, 1, 0, 0, 2)
		EndIf
		For $i = 0 To UBound($GreenAssignButtons) - 1
			Local $bRemainingUpTimeOCR = getOcrAndCapture("coc-BAUpgradeTime", $GreenAssignButtons[$i][1] - 166, $GreenAssignButtons[$i][2] - 4, 114, 16, True)
			Local $iRemainingTime = ConvertOCRTime("Upgrade Time", $bRemainingUpTimeOCR, False)
			SetDebugLog("Remaining Up OCR Time = " & $bRemainingUpTimeOCR & ", $iRemainingTime = " & $iRemainingTime & " m", $COLOR_INFO)
			Local $bBAGranted = False
			Switch $bXMultiplier
				Case 1 To 3
					If $iRemainingTime > $bXMultiplier * 60 Then $bBAGranted = True
				Case 4
					If $iRemainingTime > ($bXMultiplier - 1) * 60 Then $bBAGranted = True
				Case 5, 6
					If $iRemainingTime > ($bXMultiplier - 2) * 60 Then $bBAGranted = True
				Case 7, 8
					If $iRemainingTime > ($bXMultiplier - 3) * 60 Then $bBAGranted = True
			EndSwitch
			If $iRemainingTime = 0 Then $bBAGranted = True ; In Case
			If $bBAGranted Then
				If $iRemainingTime > 0 Then
					; Must be in ms !
					If $iRemainingTime > $bXMultiplier * 60 Then
						$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
					Else
						$iWaitTime = ($iRemainingTime / $bXMultiplier) * 60 * 1000
					EndIf
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
					If $iDay > 0 Then
						$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
					Else
						$iHour = Floor(Floor($iWaitSec / 60 / 60))
					EndIf
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iDay = 1 Then $sWaitTime &= $iDay & " day "
					If $iDay > 1 Then $sWaitTime &= $iDay & " days "
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					SetLog("Current Upgrade Will Finish in " & $sWaitTime, $COLOR_SUCCESS1)

				EndIf

				Click($GreenAssignButtons[$i][1], $GreenAssignButtons[$i][2]) ;Click Assign
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If $bUnderTime[$g_iCurAccount] = True Then $bUnderTime[$g_iCurAccount] = False
				ExitLoop
			Else
				If $iRemainingTime > 0 Then
					$iWaitTime = $iRemainingTime * 60 * 1000
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					Switch $bXMultiplier
						Case 1 To 3
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & $bXMultiplier & " Hour" & ($bXMultiplier > 1 ? "s)" : ")"), $COLOR_WARNING)
						Case 4
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 1) & " Hours)", $COLOR_WARNING)
						Case 5, 6
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 2) & " Hours)", $COLOR_WARNING)
						Case 7, 8
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 3) & " Hours)", $COLOR_WARNING)
					EndSwitch

					If $g_bChkAppBuilder = 1 Or ($g_bChkAppBuilder = 2 And $i = UBound($GreenAssignButtons) - 1) Then
						Local $StartTime = _NowCalc() ; what is date:time now
						$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iRemainingTime), $StartTime)
						SetLog("Buider's App Next Check @ " & $g_sAvailableAppBuilder, $COLOR_DEBUG1)
						$bUnderTime[$g_iCurAccount] = True
					Else
						SetLog("Check Next Upgrade...", $COLOR_INFO)
						If _Sleep(1000) Then Return
						ContinueLoop
					EndIf
				Else
					$g_sAvailableAppBuilder = 0
					$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				EndIf
				CloseWindow()
				Return
			EndIf
		Next
	Else
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			If $iAppBuilderAvailTime > 60 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		Else
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			If $iAppBuilderAvailTime > 0 And $iAppBuilderAvailTime < 1380 Then SetLog("CoolDown Time", $COLOR_SUCCESS)
			If $iAppBuilderAvailTime > 1380 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		EndIf
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iAppBuilderAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			SetLog("Buider's App Available @ " & $g_sAvailableAppBuilder, $COLOR_DEBUG1)
			$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Builder's Apprentice Unavailable", $COLOR_DEBUG1)
				SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("No upgrade in progress", $COLOR_INFO)
		EndIf
		CloseWindow()
		Return
	EndIf

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 470 + $g_iMidOffsetY, 520, 530 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $iAppBuilderAvailTime = 0
		Local $CoordsX[2] = [390, 480]
		Local $CoordsY[2] = [480 + $g_iMidOffsetY, 520 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Builder's Apprentice Assigned", $COLOR_SUCCESS)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		WaitForClanMessage("BuildersApprenticeMid")
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			$iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			If $iAppBuilderAvailTime > 60 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
			$iAppBuilderAvailTime += 1320
			SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		EndIf
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			SetLog("Buider's App Available @ " & $g_sAvailableAppBuilder, $COLOR_DEBUG1)
			$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Builder's Apprentice Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("Error processing time read!", $COLOR_WARNING)
			$g_sAvailableAppBuilder = 0
			$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
		EndIf
	Else
		WaitForClanMessage("BuildersApprenticeConfirm")
		CloseWindow2(1) ; Close If a window is open
		If _Sleep(1000) Then Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	CloseWindow()
EndFunc   ;==>AppBuilder

Func LabAssistant()

	If $g_iTownHallLevel < 9 Then
		Return
	EndIf

	If Not _DateIsValid($g_sLabUpgradeTime) Then
		Return
	Else
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime)
		If $iLabTime <= 20 Then Return     ; Less than 20 min -> Return
	EndIf

	If Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[8]
	Local Static $bUnderTime[8]
	If $g_bFirstStart Then
		$iLastTimeChecked[$g_iCurAccount] = ""
		$bUnderTime[$g_iCurAccount] = False
	EndIf

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec, $iDay

	If _DateIsValid($g_sAvailableLabAssistant) Then
		$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffLabAssistant > 0 Then

			$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			If $bUnderTime[$g_iCurAccount] = True Then
				SetLog("Current Updgrade Time Too Small", $COLOR_DEBUG1)
				SetLog("Next Check in " & $sWaitTime, $COLOR_ACTION)
			Else
				SetLog("Lab Assistant Unavailable", $COLOR_DEBUG1)
				SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)
			EndIf
			Return
		EndIf
	Else
		If Not _DateIsValid($g_sAvailableLabAssistant) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc())     ; elapse time from last check (minutes)
			SetDebugLog("Builder's App LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
			Local $iDelayToCheck = Random(120, 240, 1)
			If $iLastCheck <= $iDelayToCheck Then Return
		EndIf
	EndIf

	Local $bLocateHelperHut = False
	BuildingClick($g_aiHelperHutPos[0], $g_aiHelperHutPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return

	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)

	If Not StringInStr($BuildingInfo[1], "Helper", $STR_NOCASESENSEBASIC) Then $bLocateHelperHut = True
	If $bLocateHelperHut Then
		SetLog("Helper Hut not Found", $COLOR_DEBUG1)
		SetLog("New Try...", $COLOR_DEBUG1)
		ClearScreen()
		If _Sleep(Random(1000, 1500, 1)) Then Return
		BuildingClick($g_aiHelperHutPos[0], $g_aiHelperHutPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If Not StringInStr($BuildingInfo[1], "Helper", $STR_NOCASESENSEBASIC) Then
			SetLog("Helper Hut not Found", $COLOR_DEBUG1)
			ClearScreen()
			Return
		EndIf
	EndIf

	Local $LabAssist = FindButton("LabAssist")
	If IsArray($LabAssist) And UBound($LabAssist) = 2 Then
		Click($LabAssist[0], 545 + $g_iBottomOffsetY)
		If _Sleep(Random(1500, 2000, 1)) Then Return
	Else
		ClearScreen()
		Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	If Not QuickMIS("BC1", $g_sImgGeneralCloseButton, 770, 100, 845, 130 + $g_iMidOffsetY) Then
		SetLog("Lab Assistant Window Didn't Open", $COLOR_DEBUG1)
		CloseWindow2()
		If _Sleep(Random(1500, 2000, 1)) Then Return
		ClearScreen()
		Return
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	WaitForClanMessage("BuildersApprenticeMid")
	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 730, 520 + $g_iMidOffsetY, 815, 560 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Lab Assistant is Locked", $COLOR_ERROR)
		CloseWindow()
		Return
	EndIf

	Local $bXMultiplier = Number(getOcrAndCapture("coc-uptime", 663, 176 + $g_iMidOffsetY, 37, 17, True))
	If $bXMultiplier = "" Or $bXMultiplier < 1 Or $bXMultiplier > 12 Then $bXMultiplier = 1 ; In Case
	SetLog("Lab Assistant is Level " & $bXMultiplier, $COLOR_INFO)

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniLabAssistHead", $g_sImgMiniLabAssistHead, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY, True)) ; Recurrence
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	Local $GreenAssignButtons = QuickMIS("CNX", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY)
	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then
		If $g_bChkLabAssistant = 1 Then
			_ArraySort($GreenAssignButtons, 0, 0, 0, 2)
		Else
			_ArraySort($GreenAssignButtons, 1, 0, 0, 2)
		EndIf
		For $i = 0 To UBound($GreenAssignButtons) - 1
			Local $bRemainingUpTimeOCR = getOcrAndCapture("coc-BAUpgradeTime", $GreenAssignButtons[$i][1] - 166, $GreenAssignButtons[$i][2] - 4, 114, 16, True)
			Local $iRemainingTime = ConvertOCRTime("Upgrade Time", $bRemainingUpTimeOCR, False)
			SetDebugLog("Remaining Up OCR Time = " & $bRemainingUpTimeOCR & ", $iRemainingTime = " & $iRemainingTime & " m", $COLOR_INFO)
			Local $bBAGranted = False
			Switch $bXMultiplier
				Case 1 To 3
					If $iRemainingTime > $bXMultiplier * 60 Then $bBAGranted = True
				Case 4
					If $iRemainingTime > ($bXMultiplier - 1) * 60 Then $bBAGranted = True
				Case 5, 6
					If $iRemainingTime > ($bXMultiplier - 2) * 60 Then $bBAGranted = True
				Case 7 To 10
					If $iRemainingTime > ($bXMultiplier - 3) * 60 Then $bBAGranted = True
				Case 11, 12
					If $iRemainingTime > ($bXMultiplier - 4) * 60 Then $bBAGranted = True
			EndSwitch
			If $iRemainingTime = 0 Then $bBAGranted = True ; In Case
			If $bBAGranted Then
				If $iRemainingTime > 0 Then
					; Must be in ms !
					If $iRemainingTime > $bXMultiplier * 60 Then
						$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
					Else
						$iWaitTime = ($iRemainingTime / $bXMultiplier) * 60 * 1000
					EndIf
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
					If $iDay > 0 Then
						$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
					Else
						$iHour = Floor(Floor($iWaitSec / 60 / 60))
					EndIf
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iDay = 1 Then $sWaitTime &= $iDay & " day "
					If $iDay > 1 Then $sWaitTime &= $iDay & " days "
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					SetLog("Current Upgrade Will Finish in " & $sWaitTime, $COLOR_SUCCESS1)
					$bLabAssistantUsedTime = _NowCalc()
				EndIf

				Click($GreenAssignButtons[$i][1], $GreenAssignButtons[$i][2]) ;Click Assign
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If $bUnderTime[$g_iCurAccount] = True Then $bUnderTime[$g_iCurAccount] = False
				ExitLoop
			Else
				If $iRemainingTime > 0 Then
					$iWaitTime = $iRemainingTime * 60 * 1000
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					Switch $bXMultiplier
						Case 1 To 3
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & $bXMultiplier & " Hour" & ($bXMultiplier > 1 ? "s)" : ")"), $COLOR_WARNING)
						Case 4
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 1) & " Hours)", $COLOR_WARNING)
						Case 5, 6
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 2) & " Hours)", $COLOR_WARNING)
						Case 7 To 10
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 3) & " Hours)", $COLOR_WARNING)
						Case 11, 12
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 4) & " Hours)", $COLOR_WARNING)
					EndSwitch

					If $g_bChkLabAssistant = 1 Or ($g_bChkLabAssistant = 2 And $i = UBound($GreenAssignButtons) - 1) Then
						Local $StartTime = _NowCalc() ; what is date:time now
						$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iRemainingTime), $StartTime)
						SetLog("Assistant Next Check @ " & $g_sAvailableLabAssistant, $COLOR_DEBUG1)
						$bUnderTime[$g_iCurAccount] = True
					Else
						SetLog("Check Next Upgrade...", $COLOR_INFO)
						If _Sleep(1000) Then Return
						ContinueLoop
					EndIf
				Else
					$g_sAvailableLabAssistant = 0
					$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				EndIf
				CloseWindow()
				Return
			EndIf
		Next
	Else
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			If $iLabAssistantAvailTime > 60 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		Else
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			If $iLabAssistantAvailTime > 0 And $iLabAssistantAvailTime < 1380 Then SetLog("CoolDown Time", $COLOR_SUCCESS)
			If $iLabAssistantAvailTime > 1380 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		EndIf
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iLabAssistantAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iLabAssistantAvailTime = " & $iLabAssistantAvailTime & " m", $COLOR_INFO)
		If $iLabAssistantAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iLabAssistantAvailTime), $StartTime)
			SetLog("Assistant Available @ " & $g_sAvailableLabAssistant, $COLOR_DEBUG1)
			$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffLabAssistant > 0 Then

				$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Lab Assistant Unavailable", $COLOR_DEBUG1)
				SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("No upgrade in progress", $COLOR_INFO)
		EndIf
		CloseWindow()
		Return
	EndIf

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 470 + $g_iMidOffsetY, 520, 530 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $iLabAssistantAvailTime = 0
		Local $CoordsX[2] = [390, 480]
		Local $CoordsY[2] = [480 + $g_iMidOffsetY, 520 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Lab Assistant Assigned", $COLOR_SUCCESS)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		WaitForClanMessage("BuildersApprenticeMid")
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			$iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			If $iLabAssistantAvailTime > 60 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
			$iLabAssistantAvailTime += 1320
			SetDebugLog("Available OCR Time = " & $Result & ", $iLabAssistantAvailTime = " & $iLabAssistantAvailTime & " m", $COLOR_INFO)
		EndIf
		If $iLabAssistantAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iLabAssistantAvailTime), $StartTime)
			SetLog("Assistant Available @ " & $g_sAvailableLabAssistant, $COLOR_DEBUG1)
			$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffLabAssistant > 0 Then

				$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Lab Assistant Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("Error processing time read!", $COLOR_WARNING)
			$g_sAvailableLabAssistant = 0
			$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
		EndIf
	Else
		WaitForClanMessage("BuildersApprenticeConfirm")
		CloseWindow2(1) ; Close If a window is open
		If _Sleep(1000) Then Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	CloseWindow()
EndFunc   ;==>LabAssistant

Func _HelperHutBoth()

	If $g_iTownHallLevel < 9 Then
		Return
	EndIf

	Local $bToOpen = False
	If HelperHutLab() Then $bToOpen = True

	If _Sleep(500) Then Return
	If Not $g_bRunState Then Return

	HelperHutApp($bToOpen)

EndFunc   ;==>_HelperHutBoth

Func HelperHutLab()

	If Not _DateIsValid($g_sLabUpgradeTime) Then
		Return True
	Else
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime)
		If $iLabTime <= 20 Then Return True ; Less than 20 min -> Return
	EndIf

	If Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[8]
	Local Static $bUnderTime[8]
	If $g_bFirstStart Then
		$iLastTimeChecked[$g_iCurAccount] = ""
		$bUnderTime[$g_iCurAccount] = False
	EndIf

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec, $iDay

	If _DateIsValid($g_sAvailableLabAssistant) Then
		$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffLabAssistant > 0 Then

			$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			If $bUnderTime[$g_iCurAccount] = True Then
				SetLog("Current Updgrade Time Too Small", $COLOR_DEBUG1)
				SetLog("Next Check in " & $sWaitTime, $COLOR_ACTION)
			Else
				SetLog("Lab Assistant Unavailable", $COLOR_DEBUG1)
				SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)
			EndIf
			Return True
		EndIf
	Else
		If Not _DateIsValid($g_sAvailableLabAssistant) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc())     ; elapse time from last check (minutes)
			SetDebugLog("Builder's App LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
			Local $iDelayToCheck = Random(120, 240, 1)
			If $iLastCheck <= $iDelayToCheck Then Return True
		EndIf
	EndIf

	Local $bLocateHelperHut = False
	BuildingClick($g_aiHelperHutPos[0], $g_aiHelperHutPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return

	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)

	If Not StringInStr($BuildingInfo[1], "Helper", $STR_NOCASESENSEBASIC) Then $bLocateHelperHut = True
	If $bLocateHelperHut Then
		SetLog("Helper Hut not Found", $COLOR_DEBUG1)
		SetLog("New Try...", $COLOR_DEBUG1)
		ClearScreen()
		If _Sleep(Random(1000, 1500, 1)) Then Return
		BuildingClick($g_aiHelperHutPos[0], $g_aiHelperHutPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If Not StringInStr($BuildingInfo[1], "Helper", $STR_NOCASESENSEBASIC) Then
			SetLog("Helper Hut not Found", $COLOR_DEBUG1)
			ClearScreen()
			Return True
		EndIf
	EndIf

	Local $LabAssist = FindButton("LabAssist")
	If IsArray($LabAssist) And UBound($LabAssist) = 2 Then
		Click($LabAssist[0], 545 + $g_iBottomOffsetY)
		If _Sleep(Random(1500, 2000, 1)) Then Return
	Else
		ClearScreen()
		Return True
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	If Not QuickMIS("BC1", $g_sImgGeneralCloseButton, 770, 100, 845, 130 + $g_iMidOffsetY) Then
		SetLog("Lab Assistant Window Didn't Open", $COLOR_DEBUG1)
		CloseWindow2()
		If _Sleep(Random(1500, 2000, 1)) Then Return
		ClearScreen()
		Return True
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	WaitForClanMessage("BuildersApprenticeMid")
	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 730, 520 + $g_iMidOffsetY, 815, 560 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Lab Assistant is Locked", $COLOR_ERROR)
		Return False
	EndIf

	Local $bXMultiplier = Number(getOcrAndCapture("coc-uptime", 663, 176 + $g_iMidOffsetY, 37, 17, True))
	If $bXMultiplier = "" Or $bXMultiplier < 1 Or $bXMultiplier > 12 Then $bXMultiplier = 1 ; In Case
	SetLog("Lab Assistant is Level " & $bXMultiplier, $COLOR_INFO)

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniLabAssistHead", $g_sImgMiniLabAssistHead, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY, True)) ; Recurrence
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	Local $GreenAssignButtons = QuickMIS("CNX", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY)
	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then
		If $g_bChkLabAssistant = 1 Then
			_ArraySort($GreenAssignButtons, 0, 0, 0, 2)
		Else
			_ArraySort($GreenAssignButtons, 1, 0, 0, 2)
		EndIf
		For $i = 0 To UBound($GreenAssignButtons) - 1
			Local $bRemainingUpTimeOCR = getOcrAndCapture("coc-BAUpgradeTime", $GreenAssignButtons[$i][1] - 166, $GreenAssignButtons[$i][2] - 4, 114, 16, True)
			Local $iRemainingTime = ConvertOCRTime("Upgrade Time", $bRemainingUpTimeOCR, False)
			SetDebugLog("Remaining Up OCR Time = " & $bRemainingUpTimeOCR & ", $iRemainingTime = " & $iRemainingTime & " m", $COLOR_INFO)
			Local $bBAGranted = False
			Switch $bXMultiplier
				Case 1 To 3
					If $iRemainingTime > $bXMultiplier * 60 Then $bBAGranted = True
				Case 4
					If $iRemainingTime > ($bXMultiplier - 1) * 60 Then $bBAGranted = True
				Case 5, 6
					If $iRemainingTime > ($bXMultiplier - 2) * 60 Then $bBAGranted = True
				Case 7 To 10
					If $iRemainingTime > ($bXMultiplier - 3) * 60 Then $bBAGranted = True
				Case 11, 12
					If $iRemainingTime > ($bXMultiplier - 4) * 60 Then $bBAGranted = True
			EndSwitch
			If $iRemainingTime = 0 Then $bBAGranted = True ; In Case
			If $bBAGranted Then
				If $iRemainingTime > 0 Then
					; Must be in ms !
					If $iRemainingTime > $bXMultiplier * 60 Then
						$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
					Else
						$iWaitTime = ($iRemainingTime / $bXMultiplier) * 60 * 1000
					EndIf
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
					If $iDay > 0 Then
						$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
					Else
						$iHour = Floor(Floor($iWaitSec / 60 / 60))
					EndIf
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iDay = 1 Then $sWaitTime &= $iDay & " day "
					If $iDay > 1 Then $sWaitTime &= $iDay & " days "
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					SetLog("Current Upgrade Will Finish in " & $sWaitTime, $COLOR_SUCCESS1)
					$bLabAssistantUsedTime = _NowCalc()
				EndIf

				Click($GreenAssignButtons[$i][1], $GreenAssignButtons[$i][2]) ;Click Assign
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If $bUnderTime[$g_iCurAccount] = True Then $bUnderTime[$g_iCurAccount] = False
				ExitLoop
			Else
				If $iRemainingTime > 0 Then
					$iWaitTime = $iRemainingTime * 60 * 1000
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					Switch $bXMultiplier
						Case 1 To 3
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & $bXMultiplier & " Hour" & ($bXMultiplier > 1 ? "s)" : ")"), $COLOR_WARNING)
						Case 4
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 1) & " Hours)", $COLOR_WARNING)
						Case 5, 6
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 2) & " Hours)", $COLOR_WARNING)
						Case 7 To 10
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 3) & " Hours)", $COLOR_WARNING)
						Case 11, 12
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 4) & " Hours)", $COLOR_WARNING)
					EndSwitch

					If $g_bChkLabAssistant = 1 Or ($g_bChkLabAssistant = 2 And $i = UBound($GreenAssignButtons) - 1) Then
						Local $StartTime = _NowCalc() ; what is date:time now
						$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iRemainingTime), $StartTime)
						SetLog("Assistant Next Check @ " & $g_sAvailableLabAssistant, $COLOR_DEBUG1)
						$bUnderTime[$g_iCurAccount] = True
					Else
						SetLog("Check Next Upgrade...", $COLOR_INFO)
						If _Sleep(1000) Then Return
						ContinueLoop
					EndIf
				Else
					$g_sAvailableLabAssistant = 0
					$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				EndIf
				Return False
			EndIf
		Next
	Else
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			If $iLabAssistantAvailTime > 60 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				Return False
			EndIf
		Else
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			If $iLabAssistantAvailTime > 0 And $iLabAssistantAvailTime < 1380 Then SetLog("CoolDown Time", $COLOR_SUCCESS)
			If $iLabAssistantAvailTime > 1380 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				Return False
			EndIf
		EndIf
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iLabAssistantAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iLabAssistantAvailTime = " & $iLabAssistantAvailTime & " m", $COLOR_INFO)
		If $iLabAssistantAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iLabAssistantAvailTime), $StartTime)
			SetLog("Assistant Available @ " & $g_sAvailableLabAssistant, $COLOR_DEBUG1)
			$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffLabAssistant > 0 Then

				$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Lab Assistant Unavailable", $COLOR_DEBUG1)
				SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("No upgrade in progress", $COLOR_INFO)
		EndIf
		Return False
	EndIf

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 470 + $g_iMidOffsetY, 520, 530 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $iLabAssistantAvailTime = 0
		Local $CoordsX[2] = [390, 480]
		Local $CoordsY[2] = [480 + $g_iMidOffsetY, 520 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Lab Assistant Assigned", $COLOR_SUCCESS)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		WaitForClanMessage("BuildersApprenticeMid")
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			$iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			If $iLabAssistantAvailTime > 60 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				Return False
			EndIf
			$iLabAssistantAvailTime += 1320
			SetDebugLog("Available OCR Time = " & $Result & ", $iLabAssistantAvailTime = " & $iLabAssistantAvailTime & " m", $COLOR_INFO)
		EndIf
		If $iLabAssistantAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iLabAssistantAvailTime), $StartTime)
			SetLog("Assistant Available @ " & $g_sAvailableLabAssistant, $COLOR_DEBUG1)
			$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffLabAssistant > 0 Then

				$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Lab Assistant Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("Error processing time read!", $COLOR_WARNING)
			$g_sAvailableLabAssistant = 0
			$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
		EndIf
	Else
		WaitForClanMessage("BuildersApprenticeConfirm")
		CloseWindow2(1) ; Close If a window is open
		If _Sleep(1000) Then Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
EndFunc   ;==>HelperHutLab

Func HelperHutApp($bToOpen = False)

	If $g_iTownHallLevel < 10 Then
		If Not $bToOpen Then CloseWindow()
		Return
	EndIf

	If Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[8]
	Local Static $bUnderTime[8]
	If $g_bFirstStart Then
		$iLastTimeChecked[$g_iCurAccount] = ""
		$bUnderTime[$g_iCurAccount] = False
	EndIf

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec, $iDay

	If _DateIsValid($g_sAvailableAppBuilder) Then
		$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffAppBuilder > 0 Then

			$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			If $bUnderTime[$g_iCurAccount] = True Then
				SetLog("Current Updgrade Time Too Small", $COLOR_DEBUG1)
				SetLog("Next Check in " & $sWaitTime, $COLOR_ACTION)
			Else
				SetLog("Builder's Apprentice Unavailable", $COLOR_DEBUG1)
				SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)
			EndIf
			If Not $bToOpen Then CloseWindow()
			Return
		EndIf
	Else
		If Not _DateIsValid($g_sAvailableAppBuilder) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
			SetDebugLog("Builder's App LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
			Local $iDelayToCheck = Random(120, 240, 1)
			If $iLastCheck <= $iDelayToCheck Then
				If Not $bToOpen Then CloseWindow()
				Return
			EndIf
		EndIf
	EndIf

	If $bToOpen Then
		Local $bLocateHelperHut = False
		BuildingClick($g_aiHelperHutPos[0], $g_aiHelperHutPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return

		Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)

		If Not StringInStr($BuildingInfo[1], "Helper", $STR_NOCASESENSEBASIC) Then $bLocateHelperHut = True
		If $bLocateHelperHut Then
			SetLog("Helper Hut not Found", $COLOR_DEBUG1)
			SetLog("New Try...", $COLOR_DEBUG1)
			ClearScreen()
			If _Sleep(Random(1000, 1500, 1)) Then Return
			BuildingClick($g_aiHelperHutPos[0], $g_aiHelperHutPos[1])
			If _Sleep($DELAYBUILDINGINFO1) Then Return
			Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
			If Not StringInStr($BuildingInfo[1], "Helper", $STR_NOCASESENSEBASIC) Then
				SetLog("Helper Hut not Found", $COLOR_DEBUG1)
				ClearScreen()
				Return
			EndIf
		EndIf

		Local $BuildersApp = FindButton("BuildersApp")
		If IsArray($BuildersApp) And UBound($BuildersApp) = 2 Then
			Click($BuildersApp[0], 545 + $g_iBottomOffsetY)
			If _Sleep(Random(1500, 2000, 1)) Then Return
		Else
			ClearScreen()
			Return
		EndIf

		WaitForClanMessage("BuildersApprenticeTop")
		If Not QuickMIS("BC1", $g_sImgGeneralCloseButton, 770, 100, 845, 130 + $g_iMidOffsetY) Then
			SetLog("Builder's Apprentice Window Didn't Open", $COLOR_DEBUG1)
			CloseWindow2()
			If _Sleep(Random(1500, 2000, 1)) Then Return
			ClearScreen()
			Return
		EndIf
	Else
		Click(210, 530 + $g_iMidOffsetY)
		If _Sleep(1000) Then Return
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	WaitForClanMessage("BuildersApprenticeMid")
	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 730, 520 + $g_iMidOffsetY, 815, 560 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Builder's Apprentice is Locked", $COLOR_ERROR)
		CloseWindow()
		Return
	EndIf

	Local $bXMultiplier = Number(getOcrAndCapture("coc-uptime", 663, 176 + $g_iMidOffsetY, 37, 17, True))
	If $bXMultiplier = "" Or $bXMultiplier < 1 Or $bXMultiplier > 8 Then $bXMultiplier = 1 ; In Case
	SetLog("Builder's Apprentice is Level " & $bXMultiplier, $COLOR_INFO)

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniBuilderApp", $g_sImgMiniBuilderAppHead, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY, True)) ; Recurrence
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	If $g_bChkAppBuilder = 2 Then MoveToBottom()

	WaitForClanMessage("BuildersApprenticeMid")

	Local $GreenAssignButtons = QuickMIS("CNX", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY)
	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then
		If $g_bChkAppBuilder = 1 Then
			_ArraySort($GreenAssignButtons, 0, 0, 0, 2)
		Else
			_ArraySort($GreenAssignButtons, 1, 0, 0, 2)
		EndIf
		For $i = 0 To UBound($GreenAssignButtons) - 1
			Local $bRemainingUpTimeOCR = getOcrAndCapture("coc-BAUpgradeTime", $GreenAssignButtons[$i][1] - 166, $GreenAssignButtons[$i][2] - 4, 114, 16, True)
			Local $iRemainingTime = ConvertOCRTime("Upgrade Time", $bRemainingUpTimeOCR, False)
			SetDebugLog("Remaining Up OCR Time = " & $bRemainingUpTimeOCR & ", $iRemainingTime = " & $iRemainingTime & " m", $COLOR_INFO) ; 460
			Local $bBAGranted = False
			Switch $bXMultiplier
				Case 1 To 3
					If $iRemainingTime > $bXMultiplier * 60 Then $bBAGranted = True
				Case 4
					If $iRemainingTime > ($bXMultiplier - 1) * 60 Then $bBAGranted = True
				Case 5, 6
					If $iRemainingTime > ($bXMultiplier - 2) * 60 Then $bBAGranted = True
				Case 7, 8
					If $iRemainingTime > ($bXMultiplier - 3) * 60 Then $bBAGranted = True
			EndSwitch
			If $iRemainingTime = 0 Then $bBAGranted = True ; In Case
			If $bBAGranted Then
				If $iRemainingTime > 0 Then
					; Must be in ms !
					If $iRemainingTime > $bXMultiplier * 60 Then
						$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
					Else
						$iWaitTime = ($iRemainingTime / $bXMultiplier) * 60 * 1000
					EndIf
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
					If $iDay > 0 Then
						$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
					Else
						$iHour = Floor(Floor($iWaitSec / 60 / 60))
					EndIf
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iDay = 1 Then $sWaitTime &= $iDay & " day "
					If $iDay > 1 Then $sWaitTime &= $iDay & " days "
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					SetLog("Current Upgrade Will Finish in " & $sWaitTime, $COLOR_SUCCESS1)

				EndIf

				Click($GreenAssignButtons[$i][1], $GreenAssignButtons[$i][2]) ;Click Assign
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If $bUnderTime[$g_iCurAccount] = True Then $bUnderTime[$g_iCurAccount] = False
				ExitLoop
			Else
				If $iRemainingTime > 0 Then
					$iWaitTime = $iRemainingTime * 60 * 1000
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					Switch $bXMultiplier
						Case 1 To 3
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & $bXMultiplier & " Hour" & ($bXMultiplier > 1 ? "s)" : ")"), $COLOR_WARNING)
						Case 4
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 1) & " Hours)", $COLOR_WARNING)
						Case 5, 6
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 2) & " Hours)", $COLOR_WARNING)
						Case 7, 8
							SetLog("Current Upgrade Will Finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 3) & " Hours)", $COLOR_WARNING)
					EndSwitch

					If $g_bChkAppBuilder = 1 Or ($g_bChkAppBuilder = 2 And $i = UBound($GreenAssignButtons) - 1) Then
						Local $StartTime = _NowCalc() ; what is date:time now
						$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iRemainingTime), $StartTime)
						SetLog("Buider's App Next Check @ " & $g_sAvailableAppBuilder, $COLOR_DEBUG1)
						$bUnderTime[$g_iCurAccount] = True
					Else
						SetLog("Check Next Upgrade...", $COLOR_INFO)
						If _Sleep(1000) Then Return
						ContinueLoop
					EndIf
				Else
					$g_sAvailableAppBuilder = 0
					$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				EndIf
				CloseWindow()
				Return
			EndIf
		Next
	Else
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			If $iAppBuilderAvailTime > 60 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		Else
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			If $iAppBuilderAvailTime > 0 And $iAppBuilderAvailTime < 1380 Then SetLog("CoolDown Time", $COLOR_SUCCESS)
			If $iAppBuilderAvailTime > 1380 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		EndIf
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iAppBuilderAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			SetLog("Buider's App Available @ " & $g_sAvailableAppBuilder, $COLOR_DEBUG1)
			$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Builder's Apprentice Unavailable", $COLOR_DEBUG1)
				SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("No upgrade in progress", $COLOR_INFO)
		EndIf
		CloseWindow()
		Return
	EndIf

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 470 + $g_iMidOffsetY, 520, 530 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $iAppBuilderAvailTime = 0
		Local $CoordsX[2] = [390, 480]
		Local $CoordsY[2] = [480 + $g_iMidOffsetY, 520 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Builder's Apprentice Assigned", $COLOR_SUCCESS)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		WaitForClanMessage("BuildersApprenticeMid")
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			$iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			If $iAppBuilderAvailTime > 60 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
			$iAppBuilderAvailTime += 1320
			SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		EndIf
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			SetLog("Buider's App Available @ " & $g_sAvailableAppBuilder, $COLOR_DEBUG1)
			$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Builder's Apprentice Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("Error processing time read!", $COLOR_WARNING)
			$g_sAvailableAppBuilder = 0
			$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
		EndIf
	Else
		WaitForClanMessage("BuildersApprenticeConfirm")
		CloseWindow2(1) ; Close If a window is open
		If _Sleep(1000) Then Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	CloseWindow()
EndFunc   ;==>HelperHutApp

Func MoveToBottom()

	If Not QuickMIS("BC1", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 320 + $g_iMidOffsetY) Then Return

	Local $aiPassMini = False, $bFirstLoop = 0
	While 1
		If UBound(decodeSingleCoord(FindImageInPlace2("Assign", $ImgAssignMini, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))) = 2 Then
			$aiPassMini = True
			ExitLoop
		Else
			If UBound(decodeSingleCoord(FindImageInPlace2("OnGoing", $ImgOnGoingMini, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))) = 2 Then
				$aiPassMini = True
				ExitLoop
			Else
				If _Sleep(100) Then ExitLoop
			EndIf
		EndIf
		If $bFirstLoop = 20 Then ExitLoop
		$bFirstLoop += 1
	WEnd

	If $aiPassMini Then

		Local $aiWhitePixelSearchOutline = False, $bSecondLoop = 0
		While 1
			If IsArray(_PixelSearch(190, 482 + $g_iMidOffsetY, 194, 492 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
				$aiWhitePixelSearchOutline = True
				ExitLoop
			Else
				If _Sleep(100) Then ExitLoop
			EndIf
			If $bSecondLoop = 20 Then ExitLoop
			$bSecondLoop += 1
		WEnd

		If $aiWhitePixelSearchOutline Then

			Local $aiWhitePixelSearchArrow = False, $bThirdLoop = 0
			While 1
				If IsArray(_PixelSearch(610, 482 + $g_iMidOffsetY, 625, 498 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					$aiWhitePixelSearchArrow = True
					ExitLoop
				Else
					If _Sleep(100) Then ExitLoop
				EndIf
				If $bThirdLoop = 25 Then ExitLoop
				$bThirdLoop += 1
			WEnd

			If $aiWhitePixelSearchArrow Then

				ClickDrag(Random(500, 680, 1), Random(460, 480, 1), Random(500, 680, 1), Random(350, 370, 1), 200)
				If _Sleep(Random(2000, 2500, 1)) Then Return

				Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniBuilderApp", $g_sImgMiniBuilderAppHead, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY, True)) ; Recurrence
				If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
					ClickP($MiniHead)
					If _Sleep(1000) Then Return
					Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
					If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
						ClickP($aConfirmButton)
						If _Sleep(1000) Then Return
					Else
						Click(530, 415 + $g_iMidOffsetY)
						If _Sleep(1000) Then Return
					EndIf
				EndIf

			EndIf

		EndIf

	EndIf

EndFunc   ;==>MoveToBottom
