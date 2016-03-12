; #FUNCTION# ====================================================================================================================
; Name ..........: CheckTombs.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: barracoda/KnowJack (2015)
; Modified ......: sardo 2015-06 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckTombs()

	If $ichkTombstones <> 1 Then Return False

	Local $CleanTombs[3]
	$CleanTombs[0] = @ScriptDir & "\images\Resources\tomb.png"
	$CleanTombs[1] = @ScriptDir & "\images\Resources\tomb1.png"
	$CleanTombs[2] = @ScriptDir & "\images\Resources\tomb2.png"
	Local $aToleranceImgLoc = 0.92
	Local $CleanTombsX, $CleanTombsY

	For $i = 0 To 2
		_CaptureRegion2()
		If FileExists($CleanTombs[$i]) Then
			Local $res = DllCall($pImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $CleanTombs[$i], "float", $aToleranceImgLoc, "str", $ExtendedCocSearchArea, "str", $ExtendedCocDiamond)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetLog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
				If $res[0] = "0" Then
					; failed to find a tomb on the field
					If $i = 2 then SetLog("No Tombstone found, Yard is clean!", $COLOR_GREEN)
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					$expRet = StringSplit($res[0], "|", 2)
					For $j = 1 To UBound($expRet) - 1 Step 2
						$CleanTombsX = Int($expRet[$j])
						$CleanTombsY = Int($expRet[$j + 1])
						If $DebugSetLog = 1 Then SetLog("Tombs found (" & $CleanTombsX & "," & $CleanTombsY & ")", $COLOR_GREEN)
						If IsMainPage() Then Click($CleanTombsX, $CleanTombsY, 1, 0, "#0432")
						If _Sleep($iDelayCheckTombs2) Then Return
						ClickP($aAway, 2, 300, "#0329") ;Click Away
						SetLog("Tombstones Cleaned ... !", $COLOR_GREEN)
						ExitLoop (2)
					Next
				EndIf
			Else
				SetLog("No Tombstone found, Yard is clean!", $COLOR_GREEN)
				If _Sleep($iDelayCheckTombs1) Then Return
			EndIf
		EndIf
	Next

	checkMainScreen(False) ; check for screen errors while function was running

EndFunc   ;==>CheckTombs

Func CleanYard()

	If $ichkCleanYard = 0 Then Return

	$aGetBuilders = StringSplit(getBuilders($aBuildersDigits[0], $aBuildersDigits[1]), "#", $STR_NOCOUNT)
	If IsArray($aGetBuilders) Then
		$iFreeBuilderCount = $aGetBuilders[0]
		$TotalBuilders = $aGetBuilders[1]
	EndIf

	Local $CleanYard[7]
	$CleanYard[0] = @ScriptDir & "\images\Resources\bush.png"
	$CleanYard[1] = @ScriptDir & "\images\Resources\mushroom.png"
	$CleanYard[2] = @ScriptDir & "\images\Resources\tree.png"
	$CleanYard[3] = @ScriptDir & "\images\Resources\tree2.png"
	$CleanYard[4] = @ScriptDir & "\images\Resources\trunk.png"
	$CleanYard[5] = @ScriptDir & "\images\Resources\trunk2.png"
	$CleanYard[6] = @ScriptDir & "\images\Resources\gembox.png"

	Local $CleanYardX, $CleanYardY
	Local $aToleranceImgLoc[7] = [0.92, 0.91, 0.91, 0.90, 0.91, 0.93, 0.89]

	Local $aGetBuilders = ""
	Local $TotalBuilders = ""

	If $iFreeBuilderCount > 0 Then
		For $i = 0 To 6
			_CaptureRegion2()
			If FileExists($CleanYard[$i]) Then
				Local $res = DllCall($pImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $CleanYard[$i], "float", $aToleranceImgLoc[$i], "str", $ExtendedCocSearchArea, "str", $ExtendedCocDiamond)
				If @error Then _logErrorDLLCall($pImgLib, @error)
				If IsArray($res) Then
					If $DebugSetLog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
					If $res[0] = "0" Then
						; failed to find a loot cart on the field
						If $DebugSetLog = 1 Then SetLog("No Resource found")
					ElseIf $res[0] = "-1" Then
						SetLog("DLL Error", $COLOR_RED)
					ElseIf $res[0] = "-2" Then
						SetLog("Invalid Resolution", $COLOR_RED)
					Else
						$expRet = StringSplit($res[0], "|", 2)
						For $j = 1 To UBound($expRet) - 1 Step 2
							$CleanYardX = Int($expRet[$j])
							$CleanYardY = Int($expRet[$j + 1])
							If isInsideDiamondXY($CleanYardX, $CleanYardY) = True Then
							   If $DebugSetLog = 1 Then SetLog("Resource found (" & $CleanYardX & "," & $CleanYardY & ")", $COLOR_GREEN)
							   If IsMainPage() Then Click($CleanYardX, $CleanYardY, 1, 0, "#0430")
							   If _Sleep($iDelayCollect3) Then Return
							   If IsMainPage() Then Click($aCleanYard[0], $aCleanYard[1], 1, 0, "#0431") ;Click loot cart button
							   If _Sleep($iDelayCheckTombs2) Then Return
							   ClickP($aAway, 2, 300, "#0329") ;Click Away
							   If _Sleep($iDelayCheckTombs1) Then Return
							   $aGetBuilders = StringSplit(getBuilders($aBuildersDigits[0], $aBuildersDigits[1]), "#", $STR_NOCOUNT)
							   If IsArray($aGetBuilders) Then
								   $iFreeBuilderCount = $aGetBuilders[0]
								   $TotalBuilders = $aGetBuilders[1]
							   EndIf
							   If $iFreeBuilderCount = 0 Then
								   Setlog("No More Builders available")
								   If _Sleep(2000) Then Return
								   ExitLoop (2)
							   EndIf
						    EndIf
						Next
					EndIf
				EndIf
			EndIf
		Next
	EndIf

	UpdateStats()
	ClickP($aAway, 1, 300, "#0329") ;Click Away

EndFunc   ;==>CleanYard


