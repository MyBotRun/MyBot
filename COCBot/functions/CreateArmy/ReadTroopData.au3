





Func ReadSiegeMachinesData()

	Global $oSiegeMachines = ObjCreate("Scripting.Dictionary")


	Local $oSiegeJson = Json_Decode(FileRead(@ScriptDir & "\lib\data\SiegeMachines.json"))
	Local $aoSiegeMachines = Json_Get($oData, ".SiegeMachines")
	Local $sName = ""

	For $oSiegeMachine in $aoSiegeMachines
		$sName = Json_Get($oSiegeMachine, ".Name")
		ConsoleWrite("Name: " & $sName & @CRLF)
	Next


	Global Enum $eSiegeWallWrecker, $eSiegeBattleBlimp, $eSiegeStoneSlammer, $eSiegeBarracks, $eSiegeMachineCount

	Global Const $g_asSiegeMachineNames[$eSiegeMachineCount] = ["Wall Wrecker", "Battle Blimp", "Stone Slammer", "Siege Barracks"]
	Global Const $g_asSiegeMachineShortNames[$eSiegeMachineCount] = ["WallW", "BattleB", "StoneS", "SiegeB"]
	Global Const $g_aiSiegeMachineSpace[$eSiegeMachineCount] = [1, 1, 1, 1]
	Global Const $g_aiSiegeMachineTrainTimePerLevel[$eSiegeMachineCount][5] = [ _
			[4, 1200, 1200, 1200, 1200], _ ; Wall Wrecker
			[4, 1200, 1200, 1200, 1200], _ ; Battle Blimp
			[4, 1200, 1200, 1200, 1200], _ ; Stone Slammer
			[4, 1200, 1200, 1200, 1200]] ; Siege Barracks
	Global Const $g_aiSiegeMachineCostPerLevel[$eSiegeMachineCount][5] = [ _
			[4, 100000, 100000, 100000, 100000], _ ; Wall Wrecker
			[4, 100000, 100000, 100000, 100000], _ ; Battle Blimp
			[4, 100000, 100000, 100000, 100000], _ ; Stone Slammer
			[4, 100000, 100000, 100000, 100000]] ; Stone Slammer
	Global Const $g_aiSiegeMachineDonateXP[$eSiegeMachineCount] = [30, 30, 30, 30]
EndFunc   ;==>ReadSiegeMachinesData
