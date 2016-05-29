; #FUNCTION# ====================================================================================================================
; Name ..........: _TrainMoveBtn
; Description ...:
; Syntax ........: _TrainMoveBtn($direction)
; Parameters ....: $direction           - a flag to set moving direction of tab selection
; Return values .: None
; Author ........:
; Modified ......: KnowJack(July 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _TrainMoveBtn($direction)
	Local $NextPos = _PixelSearch(749, 311 + $midOffsetY, 787, 322 + $midOffsetY, Hex(0xF08C40, 6), 5)
	Local $PrevPos = _PixelSearch(70, 311 + $midOffsetY, 110, 322 + $midOffsetY, Hex(0xF08C40, 6), 5)

	;where I am?
	Local $tabpos = [[112, 530 + $midOffsetY], [228, 530 + $midOffsetY], [288, 530 + $midOffsetY], [348, 530 + $midOffsetY], [409, 530 + $midOffsetY], [494, 530 + $midOffsetY], [555, 530 + $midOffsetY], [637, 530 + $midOffsetY], [698, 530 + $midOffsetY]]
	Local $i = 0
	While Not _ColorCheck(_GetPixelColor($tabpos[$i][0], $tabpos[$i][1], True), Hex(0xE8E8E0, 6), 20)
		$i += 1
		If $i >= UBound($tabpos) Then ExitLoop
	WEnd

	If $debugsetlogTrain = 1 Then
		Switch $i
			Case 0
				Setlog("Move from Army Overview", $COLOR_PURPLE)
			Case 1 To 4
				Setlog("Move from Barrack " & $i & " direction " & $direction, $COLOR_PURPLE)
			Case 5 To 6
				Setlog("Move from Dark Barrack " & $i - 4 & " direction " & $direction, $COLOR_PURPLE)
			Case 7
				Setlog("Move from Spell Factory" & " direction " & $direction, $COLOR_PURPLE)
			Case 8
				Setlog("Move from Dark Spell Factory" & " direction " & $direction, $COLOR_PURPLE)
			Case 9
				Setlog("Move from UNKNOWN position " & $i & " to direction " & $direction, $COLOR_RED)
		EndSwitch
	EndIf

	If $i = 9 Then
		;if unknow position move with arrows
		If $direction = -1 And IsArray($PrevPos) Then
			Click($PrevPos[0], $PrevPos[1], 1, $iDelayTrainMoveBtn1, "#0337")
		Else
			If $debugsetlogTrain = 1 And Not (IsArray($PrevPos)) Then Setlog("CANNOT FIND PREV BUTTON", $COLOR_RED)
		EndIf
		If $direction = +1 And IsArray($NextPos) Then
			Click($NextPos[0], $NextPos[1], 1, $iDelayTrainMoveBtn1, "#0338")
		Else
			If $debugsetlogTrain = 1 And Not (IsArray($NextPos)) Then Setlog("CANNOT FIND PREV BUTTON", $COLOR_RED)

		EndIf
	Else
		;find next/prev position
		If $direction = -1 Then
			Local $j = $i - 1
			If $j <= 0 Then $j = 8
			While (($Trainavailable[$j] = 0) And ($j <> $i))
				If $j = 1 Then
					$j = 8
				Else
					$j -= 1
				EndIf
			WEnd
			Click($tabpos[$j][0], $tabpos[$j][1], 1, $iDelayTrainMoveBtn1, "#0339")
		Else
			Local $j = $i + 1
			If $j = 9 Then $j = 1
			While (($Trainavailable[$j] = 0) And ($j <> $i))
				If $j = 8 Then
					$j = 1
				Else
					$j += 1
				EndIf
			WEnd
			Click($tabpos[$j][0], $tabpos[$j][1], 1, $iDelayTrainMoveBtn1, "#0340")
		EndIf
	EndIf

EndFunc   ;==>_TrainMoveBtn
