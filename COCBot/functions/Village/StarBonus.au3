; #FUNCTION# ====================================================================================================================
; Name ..........: StarBonus
; Description ...: Checks for Star bonus window, and clicks ok to close window.
; Syntax ........: StarBonus()
; Parameters ....:
; Return values .: MonkeyHunter(2016-1)
; Modified ......: MonkeyHunter (05-2017), Moebius14 (12-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func StarBonus()

	SetDebugLog("Begin Star Bonus window check", $COLOR_DEBUG1)

	; The "Star Bonus received!" window of CoC 18.600.5, measured on a live capture: a deep blue
	; title band (0x3E2EB7 across the whole width at y 130), five white stars around y 210 and
	; a green Okay button spanning x 355-515, y 533-603 with 0xC6EB60 in its upper half. The
	; old checks looked for a light sky blue and a grey star that the redesign no longer has.
	Local $aWindowChk1[4] = [630, 100 + $g_iMidOffsetY, 0x3E2EB7, 20] ; deep blue title band
	Local $aWindowChk2[4] = [435, 180 + $g_iMidOffsetY, 0xF5F7F7, 20] ; middle white star
	Local $aOkayGreen[4] = [380, 538 + $g_iMidOffsetY, 0xC6EB60, 20] ; upper half of the Okay button, left of its text

	If _Sleep($DELAYSTARBONUS100) Then Return

	; Verify actual star bonus window open
	If _CheckPixel($aWindowChk1, $g_bCapturePixel, Default, "Starbonus1") And _CheckPixel($aWindowChk2, $g_bCapturePixel, Default, "Starbonus2") Then
		; Find and Click Okay button
		Local $aiOkayButton = findButton("Okay", Default, 1, True)
		If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
			PureClickP($aiOkayButton, 1, 100, "#0117") ; Click Okay Button
			If _Sleep($DELAYSTARBONUS500) Then Return
			$StarBonusReceived = 1
			Return True
		ElseIf _CheckPixel($aOkayGreen, $g_bCapturePixel, Default, "StarbonusOkay") Then
			; The redrawn button is not matched by the Okay templates, but it always sits at the same place
			SetDebugLog("Okay button found by its colour", $COLOR_DEBUG)
			PureClick(435, 538 + $g_iMidOffsetY, 1, 100, "#0117")
			If _Sleep($DELAYSTARBONUS500) Then Return
			$StarBonusReceived = 1
			Return True
		Else
			SetDebugLog("Cannot Find Okay Button", $COLOR_ERROR)
		EndIf
	EndIf

	SetDebugLog("Star Bonus window not found?", $COLOR_DEBUG)
	Return False

EndFunc   ;==>StarBonus
