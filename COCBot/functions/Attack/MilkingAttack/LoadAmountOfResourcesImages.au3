; #FUNCTION# ====================================================================================================================
; Name ..........:LoadAmountOfResourcesImages.au3
; Description ...:Load the images used in milking attack
; Syntax ........:LoadAmountOfResourcesImages()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func LoadAmountOfResourcesImages()
	Local $x
	Local $path = @ScriptDir & "\images\CapacityStructure\"
	Local $useImages = "*.bmp"
	For $t = 0 To 8
		Assign("CapacityStructureElixir" & $t, StringSplit("", ""))
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec($path, "elixir_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then Assign("CapacityStructureElixir" & $t, $x)
	Next
	For $t = 0 To 8
		Assign("DestroyedMineIMG" & $t, StringSplit("", ""))
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec($path, "destroyed_mine_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then Assign("DestroyedMineIMG" & $t, $x)
	Next
	For $t = 0 To 8
		Assign("DestroyedElixirIMG" & $t, StringSplit("", ""))
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec($path, "destroyed_elixir_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then Assign("DestroyedElixirIMG" & $t, $x)
	Next
	For $t = 0 To 8
		Assign("DestroyedDarkIMG" & $t, StringSplit("", ""))
		;put in a temp array the list of files matching condition "*_*_*_*.bmp"
		$x = _FileListToArrayRec($path, "destroyed_dark_" & $t & $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($x) > 0 Then Assign("DestroyedDarkIMG" & $t, $x)
	Next

EndFunc   ;==>LoadAmountOfResourcesImages
