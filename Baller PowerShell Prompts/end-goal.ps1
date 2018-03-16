[System.Collections.Generic.List[ScriptBlock]]$global:Prompt = @(
    # right aligned
    { " " * ($Host.UI.RawUI.BufferSize.Width - 29) }
    { "$F;${er}m{0}" -f [char]0xe0b2 }
    { "$F;15m$B;${er}m{0}" -f $(if (@(get-history).Count -gt 0){(get-history)[-1] | % { "{0:c}" -f (new-timespan $_.StartExecutionTime $_.EndExecutionTime)}}else{'00:00:00.0000000'}) }
    
    { "$F;7m$B;${er}m{0}" -f [char]0xe0b2 }
    { "$F;0m$B;7m{0}" -f $(get-date -format "hh:mm:ss tt") }
    
    
    # left aligned
    { "$F;15m$B;117m{0}" -f $('{0:d4}' -f $MyInvocation.HistoryId) }
    { "$B;22m$F;117m{0}" -f $([char]0xe0b0) }
    
    { "$B;22m$F;15m{0}" -f $(if($pushd = (Get-Location -Stack).count) { "$([char]187)" + $pushd }) }
    { "$F;22m$B;5m{0}" -f $([char]0xe0b0) }
    
    { "$B;5m$F;15m{0}" -f $($pwd.Drive.Name) }
    { "$B;20m$F;5m{0}" -f $([char]0xe0b0) }
    
    { "$B;20m$F;15m{0}$E[0m" -f $(Split-Path $pwd -leaf) }
    { "$F;20m{0}$E[0m" -f $([char]0xe0b0) }
)
function global:prompt {
    $global:er = if ($?){22}else{1}
    $E = "$([char]27)"
    $F = "$E[38;5"
    $B = "$E[48;5"
    -join $global:Prompt.Invoke()
}
