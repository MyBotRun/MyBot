
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCapacity
; Description ...: Obtains current and total capacity of troops from Training - Army Overview window
; Syntax ........: getArmyCapacity([$bOpenArmyWindow = False[, $bCloseArmyWindow = False]])
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getArmyCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SETLOG("Begin getArmyCapacity:", $COLOR_DEBUG1)

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	Local $aGetArmySize[3] = ["", "", ""]
	Local $sArmyInfo = ""
	Local $sInputbox, $iTried, $iHoldCamp
	Local $tmpTotalCamp = 0
	Local $tmpCurCamp = 0

	; Verify troop current and full capacity
	$iTried = 0 ; reset loop safety exit counter
	$sArmyInfo = getArmyCampCap($aArmyCampSize[0], $aArmyCampSize[1]) ; OCR read army trained and total
	If $g_iDebugSetlogTrain = 1 Then Setlog("OCR $sArmyInfo = " & $sArmyInfo, $COLOR_DEBUG)

	While $iTried < 100 ; 30 - 40 sec

		$iTried += 1
		If _Sleep($iDelaycheckArmyCamp5) Then Return ; Wait 250ms before reading again
	    ForceCaptureRegion()
		$sArmyInfo = getArmyCampCap($aArmyCampSize[0], $aArmyCampSize[1]) ; OCR read army trained and total
		If $g_iDebugSetlogTrain = 1 Then Setlog("OCR $sArmyInfo = " & $sArmyInfo, $COLOR_DEBUG)
		If StringInStr($sArmyInfo, "#", 0, 1) < 2 Then ContinueLoop ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid

		$aGetArmySize = StringSplit($sArmyInfo, "#") ; split the trained troop number from the total troop number
		If IsArray($aGetArmySize) Then
			If $aGetArmySize[0] > 1 Then ; check if the OCR was valid and returned both values
				If Number($aGetArmySize[2]) < 10 Or Mod(Number($aGetArmySize[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $g_iDebugSetlogTrain = 1 Then Setlog(" OCR value is not valid camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$tmpCurCamp = Number($aGetArmySize[1])
				If $g_iDebugSetlogTrain = 1 Then Setlog("$tmpCurCamp = " & $tmpCurCamp, $COLOR_DEBUG)
				$tmpTotalCamp = Number($aGetArmySize[2])
				If $g_iDebugSetlogTrain = 1 Then Setlog("$TotalCamp = " & $TotalCamp & ", Camp OCR = " & $tmpTotalCamp, $COLOR_DEBUG)
				If $iHoldCamp = $tmpTotalCamp Then ExitLoop ; check to make sure the OCR read value is same in 2 reads before exit
				$iHoldCamp = $tmpTotalCamp ; Store last OCR read value
			EndIf
		EndIf

	WEnd

	If $iTried <= 99 Then
		$CurCamp = $tmpCurCamp
		If $TotalCamp = 0 Then $TotalCamp = $tmpTotalCamp
		If $g_iDebugSetlogTrain = 1 Then Setlog("$CurCamp = " & $CurCamp & ", $TotalCamp = " & $TotalCamp, $COLOR_DEBUG)
	Else
		Setlog("Army size read error, Troop numbers may not train correctly", $COLOR_ERROR) ; log if there is read error
		$CurCamp = 0
		CheckOverviewFullArmy()
	EndIf

	If $TotalCamp = 0 Or ($TotalCamp <> $tmpTotalCamp) Then ; if Total camp size is still not set or value not same as read use forced value
		If $g_bTotalCampForced = False Then ; check if forced camp size set in expert tab
		    Local $proposedTotalCamp = $tmpTotalCamp
			If $TotalCamp > $tmpTotalCamp Then $proposedTotalCamp = $TotalCamp
			$sInputbox = InputBox("Question", _
								  "Enter your total Army Camp capacity." & @CRLF & @CRLF & _
								  "Please check it matches with total Army Camp capacity" & @CRLF & _
								  "you see in Army Overview right now in Android Window:" & @CRLF & _
								  $Title & @CRLF & @CRLF & _
								  "(This window closes in 2 Minutes with value of " & $proposedTotalCamp & ")", $proposedTotalCamp, "", 330, 220, Default, Default, 120, $g_hFrmBot)
			Local $error = @error
			If $error = 1 Then
			   Setlog("Army Camp User input cancelled, still using " & $TotalCamp, $COLOR_ACTION)
			Else
			   If $error = 2 Then
				  ; Cancelled, using proposed value
				  $TotalCamp = $proposedTotalCamp
			   Else
				  $TotalCamp = Number($sInputbox)
			   EndIf
			   If $error = 0 Then
				  $g_iTotalCampForcedValue = $TotalCamp
				  $g_bTotalCampForced = True
				  Setlog("Army Camp User input = " & $TotalCamp, $COLOR_INFO)
			   Else
				  ; timeout
				  Setlog("Army Camp proposed value = " & $TotalCamp, $COLOR_ACTION)
			   EndIf
			EndIF
		Else
			$TotalCamp = Number($g_iTotalCampForcedValue)
		EndIf
	EndIf
	If _Sleep($iDelaycheckArmyCamp4) Then Return

	If $g_bTotalCampForced = True Then $TotalCamp = Number($g_iTotalCampForcedValue)

	If $TotalCamp > 0 Then
		SetLog("Total Army Camp capacity: " & $CurCamp & "/" & $TotalCamp & " (" & Int($CurCamp / $TotalCamp * 100) & "%)")
		$ArmyCapacity = Int($CurCamp / $TotalCamp * 100)
	Else
		SetLog("Total Army Camp capacity: " & $CurCamp & "/" & $TotalCamp)
		$ArmyCapacity = 0
	EndIf

	If ($CurCamp >= ($TotalCamp * $g_iTrainArmyFullTroopPct / 100)) Then
		$fullArmy = True
	Else
		$fullArmy = False
	EndIf

	If $CurCamp >= $TotalCamp * $g_aiSearchCampsPct[$DB] / 100 And $g_abSearchCampsEnable[$DB] And IsSearchModeActive($DB) Then $fullArmy = True
	If $CurCamp >= $TotalCamp * $g_aiSearchCampsPct[$LB] / 100 And $g_abSearchCampsEnable[$LB] And IsSearchModeActive($LB) Then $fullArmy = True
	If $CurCamp >= $TotalCamp * $g_aiSearchCampsPct[$TS] / 100 And $g_abSearchCampsEnable[$TS] And IsSearchModeActive($TS) Then $fullArmy = True

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmyCapacity

