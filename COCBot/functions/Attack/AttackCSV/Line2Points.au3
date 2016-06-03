; #FUNCTION# ====================================================================================================================
; Name ..........: Line2Points
; Description ...: Equation of a Line Passing Through Two Points  (x-x0)/(x1-x0) = (y-y0)/(y1-y0) ==>  y = (x-x0)/(x1-x0)*(y1-y0) + y0
; Syntax ........: Line2Points($pixel0, $pixel1, $x)
; Parameters ....: $pixel0              - pixel array
;                  $pixel1              -pixel array
;                  $x
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Line2Points($pixel0, $pixel1, $x)
	Return Round(($x - $pixel0[0]) / ($pixel1[0] - $pixel0[0]) * ($pixel1[1] - $pixel0[1]) + $pixel0[1])
EndFunc   ;==>Line2Points
