; #FUNCTION# ====================================================================================================================
; Name ..........: checkDeadBase
; Description ...: This file Includes the Variables and functions to detection of a DeadBase. Uses imagesearch to see whether a collector
;                  is full or semi-full to indicate that it is a dead base
; Syntax ........: checkDeadBase() , ZombieSearch()
; Parameters ....: None
; Return values .: True if it is, returns false if it is not a dead base
; Author ........:  AtoZ , DinoBot (01-2015)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
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

Func checkDeadBaseNew()

	If $g_bCollectorFilterDisable Then
		Return True
	EndIf
	Local $minCollectorLevel = 0
	Local $maxCollectorLevel = 0
	Local $anyFillLevel[2] = [False, False] ; 50% and 100%
	If $g_bDebugSetlog Then SetDebugLog("Checking Deadbase With IMGLOC START", $COLOR_WARNING)

	For $i = 6 To 13
		If $g_abCollectorLevelEnabled[$i] Then
			If $minCollectorLevel = 0 Then $minCollectorLevel = $i
			If $i > $maxCollectorLevel Then $maxCollectorLevel = $i
			$anyFillLevel[$g_aiCollectorLevelFill[$i]] = True
		EndIf
	Next

	If $maxCollectorLevel = 0 Then
		Return True
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("Checking Deadbase With IMGLOC START", $COLOR_WARNING)

	Local $TotalMatched = 0
	Local $Matched[2] = [-1, -1]
	Local $aPoints[0]

	; only one capture here, very important for consistent zombies
	_CaptureRegion2()

	;retry with imgloc 50% Fill collectors
	If $anyFillLevel[0] = True Then
		$Matched[0] = imglocIsDeadBase($aPoints, 50, $minCollectorLevel, $maxCollectorLevel, True, False) ; try half full collectors
		If $Matched[0] > 0 Then $TotalMatched += $Matched[0]
	EndIf

	If $TotalMatched < $g_iCollectorMatchesMin Then ;retry with imgloc 100% Fill collectors
		$Matched[1] = imglocIsDeadBase($aPoints, 100, $minCollectorLevel, $maxCollectorLevel, True, False) ; try full collectors
		If $Matched[1] > 0 Then $TotalMatched += $Matched[1]
	EndIf

	Local $dbFound = $TotalMatched >= $g_iCollectorMatchesMin
	If $dbFound Then
		If $g_bDebugSetlog Then SetDebugLog("IMGLOC : FOUND DEADBASE !!! Matched: " & $TotalMatched & "/" & $g_iCollectorMatchesMin & ": " & UBound($aPoints), $COLOR_GREEN)
	Else
		If $g_bDebugSetlog Then
			If $Matched[0] = -1 And $Matched[1] = -1 Then
				SetDebugLog("IMGLOC : NOT A DEADBASE!!! ", $COLOR_INFO)
			Else
				SetDebugLog("IMGLOC : DEADBASE NOT MATCHED Matched: " & $TotalMatched & "/" & $g_iCollectorMatchesMin, $COLOR_WARNING)
			EndIf
		EndIf
	EndIf

	; always update $g_aZombie[3], current matched collectors count
	$g_aZombie[3] = $TotalMatched
	If $g_bDebugDeadBaseImage Then
		setZombie(0, $g_iSearchElixir, $TotalMatched, $g_iSearchCount, $g_sImglocRedline)
	EndIf

	Return $dbFound
EndFunc   ;==>checkDeadBaseNew

Func checkDeadBase()
	Return checkDeadBaseSuperNew(False)
EndFunc   ;==>checkDeadBase

Func GetCollectorIndexByFillLevel($level)
	If Number($level) >= 85 Then Return 1
	Return 0
EndFunc   ;==>GetCollectorIndexByFillLevel

Func imglocIsDeadBase(ByRef $aPos, $FillLevel = 100, $minCollectorLevel = 0, $maxCollectorLevel = 1000, $CheckConfig = False, $bForceCapture = True)
	;only supports 50 and 100
	;accepts "regular,dark,spells"
	;returns array with all found objects
	Local $sCocDiamond = "ECD" ;
	Local $redLines = $g_sImglocRedline ; if TH was Search then redline is set!
	Local $minLevel = $minCollectorLevel ; We only support TH6+
	Local $maxLevel = $maxCollectorLevel
	Local $maxReturnPoints = 0 ; all positions
	Local $returnProps = "objectname,objectpoints,objectlevel"
	Local $sDirectory = @ScriptDir & "\imgxml\deadbase\elix\" & $FillLevel & "\"
	Local $matchedValues
	Local $TotalMatched = 0
	Local $fillIndex = GetCollectorIndexByFillLevel($FillLevel)

	If $g_bDebugSetlog Then SetDebugLog("IMGLOC : Searching Deadbase for FillLevel/MinLevel/MaxLevel: " & $FillLevel & "/" & $minLevel & "/" & $maxLevel & " using " & $sDirectory, $COLOR_INFO)

	Local $result = findMultiple($sDirectory, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)
	If IsArray($result) Then
		For $matchedValues In $result
			Local $aPoints = StringSplit($matchedValues[1], "|", $STR_NOCOUNT) ; multiple points splited by | char
			Local $found = UBound($aPoints)

			If $CheckConfig = True Then
				Local $level = Number($matchedValues[2])
				If $g_abCollectorLevelEnabled[$level] Then
					If $fillIndex < $g_aiCollectorLevelFill[$level] Then
						; collector fill level not reached
						$found = 0
					EndIf
				Else
					; collector is not enabled
					$found = 0
				EndIf
			EndIf

			If $found > 0 Then
				For $sPoint In $aPoints
					Local $aP = StringSplit($sPoint, ",", $STR_NOCOUNT)
					Local $bSkipPoint = False
					For $bP In $aPos
						Local $a = $aP[1] - $bP[1]
						Local $b = $aP[0] - $bP[0]
						Local $c = Sqrt($a * $a + $b * $b)
						If $c < 25 Then
							; duplicate point: skip
							If $g_bDebugSetlog Then SetDebugLog("IMGLOC : Searching Deadbase ignore duplicate collector " & $matchedValues[0] & " at " & $aP[0] & ", " & $aP[1], $COLOR_INFO)
							$bSkipPoint = True
							$found -= 1
							ExitLoop
						EndIf
					Next
					If $bSkipPoint = False Then
						Local $i = UBound($aPos)
						ReDim $aPos[$i + 1]
						$aPos[$i] = $aP
					EndIf
				Next

			EndIf

			$TotalMatched += $found
		Next
	Else
		$TotalMatched = -1
	EndIf

	Return $TotalMatched

EndFunc   ;==>imglocIsDeadBase

Func checkDeadBaseSuperNew($bForceCapture = True, $sFillDirectory = @ScriptDir & "\imgxml\deadbase\elix\fill\", $sLvlDirectory = @ScriptDir & "\imgxml\deadbase\elix\lvl\")

	If $g_bCollectorFilterDisable Then
		Return True
	EndIf

	Local $minCollectorLevel = 0
	Local $maxCollectorLevel = 0
	Local $anyFillLevel[2] = [False, False] ; 50% and 100%
	If $g_bDebugSetlog Then SetDebugLog("Checking Deadbase With IMGLOC START (super new)", $COLOR_WARNING)

	For $i = 6 To 13
		If $g_abCollectorLevelEnabled[$i] Then
			If $minCollectorLevel = 0 Then $minCollectorLevel = $i
			If $i > $maxCollectorLevel Then $maxCollectorLevel = $i
			$anyFillLevel[$g_aiCollectorLevelFill[$i]] = True
		EndIf
	Next

	If $maxCollectorLevel = 0 Then
		Return True
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("Checking Deadbase With IMGLOC START", $COLOR_WARNING)

	Local $TotalMatched = 0
	Local $Matched[2] = [-1, -1]
	Local $aPoints[0]

	; found fill positions (deduped)
	Local $aPos[0]

	Local $sCocDiamond = "ECD" ;
	Local $redLines = $g_sImglocRedline ; if TH was Search then redline is set!
	Local $minLevel = 0
	Local $maxLevel = 1000
	Local $maxReturnPoints = 0 ; all positions
	Local $returnProps = "objectname,objectpoints,objectlevel,fillLevel"
	Local $matchedValues
	Local $TotalMatched = 0
	Local $x, $y, $lvl, $fill

	; check for any collector filling
	Local $result = findMultiple($sFillDirectory, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)
	Local $foundFilledCollectors = IsArray($result) = 1

	If $foundFilledCollectors = True Then

		For $matchedValues In $result
			Local $aPoints = StringSplit($matchedValues[1], "|", $STR_NOCOUNT) ; multiple points splited by | char
			Local $found = UBound($aPoints)
			If $found > 0 Then
				$lvl = Number($matchedValues[3])
				For $sPoint In $aPoints
					Local $aP = StringSplit($sPoint, ",", $STR_NOCOUNT)
					ReDim $aP[4] ; 2=fill, 3=lvl
					$aP[3] = 0 ; initial lvl is 0 (for not found/identified yet)
					$aP[2] = $lvl
					Local $bSkipPoint = False
					For $i = 0 To UBound($aPos) - 1
						Local $bP = $aPos[$i]
						Local $a = $aP[1] - $bP[1]
						Local $b = $aP[0] - $bP[0]
						Local $c = Sqrt($a * $a + $b * $b)
						If $c < 25 Then
							; duplicate point: skipped
							If $aP[2] > $bP[2] Then
								; keep this one with higher level
								$aPos[$i] = $aP
								$aP = $bP ; just for logging
							EndIf
							If $g_bDebugSetlog Then SetDebugLog("IMGLOC : Searching Deadbase ignore duplicate collector with fill level " & $aP[2] & " at " & $aP[0] & ", " & $aP[1], $COLOR_INFO)
							$bSkipPoint = True
							$found -= 1
							ExitLoop
						EndIf
					Next
					If $bSkipPoint = False Then
						Local $i = UBound($aPos)
						ReDim $aPos[$i + 1]
						$aPos[$i] = $aP
					EndIf
				Next
			EndIf
		Next

		; check each collector location for collector level
		For $aP In $aPos
			$x = $aP[0]
			$y = $aP[1]
			$fill = $aP[2]
			$lvl = $aP[3]
			; search area for collector level, add 20 left and right, 25 top and 15 bottom
			$sCocDiamond = ($x - 20) & "," & ($y - 25) & "|" & ($x + 20) & "," & ($y - 25) & "|" & ($x + 20) & "," & ($y + 15) & "|" & ($x - 20) & "," & ($y + 15)
			$redLines = $sCocDiamond ; override red line with CoC Diamond so not calculated again
			$result = findMultiple($sLvlDirectory, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)
			$bForceCapture = False ; force capture only first time
			If IsArray($result) Then
				For $matchedValues In $result
					Local $aPoints = StringSplit($matchedValues[1], "|", $STR_NOCOUNT) ; multiple points splited by | char
					If UBound($aPoints) > 0 Then
						; collector level found
						$lvl = Number($matchedValues[2])
						If $lvl > $aP[3] Then $aP[3] = $lvl ; update collector level
					EndIf
				Next
			EndIf
			$lvl = $aP[3] ; update level variable as modified above
			If $lvl = 0 Then
				; collector level not identified
				If $g_bDebugSetlog Then SetDebugLog("IMGLOC : Searching Deadbase no collector identified with fill level " & $fill & " at " & $x & ", " & $y, $COLOR_INFO)
				ContinueLoop ; jump to next collector
			EndIf

			; check if this collector level with fill level is enabled
			If $g_abCollectorLevelEnabled[$lvl] Then
				Local $fillIndex = GetCollectorIndexByFillLevel($fill)
				If $fillIndex < $g_aiCollectorLevelFill[$lvl] Then
					; collector fill level not reached
					If $g_bDebugSetlog Then SetDebugLog("IMGLOC : Searching Deadbase collector level " & $lvl & " found but not enough elixir, fill level " & $fill & " at " & $x & ", " & $y, $COLOR_INFO)
					ContinueLoop ; jump to next collector
				EndIf
			Else
				; collector is not enabled
				If $g_bDebugSetlog Then SetDebugLog("IMGLOC : Searching Deadbase collector level " & $lvl & " found but not enabled, fill level " & $fill & " at " & $x & ", " & $y, $COLOR_INFO)
				ContinueLoop ; jump to next collector
			EndIf

			; found collector
			$TotalMatched += 1
		Next
	EndIf

	Local $dbFound = $TotalMatched >= $g_iCollectorMatchesMin
	If $g_bDebugSetlog Then
		If $foundFilledCollectors = False Then
			SetDebugLog("IMGLOC : NOT A DEADBASE!!!", $COLOR_INFO)
		ElseIf $dbFound = False Then
			SetDebugLog("IMGLOC : DEADBASE NOT MATCHED: " & $TotalMatched & "/" & $g_iCollectorMatchesMin, $COLOR_WARNING)
		Else
			SetDebugLog("IMGLOC : FOUND DEADBASE !!! Matched: " & $TotalMatched & "/" & $g_iCollectorMatchesMin & ": " & UBound($aPoints), $COLOR_GREEN)
		EndIf
	EndIf

	; always update $g_aZombie[3], current matched collectors count
	$g_aZombie[3] = $TotalMatched
	If $g_bDebugDeadBaseImage Then
		setZombie(0, $g_iSearchElixir, $TotalMatched, $g_iSearchCount, $g_sImglocRedline)
	EndIf

	Return $dbFound

EndFunc   ;==>checkDeadBaseSuperNew

Func checkDeadBaseFolder($directory, $executeOldCode = "checkDeadBaseNew()", $executeNewCode = "checkDeadBaseSuperNew()")

	Local $aFiles = _FileListToArray($directory, "*.png", $FLTA_FILES)

	If IsArray($aFiles) = 0 Then Return False
	If $aFiles[0] = 0 Then Return False

	Local $wasDebugsetlog = $g_bDebugSetlog
	$g_bDebugSetlog = True

	SetLog("Checking " & $aFiles[0] & " village screenshots for dead base...")

	DirCreate($directory & "\better")
	DirCreate($directory & "\worse")
	DirCreate($directory & "\same")

	Local $iTotalMsSuperNew = 0
	Local $iTotalMsNew = 0
	Local $iSuperNewFound = 0
	Local $iNewFound = 0
	Local $iBetter = 0
	Local $iWorse = 0
	Local $iSame = 0

	Local $sCocDiamond = "ECD" ;

	For $i = 1 To $aFiles[0]

		Local $sFile = $aFiles[$i]
		Local $srcFile = $directory & "\" & $sFile

		; local image
		Local $hBMP = _GDIPlus_BitmapCreateFromFile($directory & "\" & $sFile)
		Local $hHBMP = _GDIPlus_BitmapCreateDIBFromBitmap($hBMP)
		_GDIPlus_BitmapDispose($hBMP)
		TestCapture($hHBMP)

		$g_sImglocRedline = ""
		; get readline
		SearchRedLines()
		; measure village
		SearchZoomOut(False, True, "checkDeadBaseFolder", False, False)
		ConvertInternalExternArea() ; generate correct internal/external diamond measures

		For $j = 1 To 2

			If Mod($i + $j, 2) = 0 Then
				; checkDeadBaseNew
				Local $hTimer = __TimerInit()
				Execute($executeOldCode)
				Local $iMsNew = __TimerDiff($hTimer)
				$iTotalMsNew += $iMsNew
				$iMsNew = Round($iMsNew)
				Local $new = $g_aZombie[3]
				$iNewFound += $new
			Else
				; checkDeadBaseSuperNew
				$hTimer = __TimerInit()
				Execute($executeNewCode)
				Local $iMsSuperNew = __TimerDiff($hTimer)
				$iTotalMsSuperNew += $iMsSuperNew
				$iMsSuperNew = Round($iMsSuperNew)
				Local $superNew = $g_aZombie[3]
				$iSuperNewFound += $superNew
			EndIf
		Next

		_WinAPI_DeleteObject($hHBMP)
		TestCapture(0)

		Local $result = ""
		If $superNew > $new Then
			SetLog(StringFormat("%5i/%5i", $i, $aFiles[0]) & ": Dead base result: BETTER : " & $superNew & " > " & $new & " (" & StringFormat("%4i/%4i", $iMsSuperNew, $iMsNew) & " ms.) " & $srcFile)
			$result = "better"
			$iBetter += 1
		ElseIf $superNew < $new Then
			SetLog(StringFormat("%5i/%5i", $i, $aFiles[0]) & ": Dead base result: WORSE  : " & $superNew & " < " & $new & " (" & StringFormat("%4i/%4i", $iMsSuperNew, $iMsNew) & " ms.) " & $srcFile)
			$result = "worse"
			$iWorse += 1
		Else
			SetLog(StringFormat("%5i/%5i", $i, $aFiles[0]) & ": Dead base result: SAME   : " & $superNew & " = " & $new & " (" & StringFormat("%4i/%4i", $iMsSuperNew, $iMsNew) & " ms.) " & $srcFile)
			$result = "same"
			$iSame += 1
		EndIf

		Local $dstFile = $directory & "\" & $result & "\" & $sFile
		FileMove($srcFile, $dstFile)

	Next

	SetLog("Checking dead base completed")
	SetLog("Super new image detection BETTER : " & $iBetter)
	SetLog("Super new image detection WORSE  : " & $iWorse)
	SetLog("Super new image detection SAME   : " & $iSame)
	SetLog("Collectos found (Super new/new)  : " & $iSuperNewFound & " / " & $iNewFound)
	SetLog("Duration in ms. (Super new/new)  : " & Round($iTotalMsSuperNew) & " / " & Round($iTotalMsNew))

	$g_bDebugSetlog = $wasDebugsetlog

	Return True

EndFunc   ;==>checkDeadBaseFolder
