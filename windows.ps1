# Run as Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process Powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Set-Location (Split-Path -Parent $PSCommandPath)

$packages = Get-Content "winget.packages"

# Install packages in winget.packages
Write-Host "Installing packages..." -ForegroundColor Green
foreach ($package in $packages) {
    winget install $package -e
}

$username = (gh auth status | Select-String -Pattern "Logged in to github.com account (\S+)" | ForEach-Object { $_.Matches.Groups[1].Value })

# If GitHub CLI is installed, authenticate
if (!($username)) {
    gh auth login -w -p 'https'
    $username = (gh auth status | Select-String -Pattern "Logged in to github.com account (\S+)" | ForEach-Object { $_.Matches.Groups[1].Value })

}

# Exit it failed to auth with GitHub
if (!($username)) {
    exit
}

# Start configuring
Write-Host "Dipping the dots..." -ForegroundColor Cyan
gh repo clone $username/dots

pwsh '.\dots\launch\windows.ps1'
