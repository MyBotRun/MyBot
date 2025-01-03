; #FUNCTION# ====================================================================================================================
; Name ..........: checkDeadBase
; Description ...: This file Includes the Variables and functions to detection of a DeadBase.
;                  is full or semi-full to indicate that it is a dead base
; Syntax ........: checkDeadBase() , ZombieSearch()
; Parameters ....: None
; Return values .: True if it is, returns false if it is not a dead base
; Author ........:  AtoZ , DinoBot (01-2015)
; Modified ......: CodeSlinger69 (01-2017), Moebius14 (08-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func hasElixirStorage($bForceCapture = False)

	Local $has = False

	Local $result = findMultiple($g_sImgElixirStorage, "ECD", $g_sImglocRedline, 0, 1000, 0, "objectname,objectpoints,objectlevel", $bForceCapture)

	If IsArray($result) Then
		For $matchedValues In $result
			Local $aPoints = StringSplit($matchedValues[1], "|", $STR_NOCOUNT) ; multiple points splited by | char
			Local $found = UBound($aPoints)
			If $found > 0 Then
				$has = True
				ExitLoop
			EndIf
		Next
	EndIf

	Return $has

EndFunc   ;==>hasElixirStorage

Func setZombie($RaidedElixir = -1, $AvailableElixir = -1, $Matched = -1, $SearchIdx = -1, $redline = "", $Timestamp = @YEAR & "-" & @MON & "-" & @MDAY & "_" & StringReplace(_NowTime(5), ":", "-"))
	If TestCapture() Then Return ""
	If $RaidedElixir = -1 And $AvailableElixir = -1 And $Matched = -1 And $SearchIdx = -1 Then
		$g_aZombie[0] = ""
		$g_aZombie[1] = 0
		$g_aZombie[2] = 0
		$g_aZombie[3] = 0
		$g_aZombie[4] = 0
		$g_aZombie[5] = ""
		$g_aZombie[6] = ""
	Else
		If $RaidedElixir >= 0 Then $g_aZombie[1] = Number($RaidedElixir)
		If $AvailableElixir >= 0 Then $g_aZombie[2] = Number($AvailableElixir)
		If $Matched >= 0 Then $g_aZombie[3] = Number($Matched)
		If $SearchIdx >= 0 Then $g_aZombie[4] = Number($SearchIdx)
		If $g_aZombie[5] = "" Then $g_aZombie[5] = $Timestamp
		If $g_aZombie[6] = "" Then $g_aZombie[6] = $redline
		Local $dbFound = $g_aZombie[3] >= $g_iCollectorMatchesMin
		Local $path = $g_sProfileTempDebugPath & (($dbFound) ? ("Zombies\") : ("SkippedZombies\"))
		Local $availK = Round($g_aZombie[2] / 1000)
		; $ZombieFilename = "DebugDB_xxx%_" & $g_sProfileCurrentName & @YEAR & "-" & @MON & "-" & @MDAY & "_" & StringReplace(_NowTime(5), ":", "-") & "_search_" & StringFormat("%03i", $g_iSearchCount) & "_" & StringFormat("%04i", Round($g_iSearchElixir / 1000)) & "k_matched_" & $TotalMatched
		If $g_aZombie[0] = "" And $g_aZombie[4] > 0 Then
			Local $create = $g_aZombie[0] = "" And ($dbFound = True Or ($g_aZombie[8] = -1 And $g_aZombie[9] = -1) Or ($availK >= $g_aZombie[8] And hasElixirStorage() = False) Or $availK >= $g_aZombie[9])
			If $create = True Then
				Local $ZombieFilename = "DebugDB_" & StringFormat("%04i", $availK) & "k_" & $g_sProfileCurrentName & "_search_" & StringFormat("%03i", $g_aZombie[4]) & "_matched_" & $g_aZombie[3] & "_" & $g_aZombie[5] & ".png"
				SetDebugLog("Saving enemy village screenshot for deadbase validation: " & $ZombieFilename)
				SetDebugLog("Redline was: " & $g_aZombie[6])
				$g_aZombie[0] = $ZombieFilename
				Local $g_hBitmapZombie = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
				_GDIPlus_ImageSaveToFile($g_hBitmapZombie, $path & $g_aZombie[0])
				_GDIPlus_BitmapDispose($g_hBitmapZombie)
			EndIf
		ElseIf $g_aZombie[0] <> "" Then
			Local $raidPct = 0
			If $g_aZombie[2] > 0 And $g_aZombie[2] >= $g_aZombie[1] Then
				$raidPct = Round((100 * $g_aZombie[1]) / $g_aZombie[2])
			EndIf
			If $g_aZombie[7] <> -1 And $raidPct >= $g_aZombie[7] And ($g_aZombie[10] = -1 Or $g_aZombie[2] >= $g_aZombie[10]) Then
				SetDebugLog("Delete enemy village screenshot as base seems dead: " & $g_aZombie[0])
				FileDelete($path & $g_aZombie[0])
			Else
				Local $ZombieFilename = "DebugDB_" & StringFormat("%03i", $raidPct) & "%_" & $g_sProfileCurrentName & "_search_" & StringFormat("%03i", $g_aZombie[4]) & "_matched_" & $g_aZombie[3] & "_" & StringFormat("%04i", $availK) & "k_" & StringFormat("%04i", Round($g_aZombie[1] / 1000)) & "k_" & $g_aZombie[5] & ".png"
				SetDebugLog("Rename enemy village screenshot as base seems live: " & $ZombieFilename)
				FileMove($path & $g_aZombie[0], $path & $ZombieFilename)
			EndIf
			; clear zombie
			setZombie()
		Else
			; clear zombie
			setZombie()
		EndIf
	EndIf
	Return $g_aZombie[0]
EndFunc   ;==>setZombie

Func checkDeadBase($TestDeadBase = False)
	If $g_bChkDeadEagle And $g_iSearchCount < $g_iDeadEagleSearch Then
		SetDebugLog("Checking base for DeadEagle : " & $g_iSearchCount)
		Return CheckForDeadEagle()
	Else
		SetDebugLog("Checking base for Collector Level : " & $g_iSearchCount)
		Return checkDeadBaseQuick(False, $TestDeadBase)
	EndIf
EndFunc   ;==>checkDeadBase

Func SuperchargeCheck($TestDeadBase = False)
	; Supercharge
	If $TestDeadBase Or ($g_iTownHallLevel > 13 And $g_bSupercharge) Then ; Only If TH Level > 13
		If Not FileExists($g_sImgElixirCollectorFill & "supercharge*.xml") Then
			FileCopy($g_sImgElixirSupercharge, $g_sImgElixirCollectorFill)
			If _Sleep($DELAYRUNBOT3) Then Return ; 200 ms
		EndIf
	Else
		CleanSuperchargeTemplates()
	EndIf
EndFunc   ;==>SuperchargeCheck

Func CleanSuperchargeTemplates()
	If FileExists($g_sImgElixirCollectorFill & "supercharge*.xml") Then
		FileDelete($g_sImgElixirCollectorFill & "supercharge*.xml")
		If _Sleep($DELAYRUNBOT6) Then Return ; 100 ms
	EndIf
EndFunc   ;==>CleanSuperchargeTemplates

Func checkDeadBaseQuick($bForceCapture = True, $TestDeadBase = False)

	If $g_bCollectorFilterDisable Then
		Return True
	EndIf

	SetDebugLog("Checking Deadbase With IMGLOC START (Quick)", $COLOR_WARNING)

	Local $sCocDiamond = "ECD" ;
	Local $redLines = $g_sImglocRedline ; if TH was Search then redline is set!
	Local $minLevel = 0
	Local $maxLevel = 1000
	Local $maxReturnPoints = 0 ; all positions
	Local $returnProps = "objectname,objectpoints"
	Local $TotalMatched = 0
	Local $x, $y
	Local $dbFound = False
	Local $aTempArray, $aTempCoords, $aTempMultiCoords
	Local $aTempArrayEx, $aTempCoordsEx, $aTempMultiCoordsEx
	Local $aExclusions[0][2], $bFoundExclusions = False
	Local $aTempCollectors[0][2], $bFoundTempCollectors = False
	Local $aCollectors[0][2]

	; check for any collector filling
	Local $result = findMultiple($g_sImgElixirCollectorFill, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)
	Local $bFoundFilledCollectors = $result <> "" And IsArray($result)

	If $bFoundFilledCollectors Then

		;Add found Exclusions into our Arrays
		For $i = 0 To UBound($result, 1) - 1
			$aTempArrayEx = $result[$i]
			If Not StringInStr($aTempArrayEx[0], "exclusion", $STR_NOCASESENSEBASIC) Then ContinueLoop
			$aTempMultiCoordsEx = decodeMultipleCoords($aTempArrayEx[1], 5, 5)
			For $j = 0 To UBound($aTempMultiCoordsEx, 1) - 1
				$aTempCoordsEx = $aTempMultiCoordsEx[$j]
				_ArrayAdd($aExclusions, $aTempCoordsEx[0] & "|" & $aTempCoordsEx[1])
				$bFoundExclusions = True
			Next
		Next
		If $bFoundExclusions Then
			For $i = 0 To UBound($aExclusions) - 1
				$aExclusions[$i][0] = Number($aExclusions[$i][0])
				$aExclusions[$i][1] = Number($aExclusions[$i][1])
			Next
			RemoveDupXY($aExclusions)
		EndIf

		;Add found collectors into our Arrays
		For $i = 0 To UBound($result, 1) - 1
			$aTempArray = $result[$i]
			If StringInStr($aTempArray[0], "exclusion", $STR_NOCASESENSEBASIC) Then ContinueLoop
			$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 5, 5)
			For $j = 0 To UBound($aTempMultiCoords, 1) - 1
				$aTempCoords = $aTempMultiCoords[$j]
				_ArrayAdd($aTempCollectors, $aTempCoords[0] & "|" & $aTempCoords[1])
				$bFoundTempCollectors = True
			Next
		Next
		If $bFoundTempCollectors Then
			For $i = 0 To UBound($aTempCollectors) - 1
				$aTempCollectors[$i][0] = Number($aTempCollectors[$i][0])
				$aTempCollectors[$i][1] = Number($aTempCollectors[$i][1])
			Next
			RemoveDupXY($aTempCollectors)
		EndIf

		If $bFoundExclusions Then ; Exclusions (Cake, etc...)
			If $bFoundTempCollectors Then
				For $i = 0 To UBound($aTempCollectors, 1) - 1
					Local $bExcluded = False
					For $z = 0 To UBound($aExclusions, 1) - 1
						Local $a = $aExclusions[$z][0] - $aTempCollectors[$i][0]
						Local $b = $aExclusions[$z][1] - $aTempCollectors[$i][1]
						Local $c = Sqrt($a * $a + $b * $b)
						If $c < 20 Then
							$bExcluded = True
							ExitLoop
						EndIf
					Next
					If Not $bExcluded Then _ArrayAdd($aCollectors, $aTempCollectors[$i][0] & "|" & $aTempCollectors[$i][1]) ; Only add if no exclusion is close.
				Next
			EndIf
		Else
			If $bFoundTempCollectors Then $aCollectors = $aTempCollectors ; no exclusion found.
		EndIf

		RemoveDupXY($aCollectors)

		If UBound($aCollectors) < $g_iCollectorMatchesMin And Not $TestDeadBase Then
			If UBound($aCollectors) > 0 Then
				SetDebugLog("IMGLOC : DEADBASE NOT MATCHED: " & UBound($aCollectors) & "/" & $g_iCollectorMatchesMin, $COLOR_WARNING)
			Else
				SetDebugLog("IMGLOC : NOT A DEADBASE", $COLOR_INFO)
			EndIf
			$g_aZombie[3] = $TotalMatched
			If $g_bDebugDeadBaseImage Then
				setZombie(0, $g_iSearchElixir, $TotalMatched, $g_iSearchCount, $g_sImglocRedline)
			EndIf
			Return $dbFound
		EndIf

		For $i = 0 To UBound($aCollectors, 1) - 1
			$x = $aCollectors[$i][0]
			$y = $aCollectors[$i][1]
			$sCocDiamond = ($x - 20) & "," & ($y - 35) & "|" & ($x + 20) & "," & ($y - 35) & "|" & ($x + 20) & "," & ($y + 15) & "|" & ($x - 20) & "," & ($y + 15)
			$redLines = $sCocDiamond ; override red line with CoC Diamond so not calculated again
			Local $result2 = findMultiple($g_sImgElixirCollectorLvl, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)
			$bForceCapture = False ; force capture only first time
			If IsArray($result2) Then $TotalMatched += 1
			If $TotalMatched >= $g_iCollectorMatchesMin Then
				$dbFound = True
				If Not $TestDeadBase Then ExitLoop ; db found
			EndIf
		Next
	EndIf

	If $g_bDebugSetLog Then
		If Not $bFoundFilledCollectors Then
			SetDebugLog("IMGLOC : NOT A DEADBASE", $COLOR_INFO)
		ElseIf Not $dbFound Then
			If UBound($aCollectors) > 0 Then
				SetDebugLog("IMGLOC : DEADBASE NOT MATCHED: " & $TotalMatched & "/" & $g_iCollectorMatchesMin, $COLOR_WARNING)
			Else
				SetDebugLog("IMGLOC : NOT A DEADBASE", $COLOR_INFO)
			EndIf
		Else
			SetDebugLog("IMGLOC : FOUND DEADBASE Matched: " & $TotalMatched & "/" & $g_iCollectorMatchesMin & ": " & UBound($aCollectors) & " collector points", $COLOR_GREEN)
		EndIf
	EndIf

	; always update $g_aZombie[3], current matched collectors count
	$g_aZombie[3] = $TotalMatched
	If $g_bDebugDeadBaseImage Then
		setZombie(0, $g_iSearchElixir, $TotalMatched, $g_iSearchCount, $g_sImglocRedline)
	EndIf

	Return $dbFound

EndFunc   ;==>checkDeadBaseQuick

Func checkDeadBaseFolder($directory, $executeNewCode = "checkDeadBaseQuick(True, True)")

	Local $aFiles = _FileListToArray($directory, "*.png", $FLTA_FILES)

	If IsArray($aFiles) = 0 Then Return False
	If $aFiles[0] = 0 Then Return False

	Local $wasDebugsetlog = $g_bDebugSetLog
	$g_bDebugSetLog = True

	SetLog("Checking " & $aFiles[0] & " village screenshot" & ($aFiles[0] > 1 ? "s" : "") & " for dead base...")

	Local $iTotalMsSuperNew = 0
	Local $iSuperNewFound = 0

	For $i = 1 To $aFiles[0]

		Local $sFile = $aFiles[$i]
		Local $srcFile = $directory & "\" & $sFile

		; local image
		Local $hBMP = _GDIPlus_BitmapCreateFromFile($directory & "\" & $sFile)
		Local $hHBMP = _GDIPlus_BitmapCreateDIBFromBitmap($hBMP)
		_GDIPlus_BitmapDispose($hBMP)
		TestCapture($hHBMP)

		Local $currentRunState = $g_bRunState
		$g_bRunState = True

		; checkDeadBaseQuick
		Local $hTimer = __TimerInit()
		Execute($executeNewCode)
		Local $iMsSuperNew = __TimerDiff($hTimer)
		$iTotalMsSuperNew += $iMsSuperNew
		$iMsSuperNew = Round($iMsSuperNew)
		Local $superNew = $g_aZombie[3]
		$iSuperNewFound += $superNew

		_WinAPI_DeleteObject($hHBMP)
		TestCapture(0)

	Next

	SetLog("Checking dead base completed")
	SetLog("Collectors found  : " & $iSuperNewFound)
	SetLog("Duration in ms. : " & Round($iTotalMsSuperNew))

	$g_bDebugSetLog = $wasDebugsetlog
	$g_bRunState = $currentRunState
	Return True

EndFunc   ;==>checkDeadBaseFolder

; search image for Dead Eagle
; return True if found
Func CheckForDeadEagle()
	Local $sImgDeadEagleImages = @ScriptDir & "\imgxml\Buildings\DeadEagle"
	Local $sBoostDiamond = "ECD"
	Local $redLines = "ECD"

	Local $avDeadEagle = findMultiple($sImgDeadEagleImages, $sBoostDiamond, $redLines, 0, 1000, 0, "objectname,objectpoints")

	If Not IsArray($avDeadEagle) Or UBound($avDeadEagle, $UBOUND_ROWS) <= 0 Then
		SetDebugLog("No Dead Eagle!")
		If $g_bDebugImageSave Then SaveDebugImage("DeadEagle", False)
		Return False
	EndIf

	Local $avTempArray

	For $i = 0 To UBound($avDeadEagle, $UBOUND_ROWS) - 1
		$avTempArray = $avDeadEagle[$i]

		SetLog("Search find : " & $avTempArray[0])
		SetLog("Location    : " & $avTempArray[1])
	Next

	Return True
EndFunc   ;==>CheckForDeadEagle

