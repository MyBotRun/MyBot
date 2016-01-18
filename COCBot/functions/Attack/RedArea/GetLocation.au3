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
