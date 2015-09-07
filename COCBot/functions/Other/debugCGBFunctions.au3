; #FUNCTION# ====================================================================================================================
; Name ..........: debugCGBFunctions
; Description ...: This file will set the debug levels for the CGBfunctions.dll
; Syntax ........:
; Parameters ....: $debugSearchArea, $debugRedArea, $debugOcr
; Return values .: None, will create files in Temp folder for debugging purposes
; Author ........: Didipe (2015)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func debugCGBFunctions($debugSearchArea = 0, $debugRedArea = 0, $debugOcr = 0)

	Local $result = DllCall($pFuncLib, "str", "setGlobalVar", "int", $debugSearchArea, "int", $debugRedArea, "int", $debugOcr)
	;dll return 0 on success, -1 on error
	If IsArray($result) Then
		If $debugSetlog And $result[0] = -1 Then setlog("CGBfunctions.dll error setting Global vars.", $COLOR_PURPLE)
	Else
		If $debugSetlog Then setlog("CGBfunctions.dll not found.")
	EndIf

EndFunc   ;==>debugCGBFunctions
