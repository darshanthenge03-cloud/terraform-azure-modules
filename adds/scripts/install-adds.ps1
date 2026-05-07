Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

$script = @"

Import-Module ADDSDeployment

$safeModePassword = ConvertTo-SecureString 'Network@1234' -AsPlainText -Force

Install-ADDSForest `
-DomainName 'dalberg.local' `
-SafeModeAdministratorPassword $safeModePassword `
-InstallDNS `
-Force

"@

$path = "C:\\promote-dc.ps1"

Set-Content -Path $path -Value $script

$action = New-ScheduledTaskAction `
-Execute "PowerShell.exe" `
-Argument "-ExecutionPolicy Bypass -File C:\\promote-dc.ps1"

$trigger = New-ScheduledTaskTrigger -AtStartup

Register-ScheduledTask `
-TaskName "PromoteDC" `
-Action $action `
-Trigger $trigger `
-User "SYSTEM" `
-RunLevel Highest `
-Force

Restart-Computer -Force
