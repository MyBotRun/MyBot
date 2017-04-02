; #FUNCTION# ====================================================================================================================
; Name ..........: GetLocationMine
; Description ...:
; Syntax ........: GetLocationMine()
; Parameters ....:
; Return values .: String with locations
; Author ........:
; Modified ......: ProMac (04-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func GetLocationMine()

	If $g_iDetectedImageType = 0 Then
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationMineExtractor", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationMine: " & $result[0], $COLOR_DEBUG1)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "Mine")
		Return GetListPixel($result[0])
	Else
		Local $directory = @ScriptDir & "\imgxml\Storages\Mines_Snow"
		Local $Maxpositions = 7
		Local $aResult = returnMultipleMatches($directory, $Maxpositions)
		Local $result = ConvertImgloc2MBR($aResult, $Maxpositions)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationSnowMine: " & $result, $COLOR_DEBUG1)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result, "SnowMine")
		Return GetListPixel($result)
	EndIf

	Return GetListPixel($result)
EndFunc   ;==>GetLocationMine

Func GetLocationElixir()
	If $g_iDetectedImageType = 0 Then
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationElixirExtractor", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationElixir: " & $result[0], $COLOR_DEBUG1)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "Elixir")
		Return GetListPixel($result[0])
	Else
		Local $directory = @ScriptDir & "\imgxml\Storages\Collectors_Snow"
		Local $Maxpositions = 7
		Local $aResult = returnMultipleMatches($directory, $Maxpositions)
		Local $result = ConvertImgloc2MBR($aResult, $Maxpositions)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationSnowElixir: " & $result, $COLOR_DEBUG1)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result, "SnowElixir")
		Return GetListPixel($result)
	EndIf
EndFunc   ;==>GetLocationElixir

Func GetLocationDarkElixir()
	;Local $result = DllCall($g_hLibMyBot, "str", "getLocationDarkElixirExtractor", "ptr", $g_hHBitmap2)
	Local $directory = @ScriptDir & "\imgxml\Storages\Drills"
	Local $Maxpositions = 3
	Local $aResult = returnMultipleMatches($directory, $Maxpositions)
	Local $result = ConvertImgloc2MBR($aResult, $Maxpositions)

	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixir: " & $result, $COLOR_DEBUG1)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result, "DarkElixir")

	Return GetListPixel($result)
EndFunc   ;==>GetLocationDarkElixir

Func GetLocationTownHall()
	Local $result = DllCall($g_hLibMyBot, "str", "getLocationTownHall", "ptr", $g_hHBitmap2)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationTownHall: " & $result[0], $COLOR_DEBUG1)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "TownHall")
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationTownHall

Func GetLocationDarkElixirStorageWithLevel()
	Local $result = DllCall($g_hLibMyBot, "str", "getLocationDarkElixirStorageWithLevel", "ptr", $g_hHBitmap2)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorageWithLevel: " & $result[0], $COLOR_DEBUG1)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "DarkElixirStorageWithLevel")
	Return $result[0]
EndFunc   ;==>GetLocationDarkElixirStorageWithLevel

Func GetLocationDarkElixirStorage()
	Local $result = DllCall($g_hLibMyBot, "str", "getLocationDarkElixirStorage", "ptr", $g_hHBitmap2)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorage: " & $result[0], $COLOR_DEBUG1)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "DarkElixirStorage")
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

	If $g_iDetectedImageType = 0 Then
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationElixirExtractorWithLevel", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationElixirExtractorWithLevel: " & $result[0], $COLOR_DEBUG1)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "ElixirExtractorWithLevel")
	Else
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationSnowElixirExtractorWithLevel", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationSnowElixirExtractorWithLevel: " & $result[0], $COLOR_DEBUG1)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "SnowElixirExtractorWithLevel")
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

	If $g_iDetectedImageType = 0 Then
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationMineExtractorWithLevel", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationMineExtractorWithLevel: " & $result[0], $COLOR_DEBUG1)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "MineExtractorWithLevel")

	Else
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationSnowMineExtractorWithLevel", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationSnowMineExtractorWithLevel: " & $result[0], $COLOR_DEBUG1)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "SnowMineExtractorWithLevel")
	EndIf
	Return $result[0]
EndFunc   ;==>GetLocationMineWithLevel

Func GetLocationDarkElixirWithLevel()
	;Local $result = DllCall($g_hLibMyBot, "str", "getLocationDarkElixirExtractorWithLevel", "ptr", $g_hHBitmap2)

	Local $directory = @ScriptDir & "\imgxml\Storages\Drills"
	Local $Maxpositions = 3
	Local $aResult = returnMultipleMatches($directory, $Maxpositions)
	Local $result = ConvertImgloc2MBR($aResult, $Maxpositions, True)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationDarkElixirExtractorWithLevel: " & $result, $COLOR_DEBUG1)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result, "DarkElixirExtractorWithLevel")

	Return $result
EndFunc   ;==>GetLocationDarkElixirWithLevel

Func GetLocationGoldStorage()

	Local $hTimer = __TimerInit()

	; Variables
	Local $directory = @ScriptDir & "\imgxml\Storages\Gold"
	Local $TempVectStr
	Local $TotalStorages = 0
	Local $TotalObjects = 0
	Local $GoldStorageXY
	Local $maxReturnPoints = 4
	Local $redLines = ""
	Local $minLevel = 0
	Local $maxLevel = 12
	Local $statFile = ""
	If $g_iDebugSetlog = 1 Then SetLog("Started the function | GetLocationGoldStorage")

	; Performing the search
	Local $aResult = returnMultipleMatches($directory, $maxReturnPoints, $redLines, $statFile, $minLevel, $maxLevel)
	; Take the results and fill the variable $TempVectStr
	If UBound($aResult) > 1 Then
		For $i = 1 To UBound($aResult) - 1
			Local $Filename = $aResult[$i][1] ; Filename
			$TotalObjects = $aResult[$i][4] ; Total of Objects from the same FileName
			$GoldStorageXY = $aResult[$i][5] ; Coords
			If IsArray($GoldStorageXY) And $TotalObjects > 0 Then
				For $t = 0 To UBound($GoldStorageXY) - 1 ; each filename can have several positions
					If $g_iDebugSetlog = 1 Then SetLog($Filename & " found (" & $GoldStorageXY[$t][0] & "," & $GoldStorageXY[$t][1] & ")", $COLOR_SUCCESS)
					$TempVectStr &= $GoldStorageXY[$t][0] & "-" & $GoldStorageXY[$t][1] & "|"
					$TotalStorages += 1
					If $TotalStorages >= 4 Then ExitLoop (2)
				Next
			EndIf
		Next
	EndIf

	If $g_iDebugSetlog = 1 Then SetLog("  - Calculated  in: " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG1)

	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($TempVectStr, "GoldStorage")
		Local $InputVect = GetListPixel($TempVectStr)
		SetLog("Total Gold Storages :" & $TotalStorages)
		Return $InputVect
	Else
		Return 0
	EndIf

EndFunc   ;==>GetLocationGoldStorage

Func GetLocationElixirStorage()

	Local $hTimer = __TimerInit()
	; Variables
	Local $directory = @ScriptDir & "\imgxml\Storages\Elixir"
	Local $TempVectStr
	Local $TotalStorages = 0
	Local $TotalObjects = 0
	Local $ElixirStorageXY
	Local $maxReturnPoints = 4
	Local $redLines = ""
	Local $minLevel = 0
	Local $maxLevel = 12
	Local $statFile = ""
	If $g_iDebugSetlog = 1 Then SetLog("Started the function | GetLocationElixirStorage")

	; Performing the search
	Local $aResult = returnMultipleMatches($directory, $maxReturnPoints, $redLines, $statFile, $minLevel, $maxLevel)
	; Take the results and fill the variable $TempVectStr
	If UBound($aResult) > 1 Then
		For $i = 1 To UBound($aResult) - 1
			Local $Filename = $aResult[$i][1] ; Filename
			$TotalObjects = $aResult[$i][4] ; Total of Objects from the same FileName
			$ElixirStorageXY = $aResult[$i][5] ; Coords
			If IsArray($ElixirStorageXY) And $TotalObjects > 0 Then
				For $t = 0 To UBound($ElixirStorageXY) - 1 ; each filename can have several positions
					If $g_iDebugSetlog = 1 Then SetLog($Filename & " found (" & $ElixirStorageXY[$t][0] & "," & $ElixirStorageXY[$t][1] & ")", $COLOR_SUCCESS)
					$TempVectStr &= $ElixirStorageXY[$t][0] & "-" & $ElixirStorageXY[$t][1] & "|"
					$TotalStorages += 1
					If $TotalStorages >= 4 Then ExitLoop (2)
				Next
			EndIf
		Next
	EndIf

	If $g_iDebugSetlog = 1 Then SetLog("  - Calculated  in: " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG1)

	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		Local $InputVect = GetListPixel($TempVectStr)
		SetLog("Total Elixirr Storages :" & $TotalStorages)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($TempVectStr, "ElixirStorage")
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
		Case "DarkElixirStorageWithLevel", "ElixirExtractorWithLevel", "SnowElixirExtractorWithLevel", "MineExtractorWithLevel", "SnowMineExtractorWithLevel", "DarkElixirExtractorWithLevel"
			Local $vector = StringSplit($vectorstr, "~", 2) ; 8#387-162~8#460-314
			Setlog("-- " & $type)
			For $i = 0 To UBound($vector) - 1
				Setlog($type & " " & $i & " --> " & $vector[$i])
				Local $temp = StringSplit($vector[$i], "#", 2) ;TEMP ["2", "404-325"]
				If UBound($temp) = 2 Then
					Local $pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
					If UBound($pixel) = 2 Then
						If isInsideDiamondRedArea($pixel) Then
							If $g_iDebugSetlog = 1 Then Setlog("coordinate inside village (" & $pixel[0] & "," & $pixel[1] & ")")
							_CaptureRegion($pixel[0] - 30, $pixel[1] - 30, $pixel[0] + 30, $pixel[1] + 30)
							DebugImageSave("DebugImageGetLocation_" & $type & "_", False)
						Else
							If $g_iDebugSetlog = 1 Then Setlog("coordinate out of village (" & $pixel[0] & "," & $pixel[1] & ")")
						EndIf
					EndIf
				EndIf
			Next
		Case "Mine", "SnowMine", "Elixir", "SnowElixir", "DarkElixir", "TownHall", "DarkElixirStorage", "GoldStorage", "ElixirStorage"
			Local $vector = StringSplit($vectorstr, "|", 2)
			Setlog("-- " & $type)
			For $i = 0 To UBound($vector) - 1
				Local $pixel = StringSplit($vector[$i], "-", 2) ;PIXEL ["404","325"]
				If UBound($pixel) = 2 Then
					If isInsideDiamondRedArea($pixel) Then
						If $g_iDebugSetlog = 1 Then Setlog("coordinate inside village (" & $pixel[0] & "," & $pixel[1] & ")")
						_CaptureRegion($pixel[0] - 30, $pixel[1] - 30, $pixel[0] + 30, $pixel[1] + 30)
						DebugImageSave("DebugImageGetLocation_" & $type & "_", False)
					Else
						If $g_iDebugSetlog = 1 Then Setlog("coordinate out of village (" & $pixel[0] & "," & $pixel[1] & ")")
					EndIf
				EndIf
			Next
		Case Else
			setlog("!!!!!!")
	EndSwitch


	setlog("-------------------------------------------")
;~ 						Local $hPen = _GDIPlus_PenCreate(0xFFFFD800, 1)
;~ 						Local $multiplier = 2
;~ 						Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)
;~ 						Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
;~ 						_GDIPlus_GraphicsDrawLine($hGraphic, 0, 30, 60, 30, $hPen)
;~ 						_GDIPlus_GraphicsDrawLine($hGraphic, 30, 0, 30, 60, $hPen)
;~ 						_GDIPlus_PenDispose($hPen)
;~ 						_GDIPlus_BrushDispose($hBrush)
;~ 						_GDIPlus_GraphicsDispose($hGraphic)
;~ 						DebugImageSave("debugresourcesoffset_" & $type & "_" & $level & "_" & $filename & "#"  ,  False)
;~ 					EndIf
EndFunc   ;==>DebugImageGetLocation

Func ConvertImgloc2MBR($Array, $Maxpositions, $level = False)

	Local $StringConverted = Null
	Local $Max = 0

	If IsArray($Array) Then
		For $i = 1 To UBound($Array) - 1 ; from 1 cos the 0 is empty
			Local $Coord = $Array[$i][5]
			If IsArray($Coord) Then ; same level with several positions
				For $t = 0 To UBound($Coord) - 1
					If isInsideDiamondXY($Coord[$t][0], $Coord[$t][1]) Then ; just in case
						If $level = True Then $StringConverted &= $Array[$i][2] & "#" & $Coord[$t][0] & "-" & $Coord[$t][1] & "~"
						If $level = False Then $StringConverted &= $Coord[$t][0] & "-" & $Coord[$t][1] & "|"
						$Max += 1
						If $Max = $Maxpositions Then ExitLoop (2)
					EndIf
				Next
			EndIf
		Next
	Else
		Setlog("Error on Imgloc detection Mines|Collectors|Drills", $COLOR_RED)
	EndIf

	$StringConverted = StringTrimRight($StringConverted, 1) ; remove the last " |" or "~"
	If $g_iDebugSetlog Then Setlog("$StringConverted: " & $StringConverted)

	Return $StringConverted ; xxx-yyy|xxx-yyy|n.... OR Lv#xxx-yyy~Lv#xxx-yyy

EndFunc   ;==>ConvertImgloc2MBR
