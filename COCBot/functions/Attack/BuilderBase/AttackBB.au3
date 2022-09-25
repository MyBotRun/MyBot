; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttackBB
; Description ...: This file controls attacking preperation of the builders base
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......: GrumpyHog (06-2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Local $ai_AttackDropPoints
Local $bFirstAttackClick 
Local $bBMDeployed, $hBMTimer
Local $bMachineAlive

; Only Clan Games requires a preset number of Attacks
Func AttackBB($iNumberOfAttacks = 0, $iAttackSide = 0)

	If Not $g_bChkEnableBBAttack And $iNumberOfAttacks = 0 Then Return False

	; active CG skip regular attacks
	If Not $g_bClanGamesCompleted And $g_IsClanGamesActive And $iNumberOfAttacks = 0 Then
		SetLog("Clan Games Active pausing regular BB Attacks")
		Return False
	Else
		SetLog("Proceeding with regular BB Attacks")
	EndIf

	SetLog("$g_bChkBBTrophyRange: " & $g_bChkBBTrophyRange)
	SetLog("$g_bChkBBAttIfLootAvail: " & $g_bChkBBAttIfLootAvail)
	SetLog("$g_bChkBBWaitForMachine: " & $g_bChkBBWaitForMachine)

	Local $iSide, $aBMPos
	Local $bAttack = True
	Local $iAttack = 1
	Local $bClanGames = True

	If Not ClickAttack() Then
	  SetLog("Can't find attack button")
	  Return False
   EndIf

	If _Sleep(3000) Then Return

	; if 0 will attack until no loot
	If $iNumberOfAttacks = 0 Then $bClanGames = False

	SetLog("Number of Attacks: " & $iNumberOfAttacks)

	While $bAttack
		If $iAttackSide = 0 Then
			$iSide = Random(1, 4, 1) ; randomly choose top left or top right
		Else
			$iSide = $iAttackSide
		EndIf
		
		$aBMPos = 0

		; check for troops, loot and Batlle Machine
		If Not PrepareAttackBB($bClanGames) Then
			SetLog("PrepareAttackBB failed")
			ClickAway()
			ZoomOut()
			Return False
		EndIf

		SetLog("Attack : " & $iAttack, $COLOR_BLUE)
		SetDebugLog("PrepareAttackBB(): Success.")

		; search for a match
		If _Sleep(2000) Then Return

		local $aBBFindNow = [521, 308, 0xffc246, 30] ; search button

		If _CheckPixel($aBBFindNow, True) Then
			PureClick($aBBFindNow[0], $aBBFindNow[1])
		Else
			SetLog("Could not locate search button to go find an attack.", $COLOR_ERROR)
			Return
		EndIf

		If _Sleep(1500) Then Return ; give time for find now button to go away

		If _CheckPixel($aBBFindNow, True) Then ; click failed so something went wrong
			SetLog("Click BB Find Now failed. We will come back and try again.", $COLOR_ERROR)
			ClickAway()
			ZoomOut()
			Return
		EndIf

		local $iAndroidSuspendModeFlagsLast = $g_iAndroidSuspendModeFlags
		$g_iAndroidSuspendModeFlags = 0 ; disable suspend and resume
		If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Disabled")

		; wait for the clouds to clear
		SetLog("Searching for Opponent.", $COLOR_BLUE)
		local $timer = __TimerInit()
		local $iPrevTime = 0

		While Not CheckBattleStarted()
			local $iTime = Int(__TimerDiff($timer)/ 60000)

			If ConnectionLost(False) Then Return False

			If $iTime > $iPrevTime Then ; if we have increased by a minute
				SetLog("Clouds: " & $iTime & "-Minute(s)")
				$iPrevTime = $iTime
			EndIf

			If _Sleep($DELAYRESPOND) Then
				$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
				If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
				Return
			EndIf
		WEnd

		ZoomOut()

		If _Sleep(250) Then Return

		;generate attack drop points
		Switch $iSide
			Case 1
				$ai_AttackDropPoints = _GetVectorOutZone($eVectorLeftTop)
			Case 2
				$ai_AttackDropPoints = _GetVectorOutZone($eVectorRightTop)
			Case 3
				$ai_AttackDropPoints = _GetVectorOutZone($eVectorRightBottom)
			Case Else
				$ai_AttackDropPoints = _GetVectorOutZone($eVectorLeftBottom)
		EndSwitch

		; Get troops on attack bar and their quantities
		local $aBBAttackBar = GetAttackBarBB()
		If _Sleep($DELAYRESPOND) Then
			$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
			If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
			Return
		EndIf

		$bFirstAttackClick = True

		; Deploy all troops
		Local $bTroopsDropped = False
		Local $hAtkTimer = TimerInit() ; exit timer
		$bBMDeployed = False
		$bMachineAlive = True
		SetLog( $g_bBBDropOrderSet = True ? "Deploying Troops in Custom Order." : "Deploying Troops in Order of Attack Bar.", $COLOR_BLUE)
		While Not $bTroopsDropped And _Timer_Diff($hAtkTimer) < 210000
			Local $iNumSlots = UBound($aBBAttackBar, 1)
			If $g_bBBDropOrderSet = True Then
				local $asBBDropOrder = StringSplit($g_sBBDropOrder, "|")
				For $i=0 To $g_iBBTroopCount - 1 ; loop through each name in the drop order
					local $j=0, $bDone = 0
					While $j < $iNumSlots And Not $bDone
						If $aBBAttackBar[$j][0] = $asBBDropOrder[$i+1] Then
							DeployBBTroop($aBBAttackBar[$j][0], $aBBAttackBar[$j][1], $aBBAttackBar[$j][2], $aBBAttackBar[$j][4], $iSide)
							If $j = $iNumSlots-1 Or $aBBAttackBar[$j][0] <> $aBBAttackBar[$j+1][0] Then
								$bDone = True
								If _Sleep($g_iBBNextTroopDelay) Then ; wait before next troop
									$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
									If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
									Return
								EndIf
							EndIf
						EndIf
						$j+=1
					WEnd
				Next
			Else
				For $i=0 To $iNumSlots - 1
					DeployBBTroop($aBBAttackBar[$i][0], $aBBAttackBar[$i][1], $aBBAttackBar[$i][2], $aBBAttackBar[$i][4], $iSide)
					If $i = $iNumSlots-1 Or $aBBAttackBar[$i][0] <> $aBBAttackBar[$i+1][0] Then
						If _Sleep($g_iBBNextTroopDelay) Then ; wait before next troop
							$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
							If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
							Return
						EndIf
					Else
						If _Sleep($DELAYRESPOND) Then ; we are still on same troop so lets drop them all down a bit faster
							$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
							If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
							Return
						EndIf
					EndIf
				Next
			EndIf
	
			If __TimerDiff($hBMTimer) > ($g_iBBMachAbilityTime - 500) And $bBMDeployed And $bMachineAlive Then
				SetLog("Check Ability") 
				$aBMPos = GetMachinePos()
				If IsArray($aBMPos) Then 
					PureClickP($aBMPos) ; ability
					$hBMTimer = __TimerInit()
				Else
					$bMachineAlive = False
				EndIf
			EndIf
		
			If _Sleep(250) Then Return
			
			$aBBAttackBar = GetAttackBarBB(True)
			If $aBBAttackBar = "" And (Not $bMachineAlive Or Not $g_bBBMachineReady) Then $bTroopsDropped = True
			
			If ConnectionLost(False) Then Return False
		WEnd

		SetLog("All Troops Deployed", $COLOR_SUCCESS)

		If $bBMDeployed And Not $bMachineAlive Then SetLog("Battle Machine Dead")

		; wait for end of battle
		SetLog("Waiting for end of battle.", $COLOR_BLUE)
		If Not Okay() Then
			$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
			If $g_bDebugSetlog Then SetDebugLog("Android Suspend Mode Enabled")
			Return
		EndIf

		SetLog("Battle ended")
		If _Sleep(3000) Then
			$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
			If $g_bDebugSetlog Then SetDebugLog("Android Suspend Mode Enabled")
			Return
		EndIf

		; wait for ok after both attacks are finished
		SetLog("Waiting for opponent", $COLOR_BLUE)
		Okay()

		  SetLog("Done", $COLOR_SUCCESS)

		If _Sleep(1500) Then Return

		$iAttack += 1

		If $bClanGames Then
			If $iAttack > $iNumberOfAttacks Then $bAttack = False
		Else
			$bAttack = False
		EndIf

	WEnd

	$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast ; reset android suspend and resume stuff
	If $g_bDebugSetlog Then SetDebugLog("Android Suspend Mode Enabled")

	If _Sleep(2000) Then Return

	ClickAway()
	ZoomOut()

	Return True
EndFunc

Func CheckBattleStarted()
	local $sSearchDiamond = GetDiamondFromRect("376,10,460,28")

	local $aCoords = decodeSingleCoord(findImage("BBBattleStarted", $g_sImgBBBattleStarted, $sSearchDiamond, 1, True))
	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		SetLog("Battle Started", $COLOR_SUCCESS)
		Return True
	EndIf

	Return False ; If battle not started
EndFunc

Func GetMachinePos($bDeployed = False)
	If Not $g_bBBMachineReady Then Return

	Local $sSearchDiamond = GetDiamondFromRect("0,630,860,732")
	Local $aCoords

	If $bDeployed Then
		SetDebugLog("Search BM Hammer")
		Local $iLoop = 10
		Local $sImgBattleMachine = @ScriptDir & "\imgxml\Attack\BuilderBase\BattleMachine\BBBattleMachineDeployed_0_90.xml"
	Else
		SetDebugLog("Search BM Eye")
		Local $iLoop = 10
		Local $sImgBattleMachine = @ScriptDir & "\imgxml\Attack\BuilderBase\BattleMachine\BBBattleMachine_0_90.xml"
	EndIf

	For $i = 0 to $iLoop
	   $aCoords = decodeSingleCoord(findImage("BBBattleMachinePos", $sImgBattleMachine, $sSearchDiamond, 1, True))

		If IsArray($aCoords) And UBound($aCoords) = 2 Then
			If _Sleep(100) Then Return
			Return $aCoords
		Else
			If $g_bDebugImageSave Then SaveDebugImage("BBBattleMachinePos")
			;SaveDebugRectImage("BBBattleMachinePos", "0,630,860,732")
			SetDebugLog("AttackBar: Locate BM Failed : " & $i)
		EndIf

		If _Sleep(100) Then Return
	Next

	Return
EndFunc

Func Okay()
	local $timer = __TimerInit()

	While 1
		local $aCoords = decodeSingleCoord(findImage("OkayButton", $g_sImgOkButton, "FV", 1, True))
		If IsArray($aCoords) And UBound($aCoords) = 2 Then
			PureClickP($aCoords)
			Return True
		EndIf

		; check for advert
		If $g_sAndroidGameDistributor = "Magic" Then ClashOfMagicAdvert()

		If ConnectionLost(False) Then Return False

		If __TimerDiff($timer) >= 180000 Then
			SetLog("Could not find button 'Okay'", $COLOR_ERROR)
			If $g_bDebugImageSave Then SaveDebugImage("BBFindOkay")
			Return False
		EndIf

		If Mod(__TimerDiff($timer), 3000) Then
			If _Sleep($DELAYRESPOND) Then Return
		EndIf
	WEnd

	Return True
EndFunc

Func DeployBBTroop($sName, $x, $y, $iAmount, $iSide)
	Local $aBMPos
	SetLog("Deploying " & $sName & "x" & String($iAmount), $COLOR_ACTION)

	PureClick($x, $y) ; select troop
	If _Sleep($g_iBBSameTroopDelay) Then Return ; slow down selecting then dropping troops

	; place hero and activate ability
	If $sName = "BattleMachine" And $g_bBBMachineReady And Not $bBMDeployed Then 
		; get random drop point
		Local $iPoint = Random(0, UBOUND($ai_AttackDropPoints) - 1, 1)
		Local $iPixel = $ai_AttackDropPoints[$iPoint]
		PureClickP($iPixel) ; Click Map
		SetLog("attack click :" & $iPixel[0] & ", " & $iPixel[1], $COLOR_INFO)

		; BM 5+ will display a hammer once deployed - search for hammer
		$aBMPos = GetMachinePos(True)
		If IsArray($aBMPos) Then 
			$bBMDeployed = True
			PureClickP($aBMPos) ; ability
			$hBMTimer = __TimerInit()
		Else
			; no hammer could be BM 1-4 or BM has failed to deployed
			; search for eye
			$aBMPos = GetMachinePos()
			If Not IsArray($aBMPos) Then 
				$bBMDeployed = True ; no eye must be BM 1-4
				$bMachineAlive = False ; no ability
			EndIf
		EndIf

		If $bBMDeployed Then SetLog("Battle Machine Deployed", $COLOR_SUCCESS)
	Else
		For $j=0 To $iAmount - 1
			; get random drop point
			Local $iPoint = Random(0, UBOUND($ai_AttackDropPoints) - 1, 1)
			Local $iPixel = $ai_AttackDropPoints[$iPoint]

			If $bFirstAttackClick Then
				IsClickOnPotions($iPixel[0], $iPixel[1])
				$bFirstAttackClick = False
			EndIf

			PureClickP($iPixel)

			If _Sleep($g_iBBSameTroopDelay) Then Return ; slow down dropping of troops
		Next
	EndIf
 EndFunc

 Func _ClickAttack()
	local $aColors = [[0xfdd79b, 96, 0], [0xffffff, 20, 50], [0xffffff, 69, 50]] ; coordinates of pixels relative to the 1st pixel
	Local $ButtonPixel = _MultiPixelSearch(8, 640, 120, 755, 1, 1, Hex(0xeac68c, 6), $aColors, 20)
	local $bRet = False

	If IsArray($ButtonPixel) Then
		SetDebugLog(String($ButtonPixel[0]) & " " & String($ButtonPixel[1]))
		PureClick($ButtonPixel[0] + 25, $ButtonPixel[1] + 25) ; Click fight Button
		$bRet = True
	Else
		SetLog("Can not find button for Builders Base Attack button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("BBAttack_ButtonCheck_")
	EndIf
	Return $bRet
EndFunc

Func ClickAttack()
	local $aCoords = decodeSingleCoord(findImage("ClickAttack", $g_sImgBBAttackButton, GetDiamondFromRect("10,620,115,720"), 1, True))
	local $bRet = False

	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		SetDebugLog(String($aCoords[0]) & " " & String($aCoords[1]))
		PureClick($aCoords[0], $aCoords[1]) ; Click Attack Button
		$bRet = True
	Else
		SetLog("Can not find button for Builders Base Attack button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("ClickAttack")
	EndIf

	Return $bRet
EndFunc

Func IsClickOnPotions(ByRef $x, ByRef $y)
	Local $bResult = False
	SetLog("IsClickOnPotions :" & $x & ", " & $y, $COLOR_INFO)
	If $y > 560 Then
		$y = 560
		If $x < 460 Then 
			$x = 460
		EndIf
		SetLog("Adjusted Pixel :" & $x & ", " & $y, $COLOR_INFO)

		$bResult = True
	EndIf
	
	Return $bResult
EndFunc
