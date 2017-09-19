;funcs.au3
#include-once

#include "csv.au3"

Func _SetNotifi ($str,$LB=3)
	Switch $LB
		Case 1
			GUICtrlSetData ( $LBpkCount, $str)
		Case 2
			GUICtrlSetData ( $LBpkCount2, $str)
		Case 3
			GUICtrlSetData ( $LBpkCount, $str)
			GUICtrlSetData ( $LBpkCount2, $str)
	EndSwitch
EndFunc

Func _runCMDgetOut($_cmd,$consoleOut = true,$IShide = True)
	_log("_runCMDgetOut cmd=" & $_cmd)
	local $sOut = '' 
	
	if ($IShide == True) Then
			$hide = @SW_HIDE
		Else
			$hide = @SW_MAXIMIZE 
	EndIf
	
	local $iPID = Run($_cmd, @SystemDir, $hide, $STDERR_CHILD + $STDOUT_CHILD)
	
	While 1
		$stOut = StdoutRead($iPID)
		
		$sOut &= $stOut
		
		If @error Then ExitLoop
	WEnd
	
	if ($consoleOut == true) Then
		GUICtrlSetTip($LBpkCount, $sOut)
		GUICtrlSetTip($LBpkCount2, $sOut)
		GUICtrlSetData ( $E_consoleOut, $sOut)
	EndIf
;~ 	_log($sOut)
	Return $sOut
EndFunc

Func _getInstalledList($SearchStr="",$fast=False)
	
	if ($fast == True) then 
			Local $_localstr = _runCMDgetOut('choco list -r -l ' & $SearchStr,False)
		Else
			if $SearchStr=="" then $SearchStr="all"
			Local $_localstr = _runCMDgetOut('cup --noop -r ' & $SearchStr,False)
	EndIf
	
	$_localstr = StringRegExpReplace($_localstr, "(?m)^[^|]*$", "")
	
	local $InstListArr = _CSVSplit($_localstr,"|")	
	
	Return $InstListArr
	
EndFunc

Func _Rclick($h,$index)

	local $fn
	
	if (($h == GUICtrlGetHandle($pkLIst)) or ($h == GUICtrlGetHandle($pkInstaledLIst))) then $fn = "info"
	
	Switch $fn
		Case "info"
			_modal(true,"Working...",$Gui)
			Local $pkName = StringSplit (_GUICtrlListView_GetItemTextString ($h, $index),"|",2)
			If IsArray($pkName) Then 
					$pkName = $pkName[0]
				Else
					$pkName = ""
			EndIf		
			_getPkInfo($pkName)
			_modal(false,"Working...",$Gui)
	EndSwitch
	

EndFunc

Func _goToUrl($url)
	ShellExecute($url)
EndFunc

Func _lvItem_textSearch($hListView,$sText)
	Local $iItemIndex = -1
	For $i = 0 To (_GUICtrlListView_GetItemCount($hListView) - 1)
        If (_GUICtrlListView_GetItemTextString($hListView, $i) == $sText) Then
            $iItemIndex = $i
            ExitLoop
        EndIf
    Next
	return $iItemIndex
EndFunc

Func _toggleElement($element)
	if (GUICtrlRead ( $CB_all ) == $GUI_CHECKED) Then 
			GUICtrlSetState ( $element, $GUI_DISABLE )
		Else
			GUICtrlSetState ( $element, $GUI_ENABLE )
	EndIf		
EndFunc

Func _testButton()
	_ArrayDisplay($onlineSearchArr, "$onlineSearchArr")
EndFunc
			
			