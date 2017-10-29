; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseReport()
; Description ...: Make Resources report of Builders Base
; Syntax ........: BuilderBaseReport()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BuilderBaseReport()

	; coc-ms [GOLD][ELIXIR][GEMS][Trophies]
	; coc-Builders [Builders]

	; [0] = Trophies , [1] = Gold , [2] = Elixir , [3] = Builder available
	; [0] = OCR name , [1] = X , [2] = Y , [3] = length
	Local Const $a_ReScreenPosition[4][4] = [["coc-ms", 67, 84, 135], ["coc-ms", 705, 23, 101], ["coc-ms", 705, 72, 101], ["coc-Builders", 410, 23, 40]]

	For $i = 0 To 3 ; all 3 Resources  + Available Builder
		Local $_sReturn = getResourcesBuilderBase($a_ReScreenPosition[$i][0], $a_ReScreenPosition[$i][1], $a_ReScreenPosition[$i][2], $a_ReScreenPosition[$i][3])
		Switch $i
			Case 0
				If $_sReturn <> "" Then $g_iTrophiesBB = Number($_sReturn)
				GUICtrlSetData($g_alblBldBaseStats[$eLootTrophy], _NumberFormat($g_iTrophiesBB))
			Case 1
				If $_sReturn <> "" Then $g_iGoldBB = Number($_sReturn)
				GUICtrlSetData($g_alblBldBaseStats[$eLootGold], _NumberFormat($g_iGoldBB))
			Case 2
				If $_sReturn <> "" Then $g_iElixirBB = Number($_sReturn)
				GUICtrlSetData($g_alblBldBaseStats[$eLootElixir], _NumberFormat($g_iElixirBB))
			Case 3
				If $_sReturn <> "" Then
					Local $a_Temp = StringSplit($_sReturn, "#", $STR_NOCOUNT)
					$g_aBuilder[0] = UBound($a_Temp) = 2 ? Number($a_Temp[0]) : 0
					$g_aBuilder[1] = UBound($a_Temp) = 2 ? Number($a_Temp[1]) : 0
					If UBound($a_Temp) <> 2 Then Setlog("Master Builder OCR issue!", $COLOR_ERROR)
				EndIf
		EndSwitch
	Next
EndFunc   ;==>BuilderBaseReport

Func getResourcesBuilderBase($OCRname, $x_start, $y_start, $length) ; -> Gets Resources on Builder Base
	Return getOcrAndCapture($OCRname, $x_start, $y_start, $length, 18, True)
EndFunc   ;==>getResourcesBuilderBase



