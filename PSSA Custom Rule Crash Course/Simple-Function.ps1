function Test-Function {
    param (
        [parameter(Mandatory)][string]$FirstParameter
        #$FirstParameter
    )
    Write-Output $FirstParameter 
}
