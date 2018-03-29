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

            # TODO: Identify violations

            [pscustomobject]@{
                Message = "This is a very valuable message."
                Extent = $ScriptblockAst.Extent
                RuleName = $PSCmdlet.MyInvocation.InvocationName
                Severity = 'Warning'
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError( $_ )
        }
    }
}
