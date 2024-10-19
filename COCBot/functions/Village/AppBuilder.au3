; #FUNCTION# ====================================================================================================================
; Name ..........: AppBuilder.au3
; Description ...: This file controls the Builder's Apprentice Assignment
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Moebius14 (06/2024)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AppBuilder()

	If $g_bChkAppBuilder = 0 Then Return

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

	Local $bRet = False
	Local $bLocateTH = False
	BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return

	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)

	If $BuildingInfo[1] <> "Town Hall" Then $bLocateTH = True
	If $bLocateTH Then
		SetLog("Town Hall Windows Didn't Open", $COLOR_DEBUG1)
		SetLog("New Try...", $COLOR_DEBUG1)
		ClearScreen()
		If _Sleep(Random(1000, 1500, 1)) Then Return
		imglocTHSearch(False, True, True) ;Sets $g_iTownHallLevel
		If _Sleep(Random(1000, 1500, 1)) Then Return
		BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $BuildingInfo[1] <> "Town Hall" Then
			SetLog("Town Hall Windows Didn't Open", $COLOR_DEBUG1)
			Return
		EndIf
	EndIf

	Local $IsTHUpInProgress = False
	Local $THallUp = FindButton("FinishNow")
	If IsArray($THallUp) And UBound($THallUp) = 2 Then $IsTHUpInProgress = True

	Local $BuildersApp = FindButton("BuildersApp")
	If IsArray($BuildersApp) And UBound($BuildersApp) = 2 Then
		Click($BuildersApp[0], 545 + $g_iBottomOffsetY)
		If _Sleep(Random(1500, 2000, 1)) Then Return
		If $IsTHUpInProgress Then
			WaitForClanMessage("BuildersApprenticeConfirm")
			If QuickMIS("BC1", $g_sImgGeneralCloseButton, 655, 150 + $g_iMidOffsetY, 720, 200 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(Random(1500, 2000, 1)) Then Return
			EndIf
		EndIf
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
	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 160, 155 + $g_iMidOffsetY, 270, 195 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Builder's Apprentice is Locked", $COLOR_ERROR)
		CloseWindow()
		Return
	EndIf

	Local $bXMultiplier = Number(getOcrAndCapture("coc-uptime", 663, 176 + $g_iMidOffsetY, 37, 17, True))
	If $bXMultiplier = "" Or $bXMultiplier < 1 Or $bXMultiplier > 8 Then $bXMultiplier = 1 ; In Case
	SetLog("Builder's Apprentice is Level " & $bXMultiplier, $COLOR_INFO)

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
			Local $bRemainingUpTimeOCR = getOcrAndCapture("coc-BAUpgradeTime", $GreenAssignButtons[$i][1] - 166, $GreenAssignButtons[$i][2] - 3, 114, 16, True)
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
					If $bXMultiplier < 4 Then
						$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
					Else
						If $iRemainingTime > $bXMultiplier Then
							$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
						Else
							$iWaitTime = ($iRemainingTime / $bXMultiplier) * 60 * 1000
						EndIf
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
			Local $Result = StringReplace(getOcrAndCapture("coc-BuildersApptime", 212, 167 + $g_iMidOffsetY, 75, 15, True), "b", "")
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
			Local $Result = StringReplace(getOcrAndCapture("coc-BuildersApptime", 222, 167 + $g_iMidOffsetY, 75, 15, True), "b", "")
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

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 445 + $g_iMidOffsetY, 520, 520 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $iAppBuilderAvailTime = 0
		Local $CoordsX[2] = [390, 480]
		Local $CoordsY[2] = [460 + $g_iMidOffsetY, 500 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Builder's Apprentice Assigned", $COLOR_SUCCESS)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		WaitForClanMessage("BuildersApprenticeMid")
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = StringReplace(getOcrAndCapture("coc-BuildersApptime", 212, 167 + $g_iMidOffsetY, 75, 15, True), "b", "")
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

Func MoveToBottom()
	Local $aiAssignMini = decodeSingleCoord(FindImageInPlace2("Assign", $ImgAssignMini, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
	If IsArray($aiAssignMini) And UBound($aiAssignMini) = 2 Then
		If IsArray(_PixelSearch(610, 482 + $g_iMidOffsetY, 625, 498 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
			ClickDrag(Random(500, 680, 1), Random(460, 480, 1), Random(500, 680, 1), Random(350, 370, 1), 200)
			If _Sleep(Random(2000, 2500, 1)) Then Return
		EndIf
	EndIf
EndFunc   ;==>MoveToBottom
