;
; #FUNCTION# ====================================================================================================================
; Name ..........: BS1BackButton
; Description ...: Sends ESC key shorcut to BS for back button on menu
; Syntax ........: BS1BackButton()
; Parameters ....:
; Return values .: False if controlsend error
; Author ........: MonkeyHunter (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BS1BackButton()
    If Not $RunState Then Return False
	SendAdbCommand("shell input keyevent 4")
	If $DebugSetLog = 1 Then Setlog("Used Adb to press back button", $COLOR_BLUE)
	Return True
EndFunc   ;==>BS1BackButton

;
; #FUNCTION# ====================================================================================================================
; Name ..........: BS1HomeButton
; Description ...: Sends Home key shorcut to BS for Home button on menu
; Syntax ........: BS1HomeButton()
; Parameters ....:
; Return values .: False if controlsend error
; Author ........: MonkeyHunter (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BS1HomeButton()
    If Not $RunState Then Return False
	SendAdbCommand("shell input keyevent 3")
	If $DebugSetLog = 1 Then Setlog("Used Adb to press home button", $COLOR_BLUE)
	Return True
EndFunc   ;==>BS1HomeButton
