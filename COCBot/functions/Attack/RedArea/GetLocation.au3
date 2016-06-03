; #FUNCTION# ====================================================================================================================
; Name ..........: GetLocationMine
; Description ...:
; Syntax ........: GetLocationMine()
; Parameters ....:
; Return values .: String with locations
; Author ........:
; Modified ......: ProMac (04-2016)
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
		if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"Mine")
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowMineExtractor", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationSnowMine: " & $result[0], $COLOR_TEAL)
		if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"SnowMine")
	EndIf
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationMine

Func GetLocationElixir()
	If $iDetectedImageType = 0 Then
		Local $result = DllCall($hFuncLib, "str", "getLocationElixirExtractor", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationElixir: " & $result[0], $COLOR_TEAL)
		if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"Elixir")
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowElixirExtractor", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationSnowElixir: " & $result[0], $COLOR_TEAL)
		if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"SnowElixir")
	EndIf
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationElixir

Func GetLocationDarkElixir()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirExtractor", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then
		Setlog("#*# GetLocationDarkElixir: " & $result[0], $COLOR_TEAL)
		if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"DarkElixir")
	EndIf
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationDarkElixir

Func GetLocationTownHall()
	Local $result = DllCall($hFuncLib, "str", "getLocationTownHall", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationTownHall: " & $result[0], $COLOR_TEAL)
	if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"TownHall")
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationTownHall

Func GetLocationDarkElixirStorageWithLevel()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirStorageWithLevel", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorageWithLevel: " & $result[0], $COLOR_TEAL)
	if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"DarkElixirStorageWithLevel")
	Return $result[0]
EndFunc   ;==>GetLocationDarkElixirStorageWithLevel

Func GetLocationDarkElixirStorage()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirStorage", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorage: " & $result[0], $COLOR_TEAL)
	if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"DarkElixirStorage")
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
		if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"ElixirExtractorWithLevel")
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowElixirExtractorWithLevel", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# getLocationSnowElixirExtractorWithLevel: " & $result[0], $COLOR_TEAL)
		if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"SnowElixirExtractorWithLevel")
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
		if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"MineExtractorWithLevel")

	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowMineExtractorWithLevel", "ptr", $hHBitmap2)
		If $debugBuildingPos = 1 Then Setlog("#*# getLocationSnowMineExtractorWithLevel: " & $result[0], $COLOR_TEAL)
		if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"SnowMineExtractorWithLevel")
	EndIf
	Return $result[0]
EndFunc   ;==>GetLocationMineWithLevel

Func GetLocationDarkElixirWithLevel()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirExtractorWithLevel", "ptr", $hHBitmap2)
	If $debugBuildingPos = 1 Then Setlog("#*# getLocationDarkElixirExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	if $debugGetLocation = 1 Then DebugImageGetLocation($result[0],"DarkElixirExtractorWithLevel")
	Return $result[0]
EndFunc   ;==>GetLocationDarkElixirWithLevel

Func GetLocationGoldStorage()

	Local $hTimer = TimerInit()

	; Variables
	Local $directory = @ScriptDir & "\images\Storages\Gold"
	Local $TempVectStr
	Local $TotalStorages = 0
	Local $TotalObjects = 0
	Local $GoldStorageXY
	Local $maxReturnPoints = 4
	Local $redLines = ""
	Local $minLevel = 0
	Local $maxLevel = 12
	Local $statFile = ""
	If $DebugSetLog = 1 Then SetLog("Started the function | GetLocationGoldStorage")

	; Performing the search
	Local $aResult = returnMultipleMatches($directory, $maxReturnPoints , $redLines, $statFile, $minLevel, $maxLevel)
	; Take the results and fill the variable $TempVectStr
	If UBound($aResult) > 1 Then
		For $i = 1 To UBound($aResult) - 1
			$Filename = $aResult[$i][1]      ; Filename
			$TotalObjects = $aResult[$i][4]  ; Total of Objects from the same FileName
			$GoldStorageXY = $aResult[$i][5] ; Coords
			If IsArray($GoldStorageXY) and $TotalObjects > 0 Then
				For $t = 0 To UBound($GoldStorageXY) - 1 ; each filename can have several positions
					If $DebugSetLog = 1 Then SetLog($Filename & " found (" & $GoldStorageXY[$t][0] & "," & $GoldStorageXY[$t][1] & ")", $COLOR_GREEN)
					$TempVectStr &= $GoldStorageXY[$t][0] & "-" & $GoldStorageXY[$t][1] & "|"
					$TotalStorages += 1
					If $TotalStorages >= 4 Then ExitLoop (2)
				Next
			EndIf
		Next
	EndIf

	If $DebugSetLog = 1 Then SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)

	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		if $debugGetLocation = 1 Then DebugImageGetLocation($TempVectStr,"GoldStorage")
		Local $InputVect = GetListPixel($TempVectStr)
		SetLog("Total Gold Storages :" & $TotalStorages)
		Return $InputVect
	Else
		Return 0
	EndIf

EndFunc   ;==>GetLocationGoldStorage

Func GetLocationElixirStorage()

	Local $hTimer = TimerInit()
	; Variables
	Local $directory = @ScriptDir & "\images\Storages\Elixir"
	Local $TempVectStr
	Local $TotalStorages = 0
	Local $TotalObjects = 0
	Local $ElixirStorageXY
	Local $maxReturnPoints = 4
	Local $redLines = ""
	Local $minLevel = 0
	Local $maxLevel = 12
	Local $statFile = ""
	If $DebugSetLog = 1 Then SetLog("Started the function | GetLocationElixirStorage")

	; Performing the search
	Local $aResult = returnMultipleMatches($directory, $maxReturnPoints , $redLines, $statFile, $minLevel, $maxLevel)
	; Take the results and fill the variable $TempVectStr
	If UBound($aResult) > 1 Then
		For $i = 1 To UBound($aResult) - 1
			$Filename = $aResult[$i][1]      ; Filename
			$TotalObjects = $aResult[$i][4]  ; Total of Objects from the same FileName
			$ElixirStorageXY = $aResult[$i][5] ; Coords
			If IsArray($ElixirStorageXY) and $TotalObjects > 0 Then
				For $t = 0 To UBound($ElixirStorageXY) - 1 ; each filename can have several positions
					If $DebugSetLog = 1 Then SetLog($Filename & " found (" & $ElixirStorageXY[$t][0] & "," & $ElixirStorageXY[$t][1] & ")", $COLOR_GREEN)
					$TempVectStr &= $ElixirStorageXY[$t][0] & "-" & $ElixirStorageXY[$t][1] & "|"
					$TotalStorages += 1
					If $TotalStorages >= 4 Then ExitLoop (2)
				Next
			EndIf
		Next
	EndIf

	If $DebugSetLog = 1 Then SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)

	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		Local $InputVect = GetListPixel($TempVectStr)
		SetLog("Total Elixirr Storages :" & $TotalStorages)
		if $debugGetLocation = 1 Then DebugImageGetLocation($TempVectStr,"ElixirStorage")
		Return $InputVect
	Else
		Return 0
	EndIf

EndFunc   ;==>GetLocationElixirStorage

Func DebugImageGetLocation($vectorstr, $type)
setlog("DebugImage .............................")
setlog("input: " & $vectorstr)
setlog("type: " & $type)

Switch $type
	case "DarkElixirStorageWithLevel", "ElixirExtractorWithLevel", "SnowElixirExtractorWithLevel", "MineExtractorWithLevel", "SnowMineExtractorWithLevel", "DarkElixirExtractorWithLevel"
		Local $vector = stringSplit($vectorstr,"~",2) ; 8#387-162~8#460-314
		Setlog("-- " & $type)
		For $i = 0 To UBound($vector) - 1
			Setlog($type & " " & $i & " --> " & $vector[$i])
			Local $temp = StringSplit($vector[$i], "#", 2) ;TEMP ["2", "404-325"]
			If UBound($temp) = 2 Then
				$pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
				If UBound($pixel) = 2 Then
					If isInsideDiamondRedArea($pixel) Then
						if $debugsetlog=1 then Setlog("coordinate inside village (" & $pixel[0] & "," & $pixel[1] & ")" )
						_CaptureRegion($pixel[0]  - 30, $pixel[1] - 30, $pixel[0]  + 30, $pixel[1]  + 30)
						DebugImageSave("DebugImageGetLocation_" & $type & "_"  ,  False)
					Else
						if $debugsetlog=1 then Setlog("coordinate out of village (" & $pixel[0] & "," & $pixel[1] & ")" )
					EndIf
				EndIf
			EndIf
		Next
	case "Mine", "SnowMine", "Elixir", "SnowElixir", "DarkElixir", "TownHall","DarkElixirStorage", "GoldStorage", "ElixirStorage"
		Local $vector = stringSplit($vectorstr,"|",2)
		Setlog("-- " & $type)
		For $i = 0 To UBound($vector) - 1
			Local $pixel = StringSplit($vector[$i], "-", 2);PIXEL ["404","325"]
			If UBound($pixel) = 2 Then
				If isInsideDiamondRedArea($pixel) Then
					if $debugsetlog=1 then Setlog("coordinate inside village (" & $pixel[0] & "," & $pixel[1] & ")" )
					_CaptureRegion($pixel[0]  - 30, $pixel[1] - 30, $pixel[0]  + 30, $pixel[1]  + 30)
					DebugImageSave("DebugImageGetLocation_" & $type & "_"  ,  False)
				Else
					if $debugsetlog=1 then Setlog("coordinate out of village (" & $pixel[0] & "," & $pixel[1] & ")" )
				EndIf
			EndIf
		Next
	case Else
		setlog("!!!!!!")
EndSwitch


setlog("-------------------------------------------")
;~ 						Local $hPen = _GDIPlus_PenCreate(0xFFFFD800, 1)
;~ 						Local $multiplier = 2
;~ 						Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmap)
;~ 						Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
;~ 						_GDIPlus_GraphicsDrawLine($hGraphic, 0, 30, 60, 30, $hPen)
;~ 						_GDIPlus_GraphicsDrawLine($hGraphic, 30, 0, 30, 60, $hPen)
;~ 						_GDIPlus_PenDispose($hPen)
;~ 						_GDIPlus_BrushDispose($hBrush)
;~ 						_GDIPlus_GraphicsDispose($hGraphic)
;~ 						DebugImageSave("debugresourcesoffset_" & $type & "_" & $level & "_" & $filename & "#"  ,  False)
;~ 					EndIf
EndFunc