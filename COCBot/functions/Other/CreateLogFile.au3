Func CreateLogFile()
    $sLogFName = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "." & @MIN & "." & @SEC & ".log"
	$sLogPath = $dirLogs & $sLogFName
	$hLogFileHandle = FileOpen($sLogPath, $FO_APPEND)
EndFunc   ;==>CreateLogFile

Func CreateAttackLogFile()
    $sAttackLogFName = "AttackLog" & "-"& @YEAR & "-" & @MON & ".log"
	$sAttackLogPath = $dirLogs & $sAttackLogFName
	$hAttackLogFileHandle = FileOpen($sAttackLogPath, $FO_APPEND)
EndFunc   ;==>CreateAttackLogFile