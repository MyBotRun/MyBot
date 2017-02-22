; #FUNCTION# ====================================================================================================================
; Name ..........: algorith_AllTroops
; Description ...: This file contens all functions to attack algorithm will all Troops , using Barbarians, Archers, Goblins, Giants and Wallbreakers as they are available
; Syntax ........: algorithm_AllTroops()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Didipe (May-2015), ProMac(2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func algorithm_AllTroops() ;Attack Algorithm for all existing troops
	If $g_iDebugSetlog = 1 Then Setlog("algorithm_AllTroops", $COLOR_DEBUG)
	SetSlotSpecialTroops()

	If _Sleep($iDelayalgorithm_AllTroops1) Then Return

	SmartAttackStrategy($g_iMatchMode) ; detect redarea first to drop any troops

	; If one of condtions passed then start TH snipe attack
	; - detect matchmode TS
	; - detect matchmode DB and enabled TH snipe before attack and th outside
	; - detect matchmode LB and enabled TH snipe before attack and th outside
	If ($searchTH = "-"  And ($g_iMatchMode = $DB And $g_bTHSnipeBeforeEnable[$DB])) Or _
	   ($searchTH = "-"  And ($g_iMatchMode = $LB and $g_bTHSnipeBeforeEnable[$LB])) Then

	   FindTownHall(True) ;If no previous detect townhall search th position
    EndIf

	Local $bTHSearchTemp = SearchTownHallLoc()
	If $g_iMatchMode = $TS Or _
	   ($g_iMatchMode = $DB And $g_bTHSnipeBeforeEnable[$DB] And $bTHSearchTemp = True) Or _
	   ($g_iMatchMode = $LB And $g_bTHSnipeBeforeEnable[$LB] And $bTHSearchTemp = True) Then

		SwitchAttackTHType()
	EndIf

	If $g_iMatchMode = $TS Then; Return ;Exit attacking if trophy hunting and not bullymode
		If ($THusedKing = 1 Or $THusedQueen = 1) And ($ichkSmartZap = 1 And $ichkSmartZapSaveHeroes = 1) Then
			SetLog("King and/or Queen dropped, close attack")
			If $ichkSmartZap = 1 Then SetLog("Skipping SmartZap to protect your royals!", $COLOR_FUCHSIA)
		ElseIf IsAttackPage() And Not SmartZap() And $THusedKing = 0 And $THusedQueen = 0 Then
			Setlog("Wait few sec before close attack")
			If _Sleep(Random(0, 2, 1) * 1000) Then Return ;wait 0-2 second before exit if king and queen are not dropped
		EndIf

		;Apply to switch Attack Standard after THSnipe End  ==>
		If CompareResources($DB) And $g_aiAttackAlgorithm[$DB] = 0 And $g_bEndTSCampsEnable And Int($CurCamp / $TotalCamp * 100) >= Int($g_iEndTSCampsPct) then
			$g_iMatchMode = $DB
		Else
			CloseBattle()
			Return
		EndIf
	EndIf



	;############################################# LSpell Attack ############################################################
	; DropLSpell()
	;########################################################################################################################
	Local $nbSides = 0
	Switch $g_aiAttackStdDropSides[$g_iMatchMode]
		Case 0 ;Single sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on a single side", $COLOR_INFO)
			$nbSides = 1
		Case 1 ;Two sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on two sides", $COLOR_INFO)
			$nbSides = 2
		Case 2 ;Three sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on three sides", $COLOR_INFO)
			$nbSides = 3
		Case 3 ;All sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on all sides", $COLOR_INFO)
			$nbSides = 4
		Case 4 ;DE Side - Live Base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on Dark Elixir Side.", $COLOR_INFO)
			$nbSides = 1
			If Not ($g_abAttackStdSmartAttack[$g_iMatchMode]) Then GetBuildingEdge($eSideBuildingDES) ; Get DE Storage side when Redline is not used.
		Case 5 ;TH Side - Live Base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on Town Hall Side.", $COLOR_INFO)
			$nbSides = 1
			If Not ($g_abAttackStdSmartAttack[$g_iMatchMode]) Then GetBuildingEdge($eSideBuildingTH) ; Get Townhall side when Redline is not used.
	EndSwitch
	If ($nbSides = 0) Then Return
	If _Sleep($iDelayalgorithm_AllTroops2) Then Return

	; $ListInfoDeploy = [Troop, No. of Sides, $WaveNb, $MaxWaveNb, $slotsPerEdge]
	If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 Then ; Customise DE side wave deployment here
		Switch $g_aiAttackStdDropOrder[$g_iMatchMode]
			Case 0
				Local $listInfoDeploy[21][5] = [[$eGole, $nbSides, 1, 1, 2] _
						, [$eLava, $nbSides, 1, 1, 2] _
						, [$eGiant, $nbSides, 1, 1, 2] _
						, [$eDrag, $nbSides, 1, 1, 0] _
						, [$eBall, $nbSides, 1, 1, 0] _
						, [$eBabyD, $nbSides, 1, 1, 1] _
						, [$eHogs, $nbSides, 1, 1, 1] _
						, [$eValk, $nbSides, 1, 1, 0] _
						, [$eBowl, $nbSides, 1, 1, 0] _
						, [$eMine, $nbSides, 1, 1, 0] _
						, [$eBarb, $nbSides, 1, 1, 0] _
						, [$eWall, $nbSides, 1, 1, 1] _
						, [$eArch, $nbSides, 1, 1, 0] _
						, [$eWiza, $nbSides, 1, 1, 0] _
						, [$eMini, $nbSides, 1, 1, 0] _
						, [$eWitc, $nbSides, 1, 1, 1] _
						, [$eGobl, $nbSides, 1, 1, 0] _
						, ["CC", 1, 1, 1, 1] _
						, [$eHeal, $nbSides, 1, 1, 1] _
						, [$ePekk, $nbSides, 1, 1, 1] _
						, ["HEROES", 1, 2, 1, 1] _
						]
			Case 1
				Local $listInfoDeploy[6][5] = [[$eBarb, $nbSides, 1, 1, 0] _
						, [$eArch, $nbSides, 1, 1, 0] _
						, [$eGobl, $nbSides, 1, 1, 0] _
						, [$eMini, $nbSides, 1, 1, 0] _
						, ["CC", 1, 1, 1, 1] _
						, ["HEROES", 1, 2, 1, 1] _
						]
			Case 2
				Local $listInfoDeploy[13][5] = [[$eGiant, $nbSides, 1, 1, 2] _
						, [$eWall, $nbSides, 1, 1, 2] _
						, [$eBarb, $nbSides, 1, 2, 2] _
						, [$eArch, $nbSides, 1, 3, 3] _
						, [$eBarb, $nbSides, 2, 2, 2] _
						, [$eArch, $nbSides, 2, 3, 3] _
						, ["CC", 1, 1, 1, 1] _
						, ["HEROES", 1, 2, 1, 0] _
						, [$eHogs, $nbSides, 1, 1, 1] _
						, [$eWiza, $nbSides, 1, 1, 0] _
						, [$eMini, $nbSides, 1, 1, 0] _
						, [$eArch, $nbSides, 3, 3, 2] _
						, [$eGobl, $nbSides, 1, 1, 1] _
						]
		EndSwitch
	Else
		If $g_iDebugSetlog = 1 Then SetLog("listdeploy standard for attack", $COLOR_DEBUG)
		Switch $g_aiAttackStdDropOrder[$g_iMatchMode]
			Case 0
				Local $listInfoDeploy[21][5] = [[$eGole, $nbSides, 1, 1, 2] _
						, [$eLava, $nbSides, 1, 1, 2] _
						, [$eGiant, $nbSides, 1, 1, 2] _
						, [$eDrag, $nbSides, 1, 1, 0] _
						, [$eBall, $nbSides, 1, 1, 0] _
						, [$eBabyD, $nbSides, 1, 1, 0] _
						, [$eHogs, $nbSides, 1, 1, 1] _
						, [$eValk, $nbSides, 1, 1, 0] _
						, [$eBowl, $nbSides, 1, 1, 0] _
						, [$eMine, $nbSides, 1, 1, 0] _
						, [$eBarb, $nbSides, 1, 1, 0] _
						, [$eWall, $nbSides, 1, 1, 1] _
						, [$eArch, $nbSides, 1, 1, 0] _
						, [$eWiza, $nbSides, 1, 1, 0] _
						, [$eMini, $nbSides, 1, 1, 0] _
						, [$eWitc, $nbSides, 1, 1, 1] _
						, [$eGobl, $nbSides, 1, 1, 0] _
						, ["CC", 1, 1, 1, 1] _
						, [$eHeal, $nbSides, 1, 1, 1] _
						, [$ePekk, $nbSides, 1, 1, 1] _
						, ["HEROES", 1, 2, 1, 1] _
						]
			Case 1
				Local $listInfoDeploy[6][5] = [[$eBarb, $nbSides, 1, 1, 0] _
						, [$eArch, $nbSides, 1, 1, 0] _
						, [$eGobl, $nbSides, 1, 1, 0] _
						, [$eMini, $nbSides, 1, 1, 0] _
						, ["CC", 1, 1, 1, 1] _
						, ["HEROES", 1, 2, 1, 1] _
						]
			Case 2
				Local $listInfoDeploy[13][5] = [[$eGiant, $nbSides, 1, 1, 2] _
						, [$eBarb, $nbSides, 1, 2, 0] _
						, [$eWall, $nbSides, 1, 1, 1] _
						, [$eArch, $nbSides, 1, 2, 0] _
						, [$eBarb, $nbSides, 2, 2, 0] _
						, [$eGobl, $nbSides, 1, 2, 0] _
						, ["CC", 1, 1, 1, 1] _
						, [$eHogs, $nbSides, 1, 1, 1] _
						, [$eWiza, $nbSides, 1, 1, 0] _
						, [$eMini, $nbSides, 1, 1, 0] _
						, [$eArch, $nbSides, 2, 2, 0] _
						, [$eGobl, $nbSides, 2, 2, 0] _
						, ["HEROES", 1, 2, 1, 1] _
						]
			Case Else
				SetLog("Algorithm type unavailable, defaulting to regular", $COLOR_ERROR)
				Local $listInfoDeploy[13][5] = [[$eGiant, $nbSides, 1, 1, 2] _
						, [$eBarb, $nbSides, 1, 2, 0] _
						, [$eWall, $nbSides, 1, 1, 1] _
						, [$eArch, $nbSides, 1, 2, 0] _
						, [$eBarb, $nbSides, 2, 2, 0] _
						, [$eGobl, $nbSides, 1, 2, 0] _
						, ["CC", 1, 1, 1, 1] _
						, [$eHogs, $nbSides, 1, 1, 1] _
						, [$eWiza, $nbSides, 1, 1, 0] _
						, [$eMini, $nbSides, 1, 1, 0] _
						, [$eArch, $nbSides, 2, 2, 0] _
						, [$eGobl, $nbSides, 2, 2, 0] _
						, ["HEROES", 1, 2, 1, 1] _
						]
		EndSwitch
	EndIf

	$isCCDropped = False
	$DeployCCPosition[0] = -1
	$DeployCCPosition[1] = -1
	$isHeroesDropped = False
	$DeployHeroesPosition[0] = -1
	$DeployHeroesPosition[1] = -1

	LaunchTroop2($listInfoDeploy, $CC, $King, $Queen, $Warden)

	If _Sleep($iDelayalgorithm_AllTroops4) Then Return
	SetLog("Dropping left over troops", $COLOR_INFO)
	For $x = 0 To 1
		IF PrepareAttack($g_iMatchMode, True) = 0 Then
			If $g_iDebugSetlog = 1 Then Setlog("No Wast time... exit, no troops usable left",$COLOR_DEBUG)
			ExitLoop ;Check remaining quantities
		EndIf
		For $i = $eBarb To $eBowl ; lauch all remaining troops
			;If $i = $eBarb Or $i = $eArch Then
			LauchTroop($i, $nbSides, 0, 1)
			If $iActivateKQCondition = "Auto" then CheckHeroesHealth()
			;Else
			;	 LauchTroop($i, $nbSides, 0, 1, 2)
			;EndIf
			If _Sleep($iDelayalgorithm_AllTroops5) Then Return
		Next
	Next

	;Activate Heroe's power Manual after X seconds
	If ($checkKPower Or $checkQPower or $checkWPower) And $iActivateKQCondition = "Manual" Then
		SetLog("Waiting " & $delayActivateKQ / 1000 & " seconds before activating Hero abilities", $COLOR_INFO)
		If _Sleep($delayActivateKQ) Then Return
		If $checkKPower Then
			SetLog("Activating King's power", $COLOR_INFO)
			SelectDropTroop($King)
			$checkKPower = False
		EndIf
		If $checkQPower Then
			SetLog("Activating Queen's power", $COLOR_INFO)
			SelectDropTroop($Queen)
			$checkQPower = False
		EndIf
		If $checkWPower then
			SetLog("Activating Warden's power", $COLOR_INFO)
			SelectDropTroop($Warden)
			$checkWPower = False
		EndIf
	EndIf

	SetLog("Finished Attacking, waiting for the battle to end")
EndFunc   ;==>algorithm_AllTroops

Func SetSlotSpecialTroops()
	$King = -1
	$Queen = -1
	$CC = -1
	$Warden = -1
	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = $eCastle Then
			$CC = $i
		ElseIf $atkTroops[$i][0] = $eKing Then
			$King = $i
		ElseIf $atkTroops[$i][0] = $eQueen Then
			$Queen = $i
		ElseIf $atkTroops[$i][0] = $eWarden Then
			$Warden = $i
		EndIf
	Next
	If $g_iDebugSetlog = 1 Then SetLog("Use king SLOT # " & $King, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then SetLog("Use queen SLOT # " & $Queen, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then SetLog("Use CC SLOT # " & $CC, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then SetLog("Use Warden SLOT # " & $Warden, $COLOR_DEBUG)
EndFunc   ;==>SetSlotSpecialTroops

Func CloseBattle()
	If IsAttackPage() Then
		For $i = 1 To 30
			;_CaptureRegion()
			If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) = True Then ExitLoop ;exit if not 'no star'
			If _Sleep($iDelayalgorithm_AllTroops2) Then Return
		Next
	EndIf

	If IsAttackPage() Then ClickP($aSurrenderButton, 1, 0, "#0030") ;Click Surrender
	If _Sleep($iDelayalgorithm_AllTroops3) Then Return
	If IsEndBattlePage() Then
		ClickP($aConfirmSurrender, 1, 0, "#0031") ;Click Confirm
		If _Sleep($iDelayalgorithm_AllTroops1) Then Return
	EndIf

EndFunc   ;==>CloseBattle


Func SmartAttackStrategy($imode)
	If $g_iMatchMode <> $MA then ; (milking attack use own strategy)

		If ($g_abAttackStdSmartAttack[$imode]) Then
			SetLog("Calculating Smart Attack Strategy", $COLOR_INFO)
			Local $hTimer = TimerInit()
			_CaptureRegion2()
			_GetRedArea()

			SetLog("Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
			;SetLog("	[" & UBound($PixelTopLeft) & "] pixels TopLeft")
			;SetLog("	[" & UBound($PixelTopRight) & "] pixels TopRight")
			;SetLog("	[" & UBound($PixelBottomLeft) & "] pixels BottomLeft")
			;SetLog("	[" & UBound($PixelBottomRight) & "] pixels BottomRight")

			If ($g_abAttackStdSmartNearCollectors[$imode][0] Or $g_abAttackStdSmartNearCollectors[$imode][1] Or $g_abAttackStdSmartNearCollectors[$imode][2]) Then
				SetLog("Locating Mines, Collectors & Drills", $COLOR_INFO)
				$hTimer = TimerInit()
				Global $PixelMine[0]
				Global $PixelElixir[0]
				Global $PixelDarkElixir[0]
				Global $PixelNearCollector[0]
				; If drop troop near gold mine
				If $g_abAttackStdSmartNearCollectors[$imode][0] Then
					$PixelMine = GetLocationMine()
					If (IsArray($PixelMine)) Then
						_ArrayAdd($PixelNearCollector, $PixelMine)
					EndIf
				EndIf
				; If drop troop near elixir collector
				If $g_abAttackStdSmartNearCollectors[$imode][1] Then
					$PixelElixir = GetLocationElixir()
					If (IsArray($PixelElixir)) Then
						_ArrayAdd($PixelNearCollector, $PixelElixir)
					EndIf
				EndIf
				; If drop troop near dark elixir drill
				If $g_abAttackStdSmartNearCollectors[$imode][2] Then
					$PixelDarkElixir = GetLocationDarkElixir()
					If (IsArray($PixelDarkElixir)) Then
						_ArrayAdd($PixelNearCollector, $PixelDarkElixir)
					EndIf
				EndIf
				SetLog("Located  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
				SetLog("[" & UBound($PixelMine) & "] Gold Mines")
				SetLog("[" & UBound($PixelElixir) & "] Elixir Collectors")
				SetLog("[" & UBound($PixelDarkElixir) & "] Dark Elixir Drill/s")
				$iNbrOfDetectedMines[$imode] += UBound($PixelMine)
				$iNbrOfDetectedCollectors[$imode] += UBound($PixelElixir)
				$iNbrOfDetectedDrills[$imode] += UBound($PixelDarkElixir)
				UpdateStats()
			EndIf

		EndIf
	EndIf

EndFunc