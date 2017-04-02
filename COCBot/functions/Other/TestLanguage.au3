; #FUNCTION# ====================================================================================================================
; Name ..........: TestLanguage
; Description ...: This function tests if the game is in english language
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-06)
; Modified ......: Hervidero(2015)
;
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func TestLanguage()
	If $g_bRunState Then
		; test "builder" word top of sceen
		If getOcrLanguage($aDetectLang[0], $aDetectLang[1]) = "english" Then
			Setlog("Language setting is English: Correct.", $COLOR_INFO)
		Else
			SetLog("Language setting is Wrong: Change CoC language to English!", $COLOR_ERROR)
			btnStop()
		EndIf
	EndIf
EndFunc   ;==>TestLanguage
