; #FUNCTION# ====================================================================================================================
; Name ..........: collectAchievements
; Description ...: Collect Achievement rewards
; Syntax ........: collectAchievements()
; Parameters ....:
; Return values .: None
; Author ........: Nytol (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_iCollectAchievementsLoopCount = 0
Global $g_iCollectAchievementsRunOn = 0
Global $g_iFoundScrollEnd = 0

Func CollectAchievements($bTestMode = False) ;Run with True parameter if testing to run regardless of checkbox setting, randomization skips and runstate check

	If Not $bTestMode Then
		If Not $g_bChkCollectAchievements Or Not $g_bRunState Then Return
		If Not CollectAchievementsRandomization() Then Return
	EndIf

	ClearScreen()
	If Not IsMainPage() Then Return

	SetLog("Begin collecting achievement rewards", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	;Check if possible rewards available from main screen
	Local $aImgAchievementsMainScreen = decodeSingleCoord(findImage("AchievementsMainScreen", $g_sImgAchievementsMainScreen, GetDiamondFromRect("5,2,70,60"), 1, True))
	If UBound($aImgAchievementsMainScreen) > 1 Then
		SetDebugLog("Achievement counter found on main screen", $COLOR_SUCCESS)
		Click($aImgAchievementsMainScreen[0] - 10, $aImgAchievementsMainScreen[1] + 20)
		If _Sleep(1500) Then Return
	Else
		SetLog("No achievement rewards to collect", $COLOR_INFO)
		SetDebugLog("Achievement counter not found on main screen", $COLOR_ERROR)
		Return
	EndIf

	;Check MyProfile window Opened correctly
	If Not $g_bRunState Then Return
	Local $aImgAchievementsMyProfile = decodeSingleCoord(findImage("MyProfile", $g_sImgAchievementsMyProfile, GetDiamondFromRect("100,55,275,110"), 1, True))
	If UBound($aImgAchievementsMainScreen) > 1 Then
		SetDebugLog("My Profile window opened successfully", $COLOR_SUCCESS)
		If _Sleep(1500) Then Return
	Else
		SetDebugLog("My Profile window failed to open", $COLOR_ERROR)
		ClickAway("Right")
		If _Sleep(1000) Then Return
	EndIf

	If Not CollectAchievementsClaimReward() Then
		SetDebugLog("There are no achievement rewards to collect", $COLOR_INFO)
		If _Sleep(1000) Then Return
		CloseWindow2()
		Return
	EndIf

	If _Sleep(1000) Then Return
	SetDebugLog("All achievment rewards collected successfully", $COLOR_SUCCESS)
	CloseWindow2()
	Return
EndFunc   ;==>CollectAchievements


Func CollectAchievementsRandomization() ; Add some randomization to avoid running the check every loop if a friend request exists

	If $g_iCollectAchievementsRunOn = 0 Then ; Run on first loop
		SetDebugLog("First Run so set randomization parameters and collect", $COLOR_INFO)
		$g_iCollectAchievementsRunOn = Random(2, 5, 1)
		$g_iCollectAchievementsLoopCount = $g_iCollectAchievementsLoopCount + 1
		Return True
	ElseIf $g_iCollectAchievementsLoopCount = $g_iCollectAchievementsRunOn Then ; Run if loop count matches random value
		SetDebugLog("Loop count matches, lets collect!", $COLOR_SUCCESS)
		Return True
	Else ; Return false in none of the above conditions match
		SetDebugLog("Skipping collection for randomization.", $COLOR_INFO)
		SetDebugLog("Collection will happen in '" & $g_iCollectAchievementsRunOn - $g_iCollectAchievementsLoopCount & "' more loops", $COLOR_INFO)
		$g_iCollectAchievementsLoopCount = $g_iCollectAchievementsLoopCount + 1
		Return False
	EndIf
EndFunc   ;==>CollectAchievementsRandomization

Func CollectAchievementsClaimReward()
	;Check Profile for Achievements and collect
	If Not $g_bRunState Then Return

	Local $sSearchArea = GetDiamondFromRect2(660, 130 + $g_iMidOffsetY, 845, 645 + $g_iMidOffsetY)
	Local $aClaimButtons = findMultiple($g_sImgAchievementsClaimReward, $sSearchArea, $sSearchArea, 0, 1000, 0, "objectname,objectpoints", True)
	If IsArray($aClaimButtons) And UBound($aClaimButtons) > 0 Then
		For $i = 0 To UBound($aClaimButtons) - 1
			Local $aTemp = $aClaimButtons[$i]
			Local $aClaimButtonXY = decodeMultipleCoords($aTemp[1])
			For $i = 0 To UBound($aClaimButtonXY) - 1
				Local $aTemp = $aClaimButtonXY[$i]
				Click($aTemp[0], $aTemp[1])
				SetLog("Achievement reward collected", $COLOR_SUCCESS)
				If _Sleep(1500) Then Return
			Next
		Next
		Return True
	Else
		SetLog("No achievement rewards to collect", $COLOR_INFO)
		Return False
	EndIf
EndFunc   ;==>CollectAchievementsClaimReward

