param (
    [string]$DomainName,
    [string]$SafeModePassword
)

Start-Transcript -Path "C:\install-adds.log"

try {

    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

    Import-Module ADDSDeployment

    $safePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force

    Install-ADDSForest `
        -DomainName $DomainName `
        -SafeModeAdministratorPassword $safePassword `
        -InstallDNS `
        -Force `
        -NoRebootOnCompletion:$false

}
catch {

    $_ | Out-File "C:\adds-error.log"

    throw
}

Stop-Transcript
