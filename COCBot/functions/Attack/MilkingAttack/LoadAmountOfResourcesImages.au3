; #FUNCTION# ====================================================================================================================
; Name ..........:LoadAmountOfResourcesImages.au3
; Description ...:Load the images used in milking attack
; Syntax ........:LoadAmountOfResourcesImages()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
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
		$g_asCapacityStructureElixir[$t] = StringSplit("", "")
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\CapacityStructure\", "elixir_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		;_ArrayDisplay($x)
		If UBound($x) > 0 Then $g_asCapacityStructureElixir[$t] = $x
	Next
	For $t = 0 To 8
		$g_asDestroyedMineIMG[$t] = StringSplit("", "")
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\CapacityStructure\", "destroyed_mine_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then $g_asDestroyedMineIMG[$t] = $x
	Next
	For $t = 0 To 8
		$g_asDestroyedElixirIMG[$t] = StringSplit("", "")
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\CapacityStructure\", "destroyed_elixir_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then $g_asDestroyedElixirIMG[$t] = $x
		If UBound($x) > 0 Then $g_asCapacityStructureElixir[$t] = $x
	Next
	For $t = 0 To 8
		$g_asDestroyedDarkIMG[$t] = StringSplit("", "")
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\CapacityStructure\", "destroyed_dark_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then $g_asDestroyedDarkIMG[$t] = $x
	Next

EndFunc   ;==>LoadAmountOfResourcesImages
