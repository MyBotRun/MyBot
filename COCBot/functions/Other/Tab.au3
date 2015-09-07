Func Tab($a, $b)
	$Tab = ""
	For $i = StringLen($a) To $b Step 1
		$Tab &= " "
	Next
	Return $Tab
EndFunc   ;==>Tab