; #FUNCTION# ====================================================================================================================
; Name ..........: GetLocationMine
; Description ...:
; Syntax ........: GetLocationMine()
; Parameters ....:
; Return values .: String with locations
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetLocationMine()
	If $iDetectedImageType = 0 Then
		Local $result = DllCall($hFuncLib, "str", "getLocationMineExtractor", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationMine: " & $result[0], $COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowMineExtractor", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationSnowMine: " & $result[0], $COLOR_TEAL)
	EndIf
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationMine

Func GetLocationElixir()
	If $iDetectedImageType = 0 Then
		Local $result = DllCall($hFuncLib, "str", "getLocationElixirExtractor", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationElixir: " & $result[0], $COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowElixirExtractor", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationSnowElixir: " & $result[0], $COLOR_TEAL)
	EndIf
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationElixir

Func GetLocationDarkElixir()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirExtractor", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixir: " & $result[0], $COLOR_TEAL)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationDarkElixir

Func GetLocationTownHall()
	Local $result = DllCall($hFuncLib, "str", "getLocationTownHall", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationTownHall: " & $result[0], $COLOR_TEAL)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationTownHall

Func GetLocationDarkElixirStorageWithLevel()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirStorageWithLevel", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorageWithLevel: " & $result[0], $COLOR_TEAL)
	Return $result[0]
EndFunc   ;==>GetLocationDarkElixirStorageWithLevel

Func GetLocationDarkElixirStorage()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirStorage", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorage: " & $result[0], $COLOR_TEAL)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationDarkElixirStorage

Func GetLocationElixirWithLevel()
	;NOTE AROUND RETURNED LEVEL:
	; LEV 0 elixir extractors from level 1 to level 4
	; LEV 1 elixir extractors level 5
	; LEV 2 elixir extractors level 6
	; LEV 3 elixir extractors level 7
	; LEV 4 elixir extractors level 8
	; LEV 5 elixir extractors level 9
	; LEV 6 elixir extractors level 10
	; LEV 7 elixir extractors level 11
	; LEV 8 elixir extractors level 12

	If $iDetectedImageType = 0 Then
		Local $result = DllCall($hFuncLib, "str", "getLocationElixirExtractorWithLevel", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# getLocationElixirExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowElixirExtractorWithLevel", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# getLocationSnowElixirExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	EndIf
	Return $result[0]
EndFunc   ;==>GetLocationElixirWithLevel


Func GetLocationMineWithLevel()
	;NOTE AROUND RETURNED LEVEL:
	; LEV 0 gold mine from level 1 to level 4
	; LEV 1 gold mine level 5
	; LEV 2 gold mine level 6
	; LEV 3 gold mine level 7
	; LEV 4 gold mine level 8
	; LEV 5 gold mine level 9
	; LEV 6 gold mine level 10
	; LEV 7 gold mine level 11
	; LEV 8 gold mine level 12

	If $iDetectedImageType = 0 Then
		Local $result = DllCall($hFuncLib, "str", "getLocationMineExtractorWithLevel", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# getLocationMineExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowMineExtractorWithLevel", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# getLocationSnowMineExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	EndIf
	Return $result[0]
EndFunc   ;==>GetLocationMineWithLevel

Func GetLocationDarkElixirWithLevel()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirExtractorWithLevel", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then Setlog("#*# getLocationDarkElixirExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	Return $result[0]
EndFunc   ;==>GetLocationDarkElixirWithLevel

Func GetLocationGoldStorage()

	Local $hTimer = TimerInit()
	Local $LocationGoldStorage[6]
	$LocationGoldStorage[0] = @ScriptDir & "\images\Storages\Gold\Lv10_f.png"
	$LocationGoldStorage[1] = @ScriptDir & "\images\Storages\Gold\Lv10_h.png"
	$LocationGoldStorage[2] = @ScriptDir & "\images\Storages\Gold\Lv11_f.png"
	$LocationGoldStorage[3] = @ScriptDir & "\images\Storages\Gold\Lv11_h.png"
	$LocationGoldStorage[4] = @ScriptDir & "\images\Storages\Gold\Lv12_f.png"
	$LocationGoldStorage[5] = @ScriptDir & "\images\Storages\Gold\Lv12_h.png"
	Local $aToleranceImgLoc[6] = [0.90, 0.90, 0.92, 0.92, 0.91, 0.91]
	Local $LocationGoldStorageX, $LocationGoldStorageY
	Local $TempVectStr
	Local $TotalStorages = 0
	If $DebugSetLog = 1 Then SetLog("Started the function | GetLocationGoldStorage")

	_CaptureRegion2()
	For $i = 0 To 5
		If FileExists($LocationGoldStorage[$i]) Then
			Local $res = DllCall($pImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $LocationGoldStorage[$i], "float", $aToleranceImgLoc[$i], "str", $DefaultCocSearchArea, "str", $DefaultCocDiamond)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetLog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
				If $res[0] = "0" Then
					; failed to find a Gold Storage on the field
					If $DebugSetLog = 1 Then SetLog("No Gold Storages found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					If $DebugSetLog = 1 Then SetLog("Gold Storages|String Returned|ImgLoc: " & $res[0], $COLOR_RED)
					$expRet = StringSplit($res[0], "|", 2)
					For $j = 1 To UBound($expRet) - 1 Step 2
						$LocationGoldStorageX = Int($expRet[$j])
						$LocationGoldStorageY = Int($expRet[$j + 1])
						If $DebugSetLog = 1 Then SetLog("Storage n :" & $TotalStorages & " (" & $LocationGoldStorageX & "/" & $LocationGoldStorageY & ")")
						$TempVectStr &= $LocationGoldStorageX & "-" & $LocationGoldStorageY & "|"
						$TotalStorages += 1
						If $TotalStorages = 4 Then ExitLoop (2)
					Next
				EndIf
			EndIf
		Else
			If $DebugSetLog = 1 Then SetLog("File not Exist ", $COLOR_RED)
		EndIf
	Next

	If $DebugSetLog = 1 Then SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)

	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		Local $InputVect = GetListPixel($TempVectStr)
		SetLog("Total Gold Storages :" & $TotalStorages)
		Return $InputVect
	Else
		Return 0
	EndIf

EndFunc   ;==>GetLocationGoldStorage

Func GetLocationElixirStorage()

	Local $hTimer = TimerInit()
	Local $LocationElixirStorag[6]
	$LocationElixirStorag[0] = @ScriptDir & "\images\Storages\Elixir\Lv10_f.png"
	$LocationElixirStorag[1] = @ScriptDir & "\images\Storages\Elixir\Lv10_h.png"
	$LocationElixirStorag[2] = @ScriptDir & "\images\Storages\Elixir\Lv11_f.png"
	$LocationElixirStorag[3] = @ScriptDir & "\images\Storages\Elixir\Lv11_h.png"
	$LocationElixirStorag[4] = @ScriptDir & "\images\Storages\Elixir\Lv12_f.png"
	$LocationElixirStorag[5] = @ScriptDir & "\images\Storages\Elixir\Lv12_h.png"
	Local $aToleranceImgLoc[6] = [0.90, 0.90, 0.92, 0.92, 0.91, 0.91]
	Local $LocationElixirStoragX, $LocationElixirStoragY
	Local $TempVectStr
	Local $TotalStorages = 0
	If $DebugSetLog = 1 Then SetLog("Started the function | GetLocationElixirStorage")

	_CaptureRegion2()
	For $i = 0 To 5
		If FileExists($LocationElixirStorag[$i]) Then
			Local $res = DllCall($pImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $LocationElixirStorag[$i], "float", $aToleranceImgLoc[$i], "str", $DefaultCocSearchArea, "str", $DefaultCocDiamond)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetLog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
				If $res[0] = "0" Then
					; failed to find a Gold Storage on the field
					If $DebugSetLog = 1 Then SetLog("No Elixir Storages found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					If $DebugSetLog = 1 Then SetLog("Elixir Storages|String Returned|ImgLoc: " & $res[0], $COLOR_RED)
					$expRet = StringSplit($res[0], "|", 2)
					For $j = 1 To UBound($expRet) - 1 Step 2
						$LocationElixirStoragX = Int($expRet[$j])
						$LocationElixirStoragY = Int($expRet[$j + 1])
						If $DebugSetLog = 1 Then SetLog("Storage n :" & $TotalStorages & " (" & $LocationElixirStoragX & "/" & $LocationElixirStoragY & ")")
						$TempVectStr &= $LocationElixirStoragX & "-" & $LocationElixirStoragY & "|"
						$TotalStorages += 1
						If $TotalStorages = 4 Then ExitLoop (2)
					Next
				EndIf
			EndIf
		Else
			If $DebugSetLog = 1 Then SetLog("File not Exist ", $COLOR_RED)
		EndIf
	Next
	If $DebugSetLog = 1 Then SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)

	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		Local $InputVect = GetListPixel($TempVectStr)
		SetLog("Total Elixirr Storages :" & $TotalStorages)
		Return $InputVect
	Else
		Return 0
	EndIf

EndFunc   ;==>GetLocationElixirStorage
