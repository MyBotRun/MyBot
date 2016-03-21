; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func cmbTroopComp()

	If _GUICtrlComboBox_GetCurSel($cmbTroopComp) <> $icmbTroopComp Then
		$icmbTroopComp = _GUICtrlComboBox_GetCurSel($cmbTroopComp)
		For $i = 0 To UBound($TroopName) - 1
			Assign("Cur" & $TroopName[$i], 1)
		Next
		For $i = 0 To UBound($TroopDarkName) - 1
			Assign("Cur" & $TroopDarkName[$i], 1)
		Next
		SetComboTroopComp()
	EndIf

EndFunc   ;==>cmbTroopComp

Func cmbDarkTroopComp()

	If _GUICtrlComboBox_GetCurSel($cmbDarkTroopComp) <> $icmbDarkTroopComp Then
		$icmbDarkTroopComp = _GUICtrlComboBox_GetCurSel($cmbDarkTroopComp)

		SetComboDarkTroopComp()
	EndIf

EndFunc   ;==>cmbDarkTroopComp

Func SetComboDarkTroopComp()

	Switch _GUICtrlComboBox_GetCurSel($cmbDarkTroopComp)
		Case 0 ; Barrack Mode

			For $i = 1 To 2
				GUICtrlSetState(Eval("cmbDarkBarrack" & $i), $GUI_SHOW)
				GUICtrlSetState(Eval("cmbDarkBarrack" & $i), $GUI_ENABLE)
				GUICtrlSetState(Eval("lblDarkBarrack" & $i), $GUI_SHOW)
			Next

			HideDarkCustomControls()
			ShowDarkBarrackControls()

		Case 1 ; Custom Mode

			HideDarkBarrackControls()
			ShowDarkCustomControls()

		Case 2;none

			HideDarkBarrackControls()
			HideDarkCustomControls()
	EndSwitch

EndFunc   ;==>SetComboDarkTroopComp

Func ShowDarkBarrackControls()

	GUICtrlSetState($grpDarkBarrackMode, $GUI_SHOW)

	For $i = 1 To 2
		GUICtrlSetState(Eval("cmbDarkBarrack" & $i), $GUI_SHOW)
		GUICtrlSetState(Eval("cmbDarkBarrack" & $i), $GUI_ENABLE)
		GUICtrlSetState(Eval("lblDarkBarrack" & $i), $GUI_SHOW)
	Next

EndFunc   ;==>ShowDarkBarrackControls

Func ShowDarkCustomControls()

	GUICtrlSetState($grpDarkTroops, $GUI_SHOW)

	For $i = 0 To UBound($TroopDarkName) - 1
		GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_SHOW + $GUI_ENABLE)
	Next

	GUICtrlSetState($lblMinion, $GUI_SHOW)
	GUICtrlSetState($lblHogRiders, $GUI_SHOW)
	GUICtrlSetState($lblValkyries, $GUI_SHOW)
	GUICtrlSetState($lblGolems, $GUI_SHOW)
	GUICtrlSetState($lblWitches, $GUI_SHOW)
	GUICtrlSetState($lblLavaHounds, $GUI_SHOW)

	GUICtrlSetState($lblTimesMinions, $GUI_SHOW)
	GUICtrlSetState($lblTimesHogRiders, $GUI_SHOW)
	GUICtrlSetState($lblTimesValkyries, $GUI_SHOW)
	GUICtrlSetState($lblTimesGolems, $GUI_SHOW)
	GUICtrlSetState($lblTimesWitches, $GUI_SHOW)
	GUICtrlSetState($lblTimesLavaHounds, $GUI_SHOW)

	GUICtrlSetState($icnMini, $GUI_SHOW)
	GUICtrlSetState($icnHogs, $GUI_SHOW)
	GUICtrlSetState($icnValk, $GUI_SHOW)
	GUICtrlSetState($icnGole, $GUI_SHOW)
	GUICtrlSetState($icnWitc, $GUI_SHOW)
	GUICtrlSetState($icnLava, $GUI_SHOW)

EndFunc   ;==>ShowDarkCustomControls

Func HideDarkBarrackControls()

	GUICtrlSetState($grpDarkBarrackMode, $GUI_HIDE)
	For $i = 1 To 2
		GUICtrlSetState(Eval("cmbDarkBarrack" & $i), $GUI_HIDE)
		GUICtrlSetState(Eval("lblDarkBarrack" & $i), $GUI_HIDE)
	Next

EndFunc   ;==>HideDarkBarrackControls

Func HideDarkCustomControls()

	GUICtrlSetState($grpDarkTroops, $GUI_HIDE)

	For $i = 0 To UBound($TroopDarkName) - 1
		GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_HIDE)
	Next

	GUICtrlSetState($lblMinion, $GUI_HIDE)
	GUICtrlSetState($lblHogRiders, $GUI_HIDE)
	GUICtrlSetState($lblValkyries, $GUI_HIDE)
	GUICtrlSetState($lblGolems, $GUI_HIDE)
	GUICtrlSetState($lblWitches, $GUI_HIDE)
	GUICtrlSetState($lblLavaHounds, $GUI_HIDE)

	GUICtrlSetState($lblTimesMinions, $GUI_HIDE)
	GUICtrlSetState($lblTimesHogRiders, $GUI_HIDE)
	GUICtrlSetState($lblTimesValkyries, $GUI_HIDE)
	GUICtrlSetState($lblTimesGolems, $GUI_HIDE)
	GUICtrlSetState($lblTimesWitches, $GUI_HIDE)
	GUICtrlSetState($lblTimesLavaHounds, $GUI_HIDE)

	GUICtrlSetState($icnMini, $GUI_HIDE)
	GUICtrlSetState($icnHogs, $GUI_HIDE)
	GUICtrlSetState($icnValk, $GUI_HIDE)
	GUICtrlSetState($icnGole, $GUI_HIDE)
	GUICtrlSetState($icnWitc, $GUI_HIDE)
	GUICtrlSetState($icnLava, $GUI_HIDE)

EndFunc   ;==>HideDarkCustomControls

Func SetComboTroopComp()

	Switch _GUICtrlComboBox_GetCurSel($cmbTroopComp)

		Case 0
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			Next

			For $i = 0 To UBound($TroopName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopName[$i]), True)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopDarkName[$i]), True)
			Next

			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumArch, "100")

			HideBarrackControls()
			ShowCustomControls()

		Case 1
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			Next

			For $i = 0 To UBound($TroopName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopName[$i]), True)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopDarkName[$i]), True)
			Next

			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumBarb, "100")
			HideBarrackControls()
			ShowCustomControls()

		Case 2
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			Next

			For $i = 0 To UBound($TroopName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopName[$i]), True)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopDarkName[$i]), True)
			Next

			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumGobl, "100")
			HideBarrackControls()
			ShowCustomControls()

		Case 3
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			Next

			For $i = 0 To UBound($TroopName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopName[$i]), True)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopDarkName[$i]), True)
			Next

			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next

			GUICtrlSetData($txtNumBarb, "50")
			GUICtrlSetData($txtNumArch, "50")
			HideBarrackControls()
			ShowCustomControls()

		Case 4
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			Next

			For $i = 0 To UBound($TroopName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopName[$i]), True)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopDarkName[$i]), True)
			Next

			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next

			_GUICtrlEdit_SetReadOnly($txtNumGiant, False)

			GUICtrlSetData($txtNumBarb, "60")
			GUICtrlSetData($txtNumArch, "30")
			GUICtrlSetData($txtNumGobl, "10")

			GUICtrlSetData($txtNumGiant, $GiantComp)
			HideBarrackControls()
			ShowCustomControls()

		Case 5
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			Next

			For $i = 0 To UBound($TroopName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopName[$i]), True)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopDarkName[$i]), True)
			Next

			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			_GUICtrlEdit_SetReadOnly($txtNumGiant, False)

			GUICtrlSetData($txtNumBarb, "50")
			GUICtrlSetData($txtNumArch, "50")

			GUICtrlSetData($txtNumGiant, $GiantComp)
			HideBarrackControls()
			ShowCustomControls()

		Case 6
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			Next

			For $i = 0 To UBound($TroopName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopName[$i]), True)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopDarkName[$i]), True)
			Next

			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next
			GUICtrlSetData($txtNumBarb, "60")
			GUICtrlSetData($txtNumArch, "30")
			GUICtrlSetData($txtNumGobl, "10")
			HideBarrackControls()
			ShowCustomControls()

		Case 7
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_ENABLE)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopDarkName[$i]), $GUI_ENABLE)
			Next

			For $i = 0 To UBound($TroopName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopName[$i]), True)
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopDarkName[$i]), True)
			Next

			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), "0")
			Next
			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), "0")
			Next

			_GUICtrlEdit_SetReadOnly($txtNumGiant, False)
			_GUICtrlEdit_SetReadOnly($txtNumWall, False)

			GUICtrlSetData($txtNumBarb, "60")
			GUICtrlSetData($txtNumArch, "30")
			GUICtrlSetData($txtNumGobl, "10")

			GUICtrlSetData($txtNumGiant, $GiantComp)
			GUICtrlSetData($txtNumWall, $WallComp)
			GUICtrlSetData($txtNumWiza, $WizaComp)
			GUICtrlSetData($txtNumMini, $MiniComp)
			GUICtrlSetData($txtNumHogs, $HogsComp)
			HideBarrackControls()
			ShowCustomControls()

		Case 8 ; Barrack Mode
			For $i = 1 To 4
				GUICtrlSetState(Eval("cmbBarrack" & $i), $GUI_SHOW)
				GUICtrlSetState(Eval("cmbBarrack" & $i), $GUI_ENABLE)
				GUICtrlSetState(Eval("lblBarrack" & $i), $GUI_SHOW)
			Next
			GUICtrlSetState($grpBarrackMode, $GUI_SHOW)
			HideCustomControls()
			ShowBarrackControls()

		Case 9 ; Custom Troops
			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_SHOW)
			Next

			For $i = 0 To UBound($TroopName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopName[$i]), False)
			Next

			For $i = 0 To UBound($TroopName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), Eval($TroopName[$i] & "Comp"))
			Next

			For $i = 0 To UBound($TroopDarkName) - 1
				_GUICtrlEdit_SetReadOnly(Eval("txtNum" & $TroopDarkName[$i]), False)
			Next

			For $i = 0 To UBound($TroopDarkName) - 1
				GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), Eval($TroopDarkName[$i] & "Comp"))
			Next

			HideBarrackControls()
			ShowCustomControls()
			ShowDarkCustomControls()

	EndSwitch
	lblTotalCount()

EndFunc   ;==>SetComboTroopComp

Func HideBarrackControls()

	GUICtrlSetState($grpBarrackMode, $GUI_HIDE)
	GUICtrlSetState($cmbBarrack1, $GUI_HIDE)
	GUICtrlSetState($cmbBarrack2, $GUI_HIDE)
	GUICtrlSetState($cmbBarrack3, $GUI_HIDE)
	GUICtrlSetState($cmbBarrack4, $GUI_HIDE)
	For $i = 1 To 4
		GUICtrlSetState(Eval("lblBarrack" & $i), $GUI_HIDE)
	Next

EndFunc   ;==>HideBarrackControls

Func HideCustomControls()

	GUICtrlSetState($grpTroops, $GUI_HIDE);hide all custom army controls
	GUICtrlSetState($grpOtherTroops, $GUI_HIDE)

	For $i = 0 To UBound($TroopName) - 1
		GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_HIDE)
	Next
	GUICtrlSetState($lblBarbarians, $GUI_HIDE)
	GUICtrlSetState($lblArchers, $GUI_HIDE)
	GUICtrlSetState($lblGoblins, $GUI_HIDE)
	GUICtrlSetState($lblGiants, $GUI_HIDE)
	GUICtrlSetState($lblWallBreakers, $GUI_HIDE)
	GUICtrlSetState($lblBalloons, $GUI_HIDE)
	GUICtrlSetState($lblWizards, $GUI_HIDE)
	GUICtrlSetState($lblHealers, $GUI_HIDE)
	GUICtrlSetState($lblDragons, $GUI_HIDE)
	GUICtrlSetState($lblPekka, $GUI_HIDE)

	GUICtrlSetState($lblTimesGiants, $GUI_HIDE)
	GUICtrlSetState($lblTimesWallBreakers, $GUI_HIDE)
	GUICtrlSetState($lblTimesBalloons, $GUI_HIDE)
	GUICtrlSetState($lblTimesWizards, $GUI_HIDE)
	GUICtrlSetState($lblTimesHealers, $GUI_HIDE)
	GUICtrlSetState($lblTimesDragons, $GUI_HIDE)
	GUICtrlSetState($lblTimesPekka, $GUI_HIDE)

	GUICtrlSetState($txtNumBarb, $GUI_HIDE)
	GUICtrlSetState($txtNumArch, $GUI_HIDE)
	GUICtrlSetState($txtNumGobl, $GUI_HIDE)
	GUICtrlSetState($txtNumGiant, $GUI_HIDE)
	GUICtrlSetState($txtNumWall, $GUI_HIDE)
	GUICtrlSetState($txtNumWiza, $GUI_HIDE)
	GUICtrlSetState($txtNumHeal, $GUI_HIDE)
	GUICtrlSetState($txtNumBall, $GUI_HIDE)
	GUICtrlSetState($txtNumDrag, $GUI_HIDE)
	GUICtrlSetState($txtNumPekk, $GUI_HIDE)

	GUICtrlSetState($icnBarb, $GUI_HIDE)
	GUICtrlSetState($icnArch, $GUI_HIDE)
	GUICtrlSetState($icnGobl, $GUI_HIDE)
	GUICtrlSetState($icnGiant, $GUI_HIDE)
	GUICtrlSetState($icnWall, $GUI_HIDE)
	GUICtrlSetState($icnWiza, $GUI_HIDE)
	GUICtrlSetState($icnHeal, $GUI_HIDE)
	GUICtrlSetState($icnBall, $GUI_HIDE)
	GUICtrlSetState($icnDrag, $GUI_HIDE)
	GUICtrlSetState($icnPekk, $GUI_HIDE)

	GUICtrlSetState($lblPercentBarbarians, $GUI_HIDE)
	GUICtrlSetState($lblPercentArchers, $GUI_HIDE)
	GUICtrlSetState($lblPercentGoblins, $GUI_HIDE)
	GUICtrlSetState($lblTotalCount, $GUI_HIDE)
	GUICtrlSetState($lblTotal, $GUI_HIDE)
	GUICtrlSetState($lblPercentTotal, $GUI_HIDE)

EndFunc   ;==>HideCustomControls

Func ShowBarrackControls()

	GUICtrlSetState($grpBarrackMode, $GUI_SHOW)
	GUICtrlSetState($cmbBarrack1, $GUI_SHOW)
	GUICtrlSetState($cmbBarrack2, $GUI_SHOW)
	GUICtrlSetState($cmbBarrack3, $GUI_SHOW)
	GUICtrlSetState($cmbBarrack4, $GUI_SHOW)

	For $i = 1 To 4
		GUICtrlSetState(Eval("lblBarrack" & $i), $GUI_SHOW)
	Next

EndFunc   ;==>ShowBarrackControls

Func ShowCustomControls()

	GUICtrlSetState($grpTroops, $GUI_SHOW);SHOW all custom army controls
	GUICtrlSetState($grpOtherTroops, $GUI_SHOW)

	For $i = 0 To UBound($TroopName) - 1
		GUICtrlSetState(Eval("txtNum" & $TroopName[$i]), $GUI_SHOW)
	Next

	GUICtrlSetState($lblBarbarians, $GUI_SHOW)
	GUICtrlSetState($lblArchers, $GUI_SHOW)
	GUICtrlSetState($lblGoblins, $GUI_SHOW)
	GUICtrlSetState($lblGiants, $GUI_SHOW)
	GUICtrlSetState($lblWallBreakers, $GUI_SHOW)
	GUICtrlSetState($lblBalloons, $GUI_SHOW)
	GUICtrlSetState($lblWizards, $GUI_SHOW)
	GUICtrlSetState($lblHealers, $GUI_SHOW)
	GUICtrlSetState($lblDragons, $GUI_SHOW)
	GUICtrlSetState($lblPekka, $GUI_SHOW)

	GUICtrlSetState($lblTimesGiants, $GUI_SHOW)
	GUICtrlSetState($lblTimesWallBreakers, $GUI_SHOW)
	GUICtrlSetState($lblTimesBalloons, $GUI_SHOW)
	GUICtrlSetState($lblTimesWizards, $GUI_SHOW)
	GUICtrlSetState($lblTimesHealers, $GUI_SHOW)
	GUICtrlSetState($lblTimesDragons, $GUI_SHOW)
	GUICtrlSetState($lblTimesPekka, $GUI_SHOW)

	GUICtrlSetState($txtNumBarb, $GUI_SHOW)
	GUICtrlSetState($txtNumArch, $GUI_SHOW)
	GUICtrlSetState($txtNumGobl, $GUI_SHOW)
	GUICtrlSetState($txtNumGiant, $GUI_SHOW)
	GUICtrlSetState($txtNumWall, $GUI_SHOW)
	GUICtrlSetState($txtNumWiza, $GUI_SHOW)
	GUICtrlSetState($txtNumHeal, $GUI_SHOW)
	GUICtrlSetState($txtNumBall, $GUI_SHOW)
	GUICtrlSetState($txtNumDrag, $GUI_SHOW)
	GUICtrlSetState($txtNumPekk, $GUI_SHOW)

	GUICtrlSetState($icnBarb, $GUI_SHOW)
	GUICtrlSetState($icnArch, $GUI_SHOW)
	GUICtrlSetState($icnGobl, $GUI_SHOW)
	GUICtrlSetState($icnGiant, $GUI_SHOW)
	GUICtrlSetState($icnWall, $GUI_SHOW)
	GUICtrlSetState($icnWiza, $GUI_SHOW)
	GUICtrlSetState($icnHeal, $GUI_SHOW)
	GUICtrlSetState($icnBall, $GUI_SHOW)
	GUICtrlSetState($icnDrag, $GUI_SHOW)
	GUICtrlSetState($icnPekk, $GUI_SHOW)

	GUICtrlSetState($lblPercentBarbarians, $GUI_SHOW)
	GUICtrlSetState($lblPercentArchers, $GUI_SHOW)
	GUICtrlSetState($lblPercentGoblins, $GUI_SHOW)
	GUICtrlSetState($lblTotalCount, $GUI_SHOW)
	GUICtrlSetState($lblTotal, $GUI_SHOW)
	GUICtrlSetState($lblPercentTotal, $GUI_HIDE)

EndFunc   ;==>ShowCustomControls

Func lblTotalCount()

	GUICtrlSetData($lblTotalCount, GUICtrlRead($txtNumBarb) + GUICtrlRead($txtNumArch) + GUICtrlRead($txtNumGobl))
	If GUICtrlRead($lblTotalCount) = "100" Then
		GUICtrlSetBkColor($lblTotalCount, $COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($lblTotalCount) = "0" Then
		GUICtrlSetBkColor($lblTotalCount, $COLOR_ORANGE)
	Else
		GUICtrlSetBkColor($lblTotalCount, $COLOR_RED)
	EndIf

EndFunc   ;==>lblTotalCount

Func lblTotalCountSpell()

	If (GUICtrlRead($txtNumLightningSpell) * 2 + GUICtrlRead($txtNumHealSpell) * 2 + GUICtrlRead($txtNumRageSpell) * 2 + GUICtrlRead($txtNumJumpSpell) * 2 + GUICtrlRead($txtNumFreezeSpell) * 2 + GUICtrlRead($txtNumPoisonSpell) + GUICtrlRead($txtNumHasteSpell) + GUICtrlRead($txtNumEarthSpell)) < GUICtrlRead($txtTotalCountSpell) + 1 Then
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_MONEYGREEN)
	Else
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_RED)
	EndIf

	If GUICtrlRead($txtTotalCountSpell) = 0 Then
		GUICtrlSetState($txtNumLightningSpell, $GUI_DISABLE)
		GUICtrlSetState($txtNumHealSpell, $GUI_DISABLE)
		GUICtrlSetState($txtNumRageSpell, $GUI_DISABLE)
		GUICtrlSetState($txtNumJumpSpell, $GUI_DISABLE)
		GUICtrlSetState($txtNumFreezeSpell, $GUI_DISABLE)
		GUICtrlSetState($txtNumPoisonSpell, $GUI_DISABLE)
		GUICtrlSetState($txtNumEarthSpell, $GUI_DISABLE)
		GUICtrlSetState($txtNumHasteSpell, $GUI_DISABLE)
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_WHITE)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_WHITE)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_WHITE)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_WHITE)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_WHITE)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_WHITE)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_WHITE)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_WHITE)
	Else
		$iTownHallLevel = Int($iTownHallLevel)
		If $iTownHallLevel > 4 Or $iTownHallLevel = 0 Then
			GUICtrlSetState($txtNumLightningSpell, $GUI_ENABLE)
		Else
			GUICtrlSetState($txtNumLightningSpell, $GUI_DISABLE)
		EndIf
		If $iTownHallLevel > 5 Or $iTownHallLevel = 0 Then
			GUICtrlSetState($txtNumHealSpell, $GUI_ENABLE)
		Else
			GUICtrlSetState($txtNumHealSpell, $GUI_DISABLE)
		EndIf
		If $iTownHallLevel > 6 Or $iTownHallLevel = 0 Then
			GUICtrlSetState($txtNumRageSpell, $GUI_ENABLE)
		Else
			GUICtrlSetState($txtNumRageSpell, $GUI_DISABLE)
		EndIf
		If $iTownHallLevel > 7 Or $iTownHallLevel = 0 Then
			GUICtrlSetState($txtNumPoisonSpell, $GUI_ENABLE)
			GUICtrlSetState($txtNumEarthSpell, $GUI_ENABLE)
		Else
			GUICtrlSetState($txtNumPoisonSpell, $GUI_DISABLE)
			GUICtrlSetState($txtNumEarthSpell, $GUI_DISABLE)
		EndIf
		If $iTownHallLevel > 8 Or $iTownHallLevel = 0 Then
			GUICtrlSetState($txtNumJumpSpell, $GUI_ENABLE)
			GUICtrlSetState($txtNumFreezeSpell, $GUI_ENABLE)
			GUICtrlSetState($txtNumHasteSpell, $GUI_ENABLE)
		Else
			GUICtrlSetState($txtNumJumpSpell, $GUI_DISABLE)
			GUICtrlSetState($txtNumFreezeSpell, $GUI_DISABLE)
			GUICtrlSetState($txtNumHasteSpell, $GUI_DISABLE)
		EndIf
	EndIf

EndFunc   ;==>lblTotalCountSpell

Func btnHideElixir()

	GUICtrlSetState($btnElixirSpell, $GUI_SHOW)
	GUICtrlSetState($btnDarkElixirSpell, $GUI_HIDE)
	For $i = $lblLightningIcon To $lblFreezeS
		GUICtrlSetState($i, $GUI_HIDE)
	Next
	For $i = $grpDarkSpells To $txtTotalCountSpell
		GUICtrlSetState($i, $GUI_SHOW)
	Next

EndFunc   ;==>btnHideElixir

Func btnHideDarkElixir()

	GUICtrlSetState($btnDarkElixirSpell, $GUI_SHOW)
	GUICtrlSetState($btnElixirSpell, $GUI_HIDE)
	For $i = $lblLightningIcon To $lblFreezeS
		GUICtrlSetState($i, $GUI_SHOW)
	Next
	For $i = $grpDarkSpells To $txtTotalCountSpell
		GUICtrlSetState($i, $GUI_HIDE)
	Next

EndFunc   ;==>btnHideDarkElixir
