; #FUNCTION# ====================================================================================================================
; Name ..........: checkAndroidTimeLag
; Description ...: Function to check time inside Android matching host time
; Syntax ........: checkAndroidTimeLag()
; Parameters ....: $bRebootAndroid = True reboots Android if time lag > $AndroidTimeLagThreshold
; Return values .: >= 0 : time lag in Seconds per Minutes
; Author ........: Cosote (March 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkAndroidTimeLag($bRebootAndroid = True)

   If $AndroidCheckTimeLagEnabled = False Then Return -1

   Local $androidUTC = $AndroidTimeLag[1]
   Local $hostTimer = $AndroidTimeLag[2]

   If $hostTimer <> 0 And TimerDiff($hostTimer) / 1000 < 60 Then
	  ; exit as not ready to compare time
	  Return -3
   EndIf

   ; get Android UTC
   Local $s = AndroidAdbSendShellCommand("date +%s")
   Local $curr_androidUTC = Number($s)
   Local $curr_hostTimer = TimerInit()

   If $androidUTC = 0 Or $hostTimer = 0 Then
	  ; init time
	  $AndroidTimeLag[1] = $curr_androidUTC
	  $AndroidTimeLag[2] = $curr_hostTimer
	  $AndroidTimeLag[3] = 0
	  Return -2
   EndIf

   ; calculate lag
   Local $hostSeconds = Int(TimerDiff($hostTimer) / 1000)
   Local $hostMinutes = $hostSeconds / 60
   Local $androidSeconds = $curr_androidUTC - $androidUTC

   Local $lagTotal = $hostSeconds - $androidSeconds ; - Int($AndroidTimeLag[3] / 1000)
   Local $lagPerMin = Int($lagTotal / $hostMinutes)

   SetDebugLog($Android & " time lag is " & $lagPerMin & " sec/min (avg for " & $hostSeconds & " sec)")

   If $lagPerMin < 0 Then $lagPerMin = 0

   ; update array
   $AndroidTimeLag[0] = $lagPerMin
   $AndroidTimeLag[1] = $curr_androidUTC
   $AndroidTimeLag[2] = $curr_hostTimer
   $AndroidTimeLag[3] = 0

   If $lagPerMin > $AndroidTimeLagThreshold Then

	  If $bRebootAndroid = True Then
		 SetLog("Rebooting " & $Android & " due to time lag problem of " & $lagPerMin & " sec/min", $COLOR_RED)
		 Local $_NoFocusTampering = $NoFocusTampering
		 $NoFocusTampering = True
		 RebootAndroid()
		 $NoFocusTampering = $_NoFocusTampering
	  ;Else
		 ;SetLog($Android & " suffered time lag of " & $lagPerMin & " sec/min (reboot skipped)", $COLOR_RED)
	  EndIf

   EndIf

   Return $lagPerMin
EndFunc