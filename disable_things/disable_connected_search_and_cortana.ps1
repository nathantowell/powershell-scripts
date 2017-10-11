# This script diables connected search and cortana in the start menu.
# Author: Nathan Towell
#requires -version 4.0
#requires –runasadministrator
#

# Naviage to registry location
New-PSDrive -PSProvider registry -Root HKEY_LOCAL_MACHINE  -Name HKLM | Out-Null
if(!(Test-Path -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\')) {
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\' -Name 'Windows Search'
}
Set-Location 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\'

# Disable connected search in the start menu.
Set-ItemProperty -Path . -Name AllowSearchToUseLocation -Value 0
Set-ItemProperty -Path . -Name ConnectedSearchUseWeb -Value 0
Set-ItemProperty -Path . -Name ConnectedSearchUseWebOverMeteredConnection -Value 0
Set-ItemProperty -Path . -Name DisableWebSearch -Value 1

# Disable Cortana in the start menu.
Set-ItemProperty -Path . -Name AllowCortana -Value 0
Set-ItemProperty -Path . -Name AllowCortanaAboveLock -Value 0

# Reset registry locatation.
Pop-Location

# Restart File Explorer
Stop-Process -ProcessName Explorer
