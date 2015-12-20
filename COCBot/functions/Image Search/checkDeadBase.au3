; #FUNCTION# ====================================================================================================================
; Name ..........: checkDeadBase
; Description ...: This file Includes the Variables and functions to detection of a DeadBase. Uses imagesearch to see whether a collector
;                  is full or semi-full to indicate that it is a dead base
; Syntax ........: checkDeadBase() , ZombieSearch()
; Parameters ....: None
; Return values .: True if it is, returns false if it is not a dead base
; Author ........:  AtoZ , DinoBot (01-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkDeadBase()
	;    _CaptureRegion()
	;	If _ColorCheck(_GetPixelColor(27, 29), Hex(0x5C5E60, 6), 20) And $SearchCount <= 3 Then
	;	   $NoLeague += 1
	;   EndIf
	;	If _ColorCheck(_GetPixelColor(27, 29), Hex(0x5C5E60, 6), 20) And $NoLeague < 3 And $SearchCount >= 3 Then
	;	   Return True ; Check if get 3x village which no league, its a false dead base because reset league features in CoC
	;   Else
	if ZombieSearch2() Then Return True
	Return ZombieSearch() ; just so it compiles
	;    EndIf
EndFunc   ;==>checkDeadBase

;checkDeadBase Variables:-------------===========================
Global $AdjustTolerance = 0
Global $Tolerance[5][11] = [[55, 55, 55, 80, 70, 70, 75, 80, 0, 75, 65], [55, 55, 55, 80, 80, 70, 75, 80, 0, 75, 65], [55, 55, 55, 80, 80, 70, 75, 80, 0, 75, 65], [55, 55, 55, 80, 80, 60, 75, 75, 0, 75, 60], [55, 55, 55, 80, 80, 70, 75, 80, 0, 75, 65]]
Global $ZC = 0, $ZombieCount = 0;, $E
Global $ZombieFileSets = 3 ;Variant Image to use organized as per Folder
Global $ZSExclude = 0 ;Set to 0 to include Elixir Lvl 6, 1 to include lvl 7 and so on..
Global $Lx[4] = [0, 400, 0, 400]
Global $Ly[4] = [0, 0, 265, 265]
Global $Rx[4] = [460, 860, 400, 860]
Global $Ry[4] = [325, 325, 590, 590]

Global $Area[5][11][4], $IS_x[11][4], $IS_y[11][4], $E[5][11]

$E[0][0] = @ScriptDir & "\images\ELIX1\E6F9.bmp"
$E[0][1] = @ScriptDir & "\images\ELIX1\E7F9.bmp"
$E[0][2] = @ScriptDir & "\images\ELIX1\E8F9.bmp"
$E[0][3] = @ScriptDir & "\images\ELIX1\E9F9.bmp"
$E[0][4] = @ScriptDir & "\images\ELIX1\E10F8.bmp"
$E[0][5] = @ScriptDir & "\images\ELIX1\E10F9.bmp"
$E[0][6] = @ScriptDir & "\images\ELIX1\E11F8.bmp"
$E[0][7] = @ScriptDir & "\images\ELIX1\E11F9.bmp"
$E[0][8] = @ScriptDir & "\images\ELIX1\E12F7.bmp"
$E[0][9] = @ScriptDir & "\images\ELIX1\E12F8.bmp"
$E[0][10] = @ScriptDir & "\images\ELIX1\E12F9.bmp"

$E[1][0] = @ScriptDir & "\images\ELIX2\E6F9.bmp"
$E[1][1] = @ScriptDir & "\images\ELIX2\E7F9.bmp"
$E[1][2] = @ScriptDir & "\images\ELIX2\E8F9.bmp"
$E[1][3] = @ScriptDir & "\images\ELIX2\E9F9.bmp"
$E[1][4] = @ScriptDir & "\images\ELIX2\E10F8.bmp"
$E[1][5] = @ScriptDir & "\images\ELIX2\E10F9.bmp"
$E[1][6] = @ScriptDir & "\images\ELIX2\E11F8.bmp"
$E[1][7] = @ScriptDir & "\images\ELIX2\E11F9.bmp"
$E[1][8] = @ScriptDir & "\images\ELIX2\E12F7.bmp"
$E[1][9] = @ScriptDir & "\images\ELIX2\E12F8.bmp"
$E[1][10] = @ScriptDir & "\images\ELIX2\E12F9.bmp"

$E[2][0] = @ScriptDir & "\images\ELIX3\E6F9.bmp"
$E[2][1] = @ScriptDir & "\images\ELIX3\E7F9.bmp"
$E[2][2] = @ScriptDir & "\images\ELIX3\E8F9.bmp"
$E[2][3] = @ScriptDir & "\images\ELIX3\E9F9.bmp"
$E[2][4] = @ScriptDir & "\images\ELIX3\E10F8.bmp"
$E[2][5] = @ScriptDir & "\images\ELIX3\E10F9.bmp"
$E[2][6] = @ScriptDir & "\images\ELIX3\E11F8.bmp"
$E[2][7] = @ScriptDir & "\images\ELIX3\E11F9.bmp"
$E[2][8] = @ScriptDir & "\images\ELIX3\E12F7.bmp"
$E[2][9] = @ScriptDir & "\images\ELIX3\E12F8.bmp"
$E[2][10] = @ScriptDir & "\images\ELIX3\E12F9.bmp"

$E[3][0] = @ScriptDir & "\images\ELIX4\E6F9.bmp"
$E[3][1] = @ScriptDir & "\images\ELIX4\E7F9.bmp"
$E[3][2] = @ScriptDir & "\images\ELIX4\E8F9.bmp"
$E[3][3] = @ScriptDir & "\images\ELIX4\E9F9.bmp"
$E[3][4] = @ScriptDir & "\images\ELIX4\E10F8.bmp"
$E[3][5] = @ScriptDir & "\images\ELIX4\E10F9.bmp"
$E[3][6] = @ScriptDir & "\images\ELIX4\E11F8.bmp"
$E[3][7] = @ScriptDir & "\images\ELIX4\E11F9.bmp"
$E[3][8] = @ScriptDir & "\images\ELIX4\E12F7.bmp"
$E[3][9] = @ScriptDir & "\images\ELIX4\E12F8.bmp"
$E[3][10] = @ScriptDir & "\images\ELIX4\E12F9.bmp"

#Region ### Check Dead Base Functions ###
;==============================================================================================================
;===Main Function==============================================================================================
;--------------------------------------------------------------------------------------------------------------
;Uses imagesearch to see whether a collector is full or semi-full to indicate that it is a dead base
;Returns True if it is, returns false if it is not a dead base
;--------------------------------------------------------------------------------------------------------------

Func ZombieSearch2()
	_CaptureRegion()

	;jp testing
	Local $location[2]
	$ZombieCount = 0

	Local $hSearch = FileFindFirstFile(@ScriptDir & "\images\Elix\*.bmp")
	If $hSearch = -1 Then
		If $debugSetlog = 1 Then SetLog("No files found: "& @ScriptDir & "\images\Elix\*.bmp", $COLOR_PURPLE)
		Return False
	EndIf

    While 1
        $sFileName = FileFindNextFile($hSearch)
        ; If there is no more file matching the search.
        If @error Then ExitLoop
		;If $debugSetlog = 1 Then SetLog("Checking zombie "& @ScriptDir & "\images\Elix\" & $sFileName, $COLOR_PURPLE)

		If FileExists($sFileName) Then
			$found = _ImageSearch(@ScriptDir & "\images\Elix\" & $sFileName, 1, $location[0], $location[1], 80)
			if $found And IsInsideDiamondXY($location[0], $location[1]) Then
				If $debugSetlog = 1 Then SetLog("Zombie at "&$location[0]&","&$location[1]&" with "& @ScriptDir & "\images\Elix\" & $sFileName, $COLOR_PURPLE)
				$ZombieCount += 1
				ExitLoop
			EndIf
		EndIf
	WEnd

	If $ZombieCount > 0 Then
		Return True
	EndIf
	Return False
EndFunc   ;==>ZombieSearch2

Func ZombieSearch()

;~ 	If $iTownHallLevel >= 9 Then
;~ 		$ZombieFileSets = 4 ;Variant Image to use organized as per Folder
;~ 		$ZSExclude = 3 ;Set to 0 to include Elixir Lvl 6, 1 to include lvl 7 and so on..
;~ 	Else
;~ 		$ZombieFileSets = 3 ;Variant Image to use organized as per Folder
;~ 		$ZSExclude = 0 ;Set to 0 to include Elixir Lvl 6, 1 to include lvl 7 and so on..
;~ 	EndIf

	; If $debugSetlog = 1 Then SetLog("$ZSExclude :" & $ZSExclude, $COLOR_PURPLE)
	_CaptureRegion()

	$ZombieCount = 0
	$ZC = 0
	For $s = 0 To ($ZombieFileSets - 1) Step 1
		For $p = 10 To 0 + $ZSExclude Step -1
			If FileExists($E[$s][$p]) Then
				$Area[$s][$p][0] = _ImageSearch($E[$s][$p], 1, $IS_x[$p][0], $IS_y[$p][0], $Tolerance[$s][$p] + $AdjustTolerance)
				If $Area[$s][$p][0] > 0 Then
					$ZC = 1
					If $debugSetlog = 1 Then SetLog("Zombie at "&$IS_x[$p][0]&","&$IS_y[$p][0]&" with "& $E[$s][$p], $COLOR_PURPLE)
					ExitLoop (2)
				EndIf
			Else
				$Area[$s][$p][0] = 0
			EndIf
		Next
	Next
	$ZombieCount += $ZC
	If $ZombieCount > 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>ZombieSearch
#EndRegion ### Check Dead Base Functions ###
