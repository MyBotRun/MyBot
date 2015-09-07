; #FUNCTION# ====================================================================================================================
; Name ..........: CheckTombs.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........:
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func CheckTombs()

	Local $TombX, $TombY
	If $ichkTombstones <> 1 Then Return False
	$tomb = @ScriptDir & "\images\tomb.png"
	If Not FileExists($tomb) Then Return False
	$TombLoc = 0
	$TombClicked = 0

	SetLog("Clear Tombs", $COLOR_BLUE)

	_CaptureRegion()

	$sendHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
	$res = DllCall($LibDir & "\ImageSearch.dll", "str", "searchInCoCD", "handle", $sendHBitmap, "str", $tomb, "float", 0.940)
	_WinAPI_DeleteObject($sendHBitmap)


	If IsArray($res) Then
		;SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
		If $res[0] = "0" Then
				; failed to find any obstacles to clear on the field
				SetLog("No tombs found", $COLOR_RED)
		ElseIf $res[0] = "-1" Then
				SetLog("DLL Error", $COLOR_RED)
		ElseIf $res[0] = "-2" Then
				SetLog("Invalid Resolution", $COLOR_RED)
		Else
			$expRet = StringSplit($res[0], "|", 2)
			For $j = 1 To UBound($expRet) - 1 Step 2
				$TombX = Int($expRet[$j])
				$TombY = Int($expRet[$j + 1])
				If isInsideDiamondXY($TombX, $TombY) Then
					;SetLog("Tombstone found (" & $TombX & "," & $TombY &")", $COLOR_GREEN)
					Click($TombX, $TombY,1,0,"#0120")
					If _Sleep($iDelayCheckTombs2) Then Return
					ClickP($aAway,1,0,"#0121") ; click away
					If _Sleep($iDelayCheckTombs1) Then Return
					$TombClicked += 1
						If($TombClicked > 2) Then
							Return True
						EndIf
				EndIf
			Next
		EndIf
	Else
		SetLog("DLL Error", $COLOR_RED)
		return
	EndIf

EndFunc   ;==>CheckTombs
