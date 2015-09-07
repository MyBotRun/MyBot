Func GUICtrlGetBkColor($hWnd)
    If Not IsHWnd($hWnd) Then
        $hWnd = GUICtrlGetHandle($hWnd)
    EndIf
    Local $hDC = _WinAPI_GetDC($hWnd)
    Local $iColor = _WinAPI_GetPixel($hDC, 0, 0)
    _WinAPI_ReleaseDC($hWnd, $hDC)
    Return $iColor
EndFunc   ;==>GUICtrlGetBkColor