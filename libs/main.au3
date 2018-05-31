;main.au3

#include "funcs.au3"

Func _SeachInRepos($SearchStr,$Notifi=true)
	if (StringReplace($SearchStr,' ','')=='') Then
		if ($Notifi == true) then _SetNotifi ("ERROR." ,1)
		Return
	EndIf
	if ($Notifi == true) then _SetNotifi ("Searching 0%" ,1)
	
	local $InstListArr = _getInstalledList('',true), $aprv = '', $brk = '', $all ='', $exact = ''
	
;~ 	if (GUICtrlRead ( $CB_apr ) == $GUI_CHECKED) Then $aprv = '--approved-only'
;~ 	if (GUICtrlRead ( $CB_rbk ) == $GUI_CHECKED) Then $aprv = '--not-broken'
;~ 	if (GUICtrlRead ( $CB_all ) == $GUI_CHECKED) Then $all = '--all'
;~ 	if (GUICtrlRead ( $CB_exact ) == $GUI_CHECKED) Then $exact = '--exact'
		
	
;~ 	Local $schCmd = $SearchStr & ' ' & $aprv & ' ' & $brk  & ' ' & $all  & ' ' & $exact
	Local $schCmd = $SearchStr & ' ' & GUICtrlRead ($cmdLine1)
	
	Local $sOut = _cash($schCmd,$onlineSearchArr)
	If ($sOut == 0) Then
		_log('$sOut == 0 ' & $sOut)
		$sOut = _runCMDgetOut('choco search ' & $schCmd,False,True,True)
		_cash($schCmd,$onlineSearchArr,True,$sOut)
	EndIf
;~ 	Local $sOut = _runCMDgetOut('choco search ' & $schCmd)	
	if ($Notifi == true) then _SetNotifi ("Searching 20%" ,1)
;~ 	_log($sOut)
	
	Local $aOut = StringRegExp($sOut, '[^\r\n]+', 3)
	if ($Notifi == true) then _SetNotifi ("Searching 30%" ,1)
;~ 		_ArrayDisplay($aOut, '')

	If @error Or (UBound($aOut) < 3) Then 
		_log("err")
		if ($Notifi == true) then _SetNotifi ("0 packages found." ,1)
		Return
	EndIf	
		
	if StringInStr($aOut[0], "Chocolatey") == 0 Then
		if ($Notifi == true) then _SetNotifi ("ERROR." ,1)
		Return
	EndIf

	local $pkCnt = _ArraySearch($aOut, "packages found.",0, 0, 0, 1, 0, 0)	
	if ($Notifi == true) then _SetNotifi ("Searching 50%" ,1)
	
	For $i = 1 To ( $pkCnt - 1)
		local $pcStr[4]
		$pcStr = StringSplit($aOut[$i]," ")
		
		Local $pkName = $pcStr[1]
		
		if $pkName == "" Then
			if ($Notifi == true) then _SetNotifi ("ERROR." ,1)
			Return
		EndIf
		_log("$pkName=" & $pkName)
		
		Local $pkVer = $pcStr[2]
		Local $pkApproved = False
		if StringInStr ($aOut[$i], "[Approved]") > 0 then $pkApproved = true		
		Local $pkBroken = False
		if StringInStr ($aOut[$i], "- Possibly broken") > 0 then $pkBroken = true
		
		local $sFill = $pkName &"|"& $pkVer &"|"& $pkApproved &"|"& $pkBroken	
		_log($sFill)
		
		GUICtrlCreateListViewItem($sFill, $pkLIst)
		
		local $isInstaled = _ArrayBinarySearch($InstListArr, $pkName)
		
		if ($isInstaled > -1) then 
;~ 				_ArrayDisplay($InstListArr, $isInstaled)
			GUICtrlSetBkColor(-1, $cYellow); Yellow
			if ($InstListArr[$isInstaled][1] == $pkVer) Then GUICtrlSetBkColor(-1, $cGreen) ; Geen	
		EndIf			
	Next	
	if ($Notifi == true) then _SetNotifi ("Searching 80%" ,1)	
	GUICtrlSendMsg($pkLIst, $LVM_SETCOLUMNWIDTH, 0, -1)
	if ($Notifi == true) then _SetNotifi ( $aOut[$pkCnt] ,1)
	$g_idListView = $pkLIst
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
EndFunc

Func _GUI_SeachInRepos($Notifi=true)
	_modal(true,"Working...",$Gui)
	_GUICtrlListView_BeginUpdate($pkLIst)
	_GUICtrlListView_DeleteAllItems($pkLIst)
	_SeachInRepos(GUICtrlRead($i_search),$Notifi)
	_GUICtrlListView_EndUpdate($pkLIst)
	_modal(false,"Working...",$Gui)
EndFunc

Func _SearchLoacal($SearchStr='',$Notifi=true)
	_log('_SearchLoacal')
	if ($Notifi == true) then _SetNotifi ("Searching 0%" ,2)	
	local $InstListArr = _getInstalledList($SearchStr)
	if not IsArray ( $InstListArr ) Then Return
;~ 	_ArrayDisplay($InstListArr, '$InstListArr')
	For $i=0 to (UBound($InstListArr)-1)
		local $sFill = $InstListArr[$i][0] &"|"& $InstListArr[$i][1] &"|"& $InstListArr[$i][2] &"|"& $InstListArr[$i][3]
		GUICtrlCreateListViewItem($sFill, $pkInstaledLIst)
		if Not ($InstListArr[$i][1] == $InstListArr[$i][2])  Then GUICtrlSetBkColor(-1, $cYellow)
	Next
	
	GUICtrlSendMsg($pkInstaledLIst, $LVM_SETCOLUMNWIDTH, 0, -1)
	$g_idListView = $pkInstaledLIst
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	if ($Notifi == true) then _SetNotifi (UBound($InstListArr) & " packages found." ,2)
EndFunc

Func _GUI_SearchLoacal($Notifi=true)
	_modal(true,"Working...",$Gui)
	_GUICtrlListView_BeginUpdate($pkInstaledLIst)
	_GUICtrlListView_DeleteAllItems($pkInstaledLIst)
	_SearchLoacal(GUICtrlRead($i_list),$Notifi)
	_GUICtrlListView_EndUpdate($pkInstaledLIst)
	_modal(false,"Working...",$Gui)
EndFunc

Func _getPkInfo($pkName)
	if $pkName == "" Then Return
	
	Local $_pkInfo = _cash($pkName,$pkInfoArr)
	
	If ($_pkInfo == 0) Then
		$_pkInfo = _runCMDgetOut('choco info ' & $pkName)
		_cash($pkName,$pkInfoArr,True,$_pkInfo)
	EndIf
	
	Local $pkSite = StringRegExp($_pkInfo, '(Software Site:)([\s\S]*?)(\n)', 2)
	$pkSite = StringReplace($pkSite[2],' ','')
	_log($pkSite)
	Local $ChpkURL = 'https://chocolatey.org/packages/' & $pkName 
	
	
	Local $_Summary = StringRegExp($_pkInfo, '(Summary)([\s\S]*?)(\n)', 2)
	if IsArray($_Summary) == 1 Then $_Summary = $_Summary[0]
	Local $_Description = StringRegExp($_pkInfo, '(Description)([\s\S]*?)(\n)', 2)
	if IsArray($_Description) == 1 Then $_Description = $_Description[0]
	_log($_Summary)
	_log($_Description)
	
	local $infStr = $pkName & @CRLF & " "& @CRLF & $_Summary & @CRLF & $_Description
	
	Switch $g_idListView
		case $pkLIst
			GUICtrlSetData ( $L_pkURL, $pkSite )
			GUICtrlSetData ( $L_ChpkURL, $ChpkURL )
			GUICtrlSetData ( $T_info, $infStr )
		case $pkInstaledLIst
			GUICtrlSetData ( $L_pkURL2, $pkSite )
			GUICtrlSetData ( $L_ChpkURL2, $ChpkURL )
			GUICtrlSetData ( $T_info2, $infStr )
		case Else
			GUICtrlSetData ( $L_pkURL, $pkSite )
			GUICtrlSetData ( $L_pkURL2, $pkSite )
			GUICtrlSetData ( $L_ChpkURL, $ChpkURL )
			GUICtrlSetData ( $L_ChpkURL2, $ChpkURL )
			GUICtrlSetData ( $T_info, $infStr )
			GUICtrlSetData ( $T_info2, $infStr )
	EndSwitch
EndFunc

Func _RightToLeftList($Rlist,$Llist,$fn='')
	local $Count = _GUICtrlListView_GetItemCount($Rlist)
	if $Count == 0 Then return
	
	For $i = 0 To ($Count - 1)
		Local $ItemText = StringSplit (_GUICtrlListView_GetItemTextString ($Rlist, $i),"|",2)
		
		Switch $fn
			case 'updAll'
				if Not ($ItemText[1] == $ItemText[2]) Then _GUICtrlListView_SetItemChecked ($Rlist, $i)
		EndSwitch
		
		If _GUICtrlListView_GetItemChecked($Rlist, $i) Then
			$ItemText = $ItemText[0] & "|" & $ItemText[1]
			if (_lvItem_textSearch($Llist, $ItemText) == -1) Then GUICtrlCreateListViewItem( $ItemText &"|", $Llist)
			GUICtrlSendMsg($Llist, $LVM_SETCOLUMNWIDTH, 0, -1)				
		EndIf
	Next
EndFunc

Func _delFromLeftList($Llist)
	_GUICtrlListView_DeleteItemsSelected ( $Llist )
EndFunc

Func _processLeftList($Llist,$fn)
	_log('_processLeftList ' & $fn)
	Local $dOut=False
	Switch $fn
		Case 'install'
			Local $_SetNotifi = "Installing... "
			local $cmd3 = ""
;~ 			If GUICtrlRead($CB_ignorechecksum) = 1 Then 
;~ 				_log("--ignorechecksum")
;~ 				$cmd3 = "--ignorechecksum "
;~ 			EndIf
;~ 			If GUICtrlRead($CB_x86) = 1 Then 
;~ 				_log("--x86")
;~ 				$cmd3 = $cmd3 & "--x86 "
;~ 			EndIf
			
			$cmd3 = GUICtrlRead ($cmdLine2)
			
			Local $cmd1 = ("cinst -y -r " & $cmd3)
			local $cmd2 = true
			$dOut=True
		Case 'uninstall'
			Local $_SetNotifi = "Uninstalling... "
			Local $cmd1 = "choco uninstall -y -r -x "
			local $cmd2 = true
			$dOut=True
		Case 'update'
			Local $_SetNotifi = "Updating... "
			Local $cmd1 = "cup -y -r "
			local $cmd2 = False
			$dOut=True
		Case 'pin'
			Local $_SetNotifi = "Pining... "
			Local $cmd1 = "choco pin -r add --name "
			local $cmd2 = False
		Case 'unpin'
			Local $_SetNotifi = "unPining... "
			Local $cmd1 = "choco pin -r remove --name "
			local $cmd2 = False	
	EndSwitch
	_SetNotifi ($_SetNotifi)
	
	local $Count = _GUICtrlListView_GetItemCount($Llist),$out
	if $Count == 0 Then return
	
	For $i = 0 To ($Count - 1)
		_SetNotifi ($_SetNotifi & Floor(($i * 100)/$Count) & "%")
		Local $ItemText = StringSplit (_GUICtrlListView_GetItemTextString ($Llist, $i),"|",2)
;~ 		_ArrayDisplay($ItemText, '$ItemText')
		Local $pkName = $ItemText[0], $pkVer = $ItemText[1],$cmd = ''
;~ 		_log($pkVer)
		if ($cmd2 == true) And (not ($pkVer == '')) Then 
				$cmd = $cmd1 & $pkName & ' --version=' & $pkVer
			Else
				$cmd = $cmd1 & $pkName 
		EndIf			
		$out &= _runCMDgetOut($cmd,True,True,$dOut)
	Next
	
	local $Failures = UBound(StringRegExp($out, 'Failures', 3))
	_SetNotifi ("Finish " & "Failures:" & $Failures)		
	GUICtrlSetTip($LBpkCount, $out)	
	GUICtrlSetData ( $E_consoleOut, $out )
	_GUICtrlListView_DeleteAllItems ( $Llist )	
EndFunc

Func _saveList($hFile)
	Local $instStr
	local $Count = _GUICtrlListView_GetItemCount($Lv_installList)
	if $Count == 0 Then return
	
	For $i = 0 To ($Count - 1)
		Local $ItemText = StringSplit (_GUICtrlListView_GetItemTextString ($Lv_installList, $i),"|",2)
		$instStr &= $ItemText[0] & ' '
	Next	
	
	if FileExists($hFile) Then FileDelete ($hFile)
	FileWrite ( $hFile, $instStr )
EndFunc

Func _loadList($hFile)
	Local $instStr = FileRead($hFile)
	$instStr = StringSplit ( $instStr, " " ,2)
	
	_GUICtrlListView_BeginUpdate($Lv_installList)
	
	for $i=0 to (UBound($instStr)-1)
		if not ($instStr[$i] == '') and (_GUICtrlListView_FindText($Lv_installList, $instStr[$i]) == -1) Then GUICtrlCreateListViewItem ( $instStr[$i], $Lv_installList )
	Next
	
	_GUICtrlListView_EndUpdate($Lv_installList)
	
EndFunc

Func _chocolateyInstall()
	if not (EnvGet("ChocolateyInstall") == '') then Return
	
	local $yes = MsgBox(4+8192+262144,"chocolatey not installed","Install chocolate?",0)
	switch $yes

		case 6 ;YES
			_modal(true,"Installing chocolatey...",$Gui)
			Local $_cmd1 = "'https://chocolatey.org/install.ps1'"
			Local $_cmd = @ComSpec &' /C '& '@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('&$_cmd1&'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"'
			RunWait($_cmd, '', @SW_MAXIMIZE)		
			Run(@AppDataCommonDir & '\chocolatey\choco.exe', '', @SW_MAXIMIZE)		
			$hWnd = WinWait(".NET Framework", "", 5)
			_modal(false,"",$Gui)
			_log('WinWait ' & $hWnd)
			If $hWnd Then
				_log('WinWait ok')
				WinClose($hWnd)					
					$rb = MsgBox(52,"","reboot needed!",0)
					switch $rb
						case 6 ;YES
							Shutdown ( 2 )
							Exit
						case 7 ;NO
							Exit
					endswitch
				Else
					$_cmd = @AppDataCommonDir & '\chocolatey\choco.exe'
					local $instOut = _runCMDgetOut($_cmd)
					if (StringInStr ( $instOut, "Chocolatey") > 0) Then
							MsgBox(64,"","Chocolatey installed",0)	
;~ 							$_cmd = 'start cmd /c taskkill /im ' & @ScriptName &' && start '& @ScriptFullPath					
;~ 							if @Compiled then Run($_cmd, '', @SW_HIDE) 
;~ 							Run(@ComSpec &' /C start cmd /c start ' & @ScriptFullPath, "", @SW_HIDE)
							Exit
						Else
							MsgBox(64,"something is wrong!",$instOut,0)
							Exit
					EndIf
						
			EndIf
		case 7 ;NO
			Exit

	endswitch

EndFunc