' Create and apply a registry mouse acceleration fix for Windows 7 or Vista or XP.
' Copyright 2010 Mark Cranness.
'
' Create a registry .REG file that removes Windows' mouse acceleration.
'
' The registry fix created works like the CPL and Cheese and MarkC fixes,
'  but is customized for your specific desktop display text size (DPI),
'  your specific mouse pointer speed slider setting, your specific refresh rate
'  and has any pointer scaling/sensitivity factor you want.
'
' Other Registry fixes need the pointer speed slider set to 6/11 (middle) to get
'  exactly 1-to-1 mouse to pointer response, but this script can create a registry
'  fix that gives exact 1-to-1 response for non-6/11 settings.
' Other registry fixes only provide files for some pre-defined display DPI 
'  values: 100%, 125%..., but this script can create a fix for any DPI setting.
' This script can create a fix with any mouse-to-pointer scaling factor you want.

' The current system is queried, and the user can change the values and tune the
'  registry fix file created.
' The result is saved to a file and can optionally be imported into the registry.
'
' This script asks for:
' - Operating system that the fix will be used for.
' - The desktop Control Panel, Display, text size (DPI) that will be used.
' - The in-game monitor refresh rate that will be used (XP and Vista only).
' - The Control Panel, Mouse, pointer speed slider position that will be used.
' - The pointer speed scaling (sensitivity) factor for that pointer speed setting.
' - Where you want to save the fix to and what name.
'
' It creates a registry .reg file with the settings entered, and
' optionally lets you merge / apply it into the registry.
'
' Credits: hoppan and scandalous for debugging and testing, Microsoft for inspiration.

option explicit
const XPVistaFix  = "XP+Vista"
const Windows7Fix = "Windows7"
dim WshShell, WMIService, OS, videoController, Shell, Folder, RegFile, FileSystem ' as Object
dim OSVersion, FixType, DPI, RefreshRate, MouseSensitivity
dim MouseSensitivityFactor, PointerSpeed, Scaling, ScalingDescr
dim RegFilename, FolderName, OSConfirmText
dim SmoothX, SmoothY, Accel, DPIFactor

set WshShell = WScript.CreateObject("WScript.Shell")
set WMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")

' Get the OS on this machine, and display DPI
for each OS in WMIService.ExecQuery("select * from Win32_OperatingSystem where Primary='True'")
	OSVersion = Left(OS.Version, InStr(InStr(OS.Version,".")+1, OS.Version, ".")-1)
	DPI = 96 ' Default in case RegRead errors
	on error resume next ' On 7, Desktop\LogPixels not present until DPI is changed
	select case OSVersion
	case "5.1","6.0"
		FixType = XPVistaFix
		OSVersion = XPVistaFix
		DPI = WshShell.RegRead("HKEY_CURRENT_CONFIG\Software\Fonts\LogPixels")
	case "6.1"
		FixType = Windows7Fix
		OSVersion = Windows7Fix
		DPI = WshShell.RegRead("HKEY_CURRENT_USER\Control Panel\Desktop\LogPixels")
	case else
		FixType = Windows7Fix
	end select
	on error goto 0 ' Normal errors
next

do ' Get which OS the fix will be used for
	FixType = InputBox( _
		"This script program creates a registry .REG file that removes Windows' mouse acceleration." _
		& vbNewLine & vbNewLine _
		& "The registry fix created works like the CPL and Cheese and MarkC fixes," _
		& " but is customized for your specific desktop display text size (DPI)," _
		& " your specific mouse pointer speed slider setting, your specific refresh rate" _
		& " and has any pointer scaling/sensitivity factor you want." _
		& vbNewLine & vbNewLine _
		& "Enter the operating system that the fix will be used for." _
		& vbNewLine & vbNewLine _
		& "1/XP+Vista	= Windows XP or Windows Vista" & vbNewLine _
		& "2/Windows7	= Windows 7", _
		"Operating System - MarkC Mouse Acceleration Fix", FixType)
	select case LCase(FixType)
	case ""
		WScript.Quit
	case "1", "xp", "vista", "xpvista", "xp+vista"
		FixType = XPVistaFix
		exit do
	case "2", "win7", "windows7", "windows 7"
		FixType = Windows7Fix
		DPI = int((100*DPI/96)+0.5) ' round() rounds to even: we don't want that
		exit do
	case else
		WshShell.Popup "'" & FixType & "' is not valid.",, "Error", vbExclamation
	end select
loop while true

do ' Get the display DPI the fix will be used with
	dim NumDPI
	if FixType = Windows7Fix then
		if InStr(DPI,"%") = 0 then DPI = DPI & "%"
		DPI = InputBox( _
			"Enter the desktop Control Panel, Display, text size (DPI) that will be used.", _
			"Display DPI - MarkC Mouse Acceleration Fix", DPI)
		if DPI = "" then WScript.Quit
		if InStr(DPI,"%") = len(DPI) and IsNumeric(left(DPI,len(DPI)-1)) then
			NumDPI = CInt(left(DPI,len(DPI)-1))
			if NumDPI > 0 and CStr(NumDPI) & "%" = DPI then DPI = NumDPI : exit do
		end if
		WshShell.Popup "'" & DPI & "' is not valid.",, "Error", vbExclamation
	else
		DPI = InputBox( _
			"Enter the desktop Control Panel, Display, DPI scaling setting that will be used.", _
			"Display DPI - MarkC Mouse Acceleration Fix", DPI)
		if DPI = "" then WScript.Quit
		if IsNumeric(DPI) then 
			NumDPI = CInt(DPI)
			if NumDPI > 0 and CStr(NumDPI) = DPI then DPI = NumDPI : exit do
		end if
		WshShell.Popup "'" & DPI & "' is not valid.",, "Error", vbExclamation
	end if
loop while true

if FixType <> Windows7Fix then ' Get the monitor refresh rate the fix will be used with
	for each videoController in WMIService.InstancesOf("Win32_VideoController")
		RefreshRate = videoController.CurrentRefreshRate
	next
	do
		RefreshRate = InputBox( _
			"Enter the in-game monitor refresh rate that will be used." _
			& vbNewLine & vbNewLine _
			& "NOTE: Your desktop refresh rate is " & RefreshRate & "Hz." _
			& vbNewLine & vbNewLine _
			& "Enter the refresh rate used by your game, when the fix will be active.", _
			"Refresh Rate - MarkC Mouse Acceleration Fix", RefreshRate)
		if RefreshRate = "" then WScript.Quit
		if IsNumeric(RefreshRate) then
			dim NumRefreshRate : NumRefreshRate = CInt(RefreshRate)
			if NumRefreshRate > 0 and CStr(NumRefreshRate) = RefreshRate then RefreshRate = NumRefreshRate : exit do
		end if
		WshShell.Popup "'" & RefreshRate & "' is not valid.",, "Error", vbExclamation
	loop while true
end if

' Get the pointer speed slider setting the fix will be used with
MouseSensitivity = CInt(WshShell.RegRead("HKEY_CURRENT_USER\Control Panel\Mouse\MouseSensitivity"))
if MouseSensitivity > 2 then PointerSpeed = MouseSensitivity / 2 + 1 else PointerSpeed = MouseSensitivity
do
	PointerSpeed = InputBox( _
		"Enter the Control Panel, Mouse, pointer speed slider position that will be used." _
		& vbNewLine & vbNewLine _
		& "1	= extreme left, Slow" & vbNewLine _
		& "2-5" & vbNewLine _
		& "6	= middle, 6/11 position" & vbNewLine _
		& "7-10	" & vbNewLine _
		& "11	= extreme right, Fast", _
		"Pointer Speed Slider - MarkC Mouse Acceleration Fix", CStr(PointerSpeed))
	if PointerSpeed = "" then WScript.Quit
	if IsNumeric(PointerSpeed) then
		dim NumSpeed : NumSpeed = CDbl(PointerSpeed)
		if NumSpeed >= 1 and NumSpeed <= 11 _
				and (NumSpeed = 1 or (NumSpeed >= 2 and int(2*NumSpeed) = 2*NumSpeed)) then
			PointerSpeed = NumSpeed
			exit do
		end if
	end if
	WshShell.Popup "'" & PointerSpeed & "' is not valid.",, "Error", vbExclamation
loop while true

' Convert pointer speed slider to a numeric sensitivity
if PointerSpeed > 2 then MouseSensitivity = CInt(2*PointerSpeed - 2) else MouseSensitivity = CInt(PointerSpeed)
if MouseSensitivity <= 2 then
	MouseSensitivityFactor = MouseSensitivity / 32
elseif MouseSensitivity <= 10 then
	MouseSensitivityFactor = (MouseSensitivity-2) / 8
else
	MouseSensitivityFactor = (MouseSensitivity-6) / 4
end if

Scaling = "1-to-1"
do ' Get the scaling (sensitivity) factor
	Scaling = InputBox( _
		"Enter the pointer speed scaling (sensitivity) factor that you want" _
		& " when the pointer speed slider is at the " & CStr(PointerSpeed) & "/11 position." _
		& vbNewLine & vbNewLine _
		& "1/1-to-1	= Exactly 1-to-1 (RECOMMENDED)" & vbNewLine _
		& "E	= x " & CStr(MouseSensitivity/10) & " (same as EPP=ON)" & vbNewLine _
		& "N	= x " & Cstr(MouseSensitivityFactor) & " (same as EPP=OFF)" & vbNewLine _
		& replace(CStr(1.111),"1","n",1,-1) & "	= a custom scaling factor (example: " & CStr(1.25) & ")", _
		"Pointer Speed Scaling - MarkC Mouse Acceleration Fix", Scaling)
	if Scaling = "" then WScript.Quit
	select case LCase(Scaling)
	case "1", "1-to-1"
		Scaling = 1
		exit do
	case "e"
		Scaling = MouseSensitivity/10
		exit do
	case "n"
		Scaling = MouseSensitivityFactor
		exit do
	end select
	if IsNumeric(Scaling) then if CDbl(Scaling) > 0 and CDbl(Scaling) <= 16 then Scaling = CDbl(Scaling) : exit do
	WshShell.Popup "'" & Scaling & "' is not valid.",, "Error", vbExclamation
loop while true

' Get the folder where the fix is to be created
set Shell = CreateObject("Shell.Application")
const BIF_RETURNONLYFSDIRS   = &H0001
const BIF_RETURNFSANCESTORS  = &H0008
const BIF_NEWDIALOGSTYLE 	 = &H0040
const BIF_NONEWFOLDERBUTTON  = &H0200
const BIF_SHAREABLE          = &H8000
set Folder = Shell.BrowseForFolder(0, _
	"Select the folder where the registry mouse acceleration fix will be saved.", _
	BIF_NEWDIALOGSTYLE or BIF_RETURNONLYFSDIRS or BIF_RETURNFSANCESTORS or BIF_NONEWFOLDERBUTTON)
if Folder is nothing then WScript.Quit
FolderName = Folder.Self.Path

' Sanity check on folder name
set FileSystem = CreateObject("Scripting.FileSystemObject")
if not FileSystem.FolderExists(FolderName) then
	WshShell.Popup "'" & Folder.Title & "' is not a usable folder.",, "Invalid Folder", vbExclamation
	WScript.Quit
end if

' Get a suggested filename for the registry fix
if Scaling = 1 then ScalingDescr = "1-to-1" else ScalingDescr = "x" & CStr(Scaling)
if FixType = Windows7Fix then
	RegFilename = "Windows7_MouseFix_TextSize(DPI)=" & DPI _
		& "%_Scale=" & ScalingDescr & "_@" & PointerSpeed & "-of-11.reg"
	OSConfirmText = _
		"OS : Windows 7" & vbNewLine _
		& "Text size (DPI) : " & DPI & "%" & vbNewLine
else
	RegFilename = "XP+Vista_MouseFix_@" & RefreshRate & "Hz_DPI=" & DPI _
		& "_Scale=" & ScalingDescr & "_@" & PointerSpeed & "-of-11.reg"
	OSConfirmText = _
		"OS : XP or Vista" & vbNewLine _
		& "Desktop monitor DPI : " & DPI & vbNewLine _
		& "In-game refresh rate : " & RefreshRate & "Hz" & vbNewLine
end if

' Ask for confirmation of parameters and filename
RegFilename = InputBox( _
	"Confirm the fix details and click OK." _
	& vbNewLine & vbNewLine _
	& OSConfirmText _
	& "Pointer speed slider : " & PointerSpeed & "/11" & vbNewLine _
	& "Pointer speed scaling : " & ScalingDescr & vbNewLine _
	& "Save to folder : " & FolderName & vbNewLine _
	& "Save to file : (file name below)", _
	"Save Fix - MarkC Mouse Acceleration Fix", RegFilename)
if RegFilename = "" then WScript.Quit

' Check and open the file
RegFilename = FileSystem.BuildPath(FolderName, FileSystem.GetBaseName(RegFilename) & ".reg")
if FileSystem.FileExists(RegFilename) then
	if WshShell.Popup( _
			RegFilename & " already exists." & vbNewLine & "Do you want to replace it?", , _
			"Save As", vbExclamation or vbYesNo) <> vbYes then
		WScript.Quit
	end if
end if
set RegFile = FileSystem.CreateTextFile(RegFilename, True)

' Compute the magic SmoothMouseCurve numbers
if FixType = Windows7Fix then
	DPI = round(DPI*96/100)
	DPIFactor = B(Max(96,DPI)/150)
else
	DPIFactor = B(Max(60,RefreshRate)/Max(96,DPI))
end if
SmoothY = B(16*3.5)
if MouseSensitivity  = 1 then SmoothY = SmoothY * 2 ' Ensure we
if MouseSensitivity <= 2 then SmoothY = SmoothY * 2 ' have enough
if Scaling > 3 then SmoothY = SmoothY * 2           ' bits of
if Scaling > 6 then SmoothY = SmoothY * 2           ' precision
if Scaling > 9 then SmoothY = SmoothY * 2           ' using
if Scaling > 12 then SmoothY = SmoothY * 2          ' somewhat arbitrary
if DPI > 144 and Scaling > 1 then SmoothY = SmoothY * 2 ' rules
Accel = BMult(SmoothY, DPIFactor)
Accel = BMult(Accel, B(MouseSensitivity/10))
SmoothX = B(Accel/(B(Scaling)*3.5))

' Make sure the magic numbers give the exact result
Accel = BDiv(Accel, BMult(SmoothX, B(3.5)))
if Accel <> B(Scaling) then
	' No exact calculation, adjust SmoothY to make it match exactly
	' (This only happens for small MouseSensitivity or large Scaling)
	if Accel > B(Scaling) then ' (Always happens)
		SmoothX = SmoothX + 1
	end if ' (Now Accel < Scaling)
	dim SmoothYAdjusted : SmoothYAdjusted = SmoothY
	do ' Slowly adjust SmoothY until we get a match
		SmoothYAdjusted = SmoothYAdjusted + 1
		Accel = BMult(SmoothYAdjusted, DPIFactor)
		Accel = BMult(Accel, B(MouseSensitivity/10))
		Accel = BDiv(Accel, BMult(SmoothX, B(3.5)))
		if Accel = B(Scaling) then
			SmoothY = SmoothYAdjusted ' Done!
			exit do
		end if
	loop until Accel > B(Scaling)
	' if Accel <> B(Scaling) now, then I don't care: close enough!
end if

' Write the registry fix to the file
RegFile.WriteLine "Windows Registry Editor Version 5.00"
RegFile.WriteLine
RegFile.WriteLine "[HKEY_CURRENT_USER\Control Panel\Mouse]"
RegFile.WriteLine
RegFile.WriteLine """MouseSensitivity""=""" & MouseSensitivity & """"
RegFile.WriteLine """SmoothMouseXCurve""=hex:\"
RegFile.WriteLine vbTab & CurveHex(0) & ",\"
RegFile.WriteLine vbTab & CurveHex(SmoothX) & ",\"
RegFile.WriteLine vbTab & CurveHex(2*SmoothX) & ",\"
RegFile.WriteLine vbTab & CurveHex(3*SmoothX) & ",\"
RegFile.WriteLine vbTab & CurveHex(4*SmoothX)
RegFile.WriteLine """SmoothMouseYCurve""=hex:\"
RegFile.WriteLine vbTab & CurveHex(0) & ",\"
RegFile.WriteLine vbTab & CurveHex(SmoothY) & ",\"
RegFile.WriteLine vbTab & CurveHex(2*SmoothY) & ",\"
RegFile.WriteLine vbTab & CurveHex(3*SmoothY) & ",\"
RegFile.WriteLine vbTab & CurveHex(4*SmoothY)
if FixType = Windows7Fix then
	RegFile.WriteLine
	RegFile.WriteLine "[HKEY_USERS\.DEFAULT\Control Panel\Mouse]"
	RegFile.WriteLine
	RegFile.WriteLine """MouseSpeed""=""0"""
	RegFile.WriteLine """MouseThreshold1""=""0"""
	RegFile.WriteLine """MouseThreshold2""=""0"""
end if
RegFile.Close

if OSVersion = FixType then

	' Confirm save
	WshShell.Popup "Mouse acceleration fix " & RegFilename & " saved.", , "Fix Saved", vbInformation

	' Offer to apply the created reg file
	dim FixApplied : FixApplied = false
	if WshShell.Popup( _
			"IMPORTANT: The fix has NOT been applied." _
			& vbNewLine & vbNewLine _
			& "To apply the fix you must:" & vbNewLine _
			& "1) Add it to the registry, then" & vbNewLine _
			& "2) Log off or reboot." _
			& vbNewLine & vbNewLine _
			& "Do you want to add the information in the fix to the registry?", , _
			"Fix Not Yet Applied", vbExclamation or vbYesNo) = vbYes then
		WshShell.Run "regedit.exe """ & RegFilename & """", 1, True ' Wait for regedit to exit
		' Check it has been merged
		if CInt(WshShell.RegRead("HKEY_CURRENT_USER\Control Panel\Mouse\MouseSensitivity")) _
				= MouseSensitivity _
			and DWordFromBytes(1, WshShell.RegRead("HKEY_CURRENT_USER\Control Panel\Mouse\SmoothMouseXCurve")) _
				= SmoothX _
			and DWordFromBytes(1, WshShell.RegRead("HKEY_CURRENT_USER\Control Panel\Mouse\SmoothMouseYCurve")) _
				= SmoothY then
			FixApplied = true
		end if
	end if
	if not FixApplied then
		' Have kittens (I don't want the support headache...)
		WshShell.Popup _
			"IMPORTANT: The fix has NOT been applied!" _
			& vbNewLine & vbNewLine _
			& "To apply the fix you must:" _
			& vbNewLine & vbNewLine _
			& "1) Add it to the registry (select it in Windows Explorer and double-click it), then" _
			& vbNewLine & vbNewLine _
			& "2) Log off or reboot.", , _
			"Fix Not Applied!", vbCritical
	end if

	if FixType = Windows7Fix then
		' Check if non-administrator account has prevented update to .DEFAULT\...\MouseSpeed
		dim LoginMouseSpeed
		LoginMouseSpeed = WshShell.RegRead("HKEY_USERS\.DEFAULT\Control Panel\Mouse\MouseSpeed")
		if LoginMouseSpeed <> "0" then
			on error resume next
			WshShell.RegWrite "HKEY_USERS\.DEFAULT\Control Panel\Mouse\MouseSpeed", LoginMouseSpeed
			if Err.Number <> 0 then ' RegWrite fails => non admin account
				WshShell.Popup _
					"Part of the mouse acceleration fix can't be applied," _
					& " because you are not logged in as an Administrator." _
					& vbNewLine & vbNewLine _
					& "To apply this part, run CMD file" & vbNewLine _
					& "MarkC_Disable_WelcomeScreen+Login_Accel.CMD" & vbNewLine _
					& "while logged in as an administrator" _
					& ", or see the ReadMe.txt file for more information.", , _
					"Part of Fix Not Applied!", vbCritical

			end if
			on error goto 0 ' Normal errors
		end if
	end if

else ' OSVersion <> FixType

	' Confirm save
	WshShell.Popup _
		"Mouse acceleration fix " & RegFilename & " saved." _
		& vbNewLine & vbNewLine _
		& "NOTE: The fix has NOT been applied." & vbNewLine & vbNewLine _
		& "To apply the fix you must add it to the registry then log off or reboot.", , _
		"Fix Saved", vbInformation

end if

' END

' Convert to fixed point (n.16) binary
function B(n)
	B = int(65536 * n)
end function

' Fixed point (n.16) binary multiply
function BMult(m1, m2)
	BMult = int(m1 * m2 / 65536)
end function

' Fixed point (n.16) binary divide
function BDiv(n, d)
	BDiv = int(65536 * n / d)
end function

' Convert number to registry REG_BINARY hex: format
function CurveHex(n)
	dim h, ch, i
	h = right("0000000" & hex(n), 8)
	ch = ""
	for i = 3 to 0 step -1
		ch = ch & mid(h, i*2+1, 2) & ","
	next
	CurveHex = ch & "00,00,00,00"
end function

function Max(n1, n2)
	if n1 > n2 then
		Max = n1
	else
		Max = n2
	end if
end function

function DWordFromBytes(i, Bytes)
	i = 8*i
	DWordFromBytes = 256*(256*(256*Bytes(i+3) + Bytes(i+2)) + Bytes(i+1)) + Bytes(i)
end function