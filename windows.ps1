# Run as Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process Powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Install pwsh
Write-Host "Installing pwsh..." -ForegroundColor Cyan
Start-Job { winget install -e --id Microsoft.PowerShell } | Wait-Job | Out-Null
Write-Host 'pwsh Installed' -ForegroundColor Green

# Install Git
Write-Host "Installing Git..." -ForegroundColor Cyan
Start-Job { winget install -e --id Git.Git } | Wait-Job | Out-Null
Write-Host 'Git Installed' -ForegroundColor Green

# Install gh cli
Write-Host "Installing gh..." -ForegroundColor Cyan
Start-Job { winget install -e --id Microsoft.PowerShell } | Wait-Job | Out-Null
gh auth login
Write-Host 'gh Installed' -ForegroundColor Green

# Get dot files
Write-Host "Dipping the dots..." -ForegroundColor Cyan
Start-Job { gh repo clone tbrundige/dots } | Wait-Job | Out-Null
pwsh './launch/windows.ps1'
