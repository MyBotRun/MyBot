; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV_Read_SIDE_variables
; Description ...:
; Syntax ........: ParseAttackCSV_Read_SIDE_variables()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV_Read_SIDE_variables()

	$attackcsv_locate_mine = 0
	$attackcsv_locate_elixir = 0
	$attackcsv_locate_drill = 0
	$attackcsv_locate_gold_storage = 0
	$attackcsv_locate_elixir_storage = 0
	$attackcsv_locate_dark_storage = 0
	$attackcsv_locate_townhall = 0

	;Local $filename = "attack1"
	If $iMatchMode = $DB Then
		Local $filename = $scmbDBScriptName
	Else
		Local $filename = $scmbABScriptName
	EndIf

	Local $f, $line, $acommand, $command
	Local $value1, $value2, $value3, $value4, $value5, $value6, $value7, $value8, $value9

	If FileExists($dirAttacksCSV & "\" & $filename & ".csv") Then
		$f = FileOpen($dirAttacksCSV & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), 2)
				$value1 = StringStripWS(StringUpper($acommand[2]), 2)
				$value2 = StringStripWS(StringUpper($acommand[3]), 2)
				$value3 = StringStripWS(StringUpper($acommand[4]), 2)
				$value4 = StringStripWS(StringUpper($acommand[5]), 2)
				$value5 = StringStripWS(StringUpper($acommand[6]), 2)
				$value6 = StringStripWS(StringUpper($acommand[7]), 2)
				$value7 = StringStripWS(StringUpper($acommand[8]), 2)
				$value8 = StringStripWS(StringUpper($acommand[9]), 2)
				$value9 = StringStripWS(StringUpper($acommand[10]), 2)

				If $command = "SIDE" Then
					;forced side
					If StringUpper($value8) = "TOP-LEFT" Or StringUpper($value8) = "TOP-RIGHT" Or StringUpper($value8) = "BOTTOM-LEFT" Or StringUpper($value8) = "BOTTOM-RIGHT" Then
						;keep original values
					Else
						;if this line uses a building, then it must be detected
						If Int($value1) > 0 Then $attackcsv_locate_mine = 1
						If Int($value2) > 0 Then $attackcsv_locate_elixir = 1
						If Int($value3) > 0 Then $attackcsv_locate_drill = 1
						If Int($value4) > 0 Then $attackcsv_locate_gold_storage = 1
						If Int($value5) > 0 Then $attackcsv_locate_elixir_storage = 1
						If Int($value6) > 0 Then $attackcsv_locate_dark_storage = 1
						If Int($value7) > 0 Then $attackcsv_locate_townhall = 1

					EndIf

				EndIf
			EndIf
		WEnd
		FileClose($f)
	Else
		SetLog("Cannot find attack file " & $dirAttacksCSV & "\" & $filename & ".csv", $color_red)
	EndIf
EndFunc   ;==>ParseAttackCSV_Read_SIDE_variables
