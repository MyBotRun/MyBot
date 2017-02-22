; #FUNCTION# ====================================================================================================================
; Name ..........:LoadAmountOfResourcesImages.au3
; Description ...:Load the images used in milking attack
; Syntax ........:LoadAmountOfResourcesImages()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================
#include-once

Func LoadAmountOfResourcesImages()
	Local $x
	Local $path = @ScriptDir & "\images\CapacityStructure\"
	Local $useImages = "*.bmp"
	For $t = 0 To 8
		$CapacityStructureElixir[$t] = StringSplit("", "")
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\CapacityStructure\", "elixir_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		;_ArrayDisplay($x)
		If UBound($x) > 0 Then $CapacityStructureElixir[$t] = $x

;~ 		For $i = 0 To UBound($CapacityStructureElixir[$t]) - 1
;~			Local $a = $CapacityStructureElixir[$t]
;~ 			If $g_iDebugSetlog=1 Then SetLog("$CapacityStructureElixir[" & $t & "][" & $i & "]:" & $a[$i] & @CRLF)
;~ 		Next
	Next
	For $t = 0 To 8
		$DestroyedMineIMG[$t] = StringSplit("", "")
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\CapacityStructure\", "destroyed_mine_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then $DestroyedMineIMG[$t] = $x
;~ 		For $i = 0 To UBound($DestroyedMineIMG[$t]) - 1
;~			Local $a = $DestroyedMineIMG[$t]
;~ 			If $g_iDebugSetlog=1 Then SetLog("$DestroyedMineIMG[" & $t & "][" & $i & "]:" & $[$i] & @CRLF)
;~ 		Next
	Next
	For $t = 0 To 8
		$DestroyedElixirIMG[$t] = StringSplit("", "")
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\CapacityStructure\", "destroyed_elixir_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then $DestroyedElixirIMG[$t] = $x
;~ 		For $i = 0 To UBound($DestroyedElixirIMG[$t]) - 1
;~			Local $a = $DestroyedElixirIMG[$t]
;~ 			If $g_iDebugSetlog=1 Then SetLog("$DestroyedElixirIMG[" & $t & "][" & $i & "]:" & $a[$i] & @CRLF)
;~ 		Next
	Next
	For $t = 0 To 8
		$DestroyedDarkIMG[$t] = StringSplit("", "")
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\CapacityStructure\", "destroyed_dark_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then $DestroyedDarkIMG[$t] = $x
;~ 		For $i = 0 To UBound($DestroyedDarkIMG[$t]) - 1
;~			Local $a = $DestroyedDarkIMG[$t]
;~ 			If $g_iDebugSetlog=1 Then SetLog("$DestroyedDarkIMG[" & $t & "][" & $i & "]:" & $a[$i] & @CRLF)
;~ 		Next
	Next



EndFunc   ;==>LoadAmountOfResourcesImages
