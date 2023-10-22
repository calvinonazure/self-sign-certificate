$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

$rootCA = "SelfSign Root CA"
$IntermediateCA = "SelfSign Intermediate CA"
$domainname = "www.abc.com"
$password = "Start123"

Write-Host "Generating SelfSign Certificate" -ForegroundColor:Green

$outputDir = "CERT-$((Get-Date).ToString("yyyyMMddHHmmss"))"

# Update openssl.cnf file
md "$scriptPath/$outputDir"
$content = Get-Content "$scriptPath/openssl.cnf"
$content = $content.Replace("www.contoso.com",$domainname)
Set-Content "$scriptPath/$outputDir/openssl.cnf" $content
cd "$scriptPath/$outputDir"

Write-Host "Creating RootCA"  -ForegroundColor:Green
openssl genrsa -out ca.key 4096
openssl req -new -x509 -days 3650 -subj='/O=MS/OU=CSS/CN=SelfSign Root CA' -config openssl.cnf -key ca.key -out ca.crt
openssl x509 -text -noout -in ca.crt

Write-Host "Creating Inter Cert" -ForegroundColor:Green
openssl genrsa -out inter.key 4096
openssl req -new -sha256 -key inter.key -subj='/O=MS/OU=CSS/CN=SelfSign Intermediate CA' -out inter.csr -config openssl.cnf
openssl x509 -req -sha256 -in inter.csr -out inter.crt -CA ca.crt -CAkey ca.key -CAcreateserial -extfile openssl.cnf -extensions v3_inter_ca -days 3650
openssl x509 -text -noout -in inter.crt
openssl verify -CAfile ca.crt inter.crt


Write-Host "Creating Client Cert" -ForegroundColor:Green
openssl genrsa -out client.key 4096
openssl req -new -sha256 -key client.key -subj="/O=MS/OU=CSS/CN=$domainname" -out client.csr -config openssl.cnf
openssl x509 -req -sha256 -in client.csr -out client.crt -CA inter.crt -CAkey inter.key -CAcreateserial -extfile openssl.cnf -extensions v3_client -days 3650
openssl x509 -text -noout -in client.crt
openssl verify -CAfile ca.crt -untrusted inter.crt client.crt

Write-Host "Put CA and Inter Certs together"
$caContent = Get-Content ca.crt
$interContent = Get-Content inter.crt
Set-Content ".\cafile.crt" $caContent
Add-Content ".\cafile.crt" $interContent

Write-Host "Packaging PFX"
openssl pkcs12 -export -passout "pass:$password" -out client.pfx -inkey client.key -in client.crt -CAfile cafile.crt

cd "$scriptPath"