# v 0.0.1-remove-openssl
 
# get-pks-k8s-config.ps1
# gmerlin@vmware.com
# cdelashmutt@pivotal.io
#
# usage:  .\get-pks-k8s-config.ps1 -API pks.mg.lab -CLUSTER k8s1.mg.lab -USER naomi -PASSWORD password
 
param (
  # [string]$server = "http://defaultserver",
   [Parameter(Mandatory=$true)][string]$API,
   [Parameter(Mandatory=$true)][string]$CLUSTER,
   [Parameter(Mandatory=$true)][string]$USER,
   [Parameter(Mandatory=$true)][string]$PASSWORD
)
 
#### Set Skip Trusts for Self Signed Certs && Force TLS 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
[System.Net.ServicePointManager]::CheckCertificateRevocationList = {$false}

#### Get Tokens
$URI = ("https://" + $API + ":8443/oauth/token")
$BODY = @{
   client_id = "pks_cluster_client"
   client_secret = ""
   grant_type = "password"
   username = $USER
   password =  $PASSWORD
   response_type = "id_token"
}
   try {$oidc_tokens=Invoke-RestMethod -Method Post -Uri $URI -Body $BODY -ContentType "application/x-www-form-urlencoded"}
   catch {
   write-error "Auth Failed"
   write-host $BODY
   throw $_
   }

$access_token = $oidc_tokens.access_token
$refresh_token = $oidc_tokens.refresh_token

### Holds CA cert as a side effect of the last call that caused the ServerCertValidationCallback to be invoked
$global:ca_cert = ""

### Trusts any cert, and captures the CA cert from the chain
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {
param($sender, $cert, $chain, $policyErrors)
    $global:ca_cert = $chain.ChainElements[$chain.ChainElements.Count-1]
    $true
}

$request = [System.Net.HttpWebRequest]::Create("https://${CLUSTER}:8443")

try
{
    #Make the request but ignore (dispose it) the response, since we only care about the side effect of the ServerCertificateValidationCallback
    $request.GetResponse().Dispose()
}
catch [System.Net.WebException]
{
    #We ignore failures, since we only want the certificate
}

if( $global:ca_cert -eq $null ) {
    Write-Error "No CA Cert found"
    exit 
}

$out = New-Object String[] -ArgumentList 3
$cluster_ca_cert = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "${CLUSTER}-ca-clean.cert")
 
$out[0] = "-----BEGIN CERTIFICATE-----"
$out[1] = [System.Convert]::ToBase64String($ca_cert.Certificate.RawData, "InsertLineBreaks")
$out[2] = "-----END CERTIFICATE-----"
 
[System.IO.File]::WriteAllLines($cluster_ca_cert,$out)

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null 
  
#### Set kubeconfig
 
& kubectl config set-cluster ${CLUSTER} --server=https://${CLUSTER}:8443 --certificate-authority=${cluster_ca_cert} --embed-certs=true
& kubectl config set-context ${CLUSTER} --cluster=${CLUSTER} --user=${USER}
& kubectl config use-context ${CLUSTER}
 
& kubectl config set-credentials ${USER} `
 --auth-provider oidc `
 --auth-provider-arg client-id=pks_cluster_client `
 --auth-provider-arg cluster_client_secret="" `
 --auth-provider-arg id-token=$access_token `
 --auth-provider-arg idp-issuer-url=https://${API}:8443/oauth/token `
 --auth-provider-arg refresh-token=$refresh_token
 
#### Cleanup
Remove-Item -path ${cluster_ca_cert} 
