;modalW.au3
#include-once
#include <ScrollBarConstants.au3>
#include <GuiEdit.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiButton.au3>

Global $GUImodal
Global $GUIconcoleDynOut
Global $concoleDynStack

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

Func _concoleDynOut($_show,$text,$prntW,$Stack='')
	$concoleDynStack &= $Stack
	Local $pPos = WinGetPos ($prntW), $modWidth = 512, $modHeight = 228
	Local $modL = $pPos[0] + Floor(($pPos[2] - $modWidth)/2)
	Local $modT = $pPos[1] + Floor(($pPos[3] - $modHeight)/2)
	
	if ($GUIconcoleDynOut == '') Then
		$GUIconcoleDynOut = GUICreate("GUIconcoleDunOut",$modWidth,$modHeight,$modL,$modT,$WS_POPUPWINDOW,'',$prntW)
		Global $GUIconcoleDynOutTxt = GUICtrlCreateEdit("",0,0,512,228,BitOr($ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL),-1)
		GUICtrlSetFont(-1,8,400,0,"@Arial Unicode MS")
		GUICtrlSetColor(-1,"0xFFFFFF")
		GUICtrlSetBkColor(-1,"0x000000")		
	EndIf
	
	
	GUICtrlSetData ( $GUIconcoleDynOutTxt, StringRegExpReplace($concoleDynStack & $text, "(?s)Progress:.*:", "Progress:", 0))
	_GUICtrlEdit_Scroll($GUIconcoleDynOutTxt, $SB_BOTTOM)

	Switch $_show
		Case True
			WinMove($GUIconcoleDynOut, "", $modL, $modT)
			GUISetState(@SW_SHOW,$GUIconcoleDynOut)
		Case False
			$concoleDynStack = ''
			GUISetState(@SW_HIDE,$GUIconcoleDynOut)		
	EndSwitch
EndFunc
