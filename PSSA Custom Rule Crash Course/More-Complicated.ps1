function Get-Something {
    [cmdletbinding()]
    param (
        [parameter( Mandatory=$false, ValueFromPipeline )]
        [string]$Param1,
    
        [parameter( ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true )]
        [string]$Param2,
    
        [parameter( ValueFromPipeline=$false, ValueFromPipelineByPropertyName )]
        [string]$Param3,
    
        [parameter( ValueFromPipelineByPropertyName, ValueFromPipeline=$false )]
        [string]$Param4,
    
        [parameter( ValueFromPipelineByPropertyName, valuefrompipeline )]
        [string]$Param5,

        [parameter(Mandatory=$false)]
        [string]$Param6
    )
    Write-Output $Param1
    Write-Output $Param2
    Write-Output $Param3
    Write-Output $Param4
    Write-Host $Param5 

    # Note this function is nested inside of the first one.
    function Get-SomethingElse {
        param (
        [parameter( Mandatory=$false, ValueFromPipeline, ParameterSetName='One' )]
        [string]$OtherParam1,
    
        [parameter( ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='One' )]
        [string]$OtherParam2,
    
        [parameter( ValueFromPipeline=$false, ValueFromPipelineByPropertyName, ParameterSetName='Two'  )]
        [string]$OtherParam3,
    
        [parameter( ValueFromPipelineByPropertyName, ValueFromPipeline=$false, ParameterSetName='Two'  )]
        [string]$OtherParam4,
    
        [parameter( ValueFromPipelineByPropertyName, valuefrompipeline, ParameterSetName='Two'  )]
        [string]$OtherParam5
    )
    }
}
