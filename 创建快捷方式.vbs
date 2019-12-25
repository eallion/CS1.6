Set WshShell = WScript.CreateObject("WScript.Shell")
strDesktop = WshShell.SpecialFolders("Desktop")
set oShellLink = WshShell.CreateShortcut(strDesktop & "\CS1.6 Launch.lnk")
oShellLink.TargetPath = WshShell.CurrentDirectory & "\Counter-Strike\cs1.6.exe"
oShellLink.Arguments = "-game cstrike -gl -noipx -hisap -noforcemaccel -noforcemparms -noforcemspd -nojoy -32bpp"
oShellLink.WindowStyle = 1
oShellLink.Hotkey = ""
oShellLink.IconLocation = WshShell.CurrentDirectory & "\Counter-Strike\cs1.6.exe, 0"
oShellLink.Description = "cs.eallion.com cs1.6 Launch"
oShellLink.WorkingDirectory = WshShell.CurrentDirectory & "\Counter-Strike\"
oShellLink.Save

Set WshShell = WScript.CreateObject("WScript.Shell")
strDesktop = WshShell.SpecialFolders("Desktop")
set oShellLink = WshShell.CreateShortcut(strDesktop & "\HLSW.lnk")
oShellLink.TargetPath = WshShell.CurrentDirectory & "\tools\hlsw\hlsw.exe"
oShellLink.WindowStyle = 1
oShellLink.Hotkey = ""
oShellLink.IconLocation = WshShell.CurrentDirectory & "\tools\hlsw\hlsw.exe, 0"
oShellLink.Description = "HLSW"
oShellLink.WorkingDirectory = WshShell.CurrentDirectory & "\tools\hlsw\"
oShellLink.Save