; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttackBB
; Description ...: This file controls attacking preperation of the builders base
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......: GrumpyHog (06-2022), (12-2022), Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Local $bFirstAttackClick 

; Only Clan Games requires a preset number of Attacks
Func DoAttackBB($iNumberOfAttacks = 0)
;	SetLog("Builder Base Attack is Disabled!", $COLOR_WARNING)
;	Return

	If Not $g_bChkEnableBBAttack And $iNumberOfAttacks = 0 Then Return False

	; active CG skip regular attacks
	If Not $g_bClanGamesCompleted And $g_IsClanGamesActive And $iNumberOfAttacks = 0 Then
		SetLog("Clan Games Active pausing regular BB Attacks")
		Return False
	Else
		SetLog("Proceeding with regular BB Attacks")
	EndIf

	SetDebugLog("$g_bChkBBTrophyRange: " & $g_bChkBBTrophyRange)
	SetDebugLog("$g_bChkBBAttIfLootAvail: " & $g_bChkBBAttIfLootAvail)
	SetDebugLog("$g_bChkBBWaitForMachine: " & $g_bChkBBWaitForMachine)

	Local $bAttack = True
	Local $iAttack = 1
	Local $bClanGames = True
	Local $MaxAttacks = Random(2, 4, 1)

	If _Sleep(3000) Then Return

	; if 0 will attack until no loot
	If $iNumberOfAttacks = 0 Then $bClanGames = False

	If $bClanGames Then SetLog("Number of Attacks: " & $iNumberOfAttacks)

	While $bAttack

		; check for troops, loot and Batlle Machine
		If Not PrepareAttackBB($bClanGames) Then
			SetLog("PrepareAttackBB failed")
			ClickAway()
			ZoomOut()
			Return False
		EndIf

		SetLog("Attack : " & $iAttack, $COLOR_BLUE)
		SetDebugLog("PrepareAttackBB(): Success.")

		_AttackBB()

		$iAttack += 1

		If $bClanGames Then
			If $iAttack > $iNumberOfAttacks Then $bAttack = False
		Else
			If $g_bChkBBAttIfLootAvail Then
				If Not CheckLootAvail(False) Then
					If _Sleep(1500) Then Return
					$bAttack = False
				Else
					If $iAttack > $MaxAttacks Then
						SetLog("Stars remaining, attacks will restart next loop", $COLOR_INFO)
						$bAttack = False
					Else
						SetLog("Attacking for Stars", $COLOR_INFO)
					EndIf
				EndIf
			Else
				$bAttack = False
			EndIf
		EndIf

	WEnd

	If _Sleep(2000) Then Return

	ClickAway()
	ZoomOut()

	Return True
EndFunc

Func ClickFindNowButton()
	Local $bRet = False
	For $i = 1 To 10
		If _ColorCheck(_GetPixelColor(655, 437 + $g_iMidOffsetY, True), Hex(0x89D239, 6), 20) Then
			Click(655, 420 + $g_iMidOffsetY, 1, "Click Find Now Button")
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(500) Then Return
	Next

	If _Sleep(8000) Then Return ; give time for find now button to go away
	If Not $bRet Then
		SetLog("Could not locate Find Now Button to go find an attack.", $COLOR_ERROR)
		ClickAway("Left")
		Return False
	EndIf

	Return $bRet
EndFunc

Func WaitCloudsBB()
	Local $bRet = True

	Local $count = 1
	While Not QuickMIS("BC1", $g_sImgBBAttackStart, 370 + $g_iMidOffsetY, 25, 430 + $g_iMidOffsetY, 60)
		If Not $g_bRunState Then Return
		If $count = 19 Then 
			SetLog("Too long waiting Clouds", $COLOR_ERROR)
		EndIf

		If $count = 21 Then
			SetLog("Try To Close and Search Again", $COLOR_ACTION)
			If $g_bDebugImageSave Then SaveDebugImage("WaitCloudsBB")
			Click(430, 535 + $g_iMidOffsetY)
			If _Sleep(3000) Then Return
			If Not ClickAttack() Then Return False
			If _Sleep(1500) Then Return
			SetLog("Try Again going to attack.", $COLOR_INFO)
			If Not ClickFindNowButton() Then
				ClickAway("Left")
				Return False
			EndIf
		EndIf

		If $count > 30 Then
			CloseCoC(True)
			checkMainScreen(False, True)
			$bRet = False
			ExitLoop
		EndIf
		If isProblemAffect(True) Then Return
		$count += 1
		If _Sleep(2000) Then Return
	WEnd
	Return $bRet
EndFunc

Func _AttackBB()
	If Not $g_bRunState Then Return
	
	SetLog("Going to attack.", $COLOR_INFO)
	If Not ClickFindNowButton() Then
		ClickAway("Left")
		Return False
	EndIf

	If Not $g_bRunState Then Return

	SetLog("Searching for Opponent.", $COLOR_BLUE)
	If Not WaitCloudsBB() Then Return
	If Not $g_bRunState Then Return

	ZoomOut() ;zoomout first before any action after COC zooms in.
	If Not isOnBuilderBaseEnemyVillage(True) Then
		SetLog("Zoom Out has failed and Attack was aborted", $COLOR_DEBUG)
		Return
	EndIf

	; Get troops on attack bar and their quantities
	$g_aMachinePos = GetMachinePos()
	$g_DeployedMachine = False
	If _Sleep(150) Then Return
	Local $aBBAttackBar = GetAttackBarBB()
	$bFirstAttackClick = True
	AttackBB($aBBAttackBar)

	If Not $g_bRunState Then Return

	If EndBattleBB() Then SetLog("Battle ended", $COLOR_INFO)
	checkObstacles($g_bStayOnBuilderBase)

	SetLog("Done", $COLOR_SUCCESS)
EndFunc

Func EndBattleBB() ; Find if battle has ended and click okay
	Local $bRet = False, $bBattleMachine = True, $bBomber = True
	Local $sDamage = 0, $sTmpDamage = 0, $bCountSameDamage = 1
	
	For $i = 1 To 200

		If Not $g_bRunState Then ExitLoop
		If $bBattleMachine Then $bBattleMachine = CheckBMLoop()
		If $bBomber Then $bBomber = CheckBomberLoop()
		$sDamage = getOcrOverAllDamage(776, 558 + $g_iMidOffsetY)
		SetDebugLog("[" & $i & "] EndBattleBB LoopCheck, [" & $bCountSameDamage & "] Overall Damage : " & $sDamage & "%", $COLOR_DEBUG2)
		If Number($sDamage) = Number($sTmpDamage) Then
			$bCountSameDamage += 1
		Else
			$bCountSameDamage = 1
		EndIf
		$sTmpDamage = Number($sDamage)
		If $sTmpDamage = 100 Then
			If _SleepStatus(12000) Then Return
			SetLog("Preparing For Second Round", $COLOR_INFO)
			If _SleepStatus(3000) Then Return

			; Get troops on attack bar and their quantities
			$g_aMachinePos = GetMachinePos()
			$g_DeployedMachine = False
			If _Sleep(150) Then Return
			Local $aBBAttackBar = GetAttackBarBB(False, True)
			AttackBB($aBBAttackBar)

			If _Sleep(5000) Then Return ; Add some delay for troops making some damage
			$sTmpDamage = 0
			$bBattleMachine = True
			$bBomber = True
		EndIf

		If $bCountSameDamage > 20 Then
			If ReturnHomeDropTrophyBB(True) Then $bRet = True
			ExitLoop
		EndIf

		If BBGoldEnd("EndBattleBB") Then
			$bRet = True
			If _Sleep(3000) Then Return
			ExitLoop
		EndIf

		If IsProblemAffect(True) Then Return
		If Not $g_bRunState Then Return
		If _Sleep(1000) Then Return
	Next

	For $i = 1 To 3
		Select
			Case QuickMIS("BC1", $g_sImgBBReturnHome, 390, 515 + $g_iMidOffsetY, 470, 560 + $g_iMidOffsetY) = True
				If _Sleep(2000) Then Return
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(3000) Then Return
			Case QuickMIS("BC1", $g_sImgBBAttackBonus, 410, 460 + $g_iMidOffsetY, 454, 490 + $g_iMidOffsetY) = True
				SetLog("Congrats Chief, Stars Bonus Awarded", $COLOR_INFO)
				If _Sleep(2000) Then Return
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(2000) Then Return
				$bRet = True
			Case isOnBuilderBase() = True
				$bRet = True
		EndSelect
		If _Sleep(1000) Then Return
	Next

	If Not $bRet Then SetLog("Could not find finish battle screen", $COLOR_ERROR)
	Return $bRet
EndFunc

Func AttackBB($aBBAttackBar = True)

	Local $iSide = Random(1, 4, 1)
	Local $ai_DropPoints
	;generate attack drop points
		Switch $iSide
			Case 1
				$ai_DropPoints = _GetVectorOutZone($eVectorLeftTop)
			Case 2
				$ai_DropPoints = _GetVectorOutZone($eVectorRightTop)
			Case 3
				$ai_DropPoints = _GetVectorOutZone($eVectorRightBottom)
			Case 4
				$ai_DropPoints = _GetVectorOutZone($eVectorLeftBottom)
		EndSwitch

	If IsProblemAffect(True) Then Return

	Local $bTroopsDropped = False
	If Not $g_bRunState Then Return

	; Deploy all troops
	SetLog( $g_bBBDropOrderSet = True ? "Deploying Troops in Custom Order." : "Deploying Troops in Order of Attack Bar.", $COLOR_BLUE)
	Local $bLoop = 0 ; Break Loop If 4 Loops
	While Not $bTroopsDropped
		If Not $g_bRunState Then Return
		Local $iNumSlots = UBound($aBBAttackBar)
		If $g_bBBDropOrderSet = True Then
			Local $asBBDropOrder = StringSplit($g_sBBDropOrder, "|")
			Local $DeployedSlot = 0
			For $i = 0 To $g_iBBTroopCount - 1 ; loop through each name in the drop order
				For $j = 0 To $iNumSlots - 1
					If $aBBAttackBar[$j][0] = $asBBDropOrder[$i+1] Then
						DeployBBTroop($aBBAttackBar[$j][0], $aBBAttackBar[$j][1] + 35, $aBBAttackBar[$j][2], $aBBAttackBar[$j][4], $ai_DropPoints)
						$DeployedSlot += 1
					EndIf
					If $DeployedSlot = $iNumSlots Then ExitLoop 2
				Next
				If _Sleep($g_iBBNextTroopDelay) Then Return; wait before next troop
				If $i = $g_iBBTroopCount - 1 Then $bLoop += 1
				If $bLoop = 4 Then
					SaveDebugImage("AttackBar")
					SetLog("All Troops Can't Be Deployed", $COLOR_DEBUG)
					SetLog("Waiting for end of battle.", $COLOR_INFO)
					ExitLoop 2
				EndIf
			Next
		Else
			Local $sTroopName = ""
			For $i = 0 To $iNumSlots - 1
				If $aBBAttackBar[$i][4] > 0 Then DeployBBTroop($aBBAttackBar[$i][0], $aBBAttackBar[$i][1] + 35, $aBBAttackBar[$i][2], $aBBAttackBar[$i][4], $ai_DropPoints)
				If $sTroopName <> $aBBAttackBar[$i][0] Then
					If _Sleep($g_iBBNextTroopDelay) Then Return; wait before next troop
				Else
					_Sleep($DELAYRESPOND) ; we are still on same troop so lets drop them all down a bit faster
				EndIf
				$sTroopName = $aBBAttackBar[$i][0]
				If $i = $iNumSlots - 1 Then $bLoop += 1
				If $bLoop = 4 Then
					SaveDebugImage("AttackBar")
					SetLog("All Troops Can't Be Deployed", $COLOR_DEBUG)
					SetLog("Waiting for end of battle.", $COLOR_INFO)
					ExitLoop 2
				EndIf
			Next
		EndIf
		$aBBAttackBar = GetAttackBarBB(True)
		If $aBBAttackBar = "" Then
			SetLog("All Troops Deployed", $COLOR_SUCCESS)
			SetLog("Waiting for end of battle.", $COLOR_INFO)
			$bTroopsDropped = True
		EndIf
	WEnd

	If Not $g_bRunState Then Return 
	If IsProblemAffect(True) Then Return

	If Not $g_bRunState Then Return 
	Return
EndFunc   ;==>AttackBB

Func DeployBBTroop($sName, $x, $y, $iAmount, $ai_AttackDropPoints)

	If $sName = "BattleMachine" Then
		Local $aBMPos = GetMachinePos()
		If IsArray($aBMPos) And $aBMPos <> 0 Then
			If StringInStr($aBMPos[2], "Copter") Then
				$sName = "Battle Copter"
			Else
				$sName = "Battle Machine"
			EndIf
		EndIf
		SetLog("Deploying " & $sName, $COLOR_ACTION)
	Else
		SetLog("Deploying " & $sName & " x" & String($iAmount), $COLOR_ACTION)
	EndIf

	PureClick($x, $y) ; select troop
	If _Sleep($g_iBBSameTroopDelay) Then Return ; slow down selecting then dropping troops

	For $j = 0 To $iAmount - 1
		; get random drop point
		Local $iPoint = Random(0, UBOUND($ai_AttackDropPoints) - 1, 1)
		Local $iPixel = $ai_AttackDropPoints[$iPoint]

		If $bFirstAttackClick Then
			IsClickOnPotions($iPixel[0], $iPixel[1])
			$bFirstAttackClick = False
		EndIf

		PureClickP($iPixel)
		Local $b_MachineTimeOffset = 0
		If $sName = "Battle Copter" Or $sName = "Battle Machine" Then
			Local $b_MachineTimeOffsetDiff = TimerInit()
			Local $bRet = False
			For $i = 1 To 16 ; 4 seconds limit
				If _Sleep(250) Then Return
				Local $aBMPosCheck = GetMachinePos()
				If IsArray($aBMPosCheck) And $aBMPosCheck <> 0 And Number($aBMPos[1]) <> Number($aBMPosCheck[1]) Then
					If $g_bDebugSetLog Then
						Local $b_MachineTimeOffsetSec = Round($b_MachineTimeOffset/1000, 2)
						SetLog("$aBMPosCheck fixed in : " & $b_MachineTimeOffsetSec & " second", $COLOR_DEBUG)
					EndIf
					$bRet = True
				EndIf
				$b_MachineTimeOffset = TimerDiff($b_MachineTimeOffsetDiff)
				If $bRet Then ExitLoop
			Next
			Local $g_DeployColor[2] = [0xC026F8, 0xFF65F]
			For $z = 0 To 1
				If WaitforPixel(41, 552 + $g_iBottomOffsetY, 43, 554 + $g_iBottomOffsetY, Hex($g_DeployColor[$z], 6), 30, 20) Then
					$g_DeployedMachine = True
					SetLog($sName & " Deployed", $COLOR_SUCCESS)
					PureClickP($aBMPos) ; Activate Ability
					SetLog("Activate " & $sName & " Ability", $COLOR_SUCCESS)
					ExitLoop
				EndIf
				If $z = 1 Then SaveDebugImage("AttackBar")
			Next
		EndIf
		If Number($g_iBBSameTroopDelay - $b_MachineTimeOffset) > 0 Then
			If _Sleep($g_iBBSameTroopDelay - $b_MachineTimeOffset) Then Return ; slow down dropping of troops
		EndIf
	Next
 EndFunc

Func GetMachinePos()
	Local $aBMPos = QuickMIS("CNX", $g_sImgBBBattleMachine, 28, 540 + $g_iBottomOffsetY, 100, 665 + $g_iBottomOffsetY)
	Local $aCoords[3]
	If $aBMPos = -1 Then Return 0

    If IsArray($aBMPos) Then
		$aCoords[0] = $aBMPos[0][1] ;x
		$aCoords[1] = $aBMPos[0][2] ;y
		$aCoords[2] = $aBMPos[0][0] ;Name
		Return $aCoords
    EndIf
	Return 0
EndFunc

Func CheckBMLoop($aBMPos = $g_aMachinePos)
	Local $count = 0, $loopcount = 0
	Local $BMDeadX = 89, $BMDeadColor
	Local $BMDeadY = 664 + $g_iBottomOffsetY
	Local $MachineName = ""

	If $aBMPos = 0 Or Not $g_bMachineAliveOnAttackBar Then Return False
	If Not IsArray($aBMPos) Then Return False

	If StringInStr($aBMPos[2], "Copter") Then
		$MachineName = "Battle Copter"
	Else
		$MachineName = "Battle Machine"
	EndIf

	Local $bCountSameDamage = 1, $sTmpDamage = ""
	For $i = 1 To 5
		If IsProblemAffect(True) Then Return
		If Not $g_bRunState Then Return

		If QuickMIS("BC1", $g_sImgDirMachineAbility, $aBMPos[0] - 35, $aBMPos[1] - 40, $aBMPos[0] + 35, $aBMPos[1] + 40) Then
			If StringInStr($g_iQuickMISName, "Wait") Then
				ExitLoop
			ElseIf StringInStr($g_iQuickMISName, "Ability") Then
				PureClickP($aBMPos)
				SetLog("Activate " & $MachineName & " Ability", $COLOR_SUCCESS)
				ExitLoop
			EndIf
		EndIf

		$BMDeadColor = _GetPixelColor($BMDeadX, $BMDeadY, True)
		If _ColorCheck($BMDeadColor, Hex(0x484848, 6), 20, Default) Then
			SetLog($MachineName & " is Dead", $COLOR_DEBUG2)
			Return False
		EndIf

		If $BMDeadColor = "000000" Then
			ExitLoop
		EndIf

		If _Sleep(500) Then Return
		If $loopcount > 60 Then Return ;1 minute
		$loopcount += 1
	Next
	Return True
EndFunc

Func CheckBomberLoop()
	Local $bRet = True
	If Not $g_bBomberOnAttackBar Or UBound($g_aBomberOnAttackBar) = 0 Then Return False
	Local $isGreyBanner = False, $ColorPickBannerX = 0, $iTroopBanners = 583 + $g_iBottomOffsetY

	For $i = 0 To UBound($g_aBomberOnAttackBar) - 1
		If Not $g_bRunState Then Return
		$ColorPickBannerX = $g_aBomberOnAttackBar[$i][0] + 37
		$isGreyBanner = _ColorCheck(_GetPixelColor($ColorPickBannerX, $iTroopBanners, True), Hex(0x707070, 6), 10, Default) ;Grey Banner on TroopSlot = Troop Die
		If $isGreyBanner Then 
			SetLog("Bomber is Dead", $COLOR_DEBUG2)
			$bRet = False
			ExitLoop
		EndIf
		If QuickMIS("BC1", $g_sImgDirBomberAbility, $g_aBomberOnAttackBar[$i][0], $g_aBomberOnAttackBar[$i][1] - 30, $g_aBomberOnAttackBar[$i][0] + 70, $g_aBomberOnAttackBar[$i][1] + 30) Then
			If StringInStr($g_iQuickMISName, "Ability") Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				SetLog("Activate Bomber Ability", $COLOR_SUCCESS)
			EndIf
			ExitLoop
		EndIf
	Next
	Return $bRet
EndFunc

Func IsBBAttackPage()
	Local $bRet = False
	If _ColorCheck(_GetPixelColor(22, 550 + $g_iMidOffsetY, True), Hex(0xCD0D0D, 6), 20) Then ;check red color on surrender button
		$bRet = True
	EndIf
	Return $bRet
EndFunc

Func BBGoldEnd($sLogText = "BBGoldEnd")
	If _CheckPixel($aBBGoldEnd, True, Default, $sLogText) Then
		SetDebugLog("Battle Ended", $COLOR_DEBUG2)
		Return True
	Else
		Return False
	EndIf
EndFunc

Func IsClickOnPotions(ByRef $x, ByRef $y)
	Local $bResult = False
	SetDebugLog("IsClickOnPotions :" & $x & ", " & $y, $COLOR_INFO)
	If $y > 500 + $g_iBottomOffsetY  Then
		$y = 500 + $g_iBottomOffsetY
		If $x < 460 Then 
			$x = 460
		EndIf
		SetDebugLog("Adjusted Pixel :" & $x & ", " & $y, $COLOR_INFO)
		$bResult = True
	EndIf
	Return $bResult
EndFunc