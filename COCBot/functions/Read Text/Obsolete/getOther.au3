; #FUNCTION# ====================================================================================================================
; Name ..........: getOther.au3
; Description ...: reads different configurations of numbers from screen
; Syntax ........: getOther($x_start, $y_start, $type, $totalcamp = false)
; Parameters ....:
; Return values .:
;
; Author ........: Unknown
; Modified ......: KnowJack (April/June-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: getDigit()
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getOther($x_start, $y_start, $type, $totalcamp = False)
	_CaptureRegion(0, 0, $x_start + 120, $y_start + 20)
	;-----------------------------------------------------------------------------
	Local $x = $x_start, $y = $y_start
	Local $Number, $i = 0

	Switch $type
		Case "Trophy"
			$Number = getDigit($x, $y, "Other")

			While $Number = ""
				If $i >= 50 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigit($x, $y, "Other")
			WEnd

			$Number &= getDigit($x, $y, "Other")
			$Number &= getDigit($x, $y, "Other")
			$Number &= getDigit($x, $y, "Other")

		Case "Builder"
			$Number = getDigit($x, $y, "Builder")

			While $Number = ""
				If $i >= 10 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigit($x, $y, "Builder")
			WEnd

		Case "Gems"
			$Number = getDigit($x, $y, "Other")

			While $Number = ""
				If $i >= 90 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigit($x, $y, "Other")
			WEnd

			$Number &= getDigit($x, $y, "Other")
			$Number &= getDigit($x, $y, "Other")
			$Number &= getDigit($x, $y, "Other")
			$x += 6
			$Number &= getDigit($x, $y, "Other")
			$Number &= getDigit($x, $y, "Other")
			$Number &= getDigit($x, $y, "Other")

		Case "Resource"
			$Number = getDigit($x, $y, "Resource")

			While $Number = ""
				If $i >= 120 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigit($x, $y, "Resource")
			WEnd

			$Number &= getDigit($x, $y, "Resource")
			$Number &= getDigit($x, $y, "Resource")
			$Number &= getDigit($x, $y, "Resource")
			$x += 6
			$Number &= getDigit($x, $y, "Resource")
			$Number &= getDigit($x, $y, "Resource")
			$Number &= getDigit($x, $y, "Resource")
			$x += 6
			$Number &= getDigit($x, $y, "Resource")
			$Number &= getDigit($x, $y, "Resource")
			$Number &= getDigit($x, $y, "Resource")

		Case "Camp"
			$Number = getDigitSmall($x, $y, "Camp")

			While $Number = ""
				If $i >= 20 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigitSmall($x, $y, "Camp")
			WEnd

			$Number &= getDigitSmall($x, $y, "Camp")
			$Number &= getDigitSmall($x, $y, "Camp")

			If $totalcamp Then
				$x += 6
				$Number = ""
				While $Number = ""
					If $i >= 20 Then ExitLoop
					$i += 1
					$x += 1
					$Number = getDigitSmall($x, $y, "Camp")
				WEnd

				$Number &= getDigitSmall($x, $y, "Camp")
				$Number &= getDigitSmall($x, $y, "Camp")
			EndIf
		Case "Barrack"
			$Number = getDigit($x, $y, "Other")

			While $Number = ""
				If $i >= 20 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigit($x, $y, "Other")
			WEnd

			$Number &= getDigit($x, $y, "Other")
			$Number &= getDigit($x, $y, "Other")
			$Number &= getDigit($x, $y, "Other")

		Case "MyProfile"
			$Number = getDigitProfile($x, $y, "MyProfile")
			While $Number = ""
				If $i >= 70 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigitProfile($x, $y, "MyProfile")
			WEnd

			$Number &= getDigitProfile($x, $y, "MyProfile")
			$Number &= getDigitProfile($x, $y, "MyProfile")
			$Number &= getDigitProfile($x, $y, "MyProfile")
			$Number &= getDigitProfile($x, $y, "MyProfile")

		Case "Hitpoints"
			$Number = getDigitSmall($x, $y, "Camp")

			While $Number = ""
				If $i >= 20 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigitSmall($x, $y, "Camp")
			WEnd

			$Number &= getDigitSmall($x, $y, "Camp")
			$Number &= getDigitSmall($x, $y, "Camp")
			$Number &= getDigitSmall($x, $y, "Camp")

			If $totalcamp Then
				$x += 6
				$Number = ""
				While $Number = ""
					If $i >= 20 Then ExitLoop
					$i += 1
					$x += 1
					$Number = getDigitSmall($x, $y, "Camp")
				WEnd

				$Number &= getDigitSmall($x, $y, "Camp")
				$Number &= getDigitSmall($x, $y, "Camp")
				$Number &= getDigitSmall($x, $y, "Camp")
			EndIf

		Case "Upgrades"
			$Number = getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)

			While $Number = ""
				If $i >= 120 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigit($x, $y, "Upgrades")
			WEnd
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)

			$Number &= getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "Upgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @Upgrade $number = "&$Number,$COLOR_PURPLE)

		Case "RedUpgrades"

			$Number = getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @ $number = "&$Number,$COLOR_PURPLE)

			While $Number = ""
				If $i >= 120 Then ExitLoop
				$i += 1
				$x += 1
				$Number = getDigit($x, $y, "RedUpgrades")
			WEnd
			If $DebugSetlog = 1 Then Setlog($x&" @ $number = "&$Number,$COLOR_PURPLE)

			$Number &= getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @RedUpgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @RedUpgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @RedUpgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @RedUpgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @RedUpgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @RedUpgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @RedUpgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @RedUpgrade $number = "&$Number,$COLOR_PURPLE)
			$Number &= getDigit($x, $y, "RedUpgrades")
			If $DebugSetlog = 1 Then Setlog($x&" @RedUpgrade $number = "&$Number,$COLOR_PURPLE)

	EndSwitch

	Return $Number
EndFunc   ;==>getOther
