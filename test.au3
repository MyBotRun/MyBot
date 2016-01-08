#include "Array.au3"

Func ZeroArray(ByRef $array)
	For $i = 0 To UBound($array) - 1
		$array[$i] = 0
	Next
EndFunc

