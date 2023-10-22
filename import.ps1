$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

$certDir = "CERT-20231022173040"

$rootCAFile = "$scriptPath/$certDir/ca.crt"
Import-Certificate -FilePath $rootCAFile -CertStoreLocation Cert:\LocalMachine\Root

$caFile = "$scriptPath/$certDir/inter.crt"
Import-Certificate -FilePath $caFile -CertStoreLocation Cert:\LocalMachine\CA