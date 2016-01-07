; #FUNCTION# ====================================================================================================================
; Name ..........: Recruit
; Description ...:
; Syntax ........: Recruit()
; Parameters ....:
; Return values .: None
; Author ........: paspiz85
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Recruit()

	Local $f , $line, $acommand, $command
 	If FileExists($fileRecruitMessages) Then
		$f = FileOpen($dirTHSnipesAttacks & "\" &$scmbAttackTHType & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			;Setlog("line content: " & $line)
		WEnd
		FileClose($f)
	Else
		SetLog("Recuitment disabled, file not found " & $fileRecruitMessages , $COLOR_ORANGE)
	EndIf

EndFunc   ;==>Recruit
