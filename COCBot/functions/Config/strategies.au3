; #FUNCTION# ====================================================================================================================
; Name ..........: strategies.au3
; Description ...: Reads config file and sets variables
; Syntax ........: IniReadS() and IniWriteS
; Parameters ....: NA
; Return values .: NA
; Author ........: Sardo (03/2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func IniReadS(ByRef $variable, $PrimaryInputFile, $section, $key, $defaultvalue, $valueType = Default)
	;read from standard config ini file but, if variable $SecondaryInputFile <>"" (valorized by button read strategy), if exists
	;section->key override values from ini files with values in $SecondaryInputFile
	Local $defaultvalueTest = "?"
	Local $readValue = IniRead($SecondaryInputFile, $section, $key, $defaultvalueTest)
	If $readValue = $defaultvalueTest Then
		$readValue = IniRead($PrimaryInputFile, $section, $key, $defaultvalue)
	EndIf
	Switch $valueType
		Case Default
			; no conversion
			$variable = $readValue
		Case "Int"
			; convert to Int
			$variable = Int($readValue)
		Case Else
			; Unsupported type
			$variable = $readValue
	EndSwitch
EndFunc   ;==>IniReadS


Func IniWriteS($filename, $section, $key, $value)
	;save in standard config files and also save settings in strategy ini file (save strategy button valorize variable $SecondaryOutputFile )
	Local $s = $section
	Local $k = $key
	IniWrite($filename, $section, $key, $value)
	If $SecondaryOutputFile <> "" Then
		If $s = "search" Or $s = "attack" Or $s = "troop" Or $s = "spells" Or $s = "milkingattack" Or $s = "endbattle" or $s = "collectors" or ($s = "general" And $k = "version") Then
			IniWrite($SecondaryOutputFile, $section, $key, $value)
		EndIf
	EndIf
EndFunc   ;==>IniWriteS
