; #FUNCTION# ====================================================================================================================
; Name ..........: ChkAttackCSVConfig
; Description ...:
; Syntax ........: ChkAttackCSVConfig()
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
Func ChkAttackCSVConfig()
	;check if exists attackscript Files
	If Not (FileExists($dirAttacksCSV & "\" & $scmbDBScriptName & ".csv")) Then
		Setlog("Dead base scripted attack file do not exists (renamed, deleted?)", $COLOR_RED)
		SetLog("Please select a new scripted algorithm from 'scripted attack' tab", $COLOR_RED)
		PopulateComboScriptsFilesDB()
		btnStop()
	EndIf
	If Not (FileExists($dirAttacksCSV & "\" & $scmbABScriptName & ".csv")) Then
		Setlog("Dead base scripted attack file do not exists (renamed, deleted?)", $COLOR_RED)
		SetLog("Please select a new scripted algorithm from 'scripted attack' tab", $COLOR_RED)
		PopulateComboScriptsFilesAB()
		btnStop()
	EndIf

EndFunc   ;==>ChkAttackCSVConfig
