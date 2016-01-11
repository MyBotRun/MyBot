TEST

#include <Array.au3>
#include <String.au3>
; I know a lot of this info is already defined in the bot but I like my format better :)

Global Enum _
	$iBarbarian, _
	$iArcher, _
	$iGiant, _
	$iGoblin, _
	$iWallBreaker , _
	$iBalloon, _
	$iWizard, _
	$iHealer, _
	$iDragon, _
	$iPekka, _
	$iMinion, _
	$iHogRider, _
	$iValkyrie, _
	$iGolem, _
	$iWitch, _
	$iLavaHound, _
	$iArmyEnd


Global $ArmyComposition[$iArmyEnd]
Global $ArmyTrained[$iArmyEnd]
Global $ArmyTraining[$iArmyEnd]

Global $UnitIsDark[$iArmyEnd]
$UnitIsDark[$iBarbarian] = False
$UnitIsDark[$iArcher] = False
$UnitIsDark[$iGiant] = False
$UnitIsDark[$iGoblin] = False
$UnitIsDark[$iWallBreaker ] = False
$UnitIsDark[$iBalloon] = False
$UnitIsDark[$iWizard] = False
$UnitIsDark[$iHealer] = False
$UnitIsDark[$iDragon] = False
$UnitIsDark[$iPekka] = False
$UnitIsDark[$iMinion] = True
$UnitIsDark[$iHogRider] = True
$UnitIsDark[$iValkyrie] = True
$UnitIsDark[$iGolem] = True
$UnitIsDark[$iWitch] = True
$UnitIsDark[$iLavaHound] = True

Global $UnitName[$iArmyEnd]
$UnitName[$iBarbarian] = "Barbarian"
$UnitName[$iArcher] = "Archer"
$UnitName[$iGiant] = "Giant"
$UnitName[$iGoblin] = "Goblin"
$UnitName[$iWallBreaker ] = "WallBreaker"
$UnitName[$iBalloon] = "Balloon"
$UnitName[$iWizard] = "Wizard"
$UnitName[$iHealer] = "Healer"
$UnitName[$iDragon] = "Dragon"
$UnitName[$iPekka] = "Pekka"
$UnitName[$iMinion] = "Minion"
$UnitName[$iHogRider] = "HogRider"
$UnitName[$iValkyrie] = "Valkyrie"
$UnitName[$iGolem] = "Golem"
$UnitName[$iWitch] = "Witch"
$UnitName[$iLavaHound] = "LaavHound"

Func getI($name)
	For $i = 0 to UBound($UnitName) - 1
		If $UnitName[$i] == $name Then Return $i
	Next
EndFunc

Global $UnitTime[$iArmyEnd]
$UnitTime[$iBarbarian] = 20
$UnitTime[$iArcher] = 25
$UnitTime[$iGiant] = 2*60
$UnitTime[$iGoblin] = 30
$UnitTime[$iWallBreaker ] = 2*60
$UnitTime[$iBalloon] = 8*60
$UnitTime[$iWizard] = 8*60
$UnitTime[$iHealer] = 15*60
$UnitTime[$iDragon] = 30*60
$UnitTime[$iPekka] = 45*60
$UnitTime[$iMinion] = 45
$UnitTime[$iHogRider] = 2*60
$UnitTime[$iValkyrie] = 8*60
$UnitTime[$iGolem] = 45*60
$UnitTime[$iWitch] = 20*60
$UnitTime[$iLavaHound] = 45*60

Global $UnitSize[$iArmyEnd]
$UnitSize[$iBarbarian] = 1
$UnitSize[$iArcher] = 1
$UnitSize[$iGiant] = 5
$UnitSize[$iGoblin] = 1
$UnitSize[$iWallBreaker ] = 2
$UnitSize[$iBalloon] = 5
$UnitSize[$iWizard] = 4
$UnitSize[$iHealer] = 14
$UnitSize[$iDragon] = 20
$UnitSize[$iPekka] = 25
$UnitSize[$iMinion] = 2
$UnitSize[$iHogRider] = 5
$UnitSize[$iValkyrie] = 8
$UnitSize[$iGolem] = 30
$UnitSize[$iWitch] = 12
$UnitSize[$iLavaHound] = 30

Global $UnitTrainOrder[$iArmyEnd] = [ _
	$iPekka, _
	$iDragon, _
	$iHealer, _
	$iWizard, _
	$iBalloon, _
	$iGiant, _
	$iWallBreaker , _
	$iGoblin, _
	$iBarbarian, _
	$iArcher, _
	$iGolem, _
	$iHogRider, _
	$iValkyrie, _
	$iLavaHound, _
	$iWitch, _
	$iMinion _
]

Global $UnitShortName[$iArmyEnd]
$UnitShortName[$iBarbarian] = "Barb"
$UnitShortName[$iArcher] = "Arch"
$UnitShortName[$iGiant] = "Giant"
$UnitShortName[$iGoblin] = "Gobl"
$UnitShortName[$iWallBreaker ] = "Wall"
$UnitShortName[$iBalloon] = "Ball"
$UnitShortName[$iWizard] = "Wiza"
$UnitShortName[$iHealer] = "Heal"
$UnitShortName[$iDragon] = "Drag"
$UnitShortName[$iPekka] = "Pekk"
$UnitShortName[$iMinion] = "Mini"
$UnitShortName[$iHogRider] = "Hogs"
$UnitShortName[$iValkyrie] = "Valk"
$UnitShortName[$iGolem] = "Gole"
$UnitShortName[$iWitch] = "Witc"
$UnitShortName[$iLavaHound] = "Lava"


; Conversions with bot structure

; real unit name from bot short name
Func getRealName($shortName)
	For $i = 0 to UBound($UnitShortName) - 1
		If $UnitShortName[$i] == $shortName Then Return $UnitName[$i]
	Next
EndFunc

; translate from my enum to the bot troop index

Func getBotIndex($iUnit)
	For $i = 0 To UBound($TroopName)-1
		If $TroopName[$i] == $UnitShortName[$iUnit] Then Return $i
	Next
	For $i = 0 To UBound($TroopDarkName)-1
		If $TroopDarkName[$i] == $UnitShortName[$iUnit] Then Return $i
	Next
EndFunc

; Utility

Func ZeroArray(ByRef $array)
	For $i = 0 To UBound($array) - 1
		$array[$i] = 0
	Next
EndFunc

;ConsoleWrite($iGolem)

Func goHome($maxDelay = 5000)
	ClickP($aAway, 2, $iDelayTrain5, "#0501"); Click away twice with 250ms delay
	If WaitforPixel(28, 505, 30, 507, Hex(0xE4A438, 6), 5, $maxDelay/500) Then
		Return True
	EndIf
	Return False
EndFunc

Func goArmyOverview($maxDelay = 5000)
	Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#9998") ; Button Army Overview
	
	Local $icount = 0
	While True
		If IsTrainPage() Then Return True
		If _Sleep(100) Then Return
		$icount += 1
		If $icount = $maxDelay/100 Then ExitLoop
	WEnd
	Return False
EndFunc

Func clearTroops()
	Local $icount = 0

	If _ColorCheck(_GetPixelColor(187, 212, True), Hex(0xD30005, 6), 10) Then ; check if the existe more then 6 slots troops on train bar
		While Not _ColorCheck(_GetPixelColor(573, 212, True), Hex(0xD80001, 6), 10) ; while until appears the Red icon to delete troops
			_PostMessage_ClickDrag(550, 240, 170, 240, "left", 1000)
			$icount += 1
			If _Sleep($iDelayTrain1) Then Return
			If $icount = 7 Then ExitLoop
		WEnd
	EndIf

	If _Sleep($iDelayTrain1) Then Return
	
	_CaptureRegion()

	$icount = 0
	SetLog("Yet another")
	While Not _ColorCheck(_GetPixelColor(593, 200 + $midOffsetY, True), Hex(0xD0D0C0, 6), 20) ; while not disappears  green arrow
		SetLog("Yet here")
		If Not (IsTrainPage()) Then Return ;exit if no train page
		Click(568, 177 + $midOffsetY, 10, 0, "#0284") ; Remove Troops in training
		$icount += 1
		If $icount = 100 Then ExitLoop
	WEnd
EndFunc

; this relies on you being on the army overview
Func goToBarracks($targetBarracks)
	Local $currentBarracks = -1
	While $currentBarracks < 6
		_TrainMoveBtn(+1) ;click Next button
		If _Sleep($iDelayTrain2) Then Return
		$currentBarracks += 1
		If $currentBarracks == $targetBarracks Then Return True
	WEnd
	Return False
EndFunc

; UI variables

Global $rtTankPerc
Global $rtMeleePerc
Global $rtRangedPerc
Global $rtResourcePerc

Global $rtElixirMax
Global $rtElixirRes
Global $rtDarkMax
Global $rtDarkRes

