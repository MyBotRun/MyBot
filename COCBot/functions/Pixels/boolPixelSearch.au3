
; #FUNCTION# ====================================================================================================================
; Name ..........: boolPixelSearch
; Description ...: Using _ColorCheck, checks compares multiple pixels and returns true if they all pass _ColorCheck.
; Syntax ........: boolPixelSearch($pixel1, $pixel2, $pixel3[, $variation = 10])
; Parameters ....: $pixel1              - array of x, y, capture flag
;                  $pixel2              - array of x, y, capture flag
;                  $pixel3              - array of x, y, capture flag
;                  $variation           - [optional] a variant value. Default is 10.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func boolPixelSearch($pixel1, $pixel2, $pixel3, $variation = 10)
	If _ColorCheck(_GetPixelColor($pixel1[0], $pixel1[1]), $pixel1[2], $variation) And _ColorCheck(_GetPixelColor($pixel2[0], $pixel2[1]), $pixel2[2], $variation) And _ColorCheck(_GetPixelColor($pixel3[0], $pixel3[1]), $pixel3[2], $variation) Then Return True
	Return False
EndFunc   ;==>boolPixelSearch
