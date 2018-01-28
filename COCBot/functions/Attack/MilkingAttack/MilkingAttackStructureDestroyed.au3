; #FUNCTION# ====================================================================================================================
; Name ..........:MilkingAttackStructureDestroyed
; Description ...:Check if a building is destroyed
; Syntax ........:MilkingAttackStructureDestroyed($type,$level, $coordinate)
; Parameters ....:$type,$level, $coordinate
; Return values .:True or False
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingAttackStructureDestroyed($type, $level, $coordinate)
	Local $pixel = StringSplit($coordinate, "-", 2)
	Switch $type ;adjust coordinate
		Case "gomine"
			Local $px = StringSplit($g_asMilkFarmOffsetMine[$level], "-", 2)
			Local $name = "Mine"
		Case "elixir"
			Local $px = StringSplit($g_asMilkFarmOffsetElixir[$level], "-", 2)
			Local $name = "Elixir"
		Case "ddrill"
			Local $px = StringSplit($g_asMilkFarmOffsetDark[$level], "-", 2)
			Local $name = "Dark"
		Case Else
			Local $px = StringSplit("0-0", "-", 2)
			Local $name = ""
			If $g_bDebugSetlog Then SetDebugLog("MilkingAttackStructureDestroyed error #1")
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
			$aDestroyedImgFilenames = $g_asDestroyedMineIMG[$level]
		ElseIf $name = "Elixir" Then
			$aDestroyedImgFilenames = $g_asDestroyedElixirIMG[$level]
		ElseIf $name = "Dark" Then
			$aDestroyedImgFilenames = $g_asDestroyedDarkIMG[$level]
		EndIf
		If $g_bDebugSetlog Then SetDebugLog("##start search in vector Destroyed" & $name & "IMG" & $level & ": numbers of files=" & UBound($aDestroyedImgFilenames), $COLOR_SUCCESS)
		For $t = UBound($aDestroyedImgFilenames) - 1 To 1 Step -1 ;
			Local $filename = $aDestroyedImgFilenames[$t]

			Local $tolerance = Int(StringMid($filename, StringInStr($filename, "_", 0, 3) + 1, StringInStr($filename, "_", 0, 4) - StringInStr($filename, "_", 0, 3) - 1))
			If $g_bMilkFarmForceToleranceEnable Then $tolerance = Int($g_iMilkFarmForceToleranceDestroyed)

			$found = _ImageSearch(@ScriptDir & "\images\CapacityStructure\" & $filename, 1, $posx, $posy, $tolerance)
			If $found = 1 Then
				If $g_bDebugSetlog Then SetDebugLog("IMAGECHECK OK " & $filename, $COLOR_DEBUG)
				If $g_bDebugSetlog Then SetDebugLog(">>Structure Destroyed! (" & $name & "," & $level & "," & $tolerance & ")", $COLOR_ERROR)
				Return True
				ExitLoop
			Else

			EndIf
		Next
		If $found = 0 Then
			DebugImageSave("debugMilkingAttackStructureDestroyed_" & $type & "_" & $level & "_", False)
		EndIf
		Return False
	Else
		If $g_bDebugSetlog Then SetDebugLog("error MilkingAttackStructureDestroyed #1")
	EndIf
EndFunc   ;==>MilkingAttackStructureDestroyed
