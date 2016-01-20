; #FUNCTION# ====================================================================================================================
; Name ..........: Click, PureClick, ClickP
; Description ...: Clicks the BS screen on desired location
; Syntax ........: Click($x, $y, $times, $speed)
; Parameters ....: $x, $y are mandatory, $times and $speed are optional
; Return values .: None
; Author ........: (2014)
; Modified ......: HungLe (may-2015) Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Click($x, $y, $times = 1, $speed = 0, $debugtxt = "")
    ;getBSPos()
    $x = $x  + $BSrpos[0]
	$y = $y  + $BSrpos[1]
    If $debugClick = 1 Then
		Local $txt = _DecodeDebug($debugtxt)
		SetLog("Click " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_ORANGE, "Verdana", "7.5", 0)
	EndIf

	If $times <> 1 Then
		For $i = 0 To ($times - 1)
			If isProblemAffect(True) Then
				If $debugClick = 1 Then Setlog("VOIDED Click " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_RED, "Verdana", "7.5", 0)
				checkMainScreen(False)
				Return  ; if need to clear screen do not click
			EndIf
			MoveMouseOutBS()
			ControlClick($Title, "", "", "left", "1", $x, $y)
			If _Sleep($speed, False) Then ExitLoop
		Next
	Else
		If isProblemAffect(True) Then
			If $debugClick = 1 Then Setlog("VOIDED Click " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_RED, "Verdana", "7.5", 0)
			checkMainScreen(False)
			Return  ; if need to clear screen do not click
		EndIf
		MoveMouseOutBS()
		ControlClick($Title, "", "", "left", "1", $x, $y)
	EndIf
EndFunc   ;==>Click

; ClickP : takes an array[2] (or array[4]) as a parameter [x,y]
Func ClickP($point, $howMuch = 1, $speed = 0, $debugtxt = "")
	Click($point[0], $point[1], $howMuch, $speed, $debugtxt)
EndFunc   ;==>ClickP

Func PureClick($x, $y, $times = 1, $speed = 0, $debugtxt = "")
    ;getBSPos()
    $x = $x  + $BSrpos[0]
	$y = $y  + $BSrpos[1]
	If $debugClick = 1 Then
		Local $txt = _DecodeDebug($debugtxt)
		SetLog("PureClick " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_ORANGE, "Verdana", "7.5", 0)
	EndIf
	If $times <> 1 Then
		For $i = 0 To ($times - 1)
			MoveMouseOutBS()
			ControlClick($Title, "", "", "left", "1", $x, $y)
			If _Sleep($speed, False) Then ExitLoop
		Next
	Else
		MoveMouseOutBS()
		ControlClick($Title, "", "", "left", "1", $x, $y)
	EndIf
EndFunc   ;==>PureClick

; PureClickP : takes an array[2] (or array[4]) as a parameter [x,y]
Func PureClickP($point, $howMuch = 1, $speed = 0, $debugtxt = "")
	PureClick($point[0], $point[1], $howMuch, $speed, $debugtxt)
EndFunc   ;==>PureClickP

Func GemClick($x, $y, $times = 1, $speed = 0, $debugtxt = "")
    ;getBSPos()
    $x = $x  + $BSrpos[0]
	$y = $y  + $BSrpos[1]
	Local $i
	If $debugClick = 1 Then
		Local $txt = _DecodeDebug($debugtxt)
		SetLog("GemClick " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_ORANGE, "Verdana", "7.5", 0)
	EndIf
	If $times <> 1 Then
		For $i = 0 To ($times - 1)
			If isGemOpen(True) Then Return False
			If isProblemAffect(True) Then
				If $debugClick = 1 Then Setlog("VOIDED GemClick " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_RED, "Verdana", "7.5", 0)
				checkMainScreen(False)
				Return  ; if need to clear screen do not click
			EndIf
			MoveMouseOutBS()
			ControlClick($Title, "", "", "left", "1", $x, $y)
			If isGemOpen(True) Then Return False
			If _Sleep($speed, False) Then ExitLoop
		Next
	Else
		If isGemOpen(True) Then Return False
		If isProblemAffect(True) Then
			If $debugClick = 1 Then Setlog("VOIDED GemClick " & $x & "," & $y & "," & $times & "," & $speed & " " & $debugtxt & $txt, $COLOR_RED, "Verdana", "7.5", 0)
			checkMainScreen(False)
			Return  ; if need to clear screen do not click
		EndIf
		MoveMouseOutBS()
		ControlClick($Title, "", "", "left", "1", $x, $y)
		If isGemOpen(True) Then Return False
	EndIf
EndFunc   ;==>GemClick

; GemClickP : takes an array[2] (or array[4]) as a parameter [x,y]
Func GemClickP($point, $howMuch = 1, $speed = 0, $debugtxt = "")
	Return GemClick($point[0], $point[1], $howMuch, $speed, $debugtxt = "")
EndFunc   ;==>GemClickP

Func _DecodeDebug($message)
	Local $separator = " | "
	Switch $message
		; AWAY CLICKS
		Case "#0112", "#0115", "#0140", "#0141", "#0142", "#0143", "#0199", "#0328", "#0201", "#0204", "#0205", "#0206", "#0327", "#0207", "#0208", "#0209", "#0210", "#0211"
			Return $separator & "Away"
		Case "#0214", "#0215", "#0216", "#0217", "#0218", "#0219", "#0220", "#0221", "#0235", "#0242", "#0268", "#0291", "#0292", "#0295", "#0298", "#0300", "#0301", "#0302"
			Return $separator & "Away"
		Case "#0303", "#0306", "#0308", "#0309", "#0310", "#0311", "#0312", "#0319", "#0333", "#0257", "#0139", "#0125", "#0251", "#0335", "#0313", "#0314", "#0332", "#0329"
			Return $separator & "Away"
		Case "#0121", "#0124", "#0133", "#0157", "#0161", "#0165", "#0166", "#0167", "#0170", "#0171", "#0176", "#0224", "#0234", "#0265", "#0346", "#0348", "#0350", "#0351"
			Return $separator & "Away"
		Case "#0352", "#0353", "#0354", "#0355", "#0356", "#0357", "#0358", "#0359", "#0360", "#0361", "#0362", "#0363", "#0364", "#0365", "#0366", "#0367", "#0368", "#0369"
			Return $separator & "Away"
		Case "#0370", "#0371", "#0373", "#0374", "#0375", "#0376", "#0377", "#0378", "#0379", "#0380", "#0381", "#0382", "#0383", "#0384", "#0385", "#0386", "#0387", "#0388"
			Return $separator & "Away"
		Case "#0389", "#0390", "#0391", "#0392", "#0393", "#0394", "#0395", "#0501", "#0502", "#0503", "#0504", "#0467", "#0505", "#0931", "#0932", "#0933"
			Return $separator & "Away"
			; ATTACK TH
		Case "#0001"
			Return $separator & "AtkTH - Select Barbarian"
		Case "#0002", "#0006"
			Return $separator & "AtkTH - Barbarian Bottom Left"
		Case "#0003", "#0007"
			Return $separator & "AtkTH - Barbarian Bottom Right"
		Case "#0004", "#0008"
			Return $separator & "AtkTH - Barbarian Top Right"
		Case "#0005", "#0009"
			Return $separator & "AtkTH - Barbarian Top Left"
		Case "#0010"
			Return $separator & "AtkTH - Select Archer"
		Case "#0011", "#0015"
			Return $separator & "AtkTH - Arcer Bottom Left"
		Case "#0012", "#0016"
			Return $separator & "AtkTH - Arcer Bottom Right"
		Case "#0013", "#0017"
			Return $separator & "AtkTH - Arcer Top Right"
		Case "#0014", "#0018"
			Return $separator & "AtkTH - Arcer Top Left"
		Case "#0155"
			Return $separator & "Attack - Next Button"
			;COLLECT
		Case "#0331"
			Return $separator & "Collect resources"
		Case "#0330"
			Return $separator & "Collect resources*"
			;TRAIN
		Case "#0266"
			Return $separator & "Train - TrainIT Selected Troop"
		Case "#0269"
			Return $separator & "Train - Open Barrack"
		Case "#0270"
			Return $separator & "Train - Train Troops button"
		Case "#0271"
			Return $separator & "Train - Next Button "
		Case "#0272", "#0286", "#0289", "#0325"
			Return $separator & "Train - Prev Button "
		Case "#0273", "#0284", "#0285", "#0287", "#0288"
			Return $separator & "Train - Remove Troops"
		Case "#0274"
			Return $separator & "Train - Train Barbarian"
		Case "#0275"
			Return $separator & "Train - Train Archer"
		Case "#0276"
			Return $separator & "Train - Train Giant"
		Case "#0277"
			Return $separator & "Train - Train Goblin"
		Case "#0278"
			Return $separator & "Train - Train Wall Breaker"
		Case "#0279"
			Return $separator & "Train - Train Balloon"
		Case "#0280"
			Return $separator & "Train - Train Wizard"
		Case "#0281"
			Return $separator & "Train - Train Healer"
		Case "#0282"
			Return $separator & "Train - Train Dragon"
		Case "#0283"
			Return $separator & "Train - Train P.E.K.K.A."
		Case "#0290"
			Return $separator & "Train - GemClick Spell"
		Case "#0293"
			Return $separator & "Train - Click Army Camp"
		Case "#0294"
			Return $separator & "Train - Open Info Army Camp"
		Case "#0336"
			Return $separator & "Train - Go to first barrack"
		Case "#0337"
			Return $separator & "Train - Click Prev Button*"
		Case "#0338"
			Return $separator & "Train - Click Next Button*"
		Case "#0339"
			Return $separator & "Train - Select Prev Barrack/SP"
		Case "#0340"
			Return $separator & "Train - Click Next Barrack/SP"

			;DONATE
		Case "#0168"
			Return $separator & "Donate - Open Chat"
		Case "#0169"
			Return $separator & "Donate - Select Clan Tab"
		Case "#0172"
			Return $separator & "Donate - Scroll"
		Case "#0173"
			Return $separator & "Donate - Click Chat"
		Case "#0174"
			Return $separator & "Donate - Click Donate Button"
		Case "#0175"
			Return $separator & "Donate - Donate Selected Troop"
			;TEST LANGUAGE
		Case "#0144"
			Return $separator & "ChkLang - Config Button"
		Case "#0145", "#0146", "#0147", "#0148"
			Return $separator & "ChkLang - Close Page"
			;PROFILE REPORT
		Case "#0222"
			Return $separator & "Profile - Profile Button"
		Case "#0223"
			Return $separator & "Profile - Close Page"
			;REARM
		Case "#0225"
			Return $separator & "Rearm - Click Town Hall"
		Case "#0326", "#0228"
			Return $separator & "Rearm - Click Rearm Button"
		Case "#0226", "#0229"
			Return $separator & "Rearm - Click Rearm"
		Case "#0227", "#0230", "#0233"
			Return $separator & "Rearm - Close Gem Spend Window"
		Case "#0231"
			Return $separator & "Rearm - Click Inferno Button"
		Case "#0232"
			Return $separator & "Rearm - Inferno Button"
			;REQUEST CC
		Case "#0250"
			Return $separator & "Request - Click Castle Clan"
		Case "#0253"
			Return $separator & "Request - Click Request Button"
		Case "#0254", "#0255"
			Return $separator & "Request - Click Select Text For Request"
		Case "#0256"
			Return $separator & "Request - Click Send Request"
		Case "#0334"
			Return $separator & "Request - Click Train Button"
			;RETURN HOME
		Case "#0099"
			Return $separator & "Return Home - End Battle"
		Case "#0100"
			Return $separator & "Return Home - Surrender, Confirm"
		Case "#0101"
			Return $separator & "Return Home - Return Home Button"
		Case "#0396"
			Return $separator & "Reach Limit - Return home, Press End Battle "
			;DETECT CLAN LEVEL
		Case "#0468"
			Return $separator & "Clan Level - Open Chat"
		Case "#0469"
			Return $separator & "Clan Level - Open Chat Clan Tab "
		Case "#0470"
			Return $separator & "Clan Level - Click Info Clan Button"
		Case "#071", "#0472"
			Return $separator & "Clan Level - Close Chat"
		Case "#0473"
			Return $separator & "Clan Level - Close Clan Info Page"

		Case "#0149"
			Return $separator & "Prepare Search - Press Attack Button"
		Case "#0150"
			Return $separator & "Prepare Search - Press Find a Match Button"

		 ;AllTroops
		Case "#0030"
			Return $separator & "Attack - press surrender"
		Case "#0031"
			Return $separator & "Attack - press confirm surrender"


		Case "#0000"
			Return $separator & " "

		Case Else
			Return ""
	EndSwitch
EndFunc   ;==>_DecodeDebug
