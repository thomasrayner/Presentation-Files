function Deny-ValueFromPipeline {
    [cmdletbinding()]
    [OutputType([pscustomobject[]])]
    param (
        [parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptblockAst]$ScriptblockAst
    )
    process {
        try {
            # This is what Get-AstObject does.
            $paramblock = $ScriptblockAst.FindAll({ $args[0] -is [system.management.automation.language.paramblockast] }, $false)
            $params = $ScriptblockAst.FindAll({ $args[0] -is [system.management.automation.language.parameterast] }, $false)

            # Compile our list of parameters, and their ValueFromPipeline and ParameterSetName values.
            $parameval = New-Object system.collections.arraylist
            foreach ( $param in $params ) {
                $vfpIndex = $param.attributes.namedarguments.argumentname.tolower().indexof('valuefrompipeline')
                if ( $vfpIndex -ge 0 ) {
                    $vfpValue = $param.attributes.namedarguments.argument[$vfpIndex].extent.text
                }
                else {
                    $vfpValue = '$false'
                }

                $paramsetIndex = $param.attributes.namedarguments.argumentname.tolower().indexof('parametersetname')
                if ( $paramsetIndex -ge 0 ) {
                    $paramsetValue = $param.attributes.namedarguments.argument[$paramsetIndex].extent.text
                }
                else {
                    $paramsetValue = "NoParamSetName"
                }
                
                $add = [pscustomobject]@{
                    'ParameterName' = $param.Name.VariablePath.UserPath
                    'ValueFromPipeline' = $vfpValue
                    'ParameterSetName' = $paramsetValue
                }
                $null = $parameval.Add($add)
            }

            # Go through our reformatted parameters, report on the violations.
            $uniqueParameterSets = @($parameval.ParameterSetName | Select-Object -Unique)
            foreach ( $paramSet in $uniqueParameterSets ) {
                $thisSet = $parameval | Where-Object { $_.ParameterSetName -eq $paramSet } # Get all the parameters in this parameter set.
                $trueCount = $thisSet | Where-Object { $_.ValueFromPipeline -ne '$false' } # Get all the parameters from this set that have VFP set/true.
                if ( $trueCount.Count -gt 1 ) {
                    [pscustomobject]@{
                        Message = "There were $($trueCount.Count) parameters in the same parameter set ($paramSet) where ValueFromPipeline " + 
                        "was specified as true. You shouldn't have more than one. The offending parameters are $($trueCount.ParameterName -join ', ')."
                        Extent = $paramblock.Extent
                        RuleName = $PSCmdlet.MyInvocation.InvocationName
                        Severity = 'Warning'
                    }
                }
            } 
        }
        catch {
            $PSCmdlet.ThrowTerminatingError( $_ )
        }
    }
}

# Ideas for improvement? Where do we go from here? 
#   - What if the same ParameterSetName exists in multiple scopes?
#   - Pester tests!
#   - More use cases.
#   - What about ParameterSetNames in single vs double quotes?
