;modalW.au3
#include-once
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiButton.au3>

Global $GUImodal

Func _modal($_show,$text,$prntW)
	if ($GUImodal == '') Then
			Local $pPos = WinGetPos ($prntW), $modWidth = 280, $modHeight = 92
			Local $modL = $pPos[0] + Floor(($pPos[2] - $modWidth)/2)
			Local $modT = $pPos[1] + Floor(($pPos[3] - $modHeight)/2)
			
			$GUImodal = GUICreate("modal",$modWidth,$modHeight,$modL,$modT,$WS_POPUPWINDOW,'',$prntW)
			GUICtrlCreateLabel($text,115,38.5,80,15,-1,-1)	
			GUISetState(@SW_DISABLE,$prntW)
			GUISetState(@SW_SHOW,$GUImodal)
		Else
			GUISetState(@SW_ENABLE,$prntW)
			GUIDelete ($GUImodal)
			$GUImodal = ''
	EndIf
EndFunc

;~ Func _modal($_show,$text,$prntW)
;~ 	Local $pPos = WinGetPos ($prntW), $modWidth = 280, $modHeight = 92
;~ 	Local $modL = $pPos[0] + Floor(($pPos[2] - $modWidth)/2)
;~ 	Local $modT = $pPos[1] + Floor(($pPos[3] - $modHeight)/2)
;~ 	
;~ 	if ($GUImodal == '') Then
;~ 		$GUImodal = GUICreate("modal",$modWidth,$modHeight,$modL,$modT,$WS_POPUPWINDOW,'',$prntW)
;~ 		GUICtrlCreateLabel("Working...",115,38.5,80,15,-1,-1)			
;~ 	EndIf

;~ 	Switch $_show
;~ 		Case True
;~ 			WinMove($GUImodal, "", $modL, $modT)
;~ 			GUISetState(@SW_DISABLE,$prntW)
;~ 			GUISetState(@SW_SHOW,$GUImodal)
;~ 		Case False
;~ 			GUISetState(@SW_ENABLE,$prntW)
;~ 			GUISetState(@SW_HIDE,$GUImodal)		
;~ 	EndSwitch
;~ EndFunc

