option explicit
Dim wsh,reg
set wsh=Wscript.CreateObject("Wscript.shell")
reg="HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools"
wsh.RegWrite reg,&H00000000,"REG_DWORD"
wscript.echo "注册表已经被解除"