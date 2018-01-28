; #FUNCTION# ====================================================================================================================
; Name ..........: GetPixelSide
; Description ...:
; Syntax ........: GetPixelSide($listPixel, $index)
; Parameters ....: $listPixel           - an unknown value.
;                  $index               - an integer value.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetPixelSide($listPixel, $index)
	If $g_bDebugSetlog Then SetDebugLog("GetPixelSide " & $index & " = " & StringReplace($listPixel[$index], "-", ","))
	Return GetListPixel($listPixel[$index])
EndFunc   ;==>GetPixelSide
