; #FUNCTION# ====================================================================================================================
; Name ..........: ArmyHeroStatus
; Description ...: Obtain Status of Heroes, Available, Healing, Upgrading...
; Syntax ........: ArmyHeroStatus($iHeroEnum = $eKing, $bReturnTimeArray = False, $bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....: $Hero = enum value for hero to OR Hero name
; Return values .: MR.ViPER (16-10-2016)
; Author ........:
; Modified ......: MR.ViPER (10-12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func ArmyHeroStatus($Hero)
	Local $directory = "trainwindow-HeroStatus-bundle"
	Local Const $aHeroesRect[3][4] = [[610, 340, 683, 390], [683, 340, 758, 390], [757, 340, 833, 390]] ; [[643, 340, 683, 390], [718, 340, 758, 390], [749, 340, 833, 390]]
	Local $Result, $Status

	Select
		Case $Hero = "King" Or $Hero = 0 Or $Hero = $eKing
			$Result = SearchArmy($directory, $aHeroesRect[0][0], $aHeroesRect[0][1], $aHeroesRect[0][2], $aHeroesRect[0][3], "", True)
			$Status = $Result[0][0]
			If $Status = "" Then $Status = "king"
			Return $Status
		Case $Hero = "Queen" Or $Hero = 1 Or $Hero = $eQueen
			$Result = SearchArmy($directory, $aHeroesRect[1][0], $aHeroesRect[1][1], $aHeroesRect[1][2], $aHeroesRect[1][3], "", True)
			$Status = $Result[0][0]
			If $Status = "" Then $Status = "queen"
			Return $Status
		Case $Hero = "Warden" Or $Hero = 2 Or $Hero = $eWarden
			$Result = SearchArmy($directory, $aHeroesRect[2][0], $aHeroesRect[2][1], $aHeroesRect[2][2], $aHeroesRect[2][3], "", True)
			$Status = $Result[0][0]
			If $Status = "" Then $Status = "warden"
			Return $Status
	EndSelect
EndFunc   ;==>ArmyHeroStatus

Func CountHeroes()
	Local $directory =  "trainwindow-HeroStatus-bundle"
	Local Const $aHeroesRect[3][4] = [[643, 340, 683, 390], [718, 340, 758, 390], [749, 340, 833, 390]]
	Local $Result, $Status
	Local $Available = 0, $Healing = 0, $Upgrading = 0, $None = 0, $AvaiAndHealing = 0
	Local $ToReturn[5] = [$Available, $Healing, $Upgrading, $None, $AvaiAndHealing]
	For $i = 0 To (UBound($aHeroesRect) - 1)
		$Result = SearchArmy($directory, $aHeroesRect[$i][0], $aHeroesRect[$i][1], $aHeroesRect[$i][2], $aHeroesRect[$i][3], "", True)
		$Status = $Result[0][0]
		Switch $Status
			Case "heal"
				$Healing += 1
			Case "upgrade"
				$Upgrading += 1
			Case "none"
				$None += 1
			Case Else
				$Available += 1
		EndSwitch
	Next
	$AvaiAndHealing = Number($Available + $Healing)
	$ToReturn[0] = $Available
	$ToReturn[1] = $Healing
	$ToReturn[2] = $Upgrading
	$ToReturn[3] = $None
	$ToReturn[4] = $AvaiAndHealing
	Return $ToReturn
EndFunc   ;==>CountHeroes
