; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingAttackStructureDestroyed
; Description ...:Check if a building is destroyed
; Syntax ........:MilkingAttackStructureDestroyed($type,$level, $coordinate)
; Parameters ....:$type,$level, $coordinate
; Return values .:True or False
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingAttackStructureDestroyed($type, $level, $coordinate)
	Local $pixel = StringSplit($coordinate, "-", 2)
	Switch $type ;adjust coordinate
		Case "gomine"
			Local $px = StringSplit($MilkFarmOffsetMine[$level], "-", 2)
			Local $name = "Mine"
		Case "elixir"
			Local $px = StringSplit($MilkFarmOffsetElixir[$level], "-", 2)
			Local $name = "Elixir"
		Case "ddrill"
			Local $px = StringSplit($MilkFarmOffsetDark[$level], "-", 2)
			Local $name = "Dark"
		Case Else
			Local $px = StringSplit("0-0", "-", 2)
			Local $name = ""
			If $g_iDebugSetlog = 1 Then Setlog("MilkingAttackStructureDestroyed error #1")
	EndSwitch
	$pixel[0] += $px[0]
	$pixel[1] += $px[1]
	If UBound($pixel) = 2 Then
		_CaptureRegion($pixel[0] - 15, $pixel[1] - 15, $pixel[0] + 15, $pixel[1] + 15)

		;----------
		Local $found = 0
		Local $posx, $posy
		Local $aDestroyedImgFilenames = 0
		If $name = "Mine" Then
		   $aDestroyedImgFilenames = $DestroyedMineIMG[$level]
	    ElseIf $name = "Elixir" Then
		   $aDestroyedImgFilenames = $DestroyedElixirIMG[$level]
	    ElseIf $name = "Dark" Then
		   $aDestroyedImgFilenames = $DestroyedDarkIMG[$level]
	    EndIf
		If $g_iDebugSetlog = 1 Then Setlog("##start search in vector Destroyed" & $name & "IMG" & $level & ": numbers of files=" & UBound($aDestroyedImgFilenames), $COLOR_SUCCESS)
;~ 		 For $t = 1 To ubound($aDestroyedImg) - 1
;~ 			   If $g_iDebugSetlog=1 Then Setlog("-" & $aDestroyedImgFilenames[$t],$COLOR_DEBUG1)
;~ 		 Next
		For $t = UBound($aDestroyedImgFilenames) - 1 To 1 Step -1 ;
			Local $filename = $aDestroyedImgFilenames[$t]

			;If $g_iDebugSetlog=1 Then Setlog(">>filename = " & $filename)
			Local $tolerance = Int(StringMid($filename, StringInStr($filename, "_", 0, 3) + 1, StringInStr($filename, "_", 0, 4) - StringInStr($filename, "_", 0, 3) - 1))
			If $g_bMilkFarmForceToleranceEnable Then $tolerance = Int($g_iMilkFarmForceToleranceDestroyed)

			;If $g_iDebugSetlog=1 Then Setlog(">>tol " & $tolerance)
			$found = _ImageSearch(@ScriptDir & "\images\CapacityStructure\" & $filename, 1, $posx, $posy, $tolerance)
			If $found = 1 Then
				If $g_iDebugSetlog = 1 Then Setlog("IMAGECHECK OK " & $filename, $COLOR_DEBUG)
				If $g_iDebugSetlog = 1 Then SetLog(">>Structure Destroyed! (" & $name & "," & $level & "," & $tolerance & ")", $COLOR_ERROR)
				;Msgbox("","","destroyed")
				Return True
				ExitLoop
			Else
;~ 					If $g_iDebugSetlog = 1 Then Setlog(">>IMAGECHECK FAIL " & $filename, $COLOR_GRAY)
			EndIf
		Next
		If $found = 0 Then
			DebugImageSave("debugMilkingAttackStructureDestroyed_" & $type & "_" & $level & "_", False)
		EndIf
		Return False
	Else
		If $g_iDebugSetlog = 1 Then Setlog("error MilkingAttackStructureDestroyed #1")
	EndIf
EndFunc   ;==>MilkingAttackStructureDestroyed
