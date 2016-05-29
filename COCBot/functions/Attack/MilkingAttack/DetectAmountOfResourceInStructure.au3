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
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func DetectAmountOfResourceInStructure($type, $coordinate, $level, $mincapacity)

	If $type = "elixir" Then

		Local $tolerance
		Local $posx, $posy
		Local $levelanalized
		Local $filename
		Local $endoffilename
		_CaptureRegion($coordinate[0] - 10, $coordinate[1] - 10, $coordinate[0] + 10, $coordinate[1] + 20)
		Local $found = 0
		For $t = UBound(Eval("CapacityStructureElixir" & $level)) - 1 To 1 Step -1 ;
			$filename = Execute("$CapacityStructureElixir" & $level & "[" & $t & "]")
			$capacityanalized = StringMid($filename, StringInStr($filename, "_", 0, 2) + 1, StringInStr($filename, "_", 0, 3) - StringInStr($filename, "_", 0, 2) - 1)
			$tolerance = StringMid($filename, StringInStr($filename, "_", 0, 3) + 1, StringInStr($filename, "_", 0, 4) - StringInStr($filename, "_", 0, 3) - 1)
			If $MilkFarmForcetolerance = 1 Then
				$endoffilename = StringMid($filename, StringInStr($filename, "_", 0, 4) + 1, 1)
				If $endoffilename = "Z" Then ;boosted
					$tolerance = $MilkFarmForcetoleranceboosted
				Else
					$tolerance = $MilkFarmForcetolerancenormal
				EndIf
			EndIf

			;If $debugsetlog=1 Then Setlog("cap " & $capacityanalized)
			;If $debugsetlog=1 Then Setlog("tol " & $tolerance)
			If $capacityanalized < $mincapacity And $continuesearchelixirdebug = 0 Then
				;stop search... do not search below minimum capacity
				If $debugsetlog = 1 Then Setlog("IMAGECKECK STOP, capacity < mincapacity " & $filename, $COLOR_purple)
				Return -1
				ExitLoop
			Else
				$found = _ImageSearch(@ScriptDir & "\images\CapacityStructure\" & Execute("$CapacityStructureElixir" & $level & "[" & $t & "]"), 1, $posx, $posy, $tolerance)
				If $found = 1 Then
					If $debugsetlog = 1 Then Setlog("IMAGECKECK OK (" & $tolerance & ") " & $filename, $COLOR_purple)
					If $debugImageSave = 1 Then DebugImageSave("IMAGECKECK OK (" & $tolerance & ") " & $filename, False)
					Return $capacityanalized
					ExitLoop
				EndIf
			EndIf
		Next
		If $found = 0 Then
			;DebugImageSave("elixir_" & $level & "_X_70_A_(" & $coordinate[0] & "," & $coordinate[1] & ")_", False)
			If $debugImageSave = 1 Then DebugImageSave("elixir_" & $level & "_", False)
			If $debugsetlog = 1 Then SETLOG("FAIL STRUCTURE POSITION (" & $coordinate[0] & "," & $coordinate[1] & ") level " & $level & " (" & $level + 4 & ")", $color_purple)
		EndIf
		Return -1
	Else
		Return -1
	EndIf
EndFunc   ;==>DetectAmountOfResourceInStructure
