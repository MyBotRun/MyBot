; #FUNCTION# ====================================================================================================================
; Name ..........: BarracksStatus
; Description ...: Determines which barracks are viable for training troops
; Syntax ........: BarracksStatus([$showlog = false])
; Parameters ....: $showlog             - [optional] Flad to display barracks status. Default is false.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (July 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BarracksStatus($showlog = False)

	Local $COLOR_AVAIABLE = "0x888070"
	Local $COLOR_UPGRADING = "0x6b6964"
	Local $COLOR_EMPTYSLOT = "0x58514D"

	$numBarracks = 0
	$numBarracksAvaiables = 0
	$numDarkBarracks = 0
	$numDarkBarracksAvaiables = 0
	$numFactorySpell = 0
	$numFactorySpellAvaiables = 0
	$numFactoryDarkSpell = 0
	$numFactoryDarkSpellAvaiables = 0


	If $debugsetlogTrain = 1 Then Setlog("start barrackstatus", $COLOR_PURPLE)
	; VERIFY HOW MUCH BARRACK ARE READY
	Local $i = 0
	While Not _ColorCheck(_GetPixelColor($btnpos[0][0], $btnpos[0][1], True), Hex(0xE8E8E0, 6), 20)
		If $debugsetlogTrain = 1 Then Setlog("search color pos0 army overview... " & $i, $COLOR_PURPLE)
		If _Sleep($iDelayBarracksStatus1) Then Return
		$i += 1
		If $i > 10 Then ExitLoop
	WEnd
	If $debugsetlogTrain = 1 Then
		If $i > 10 Then
			Setlog("BarrackStatus Warning #1", $COLOR_PURPLE)
		Else
			Setlog("OK, I'm in army overview", $COLOR_PURPLE)
		EndIf
	EndIf
	If _sleep($iDelayBarracksStatus2) Then Return

	For $i = 1 To 4
		If _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex($COLOR_AVAIABLE, 6), 20) Then
			If $debugsetlogTrain = 1 Then Setlog("barrack " & $i & " found! color " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
			$numBarracks += 1
			$numBarracksAvaiables += 1
			$Trainavailable[$i] = 1
		ElseIf _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex($COLOR_UPGRADING, 6), 20) Then
			If $debugsetlogTrain = 1 Then Setlog("barrack " & $i & " found upgrading! color " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
			$numBarracks += 1
			$numBarracksAvaiables += 0
			$Trainavailable[$i] = 0
		Else
			If $debugsetlogTrain = 1 Then Setlog("barrack " & $i & " NO found, color = " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
			$numBarracks += 0
			$numBarracksAvaiables += 0
			$Trainavailable[$i] = 0
		EndIf
	Next

	For $i = 5 To 6
		If _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex($COLOR_AVAIABLE, 6), 20) Then
			If $debugsetlogTrain = 1 Then Setlog("dark barrack " & $i - 4 & " found! color " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
			$numDarkBarracks += 1
			$numDarkBarracksAvaiables += 1
			$Trainavailable[$i] = 1
		ElseIf _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex($COLOR_UPGRADING, 6), 20) Then
			If $debugsetlogTrain = 1 Then Setlog("dark barrack " & $i - 1 & " found upgrading! color " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
			$numDarkBarracks += 1
			$numDarkBarracksAvaiables += 0
			$Trainavailable[$i] = 0
		Else
			If $debugsetlogTrain = 1 Then Setlog("dark barrack " & $i - 2 & " NO found, color = " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
			$numDarkBarracks += 0
			$numDarkBarracksAvaiables += 0
			$Trainavailable[$i] = 0
		EndIf
	Next

	$i = 7
	If _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex($COLOR_AVAIABLE, 6), 20) Then
		If $debugsetlogTrain = 1 Then Setlog("Factory Spell found! color " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
		$numFactorySpell += 1
		$numFactorySpellAvaiables += 1
		$Trainavailable[$i] = 1
	ElseIf _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex($COLOR_UPGRADING, 6), 20) Then
		If $debugsetlogTrain = 1 Then Setlog("Factory spell found upgrading! color " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
		$numFactorySpell += 1
		$numFactorySpellAvaiables += 0
		$Trainavailable[$i] = 0
	Else
		If $debugsetlogTrain = 1 Then Setlog("Factory spell NO found, color = " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
		$numFactorySpell += 0
		$numFactorySpellAvaiables += 0
		$Trainavailable[$i] = 0
	EndIf

	$i = 8
	If _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex($COLOR_AVAIABLE, 6), 20) Then
		If $debugsetlogTrain = 1 Then Setlog("Dark Factory Spell found! color " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
		$numFactoryDarkSpell += 1
		$numFactoryDarkSpellAvaiables += 1
		$Trainavailable[$i] = 1
	ElseIf _ColorCheck(_GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), Hex($COLOR_UPGRADING, 6), 20) Then
		If $debugsetlogTrain = 1 Then Setlog("Dark Factory spell found upgrading! color " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
		$numFactoryDarkSpell += 1
		$numFactoryDarkSpellAvaiables += 0
		$Trainavailable[$i] = 0
	Else
		If $debugsetlogTrain = 1 Then Setlog("Dark Factory spell NO found, color = " & _GetPixelColor($btnpos[$i][0], $btnpos[$i][1], True), $COLOR_PURPLE)
		$numFactorySpell += 0
		$numFactorySpellAvaiables += 0
		$Trainavailable[$i] = 0
	EndIf

	If $showlog = True Or $debugsetlogTrain = 1 Then
		SetLog("Barracks and Spell factory status: ", $COLOR_GREEN)
		SetLog("- Barracks detected: " & $numBarracks & " | Available: " & $numBarracksAvaiables & " | Upgrading: " & $numBarracks - $numBarracksAvaiables, $COLOR_GREEN)
		SetLog("- Dark Barracks detected: " & $numDarkBarracks & " | Available: " & $numDarkBarracksAvaiables & " | Upgrading: " & $numDarkBarracks - $numDarkBarracksAvaiables, $COLOR_GREEN)
		Setlog("- Spell factory detected: " & $numFactorySpell & " | Available: " & $numFactorySpellAvaiables & " | Upgrading: " & $numFactorySpell - $numFactorySpellAvaiables, $COLOR_GREEN)
		Setlog("- Dark Spell factory detected: " & $numFactoryDarkSpell & " | Available: " & $numFactoryDarkSpellAvaiables & " | Upgrading: " & $numFactoryDarkSpell - $numFactoryDarkSpellAvaiables, $COLOR_GREEN)
	EndIf

	If $debugsetlogTrain = 1 Then
		Local $txt = ""
		For $i = 0 To UBound($Trainavailable) - 1
			$txt &= $Trainavailable[$i] & " "
		Next
		SetLog("Trainavailable = " & $txt, $COLOR_PURPLE)
	EndIf

EndFunc   ;==>BarracksStatus
