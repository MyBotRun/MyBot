Func GetLocationMine()
	Local $result = DllCall($pFuncLib, "str", "getLocationMineExtractor", "ptr", $hBitmapFirst)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationMine

Func GetLocationElixir()
	Local $result = DllCall($pFuncLib, "str", "getLocationElixirExtractor", "ptr", $hBitmapFirst)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationElixir

Func GetLocationDarkElixir()
	Local $result = DllCall($pFuncLib, "str", "getLocationDarkElixirExtractor", "ptr", $hBitmapFirst)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationDarkElixir

Func GetLocationDarkElixirStorage()
	Local $result = DllCall($pFuncLib, "str", "getLocationDarkElixirStorage", "ptr", $hBitmapFirst)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationDarkElixirStorage
