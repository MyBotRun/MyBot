; #FUNCTION# ====================================================================================================================
; Name ..........: BoostBarracks.au3
; Description ...:
; Syntax ........: BoostBarracks(), BoostSpellFactory()
; Parameters ....:
; Return values .: None
; Author ........: MR.ViPER (9/9/2016)
; Modified ......: MR.ViPER (17/10/2016), Fliegerfaust (21/12/2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BoostBarracks()
	Return BoostTrainBuilding("Barracks", $g_iCmbBoostBarracks, $g_hCmbBoostBarracks)
EndFunc

Func BoostSpellFactory()
	Return BoostTrainBuilding("Spell Factory", $g_iCmbBoostSpellFactory, $g_hCmbBoostSpellFactory)
EndFunc   ;==>BoostSpellFactory

Func BoostTrainBuilding($sName, $iCmbBoost, $iCmbBoostCtrl)

	If Not $g_bTrainEnabled Or $iCmbBoost <= 0 Then Return

	Local $aHours = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
	If Not $g_abBoostBarracksHours[$aHours[0]] Then
		SetLog("Boosting " & $sName & " isn't planned, skipping", $COLOR_INFO)
		Return
	EndIf

	SetLog("Boosting " & $sName, $COLOR_INFO)

	If OpenArmyOverview(True, "BoostTrainBuilding()") Then

		If $sName = "Barracks" Then
			OpenTroopsTab(False, "BoostTrainBuilding()")
		Else
			OpenSpellsTab(False, "BoostTrainBuilding()")
		EndIf

		Local $aBoostBtn = findButton("BoostBarrack")
		If IsArray($aBoostBtn) Then
			ClickP($aBoostBtn)
			_Sleep($DELAYBOOSTBARRACKS1)
			Local $aGemWindowBtn = findButton("GEM")
			If IsArray($aGemWindowBtn) Then
				ClickP($aGemWindowBtn)
				_Sleep($DELAYBOOSTBARRACKS2)
				If IsArray(findButton("EnterShop")) Then
					SetLog("Not enough gems to boost " & $sName, $COLOR_ERROR)
				Else
					If $iCmbBoost >= 1 And $iCmbBoost <= 24 Then
						$iCmbBoost -= 1
						_GUICtrlComboBox_SetCurSel($iCmbBoostCtrl, $iCmbBoost)
						Setlog("Remaining " & $sName & " Boosts: " & $iCmbBoost, $COLOR_SUCCESS)
					ElseIf $iCmbBoost = 25 Then
						Setlog("Remain " & $sName & " Boosts: Unlimited", $COLOR_SUCCESS)
					EndIf
				EndIf
				_Sleep($DELAYBOOSTBARRACKS1)
				ClickP($aAway, 1, 0, "#0161")
				Return True
			EndIf
		Else
			If IsArray(findButton("BarrackBoosted")) Then
				SetLog( $sName & " is already boosted", $COLOR_INFO)
			Else
				SetLog($sName & "boost button not found", $COLOR_ERROR)
			ClickP($aAway, 1, 0, "#0161")
			Return False
			EndIf
		EndIf
	EndIf
EndFunc
