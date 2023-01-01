; #FUNCTION# ====================================================================================================================
; Name ..........: GetAttackBarBB
; Description ...: Gets the troops and there quantities for the current attack
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetAttackBarBB($bRemaining = False)
	local $iTroopBanners = 579 + $g_iBottomOffsetY; 640 ; y location of where to find troop quantities
	local $aSlot1 = [85, 580 + $g_iBottomOffsetY] ; location of first slot
	local $iSlotOffset = 73 ; slots are 73 pixels apart
	local $iBarOffset = 66 ; 66 pixels from side to attack bar

	; testing troop count logic
	;PureClickP($aSlot1)
	;local $iTroopCount = Number(getTroopCountSmall($aSlot1[0], $aSlot1[1]))
	;If $iTroopCount == 0 Then $iTroopCount = Number(getTroopCountBig($aSlot1[0], $aSlot1[1]-2))
	;SetLog($iTroopCount)
	;$iTroopCount = Number(getTroopCountSmall($aSlot1[0] + 144, $aSlot1[1]))
	;SetLog($iTroopCount)

	local $aBBAttackBar[0][5]
	#comments-start
		$aAttackBar[n][8]
		[n][0] = Name of the found Troop/Spell/Hero/Siege
		[n][1] = The X Coordinate of the Troop
		[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
		[n][3] = The Slot Number (Starts with 0)
		[n][4] = The Amount
	#comments-end

	If Not $g_bRunState Then Return ; Stop Button
	
	;local $sSearchDiamond = GetDiamondFromRect("0,630,860,732")
	Local $sSearchDiamond = GetDiamondFromRect2(0, 570 + $g_iBottomOffsetY, 860, 672 + $g_iBottomOffsetY)
	local $aBBAttackBarResult = findMultiple($g_sImgDirBBTroops, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)

	If UBound($aBBAttackBarResult) = 0 Then
		If Not $bRemaining Then
			SetLog("Error in BBAttackBarCheck(): Search did not return any results!", $COLOR_ERROR)
			If $g_bDebugImageSave Then SaveDebugImage("ErrorBBAttackBarCheck", False, Default, Default)
		EndIf
		Return ""
	EndIf

	If Not $g_bRunState Then Return ; Stop Button
	
	; parse data into attackbar array... not done
	For $i = 0 To UBound($aBBAttackBarResult, 1) - 1
		local $aTroop = $aBBAttackBarResult[$i]

		local $aTempMultiCoords = decodeMultipleCoords($aTroop[1])
		For $j=0 To UBound($aTempMultiCoords, 1) - 1
			local $aTempCoords = $aTempMultiCoords[$j]
			If UBound($aTempCoords) < 2 Then ContinueLoop
			local $iSlot = Round(($aTempCoords[0] - $iBarOffset) / $iSlotOffset)

			If $aTroop[0] = "BattleMachine" Then
				Local $iCount = 0
			Else
				local $iCount = Number(getTroopCountSmall($aTempCoords[0], $iTroopBanners))
				If $iCount == 0 Then $iCount = Number(getTroopCountBig($aTempCoords[0], $iTroopBanners-5))
				If $iCount == 0 Then
					SetLog("Could not get count for " & $aTroop[0] & " in slot " & String($iSlot), $COLOR_ERROR)
					ContinueLoop
				EndIf
			EndIf

			local $aTempElement[1][5] = [[$aTroop[0], $aTempCoords[0], $aTempCoords[1], $iSlot, $iCount]] ; element to add to attack bar list
			_ArrayAdd($aBBAttackBar, $aTempElement)
		Next

	If Not $g_bRunState Then Return ; Stop Button
	Next
	_ArraySort($aBBAttackBar, 0, 0, 0, 3)
	For $i=0 To UBound($aBBAttackBar, 1) - 1
		SetLog($aBBAttackBar[$i][0] & ", (" & String($aBBAttackBar[$i][1]) & "," & String($aBBAttackBar[$i][2]) & "), Slot: " & String($aBBAttackBar[$i][3]) & ", Count: " & String($aBBAttackBar[$i][4]), $COLOR_SUCCESS)
	Next
	Return $aBBAttackBar
EndFunc
