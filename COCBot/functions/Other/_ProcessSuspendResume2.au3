;https://www.autoitscript.com/forum/topic/32975-process-suspendprocess-resume-udf/?do=findComment&comment=1256804
; The more 'offical' & easy way (http://stackoverflow.com/a/11010508/3135511)
Func _ProcessSuspendResume2($iPIDorName, $iSuspend = True)

   If IsString($iPIDorName) Then $iPIDorName = ProcessExists($iPIDorName)
   If Not $iPIDorName Then Return SetError(2, 0, 0)

   if $iSuspend then
      ;Note Opens Process with PROCESS_ALL_ACCESS
      DllCall('kernel32.dll','ptr','DebugActiveProcess','int',$iPIDorName)

      ; you may leave out DebugSetProcessKillOnExit; however then your supended App will also Exit when you quit this AutoIt App
      DllCall('kernel32.dll','ptr','DebugSetProcessKillOnExit','int',False)
   Else
      DllCall('kernel32.dll','ptr','DebugActiveProcessStop','int',$iPIDorName)
   EndIf

EndFunc