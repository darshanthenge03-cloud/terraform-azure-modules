param (
    [string]$RegistrationToken
)

Invoke-WebRequest `
-Uri "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv" `
-OutFile "C:\AVD-Agent.msi"

Invoke-WebRequest `
-Uri "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH" `
-OutFile "C:\AVD-Bootloader.msi"

Start-Process msiexec.exe `
-Wait `
-ArgumentList "/i C:\AVD-Agent.msi /quiet REGISTRATIONTOKEN=$RegistrationToken"

Start-Process msiexec.exe `
-Wait `
-ArgumentList "/i C:\AVD-Bootloader.msi /quiet"

Restart-Computer -Force
