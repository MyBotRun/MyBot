; #FUNCTION# ====================================================================================================================
; Name ..........: ReArm.au3
; Description ...: Rearms and reloads traps that have been triggered.
; Syntax ........: ReArm()
; Parameters ....:
; Return values .:
; Authors .......: Saviart, Hervidero
; Modified ......: Hervidero, ProMac, KnowJack (May/July-2015) added check for loot available to prevent spending gems. changed screen capture to pixel capture.
;                  Sardo 2015-08 , ProMac (01-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ReArm()

	If $ichkTrap = 0 Then Return ; If Re-Arm is not enable in GUI return and skip this code
	SetLog("Checking if Village needs Rearming..", $COLOR_BLUE)

	;- Variables to use with ImgLoc -
	; --- ReArm Buttons Detection ---
	Local $ImagesToUse[3]
	$ImagesToUse[0] = @ScriptDir & "\images\Button\Traps.png"
	$ImagesToUse[1] = @ScriptDir & "\images\Button\Xbow.png"
	$ImagesToUse[2] = @ScriptDir & "\images\Button\Inferno.png"
	$ToleranceImgLoc = 0.900
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
	If IsMainPage() Then Click($TownHallPos[0], $TownHallPos[1] + 5, 1, 0, "#0225")

	If _Sleep($iDelayReArm2) Then Return

	If Number($iTownHallLevel) > 8 Then $t = 1
	If Number($iTownHallLevel) > 9 Then $t = 2

	For $i = 0 To $t
		If FileExists($ImagesToUse[$i]) Then
			_CaptureRegion2(125, 610, 740, 715)
			$res = DllCall($pImgLib, "str", "MBRSearchImage", "handle", $hHBitmap2, "str", $ImagesToUse[$i], "float", $ToleranceImgLoc)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					If $DebugSetlog Then SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					$expRet = StringSplit($res[0], "|", 2)
					$ButtonX = 125 + Int($expRet[1])
					$ButtonY = 610 + Int($expRet[2])
					If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
					If _Sleep($iDelayReArm1) Then Return
					Click(515, 400, 1, 0, "#0226")
					If _Sleep($iDelayReArm4) Then Return
					If isGemOpen(True) = True Then
						Setlog("Not enough loot to rearm traps.....", $COLOR_RED)
						Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
						If _Sleep($iDelayReArm1) Then Return
					Else
						If $i = 0 Then SetLog("Rearmed Trap(s)", $COLOR_GREEN)
						If $i = 1 Then SetLog("Reloaded XBow(s)", $COLOR_GREEN)
						If $i = 2 Then SetLog("Reloaded Inferno(s)", $COLOR_GREEN)
						If _Sleep($iDelayReArm1) Then Return
					EndIf
				EndIf
			EndIf
		EndIf
	Next

	ClickP($aAway, 1, 0, "#0234") ; Click away
	If _Sleep($iDelayReArm2) Then Return
	checkMainScreen(False) ; check for screen errors while running function

EndFunc   ;==>ReArm
