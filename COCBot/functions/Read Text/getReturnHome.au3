;Returns complete value of other

Func getReturnHome($x_start, $y_start, $type)

    Local $x = $x_start, $y = $y_start
    Local $Number, $i = 0

    Switch $type

        Case "ReturnResource"
            $Number = getDigitLarge($x, $y, "ReturnHome")

            While $Number = ""
                If $i >= 120 Then ExitLoop
                $i += 1
                $x -= 1
                $Number = getDigitLarge($x, $y, "ReturnHome")
            WEnd

            $Number = getDigitLarge($x, $y, "ReturnHome") & $Number
            $Number = getDigitLarge($x, $y, "ReturnHome") & $Number
            $Number = getDigitLarge($x, $y, "ReturnHome") & $Number
            $x -= 7
            $Number = getDigitLarge($x, $y, "ReturnHome") & $Number
            $Number = getDigitLarge($x, $y, "ReturnHome") & $Number
            $Number = getDigitLarge($x, $y, "ReturnHome") & $Number
            $x -= 7
            $Number = getDigitLarge($x, $y, "ReturnHome") & $Number
            $Number = getDigitLarge($x, $y, "ReturnHome") & $Number
            $Number = getDigitLarge($x, $y, "ReturnHome") & $Number

    EndSwitch

    Return $Number
EndFunc   ;==>getReturnHome