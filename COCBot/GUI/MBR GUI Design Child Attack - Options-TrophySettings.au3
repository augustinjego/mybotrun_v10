; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "League" tab (formerly "Trophy Settings", trophies are gone since CoC 18.600) under the "Options" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkTrophyRange = 0, $g_hTxtDropTrophy = 0, $g_hTxtMaxTrophy = 0, $g_hChkTrophyHeroes = 0, $g_hCmbTrophyHeroesPriority = 0, _
		$g_hChkTrophyAtkDead = 0, $g_hTxtDropTrophyArmyMin = 0
Global $g_hPicMinTrophies[$eLeagueCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hLblMinTrophies = 0
Global $g_hPicMaxTrophies[$eLeagueCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hLblMaxTrophies = 0

Global $g_hLblTrophyHeroesPriority = 0, $g_hLblDropTrophyArmyMin = 0, $g_hLblDropTrophyArmyPercent = 0

Func CreateAttackSearchOptionsTrophySettings()

	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "Group_01", "League tier"), $x - 20, $y - 20, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
	$x += 25
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 15, $y, 64, 64, $BS_ICON)

	; CoC 18.600 replaced trophies with 36 league tiers that cannot be dropped on purpose, so the drop
	; trophy controls below are still created (the config code reads and writes them) but stay hidden.
	; Only the max tier survives: it feeds the "Max.League" bot conditions of Village -> Misc.
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblLeagueInfo", "Since CoC 18.600 there are no trophies any more: the league is a tier from 1 (Skeleton 1) to 36 (Legend I), read on the badge of the main screen. Tiers cannot be dropped on purpose, so the old trophy drop options are gone."), $x + 55, $y - 5, 300, 60)
	$y += 62
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblMaxLeague", "Max. league tier") & ":", $x + 55, $y + 3, 90, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblMaxLeague_Info_01", "The Max.League bot conditions (Village -> Misc) stop attacking once your tier is above this value (1-36, 36 = never)."))

	$x += 50
	$g_hChkTrophyRange = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyRange", "Trophy range") & ":", $x + 20, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkTrophyRange")
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hTxtDropTrophy = GUICtrlCreateInput("5000", $x + 110, $y, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 4)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "TxtDropTrophy_Info_01", "MIN: The Bot will drop trophies until below this value."))
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetOnEvent(-1, "TxtDropTrophy")

	; The Min/Max trophy badge icons below matched trophy counts (0-6000) to a league banner; they have
	; no meaningful mapping to a 1-36 tier, so the whole row is created (config code still expects the
	; handles) but kept hidden. Only the plain "Max. league tier" number above is shown to the user.
	$g_hPicMinTrophies[$eLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 116, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMinTrophies[$eLeagueBronze] = _GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x + 116, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMinTrophies[$eLeagueSilver] = _GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x + 116, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMinTrophies[$eLeagueGold] = _GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x + 116, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMinTrophies[$eLeagueCrystal] = _GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x + 116, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMinTrophies[$eLeagueMaster] = _GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x + 116, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMinTrophies[$eLeagueChampion] = _GUICtrlCreateIcon($g_sLibIconPath, $eLChampion, $x + 116, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMinTrophies[$eLeagueTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x + 116, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMinTrophies[$eLeagueLegend] = _GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x + 116, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblMinTrophies = GUICtrlCreateLabel("", $x + 133, $y - 15, 17, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_hTxtMaxTrophy = GUICtrlCreateInput("36", $x + 100, $y, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 2)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "TxtMaxTrophy_Info_01", "MAX: the Max.League bot conditions stop attacking when your league tier is greater than this value (1-36, 36 = never)."))
	GUICtrlSetOnEvent(-1, "TxtMaxTrophy")

	$g_hPicMaxTrophies[$eLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 161, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMaxTrophies[$eLeagueBronze] = _GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x + 161, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMaxTrophies[$eLeagueSilver] = _GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x + 161, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMaxTrophies[$eLeagueGold] = _GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x + 161, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMaxTrophies[$eLeagueCrystal] = _GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x + 161, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMaxTrophies[$eLeagueMaster] = _GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x + 161, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMaxTrophies[$eLeagueChampion] = _GUICtrlCreateIcon($g_sLibIconPath, $eLChampion, $x + 161, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMaxTrophies[$eLeagueTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x + 161, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicMaxTrophies[$eLeagueLegend] = _GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x + 161, $y - 30, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblMaxTrophies = GUICtrlCreateLabel("", $x + 178, $y - 15, 17, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 24
	$x += 20
	$g_hChkTrophyHeroes = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyHeroes", "Use Heroes To Drop Trophies"), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyHeroes_Info_01", "Use Heroes to drop Trophies if Heroes are available."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "chkTrophyHeroes")

	$y += 25
	$g_hLblTrophyHeroesPriority = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblTrophyHeroesPriority", "Priority Hero to Use") & " :", $x, $y, 110, -1)
	$g_hCmbTrophyHeroesPriority = GUICtrlCreateCombo("", $x + 100, $y - 4, 195, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblTrophyHeroesPriority_Info_01", "Set the order on which Hero the Bot drops first when available."))
	Local $txtPriorityConnector = ">"
	Local $txtPriorityDefault = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince", -1) & $txtPriorityConnector & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1)                             ; default value Queen, King, G.Warden, Prince, Royal Champion
	Local $txtPriorityList = "" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & "|" & _
			""

	If $g_bDebugSetLog Then SetDebugLog($txtPriorityDefault)
	If $g_bDebugSetLog Then SetDebugLog($txtPriorityList)
	GUICtrlSetData(-1, $txtPriorityList, $txtPriorityDefault)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 20
	$g_hChkTrophyAtkDead = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyAtkDead", "Attack Dead Bases During Drop"), $x, $y + 2, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyAtkDead_Info_01", "Attack a Deadbase found on the first search while dropping Trophies."))
	GUICtrlSetOnEvent(-1, "chkTrophyAtkDead")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 24
	$g_hLblDropTrophyArmyMin = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblDropTrophyArmyMin", "Wait until Army Camp are at least") & " " & ChrW(8805), $x + 16, $y + 6, 200, -1, $SS_LEFT)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblDropTrophyArmyMin_Info_01", "Enter the percent of full army required for dead base attack before starting trophy drop.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hTxtDropTrophyArmyMin = GUICtrlCreateInput("70", $x + 215, $y + 2, 27, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hLblDropTrophyArmyPercent = GUICtrlCreateLabel("%", $x + 245, $y + 6, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchOptionsTrophySettings
