Param( [string] $userName, 
       [string] $password )
Write-Host "Retrieving Tools from l3"
$toolRoot = "https://raw.githubusercontent.com/seansp/l3/master/tools"
$tools = @()
$tools += "Get-TrustedHosts.ps1"
$tools += "List-VMs.ps1"
$tools += "Get-HostnameFromVM.ps1"
foreach( $tool in $tools )
{
    Write-Host "Retrieving $tool to local folder."
    $src = wget $toolRoot/$tool
    $src = $src -replace "AUTOMATION_USERNAME", $userName
    $src = $src -replace "AUTOMATION_PASSWORD", $password
    Set-Content -Path $tool -Value $src
}
Write-Host "Finished."