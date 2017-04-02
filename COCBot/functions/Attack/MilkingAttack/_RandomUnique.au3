;#FUNCTION# ====================================================================================================================
; Version........: 1.1 - 2011/11/24
; Name...........: _RandomUnique
; Description ...: Returns an array of unique random numbers
; Syntax.........: _RandomUnique($iCount, $nMin, $nMax, [$iInt = 0, [$nSeed = Default]])
; Parameters ....: $iCount  - The amount of numbers to generate Number between 1 and 10^6-1
;                 $nMin   - The smallest number to be generated. Number between -2^31 and 2^31-1
;                 $nMax   - The largest number to be generated. Number between -2^31 and 2^31-1
;                 $iInt   - [optional] If this is set to 1 then an integer result will be returned. Default is a floating point number.
;                 $nSeed     - [optional] Seed value for random number generation. Number between -2^31 and 2^31-1
; Return values .: Success  - Returns a 1-dimensional array containing only unique numbers
;                            $Array[0] = count of generated numbers
;                            $Array[1] = first number
;                            $Array[2] = second number, etc
;                Failure     - Returns 0 and sets @error:
;                               | 1 - $iCount is too small
;                               | 2 - $iCount is too large
;                               | 3 - $nMin and $nMax are equal
;                               | 4 - $nMin is larger than $nMax
;                               | 5 - $nMin or $nMax exceeds limit
;                               | 6 - $nSeed exceeds limit
; Author ........: Money (AutoIt Forums)
; Modified.......:
; Remarks .......:  If $iInt is 1 and $iCount exceeds total unique numbers than @extend is set to 1 and item count is adjusted to the
;                  + maximum numbers that can be returned
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func _RandomUnique($iCount, $nMin, $nMax, $iInt = 0, $nSeed = Default)
	; error checking
	Select
		; $iCount is too small
		Case ($iCount < 1)
			Return SetError(1, 0, 0)
			; $iCount is too large
		Case ($iCount > 10 ^ 6 - 1)
			Return SetError(2, 0, 0)
			; $nMin and $nMax cannot be equal
		Case ($nMin = $nMax)
			Return SetError(3, 0, 0)
			; $nMin cannot be larger than $nMax
		Case ($nMin > $nMax)
			Return SetError(4, 0, 0)
			; $nMin or $nMax exceeds limit
		Case (($nMin < -2 ^ 31) Or ($nMax > 2 ^ 31 - 1))
			Return SetError(5, 0, 0)
	EndSelect
	; user specific seed
	If IsNumber($nSeed) Then
		; $nSeed exceeds limit
		If (($nSeed < -2 ^ 31) Or ($nSeed > 2 ^ 31 - 1)) Then Return SetError(6, 0, 0)
		SRandom($nSeed)
	EndIf
	; $iCount is equal too or exceeds maximum possible unique values
	Local $iCountInval = 0
	If ($iInt) Then
		; positive
		If ($nMin >= 0) Then
			If ($iCount > ($nMax - $nMin) + 1) Then
				$iCountInval = 1
			ElseIf ($iCount = ($nMax - $nMin) + 1) Then
				$iCountInval = 3
			EndIf
			; negative to positive
		Else
			If ($iCount > ($nMax + Abs($nMin) + 1)) Then
				$iCountInval = 2
			ElseIf ($iCount = ($nMax + Abs($nMin) + 1)) Then
				$iCountInval = 3
			EndIf
		EndIf
	EndIf
	; courtesy
	If ($iInt And $iCount = 1) Then
		Local $aArray[2] = [1, Random($nMin, $nMax, $iInt)]
		; $iCount is too large so we will generate as much we can from $nMin to $nMax values
	ElseIf $iCountInval Then
		If $iCountInval = 1 Then
			$iCount = Int($nMax - $nMin) + 1
		ElseIf $iCountInval = 2 Then
			$iCount = Int($nMax + Abs($nMin)) + 1
		EndIf
		; $iCount is equal to total unique numbers
		If $iCountInval = 3 Then $iCountInval = 0
		Local $aTmp, $iA, $iNumber = $nMin, $aArray[$iCount + 1] = [$iCount]
		; add our numbers sequentially (from $iMin to $iMax)
		For $i = 1 To $aArray[0]
			$aArray[$i] = $iNumber
			$iNumber += 1
		Next
		; swap every x index value with a random index value
		For $i = 1 To $aArray[0]
			$iA = Random($i, $aArray[0], 1)
			If $i = $iA Then ContinueLoop
			If $iA = 0 Then $iA = $aArray[0]
			$aTmp = $aArray[$i]
			$aArray[$i] = $aArray[$iA]
			$aArray[$iA] = $aTmp
		Next
	Else
		; everything else is ok, generate unique numbers
		Local $nRnd, $iStep = 0, $aArray[$iCount + 1] = [$iCount]
		While ($iStep <= $iCount - 1)
			$nRnd = Random($nMin, $nMax, $iInt)
			; check if the number already exist
			If IsDeclared($nRnd) <> -1 Then
				$iStep += 1
				$aArray[$iStep] = $nRnd
				; store our numbers in a local variable
				Assign($nRnd, '', 1)
			EndIf
		WEnd
	EndIf
	Return SetError(0, Number($iCountInval > 0), $aArray)
EndFunc   ;==>_RandomUnique
