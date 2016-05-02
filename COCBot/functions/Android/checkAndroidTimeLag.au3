; #FUNCTION# ====================================================================================================================
; Name ..........: checkAndroidTimeLag
; Description ...: Function to check time inside Android matching host time
; Syntax ........: checkAndroidTimeLag()
; Parameters ....: $bRebootAndroid = True reboots Android if time lag > $AndroidTimeLagThreshold
; Return values .: True if Android reboot initiated, False otherwise
;                  @extended = time lag in Seconds per Minutes
;                  @error = 1 : Time lag check not available
;                           2 : Time lag variables initialized
;                           3 : Time lag cannot be calculated, subsequent call within 60 Seconds
;                           4 : ADB shell error
;                           5 : ADB date +%s returned not a number >= 1
;                           6 : Android elapsed time is <= 0
; Author ........: Cosote (March 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: If checkAndroidTimeLag() = True Then Return
; ===============================================================================================================================

Func checkAndroidTimeLag($bRebootAndroid = True)

   SetError(0, 0)
   If $AndroidCheckTimeLagEnabled = False Then Return SetError(1, 0, False)

   Local $androidUTC = $AndroidTimeLag[1]
   Local $hostTimer = $AndroidTimeLag[2]

   If $hostTimer <> 0 And TimerDiff($hostTimer) / 1000 < 60 Then
	  ; exit as not ready to compare time
	  Return SetError(3, 0, False)
   EndIf

   ; get Android UTC
   Local $s = AndroidAdbSendShellCommand("date +%s")
   If @error <> 0 Then Return SetError(4, 0, False)

   Local $curr_androidUTC = Number($s)
   Local $curr_hostTimer = TimerInit()

   If $curr_androidUTC < 1 Then
	  InitAndroidTimeLag()
	  Return SetError(5, 0, False)
   EndIf

   If $androidUTC = 0 Or $hostTimer = 0 Then
	  ; init time
	  $AndroidTimeLag[1] = $curr_androidUTC
	  $AndroidTimeLag[2] = $curr_hostTimer
	  $AndroidTimeLag[3] = 0
	  Return SetError(2, 0, False)
   EndIf

   ; calculate lag
   Local $hostSeconds = Int(TimerDiff($hostTimer) / 1000)
   Local $hostMinutes = $hostSeconds / 60
   Local $androidSeconds = $curr_androidUTC - $androidUTC

   Local $lagTotal = $hostSeconds - $androidSeconds ; - Int($AndroidTimeLag[3] / 1000)
   Local $lagPerMin = Int($lagTotal / $hostMinutes)

   SetDebugLog($Android & " time lag is " & ($lagPerMin > 0 ? "> " : "") & $lagPerMin & " sec/min (avg for " & $hostSeconds & " sec)")

   If $androidSeconds <= 0 Then
	  InitAndroidTimeLag()
	  Return SetError(6, 0, False)
   EndIf

   If $lagPerMin < 0 Then $lagPerMin = 0

   ; update array
   $AndroidTimeLag[0] = $lagPerMin
   $AndroidTimeLag[1] = $curr_androidUTC
   $AndroidTimeLag[2] = $curr_hostTimer
   $AndroidTimeLag[3] = 0

   Local $bRebooted = False
   If $lagPerMin > $AndroidTimeLagThreshold Then

	  If $bRebootAndroid = True Then
		 SetLog("Rebooting " & $Android & " due to time lag problem of " & $lagPerMin & " sec/min", $COLOR_RED)
		 Local $_NoFocusTampering = $NoFocusTampering
		 $NoFocusTampering = True
		 RebootAndroid()
		 $NoFocusTampering = $_NoFocusTampering
		 $bRebooted = True
	  ;Else
		 ;SetLog($Android & " suffered time lag of " & $lagPerMin & " sec/min (reboot skipped)", $COLOR_RED)
	  EndIf

   EndIf

   Return SetError(0, $lagPerMin, $bRebooted)
EndFunc