param (
    [string]$DomainName,
    [string]$SafeModePassword
)

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

$safePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force

Install-ADDSForest `
    -DomainName $DomainName `
    -SafeModeAdministratorPassword $safePassword `
    -InstallDNS `
    -Force
