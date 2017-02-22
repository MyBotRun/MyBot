; #FUNCTION# ====================================================================================================================
; Name ..........: ReArm.au3
; Description ...: Rearms and reloads traps that have been triggered.
; Syntax ........: ReArm()
; Parameters ....:
; Return values .:
; Authors .......: Saviart, Hervidero
; Modified ......: Hervidero, ProMac, KnowJack (May/July-2015) added check for loot available to prevent spending gems. changed screen capture to pixel capture.
;                  Sardo 2015-08 , ProMac (01-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ReArm()

	If $g_bChkTrap = False Then Return ; If re-arm is not enable in GUI return and skip this code
	;If $iShouldRearm = False Then Return
	If $NotNeedAllTime[0] = 0 Then Return
	;$iShouldRearm = False
	;	Local $y = 562 + $g_iBottomOffsetY ; Add 60 y pixel for 860x780 window

	SetLog("Checking if Village needs Rearming..", $COLOR_INFO)

	;- Variables to use with ImgLoc -
	; --- ReArm Buttons Detection ---
	Local $ImagesToUse[3]
	$ImagesToUse[0] = @ScriptDir & "\imgxml\rearm\Traps_0_90.xml"
	$ImagesToUse[1] = @ScriptDir & "\imgxml\rearm\Xbow_0_90.xml"
	$ImagesToUse[2] = @ScriptDir & "\imgxml\rearm\Inferno_0_90.xml"
	$ToleranceImgLoc = 0.90
	Local $locate = 0
	Local $t = 0
	;--- End -----

	;- Verifying The TH Coordinates -
	If isInsideDiamond($TownHallPos) = False Then
		LocateTownHall(True) ; get only new TH location during rearm, due BotFirstDetect now must have TH or there is an error.
		SaveConfig()
		If _Sleep($iDelayReArm3) Then Return
	EndIf
	; --- End ---

	ClickP($aAway, 1, 0, "#0224") ; Click away
	If _Sleep($iDelayReArm4) Then Return
	If IsMainPage() Then BuildingClickP($TownHallPos, "#0225")

	If _Sleep($iDelayReArm2) Then Return

	If Number($iTownHallLevel) > 8 Then $t = 1
	If Number($iTownHallLevel) > 9 Then $t = 2

	For $i = 0 To $t
		If FileExists($ImagesToUse[$i]) Then
			_CaptureRegion2(125, 610, 740, 715)
			;Full Search in ALL Image (FV for cocDiamond) and return only fisrt match (maxObjects=1)
			Local $res = DllCall($g_hLibImgLoc, "str", "FindTile", "handle", $hHBitmap2, "str", $ImagesToUse[$i], "str", "FV", "int", 1)
			If @error Then _logErrorDLLCall($g_sLibImgLocPath, @error)
			If IsArray($res) Then
				If $g_iDebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
				If $res[0] = "0" Or $res[0] = "" Then
					If $g_iDebugSetlog = 1 Then SetLog("No Button found")
				ElseIf StringLeft($res[0], 2) = "-1" Then
					SetLog("DLL Error: " & $res[0], $COLOR_ERROR)
				Else
					Local $expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
					Local $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
					Local $ButtonX = 125 + Int($posPoint[0])
					Local $ButtonY = 610 + Int($posPoint[1])
					If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
					If _Sleep($iDelayReArm1) Then Return
					Click(515, 400, 1, 0, "#0226")
					If _Sleep($iDelayReArm4) Then Return
					If isGemOpen(True) = True Then
						Setlog("Not enough loot to rearm traps.....", $COLOR_ERROR)
						Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
						If _Sleep($iDelayReArm1) Then Return
					Else
						Switch $i
							Case 0
								SetLog("Rearmed Trap(s)", $COLOR_SUCCESS)
								$NotNeedAllTime[0] = 0
							Case 1
								SetLog("Reloaded XBow(s)", $COLOR_SUCCESS)
								$NotNeedAllTime[0] = 0
							Case 2
								SetLog("Reloaded Inferno(s)", $COLOR_SUCCESS)
								$NotNeedAllTime[0] = 0
						EndSwitch
						$locate = 1
						If _Sleep($iDelayReArm1) Then Return
					EndIf
				EndIf
			EndIf
		EndIf
	Next

	If $locate = 0 Then
		SetLog("Rearm not needed!", $COLOR_SUCCESS)
		$NotNeedAllTime[0] = 0
	EndIf
	ClickP($aAway, 1, 0, "#0234") ; Click away
	If _Sleep($iDelayReArm2) Then Return
	checkMainScreen(False) ; check for screen errors while running function

EndFunc   ;==>ReArm
