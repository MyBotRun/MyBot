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
		_CaptureRegion($coordinate[0] - 10, $coordinate[1] - 10, $coordinate[0] + 10, $coordinate[1] + 20)
		Local $found = 0
		For $t = UBound(Eval("CapacityStructureElixir" & $level)) - 1 To 1 Step -1 ;
			$filename = Execute("$CapacityStructureElixir" & $level & "[" & $t & "]")
			$capacityanalized = StringMid($filename, StringInStr($filename, "_", 0, 2) + 1, StringInStr($filename, "_", 0, 3) - StringInStr($filename, "_", 0, 2) - 1)
			$tolerance = StringMid($filename, StringInStr($filename, "_", 0, 3) + 1, StringInStr($filename, "_", 0, 4) - StringInStr($filename, "_", 0, 3) - 1)
			If $capacityanalized < $mincapacity And $continuesearchelixirdebug = 0 Then
				;stop search... do not search below minimum capacity
				If $debugsetlog = 1 Then Setlog("IMAGECKECK STOP, capacity < mincapacity " & $filename, $COLOR_purple)
				Return -1
				ExitLoop
			Else
				$found = _ImageSearch(@ScriptDir & "\images\CapacityStructure\" & Execute("$CapacityStructureElixir" & $level & "[" & $t & "]"), 1, $posx, $posy, $tolerance)
				If $found = 1 Then
					If $debugresourcesoffset = 1 Then ; make debug image for check offset
						Local $resourceoffsetx = 0
						Local $resourceoffsety = 0
						Local $px = StringSplit($MilkFarmOffsetElixir[$level], "-", 2)
						$resourceoffsetx = $px[0]
						$resourceoffsety = $px[1]
						_CaptureRegion($coordinate[0] + $resourceoffsetx - 30, $coordinate[1] + $resourceoffsety - 30, $coordinate[0] + $resourceoffsetx + 30, $coordinate[1] + $resourceoffsety + 30)
						Local $hPen = _GDIPlus_PenCreate(0xFFFFD800, 1)
						Local $multiplier = 2
						Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmap)
						Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
						_GDIPlus_GraphicsDrawLine($hGraphic, 0, 30, 60, 30, $hPen)
						_GDIPlus_GraphicsDrawLine($hGraphic, 30, 0, 30, 60, $hPen)
						_GDIPlus_PenDispose($hPen)
						_GDIPlus_BrushDispose($hBrush)
						_GDIPlus_GraphicsDispose($hGraphic)
						DebugImageSave("debugresourcesoffset_" & $type & "_" & $level & "_" & $filename & "#", False)
					EndIf
					Return $capacityanalized
					ExitLoop
				EndIf
			EndIf
		Next
		If $found = 0 Then
			DebugImageSave("elixir_" & $level & "_X_70_A_(" & $coordinate[0] & "," & $coordinate[1] & ")_", False)
			If $debugsetlog = 1 Then SETLOG("FAIL STRUCTURE POSITION (" & $coordinate[0] & "," & $coordinate[1] & ") level " & $level & " (" & $level + 4 & ")", $color_purple)
		EndIf
		Return -1
	Else
		Return -1
	EndIf
EndFunc   ;==>DetectAmountOfResourceInStructure
