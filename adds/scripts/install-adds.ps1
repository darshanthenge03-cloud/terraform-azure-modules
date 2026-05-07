Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

$safeModePassword = ConvertTo-SecureString "Network@1234" -AsPlainText -Force

Install-ADDSForest `
-DomainName "dalberg.local" `
-SafeModeAdministratorPassword $safeModePassword `
-InstallDNS `
-Force
