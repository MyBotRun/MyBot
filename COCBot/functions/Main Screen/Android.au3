; #FUNCTION# ====================================================================================================================
; Name ..........: Functions to interact with Android Window
; Description ...: This file contains the detection fucntions for the Emulator and Android version used.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Update Global Android variables based on $AndroidConfig index
; Calls "Update" & $Android & "Config()"
Func UpdateAndroidConfig()

	$Android = $AndroidAppConfig[$AndroidConfig][0] ; Emulator used (BS, BS2 or Droid4X)
	$AndroidInstance = $AndroidAppConfig[$AndroidConfig][1] ; Clone or instance of emulator or "" if not supported
	$Title = $AndroidAppConfig[$AndroidConfig][2] ; Emulator Window Title
	$AppClassInstance = $AndroidAppConfig[$AndroidConfig][3] ; Control Class and instance of android rendering
	$AppPaneName = $AndroidAppConfig[$AndroidConfig][4] ; Control name of android rendering TODO check is still required
	$AndroidClientWidth = $AndroidAppConfig[$AndroidConfig][5] ; Expected width of android rendering
	$AndroidClientHeight = $AndroidAppConfig[$AndroidConfig][6] ; Expected height of android rendering
	$AndroidWindowWidth = $AndroidAppConfig[$AndroidConfig][7]
	$AndroidWindowHeight = $AndroidAppConfig[$AndroidConfig][8]
	$ClientOffsetY = $AndroidAppConfig[$AndroidConfig][9]
	$AndroidAdbDevice = $AndroidAppConfig[$AndroidConfig][10]
	$AndroidSupportsBackgroundMode = $AndroidAppConfig[$AndroidConfig][11]

	Return Execute("Update" & $Android & "Config()")

EndFunc   ;==>UpdateAndroidConfig

; Detects first running Adnroid Window is present based on $AndroidAppConfig array sequence
Func DetectRunningAndroid()

	; Find running Android Emulator

	Local $i
	For $i = 0 To UBound($AndroidAppConfig) - 1

		Local $A, $T, $N, $C
		$A = $AndroidAppConfig[$i][0]
		$T = $AndroidAppConfig[$i][2]
		$C = $AndroidAppConfig[$i][3]
		$N = $AndroidAppConfig[$i][4]

		If IsArray(ControlGetPos($T, $N, $C)) Or ($A = $AndroidAppConfig[1][0] And IsArray(ControlGetPos("Bluestacks App Player", "", ""))) Then ; $AndroidAppConfig[1][4]

			$AndroidConfig = $i
			UpdateAndroidConfig()
			$FoundRunningAndroid = True
			; validate install
			InitAndroid()
			Return

		EndIf

	Next

EndFunc   ;==>DetectRunningAndroid

; Detects first installed Adnroid Emulator installation based on $AndroidAppConfig array sequence
Func DetectInstalledAndroid()

	; Find installed Android Emulator

	Local $i, $installed, $A
	For $i = 0 To UBound($AndroidAppConfig) - 1

		$A = $AndroidAppConfig[$i][0]
		$installed = Execute("Init" & $A & "(True)")

		If $installed Then
			$AndroidConfig = $i
			UpdateAndroidConfig()
			$FoundInstalledAndroid = True
			; validate install
			InitAndroid()
			Return

		EndIf

	Next

EndFunc   ;==>DetectInstalledAndroid

; Updates Adnroid variables for Droid4X
Func UpdateDroid4XConfig()

	; Update Window Title if instance has been configured

	If $AndroidInstance = "" Or StringCompare($AndroidInstance, $AndroidAppConfig[$AndroidConfig][1]) = 0 Then
		; Default title, nothing to do
	Else
		; Update title
		$Title = StringReplace($AndroidAppConfig[$AndroidConfig][2], "Droid4X", $AndroidInstance)
	EndIf

EndFunc   ;==>UpdateDroid4XConfig

Func UpdateBlueStacksConfig()
EndFunc   ;==>UpdateBlueStacksConfig

Func UpdateBlueStacks2Config()
EndFunc   ;==>UpdateBlueStacks2Config

Func InitAndroid($bCheckOnly = False)
	Local $Result = Execute("Init" & $Android & "(" & $bCheckOnly & ")")
	$HWnD = WinGetHandle($Title) ;Handle for Android window
	Return $Result
EndFunc   ;==>InitAndroid

Func OpenAndroid($bRestart = False)
	Return Execute("Open" & $Android & "(" & $bRestart & ")")
EndFunc   ;==>OpenAndroid

Func RestartAndroidCoC()
	Return Execute("Restart" & $Android & "CoC()")
EndFunc   ;==>RestartAndroidCoC

Func CloseAndroid()
	Return Execute("Close" & $Android & "()")
EndFunc   ;==>CloseAndroid

Func SetScreenAndroid()
	Return Execute("SetScreen" & $Android & "()")
EndFunc   ;==>SetScreenAndroid

Func RebootAndroidSetScreen()
	Return Execute("Reboot" & $Android & "SetScreen()")
EndFunc   ;==>RebootAndroidSetScreen

Func RebootAndroid()

	; Close Android
	CloseAndroid()
	If _Sleep(1000) Then Return

	; Start Android
	OpenAndroid()

EndFunc   ;==>RebootAndroid

Func RebootAndroidSetScreenDefault()

	; Close Android
	CloseAndroid()
	If _Sleep(1000) Then Return

	; Set Android screen size and dpi
	SetLog("Set " & $Android & " screen resolution to " & $AndroidClientWidth & " x " & $AndroidClientHeight, $COLOR_BLUE)

	SetScreenAndroid()
	SetLog("A restart of your computer might be required for the applied changes to take effect.", $COLOR_ORANGE)

	; Start Android
	OpenAndroid()

	Return True

EndFunc   ;==>RebootAndroidSetScreenDefault