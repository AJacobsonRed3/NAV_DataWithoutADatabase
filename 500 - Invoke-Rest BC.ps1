$UserName  = "ADAM"
$PlainTextPassword = "t/oX4F3FUKx70CNydY0LM7CM3w59zy/GpyLJ4HwSbs8="
$SecurePassword = ConvertTo-SecureString $PlainTextPassword -AsPlainText -Force
$Credentials    = New-Object System.Management.Automation.PSCredential ($UserName, $SecurePassword)
$RESTAPIUser = $Credentials.UserName
$RESTAPIPassword = $Credentials.GetNetworkCredential().password
$URL = "https://api.businesscentral.dynamics.com/v2.0/d4211f02-6257-4c99-9875-0fba976cc613/Production/ODataV4/Company('CRONUS%20USA%2C%20Inc.')/Chart_of_Accounts"
$Header = @{"Authorization" = "Basic "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($RESTAPIUser+":"+$RESTAPIPassword))}
$Type = "application/json"
$BCListJSON = Invoke-RestMethod -Method Get -Uri $URL -TimeoutSec 100 -Headers $Header -ContentType $Type
$BCList = $BCListJSON.value
# $BCList |  Out-GridView
# # $OutputFile = join-path $PSScriptRoot "ChartOutput.csv"
# # $BCList | export-csv -path $OutputFile -NoTypeInformation

$SchemaName = "demo"
$ServerInstance = "ADAM2019"
$DatabaseName = "RedThree"
$TableName = "BCGLAccounts2"

$params = @{
    serverinstance = $ServerInstance 
    DatabaseName   = $DatabaseName 
    SchemaName     = $SchemaName 
    TableName      = $TableName 
    ErrorAction    = "Stop"  
}

$BCList | Write-SqlTableData @params -force 

