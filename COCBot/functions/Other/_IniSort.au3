#include <array.au3>
;$file = @DesktopDir & '\test.ini'
;_IniSort($file)


;by SmOke_N
Func _IniSort($hIni)
	Local $aIRSN = IniReadSectionNames($hIni)
	If Not IsArray($aIRSN) Then Return SetError(1, 0, 0)
	_ArraySort($aIRSN, 0, 1)
	Local $aKey, $sHold
	For $iCC = 1 To UBound($aIRSN) - 1
		Local $aIRS = IniReadSection($hIni, $aIRSN[$iCC])
		If Not IsArray($aIRS) Then ContinueLoop
		For $xCC = 1 To $aIRS[0][0]
			$aKey &= $aIRS[$xCC][0] & Chr(1)
		Next
		If $aKey Then
			$aKey = StringSplit(StringTrimRight($aKey, 1), Chr(1))
			_ArraySort($aKey, 0, 1)
			$sHold &= '[' & $aIRSN[$iCC] & ']' & @CRLF
			For $aCC = 1 To UBound($aKey) - 1
				$sHold &= $aKey[$aCC] & '=' & IniRead($hIni, $aIRSN[$iCC], $aKey[$aCC], 'blahblah') & @CRLF
			Next
			$aKey = ''
		EndIf
	Next
	If $sHold Then
		$sHold = StringTrimRight($sHold, 2)
		FileClose(FileOpen($hIni, 2))
		FileWrite($hIni, $sHold)
		Return 1
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_IniSort


; by ResNullius
Func _IniSort($hIni, $iAscend = 1)
    Local $aIRSN = IniReadSectionNames($hIni)
    If Not IsArray($aIRSN) Then Return SetError(1, 0, 0)

    _ArraySort($aIRSN, 0, $iAscend)
    Local $sHold

    For $iCC = 1 To UBound($aIRSN) - 1
       Local $aIRS = IniReadSection($hIni, $aIRSN[$iCC])
       $sHold &= '[' & $aIRSN[$iCC] & ']' & @CRLF
       If Not IsArray($aIRS) Then
             $sHold &= @CRLF
             ContinueLoop
       EndIf
       _ArraySort($aIRS, 0, $iAscend, 0, 2)
       For $xCC = 1 To $aIRS[0][0]
           $sHold &= $aIRS[$xCC][0] & '=' & $aIRS[$xCC][1] & @CRLF
       Next
       $sHold &= @CRLF
    Next

    If $sHold Then
       $sHold = StringTrimRight($sHold, 2)
       FileClose(FileOpen($hIni, 2))
       FileWrite($hIni, $sHold)
       Return 1
    EndIf

    Return SetError(1, 0, 0)
EndFunc