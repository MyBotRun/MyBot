
; #FUNCTION# ====================================================================================================================
; Name ..........: _ArraySortEx
; Description ...:
; Syntax ........: _ArraySortEx($Arry, $iStartRow, $iEndRow, Column, iDescending, Column, iDescending, Column, iDescending, Column, iDescending)
; Parameters ....: 
; Return values .: None
; Author ........:
; Modified ......: Boju (10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: _ArraySortEx($DefaultTroopGroup, 0, 0, 3, 1, 2, 0)
; ===============================================================================================================================
Func _ArraySortEx(ByRef $avArray, $iStartRow = 0, $iEndRow = 0, $iCol1 = 0, $AscDescCol1  = 0, $iCol2 = -1, $AscDescCol2  = 0, $iCol3 = -1, $AscDescCol3  = 0, $iCol4 = -1, $AscDescCol4  = 0)
  Local $iLastRow = 0
  Local $iStart = -1
  Local $iEnd = -1

  If $iCol1 >= 0 Then
    ; Sort on the first column
    _ArraySort($avArray, $AscDescCol1, $iStartRow, $iEndRow, $iCol1)

    If $iCol2 >= 0 Then
      $iStart = -1
      $iLastRow = UBound($avArray) - 1
      For $i = $iStartRow To $iLastRow
        Switch $i
          Case $iStartRow
            If $i <> $iLastRow Then
              If ($avArray[$i][$iCol1] <> $avArray[$i + 1][$iCol1]) Then
                $iStart = $i
                $iEnd = $i
              Else
                $iStart = $i
                $iEnd = $i + 1
              EndIf
            EndIf
          Case $iLastRow
            $iEnd = $iLastRow
            If $iStart <> $iEnd Then
              _ArraySort($avArray, $AscDescCol2, $iStart, $iEnd, $iCol2)
            EndIf
          Case Else
            If ($avArray[$i][$iCol1] <> $avArray[$i + 1][$iCol1]) Then
              $iEnd = $i
              If $iStart <> $iEnd Then
                _ArraySort($avArray, $AscDescCol2, $iStart, $iEnd, $iCol2)
              EndIf
              $iStart = $i + 1
              $iEnd = $iStart
            Else
              $iEnd = $i
            EndIf
        EndSwitch
      Next

      If $iCol3 >= 0 Then
        $iStart = -1
        For $i = 1 To $iLastRow
          Switch $i
            Case 1
              If $i <> $iLastRow Then
                If ($avArray[$i][$iCol1] <> $avArray[2][$iCol1]) Or ($avArray[$i][$iCol2] <> $avArray[2][$iCol2]) Then
                  $iStart = 2
                  $iEnd = $iStart
                Else
                  $iStart = 1
                  $iEnd = $iStart
                EndIf
              EndIf
            Case $iLastRow
              $iEnd = $iLastRow
              If $iStart <> $iEnd Then
                _ArraySort($avArray, $AscDescCol3, $iStart, $iEnd, $iCol3)
              EndIf
            Case Else
              If ($avArray[$i][$iCol1] <> $avArray[$i + 1][$iCol1]) Or ($avArray[$i][$iCol2] <> $avArray[$i + 1][$iCol2]) Then
                $iEnd = $i
                If $iStart <> $iEnd Then
                  _ArraySort($avArray, $AscDescCol3, $iStart, $iEnd, $iCol3)
                EndIf
                $iStart = $i + 1
                $iEnd = $iStart
              Else
                $iEnd = $i
              EndIf
          EndSwitch
        Next

        If $iCol4 >= 0 Then
          $iStart = -1
          For $i = 1 To $iLastRow
            Switch $i
              Case 1
                If $i <> $iLastRow Then
                  If ($avArray[$i][$iCol1] <> $avArray[2][$iCol1]) Or ($avArray[$i][$iCol2] <> $avArray[2][$iCol2]) Or ($avArray[$i][$iCol3] <> $avArray[2][$iCol3]) Then
                    $iStart = 2
                    $iEnd = $iStart
                  Else
                    $iStart = 1
                    $iEnd = $iStart
                  EndIf
                EndIf
              Case $iLastRow
                $iEnd = $iLastRow
                If $iStart <> $iEnd Then
                  _ArraySort($avArray, $AscDescCol4, $iStart, $iEnd, $iCol4)
                EndIf
              Case Else
                If ($avArray[$i][$iCol1] <> $avArray[$i + 1][$iCol1]) Or ($avArray[$i][$iCol2] <> $avArray[$i + 1][$iCol2]) Or ($avArray[$i][$iCol3] <> $avArray[$i + 1][$iCol3]) Then
                  $iEnd = $i
                  If $iStart <> $iEnd Then
                    _ArraySort($avArray, $AscDescCol4, $iStart, $iEnd, $iCol4)
                  EndIf
                  $iStart = $i + 1
                  $iEnd = $iStart
                Else
                  $iEnd = $i
                EndIf
            EndSwitch
          Next
        EndIf
      EndIf
    EndIf
  EndIf
EndFunc   ;==>_ArraySortEx