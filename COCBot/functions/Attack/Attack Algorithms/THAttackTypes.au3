; #FUNCTION# ==========================================================
; Name ..........: THAttackTypes
; Description ...: This file contens the TH attacks
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: AtoZ (2015)
; Modified ......: Barracoda (July 2015), TheMaster 2015-10
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ================================================================

Func SwitchAttackTHType()
   $THusedKing= 0
   $THusedQueen=0
	AttackTHParseCSV()
EndFunc   ;==>SwitchAttackTHType

Func AttackTHParseCSV($test=False)
	If $debugsetlog=1 Then Setlog("AttackTHParseCSV start",$COLOR_PURPLE)
	Local $f , $line, $acommand, $command, $isTownHallDestroy

	;Noyax top
	Local $Gold1 = getGoldVillageSearch(48, 69)
	Local $Elixir1 = getElixirVillageSearch(48, 69 + 29)
	;Noyax bottom

 	If FileExists($dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv") Then
		$f = FileOpen($dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv", 0)
    $isTownHallDestroy = false
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			;Setlog("line content: " & $line)
			$acommand = StringSplit($line,"|")
			if $acommand[0] >=8 Then
				$command = StringStripWS (StringUpper( $acommand[1] ),2)
				;   $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell
				Select
					Case $command = "TROOP"  or $command = ""
						;Setlog("<<<<discard line>>>>")
					Case $command = "TEXT"
						If $debugSetLog = True Then Setlog(">> SETLOG(""" & $acommand[8] & """)")

							SetLog($acommand[8] ,$COLOR_BLUE)

					Case StringInStr(StringUpper("-Barb-Arch-Giant-Gobl-Wall-Ball-Wiza-Heal-Drag-Pekk-Mini-Hogs-Valk-Gole-Witc-Lava-"), "-" & $command & "-") >0
						;If $debugSetLog = True Then Setlog(">> AttackTHGrid($e" &$command&", Random (" &  Int($acommand[2])&"," & int($acommand[3])&",1), Random("& int($acommand[4])&"," & int($acommand[5])&",1), Random(" & int($acommand[6]) &"," & int($acommand[7])& ",1) )" )
;Noyax						AttackTHGrid(Eval("e" & $command), Random(Int($acommand[2]), Int($acommand[3]), 1), Random(Int($acommand[4]), Int(2), 1), Random(Int($acommand[6]), Int($acommand[7]), 1))
						AttackTHGrid(Eval("e" & $command), Int($acommand[2]), Int($acommand[4]), Int($acommand[6]))
							
					Case $command = "WAIT"
						If $debugSetLog = True Then Setlog(">> ThSnipeWait(" &int($acommand[7])  & ") " )

							$isTownHallDestroy = ThSnipeWait( Int($acommand[7]) )

					Case StringInStr(StringUpper("-King-Queen-Castle-"), "-" & $command & "-") >0
						If $debugSetLog = True Then Setlog(">> AttackTHGrid($e"&$command & ")" )

							AttackTHGrid( Eval("e"&$command ) )

					Case StringInStr(StringUpper("-HSpell-RSpell-"), "-" & $command & "-") >0
						If $debugSetLog = True Then Setlog(">> SpellTHGrid($e"&$command & ")" )

							SpellTHGrid( Eval("e"& $command ) )

					Case StringInStr(StringUpper("-LSpell-"), "-" & $command & "-") >0
						If $debugSetLog = True Then Setlog(">> CastSpell($e"&$command & ",$THx, $THy)" )

							CastSpell(Eval("e"&$command) ,$THx, $THy )

					Case Else
						Setlog("attack row bad, discard: " & $line,$COLOR_RED)
				    EndSelect
				   if $acommand[8] <> "" and $command <> "TEXT"  and $command <>"TROOP" then
						If $debugSetLog = True Then Setlog(">> SETLOG(""" & $acommand[8] & """)")
							SETLOG( $acommand[8] ,$COLOR_BLUE)
					EndIf
			Else
				if StringStripWS( $acommand[1],2  ) <>"" Then  Setlog("attack row error, discard: " & $line,$COLOR_RED)
			EndIf
			If $isTownHallDestroy = true Then ExitLoop
		WEnd
		FileClose($f)
	Else
		SetLog("Cannot found THSnipe attack file " & $dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv" , $color_red)
	EndIf
	
	If $isTownHallDestroy = true Then TestLoots($Gold1, $Elixir1) ;Noyax

EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: ThSnipeWait
; Description ...: Waiting for x milliseconds or until the destruction of the town hall
; Syntax ........: ThSnipeWait(x milliseconds)
; Parameters ....: $delay milliseconds to wait
; Return values .: Return true if the town hall has been destroyed else false
; Author ........: MereDoku
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Example .......: $isTownHallDestroy = ThSnipeWait( 20000 )
; ===============================================================================================================================
Func ThSnipeWait($delay)
	Local $ts, $td
  
  Setlog("Waiting for " & $delay & " milliseconds or until the destruction of the town hall")
  
  $ts = TimerInit()  
  $td = 0

  While $td < $delay 
     _Sleep(1000)
  	If CheckOneStar(0, True, False) Then
;noyax       While GoldElixirChangeEBO()
;noyax    	  _Sleep(1000)
;       WEnd
       Return true
  	EndIf
    $td = TimerDiff($ts)
  WEnd
  Return false
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: TestLoots
; Description ...: test loot when Th fall
; Syntax ........: 
; Parameters ....: 
; Return values .: 
; Author ........: Noyax37 
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Example .......: 
; ===============================================================================================================================
Func TestLoots($Gold1 = 0, $Elixir1 = 0)

	Local $Gold2 = getGoldVillageSearch(48, 69)
	Local $Elixir2 = getElixirVillageSearch(48, 69 + 29)
	Local $Ggold = 0
	$Ggold = $Gold1 - $Gold2
	Local $Gelixir = 0
	$Gelixir = $Elixir1 - $Elixir2
	Setlog ("Gold loots = " & $Gold1 & " - " & $Gold2 & " = " & $Ggold)
	Setlog ("% Gold = 100 * " & $Ggold & " / " & $Gold1 & " = " & Round(100 * $Ggold / $Gold1, 1))
	Setlog ("Elixir loots = " & $Elixir1 & " - " & $Elixir2 & " = " & $Gelixir)
	Setlog ("% Elixir = 100 * " & $Gelixir & " / " & $Elixir1 & " = " & Round(100 * $Gelixir / $Elixir1, 1))
	If Round(100 * $Ggold / $Gold1, 1) < $iPercentThsn Or Round(100 * $Gelixir / $Elixir1, 1) < $iPercentThsn Then 
		Setlog ("Go to attack this dead base")
		If $zoomedin = True Then
			ZoomOut()
			$zoomedin = False
			$zCount = 0
			$sCount = 0
		EndIf
;		$TestLoots = True
		$iMatchMode = $DB
		PrepareAttack($iMatchMode)
		If $Restart = True Then 
			$TestLoots = False
			$iMatchMode = $TS
			Return
		EndIf
;		Attack()
;		$TestLoots = False
;		$iMatchMode = $TS
		Return
	EndIf
	
EndFunc
