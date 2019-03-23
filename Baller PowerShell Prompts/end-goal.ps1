$forePromptColor = 0

[System.Collections.Generic.List[ScriptBlock]]$global:PromptRight = @(
    # right aligned
    { "$F;${er}m{0}" -f [char]0xe0b2 }
    { "$F;${forePromptColor}m$B;${er}m{0}" -f $(if (@(get-history).Count -gt 0) {(get-history)[-1] | % { "{0:c}" -f (new-timespan $_.StartExecutionTime $_.EndExecutionTime)}}else {'00:00:00.0000000'}) }
    
    { "$F;7m$B;${er}m{0}" -f [char]0xe0b2 }
    { "$F;0m$B;7m{0}" -f $(get-date -format "hh:mm:ss tt") }
)

[System.Collections.Generic.List[ScriptBlock]]$global:PromptLeft = @(
    # left aligned
    { "$F;${forePromptColor}m$B;${global:plat}m{0}" -f $('{0:d4}' -f $MyInvocation.HistoryId) }
    { "$B;22m$F;${global:plat}m{0}" -f $([char]0xe0b0) }
    
    { "$B;22m$F;${forePromptColor}m{0}" -f $(if ($pushd = (Get-Location -Stack).count) { "$([char]187)" + $pushd }) }
    { "$F;22m$B;5m{0}" -f $([char]0xe0b0) }
    
    { "$B;5m$F;${forePromptColor}m{0}" -f $($pwd.Drive.Name) }
    { "$B;14m$F;5m{0}" -f $([char]0xe0b0) }
    
    { "$B;14m$F;${forePromptColor}m{0}$E[0m" -f $(Split-Path $pwd -leaf) }
)
function global:prompt {
    $global:er = if ($?) {22}else {1}
    $global:plat = if ($isWindows) {11}else {117}
    $E = "$([char]27)"
    $F = "$E[38;5"
    $B = "$E[48;5"
    $p = ''
        
    $gitTest = $(git config -l) -match 'branch\.'
    if (-not [string]::IsNullOrEmpty($gitTest)) {
        $branch = git symbolic-ref --short -q HEAD
        $aheadbehind = git status -sb
        $distance = ''
    
        if (-not [string]::IsNullOrEmpty($(git diff --staged))) { $branchbg = 3 }
        else { $branchbg = 5 }
    
        if (-not [string]::IsNullOrEmpty($(git status -s))) { $arrowfg = 3 }
        else { $arrowfg = 5 }
    
        if ($aheadbehind -match '\[\w+.*\w+\]$') {
            $ahead = [regex]::matches($aheadbehind, '(?<=ahead\s)\d+').value
            $behind = [regex]::matches($aheadbehind, '(?<=behind\s)\d+').value
    
            $distance = "$B;15m$F;${arrowfg}m{0}$E[0m" -f $([char]0xe0b0)
            if ($ahead) {$distance += "$B;15m$F;${forePromptColor}m{0}$E[0m" -f "a$ahead"}
            if ($behind) {$distance += "$B;15m$F;${forePromptColor}m{0}$E[0m" -f "b$behind"}
            $distance += "$F;15m{0}$E[0m" -f $([char]0xe0b0)
        }
        else {
            $distance = "$F;${arrowfg}m{0}$E[0m" -f $([char]0xe0b0)
        }
    
        [System.Collections.Generic.List[ScriptBlock]]$gitPrompt = @(
            { "$B;${branchbg}m$F;14m{0}$E[0m" -f $([char]0xe0b0) }
            { "$B;${branchbg}m$F;${forePromptColor}m{0}$E[0m" -f $branch }
            { "{0}$E[0m" -f $distance }
        )
        $p = -join @($global:PromptLeft + $gitPrompt + {" "}).Invoke()
    }
    else {
        $p = -join @($global:PromptLeft + { "$F;14m{0}$E[0m" -f $([char]0xe0b0) } + {" "}).Invoke()
    }
    
    $l = -join ($global:promptRight).Invoke()
    $o = $global:host.UI.RawUI.BufferSize.Width - 28
    $r = -join @($p, "$E[${o}G", $l, "$E[0m" + "`n`r`> ")
    $r
}
