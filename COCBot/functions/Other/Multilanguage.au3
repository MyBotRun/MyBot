; #FUNCTION# ====================================================================================================================
; Name ..........: Multilanguage
; Description ...: This file contains functions to read and write the Multilanguage .ini files and Translate the texts
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-11), Hervidero (2015-11)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global Const $dirLanguages = @ScriptDir & "\languages\"
Global $sLanguage = "English"
Global Const $sDefaultLanguage = "English"
Global $aLanguage[1][1] ;undimmed language array

Func GetTranslated($iSection = -1, $iKey = -1, $sText = "")
	;If GetTranslated was called without correct parameters return value -2 to show the coder there is a mistake made somewhere (debug)
	If $iSection = -1 Or $iKey = -1 Or $sText = "" Then Return "-2"

	Local $bOutBound = False
	If $iSection >= Ubound($aLanguage, $UBOUND_ROWS) Or $iKey >= Ubound($aLanguage, $UBOUND_COLUMNS) Then $bOutBound = True
	If $bOutBound = True Then ReDim $aLanguage[$iSection + 1][$iKey + 1]

	If $aLanguage[$iSection][$iKey] <> "" Then Return $aLanguage[$iSection][$iKey] ; Return from array if it was already parsed.

	If $sLanguage = $sDefaultLanguage Then ; default English
		Local $sDefaultText = IniRead($dirLanguages & $sDefaultLanguage & ".ini", $iSection, $iKey, $sText)

		If $sText = "-1" Then
			$aLanguage[$iSection][$iKey] = $sDefaultText
			Return $sDefaultText ; will also return "-1" as debug if english.ini does not contain the correct section/key
		EndIf

		If $sDefaultText <> $sText Then
			IniWrite($dirLanguages & $sDefaultLanguage & ".ini", $iSection, $iKey, $sText) ; Rewrite Default English.ini with new text value
			$aLanguage[$iSection][$iKey] = $sText
			Return $sText
		Else
			$aLanguage[$iSection][$iKey] = $sDefaultText
			Return $sDefaultText
		EndIf
	Else ; translated language
		Local $sLanguageText = IniRead($dirLanguages & $sLanguage & ".ini", $iSection, $iKey, "-3")

		If $sText = "-1" Then
			Local $sDefaultText = IniRead($dirLanguages & $sDefaultLanguage & ".ini", $iSection, $iKey, $sText)
			If $sLanguageText = "-3" Then
				$aLanguage[$iSection][$iKey] = $sDefaultText
				Return $sDefaultText ; will also return "-1" as debug if english.ini does not contain the correct section/key
			Else
				$aLanguage[$iSection][$iKey] = $sLanguageText
				Return $sLanguageText
			EndIf
		EndIf

		If $sLanguageText = "-3" Then
			IniWrite($dirLanguages & $sLanguage & ".ini", $iSection, $iKey, $sText) ; Rewrite Language.ini with new untranslated Default text value
			$aLanguage[$iSection][$iKey] = $sText
			Return $sText
		EndIf

		$aLanguage[$iSection][$iKey] = $sLanguageText
		Return $sLanguageText
	EndIf
EndFunc   ;==>GetTranslated
