
; #FUNCTION# ====================================================================================================================
; Name ..........: SearchTownHallLoc
; Description ...:
; Syntax ........: SearchTownHallLoc()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #5
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SearchTownHallLoc()
   If $searchTH <> "-" Then
 		 If isInsideDiamondXY( $THx,$THy)=False Then Return False

	  For $i=0 to 20

		 If $Thx<114+$i*19+ceiling(($THaddtiles-2)/2*19) And $Thy<359-$i*14+ceiling(($THaddtiles-2)/2*14) Then
			$THi=$i
			$THside=0
			Return True
		 EndIf
		 If $Thx<117+$i*19+ceiling(($THaddtiles-2)/2*19) And $Thy>268+$i*14-floor(($THaddtiles-2)/2*14) Then
			$THi=$i
			$THside=1
			Return True
		 EndIf
		 If $Thx>743-$i*19-floor(($THaddtiles-2)/2*19) And $Thy<358-$i*14+ceiling(($THaddtiles-2)/2*14) Then
			$THi=$i
			$THside=2
			Return True
		 EndIf
		 If $Thx>742-$i*19-floor(($THaddtiles-2)/2*19) And $Thy>268+$i*14-floor(($THaddtiles-2)/2*14) Then
			$THi=$i
			$THside=3
			Return True
		 EndIf
		 Next
   EndIf
	Return False
EndFunc ;--- SearchTownHallLoc

;~ Func FilterTH()
;~    	  For $i=0 to 20
;~ 		 If $Thx<52+$i*19 And $Thy<315-$i*14 Then Return False
;~ 		 If $Thx<52+$i*19 And $Thy>315+$i*14 Then Return False
;~  		 If $Thx>802-$i*19 And $Thy<315-$i*14 Then Return False
;~ 		 If $Thx>802-$i*19 And $Thy>315+$i*14 Then Return False
;~ 	  Next
;~ 			Return True
;~ EndFunc

