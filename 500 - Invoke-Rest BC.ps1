$UserName  = "YourUserName"
$PlainTextPassword = "YourWebServicesPassword"
$SecurePassword = ConvertTo-SecureString $PlainTextPassword -AsPlainText -Force
$Credentials    = New-Object System.Management.Automation.PSCredential ($UserName, $SecurePassword)
$RESTAPIUser = $Credentials.UserName
$RESTAPIPassword = $Credentials.GetNetworkCredential().password
$URL = "https://api.businesscentral.dynamics.com/v2.0/yourdomain/Production/ODataV4/Company('CRONUS%20USA%2C%20Inc.')/Chart_of_Accounts"
$Header = @{"Authorization" = "Basic "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($RESTAPIUser+":"+$RESTAPIPassword))}
$Type = "application/json"
$BCListJSON = Invoke-RestMethod -Method Get -Uri $URL -TimeoutSec 100 -Headers $Header -ContentType $Type
$BCList = $BCListJSON.value
# $BCList |  Out-GridView
# # $OutputFile = join-path $PSScriptRoot "ChartOutput.csv"
# # $BCList | export-csv -path $OutputFile -NoTypeInformation

$SchemaName = "YourSchema"
$ServerInstance = "YourInstance"
$DatabaseName = "YourDBName"
$TableName = "BCGLAccounts2"

$params = @{
    serverinstance = $ServerInstance 
    DatabaseName   = $DatabaseName 
    SchemaName     = $SchemaName 
    TableName      = $TableName 
    ErrorAction    = "Stop"  
}

$BCList | Write-SqlTableData @params -force 

