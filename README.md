# self-sign-certificate
Generate a self-signed certificate with OpenSSL

## Prerequisite
The scripts will use the openssl to generate self signed certificate, this tool should already installed in Windows 10 machine. 
In case you don't have the tool, try to install it from https://www.openssl.org/

## Scripts

1. selfsign.ps1

Open the script and update following variables based on your requirements, and then save it

```powershell
$rootCA = "SelfSign Root CA"
$IntermediateCA = "SelfSign Intermediate CA"
$domainname = "www.abc.com"
$password = "Start123"
```

Open PowerShell window and execute `.\selfsign.ps1` command, it will create a forder with format `CERT-yyyyMMddHHmmss`, the generated client.pfx file is what you could used to upload to cloud platform.

2. import.ps1

This script used to import the generated Root and CA files to your local machine truested store, so it could trust the client certificate you generated before. 

Open the PowerShell window as `Administrator` mode and execute `.\import.ps1` command, you will see the success information like below

```
   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\Root

Thumbprint                                Subject              EnhancedKeyUsageList
----------                                -------              --------------------
C01588B8DXXXXXXXXXXXXXXXXXX633989CB0760  CN=SelfSign Root CA…

   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\CA

Thumbprint                                Subject              EnhancedKeyUsageList
----------                                -------              --------------------
8D3223290XXXXXXXXXXXXXXXXXFCE8BE1EB1949  CN=SelfSign Interme… {Server Authentication, Client Authentication, Code Sig…
```
