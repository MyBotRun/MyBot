; #FUNCTION# ====================================================================================================================
; Name ..........: Slice8
; Description ...:
; Syntax ........: Slice8($pixel)
; Parameters ....: $pixel               - pixel array
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Slice8($pixel)
	If UBound($pixel) < 2 Then Return "0_NO_ARRAY" ;exit
	If $pixel[0] < $ExternalArea[0][0] Or $pixel[0] > $ExternalArea[1][0] Or $pixel[1] < $ExternalArea[2][1] Or $pixel[1] > $ExternalArea[3][1] Then
		; PIXEL OUT OF AREA
		Return "0_O"
	Else
		If $pixel[0] <= $ExternalArea[2][0] Then
			If $pixel[1] <= $ExternalArea[0][1] Then
				;TOP-LEFT, slices 5 and 6
				If $pixel[0] <= $ExternalArea[4][0] Then ; slice 6 external
					If ($ExternalArea[4][0] - $pixel[0]) / ($ExternalArea[4][0] - $ExternalArea[0][0]) + ($ExternalArea[0][1] - $pixel[1]) / ($ExternalArea[0][1] - $ExternalArea[4][1]) <= 1 Then
						Return "6E"
					Else
						Return "0_6E"
					EndIf
				Else
					If ($pixel[0] - $ExternalArea[4][0]) / ($ExternalArea[2][0] - $ExternalArea[4][0]) + ($ExternalArea[0][1] - $pixel[1]) / ($ExternalArea[0][1] - $ExternalArea[4][1]) <= 1 Then
						Return "6_I"
					Else
						If ($ExternalArea[2][0] - $pixel[0]) / ($ExternalArea[2][0] - $ExternalArea[4][0]) + Abs($ExternalArea[4][1] - $pixel[1]) / ($ExternalArea[0][1] - $ExternalArea[4][1]) <= 1 Then
							If $pixel[1] <= $ExternalArea[4][1] Then
								Return "5_E"
							Else
								Return "5_I"
							EndIf
						Else
							Return "O_5"
						EndIf
					EndIf
				EndIf
			Else
				;BOTTOM-LEFT slices 7 and 8
				If $pixel[0] <= $ExternalArea[6][0] Then ; slice 7 external
					If ($ExternalArea[6][0] - $pixel[0]) / ($ExternalArea[6][0] - $ExternalArea[0][0]) + ($pixel[1] - $ExternalArea[0][1]) / ($ExternalArea[6][1] - $ExternalArea[0][1]) <= 1 Then
						Return "7_E"
					Else
						Return "0_7"
					EndIf
				Else
					If ($pixel[0] - $ExternalArea[6][0]) / ($ExternalArea[2][0] - $ExternalArea[6][0]) + ($pixel[1] - $ExternalArea[0][1]) / ($ExternalArea[6][1] - $ExternalArea[0][1]) <= 1 Then
						Return "7_I"
					Else
						If ($ExternalArea[2][0] - $pixel[0]) / ($ExternalArea[2][0] - $ExternalArea[6][0]) + Abs($ExternalArea[6][1] - $pixel[1]) / ($ExternalArea[6][1] - $ExternalArea[0][1]) <= 1 Then
							If $pixel[1] <= $ExternalArea[6][1] Then
								Return "8_I"
							Else
								Return "8_E"
							EndIf
						Else
							Return "0_8"
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			If $pixel[1] <= $ExternalArea[0][1] Then
				;TOP-RIGHT slices 3 and 4
				If $pixel[0] > $ExternalArea[5][0] Then ; slice 3 external
					If ($pixel[0] - $ExternalArea[5][0]) / ($ExternalArea[1][0] - $ExternalArea[5][0]) + ($ExternalArea[0][1] - $pixel[1]) / ($ExternalArea[0][1] - $ExternalArea[5][1]) <= 1 Then
						Return "3_E"
					Else
						Return "0_3"
					EndIf
				Else
					If ($ExternalArea[5][0] - $pixel[0]) / ($ExternalArea[5][0] - $ExternalArea[2][0]) + ($ExternalArea[0][1] - $pixel[1]) / ($ExternalArea[0][1] - $ExternalArea[5][1]) <= 1 Then
						Return "3_I"
					Else
						If ($pixel[0] - $ExternalArea[2][0]) / ($ExternalArea[5][0] - $ExternalArea[2][0]) + Abs($ExternalArea[5][1] - $pixel[1]) / ($ExternalArea[0][1] - $ExternalArea[5][1]) <= 1 Then
							If $pixel[1] <= $ExternalArea[5][1] Then
								Return "4_E"
							Else
								Return "4_I"
							EndIf
						Else
							Return "0_4"
						EndIf
					EndIf
				EndIf
			Else
				;BOTTOM-RIGHT slices 1 and 2
				If $pixel[0] > $ExternalArea[7][0] Then ; slice 2 external
					If ($pixel[0] - $ExternalArea[7][0]) / ($ExternalArea[1][0] - $ExternalArea[7][0]) + ($pixel[1] - $ExternalArea[0][1]) / ($ExternalArea[7][1] - $ExternalArea[0][1]) <= 1 Then
						Return "2_E"
					Else
						Return "0_2"
					EndIf
				Else
					If ($ExternalArea[7][0] - $pixel[0]) / ($ExternalArea[7][0] - $ExternalArea[3][0]) + ($pixel[1] - $ExternalArea[0][1]) / ($ExternalArea[7][1] - $ExternalArea[0][1]) <= 1 Then
						Return "2_I"
					Else
						If ($pixel[0] - $ExternalArea[3][0]) / ($ExternalArea[7][0] - $ExternalArea[3][0]) + Abs($ExternalArea[7][1] - $pixel[1]) / ($ExternalArea[7][1] - $ExternalArea[0][1]) <= 1 Then
							If $pixel[1] <= $ExternalArea[7][1] Then
								Return "1_I"
							Else
								Return "1_E"
							EndIf
						Else
							Return "0_1"
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>Slice8
