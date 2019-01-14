function Test-Mandatory {
    [cmdletbinding()]
    param (
        [parameter( Mandatory )]
        [System.Management.Automation.Language.ScriptblockAst]$ScriptblockAst
    )
    $param = $ScriptblockAst.FindAll({ $args[0] -is [system.management.automation.language.parameterast] }, $false)
    if ($param.Attributes.NamedArguments.ArgumentName -contains 'Mandatory') {
        $paramToCheck = $param.Attributes.NamedArguments |
            Where-Object {$_.ArgumentName -eq 'Mandatory'}
    
        if ($paramToCheck.Argument.Value -ne $true) {
            [pscustomobject]@{
                Message = "Mandatory attribute was found but set to false"
                Extent = $param.Extent
                RuleName = $PSCmdlet.MyInvocation.InvocationName
                Severity = 'Warning'
            }
        }
    }
    else {
        [pscustomobject]@{
            Message = "Mandatory attribute was not found"
            Extent = $param.Extent
            RuleName = $PSCmdlet.MyInvocation.InvocationName
            Severity = 'Warning'
        }
    }

}
