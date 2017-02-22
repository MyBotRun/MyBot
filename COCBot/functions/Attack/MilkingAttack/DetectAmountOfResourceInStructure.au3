; #FUNCTION# ====================================================================================================================
; Name ..........:DetectAmountOfResourceInStructure.au3
; Description ...:Finds how many resources an elixir collector has
; Syntax ........:DetectAmountOfResourceInStructure($type, $coordinate, $level, $mincapacity)
; Parameters ....:$type-Which type of resource
;                 $coordinate- where the building is
;                 $level-which level the building is
;                 $minCapacity-the minimum of how much the building contains
; Return values .:$capacityanalized-how many resources were detected in the building
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================
#include-once

Func DetectAmountOfResourceInStructure($type, $coordinate, $level, $mincapacity)

	If $type = "elixir" Then

		Local $tolerance
		Local $posx, $posy
		Local $levelanalized
		Local $filename
		Local $endoffilename
		_CaptureRegion($coordinate[0] - 10, $coordinate[1] - 10, $coordinate[0] + 10, $coordinate[1] + 20)
		Local $found = 0
		For $t = UBound($CapacityStructureElixir[$level]) - 1 To 1 Step -1
		    Local $a = $CapacityStructureElixir[$level]
			$filename = $a[$t]
			Local $capacityanalized = StringMid($filename, StringInStr($filename, "_", 0, 2) + 1, StringInStr($filename, "_", 0, 3) - StringInStr($filename, "_", 0, 2) - 1)
			$tolerance = StringMid($filename, StringInStr($filename, "_", 0, 3) + 1, StringInStr($filename, "_", 0, 4) - StringInStr($filename, "_", 0, 3) - 1)
			If $g_bMilkFarmForceToleranceEnable Then
				$endoffilename = StringMid($filename, StringInStr($filename, "_", 0, 4) + 1, 1)
				If $endoffilename = "Z" Then ;boosted
					$tolerance = $g_iMilkFarmForceToleranceBoosted
				Else
					$tolerance = $g_iMilkFarmForceToleranceNormal
				EndIf
			EndIf

			;If $g_iDebugSetlog=1 Then Setlog("cap " & $capacityanalized)
			;If $g_iDebugSetlog=1 Then Setlog("tol " & $tolerance)
			If $capacityanalized < $mincapacity And $g_iDebugContinueSearchElixir = 0 Then
				;stop search... do not search below minimum capacity
				If $g_iDebugSetlog = 1 Then Setlog("IMAGECKECK STOP, capacity < mincapacity " & $filename, $COLOR_DEBUG)
				Return -1
				ExitLoop
			Else
				$found = _ImageSearch(@ScriptDir & "\images\CapacityStructure\" & $a[$t], 1, $posx, $posy, $tolerance)
				If $found = 1 Then
					If $g_iDebugSetlog = 1 Then Setlog("IMAGECKECK OK (" & $tolerance & ") " & $filename, $COLOR_DEBUG)
					If $g_iDebugImageSave = 1 Then DebugImageSave("IMAGECKECK OK (" & $tolerance & ") " & $filename, False)
					Return $capacityanalized
					ExitLoop
				EndIf
			EndIf
		Next
		If $found = 0 Then
			;DebugImageSave("elixir_" & $level & "_X_70_A_(" & $coordinate[0] & "," & $coordinate[1] & ")_", False)
			If $g_iDebugImageSave = 1 Then DebugImageSave("elixir_" & $level & "_", False)
			If $g_iDebugSetlog = 1 Then SETLOG("FAIL STRUCTURE POSITION (" & $coordinate[0] & "," & $coordinate[1] & ") level " & $level & " (" & $level + 4 & ")", $COLOR_DEBUG)
		EndIf
		Return -1
	Else
		Return -1
	EndIf
EndFunc   ;==>DetectAmountOfResourceInStructure
