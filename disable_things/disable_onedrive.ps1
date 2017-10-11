# This script completely removes OneDrive.
# Author: Nathan Towell
#requires -version 4.0
#requires –runasadministrator
#

#Stop OneDrive
Stop-Process -Name OneDrive

# Uninstall OneDrive
if ([Environment]::Is64BitProcess) {
    $executable = $env:SystemRoot + '\SysWOW64\OneDriveSetup.exe'
    Start-Process -FilePath $executable -ArgumentList '-uninstall' -NoNewWindow -Wait
}
else {
    $executable = $env:SystemRoot + '\System32\OneDriveSetup.exe'
    Start-Process -FilePath $executable -ArgumentList '-uninstall' -NoNewWindow -Wait
}

# Remove Folders
$paths = @(
    'C:\OneDriveTemp',
    '$env:USERPROFILE\OneDrive',
    '$env:LOCALAPPDATA\Microsoft\OneDrive',
    '$env:PROGRAMDATA\Microsoft OneDrive'
)

for ($p=0;$p -lt $paths.length; $p++) {
    $path = $paths[$p]
    if (Test-Path $path -PathType Any) {
        Remove-Item -Force -Recurse -Path $path
    }
}


# Removing OneDrive shortcut from windows explorer sidebar.
New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT  -Name HKCR | Out-Null
Set-ItemProperty -Path 'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Name System.IsPinnedToNameSpaceTree -Value 0
if ([Environment]::Is64BitProcess) {
    Set-ItemProperty -Path 'HKCR:\WOW6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Name System.IsPinnedToNameSpaceTree -Value 0
}

# Restart File Explorer
Stop-Process -ProcessName Explorer
