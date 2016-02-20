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
		Local $result = DllCall($hFuncLib, "str", "getLocationMineExtractor", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationMine: " & $result[0] ,$COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowMineExtractor", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationSnowMine: " & $result[0] ,$COLOR_TEAL)
	EndIf
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationMine

Func GetLocationElixir()
	If $iDetectedImageType = 0 Then
		Local $result = DllCall($hFuncLib, "str", "getLocationElixirExtractor", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationElixir: " & $result[0] ,$COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowElixirExtractor", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationSnowElixir: " & $result[0] ,$COLOR_TEAL)
	EndIf
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationElixir

Func GetLocationDarkElixir()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirExtractor", "ptr", $hBitmapFirst)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixir: " & $result[0] ,$COLOR_TEAL)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationDarkElixir

Func GetLocationTownHall()
	Local $result = DllCall($hFuncLib, "str", "getLocationTownHall", "ptr", $hBitmapFirst)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationTownHall: " & $result[0] ,$COLOR_TEAL)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationTownHall

Func GetLocationDarkElixirStorageWithLevel()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirStorageWithLevel", "ptr", $hBitmapFirst)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorageWithLevel: " & $result[0] ,$COLOR_TEAL)
	Return $result[0]
EndFunc   ;==>GetLocationDarkElixirStorage

Func GetLocationDarkElixirStorage()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirStorage", "ptr", $hBitmapFirst)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorage: " & $result[0] ,$COLOR_TEAL)
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
		Local $result = DllCall($hFuncLib, "str", "getLocationElixirExtractorWithLevel", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# getLocationElixirExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowElixirExtractorWithLevel", "ptr", $hBitmapFirst)
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
		Local $result = DllCall($hFuncLib, "str", "getLocationMineExtractorWithLevel", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# getLocationMineExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowMineExtractorWithLevel", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# getLocationSnowMineExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	EndIf
	Return $result[0]
EndFunc   ;==>GetLocationMineWithLevel

Func GetLocationDarkElixirWithLevel()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirExtractorWithLevel", "ptr", $hBitmapFirst)
	If $debugBuildingPos = 1 Then Setlog("#*# getLocationDarkElixirExtractorWithLevel: " & $result[0], $COLOR_TEAL)
	Return $result[0]
EndFunc   ;==>GetLocationDarkElixirWithLevel
